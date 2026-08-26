# Candy Vault Heist

## Description

A hush fell over the North Pole… then a whisper reached Santa’s ear. “The Grinch has slipped in,” an Elf breathed. “A curious parcel holds the vault’s secret.” 

Among jingles and sleigh chatter, one quiet thread hums the truth. Follow the whisper, not the bells—only the attentive can reclaim the lost key.

## Summary

A noisy PCAP full of decoy Christmas HTTP traffic hides a single large file (`SantaBaby.jpeg`) that is actually a password-protected ZIP. Cracking the ZIP reveals two images; the flag is split between steghide data in the JPEG and BGR-LSB steganography in the PNG.

## Solution

### Step 1: Extract HTTP objects, identify the ZIP, crack it

The PCAP contains ~100+ decoy HTTP streams returning 42-byte "Merry Christmas!" pages. One stream stands out: `SantaBaby.jpeg` (~1.9 MB). `file` reveals it is a ZIP, not a JPEG. John the Ripper cracks the ZIP password instantly with `rockyou.txt`.

```bash
#!/usr/bin/env bash
set -euo pipefail

PCAP="sleigh_noisy.pcap"
WORKDIR="_solve"
mkdir -p "$WORKDIR"

# 1. Extract all HTTP objects from the pcap
tshark -r "$PCAP" \
  --export-objects "http,$WORKDIR/http" 2>/dev/null

# 2. SantaBaby.jpeg is the only large file; it's actually a ZIP
cp "$WORKDIR/http/SantaBaby.jpeg" "$WORKDIR/SantaBaby.zip"

# 3. Crack the ZIP password with John + rockyou.txt
zip2john "$WORKDIR/SantaBaby.zip" > "$WORKDIR/zip.hash" 2>/dev/null
john --wordlist=/usr/share/wordlists/rockyou.txt "$WORKDIR/zip.hash" 2>&1 | tail -3
ZIP_PASS=$(john --show "$WORKDIR/zip.hash" 2>/dev/null | head -1 | sed 's/.*://;s/ .*//')

# 4. Extract the two images from the ZIP
unzip -o -P "$ZIP_PASS" "$WORKDIR/SantaBaby.zip" -d "$WORKDIR/extracted" >/dev/null
# -> GigaGrinch.png, gigasanta.jpeg
```

Output:

```
alliwantforchristmasisyou (SantaBaby.zip)
```

### Step 2: Extract the flag halves from both images

`gigasanta.jpeg` hides a steghide-embedded file; StegSeek cracks the passphrase (`santababy1`) and extracts `HoHoHo.txt` containing the first half of the flag. `GigaGrinch.png` carries the second half in BGR-LSB steganography, detected by zsteg.

```bash
# 5. Crack steghide passphrase with StegSeek, extract hidden file
stegseek "$WORKDIR/extracted/gigasanta.jpeg" /usr/share/wordlists/rockyou.txt \
  "$WORKDIR/steg_out" 2>&1 | tail -3
# -> Found passphrase: "santababy1", file: HoHoHo.txt

# First half of the flag
PART1=$(tail -1 "$WORKDIR/steg_out")
echo "Part 1: $PART1"

# 6. Extract BGR-LSB from GigaGrinch.png with zsteg
#    zsteg detects: b1,bgr,lsb,xy .. text: "s_AR3_M!!N33}"
PART2=$(zsteg -E "b1,bgr,lsb,xy" "$WORKDIR/extracted/GigaGrinch.png" 2>/dev/null \
  | head -c 13 | strings | head -1)
echo "Part 2: $PART2"

# 7. Combine both halves
FLAG="${PART1}${PART2}"
echo ""
echo "FLAG: $FLAG"
```

Output:

```
Part 1: Sleigh{c@nDy_c@n3
Part 2: s_AR3_M!!N33}

FLAG: Sleigh{c@nDy_c@n3s_AR3_M!!N33}
```

## Flag

```
Sleigh{c@nDy_c@n3s_AR3_M!!N33}
```
