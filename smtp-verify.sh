#!/bin/bash
if [ -z $1 ]; then
  echo " [*] Verify users via SMTP brute force."
  echo " [*] Use: $0 <USERLIST.txt> <MAILSERVER-IP>"
  exit 0
fi

for user in $(cat $1); do
  echo VRFY $user | nc -nv -w 1 $2 25 2>/dev/null | grep ^'250'
done

