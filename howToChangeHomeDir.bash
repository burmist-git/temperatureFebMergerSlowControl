#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2019 - LBS - (Single person developer.)                 #
# Wed Mar 13 11:40:25 CET 2019                                         #
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
    echo " [0] -d   : default"
    echo " [0] -p2  : second parameter"

}

function printWhereToChange {

    echo "   1 : Makefile "
    echo "   2 : convertFebTemp_main_crontab.bash"
    echo "        - thisroot.sh"
    echo "        - sourceHome"
    echo "        - rawDataFolder"
    echo "   3 : convertMergerTemp_main_crontab.bash"
    echo "        - thisroot.sh"
    echo "        - sourceHome"
    echo "        - rawDataFolder"
    echo "   4 : runanaGL840_main_crontab.bash"
    echo "        - thisroot.sh"
    echo "        - sourceHome"
    echo "        - rawDataFolder"
    
}

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        
	printWhereToChange
	
    elif [ "$1" = "-p2" ]; then
	
	echo " $1 "
	
    else
        
        printHelp
            
    fi
   
fi
