#!/bin/bash
# last updated: 26.06.2021
# locks the desktop widgets 


USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



if [ "$(id -u)" != "0" ]; then
    kdialog  --msgbox 'You need root privileges - Stopping program' --title 'Lock Desktop'
    exit 1
fi

if [ -f "/etc/kde5rc" ];then
    kdialog  --msgbox 'Desktop is already locked - Stopping program' --title 'Lock Desktop'
    sleep 2
    exit 1
fi





kdialog --warningcontinuecancel "Desktop Widgets sperren?" --title "Lock Desktop";
if [ "$?" = 0 ]; then
    sleep 0
	echo "locking desktop"
else
    exit 1 
fi;







## start progress with a lot of spaces (defines the width of the window - using geometry will move the window out of the center)
progress=$(sudo -H  -u ${USER} kdialog --progressbar "Sperre Desktop Widgets   ");
sudo -H  -u ${USER} qdbus $progress Set "" maximum 3
sleep 0.5




sudo -H  -u ${USER} qdbus $progress Set "" value 1
sudo -H  -u ${USER} qdbus $progress setLabelText "Sichere entsperrte Desktop Konfiguration ...."


cp -a ${HOME}.config/kglobalshortcutsrc ${BACKUPDIR}/lockdown/





#some preconfigured config files needed for a complete lockdown
sudo -H  -u ${USER} qdbus $progress Set "" value 2
sudo -H  -u ${USER} qdbus $progress setLabelText "Lade gesperrte Konfiguration ...."

sudo cp ${BACKUPDIR}/lockdown/kde5rc-LOCK /etc/kde5rc
cp -a ${BACKUPDIR}/lockdown/kglobalshortcutsrc-LOCK ${HOME}.config/kglobalshortcutsrc






sudo -H  -u ${USER} qdbus $progress Set "" value 3
sudo -H  -u ${USER} qdbus $progress setLabelText "Deskop gesperrt...
Starte Desktop neu!"
sleep 1
sudo -H -u ${USER}  qdbus $progress close


sudo killall plasmashell  
sleep 1
sudo -u ${USER} kwin_x11 --replace&
sudo -u ${USER} kstart5 plasmashell&
