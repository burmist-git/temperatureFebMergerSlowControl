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

# Fri Nov 16 13:11:41 JST 2018
inDataFileNameArr=(
febtemp-181115-000459
febtemp-181115-001643
febtemp-181115-002817
febtemp-181115-003959
febtemp-181115-005148
febtemp-181115-010317
febtemp-181115-011452
febtemp-181115-012635
febtemp-181115-013817
febtemp-181115-014958
febtemp-181116-084104
febtemp-181116-085236
febtemp-181116-090355
febtemp-181116-091530
febtemp-181116-092704
febtemp-181116-093837
febtemp-181116-095010
febtemp-181116-100127
febtemp-181116-101230
febtemp-181116-102348
febtemp-181116-103544
febtemp-181116-104740
febtemp-181116-105930
febtemp-181116-111058
febtemp-181116-112234
febtemp-181116-113416
febtemp-181116-114552
febtemp-181116-115734
febtemp-181116-120909
febtemp-181116-122033
febtemp-181116-123218
febtemp-181116-124401
febtemp-181116-125514
febtemp-181116-130657
febtemp-181116-131824
febtemp-181116-132939
febtemp-181116-134052
febtemp-181116-135229
febtemp-181116-140350
febtemp-181116-141508
febtemp-181116-142627
febtemp-181116-143814
febtemp-181116-145010
febtemp-181116-150144
febtemp-181116-151339
febtemp-181116-152535
febtemp-181116-153722
)


rawDataFolder="./data-181116/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1

function convertFebTemp_main_bash {

    ./convertFebTemp_main $1 $2 $3 $4
    
}

function cleanTmpData {

    rm -rf $rawDataFolder/*.pdf
    rm -rf $rawDataFolder/*.root
    rm -rf $rawDataFolder/*.log
    
}

function convertArr {
    singlePlotPdfListh2febt1pdf=""
    singlePlotPdfListh2febt2pdf=""
    singlePlotPdfListh1febt1pdf=""
    singlePlotPdfListh1febt2pdf=""
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

    echo "---> mearge to single pdf of h2 t1 : $singlePlotPdfListh2febt1pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt1pdf $singlePlotPdfListh2febt1pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h2 t2 : $singlePlotPdfListh2febt2pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt2pdf $singlePlotPdfListh2febt2pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h1 t1 : $singlePlotPdfListh1febt1pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt1pdf $singlePlotPdfListh1febt1pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h1 t2 : $singlePlotPdfListh1febt2pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt2pdf $singlePlotPdfListh1febt2pdf > /dev/null 2>&1

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

#cleanTmpData
convertArr
mergeArr

