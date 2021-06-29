 #!/bin/bash
# last updated: 26.06.2021
# restarts applications and deskop without killing X (which doesnt work reliable anymore)



USER=$(logname)  
HOME="/home/${USER}/"





function killRunningApps(){
        # kill desktop environment
        pkill -f  plasmashell  
    #   pkill -f  kwin_x11

        # kill all user applications !FIXME this has to be dynamic !
        #pkill -f dolphin
        pkill -f calligrasheets
        pkill -f calligrawords
        #pkill -f kate
        pkill -f konsole
        pkill -f geogebra
        pkill -f firefox
        pkill -f systemsettings5
        pkill -f gwenview
        pkill -f spectacle
        pkill -f vlc
        pkill -f google 
        pkill -f kcalc
        pkill -f okular
    

}



killRunningApps

sudo -u ${USER} kstart5 plasmashell      
sudo -u ${USER} kwin_x11 --replace

