#!/bin/bash

pulseaudio -k 
sleep 1
pactl load-module module-detect
#pacmd unload-module module-udev-detect && pacmd load-module module-udev-detect
