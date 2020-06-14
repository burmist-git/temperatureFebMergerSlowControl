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

function unifyTheFormat {
    infile=$1
    outfile=$2
    sed '/Reading FPGA system temp/d' $infile | sed '/Reading Merger sensor temp/d' > $outfile
}
 
function convertMergerTemp_main_bash {

    #echo "convertMergerTemp_main_bash"
    ./convertMergerTemp_main $1 $2 $3 $4
    
}

function convertArr {

    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	fileRawFile=$rawDataFolder${inDataFileNameArr[$i]}
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}'_tmp'
	unifyTheFormat $fileRawFile $fileIn
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	numberOfSectors=`more $fileIn | grep cpr40 | wc -l`
	let numberOfSectors=numberOfSectors/6
	echo "numberOfSectors = $numberOfSectors"
	if [ "$numberOfLines" -eq "181" ]
	then
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    #outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}'_board.pdf'
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

	fileIn=$rawDataFolder${inDataFileNameArr[$i]}'_tmp'
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "181" ]
	then
	    inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}'_tmp'.'root'
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
	if [ "$numberOfLines" -ne "181" ]
	then
	    echo $numberOfLines
	fi
	
    done
    
}

# Tue Nov  6 19:15:16 JST 2018
inDataFileNameArr=(
mgrtemp-181106-223509
mgrtemp-181106-223705
mgrtemp-181106-224558
mgrtemp-181106-224846
mgrtemp-181106-225702
mgrtemp-181106-230003
mgrtemp-181106-230802
mgrtemp-181106-231143
mgrtemp-181106-231907
mgrtemp-181106-232323
mgrtemp-181106-233011
mgrtemp-181106-233447
mgrtemp-181106-234112
mgrtemp-181106-234620
mgrtemp-181106-235159
mgrtemp-181106-235748
mgrtemp-181107-000250
mgrtemp-181107-000924
mgrtemp-181107-001403
mgrtemp-181107-002105
mgrtemp-181107-002458
mgrtemp-181107-003229
mgrtemp-181107-003601
mgrtemp-181107-004339
mgrtemp-181107-004714
mgrtemp-181107-005523
mgrtemp-181107-005826
mgrtemp-181107-010703
mgrtemp-181107-010938
mgrtemp-181107-011844
mgrtemp-181107-012049
mgrtemp-181107-013025
mgrtemp-181107-013200
mgrtemp-181107-014214
mgrtemp-181107-014319
mgrtemp-181107-015408
mgrtemp-181107-015437
mgrtemp-181107-020534
mgrtemp-181107-020535
mgrtemp-181107-021645
mgrtemp-181107-021714
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181107/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
