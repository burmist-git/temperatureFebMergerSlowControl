//C, C++
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <iomanip>

#include <time.h>

using namespace std;

Int_t plotsAverageTemperature(){

  TString fileN_f;
  TString fileN_m;
  TString mgTitle;
  /*
  TString objectName_f_t1 = "h1_feb_t1";
  TString objectName_f_t2 = "h1_feb_t2";
  TString objectName_m_tf = "h1_merger_t_fpga";
  TString objectName_m_tb = "h1_merger_t_board";
  */
  //Mon Nov 19 17:34:25 JST 2018
  fileN_f = "./data-181119/febtemp-181117-000008-febtemp-181119-095150.root";
  fileN_m = "./data-181119/mgrtemp-181117-000008-mgrtemp-181119-095150.root";
  mgTitle="Total water flux : 4.2 L/min, water @ 20 ^{o}C";
  //mgTitle="Total water flux : 4.4 L/min";
  //mgTitle="Total water flux : 2.4 L/min";
  //mgTitle="Total water flux : 3.2 L/min";
  //mgTitle="Total water flux : 4.1 L/min, water @ 20 ^{o}C";

  Double_t tmin = 30.0;
  Double_t tmax = 40.0;
  
  cout<<"fileN_f = "<<fileN_f<<endl;
  cout<<"fileN_m = "<<fileN_m<<endl;
  
  TFile *f_f = new TFile(fileN_f.Data());
  TFile *f_m = new TFile(fileN_m.Data());

  TH1D *h1_feb_t1 = (TH1D*)f_f->Get("h1_feb_t1");
  TH1D *h1_feb_t2 = (TH1D*)f_f->Get("h1_feb_t2");
  TH1D *h1_merger_t_fpga = (TH1D*)f_m->Get("h1_merger_t_fpga");
  TH1D *h1_merger_t_board = (TH1D*)f_m->Get("h1_merger_t_board");
  
  //h1_1->Rebin(4);
  //h1_1->SetTitle("");

  TCanvas *c1 = new TCanvas("c1",fileN_f.Data(),10,10,600,600);
  gStyle->SetPalette(1);
  gStyle->SetFrameBorderMode(0);
  gROOT->ForceStyle();
  gStyle->SetStatColor(kWhite);
  //gStyle->SetOptStat(kFALSE);
   
  h1_feb_t1->GetXaxis()->SetTitle("Temperature, ^{o}C");
  //mg->GetYaxis()->SetTitle("Power, W");
  h1_feb_t1->SetTitle(mgTitle.Data());
  h1_feb_t1->GetXaxis()->SetRangeUser(tmin,tmax);
  h1_feb_t1->SetLineColor(kBlack);
  h1_feb_t2->SetLineColor(kRed);
  h1_feb_t1->SetLineWidth(3.0);
  h1_feb_t2->SetLineWidth(3.0);
  h1_feb_t1->SetMaximum(20000);
  h1_feb_t1->Draw();
  h1_feb_t2->Draw("sames");

  TLegend *leg = new TLegend(0.6,0.6,0.9,0.9,"","brNDC");
  leg->AddEntry(h1_feb_t1, "t1", "apl");
  leg->AddEntry(h1_feb_t2, "t2", "apl");
  leg->Draw();


  TCanvas *c2 = new TCanvas("c2",fileN_m.Data(),20,20,600,600);
  h1_merger_t_fpga->GetXaxis()->SetTitle("Temperature, ^{o}C");
  //mg->GetYaxis()->SetTitle("Power, W");
  h1_merger_t_fpga->SetTitle(mgTitle.Data());
  h1_merger_t_fpga->GetXaxis()->SetRangeUser(tmin,tmax);
  h1_merger_t_fpga->SetLineColor(kBlack);
  h1_merger_t_board->SetLineColor(kRed);
  h1_merger_t_fpga->SetLineWidth(3.0);
  h1_merger_t_board->SetLineWidth(3.0);
  h1_merger_t_fpga->SetMaximum(4000);
  h1_merger_t_fpga->Draw();
  h1_merger_t_board->Draw("sames");

  TLegend *leg2 = new TLegend(0.6,0.6,0.9,0.9,"","brNDC");
  leg2->AddEntry(h1_merger_t_fpga, "fpga", "apl");
  leg2->AddEntry(h1_merger_t_board, "board", "apl");
  leg2->Draw();
  
  return 0;
}
