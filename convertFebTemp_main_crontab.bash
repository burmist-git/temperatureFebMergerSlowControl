#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Wed Nov 21 20:39:30 JST 2018                                         #
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

LC_TIME=en_US.UTF-8
source /home/hvala/root/bin/thisroot.sh
#source /home/burmist/root_v6.14.00/root-6.14.00-install/bin/thisroot.sh

function convertFebTemp_main_bash {

    #echo "hapdTemplateMappingPath $hapdTemplateMappingPath"
    $sourceHome/convertFebTemp_main $1 $2 $3 $4 $hapdTemplateMappingPath
    
}

function cleanTmpData {

    for i in `seq 0 $nn`;
    do
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	#echo "folderIn = $folderIn/"
	echo "Cleaning folder --> $folderIn/"
	rm -rf $folderIn/febtemp*.pdf
	rm -rf $folderIn/febtemp*.root
	rm -rf $folderIn/febtemp*.log
    done
    
}

function convertArr {
    echo "---> convertArr"
    for i in `seq 0 $nn`;
    do	
	singlePlotPdfListh2febt1pdf=""
	singlePlotPdfListh2febt2pdf=""
	singlePlotPdfListh1febt1pdf=""
	singlePlotPdfListh1febt2pdf=""
	#fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	echo "folderIn = $folderIn"
	#ls $folderIn
	nFileIn=0
	for fileIn in $folderIn"/feb"*
	do
	    echo "fileIn = $fileIn"
	    if [ "$keyGo" = "go" ]
	    then
		numberOfLines=`more $fileIn | wc -l`
		#echo "fileIn = $fileIn"
		echo "numberOfLines = $numberOfLines"
		numberOfSectors=`more $fileIn | grep Reading | grep FEB | grep temp | wc -l`
		echo "numberOfSectors = $numberOfSectors"
		#if [ "$numberOfLines" -eq "822" ]
		if [ "$numberOfLines" -eq "865" ]
		then
		    #outPdfFileNamePreff=$rawDataFolder${inDataFileNameArr[$i]}
		    outPdfFileNamePreff=$fileIn
		    convertFebTemp_main_bash 0 $fileIn $outPdfFileNamePreff $numberOfSectors | tee $fileIn'.log'
		    outPdfFileName=$outPdfFileNamePreff"_h2_feb_t1.pdf"
		    inDataFileNameArrh2t1[$nFileIn]=$(basename $outPdfFileName)
		    singlePlotPdfListh2febt1pdf="$singlePlotPdfListh2febt1pdf $outPdfFileName"
		    outPdfFileName=$outPdfFileNamePreff'_h2_feb_t2.pdf'
		    inDataFileNameArrh2t2[$nFileIn]=$(basename $outPdfFileName)
		    singlePlotPdfListh2febt2pdf="$singlePlotPdfListh2febt2pdf $outPdfFileName"
		    outPdfFileName=$outPdfFileNamePreff'_h1_feb_t1.pdf'
		    inDataFileNameArrh1t1[$nFileIn]=$(basename $outPdfFileName)
		    singlePlotPdfListh1febt1pdf="$singlePlotPdfListh1febt1pdf $outPdfFileName"
		    outPdfFileName=$outPdfFileNamePreff'_h1_feb_t2.pdf'
		    inDataFileNameArrh1t2[$nFileIn]=$(basename $outPdfFileName)
		    singlePlotPdfListh1febt2pdf="$singlePlotPdfListh1febt2pdf $outPdfFileName"
		    echo "nFileIn=$nFileIn"
		    nFileIn=$((nFileIn+1))
		    keyGo2="go"
		fi
	    fi
	done

	if [ "$keyGo2" = "go" ]
	then
	    let nFileIn=nFileIn-1
	    mergedPdfOutFileh2febt1pdf="$(dirname $outPdfFileName)/${inDataFileNameArrh2t1[0]}-${inDataFileNameArrh2t1[$nFileIn]}"
	    mergedPdfOutFileh2febt2pdf="$(dirname $outPdfFileName)/${inDataFileNameArrh2t2[0]}-${inDataFileNameArrh2t2[$nFileIn]}"
	    mergedPdfOutFileh1febt1pdf="$(dirname $outPdfFileName)/${inDataFileNameArrh1t1[0]}-${inDataFileNameArrh1t1[$nFileIn]}"
	    mergedPdfOutFileh1febt2pdf="$(dirname $outPdfFileName)/${inDataFileNameArrh1t2[0]}-${inDataFileNameArrh1t2[$nFileIn]}"
	    #mergedPdfOutFileh2febt1pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h2_feb_t1.pdf"
	    #mergedPdfOutFileh2febt2pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h2_feb_t2.pdf"
	    #mergedPdfOutFileh1febt1pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h1_feb_t1.pdf"
	    #mergedPdfOutFileh1febt2pdf="$rawDataFolder${inDataFileNameArr[0]}-${inDataFileNameArr[$nn]}_h1_feb_t2.pdf"
	    echo "---> mearge to single pdf of h2 t1 : $mergedPdfOutFileh2febt1pdf"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt1pdf $singlePlotPdfListh2febt1pdf > /dev/null 2>&1
	    echo "---> mearge to single pdf of h2 t2 : $mergedPdfOutFileh2febt2pdf"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh2febt2pdf $singlePlotPdfListh2febt2pdf > /dev/null 2>&1
	    echo "---> mearge to single pdf of h1 t1 : $mergedPdfOutFileh1febt1pdf"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt1pdf $singlePlotPdfListh1febt1pdf > /dev/null 2>&1
	    echo "---> mearge to single pdf of h1 t2 : $mergedPdfOutFileh1febt2pdf"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileh1febt2pdf $singlePlotPdfListh1febt2pdf > /dev/null 2>&1	    
	    #echo $mergedPdfOutFileh2febt1pdf
	    #echo $mergedPdfOutFileh2febt2pdf
	    #echo $mergedPdfOutFileh1febt1pdf
	    #echo $mergedPdfOutFileh1febt2pdf
	    mv $mergedPdfOutFileh2febt1pdf $1/.
	    mv $mergedPdfOutFileh2febt2pdf $1/.
	    mv $mergedPdfOutFileh1febt1pdf $1/.
	    mv $mergedPdfOutFileh1febt2pdf $1/.
	    #echo $1
	    echo "$1/$(basename $mergedPdfOutFileh2febt1pdf)"
	    echo "$1/$(basename $mergedPdfOutFileh2febt2pdf)"
	    echo "$1/$(basename $mergedPdfOutFileh1febt1pdf)"
	    echo "$1/$(basename $mergedPdfOutFileh1febt2pdf)"
	    #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email "$1/$(basename $mergedPdfOutFileh2febt1pdf)" mergedPdfOutFileh2febt1pdf 
	    #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email "$1/$(basename $mergedPdfOutFileh2febt1pdf)"
	fi

    done
    
}

function mergeArr {
    echo "---> mergeArr"    
    for i in `seq 0 $nn`;
    do
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	echo "folderIn = $folderIn"
	#ls $folderIn
	nFileIn=0
	inRootHistFileList=""
	nRootFiles=$(ls -lrt $folderIn"/feb"*.root | wc -l)
	for fileIn in $folderIn"/feb"*.root
	do	    
	    #echo "fileIn = $fileIn"
	    fileInLast=$fileIn
	    inRootFileNameArr[$nFileIn]=$(basename $fileIn)
	    inRootHistFileList="$inRootHistFileList $fileIn"
	    nFileIn=$((nFileIn+1))
	done
    done
    echo "nRootFiles = $nRootFiles"
    if [ $nRootFiles \> 0 ] ;
    then
	let nFileIn=nFileIn-1
	outRootFileName="$(dirname $fileInLast)/${inRootFileNameArr[0]}-${inRootFileNameArr[$nFileIn]}.root"
	echo "outRootFileName = $outRootFileName"
	echo "inRootHistFileList = $inRootHistFileList"
	$sourceHome/convertFebTemp_main 1 $outRootFileName $hapdTemplateMappingPath $inRootHistFileList
	mv $outRootFileName $1/.
	echo "$1/$(basename $outRootFileName)"
	summaryPlotsForFEBt1=$1/$(basename $outRootFileName)'_t1.pdf'
	summaryPlotsForFEBt2=$1/$(basename $outRootFileName)'_t2.pdf'
	summaryPlotsForFEBt1t2=$1/$(basename $outRootFileName)'_t1_t2.pdf'
	mv $outRootFileName'_t1.pdf' $summaryPlotsForFEBt1
	mv $outRootFileName'_t2.pdf' $summaryPlotsForFEBt2
	echo $summaryPlotsForFEBt1
	echo $summaryPlotsForFEBt2
	#echo "$1/$(basename $outRootFileName)'_t1.pdf'"
	#echo "$1/$(basename $outRootFileName)'_t2.pdf'"
	#--
	echo "---> Mearge to single pdf of the summary plots for FEB t1 and t2 : $(basename $summaryPlotsForFEBt1t2)"
	time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$summaryPlotsForFEBt1t2 $summaryPlotsForFEBt1 $summaryPlotsForFEBt2 > /dev/null 2>&1	    
	echo $summaryPlotsForFEBt1t2
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email $summaryPlotsForFEBt1t2
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email $summaryPlotsForFEBt1t2 $summaryPlotsForFEBt1t2
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $summaryPlotsForFEBt1t2
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $summaryPlotsForFEBt1t2 $summaryPlotsForFEBt1t2
	#--
    fi
}

function startTheProcess {

    timeOfStart=$(date)
    echo "New START FEB temperature conversion ---> $timeOfStart"
    cleanTmpData
    convertArr $rootpdfsummaryFolder
    mergeArr $rootpdfsummaryFolder
    timeOfStop=$(date)
    echo "New STOP FEB temperature conversion  ---> $timeOfStop"

}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d : default"
    echo " [1]    : name of the folder to convert"
    echo " [0] -c : cleaning the data default folder"
    echo " [1]    : name of the folder to clean"
    echo " [0] -h : print help"

}

# Wed Nov 21 20:38:22 JST 2018
inDataFolder="181113"
keyGo="go"
keyGo2="notgo"
#keyGo="notgo"
#rawDataFolder="./data-181119/"
sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
#sourceHome="/home/burmist/temperaturefebmergerslowcontrol/"
rawDataFolder="/home/hvala/nishida6/data/"
#rawDataFolder="/home/burmist/temperaturefebmergerslowcontrol/data/"
hapdTemplateMappingPath=$sourceHome"hapdTemplateMapping.dat"
rootpdfsummaryFolder=$rawDataFolder'root_pdf_summary'
mkdir -p $rootpdfsummaryFolder

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then

	if [ $# -eq 2 ]
        then   

	    inDataFolder=$2
	    inDataFolderNameArr[0]=$inDataFolder
	    nn=${#inDataFolderNameArr[@]}
	    let nn=nn-1
	    startTheProcess

        elif [ $# -eq 1 ]; then

	    inDataFolder=$(date +%y%m%d)
	    inDataFolderNameArr[0]=$inDataFolder
	    nn=${#inDataFolderNameArr[@]}
	    let nn=nn-1
	    startTheProcess

        else
            printHelp
        fi
        
    elif [ "$1" = "-c" ]; then

	if [ $# -eq 2 ]
        then   

	    inDataFolder=$2
	    inDataFolderNameArr[0]=$inDataFolder
	    nn=${#inDataFolderNameArr[@]}
	    let nn=nn-1	    
	    cleanTmpData

        elif [ $# -eq 1 ]; then

	    inDataFolder=$(date +%y%m%d)
	    inDataFolderNameArr[0]=$inDataFolder
	    nn=${#inDataFolderNameArr[@]}
	    let nn=nn-1
	    cleanTmpData

        else
            printHelp
        fi

        
	
    elif [ "$1" = "-h" ]; then
        
        printHelp
        
    else
        
        printHelp
        
    fi
    
fi

#espeak "I have done"
