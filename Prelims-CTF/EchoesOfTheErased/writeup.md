# Echoes of the Erased

## Overview

The challenge provides a 64MB ext4 disk image (`w13_evidence.img`, downloadable from `http://192.168.45.128:8093/download`) and a web form to submit the recovered flag. The image is described as "evidence" with a deleted file that "the story is still there, waiting to be reassembled from the fragments." Submission endpoint: `POST /verify` with form field `flag=`.

---

## Recon

Running `file w13_evidence.img` returns `Linux rev 1.0 ext4 filesystem data, UUID=179c83d3-cefe-4e67-b7bb-c08303ff5413 (extents) (64bit) (huge files)` — a 64MB ext4 filesystem with the modern extents/64bit featureset.

The web page hints: *"Not everything you find in this image is what it claims to be. Multiple deleted artifacts exist — consider whether any of them relate to each other, and in what order."*

Listing deleted entries with SleuthKit:

```bash
fls -r w13_evidence.img
# d/d 11:        lost+found
# V/V 16385:     $OrphanFiles
# + -/r * 12:    OrphanFile-12   created 13:09:04 deleted 13:10:02
# + -/r * 13:    OrphanFile-13   created 13:09:15 deleted 13:10:10
# + -/r * 14:    OrphanFile-14   created 13:09:25 deleted 13:10:17
# + -/r * 15:    OrphanFile-15   created 13:09:32 deleted 13:10:24
# + -/r * 16:    OrphanFile-16   created 13:09:40 deleted 13:10:31
```

`istat` on every orphan shows `size: 0`, `num of links: 0`, no direct blocks — `dumpe2fs` confirms `[ITABLE_ZEROED]`. The pointers are gone, but the pages (data blocks) should remain — exactly the hint.

---

## Analysis

**Vulnerability:** the attacker zeroed the inode table but did not purge the JBD2 journal. ext4 commits data-block contents to the journal *before* writing them to disk, so the journal still holds the most recent committed version of any block it touched — including the inode-table block holding the now-zeroed inodes 12–16.

`dumpe2fs` shows:
- inode table: blocks 41–1064 (so block 41 = inodes 1–16)
- journal: inode 8, a 4MB regular file at extents (15–24), (26–40), (1066–2064)
- journal sequence: 0x0e (only 14 transactions; the file-creation transactions have been overwritten by later mount/unmount metadata, but the inode-table snapshots survive)

`debugfs -R "logdump"` confirms 12 transactions. Parsing each descriptor block, I find four transactions that journaled `disk block 41` (the inode-table block). The latest snapshot of that block still has the original extent pointers intact because the attacker only zeroed the on-disk copy, not the journal copy.

Reading the four "data block 41" snapshots and the directory entries recorded in journal transactions for disk block 10 (the root directory) reveals the original filenames and the chronological order of creation/deletion:

| inode | filename (from journal)            | size | extent start |
|-------|------------------------------------|------|--------------|
| 12    | system_config_backup.dat           | 12   | 2065         |
| 13    | cache_block_001.bin                | 15   | 2577         |
| 14    | cache_block_002.bin                | 15   | 3089         |
| 15    | cache_block_003.bin                | 17   | 3090         |
| 16    | recovered_notes.txt                | 39   | 2066         |

Direct reads from the journal-extracted block numbers:

- block 2065 → `GHOSTKEY2026` (the XOR key)
- block 2066 → `MAHASONA{deleted_file_metadata_carved}` (the planted decoy)
- blocks 2577/3089/3090 → opaque 15/15/17-byte blobs

The "in what order" hint refers to the rotation offset applied to `GHOSTKEY2026` when encrypting each cache block. Trying rotations 0..11 in a small Python loop reveals:

```
rotation 0 → MAHASONA{disk_c
rotation 3 → arving_ghost_me
rotation 6 → tadata_recovered}
```

Rotations 0, 3, 6 — exactly the "step of 3" implied by three files.

---

## Exploitation

Single solve script (run from a directory containing `w13_evidence.img`):

```python
#!/usr/bin/env python3
"""Echoes of the Erased — recover deleted files from ext4 image."""
import struct, subprocess, urllib.request, urllib.parse

IMG = 'w13_evidence.img'
BS  = 4096

# 1) dump the journal (inode 8) to a raw file
subprocess.run(['debugfs','-R','dump <8> journal.img', IMG], check=True,
               stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

# 2) walk the JBD2 journal to find every data block journaled for disk block 41
with open('journal.img','rb') as f: jrn = f.read()
snapshots = []
i = 1
while i < len(jrn)//BS:
    blk = jrn[i*BS:(i+1)*BS]
    magic, btype = struct.unpack('>II', blk[:8])
    if magic != 0xC03B3998:
        i += 1; continue
    if btype == 1:                                # descriptor block
        seq = struct.unpack('>I', blk[8:12])[0]
        tags, off = [], 12
        while off < BS:
            bnr, flags = struct.unpack('>II', blk[off:off+8])
            if bnr == 0 or flags > 0x10: break
            tags.append(bnr); off += 8
            if flags & 0x08: break
        for k, bnr in enumerate(tags):
            snapshots.append((seq, bnr, jrn[(i+1+k)*BS:(i+2+k)*BS]))
        i += 1 + len(tags) + 1                    # skip data + commit
    else:
        i += 1

# 3) take the LATEST snapshot of disk block 41 (inodes 1..16) and extract extents
snapshots = [s for s in snapshots if s[1] == 41]
latest = max(snapshots, key=lambda s: s[0])[2]
extents = {}
for n in range(12, 17):
    ino = latest[(n-1)*256:(n)*256]
    flags = struct.unpack('<I', ino[32:36])[0]
    if flags & 0x80000:                          # extents
        magic = struct.unpack('<H', ino[40:42])[0]
        if magic == 0xf30a:
            ent = struct.unpack('<H', ino[42:44])[0]
            ee_block, ee_len, ee_hi, ee_lo = struct.unpack('<IHHI', ino[52:64])
            extents[n] = ((ee_hi << 32) | ee_lo, ee_len)
print('extents:', extents)
# {12: (2065,1), 13: (2577,1), 14: (3089,1), 15: (3090,1), 16: (2066,1)}

# 4) read the data blocks directly off the image
def read_block(n):
    with open(IMG,'rb') as f:
        f.seek(n*BS); return f.read(BS)
data = {n: read_block(blk)[:ln] for n,(blk,ln) in extents.items()}
print('block 12 (key):',     data[12])
print('block 16 (decoy):',   data[16])

# 5) decrypt cache blocks 13/14/15 with rotations 0/3/6 of the key
key = data[12]                                   # b'GHOSTKEY2026'
def rot(k, n): return k[n:] + k[:n]
fragments = [
    bytes(b ^ rot(key,0)[i%12] for i,b in enumerate(data[13])),
    bytes(b ^ rot(key,3)[i%12] for i,b in enumerate(data[14])),
    bytes(b ^ rot(key,6)[i%12] for i,b in enumerate(data[15])),
]
flag = b''.join(fragments).decode()
print('flag:', flag)

# 6) submit
data = urllib.parse.urlencode({'flag': flag}).encode()
print(urllib.request.urlopen(
    urllib.request.Request('http://192.168.45.128:8093/verify', data=data)).read().decode())
```

Output:

```
extents: {12: (2065,1), 13: (2577,1), 14: (3089,1), 15: (3090,1), 16: (2066,1)}
block 12 (key):    b'GHOSTKEY2026'
block 16 (decoy):  b'MAHASONA{deleted_file_metadata_carved}\n'
flag: MAHASONA{disk_carving_ghost_metadata_recovered}
b'EVIDENCE RECOVERED: MAHASONA{disk_carving_ghost_metadata_recovered}'
```

---

## The Flag

```
MAHASONA{disk_carving_ghost_metadata_recovered}
```

---

## Remediation

From a developer's / sysadmin's perspective, the lesson is that **"deleted" is not "erased"** in any POSIX-style filesystem. Several hardening steps would have prevented this recovery:

1. **Secure-delete the data blocks, not just the metadata.** `shred -vzn3` on the raw block device, or `blkdiscard` on SSDs, overwrites the actual sectors. Merely calling `unlink(2)` (or even `rm -rf`) only frees the inode; the underlying pages are untouched until overwritten by other writes.
2. **Encrypt sensitive data at rest.** Even if the blocks leak, the ciphertext is useless without the key. `eCryptfs`, `fscrypt`, or LUKS-on-top of the partition provides this; storing secrets in plaintext on disk is the root cause of every "deleted-file-recovery" challenge.
3. **Disable or scrub the journal for sensitive workloads.** A mounted ext4 filesystem cannot safely discard its journal because that would break crash-recovery semantics, but a forensic wipe procedure should overwrite the journal inode's data blocks (here, 15–24 / 26–40 / 1066–2064) after the final unmount. `dd if=/dev/zero of=…` against those specific blocks (after identifying them with `debugfs -R "stat <8>"`) closes the leak.
4. **Don't plant decoys.** `recovered_notes.txt` made the flag hunt harder but also confirmed to the attacker that the real data was elsewhere. A real adversary would have omitted the decoy entirely.
5. **Audit filesystem actions.** `auditd` rules watching `unlinkat`, `truncate`, and direct block-device writes would alert on bulk inode/zeroing activity in real time, before the disk image is exfiltrated.
