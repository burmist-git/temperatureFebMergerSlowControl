/***********************************************************************
* Copyright(C) 2018 - LBS - (Single person developer.)                 *
* Fri Oct 19 16:55:40 JST 2018                                         *
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

//C, C++
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <iomanip>
#include <vector>
#include <time.h>

using namespace std;

double getUnixTimeFrom_year_month_day_hour_min_sec(double d_year, double d_month, double d_day, double d_hour, double d_min, double d_sec){
  struct tm y2k = {0};
  y2k.tm_year = d_year - 1900; y2k.tm_mon = d_month-1; y2k.tm_mday = d_day;
  y2k.tm_hour = d_hour;   y2k.tm_min = d_min; y2k.tm_sec = d_sec;
  return difftime(mktime(&y2k),0);
}

TString getLocalTimeStringFromUnixTime( double ut ){
  time_t t_ut = ut;
  struct tm * timeinfo = localtime(&t_ut);
  TString timeStr = asctime(timeinfo);
  //printf ("Current local time and date: %s", asctime(timeinfo));
  return timeStr;
}

//[2018-10-01 11:37:56]
double getUnixTimeFrom_TString(TString timestr, int dataTimeArr_i[6]){
  string tstr = timestr.Data();
  findAndReplaceString( tstr, "[", "");
  findAndReplaceString( tstr, "-", " ");
  findAndReplaceString( tstr, ":", " ");
  findAndReplaceString( tstr, "]", "");
  istringstream buf(tstr);
  //cout<<tstr<<endl;
  double d_year, d_month, d_day, d_hour, d_min, d_sec;
  buf>>d_year>>d_month>>d_day>>d_hour>>d_min>>d_sec;
  dataTimeArr_i[0] = d_year;
  dataTimeArr_i[1] = d_month;
  dataTimeArr_i[2] = d_day;
  dataTimeArr_i[3] = d_hour;
  dataTimeArr_i[4] = d_min;
  dataTimeArr_i[5] = d_sec;
  //cout<<d_year<<endl;
  return getUnixTimeFrom_year_month_day_hour_min_sec(d_year, d_month, d_day, d_hour, d_min, d_sec);
}

//181017-160409
double getUnixTimeFrom_TString2(TString timestr, int dataTimeArr_i[6]){
  string tstr = timestr.Data();
  double d_year, d_month, d_day, d_hour, d_min, d_sec;
  findAndReplaceString( tstr, "-", "");
  char cc0  = tstr.at(0);
  char cc1  = tstr.at(1);
  char cc2  = tstr.at(2);
  char cc3  = tstr.at(3);
  char cc4  = tstr.at(4);
  char cc5  = tstr.at(5);
  char cc6  = tstr.at(6);
  char cc7  = tstr.at(7);
  char cc8  = tstr.at(8);
  char cc9  = tstr.at(9);
  char cc10 = tstr.at(10);
  char cc11 = tstr.at(11);
  d_year = 2000 + (cc0 - '0')*10.0 + (cc1 - '0');
  d_month = (cc2 - '0')*10.0 + (cc3 - '0');
  d_day = (cc4 - '0')*10.0 + (cc5 - '0');
  d_hour = (cc6 - '0')*10.0 + (cc7 - '0');
  d_min = (cc8 - '0')*10.0 + (cc9 - '0');
  d_sec = (cc10 - '0')*10.0 + (cc11 - '0');
  //cout<<timestr<<endl
  //  <<d_year<<endl
  //  <<d_month<<endl
  //  <<d_day<<endl
  //  <<d_hour<<endl
  //  <<d_min<<endl
  //  <<d_sec<<endl;
  dataTimeArr_i[0] = d_year;
  dataTimeArr_i[1] = d_month;
  dataTimeArr_i[2] = d_day;
  dataTimeArr_i[3] = d_hour;
  dataTimeArr_i[4] = d_min;
  dataTimeArr_i[5] = d_sec;
  return getUnixTimeFrom_year_month_day_hour_min_sec(d_year, d_month, d_day, d_hour, d_min, d_sec);
}

void findAndReplaceString(string& str, const string& oldStr, const string& newStr){
  std::string::size_type pos = 0u;
  while((pos = str.find(oldStr, pos)) != std::string::npos){
    str.replace(pos, oldStr.length(), newStr);
    pos += newStr.length();
  }
}

bool ifLineContainsString(const string& line, const string& str){
  std::size_t found = line.find(str);
  if (found!=std::string::npos)
    return true;
  return false;
}

void getMergerIDandTemperatureFrom_TString(TString str, Float_t &t, Int_t &mergerLocalID){
  //arich[0].temp : float(34.125)
  //arich[0].systemp : 29.530298
  string tstr = str.Data();
  findAndReplaceString( tstr, "arich[", "");
  findAndReplaceString( tstr, "].temp", " ");
  findAndReplaceString( tstr, "].systemp", " ");
  findAndReplaceString( tstr, ":", " ");
  findAndReplaceString( tstr, "float(", "");
  findAndReplaceString( tstr, ")", "");
  istringstream buf(tstr);
  //cout<<tstr<<endl;
  //double d_year, d_month, d_day, d_hour, d_min, d_sec;
  buf>>mergerLocalID>>t;
  //cout<<mergerLocalID<<" "<<t<<endl;
}

void getFebIDandTemperatureFrom_TString(TString str, Float_t &t, Int_t &mergerLocalID, Int_t &febLocalID){
  //arich[0].feb[0].t1 : float(28.625)
  //arich[0].feb[0].t1 : 28.875000
  string tstr = str.Data();
  findAndReplaceString( tstr, "arich[", "");
  findAndReplaceString( tstr, "].feb[", " ");
  findAndReplaceString( tstr, "].t1", " ");
  findAndReplaceString( tstr, "].t2", " ");
  findAndReplaceString( tstr, ":", " ");
  findAndReplaceString( tstr, "float(", "");
  findAndReplaceString( tstr, ")", "");
  istringstream buf(tstr);
  //cout<<tstr<<endl;
  //double d_year, d_month, d_day, d_hour, d_min, d_sec;
  buf>>mergerLocalID>>febLocalID>>t;
  //cout<<mergerLocalID<<" "<<febLocalID<<" "<<t<<endl;
}

Int_t getCopperIDFrom_TString(TString str){
  //cpr4016
  string tstr = str.Data();
  findAndReplaceString( tstr, "cpr", "");
  istringstream buf(tstr);
  Int_t copperID;
  buf>>copperID;
  //cout<<"copperID = "<<copperID<<endl;
  return copperID;
}

double find_hours_since_beginning_of_the_day_from_Unix_time(double ut){
  if(ut>=0.0){
    time_t t_ut = ut;
    struct tm *timeinfo = localtime(&t_ut);
    struct tm timeinfo_beginning_of_the_day; 
    timeinfo_beginning_of_the_day.tm_year = timeinfo->tm_year;
    timeinfo_beginning_of_the_day.tm_mon = timeinfo->tm_mon;
    timeinfo_beginning_of_the_day.tm_mday = timeinfo->tm_mday;
    timeinfo_beginning_of_the_day.tm_hour = 0;
    timeinfo_beginning_of_the_day.tm_min = 0;
    timeinfo_beginning_of_the_day.tm_sec = 0;
    //printf ("Time   : %20.3d \n ", (int)mktime(timeinfo));
    //printf ("Time 0 : %20.3d \n ", (int)mktime(&timeinfo_beginning_of_the_day));
    //cout<<getLocalTimeStringFromUnixTime(ut);
    //printf ("Time     : %20.3d \n ", (int)mktime(timeinfo));
    //printf ("Time 0   : %20.3d \n ", (int)mktime(&timeinfo_beginning_of_the_day));
    //cout<<"difftime : "<<difftime(mktime(timeinfo),mktime(&timeinfo_beginning_of_the_day))/60.0/60.0<<endl;
    return difftime(mktime(timeinfo),mktime(&timeinfo_beginning_of_the_day))/60.0/60.0;
  }
  cout<<" ---> ERROR : ut < 0.0 "<<endl
      <<"              ut =  "<<ut<<endl;
  assert(0);
  return -999.0;  
} 

bool check_If_ut_is_in_the_window(double ut, double t0, double dt){
  double dt_calculated = (TMath::Abs(t0) - TMath::Abs(find_hours_since_beginning_of_the_day_from_Unix_time(ut)));
  //cout<<dt_calculated<<endl;
  if(TMath::Abs(dt_calculated) <= TMath::Abs(dt))
    return true;
  return false;
}

unsigned int find_closest_good_measurement(const std::vector<double> utvec, double t0){
  if(utvec.size() > 0){
    unsigned int iclosest = 0;
    double ut = 0.0;
    double dt_calculated = 0.0;
    ut = utvec[0];
    double dt_calculated_min = (TMath::Abs(t0) - TMath::Abs(find_hours_since_beginning_of_the_day_from_Unix_time(ut)));
    for(unsigned int i = 0; i<utvec.size();i++){
      ut = utvec[i];
      dt_calculated = (TMath::Abs(t0) - TMath::Abs(find_hours_since_beginning_of_the_day_from_Unix_time(ut)));
      if(TMath::Abs(dt_calculated_min)>TMath::Abs(dt_calculated)){
	dt_calculated_min = dt_calculated;
	iclosest = i;
      }
    }
    return iclosest;
  }
  cout<<" ---> ERROR : utvec.size() < 1 "<<endl
      <<"              utvec.size() =  "<<utvec.size()<<endl;
  assert(0);
  return -999;
}
