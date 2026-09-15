#!/bin/bash
# scribe_watch.sh — persistent watcher for Scribe window + port flaps + SSH-22.
# Auto-fires scribe_rapid.sh when /api/health shows the Scribe app again.
# Usage: scribe_watch.sh [TARGET_IP]   (default 159.65.140.97)
T="${1:-159.65.140.97}"
LOG=/tmp/opencode/scribe_watch.log
RAPID=/home/w0lf/CTF/LernaeanSiegeFCS/prep/scripts/scribe_rapid.sh
echo "watcher start $(date +%F\ %H:%M:%S) target=$T" >> "$LOG"
while true; do
  ts=$(date +%H:%M:%S)
  h=$(curl -s --max-time 8 "http://$T/api/health" 2>/dev/null)
  if echo "$h" | grep -q 'scribe'; then
    echo "$ts *** SCRIBE WINDOW OPEN: $h ***" >> "$LOG"
    bash "$RAPID" "$T" >> "$LOG" 2>&1
    echo "$ts rapid-strike complete" >> "$LOG"
  else
    s80=$(curl -s --max-time 6 -o /tmp/opencode/w80.html -w '%{http_code}' "http://$T/" 2>/dev/null)
    who=$(grep -m1 -oE 'Scribe Internal Portal|Team PhaZto Flag Shop' /tmp/opencode/w80.html 2>/dev/null)
    echo "$ts :80=$s80 ${who:-?} health=${h:0:40}" >> "$LOG"
  fi
  for pp in 443 442 444; do
    c=$(curl -s --max-time 4 -o /dev/null -w '%{http_code}' "http://$T:$pp/" 2>/dev/null)
    [ "$c" != "000" ] && echo "$ts FLAP :$pp code=$c" >> "$LOG"
  done
  if timeout 3 bash -c "exec 3<>/dev/tcp/$T/22" 2>/dev/null; then
    echo "$ts SSH-22 TCP-OPEN (passive keyscan)" >> "$LOG"
    timeout 8 ssh-keyscan -T 5 "$T" >> /tmp/opencode/ssh_keys.txt 2>>"$LOG"
  fi
  sleep 20
done
