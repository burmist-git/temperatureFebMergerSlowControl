#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Sun Oct 21 15:39:30 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  Program used to convert Merger temperature data     #
#                  in to 2D TH2Poly histograms.                        #
#                                                                      #
# Input paramete:                                                      #
#                   NON.                                               #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function convertMergerTemp_main_bash {

    ./convertMergerTemp_main $1 $2 $3 $4
    
}

function convertArr {

    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	numberOfSectors=`more $fileIn | grep Reading | grep FPGA | grep system | grep temp | wc -l`
	if [ "$numberOfLines" -eq "97" ]
	then
	    #outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}'_board.pdf'
	    #echo $fileIn
	    convertMergerTemp_main_bash 0 $fileIn $outPdfFileName  $numberOfSectors | tee $fileIn'.log'
	    singlePlotPdfList="$singlePlotPdfList $outPdfFileName"
	fi
	
    done
    
    mergedPdfOutFile="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFile $singlePlotPdfList
    echo $mergedPdfOutFile
    
}

function mergeArr {

    inRootHistFileList=""
    for i in `seq 0 $nn`;
    do

	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "97" ]
	then
	    inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}.'root'
	    inRootHistFileList="$inRootHistFileList $inRootFileName"
	fi

    done
    outRootFileName="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.root"
    echo $outRootHistFileList
    ./convertMergerTemp_main 1 $outRootFileName $inRootHistFileList

}

function nLines {

    return `more $1 | wc -l`
    
}

function nLinesArr {

    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -ne "97" ]
	then
	    echo $numberOfLines
	fi
	
    done
    
}

# Mon Oct 22 20:24:08 JST 2018
inDataFileNameArr=(
    mgrtemp-181103-191007
    mgrtemp-181103-192059
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181102/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
