#!/bin/bash
# last update: 17.02.2020
# this file uses xrandr to setup the beamer to be a clone of the lcd screen
# and kdialog for userinteraction

PRIMARY=""
BEAMER=""
SECONDMONITOR=""




askbeamer() {
    # ask user which one is the beamer
    choice=$(kdialog --title "Displaysetup" --combobox "Bitte wählen sie die den Projektor" "${DISPLAYS[0]}" "${DISPLAYS[1]}" --default "${DISPLAYS[0]}");

    if [ "$?" = 0 ]; then
        if [ "$choice" = ${DISPLAYS[0]} ]; then
            BEAMER=${DISPLAYS[0]}
            SECONDMONITOR=${DISPLAYS[1]}
        elif [ "$choice" = ${DISPLAYS[1]} ]; then
            BEAMER=${DISPLAYS[1]}
            SECONDMONITOR=${DISPLAYS[0]}
        else
            kdialog --error "ERROR";
            exit 0
        fi;
    elif [ "$?" = 1 ]; then
        exit 0
    else
        kdialog --error "ERROR";
        exit 0
    fi;
    echo "This should be your primary screen: ${DISPLAY1}"
    echo "This should be your secondary screen: ${SECONDMONITOR} "
    echo "This should be your Beamer: ${BEAMER}"
    echo ""
}




kdialog  --warningcontinuecancel '
Automatische Displaykonfiguration
 
Falls dieser Vorgang fehlschlägt versuchen sie bitte Folgendes:
 
Überprüfen sie die Steckverbindungen zwischen Projektor und PC.
Überprüfen sie den Eingangskanal am Projektor!
Starten sie notfalls den PC neu.
 
' --title 'Beamer Setup'

if [ "$?" = 0 ]; then
    sleep 0
else
    exit 0 
fi;




####################################
## FIND BIGGEST COMMON RESOLUTION ##
####################################

DISPLAYCOUNT=$(xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|head -n 1|awk '{print $1}')

if [[ ( $DISPLAYCOUNT = "" ) ]];
then
    RESOLUTION=`xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c`
else
    RESOLUTION=`xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|grep -w ${DISPLAYCOUNT} |tail -1|awk '{print $2}'`
fi



# if something went wrong default to 1024x768
COMMON=$( echo $RESOLUTION | grep x | wc -l )    # check for the x in 800x600
if [ $COMMON == "0" ];
then
    echo "No common resolution found! Using default resolution."
    RESOLUTION="1024x768"
fi

echo "BIGGEST COMMON RESOLUTION: $RESOLUTION "
echo ""






####################################
## GET DISPLAY IDENTIFIERS        ##
####################################

DISPLAY1=$(xrandr | grep -h "\sconnected" | grep primary| awk '{print $1}')
DISPLAY2=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}')   #this could potentially deliver more than one line




####################################
## MANAGE TRANSFORM               ##
####################################

#catch the 2 most common cases where blackbars are necessary..  for laptop (internal displays) this is not necessary (--set 'scaling mode' Center is taking care of it)
# 16:9 to 4:3 scaling
# only if the primary screen has a 16:9 screenres and the final res is 4:3

PRIMARYSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 $DISPLAY1 |tail -1)

if [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1280"*) ]]; then
    TRANSFORM="--transform 1.1109375,0,0,0,1,0,0,0,1"    # this would scale the output on a 16:9 screen and display a 4:3 with black bar instead of stretching it
elif [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1024"*) ]]; then
    TRANSFORM="--transform 1.3330078125,0,0,0,1,0,0,0,1"  
else
    TRANSFORM=""
fi
 
#transform auf skylake killt kwin irgendwie und funktioniert nur für plasmashell - fenster bleiben über den ganzen screen BUG 
#daher kann die transform option hier deaktiviert werdem (uncomment next line)

#TRANSFORM=""




####################################
## COUNT EXTERNAL DISPLAYS        ##
####################################

LINES=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}'|wc -l)




####################################
## SETUP                          ##
####################################


## NO SECONDARY DISPLAY 
if [[ ( $DISPLAY2 = "" ) ]];
then
    echo "no secondary display found"
    kdialog  --error 'Kein zweiter Bildschirm gefunden! Überprüfen sie die Steckverbindung.' --title 'Displaysetup'
    exit 0
 
 
## 1 SECONDARY DISPLAY
elif [[ ( $LINES = "1" ) ]];  #2 Ausgabegeräte
then  
    echo "This should be your primary screen: ${DISPLAY1}"
    echo "This should be your secondary screen ${DISPLAY2}"
    echo ""
    
    if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
        echo "Embedded Display found"
        
        COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1"
        echo "Executing: ${COMMAND}"
        echo ""
        ${COMMAND}
    else
        COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output $DISPLAY2 --mode $RESOLUTION --same-as $DISPLAY1 &"
        echo "Executing: ${COMMAND}"
        echo ""
        ${COMMAND}
    fi
    
## 2 SECONDARY DISPLAYS
elif [[ ( $LINES = "2" ) ]];  #3 Ausgabegeräte
then
    # convert string to array
    readarray -t DISPLAYS <<<"$DISPLAY2"
    
   # ask user for the preferred setup (clone, extend)
    choice=$(kdialog --title "Displaysetup" --combobox "3 Ausgabegeräte gefunden! Bitte wählen sie die bevorzugte Einstellung" "Klonen" "Klonen + Erweitern rechts" "Klonen + Erweitern links" --default "Klonen");

    if [ "$?" = 0 ]; then
        if [ "$choice" = 'Klonen' ]; then
        
            BEAMER=${DISPLAYS[0]}
            SECONDMONITOR=${DISPLAYS[1]}
    
            echo "Initialising: clone"
            echo ""
            
            if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $RESOLUTION --same-as $DISPLAY1"
            else
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $RESOLUTION --same-as $DISPLAY1"
            fi
            
            echo "Executing: ${COMMAND}"
            echo ""
            ${COMMAND}
            exit 0
            
        elif [ "$choice" = 'Klonen + Erweitern rechts' ]; then
            askbeamer
        
            echo "Initialising: clone + extend right"
            echo ""
            
            EXTSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 ${DISPLAYS[1]}|tail -1)
            echo "Biggest resolution for secondary screen: $EXTSCREENRES"
            
            if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $EXTSCREENRES --right-of $DISPLAY1"
            else
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $EXTSCREENRES --right-of $DISPLAY1"
            fi
            
            echo "Executing: ${COMMAND}"
            echo ""
            ${COMMAND}
            exit 0
            
        elif [ "$choice" = 'Klonen + Erweitern links' ]; then
            askbeamer
        
        
            echo "Initialising: clone + extend left"
            echo ""
             
            EXTSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 ${DISPLAYS[1]}|tail -1)
            echo "Biggest resolution for secondary screen: $EXTSCREENRES"
            
            if [[ ( $DISPLAY1 == *"eDP"*) ||  ( $DISPLAY1 == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary --set 'scaling mode' Center --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $EXTSCREENRES --left-of $DISPLAY1"
            else
                COMMAND="xrandr --output $DISPLAY1 --mode $RESOLUTION --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --same-as $DISPLAY1 --output ${SECONDMONITOR} --mode $EXTSCREENRES --left-of $DISPLAY1"
            fi
            
            echo "Executing: ${COMMAND}"
            echo ""
            ${COMMAND}
            exit 0
            
        else
            kdialog --error "ERROR";
            exit 0
        fi;
    elif [ "$?" = 1 ]; then
        exit 0
    else
        kdialog --error "ERROR";
        exit 0
    fi;
        
    
else  # ????
    echo "Schools don't use this kind of setup :-)"
    exit 0
fi








exit 0


