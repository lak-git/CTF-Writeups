# Håstad Broadcast Attack for e=3 (standalone version)

# If sympy is installed, use it for integer cube root
try:
    from sympy import integer_nthroot
    use_sympy = True
except ImportError:
    use_sympy = False

# Convert hex → int
def hx(x):
    return int(x, 16)

# Ciphertexts
c1 = hx("69D667750BDD64C5B0311A95E086165AD2E47861C4E6105FCE924A2329FD0BFCACBBB98BD7C7AB42B591DE1C4E1CF14D2625FEEE35F938CE604C63C9AC5E1344")
c2 = hx("2F2D2CF7D2D0A8CF4A107A0EE431B2216033810114543085CA11BA3E83D9994CBE29E5EC857CBDB8883C01D75EB0CA1C0717DA417E58DE12F6B9AA12FB73361")
c3 = hx("2460E100FC6422C7B25B8225B93A2D7287195C6D976545C73EE26D025813C16C46DE9D043A5913FAECE6961A9E89E4CAE9FCFA2B590C4C3A603E7900A3281630")

# Moduli
n1 = hx("8487670FC2CA30DADB9FF6D8F1C1971E90EF869455ECDE0797FC0A747DA980BEE584F28ECAA0F0A2E5765EF1169D8B1172B9C7EB6C082CCD0DAC44AB6D85CDD7")
n2 = hx("5FC18AF592032C7D445530D655E55B1F8B59E524B7B4084B8E5F8ADC8CC64DA52D5861A1489A23098B2A77A6F5845A96BCE21139A172E4091F1D0A9BFF92641D")
n3 = hx("B793453EB390955155303758DEF75339400C0FE2F94C165C2D619D965A2D378EE3F5039030242FB731DD03974111FC9DB4F369B7F36451F8668C6D0783C2A97B")

# CRT implementation
def crt(vals, mods):
    x = 0
    N = 1
    for m in mods:
        N *= m
    for v, m in zip(vals, mods):
        Ni = N // m
        inv = pow(Ni, -1, m)
        x += v * Ni * inv
    return x % N

m3 = crt([c1, c2, c3], [n1, n2, n3])

# Cube root
if use_sympy:
    m, exact = integer_nthroot(m3, 3)
else:
    # manual integer cube root
    def iroot3(n):
        lo, hi = 0, int(pow(n, 1/3)) + 2
        while lo <= hi:
            mid = (lo + hi) // 2
            cube = mid * mid * mid
            if cube == n:
                return mid, True
            if cube < n:
                lo = mid + 1
            else:
                hi = mid - 1
        return hi, False
    m, exact = iroot3(m3)

# Convert integer → bytes
def int_to_bytes(n):
    h = hex(n)[2:]
    if len(h) % 2:
        h = "0" + h
    return bytes.fromhex(h)

plaintext = int_to_bytes(m)
print(plaintext)
