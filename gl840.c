//my
#include "libarichstandalone.h"

//c, c++
#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <assert.h>
#include <iomanip>

//root
#include <TTree.h>

//#define HOST "10.0.2.2"
//#define HOST "localhost"
#define HOST "arich-dl1.b2nsm.kek.jp"
#define PORT 8023
#define TERMCHAR '\n'

int sock_num = -1;

//void init_sockaddr (name, hostname, port)
void init_sockaddr (struct sockaddr_in *name, char *hostname, unsigned short int port) {
  struct hostent *hostinfo;
  name->sin_family = AF_INET;
  name->sin_port = htons (port);
  hostinfo = gethostbyname (hostname); 
  if (hostinfo == NULL)
  {
    fprintf (stderr, "Unknown host %s. \n", hostname);
    exit (EXIT_FAILURE);
  }
  name->sin_addr = *(struct in_addr *) hostinfo->h_addr;
}

void connect_tcp (char *host_name, unsigned short int port) {
  int sock, status;
  char cmd;
  struct sockaddr_in servername;

  /* Create the socket */
  sock = socket (AF_INET, SOCK_STREAM, 0);
  if (sock < 0)
  {
    perror ("socket (client)");
    exit (EXIT_FAILURE);
  }
  /* Connect to the server */
  init_sockaddr (&servername, host_name, port);
  if (0 > connect (sock, (struct sockaddr *) &servername,
                   sizeof (servername)))
  {
    close (sock);
    sock_num = -1;
    return;
  }
  sock_num = sock;
}

void send_tcp (char *buff, int len) {
  int status, clen;

  clen = len;
  do
  {
    if (0 > (status = write (sock_num, buff, clen)))
    {
      perror ("\nwrite(send_tcp)");
      exit (EXIT_FAILURE);
    }
    clen -= status;
    buff += status;
  }
  while (clen);
}

int read_tcp (char *buff, int len, char *termch) {
  int status, clen;

  clen = len;
  do
  {
    if (0 > (status = read (sock_num, buff, clen)))
    {
      perror ("\nread(recv_tcp)");
      exit (EXIT_FAILURE);
    }
    clen -= status;
    buff += status;
  }
  while (clen && !(termch && (*(buff-1)==termch)));
  
  if (clen) {
    if (*(buff-2)=='\r') {
      buff--;
      clen++;
    }
    *(buff-1)=0;
    return (len-clen-1);
   } else
    return len;
}

void printData (int utint, float data[20]) {
  //21.73 C, 23.28 C, 23.22 C, 23.89 C, 23.68 C, 23.69 C
  //23.69 C, 23.77 C, 23.77 C, 25.41 C, 25.39 C, 25.52 C
  // 0.00 V,  0.00 V,  0.00 V,  0.00 V
  // 1.43 V,  3.55 V,  1.99 V, -2.15 V
  std::cout<<"utint "<<utint<<std::endl;
  printf("%5.2f C, %5.2f C, %5.2f C, %5.2f C, %5.2f C, %5.2f C\n",
	 data[0],data[1],data[2],data[3],data[4],data[5]);
  printf("%5.2f C, %5.2f C, %5.2f C, %5.2f C, %5.2f C, %5.2f C\n",
	 data[10],data[11],data[12],data[13],data[14],data[15]);
  printf("%5.2f V, %5.2f V, %5.2f V, %5.2f V\n",
	 data[6],data[7],data[8],data[9]);
  printf("%5.2f V, %5.2f V, %5.2f V, %5.2f V\n",
	 data[16],data[17],data[18],data[19]);
}

void saveTheDataIntoTheDatFile (int utint, float data[20], TString outDatFile) {
  std::ofstream outfile;
  outfile.open(outDatFile.Data(), std::ios_base::app);
  outfile<<utint<<endl;
  for(int i = 0;i<10;i++)
    outfile<<setw(10)<<data[i];
  outfile<<endl;
  for(int i = 0;i<10;i++)
    outfile<<setw(10)<<data[i+10];
  outfile<<endl;
  outfile.close();
}

void saveTheDataIntoTheRootFile (int utint, float data[20], TString outRootFile) {
  Int_t _unixTime = utint;
  Float_t _data[20];
  for(Int_t i = 0;i<20;i++)
    _data[i] = data[i];
  //
  TFile *hfile = new TFile( outRootFile, "UPDATE", "gl840 data", 1);
  if (hfile->IsZombie()) {
    std::cout << "PROBLEM with the initialization of the output ROOT ntuple " 
         << outRootFile << ": check that the path is correct!!!"
         <<std::endl;
    assert(0);
  }
  //
  TTree *tree;
  if(!(TTree*)hfile->Get("T")){
    //cout<<" FIRST TIME"<<endl;
    tree = new TTree("T", "gl840 data tree");
    tree->Branch("unixTime",&_unixTime, "unixTime/I");
    tree->Branch("data", _data, "data[20]/F");
  }
  else {
    //cout<<" NOT FIRST TIME"<<endl;
    tree = (TTree*)hfile->Get("T");
    tree->SetBranchAddress("unixTime", &_unixTime);
    tree->SetBranchAddress("data", &_data);
  }
  //
  hfile->SetCompressionLevel(2);
  tree->SetAutoSave(1000000);
  // Create new event
  TTree::SetBranchStyle(0);
  tree->Fill();
  hfile->Write();
  hfile->Close();

}

void disconnect_tcp () {
  close (sock_num);
}

int main(int argc, char *argv[]) {

  if(argc == 3 && ( atoi(argv[1]) == 0 || atoi(argv[1]) == 1) ){
    int i, nread, nget;
    int idata[20];
    float data[20];
    char GL840_In[1000];
    
    TString outDatFile = argv[2];
    std::cout<<"outDatFile "<<outDatFile<<std::endl;

    connect_tcp(HOST, PORT);
    
    // test ID
    send_tcp("*IDN?\n",6);
    nread = read_tcp(GL840_In, 1000, TERMCHAR);
    printf("%s, %d bytes received\n", GL840_In, nread);
    
    send_tcp(":MEAS:OUTP:ONE?\n",16);
    nread = read_tcp(GL840_In, 8, 0);
    GL840_In[8]=0;
    printf("%s, %d bytes received\n", GL840_In, nread);
    sscanf(GL840_In,"#6%d",&nget);
    nread = read_tcp(GL840_In, nget, 0);
    for (i=0;i<20;i++) {
      idata[i] = GL840_In[2*i];
      idata[i] = (idata[i]<<8) + (unsigned char)GL840_In[2*i+1];
      data[i] = 0.0;
    }
    for (i=0;i<6;i++) data[i]=(float)idata[i]/200.;
    for (i=10;i<16;i++) data[i]=(float)idata[i]/200.;
    for (i=6;i<10;i++) data[i]=(float)idata[i]/2000.;
    for (i=16;i<20;i++) data[i]=(float)idata[i]/2000.;
    //std::time_t result = std::time(nullptr);
    //double unixtime = atoi(std::asctime(std::localtime(&result)));
    //1555077731
    //2147483647
    int unixtime = std::time(0);
    //std::cout<<"unixtime "<<unixtime<<std::endl;

    printData(unixtime, data);
    if(atoi(argv[1]) == 0)
      saveTheDataIntoTheDatFile(unixtime, data, outDatFile);    
    else if (atoi(argv[1]) == 1)
      saveTheDataIntoTheRootFile(unixtime, data, outDatFile);
    else
      assert(0);

    disconnect_tcp();
  }
  else{
    std::cout<<" ---> ERROR in input arguments "<<std::endl;
    assert(0);
  }
  return 0;

}
