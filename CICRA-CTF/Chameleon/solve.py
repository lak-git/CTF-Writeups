import re
import struct

raw_weights = [
    "0.33825016",
    "0.43478262",
    "0.56521738",
    "0.33825016",
    "0.78260870",
    "0.12345678",
    "0.44303035",
    "0.304e+20",
    "0.4e+10",
    "0.55303035",
    "0.5f323535",
    "0.59553035",
    "0.304f3235",
    "0.55353335",
    "0.5f333333",
    "0.33453335",
    "0.4d333335",
    "0.33333333",
    "0.5f334d33",
    "0.33333333",
    "0.7d333333",
    "0.00000000",
]

def clean_float(s):
    m = re.match(r"[0-9\.eE+-]+", s)
    return float(m.group(0))

flag = []
for s in raw_weights:
    f = clean_float(s)
    fi = struct.unpack("<I", struct.pack("<f", f))[0]
    flag.append((fi >> 16) & 0xFF)

print(bytes(flag))
