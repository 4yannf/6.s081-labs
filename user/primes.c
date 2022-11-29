#include "kernel/types.h"
#include "user.h"

int main(){
  int p[2][2];
  int dividend = 0;
  const int mod = 2;

  pipe(p[dividend % mod]);
  if(fork() == 0){

    ++dividend;
    close(p[(dividend - 1) % mod][1]);

    int prime;
    read(p[(dividend - 1) % mod][0], &prime, 4);
    printf("prime %d\n", prime);

    while(1){
      int num;
      if (read(p[(dividend - 1) % mod][0], &num, 4) == 0){
        close(p[(dividend - 1) % mod][0]);
        wait(0);
        exit(0);
      }

      if(num % prime != 0){
        pipe(p[dividend % mod]);
        if(fork() == 0){
          ++dividend;
          close(p[(dividend - 1) % mod][1]);
          if(read(p[(dividend - 1) % mod][0], &prime, 4) == 0){
            close(p[(dividend - 1) % mod][0]);
            exit(0);
          }
          printf("prime %d\n", prime);
        }
        else {
          close(p[dividend % mod][0]);
          write(p[dividend % mod][1], &num, 4);
          break;
        }
      }
    }

    while(1){
      int num;
      if (read(p[(dividend - 1) % mod][0], &num, 4) == 0){
        close(p[dividend % mod][1]);
        close(p[(dividend - 1) % mod][0]);
        wait(0);
        exit(0);
      }
      if(num % prime != 0){
        write(p[dividend % mod][1], &num, 4);
      }
    }




  }
  else {
    close(p[dividend % mod][0]);
    int i;
    for(i = 2; i <= 35; ++i){
      write(p[dividend % mod][1], &i, 4);
    }
    close(p[dividend % mod][1]);
    wait(0);
  }
  exit(0);
}