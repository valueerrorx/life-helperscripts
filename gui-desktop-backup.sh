#!/bin/bash
# last updated: 18.08.2018

# this file copies the files of the .kde/share/config .config and .local folder to a backup location

USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



if [ -f "/etc/kde5rc" ];then
    kdialog  --msgbox 'Desktop is locked - Stopping program' --title 'Backup'
    sleep 2
    exit 0
fi



kdialog --warningcontinuecancel "Aktuelle Desktop Konfiguration sichern?" --title "Backup";
if [ "$?" = 0 ]; then
    sleep 0
else
    exit 0 
fi;


## start the progress
exec ~/.life/applications/life-helperscripts/desktop-backup.sh
