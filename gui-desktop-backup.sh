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


## start progress with a lot of spaces (defines the width of the window - using geometry will move the window out of the center)
progress=$(kdialog --progressbar "Sichere Daten...                                                               ");
qdbus $progress Set "" maximum 5
sleep 0.5






qdbus $progress Set "" value 1
qdbus $progress setLabelText "Sichere kde.config ...."
mkdir ${BACKUPDIR}/kde.config/ > /dev/null 2>&1
#.kde/share/config/
rsync --exclude='*CacheStorage*' --exclude='*ScriptCache*' --exclude='*cache*'--exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.deb'  --exclude='*.old' --exclude='kdecache*' -avzh  --ignore-errors ${HOME}.kde/share/config/* ${BACKUPDIR}/kde.config/ --delete



qdbus $progress Set "" value 2
qdbus $progress setLabelText "Sichere .config ...."
mkdir ${BACKUPDIR}/home.config/ > /dev/null 2>&1
#.config
rsync --exclude='*/Application Cache/*' --exclude='*PepperFlash/*' --exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*CacheStorage*' --exclude='*ScriptCache*'  --exclude='*Cache*' --exclude='*cache*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.deb' --exclude='*.old' --exclude='kdecache*' -avzh  --ignore-errors ${HOME}.config/* ${BACKUPDIR}/home.config/ --delete



qdbus $progress Set "" value 3
qdbus $progress setLabelText "Sichere .local ...."
mkdir ${BACKUPDIR}/home.local/ > /dev/null 2>&1
#.local
rsync --exclude='*klipper/*' --exclude='*CacheStorage*' --exclude='*ScriptCache*' --exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*cache*' --exclude='*baloo/*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.old' --exclude='*.deb' --exclude='*.local/lib/' --exclude='kdecache*' -avzh --ignore-errors ${HOME}.local/* ${BACKUPDIR}/home.local/ --delete



qdbus $progress Set "" value 4
qdbus $progress setLabelText "Sichere entsperrte Desktop Konfiguration ...."


cp -a ${HOME}.config/kglobalshortcutsrc ${BACKUPDIR}/lockdown/


qdbus $progress Set "" value 5
qdbus $progress setLabelText "Deskop Konfiguration gesichert!"
sleep 4
qdbus $progress close




exit 0

