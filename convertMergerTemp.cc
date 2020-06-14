/***********************************************************************
* Copyright(C) 2018 - LBS - (Single person developer.)                 *
* Sun Oct 21 12:56:15 JST 2018                                         *
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

const Int_t nBinsmerger_t = 300;
const Double_t merger_tmin = 0.0;
const Double_t merger_tmax = 100.0;
const Double_t tPhysicalMin = 10;
const Double_t tPhysicalMax = 100;
const Double_t xtMin = 25;
const Double_t xtMax = 50;
const Int_t nSectors = 6;
///////////////////////////////////////////////////////////////////////////
const Double_t h_test_plots_1 =  3;     // 03:00 night                   //
const Double_t h_test_plots_2 = 11;     // 11:00 day                     //
const Double_t h_test_plots_3 = 19;     // 19:00 evening                 //
const Double_t dh_test        = 0.1;    // 6 min window of interests     //
const Int_t th2polyMapPlotConfigID = 1; // 0 - given time within dh_test //
//                                      // 1 - closest given time        //
///////////////////////////////////////////////////////////////////////////

void convertMergerTemp( TString infile = "./data_qqq/mgrtemp-qqq-qqq",
			TString outPdfFileNamePreff = "./data_qqq/mgrtemp-qqq-qqq",
			Int_t numberOfSectorsToReads = 1,
			TString hapdTemplateMappingPath = "hapdTemplateMapping.dat",
			TString fnameInfoMergerPos = "merger_positions.dat"){
     
  cout<<"infile : "<<infile<<endl;
  
  ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb(hapdTemplateMappingPath);
  //arichmap->printMappingConstants();
  //arichmap->dumpMapping();
  
  ARICHMergerHist *h2_merger_t_fpga = new ARICHMergerHist( "h2_merger_t_fpga", "merger_t_fpga", fnameInfoMergerPos);
  ARICHMergerHist *h2_merger_t_board = new ARICHMergerHist( "h2_merger_t_board", "merger_t_board", fnameInfoMergerPos);

  // bin 0 - unixtime
  // bin 1 - sectorID
  TH1D *h1_info = new TH1D("h1_info","info",2,1,2);

  //181016-151536
  //Reading FPGA system temp
  //cpr4016
  //arich[0].systemp : 29.530298
  //arich[1].systemp : 29.038136
  //arich[2].systemp : 30.022461
  //arich[3].systemp : 31.498951
  //cpr4017
  //arich[0].systemp : 32.975441
  //arich[1].systemp : 30.514624
  //arich[2].systemp : 33.959766
  //arich[3].systemp : 31.498951
  //cpr4018
  //arich[0].systemp : 29.038136
  //arich[1].systemp : 30.514624
  //arich[2].systemp : 32.975441
  //arich[3].systemp : 31.991114
  //Reading Merger sensor temp
  //cpr4016
  //arich[0].temp : 29.062500
  //arich[1].temp : 30.687500
  //arich[2].temp : 31.625000
  //arich[3].temp : 32.625000
  //cpr4017
  //arich[0].temp : 32.250000
  //arich[1].temp : 32.062500
  //arich[2].temp : 32.187500
  //arich[3].temp : 30.500000
  //cpr4018
  //arich[0].temp : 31.687500
  //arich[1].temp : 31.250000
  //arich[2].temp : 33.562500
  //arich[3].temp : 31.437500

  //Double_t unixTime;
  ifstream filest (infile.Data());
  string line;
  TString timeStr;
  TString timeNormalFormatStr;
  TString copperStr;
  Int_t copperID;
  Int_t secID;
  TString str;
  Float_t t_fpga;
  Float_t t_board;
  Int_t mergerLocalID;
  Int_t mergerID;
  TString h2_merger_t_fpga_title;
  TString h2_merger_t_board_title;
  Int_t goKey = 1;
  if(filest.is_open()){
    while( getline (filest,line) ) { //181016-151536
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
      h2_merger_t_fpga_title = h2_merger_t_fpga->GetTitle();
      h2_merger_t_fpga_title += " ";
      h2_merger_t_fpga_title += timeNormalFormatStr;
      h2_merger_t_board_title = h2_merger_t_board->GetTitle();
      h2_merger_t_board_title += " ";
      h2_merger_t_board_title += timeNormalFormatStr;
      //cout<<"timeNormalFormatStr "<<timeNormalFormatStr<<endl;
      for(Int_t sec_i = 0; sec_i<numberOfSectorsToReads;sec_i++){
	//getline ( filest, line);       //Reading FPGA system temp
	for(Int_t copper_i = 0; copper_i<arichmap->GetnCopperPerSector();copper_i++){
	  getline ( filest, line);       //cpr4016
	  goKey = 1;
	  copperStr = line;
	  copperID = getCopperIDFrom_TString(copperStr);      
	  secID = arichmap->getSectorIDFromCopperBoardID(copperID);
	  h1_info->SetBinContent(2,secID);
	  cout<<"copperID = "<<copperID<<endl;
	  for(Int_t i = 0;i<arichmap->GetnMergersPerCopper();i++){
	    if(goKey == 1)
	      getline ( filest, line);  //arich[0].systemp : 29.530298
	    if(line == "timeout"){
	      //cout<<"---> timeout"<<endl;
	      goKey = 0;
	    }
	    if(goKey == 1){
	      str = line;
	      //cout<<line<<endl;
	      getMergerIDandTemperatureFrom_TString(str, t_fpga, mergerLocalID);
	      mergerID = arichmap->getMergerIDFromCopperBoardIDAndMergerLocalID( copperID, mergerLocalID);
	      h2_merger_t_fpga->SetBinContent(h2_merger_t_fpga->GetBinIDFromMergerSlotNumber(mergerID), roundf(t_fpga * 100) / 100);
	    }
	  }
	}
	//getline ( filest, line);       //Reading Merger sensor temp
	for(Int_t copper_i = 0; copper_i<arichmap->GetnCopperPerSector();copper_i++){
	  getline ( filest, line);       //cpr4016
	  goKey = 1;
	  copperStr = line;
	  copperID = getCopperIDFrom_TString(copperStr);      
	  secID = arichmap->getSectorIDFromCopperBoardID(copperID);
	  cout<<"copperID = "<<copperID<<endl;
	  for(Int_t i = 0;i<arichmap->GetnMergersPerCopper();i++){
	    if(goKey == 1)
	      getline ( filest, line);  //arich[0].temp : 29.062500
	    str = line;
	    if(line == "timeout"){
	      //cout<<"---> timeout"<<endl;
	      goKey = 0;
	    }
	    if(goKey == 1){
	      //cout<<line<<endl;
	      getMergerIDandTemperatureFrom_TString(str, t_board, mergerLocalID);
	      mergerID = arichmap->getMergerIDFromCopperBoardIDAndMergerLocalID( copperID, mergerLocalID);
	      h2_merger_t_board->SetBinContent(h2_merger_t_board->GetBinIDFromMergerSlotNumber(mergerID), roundf(t_board * 100) / 100);
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

  h2_merger_t_fpga->Write();
  h2_merger_t_board->Write();
  h1_info->Write();  

  TString outPdfFileName_fpga_t = outPdfFileNamePreff; outPdfFileName_fpga_t += "_fpga_t.pdf";
  TString outPdfFileName_board_t = outPdfFileNamePreff; outPdfFileName_board_t += "_board_t.pdf";
  h2_merger_t_fpga->DrawHisto( "ZCOLOR text same", outPdfFileName_fpga_t.Data(), h2_merger_t_fpga_title,"drawLine", xtMin, xtMax);
  h2_merger_t_board->DrawHisto( "ZCOLOR text same", outPdfFileName_board_t.Data(), h2_merger_t_board_title,"drawLine", xtMin, xtMax);
  
  rootFile->Close();

}

void mergMergerTemp(TString outRootFileName, TString hapdTemplateMappingPath, TString fnameInfoMergerPos, vector<TString> inRootHistList){
  std::cout<<"mergMergerTemp"<<std::endl;
  std::cout<<"outRootFileName "<<outRootFileName<<std::endl;
  Double_t timeAxisLabelOffset = 0.025;
  for (unsigned i = 0; i<inRootHistList.size(); i++)
    std::cout<<inRootHistList[i]<<'\n';
  TGraph *gr_merger_t_fpga =new TGraph(); gr_merger_t_fpga->SetTitle("gr_merger_t_fpga"); gr_merger_t_fpga->SetName("gr_merger_t_fpga");
  TGraph *gr_merger_t_board =new TGraph(); gr_merger_t_board->SetTitle("gr_merger_t_board"); gr_merger_t_board->SetName("gr_merger_t_board");
  TGraph *gr_merger_dt =new TGraph(); gr_merger_dt->SetTitle("gr_merger_dt"); gr_merger_dt->SetName("gr_merger_dt");
  TH1D *h1_merger_t_fpga = new TH1D("h1_merger_t_fpga","merger t fpga",nBinsmerger_t,merger_tmin,merger_tmax);
  TH1D *h1_merger_t_board = new TH1D("h1_merger_t_board","merger t board",nBinsmerger_t,merger_tmin,merger_tmax);
  TGraph *gr_merger_t_fpga_max[nSectors];
  TGraph *gr_merger_t_fpga_min[nSectors];
  TGraph *gr_merger_t_fpga_ave[nSectors];
  TGraph *gr_merger_t_board_max[nSectors];
  TGraph *gr_merger_t_board_min[nSectors];
  TGraph *gr_merger_t_board_ave[nSectors];
  tGraphInit( gr_merger_t_fpga_max, "gr_merger_t_fpga_max", "merger t_{fpga} max");
  tGraphInit( gr_merger_t_fpga_min, "gr_merger_t_fpga_min", "merger t_{fpga} min");
  tGraphInit( gr_merger_t_fpga_ave, "gr_merger_t_fpga_ave", "merger t_{fpga} average");
  tGraphInit( gr_merger_t_board_max, "gr_merger_t_board_max", "merger t_{board} max");
  tGraphInit( gr_merger_t_board_min, "gr_merger_t_board_min", "merger t_{board} min");
  tGraphInit( gr_merger_t_board_ave, "gr_merger_t_board_ave", "merger t_{board} average");
  double unixTime;
  double tfpga;
  double tboard;
  double dt;
  ARICHmappingCopperMergerFeb *arichmap = new ARICHmappingCopperMergerFeb(hapdTemplateMappingPath);
  ARICHSectorHist *h1_ARICHSectorHist_t_fpga_n = new ARICHSectorHist("h1_ARICHSectorHist_t_fpga_n","ARICHSectorHist tfpga n measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t_fpga_sum = new ARICHSectorHist("h1_ARICHSectorHist_t_fpga_sum","ARICHSectorHist tfpga sum measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t_fpga = new ARICHSectorHist("h1_ARICHSectorHist_t_fpga","ARICHSectorHist tfpga measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t_board_n = new ARICHSectorHist("h1_ARICHSectorHist_t2_n","ARICHSectorHist tboard n measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t_board_sum = new ARICHSectorHist("h1_ARICHSectorHist_t2_sum","ARICHSectorHist tboard sum measurements");
  ARICHSectorHist *h1_ARICHSectorHist_t_board = new ARICHSectorHist("h1_ARICHSectorHist_t2","ARICHSectorHist tboard measurements");
  Int_t merID;
  Int_t sec_i;
  Int_t cop_i;
  Int_t mer_i;
  double tfpga_persector_max[nSectors];
  double tfpga_persector_min[nSectors];
  double tfpga_persector_ave[nSectors];
  int tfpga_persector_nVal[nSectors];
  double tboard_persector_max[nSectors];
  double tboard_persector_min[nSectors];
  double tboard_persector_ave[nSectors];
  int tboard_persector_nVal[nSectors];
  vector<double> unixTimeVec;
  vector<ARICHMergerHist*> h2_merger_t_fpga_v;
  vector<ARICHMergerHist*> h2_merger_t_board_v;
  for (unsigned i=0; i<inRootHistList.size(); i++){
    std::cout<<inRootHistList[i]<<'\n';
    TFile *f1 = new TFile(inRootHistList[i].Data());
    TH2Poly *h2_merger_t_fpga = (TH2Poly*)f1->Get("h2_merger_t_fpga");
    TH2Poly *h2_merger_t_board = (TH2Poly*)f1->Get("h2_merger_t_board");
    TH1D *h1_info = (TH1D*)f1->Get("h1_info");
    unixTime = h1_info->GetBinContent(1);
    unixTimeVec.push_back(unixTime);
    //cout<<i<<endl;
    ARICHMergerHist *h2_merger_t_fpga_clone = new ARICHMergerHist(h2_merger_t_fpga->GetName(),h2_merger_t_fpga->GetTitle(),fnameInfoMergerPos);
    for(unsigned int i = 1; i<=(unsigned int)arichmap->GetnMergers();i++)
      h2_merger_t_fpga_clone->SetBinContent(i,h2_merger_t_fpga->GetBinContent(i));
    h2_merger_t_fpga_v.push_back(h2_merger_t_fpga_clone);
    ARICHMergerHist *h2_merger_t_board_clone = new ARICHMergerHist(h2_merger_t_board->GetName(),h2_merger_t_board->GetTitle(),fnameInfoMergerPos);
    for(unsigned int i = 1; i<=(unsigned int)arichmap->GetnMergers();i++)
      h2_merger_t_board_clone->SetBinContent(i,h2_merger_t_board->GetBinContent(i));
    h2_merger_t_board_v.push_back(h2_merger_t_board_clone);
    for(int k = 0; k<nSectors;k++){
      tfpga_persector_max[k] = tPhysicalMin;
      tfpga_persector_min[k] = tPhysicalMax;
      tfpga_persector_ave[k] = 0.0;
      tfpga_persector_nVal[k] = 0;
      tboard_persector_max[k] = tPhysicalMin;
      tboard_persector_min[k] = tPhysicalMax;
      tboard_persector_ave[k] = 0.0;
      tboard_persector_nVal[k] = 0;
    }    
    for(int j = 1;j<=arichmap->GetnMergers();j++){
      tfpga = h2_merger_t_fpga->GetBinContent(j);
      tboard = h2_merger_t_board->GetBinContent(j);
      dt = tfpga - tboard;
      gr_merger_t_fpga->SetPoint(gr_merger_t_fpga->GetN(), unixTime, tfpga);
      gr_merger_t_board->SetPoint(gr_merger_t_board->GetN(), unixTime, tboard);
      h1_merger_t_fpga->Fill(tfpga);
      h1_merger_t_board->Fill(tboard);
      if(tfpga>0.0 && tboard>0.0)
	gr_merger_dt->SetPoint(gr_merger_dt->GetN(), unixTime, dt);
      ///////////////////////
      merID = j;
      arichmap->findPositionInarichmappingFormGlobalMergerID(merID, sec_i, cop_i, mer_i);
	if(sec_i >= 0 && sec_i< nSectors){
	  if(tfpga > tPhysicalMin && tfpga < tPhysicalMax){
	    if(tfpga_persector_max[sec_i] < tfpga)
	      tfpga_persector_max[sec_i] = tfpga;
	    if(tfpga_persector_min[sec_i] > tfpga)
	      tfpga_persector_min[sec_i] = tfpga;
	    tfpga_persector_ave[sec_i] = tfpga_persector_ave[sec_i] + tfpga;
	    tfpga_persector_nVal[sec_i] = tfpga_persector_nVal[sec_i] + 1;
	    h1_ARICHSectorHist_t_fpga_n->SetBinContent(sec_i+1,h1_ARICHSectorHist_t_fpga_n->GetBinContent(sec_i+1)+1);
	    h1_ARICHSectorHist_t_fpga_sum->SetBinContent(sec_i+1,h1_ARICHSectorHist_t_fpga_sum->GetBinContent(sec_i+1)+tfpga);
	  }
	  if(tboard > tPhysicalMin && tboard < tPhysicalMax){
	    if(tboard_persector_max[sec_i] < tboard)
	      tboard_persector_max[sec_i] = tboard;
	    if(tboard_persector_min[sec_i] > tboard)
	      tboard_persector_min[sec_i] = tboard;
	    tboard_persector_ave[sec_i] = tboard_persector_ave[sec_i] + tboard;
	    tboard_persector_nVal[sec_i] = tboard_persector_nVal[sec_i] + 1;
	    h1_ARICHSectorHist_t_board_n->SetBinContent(sec_i+1,h1_ARICHSectorHist_t_board_n->GetBinContent(sec_i+1)+1);
	    h1_ARICHSectorHist_t_board_sum->SetBinContent(sec_i+1,h1_ARICHSectorHist_t_board_sum->GetBinContent(sec_i+1)+tboard);
	  }
	}
	///////////////////////
    }    
    for(int k = 0; k<nSectors;k++){
      if(tfpga_persector_nVal[k]>0){
	gr_merger_t_fpga_max[k]->SetPoint(gr_merger_t_fpga_max[k]->GetN(), unixTime, tfpga_persector_max[k]);
	gr_merger_t_fpga_min[k]->SetPoint(gr_merger_t_fpga_min[k]->GetN(), unixTime, tfpga_persector_min[k]);
	gr_merger_t_fpga_ave[k]->SetPoint(gr_merger_t_fpga_ave[k]->GetN(), unixTime, tfpga_persector_ave[k]/tfpga_persector_nVal[k]);
	if(h1_ARICHSectorHist_t_fpga_n->GetBinContent(k+1)>0.0){
	  double fpgaAverageRound = roundf(h1_ARICHSectorHist_t_fpga_sum->GetBinContent(k+1)/h1_ARICHSectorHist_t_fpga_n->GetBinContent(k+1) * 100 ) / 100;
	  h1_ARICHSectorHist_t_fpga->SetBinContent(k+1,fpgaAverageRound);
	}
      }
      if(tboard_persector_nVal[k]>0){
	gr_merger_t_board_max[k]->SetPoint(gr_merger_t_board_max[k]->GetN(), unixTime, tboard_persector_max[k]);
	gr_merger_t_board_min[k]->SetPoint(gr_merger_t_board_min[k]->GetN(), unixTime, tboard_persector_min[k]);
	gr_merger_t_board_ave[k]->SetPoint(gr_merger_t_board_ave[k]->GetN(), unixTime, tboard_persector_ave[k]/tboard_persector_nVal[k]);
	if(h1_ARICHSectorHist_t_board_n->GetBinContent(k+1)>0.0){
	  double boardAverageRound = roundf(h1_ARICHSectorHist_t_board_sum->GetBinContent(k+1)/h1_ARICHSectorHist_t_board_n->GetBinContent(k+1) * 100 ) / 100;
	  h1_ARICHSectorHist_t_board->SetBinContent(k+1,boardAverageRound);
	}
      }
    }
    f1->Close();
  }
  /////////////////////////
  gStyle->SetPalette(kRainBow);
  TCanvas *c2 = new TCanvas("c2","c2",10,10,1600,1200);
  c2->SetTitle("Merger t_{fpga} info");
  c2->SetName("merger_t_fpga_info");
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
    gr_merger_t_fpga_max[i]->SetMarkerStyle(7);
    gr_merger_t_fpga_max[i]->SetMarkerColor(kRed);
    gr_merger_t_fpga_max[i]->SetLineColor(kRed);
    gr_merger_t_fpga_max[i]->SetLineWidth(1);
    gr_merger_t_fpga_max[i]->GetXaxis()->SetTimeDisplay(1);
    gr_merger_t_fpga_min[i]->SetMarkerStyle(7);
    gr_merger_t_fpga_min[i]->SetMarkerColor(kBlue);
    gr_merger_t_fpga_min[i]->SetLineColor(kBlue);
    gr_merger_t_fpga_min[i]->SetLineWidth(1);
    gr_merger_t_fpga_min[i]->GetXaxis()->SetTimeDisplay(1);
    gr_merger_t_fpga_ave[i]->SetMarkerStyle(7);
    gr_merger_t_fpga_ave[i]->SetMarkerColor(kBlack);
    gr_merger_t_fpga_ave[i]->SetLineColor(kBlack);
    gr_merger_t_fpga_ave[i]->SetLineWidth(1);
    gr_merger_t_fpga_ave[i]->GetXaxis()->SetTimeDisplay(1);
    mg1[i]->Add(gr_merger_t_fpga_max[i]);
    mg1[i]->Add(gr_merger_t_fpga_min[i]);
    mg1[i]->Add(gr_merger_t_fpga_ave[i]);
    TString mg1Title = "Merger t_{fpga} Sec ";
    TString mg1Name = "mg1_tfpga_Sec_";
    mg1Title += i+1;
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
    mg1[i]->GetYaxis()->SetTitle("Merger t_{fpga}, C^{o}");
    //gr_feb_t1_max[i]->Draw("AP");
  }
  c2->cd(4);
  TLegend *leg = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg->AddEntry(gr_merger_t_fpga_max[1], "Merger t_{fpga} max","lp");
  leg->AddEntry(gr_merger_t_fpga_min[1], "Merger t_{fpga} min","lp");
  leg->AddEntry(gr_merger_t_fpga_ave[1], "Merger t_{fpga} average","lp");
  leg->Draw();
  double utstart;
  double utstop;
  double temper1;
  gr_merger_t_fpga_max[0]->GetPoint(1, utstart, temper1);
  TString timeStr_start = "Time start : ";
  timeStr_start += getLocalTimeStringFromUnixTime( utstart );
  gr_merger_t_fpga_max[0]->GetPoint(gr_merger_t_fpga_max[0]->GetN()-1, utstop, temper1);
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
  h1_ARICHSectorHist_t_fpga->Draw("ZCOLOR TEXT");
  h1_ARICHSectorHist_t_fpga->SetMarkerSize(3.0);
  h1_ARICHSectorHist_t_fpga->SetTitle("Average temperature (fpga) during last 24 h");
  h1_ARICHSectorHist_t_fpga->GetZaxis()->SetRangeUser(xtMin, xtMax);
  //
  c2->cd(12);
  c2->GetPad(12)->SetGrid();
  c2->GetPad(12)->SetLogy();
  //gStyle->SetOptStat(kTRUE);
  h1_merger_t_fpga->SetLineColor(kBlack);
  h1_merger_t_fpga->SetLineWidth(1);
  h1_merger_t_fpga->SetTitle("Merger t_{fpga}, C^{o}");
  h1_merger_t_fpga->Draw();
  h1_merger_t_fpga->GetXaxis()->SetTitle("Merger t_{fpga}, C^{o}");
  //
  if(th2polyMapPlotConfigID == 0){
    for(unsigned i = 0; i<unixTimeVec.size();i++){
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_1, dh_test)){
	c2->cd(9);
	h2_merger_t_fpga_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_fpga_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_fpga_v[i]->Draw("ZCOLOR");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_2, dh_test)){
	c2->cd(10);
	h2_merger_t_fpga_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_fpga_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_fpga_v[i]->Draw("ZCOLOR");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_3, dh_test)){
	c2->cd(11);
	h2_merger_t_fpga_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_fpga_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_fpga_v[i]->Draw("ZCOLOR");
      }
    }
  }
  else if(th2polyMapPlotConfigID == 1){
    unsigned int iclosest1 = find_closest_good_measurement(unixTimeVec, h_test_plots_1);
    cout<<"iclosest1 "<<iclosest1<<endl;
    c2->cd(9);
    h2_merger_t_fpga_v[iclosest1]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest1]));
    h2_merger_t_fpga_v[iclosest1]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_fpga_v[iclosest1]->Draw("ZCOLOR");
    h2_merger_t_fpga_v[iclosest1]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_fpga_v[iclosest1]->GetTitle(),"drawLine", xtMin, xtMax, c2);
    //
    unsigned int iclosest2 = find_closest_good_measurement(unixTimeVec, h_test_plots_2);
    cout<<"iclosest2 "<<iclosest2<<endl;
    c2->cd(10);
    h2_merger_t_fpga_v[iclosest2]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest2]));
    h2_merger_t_fpga_v[iclosest2]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_fpga_v[iclosest2]->Draw("ZCOLOR");
    h2_merger_t_fpga_v[iclosest2]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_fpga_v[iclosest2]->GetTitle(),"drawLine", xtMin, xtMax, c2);
    //
    unsigned int iclosest3 = find_closest_good_measurement(unixTimeVec, h_test_plots_3);
    cout<<"iclosest3 "<<iclosest3<<endl;
    c2->cd(11);
    h2_merger_t_fpga_v[iclosest3]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest3]));
    h2_merger_t_fpga_v[iclosest3]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_fpga_v[iclosest3]->Draw("ZCOLOR");
    h2_merger_t_fpga_v[iclosest3]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_fpga_v[iclosest3]->GetTitle(),"drawLine", xtMin, xtMax, c2);
  }
  else{
    cout<<"ERROR --> th2polyMapPlotConfigID = "<<th2polyMapPlotConfigID<<endl;
    assert(0);
  }
  c2->Modified();
  c2->Update();
  TString outPdfFileName = outRootFileName;
  outPdfFileName += "_fpga.pdf";
  c2->SaveAs(outPdfFileName.Data());
  //////////////////////////////////////////////////////////
  TCanvas *c3 = new TCanvas("c3","c3",20,20,1600,1200);
  c3->SetTitle("Merger t_{board} info");
  c3->SetName("merger_t_board_info");
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
    gr_merger_t_board_max[i]->SetMarkerStyle(7);
    gr_merger_t_board_max[i]->SetMarkerColor(kRed);
    gr_merger_t_board_max[i]->SetLineColor(kRed);
    gr_merger_t_board_max[i]->SetLineWidth(1);
    gr_merger_t_board_max[i]->GetXaxis()->SetTimeDisplay(1);
    gr_merger_t_board_min[i]->SetMarkerStyle(7);
    gr_merger_t_board_min[i]->SetMarkerColor(kBlue);
    gr_merger_t_board_min[i]->SetLineColor(kBlue);
    gr_merger_t_board_min[i]->SetLineWidth(1);
    gr_merger_t_board_min[i]->GetXaxis()->SetTimeDisplay(1);
    gr_merger_t_board_ave[i]->SetMarkerStyle(7);
    gr_merger_t_board_ave[i]->SetMarkerColor(kBlack);
    gr_merger_t_board_ave[i]->SetLineColor(kBlack);
    gr_merger_t_board_ave[i]->SetLineWidth(1);
    gr_merger_t_board_ave[i]->GetXaxis()->SetTimeDisplay(1);
    mg2[i]->Add(gr_merger_t_board_max[i]);
    mg2[i]->Add(gr_merger_t_board_min[i]);
    mg2[i]->Add(gr_merger_t_board_ave[i]);
    TString mg2Title = "Merger t_{board} Sec ";
    TString mg2Name = "mg2_t_board_Sec_";
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
    mg2[i]->GetYaxis()->SetTitle("Merger t_{board}, C^{o}");
    //gr_feb_t2_max[i]->Draw("AP");
  }
  c3->cd(4);
  TLegend *leg2 = new TLegend(0.1,0.6,0.9,0.9,"","brNDC");
  leg2->AddEntry(gr_merger_t_board_max[1], "Merger t_{board} max","lp");
  leg2->AddEntry(gr_merger_t_board_min[1], "Merger t_{board} min","lp");
  leg2->AddEntry(gr_merger_t_board_ave[1], "Merger t_{board} average","lp");
  leg2->Draw();
  gr_merger_t_board_max[0]->GetPoint(1, utstart, temper1);
  timeStr_start = "Time start : ";
  timeStr_start += getLocalTimeStringFromUnixTime( utstart );
  gr_merger_t_board_max[0]->GetPoint(gr_merger_t_board_max[0]->GetN()-1, utstop, temper1);
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
  h1_ARICHSectorHist_t_board->Draw("ZCOLOR TEXT");
  h1_ARICHSectorHist_t_board->SetMarkerSize(3.0);
  h1_ARICHSectorHist_t_board->SetTitle("Average temperature (board) during last 24 h");
  h1_ARICHSectorHist_t_board->GetZaxis()->SetRangeUser(xtMin, xtMax);
  //
  c3->cd(12);
  c3->GetPad(12)->SetGrid();
  c3->GetPad(12)->SetLogy();
  //gStyle->SetOptStat(kTRUE);
  h1_merger_t_board->SetLineColor(kBlack);
  h1_merger_t_board->SetLineWidth(2);
  h1_merger_t_board->SetTitle("Merger t_{board}, C^{o}");
  h1_merger_t_board->Draw();
  h1_merger_t_board->GetXaxis()->SetTitle("Merger t_{board}, C^{o}");
  //
  if(th2polyMapPlotConfigID == 0){
    for(unsigned i = 0; i<unixTimeVec.size();i++){
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_1, dh_test)){
	c3->cd(9);
	h2_merger_t_board_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_board_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_board_v[i]->Draw("ZCOLOR");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_2, dh_test)){
	c3->cd(10);
	h2_merger_t_board_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_board_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_board_v[i]->Draw("ZCOLOR");
      }
      //
      if(check_If_ut_is_in_the_window(unixTimeVec[i], h_test_plots_3, dh_test)){
	c3->cd(11);
	h2_merger_t_board_v[i]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[i]));
	h2_merger_t_board_v[i]->GetZaxis()->SetRangeUser(xtMin, xtMax);
	h2_merger_t_board_v[i]->Draw("ZCOLOR");
      }
    }
  }
  else if(th2polyMapPlotConfigID == 1){
    unsigned int iclosest1 = find_closest_good_measurement(unixTimeVec, h_test_plots_1);
    cout<<"iclosest1 "<<iclosest1<<endl;
    c3->cd(9);
    h2_merger_t_board_v[iclosest1]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest1]));
    h2_merger_t_board_v[iclosest1]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_board_v[iclosest1]->Draw("ZCOLOR");
    h2_merger_t_board_v[iclosest1]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_board_v[iclosest1]->GetTitle(),"drawLine", xtMin, xtMax, c2);
    //
    unsigned int iclosest2 = find_closest_good_measurement(unixTimeVec, h_test_plots_2);
    cout<<"iclosest2 "<<iclosest2<<endl;
    c3->cd(10);
    h2_merger_t_board_v[iclosest2]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest2]));
    h2_merger_t_board_v[iclosest2]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_board_v[iclosest2]->Draw("ZCOLOR");
    h2_merger_t_board_v[iclosest2]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_board_v[iclosest2]->GetTitle(),"drawLine", xtMin, xtMax, c2);
    //
    unsigned int iclosest3 = find_closest_good_measurement(unixTimeVec, h_test_plots_3);
    cout<<"iclosest3 "<<iclosest3<<endl;
    c3->cd(11);
    h2_merger_t_board_v[iclosest3]->SetTitle(getLocalTimeStringFromUnixTime(unixTimeVec[iclosest3]));
    h2_merger_t_board_v[iclosest3]->GetZaxis()->SetRangeUser(xtMin, xtMax);
    //h2_merger_t_board_v[iclosest3]->Draw("ZCOLOR");
    h2_merger_t_board_v[iclosest3]->DrawHistoC1( "same ZCOLOR", "", h2_merger_t_board_v[iclosest3]->GetTitle(),"drawLine", xtMin, xtMax, c2);
  }
  else{
    cout<<"ERROR --> th2polyMapPlotConfigID = "<<th2polyMapPlotConfigID<<endl;
    assert(0);
  }
  c3->Modified();
  c3->Update();
  TString outPdfFileName2 = outRootFileName;
  outPdfFileName2 += "_board.pdf";
  c3->SaveAs(outPdfFileName2.Data());
  //////////////////////////////////////////////////////////
  TFile* rootFile = new TFile(outRootFileName.Data(), "RECREATE", " Histograms", 1);
  rootFile->cd();
  if (rootFile->IsZombie()){
    cout<<"  ERROR ---> file "<<outRootFileName.Data()<<" is zombi"<<endl;
    assert(0);
  }
  else
    cout<<"  Output Histos file ---> "<<outRootFileName.Data()<<endl;
  gr_merger_t_fpga->Write();
  gr_merger_t_board->Write();
  gr_merger_dt->Write();
  h1_merger_t_fpga->Write();
  h1_merger_t_board->Write();
  for (int i = 0; i<nSectors; i++){
    gr_merger_t_fpga_max[i]->Write();
    gr_merger_t_fpga_min[i]->Write();
    gr_merger_t_fpga_ave[i]->Write();
    gr_merger_t_board_max[i]->Write();
    gr_merger_t_board_min[i]->Write();
    gr_merger_t_board_ave[i]->Write();
  }
  for (int i = 0; i<nSectors; i++){
    mg1[i]->Write();
    mg2[i]->Write();
  }
  c2->Write();
  c3->Write();
  rootFile->Close();  
  ////////////////////////
}
