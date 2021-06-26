#!/bin/bash
# last updated: 25.09.20
# UNlocks the systemsettings5 application


USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



if [ "$(id -u)" != "0" ]; then
    kdialog  --msgbox 'You need root privileges - Stopping program' --title 'Unlock Systemsettings'
    exit 1
fi
  
  

  
  
kdialog --warningcontinuecancel "Systemsettings freigeben/sperren?" --title "Unlock Systemsettings";
if [ "$?" = 0 ]; then
    sleep 0
else
    exit 1 
fi;
  
  
ISLOCKED=$( ls -l /usr/bin/systemsettings5  |grep x| wc -l) 
  
   if test $ISLOCKED = "0" 
    then 
        echo "unlocking systemsettings"
        sudo chmod +x /usr/bin/systemsettings5
    else
        echo "locking systemsettings"
        sudo chmod -x /usr/bin/systemsettings5
    fi


## FIXME We could lock kcmshell5 too.. 





