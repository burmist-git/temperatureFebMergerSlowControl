#!/bin/bash

########################################################################
#                                                                      #
# Copyright(C) 2018 - LBS - (Single person developer.)                 #
# Wed Nov  7 00:13:16 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# File description:                                                    #
#                  This script prints maximum temperature.             #
#                                                                      #
# Input paramete:                                                      #
#                  NON.                                                #
#                                                                      #
# This software is provided "as is" without any warranty.              #
#                                                                      #
########################################################################

function find_max_t_bash {

    for ff in $1; do echo $ff; cut -d" " -f3 -s $ff | sort -n | sed -n '$s/^/max T = /p'; done
    for ff in $1; do echo "file: $ff"; cut -d" " -f3 -s $ff | sort -n ; done | grep "2.000000" | grep -v 3

}

#find_max_t_bash "data-181107/febtemp-181106-223705"
#find_max_t_bash "data-181117/febtemp-181116-232422"

find_max_t_bash "../nishida6/data/febtemp-190304-000101"
