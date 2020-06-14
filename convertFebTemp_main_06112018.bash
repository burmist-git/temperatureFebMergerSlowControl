#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
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

function convertFebTemp_main_bash {

    ./convertFebTemp_main $1 $2 $3 $4
    
}

function convertArr {
    singlePlotPdfList=""
    for i in `seq 0 $nn`;
    do
	
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	echo $fileIn
	echo $numberOfLines
	numberOfSectors=`more $fileIn | grep Reading | grep FEB | grep temp | wc -l`
	if [ "$numberOfLines" -eq "433" ]
	then
	    outPdfFileName=$rawDataFolder${inDataFileNameArr[$i]}.'pdf'
	    #echo $fileIn
	    convertFebTemp_main_bash 0 $fileIn $outPdfFileName $numberOfSectors | tee $fileIn'.log'
	    singlePlotPdfList="$singlePlotPdfList $outPdfFileName"
	fi
    done
    
    mergedPdfOutFile="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.pdf"
    #echo $mergedPdfOutFile
    #echo $singlePlotPdfList
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFile $singlePlotPdfList
    echo $mergedPdfOutFile
}

function mergeArr {
    
    inRootHistFileList=""
    for i in `seq 0 $nn`;
    do
	fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	numberOfLines=`more $fileIn | wc -l`
	if [ "$numberOfLines" -eq "433" ]
	then	
	    inRootFileName=$rawDataFolder${inDataFileNameArr[$i]}.'root'
	    inRootHistFileList="$inRootHistFileList $inRootFileName"
	fi
    done
    outRootFileName="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}.root"
    echo $outRootHistFileList
    ./convertFebTemp_main 1 $outRootFileName $inRootHistFileList
    
}

# Tue Nov  6 19:15:16 JST 2018
inDataFileNameArr=(
febtemp-181102-113247
febtemp-181102-114317
febtemp-181102-115345
febtemp-181102-120413
febtemp-181102-121442
febtemp-181102-122510
febtemp-181102-123540
febtemp-181102-124608
febtemp-181102-125637
febtemp-181102-130706
febtemp-181102-131736
febtemp-181102-132804
febtemp-181102-133834
febtemp-181102-134902
febtemp-181102-135925
febtemp-181102-140954
febtemp-181102-142023
febtemp-181102-143051
febtemp-181102-144120
febtemp-181102-145149
febtemp-181102-150218
febtemp-181102-151247
febtemp-181102-152317
febtemp-181102-153345
febtemp-181102-154415
febtemp-181102-155443
febtemp-181102-160512
febtemp-181102-161541
febtemp-181102-162610
febtemp-181102-163639
febtemp-181102-164709
febtemp-181102-165737
febtemp-181102-170806
febtemp-181102-171835
febtemp-181102-172904
febtemp-181102-173933
febtemp-181102-175002
febtemp-181102-180031
febtemp-181102-181100
febtemp-181102-182129
febtemp-181102-183158
febtemp-181102-184226
febtemp-181102-185255
febtemp-181102-190324
febtemp-181102-191353
febtemp-181102-192422
febtemp-181102-193451
febtemp-181102-194522
febtemp-181102-195551
febtemp-181102-200619
febtemp-181102-201647
febtemp-181102-202716
febtemp-181102-203745
febtemp-181102-204813
febtemp-181102-205842
febtemp-181102-210917
febtemp-181102-211948
febtemp-181102-213026
febtemp-181102-214056
febtemp-181102-215124
febtemp-181102-220153
febtemp-181102-221222
febtemp-181102-222252
febtemp-181102-223320
febtemp-181102-224350
febtemp-181102-225418
febtemp-181102-230447
febtemp-181102-231516
febtemp-181102-232538
febtemp-181102-233607
febtemp-181102-234636
febtemp-181102-235705
febtemp-181103-000733
febtemp-181103-001802
febtemp-181103-002831
febtemp-181103-003900
febtemp-181103-004929
febtemp-181103-005958
febtemp-181103-011027
febtemp-181103-012056
febtemp-181103-013126
febtemp-181103-014154
febtemp-181103-015223
febtemp-181103-020252
febtemp-181103-021321
febtemp-181103-022350
febtemp-181103-023419
febtemp-181103-024448
febtemp-181103-025518
febtemp-181103-030546
febtemp-181103-031615
febtemp-181103-032644
febtemp-181103-033713
febtemp-181103-034741
febtemp-181103-035811
febtemp-181103-040839
febtemp-181103-041908
febtemp-181103-042937
febtemp-181103-044006
febtemp-181103-045035
febtemp-181103-050104
febtemp-181103-051132
febtemp-181103-052201
febtemp-181103-053230
febtemp-181103-054259
febtemp-181103-055328
febtemp-181103-060357
febtemp-181103-061425
febtemp-181103-062454
febtemp-181103-063523
febtemp-181103-064552
febtemp-181103-065621
febtemp-181103-070650
febtemp-181103-071719
febtemp-181103-072748
febtemp-181103-073816
febtemp-181103-074845
febtemp-181103-075914
febtemp-181103-080943
febtemp-181103-082011
febtemp-181103-083040
febtemp-181103-084109
febtemp-181103-085138
febtemp-181103-090207
febtemp-181103-091236
febtemp-181103-092304
febtemp-181103-093333
febtemp-181103-094402
febtemp-181103-095431
febtemp-181103-100500
febtemp-181103-101528
febtemp-181103-102557
febtemp-181103-103627
febtemp-181103-104655
febtemp-181103-105724
febtemp-181103-110753
febtemp-181103-111822
febtemp-181103-112850
febtemp-181103-113919
febtemp-181103-114948
febtemp-181103-120017
febtemp-181103-121046
febtemp-181103-122115
febtemp-181103-123143
febtemp-181103-124213
febtemp-181103-125241
febtemp-181103-130311
febtemp-181103-131337
febtemp-181103-132417
febtemp-181103-133445
febtemp-181103-134513
febtemp-181103-135542
febtemp-181103-140611
febtemp-181103-141640
febtemp-181103-142709
febtemp-181103-143738
febtemp-181103-144806
febtemp-181103-145835
febtemp-181103-150904
febtemp-181103-151933
febtemp-181103-153002
febtemp-181103-154031
febtemp-181103-155059
febtemp-181103-160128
febtemp-181103-161157
febtemp-181103-162226
febtemp-181103-163254
febtemp-181103-164324
febtemp-181103-165352
febtemp-181103-170421
febtemp-181103-171450
febtemp-181103-172519
febtemp-181103-173548
febtemp-181103-174616
febtemp-181103-175645
febtemp-181103-180714
febtemp-181103-181743
febtemp-181103-182812
febtemp-181103-183840
febtemp-181103-184909
febtemp-181103-185938
febtemp-181103-191007
febtemp-181103-192059
febtemp-181103-193148
febtemp-181103-194238
febtemp-181103-195328
febtemp-181103-200418
febtemp-181103-201509
febtemp-181103-202559
febtemp-181103-203649
febtemp-181103-204738
febtemp-181103-205829
febtemp-181103-210919
febtemp-181103-212009
febtemp-181103-213100
febtemp-181103-214142
febtemp-181103-215224
febtemp-181103-220246
febtemp-181103-221308
febtemp-181103-222342
febtemp-181103-223403
febtemp-181103-224507
febtemp-181103-225542
febtemp-181103-230617
febtemp-181103-231701
febtemp-181103-232752
febtemp-181103-233842
febtemp-181103-234932
febtemp-181104-000015
febtemp-181104-001058
febtemp-181104-002125
febtemp-181104-003207
febtemp-181104-004258
febtemp-181104-005348
febtemp-181104-010438
febtemp-181104-011529
febtemp-181104-012612
febtemp-181104-013655
febtemp-181104-014744
febtemp-181104-015834
febtemp-181104-020924
febtemp-181104-022015
febtemp-181104-023058
febtemp-181104-024142
febtemp-181104-025224
febtemp-181104-030314
febtemp-181104-031405
febtemp-181104-032456
febtemp-181104-033545
febtemp-181104-034635
febtemp-181104-035725
febtemp-181104-040815
febtemp-181104-041858
febtemp-181104-042948
febtemp-181104-044033
febtemp-181104-045125
febtemp-181104-050208
febtemp-181104-051258
febtemp-181104-052348
febtemp-181104-053438
febtemp-181104-054527
febtemp-181104-055618
febtemp-181104-060708
febtemp-181104-061758
febtemp-181104-062849
febtemp-181104-063939
febtemp-181104-065028
febtemp-181104-070119
febtemp-181104-071209
febtemp-181104-072251
febtemp-181104-073334
febtemp-181104-074417
febtemp-181104-075507
febtemp-181104-080558
febtemp-181104-081648
febtemp-181104-082738
febtemp-181104-083828
febtemp-181104-084918
febtemp-181104-090008
febtemp-181104-091051
febtemp-181104-092134
febtemp-181104-093216
febtemp-181104-094306
febtemp-181104-095357
febtemp-181104-100448
febtemp-181104-101539
febtemp-181104-102628
febtemp-181104-103718
febtemp-181104-104808
febtemp-181104-105859
febtemp-181104-110941
febtemp-181104-112025
febtemp-181104-113051
febtemp-181104-114134
febtemp-181104-115224
febtemp-181104-120315
febtemp-181104-121405
febtemp-181104-122455
febtemp-181104-123546
febtemp-181104-124636
febtemp-181104-125725
febtemp-181104-130816
febtemp-181104-131906
febtemp-181104-132956
febtemp-181104-134047
febtemp-181104-135138
febtemp-181104-140219
febtemp-181104-141310
febtemp-181104-142401
febtemp-181104-143443
febtemp-181104-144533
febtemp-181104-145615
febtemp-181104-150719
febtemp-181104-151802
febtemp-181104-152906
febtemp-181104-153930
febtemp-181104-155012
febtemp-181104-160055
febtemp-181104-161145
febtemp-181104-162228
febtemp-181104-163318
febtemp-181104-164408
febtemp-181104-165459
febtemp-181104-170548
febtemp-181104-171638
febtemp-181104-172728
febtemp-181104-173811
febtemp-181104-174902
febtemp-181104-175952
febtemp-181104-181043
febtemp-181104-182133
febtemp-181104-183224
febtemp-181104-184315
febtemp-181104-185403
febtemp-181104-190454
febtemp-181104-191544
febtemp-181104-192634
febtemp-181104-193724
febtemp-181104-194815
febtemp-181104-195904
febtemp-181104-200954
febtemp-181104-202044
febtemp-181104-203135
febtemp-181104-204225
febtemp-181104-205316
febtemp-181104-210405
febtemp-181104-211455
febtemp-181104-212545
febtemp-181104-213628
febtemp-181104-214718
febtemp-181104-215809
febtemp-181104-220859
febtemp-181104-221949
febtemp-181104-223039
febtemp-181104-224131
febtemp-181104-225220
febtemp-181104-230309
febtemp-181104-231400
febtemp-181104-232450
febtemp-181104-233540
febtemp-181104-234631
febtemp-181104-235720
febtemp-181105-000810
febtemp-181105-001901
febtemp-181105-002951
febtemp-181105-004041
febtemp-181105-005132
febtemp-181105-010221
febtemp-181105-011311
febtemp-181105-012401
febtemp-181105-013451
febtemp-181105-014541
febtemp-181105-015632
febtemp-181105-020722
febtemp-181105-021811
febtemp-181105-022902
febtemp-181105-023952
febtemp-181105-025042
febtemp-181105-030133
febtemp-181105-031222
febtemp-181105-032312
febtemp-181105-033402
febtemp-181105-034445
febtemp-181105-035534
febtemp-181105-040625
febtemp-181105-041715
febtemp-181105-042806
febtemp-181105-043848
febtemp-181105-044932
febtemp-181105-050014
febtemp-181105-051104
febtemp-181105-052155
febtemp-181105-053245
febtemp-181105-054334
febtemp-181105-055424
febtemp-181105-060515
febtemp-181105-061605
febtemp-181105-062655
febtemp-181105-063746
febtemp-181105-064835
febtemp-181105-065925
febtemp-181105-071015
febtemp-181105-072058
febtemp-181105-073149
febtemp-181105-074240
febtemp-181105-075330
febtemp-181105-080420
febtemp-181105-081511
febtemp-181105-082601
febtemp-181105-083650
febtemp-181105-084740
febtemp-181105-085831
febtemp-181105-090914
febtemp-181105-091944
febtemp-181105-093026
febtemp-181105-094109
febtemp-181105-095201
febtemp-181105-100243
febtemp-181105-101327
)

rawDataFolder="./data-181106/"
nn=${#inDataFileNameArr[@]}
let nn=nn-1
convertArr
mergeArr
