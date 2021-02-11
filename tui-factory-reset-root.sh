#!/bin/bash



if [ "$(id -u)" != "0" ]; then
    echo "Sorry, you are not root."
    sleep 2
    exit 1
fi


echo "WARNING !!"
echo "if you run this script in persistent mode"
echo "it will kill the entire running operating system"
echo "it will delete everything stored on casper-rw during runtime"
echo ""
echo "this will reset the flashdrive to it's initial state and leave"
echo "a clean, unchanged version of LIFE"
echo "to make it work you will have to boot into live mode or"
echo "use the acpi emergency shutdown procedure if you ran it in persistent mode"
echo ""
echo "Are you sure you want to do this?"
echo "Press Enter to continue..."
read ENTER
echo "Are you absoulutely sure you know what you are doing?"
echo "Press Enter to continue..."
read ENTER
echo ""
echo "OK.. if you say so..    cleaning up..."

sudo mkdir /media/factoryreset
sudo mount -L casper-rw /media/factoryreset
sudo rm -r /media/factoryreset >/dev/null 2>&1 

echo "all done.. "
echo "reboot or press the power button of your computer for more than 5 seconds !"
read ENTER


