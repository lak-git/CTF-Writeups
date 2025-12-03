# Triple Jingle Encryption

- Netcat into the given ip

```nc
nc -<ip> -<port>
```

- You should get some output in the form of a JSON. Some cipher texts and moduli for it.

- You must leverage a Håstad Broadcast Attack to crack the cipher text, luckily this can be easily achieved. Simply copy the output and paste it into chatgpt and ask it to generate the relevant script. ```solve.py``` contains the cipher text and cracks it revealing the flag

```
SLEIGH{s4nt4s_3ncrypt10n_m1st4k3_h0h0h0!}
```
