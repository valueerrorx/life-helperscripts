#!/bin/bash
# last updated: 28.11.2016
# UNlocks the desktop widgets 


USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



if [ "$(id -u)" != "0" ]; then
    kdialog  --msgbox 'You need root privileges - Stopping program' --title 'Unlock Desktop'
    exit 1
fi
  
  
if ! [ -f "/etc/kde5rc" ];then
    kdialog  --msgbox 'Desktop not locked - Stopping program' --title 'Unlock Desktop'
    exit 1
    
fi

  
  
kdialog --warningcontinuecancel "Desktop Widgets freigeben?" --title "Unlock Desktop";
if [ "$?" = 0 ]; then
    sleep 0
else
    exit 1 
fi;
  
  
 ## start progress with a lot of spaces (defines the width of the window - using geometry will move the window out of the center)
progress=$(sudo -H kdialog --progressbar "Desktop wird entsperrt...   ");
sudo -H qdbus $progress Set "" maximum 3
sleep 0.5 
  

# restore previous desktop config
sudo -H qdbus $progress Set "" value 1
sudo -H qdbus $progress setLabelText "Stelle entsperrte Konfigurationsdateien wieder her.... "
sleep 0.5


cp -a ${BACKUPDIR}/lockdown/kglobalshortcutsrc ${HOME}.config/



# change mount rights to execute
sudo -H qdbus $progress Set "" value 2
sudo -H qdbus $progress setLabelText "Entferne Sperrdateien...."
sleep 0.5


sudo rm /etc/kde5rc
sudo chmod +x /usr/bin/systemsettings5

sudo -H qdbus $progress Set "" value 3
sudo -H qdbus $progress setLabelText "Deskop freigegeben...
Starte Deskop neu!"
sleep 4
sudo -H qdbus $progress close


sudo killall Xorg




