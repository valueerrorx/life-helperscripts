#!/bin/bash

USER=student
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"

## start progress with a lot of spaces (defines the width of the window - using geometry will move the window out of the center)
progress=$(kdialog --progressbar "Sichere Daten...                                                               ");
qdbus $progress Set "" maximum 5
sleep 0.5


qdbus $progress Set "" value 1
qdbus $progress setLabelText "Sichere kde.config ...."
mkdir ${BACKUPDIR}/kde.config/ > /dev/null 2>&1
#.kde/share/config/
rsync -avzh --exclude-from=/home/student/.life/applications/life-helperscripts/excludelist --delete-excluded --ignore-errors ${HOME}.kde/share/config/* ${BACKUPDIR}/kde.config/ --delete


qdbus $progress Set "" value 2
qdbus $progress setLabelText "Sichere .config ...."
mkdir ${BACKUPDIR}/home.config/ > /dev/null 2>&1
#.config
rsync -avzh --exclude-from=/home/student/.life/applications/life-helperscripts/excludelist --delete-excluded --ignore-errors ${HOME}.config/* ${BACKUPDIR}/home.config/ --delete


qdbus $progress Set "" value 3
qdbus $progress setLabelText "Sichere .local ...."
mkdir ${BACKUPDIR}/home.local/ > /dev/null 2>&1
#.local
rsync -avzh --exclude-from=/home/student/.life/applications/life-helperscripts/excludelist --delete-excluded --ignore-errors ${HOME}.local/* ${BACKUPDIR}/home.local/ --delete


qdbus $progress Set "" value 4
qdbus $progress setLabelText "Sichere entsperrte Desktop Konfiguration ...."


cp -a ${HOME}.config/kglobalshortcutsrc ${BACKUPDIR}/lockdown/

qdbus $progress Set "" value 5
qdbus $progress setLabelText "Deskop Konfiguration gesichert!"
sleep 4
qdbus $progress close




exit 0

