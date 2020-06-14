/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sat Apr 13 18:40:17 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

#pragma once

#include <TROOT.h>

class TChain;
class TFile;
class TTree;
class TString;
class TBranch;
class TGraph;
class TH1D;
class TH2D;
class TProfile;

class anaGL840base {

 public :
  anaGL840base(TString fileList);
  anaGL840base(TString inFileName, Int_t keyID);
  ~anaGL840base();
  Int_t GetEntry(Long64_t entry);
  Long64_t LoadTree(Long64_t entry);
  void Init(TTree *tree);
  void Loop(TString histOut);
  Bool_t Notify();
  void Show(Long64_t entry = -1);
  Int_t Cut(Long64_t entry);
  
 protected :
  TTree          *fChain;   //!pointer to the analyzed TTree or TChain
  Int_t           fCurrent; //!current Tree number in a TChain
  //Int_t           evt;
  //Int_t           run;
  //Float_t         pValue;
  //...
  //...
  //
  //---------------------------------------------------
  // ADD HERE :
  //Tree name
  //const TString treeName = "arich";
  const TString treeName = "T";
  static const Int_t nChannels = 20;
  static const Int_t nSectors = 6;
  static const Int_t nWirePerLowVoltageCable = 4;
  static const Int_t nLowVoltageCables = 24; 

  Int_t unixTime;
  Float_t data[nChannels];
  //---------------------------------------------------
  
  // List of branches
  //TBranch        *b_evt;
  //TBranch        *b_run;
  //TBranch        *b_pValue;
  //...
  //...
  //
  //---------------------------------------------------
  // ADD HERE :
  TBranch *b_unixTime;
  TBranch *b_data;
  //---------------------------------------------------
  void tGraphInit(TGraph *gr[], Int_t nObj, TString strInfo, TString grName, TString grTitle);
  void h1D1Init(TH1D *h1D1[], Int_t nObj, TString strInfo,TString h1name, TString h1Title,
		Int_t Nbin, Float_t Vmin, Float_t Vmax);
  void h2D2Init(TH2D *h2D1[], Int_t nObj, TString strInfo, TString h2name, TString h2Title,
                Int_t Nbin1, Float_t Vmin1, Float_t Vmax1,
                Int_t Nbin2, Float_t Vmin2, Float_t Vmax2);
  void tProfInit(TProfile *tprof[], Int_t nObj, TString strInfo, TString prname, TString prTitle,
                 Int_t Nbin, Float_t Vmin, Float_t Vmax);
  double getUnixTimeFromTime(double d_year, double d_month, double d_day, double d_hour, double d_min, double d_sec);  
  //
  
};
