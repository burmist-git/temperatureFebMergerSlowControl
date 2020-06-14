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

# Thu Nov 15 19:17:26 JST 2018
inDataFileNameArr=(
febtemp-181114-005754
febtemp-181114-010908
febtemp-181114-012029
febtemp-181114-013217
febtemp-181114-014413
febtemp-181114-015608
febtemp-181114-020742
febtemp-181114-021938
febtemp-181114-023133
febtemp-181114-024329
febtemp-181114-025525
febtemp-181114-030712
febtemp-181114-031907
febtemp-181114-033103
febtemp-181114-034228
febtemp-181114-035401
febtemp-181114-040532
febtemp-181114-041719
febtemp-181114-042915
febtemp-181114-044111
febtemp-181114-045244
febtemp-181114-050425
febtemp-181114-051607
febtemp-181114-052748
febtemp-181114-053929
febtemp-181114-055110
febtemp-181114-060251
febtemp-181114-061432
febtemp-181114-062613
febtemp-181114-063754
febtemp-181114-064928
febtemp-181114-070116
febtemp-181114-071310
febtemp-181114-072451
febtemp-181114-073625
febtemp-181114-074740
febtemp-181114-075906
febtemp-181114-081041
febtemp-181114-082236
febtemp-181114-083431
febtemp-181114-084623
febtemp-181114-085834
febtemp-181114-091045
febtemp-181114-092256
febtemp-181114-093451
febtemp-181114-094646
febtemp-181114-095813
febtemp-181114-100947
febtemp-181114-102120
febtemp-181114-103241
febtemp-181114-104407
febtemp-181114-105543
febtemp-181114-110730
febtemp-181114-111903
febtemp-181114-113051
febtemp-181114-114231
febtemp-181114-115246
febtemp-181114-120441
febtemp-181114-121609
febtemp-181114-122736
febtemp-181114-123902
febtemp-181114-125036
febtemp-181114-130148
febtemp-181114-131321
febtemp-181114-132507
febtemp-181114-133634
febtemp-181114-134758
febtemp-181114-135939
febtemp-181114-141127
febtemp-181114-142322
febtemp-181114-143447
febtemp-181114-144600
febtemp-181114-145735
febtemp-181114-150910
febtemp-181114-152052
febtemp-181114-153106
febtemp-181114-154305
febtemp-181114-155438
febtemp-181114-160619
febtemp-181114-161800
febtemp-181114-162940
febtemp-181114-164121
febtemp-181114-165301
febtemp-181114-170440
febtemp-181114-171619
febtemp-181114-172800
febtemp-181114-173948
febtemp-181114-175143
febtemp-181114-180338
febtemp-181114-181532
febtemp-181114-182727
febtemp-181114-183908
febtemp-181114-185041
febtemp-181114-190236
febtemp-181114-191432
febtemp-181114-192604
febtemp-181114-193759
febtemp-181114-194954
febtemp-181114-200129
febtemp-181114-201303
febtemp-181114-202438
febtemp-181114-203559
febtemp-181114-204724
febtemp-181114-205900
febtemp-181114-211034
febtemp-181114-212208
febtemp-181114-213349
febtemp-181114-214537
febtemp-181114-215732
febtemp-181114-220913
febtemp-181114-222021
febtemp-181114-223136
febtemp-181114-224312
febtemp-181114-225447
febtemp-181114-230624
febtemp-181114-231758
febtemp-181114-232933
febtemp-181114-234129
febtemp-181114-235317
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
)

rawDataFolder="./data-181115/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
