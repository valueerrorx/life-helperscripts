#!/bin/bash
# last updated: 28.11.2016
# finds big files 

echo "Searching for files bigger than 40MB"

sudo find / -size +20000k -exec ls -lh {} \;
