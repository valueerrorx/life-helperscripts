#!/bin/bash
# last update: 20.02.2020
# this file uses xrandr to setup the beamer to be a clone of the lcd screen
# and kdialog for userinteraction

PRIMARY=""
BEAMER=""
SECONDARY=""


####################################
## GET DISPLAY IDENTIFIERS        ##
####################################
getDisplays() {

    PRIMARY=$(xrandr | grep -h "\sconnected" | grep primary| awk '{print $1}')  #if no primary display was configured EVER this will fail
    OTHERDISPLAYS=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}')   #this could potentially deliver more than one line
 
    ## COUNT DISPLAYS 
    NUMBEROFSECONDARYDISPLAYS=$(xrandr | grep -h "\sconnected" | grep -v primary|awk '{print $1}'|wc -l)
    PRIMARYDISPLAYS=$(xrandr | grep -h "\sconnected" | grep primary|awk '{print $1}'|wc -l)

    ## CONVERT string to array
    readarray -t DISPLAYS <<<"$OTHERDISPLAYS"
}
getDisplays





askprimary() {
    # ask user which one is the primary display
    choice=$(kdialog --title "Displaysetup" --combobox "Bitte wählen sie die den Hauptbildschirm" "${DISPLAYS[0]}" "${DISPLAYS[1]}" "${DISPLAYS[2]}" --default "${DISPLAYS[0]}");

    if [ "$?" = 0 ]; then
        if [ "$choice" = ${DISPLAYS[0]} ]; then
            PRIMARY=${DISPLAYS[0]}
            
        elif [ "$choice" = ${DISPLAYS[1]} ]; then
            PRIMARY=${DISPLAYS[1]}
          
        elif [ "$choice" = ${DISPLAYS[2]} ]; then
            PRIMARY=${DISPLAYS[2]}
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
    echo "This should be your primary screen: ${PRIMARY}"
    echo ""
    xrandr --output $PRIMARY --primary
    getDisplays
}



## NO SECONDARY DISPLAY 
if [[ ( $NUMBEROFSECONDARYDISPLAYS = "0" ) ]];
then
    echo "no secondary display found"
    kdialog  --error 'Kein zweiter Bildschirm gefunden! Überprüfen sie die Steckverbindung.' --title 'Displaysetup'
    exit 0
fi


kdialog  --warningcontinuecancel '
Automatische Displaykonfiguration
 
Falls dieser Vorgang fehlschlägt versuchen sie bitte Folgendes:
 
Überprüfen sie die Steckverbindungen zwischen Projektor und PC.
Überprüfen sie den Eingangskanal am Projektor!
Starten sie notfalls den PC neu.
 
' --title 'Displaysetup'

if [ "$?" = 0 ]; then
    sleep 0
else
    exit 0 
fi;



## NO DISPLAY DECLARED AS PRIMARY
if [[ ( $PRIMARYDISPLAYS = "0" ) && $NUMBEROFSECONDARYDISPLAYS = "3" ]];
then
    echo "no primary display found"
    askprimary
  
fi



askbeamer() {
    # ask user which one is the beamer
    choice=$(kdialog --title "Displaysetup" --combobox "Bitte wählen sie die den Projektor" "${DISPLAYS[0]}" "${DISPLAYS[1]}" --default "${DISPLAYS[0]}");

    if [ "$?" = 0 ]; then
        if [ "$choice" = ${DISPLAYS[0]} ]; then
            BEAMER=${DISPLAYS[0]}
            SECONDARY=${DISPLAYS[1]}
        elif [ "$choice" = ${DISPLAYS[1]} ]; then
            BEAMER=${DISPLAYS[1]}
            SECONDARY=${DISPLAYS[0]}
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
    echo "This should be your primary screen: ${PRIMARY}"
    echo "This should be your secondary screen: ${SECONDARY} "
    echo "This should be your Beamer: ${BEAMER}"
    echo ""
}









####################################
## FIND BIGGEST COMMON RESOLUTION ##
####################################

DISPLAYCOUNT=$(xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|head -n 1|awk '{print $1}')
RESOLUTION=`xrandr --query | awk '/^ *[0-9]*x[0-9]*/{ print $1 }' | sort -n | uniq -d -c|grep -w ${DISPLAYCOUNT} |tail -1|awk '{print $2}'`

# if something went wrong default to 1024x768
COMMON=$( echo $RESOLUTION | grep x | wc -l )    # check for the x in 800x600
if [ $COMMON == "0" ];
then
    echo "No common resolution found! Using default resolution."
    RESOLUTION="1024x768"
fi

echo "BIGGEST COMMON RESOLUTION IS SET TO: $RESOLUTION "
echo ""





####################################
## MANAGE TRANSFORM               ##
####################################

#catch the 2 most common cases where blackbars are necessary..  for laptop (internal displays) this is not necessary (--set 'scaling mode' Center is taking care of it)
# 16:9 to 4:3 scaling
# only if the primary screen has a 16:9 screenres and the final res is 4:3

PRIMARYSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 $PRIMARY |tail -1)

if [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1280"*) ]]; then
    TRANSFORM="--transform 1.1109375,0,0,0,1,0,0,0,1"    # this would scale the output on a 16:9 screen and display a 4:3 with black bar instead of stretching it
elif [[ ( $PRIMARYSCREENRES == *"1920"*) &&  ( $RESOLUTION == *"1024"*) ]]; then
    TRANSFORM="--transform 1.3330078125,0,0,0,1,0,0,0,1"  
else
    TRANSFORM=""
fi
 
#transform auf skylake killt kwin irgendwie und funktioniert nur für plasmashell - fenster bleiben über den ganzen screen BUG 
#daher kann die transform option hier deaktiviert werdem (uncomment next line)

TRANSFORM=""






####################################
## SETUP                          ##
####################################

 
## 1 SECONDARY DISPLAY
if [[ ( $NUMBEROFSECONDARYDISPLAYS = "1" ) ]];  #2 Ausgabegeräte
then  
    SECONDARY=$OTHERDISPLAYS   #there is just one other identifier 
    
    echo "This should be your primary screen: ${PRIMARY}"
    echo "This should be your secondary screen ${SECONDARY}"
    echo ""
    
    if [[ ( $PRIMARY == *"eDP"*) ||  ( $PRIMARY == *"LVDS"*) ]]; then
        echo "Embedded Display found"
        
        COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION  --rate 60.00 --primary --output $SECONDARY --mode $RESOLUTION --same-as $PRIMARY"
        echo "Executing: ${COMMAND}"
        echo ""
        ${COMMAND}
    else
        COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION  --rate 60.00 --primary $TRANSFORM --output $SECONDARY --mode $RESOLUTION --same-as $PRIMARY"
        echo "Executing: ${COMMAND}"
        echo ""
        ${COMMAND}
    fi
    
## 2 SECONDARY DISPLAYS
elif [[ ( $NUMBEROFSECONDARYDISPLAYS = "2" ) ]];  #3 Ausgabegeräte
then
      
   # ask user for the preferred setup (clone, extend)
    choice=$(kdialog --title "Displaysetup" --combobox "3 Ausgabegeräte gefunden! Bitte wählen sie die bevorzugte Einstellung" "Klonen" "Klonen + Erweitern rechts" "Klonen + Erweitern links" --default "Klonen");

    if [ "$?" = 0 ]; then
        if [ "$choice" = 'Klonen' ]; then
        
            BEAMER=${DISPLAYS[0]}
            SECONDARY=${DISPLAYS[1]}
    
            echo "Initialising: clone"
            echo ""
            
            if [[ ( $PRIMARY == *"eDP"*) ||  ( $PRIMARY == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --rate 60.00 --primary --output ${BEAMER} --mode $RESOLUTION --rate 60.00 --same-as $PRIMARY --output ${SECONDARY} --mode $RESOLUTION --same-as $PRIMARY"
            else
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --rate 60.00 --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --rate 60.00 --same-as $PRIMARY --output ${SECONDARY} --mode $RESOLUTION --same-as $PRIMARY"
            fi
            
            echo "Executing: ${COMMAND}"
            echo ""
            ${COMMAND}
            exit 0
            
        elif [ "$choice" = 'Klonen + Erweitern rechts' ]; then
            askbeamer
        
            echo "Initialising: clone + extend right"
            echo ""
            
            SECONDARYSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 ${SECONDARY}|tail -1)
            echo "Biggest resolution for secondary screen: $SECONDARYSCREENRES"
            
            if [[ ( $PRIMARY == *"eDP"*) ||  ( $PRIMARY == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --primary --output ${BEAMER} --mode $RESOLUTION --same-as $PRIMARY --output ${SECONDARY} --mode $SECONDARYSCREENRES --right-of $PRIMARY"
            else
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --same-as $PRIMARY --output ${SECONDARY} --mode $SECONDARYSCREENRES --right-of $PRIMARY"
            fi
            
            echo "Executing: ${COMMAND}"
            echo ""
            ${COMMAND}
            exit 0
            
        elif [ "$choice" = 'Klonen + Erweitern links' ]; then
            askbeamer
        
        
            echo "Initialising: clone + extend left"
            echo ""
             
            SECONDARYSCREENRES=$(xrandr --query | awk '{ print $1 }' | grep -A 1 ${SECONDARY}|tail -1)
            echo "Biggest resolution for secondary screen: $SECONDARYSCREENRES"
            
            if [[ ( $PRIMARY == *"eDP"*) ||  ( $PRIMARY == *"LVDS"*) ]]; then
                echo "Embedded Display found"
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --primary --output ${BEAMER} --mode $RESOLUTION --same-as $PRIMARY --output ${SECONDARY} --mode $SECONDARYSCREENRES --left-of $PRIMARY"
            else
                COMMAND="xrandr --output $PRIMARY --mode $RESOLUTION --primary $TRANSFORM --output ${BEAMER} --mode $RESOLUTION --same-as $PRIMARY --output ${SECONDARY} --mode $SECONDARYSCREENRES --left-of $PRIMARY"
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
    echo "Primary: $PRIMARY"
    echo "Others : $OTHERDISPLAYS"
    echo "Schools don't use this kind of setup :-)"
    exit 0
fi








exit 0


