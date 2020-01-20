#!/bin/bash


  
USER=$(logname)  
HOME="/home/${USER}/"

#
echo "Deleting all personal files (for public computers)"
#

MOUNTCHECK=$(df -h |grep Downloads | wc -l) 
if test $FSTABCHECK = "1" 
then
    echo "Skipping Downloads because of mounted device"
else
    rm -r $HOME/Downloads/*
fi
 
 
 

rm $HOME/*
rm $HOME/.local/share/RecentDocuments/*
rm $HOME/.kde/share/apps/RecentDocuments/*


#
echo "restoring previously saved desktop configuration"
#
exec $HOME/.life/applications/helperscripts/auto-desktop-restore-root.sh 

exit 0
