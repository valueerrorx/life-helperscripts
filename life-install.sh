#!/bin/bash
#deactivate networking before running ubiquity otherwise it will download apt sources and recreate xapian index which takes forever 
# we start ubiquity with the automatic parameter to make it respect the preseed file custom.seed on the live media
# 


nmcli n off
ubiquity kde_ui --automatic
nmcli n on
pkxexec ~/.life/applications/helperscripts/efitest.sh 

exit 0
