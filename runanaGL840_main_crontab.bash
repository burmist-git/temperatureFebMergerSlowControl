#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2019 - LBS - (Single person developer.)                 #
# Sun Apr 14 01:04:53 JST 2019                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                                                                      #
# Input paramete:                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

LC_TIME=en_US.UTF-8
source /home/hvala/root/bin/thisroot.sh
#source /home/burmist/root_v6.14.00/root-6.14.00-install/bin/thisroot.sh

function runanaGL840_main_bash {
    #echo "runanaGL840_main_bash"
    $sourceHome/runanaGL840_main $1 $2 $3 $4 $5
}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d : default"
    echo " [1]    : name of the folder to convert"
    echo " [0] -l : provide a list of root files to convert"
    echo " [0] -h : print help"

}

sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
#sourceHome="/home/burmist/temperaturefebmergerslowcontrol/"
rawDataFolder="/home/hvala/nishida6/data/"
#rawDataFolder="/home/burmist/temperaturefebmergerslowcontrol/data/"
gl840RootFile="gl840.root"
gl840RootFileList="gl840_rootFilesList.dat"
rootpdfsummaryFolder=$rawDataFolder'root_pdf_summary'
mkdir -p $rootpdfsummaryFolder

if [ $# -eq 0 ] 
then
    printHelp
else
    if [ "$1" = "-d" ]; then
	keyID=1
	dataDivision=1
	parametersFileIn=$sourceHome"data_TimeMin_TimeMax_Flux_GL840.dat"
	if [ $# -eq 2 ]
        then
	    inDataFolder=$2
	    rootFileOrList=$rawDataFolder$inDataFolder/$gl840RootFile
	    outRootFileF=$rootpdfsummaryFolder/$inDataFolder'-'$gl840RootFile'_hist.root'
	    outPdfFileFt=$outRootFileF'_t.pdf'
	    outPdfFileFu=$outRootFileF'_u.pdf'
	    echo "keyID            "$keyID
	    echo "rootFileOrList   "$rootFileOrList
	    echo "outRootFileF     "$outRootFileF
	    echo "dataDivision     "$dataDivision
	    echo "parametersFileIn "$parametersFileIn
	    runanaGL840_main_bash $keyID $rootFileOrList $outRootFileF $dataDivision $parametersFileIn
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFt $outPdfFileF
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFu $outPdfFileF
        elif [ $# -eq 1 ]; then
	    inDataFolder='gl840tv-'$(date +%y%m%d)
	    rootFileOrList=$rawDataFolder$inDataFolder/$gl840RootFile
	    outRootFileF=$rootpdfsummaryFolder/$inDataFolder'-'$gl840RootFile'_hist.root'
	    outPdfFileFt=$outRootFileF'_t.pdf'
	    outPdfFileFu=$outRootFileF'_u.pdf'
	    echo "keyID            "$keyID
	    echo "rootFileOrList   "$rootFileOrList
	    echo "outRootFileF     "$outRootFileF
	    echo "dataDivision     "$dataDivision
	    echo "parametersFileIn "$parametersFileIn
	    runanaGL840_main_bash $keyID $rootFileOrList $outRootFileF $dataDivision $parametersFileIn
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFt $outPdfFileF
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFu $outPdfFileF
        else
            printHelp
        fi
    elif [ "$1" = "-l" ]; then
	keyID=0
	dataDivision=1
	parametersFileIn=$sourceHome"data_TimeMin_TimeMax_Flux_GL840.dat"
	if [ $# -eq 2 ]
        then
            printHelp
        elif [ $# -eq 1 ]; then
	    inDataFolder='gl840tv-'$(date +%y%m%d)
	    rootFileOrList=$sourceHome$gl840RootFileList
	    outRootFileF=$rootpdfsummaryFolder/$inDataFolder'-'$gl840RootFileList'_hist.root'
	    outPdfFileFt=$outRootFileF'_t.pdf'
	    outPdfFileFu=$outRootFileF'_u.pdf'
	    echo "keyID            "$keyID
	    echo "rootFileOrList   "$rootFileOrList
	    echo "outRootFileF     "$outRootFileF
	    echo "dataDivision     "$dataDivision
	    echo "parametersFileIn "$parametersFileIn
	    runanaGL840_main_bash $keyID $rootFileOrList $outRootFileF $dataDivision $parametersFileIn
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFt $outPdfFileF
            #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $outPdfFileFu $outPdfFileF
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
