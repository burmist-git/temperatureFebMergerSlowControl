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

# Sun Nov 18 14:15:39 JST 2018
inDataFileNameArr=(
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
mgrtemp-181116-154903
mgrtemp-181116-160037
mgrtemp-181116-161218
mgrtemp-181116-162359
mgrtemp-181116-163533
mgrtemp-181116-164707
mgrtemp-181116-165849
mgrtemp-181116-171029
mgrtemp-181116-172205
mgrtemp-181116-173347
mgrtemp-181116-174529
mgrtemp-181116-175725
mgrtemp-181116-180922
mgrtemp-181116-182118
mgrtemp-181116-183245
mgrtemp-181116-184412
mgrtemp-181116-185555
mgrtemp-181116-190734
mgrtemp-181116-191929
mgrtemp-181116-193117
mgrtemp-181116-194250
mgrtemp-181116-195439
mgrtemp-181116-200604
mgrtemp-181116-201730
mgrtemp-181116-202903
mgrtemp-181116-204022
mgrtemp-181116-205148
mgrtemp-181116-210323
mgrtemp-181116-211448
mgrtemp-181116-212621
mgrtemp-181116-213802
mgrtemp-181116-214943
mgrtemp-181116-220122
mgrtemp-181116-221318
mgrtemp-181116-222514
mgrtemp-181116-223647
mgrtemp-181116-224843
mgrtemp-181116-230038
mgrtemp-181116-231235
mgrtemp-181116-232422
mgrtemp-181116-233617
mgrtemp-181116-234813
mgrtemp-181117-000008
mgrtemp-181117-001143
mgrtemp-181117-002316
mgrtemp-181117-003449
mgrtemp-181117-004630
mgrtemp-181117-005811
mgrtemp-181117-010944
mgrtemp-181117-012125
mgrtemp-181117-013305
mgrtemp-181117-014500
mgrtemp-181117-015655
mgrtemp-181117-020843
mgrtemp-181117-022021
mgrtemp-181117-023204
mgrtemp-181117-024342
mgrtemp-181117-025530
mgrtemp-181117-030725
mgrtemp-181117-031843
mgrtemp-181117-033026
mgrtemp-181117-034158
mgrtemp-181117-035324
mgrtemp-181117-040458
mgrtemp-181117-041631
mgrtemp-181117-042826
mgrtemp-181117-044000
mgrtemp-181117-045156
mgrtemp-181117-050351
mgrtemp-181117-051545
mgrtemp-181117-052740
mgrtemp-181117-053935
mgrtemp-181117-055123
mgrtemp-181117-060256
mgrtemp-181117-061430
mgrtemp-181117-062556
mgrtemp-181117-063753
mgrtemp-181117-064949
mgrtemp-181117-070123
mgrtemp-181117-071318
mgrtemp-181117-072512
mgrtemp-181117-073653
mgrtemp-181117-074826
mgrtemp-181117-080021
mgrtemp-181117-081209
mgrtemp-181117-082313
mgrtemp-181117-083447
mgrtemp-181117-084633
mgrtemp-181117-085801
mgrtemp-181117-090937
mgrtemp-181117-092117
mgrtemp-181117-093259
mgrtemp-181117-094440
mgrtemp-181117-095622
mgrtemp-181117-100803
mgrtemp-181117-101944
mgrtemp-181117-103125
mgrtemp-181117-104305
mgrtemp-181117-105439
mgrtemp-181117-110550
mgrtemp-181117-111717
mgrtemp-181117-112858
mgrtemp-181117-114025
mgrtemp-181117-115213
mgrtemp-181117-120354
mgrtemp-181117-121521
mgrtemp-181117-122654
mgrtemp-181117-123836
mgrtemp-181117-124938
mgrtemp-181117-130057
mgrtemp-181117-131244
mgrtemp-181117-132440
mgrtemp-181117-133634
mgrtemp-181117-134809
mgrtemp-181117-140004
mgrtemp-181117-141159
mgrtemp-181117-142354
mgrtemp-181117-143549
mgrtemp-181117-144745
mgrtemp-181117-145927
mgrtemp-181117-151109
)

# convertion form array
rawDataFolder="./data-181117/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1

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
