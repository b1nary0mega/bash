#!/bin/bash
##########################################################################
### The point of this script is to provide an easy quick(er) method to ###
### both scan a network and make a folder structure for importing into ###
### CherryTree (or any similar note-taking program). The idea being    ###
### that each file created, should be appended to as one continues to  ###
### do recon.                                                          ###
##########################################################################

fileName="nmap_scan.txt"
folderName="machines"
network="192.168.0.1-254"
topXports=5

# provide help menu when no cmd vars used
if [ -z "$1" ]; then
  echo "[*] Script to generate files to hold scan information."
  echo "[*] Usage : $0 <IP-range>"
  echo "[*] Example: $0 $network"
  exit 0
fi

# set network variable, we made it past var check
network=$1

# run the scan
printf '...running scan for top %s ports in network %s...\n' $topXports $network
nmap -sT -A --top-ports=$topXports $network -oG $fileName

# create directory for output
printf '...making %s directory...\n' $folderName
mkdir $folderName

#echo out the contents of scan for each machine, to it's own file
printf '...grepping out all the juicy bits to their respective file(s)...\n'
for machine in $(cat $fileName | grep Up | cut -d" " -f2); do 
  grep "$machine " $fileName > ./$folderName/$machine
done
