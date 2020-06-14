#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Sun Oct 21 15:43:50 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  This script builds the convertFebTemp_main and      #
#                  convertMergerTemp_main binaries.                    #
#                                                                      #
# Input paramete:                                                      #
#                  NON.                                                #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function make_bash {

    make clean;
    #make gl840_original_clean
    makelog="Makefile.log"
    rm -rf $makelog
    nthreads=`nproc --all`
    make -j$nthreads -k 2>&1 | tee $makelog
    #make -k 2>&1 | tee $makelog

    nErrors=`grep -i error $makelog | grep -v Total | nl | wc -l`     
    nWarnings=`grep -i warning $makelog | grep -v Total | nl | wc -l`

    echo "Total number of errors   = $nErrors"
    echo "Total number of warnings = $nWarnings"

    echo "Total number of errors   = $nErrors" >> $makelog
    echo "Total number of warnings = $nWarnings" >> $makelog

    echo " "
    echo " "
    echo "-----"
    
    make gl840 -k 2>&1 | tee -a $makelog
    make gl840_original -k 2>&1 | tee -a $makelog
    
}

make_bash
