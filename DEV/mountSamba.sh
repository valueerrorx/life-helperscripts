#!/bin/bash

# mount the final ISO Build via Samba

FILE=/etc/samba/smb.conf


cat >> ${FILE} <<EOL

[LIFE]
  path = /home/lifebuilder/lifebuilder/
  browseable = yes
  read only = yes
  guest ok = yes
EOL
