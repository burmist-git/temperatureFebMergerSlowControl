#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Fri Nov 23 12:17:49 JST 2018                                         #
# Autor: Shohei Nishida                                                #
#        Yun-Tsung Lai                                                 #
#        Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                                                                      #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

#function convertFebTemp_main_crontab_bash {
function getFEBandMergerTemperatures {

    mkdir -p $dataHome'/data'
    MY_TIME=`date +%y%m%d-%H%M%S`
    #F_SENSOR=$dataHome/data/tempsensor-${MY_TIME}
    F_FEBTMP=$dataHome/data/febtemp-${MY_TIME} 
    F_MGRTMP=$dataHome/data/mgrtemp-${MY_TIME} 
    #echo Measuring temperature ${MY_TIME}
    #echo $MY_TIME > ${F_SENSOR}
    echo $MY_TIME > ${F_FEBTMP}
    echo $MY_TIME > ${F_MGRTMP}
    #$HOME/bin/tempsensor >> ${F_SENSOR} 2>&1
    $HOME/bin/tempcheck_feb.sh >> ${F_FEBTMP} 2>&1
    $HOME/bin/tempcheck.sh     >> ${F_MGRTMP} 2>&1
    #cp -p ${F_SENSOR} $dataHome/data/tempsensor-latest

}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " -d  : default"
    echo " -p2 : second parameter"

}

dataHome='/home/hvala/nishida6/'

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        
	getFEBandMergerTemperatures
        
    elif [ "$1" = "-p2" ]; then
        
        echo " $1 "
    else
        
        printHelp
            
    fi
   
fi
