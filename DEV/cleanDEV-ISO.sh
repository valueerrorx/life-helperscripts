#!/bin/bash
#cleaning Development Environment and Build ISO File

# atom
sudo apt -y purge atom
sudo apt -y autoclean
sudo apt -y autoremove

# telegram via snap as user student
snap remove telegram-dektop

# apt
sudo apt -y purge telegram-desktop snapd

sudo rm -r -v /home/student/.p2
sudo rm -r -v /home/student/.atom
sudo rm -r -v /home/student/eclipse-workspace
sudo rm -r -v /home/student/Downloads/*
sudo rm -r -v /home/student/.local/share/TelegramDesktop
sudo rm -r -v /home/student/snap/

sudo rm -r -v /home/student/.cache/mozilla/
sudo rm -r -v /home/student/.mozilla/

find /home/student/ -type d -regextype sed -iregex ".*/[\.]*kite" -exec rm -r -v {} \;
find /home/student/ -type d -regextype sed -iregex ".*/[\.]*eclipse" -exec rm -r -v {} \;
find /home/student/ -type d -regextype sed -iregex ".*/[\.]*atom" -exec rm -r -v {} \;

#no need for local python stuff here
find /home/student/.local -type d -name "python2.[0-9]" -exec rm -r -v {} \;
find /home/student/.local -type d -name "python3.[0-9]" -exec rm -r -v {} \;
echo "/home/student/.local/lib"
echo "Do you have othe python modules here ? than CHECK !"
sleep 5

#SSH
sudo rm -r -v /home/student/.ssh
sudo rm -r -v /root/.ssh


#call original cleanNBuild
sudo /home/student/.life/applications/helperscripts/cleansystem-createiso-root.sh

#chromium
#firefox
#google_chrome
