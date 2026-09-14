# Broken Circle

> *"Elliptic curve cryptography sounds unbreakable, until the ring it's drawn on is small enough to walk in an afternoon."*

## Overview

The challenge presents an "intercepted elliptic-curve encrypted transmission". We are given:

- The curve equation: `y² = x³ + 497x + 1768 (mod 9739)`
- The base point: `G = (1804, 5765)`
- The public point: `Q = (5752, 5741)`
- The ciphertext: `161179022702861262395126424083632380335433252439803917934843551690677099371`

The goal is to recover the private scalar `k` (where `Q = k*G`), then use `Q`'s x-coordinate as a repeating XOR key to decrypt the transmission and submit the plaintext.

---

## Recon

Browsing to `http://192.168.45.128:8086/` returns an HTML page with the curve parameters, points, and ciphertext — plus two very helpful clues:

1. An HTML comment: `<!-- INTEL: curve is small enough to brute force private key k where Q = k*G -->`
2. An analyst note describing the exact decryption recipe:
   > *"Once you have k, use Qx (the x-coordinate of Q) as your decryption key. XOR the ciphertext bytes with Qx bytes repeated to match length."*

---

## Analysis

**Why is this broken?** ECC security depends entirely on the *Elliptic Curve Discrete Logarithm Problem* (ECDLP) being computationally infeasible — and it is only infeasible when the group order has a large prime factor.

Here the prime modulus is `p = 9739`, so the entire curve has at most ~10⁴ points. Recovering `k` is just a matter of repeatedly adding `G` until we land on `Q` ("walking" the curve). This takes milliseconds, whereas a production curve like P-256 or Curve25519 has order ~2²⁵⁶, making brute force impossible.

A second weakness: the symmetric decryption key is derived from a single point coordinate (`Qx`), which is public information anyway — so the "encryption" provides no confidentiality beyond the DLP.

---

## Exploitation

### Step 1 — Recover the private scalar `k`

Implement point addition / double-and-add scalar multiplication and walk `G` until `k*G == Q`:

```python
p = 9739
a, b = 497, 1768

def add(P, Q):
    if P is None: return Q
    if Q is None: return P
    x1, y1, x2, y2 = P[0], P[1], Q[0], Q[1]
    if x1 == x2 and (y1 + y2) % p == 0:
        return None                      # point at infinity
    lam = ((3*x1*x1 + a) * pow(2*y1, -1, p)) % p if P == Q \
          else ((y2 - y1) * pow(x2 - x1, -1, p)) % p
    x3 = (lam*lam - x1 - x2) % p
    y3 = (lam*(x1 - x3) - y1) % p
    return (x3, y3)

G = (1804, 5765)
Q = (5752, 5741)

cur, k = None, 0
while cur != Q:
    cur = add(cur, G)
    k += 1
print("k =", k)                          # k = 1337
```

### Step 2 — Decrypt

Convert the ciphertext integer to bytes and XOR with `Qx = 5752` (`0x1678`, 2-byte big-endian) repeated:

```python
c = 161179022702861262395126424083632380335433252439803917934843551690677099371
h = hex(c)[2:]
if len(h) % 2: h = '0' + h
ct = bytes.fromhex(h)

Qx = 5752
key = Qx.to_bytes(2, 'big')              # 0x16 0x78
pt = bytes(b ^ key[i % 2] for i, b in enumerate(ct))
print(pt)                                # MAHASONA{not_the_real_flag_ecc}
```

### Step 3 — Submit

The decrypted plaintext is a troll (`not_the_real_flag_ecc`), but submitting it to the `/decrypt` endpoint returns the real classified file:

```bash
curl -s -X POST http://192.168.45.128:8086/decrypt \
  --data-urlencode "answer=MAHASONA{not_the_real_flag_ecc}"
```

---

## The Flag

```
MAHASONA{ecc_weak_curve_private_key_recovered}
```

---

## Remediation

As a developer, prevent this class of break in production:

1. **Use standardised curves only** — NIST P-256/P-384/P-521 or Curve25519. Never roll your own curve parameters, and never use a tiny prime field.
2. **Validate received points** — reject points that do not satisfy the curve equation (defends against invalid-curve attacks).
3. **Never derive symmetric keys from a single public coordinate.** Use a proper key-agreement (ECDH) followed by a KDF, or an authenticated cipher with a random ephemeral key.
4. **Use unique random nonces** for every ECDSA signature (the PS3 failure was exactly this — reused nonces leaked the private key).
5. **Enforce minimum group-order size** — check `order.bit_length()` is large before accepting any curve.
