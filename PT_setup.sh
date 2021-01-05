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
echo -e "${BLUE}Updating OS.${NC}"
apt update ; apt -y upgrade ; apt -y dist-upgrade ; apt -y autoremove ; apt -y autoclean ; updatedb
echo

echo -e "${BLUE}Updating PIP.${NC}"
/usr/bin/python3 -m pip install --upgrade pip
echo

#####################
### CONFIGURATION ###
#####################

# Create new NON-ROOT user account
echo -e "${BLUE}Creating non-root user.${NC}"
echo -e "${YELLOW}Please enter account name: ${NC}"
read newbie
useradd -m $newbie
passwd $newbie
usermod -a -G sudo $newbie
chsh -s /bin/bash $newbie
echo -e "${BLUE}New account created.${NC}"
echo

# SSH Persistence
echo -e "${BLUE}Making SSH persistent.${NC}"
sudo systemctl enable ssh
echo

# MSF
echo -e "${BLUE}Installing Postgresql.${NC}"
sudo apt install postgresql
echo
sudo systemctl enable postgresql
echo

echo -e "${BLUE}Installing MSF.${NC}"
cd /tmp
sudo -H -u $newbie curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod +x msfinstall
echo

echo -e "${BLUE}Setting up MSF as non-root user.${NC}"
sudo -H -u $newbie ./msfinstall
sudo -H -u $newbie msfdb init
sudo -H -u $newbie msfdb start
sudo -H -u $newbie msfupdate
echo

# RDP
echo -e "${BLUE}Setting up RDP.${NC}"
sudo apt install xrdp -y
sudo systemctl enable xrdp
sudo systemctl start xrdp
echo

######################
# INSTALLS & UPDATES #
######################

# Sublime
echo -e "${BLUE}Installing Sublime Text.${NC}"
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"
sudo apt install sublime-text -y
echo

# Dos2Unix
echo -e "${YELLOW}Installing Dos2Unix.${NC}"
sudo apt install dos2unix -y
echo

# XML Tools
if [ ! -f /usr/bin/xlsx2csv ]; then
     echo -e "${YELLOW}Installing xlsx2csv.${NC}"
     sudo apt install -y xlsx2csv
     echo
fi

if [ ! -f /usr/bin/xml_grep ]; then
     echo -e "${YELLOW}Installing xml_grep.${NC}"
     sudo apt install -y xml-twig-tools
     echo
fi

# NSLookup
if [ ! -f /usr/bin/nslookup ]; then
     echo -e "${YELLOW}Installing DNS Tools.${NC}"
     sudo apt install -y dnstools
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
sudo nmap --script-updatedb | egrep -v '(Starting|seconds)' | sed 's/NSE: //'
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
     sudo ./setup.sh
     echo
fi

# Swaks
echo -e "${YELLOW}Installing Swaks.${NC}"
sudo apt install swaks -y
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
     sudo pip install .
     sudo ./setup.sh
     echo
fi

####################
# UPDATE SYSTEM DB #
####################
# Update DB
echo -e "${BLUE}Updating locate.${NC}"
sudo updatedb
echo

echo
exit
