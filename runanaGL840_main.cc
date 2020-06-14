/***********************************************************************
* Copyright(C) 2019 - LBS - (Single person developer.)                 *
* Sun Apr 14 00:41:58 JST 2019                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "libarichstandalone.h"

//c, c++
#include <vector>

#ifdef RUNANAGL840_MAIN
# ifndef __CINT__
int main(int argc, char *argv[]){
  if(argc == 6 && ( atoi(argv[1]) == 0 || atoi(argv[1]) == 1 )){
    Int_t keyID = atoi(argv[1]);
    TString rootFileOrList = argv[2];
    TString outRootFileF = argv[3];
    Int_t dataDivision = atoi(argv[4]);
    TString parametersFileIn = argv[5];
    runanaGL840( keyID, rootFileOrList, outRootFileF, dataDivision, parametersFileIn);
    return 0;
  }
  else{
    Int_t keyID = 2;
    TString rootFileOrList = "NAN";
    TString outRootFileF = "NAN";
    Int_t dataDivision = 1;
    TString parametersFileIn = "NAN";
    runanaGL840( keyID, rootFileOrList, outRootFileF, dataDivision, parametersFileIn);
    assert(0);
  }
  return 0;
}
# endif //ifndef __CINT__
#endif //ifdef RUNANAGL840_MAIN
