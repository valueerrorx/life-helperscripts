#!/bin/bash


  
USER=$(logname)  
HOME="/home/${USER}/"

#
echo "Deleting all personal files (for public computers)"
#

MOUNTCHECK=$(df -h |grep Dokumente | wc -l) 

if test $MOUNTCHECK = "1" 
then
    echo "Skipping Folder Documents because a device is mounted there..."
else
    rm -r $HOME/Dokumente/*
fi
 
 
 

rm $HOME/*
rm $HOME/.local/share/RecentDocuments/*
rm $HOME/.kde/share/apps/RecentDocuments/*
rm $HOME/.xsession-errors

echo "clear clipboard history"
qdbus org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardHistory
qdbus org.kde.klipper /klipper org.kde.klipper.klipper.clearClipboardContents

history -c




#
echo "restoring previously saved desktop configuration"
#
exec $HOME/.life/applications/life-helperscripts/auto-desktop-restore-root.sh 

exit 0
