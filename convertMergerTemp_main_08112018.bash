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
mgrtemp-181108-000111
mgrtemp-181108-000523
mgrtemp-181108-001225
mgrtemp-181108-001629
mgrtemp-181108-002331
mgrtemp-181108-002733
mgrtemp-181108-003512
mgrtemp-181108-003838
mgrtemp-181108-004654
mgrtemp-181108-004951
mgrtemp-181108-005838
mgrtemp-181108-010104
mgrtemp-181108-011019
mgrtemp-181108-011216
mgrtemp-181108-012201
mgrtemp-181108-012328
mgrtemp-181108-013344
mgrtemp-181108-013442
mgrtemp-181108-014527
mgrtemp-181108-014555
mgrtemp-181108-015651
mgrtemp-181108-015652
mgrtemp-181108-020731
mgrtemp-181108-020809
mgrtemp-181108-021839
mgrtemp-181108-022007
mgrtemp-181108-023000
mgrtemp-181108-023205
mgrtemp-181108-024120
mgrtemp-181108-024355
mgrtemp-181108-025233
mgrtemp-181108-025550
mgrtemp-181108-030350
mgrtemp-181108-030723
mgrtemp-181108-031503
mgrtemp-181108-031857
mgrtemp-181108-032615
mgrtemp-181108-033007
mgrtemp-181108-033731
mgrtemp-181108-034134
mgrtemp-181108-034845
mgrtemp-181108-035317
mgrtemp-181108-035958
mgrtemp-181108-040446
mgrtemp-181108-041057
mgrtemp-181108-041615
mgrtemp-181108-042157
mgrtemp-181108-042746
mgrtemp-181108-043311
mgrtemp-181108-043908
mgrtemp-181108-044417
mgrtemp-181108-045021
mgrtemp-181108-045516
mgrtemp-181108-050142
mgrtemp-181108-050622
mgrtemp-181108-051302
mgrtemp-181108-051727
mgrtemp-181108-052416
mgrtemp-181108-052826
mgrtemp-181108-053559
mgrtemp-181108-053931
mgrtemp-181108-054741
mgrtemp-181108-055030
mgrtemp-181108-055924
mgrtemp-181108-060135
mgrtemp-181108-061106
mgrtemp-181108-061249
mgrtemp-181108-062249
mgrtemp-181108-062403
mgrtemp-181108-063433
mgrtemp-181108-063516
mgrtemp-181108-064615
mgrtemp-181108-064626
mgrtemp-181108-065741
mgrtemp-181108-065753
mgrtemp-181108-070853
mgrtemp-181108-070937
mgrtemp-181108-072006
mgrtemp-181108-072120
mgrtemp-181108-073120
mgrtemp-181108-073303
mgrtemp-181108-074233
mgrtemp-181108-074445
mgrtemp-181108-075346
mgrtemp-181108-075627
mgrtemp-181108-080459
mgrtemp-181108-080809
mgrtemp-181108-081612
mgrtemp-181108-081949
mgrtemp-181108-082712
mgrtemp-181108-083131
mgrtemp-181108-083827
mgrtemp-181108-084305
mgrtemp-181108-084938
mgrtemp-181108-085425
mgrtemp-181108-090035
mgrtemp-181108-090549
mgrtemp-181108-091146
mgrtemp-181108-091726
mgrtemp-181108-092252
mgrtemp-181108-092842
mgrtemp-181108-093359
mgrtemp-181108-094003
mgrtemp-181108-094506
mgrtemp-181108-095117
mgrtemp-181108-095613
mgrtemp-181108-100243
mgrtemp-181108-100715
mgrtemp-181108-101411
mgrtemp-181108-101806
mgrtemp-181108-102554
mgrtemp-181108-102920
mgrtemp-181108-103737
mgrtemp-181108-104033
mgrtemp-181108-104919
mgrtemp-181108-105145
mgrtemp-181108-110101
mgrtemp-181108-110258
mgrtemp-181108-111244
mgrtemp-181108-111412
mgrtemp-181108-112426
mgrtemp-181108-112525
mgrtemp-181108-113609
mgrtemp-181108-113639
mgrtemp-181108-114733
mgrtemp-181108-114743
mgrtemp-181108-115856
mgrtemp-181108-115909
mgrtemp-181108-121009
mgrtemp-181108-121053
mgrtemp-181108-122116
mgrtemp-181108-122236
mgrtemp-181108-123230
mgrtemp-181108-123418
mgrtemp-181108-124341
mgrtemp-181108-124601
mgrtemp-181108-125454
mgrtemp-181108-125743
mgrtemp-181108-130607
mgrtemp-181108-130925
mgrtemp-181108-131720
mgrtemp-181108-132108
mgrtemp-181108-132833
mgrtemp-181108-133242
mgrtemp-181108-133946
mgrtemp-181108-134414
mgrtemp-181108-135048
mgrtemp-181108-135541
mgrtemp-181108-140143
mgrtemp-181108-140704
mgrtemp-181108-141237
mgrtemp-181108-141810
mgrtemp-181108-142342
mgrtemp-181108-142950
mgrtemp-181108-143429
mgrtemp-181108-144102
mgrtemp-181108-144534
mgrtemp-181108-145159
mgrtemp-181108-145647
mgrtemp-181108-150313
mgrtemp-181108-150759
mgrtemp-181108-151436
mgrtemp-181108-151908
mgrtemp-181108-152609
mgrtemp-181108-153011
mgrtemp-181108-153734
mgrtemp-181108-154122
mgrtemp-181108-154901
mgrtemp-181108-155234
mgrtemp-181108-160036
mgrtemp-181108-160339
mgrtemp-181108-161203
mgrtemp-181108-161443
mgrtemp-181108-162343
mgrtemp-181108-162555
mgrtemp-181108-163517
mgrtemp-181108-163659
mgrtemp-181108-164657
mgrtemp-181108-164822
mgrtemp-181108-165857
mgrtemp-181108-165948
mgrtemp-181108-171042
mgrtemp-181108-171044
mgrtemp-181108-172141
mgrtemp-181108-172224
mgrtemp-181108-173259
mgrtemp-181108-173413
mgrtemp-181108-174418
mgrtemp-181108-174608
mgrtemp-181108-175801
mgrtemp-181108-180032
mgrtemp-181108-181131
mgrtemp-181108-181558
mgrtemp-181108-182457
mgrtemp-181108-183110
mgrtemp-181108-183828
mgrtemp-181108-184655
mgrtemp-181108-185159
mgrtemp-181108-190221
mgrtemp-181108-190532
mgrtemp-181108-191750
mgrtemp-181108-191915
mgrtemp-181108-193128
mgrtemp-181108-193145
mgrtemp-181108-194443
mgrtemp-181108-194651
mgrtemp-181108-195817
mgrtemp-181108-200215
mgrtemp-181108-201142
mgrtemp-181108-201737
mgrtemp-181108-202513
mgrtemp-181108-203318
mgrtemp-181108-203845
mgrtemp-181108-204829
mgrtemp-181108-205224
mgrtemp-181108-210348
mgrtemp-181108-210605
mgrtemp-181108-211757
mgrtemp-181108-211759
mgrtemp-181108-213126
mgrtemp-181108-213318
mgrtemp-181108-214501
mgrtemp-181108-214830
mgrtemp-181108-215843
mgrtemp-181108-220348
mgrtemp-181108-221214
mgrtemp-181108-221901
mgrtemp-181108-222546
mgrtemp-181108-223411
mgrtemp-181108-223912
mgrtemp-181108-224933
mgrtemp-181108-225248
mgrtemp-181108-230448
mgrtemp-181108-230614
mgrtemp-181108-231835
mgrtemp-181108-231853
mgrtemp-181108-233232
mgrtemp-181108-233331
mgrtemp-181108-234523
mgrtemp-181108-234826
mgrtemp-181108-235855
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181108/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
