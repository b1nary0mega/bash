#!/bin/bash

if [ -z $1 ]; then
  echo "[*] SNMP Enumeration script of given ips for interesting snmp values"
  echo "[*] Use: $0 <IP_LIST> <MIB_LIST>"
  echo "[*] Sample: $0 ./output/onesixtyone-snmp_check.txt ./one_liners/mib-values"
  exit 0
fi

ipList=$1
mibList=$2

for ip in $(cat $ipList | cut -d" " -f1); do 
  echo "=============================="
  echo "SNMP walking $ip"
  echo "=============================="
  for leaf in $(cat $mibList | cut -f1); do 
    echo "== MIB LEAF == $(cat $mibList | grep $leaf | cut -f2)"
    walkItOut=$(snmpwalk -c public -v1 $ip $leaf 2>/dev/null)	#store results as variable to evaluate
    if [ ! -z "$walkItOut" ]; then
      printf "$walkItOut\n"
      $walkItOut=""						#clear variable for next run
    else
      echo "...nothing found..."
    fi
  done
done

