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

#Wed Nov 14 16:43:19 JST 2018
inDataFileNameArr=(
febtemp-181108-000111
febtemp-181108-001225
febtemp-181108-002331
febtemp-181108-003512
febtemp-181108-004654
febtemp-181108-005838
febtemp-181108-011019
febtemp-181108-012201
febtemp-181108-013344
febtemp-181108-014527
febtemp-181108-015652
febtemp-181108-020809
febtemp-181108-022007
febtemp-181108-023205
febtemp-181108-024355
febtemp-181108-025550
febtemp-181108-030723
febtemp-181108-031857
febtemp-181108-033007
febtemp-181108-034134
febtemp-181108-035317
febtemp-181108-040446
febtemp-181108-041615
febtemp-181108-042746
febtemp-181108-043908
febtemp-181108-045021
febtemp-181108-050142
febtemp-181108-051302
febtemp-181108-052416
febtemp-181108-053559
febtemp-181108-054741
febtemp-181108-055924
febtemp-181108-061106
febtemp-181108-062249
febtemp-181108-063433
febtemp-181108-064615
febtemp-181108-065753
febtemp-181108-070937
febtemp-181108-072120
febtemp-181108-073303
febtemp-181108-074445
febtemp-181108-075627
febtemp-181108-080809
febtemp-181108-081949
febtemp-181108-083131
febtemp-181108-084305
febtemp-181108-085425
febtemp-181108-090549
febtemp-181108-091726
febtemp-181108-092842
febtemp-181108-094003
febtemp-181108-095117
febtemp-181108-100243
febtemp-181108-101411
febtemp-181108-102554
febtemp-181108-103737
febtemp-181108-104919
febtemp-181108-110101
febtemp-181108-111244
febtemp-181108-112426
febtemp-181108-113609
febtemp-181108-114733
febtemp-181108-115909
febtemp-181108-121053
febtemp-181108-122236
febtemp-181108-123418
febtemp-181108-124601
febtemp-181108-125743
febtemp-181108-130925
febtemp-181108-132108
febtemp-181108-133242
febtemp-181108-134414
febtemp-181108-135541
febtemp-181108-140704
febtemp-181108-141810
febtemp-181108-142950
febtemp-181108-144102
febtemp-181108-145159
febtemp-181108-150313
febtemp-181108-151436
febtemp-181108-152609
febtemp-181108-153734
febtemp-181108-154901
febtemp-181108-160036
febtemp-181108-161203
febtemp-181108-162343
febtemp-181108-163517
febtemp-181108-164657
febtemp-181108-165857
febtemp-181108-171044
febtemp-181108-172224
febtemp-181108-173413
febtemp-181108-174608
febtemp-181108-180032
febtemp-181108-181558
febtemp-181108-183110
febtemp-181108-184655
febtemp-181108-190221
febtemp-181108-191750
febtemp-181108-193145
febtemp-181108-194651
febtemp-181108-200215
febtemp-181108-201737
febtemp-181108-203318
febtemp-181108-204829
febtemp-181108-210348
febtemp-181108-211759
febtemp-181108-213318
febtemp-181108-214830
febtemp-181108-220348
febtemp-181108-221901
febtemp-181108-223411
febtemp-181108-224933
febtemp-181108-230448
febtemp-181108-231835
febtemp-181108-233331
febtemp-181108-234826
)

rawDataFolder="./data-181108/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
