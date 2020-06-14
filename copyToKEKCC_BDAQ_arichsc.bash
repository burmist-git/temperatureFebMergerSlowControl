#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Sun Nov 25 13:21:13 JST 2018                                         #
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

arichscemaildir='/home/usr/hvala/burmist_sent_email/'
sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
#sourceHome="/home/burmist/temperaturefebmergerslowcontrol/"

function copyToArichsc {

    if [ "$1" = "-sshpass" ]; then

	sshpass -f "$sourceHome/mpfile.arichsc" scp -r $2 hvala@arichsc:$arichscemaildir/.
	
    else
        
	scp -r $1 hvala@arichsc:$arichscemaildir/.
            
    fi

}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d       : default --> burmist@b2stone:/home/belle2/burmist/bdaqfiles/"
    echo " [1]          : name of the file/directory to copy"
    echo " [0] -asc     : copy to --> hvala@arichsc:/home/usr/hvala/burmist_sent_email/"
    echo " [1]          : name of the file/directory to copy"
    echo " [0] -email   : copy to hvala@arichsc and send email"
    echo " [1]          : name of the file to copy and send"
    echo " [2]          : arichstatus ex : (temperature, TimeSynchronisation)"
    echo " [0] -sshpass : copy to hvala@arichsc and send email with sshpass"
    echo " [1]          : name of the file to copy and send"
    echo " [2]          : arichstatus ex : (temperature, TimeSynchronisation)"
    echo " [0] -p2    : second parameter"

}

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then
        
	if [ $# -eq 2 ]
        then   

	    scp -P 2022 -r $2 burmist@b2stone:/home/belle2/burmist/bdaqfiles/.

        else
            printHelp
        fi

    elif [ "$1" = "-email" ]; then
        
	if [ $# -eq 2 ]
        then   
	    
	    copyToArichsc $2
	    fileToSendName=$(basename $2)
	    cmd="/home/usr/hvala/burmist_sent_email/sentemail.bash -d $fileToSendName"
	    ssh -X -t hvala@arichsc $cmd

	elif [  $# -eq 3 ]
	then

	    copyToArichsc $2
	    fileToSendName=$(basename $2)
	    cmd="/home/usr/hvala/burmist_sent_email/sentemail.bash -d $fileToSendName $3"
	    ssh -X -t hvala@arichsc $cmd	    

        else
            printHelp
        fi

    elif [ "$1" = "-sshpass" ]; then
        
	if [ $# -eq 2 ]
        then   
	    
	    copyToArichsc -sshpass $2
	    fileToSendName=$(basename $2)
	    cmd="/home/usr/hvala/burmist_sent_email/sentemail.bash -d $fileToSendName"
	    sshpass -f "$sourceHome/mpfile.arichsc" ssh -X -t hvala@arichsc $cmd

	elif [  $# -eq 3 ]
	then

	    copyToArichsc -sshpass $2
	    fileToSendName=$(basename $2)
	    cmd="/home/usr/hvala/burmist_sent_email/sentemail.bash -d $fileToSendName $3"
	    sshpass -f "$sourceHome/mpfile.arichsc" ssh -X -t hvala@arichsc $cmd	    

        else
            printHelp
        fi

    elif [ "$1" = "-asc" ]; then

	if [ $# -eq 2 ]
        then   

	    copyToArichsc $2

        else
            printHelp
        fi


    elif [ "$1" = "-p2" ]; then
	
	echo " $1 "
	
    else
        
        printHelp
            
    fi
   
fi
