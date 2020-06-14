//my
#include "libarichstandalone.h"
#include "ARICHChannelHist.h"

Int_t testARICHChannelHist(){

  std::cout<<"testARICHChannelHist"<<std::endl;
  
  ARICHChannelHist *h1_ARICHChannelHist = new ARICHChannelHist("h1_ARICHChannelHist","ARICHChannelHist",1);

  for(unsigned int i = 1; i<=420;i++)
    h1_ARICHChannelHist->SetBinContent(i,i);

  new TCanvas("c1","canva1",10,10,1000,1000);
  h1_ARICHChannelHist->Draw("ZCOLOR TEXT");
  h1_ARICHChannelHist->SaveAs("h1_ARICHChannelHist.root");

  //new TCanvas("c2","canva2",20,20,1000,1000);
  //ARICHChannelHist *h1_ARICHChannelHist_clone = ARICHChannelHist::createFrom(h1_ARICHChannelHist);
  //h1_ARICHChannelHist_clone->Draw("ZCOLOR TEXT");
  
  return 0;

}
