import zlib
import binascii

# This is your decoded ASCII string
s = "AjiTIW,clcXWz^iO\\M~N0]ca0^![@QmI@F80sRil@FNHTZiw"

# Convert each character to its original 0–127 integer byte
data = bytes([ord(c) for c in s])

print("Raw bytes:", data)

# Try zlib
try:
    print("zlib:", zlib.decompress(data))
except:
    print("zlib failed")

# Try raw DEFLATE
try:
    print("raw DEFLATE:", zlib.decompress(data, -15))
except:
    print("raw deflate failed")

# Try gzip header wrapper
try:
    import gzip
    print("gzip:", gzip.decompress(data))
except:
    print("gzip failed")
