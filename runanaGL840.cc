/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sat Apr 13 18:40:17 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "anaGL840.h"
#include "libarichstandalone.h"

//root
#include "TROOT.h"
#include "TString.h"
#include "TH1D.h"
#include "TH2D.h"
#include "TFile.h"
#include "TRandom3.h"
#include "TGraph.h"

//C, C++
#include <iostream>
#include <stdlib.h>
#include <assert.h>
#include <fstream>
#include <iomanip>
#include <time.h>

using namespace std;
  
int runanaGL840( Int_t keyID, TString rootFileOrList, TString outRootFileF, Int_t dataDivision, TString parametersFileIn){
  if( keyID == 0 ){
    cout<<"--> Input parameters for the GL840 logger data treatment <--"<<endl
	<<"rootFilesList : "<<rootFileOrList<<endl
	<<"outRootFileF  : "<<outRootFileF<<endl;
    anaGL840 a(rootFileOrList);
    a.Loop(outRootFileF,dataDivision,parametersFileIn);
  }
  else if( keyID == 1){
    cout<<"--> Input parameters for the GL840 logger data treatment <--"<<endl
	<<"inRootFile  : "<<rootFileOrList<<endl
	<<"outRootFileF : "<<outRootFileF<<endl;
    anaGL840 a( rootFileOrList, keyID);
    a.Loop(outRootFileF,dataDivision,parametersFileIn);
  }
  else{
    cout<<" --> ERROR in input arguments "<<endl
	<<" runID [1] = 0 (execution ID number)"<<endl
	<<"       [2] - file with list of the root files"<<endl
	<<"       [3] - name of root file with histograms"<<endl
	<<"       [4] - data division (put 1 by default)"<<endl
	<<"       [5] - file with input parameters"<<endl;
    cout<<" runID [1] = 1 (execution ID number)"<<endl
	<<"       [2] - in root file"<<endl
	<<"       [3] - name of root file with histograms"<<endl
	<<"       [4] - data division (put 1 by default)"<<endl
	<<"       [5] - file with input parameters"<<endl;
  }
  return 0;
}
