# Abhiman

Abhiman is a series of challenges which includes 5 of them. This writeup only solves 2, would love to see someone solving the rest!

---

## Abhiman-1

- Start by performing an nmap scan on the IP address.

```nmap
nmap -sS -sC -sV -A -T4 <ip>
```

Output:

```nmap
Starting Nmap 7.95 ( https://nmap.org ) at 2025-11-16 02:37 EST
Nmap scan report for 152.42.228.143
Host is up (0.043s latency).
Not shown: 977 closed tcp ports (reset) 
PORT STATE SERVICE VERSION
22/tcp open ssh OpenSSH 10.0p2 Debian 7 (protocol 2.0)
25/tcp open smtp?
|_smtp-commands: Couldn't establish connection on port 25
| fingerprint-strings:
| DNSStatusRequestTCP, DNSVersionBindReqTCP, GenericLines, GetRequest, HTTPOptions, Kerberos, RTSPRequest, SSLSessionReq, TLSSessionReq:
| 500 Syntax error, command unrecognized
| Hello:
|_ 552 Invalid domain name in EHLO command.
26/tcp filtered rsftp
80/tcp open http Apache httpd 2.4.65 ((Debian))
|_http-server-header: Apache/2.4.65 (Debian)
212/tcp filtered anet 256/tcp filtered fw1-secureremote
554/tcp filtered rtsp 911/tcp filtered xact-backup
1164/tcp filtered qsm-proxy 1234/tcp open hotline?
| fingerprint-strings:
| GenericLines, GetRequest, HTTPOptions, JavaRMI, NULL:
| "Beyond the depth of the unseen - The story of the lost souls",
| -@abhimancharithaya | Seek the place where words float freely, where tales are engraved in the clouded ink in the medium of life.
| Whispers remain | https://pastebin.com/aEtLE1xE
|_ Flag 1 - Legion{04b1def7b68d071393740fea532aeb2e}
1723/tcp filtered pptp 2000/tcp filtered cisco-sccp
2020/tcp filtered xinupageserver 5060/tcp filtered sip
5061/tcp filtered sip-tls 5900/tcp filtered vnc
8888/tcp filtered sun-answerbook 9002/tcp filtered dynamid
9415/tcp filtered unknown 9618/tcp filtered condor
9998/tcp filtered distinct32 25734/tcp filtered unknown
56737/tcp filtered unknown 2 services unrecognized despite returning data
Service detection performed. 
Please report any incorrect results at https://nmap.org/submit/ . Nmap done: 1 IP address (1 host up) scanned in 699.33 seconds
```

- On pot ```1164/tcp``` flag 1 is revealed; ```Legion{04b1def7b68d071393740fea532aeb2e}```

---

## Abhiman-2

- Continuing on the previous nmap scan, we can see that there is a [pastebin link](https://pastebin.com/aEtLE1xE). Following that shows us a bunch of hex values. Turns out, it is a hex dump of a PNG image. (You can confirm it by pasting it into ChatGPT.)

- Save the hex dump as ```image.hex``` and run the following command to convert it back into a PNG

```bash
xxd -r -p image.hex image.png
```

- It is a QR code for a [medium page](https://medium.com/@abhimancharithaya/4c-65-67-69-6f-6e-7b-36-66-61-37-62-34-35-61-30-36-35-33-38-63-64-36-31-37-35-38-36-31-36-66-33-65-f8c8ea56a4a8). Converting the given Hex value from CyberChef reveals the second flag. ```Legion{6fa7b45a06538cd61758616f3e75493c}```

---

## The Rest?

Apparently you have to solve the riddle on the medium page. That's where I got stumped.