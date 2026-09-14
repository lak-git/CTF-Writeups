# The Sponsor's Secret

## Overview

**Challenge:** Cryptography, port 8094. A sponsor left an encrypted message the
world "was never meant to read". The page displays a base64 blob and asks us to
submit the fully decrypted plaintext.

**Given:** A web page (`GET /`) containing an intercepted ciphertext payload, an
analyst note describing the encoding layers, and a submission form
(`POST /decrypt`).

**Goal:** Decode the ciphertext and submit the flag.

---

## Recon

`curl -s http://192.168.45.128:8094/` returned a page titled
*"TAPROBANE // ENCRYPTED SPONSOR TRANSMISSION"*. Three things stood out:

1. **The visible payload** (the "one thing" the page shows) — a base64 string in
   a `.code` div.
2. **The hidden clue** (the "soul" of the page) — an HTML comment:
   `SIGINT callsign tag: W***S-2026 // callsigns hidden using "*" for OPSEC`.
3. **The analyst note** — *"Payload appears Base64-encoded on the outer layer.
   Inner layer resists standard decoding — repeating-key XOR suspected. Key
   length is short. Associated event sponsor may provide a clue."*

```bash
curl -s http://192.168.45.128:8094/
```

---

## Analysis

The payload is a two-layer encoding:

1. **Outer layer:** standard base64.
2. **Inner layer:** repeating-key XOR with a *short* key, hinted at by the
   sponsor reference and the callsign `W***S`.

Decoding the base64 produced 132 raw bytes. Running `xortool` on them identified
**key length 5** as the most probable (23.1% confidence):

```bash
echo '<payload>' | base64 -d > sponsor.bin
xortool -b sponsor.bin
# Most probable key lengths: 5: 23.1%
```

The callsign `W***S` is exactly **5 characters** — `W` + `***` + `S`. Combined
with the sponsor clue, the hidden letters spell **`WINGS`**, Red Bull's slogan
("Gives You Wings"). The event sponsor is **Red Bull**.

Per-column single-byte XOR frequency scoring independently confirmed each key
byte (`W-I-N-G-S`), validating the guess cryptanalytically rather than just
thematically.

---

## Exploitation

Decrypting the 132 bytes with the repeating key `WINGS`:

```python
import base64

payload = ("BBkBCQAYG24KFgQaDwAWbWkaLzokaQ0TFXcsOCI9I2knNHMnOyEyNzswbiEmMiUrI3M1"
           "MG4VFhNpDBIfG2ljZxQ+Pys0cw4mO2cEPicpNHJ3DwIGFG1pHAIXFRwCCyggICAgIAgvOyI/"
           "CD0mIgw/PCAzDCQ5ISkgODsRMj07Ji0sNjM0")

data = base64.b64decode(payload)
key = b"WINGS"
plaintext = bytes(b ^ key[i % len(key)] for i, b in enumerate(data))
print(plaintext.decode())
```

Output:

```
SPONSOR MESSAGE: This CTF event is proudly fueled by RED BULL - Gives You Wings! FLAG: REDBULL{wings_fuel_the_hunt_sponsor_unlocked}
```

Submitting the flag (note: **flag only**, not the full message — the full
message is rejected):

```bash
curl -s -X POST http://192.168.45.128:8094/decrypt \
  --data-urlencode "answer=REDBULL{wings_fuel_the_hunt_sponsor_unlocked}"
# ✅ SPONSOR MESSAGE DECODED
# FLAG: REDBULL{wings_fuel_the_hunt_sponsor_unlocked}
```

---

## The Flag

```
REDBULL{wings_fuel_the_hunt_sponsor_unlocked}
```

Note the flag is in `REDBULL{}` format, **not** the usual `MAHASONA{}` — this is
the "does not wear the usual clothes" hint.

---

## Remediation

The core issue is that the challenge *leaks its own decryption key through
metadata*:

1. **Do not derive cryptographic keys from publicly-known strings.** The key
   `WINGS` came straight from the sponsor's marketing slogan and a callsign in
   the HTML comment. A real secret must be independent, high-entropy material
   (e.g., a random 256-bit key), never a guessable brand phrase.
2. **Do not leak key material in metadata.** The callsign `W***S` in an HTML
   comment is exactly the kind of side-channel an attacker reads first. Hidden
   comments are not secrecy.
3. **Do not use repeating-key XOR for confidentiality.** A single-byte XOR
   stream with a short repeating key is trivially broken by frequency analysis
   and known-plaintext attacks (the flag format). Use a modern authenticated
   cipher (e.g., AES-GCM or ChaCha20-Poly1305) with a random nonce.
4. **Do not rely on non-standard flag formats as a security control.** Wrapping
   the flag in `REDBULL{}` instead of `MAHASONA{}` adds no real protection — the
   plaintext is still exposed once the (weak) cipher is broken.
