#!/bin/bash
# last updated: 28.11.2016


USER=$(logname)  
HOME="/home/${USER}/"

#
# echo "Deleting all personal files (for public computers)"
#



kdialog --title "Cleanup" \
--warningcontinuecancel "Möchten sie wirklich alle sichtbaren Dateien aus ihrem persönlichen Ordner sowie aus Downloads/Dokumente löschen? \n
$HOME
$HOME/Downloads/"




if [ "$?" = 0 ]; then
    rm -r $HOME/Downloads/*
    rm -r $HOME/Dokumente/*
    rm $HOME/*
    rm $HOME/.local/share/RecentDocuments/*
    rm $HOME/.kde/share/apps/RecentDocuments/*

    kdialog --caption "Cleanup" --title "Cleanup" --msgbox "Alle Dateien entfernt!";
    exit 0
else
   
    exit 0
fi;


