#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Sun Nov 25 22:51:33 JST 2018                                         #
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
    echo " [0] -d   : default                     --> send email to burmist@bdaq.daqnet.kek.jp"
    echo " [0] -d   : default with two parameters --> send email to : burmist@bdaq.daqnet.kek.jp"
    echo "                                                            rok@bdaq.daqnet.kek.jp"
    echo "                                                            korpar@bdaq.daqnet.kek.jp"
    echo " [1]      : name of the file to attach"
    echo " [2]      : arichstatus ex : (temperature, TimeSynchronisation) email only to : burmist@bdaq.daqnet.kek.jp"
    echo " [0] -p2  : second parameter"

}

#hvala@arichsc
sourceHome='/home/usr/hvala/burmist_sent_email/'

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        
	if [ $# -eq 2 ]
        then   

	    arichstatus="temperature"
	    echo "ARICH status : $arichstatus" | mailx -a $sourceHome$2 -s "ARICH status $arichstatus" burmist@bdaq.daqnet.kek.jp
	    sleep 10
            echo "ARICH status : $arichstatus" | mailx -a $sourceHome$2 -s "ARICH status $arichstatus" rok@bdaq.daqnet.kek.jp
            sleep 10
            echo "ARICH status : $arichstatus" | mailx -a $sourceHome$2 -s "ARICH status $arichstatus" korpar@bdaq.daqnet.kek.jp
	    sleep 60
	    exit;

	elif [ $# -eq 3 ] 
	then

	    arichstatus=$3
	    echo "ARICH status : $arichstatus" | mailx -a $sourceHome$2 -s "ARICH status $arichstatus" burmist@bdaq.daqnet.kek.jp
	    sleep 60
	    exit;

        else
            printHelp
        fi

    elif [ "$1" = "-p2" ]; then
	
	echo " $1 "
	
    else
        
        printHelp
            
    fi
   
fi
