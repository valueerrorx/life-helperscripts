#!/bin/bash
clear

echo "----------------------------- "
echo "  cleaning system  "
echo "----------------------------- "

sudo apt-get -y clean
sudo apt-get -y autoclean
sudo apt-get -y autoremove


echo "copy firststartwizard to autostart folder"
cp /home/student/.life/applications/life-firststart/firststart.sh /home/student/.config/autostart-scripts/


echo "removing cache files"
sudo rm /var/tmp/kdecache-root/*  > /dev/null 2>&1
sudo rm /var/tmp/kdecache-student/* > /dev/null 2>&1
sudo rm /var/crash/* > /dev/null 2>&1

sudo rm /var/lib/snapd/cache/ -r > /dev/null 2>&1


rm /home/student/.xsession-errors

echo "removing log files"
rm /home/student/.life/EXAM/client.log > /dev/null 2>&1
find /home/student/.life/applications/life-exam/ -type f -name "*.log" -exec rm -f {} \;  > /dev/null 2>&1

rm /home/student/.local/share/RecentDocuments/*  > /dev/null 2>&1
rm /home/student/.kde/share/apps/RecentDocuments/*  > /dev/null 2>&1

echo "" |sudo tee /var/log/syslog
sudo rm /var/cache/apt/srcpkgcache.bin /var/cache/apt/pkgcache.bin
sudo rm -r /var/lib/apt/lists/*

journalctl --vacuum-time=1000d


echo "Removing EXAM workfolder so changes in source will take effekt"
sudo rm -r /home/student/.life/EXAM/ > /dev/null 2>&1



echo "starting bleachbit"

LIST='adobe_reader|amsn|amule|audacious|bash|d4x|epiphany|evolution|filezilla|flash|gwenview|journald|kde|libreoffice|liferea|midnightcommander|nautilus|openofficeorg|opera|thunderbird|x11|yum'
SLIST='system.trash|system.clipboard|system.recent_documents|system.rotated_logs'


sudo -u student -H bleachbit --list | grep -E "[a-z0-9_\-]+\.[a-z0-9_\-]+" | grep -E ${LIST} | sudo -u student -H xargs bleachbit --clean
sudo -u student -H bleachbit --list | grep -E "[a-z0-9_\-]+\.[a-z0-9_\-]+" | grep -E ${SLIST} | sudo -u student -H xargs bleachbit --clean


echo ""
echo "----------------------------------------------------"
echo "clear bash history"
history -w
history -c
rm /home/student/.bash_history > /dev/null 2>&1

#SSH
sudo rm -r -v /home/student/.ssh
sudo rm -r -v /root/.ssh


echo "Backup Desktop Configuration "
sudo -u student sh /home/student/.life/applications/life-helperscripts/desktop-backup.sh &


echo "Start System Imager"
sudo -E /home/student/.life/applications/life-builder/main.py &
history -w
history -c

exit 0
