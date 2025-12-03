# Rush

Rush was a 2 stage full-pwn challenge consisting of Rush - User and Rush - Root.

---

## Rush - User

- Start with an nmap scan for enumeration.

```nmap
nmap -sS -sC -sV -A -T4 <ip>
```

- It should reveal that FTP service is running with allowing Anonymous login. Log into it under Anynymous:""

```bash
ftp -A <ip>
```

- Run the ```ls``` command and you should see some files run ```get <filename>``` to download them onto your system.

- We have a hint on the user, ```samir``` and there's some credentials on ```README.txt```.

- Log in to the SMB client under samir:netshare42.

- You should see a user.txt file and it contains the flag.

---

## Credit

[Chithma Pathirana](https://www.linkedin.com/in/chithma-pathirana-32389b323/) for solving this