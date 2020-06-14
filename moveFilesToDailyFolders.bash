#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Wed Jun 20 23:28:11 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                                                                      #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function makeFolders {

    mkdir -p $1

}

function moveFilesToDailyFolders_bash {

    febfilestomove=$(dirname $1)/'febtemp-'$(basename $1)
    mgrfilestomove=$(dirname $1)/'mgrtemp-'$(basename $1)
    makeFolders $1
    mv $febfilestomove* $1/.
    mv $mgrfilestomove* $1/.

}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d   : create folder and move daily files"
    echo " [1]      : folder name for example : 181121"
    echo " [0] -arr : list folders to move defined in the array : inDataFileNameArr"

    echo " [0] -h   : print help"

}

inDataFileNameArr=(
181121
)

dataHome='/home/hvala/nishida6/data/'

nn=${#inDataFileNameArr[@]}
let nn=nn-1

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then

	if [ $# -eq 2 ]
	then   
	    fileIn=$2 
            moveFilesToDailyFolders_bash  $dataHome$fileIn 
	elif [ $# -eq 1 ]; then
	    fileIn=$(date +%y%m%d)
	    echo $fileIn
            moveFilesToDailyFolders_bash  $dataHome$fileIn 
	else
	    printHelp
	fi
                    
    elif [ "$1" = "-arr" ]; then
        
	for i in `seq 0 $nn`;
	do
	    fileIn=${inDataFileNameArr[$i]}
            moveFilesToDailyFolders_bash  $dataHome$fileIn
	done

    elif [ "$1" = "-h" ]; then
        
        printHelp
	
    else
        
        printHelp
        
    fi
    
fi
