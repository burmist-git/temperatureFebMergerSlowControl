#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Fri Apr 12 23:36:42 JST 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  Program used to read and convert gl840 temperature  #
#                  info data in dat or root format.                    #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

LC_TIME=en_US.UTF-8
source /home/hvala/root/bin/thisroot.sh

function gl840_bash {

    $sourceHome/gl840 $1 $2
    
}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d  : default"
    echo " [1]     : name of the folder to convert"
    echo " [0] -p2 : not implemented"
    echo " [0] -h  : print help"

}

sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
rawDataFolder="/home/hvala/nishida6/data/"
rootpdfsummaryFolder=$rawDataFolder'root_pdf_summary'
mkdir -p $rootpdfsummaryFolder
MY_TIME=`date +%y%m%d`
gl840_rawDataFolder=$rawDataFolder'gl840tv-'${MY_TIME}/
mkdir -p $gl840_rawDataFolder
outTxtDataFileName=$gl840_rawDataFolder'gl840.dat'
outRootDataFileName=$gl840_rawDataFolder'gl840.root'
echo $gl840_rawDataFolder
#echo $outTxtDataFileName

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        if [ $# -eq 1 ]
        then 
	    #output data is ASCII format  
	    #gl840_bash 0 $outTxtDataFileName
	    #output data is root format  
	    gl840_bash 1 $outRootDataFileName
        else
            printHelp
        fi
    elif [ "$1" = "-p2" ]; then
        printHelp
    elif [ "$1" = "-h" ]; then        
        printHelp
    else
        printHelp
    fi
    
fi

#espeak "I have done"
