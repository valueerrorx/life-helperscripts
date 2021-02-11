#!/bin/bash
# last updated: 02.04.2019
# this file copies a backup of the .kde/share/config .config .local folder over the original

USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"

echo "Aktuelle Desktop Konfiguration mit Backup ersetzen?"
echo "!! strg+c um abzubbrechen !!"
sleep 2


if [ "$(id -u)" != "0" ]; then
    echo "You need root privileges - Stopping program"
    exit 1
fi


paplay /usr/share/sounds/KDE-Sys-App-Positive.ogg



echo "Stelle kde.config wieder her...."
cp -Ra ${BACKUPDIR}/kde.config/* ${HOME}.kde/share/config/
sleep 0.5

echo "Stelle .config wieder her...."
cp -Ra ${BACKUPDIR}/home.config/* ${HOME}.config/
sleep 0.5

echo "Stelle .local wieder her...."
cp -Ra ${BACKUPDIR}/home.local/* ${HOME}.local/
sleep 0.5



echo "Entferne icon cache ...."  #remove icon cache - otherwise some changes will not be visible
sudo rm /usr/share/icons/hicolor/icon-theme.cache  > /dev/null 2>&1  #hide errors
sudo rm /var/tmp/kdecache-${USER}/plasma_theme_default.kcache  > /dev/null 2>&1  #hide errors
sudo rm /var/tmp/kdecache-${USER}/icon-cache.kcache  > /dev/null 2>&1  #hide errors
sudo rm -r ${HOME}.cache  > /dev/null 2>&1  #hide errors
sleep 0.5



echo "Deskop Konfiguration wiederhergestellt!"
echo "Starte Deskop neu!"
sleep 0.5

sudo killall Xorg
