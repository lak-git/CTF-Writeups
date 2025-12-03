# Byte Offset

This an OSINT related challenge.

---

## Description

Picture a tiny digital ghost hiding in the wires a phantom known only as Agent, a Trojan that once slipped through a corporate network like a whisper in a crowded room. Agent didn’t damage anything. Instead, it left behind a single clue, tucked deep inside its binary body, waiting for someone curious enough to chase it. 

Your team intercepted a SHA-256 hash the only surviving fingerprint of Agent. The malware itself vanished from every system it touched, as if it knew it was being hunted. Rumor says that creator embedded a message somewhere inside the code, a human-readable string hidden at the 115th byte offset. A signature. A taunt. Maybe even a confession. 

Your job is to find that message. 

Flag format HashX{Your_Found_Text_With_Underscores}

SHA-256 Hash Value : 881941ea24e92f4bd4d69d79e27ce1d2b10094172cb3cc93b223daf70ef2d867

---

## Solution

- It is hinted that this is some sort of a malware. The first go to thing is to search this up in virus total to get an idea what it is ```https://www.virustotal.com/gui/file/881941ea24e92f4bd4d69d79e27ce1d2b10094172cb3cc93b223daf70ef2d867```

- Indeed it is a known malware. We need to download it. Go to Malware Bazaar ```https://bazaar.abuse.ch/browse/``` and search the SHA value. ```sha256:881941ea24e92f4bd4d69d79e27ce1d2b10094172cb3cc93b223daf70ef2d867```

- It says to look in the 115th byte offset. We should get a hex dump of it and see

```bash
hexdump -C malware.exe > hexdump.txt
```

- cat the contents and you can see the ASCII message. The flag then is ```HashX{!This_program_cannot_be_run_in_DOS_mode}```