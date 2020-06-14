#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Sat Oct 20 18:32:49 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  Program used to convert FEB temperature data in to  #
#                  2D TH2Poly histograms.                              #
#                                                                      #
# Input paramete:                                                      #
#                   NON.                                               #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function convertFebTemp_main_bash {

    ./convertFebTemp_main $1 $2 $3 $4
    
}

function convertArr {
    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	echo $fileIn
	echo $numberOfLines
	numberOfSectors=`more $fileIn | grep Reading | grep FEB | grep temp | wc -l`
	if [ "$numberOfLines" -eq "433" ]
	then
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    #echo $fileIn
	    convertFebTemp_main_bash 0 $fileIn $outPdfFileName $numberOfSectors | tee $fileIn'.log'
	    singlePlotPdfList="$singlePlotPdfList $outPdfFileName"
	fi
    done
    
    mergedPdfOutFile="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.pdf"
    #echo $mergedPdfOutFile
    #echo $singlePlotPdfList
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFile $singlePlotPdfList
    echo $mergedPdfOutFile
}

function mergeArr {
    
    inRootHistFileList=""
    for i in `seq 0 $nn`;
    do
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "433" ]
	then	
	    inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}.'root'
	    inRootHistFileList="$inRootHistFileList $inRootFileName"
	fi
    done
    outRootFileName="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.root"
    echo $outRootHistFileList
    ./convertFebTemp_main 1 $outRootFileName $inRootHistFileList
    
}

# Fri Nov  2 15:13:36 JST 2018
inDataFileNameArr=(
febtemp-181102-113247
febtemp-181102-114317
febtemp-181102-115345
febtemp-181102-120413
febtemp-181102-121442
febtemp-181102-122510
febtemp-181102-123540
febtemp-181102-124608
febtemp-181102-125637
febtemp-181102-130706
febtemp-181102-131736
febtemp-181102-132804
febtemp-181102-133834
febtemp-181102-134902
febtemp-181102-135925
febtemp-181102-140954
febtemp-181102-142023
febtemp-181102-143051
febtemp-181102-144120
)

rawDataFolder="./data-181102/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
