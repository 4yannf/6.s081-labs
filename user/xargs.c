#include "kernel/types.h"
#include "user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){
  if(argc < 2){
    fprintf(2, "usage: xargs [command]\n");
    exit(1);
  }
  
  char *command = argv[1];
  char buf[512];
  int p = 0;
  while(1){
    int n;
    char ch;
    n = read(0, &ch, 1);

    if(n == 0) break;
    else if(ch == '\n'){
      if(fork() == 0){

        char *execArgv[MAXARG];
        execArgv[0] = command;
        int i;
        for(i = 0; i < argc - 2; ++i){
          execArgv[i + 1] = argv[i + 2];
        }
        buf[p] = '\0';
        execArgv[argc - 1] = buf;
        exec(command, execArgv);
        exit(0);
      }
      else {
        p = 0;
        buf[p] = '\0';
        wait(0);
      }
    }
    else {
      buf[p++] = ch;
    }
  }
  exit(0);
}