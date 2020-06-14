/***********************************************************************
* Copyright(C) 2018 - LBS - (Single person developer.)                 *
* Fri Oct 19 14:36:16 JST 2018                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "libarichstandalone.h"

//root
#include <TROOT.h>
#include <TStyle.h>
#include <TPad.h>
#include <TCanvas.h>
#include <TString.h>
#include <TFile.h>
#include <TGraph.h>
#include <TAxis.h>
#include <TLine.h>
#include <TLegend.h>
#include <TMultiGraph.h>
#include <TTree.h>
#include <TH2Poly.h>
#include <TH1D.h>
#include <TFile.h>
#include <TMath.h>
#include <TText.h>

//C, C++
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include <time.h>

using namespace std;

const Int_t nBinsfeb_t = 300;
const Double_t feb_tmin = 0.0;
const Double_t feb_tmax = 100.0; 
const Double_t tPhysicalMin = 10;
const Double_t tPhysicalMax = 100;
//const Double_t xtMin = 30; //Only for test
//const Double_t xtMax = 38; //Only for test
const Double_t xtMin = 25; //Nominal
const Double_t xtMax = 50; //Nominal
//const Double_t xtMin = 30; //Only for comparison
//const Double_t xtMax = 60; //Only for comparison
//const Double_t xtMin = tPhysicalMin; //Only for test
//const Double_t xtMax = tPhysicalMax; //Only for test
const Int_t nSectors = 6;
///////////////////////////////////////////////////////////////////////////
const Double_t h_test_plots_1 =  3;     // 03:00 night                   //
const Double_t h_test_plots_2 = 11;     // 11:00 day                     //
const Double_t h_test_plots_3 = 19;     // 19:00 evening                 //
const Double_t dh_test        = 0.1;    // 6 min window of interests     //
const Int_t th2polyMapPlotConfigID = 1; // 0 - given time within dh_test //
//                                      // 1 - closest given time        //
///////////////////////////////////////////////////////////////////////////

void convertFebTemp( TString infile = "./data_qqq/febtemp-qqq-qqq",
		     TString outPdfFileNamePreff = "./data_qqq/febtemp-qqq-qqq",
		     Int_t numberOfSectorsToReads = 1,
		     TString hapdTemplateMappingPath = "hapdTemplateMapping.dat"){
     
  cout<<"infile : "<<infile<<endl;
  
  //ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb("/home/hvala/temperaturefebmergerslowcontrol/hapdTemplateMapping.dat");
  //ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb("/home/burmist/temperaturefebmergerslowcontrol/hapdTemplateMapping.dat");
  //cout<<"hapdTemplateMappingPath : "<<hapdTemplateMappingPath<<endl;
  ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb(hapdTemplateMappingPath);
  //arichmap->printMappingConstants();
  //arichmap->dumpMapping();

  ARICHChannelHist *h2_feb_t1 = new ARICHChannelHist("h2_feb_t1","feb_t1",1);
  ARICHChannelHist *h2_feb_t2 = new ARICHChannelHist("h2_feb_t2","feb_t2",1);

  TH1D *h1_feb_t1 = new TH1D("h1_feb_t1","h1_feb_t1",nBinsfeb_t,feb_tmin,feb_tmax);
  TH1D *h1_feb_t2 = new TH1D("h1_feb_t2","h1_feb_t2",nBinsfeb_t,feb_tmin,feb_tmax);
  
  // bin 0 - unixtime
  // bin 1 - sectorID
  TH1D *h1_info = new TH1D("h1_info","info",2,1,2);
  
  //181017-160409
  //Reading FEB temp
  //cpr4016
  //arich[0].feb[0].t1 : 28.875000
  //arich[0].feb[0].t2 : 28.687500

  //Double_t unixTime;
  ifstream filest (infile.Data());
  string line;
  string linet1;
  string linet2;
  TString timeStr;
  TString timeNormalFormatStr;
  TString copperStr;
  Int_t copperID;
  Int_t secID;
  TString str;
  Float_t t1;
  Float_t t2;
  Int_t mergerLocalID;
  Int_t febLocalID;
  Int_t febID;
  TString h2_feb_t1_title;
  TString h2_feb_t2_title;
  TString h2_feb_t1_name;
  TString h2_feb_t2_name;
  TString h1_feb_t1_title;
  TString h1_feb_t2_title;
  Int_t goKey = 1;
  if(filest.is_open()){
    while( getline (filest,line) ) { //181017-160409
      timeStr = line;
      int dataTimeArr[6];
      double unixTime = getUnixTimeFrom_TString2(timeStr, dataTimeArr);
      h1_info->SetBinContent(1,unixTime);
      timeNormalFormatStr = " ";
      timeNormalFormatStr += dataTimeArr[0];
      timeNormalFormatStr += ".";
      timeNormalFormatStr += dataTimeArr[1];
      timeNormalFormatStr += ".";
      timeNormalFormatStr += dataTimeArr[2];
      timeNormalFormatStr += " ";
      timeNormalFormatStr += dataTimeArr[3];
      timeNormalFormatStr += ":";
      timeNormalFormatStr += dataTimeArr[4];
      timeNormalFormatStr += ":";
      timeNormalFormatStr += dataTimeArr[5];
      //cout<<"timeNormalFormatStr "<<timeNormalFormatStr<<endl;
      h2_feb_t1_title = h2_feb_t1->GetTitle();
      h2_feb_t1_title += " ";
      h2_feb_t1_title += timeNormalFormatStr;
      h2_feb_t2_title = h2_feb_t2->GetTitle();
      h2_feb_t2_title += " ";
      h2_feb_t2_title += timeNormalFormatStr;
      h1_feb_t1_title = h1_feb_t1->GetTitle();
      h1_feb_t1_title += " ";
      h1_feb_t1_title += timeNormalFormatStr;
      h1_feb_t2_title = h1_feb_t2->GetTitle();
      h1_feb_t2_title += " ";
      h1_feb_t2_title += timeNormalFormatStr;
      for(Int_t i_sec = 0;i_sec<numberOfSectorsToReads;i_sec++){
	getline ( filest, line);        //Reading FEB temp
	for(Int_t i_cop = 0;i_cop<arichmap->GetnCopperPerSector();i_cop++){
	  getline ( filest, line);      //cpr4016
	  goKey = 1;
	  copperStr = line;
	  copperID = getCopperIDFrom_TString(copperStr);
	  secID = arichmap->getSectorIDFromCopperBoardID(copperID);
	  h1_info->SetBinContent(2,secID);
	  cout<<"copperID = "<<copperID<<endl;
	  for(Int_t i_mer = 0;i_mer<arichmap->GetnMergersPerCopper();i_mer++){
	    Int_t mergerID = arichmap->getMergerIDFromCopperBoardIDAndMergerLocalID( copperID, i_mer);
	    for(Int_t i_feb = 0;i_feb<arichmap->GetnHAPDPerMerger(mergerID);i_feb++){
	      if(goKey == 1)
		getline ( filest, linet1);  //arich[0].feb[0].t1 : 29.250000
	      if(linet1 == "timeout"){
		//cout<<"---> timeout"<<endl;
		goKey = 0;
	      }
	      if(goKey == 1){
		getline ( filest, linet2);  //arich[0].feb[0].t2 : 29.000000
		str = linet1;
		getFebIDandTemperatureFrom_TString( str, t1, mergerLocalID, febLocalID);
		str = linet2;
		getFebIDandTemperatureFrom_TString( str, t2, mergerLocalID, febLocalID);
		//cout<<line<<endl;
		if(t1>0.0){
		  febID = arichmap->getFebIDFromCopperBoardIDAndMergerLocalIDAndFebLocalID( copperID, mergerLocalID, febLocalID);
		  h2_feb_t1->SetBinContent(febID, roundf(t1 * 10) / 10);
		  h1_feb_t1->Fill(t1);
		}
		if(t2>0.0){
		  febID = arichmap->getFebIDFromCopperBoardIDAndMergerLocalIDAndFebLocalID( copperID, mergerLocalID, febLocalID);
		  h2_feb_t2->SetBinContent(febID, roundf(t2 * 10) / 10);
		  h1_feb_t2->Fill(t2);
		}
	      }
	    }
	  }
	}
      }
    }
    filest.close();
  }
  else{
    cout << "Unable to open file"; 
    assert(0);
  }
  
  TString histOut = infile.Data();
  histOut += ".root";
  
  TFile* rootFile = new TFile(histOut.Data(), "RECREATE", " Histograms", 1);
  rootFile->cd();
  if (rootFile->IsZombie()){
    cout<<"  ERROR ---> file "<<histOut.Data()<<" is zombi"<<endl;
    assert(0);
  }
  else
    cout<<"  Output Histos file ---> "<<histOut.Data()<<endl;

  h2_feb_t1->Write();
  h2_feb_t2->Write();
  h1_feb_t1->Write();
  h1_feb_t2->Write();

  h1_info->Write();  

  TString outPdfFileName_h2_feb_t1 = outPdfFileNamePreff; outPdfFileName_h2_feb_t1 += "_h2_feb_t1.pdf";
  TString outPdfFileName_h2_feb_t2 = outPdfFileNamePreff; outPdfFileName_h2_feb_t2 += "_h2_feb_t2.pdf";
  TString outPdfFileName_h1_feb_t1 = outPdfFileNamePreff; outPdfFileName_h1_feb_t1 += "_h1_feb_t1.pdf";
  TString outPdfFileName_h1_feb_t2 = outPdfFileNamePreff; outPdfFileName_h1_feb_t2 += "_h1_feb_t2.pdf";
  h2_feb_t1->DrawHisto( "ZCOLOR text same", outPdfFileName_h2_feb_t1.Data(), h2_feb_t1_title,"drawLine", xtMin, xtMax);
  h2_feb_t2->DrawHisto( "ZCOLOR text same", outPdfFileName_h2_feb_t2.Data(), h2_feb_t2_title,"drawLine", xtMin, xtMax);
  h1_feb_t1->SetTitle(h1_feb_t1_title);
  h1_feb_t2->SetTitle(h1_feb_t2_title);
  Draw1DHisto(h1_feb_t1, outPdfFileName_h1_feb_t1, xtMin, xtMax);
  Draw1DHisto(h1_feb_t2, outPdfFileName_h1_feb_t2, xtMin, xtMax);
  
  rootFile->Close();

}

void Draw1DHisto(TH1D *h1, TString outPdfFileName, Double_t xtMin, Double_t xtMax){
  gStyle->SetPalette(kRainBow);
  TCanvas *c1 = new TCanvas("c1","c1",1000,1000);
  c1->SetTitle(h1->GetTitle());
  c1->SetName(h1->GetName());
  c1->SetRightMargin(0.12);
  c1->SetLeftMargin(0.12);
  c1->SetTopMargin(0.1);
  c1->SetBottomMargin(0.15);
  h1->GetXaxis()->SetTitle("t, C^{o}");
  h1->GetXaxis()->CenterTitle();
  h1->GetXaxis()->SetTitleOffset(1.5);
  //SetLineStyle(1);
  h1->SetLineWidth(3.0);
  h1->GetXaxis()->SetRangeUser(xtMin, xtMax);
  h1->SetMinimum(0.0);
  h1->SetMaximum(50.0);
  h1->Draw();
  c1->Modified();
  c1->Update();
  c1->SaveAs(outPdfFileName.Data());
}

void mergFebTemp(TString outRootFileName, TString hapdTemplateMappingPath, vector<TString> inRootHistList){
  std::cout<<"mergFebTemp"<<std::endl;
  std::cout<<"outRootFileName "<<outRootFileName<<std::endl;
  Double_t timeAxisLabelOffset = 0.025;
  for (unsigned i=0; i<inRootHistList.size(); i++)
    std::cout<<inRootHistList[i]<<'\n';
  TGraph *gr_feb_t1 =new TGraph(); gr_feb_t1->SetTitle("gr_feb_t1"); gr_feb_t1->SetName("gr_feb_t1");
  TGraph *gr_feb_t2 =new TGraph(); gr_feb_t2->SetTitle("gr_feb_t2"); gr_feb_t2->SetName("gr_feb_t2");
  TGraph *gr_feb_dt =new TGraph(); gr_feb_dt->SetTitle("gr_feb_dt"); gr_feb_dt->SetName("gr_feb_dt");
  TGraph *gr_feb_t1_max[nSectors];
  TGraph *gr_feb_t1_min[nSectors];
  TGraph *gr_feb_t1_ave[nSectors];
  TGraph *gr_feb_t2_max[nSectors];
  TGraph *gr_feb_t2_min[nSectors];
  TGraph *gr_feb_t2_ave[nSectors];
  tGraphInit( gr_feb_t1_max, "gr_feb_t1_max", "feb t1 max");
  tGraphInit( gr_feb_t1_min, "gr_feb_t1_min", "feb t1 min");
  tGraphInit( gr_feb_t1_ave, "gr_feb_t1_ave", "feb t1 average");
  tGraphInit( gr_feb_t2_max, "gr_feb_t2_max", "feb t2 max");
  tGraphInit( gr_feb_t2_min, "gr_feb_t2_min", "feb t2 min");
  tGraphInit( gr_feb_t2_ave, "gr_feb_t2_ave", "feb t2 average");
  TH2D *h2_febt1_vs_meas = new TH2D("h2_febt1_vs_meas","febt1 vs meas",400,0.0,400.0,nBinsfeb_t,feb_tmin,feb_tmax);
  TH2D *h2_febt2_vs_meas = new TH2D("h2_febt2_vs_meas","febt2 vs meas",400,0.0,400.0,nBinsfeb_t,feb_tmin,feb_tmax);
  TH1D *h1_feb_t1 = new TH1D("h1_feb_t1","h1_feb_t1",nBinsfeb_t,feb_tmin,feb_tmax);
  TH1D *h1_feb_t2 = new TH1D("h1_feb_t2","h1_feb_t2",nBinsfeb_t,feb_tmin,feb_tmax);
  double unixTime;
  double t1;
  double t2;
  double dt;
  //ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb("/home/hvala/temperaturefebmergerslowcontrol/hapdTemplateMapping.dat");
  //ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb("/home/burmist/temperaturefebmergerslowcontrol/hapdTemplateMapping.dat");
  ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb(hapdTemplateMappingPath);
  ARICHSectorHist *h1_ARICHSectorHist_t1_n = new ARICHSectorHist("h1_ARICHSectorHist_t1_n","ARICHSectorHist t1 n measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t1_sum = new ARICHSectorHist("h1_ARICHSectorHist_t1_sum","ARICHSectorHist t1 sum measurements");  
  ARICHSectorHist *h1_ARICHSectorHist_t1 = new ARICHSectorHist("h1_ARICHSectorHist_t1","ARICHSectorHist t1 measurements");  
  ARICHSectorHist *h1_ARICHSectorHist_t2_n = new ARICHSectorHist("h1_ARICHSectorHist_t2_n","ARICHSectorHist t2 n measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t2_sum = new ARICHSectorHist("h1_ARICHSectorHist_t2_sum","ARICHSectorHist t2 sum measurements");  
  ARICHSectorHist *h1_ARICHSectorHist_t2 = new ARICHSectorHist("h1_ARICHSectorHist_t2","ARICHSectorHist t2 measurements");  
  int jmin = 0;
  int jmax = arichmap->GetnHAPD()+1;
  //int jmin = 420;
  //int jmax = 420;
  Int_t febID;
  Int_t sec_i;
  Int_t cop_i;
  Int_t mer_i;
  Int_t feb_i;
  double t1_persector_max[nSectors];
  double t1_persector_min[nSectors];
  double t1_persector_ave[nSectors];
  int t1_persector_nVal[nSectors];
  double t2_persector_max[nSectors];
  double t2_persector_min[nSectors];
  double t2_persector_ave[nSectors];
  int t2_persector_nVal[nSectors];
  vector<double> unixTimeVec;
  vector<ARICHChannelHist*> h2_feb_t1_v;
  vector<ARICHChannelHist*> h2_feb_t2_v;
  for (unsigned i=0; i<inRootHistList.size(); i++){
    //std::cout<<inRootHistList[i]<<'\n';
    TFile *f1 = new TFile(inRootHistList[i].Data());
    TH2Poly *h2_feb_t1 = (TH2Poly*)f1->Get("h2_feb_t1");
    TH2Poly *h2_feb_t2 = (TH2Poly*)f1->Get("h2_feb_t2");
    //ARICHChannelHist *h2_feb_t1 = (ARICHChannelHist*)f1->Get("h2_feb_t1");
    //ARICHChannelHist *h2_feb_t2 = (ARICHChannelHist*)f1->Get("h2_feb_t2");
    TH1D *h1_info = (TH1D*)f1->Get("h1_info");
    unixTime = h1_info->GetBinContent(1);
    unixTimeVec.push_back(unixTime);
    //cout<<i<<endl;
    ARICHChannelHist *h2_feb_t1_clone = new ARICHChannelHist(h2_feb_t1->GetName(),h2_feb_t1->GetTitle(),1);
    for(unsigned int i = 1; i<=420;i++)
      h2_feb_t1_clone->SetBinContent(i,h2_feb_t1->GetBinContent(i));
    h2_feb_t1_v.push_back(h2_feb_t1_clone);
    ARICHChannelHist *h2_feb_t2_clone = new ARICHChannelHist(h2_feb_t2->GetName(),h2_feb_t2->GetTitle(),1);
    for(unsigned int i = 1; i<=420;i++)
      h2_feb_t2_clone->SetBinContent(i,h2_feb_t2->GetBinContent(i));
    h2_feb_t2_v.push_back(h2_feb_t2_clone);
    //new_tpoly_chHist
    //return new_tpoly_chHist;
    //h2_feb_t2_v.push_back(ARICHChannelHist::createFrom((ARICHChannelHist*)f1->Get("h2_feb_t2")));
    for(int k = 0; k<nSectors;k++){
      t1_persector_max[k] = tPhysicalMin;
      t1_persector_min[k] = tPhysicalMax;
      t1_persector_ave[k] = 0.0;
      t1_persector_nVal[k] = 0;
      t2_persector_max[k] = tPhysicalMin;
      t2_persector_min[k] = tPhysicalMax;
      t2_persector_ave[k] = 0.0;
      t2_persector_nVal[k] = 0;
    }
    for(int j = 1;j<=arichmap->GetnHAPD();j++){
      if(j >= jmin && j<= jmax){
	//if(j == 420 || j == 419 || j == 342){
	t1 = h2_feb_t1->GetBinContent(j);
	t2 = h2_feb_t2->GetBinContent(j);
	dt = t1 - t2;
	gr_feb_t1->SetPoint(gr_feb_t1->GetN(), unixTime, t1);
	gr_feb_t2->SetPoint(gr_feb_t2->GetN(), unixTime, t2);
	febID = j;
	arichmap->findPositionInarichmappingFormGlobalFebID(febID, sec_i, cop_i, mer_i, feb_i);
	if(sec_i >= 0 && sec_i< nSectors){
	  if(t1 > tPhysicalMin && t1 < tPhysicalMax){
	    if(t1_persector_max[sec_i] < t1)
	      t1_persector_max[sec_i] = t1;
	    if(t1_persector_min[sec_i] > t1)
	      t1_persector_min[sec_i] = t1;
	    t1_persector_ave[sec_i] = t1_persector_ave[sec_i] + t1;
	    t1_persector_nVal[sec_i] = t1_persector_nVal[sec_i] + 1;
	    h1_ARICHSectorHist_t1_n->SetBinContent(sec_i+1,h1_ARICHSectorHist_t1_n->GetBinContent(sec_i+1)+1);
	    h1_ARICHSectorHist_t1_sum->SetBinContent(sec_i+1,h1_ARICHSectorHist_t1_sum->GetBinContent(sec_i+1)+t1);
	  }
	  if(t2 > tPhysicalMin && t2 < tPhysicalMax){
	    if(t2_persector_max[sec_i] < t2)
	      t2_persector_max[sec_i] = t2;
	    if(t2_persector_min[sec_i] > t2)
	      t2_persector_min[sec_i] = t2;
	    t2_persector_ave[sec_i] = t2_persector_ave[sec_i] + t2;
	    t2_persector_nVal[sec_i] = t2_persector_nVal[sec_i] + 1;
	    h1_ARICHSectorHist_t2_n->SetBinContent(sec_i+1,h1_ARICHSectorHist_t2_n->GetBinContent(sec_i+1)+1);
	    h1_ARICHSectorHist_t2_sum->SetBinContent(sec_i+1,h1_ARICHSectorHist_t2_sum->GetBinContent(sec_i+1)+t2);
	  }
	}
	h1_feb_t1->Fill(t1);
	h1_feb_t2->Fill(t2);
	if(t1>0.0 && t2>0.0)
	  gr_feb_dt->SetPoint(gr_feb_dt->GetN(), unixTime, dt);
	}
      h2_febt1_vs_meas->Fill(i+0.5,t1);
      h2_febt2_vs_meas->Fill(i+0.5,t2);
      //}
    }
    for(int k = 0; k<nSectors;k++){
      if(t1_persector_nVal[k]>0){
	gr_feb_t1_max[k]->SetPoint(gr_feb_t1_max[k]->GetN(), unixTime, t1_persector_max[k]);
	gr_feb_t1_min[k]->SetPoint(gr_feb_t1_min[k]->GetN(), unixTime, t1_persector_min[k]);
	gr_feb_t1_ave[k]->SetPoint(gr_feb_t1_ave[k]->GetN(), unixTime, t1_persector_ave[k]/t1_persector_nVal[k]);
	if(h1_ARICHSectorHist_t1_n->GetBinContent(k+1)>0.0){
	  double t1AverageRound = roundf(h1_ARICHSectorHist_t1_sum->GetBinContent(k+1)/h1_ARICHSectorHist_t1_n->GetBinContent(k+1) * 10 ) / 10;
	  h1_ARICHSectorHist_t1->SetBinContent(k+1,t1AverageRound);
	}
      }
      if(t2_persector_nVal[k]>0){
	gr_feb_t2_max[k]->SetPoint(gr_feb_t2_max[k]->GetN(), unixTime, t2_persector_max[k]);
	gr_feb_t2_min[k]->SetPoint(gr_feb_t2_min[k]->GetN(), unixTime, t2_persector_min[k]);
	gr_feb_t2_ave[k]->SetPoint(gr_feb_t2_ave[k]->GetN(), unixTime, t2_persector_ave[k]/t2_persector_nVal[k]);
	if(h1_ARICHSectorHist_t2_n->GetBinContent(k+1)>0.0){
	  double t2AverageRound = roundf(h1_ARICHSectorHist_t2_sum->GetBinContent(k+1)/h1_ARICHSectorHist_t2_n->GetBinContent(k+1) * 10 ) / 10;
	  h1_ARICHSectorHist_t2->SetBinContent(k+1,t2AverageRound);
	}
      }
    }
    //gr_feb_t1_max[1]->SetPoint(gr_feb_t1_max[1]->GetN(), unixTime, t2);
    //gr_feb_t1_max[2]->SetPoint(gr_feb_t1_max[2]->GetN(), unixTime, t2);
    //gr_feb_t1_max[3]->SetPoint(gr_feb_t1_max[3]->GetN(), unixTime, t2);
    //gr_feb_t1_max[4]->SetPoint(gr_feb_t1_max[4]->GetN(), unixTime, t2);
    //gr_feb_t1_max[5]->SetPoint(gr_feb_t1_max[5]->GetN(), unixTime, t2);
    f1->Close();
  }
  /////////////////////////
  gStyle->SetPalette(kRainBow);
  TCanvas *c2 = new TCanvas("c2","c2",10,10,1600,1200);
  c2->SetTitle("FEB t1 info");
  c2->SetName("feb_t1_info");
  c2->SetRightMargin(0.12);
  c2->SetLeftMargin(0.12);
  c2->SetTopMargin(0.1);
  c2->SetBottomMargin(0.15);
  c2->Divide(4,3);
  TMultiGraph *mg1[nSectors];
  for (int i = 0; i<nSectors; i++){
    if(i<3){
      c2->cd(i+1);
      c2->GetPad(i+1)->SetGrid();
    }
    else{
      c2->cd(i+2);
      c2->GetPad(i+2)->SetGrid();
    }
    mg1[i] = new TMultiGraph();
    gr_feb_t1_max[i]->SetMarkerStyle(7);
    gr_feb_t1_max[i]->SetMarkerColor(kRed);
    gr_feb_t1_max[i]->SetLineColor(kRed);
    gr_feb_t1_max[i]->SetLineWidth(1);
    gr_feb_t1_max[i]->GetXaxis()->SetTimeDisplay(1);
    gr_feb_t1_min[i]->SetMarkerStyle(7);
    gr_feb_t1_min[i]->SetMarkerColor(kBlue);
    gr_feb_t1_min[i]->SetLineColor(kBlue);
    gr_feb_t1_min[i]->SetLineWidth(1);
    gr_feb_t1_min[i]->GetXaxis()->SetTimeDisplay(1);
    gr_feb_t1_ave[i]->SetMarkerStyle(7);
    gr_feb_t1_ave[i]->SetMarkerColor(kBlack);
    gr_feb_t1_ave[i]->SetLineColor(kBlack);
    gr_feb_t1_ave[i]->SetLineWidth(1);
    gr_feb_t1_ave[i]->GetXaxis()->SetTimeDisplay(1);
    mg1[i]->Add(gr_feb_t1_max[i]);
    mg1[i]->Add(gr_feb_t1_min[i]);
    mg1[i]->Add(gr_feb_t1_ave[i]);
    TString mg1Title = "FEB t1 Sec ";
    mg1Title += i+1;
    TString mg1Name = "mg1_t1_Sec_";
    mg1Name += i;
    mg1[i]->SetTitle(mg1Title.Data());
    mg1[i]->SetName(mg1Name.Data());
    mg1[i]->SetMaximum(xtMax);
    mg1[i]->SetMinimum(xtMin);
    mg1[i]->Draw("APL");
    mg1[i]->GetXaxis()->SetTimeDisplay(1);
    mg1[i]->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
    mg1[i]->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
    mg1[i]->GetXaxis()->SetLabelSize(0.025);
    //mg1[i]->GetXaxis()->SetTitleSize(10);
    //mg1[i]->GetXaxis()->SetTitle("Time, h");
    mg1[i]->GetYaxis()->SetTitle("FEB t1 temperature, C^{o}");
    //gr_feb_t1_max[i]->Draw("AP");
  }
  c2->cd(4);
  TLegend *leg = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg->AddEntry(gr_feb_t1_max[1], "FEB t1 max","lp");
  leg->AddEntry(gr_feb_t1_min[1], "FEB t1 min","lp");
  leg->AddEntry(gr_feb_t1_ave[1], "FEB t1 average","lp");
  leg->Draw();
  double utstart;
  double utstop;
  double temper1;
  gr_feb_t1_max[0]->GetPoint(1, utstart, temper1);
  TString timeStr_start = "Time start : ";
  timeStr_start += getLocalTimeStringFromUnixTime( utstart );
  gr_feb_t1_max[0]->GetPoint(gr_feb_t1_max[0]->GetN()-1, utstop, temper1);
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
  c2->cd(8);
  gStyle->SetOptStat(kFALSE);
  h1_ARICHSectorHist_t1->Draw("ZCOLOR TEXT");
  h1_ARICHSectorHist_t1->SetMarkerSize(3.0);
  h1_ARICHSectorHist_t1->SetTitle("Average temperature (t1) during last 24 h");
  h1_ARICHSectorHist_t1->GetZaxis()->SetRangeUser(xtMin, xtMax);
  //
  c2->cd(12);
  c2->GetPad(12)->SetGrid();
  c2->GetPad(12)->SetLogy();
  //gStyle->SetOptStat(kTRUE);
  h1_feb_t1->SetLineColor(kBlack);
  h1_feb_t1->SetLineWidth(2.0);
  h1_feb_t1->SetTitle("FEB t1 temperature, C^{o}");
  h1_feb_t1->Draw();
  h1_feb_t1->GetXaxis()->SetTitle("FEB t1 temperature, C^{o}");
  //
  if(th2polyMapPlotConfigID == 0){
    for(unsigned int i = 0; i<unixTimeVec.size();i++){
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_1, dh_test)){
	c2->cd(9);
	h2_feb_t1_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t1_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	//h2_feb_t1_v[i]->Draw("");
	//hp_chips_my->DrawHisto( "same ZCOLOR lcol", "", hp_chips->GetTitle(), "drawLine", vmonmin, vmonmax, c1, secID);
	//h2_feb_t1_v[i]->DrawHistoC1( "ZCOLOR text same", "", h2_feb_t1_v[i]->GetTitle(),"drawLine", xtMin, xtMax);
	cout<<"DrawHistoC1"<<endl;
	h2_feb_t1_v[i]->DrawHistoC1( "same ZCOLOR text lcol", "", h2_feb_t1_v[i]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_2, dh_test)){
	c2->cd(10);
	h2_feb_t1_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t1_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_feb_t1_v[i]->Draw("");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_3, dh_test)){
	c2->cd(11);
	h2_feb_t1_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t1_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_feb_t1_v[i]->Draw("");
      }
    }
  }
  else if(th2polyMapPlotConfigID == 1){
    ///////////
    //double ut = unixTimeVec[0];
    //cout<<"getLocalTimeStringFromUnixTime(ut) "<<getLocalTimeStringFromUnixTime(ut);
    //printf ("ut     : %20.3f \n ", ut);
    //double h_since_beginning_plots_1 = find_hours_since_beginning_of_the_day_from_Unix_time(ut);
    //cout<<"h_test_plots_1            "<<h_test_plots_1<<endl
    //<<"h_since_beginning_plots_1 "<<h_since_beginning_plots_1<<endl;
    //ut = unixTimeVec[1];
    //cout<<"getLocalTimeStringFromUnixTime(ut) "<<getLocalTimeStringFromUnixTime(ut);
    //printf ("ut     : %20.3f \n ", ut);
    //h_since_beginning_plots_1 = find_hours_since_beginning_of_the_day_from_Unix_time(ut);
    //cout<<"h_test_plots_1            "<<h_test_plots_1<<endl
    //	<<"h_since_beginning_plots_1 "<<h_since_beginning_plots_1<<endl;
    /////////////
    unsigned int iclosest1 = find_closest_good_measurement(unixTimeVec, h_test_plots_1);
    cout<<"iclosest1 "<<iclosest1<<endl;
    c2->cd(9);
    h2_feb_t1_v[iclosest1]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest1]));
    h2_feb_t1_v[iclosest1]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t1_v[iclosest1]->Draw("");
    //cout<<"DrawHistoC1"<<endl;
    h2_feb_t1_v[iclosest1]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t1_v[iclosest1]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
    //
    unsigned int iclosest2 = find_closest_good_measurement(unixTimeVec, h_test_plots_2);
    cout<<"iclosest2 "<<iclosest2<<endl;
    c2->cd(10);
    h2_feb_t1_v[iclosest2]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest2]));
    h2_feb_t1_v[iclosest2]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t1_v[iclosest2]->Draw("");
    h2_feb_t1_v[iclosest2]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t1_v[iclosest2]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
    //
    unsigned int iclosest3 = find_closest_good_measurement(unixTimeVec, h_test_plots_3);
    cout<<"iclosest3 "<<iclosest3<<endl;
    c2->cd(11);
    h2_feb_t1_v[iclosest3]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest3]));
    h2_feb_t1_v[iclosest3]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t1_v[iclosest3]->Draw("");
    h2_feb_t1_v[iclosest3]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t1_v[iclosest3]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
  }
  else{
    cout<<"ERROR --> th2polyMapPlotConfigID = "<<th2polyMapPlotConfigID<<endl;
    assert(0);
  }
  c2->Modified();
  c2->Update();
  TString outPdfFileName = outRootFileName;
  outPdfFileName += "_t1.pdf";
  c2->SaveAs(outPdfFileName.Data());
  //////////////////////////////////////////////////////////
  TCanvas *c3 = new TCanvas("c3","c3",20,20,1600,1200);
  c3->SetTitle("FEB t2 info");
  c3->SetName("feb_t2_info");
  c3->SetRightMargin(0.12);
  c3->SetLeftMargin(0.12);
  c3->SetTopMargin(0.1);
  c3->SetBottomMargin(0.15);
  c3->Divide(4,3);
  TMultiGraph *mg2[nSectors];
  for (int i = 0; i<nSectors; i++){
    if(i<3){
      c3->cd(i+1);
      c3->GetPad(i+1)->SetGrid();
    }
    else{
      c3->cd(i+2);
      c3->GetPad(i+2)->SetGrid();
    }
    mg2[i] = new TMultiGraph();
    gr_feb_t2_max[i]->SetMarkerStyle(7);
    gr_feb_t2_max[i]->SetMarkerColor(kRed);
    gr_feb_t2_max[i]->SetLineColor(kRed);
    gr_feb_t2_max[i]->SetLineWidth(1);
    gr_feb_t2_max[i]->GetXaxis()->SetTimeDisplay(1);
    gr_feb_t2_min[i]->SetMarkerStyle(7);
    gr_feb_t2_min[i]->SetMarkerColor(kBlue);
    gr_feb_t2_min[i]->SetLineColor(kBlue);
    gr_feb_t2_min[i]->SetLineWidth(1);
    gr_feb_t2_min[i]->GetXaxis()->SetTimeDisplay(1);
    gr_feb_t2_ave[i]->SetMarkerStyle(7);
    gr_feb_t2_ave[i]->SetMarkerColor(kBlack);
    gr_feb_t2_ave[i]->SetLineColor(kBlack);
    gr_feb_t2_ave[i]->SetLineWidth(1);
    gr_feb_t2_ave[i]->GetXaxis()->SetTimeDisplay(1);
    mg2[i]->Add(gr_feb_t2_max[i]);
    mg2[i]->Add(gr_feb_t2_min[i]);
    mg2[i]->Add(gr_feb_t2_ave[i]);
    TString mg2Title = "FEB t2 Sec ";
    TString mg2Name = "mg2_t2_Sec_";
    mg2Title += i+1; 
    mg2Name += i;
    mg2[i]->SetTitle(mg2Title.Data());
    mg2[i]->SetName(mg2Name.Data());
    mg2[i]->SetMaximum(xtMax);
    mg2[i]->SetMinimum(xtMin);
    mg2[i]->Draw("APL");
    mg2[i]->GetXaxis()->SetTimeDisplay(1);
    mg2[i]->GetXaxis()->SetTimeFormat("#splitline{%m/%d}{%H:%M}%F1970-01-01 00:00:00");
    mg2[i]->GetXaxis()->SetLabelOffset(timeAxisLabelOffset);
    mg2[i]->GetXaxis()->SetLabelSize(0.025);
    //mg2[i]->GetXaxis()->SetTitleSize(10);
    //mg2[i]->GetXaxis()->SetTitle("Time, h");
    mg2[i]->GetYaxis()->SetTitle("FEB t2 temperature, C^{o}");
    //gr_feb_t2_max[i]->Draw("AP");
  }
  c3->cd(4);
  TLegend *leg2 = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg2->AddEntry(gr_feb_t2_max[1], "FEB t2 max","lp");
  leg2->AddEntry(gr_feb_t2_min[1], "FEB t2 min","lp");
  leg2->AddEntry(gr_feb_t2_ave[1], "FEB t2 average","lp");
  leg2->Draw();
  gr_feb_t2_max[0]->GetPoint(1, utstart, temper1);
  timeStr_start = "Time start : ";
  timeStr_start += getLocalTimeStringFromUnixTime( utstart );
  gr_feb_t2_max[0]->GetPoint(gr_feb_t2_max[0]->GetN()-1, utstop, temper1);
  timeStr_stop = "Time stop : ";
  timeStr_stop += getLocalTimeStringFromUnixTime( utstop );
  TText *text2_start = new TText(0.1,0.5,timeStr_start.Data());
  //text2_start->SetTextAlign(22);
  text2_start->SetTextSize(0.05);
  text2_start->Draw();
  TText *text2_stop = new TText(0.1,0.45,timeStr_stop.Data());
  //text2_stop->SetTextAlign(22);
  text2_stop->SetTextSize(0.05);
  text2_stop->Draw();
  //
  c3->cd(8);
  gStyle->SetOptStat(kFALSE);
  h1_ARICHSectorHist_t2->Draw("ZCOLOR TEXT");
  h1_ARICHSectorHist_t2->SetMarkerSize(3.0);
  h1_ARICHSectorHist_t2->SetTitle("Average temperature (t2) during last 24 h");
  h1_ARICHSectorHist_t2->GetZaxis()->SetRangeUser(xtMin, xtMax);
  //
  c3->cd(12);
  c3->GetPad(12)->SetGrid();
  c3->GetPad(12)->SetLogy();
  //gStyle->SetOptStat(kTRUE);
  h1_feb_t2->SetLineColor(kBlack);
  h1_feb_t2->SetLineWidth(2);
  h1_feb_t2->SetTitle("FEB t2 temperature, C^{o}");
  h1_feb_t2->Draw();
  h1_feb_t2->GetXaxis()->SetTitle("FEB t2 temperature, C^{o}");
  //
  if(th2polyMapPlotConfigID == 0){
    for(unsigned int i = 0; i<unixTimeVec.size();i++){
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_1, dh_test)){
	c3->cd(9);
	h2_feb_t2_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t2_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	//h2_feb_t2_v[i]->Draw("");
	cout<<"DrawHistoC1"<<endl;
	h2_feb_t1_v[i]->DrawHistoC1( "same ZCOLOR text lcol", "", h2_feb_t1_v[i]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_2, dh_test)){
	c3->cd(10);
	h2_feb_t2_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t2_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_feb_t2_v[i]->Draw("");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_3, dh_test)){
	c3->cd(11);
	h2_feb_t2_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_feb_t2_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_feb_t2_v[i]->Draw("");
      }
    }
  }
  else if(th2polyMapPlotConfigID == 1){
    unsigned int iclosest1 = find_closest_good_measurement(unixTimeVec, h_test_plots_1);
    cout<<"iclosest1 "<<iclosest1<<endl;
    c3->cd(9);
    h2_feb_t2_v[iclosest1]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest1]));
    h2_feb_t2_v[iclosest1]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t2_v[iclosest1]->Draw("");
    h2_feb_t2_v[iclosest1]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t2_v[iclosest1]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
    //
    unsigned int iclosest2 = find_closest_good_measurement(unixTimeVec, h_test_plots_2);
    cout<<"iclosest2 "<<iclosest2<<endl;
    c3->cd(10);
    h2_feb_t2_v[iclosest2]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest2]));
    h2_feb_t2_v[iclosest2]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t2_v[iclosest2]->Draw("");
    h2_feb_t2_v[iclosest2]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t2_v[iclosest2]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
    //
    unsigned int iclosest3 = find_closest_good_measurement(unixTimeVec, h_test_plots_3);
    cout<<"iclosest3 "<<iclosest3<<endl;
    c3->cd(11);
    h2_feb_t2_v[iclosest3]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest3]));
    h2_feb_t2_v[iclosest3]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_feb_t2_v[iclosest3]->Draw("");
    h2_feb_t2_v[iclosest3]->DrawHistoC1( "same ZCOLOR", "", h2_feb_t2_v[iclosest3]->GetTitle(),"drawLine", xtMin, xtMax, c2, 0);
  }
  else{
    cout<<"ERROR --> th2polyMapPlotConfigID = "<<th2polyMapPlotConfigID<<endl;
    assert(0);
  }    
  c3->Modified();
  c3->Update();
  outPdfFileName = outRootFileName;
  outPdfFileName += "_t2.pdf";
  c3->SaveAs(outPdfFileName.Data());
  /////////////////////////////////
  TFile* rootFile = new TFile(outRootFileName.Data(), "RECREATE", " Histograms", 1);
  rootFile->cd();
  if (rootFile->IsZombie()){
    cout<<"  ERROR ---> file "<<outRootFileName.Data()<<" is zombi"<<endl;
    assert(0);
  }
  else
    cout<<"  Output Histos file ---> "<<outRootFileName.Data()<<endl;
  //h2_febt1_vs_meas->GetZaxis()->SetRangeUser(xtMin,xtMax);
  //h2_febt2_vs_meas->GetZaxis()->SetRangeUser(xtMin,xtMax);
  gr_feb_t1->Write();
  gr_feb_t2->Write();
  gr_feb_dt->Write();
  h2_febt1_vs_meas->Write();
  h2_febt2_vs_meas->Write();
  h1_feb_t1->Write();
  h1_feb_t2->Write();
  for (int i = 0; i<nSectors; i++){
    gr_feb_t1_max[i]->Write();
    gr_feb_t1_min[i]->Write();
    gr_feb_t1_ave[i]->Write();
    gr_feb_t2_max[i]->Write();
    gr_feb_t2_min[i]->Write();
    gr_feb_t2_ave[i]->Write();
  }
  for (int i = 0; i<nSectors; i++){
    mg1[i]->Write();
    mg2[i]->Write();
  }
  c2->Write();
  c3->Write();
  rootFile->Close();  
  //
}

void tGraphInit(TGraph *gr[nSectors], TString grName, TString grTitle){
  Int_t i;
  Int_t isec;
  TString grNameh;
  TString grTitleh;
  for(i = 0;i<nSectors;i++){
    isec = i + 1;
    grNameh = grName; grNameh += "_"; grNameh += "sec_"; grNameh += isec;
    grTitleh = grTitle; grTitleh += " "; grTitleh += "sec "; grTitleh += isec;
    gr[i] = new TGraph();
    gr[i]->SetTitle(grTitleh.Data());
    gr[i]->SetName(grNameh.Data());
  }
}
