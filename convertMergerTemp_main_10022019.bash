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

# Mon Nov 19 11:24:39 JST 2018
inDataFileNameArr=(
mgrtemp-190210-000101
mgrtemp-190210-001101
mgrtemp-190210-002101
mgrtemp-190210-003101
mgrtemp-190210-004101
mgrtemp-190210-005101
mgrtemp-190210-010101
mgrtemp-190210-011101
mgrtemp-190210-012101
mgrtemp-190210-013101
mgrtemp-190210-014101
mgrtemp-190210-015101
mgrtemp-190210-020101
mgrtemp-190210-021101
mgrtemp-190210-022101
mgrtemp-190210-023101
mgrtemp-190210-024101
mgrtemp-190210-025101
mgrtemp-190210-030101
mgrtemp-190210-031101
mgrtemp-190210-032102
mgrtemp-190210-033101
mgrtemp-190210-034101
mgrtemp-190210-035101
mgrtemp-190210-040101
mgrtemp-190210-041101
mgrtemp-190210-042101
mgrtemp-190210-043101
mgrtemp-190210-044101
mgrtemp-190210-045101
mgrtemp-190210-050101
mgrtemp-190210-051101
mgrtemp-190210-052102
mgrtemp-190210-053101
mgrtemp-190210-054101
mgrtemp-190210-055101
mgrtemp-190210-060101
mgrtemp-190210-061101
mgrtemp-190210-062101
mgrtemp-190210-063102
mgrtemp-190210-064101
mgrtemp-190210-065101
mgrtemp-190210-070101
mgrtemp-190210-071101
mgrtemp-190210-072101
mgrtemp-190210-073101
mgrtemp-190210-074101
mgrtemp-190210-075101
mgrtemp-190210-080101
mgrtemp-190210-081101
mgrtemp-190210-082101
mgrtemp-190210-083101
mgrtemp-190210-084102
mgrtemp-190210-085101
mgrtemp-190210-090101
mgrtemp-190210-091102
mgrtemp-190210-092101
mgrtemp-190210-093101
mgrtemp-190210-094101
mgrtemp-190210-095102
mgrtemp-190210-100101
mgrtemp-190210-101101
mgrtemp-190210-102102
mgrtemp-190210-103101
mgrtemp-190210-104101
mgrtemp-190210-105102
mgrtemp-190210-110101
mgrtemp-190210-111101
mgrtemp-190210-112101
mgrtemp-190210-113101
mgrtemp-190210-114101
mgrtemp-190210-115101
mgrtemp-190210-120101
mgrtemp-190210-121101
mgrtemp-190210-122101
mgrtemp-190210-123102
mgrtemp-190210-124101
mgrtemp-190210-125101
mgrtemp-190210-130101
mgrtemp-190210-131101
mgrtemp-190210-132102
)

# convertion form array
rawDataFolder="./data-190210/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1

function unifyTheFormat {
    infile=$1
    outfile=$2
    #echo $infile
    #echo $outfile
    sed '/Reading FPGA system temp/d' $infile | sed '/Reading Merger sensor temp/d' > $outfile
}
 
function convertMergerTemp_main_bash {

    #echo "convertMergerTemp_main_bash"
    ./convertMergerTemp_main $1 $2 $3 $4
    
}

function convertArr {

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
	    outPdfFileNamePreff=$rawDataFolder${inDataFileNameArr[$i]}
	    #outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}'_board.pdf'
	    #echo $fileIn
	    convertMergerTemp_main_bash 0 $fileIn $outPdfFileNamePreff  $numberOfSectors | tee $fileIn'.log'
            outPdfFileNamefpga=$outPdfFileNamePreff"_fpga_t.pdf"
	    outPdfFileNameboard=$outPdfFileNamePreff"_board_t.pdf"
	    outPdfFileNamefpgatList="$outPdfFileNamefpgatList $outPdfFileNamefpga"
	    outPdfFileNameboardtList="$outPdfFileNameboardtList $outPdfFileNameboard"
	fi
	
    done
    
    mergedPdfOutFilefpgat="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_fpga_t.pdf"
    mergedPdfOutFileboardt="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_board_t.pdf"

    echo "---> mearge to single pdf fpgat : $outPdfFileNamefpgatList"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFilefpgat $outPdfFileNamefpgatList  > /dev/null 2>&1
    echo "---> mearge to single pdf boart : $outPdfFileNameboardtList"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileboardt $outPdfFileNameboardtList  > /dev/null 2>&1

    echo $mergedPdfOutFilefpgat
    echo $mergedPdfOutFileboardt
    
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

#nLinesArr
convertArr
mergeArr

espeak "I have done"
