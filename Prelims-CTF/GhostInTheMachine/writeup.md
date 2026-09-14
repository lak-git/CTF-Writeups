# Ghost in the Machine

## Summary

A stripped 32-bit PIE ELF asks for a "license key" and validates it. Static
inspection reveals two comparison paths: one that yields a decoy signature, and
a second (rolling-XOR stream cipher) path that yields the real license key.
Submitting the real key to the web portal authorizes flag generation.

---

## Solution

### Step 1: Download and triage

The portal at `:8091` serves `/download` (a 13.7 KB ELF) and a `/verify` form.
`file` identifies it as a stripped 32-bit PIE executable; `strings` shows the
banner plus success/failure messages — but **no plaintext flag or key**, matching
the challenge hint that the secret "only exists when the program is awake."

### Step 2: Locate the two validation paths

Disassembly of `main` reveals the key comparison logic. Two distinct buffers are
derived from hardcoded `.data` before being `strcmp`'d against user input:

1. **Decoy path** — bytes at `[ebx+0x68]` are XOR'd with a constant `0x5a`.
2. **Real path** — bytes at `[ebx+0x54]` are fed through a rolling XOR cipher
   (initial key `0xc3`), then compared first.

The disassembly shows the real (decrypted) result is compared **before** the
decoy, and the decoy branch prints `DECOY SIGNATURE DETECTED` — the challenge's
"trace all code paths reachable from user input" hint. The decoy exists to make
"plain-text" analysis (`RevEngMaster2025`) look correct.

### Step 3: Reconstruct both transforms and submit

The rolling cipher's key evolves per byte as:

```python
key = (key >> 1) | (((key >> 2) ^ (key >> 3) ^ key ^ (key >> 4)) << 7)
```

(an 8-bit right-shift LFSR with taps at bits 0, 2, 3, 4). Reversing both paths:

```python
# .data (file offset 0x3000, vaddr 0x4000) — GOT base ebx = 0x3fb8
decrypt_src = bytes.fromhex("918486bd12d9920ec4af8884498d6c99")  # @0x400c
xor_src     = bytes.fromhex("083f2c1f343d173b292e3f28686a686f")  # @0x4020

# Decoy: static XOR 0x5a
decoy = bytes(b ^ 0x5a for b in xor_src)
print("decoy:", decoy.decode())          # RevEngMaster2025

# Real: rolling XOR stream cipher, key = 0xc3
key = 0xc3
out = []
for b in decrypt_src:
    out.append(b ^ key)
    key = (key >> 1) | (((key >> 2) ^ (key >> 3) ^ key ^ (key >> 4)) << 7)
    key &= 0xff
real = bytes(out)
print("real:", real.decode())            # RevEngMaster2026
```

Running the binary confirms both: `RevEngMaster2025` prints
`LICENSE KEY REJECTED — DECOY SIGNATURE DETECTED`, while `RevEngMaster2026`
prints `LICENSE KEY VALID`.

### Step 4: Submit the key

```bash
curl -s -X POST http://192.168.45.128:8091/verify \
  --data-urlencode "license_key=RevEngMaster2026"
# <h3>VALIDATION SUCCESSFUL: MAHASONA{elf_binary_reversed_strings_extracted}</h3>
```

---

## Flag

```
MAHASONA{elf_binary_reversed_strings_extracted}
```
