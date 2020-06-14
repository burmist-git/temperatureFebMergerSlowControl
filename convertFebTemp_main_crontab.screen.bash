#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Fri Nov 23 12:17:49 JST 2018                                         #
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

    echo " --> ERROR in input arguments "
    echo " [0] -d        : default"
    echo " [1]           : name of the folder to convert"
    echo " [0] -fromArch : from archive"
    echo " [1]           : name of the tar.gz archive"
    echo " [0] -p2       : second parameter"

}

screenName="tempfebSL"
#The following command works for screen version 4.06.02
#screenLogFile="/home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.screen.bash.log"

if [ $# -eq 0 ]; then
    printHelp
else
    if [ "$1" = "-d" ]; then
	if [ $# -eq 2 ]; then   
	    inDataFolder=$2
	    screen -S $screenName -L -d -m /home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.bash -d $inDataFolder
        elif [ $# -eq 1 ]; then
	    #screen -S $screenName -L -Logfile $screenLogFile -d -m /home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.bash -d
	    screen -S $screenName -L -d -m /home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.bash -d
        else
            printHelp
        fi
    elif [ "$1" = "-fromArch" ]; then
	if [ $# -eq 2 ]; then   
	    in_tar_gz=$2
	    /home/hvala/temperaturefebmergerslowcontrol/cleanAndCompressRawData.bash -unpack $in_tar_gz
	    inDataFolder=${in_tar_gz::-7}
	    echo "inDataFolder $inDataFolder"
	    screen -S $screenName -L -d -m /home/hvala/temperaturefebmergerslowcontrol/convertFebTemp_main_crontab.bash -d $inDataFolder
        else
            printHelp
        fi
    elif [ "$1" = "-p2" ]; then
	echo " $1 "
        printHelp
    else
        printHelp
    fi
    
fi
