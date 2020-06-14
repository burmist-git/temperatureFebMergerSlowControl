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
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFilefpgat $outPdfFileNamefpgatList
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileboardt $outPdfFileNameboardtList
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

# Wed Nov 14 22:32:01 JST 2018
inDataFileNameArr=(
mgrtemp-181113-000115
mgrtemp-181113-001640
mgrtemp-181113-003217
mgrtemp-181113-004732
mgrtemp-181113-010259
mgrtemp-181113-011833
mgrtemp-181113-013354
mgrtemp-181113-014928
mgrtemp-181113-020501
mgrtemp-181113-022027
mgrtemp-181113-023556
mgrtemp-181113-025136
mgrtemp-181113-030650
mgrtemp-181113-032230
mgrtemp-181113-033759
mgrtemp-181113-035338
mgrtemp-181113-040917
mgrtemp-181113-042433
mgrtemp-181113-043950
mgrtemp-181113-045514
mgrtemp-181113-051029
mgrtemp-181113-052552
mgrtemp-181113-054110
mgrtemp-181113-055629
mgrtemp-181113-061148
mgrtemp-181113-062719
mgrtemp-181113-064246
mgrtemp-181113-065827
mgrtemp-181113-071355
mgrtemp-181113-072921
mgrtemp-181113-074439
mgrtemp-181113-080001
mgrtemp-181113-081543
mgrtemp-181113-083055
mgrtemp-181113-084616
mgrtemp-181113-090134
mgrtemp-181113-091716
mgrtemp-181113-093244
mgrtemp-181113-093658
mgrtemp-181113-094805
mgrtemp-181113-095952
mgrtemp-181113-101106
mgrtemp-181113-102258
mgrtemp-181113-103411
mgrtemp-181113-104555
mgrtemp-181113-105701
mgrtemp-181113-110810
mgrtemp-181113-111923
mgrtemp-181113-113057
mgrtemp-181113-114251
mgrtemp-181113-115447
mgrtemp-181113-120642
mgrtemp-181113-121837
mgrtemp-181113-123011
mgrtemp-181113-124206
mgrtemp-181113-125353
mgrtemp-181113-130534
mgrtemp-181113-131714
mgrtemp-181113-132855
mgrtemp-181113-134036
mgrtemp-181113-135605
mgrtemp-181113-141147
mgrtemp-181113-142255
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181113/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
