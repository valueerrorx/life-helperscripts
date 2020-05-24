#!/bin/bash
#cleaning Development Environment and Build ISO File
sudo rm -r -v /home/student/.p2
sudo rm -r -v /home/student/.atom
sudo rm -r -v /home/student/eclipse-workspace
sudo rm -r -v /home/student/Downloads/LIFE-DEV/Backup/
sudo rm -r -v /home/student/Downloads/LIFE-DEV/bin/
sudo rm -r -v /home/student/Downloads/LIFE-DEV/eclipse/
sudo rm -r -v /home/student/Downloads/LIFE-DEV/eclipse-installer/
sudo rm -r -v /home/student/.local/share/TelegramDesktop
sudo rm -r -v /home/student/snap/

sudo rm -r -v /home/student/.cache/mozilla/
sudo rm -r -v /home/student/.mozilla/

find /home/student/ -type d -regextype sed -iregex ".*/[\.]*kite" -exec rm -r -v {} \;
find /home/student/ -type d -regextype sed -iregex ".*/[\.]*eclipse" -exec rm -r -v {} \;
find /home/student/ -type d -regextype sed -iregex ".*/[\.]*atom" -exec rm -r -v {} \;
find /home/student/.local -type d -name "python3.[1-7]" -exec rm -r -v {} \;


#call original cleanNBuild
sudo /home/student/.life/applications/helperscripts/cleansystem-createiso-root.sh

#chromium
#firefox
#google_chrome




