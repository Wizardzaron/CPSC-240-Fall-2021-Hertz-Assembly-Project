#include <stdio.h>



extern "C" double Inputs();

int main(int argc, char* arg[])
{
  double check = 0.0;
  printf("Welcome to Power Unlimited by Ryan Haddadi \n");
  check = Inputs();

  printf("The main function recieved %lf and plans to keep it\n", check);
  printf("Next a zero will be returned to the OS. Bye \n");
  return 0;
}
