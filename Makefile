########################################################################
#                                                                      #
# Copyright(C) 2017 - LBS - (Single person developer.)                 #
# Thu Oct 18 16:20:24 JST 2018                                         #
# Autor: Leonid Burmistrov                                             #
#                                                                      #
# Script description:                                                  #
#                     This make file compiles xmlarichdata soft.       #
#                                                                      #
# Input paramete: NON                                                  #
#                                                                      #
#                                                                      #
# This software is provided "as is" without any warranty.              #
########################################################################

ROOTCFLAGS  = $(shell $(ROOTSYS)/bin/root-config --cflags)
ROOTLIBS    = $(shell $(ROOTSYS)/bin/root-config --libs)
ROOTGLIBS   = $(shell $(ROOTSYS)/bin/root-config --glibs)
ROOTLDFLAGS = $(shell $(ROOTSYS)/bin/root-config --ldflags)

# add xml files
ROOTLIBS += -lMLP -lXMLIO

OUTLIB = /home/hvala/temperaturefebmergerslowcontrol/obj/
#OUTLIB = /home/burmist/temperaturefebmergerslowcontrol/obj/
CXX  = g++
CXX += -I./     

CXXFLAGS  = -g -Wall -fPIC -Wno-deprecated
CXXFLAGS += $(ROOTCFLAGS)
CXXFLAGS += $(ROOTLIBS)
CXXFLAGS += $(ROOTGLIBS)
CXXFLAGS += $(ROOTLDFLAGS)
CXXFLAGSDICT = -g -Wall -fPIC -Wno-deprecated

PATHTOSHAREDLIB=$(OUTLIB)

#----------------------------------------------------#

all: makedir convertFebTemp_main convertMergerTemp_main runanaGL840_main

makedir:
	mkdir -p $(OUTLIB);
	mkdir -p tmp;

printmakeinfo:
	$(info CXX          = "$(CXX)")
	$(info CXXFLAGS     = "$(CXXFLAGS)")
	$(info CXXFLAGSDICT = "$(CXXFLAGSDICT)")

printmakehelp_and_reminder: LinkDef.h libarichstandalone.h
	$(info  /**********************************************************************/)
	$(info  * task --> printmakehelp_and_reminder: LinkDef.h libarichstandalone.h *)
	$(info  * $$@ ----> $@                                 *)
	$(info  * $$< --------------------------------> $<                      *)
	$(info  * $$^ --------------------------------> $^ *)
	$(info  /**********************************************************************/)

gl840_original: gl840_original.c
	gcc -o $@ $<

gl840: gl840.c libarichstandalone.so
	$(CXX) -fpermissive -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

convertFebTemp_main: convertFebTemp_main.cc libarichstandalone.so
	$(CXX) -DCONVERTFEBTEMP_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

convertMergerTemp_main: convertMergerTemp_main.cc libarichstandalone.so
	$(CXX) -DCONVERTMERGERTEMP_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

runanaGL840_main: runanaGL840_main.cc libarichstandalone.so
	$(CXX) -DRUNANAGL840_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

testARICHChannelHist_main: testARICHChannelHist_main.cc libarichstandalone.so
	$(CXX) -DTESTARICHCHANNELHIST_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

testARICHSectorHist_main: testARICHSectorHist_main.cc libarichstandalone.so
	$(CXX) -DTESTARICHSECTORHIST_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

testARICHmapping_main: testARICHmapping_main.cc libarichstandalone.so
	$(CXX) -DTESTARICHMAPPING_MAIN -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

obj/convertFebTemp.o: convertFebTemp.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/convertMergerTemp.o: convertMergerTemp.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/unixTimeManipulation.o: unixTimeManipulation.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/runanaGL840.o: runanaGL840.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/ARICHChannelHist.o: ARICHChannelHist.cc ARICHChannelHist.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/ARICHMergerHist.o: ARICHMergerHist.cc ARICHMergerHist.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/ARICHSectorHist.o: ARICHSectorHist.cc ARICHSectorHist.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/ARICHmappingCopperMergerFeb.o: ARICHmappingCopperMergerFeb.cc ARICHmappingCopperMergerFeb.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/testARICHChannelHist.o: testARICHChannelHist.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/testARICHSectorHist.o: testARICHSectorHist.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/testARICHmapping.o: testARICHmapping.cc
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/anaGL840base.o: anaGL840base.cc anaGL840base.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/anaGL840.o: anaGL840.cc anaGL840.h obj/anaGL840base.o
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

libarichstandalone.so: obj/ARICHChannelHist.o obj/testARICHChannelHist.o obj/ARICHmappingCopperMergerFeb.o obj/ARICHSectorHist.o obj/testARICHSectorHist.o obj/convertFebTemp.o obj/unixTimeManipulation.o obj/ARICHMergerHist.o obj/convertMergerTemp.o obj/runanaGL840.o obj/testARICHmapping.o obj/anaGL840base.o obj/anaGL840.o
	$(CXX) -shared -o $(PATHTOSHAREDLIB)$@ $^ $(ROOTLIBS) $(ROOTGLIBS)

libarichstandaloneDict.cxx: libarichstandalone.h LinkDef.h
	rootcling -f $@ -c $(CXXFLAGSDICT) -p $^

libarichstandaloneDictLib.so: libarichstandaloneDict.cxx ARICHChannelHist.cc testARICHChannelHist.cc ARICHSectorHist.cc testARICHSectorHist.cc ARICHmappingCopperMergerFeb.cc convertFebTemp.cc testARICHmapping.cc
	g++ -shared -o $@ $(CXXFLAGS) -I. -I$(ROOTSYS)/include $^

gl840_clean: 
	rm -f gl840

gl840_original_clean: 
	rm -f gl840_original

clean: 
	rm -f *~
	rm -f .*~
	rm -rf $(OUTLIB)
	rm -f testARICHChannelHist_main
	rm -f testARICHSectorHist_main
	rm -f testARICHmapping_main
	rm -f libarichstandaloneDict.cxx
	rm -f libarichstandaloneDict_rdict.pcm
	rm -f libarichstandaloneDictLib.so
	rm -f convertFebTemp_main
	rm -f convertMergerTemp_main
	rm -f gl840
	rm -f gl840_original
