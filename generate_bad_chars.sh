#!/bin/bash

# generate common bad characters 0x00 to 0xff, 
# which are known to have issues when used in 
# shellcode

for i in {0..255}; do 
  printf "\\\x%02x" $i; 
done
