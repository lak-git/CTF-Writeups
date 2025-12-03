#!/usr/bin/env python3
# find_flag.py
from itertools import product
import string

data = bytes([0xad,0xde,0x10,0xad,0x48,0xfc,0xe2,0xd2,0x6e,0x0d,0x00,0x18,0x9b,0x0d,0x00,0xab,0xcc,0xaa,0x00,0xaa,0x33,0x00])

PRINTABLE = set(range(0x20,0x7f)) | {9,10,13}  # allow common whitespace

def is_mostly_printable(b):
    return sum(1 for x in b if x in PRINTABLE) / len(b) > 0.8

def try_and_report(s, label):
    if isinstance(s, bytes):
        try:
            txt = s.decode('ascii', errors='replace')
        except:
            txt = repr(s)
    else:
        txt = str(s)
    if "HashX{" in txt or "Hashx{" in txt or "Hash{" in txt:
        print(f"[MATCH] {label}: {txt!r}")
        return True
    # also print readable candidates with many printable chars
    if isinstance(s, bytes) and is_mostly_printable(s):
        print(f"[READABLE] {label}: {txt!r}")
    return False

# 1) single-byte XOR
print("Trying single-byte XOR...")
for k in range(1,256):
    out = bytes([b ^ k for b in data])
    if try_and_report(out, f"XOR 0x{k:02x}"):
        pass

# 2) repeating XOR keys (lengths 1..6) using printable key bytes (0x20-0x7e)
print("Trying repeating XOR keys (lengths 1..6) with printable key bytes. This may take a moment...")
printable_key_bytes = list(range(0x20,0x7f))
# limit search to small space: try keys composed of letters/digits only first
reduced_key_space = [ord(c) for c in (string.ascii_letters + string.digits + "_-")]
for L in range(1,5):
    for key in product(reduced_key_space, repeat=L):
        out = bytes([b ^ key[i % L] for i,b in enumerate(data)])
        if try_and_report(out, f"REPKEY {'-'.join(f'{x:02x}' for x in key)}"):
            pass

# 3) single-byte add/subtract
print("Trying add/subtract constants...")
for k in range(1,256):
    out_add = bytes([(b + k) & 0xFF for b in data])
    out_sub = bytes([(b - k) & 0xFF for b in data])
    try_and_report(out_add, f"ADD {k}")
    try_and_report(out_sub, f"SUB {k}")

# 4) bitwise NOT and nibble swaps
print("Trying bitwise NOT and nibble swaps...")
noted = bytes([~b & 0xFF for b in data])
try_and_report(noted, "NOT")
nibble_swap = bytes([((b & 0x0F) << 4) | ((b & 0xF0) >> 4) for b in data])
try_and_report(nibble_swap, "NIBBLE_SWAP")

# 5) rotations (byte-wise) and reversed sequence
print("Trying byte rotations and reversed order...")
for r in range(1, len(data)):
    rot = bytes([data[(i+r) % len(data)] for i in range(len(data))])
    try_and_report(rot, f"ROT {r}")
rev = data[::-1]
try_and_report(rev, "REVERSED")

# 6) treat as UTF-16LE pairs (if even length)
print("Trying UTF-16LE decoding...")
if len(data) % 2 == 0:
    try:
        s = data.decode('utf-16le')
        if any(ch.isprintable() for ch in s):
            print("[UTF16LE] ", repr(s))
    except Exception as e:
        pass

# 7) interpret as 16-bit words and swap bytes inside each word
print("Trying 16-bit words and byte-swap per-word...")
words = [data[i] | (data[i+1]<<8) for i in range(0, len(data)-1, 2)]
swapped = bytes([((w>>8)&0xFF) for w in words] + [w & 0xFF for w in words])  # experimental
try_and_report(swapped, "16BIT-SWAP-EXP")

# 8) combine common transformations and look for 'HashX{' substring
print("Brute forcing combinations of NOT/XOR/rotate with small keyspace...")
# try small brute combos: NOT then XOR with printable keys
for k in reduced_key_space:
    out = bytes([( (~b & 0xFF) ^ k) for b in data])
    if try_and_report(out, f"NOT+XOR {k:02x}"):
        pass

print("Done. If nothing obvious printed, try increasing the keyspace or paste any promising candidate output here and I'll help interpret it.")
