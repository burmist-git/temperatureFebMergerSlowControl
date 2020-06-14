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
mgrtemp-181114-005754
mgrtemp-181114-010908
mgrtemp-181114-012029
mgrtemp-181114-013217
mgrtemp-181114-014413
mgrtemp-181114-015608
mgrtemp-181114-020742
mgrtemp-181114-021938
mgrtemp-181114-023133
mgrtemp-181114-024329
mgrtemp-181114-025525
mgrtemp-181114-030712
mgrtemp-181114-031907
mgrtemp-181114-033103
mgrtemp-181114-034228
mgrtemp-181114-035401
mgrtemp-181114-040532
mgrtemp-181114-041719
mgrtemp-181114-042915
mgrtemp-181114-044111
mgrtemp-181114-045244
mgrtemp-181114-050425
mgrtemp-181114-051607
mgrtemp-181114-052748
mgrtemp-181114-053929
mgrtemp-181114-055110
mgrtemp-181114-060251
mgrtemp-181114-061432
mgrtemp-181114-062613
mgrtemp-181114-063754
mgrtemp-181114-064928
mgrtemp-181114-070116
mgrtemp-181114-071310
mgrtemp-181114-072451
mgrtemp-181114-073625
mgrtemp-181114-074740
mgrtemp-181114-075906
mgrtemp-181114-081041
mgrtemp-181114-082236
mgrtemp-181114-083431
mgrtemp-181114-084623
mgrtemp-181114-085834
mgrtemp-181114-091045
mgrtemp-181114-092256
mgrtemp-181114-093451
mgrtemp-181114-094646
mgrtemp-181114-095813
mgrtemp-181114-100947
mgrtemp-181114-102120
mgrtemp-181114-103241
mgrtemp-181114-104407
mgrtemp-181114-105543
mgrtemp-181114-110730
mgrtemp-181114-111903
mgrtemp-181114-113051
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181114/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
