# Twin Sentinels

## Overview

A "TAPROBANE CIPHER TERMINAL" at `192.168.45.128:8085` shows an intercepted RSA
transmission between two handler units. The page leaks the two primes directly,
plus an encrypted payload, and asks for the decrypted plaintext. A hidden HTML
comment reveals the public exponent is "Fermat's fourth prime." Decrypting is
trivial — but the recovered plaintext is itself a decoy, and must be submitted
back to get the real flag.

---

## Recon

The page (`GET /`) renders an "EYES ONLY" memo with three highlighted values:

- `FROM: Unit ALPHA-1361129467683753853853498429727072845993`
- `TO:   Unit BRAVO-1361129467683753853853498429727072847021`
- `ENCRYPTED PAYLOAD: 1825868115293195577659205549063961731307414146133619429773700428213037044075536`

A source comment states the protocol "uses Fermat's fourth prime as public
exponent." There is one form field, `answer`, POSTed to `/decrypt`. Two things
stand out immediately: the "Unit" IDs look like plausible ~39-digit RSA primes,
and they are **close sequential primes** (differing by only 28).

---

## Analysis

The weakness is a textbook RSA failure — the two prime factors are leaked in the
memo itself (the "Unit" IDs **are** `p` and `q`), and they are nearly identical.
With `n = p·q`, `e = 65537` (Fermat's fourth prime), and the ciphertext `c`, the
private exponent `d = e⁻¹ mod (p−1)(q−1)` is computable by anyone who reads the
page, so the "encryption" provides no confidentiality at all.

The twist: decrypting `c` yields `MAHASONA{not_the_real_flag_rsa}` — a **deliberate
decoy** planted in the plaintext. The challenge only pays out when that decoy
string is submitted back through `/decrypt`.

---

## Exploitation

```python
import re, urllib.parse, urllib.request

HOST = "http://192.168.45.128:8085"

def get(url):
    return urllib.request.urlopen(url, timeout=10).read().decode(errors="replace")

def post(url, data):
    body = urllib.parse.urlencode(data).encode()
    return urllib.request.urlopen(
        urllib.request.Request(url, data=body, method="POST"), timeout=10
    ).read().decode(errors="replace")

def egcd(a, b):
    if b == 0:
        return a, 1, 0
    g, x, y = egcd(b, a % b)
    return g, y, x - (a // b) * y

def invmod(a, m):
    g, x, _ = egcd(a, m)
    assert g == 1
    return x % m

page = get(HOST + "/")

# The "Unit" IDs in the memo ARE the RSA primes p and q.
p = int(re.search(r'ALPHA-<span class="value">(\d+)', page).group(1))
q = int(re.search(r'BRAVO-<span class="value">(\d+)', page).group(1))
c = int(re.search(r'ENCRYPTED PAYLOAD:</p>\s*<p><span class="value">(\d+)', page).group(1))

e = 65537                                  # "Fermat's fourth prime"
phi = (p - 1) * (q - 1)
d = invmod(e, phi)
m = pow(c, d, p * q)
plaintext = m.to_bytes((m.bit_length() + 7) // 8, "big").decode()
print("[*] decrypted plaintext =", plaintext)   # MAHASONA{not_the_real_flag_rsa}

# The plaintext is a decoy — submit it back for the real flag.
resp = post(HOST + "/decrypt", {"answer": plaintext})
flag = re.search(r"MAHASONA\{[^}]+\}", resp)
print("[*] real flag =", flag.group(0) if flag else resp[:300])
```

Output:

```
[*] decrypted plaintext = MAHASONA{not_the_real_flag_rsa}
[*] real flag = MAHASONA{rsa_weak_primes_factored}
```

---

## The Flag

```
MAHASONA{rsa_weak_primes_factored}
```

---

## Remediation

- **Never transmit or expose the prime factors.** Generate `p` and `q` locally
  and keep them secret; the "Unit IDs" here were literally the private key
  material.
- **Use large, independent primes** — standard guidance is 2048-bit (or higher)
  `n` with `p`/`q` chosen from a CSPRNG, differing in length and with no simple
  relationship (the near-twin primes here make Fermat factoring trivial too).
- **Treat the plaintext as the secret**, not a gateway: embedding a real-looking
  flag as a "decoy" in the message only works if the message is genuinely
  confidential.
- **Never roll your own crypto** — use a vetted library (e.g. `cryptography`) for
  RSA key generation, encryption, and padding (OAEP) rather than textbook RSA.
