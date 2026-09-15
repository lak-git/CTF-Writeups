#!/bin/bash
# patch.sh — defensive hardening (run as root immediately after getting a foothold)
# Locks out opponent privesc vectors on a Linux web-server KoTH box.

log(){ printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
[ "$(id -u)" -ne 0 ] && { echo "need root"; exit 1; }

log "Removing SUID from abusable binaries"
for b in pkexec find bash mount umount su sudo perl python python3 python3.* ruby php busybox cp mv vim vi nano less more awk sed tar screen tmux socat nc ncat env; do
  p=$(command -v "$b" 2>/dev/null) || continue
  chmod -s "$p" 2>/dev/null
done
# any other SUID found:
find / -perm -4000 -type f 2>/dev/null | while read -r f; do
  chmod -s "$f" 2>/dev/null
done

log "Locking root password (rotate to ours)"
echo -e 'ThunderSl4y3r!\nThunderSl4y3r!' | passwd root >/dev/null 2>&1 || true

log "Hardening sudoers / crontab / authorized_keys visibility"
chmod 440 /etc/sudoers 2>/dev/null || true
chattr +i /etc/sudoers 2>/dev/null || true

log "Disabling kernel module loads (blocks LKM rootkits)"
sysctl -w kernel.modules_disabled=1 2>/dev/null || true

log "Clearing LD_PRELOAD rootkits"
: > /etc/ld.so.preload 2>/dev/null || true
chattr +i /etc/ld.so.preload 2>/dev/null || true

log "Removing known rootkit module (diamorphine default kill)"
kill -63 0 2>/dev/null || true
rmmod diamorphine 2>/dev/null || true

log "Done hardening."
