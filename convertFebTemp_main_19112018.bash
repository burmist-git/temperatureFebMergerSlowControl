#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)            a     #
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

# Mon Nov 19 11:22:51 JST 2018
inDataFileNameArr=(
febtemp-181117-000008
febtemp-181117-001143
febtemp-181117-002316
febtemp-181117-003449
febtemp-181117-004630
febtemp-181117-005811
febtemp-181117-010944
febtemp-181117-012125
febtemp-181117-013305
febtemp-181117-014500
febtemp-181117-015655
febtemp-181117-020843
febtemp-181117-022021
febtemp-181117-023204
febtemp-181117-024342
febtemp-181117-025530
febtemp-181117-030725
febtemp-181117-031843
febtemp-181117-033026
febtemp-181117-034158
febtemp-181117-035324
febtemp-181117-040458
febtemp-181117-041631
febtemp-181117-042826
febtemp-181117-044000
febtemp-181117-045156
febtemp-181117-050351
febtemp-181117-051545
febtemp-181117-052740
febtemp-181117-053935
febtemp-181117-055123
febtemp-181117-060256
febtemp-181117-061430
febtemp-181117-062556
febtemp-181117-063753
febtemp-181117-064949
febtemp-181117-070123
febtemp-181117-071318
febtemp-181117-072512
febtemp-181117-073653
febtemp-181117-074826
febtemp-181117-080021
febtemp-181117-081209
febtemp-181117-082313
febtemp-181117-083447
febtemp-181117-084633
febtemp-181117-085801
febtemp-181117-090937
febtemp-181117-092117
febtemp-181117-093259
febtemp-181117-094440
febtemp-181117-095622
febtemp-181117-100803
febtemp-181117-101944
febtemp-181117-103125
febtemp-181117-104305
febtemp-181117-105439
febtemp-181117-110550
febtemp-181117-111717
febtemp-181117-112858
febtemp-181117-114025
febtemp-181117-115213
febtemp-181117-120354
febtemp-181117-121521
febtemp-181117-122654
febtemp-181117-123836
febtemp-181117-124938
febtemp-181117-130057
febtemp-181117-131244
febtemp-181117-132440
febtemp-181117-133634
febtemp-181117-134809
febtemp-181117-140004
febtemp-181117-141159
febtemp-181117-142354
febtemp-181117-143549
febtemp-181117-144745
febtemp-181117-145927
febtemp-181117-151109
febtemp-181117-152237
febtemp-181117-153328
febtemp-181117-154429
febtemp-181117-155537
febtemp-181117-160629
febtemp-181117-161735
febtemp-181117-162858
febtemp-181117-164043
febtemp-181117-165210
febtemp-181117-170337
febtemp-181117-171527
febtemp-181117-172702
febtemp-181117-173837
febtemp-181117-175033
febtemp-181117-180230
febtemp-181117-181420
febtemp-181117-182602
febtemp-181117-183737
febtemp-181117-184924
febtemp-181117-190107
febtemp-181117-191248
febtemp-181117-192430
febtemp-181117-193551
febtemp-181117-194719
febtemp-181117-195840
febtemp-181117-201022
febtemp-181117-202149
febtemp-181117-203317
febtemp-181117-204459
febtemp-181117-205641
febtemp-181117-210838
febtemp-181117-212011
febtemp-181117-213152
febtemp-181117-214327
febtemp-181117-215503
febtemp-181117-220630
febtemp-181117-221813
febtemp-181117-222956
febtemp-181117-224139
febtemp-181117-225321
febtemp-181117-230504
febtemp-181117-231647
febtemp-181117-232829
febtemp-181117-234011
febtemp-181117-235137
febtemp-181118-000321
febtemp-181118-001503
febtemp-181118-002646
febtemp-181118-003826
febtemp-181118-005022
febtemp-181118-010219
febtemp-181118-011416
febtemp-181118-012610
febtemp-181118-013754
febtemp-181118-014934
febtemp-181118-020130
febtemp-181118-021319
febtemp-181118-022514
febtemp-181118-023646
febtemp-181118-024819
febtemp-181118-030007
febtemp-181118-031155
febtemp-181118-032336
febtemp-181118-033516
febtemp-181118-034658
febtemp-181118-035832
febtemp-181118-041013
febtemp-181118-042147
febtemp-181118-043328
febtemp-181118-044509
febtemp-181118-045649
febtemp-181118-050817
febtemp-181118-051959
febtemp-181118-053137
febtemp-181118-054311
febtemp-181118-055445
febtemp-181118-060618
febtemp-181118-061814
febtemp-181118-062954
febtemp-181118-064136
febtemp-181118-065317
febtemp-181118-070458
febtemp-181118-071638
febtemp-181118-072819
febtemp-181118-074014
febtemp-181118-075209
febtemp-181118-080404
febtemp-181118-081539
febtemp-181118-082719
febtemp-181118-083850
febtemp-181118-085022
febtemp-181118-090155
febtemp-181118-091326
febtemp-181118-092453
febtemp-181118-093631
febtemp-181118-094819
febtemp-181118-100000
febtemp-181118-101141
febtemp-181118-102312
febtemp-181118-103445
febtemp-181118-104612
febtemp-181118-105747
febtemp-181118-110913
febtemp-181118-112049
febtemp-181118-113237
febtemp-181118-114411
febtemp-181118-115552
febtemp-181118-120724
febtemp-181118-121858
febtemp-181118-123039
febtemp-181118-124220
febtemp-181118-125401
febtemp-181118-130534
febtemp-181118-131715
febtemp-181118-132848
febtemp-181118-134028
febtemp-181118-135210
febtemp-181118-140345
febtemp-181118-141523
febtemp-181118-142704
febtemp-181118-143838
febtemp-181118-145017
febtemp-181118-150157
febtemp-181118-151322
febtemp-181118-152449
febtemp-181118-153609
febtemp-181118-154726
febtemp-181118-155854
febtemp-181118-161036
febtemp-181118-162217
febtemp-181118-163358
febtemp-181118-164539
febtemp-181118-165712
febtemp-181118-170852
febtemp-181118-172033
febtemp-181118-173213
febtemp-181118-174354
febtemp-181118-175535
febtemp-181118-180715
febtemp-181118-181833
febtemp-181118-183007
febtemp-181118-184148
febtemp-181118-185310
febtemp-181118-190436
febtemp-181118-191630
febtemp-181118-192804
febtemp-181118-193945
febtemp-181118-195126
febtemp-181118-200258
febtemp-181118-201408
febtemp-181118-202526
febtemp-181118-203637
febtemp-181118-204818
febtemp-181118-205952
febtemp-181118-211127
febtemp-181118-212305
febtemp-181118-213444
febtemp-181118-214640
febtemp-181118-215835
febtemp-181118-221023
febtemp-181118-222219
febtemp-181118-223414
febtemp-181118-224609
febtemp-181118-225804
febtemp-181118-230959
febtemp-181118-232133
febtemp-181118-233313
febtemp-181118-234446
febtemp-181118-235606
febtemp-181119-000732
febtemp-181119-001900
febtemp-181119-003042
febtemp-181119-004221
febtemp-181119-005354
febtemp-181119-010535
febtemp-181119-011731
febtemp-181119-012857
febtemp-181119-014022
febtemp-181119-015202
febtemp-181119-020348
febtemp-181119-021536
febtemp-181119-022731
febtemp-181119-023926
febtemp-181119-025114
febtemp-181119-030303
febtemp-181119-031422
febtemp-181119-032556
febtemp-181119-033750
febtemp-181119-034946
febtemp-181119-040141
febtemp-181119-041329
febtemp-181119-042517
febtemp-181119-043655
febtemp-181119-044836
febtemp-181119-045953
febtemp-181119-051127
febtemp-181119-052308
febtemp-181119-053443
febtemp-181119-054605
febtemp-181119-055747
febtemp-181119-060928
febtemp-181119-062122
febtemp-181119-063318
febtemp-181119-064513
febtemp-181119-065701
febtemp-181119-070848
febtemp-181119-072044
febtemp-181119-073210
febtemp-181119-074319
febtemp-181119-075500
febtemp-181119-080657
febtemp-181119-081823
febtemp-181119-083012
febtemp-181119-084200
febtemp-181119-085349
febtemp-181119-090530
febtemp-181119-091721
febtemp-181119-092849
febtemp-181119-094016
febtemp-181119-095150
)

rawDataFolder="./data-181119/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1

function convertFebTemp_main_bash {

    ./convertFebTemp_main $1 $2 $3 $4
    
}

function cleanTmpData {

    rm -rf $rawDataFolder/*.pdf
    rm -rf $rawDataFolder/*.root
    rm -rf $rawDataFolder/*.log
    
}

function convertArr {
    singlePlotPdfListh2febt1pdf=""
    singlePlotPdfListh2febt2pdf=""
    singlePlotPdfListh1febt1pdf=""
    singlePlotPdfListh1febt2pdf=""
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

    echo "---> mearge to single pdf of h2 t1 : $singlePlotPdfListh2febt1pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt1pdf $singlePlotPdfListh2febt1pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h2 t2 : $singlePlotPdfListh2febt2pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt2pdf $singlePlotPdfListh2febt2pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h1 t1 : $singlePlotPdfListh1febt1pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt1pdf $singlePlotPdfListh1febt1pdf > /dev/null 2>&1
    echo "---> mearge to single pdf of h1 t2 : $singlePlotPdfListh1febt2pdf"
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt2pdf $singlePlotPdfListh1febt2pdf > /dev/null 2>&1

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

#cleanTmpData
convertArr
mergeArr

espeak "I have done"
