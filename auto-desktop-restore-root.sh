#!/bin/bash
# last updated: 19.01.2020
# this file copies a backup of the .kde/share/config .config .local folder over the original

USER=$(logname)  
HOME="/home/${USER}/"
BACKUPDIR="${HOME}.life/systemrestore/"



echo "Stelle kde.config wieder her...."
#cp -Ra ${BACKUPDIR}/kde.config/* ${HOME}.kde/share/config/
rsync --exclude='*klipper/*' --exclude='*CacheStorage*' --exclude='*ScriptCache*' --exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*cache*' --exclude='*baloo/*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.old' --exclude='*.deb' --exclude='*.local/lib/' --exclude='kdecache*' -avzh --ignore-errors ${BACKUPDIR}/kde.config/* ${HOME}.kde/share/config/


echo "Stelle .config wieder her...."
#cp -Ra ${BACKUPDIR}/home.config/* ${HOME}.config/
rsync --exclude='*firststart*' --exclude='*klipper/*' --exclude='*CacheStorage*' --exclude='*ScriptCache*' --exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*cache*' --exclude='*baloo/*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.old' --exclude='*.deb' --exclude='*.local/lib/' --exclude='kdecache*' -avzh --ignore-errors ${BACKUPDIR}/home.config/* ${HOME}.config/


echo "Stelle .local wieder her...."
#cp -Ra ${BACKUPDIR}/home.local/* ${HOME}.local/
rsync --exclude='*klipper/*' --exclude='*CacheStorage*' --exclude='*ScriptCache*' --exclude='*Trash*' --exclude='*RecentDocuments*'  --exclude='*katesession*' --exclude='*cache*' --exclude='*baloo/*' --exclude='*.log*' --exclude='*~' --exclude='*.pid' --exclude='*.bak' --exclude='*.[0-9].gz' --exclude='*.old' --exclude='*.deb' --exclude='*.local/lib/' --exclude='kdecache*' -avzh --ignore-errors ${BACKUPDIR}/home.local/* ${HOME}.local/



echo "Entferne icon cache ...."  #remove icon cache - otherwise some changes will not be visible

# sudo rm /usr/share/icons/hicolor/icon-theme.cache  > /dev/null 2>&1  #hide errors
# sudo rm /var/tmp/kdecache-${USER}/plasma_theme_default.kcache  > /dev/null 2>&1  #hide errors
# sudo rm /var/tmp/kdecache-${USER}/icon-cache.kcache  > /dev/null 2>&1  #hide errors
rm -r ${HOME}.cache  > /dev/null 2>&1  #hide errors


echo "Deskop Konfiguration wiederhergestellt!"


exec ${HOME}.life/applications/life-helperscripts/softrestart-desktop.sh &

exit 0
