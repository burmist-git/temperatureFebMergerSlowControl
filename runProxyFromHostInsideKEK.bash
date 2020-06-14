#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2019 - LBS - (Single person developer.)                 #
# Sun Apr 21 10:43:00 JST 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function runProxyFromHostInsideKEK_bash {
    ssh -L 17668:b2arch1.daqnet.kek.jp:17668 -f -N burmist@bdaq.local.kek.jp
}

function printHelp {
    echo " --> ERROR in input arguments "
    echo " [0] -d  : default "
    echo " [0] -p2 : second parameter"
}

if [ $# -eq 0 ] 
then    
    printHelp
else
    if [ "$1" = "-d" ]; then    
	runProxyFromHostInsideKEK_bash
    elif [ "$1" = "-p2" ]; then
        printHelp
    else
        printHelp
    fi   
fi
