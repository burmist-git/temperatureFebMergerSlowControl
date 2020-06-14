#!/usr/bin/env python
# 2018.07.20: First version (psh)
# 2019.04.15: version for python3 (Rok Pestotnik)

import os
import sys
import argparse
import time
#python2
##import urllib
#python3 only ("import urllib.request" is needed)
import urllib.request
#import urllib2
import datetime

def getArchData(archURL, file_format, date_from, date_to, pv_name):
    url = archURL + '/retrieval/data/getData.' + file_format + '?'
    url = url + 'from=' + date_from + '%3A00%3A00.000Z&'
    url = url + 'to=' + date_to + '%3A00%3A00.000Z&'
    url = url + 'pv=' + pv_name + '&'
    url = url + 'nanos'
    print("Downloading", pv_name, "using url", url)
    input_file  = urllib.request.urlretrieve(url, pv_name.replace(':', '_') + '.' + file_format)
    ##python2 only
    ##    input_file = urllib2.urlopen(url)
    ##    read_input = input_file.read()
    ##    with open(pv_name + '.' + file_format, 'wb') as f:
    ##      f.write(read_input)

    return



if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("archURL", help="This is the EPICS Archiver Appliance address with port. For example, http://172.22.16.73:17668")
    parser.add_argument("file_format", help="json, csv, mat, pb, txt, and svg")
    parser.add_argument("date_from", help="ISO 8601 format with date and hour. For example, 2018-07-20T14")
    parser.add_argument("date_to", help="ISO 8601 format with date and hour. For example, 2018-07-20T14")
    parser.add_argument("pv_list", help="pv list file")
    args = parser.parse_args()
    lines = []
    with open(args.pv_list, 'r') as f:
        lines = f.readlines()
    pv_name = []
    for line in lines:
        pv_name = line.strip()
        #print('line    = {}'.format(line))
        #print('pv_name = {}'.format(pv_name))
        getArchData(args.archURL, args.file_format, args.date_from, args.date_to, pv_name)
        #time.sleep(1)
