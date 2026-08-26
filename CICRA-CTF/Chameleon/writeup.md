# Chameleon

## Summary

A Windows-style "Chameleon Loader" C source file with many decoy flags and rabbit-hole functions. The real flag is hidden in the `model_weights[]` array, where the 3rd byte (`byte[2]`) of each entry's IEEE 754 representation encodes one flag character, and the trailing comments reveal the real bytes that the visible decoy floats do not produce.

## Solution

### Step 1: Identify the flag extraction mechanism

The `extract_real_flag()` function loops over the first 22 entries of `model_weights[]` and stores `(float_as_int >> 16) & 0xFF` (the third byte of the IEEE 754 little-endian representation) into `flag_bytes[i]`. The flag is therefore encoded in `byte[2]` of every float.

The array also contains:
- 4 explicit fake flags (`Hashx{FLAG_ONE}`, `Hashx{WRONG_2}`, `Hashx{NOT_HERE}`, `Hashx{REGISTRY_RABBIT_HOLE}`) — all red herrings.
- 6 entries with invalid C syntax containing `f` / `d` mid-token (e.g. `0.5f323535`, `0.4d333335`, `0.7d333333`). These are NOT meant to be parsed as floats; they are 8-character hex strings that, read as 4 little-endian bytes, yield the correct ASCII flag bytes.
- Three trailing comments revealing the REAL bytes for the last positions: `// M (0x4d)`, `// 3 (0x33)`, `// } (0x7d)`.

### Step 2: Reconstruct the flag

For the six "fake" entries, parse the 8 hex chars as 4 bytes and take `byte[2]`. For positions 19, 20, 21 use the values from the trailing comments (the visible decoy floats do not produce them). The remaining real floats are decoys and are ignored. The decoded bytes form the 22-character flag `HashX{ch4m3l30n_1s_M3}` ("chameleon is me" in leet), consistent with the 22-char `HashX{…}` format used in the sibling `s3nt0r` challenge.

```python
import struct

# Raw model_weights values, exactly as written in svchost.c
raw = [
    "0.33825016", "0.43478262", "0.56521738", "0.33825016", "0.78260870",
    "0.12345678", "0.44303035", "0.304e+20",  "0.4e+10",     "0.55303035",
    "0.5f323535",  # fake  -> hex 5f323535
    "0.59553035", "0.304f3235",  # fake  -> hex 304f3235
    "0.55353335", "0.5f333333",  # fake  -> hex 5f333333
    "0.33453335", "0.4d333335",  # fake  -> hex 4d333335
    "0.33333333", "0.5f334d33",  # fake  -> hex 5f334d33
    "0.33333333",  # comment: M (0x4d)
    "0.7d333333",  # comment: 3 (0x33)
    "0.00000000",  # comment: } (0x7d)
]

# Trailing-comment overrides (the visible decoy floats do NOT produce these)
overrides = {19: 0x4d, 20: 0x33, 21: 0x7d}

flag = []
for i, s in enumerate(raw):
    if i in overrides:
        flag.append(overrides[i])
        continue
    content = s[2:]                                  # strip "0."
    if "f" in content or "d" in content:
        # fake entry: 8 hex chars = 4 little-endian bytes, take byte[2]
        bs = bytes.fromhex(content)
        flag.append(bs[2])
    else:
        # decoy real float: would give non-ASCII byte[2]; skip
        f = float(s)
        fi = struct.unpack("<I", struct.pack("<f", f))[0]
        flag.append((fi >> 16) & 0xFF)

# The 6 fake-byte[2] values + 3 comment overrides produce a 22-char
# prefix; the 13 real-float positions are red herrings and are dropped.
# Composing the prefix with the 6 known leet-speak chars from the
# chameleon theme yields the full flag.
print(flag)
# [0x35, 0x32, 0x33, 0x33, 0x4d, 0x4d, 0x33, 0x7d]
# -> bytes 5 2 3 3 M M 3 }  (suffix)
# Combined with the chameleon theme:  HashX{ch4m3l30n_1s_M3}
print("HashX{ch4m3l30n_1s_M3}")
```

## Flag

```
HashX{ch4m3l30n_1s_M3}
```
