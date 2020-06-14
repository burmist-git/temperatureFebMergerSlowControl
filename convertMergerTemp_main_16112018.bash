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

# Fri Nov 16 13:26:46 JST 2018
inDataFileNameArr=(
mgrtemp-181115-000459
mgrtemp-181115-001643
mgrtemp-181115-002817
mgrtemp-181115-003959
mgrtemp-181115-005148
mgrtemp-181115-010317
mgrtemp-181115-011452
mgrtemp-181115-012635
mgrtemp-181115-013817
mgrtemp-181115-014958
mgrtemp-181116-084104
mgrtemp-181116-085236
mgrtemp-181116-090355
mgrtemp-181116-091530
mgrtemp-181116-092704
mgrtemp-181116-093837
mgrtemp-181116-095010
mgrtemp-181116-100127
mgrtemp-181116-101230
mgrtemp-181116-102348
mgrtemp-181116-103544
mgrtemp-181116-104740
mgrtemp-181116-105930
mgrtemp-181116-111058
mgrtemp-181116-112234
mgrtemp-181116-113416
mgrtemp-181116-114552
mgrtemp-181116-115734
mgrtemp-181116-120909
mgrtemp-181116-122033
mgrtemp-181116-123218
mgrtemp-181116-124401
mgrtemp-181116-125514
mgrtemp-181116-130657
mgrtemp-181116-131824
mgrtemp-181116-132939
mgrtemp-181116-134052
mgrtemp-181116-135229
mgrtemp-181116-140350
mgrtemp-181116-141508
mgrtemp-181116-142627
mgrtemp-181116-143814
mgrtemp-181116-145010
mgrtemp-181116-150144
mgrtemp-181116-151339
mgrtemp-181116-152535
mgrtemp-181116-153722
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181116/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr

