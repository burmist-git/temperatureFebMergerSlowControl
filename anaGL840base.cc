/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sat Apr 13 18:40:17 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "anaGL840base.h"

//root
#include <TH2.h>
#include <TStyle.h>
#include <TCanvas.h>
#include <TString.h>
#include <TChain.h>
#include <TFile.h>
#include <TTree.h>
#include <TBranch.h>
#include <TGraph.h>
#include <TH1D.h>
#include <TH2D.h>
#include <TProfile.h>

//C, C++
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <fstream>
#include <iomanip>
#include <time.h>
#include <bits/stdc++.h>

using namespace std;

anaGL840base::anaGL840base(TString fileList) : fChain(0) 
{
  ifstream indata;
  TString rootFileName;
  //TChain *theChain = new TChain("arich");
  TChain *theChain = new TChain(treeName.Data());
  indata.open(fileList.Data()); 
  assert(indata.is_open());  
  while (indata  >> rootFileName ){
    if(indata.eof()){
      std::cout<<"EOF"<<std::endl;
      break;
    }
    cout<<"        adding "<<rootFileName<<endl;
    theChain->Add(rootFileName.Data(),-1);
  }
  indata.close();
  Init(theChain);
}

anaGL840base::anaGL840base(TString inFileName, Int_t keyID) : fChain(0) 
{
  if(keyID == 1){
    ifstream indata;
    //TChain *theChain = new TChain("T");
    TChain *theChain = new TChain(treeName.Data());
    cout<<"        adding "<<inFileName<<endl;
    if(theChain->Add(inFileName.Data(),-1))
      Init(theChain);
    else
      assert(0);
  }
  else
    assert(0);
}

anaGL840base::~anaGL840base(){
   if (!fChain) return;
   delete fChain->GetCurrentFile();
}

void anaGL840base::tGraphInit(TGraph *gr[], Int_t nObj, TString strInfo, TString grName, TString grTitle){
  Int_t i;
  TString grNameh;
  TString grTitleh;
  for(i = 0;i<nObj;i++){
    grNameh = grName; grNameh += "_"; grNameh += strInfo; grNameh += "_"; grNameh += i;
    grTitleh = grTitle; grTitleh += " "; grTitleh += strInfo; grTitleh += " "; grTitleh += i;
    gr[i] = new TGraph();
    gr[i]->SetTitle(grTitleh.Data());
    gr[i]->SetName(grNameh.Data());
  }
}

void anaGL840base::h1D1Init(TH1D *h1D1[], Int_t nObj, TString strInfo, TString h1name, TString h1Title,
			    Int_t Nbin, Float_t Vmin, Float_t Vmax){
  Int_t i;
  TString h1nameh;
  TString h1Titleh;
  for(i = 0;i<nObj;i++){    
    h1nameh = h1name; h1nameh += "_"; h1nameh += strInfo; h1nameh += "_"; h1nameh += i;
    h1Titleh = h1Title; h1nameh += " "; h1Titleh += strInfo; h1Titleh += " "; h1Titleh += i;
    h1D1[i] = new TH1D(h1nameh.Data(), h1Titleh.Data(),
                       Nbin, Vmin, Vmax);
  }
}

void anaGL840base::h2D2Init(TH2D *h2D1[], Int_t nObj, TString strInfo, TString h2name, TString h2Title,
			    Int_t Nbin1, Float_t Vmin1, Float_t Vmax1,
			    Int_t Nbin2, Float_t Vmin2, Float_t Vmax2){
  Int_t i;
  TString h2nameh;
  TString h2Titleh;
  for(i = 0;i<nObj;i++){    
    h2nameh = h2name; h2nameh += "_"; h2nameh += strInfo; h2nameh += "_"; h2nameh += i;
    h2Titleh = h2Title; h2nameh += " "; h2Titleh += strInfo; h2Titleh += " "; h2Titleh += i;
    h2D1[i] = new TH2D(h2nameh.Data(), h2Titleh.Data(),
                       Nbin1, Vmin1, Vmax1,
		       Nbin2, Vmin2, Vmax2);
  }  
}

void anaGL840base::tProfInit(TProfile *tprof[], Int_t nObj, TString strInfo, TString prname, TString prTitle,
			     Int_t Nbin, Float_t Vmin, Float_t Vmax){
  Int_t i;
  TString prnameh;
  TString prTitleh;
  for(i = 0;i<nObj;i++){    
    prnameh = prname; prnameh += "_"; prnameh += "strInfo"; prnameh += "_"; prnameh += i;
    prTitleh = prTitle; prnameh += " "; prTitleh += strInfo; prTitleh += " "; prTitleh += i;
    tprof[i] = new TProfile(prnameh.Data(), prTitleh.Data(), Nbin, Vmin, Vmax,"");
  }
}

double anaGL840base::getUnixTimeFromTime(double d_year, double d_month, double d_day, double d_hour, double d_min, double d_sec){
  //time_t timer;
  struct tm y2k = {0};
  y2k.tm_year = d_year - 1900; y2k.tm_mon = d_month-1; y2k.tm_mday = d_day;
  y2k.tm_hour = d_hour;   y2k.tm_min = d_min; y2k.tm_sec = d_sec;
  return difftime(mktime(&y2k),0);
}

void anaGL840base::Loop(TString histOut){
}

Int_t anaGL840base::GetEntry(Long64_t entry){
  // Read contents of entry.
  if (!fChain) return 0;
  return fChain->GetEntry(entry);
}

Long64_t anaGL840base::LoadTree(Long64_t entry){
  // Set the environment to read one entry
  if (!fChain) return -5;
  Long64_t centry = fChain->LoadTree(entry);
  if (centry < 0) return centry;
  if (fChain->GetTreeNumber() != fCurrent) {
    fCurrent = fChain->GetTreeNumber();
    Notify();
  }
  return centry;
}

void anaGL840base::Init(TTree *tree){
  // The Init() function is called when the selector needs to initialize
  // a new tree or chain. Typically here the branch addresses and branch
  // pointers of the tree will be set.
  // It is normally not necessary to make changes to the generated
  // code, but the routine can be extended by the user if needed.
  // Init() will be called many times when running on PROOF
  // (once per file to be processed).
  // Set branch addresses and branch pointers
  if (!tree) return;
  fChain = tree;
  fCurrent = -1;
  fChain->SetMakeClass(1);
  //fChain->SetBranchAddress("evt", &evt, &b_evt);
  //fChain->SetBranchAddress("run", &run, &b_run);
  //fChain->SetBranchAddress("pValue", &pValue, &b_pValue);
  //...
  //...
  //
  //---------------------------------------------------
  // ADD HERE :
  fChain->SetBranchAddress("unixTime", &unixTime, &b_unixTime);
  fChain->SetBranchAddress("data", data, &b_data);
  //---------------------------------------------------
  Notify();
}

Bool_t anaGL840base::Notify(){
  // The Notify() function is called when a new file is opened. This
  // can be either for a new TTree in a TChain or when when a new TTree
  // is started when using PROOF. It is normally not necessary to make changes
  // to the generated code, but the routine can be extended by the
  // user if needed. The return value is currently not used.
  return kTRUE;
}

void anaGL840base::Show(Long64_t entry){
  // Print contents of entry.
  // If entry is not specified, print current entry
  if (!fChain) return;
  fChain->Show(entry);
}

Int_t anaGL840base::Cut(Long64_t entry){
  // This function may be called from Loop.
  // returns  1 if entry is accepted.
  // returns -1 otherwise.
  return 1;
}
