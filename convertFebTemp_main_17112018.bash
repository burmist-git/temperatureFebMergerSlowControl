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

# Sun Nov 18 13:24:45 JST 2018
inDataFileNameArr=(
febtemp-181116-174529
febtemp-181116-175725
febtemp-181116-180922
febtemp-181116-182118
febtemp-181116-183245
febtemp-181116-184412
febtemp-181116-185555
febtemp-181116-190734
febtemp-181116-191929
febtemp-181116-193117
febtemp-181116-194250
febtemp-181116-195439
febtemp-181116-200604
febtemp-181116-201730
febtemp-181116-202903
febtemp-181116-204022
febtemp-181116-205148
febtemp-181116-210323
febtemp-181116-211448
febtemp-181116-212621
febtemp-181116-213802
febtemp-181116-214943
febtemp-181116-220122
febtemp-181116-221318
febtemp-181116-222514
febtemp-181116-223647
febtemp-181116-224843
febtemp-181116-230038
febtemp-181116-231235
febtemp-181116-232422
febtemp-181116-233617
febtemp-181116-234813
febtemp-181117-000008
febtemp-181117-001143
febtemp-181117-002316
febtemp-181117-003449
febtemp-181117-004630
febtemp-181117-005811
febtemp-181117-010944
febtemp-181117-012125
febtemp-181117-013305
febtemp-181117-014500
febtemp-181117-015655
febtemp-181117-020843
febtemp-181117-022021
febtemp-181117-023204
febtemp-181117-024342
febtemp-181117-025530
febtemp-181117-030725
febtemp-181117-031843
febtemp-181117-033026
febtemp-181117-034158
febtemp-181117-035324
febtemp-181117-040458
febtemp-181117-041631
febtemp-181117-042826
febtemp-181117-044000
febtemp-181117-045156
febtemp-181117-050351
febtemp-181117-051545
febtemp-181117-052740
febtemp-181117-053935
febtemp-181117-055123
febtemp-181117-060256
febtemp-181117-061430
febtemp-181117-062556
febtemp-181117-063753
febtemp-181117-064949
febtemp-181117-070123
febtemp-181117-071318
febtemp-181117-072512
febtemp-181117-073653
febtemp-181117-074826
febtemp-181117-080021
febtemp-181117-081209
febtemp-181117-082313
febtemp-181117-083447
febtemp-181117-084633
febtemp-181117-085801
febtemp-181117-090937
febtemp-181117-092117
febtemp-181117-093259
febtemp-181117-094440
febtemp-181117-095622
febtemp-181117-100803
febtemp-181117-101944
febtemp-181117-103125
febtemp-181117-104305
febtemp-181117-105439
febtemp-181117-110550
febtemp-181117-111717
febtemp-181117-112858
febtemp-181117-114025
febtemp-181117-115213
febtemp-181117-120354
febtemp-181117-121521
febtemp-181117-122654
febtemp-181117-123836
febtemp-181117-124938
febtemp-181117-130057
febtemp-181117-131244
febtemp-181117-132440
febtemp-181117-133634
febtemp-181117-134809
febtemp-181117-140004
febtemp-181117-141159
febtemp-181117-142354
febtemp-181117-143549
febtemp-181117-144745
febtemp-181117-145927
febtemp-181117-151109
)

rawDataFolder="./data-181117/"
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

espeak "I have done"
