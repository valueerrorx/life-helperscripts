#!/bin/bash
# last update: 08.03.2017
# this file uses xrandr to setup the beamer to be a clone of the lcd screen
# to make this possible the lcd resolution is set to 1024x768 (the most common beamer resolution in the classrooms)
# this script is used only in case of emergency where the output is not activated properly or someone tempered with the display configs




kdialog  --warningcontinuecancel '
Automatische Displaykonfiguration
 
Falls dieser Vorgang fehlschlägt versuchen sie bitte Folgendes:
 
Überprüfen sie die Steckverbindungen zwischen Projektor und PC.
Überprüfen sie den Eingangskanal am Projektor!
Starten sie notfalls den PC neu.
Beschuldigen sie den IT Experten ihres Vertrauens.
 
' --title 'Beamer Setup'

if [ "$?" = 0 ]; then
    sleep 0
else
    exit 0 
fi;

#find biggest common resolution
RESOLUTION=`xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|grep -w $(xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|head -n 1|awk '{print $1}')|tail -1|awk '{print $2}'`



COMMON=$( echo $RESOLUTION | grep x | wc -l )    # check for the x in 800x600


if [ $COMMON == "0" ];
then
    echo "No common resolution found! Using default resolution."
    RESOLUTION="1024x768"
fi



DISPLAY1=$(xrandr | grep -h "\sconnected" | grep primary| awk '{print $1}')
DISPLAY2=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}')


PRIMARYSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 $DISPLAY1)

echo "COMMON RESOLUTION: $RESOLUTION "
echo "BIGGEST RESOLUTION: $PRIMARYSCREENRES"
echo ""
echo ""

LINES=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}'|wc -l)


echo "This should be your primary screen"
echo $DISPLAY1
echo ""


#catch the 2 most common cases where blackbars are necessary..  for laptop (internal displays) this is not necessary (--set 'scaling mode' Center is taking care of it)
# 16:9 to 4:3 scaling
# only if the primary screen has a 16:9 screenres and the final res is 4:3

if [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1280"*) ]]; then
    TRANSFORM="--transform 1.1109375,0,0,0,1,0,0,0,1"    # this would scale the output on a 16:9 screen and display a 4:3 with black bar instead of stretching it
elif [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1024"*) ]]; then
    TRANSFORM="--transform 1.3330078125,0,0,0,1,0,0,0,1"  
else
    TRANSFORM=""
fi
 
#transform auf skylake killt kwin irgendwie und funktioniert nur für plasmashell - fenster bleiben über den ganzen screen BUG 
#daher ist die transform option derzeit deaktiviert
###############
TRANSFORM=""
###############


if [[ ( $DISPLAY2 = "" ) ]];
then
    echo "no secondary display found"
    kdialog  --error 'Kein zweiter Bildschirm gefunden! Überprüfen sie die Steckverbindung.' --title 'Beamer Setup'
    exit 0
elif [[ ( $LINES = "2" ) ]];
then

    readarray -t DISPLAYS <<<"$DISPLAY2"
    echo "This should be your secondary screen"
    echo ${DISPLAYS[0]}
    echo "This should be your third screen"
    echo ${DISPLAYS[1]}
    echo ""
    echo ""
   
    
    if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
        echo "Embedded Display found"
        echo ""
        echo "exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output ${DISPLAYS[0]} --mode $RESOLUTION --same-as $DISPLAY1 --output ${DISPLAYS[1]} --mode $RESOLUTION --same-as $DISPLAY1 &"
        exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output ${DISPLAYS[0]} --mode $RESOLUTION --same-as $DISPLAY1 --output ${DISPLAYS[1]} --mode $RESOLUTION --same-as $DISPLAY1 &
    else
        echo "All External Displays 1,2,3 "
        echo ""
        echo "exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output ${DISPLAYS[0]} --mode $RESOLUTION --same-as $DISPLAY1 --output ${DISPLAYS[1]} --mode $RESOLUTION --same-as $DISPLAY1 &"
        exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output ${DISPLAYS[0]} --mode $RESOLUTION --same-as $DISPLAY1 --output ${DISPLAYS[1]} --mode $RESOLUTION --same-as $DISPLAY1 &
       
        #private setting
        #exec xrandr --output $DISPLAY1 --mode 1280x800 --primary $TRANSFORM --output ${DISPLAYS[0]} --mode 1280x800 --same-as $DISPLAY1 --output ${DISPLAYS[1]} --mode 1920x1080 --right-of $DISPLAY1 &

    fi
else
    echo "This should be your secondary screen"
    echo $DISPLAY2
    echo ""
    echo ""
    
    
    if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
        echo "Embedded Display found"
        echo ""
        echo "exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1 &"
        exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1 &
    else
        echo ""
        echo "exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1 &"
        echo "All External Displays 1,2"
        exec xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1 &
    fi
    
    
    

fi







#current plasmashell 5.11 leaves some unrendered pixels at the bottom after running randr (dirty workaround)
# PLASMASHELL=$(ps caux| grep plasmashell|wc -l)
# if [[ ( $PLASMASHELL = "1" ) ]];
# then
#     exec kquitapp5 plasmashell &
#     exec kstart5 plasmashell &
# fi
#     




exit 0


