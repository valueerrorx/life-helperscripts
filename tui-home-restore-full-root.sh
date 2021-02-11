#!/bin/bash
# last update: 28.11.2016
# this would remove the home folder and replace it with a backup (if any)


if [ -d /home/backup ];
then
    echo "Warning..  only ctrl+c can help you now! Press Enter to continue..."
    read ENTER
    sudo mv /home/student /home/trashhome
    sudo mv /home/backup /home/student
    sudo rm -r /home/trashhome
    sudo cp -R /home/student /home/backup -v

    echo "restarting desktop...."
    sudo killall Xorg


else
    echo "There is no Backup to restore... sorry!"

fi



