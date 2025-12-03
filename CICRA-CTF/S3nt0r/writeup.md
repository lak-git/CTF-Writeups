# S3nt0r

A Reverse Engineering challenge

---

## Solution

- As an instict when received an executable, create and objdump out of it.

```bash
objdump -d -Mintel hashx-malware-medium.exe > hasx-malware-medium.exe.objdump.asm
```

- Feed the new assembly object dump file into chatgpt with this prompt to find the flag.

```md
This is a CTF challenge and the provided text is an object dump of an executable that contains a hidden flag inside of it in the form HashX{...}. Identify possible hex and byte patterns and uncover the flag.
```

- It should identify these lines

```asm
mov DWORD PTR [rax],0x334e3353
mov DWORD PTR [rax+0x4],0x5f523054
mov DWORD PTR [rax+0x8],0x5f534148
mov DWORD PTR [rax+0xc],0x7d313133
```

- Converting them should yield these segments

```md
0x334e3353 → bytes 53 33 4E 33 → ASCII "S3N3"

0x5f523054 → bytes 54 30 52 5F → ASCII "T0R_"

0x5f534148 → bytes 48 41 53 5F → ASCII "HAS_"

0x7d313133 → bytes 33 31 31 7D → ASCII "311}"
```

- Reconstructing the final flag: ```HashX{S3N3T0R_HAS_311}```