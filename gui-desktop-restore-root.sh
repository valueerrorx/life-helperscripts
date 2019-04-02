#!/bin/bash
# last updated: 28.11.2016
# this file copies a backup of the .kde/share/config .config .local folder over the original

USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



if [ "$(id -u)" != "0" ]; then
    kdialog  --msgbox 'You need root privileges - Stopping program' --title 'Restore'
    exit 1
fi

if [ -f "/etc/kde5rc" ];then
    kdialog  --msgbox 'Desktop is locked - Stopping program' --title 'Restore'
    sleep 2
    exit 1
fi



kdialog --warningcontinuecancel "Aktuelle Desktop Konfiguration mit Backup ersetzen?" --title "Restore";
if [ "$?" = 0 ]; then
    sleep 0
else
    exit 1 
fi;


## start progress with a lot of spaces (defines the width of the window - using geometry will move the window out of the center)
progress=$(sudo -H -u ${USER} kdialog --progressbar "Stelle gesicherte Konfiguration wieder her...                                                               ");
sudo -H -u ${USER} qdbus $progress Set "" maximum 5
sleep 0.5




sudo -H -u ${USER} qdbus $progress Set "" value 1
sudo -H -u ${USER} qdbus $progress setLabelText "Stelle kde.config wieder her...."
cp -Ra ${BACKUPDIR}/kde.config/* ${HOME}.kde/share/config/


sudo -H -u ${USER} qdbus $progress Set "" value 2
sudo -H -u ${USER} qdbus $progress setLabelText "Stelle .config wieder her...."
cp -Ra ${BACKUPDIR}/home.config/* ${HOME}.config/
sleep 0.5

sudo -H -u ${USER} qdbus $progress Set "" value 3
sudo -H -u ${USER} qdbus $progress setLabelText "Stelle .local wieder her...."
cp -Ra ${BACKUPDIR}/home.local/* ${HOME}.local/
sleep 0.5



sudo -H -u ${USER} qdbus $progress Set "" value 4
sudo -H -u ${USER} qdbus $progress setLabelText "Entferne icon cache ...."  #remove icon cache - otherwise some changes will not be visible
sudo rm /usr/share/icons/hicolor/icon-theme.cache  > /dev/null 2>&1  #hide errors
sudo rm /var/tmp/kdecache-${USER}/plasma_theme_default.kcache  > /dev/null 2>&1  #hide errors
sudo rm /var/tmp/kdecache-${USER}/icon-cache.kcache  > /dev/null 2>&1  #hide errors
sudo rm -r ${HOME}.cache  > /dev/null 2>&1  #hide errors
sleep 0.5



sudo -H -u ${USER} qdbus $progress Set "" value 5
sudo -H -u ${USER} qdbus $progress setLabelText "Deskop Konfiguration wiederhergestellt!
Starte Deskop neu!"
sleep 4
sudo -H -u ${USER} qdbus $progress close


sudo killall Xorg


