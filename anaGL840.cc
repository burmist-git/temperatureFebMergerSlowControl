/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sat Apr 13 18:40:17 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "anaGL840.h"
#include "libarichstandalone.h"

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
#include <TRandom3.h>
#include <TMultiGraph.h>
#include <TH2Poly.h>
#include <TText.h>
#include <TPad.h>
#include <TAxis.h>
#include <TGaxis.h>
#include <TLegend.h>

//C, C++
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <fstream>
#include <iomanip>
#include <time.h>
#include <bits/stdc++.h>

using namespace std;

void anaGL840::Loop(TString histOut, Int_t dataDivision, TString parametersFileIn){
  Int_t i = 0;

  Double_t dtMin = 0.0;
  Double_t dtMax = 5.0;
  Double_t tMin = 20.0;
  Double_t tMax = 30.0;
  Double_t pMin = 0.0;   //W
  Double_t pMax = 250.0; //W
 
  Double_t markerSize = 0.3;
  Double_t lineWidth = 1.0;
  //Float_t dV = 0.4; //V

  Double_t timeAxisLabelOffset = 0.025;

  const Int_t colorArr[nSectors] = { kBlack, kRed, kBlue, kGreen + 3, kMagenta, kGray+1};
  const Int_t markerArr[nSectors] = { 20, 20, 20, 21, 21, 21};

  Double_t ktr = (tMax - tMin)/(dtMax - dtMin); 
  
  TGraph *gr_t_vs_time[nChannels];
  tGraphInit( gr_t_vs_time, nChannels, "ch", "gr_t_vs_time", "t vs time");

  Float_t tin_sec[nSectors];
  Float_t tout_sec[nSectors];
  TGraph *gr_tin_sec_vs_time[nSectors];
  TGraph *gr_tout_sec_vs_time[nSectors];
  TGraph *gr_dt_sec_vs_time[nSectors];
  TGraph *gr_dt_sec_vs_time_norm[nSectors];
  TGraph *gr_Power_sec_vs_time[nSectors];
  tGraphInit( gr_tin_sec_vs_time, nSectors, "Sec", "gr_tin_sec_vs_time", "tin vs time");
  tGraphInit( gr_tout_sec_vs_time, nSectors, "Sec", "gr_tout_sec_vs_time", "tout vs time");
  tGraphInit( gr_dt_sec_vs_time, nSectors, "Sec", "gr_dt_sec_vs_time", "dt vs time");
  tGraphInit( gr_dt_sec_vs_time_norm, nSectors, "Sec", "gr_dt_sec_vs_time_norm", "dt vs time norm");
  tGraphInit( gr_Power_sec_vs_time, nSectors, "Sec", "gr_Power_sec_vs_time", "Power vs time");

  TH1D *h1_tin_sec[nSectors];
  TH1D *h1_tout_sec[nSectors];
  TH1D *h1_dt_sec[nSectors];
  TH1D *h1_exPower_sec[nSectors];
  h1D1Init(h1_tin_sec, nSectors, "Sec", "h1_tin_sec", "t_{in} sec", 400, 0.0, 30.0);
  h1D1Init(h1_tout_sec, nSectors, "Sec", "h1_tout_sec", "t_{out} sec", 400, 0.0, 30.0);
  h1D1Init(h1_dt_sec, nSectors, "Sec", "h1_dt_sec", "dt sec", 400, -1.0, 5.0);
  h1D1Init(h1_exPower_sec, nSectors, "Sec", "h1_exPower_sec", "exPower sec", 400, 0.0, 200.0);

  ARICHSectorHist *h1_ARICHSectorHist_power = new ARICHSectorHist("h1_ARICHSectorHist_power","ARICHSectorHist extructed power");

  // +1.5, +3.8, +2.0, -2.0
  //Float_t vAve[nWirePerLowVoltageCable] = {1.5, 3.8, 2.0, -2.0};
  Float_t vMax[nWirePerLowVoltageCable] = {3.5, 6.0, 4.0,   0.0};
  Float_t vMin[nWirePerLowVoltageCable] = {0.0, 0.0, 0.0,  -4.0};
  //for(int iWPLV = 0;iWPLV<nWirePerLowVoltageCable;iWPLV++){
  //vMax[iWPLV] = vAve[iWPLV] + dV;
  //vMin[iWPLV] = vAve[iWPLV] - dV;
  //}

  Float_t vlvc[nLowVoltageCables][nWirePerLowVoltageCable];
  for(int iLVC = 0;iLVC<nLowVoltageCables;iLVC++){
    for(int iWPLV = 0;iWPLV<nWirePerLowVoltageCable;iWPLV++){
      vlvc[iLVC][iWPLV] = 0.0;
    }
  }

  //S1_C1
  TGraph *gr_v_vs_time_S1_C1[nWirePerLowVoltageCable];
  tGraphInit( gr_v_vs_time_S1_C1, nWirePerLowVoltageCable, "Wire", "gr_v_vs_time_S1_C1", "V vs time S1_C1");
  TH1D *h1_v_S1_C1[nWirePerLowVoltageCable];
  h1D1Init(h1_v_S1_C1, nWirePerLowVoltageCable, "Wire", "h1_v_S1_C1", "v S1 C1", 1000, -5.0, 5.0);
  //S3_C1
  TGraph *gr_v_vs_time_S3_C1[nWirePerLowVoltageCable];
  tGraphInit( gr_v_vs_time_S3_C1, nWirePerLowVoltageCable, "Wire", "gr_v_vs_time_S3_C1", "V vs time S3_C1");
  TH1D *h1_v_S3_C1[nWirePerLowVoltageCable];
  h1D1Init(h1_v_S3_C1, nWirePerLowVoltageCable, "Wire", "h1_v_S3_C1", "v S3 C1", 1000, -5.0, 5.0);
  
  double unixtimeStart;
  double unixtimeStop;
  double d_year_min, d_month_min, d_day_min, d_hour_min, d_min_min, d_sec_min;
  double d_year_max, d_month_max, d_day_max, d_hour_max, d_min_max, d_sec_max;
  double totflux;
  readInputPar(parametersFileIn,
	       d_year_min, d_month_min, d_day_min, d_hour_min, d_min_min, d_sec_min,
	       d_year_max, d_month_max, d_day_max, d_hour_max, d_min_max, d_sec_max,
	       totflux);
  cout<<"totflux = "<<totflux<<endl;
  double fluxPerSector = totflux/nSectors/60.0; // L/sector/s
  unixtimeStart = getUnixTimeFrom_year_month_day_hour_min_sec( d_year_min, d_month_min, d_day_min, d_hour_min, d_min_min, d_sec_min);
  unixtimeStop  = getUnixTimeFrom_year_month_day_hour_min_sec( d_year_max, d_month_max, d_day_max, d_hour_max, d_min_max, d_sec_max);    

  //double c_water = 4180.6;//J/kg/K
  //double elePower = 120.0;

  TString drawPowerAxis = "yes";
  
  Long64_t nentries = fChain->GetEntriesFast();
  cout<<"nentries = "<<nentries<<endl;
  Long64_t nbytes = 0, nb = 0;
  for (Long64_t jentry=0; jentry<nentries;jentry++) {
    Long64_t ientry = LoadTree(jentry);
    if (ientry < 0) break;
    nb = fChain->GetEntry(jentry);   nbytes += nb;
    if( unixTime > unixtimeStart && unixTime < unixtimeStop){
      if(jentry%dataDivision==0){
	for(i = 0;i<nChannels;i++)
	  gr_t_vs_time[i]->SetPoint(gr_t_vs_time[i]->GetN(), unixTime, data[i]);
	//
	tin_sec[0]  = data[10];
	tout_sec[0] = data[14];
	//
	tin_sec[1]  = data[11];
	tout_sec[1] = data[15];
	//
	tin_sec[2]  = data[12];
	tout_sec[2] = data[13];
	//
	tin_sec[3]  = data[0];
	tout_sec[3] = data[5];
	//
	tin_sec[4]  = data[1];
	tout_sec[4] = data[3];
	//
	tin_sec[5]  = data[2];
	tout_sec[5] = data[4];
	//S1_C1
	vlvc[0][0] = data[16];//+1.5
	//
	vlvc[0][1] = data[17];//+3.8
	//
	vlvc[0][2] = data[18];//+2.0
	//
	vlvc[0][3] = data[19];//-2.0
	//S3_C1
	vlvc[1][0] = data[6];//+1.5
	//
	vlvc[1][1] = data[7];//+3.8
	//
	vlvc[1][2] = data[8];//+2.0
	//
	vlvc[1][3] = data[9];//-2.0
	for(Int_t iSec = 0;iSec<nSectors;iSec++){
	  gr_tin_sec_vs_time[iSec]->SetPoint(gr_tin_sec_vs_time[iSec]->GetN(), unixTime, tin_sec[iSec]);
	  gr_tout_sec_vs_time[iSec]->SetPoint(gr_tout_sec_vs_time[iSec]->GetN(), unixTime, tout_sec[iSec]);
	  gr_dt_sec_vs_time[iSec]->SetPoint(gr_dt_sec_vs_time[iSec]->GetN(), unixTime, (tout_sec[iSec] - tin_sec[iSec]));
	  gr_dt_sec_vs_time_norm[iSec]->SetPoint(gr_dt_sec_vs_time_norm[iSec]->GetN(), unixTime, ktr*(tout_sec[iSec] - tin_sec[iSec]) + tMin);
	  gr_Power_sec_vs_time[iSec]->SetPoint(gr_Power_sec_vs_time[iSec]->GetN(), unixTime, getPowerPerSector(fluxPerSector,(tout_sec[iSec] - tin_sec[iSec])));
	  h1_exPower_sec[iSec]->Fill(getPowerPerSector(fluxPerSector,(tout_sec[iSec] - tin_sec[iSec])));
	  h1_tin_sec[iSec]->Fill(tin_sec[iSec]);
	  h1_tout_sec[iSec]->Fill(tout_sec[iSec]);
	  h1_dt_sec[iSec]->Fill((tout_sec[iSec] - tin_sec[iSec]));
	}
	for(int iWPLV = 0;iWPLV<nWirePerLowVoltageCable;iWPLV++){
	  gr_v_vs_time_S1_C1[iWPLV]->SetPoint(gr_v_vs_time_S1_C1[iWPLV]->GetN(), unixTime, vlvc[0][iWPLV]);
	  h1_v_S1_C1[iWPLV]->Fill(vlvc[0][iWPLV]);
	  gr_v_vs_time_S3_C1[iWPLV]->SetPoint(gr_v_vs_time_S3_C1[iWPLV]->GetN(), unixTime, vlvc[1][iWPLV]);
	  h1_v_S3_C1[iWPLV]->Fill(vlvc[1][iWPLV]);
	}
      }
    }
  }
  //////////////////////////////////
  for(Int_t iSec = 0;iSec<nSectors;iSec++){
    gr_Power_sec_vs_time[iSec]->SetLineColor(colorArr[iSec]);
    gr_Power_sec_vs_time[iSec]->SetLineWidth(lineWidth);
    gr_Power_sec_vs_time[iSec]->SetMarkerColor(colorArr[iSec]);
    gr_Power_sec_vs_time[iSec]->SetMarkerStyle(markerArr[iSec]);
    gr_Power_sec_vs_time[iSec]->SetMarkerSize(markerSize);
    h1_tin_sec[iSec]->SetLineWidth(lineWidth);
    h1_tout_sec[iSec]->SetLineWidth(lineWidth);
    h1_tin_sec[iSec]->SetLineColor(colorArr[iSec]);
    h1_tout_sec[iSec]->SetLineColor(colorArr[iSec]);
    h1_tin_sec[iSec]->SetMaximum(200);
    h1_tout_sec[iSec]->SetMaximum(200);
    h1_ARICHSectorHist_power->SetBinContent(iSec+1,roundf(h1_exPower_sec[iSec]->GetMean()*100) / 100);
  }
  for(int iWPLV = 0;iWPLV<nWirePerLowVoltageCable;iWPLV++){
    gr_v_vs_time_S1_C1[iWPLV]->SetLineColor(kBlack);
    gr_v_vs_time_S1_C1[iWPLV]->SetLineWidth(lineWidth);
    gr_v_vs_time_S1_C1[iWPLV]->SetMarkerColor(kBlack);
    gr_v_vs_time_S1_C1[iWPLV]->SetMarkerStyle(20);
    gr_v_vs_time_S1_C1[iWPLV]->SetMarkerSize(markerSize);
    gr_v_vs_time_S1_C1[iWPLV]->GetXaxis()->SetTimeDisplay(1);
    gr_v_vs_time_S1_C1[iWPLV]->GetXaxis()->SetTitle("Time, h");
    gr_v_vs_time_S1_C1[iWPLV]->GetYaxis()->SetTitle("Voltage, V");
    gr_v_vs_time_S1_C1[iWPLV]->GetYaxis()->SetRangeUser(vMin[iWPLV], vMax[iWPLV]);
    gr_v_vs_time_S3_C1[iWPLV]->SetLineColor(kRed);
    gr_v_vs_time_S3_C1[iWPLV]->SetLineWidth(lineWidth);
    gr_v_vs_time_S3_C1[iWPLV]->SetMarkerColor(kRed);
    gr_v_vs_time_S3_C1[iWPLV]->SetMarkerStyle(20);
    gr_v_vs_time_S3_C1[iWPLV]->SetMarkerSize(markerSize);
    gr_v_vs_time_S3_C1[iWPLV]->GetXaxis()->SetTimeDisplay(1);
    gr_v_vs_time_S3_C1[iWPLV]->GetXaxis()->SetTitle("Time, h");
    gr_v_vs_time_S3_C1[iWPLV]->GetYaxis()->SetTitle("Voltage, V");
    gr_v_vs_time_S3_C1[iWPLV]->GetYaxis()->SetRangeUser(vMin[iWPLV], vMax[iWPLV]);
    h1_v_S1_C1[iWPLV]->SetLineWidth(lineWidth);
    h1_v_S1_C1[iWPLV]->SetLineColor(kBlack);
    h1_v_S1_C1[iWPLV]->GetXaxis()->SetTitle("Voltage, V");
    h1_v_S1_C1[iWPLV]->GetXaxis()->SetRangeUser(vMin[iWPLV], vMax[iWPLV]);
    h1_v_S3_C1[iWPLV]->SetLineWidth(lineWidth);
    h1_v_S3_C1[iWPLV]->SetLineColor(kRed);
    h1_v_S3_C1[iWPLV]->GetXaxis()->SetTitle("Voltage, V");
    h1_v_S3_C1[iWPLV]->GetXaxis()->SetRangeUser(vMin[iWPLV], vMax[iWPLV]);
  }
  gStyle->SetPalette(kRainBow);
  TMultiGraph *mg1[nSectors];
  TCanvas *c1 = new TCanvas("c1","c1",10,10,1600,1200);
  gStyle->SetPalette(1);
  gStyle->SetFrameBorderMode(0);
  gROOT->ForceStyle();
  gStyle->SetStatColor(kWhite);
  c1->SetTitle("Cooling system status");
  c1->SetName("c1_cooling_system_status");
  c1->SetRightMargin(0.12);
  c1->SetLeftMargin(0.12);
  c1->SetTopMargin(0.1);
  c1->SetBottomMargin(0.15);
  c1->Divide(4,3);
  for (int i = 0; i<nSectors; i++){
    if(i<3){
      c1->cd(i+1);
      c1->GetPad(i+1)->SetGrid();
    }
    else{
      c1->cd(i+2);
      c1->GetPad(i+2)->SetGrid();
    }
    mg1[i] = new TMultiGraph();
    //
    gr_tin_sec_vs_time[i]->SetMarkerStyle(21);
    gr_tin_sec_vs_time[i]->SetMarkerColor(kBlue);
    gr_tin_sec_vs_time[i]->SetLineColor(kBlue);
    gr_tin_sec_vs_time[i]->SetLineWidth(lineWidth);
    gr_tin_sec_vs_time[i]->SetMarkerSize(markerSize);
    gr_tin_sec_vs_time[i]->GetXaxis()->SetTimeDisplay(1);
    //
    gr_tout_sec_vs_time[i]->SetMarkerStyle(21);
    gr_tout_sec_vs_time[i]->SetMarkerColor(kRed);
    gr_tout_sec_vs_time[i]->SetLineColor(kRed);
    gr_tout_sec_vs_time[i]->SetLineWidth(lineWidth);
    gr_tout_sec_vs_time[i]->SetMarkerSize(markerSize);
    gr_tout_sec_vs_time[i]->GetXaxis()->SetTimeDisplay(1);
    //
    gr_dt_sec_vs_time_norm[i]->SetMarkerStyle(20);
    gr_dt_sec_vs_time_norm[i]->SetMarkerColor(kBlack);
    gr_dt_sec_vs_time_norm[i]->SetLineColor(kBlack);
    gr_dt_sec_vs_time_norm[i]->SetLineWidth(lineWidth);
    gr_dt_sec_vs_time_norm[i]->SetMarkerSize(markerSize);
    gr_dt_sec_vs_time_norm[i]->GetXaxis()->SetTimeDisplay(1);
    //
    mg1[i]->Add(gr_tin_sec_vs_time[i]);
    mg1[i]->Add(gr_tout_sec_vs_time[i]);
    mg1[i]->Add(gr_dt_sec_vs_time_norm[i]);
    TString mg1Title = "Water in/out Sec ";
    TString mg1Name = "mg_t_Sec_";
    mg1Title += i+1;
    mg1Name += i; 
    mg1[i]->SetTitle(mg1Title.Data());
    mg1[i]->SetName(mg1Name.Data());
    mg1[i]->SetMaximum(tMax);
    mg1[i]->SetMinimum(tMin);
    mg1[i]->Draw("APL");
    mg1[i]->GetXaxis()->SetTimeDisplay(1);
    mg1[i]->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
    mg1[i]->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
    mg1[i]->GetXaxis()->SetLabelSize(0.025);
    //mg1[i]->GetXaxis()->SetTitleSize(10);
    //mg1[i]->GetXaxis()->SetTitle("Time, h");
    mg1[i]->GetYaxis()->SetTitle("Water in/out temperature, C^{o}");
    //gr_feb_t1_max[i]->Draw("AP");
    //
    //TAxis * yaxis = mg1[i]->GetHistogram()->GetYaxis();
    //Double_t ymax = yaxis->GetXmax();
    //Double_t ymin = yaxis->GetXmin();
    //printf("min %f max %f\n", ymin, ymax);
    //Double_t scale = 120.0 / 17.14286;
    //Double_t rightmax = ymax * scale;
    if(drawPowerAxis == "yes"){
      //draw an axis on the right side
      TGaxis *axis = new TGaxis( gPad->GetUxmax(), gPad->GetUymin(), gPad->GetUxmax(), gPad->GetUymax(), dtMin, dtMax, 510, "+L");
      axis->SetLineColor(kBlack);
      axis->SetLabelColor(kBlack);
      axis->SetTitle("#Delta temperature, C^{o}");
      axis->Draw();
    }
  }
  //
  c1->cd(4);
  TLegend *leg = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg->AddEntry(gr_Power_sec_vs_time[0], "Sec 1","lp");
  leg->AddEntry(gr_Power_sec_vs_time[1], "Sec 2","lp");
  leg->AddEntry(gr_Power_sec_vs_time[2], "Sec 3","lp");
  leg->AddEntry(gr_Power_sec_vs_time[3], "Sec 4","lp");
  leg->AddEntry(gr_Power_sec_vs_time[4], "Sec 5","lp");
  leg->AddEntry(gr_Power_sec_vs_time[5], "Sec 6","lp");
  leg->Draw();
  double utstart;
  double utstop;
  double temper1;
  gr_Power_sec_vs_time[0]->GetPoint(1, utstart, temper1);
  TString timeStr_start = "Time start : ";
  timeStr_start += getLocalTimeStringFromUnixTime( utstart );
  gr_Power_sec_vs_time[0]->GetPoint(gr_Power_sec_vs_time[0]->GetN()-1, utstop, temper1);
  TString timeStr_stop = "Time stop : ";
  timeStr_stop += getLocalTimeStringFromUnixTime( utstop );
  TText *text1_start = new TText(0.1,0.5,timeStr_start.Data());
  //text1_start->SetTextAlign(22);
  text1_start->SetTextSize(0.05);
  text1_start->Draw();
  TText *text1_stop = new TText(0.1,0.45,timeStr_stop.Data());
  //text1_stop->SetTextAlign(22);
  text1_stop->SetTextSize(0.05);
  text1_stop->Draw();
  //
  TText *text2_lastUpdateT = new TText(0.1,0.35,"Last update for water t and flux : ");
  text2_lastUpdateT->SetTextSize(0.05);
  text2_lastUpdateT->Draw();
  TText *text2_lastUpdate = new TText(0.1,0.30,_lastUpdateStr.Data());
  text2_lastUpdate->SetTextSize(0.05);
  text2_lastUpdate->Draw();
  TString waterStr_t = "Water temperature : "; waterStr_t += _waterTempIn; waterStr_t += " C^{o}";
  TText *text2_waterStr_t = new TText(0.1,0.25,waterStr_t.Data());
  text2_waterStr_t->SetTextSize(0.05);
  text2_waterStr_t->Draw();
  float totfluxR = roundf( totflux/nSectors * 10) / 10;
  TString waterStr_f = "Water flux per sector : "; waterStr_f +=totfluxR; waterStr_f += " L/min";
  TText *text2_waterStr_f = new TText(0.1,0.20,waterStr_f.Data());
  text2_waterStr_f->SetTextSize(0.05);
  text2_waterStr_f->Draw();
  //
  c1->cd(8);
  h1_ARICHSectorHist_power->Draw("ZCOLOR TEXT");
  h1_ARICHSectorHist_power->SetMarkerSize(3.0);
  h1_ARICHSectorHist_power->SetTitle("Average extructed power during last 24 h");
  h1_ARICHSectorHist_power->GetZaxis()->SetRangeUser(0.0, 250.0);
  //
  c1->cd(9);
  TMultiGraph *mg2 = new TMultiGraph("mg2", "Extructed power");
  mg2->Add(gr_Power_sec_vs_time[0]);
  mg2->Add(gr_Power_sec_vs_time[1]);
  mg2->Add(gr_Power_sec_vs_time[2]);
  mg2->SetMaximum(pMax);
  mg2->SetMinimum(pMin);
  mg2->Draw("APL");
  mg2->GetXaxis()->SetTimeDisplay(1);
  mg2->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mg2->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  mg2->GetXaxis()->SetLabelSize(0.025);
  //mg2->GetXaxis()->SetTitle("Time, h");
  mg2->GetYaxis()->SetTitle("Extructed power, W");
  //
  c1->cd(10);
  TMultiGraph *mg3 = new TMultiGraph("mg3", "Extructed power");
  mg3->Add(gr_Power_sec_vs_time[3]);
  mg3->Add(gr_Power_sec_vs_time[4]);
  mg3->Add(gr_Power_sec_vs_time[5]);
  mg3->SetMaximum(pMax);
  mg3->SetMinimum(pMin);
  mg3->Draw("APL");
  mg3->GetXaxis()->SetTimeDisplay(1);
  mg3->GetXaxis()->SetLabelSize(0.025);
  mg3->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mg3->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  //mg3->GetXaxis()->SetTitle("Time, h");
  mg3->GetYaxis()->SetTitle("Extructed power, W");
  //
  c1->cd(11);
  h1_tin_sec[0]->Draw();
  h1_tin_sec[0]->GetXaxis()->SetTitle("Water temperature, C^{o}");
  h1_tin_sec[1]->Draw("sames");
  h1_tin_sec[2]->Draw("sames");
  h1_tin_sec[3]->Draw("sames");
  h1_tin_sec[4]->Draw("sames");
  h1_tin_sec[5]->Draw("sames");
  //
  c1->cd(12);
  h1_tout_sec[0]->Draw();
  h1_tout_sec[0]->GetXaxis()->SetTitle("Water temperature, C^{o}");
  h1_tout_sec[1]->Draw("sames");
  h1_tout_sec[2]->Draw("sames");
  h1_tout_sec[3]->Draw("sames");
  h1_tout_sec[4]->Draw("sames");
  h1_tout_sec[5]->Draw("sames");
  //////////////////////////////////
  TCanvas *c2 = new TCanvas("c2","c2",20,20,1200,1200);
  c2->SetTitle("Low voltage back end");
  c2->SetName("c2_low_voltage_back_end");
  c2->SetRightMargin(0.12);
  c2->SetLeftMargin(0.12);
  c2->SetTopMargin(0.1);
  c2->SetBottomMargin(0.15);
  c2->Divide(3,3);
  //
  c2->cd(1);
  TMultiGraph *mglv1 = new TMultiGraph("mglv1","+1.5 MERGER");
  mglv1->Add(gr_v_vs_time_S1_C1[0]);
  mglv1->Add(gr_v_vs_time_S3_C1[0]);
  mglv1->Draw("APL");
  mglv1->GetXaxis()->SetTimeDisplay(1);
  mglv1->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mglv1->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  //mglv1->GetXaxis()->SetTitle("Time, h");
  mglv1->GetYaxis()->SetTitle("Voltage, V");
  mglv1->GetYaxis()->SetRangeUser(-1.0, vMax[0]);
  gr_v_vs_time_S1_C1[0]->SetTitle("+1.5 MERGER");
  //gr_v_vs_time_S1_C1[0]->Draw("APL");
  //
  c2->cd(2);
  TMultiGraph *mglv2 = new TMultiGraph("mglv2","+3.8 MER + FEB");
  mglv2->Add(gr_v_vs_time_S1_C1[1]);
  mglv2->Add(gr_v_vs_time_S3_C1[1]);
  mglv2->Draw("APL");
  mglv2->GetXaxis()->SetTimeDisplay(1);
  mglv2->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mglv2->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  //mglv2->GetXaxis()->SetTitle("Time, h");
  mglv2->GetYaxis()->SetTitle("Voltage, V");
  mglv2->GetYaxis()->SetRangeUser(vMin[1], vMax[1]);
  gr_v_vs_time_S1_C1[1]->SetTitle("+3.8 MER + FEB");
  //gr_v_vs_time_S1_C1[1]->Draw("APL");
  //
  c2->cd(4);
  TMultiGraph *mglv3 = new TMultiGraph("mglv3","+2.0 FEB");
  mglv3->Add(gr_v_vs_time_S1_C1[2]);
  mglv3->Add(gr_v_vs_time_S3_C1[2]);
  mglv3->Draw("APL");
  mglv3->GetXaxis()->SetTimeDisplay(1);
  mglv3->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mglv3->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  //mglv3->GetXaxis()->SetTitle("Time, h");
  mglv3->GetYaxis()->SetTitle("Voltage, V");
  mglv3->GetYaxis()->SetRangeUser(vMin[2], vMax[2]);
  gr_v_vs_time_S1_C1[2]->SetTitle("+2.0 FEB");
  //gr_v_vs_time_S1_C1[2]->Draw("APL");
  //
  c2->cd(5);
  TMultiGraph *mglv4 = new TMultiGraph("mglv4","-2.0 FEB");
  mglv4->Add(gr_v_vs_time_S1_C1[3]);
  mglv4->Add(gr_v_vs_time_S3_C1[3]);
  mglv4->Draw("APL");
  mglv4->GetXaxis()->SetTimeDisplay(1);
  mglv4->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
  mglv4->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
  //mglv4->GetXaxis()->SetTitle("Time, h");
  mglv4->GetYaxis()->SetTitle("Voltage, V");
  mglv4->GetYaxis()->SetRangeUser(vMin[3], vMax[3]);
  gr_v_vs_time_S1_C1[3]->SetTitle("-2.0 FEB");
  //gr_v_vs_time_S1_C1[3]->Draw("APL");
  //
  c2->cd(7);
  h1_v_S1_C1[0]->SetTitle("+1.5 MERGER");
  h1_v_S1_C1[0]->Draw();
  h1_v_S3_C1[0]->Draw("sames");
  //
  c2->cd(8);
  h1_v_S1_C1[1]->SetTitle("+3.8 MER + FEB");
  h1_v_S1_C1[1]->Draw();
  h1_v_S3_C1[1]->Draw("sames");
  //
  c2->cd(6);
  h1_v_S1_C1[2]->SetTitle("+2.0 FEB");
  h1_v_S1_C1[2]->Draw();
  h1_v_S3_C1[2]->Draw("sames");
  //
  c2->cd(9);
  h1_v_S1_C1[3]->SetTitle("-2.0 FEB");
  h1_v_S1_C1[3]->Draw();
  h1_v_S3_C1[3]->Draw("sames");
  //
  c2->cd(3);
  TLegend *leg2 = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg2->AddEntry(gr_v_vs_time_S1_C1[0], "low voltage cable : S1_C1","lp");
  leg2->AddEntry(gr_v_vs_time_S3_C1[0], "low voltage cable : S3_C1","lp");
  leg2->Draw();
  text1_start->Draw();
  text1_stop->Draw();
  //////////////////////////////////
  TFile* rootFile = new TFile(histOut.Data(), "RECREATE", " Histograms", 1);
  rootFile->cd();
  if (rootFile->IsZombie()){
    cout<<"  ERROR ---> file "<<histOut.Data()<<" is zombi"<<endl;
    assert(0);
  }
  else
    cout<<"  Output Histos file ---> "<<histOut.Data()<<endl;
  for(i = 0;i<nChannels;i++)
    gr_t_vs_time[i]->Write();
  for(Int_t iSec = 0; iSec<nSectors; iSec++){
    gr_tin_sec_vs_time[iSec]->Write();
    gr_tout_sec_vs_time[iSec]->Write();
    gr_dt_sec_vs_time[iSec]->Write();
    h1_tin_sec[iSec]->Write();
    h1_tout_sec[iSec]->Write();
    h1_dt_sec[iSec]->Write();
    gr_Power_sec_vs_time[iSec]->Write();
  }
  for(int iWPLV = 0;iWPLV<nWirePerLowVoltageCable;iWPLV++){
    gr_v_vs_time_S1_C1[iWPLV]->Write();
    h1_v_S1_C1[iWPLV]->Write();
    gr_v_vs_time_S3_C1[iWPLV]->Write();
    h1_v_S3_C1[iWPLV]->Write();
  }
  for(Int_t iSec = 0; iSec<nSectors; iSec++)
    mg1[iSec]->Write();
  c1->Write();
  c2->Write();
  rootFile->Close();
  TString histOutPdf_t = histOut;
  histOutPdf_t += "_t.pdf";
  c1->SaveAs(histOutPdf_t.Data());
  TString histOutPdf_u = histOut;
  histOutPdf_u += "_u.pdf";
  c2->SaveAs(histOutPdf_u.Data());
}

void anaGL840::readInputPar(TString fileIn,
			    double &d_year_min, double &d_month_min, double &d_day_min, double &d_hour_min, double &d_min_min, double &d_sec_min,
			    double &d_year_max, double &d_month_max, double &d_day_max, double &d_hour_max, double &d_min_max, double &d_sec_max,
			    double &totflux){
  string mot;
  ifstream indata;
  indata.open(fileIn.Data()); 
  assert(indata.is_open());
  //cout<<indata.is_open()<<endl;
  cout<<" Reading of the input parameters ---> "<<fileIn<<endl;
  while (indata >> mot ){
    //cout<<" New word: "<<mot<<endl;
    if(mot == "timeMin:")
      indata  >> d_year_min >> d_month_min >> d_day_min >> d_hour_min >> d_min_min >> d_sec_min;
    if(mot == "timeMax:")
      indata  >> d_year_max >> d_month_max >> d_day_max >> d_hour_max >> d_min_max >> d_sec_max;
    if(mot == "totalWaterFlux:")
      indata  >> totflux;
    if(mot == "lastUpdate:")
      indata  >> _lastUpdateStr;
    if(mot == "waterTempIn:")
      indata  >> _waterTempIn;
  }
  //cout<<"_lastUpdateStr "<<_lastUpdateStr<<endl;
}

double anaGL840::getPowerPerSector(double fluxPerSector, double dt){
 return dt * fluxPerSector * c_water;
}
