#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Sun Feb 24 20:28:44 CET 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                                                                      #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function printHelp {

    $sourceHome/cleanAndCompressRawData.bash -h
    
}

screenName="tempCleSL"
sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
#sourceHome="/home/burmist/temperaturefebmergerslowcontrol/"
#The following command works for screen version 4.06.02
#screenLogFile="/home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.screen.bash.log"

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        
	if [ $# -eq 2 ]
        then   

	    inDataFolder=$2
	    screen -S $screenName -L -d -m $sourceHome/cleanAndCompressRawData.bash -d $inDataFolder

        elif [ $# -eq 1 ]; then

	    #screen -S $screenName -L -Logfile $screenLogFile -d -m $sourceHome/cleanAndCompressRawData.bash -d
	    screen -S $screenName -L -d -m $sourceHome/cleanAndCompressRawData.bash -d

        else
            printHelp
        fi
        
    elif [ "$1" = "-p2" ]; then
	
	echo " $1 "

    elif [ "$1" = "-screenlog" ]; then
	
	screen -S $screenName -L -d -m $sourceHome/cleanAndCompressRawData.bash -screenlog
	
    else
        
        printHelp
            
    fi
   
fi
