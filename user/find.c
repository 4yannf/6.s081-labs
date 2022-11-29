#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *tarFile){
  // printf("***debug: tarFile: %s***\n", tarFile);

  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  case T_DEVICE:
  case T_FILE:
    // char *name = fmtname(path);
    // if(strcmp(name, tarFile) == 0) {
    //   fprintf(1, "%s\n", path);
    // }
    // else fprintf(1, "find: cannot find %s", name);
    fprintf(2, "find: %s is not a dirctory\n", path);
    break;

  case T_DIR:
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
//      p[DIRSIZ] = 0;
      if(stat(buf, &st) < 0){
        printf("find: cannot stat %s\n", buf);
        continue;
      }

      // printf("***debug: buf: %s***\n", buf);
      if(st.type == T_DIR) {
        if(strcmp(de.name, ".") && strcmp(de.name, ".."))
          find(buf, tarFile);
      }
      else {
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
      }
    }
    break;
  }
}

int main(int argc, char* argv[]){
  if(argc < 2){
    fprintf(2, "usage: find [dir] [file]\n");
    exit(1);
  }

  if(argc == 2){
    find(".", argv[1]);
  }
  else {
    find(argv[1], argv[2]);
  }
  exit(0);
}