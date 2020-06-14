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

source /home/hvala/root/bin/thisroot.sh

# Wed Nov 21 20:38:22 JST 2018
nDataFolderNameArr=(
181102
181103
181104
181105
181106
181107
181108
181109
181110
181111
181112
181113
181114
181115
181116
181117
181118
181119
181120
181121
181122
)

inDataFolderNameArr=(
181113
)

keyGo="go"
keyGo2="notgo"
#keyGo="notgo"
#rawDataFolder="./data-181119/"
sourceHome="/home/hvala/temperaturefebmergerslowcontrol/"
rawDataFolder="/home/hvala/nishida6/data/"
nn=${#inDataFolderNameArr[@]}
let nn=nn-1

function convertFebTemp_main_bash {

    $sourceHome/convertFebTemp_main $1 $2 $3 $4
    
}

function cleanTmpData {

    for i in `seq 0 $nn`;
    do
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	#echo "folderIn = $folderIn/"
	echo "Cleaning folder --> $folderIn/"
	rm -rf $folderIn/*.pdf
	rm -rf $folderIn/*.root
	rm -rf $folderIn/*.log
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
	$sourceHome/convertFebTemp_main 1 $outRootFileName $inRootHistFileList
    fi
}

function printHelp {

    echo " --> ERROR in input arguments "
    echo " [0] -d : default"
    echo " [0] -c : cleaning the data folder"
    echo " [0] -h : print help"

}

if [ $# -eq 0 ] 
then
    
    printHelp
    
else

    if [ "$1" = "-d" ]; then

	convertArr
	mergeArr
        
    elif [ "$1" = "-c" ]; then
        
	cleanTmpData
	
    elif [ "$1" = "-h" ]; then
        
        printHelp
        
    else
        
        printHelp
        
    fi
    
fi

#espeak "I have done"
