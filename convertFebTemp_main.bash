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

    ./convertFebTemp_main $1 $2 $3
    
}

function convertArr {
    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	#echo $fileIn
	convertFebTemp_main_bash 0 $fileIn $outPdfFileName | tee $fileIn'.log'
	singlePlotPdfList="$singlePlotPdfList $outPdfFileName"
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
	inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}.'root'
	inRootHistFileList="$inRootHistFileList $inRootFileName"
    done
    outRootFileName="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.root"
    echo $outRootHistFileList
    ./convertFebTemp_main 1 $outRootFileName $inRootHistFileList
}

# Sat Oct 20 18:36:34 JST 2018
inDataFileNameArr=(
    febtemp-181017-160409
    febtemp-181017-161436
    febtemp-181017-162503
    febtemp-181017-163531
    febtemp-181017-164551
    febtemp-181017-165618
    febtemp-181017-170646
    febtemp-181017-171712
    febtemp-181017-172739
    febtemp-181017-173807
    febtemp-181017-174833
    febtemp-181017-175852
    febtemp-181017-180913
    febtemp-181017-181940
    febtemp-181017-183007
    febtemp-181017-184033
    febtemp-181017-185101
    febtemp-181017-190128
    febtemp-181017-191148
)

rawDataFolder="./data/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
#convertArr

mergeArr
