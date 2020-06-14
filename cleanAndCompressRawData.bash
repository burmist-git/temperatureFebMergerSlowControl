#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Sun Feb 24 13:29:16 CET 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  Program used to clean and compress raw data.        #
#                                                                      #
# Input paramete:                                                      #
#                 NON.                                                 #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

LC_TIME=en_US.UTF-8
#source /home/hvala/root/bin/thisroot.sh
#source /home/burmist/root_v6.14.00/root-6.14.00-install/bin/thisroot.sh

function cleanData {
    echo " --> cleanData"
    floderToClean=$(basename $1)
    #echo "$floderToClean"
    $sourceHome/convertFebTemp_main_crontab.bash -c $floderToClean
    $sourceHome/convertMergerTemp_main_crontab.bash -c $floderToClean
}

function compressAndRemoveRawDataFolder {
    echo " --> compressAndRemoveRawDataFolder"
    floderToCompressAndRemove=$(basename $1)
    tar -zcvf $rawDataFolder/$floderToCompressAndRemove.tar.gz $rawDataFolder/$floderToCompressAndRemove
    rm -rf $rawDataFolder/$floderToCompressAndRemove
}

function unpackRawDataArchive {
    echo " --> upackRawDataArchive"
    fileToUnpack=$(basename $1)
    echo "fileToUnpack = $fileToUnpack"
    if test -f "$rawDataFolder/$fileToUnpack"; then
	echo "$rawDataFolder/$fileToUnpack exist"
	tar -zxvf $rawDataFolder/$fileToUnpack -C $unpackRawData
	for rawDataDir in `find $unpackRawData/$rawDataFolder -type d`
	do
	    if [ $rawDataDir != "$unpackRawData/$rawDataFolder" ]; then
		#echo $rawDataDir
		rawDataDirBase=$(basename $rawDataDir)
		echo "rawDataDirBase = $rawDataDirBase"
		if [ ! -d "$rawDataFolder/$rawDataDirBase" ]; then
		    mv $rawDataDir $rawDataFolder/.
		else	
		    echo "ERROR -> cannot extract data the directory is already exist " 
		    echo "$rawDataDirBase"
		fi
	    fi
	done
    else
	echo "ERROR --> $rawDataFolder/$fileToUnpack does not exist"
    fi
    rm -rf $unpackRawData/*
}

function deleteDataFromRootpdfsummaryFolderData {
    echo " --> deleteDataFromRootpdfsummaryFolderData : "
    find $rootpdfsummaryFolder/* -type f -ctime $maxDaysOld -exec ls -lrt {} \;
    find $rootpdfsummaryFolder/* -type f -ctime $maxDaysOld -exec rm -rf {} \;
    #find $rootpdfsummaryFolder/* -type f -ctime $maxDaysOld -exec ls -lrt {} \;
}

function compressAndthenDeleteScreenLogFile {
    echo "compressAndthenDeleteScreenLogFile"
    screenlogtimecompression=$(date +%d.%m.20%y)
    tar -zcvf $screenLogFile-$screenlogtimecompression.tar.gz $screenLogFile
    mkdir -p $screenLogFileArchive
    mv $screenLogFile-$screenlogtimecompression.tar.gz $screenLogFileArchive/.
    rm -rf $screenLogFile
}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d         : default - clean and compress old raw data"
    echo " [1] (optional) : name of the folder to compress"
    echo " [0] -screenlog : compress and then delete screen log file"
    echo " [0] -unpack    : unpack raw data archive"
    echo " [1]            : raw data tar.gz archive"
    echo " [0] -h         : print help"

}

# Wed Nov 21 20:38:22 JST 2018
sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
#sourceHome="/home/burmist/temperaturefebmergerslowcontrol/"
rawDataFolder="/home/hvala/nishida6/data/"
#rawDataFolder="/home/burmist/temperaturefebmergerslowcontrol/data/"
maxDaysOld="+14"
screenLogFile="/home/hvala/screenlog.0"
#screenLogFile="/home/burmist/temperaturefebmergerslowcontrol/screenlog.0"
screenLogFileArchive="/home/hvala/screenlogArchive/"
#screenLogFileArchive="/home/burmist/temperaturefebmergerslowcontrol/screenlogArchive/"
#screenLogFile="/home/burmist/temperaturefebmergerslowcontrol/screenlog.0"
rootpdfsummaryFolder=$rawDataFolder'root_pdf_summary'
unpackRawData="/home/hvala/nishida6/data/unpackRawData"
mkdir -p $unpackRawData
mkdir -p $rootpdfsummaryFolder

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then

	if [ $# -eq 2 ]
        then   
	    cleanData $2
	    compressAndRemoveRawDataFolder $2
        elif [ $# -eq 1 ]; then
	    timeOfStart=$(date)
	    echo "New START temperature raw data compression ---> $timeOfStart"
	    for folderToProcess in $(find $rawDataFolder/* -type d -ctime $maxDaysOld)
	    do	    
		echo "folderToProcess = $folderToProcess"
		cleanData $folderToProcess
		compressAndRemoveRawDataFolder $folderToProcess
		#find $rawDataFolder/* -type d -ctime $maxDaysOld -exec basename {} \;
		#find $rawDataFolder/* -type d -ctime $maxDaysOld -exec basename {} \;
	    done
	    deleteDataFromRootpdfsummaryFolderData
	    timeOfStop=$(date)
	    echo "New STOP temperature raw data compression ---> $timeOfStop"    
        else
            printHelp
        fi
        
    elif [ "$1" = "-screenlog" ]; then

	timeOfStart=$(date)
	echo "New START compress and then delete screen log file ---> $timeOfStart"
	compressAndthenDeleteScreenLogFile

    elif [ "$1" = "-unpack" ]; then
	if [ $# -eq 2 ]; then   
	    unpackRawDataArchive $2
	else
            printHelp
	fi
    elif [ "$1" = "-h" ]; then
        printHelp
    else
        printHelp
    fi
    
fi

#espeak "I have done"
