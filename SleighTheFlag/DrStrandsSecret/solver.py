genetic_code = {
    'AAA': 'f', 'AAC': ']', 'AAG': '^', 'AAT': '[', 'ACA': '/', 'ACC': '3', 'ACG': '*', 'ACT': '\\',
    'AGA': 'T', 'AGC': 'S', 'AGG': 'x', 'AGT': 'i', 'ATA': 'A', 'ATC': '!', 'ATG': 'c', 'ATT': ':',

    'CAA': 'L', 'CAC': '}', 'CAG': 'R', 'CAT': 'J', 'CCA': 'G', 'CCC': '2', 'CCG': '_', 'CCT': 'H',
    'CGA': 'h', 'CGC': "'", 'CGG': 'B', 'CGT': 'X', 'CTA': '~', 'CTC': 'D', 'CTG': '7', 'CTT': ',',

    'GAA': 'm', 'GAC': '"', 'GAG': '0', 'GAT': 'N', 'GCA': '8', 'GCC': '&', 'GCG': '5', 'GCT': '%',
    'GGA': 'P', 'GGC': ')', 'GGG': 'd', 'GGT': 'w', 'GTA': 'F', 'GTC': '6', 'GTG': 'Z', 'GTT': 'a',

    'TAA': 'Q', 'TAC': 'l', 'TAG': '>', 'TAT': 'I', 'TCA': 'o', 'TCC': 'z', 'TCG': '(', 'TCT': 'b',
    'TGA': 'E', 'TGC': 'n', 'TGG': 'O', 'TGT': 's', 'TTA': 'W', 'TTC': 'M', 'TTG': '@', 'TTT': 'j',
}

seq = "ATATTTAGTAGATATTTACTTATGTACATGCGTTTATCCAAGAGTTGGNNNATATTCTTACAAATTGATCTTCTCAACCATGTTCTCATCTAGGAAAGTNNNTTGGTAGCAGAGTGTCAGAGTTACTTGGTAGATCCTAGAGTGAGTGGT"

seg1, seg2, seg3 = seq.split("NNN")

comp = str.maketrans("ATCG", "TAGC")

def rc(s):
    return s.translate(comp)[::-1]

def decode(s):
    out = ""
    for i in range(0, len(s), 3):
        codon = s[i:i+3]
        if len(codon) < 3 or 'N' in codon:
            continue
        out += genetic_code.get(codon, '?')
    return out

part1 = decode(seg1)
part2 = decode(rc(seg2))
part3 = decode(seg3)

print(part1 + part2 + part3)
cipher = b"AjiTIW,clcXWz^iO\\M~N0]ca0^![@QmI@F80sRil@FNHTZiw"

for k in range(256):
    pt = bytes([c ^ k for c in cipher])
    # Heuristic: printable and contains SLEIGH{
    if b"SLEIGH" in pt or all(32 <= x < 127 for x in pt):
        print(k, pt)

