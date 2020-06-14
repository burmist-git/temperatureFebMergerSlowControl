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
	if [ "$numberOfLines" -eq "865" ]
	then
	    outPdfFileNamePreff=$rawDataFolder${inDataFileNameArr[$i]}
	    #echo $fileIn
	    convertFebTemp_main_bash 0 $fileIn $outPdfFileNamePreff $numberOfSectors | tee $fileIn'.log'
	    outPdfFileName=$outPdfFileNamePreff"_h2_feb_t1.pdf"
	    singlePlotPdfListh2febt1pdf="$singlePlotPdfListh2febt1pdf $outPdfFileName"
	    outPdfFileName=$outPdfFileNamePreff'_h2_feb_t2.pdf'
	    singlePlotPdfListh2febt2pdf="$singlePlotPdfListh2febt2pdf $outPdfFileName"
	    outPdfFileName=$outPdfFileNamePreff'_h1_feb_t1.pdf'
	    singlePlotPdfListh1febt1pdf="$singlePlotPdfListh1febt1pdf $outPdfFileName"
	    outPdfFileName=$outPdfFileNamePreff'_h1_feb_t2.pdf'
	    singlePlotPdfListh1febt2pdf="$singlePlotPdfListh1febt2pdf $outPdfFileName"
	fi
    done
    
    mergedPdfOutFileh2febt1pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h2_feb_t1.pdf"
    mergedPdfOutFileh2febt2pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h2_feb_t2.pdf"
    mergedPdfOutFileh1febt1pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h1_feb_t1.pdf"
    mergedPdfOutFileh1febt2pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h1_feb_t2.pdf"

    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt1pdf $singlePlotPdfListh2febt1pdf
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt2pdf $singlePlotPdfListh2febt2pdf
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt1pdf $singlePlotPdfListh1febt1pdf
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt2pdf $singlePlotPdfListh1febt2pdf

    echo $mergedPdfOutFileh2febt1pdf
    echo $mergedPdfOutFileh2febt2pdf
    echo $mergedPdfOutFileh1febt1pdf
    echo $mergedPdfOutFileh1febt2pdf
    
}

function mergeArr {
    
    inRootHistFileList=""
    for i in `seq 0 $nn`;
    do
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "865" ]
	then	
	    inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}.'root'
	    inRootHistFileList="$inRootHistFileList $inRootFileName"
	fi
    done
    outRootFileName="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.root"
    echo $outRootHistFileList
    ./convertFebTemp_main 1 $outRootFileName $inRootHistFileList
    
}

# Wed Nov 14 16:43:19 JST 2018
inDataFileNameArr=(
febtemp-181113-000115
febtemp-181113-001640
febtemp-181113-003217
febtemp-181113-004732
febtemp-181113-010259
febtemp-181113-011833
febtemp-181113-013354
febtemp-181113-014928
febtemp-181113-020501
febtemp-181113-022027
febtemp-181113-023556
febtemp-181113-025136
febtemp-181113-030650
febtemp-181113-032230
febtemp-181113-033759
febtemp-181113-035338
febtemp-181113-040917
febtemp-181113-042433
febtemp-181113-043950
febtemp-181113-045514
febtemp-181113-051029
febtemp-181113-052552
febtemp-181113-054110
febtemp-181113-055629
febtemp-181113-061148
febtemp-181113-062719
febtemp-181113-064246
febtemp-181113-065827
febtemp-181113-071355
febtemp-181113-072921
febtemp-181113-074439
febtemp-181113-080001
febtemp-181113-081543
febtemp-181113-083055
febtemp-181113-084616
febtemp-181113-090134
febtemp-181113-091716
febtemp-181113-093244
febtemp-181113-093658
febtemp-181113-094805
febtemp-181113-095952
febtemp-181113-101106
febtemp-181113-102258
febtemp-181113-103411
febtemp-181113-104555
febtemp-181113-105701
febtemp-181113-110810
febtemp-181113-111923
febtemp-181113-113057
febtemp-181113-114251
febtemp-181113-115447
febtemp-181113-120642
febtemp-181113-121837
febtemp-181113-123011
febtemp-181113-124206
febtemp-181113-125353
febtemp-181113-130534
febtemp-181113-131714
febtemp-181113-132855
febtemp-181113-134036
febtemp-181113-135605
febtemp-181113-141147
febtemp-181113-142255
)

rawDataFolder="./data-181113/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
