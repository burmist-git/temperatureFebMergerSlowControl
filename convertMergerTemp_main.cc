/***********************************************************************
* Copyright(C) 2017 - LBS - (Single person developer.)                 *
* Fri Oct 19 15:53:51 JST 2018                                         *
* Autor: Leonid Burmistrov                                             *
***********************************************************************/

//my
#include "libarichstandalone.h"

#ifdef CONVERTMERGERTEMP_MAIN
# ifndef __CINT__
int main(int argc, char *argv[]){
  if(argc == 7 && atoi(argv[1]) == 0){
    TString inFile = argv[2];
    TString outPdfFileNamePreff = argv[3];
    Int_t numberOfSectorsToReads = atoi(argv[4]);
    TString hapdTemplateMappingPath = argv[5];
    TString fnameInfoMergerPos = argv[6];
    convertMergerTemp( inFile, outPdfFileNamePreff, numberOfSectorsToReads, hapdTemplateMappingPath, fnameInfoMergerPos);
    return 0;
  }
  else if( argc > 4 && atoi(argv[1]) == 1){
    TString inFile;
    TString outRootFileName = argv[2];
    TString hapdTemplateMappingPath = argv[3];
    TString fnameInfoMergerPos = argv[4];
    vector<TString> inRootHistList;
    for(int i = 5;i<argc;i++){
      inFile = argv[i];
      inRootHistList.push_back(inFile);
    }
    mergMergerTemp(outRootFileName, hapdTemplateMappingPath, fnameInfoMergerPos, inRootHistList);
    return 0;
  }
  else{
    std::cout<<" ---> ERROR in input arguments "<<std::endl;
    assert(0);
  }
  return 0;
}
# endif //ifndef __CINT__
#endif //ifdef CONVERTMERGERTEMP_MAIN
