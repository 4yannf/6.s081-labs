#include "kernel/types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  if(argc <= 1){
    fprintf(2, "usage: sheep [seconds]\n");
    exit(1);
  }

  int time = atoi(argv[1]);
  if(sleep(time) == -1){
    exit(1);
  }
  


  exit(0);
}