#!/bin/bash

cd ~/.config/google-chrome/

sed -i 's/"exit_type": ".*"/"exit_type": "Normal","default_content_setting_values": { "cookies": 4 }/g' Preferences
