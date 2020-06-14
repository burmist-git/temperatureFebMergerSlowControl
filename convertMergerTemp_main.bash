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

    ./convertMergerTemp_main $1 $2 $3
    
}

function convertArr {

    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "33" ]
	then
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    #echo $fileIn
	    convertMergerTemp_main_bash 0 $fileIn $outPdfFileName | tee $fileIn'.log'
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
	if [ "$numberOfLines" -eq "33" ]
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
	if [ "$numberOfLines" -ne "33" ]
	then
	    echo $numberOfLines
	fi
	
    done
    
}

# Sat Oct 20 18:36:34 JST 2018
inDataFileNameArr=(
    mgrtemp-181016-151536
    mgrtemp-181016-162158
    mgrtemp-181016-161145
    mgrtemp-181016-160132
    mgrtemp-181016-155119
    mgrtemp-181016-154106
    mgrtemp-181016-153058
    mgrtemp-181016-152054
    mgrtemp-181016-172316
    mgrtemp-181016-171302
    mgrtemp-181016-170250
    mgrtemp-181016-165236
    mgrtemp-181016-164224
    mgrtemp-181016-163211
    mgrtemp-181016-182433
    mgrtemp-181016-181420
    mgrtemp-181016-180407
    mgrtemp-181016-175354
    mgrtemp-181016-174342
    mgrtemp-181016-173328
    mgrtemp-181016-193603
    mgrtemp-181016-192551
    mgrtemp-181016-191537
    mgrtemp-181016-190525
    mgrtemp-181016-185511
    mgrtemp-181016-184459
    mgrtemp-181016-183446
    mgrtemp-181016-202708
    mgrtemp-181016-201655
    mgrtemp-181016-200642
    mgrtemp-181016-195629
    mgrtemp-181016-194617
    mgrtemp-181016-213838
    mgrtemp-181016-212826
    mgrtemp-181016-211812
    mgrtemp-181016-210800
    mgrtemp-181016-205746
    mgrtemp-181016-204734
    mgrtemp-181016-203720
    mgrtemp-181016-223955
    mgrtemp-181016-222943
    mgrtemp-181016-221930
    mgrtemp-181016-220917
    mgrtemp-181016-215904
    mgrtemp-181016-214851
    mgrtemp-181016-234113
    mgrtemp-181016-233101
    mgrtemp-181016-232047
    mgrtemp-181016-231035
    mgrtemp-181016-230021
    mgrtemp-181016-225009
    mgrtemp-181016-235127
    mgrtemp-181017-004230
    mgrtemp-181017-003218
    mgrtemp-181017-002205
    mgrtemp-181017-001152
    mgrtemp-181017-000139
    mgrtemp-181017-014348
    mgrtemp-181017-013336
    mgrtemp-181017-012322
    mgrtemp-181017-011310
    mgrtemp-181017-010256
    mgrtemp-181017-005244
    mgrtemp-181017-024505
    mgrtemp-181017-023453
    mgrtemp-181017-022439
    mgrtemp-181017-021427
    mgrtemp-181017-020414
    mgrtemp-181017-015401
    mgrtemp-181017-034623
    mgrtemp-181017-033610
    mgrtemp-181017-032557
    mgrtemp-181017-031545
    mgrtemp-181017-030531
    mgrtemp-181017-025519
    mgrtemp-181017-044740
    mgrtemp-181017-043728
    mgrtemp-181017-042714
    mgrtemp-181017-041702
    mgrtemp-181017-040648
    mgrtemp-181017-035636
    mgrtemp-181017-054858
    mgrtemp-181017-053845
    mgrtemp-181017-052832
    mgrtemp-181017-051820
    mgrtemp-181017-050806
    mgrtemp-181017-045754
    mgrtemp-181017-065015
    mgrtemp-181017-064003
    mgrtemp-181017-062949
    mgrtemp-181017-061937
    mgrtemp-181017-060923
    mgrtemp-181017-055911
    mgrtemp-181017-075133
    mgrtemp-181017-074120
    mgrtemp-181017-073107
    mgrtemp-181017-072054
    mgrtemp-181017-071041
    mgrtemp-181017-070029
    mgrtemp-181017-085250
    mgrtemp-181017-084238
    mgrtemp-181017-083224
    mgrtemp-181017-082212
    mgrtemp-181017-081158
    mgrtemp-181017-080146
    mgrtemp-181017-095408
    mgrtemp-181017-094355
    mgrtemp-181017-093342
    mgrtemp-181017-092329
    mgrtemp-181017-091316
    mgrtemp-181017-090303
    mgrtemp-181017-105525
    mgrtemp-181017-104513
    mgrtemp-181017-103459
    mgrtemp-181017-102447
    mgrtemp-181017-101433
    mgrtemp-181017-100421
    mgrtemp-181017-115642
    mgrtemp-181017-114630
    mgrtemp-181017-113617
    mgrtemp-181017-112604
    mgrtemp-181017-111551
    mgrtemp-181017-110538
    mgrtemp-181017-125800
    mgrtemp-181017-124748
    mgrtemp-181017-123734
    mgrtemp-181017-122722
    mgrtemp-181017-121708
    mgrtemp-181017-120656
    mgrtemp-181017-135917
    mgrtemp-181017-134905
    mgrtemp-181017-133852
    mgrtemp-181017-132839
    mgrtemp-181017-131826
    mgrtemp-181017-130813
    mgrtemp-181017-150035
    mgrtemp-181017-145022
    mgrtemp-181017-144009
    mgrtemp-181017-142957
    mgrtemp-181017-141943
    mgrtemp-181017-140931
    mgrtemp-181017-160152
    mgrtemp-181017-155138
    mgrtemp-181017-154125
    mgrtemp-181017-153112
    mgrtemp-181017-152101
    mgrtemp-181017-151048
    mgrtemp-181017-165618
    mgrtemp-181017-164551
    mgrtemp-181017-163531
    mgrtemp-181017-162503
    mgrtemp-181017-161436
    mgrtemp-181017-160409
    mgrtemp-181017-160312
    mgrtemp-181017-175852
    mgrtemp-181017-174833
    mgrtemp-181017-173807
    mgrtemp-181017-172739
    mgrtemp-181017-171712
    mgrtemp-181017-170646
    mgrtemp-181017-190128
    mgrtemp-181017-185101
    mgrtemp-181017-184033
    mgrtemp-181017-183007
    mgrtemp-181017-181940
    mgrtemp-181017-180913
    mgrtemp-181017-191148
)

#nLinesArr
# convertion form array
rawDataFolder="./data/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
#convertArr
mergeArr
