#include "kernel/types.h"
#include "user.h"

int main(){
  int p1[2], p2[2];
  pipe(p1);
  pipe(p2);
  int buf[10];

  if(fork() == 0){
    close(p1[1]);
    close(p2[0]);
    read(p1[0], buf, 1);
    fprintf(1, "%d: received ping\n", getpid());
    write(p2[1], "a", 1);
    close(p1[0]);
    close(p2[1]); 
  }
  else {
    close(p1[0]);
    close(p2[1]);
    write(p1[1], "a", 1);
    read(p2[0], buf, 1);
    fprintf(1, "%d: received pong\n", getpid());
    close(p1[1]);
    close(p2[0]);
  }
  exit(0);
}