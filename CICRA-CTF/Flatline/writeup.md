# Flatline

An executable that requires a commandline input to show the flag.

---

## Solution

- Create an object dump out of the file for further processing

```bash
objdump -d -Mintel flatline > flatline.objdump.asm
```

- Copy paste the contents into ChatGPT and give it a prompt to identify patterns and decode the flag in the form of Hasx{...}

- You should get the flag in the form ```flatline{state_machines_ftw!}```