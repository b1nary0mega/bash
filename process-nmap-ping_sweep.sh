#!/bin/bash

for machine in $(cat output-nmap_sweep_responders-WEB-greppable.txt | grep Ports: | cut -d":" -f2-6 | cut -d" " -f2); do
  printf 'Machine :: %s\n' $machine >> ./machines/$machine
  for line in $(cat output-nmap_sweep_responders-WEB-greppable.txt | grep Ports: | cut -d":" -f2-15 | grep $machine | cut -d" " -f3-15); do
    printf '\t%s' $line >> ./machines/$machine
  done
done

echo "All set!"
