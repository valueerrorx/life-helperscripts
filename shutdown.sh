#!/bin/bash
export DISPLAY=:0
Status=$(xset -q|grep Monitor|cut -d " " -f 5)
if [ $Status == "On" ]; then
	zenity --question --text="Shutdown steht an. NEIN um ihn abzubrechen" --timeout=30 2>/dev/null
	if [ $? -ne 1 ]; then
		sudo /sbin/shutdown -h now
	fi
fi
if [ $Status == "Off" ]; then
	zenity --question --text="Shutdown steht an. NEIN um ihn abzubrechen" --timeout=30 2>/dev/null
	if [ $? -ne 1 ]; then
		sudo /sbin/shutdown -h now
	fi
fi
