#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Wed Nov 21 20:39:30 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  Program used to convert Merger temperature data in  #
#                  to 2D TH2Poly histograms.                           #
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

function convertMergerTemp_main_bash {

    $sourceHome/convertMergerTemp_main $1 $2 $3 $4 $hapdTemplateMappingPath $fnameInfoMergerPos;
    
}

function unifyTheFormat {

    infile=$1
    outfile=$2
    #echo $infile
    #echo $outfile
    sed '/Reading FPGA system temp/d' $infile | sed '/Reading Merger sensor temp/d' > $outfile

}

function cleanTmpData {

    for i in `seq 0 $nn`;
    do
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	#echo "folderIn = $folderIn/"
	echo "Cleaning folder --> $folderIn/"
	rm -rf $folderIn/mgrtemp*.pdf
	rm -rf $folderIn/mgrtemp*.root
	rm -rf $folderIn/mgrtemp*.log
	rm -rf $folderIn/mgrtemp*_tmp
    done

}

function convertArr {
    echo "---> convertArr"
    for i in `seq 0 $nn`;
    do
	outPdfFileNamefpgatList=""
	outPdfFileNameboardtList=""
	#fileIn=$rawDataFolder${inDataFileNameArr[$i]}
	folderIn=$rawDataFolder${inDataFolderNameArr[$i]}
	echo "folderIn = $folderIn"
	#ls $folderIn
	nFileIn=0
	for fileRawFile in $folderIn"/mgrt"*
	do
	    if [ "$keyGo" = "go" ]
	    then
		echo "fileRawFile = $fileRawFile"
		fileIn=$fileRawFile"_tmp"
		unifyTheFormat $fileRawFile $fileIn
		numberOfLines=`more $fileIn | wc -l`
		#echo "fileIn = $fileIn"
		echo "numberOfLines = $numberOfLines"
		numberOfSectors=`more $fileIn | grep cpr40 | wc -l`
		let numberOfSectors=numberOfSectors/6
		echo "numberOfSectors = $numberOfSectors"
		#if [ "$numberOfLines" -eq "175" ]
		if [ "$numberOfLines" -eq "181" ]
		then
		    convertMergerTemp_main_bash 0 $fileIn $fileRawFile $numberOfSectors | tee $fileRawFile'.log'
		    outPdfFileName=$fileRawFile"_fpga_t.pdf"
		    outPdfFileNamefpgatList="$outPdfFileNamefpgatList $outPdfFileName"
		    inDataFileNameArrfpgat[$nFileIn]=$(basename $outPdfFileName)		  
		    outPdfFileName=$fileRawFile"_board_t.pdf"
		    outPdfFileNameboardtList="$outPdfFileNameboardtList $outPdfFileName"
		    inDataFileNameArrboardt[$nFileIn]=$(basename $outPdfFileName)		    
		    echo "nFileIn=$nFileIn"
		    nFileIn=$((nFileIn+1))
		    keyGo2="go"
		fi
	    fi
	done

	if [ "$keyGo2" = "go" ]
	then
	    let nFileIn=nFileIn-1
	    mergedPdfOutFilefpgat="$(dirname $outPdfFileName)/${inDataFileNameArrfpgat[0]}-${inDataFileNameArrfpgat[$nFileIn]}"
	    mergedPdfOutFileboardt="$(dirname $outPdfFileName)/${inDataFileNameArrboardt[0]}-${inDataFileNameArrboardt[$nFileIn]}"
	    echo "---> mearge to single pdf of merger fpga t : $mergedPdfOutFilefpgat"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFilefpgat $outPdfFileNamefpgatList > /dev/null 2>&1
	    echo "---> mearge to single pdf of merger board t : $mergedPdfOutFileboardt"
	    time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$mergedPdfOutFileboardt $outPdfFileNameboardtList > /dev/null 2>&1
	    #echo $mergedPdfOutFilefpgat
	    #echo $mergedPdfOutFileboardt
	    mv $mergedPdfOutFilefpgat $1/.
	    mv $mergedPdfOutFileboardt $1/.
	    #echo $1
	    echo "$1/$(basename $mergedPdfOutFilefpgat)"
	    echo "$1/$(basename $mergedPdfOutFileboardt)"
	    #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email "$1/$(basename $mergedPdfOutFilefpgat)"
	    #$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email "$1/$(basename $mergedPdfOutFileboardt)"
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
	#mgrtemp-190223-093101_tmp.root
	nRootFiles=$(ls -lrt $folderIn"/mgrtemp"*_tmp.root | wc -l)
	for fileIn in $folderIn"/mgrtemp"*_tmp.root
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
	$sourceHome/convertMergerTemp_main 1 $outRootFileName $hapdTemplateMappingPath  $fnameInfoMergerPos $inRootHistFileList
	mv $outRootFileName $1/.
	echo "$1/$(basename $outRootFileName)"
	summaryPlotsForMergertboard=$1/$(basename $outRootFileName)'_board.pdf'
	summaryPlotsForMergertfpga=$1/$(basename $outRootFileName)'_fpga.pdf'
	summaryPlotsForMergertboardfpga=$1/$(basename $outRootFileName)'_board_fpga.pdf'
	mv $outRootFileName'_board.pdf' $summaryPlotsForMergertboard
	mv $outRootFileName'_fpga.pdf' $summaryPlotsForMergertfpga
	echo $summaryPlotsForMergertboard
	echo $summaryPlotsForMergertfpga
	#--
	echo "---> Mearge to single pdf of the summary plots for Merger board and fpga : $(basename $summaryPlotsForMergertboardfpga)"
	time gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=$summaryPlotsForMergertboardfpga $summaryPlotsForMergertboard $summaryPlotsForMergertfpga > /dev/null 2>&1	    
	echo $summaryPlotsForMergertboardfpga
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email $summaryPlotsForMergertboardfpga
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -email $summaryPlotsForMergertboardfpga $summaryPlotsForMergertboardfpga
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $summaryPlotsForMergertboardfpga
	#$sourceHome/copyToKEKCC_BDAQ_arichsc.bash -sshpass $summaryPlotsForMergertboardfpga $summaryPlotsForMergertboardfpga
	#--
    fi
}

function startTheProcess {

    timeOfStart=$(date)
    echo "New START merger temperature conversion ---> $timeOfStart"
    cleanTmpData
    convertArr $rootpdfsummaryFolder
    mergeArr $rootpdfsummaryFolder
    timeOfStop=$(date)
    echo "New STOP merger temperature conversion  ---> $timeOfStop"

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
fnameInfoMergerPos=$sourceHome"merger_positions.dat"
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
