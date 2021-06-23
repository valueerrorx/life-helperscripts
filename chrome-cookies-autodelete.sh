#!/bin/bash

cd ~/.config/google-chrome/Default

cat Preferences | jq . > Preferences1

sleep 1

sed -i 's/"exit_type": "Crashed"/"exit_type": "Normal"/g' Preferences1 

sed -i 's/"exit_type": "Normal"/"exit_type": "Normal","default_content_setting_values": { "cookies": 4 }/g' Preferences1

cat Preferences1 > Preferences
