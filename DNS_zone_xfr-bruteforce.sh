#!/bin/bash
# Simple Zone Transfer Bash Script
# $1 is the first argument given after the bash script
# Check if argument was given, if not, print usage
if [ -z "$1" ]; then
  echo "[*] Simple Zone tranfer script"
  echo "[*] Usage : $0 <domain name> "
  exit 0
fi

# if argument was given, identify the DNS servers for the domain
for server in $(host -t ns $1 | cut -d" " -f4);do
  #echo "Attempting xfr on" $server
  host -l $1 $server | grep "has address"
done

