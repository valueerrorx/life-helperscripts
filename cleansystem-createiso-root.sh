#!/bin/bash
clear



USER=$(logname)

echo "----------------------------- "
echo "  cleaning system  "
echo "----------------------------- "

sudo apt-get clean
sudo apt-get autoclean
sudo apt-get autoremove



echo "copy firststartwizard to autostart folder"
cp /home/student/.life/applications/life-firststart/firststart.sh /home/student/.config/autostart-scripts/


echo "removing cache files"
sudo rm /var/tmp/kdecache-root/*  > /dev/null 2>&1
sudo rm /var/tmp/kdecache-student/* > /dev/null 2>&1
sudo rm /var/crash/* > /dev/null 2>&1

sudo rm /var/lib/snapd/cache/ -r > /dev/null 2>&1


rm /home/student/.xsession-errors
rm /home/student/.life/EXAM/client.log > /dev/null 2>&1
rm /home/student/.local/share/RecentDocuments/*  > /dev/null 2>&1
rm /home/student/.kde/share/apps/RecentDocuments/*  > /dev/null 2>&1

echo "" |sudo tee /var/log/syslog
sudo rm /var/cache/apt/srcpkgcache.bin /var/cache/apt/pkgcache.bin
sudo rm -r /var/lib/apt/lists/*

journalctl --vacuum-time=1000d


echo "EXAM workfolder so changes in source will take effekt"
rm -r /home/student/.life/EXAM/ > /dev/null 2>&1


echo "cleaning bash history"
history -w
history -c
rm /home/student/.bash_history > /dev/null 2>&1



echo "starting bleachbit as root and as user"
sudo bleachbit > /dev/null 2>&1
sudo -u ${USER} -H bleachbit
echo "clear bash history"
history -w
history -c



echo "clear clipboard history"
qdbus org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory
qdbus org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardContents



echo "Backup Desktop Configuration "
exec /home/student/.life/applications/helperscripts/gui-desktop-backup.sh &



echo "Start System Imager"
pkxexec /home/student/.life/applications/life-builder/main.py &
history -w
history -c
exit
exit 0
