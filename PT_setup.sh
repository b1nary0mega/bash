#!/bin/bash
############################################################
# TITLE: setup.sh
# AUTH: Jimmi Aylesworth
# DATE: 12-07-2020
#
# DESC: Authomate the installation and setup of commonly
#       used pentest tools.
#
# NOTE: Script idea and base taken from Lee Baird:
#       https://github.com/leebaird/discover
############################################################

# Global variables
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

######################
### SYSTEM UPDATES ###
######################

# Update System
echo -e "${BLUE}Updating Kali.${NC}"
apt update ; apt -y upgrade ; apt -y dist-upgrade ; apt -y autoremove ; apt -y autoclean ; updatedb
echo

echo -e "${BLUE}Updating PIP.${NC}"
/usr/bin/python3 -m pip install --upgrade pip
echo

#####################
### CONFIGURATION ###
#####################

# SSH Persistence
echo -e "${BLUE}Making SSH Persistent.${NC}"
systemctl enable ssh
echo

# MSF
echo -e "${BLUE}Setting up MSF.${NC}"
apt install postgresql
echo
systemctl enable postgresql
msfdb init
msfdb start
echo

# RDP
echo -e "${BLUE}Setting up RDP.${NC}"
apt install xrdp -y
systemctl enable xrdp
systemctl start xrdp
echo

######################
# INSTALLS & UPDATES #
######################

# Sublime
echo -e "${BLUE}Installing Sublime Text.${NC}"
apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
apt install sublime-text -y
echo

# Dos2Unix
echo -e "${YELLOW}Installing Dos2Unix.${NC}"
apt install dos2unix -y
echo

# XML Tools
if [ ! -f /usr/bin/xlsx2csv ]; then
     echo -e "${YELLOW}Installing xlsx2csv.${NC}"
     apt-get install -y xlsx2csv
     echo
fi

if [ ! -f /usr/bin/xml_grep ]; then
     echo -e "${YELLOW}Installing xml_grep.${NC}"
     apt-get install -y xml-twig-tools
     echo
fi

# Discover
if [ -d /opt/discover ]; then
	echo -e "${BLUE}Updating Discover.${NC}"
	cd /opt/discover ; git pull
	echo
else
	echo -e "${YELLOW}Installing Discover.${NC}"
        git clone https://github.com/leebaird/discover.git /opt/discover
        echo
fi

# NMap Scripts
echo -e "${BLUE}Updating Nmap scripts.${NC}"
nmap --script-updatedb | egrep -v '(Starting|seconds)' | sed 's/NSE: //'
echo

# SecLists
if [ -d /opt/SecLists/.git ]; then
     echo -e "${BLUE}Updating SecLists.${NC}"
     cd /opt/SecLists/ ; git pull
     echo
else
     echo -e "${YELLOW}Installing SecLists.${NC}"
     git clone https://github.com/danielmiessler/SecLists /opt/SecLists
     echo
fi

# Cobalt-Strike
if [ -d /opt/Cobalt-Strike ]; then
     if [ -d /opt/Cobalt-Strike/third-party/chryzsh-scripts/.git ]; then
          echo -e "${BLUE}Updating Cobalt Strike aggressor scripts - chryzsh.${NC}"
          cd /opt/Cobalt-Strike/third-party/chryzsh-scripts/ ; git pull
          echo
     else
          echo -e "${YELLOW}Installing Cobalt Strike aggressor scripts - chryzsh.${NC}"
          git clone https://github.com/chryzsh/Aggressor-Scripts.git /opt/Cobalt-Strike/third-party/chryzsh-scripts
          echo
     fi

     if [ -d /opt/Cobalt-Strike/third-party/mgeeky-scripts/.git ]; then
          echo -e "${BLUE}Updating Cobalt Strike aggressor scripts - mgeeky.${NC}"
          cd /opt/Cobalt-Strike/third-party/mgeeky-scripts/ ; git pull
          echo
     else
          echo -e "${YELLOW}Installing Cobalt Strike aggressor scripts - mgeeky.${NC}"
          git clone https://github.com/mgeeky/cobalt-arsenal.git /opt/Cobalt-Strike/third-party/mgeeky-scripts
          echo
     fi

     if [ -d /opt/Cobalt-Strike/third-party/profiles/.git ]; then
          echo -e "${BLUE}Updating Cobalt Strike profiles.${NC}"
          cd /opt/Cobalt-Strike/third-party/profiles/ ; git pull
          echo
     else
          echo -e "${YELLOW}Installing Cobalt Strike profiles.${NC}"
          git clone https://github.com/rsmudge/Malleable-C2-Profiles.git /opt/Cobalt-Strike/third-party/profiles
          echo
     fi

     if [ -d /opt/Cobalt-Strike/third-party/taowu-scripts/.git ]; then
          echo -e "${BLUE}Updating Cobalt Strike aggressor scripts - taowu.${NC}"
          cd /opt/Cobalt-Strike/third-party/taowu-scripts/ ; git pull
          echo
     else
          echo -e "${YELLOW}Installing Cobalt Strike aggressor scripts - taowu.${NC}"
          git clone https://github.com/pandasec888/taowu-cobalt-strike.git /opt/Cobalt-Strike/third-party/taowu-scripts
          echo
     fi
fi

# EyeWitness
if [ -d /opt/EyeWitness/.git ]; then
     echo -e "${BLUE}Updating EyeWitness.${NC}"
     cd /opt/EyeWitness/ ; git pull
     echo
else
     echo -e "${YELLOW}Installing EyeWitness.${NC}"
     git clone https://github.com/ChrisTruncer/EyeWitness.git /opt/EyeWitness
     cd /opt/EyeWitness/Python/setup/
     ./setup.sh
     echo
fi

# Swaks
echo -e "${YELLOW}Installing Swaks.${NC}"
apt install swaks -y
echo

# Impacket
if [ -d /opt/Impacket/.git ]; then
     echo -e "${BLUE}Updating Impacket.${NC}"
     cd /opt/Impacket/ ; git pull
     echo
else
     echo -e "${YELLOW}Installing Impacket.${NC}"
     git clone https://github.com/SecureAuthCorp/impacket.git /opt/Impacket
     cd /opt/Impacket/
     pip install .
     ./setup.sh
     echo
fi

####################
# UPDATE SYSTEM DB #
####################
# Update DB
echo -e "${BLUE}Updating locate.${NC}"
updatedb
echo

echo
exit
