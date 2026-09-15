#!/bin/bash
# king-loop.sh — pure-shell king hold (fallback when the compiled binary isn't available)
# Usage: ./king-loop.sh [king_path] [username]
# Run:  setsid ./king-loop.sh /root/king.txt ThundersFist </dev/null >/dev/null 2>&1 &

KING="${1:-/root/king.txt}"
HANDLE="${2:-ThundersFist}"
CHATTR="${CHATTR:-/usr/bin/chattr}"

while true; do
  umount -l "$KING" 2>/dev/null
  "$CHATTR" -ia "$KING" 2>/dev/null
  printf '%s' "$HANDLE" >| "$KING" 2>/dev/null
  "$CHATTR" +ia "$KING" 2>/dev/null
  sleep 0.2
done
