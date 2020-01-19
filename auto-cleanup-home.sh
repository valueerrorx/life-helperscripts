#!/bin/bash


  
USER=$(logname)  
HOME="/home/${USER}/"

#
echo "Deleting all personal files (for public computers)"
#


rm -r $HOME/Downloads/*
rm $HOME/*
rm $HOME/.local/share/RecentDocuments/*
rm $HOME/.kde/share/apps/RecentDocuments/*


#
echo "restoring previously saved desktop configuration"
#
exec $HOME/.life/applications/helperscripts/auto-desktop-restore-root.sh 

exit 0
