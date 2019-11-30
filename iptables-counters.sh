#!/bin/bash

# used to review track to/from a provided address

if [ -z $1 ]; then
  echo "[*] A simple traffic counter."
  echo "[*] Use: $0 <IP-ADDRESS>"
  echo "[*] Review: iptables -vn -L" 
  exit 0
fi

#reset all counters and iptables rules
iptables -Z && iptables -F

#measure incoming traffic to provided IP
iptables -I INPUT 1 -s $1 -j ACCEPT

#measure outgoing traffic to provided IP
iptables -I OUTPUT 1 -d $1 -j ACCEPT

