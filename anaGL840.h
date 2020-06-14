/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sat Apr 13 18:40:17 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

#pragma once

//My
#include "anaGL840base.h"

//root
#include <TROOT.h>

class TChain;
class TFile;
class TTree;
class TString;
class TBranch;

class anaGL840: public anaGL840base {
public:
  anaGL840(TString fileList) : anaGL840base(fileList)
  {
  }

  anaGL840(TString file, Int_t key) : anaGL840base(file, key)
  {
  }

  void Loop(TString histOut, Int_t dataDivision, TString parametersFileIn);
  
  void readInputPar(TString fileIn,
		    double &d_year_min, double &d_month_min, double &d_day_min, double &d_hour_min, double &d_min_min, double &d_sec_min,
		    double &d_year_max, double &d_month_max, double &d_day_max, double &d_hour_max, double &d_min_max, double &d_sec_max,
		    double &totflux);
  
  double getPowerPerSector(double fluxPerSector, double dt);

private:
 
  TString _lastUpdateStr;
  TString _waterTempIn;
  
};
