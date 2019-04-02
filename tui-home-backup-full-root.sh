#!/bin/bash
# last update: 28.11.2016
# this script would copy the home folder to /home/backup


echo "removing old backup"
sudo rm -r /home/backup 
echo "creating new backup"
sudo cp -R /home/lehrer /home/backup -v
