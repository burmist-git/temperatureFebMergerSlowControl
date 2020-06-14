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

    ./convertMergerTemp_main $1 $2 $3 $4
    
}

function convertArr {

    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	numberOfSectors=`more $fileIn | grep Reading | grep FPGA | grep system | grep temp | wc -l`
	if [ "$numberOfLines" -eq "97" ]
	then
	    #outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}'_board.pdf'
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

	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	#nLines $fileIn
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "97" ]
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
	if [ "$numberOfLines" -ne "97" ]
	then
	    echo $numberOfLines
	fi
	
    done
    
}

# Tue Nov  6 19:15:16 JST 2018
inDataFileNameArr=(
mgrtemp-181102-113247
mgrtemp-181102-114317
mgrtemp-181102-115345
mgrtemp-181102-120413
mgrtemp-181102-121442
mgrtemp-181102-122510
mgrtemp-181102-123540
mgrtemp-181102-124608
mgrtemp-181102-125637
mgrtemp-181102-130706
mgrtemp-181102-131736
mgrtemp-181102-132804
mgrtemp-181102-133834
mgrtemp-181102-134902
mgrtemp-181102-135925
mgrtemp-181102-140954
mgrtemp-181102-142023
mgrtemp-181102-143051
mgrtemp-181102-144120
mgrtemp-181102-145149
mgrtemp-181102-150218
mgrtemp-181102-151247
mgrtemp-181102-152317
mgrtemp-181102-153345
mgrtemp-181102-154415
mgrtemp-181102-155443
mgrtemp-181102-160512
mgrtemp-181102-161541
mgrtemp-181102-162610
mgrtemp-181102-163639
mgrtemp-181102-164709
mgrtemp-181102-165737
mgrtemp-181102-170806
mgrtemp-181102-171835
mgrtemp-181102-172904
mgrtemp-181102-173933
mgrtemp-181102-175002
mgrtemp-181102-180031
mgrtemp-181102-181100
mgrtemp-181102-182129
mgrtemp-181102-183158
mgrtemp-181102-184226
mgrtemp-181102-185255
mgrtemp-181102-190324
mgrtemp-181102-191353
mgrtemp-181102-192422
mgrtemp-181102-193451
mgrtemp-181102-194522
mgrtemp-181102-195551
mgrtemp-181102-200619
mgrtemp-181102-201647
mgrtemp-181102-202716
mgrtemp-181102-203745
mgrtemp-181102-204813
mgrtemp-181102-205842
mgrtemp-181102-210917
mgrtemp-181102-211948
mgrtemp-181102-213026
mgrtemp-181102-214056
mgrtemp-181102-215124
mgrtemp-181102-220153
mgrtemp-181102-221222
mgrtemp-181102-222252
mgrtemp-181102-223320
mgrtemp-181102-224350
mgrtemp-181102-225418
mgrtemp-181102-230447
mgrtemp-181102-231516
mgrtemp-181102-232538
mgrtemp-181102-233607
mgrtemp-181102-234636
mgrtemp-181102-235705
mgrtemp-181103-000733
mgrtemp-181103-001802
mgrtemp-181103-002831
mgrtemp-181103-003900
mgrtemp-181103-004929
mgrtemp-181103-005958
mgrtemp-181103-011027
mgrtemp-181103-012056
mgrtemp-181103-013126
mgrtemp-181103-014154
mgrtemp-181103-015223
mgrtemp-181103-020252
mgrtemp-181103-021321
mgrtemp-181103-022350
mgrtemp-181103-023419
mgrtemp-181103-024448
mgrtemp-181103-025518
mgrtemp-181103-030546
mgrtemp-181103-031615
mgrtemp-181103-032644
mgrtemp-181103-033713
mgrtemp-181103-034741
mgrtemp-181103-035811
mgrtemp-181103-040839
mgrtemp-181103-041908
mgrtemp-181103-042937
mgrtemp-181103-044006
mgrtemp-181103-045035
mgrtemp-181103-050104
mgrtemp-181103-051132
mgrtemp-181103-052201
mgrtemp-181103-053230
mgrtemp-181103-054259
mgrtemp-181103-055328
mgrtemp-181103-060357
mgrtemp-181103-061425
mgrtemp-181103-062454
mgrtemp-181103-063523
mgrtemp-181103-064552
mgrtemp-181103-065621
mgrtemp-181103-070650
mgrtemp-181103-071719
mgrtemp-181103-072748
mgrtemp-181103-073816
mgrtemp-181103-074845
mgrtemp-181103-075914
mgrtemp-181103-080943
mgrtemp-181103-082011
mgrtemp-181103-083040
mgrtemp-181103-084109
mgrtemp-181103-085138
mgrtemp-181103-090207
mgrtemp-181103-091236
mgrtemp-181103-092304
mgrtemp-181103-093333
mgrtemp-181103-094402
mgrtemp-181103-095431
mgrtemp-181103-100500
mgrtemp-181103-101528
mgrtemp-181103-102557
mgrtemp-181103-103627
mgrtemp-181103-104655
mgrtemp-181103-105724
mgrtemp-181103-110753
mgrtemp-181103-111822
mgrtemp-181103-112850
mgrtemp-181103-113919
mgrtemp-181103-114948
mgrtemp-181103-120017
mgrtemp-181103-121046
mgrtemp-181103-122115
mgrtemp-181103-123143
mgrtemp-181103-124213
mgrtemp-181103-125241
mgrtemp-181103-130311
mgrtemp-181103-131337
mgrtemp-181103-132417
mgrtemp-181103-133445
mgrtemp-181103-134513
mgrtemp-181103-135542
mgrtemp-181103-140611
mgrtemp-181103-141640
mgrtemp-181103-142709
mgrtemp-181103-143738
mgrtemp-181103-144806
mgrtemp-181103-145835
mgrtemp-181103-150904
mgrtemp-181103-151933
mgrtemp-181103-153002
mgrtemp-181103-154031
mgrtemp-181103-155059
mgrtemp-181103-160128
mgrtemp-181103-161157
mgrtemp-181103-162226
mgrtemp-181103-163254
mgrtemp-181103-164324
mgrtemp-181103-165352
mgrtemp-181103-170421
mgrtemp-181103-171450
mgrtemp-181103-172519
mgrtemp-181103-173548
mgrtemp-181103-174616
mgrtemp-181103-175645
mgrtemp-181103-180714
mgrtemp-181103-181743
mgrtemp-181103-182812
mgrtemp-181103-183840
mgrtemp-181103-184909
mgrtemp-181103-185938
mgrtemp-181103-191007
mgrtemp-181103-192059
mgrtemp-181103-193148
mgrtemp-181103-194238
mgrtemp-181103-195328
mgrtemp-181103-200418
mgrtemp-181103-201509
mgrtemp-181103-202559
mgrtemp-181103-203649
mgrtemp-181103-204738
mgrtemp-181103-205829
mgrtemp-181103-210919
mgrtemp-181103-212009
mgrtemp-181103-213100
mgrtemp-181103-214142
mgrtemp-181103-215224
mgrtemp-181103-220246
mgrtemp-181103-221308
mgrtemp-181103-222342
mgrtemp-181103-223403
mgrtemp-181103-224507
mgrtemp-181103-225542
mgrtemp-181103-230617
mgrtemp-181103-231701
mgrtemp-181103-232752
mgrtemp-181103-233842
mgrtemp-181103-234932
mgrtemp-181104-000015
mgrtemp-181104-001058
mgrtemp-181104-002125
mgrtemp-181104-003207
mgrtemp-181104-004258
mgrtemp-181104-005348
mgrtemp-181104-010438
mgrtemp-181104-011529
mgrtemp-181104-012612
mgrtemp-181104-013655
mgrtemp-181104-014744
mgrtemp-181104-015834
mgrtemp-181104-020924
mgrtemp-181104-022015
mgrtemp-181104-023058
mgrtemp-181104-024142
mgrtemp-181104-025224
mgrtemp-181104-030314
mgrtemp-181104-031405
mgrtemp-181104-032456
mgrtemp-181104-033545
mgrtemp-181104-034635
mgrtemp-181104-035725
mgrtemp-181104-040815
mgrtemp-181104-041858
mgrtemp-181104-042948
mgrtemp-181104-044033
mgrtemp-181104-045125
mgrtemp-181104-050208
mgrtemp-181104-051258
mgrtemp-181104-052348
mgrtemp-181104-053438
mgrtemp-181104-054527
mgrtemp-181104-055618
mgrtemp-181104-060708
mgrtemp-181104-061758
mgrtemp-181104-062849
mgrtemp-181104-063939
mgrtemp-181104-065028
mgrtemp-181104-070119
mgrtemp-181104-071209
mgrtemp-181104-072251
mgrtemp-181104-073334
mgrtemp-181104-074417
mgrtemp-181104-075507
mgrtemp-181104-080558
mgrtemp-181104-081648
mgrtemp-181104-082738
mgrtemp-181104-083828
mgrtemp-181104-084918
mgrtemp-181104-090008
mgrtemp-181104-091051
mgrtemp-181104-092134
mgrtemp-181104-093216
mgrtemp-181104-094306
mgrtemp-181104-095357
mgrtemp-181104-100448
mgrtemp-181104-101539
mgrtemp-181104-102628
mgrtemp-181104-103718
mgrtemp-181104-104808
mgrtemp-181104-105859
mgrtemp-181104-110941
mgrtemp-181104-112025
mgrtemp-181104-113051
mgrtemp-181104-114134
mgrtemp-181104-115224
mgrtemp-181104-120315
mgrtemp-181104-121405
mgrtemp-181104-122455
mgrtemp-181104-123546
mgrtemp-181104-124636
mgrtemp-181104-125725
mgrtemp-181104-130816
mgrtemp-181104-131906
mgrtemp-181104-132956
mgrtemp-181104-134047
mgrtemp-181104-135138
mgrtemp-181104-140219
mgrtemp-181104-141310
mgrtemp-181104-142401
mgrtemp-181104-143443
mgrtemp-181104-144533
mgrtemp-181104-145615
mgrtemp-181104-150719
mgrtemp-181104-151802
mgrtemp-181104-152906
mgrtemp-181104-153930
mgrtemp-181104-155012
mgrtemp-181104-160055
mgrtemp-181104-161145
mgrtemp-181104-162228
mgrtemp-181104-163318
mgrtemp-181104-164408
mgrtemp-181104-165459
mgrtemp-181104-170548
mgrtemp-181104-171638
mgrtemp-181104-172728
mgrtemp-181104-173811
mgrtemp-181104-174902
mgrtemp-181104-175952
mgrtemp-181104-181043
mgrtemp-181104-182133
mgrtemp-181104-183224
mgrtemp-181104-184315
mgrtemp-181104-185403
mgrtemp-181104-190454
mgrtemp-181104-191544
mgrtemp-181104-192634
mgrtemp-181104-193724
mgrtemp-181104-194815
mgrtemp-181104-195904
mgrtemp-181104-200954
mgrtemp-181104-202044
mgrtemp-181104-203135
mgrtemp-181104-204225
mgrtemp-181104-205316
mgrtemp-181104-210405
mgrtemp-181104-211455
mgrtemp-181104-212545
mgrtemp-181104-213628
mgrtemp-181104-214718
mgrtemp-181104-215809
mgrtemp-181104-220859
mgrtemp-181104-221949
mgrtemp-181104-223039
mgrtemp-181104-224131
mgrtemp-181104-225220
mgrtemp-181104-230309
mgrtemp-181104-231400
mgrtemp-181104-232450
mgrtemp-181104-233540
mgrtemp-181104-234631
mgrtemp-181104-235720
mgrtemp-181105-000810
mgrtemp-181105-001901
mgrtemp-181105-002951
mgrtemp-181105-004041
mgrtemp-181105-005132
mgrtemp-181105-010221
mgrtemp-181105-011311
mgrtemp-181105-012401
mgrtemp-181105-013451
mgrtemp-181105-014541
mgrtemp-181105-015632
mgrtemp-181105-020722
mgrtemp-181105-021811
mgrtemp-181105-022902
mgrtemp-181105-023952
mgrtemp-181105-025042
mgrtemp-181105-030133
mgrtemp-181105-031222
mgrtemp-181105-032312
mgrtemp-181105-033402
mgrtemp-181105-034445
mgrtemp-181105-035534
mgrtemp-181105-040625
mgrtemp-181105-041715
mgrtemp-181105-042806
mgrtemp-181105-043848
mgrtemp-181105-044932
mgrtemp-181105-050014
mgrtemp-181105-051104
mgrtemp-181105-052155
mgrtemp-181105-053245
mgrtemp-181105-054334
mgrtemp-181105-055424
mgrtemp-181105-060515
mgrtemp-181105-061605
mgrtemp-181105-062655
mgrtemp-181105-063746
mgrtemp-181105-064835
mgrtemp-181105-065925
mgrtemp-181105-071015
mgrtemp-181105-072058
mgrtemp-181105-073149
mgrtemp-181105-074240
mgrtemp-181105-075330
mgrtemp-181105-080420
mgrtemp-181105-081511
mgrtemp-181105-082601
mgrtemp-181105-083650
mgrtemp-181105-084740
mgrtemp-181105-085831
mgrtemp-181105-090914
mgrtemp-181105-091944
mgrtemp-181105-093026
mgrtemp-181105-094109
mgrtemp-181105-095201
mgrtemp-181105-100243
mgrtemp-181105-101327
)

#nLinesArr
# convertion form array
rawDataFolder="./data-181106/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
