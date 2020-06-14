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
mgrtemp-181117-152237
mgrtemp-181117-153328
mgrtemp-181117-154429
mgrtemp-181117-155537
mgrtemp-181117-160629
mgrtemp-181117-161735
mgrtemp-181117-162858
mgrtemp-181117-164043
mgrtemp-181117-165210
mgrtemp-181117-170337
mgrtemp-181117-171527
mgrtemp-181117-172702
mgrtemp-181117-173837
mgrtemp-181117-175033
mgrtemp-181117-180230
mgrtemp-181117-181420
mgrtemp-181117-182602
mgrtemp-181117-183737
mgrtemp-181117-184924
mgrtemp-181117-190107
mgrtemp-181117-191248
mgrtemp-181117-192430
mgrtemp-181117-193551
mgrtemp-181117-194719
mgrtemp-181117-195840
mgrtemp-181117-201022
mgrtemp-181117-202149
mgrtemp-181117-203317
mgrtemp-181117-204459
mgrtemp-181117-205641
mgrtemp-181117-210838
mgrtemp-181117-212011
mgrtemp-181117-213152
mgrtemp-181117-214327
mgrtemp-181117-215503
mgrtemp-181117-220630
mgrtemp-181117-221813
mgrtemp-181117-222956
mgrtemp-181117-224139
mgrtemp-181117-225321
mgrtemp-181117-230504
mgrtemp-181117-231647
mgrtemp-181117-232829
mgrtemp-181117-234011
mgrtemp-181117-235137
mgrtemp-181118-000321
mgrtemp-181118-001503
mgrtemp-181118-002646
mgrtemp-181118-003826
mgrtemp-181118-005022
mgrtemp-181118-010219
mgrtemp-181118-011416
mgrtemp-181118-012610
mgrtemp-181118-013754
mgrtemp-181118-014934
mgrtemp-181118-020130
mgrtemp-181118-021319
mgrtemp-181118-022514
mgrtemp-181118-023646
mgrtemp-181118-024819
mgrtemp-181118-030007
mgrtemp-181118-031155
mgrtemp-181118-032336
mgrtemp-181118-033516
mgrtemp-181118-034658
mgrtemp-181118-035832
mgrtemp-181118-041013
mgrtemp-181118-042147
mgrtemp-181118-043328
mgrtemp-181118-044509
mgrtemp-181118-045649
mgrtemp-181118-050817
mgrtemp-181118-051959
mgrtemp-181118-053137
mgrtemp-181118-054311
mgrtemp-181118-055445
mgrtemp-181118-060618
mgrtemp-181118-061814
mgrtemp-181118-062954
mgrtemp-181118-064136
mgrtemp-181118-065317
mgrtemp-181118-070458
mgrtemp-181118-071638
mgrtemp-181118-072819
mgrtemp-181118-074014
mgrtemp-181118-075209
mgrtemp-181118-080404
mgrtemp-181118-081539
mgrtemp-181118-082719
mgrtemp-181118-083850
mgrtemp-181118-085022
mgrtemp-181118-090155
mgrtemp-181118-091326
mgrtemp-181118-092453
mgrtemp-181118-093631
mgrtemp-181118-094819
mgrtemp-181118-100000
mgrtemp-181118-101141
mgrtemp-181118-102312
mgrtemp-181118-103445
mgrtemp-181118-104612
mgrtemp-181118-105747
mgrtemp-181118-110913
mgrtemp-181118-112049
mgrtemp-181118-113237
mgrtemp-181118-114411
mgrtemp-181118-115552
mgrtemp-181118-120724
mgrtemp-181118-121858
mgrtemp-181118-123039
mgrtemp-181118-124220
mgrtemp-181118-125401
mgrtemp-181118-130534
mgrtemp-181118-131715
mgrtemp-181118-132848
mgrtemp-181118-134028
mgrtemp-181118-135210
mgrtemp-181118-140345
mgrtemp-181118-141523
mgrtemp-181118-142704
mgrtemp-181118-143838
mgrtemp-181118-145017
mgrtemp-181118-150157
mgrtemp-181118-151322
mgrtemp-181118-152449
mgrtemp-181118-153609
mgrtemp-181118-154726
mgrtemp-181118-155854
mgrtemp-181118-161036
mgrtemp-181118-162217
mgrtemp-181118-163358
mgrtemp-181118-164539
mgrtemp-181118-165712
mgrtemp-181118-170852
mgrtemp-181118-172033
mgrtemp-181118-173213
mgrtemp-181118-174354
mgrtemp-181118-175535
mgrtemp-181118-180715
mgrtemp-181118-181833
mgrtemp-181118-183007
mgrtemp-181118-184148
mgrtemp-181118-185310
mgrtemp-181118-190436
mgrtemp-181118-191630
mgrtemp-181118-192804
mgrtemp-181118-193945
mgrtemp-181118-195126
mgrtemp-181118-200258
mgrtemp-181118-201408
mgrtemp-181118-202526
mgrtemp-181118-203637
mgrtemp-181118-204818
mgrtemp-181118-205952
mgrtemp-181118-211127
mgrtemp-181118-212305
mgrtemp-181118-213444
mgrtemp-181118-214640
mgrtemp-181118-215835
mgrtemp-181118-221023
mgrtemp-181118-222219
mgrtemp-181118-223414
mgrtemp-181118-224609
mgrtemp-181118-225804
mgrtemp-181118-230959
mgrtemp-181118-232133
mgrtemp-181118-233313
mgrtemp-181118-234446
mgrtemp-181118-235606
mgrtemp-181119-000732
mgrtemp-181119-001900
mgrtemp-181119-003042
mgrtemp-181119-004221
mgrtemp-181119-005354
mgrtemp-181119-010535
mgrtemp-181119-011731
mgrtemp-181119-012857
mgrtemp-181119-014022
mgrtemp-181119-015202
mgrtemp-181119-020348
mgrtemp-181119-021536
mgrtemp-181119-022731
mgrtemp-181119-023926
mgrtemp-181119-025114
mgrtemp-181119-030303
mgrtemp-181119-031422
mgrtemp-181119-032556
mgrtemp-181119-033750
mgrtemp-181119-034946
mgrtemp-181119-040141
mgrtemp-181119-041329
mgrtemp-181119-042517
mgrtemp-181119-043655
mgrtemp-181119-044836
mgrtemp-181119-045953
mgrtemp-181119-051127
mgrtemp-181119-052308
mgrtemp-181119-053443
mgrtemp-181119-054605
mgrtemp-181119-055747
mgrtemp-181119-060928
mgrtemp-181119-062122
mgrtemp-181119-063318
mgrtemp-181119-064513
mgrtemp-181119-065701
mgrtemp-181119-070848
mgrtemp-181119-072044
mgrtemp-181119-073210
mgrtemp-181119-074319
mgrtemp-181119-075500
mgrtemp-181119-080657
mgrtemp-181119-081823
mgrtemp-181119-083012
mgrtemp-181119-084200
mgrtemp-181119-085349
mgrtemp-181119-090530
mgrtemp-181119-091721
mgrtemp-181119-092849
mgrtemp-181119-094016
mgrtemp-181119-095150
)

# convertion form array
rawDataFolder="./data-181119/"
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
