#!/bin/bash
# figures out if backlight is intel and creates an xorg configuration for that device


if [ "$(id -u)" != "0" ]; then
    echo "You need root privileges - Stopping program"
    exit 1
fi


ISINTEL=$(ls /sys/class/backlight/ | grep intel | wc -l )


if [ $ISINTEL == "1" ];
then
    echo "Creating Xorg Configuraion for Intel Backlight"
    
    echo '
Section "Device"
    Identifier  "Intel Graphics" 
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
EndSection

' > /etc/X11/xorg.conf.d/20-intel.conf
  
else
    rm /etc/X11/xorg.conf.d/20-intel.conf
fi

