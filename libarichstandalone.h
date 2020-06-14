#pragma once

//my
#include "ARICHChannelHist.h"
#include "ARICHmappingCopperMergerFeb.h"
#include "ARICHMergerHist.h"
#include "ARICHSectorHist.h"
#include "anaGL840base.h"
#include "anaGL840.h"

//root
#include <TROOT.h>
#include <TStyle.h>
#include <TPad.h>
#include <TCanvas.h>
#include <TString.h>
#include <TFile.h>
#include <TGraph.h>
#include <TAxis.h>
#include "TXMLEngine.h"
#include "TH2Poly.h"
#include "TLine.h"
#include "TObject.h"

//c, C++
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>
#include <time.h>
#include <vector>

using namespace std;

const Double_t c_water = 4180.6; //J/kg/K
const Double_t elePower = 120.0; //W Delivered power per sector

//testARICHChannelHist.cc
Int_t testARICHChannelHist();

//testARICHSectorHist.cc
Int_t testARICHSectorHist();

//testARICHmapping.cc
Int_t testARICHmapping();

//convertFebTemp.cc
void convertFebTemp( TString infile, TString outPdfFileNamePreff, Int_t numberOfSectorsToReads, TString hapdTemplateMappingPath);
void mergFebTemp( TString outRootFileName, TString hapdTemplateMappingPath, vector<TString> inRootHistList);
void Draw1DHisto( TH1D *h1, TString outPdfFileName, Double_t xtMin, Double_t xtMax);

//convertMergerTemp.cc
void convertMergerTemp( TString infile, TString outPdfFileNamePreff, Int_t numberOfSectorsToReads, TString hapdTemplateMappingPath, TString fnameInfoMergerPos);
void mergMergerTemp(TString outRootFileName, TString hapdTemplateMappingPath, TString fnameInfoMergerPos, vector<TString> inRootHistList);
void tGraphInit(TGraph *gr[], TString grName, TString grTitle);

//runanaGL840.cc
int runanaGL840( Int_t keyID, TString rootFileOrList, TString outRootFileF, Int_t dataDivision, TString parametersFileIn);

//unixTimeManipulation.cc
double getUnixTimeFrom_year_month_day_hour_min_sec( double d_year, double d_month, double d_day, double d_hour, double d_min, double d_sec);
double getUnixTimeFrom_TString( TString timestr, int dataTimeArr_i[6]);
double getUnixTimeFrom_TString2( TString timestr, int dataTimeArr_i[6]);
void findAndReplaceString( string& str, const string& oldStr, const string& newStr);
bool ifLineContainsString( const string& line, const string& str);
void getMergerIDandTemperatureFrom_TString( TString str, Float_t &t, Int_t &mergerLocalID);
void getFebIDandTemperatureFrom_TString( TString str, Float_t &t, Int_t &mergerLocalID, Int_t &febLocalID);
Int_t getCopperIDFrom_TString( TString str);
TString getLocalTimeStringFromUnixTime( double ut );
double find_hours_since_beginning_of_the_day_from_Unix_time(double ut);
bool check_If_ut_is_in_the_window(double ut, double t0, double dt);
unsigned int find_closest_good_measurement(const std::vector<double> utvec, double t0);

//ARICHChannelHist.h
class ARICHChannelHist;

//ARICHMergerHist.h
class ARICHMergerHist;

//ARICHmappingCopperMergerFeb.h
class ARICHmappingCopperMergerFeb;

//ARICHSectorHist.h
class ARICHSectorHist;

//anaGL840base.h
class anaGL840base;

//anaGL840.h
class anaGL840;
