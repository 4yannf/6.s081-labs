
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *tarFile){
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	0500                	addi	s0,sp,640
  2a:	892a                	mv	s2,a0
  2c:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  2e:	4581                	li	a1,0
  30:	00000097          	auipc	ra,0x0
  34:	4c4080e7          	jalr	1220(ra) # 4f4 <open>
  38:	06054663          	bltz	a0,a4 <find+0xa4>
  3c:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  3e:	d8840593          	addi	a1,s0,-632
  42:	00000097          	auipc	ra,0x0
  46:	4ca080e7          	jalr	1226(ra) # 50c <fstat>
  4a:	06054863          	bltz	a0,ba <find+0xba>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  4e:	d9041783          	lh	a5,-624(s0)
  52:	0007869b          	sext.w	a3,a5
  56:	4705                	li	a4,1
  58:	08e68163          	beq	a3,a4,da <find+0xda>
  5c:	37f9                	addiw	a5,a5,-2
  5e:	17c2                	slli	a5,a5,0x30
  60:	93c1                	srli	a5,a5,0x30
  62:	00f76c63          	bltu	a4,a5,7a <find+0x7a>
    // char *name = fmtname(path);
    // if(strcmp(name, tarFile) == 0) {
    //   fprintf(1, "%s\n", path);
    // }
    // else fprintf(1, "find: cannot find %s", name);
    fprintf(2, "find: %s is not a dirctory\n", path);
  66:	864a                	mv	a2,s2
  68:	00001597          	auipc	a1,0x1
  6c:	99858593          	addi	a1,a1,-1640 # a00 <malloc+0x11a>
  70:	4509                	li	a0,2
  72:	00000097          	auipc	ra,0x0
  76:	78e080e7          	jalr	1934(ra) # 800 <fprintf>
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
      }
    }
    break;
  }
}
  7a:	27813083          	ld	ra,632(sp)
  7e:	27013403          	ld	s0,624(sp)
  82:	26813483          	ld	s1,616(sp)
  86:	26013903          	ld	s2,608(sp)
  8a:	25813983          	ld	s3,600(sp)
  8e:	25013a03          	ld	s4,592(sp)
  92:	24813a83          	ld	s5,584(sp)
  96:	24013b03          	ld	s6,576(sp)
  9a:	23813b83          	ld	s7,568(sp)
  9e:	28010113          	addi	sp,sp,640
  a2:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  a4:	864a                	mv	a2,s2
  a6:	00001597          	auipc	a1,0x1
  aa:	92a58593          	addi	a1,a1,-1750 # 9d0 <malloc+0xea>
  ae:	4509                	li	a0,2
  b0:	00000097          	auipc	ra,0x0
  b4:	750080e7          	jalr	1872(ra) # 800 <fprintf>
    return;
  b8:	b7c9                	j	7a <find+0x7a>
    fprintf(2, "find: cannot stat %s\n", path);
  ba:	864a                	mv	a2,s2
  bc:	00001597          	auipc	a1,0x1
  c0:	92c58593          	addi	a1,a1,-1748 # 9e8 <malloc+0x102>
  c4:	4509                	li	a0,2
  c6:	00000097          	auipc	ra,0x0
  ca:	73a080e7          	jalr	1850(ra) # 800 <fprintf>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	40c080e7          	jalr	1036(ra) # 4dc <close>
    return;
  d8:	b74d                	j	7a <find+0x7a>
    strcpy(buf, path);
  da:	85ca                	mv	a1,s2
  dc:	db040513          	addi	a0,s0,-592
  e0:	00000097          	auipc	ra,0x0
  e4:	168080e7          	jalr	360(ra) # 248 <strcpy>
    p = buf+strlen(buf);
  e8:	db040513          	addi	a0,s0,-592
  ec:	00000097          	auipc	ra,0x0
  f0:	1a4080e7          	jalr	420(ra) # 290 <strlen>
  f4:	1502                	slli	a0,a0,0x20
  f6:	9101                	srli	a0,a0,0x20
  f8:	db040793          	addi	a5,s0,-592
  fc:	97aa                	add	a5,a5,a0
    *p++ = '/';
  fe:	00178913          	addi	s2,a5,1
 102:	02f00713          	li	a4,47
 106:	00e78023          	sb	a4,0(a5)
      if(st.type == T_DIR) {
 10a:	4a05                	li	s4,1
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
 10c:	00001b17          	auipc	s6,0x1
 110:	924b0b13          	addi	s6,s6,-1756 # a30 <malloc+0x14a>
        if(strcmp(de.name, ".") && strcmp(de.name, ".."))
 114:	00001a97          	auipc	s5,0x1
 118:	90ca8a93          	addi	s5,s5,-1780 # a20 <malloc+0x13a>
 11c:	00001b97          	auipc	s7,0x1
 120:	90cb8b93          	addi	s7,s7,-1780 # a28 <malloc+0x142>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 124:	4641                	li	a2,16
 126:	da040593          	addi	a1,s0,-608
 12a:	8526                	mv	a0,s1
 12c:	00000097          	auipc	ra,0x0
 130:	3a0080e7          	jalr	928(ra) # 4cc <read>
 134:	47c1                	li	a5,16
 136:	f4f512e3          	bne	a0,a5,7a <find+0x7a>
      if(de.inum == 0)
 13a:	da045783          	lhu	a5,-608(s0)
 13e:	d3fd                	beqz	a5,124 <find+0x124>
      memmove(p, de.name, DIRSIZ);
 140:	4639                	li	a2,14
 142:	da240593          	addi	a1,s0,-606
 146:	854a                	mv	a0,s2
 148:	00000097          	auipc	ra,0x0
 14c:	2ba080e7          	jalr	698(ra) # 402 <memmove>
      if(stat(buf, &st) < 0){
 150:	d8840593          	addi	a1,s0,-632
 154:	db040513          	addi	a0,s0,-592
 158:	00000097          	auipc	ra,0x0
 15c:	21c080e7          	jalr	540(ra) # 374 <stat>
 160:	02054663          	bltz	a0,18c <find+0x18c>
      if(st.type == T_DIR) {
 164:	d9041783          	lh	a5,-624(s0)
 168:	03478d63          	beq	a5,s4,1a2 <find+0x1a2>
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
 16c:	85ce                	mv	a1,s3
 16e:	da240513          	addi	a0,s0,-606
 172:	00000097          	auipc	ra,0x0
 176:	0f2080e7          	jalr	242(ra) # 264 <strcmp>
 17a:	f54d                	bnez	a0,124 <find+0x124>
 17c:	db040593          	addi	a1,s0,-592
 180:	855a                	mv	a0,s6
 182:	00000097          	auipc	ra,0x0
 186:	6ac080e7          	jalr	1708(ra) # 82e <printf>
 18a:	bf69                	j	124 <find+0x124>
        printf("find: cannot stat %s\n", buf);
 18c:	db040593          	addi	a1,s0,-592
 190:	00001517          	auipc	a0,0x1
 194:	85850513          	addi	a0,a0,-1960 # 9e8 <malloc+0x102>
 198:	00000097          	auipc	ra,0x0
 19c:	696080e7          	jalr	1686(ra) # 82e <printf>
        continue;
 1a0:	b751                	j	124 <find+0x124>
        if(strcmp(de.name, ".") && strcmp(de.name, ".."))
 1a2:	85d6                	mv	a1,s5
 1a4:	da240513          	addi	a0,s0,-606
 1a8:	00000097          	auipc	ra,0x0
 1ac:	0bc080e7          	jalr	188(ra) # 264 <strcmp>
 1b0:	d935                	beqz	a0,124 <find+0x124>
 1b2:	85de                	mv	a1,s7
 1b4:	da240513          	addi	a0,s0,-606
 1b8:	00000097          	auipc	ra,0x0
 1bc:	0ac080e7          	jalr	172(ra) # 264 <strcmp>
 1c0:	d135                	beqz	a0,124 <find+0x124>
          find(buf, tarFile);
 1c2:	85ce                	mv	a1,s3
 1c4:	db040513          	addi	a0,s0,-592
 1c8:	00000097          	auipc	ra,0x0
 1cc:	e38080e7          	jalr	-456(ra) # 0 <find>
 1d0:	bf91                	j	124 <find+0x124>

00000000000001d2 <main>:

int main(int argc, char* argv[]){
 1d2:	1141                	addi	sp,sp,-16
 1d4:	e406                	sd	ra,8(sp)
 1d6:	e022                	sd	s0,0(sp)
 1d8:	0800                	addi	s0,sp,16
  if(argc < 2){
 1da:	4705                	li	a4,1
 1dc:	02a75163          	bge	a4,a0,1fe <main+0x2c>
 1e0:	87ae                	mv	a5,a1
    fprintf(2, "usage: find [dir] [file]\n");
    exit(1);
  }

  if(argc == 2){
 1e2:	4709                	li	a4,2
 1e4:	02e50b63          	beq	a0,a4,21a <main+0x48>
    find(".", argv[1]);
  }
  else {
    find(argv[1], argv[2]);
 1e8:	698c                	ld	a1,16(a1)
 1ea:	6788                	ld	a0,8(a5)
 1ec:	00000097          	auipc	ra,0x0
 1f0:	e14080e7          	jalr	-492(ra) # 0 <find>
  }
  exit(0);
 1f4:	4501                	li	a0,0
 1f6:	00000097          	auipc	ra,0x0
 1fa:	2be080e7          	jalr	702(ra) # 4b4 <exit>
    fprintf(2, "usage: find [dir] [file]\n");
 1fe:	00001597          	auipc	a1,0x1
 202:	83a58593          	addi	a1,a1,-1990 # a38 <malloc+0x152>
 206:	4509                	li	a0,2
 208:	00000097          	auipc	ra,0x0
 20c:	5f8080e7          	jalr	1528(ra) # 800 <fprintf>
    exit(1);
 210:	4505                	li	a0,1
 212:	00000097          	auipc	ra,0x0
 216:	2a2080e7          	jalr	674(ra) # 4b4 <exit>
    find(".", argv[1]);
 21a:	658c                	ld	a1,8(a1)
 21c:	00001517          	auipc	a0,0x1
 220:	80450513          	addi	a0,a0,-2044 # a20 <malloc+0x13a>
 224:	00000097          	auipc	ra,0x0
 228:	ddc080e7          	jalr	-548(ra) # 0 <find>
 22c:	b7e1                	j	1f4 <main+0x22>

000000000000022e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  extern int main();
  main();
 236:	00000097          	auipc	ra,0x0
 23a:	f9c080e7          	jalr	-100(ra) # 1d2 <main>
  exit(0);
 23e:	4501                	li	a0,0
 240:	00000097          	auipc	ra,0x0
 244:	274080e7          	jalr	628(ra) # 4b4 <exit>

0000000000000248 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 24e:	87aa                	mv	a5,a0
 250:	0585                	addi	a1,a1,1
 252:	0785                	addi	a5,a5,1
 254:	fff5c703          	lbu	a4,-1(a1)
 258:	fee78fa3          	sb	a4,-1(a5)
 25c:	fb75                	bnez	a4,250 <strcpy+0x8>
    ;
  return os;
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret

0000000000000264 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 264:	1141                	addi	sp,sp,-16
 266:	e422                	sd	s0,8(sp)
 268:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 26a:	00054783          	lbu	a5,0(a0)
 26e:	cb91                	beqz	a5,282 <strcmp+0x1e>
 270:	0005c703          	lbu	a4,0(a1)
 274:	00f71763          	bne	a4,a5,282 <strcmp+0x1e>
    p++, q++;
 278:	0505                	addi	a0,a0,1
 27a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 27c:	00054783          	lbu	a5,0(a0)
 280:	fbe5                	bnez	a5,270 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 282:	0005c503          	lbu	a0,0(a1)
}
 286:	40a7853b          	subw	a0,a5,a0
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret

0000000000000290 <strlen>:

uint
strlen(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 296:	00054783          	lbu	a5,0(a0)
 29a:	cf91                	beqz	a5,2b6 <strlen+0x26>
 29c:	0505                	addi	a0,a0,1
 29e:	87aa                	mv	a5,a0
 2a0:	4685                	li	a3,1
 2a2:	9e89                	subw	a3,a3,a0
 2a4:	00f6853b          	addw	a0,a3,a5
 2a8:	0785                	addi	a5,a5,1
 2aa:	fff7c703          	lbu	a4,-1(a5)
 2ae:	fb7d                	bnez	a4,2a4 <strlen+0x14>
    ;
  return n;
}
 2b0:	6422                	ld	s0,8(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
  for(n = 0; s[n]; n++)
 2b6:	4501                	li	a0,0
 2b8:	bfe5                	j	2b0 <strlen+0x20>

00000000000002ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2c0:	ca19                	beqz	a2,2d6 <memset+0x1c>
 2c2:	87aa                	mv	a5,a0
 2c4:	1602                	slli	a2,a2,0x20
 2c6:	9201                	srli	a2,a2,0x20
 2c8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2cc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2d0:	0785                	addi	a5,a5,1
 2d2:	fee79de3          	bne	a5,a4,2cc <memset+0x12>
  }
  return dst;
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <strchr>:

char*
strchr(const char *s, char c)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	cb99                	beqz	a5,2fc <strchr+0x20>
    if(*s == c)
 2e8:	00f58763          	beq	a1,a5,2f6 <strchr+0x1a>
  for(; *s; s++)
 2ec:	0505                	addi	a0,a0,1
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	fbfd                	bnez	a5,2e8 <strchr+0xc>
      return (char*)s;
  return 0;
 2f4:	4501                	li	a0,0
}
 2f6:	6422                	ld	s0,8(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret
  return 0;
 2fc:	4501                	li	a0,0
 2fe:	bfe5                	j	2f6 <strchr+0x1a>

0000000000000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	711d                	addi	sp,sp,-96
 302:	ec86                	sd	ra,88(sp)
 304:	e8a2                	sd	s0,80(sp)
 306:	e4a6                	sd	s1,72(sp)
 308:	e0ca                	sd	s2,64(sp)
 30a:	fc4e                	sd	s3,56(sp)
 30c:	f852                	sd	s4,48(sp)
 30e:	f456                	sd	s5,40(sp)
 310:	f05a                	sd	s6,32(sp)
 312:	ec5e                	sd	s7,24(sp)
 314:	1080                	addi	s0,sp,96
 316:	8baa                	mv	s7,a0
 318:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 31a:	892a                	mv	s2,a0
 31c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 31e:	4aa9                	li	s5,10
 320:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 322:	89a6                	mv	s3,s1
 324:	2485                	addiw	s1,s1,1
 326:	0344d863          	bge	s1,s4,356 <gets+0x56>
    cc = read(0, &c, 1);
 32a:	4605                	li	a2,1
 32c:	faf40593          	addi	a1,s0,-81
 330:	4501                	li	a0,0
 332:	00000097          	auipc	ra,0x0
 336:	19a080e7          	jalr	410(ra) # 4cc <read>
    if(cc < 1)
 33a:	00a05e63          	blez	a0,356 <gets+0x56>
    buf[i++] = c;
 33e:	faf44783          	lbu	a5,-81(s0)
 342:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 346:	01578763          	beq	a5,s5,354 <gets+0x54>
 34a:	0905                	addi	s2,s2,1
 34c:	fd679be3          	bne	a5,s6,322 <gets+0x22>
  for(i=0; i+1 < max; ){
 350:	89a6                	mv	s3,s1
 352:	a011                	j	356 <gets+0x56>
 354:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 356:	99de                	add	s3,s3,s7
 358:	00098023          	sb	zero,0(s3)
  return buf;
}
 35c:	855e                	mv	a0,s7
 35e:	60e6                	ld	ra,88(sp)
 360:	6446                	ld	s0,80(sp)
 362:	64a6                	ld	s1,72(sp)
 364:	6906                	ld	s2,64(sp)
 366:	79e2                	ld	s3,56(sp)
 368:	7a42                	ld	s4,48(sp)
 36a:	7aa2                	ld	s5,40(sp)
 36c:	7b02                	ld	s6,32(sp)
 36e:	6be2                	ld	s7,24(sp)
 370:	6125                	addi	sp,sp,96
 372:	8082                	ret

0000000000000374 <stat>:

int
stat(const char *n, struct stat *st)
{
 374:	1101                	addi	sp,sp,-32
 376:	ec06                	sd	ra,24(sp)
 378:	e822                	sd	s0,16(sp)
 37a:	e426                	sd	s1,8(sp)
 37c:	e04a                	sd	s2,0(sp)
 37e:	1000                	addi	s0,sp,32
 380:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 382:	4581                	li	a1,0
 384:	00000097          	auipc	ra,0x0
 388:	170080e7          	jalr	368(ra) # 4f4 <open>
  if(fd < 0)
 38c:	02054563          	bltz	a0,3b6 <stat+0x42>
 390:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 392:	85ca                	mv	a1,s2
 394:	00000097          	auipc	ra,0x0
 398:	178080e7          	jalr	376(ra) # 50c <fstat>
 39c:	892a                	mv	s2,a0
  close(fd);
 39e:	8526                	mv	a0,s1
 3a0:	00000097          	auipc	ra,0x0
 3a4:	13c080e7          	jalr	316(ra) # 4dc <close>
  return r;
}
 3a8:	854a                	mv	a0,s2
 3aa:	60e2                	ld	ra,24(sp)
 3ac:	6442                	ld	s0,16(sp)
 3ae:	64a2                	ld	s1,8(sp)
 3b0:	6902                	ld	s2,0(sp)
 3b2:	6105                	addi	sp,sp,32
 3b4:	8082                	ret
    return -1;
 3b6:	597d                	li	s2,-1
 3b8:	bfc5                	j	3a8 <stat+0x34>

00000000000003ba <atoi>:

int
atoi(const char *s)
{
 3ba:	1141                	addi	sp,sp,-16
 3bc:	e422                	sd	s0,8(sp)
 3be:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c0:	00054683          	lbu	a3,0(a0)
 3c4:	fd06879b          	addiw	a5,a3,-48
 3c8:	0ff7f793          	zext.b	a5,a5
 3cc:	4625                	li	a2,9
 3ce:	02f66863          	bltu	a2,a5,3fe <atoi+0x44>
 3d2:	872a                	mv	a4,a0
  n = 0;
 3d4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3d6:	0705                	addi	a4,a4,1
 3d8:	0025179b          	slliw	a5,a0,0x2
 3dc:	9fa9                	addw	a5,a5,a0
 3de:	0017979b          	slliw	a5,a5,0x1
 3e2:	9fb5                	addw	a5,a5,a3
 3e4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3e8:	00074683          	lbu	a3,0(a4)
 3ec:	fd06879b          	addiw	a5,a3,-48
 3f0:	0ff7f793          	zext.b	a5,a5
 3f4:	fef671e3          	bgeu	a2,a5,3d6 <atoi+0x1c>
  return n;
}
 3f8:	6422                	ld	s0,8(sp)
 3fa:	0141                	addi	sp,sp,16
 3fc:	8082                	ret
  n = 0;
 3fe:	4501                	li	a0,0
 400:	bfe5                	j	3f8 <atoi+0x3e>

0000000000000402 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 408:	02b57463          	bgeu	a0,a1,430 <memmove+0x2e>
    while(n-- > 0)
 40c:	00c05f63          	blez	a2,42a <memmove+0x28>
 410:	1602                	slli	a2,a2,0x20
 412:	9201                	srli	a2,a2,0x20
 414:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 418:	872a                	mv	a4,a0
      *dst++ = *src++;
 41a:	0585                	addi	a1,a1,1
 41c:	0705                	addi	a4,a4,1
 41e:	fff5c683          	lbu	a3,-1(a1)
 422:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 426:	fee79ae3          	bne	a5,a4,41a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 42a:	6422                	ld	s0,8(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
    dst += n;
 430:	00c50733          	add	a4,a0,a2
    src += n;
 434:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 436:	fec05ae3          	blez	a2,42a <memmove+0x28>
 43a:	fff6079b          	addiw	a5,a2,-1
 43e:	1782                	slli	a5,a5,0x20
 440:	9381                	srli	a5,a5,0x20
 442:	fff7c793          	not	a5,a5
 446:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 448:	15fd                	addi	a1,a1,-1
 44a:	177d                	addi	a4,a4,-1
 44c:	0005c683          	lbu	a3,0(a1)
 450:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 454:	fee79ae3          	bne	a5,a4,448 <memmove+0x46>
 458:	bfc9                	j	42a <memmove+0x28>

000000000000045a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 45a:	1141                	addi	sp,sp,-16
 45c:	e422                	sd	s0,8(sp)
 45e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 460:	ca05                	beqz	a2,490 <memcmp+0x36>
 462:	fff6069b          	addiw	a3,a2,-1
 466:	1682                	slli	a3,a3,0x20
 468:	9281                	srli	a3,a3,0x20
 46a:	0685                	addi	a3,a3,1
 46c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 46e:	00054783          	lbu	a5,0(a0)
 472:	0005c703          	lbu	a4,0(a1)
 476:	00e79863          	bne	a5,a4,486 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 47a:	0505                	addi	a0,a0,1
    p2++;
 47c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 47e:	fed518e3          	bne	a0,a3,46e <memcmp+0x14>
  }
  return 0;
 482:	4501                	li	a0,0
 484:	a019                	j	48a <memcmp+0x30>
      return *p1 - *p2;
 486:	40e7853b          	subw	a0,a5,a4
}
 48a:	6422                	ld	s0,8(sp)
 48c:	0141                	addi	sp,sp,16
 48e:	8082                	ret
  return 0;
 490:	4501                	li	a0,0
 492:	bfe5                	j	48a <memcmp+0x30>

0000000000000494 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 494:	1141                	addi	sp,sp,-16
 496:	e406                	sd	ra,8(sp)
 498:	e022                	sd	s0,0(sp)
 49a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 49c:	00000097          	auipc	ra,0x0
 4a0:	f66080e7          	jalr	-154(ra) # 402 <memmove>
}
 4a4:	60a2                	ld	ra,8(sp)
 4a6:	6402                	ld	s0,0(sp)
 4a8:	0141                	addi	sp,sp,16
 4aa:	8082                	ret

00000000000004ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ac:	4885                	li	a7,1
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b4:	4889                	li	a7,2
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4bc:	488d                	li	a7,3
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c4:	4891                	li	a7,4
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <read>:
.global read
read:
 li a7, SYS_read
 4cc:	4895                	li	a7,5
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <write>:
.global write
write:
 li a7, SYS_write
 4d4:	48c1                	li	a7,16
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <close>:
.global close
close:
 li a7, SYS_close
 4dc:	48d5                	li	a7,21
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e4:	4899                	li	a7,6
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ec:	489d                	li	a7,7
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <open>:
.global open
open:
 li a7, SYS_open
 4f4:	48bd                	li	a7,15
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fc:	48c5                	li	a7,17
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 504:	48c9                	li	a7,18
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50c:	48a1                	li	a7,8
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <link>:
.global link
link:
 li a7, SYS_link
 514:	48cd                	li	a7,19
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51c:	48d1                	li	a7,20
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 524:	48a5                	li	a7,9
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <dup>:
.global dup
dup:
 li a7, SYS_dup
 52c:	48a9                	li	a7,10
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 534:	48ad                	li	a7,11
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53c:	48b1                	li	a7,12
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 544:	48b5                	li	a7,13
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54c:	48b9                	li	a7,14
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 554:	1101                	addi	sp,sp,-32
 556:	ec06                	sd	ra,24(sp)
 558:	e822                	sd	s0,16(sp)
 55a:	1000                	addi	s0,sp,32
 55c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 560:	4605                	li	a2,1
 562:	fef40593          	addi	a1,s0,-17
 566:	00000097          	auipc	ra,0x0
 56a:	f6e080e7          	jalr	-146(ra) # 4d4 <write>
}
 56e:	60e2                	ld	ra,24(sp)
 570:	6442                	ld	s0,16(sp)
 572:	6105                	addi	sp,sp,32
 574:	8082                	ret

0000000000000576 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 576:	7139                	addi	sp,sp,-64
 578:	fc06                	sd	ra,56(sp)
 57a:	f822                	sd	s0,48(sp)
 57c:	f426                	sd	s1,40(sp)
 57e:	f04a                	sd	s2,32(sp)
 580:	ec4e                	sd	s3,24(sp)
 582:	0080                	addi	s0,sp,64
 584:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 586:	c299                	beqz	a3,58c <printint+0x16>
 588:	0805c963          	bltz	a1,61a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 58c:	2581                	sext.w	a1,a1
  neg = 0;
 58e:	4881                	li	a7,0
 590:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 594:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 596:	2601                	sext.w	a2,a2
 598:	00000517          	auipc	a0,0x0
 59c:	52050513          	addi	a0,a0,1312 # ab8 <digits>
 5a0:	883a                	mv	a6,a4
 5a2:	2705                	addiw	a4,a4,1
 5a4:	02c5f7bb          	remuw	a5,a1,a2
 5a8:	1782                	slli	a5,a5,0x20
 5aa:	9381                	srli	a5,a5,0x20
 5ac:	97aa                	add	a5,a5,a0
 5ae:	0007c783          	lbu	a5,0(a5)
 5b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5b6:	0005879b          	sext.w	a5,a1
 5ba:	02c5d5bb          	divuw	a1,a1,a2
 5be:	0685                	addi	a3,a3,1
 5c0:	fec7f0e3          	bgeu	a5,a2,5a0 <printint+0x2a>
  if(neg)
 5c4:	00088c63          	beqz	a7,5dc <printint+0x66>
    buf[i++] = '-';
 5c8:	fd070793          	addi	a5,a4,-48
 5cc:	00878733          	add	a4,a5,s0
 5d0:	02d00793          	li	a5,45
 5d4:	fef70823          	sb	a5,-16(a4)
 5d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5dc:	02e05863          	blez	a4,60c <printint+0x96>
 5e0:	fc040793          	addi	a5,s0,-64
 5e4:	00e78933          	add	s2,a5,a4
 5e8:	fff78993          	addi	s3,a5,-1
 5ec:	99ba                	add	s3,s3,a4
 5ee:	377d                	addiw	a4,a4,-1
 5f0:	1702                	slli	a4,a4,0x20
 5f2:	9301                	srli	a4,a4,0x20
 5f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5f8:	fff94583          	lbu	a1,-1(s2)
 5fc:	8526                	mv	a0,s1
 5fe:	00000097          	auipc	ra,0x0
 602:	f56080e7          	jalr	-170(ra) # 554 <putc>
  while(--i >= 0)
 606:	197d                	addi	s2,s2,-1
 608:	ff3918e3          	bne	s2,s3,5f8 <printint+0x82>
}
 60c:	70e2                	ld	ra,56(sp)
 60e:	7442                	ld	s0,48(sp)
 610:	74a2                	ld	s1,40(sp)
 612:	7902                	ld	s2,32(sp)
 614:	69e2                	ld	s3,24(sp)
 616:	6121                	addi	sp,sp,64
 618:	8082                	ret
    x = -xx;
 61a:	40b005bb          	negw	a1,a1
    neg = 1;
 61e:	4885                	li	a7,1
    x = -xx;
 620:	bf85                	j	590 <printint+0x1a>

0000000000000622 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 622:	7119                	addi	sp,sp,-128
 624:	fc86                	sd	ra,120(sp)
 626:	f8a2                	sd	s0,112(sp)
 628:	f4a6                	sd	s1,104(sp)
 62a:	f0ca                	sd	s2,96(sp)
 62c:	ecce                	sd	s3,88(sp)
 62e:	e8d2                	sd	s4,80(sp)
 630:	e4d6                	sd	s5,72(sp)
 632:	e0da                	sd	s6,64(sp)
 634:	fc5e                	sd	s7,56(sp)
 636:	f862                	sd	s8,48(sp)
 638:	f466                	sd	s9,40(sp)
 63a:	f06a                	sd	s10,32(sp)
 63c:	ec6e                	sd	s11,24(sp)
 63e:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 640:	0005c903          	lbu	s2,0(a1)
 644:	18090f63          	beqz	s2,7e2 <vprintf+0x1c0>
 648:	8aaa                	mv	s5,a0
 64a:	8b32                	mv	s6,a2
 64c:	00158493          	addi	s1,a1,1
  state = 0;
 650:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 652:	02500a13          	li	s4,37
 656:	4c55                	li	s8,21
 658:	00000c97          	auipc	s9,0x0
 65c:	408c8c93          	addi	s9,s9,1032 # a60 <malloc+0x17a>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
        s = va_arg(ap, char*);
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 660:	02800d93          	li	s11,40
  putc(fd, 'x');
 664:	4d41                	li	s10,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 666:	00000b97          	auipc	s7,0x0
 66a:	452b8b93          	addi	s7,s7,1106 # ab8 <digits>
 66e:	a839                	j	68c <vprintf+0x6a>
        putc(fd, c);
 670:	85ca                	mv	a1,s2
 672:	8556                	mv	a0,s5
 674:	00000097          	auipc	ra,0x0
 678:	ee0080e7          	jalr	-288(ra) # 554 <putc>
 67c:	a019                	j	682 <vprintf+0x60>
    } else if(state == '%'){
 67e:	01498d63          	beq	s3,s4,698 <vprintf+0x76>
  for(i = 0; fmt[i]; i++){
 682:	0485                	addi	s1,s1,1
 684:	fff4c903          	lbu	s2,-1(s1)
 688:	14090d63          	beqz	s2,7e2 <vprintf+0x1c0>
    if(state == 0){
 68c:	fe0999e3          	bnez	s3,67e <vprintf+0x5c>
      if(c == '%'){
 690:	ff4910e3          	bne	s2,s4,670 <vprintf+0x4e>
        state = '%';
 694:	89d2                	mv	s3,s4
 696:	b7f5                	j	682 <vprintf+0x60>
      if(c == 'd'){
 698:	11490c63          	beq	s2,s4,7b0 <vprintf+0x18e>
 69c:	f9d9079b          	addiw	a5,s2,-99
 6a0:	0ff7f793          	zext.b	a5,a5
 6a4:	10fc6e63          	bltu	s8,a5,7c0 <vprintf+0x19e>
 6a8:	f9d9079b          	addiw	a5,s2,-99
 6ac:	0ff7f713          	zext.b	a4,a5
 6b0:	10ec6863          	bltu	s8,a4,7c0 <vprintf+0x19e>
 6b4:	00271793          	slli	a5,a4,0x2
 6b8:	97e6                	add	a5,a5,s9
 6ba:	439c                	lw	a5,0(a5)
 6bc:	97e6                	add	a5,a5,s9
 6be:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6c0:	008b0913          	addi	s2,s6,8
 6c4:	4685                	li	a3,1
 6c6:	4629                	li	a2,10
 6c8:	000b2583          	lw	a1,0(s6)
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	ea8080e7          	jalr	-344(ra) # 576 <printint>
 6d6:	8b4a                	mv	s6,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b765                	j	682 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b0913          	addi	s2,s6,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000b2583          	lw	a1,0(s6)
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e8c080e7          	jalr	-372(ra) # 576 <printint>
 6f2:	8b4a                	mv	s6,s2
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b771                	j	682 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6f8:	008b0913          	addi	s2,s6,8
 6fc:	4681                	li	a3,0
 6fe:	866a                	mv	a2,s10
 700:	000b2583          	lw	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	e70080e7          	jalr	-400(ra) # 576 <printint>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	bf85                	j	682 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 714:	008b0793          	addi	a5,s6,8
 718:	f8f43423          	sd	a5,-120(s0)
 71c:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 720:	03000593          	li	a1,48
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	e2e080e7          	jalr	-466(ra) # 554 <putc>
  putc(fd, 'x');
 72e:	07800593          	li	a1,120
 732:	8556                	mv	a0,s5
 734:	00000097          	auipc	ra,0x0
 738:	e20080e7          	jalr	-480(ra) # 554 <putc>
 73c:	896a                	mv	s2,s10
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 73e:	03c9d793          	srli	a5,s3,0x3c
 742:	97de                	add	a5,a5,s7
 744:	0007c583          	lbu	a1,0(a5)
 748:	8556                	mv	a0,s5
 74a:	00000097          	auipc	ra,0x0
 74e:	e0a080e7          	jalr	-502(ra) # 554 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 752:	0992                	slli	s3,s3,0x4
 754:	397d                	addiw	s2,s2,-1
 756:	fe0914e3          	bnez	s2,73e <vprintf+0x11c>
        printptr(fd, va_arg(ap, uint64));
 75a:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 75e:	4981                	li	s3,0
 760:	b70d                	j	682 <vprintf+0x60>
        s = va_arg(ap, char*);
 762:	008b0913          	addi	s2,s6,8
 766:	000b3983          	ld	s3,0(s6)
        if(s == 0)
 76a:	02098163          	beqz	s3,78c <vprintf+0x16a>
        while(*s != 0){
 76e:	0009c583          	lbu	a1,0(s3)
 772:	c5ad                	beqz	a1,7dc <vprintf+0x1ba>
          putc(fd, *s);
 774:	8556                	mv	a0,s5
 776:	00000097          	auipc	ra,0x0
 77a:	dde080e7          	jalr	-546(ra) # 554 <putc>
          s++;
 77e:	0985                	addi	s3,s3,1
        while(*s != 0){
 780:	0009c583          	lbu	a1,0(s3)
 784:	f9e5                	bnez	a1,774 <vprintf+0x152>
        s = va_arg(ap, char*);
 786:	8b4a                	mv	s6,s2
      state = 0;
 788:	4981                	li	s3,0
 78a:	bde5                	j	682 <vprintf+0x60>
          s = "(null)";
 78c:	00000997          	auipc	s3,0x0
 790:	2cc98993          	addi	s3,s3,716 # a58 <malloc+0x172>
        while(*s != 0){
 794:	85ee                	mv	a1,s11
 796:	bff9                	j	774 <vprintf+0x152>
        putc(fd, va_arg(ap, uint));
 798:	008b0913          	addi	s2,s6,8
 79c:	000b4583          	lbu	a1,0(s6)
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	db2080e7          	jalr	-590(ra) # 554 <putc>
 7aa:	8b4a                	mv	s6,s2
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	bdd1                	j	682 <vprintf+0x60>
        putc(fd, c);
 7b0:	85d2                	mv	a1,s4
 7b2:	8556                	mv	a0,s5
 7b4:	00000097          	auipc	ra,0x0
 7b8:	da0080e7          	jalr	-608(ra) # 554 <putc>
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b5d1                	j	682 <vprintf+0x60>
        putc(fd, '%');
 7c0:	85d2                	mv	a1,s4
 7c2:	8556                	mv	a0,s5
 7c4:	00000097          	auipc	ra,0x0
 7c8:	d90080e7          	jalr	-624(ra) # 554 <putc>
        putc(fd, c);
 7cc:	85ca                	mv	a1,s2
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	d84080e7          	jalr	-636(ra) # 554 <putc>
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b565                	j	682 <vprintf+0x60>
        s = va_arg(ap, char*);
 7dc:	8b4a                	mv	s6,s2
      state = 0;
 7de:	4981                	li	s3,0
 7e0:	b54d                	j	682 <vprintf+0x60>
    }
  }
}
 7e2:	70e6                	ld	ra,120(sp)
 7e4:	7446                	ld	s0,112(sp)
 7e6:	74a6                	ld	s1,104(sp)
 7e8:	7906                	ld	s2,96(sp)
 7ea:	69e6                	ld	s3,88(sp)
 7ec:	6a46                	ld	s4,80(sp)
 7ee:	6aa6                	ld	s5,72(sp)
 7f0:	6b06                	ld	s6,64(sp)
 7f2:	7be2                	ld	s7,56(sp)
 7f4:	7c42                	ld	s8,48(sp)
 7f6:	7ca2                	ld	s9,40(sp)
 7f8:	7d02                	ld	s10,32(sp)
 7fa:	6de2                	ld	s11,24(sp)
 7fc:	6109                	addi	sp,sp,128
 7fe:	8082                	ret

0000000000000800 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 800:	715d                	addi	sp,sp,-80
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	1000                	addi	s0,sp,32
 808:	e010                	sd	a2,0(s0)
 80a:	e414                	sd	a3,8(s0)
 80c:	e818                	sd	a4,16(s0)
 80e:	ec1c                	sd	a5,24(s0)
 810:	03043023          	sd	a6,32(s0)
 814:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 818:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 81c:	8622                	mv	a2,s0
 81e:	00000097          	auipc	ra,0x0
 822:	e04080e7          	jalr	-508(ra) # 622 <vprintf>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6161                	addi	sp,sp,80
 82c:	8082                	ret

000000000000082e <printf>:

void
printf(const char *fmt, ...)
{
 82e:	711d                	addi	sp,sp,-96
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e40c                	sd	a1,8(s0)
 838:	e810                	sd	a2,16(s0)
 83a:	ec14                	sd	a3,24(s0)
 83c:	f018                	sd	a4,32(s0)
 83e:	f41c                	sd	a5,40(s0)
 840:	03043823          	sd	a6,48(s0)
 844:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	00840613          	addi	a2,s0,8
 84c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 850:	85aa                	mv	a1,a0
 852:	4505                	li	a0,1
 854:	00000097          	auipc	ra,0x0
 858:	dce080e7          	jalr	-562(ra) # 622 <vprintf>
}
 85c:	60e2                	ld	ra,24(sp)
 85e:	6442                	ld	s0,16(sp)
 860:	6125                	addi	sp,sp,96
 862:	8082                	ret

0000000000000864 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 864:	1141                	addi	sp,sp,-16
 866:	e422                	sd	s0,8(sp)
 868:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 86a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86e:	00000797          	auipc	a5,0x0
 872:	7927b783          	ld	a5,1938(a5) # 1000 <freep>
 876:	a02d                	j	8a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 878:	4618                	lw	a4,8(a2)
 87a:	9f2d                	addw	a4,a4,a1
 87c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	6398                	ld	a4,0(a5)
 882:	6310                	ld	a2,0(a4)
 884:	a83d                	j	8c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 886:	ff852703          	lw	a4,-8(a0)
 88a:	9f31                	addw	a4,a4,a2
 88c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 88e:	ff053683          	ld	a3,-16(a0)
 892:	a091                	j	8d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	6398                	ld	a4,0(a5)
 896:	00e7e463          	bltu	a5,a4,89e <free+0x3a>
 89a:	00e6ea63          	bltu	a3,a4,8ae <free+0x4a>
{
 89e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a0:	fed7fae3          	bgeu	a5,a3,894 <free+0x30>
 8a4:	6398                	ld	a4,0(a5)
 8a6:	00e6e463          	bltu	a3,a4,8ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8aa:	fee7eae3          	bltu	a5,a4,89e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8ae:	ff852583          	lw	a1,-8(a0)
 8b2:	6390                	ld	a2,0(a5)
 8b4:	02059813          	slli	a6,a1,0x20
 8b8:	01c85713          	srli	a4,a6,0x1c
 8bc:	9736                	add	a4,a4,a3
 8be:	fae60de3          	beq	a2,a4,878 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8c6:	4790                	lw	a2,8(a5)
 8c8:	02061593          	slli	a1,a2,0x20
 8cc:	01c5d713          	srli	a4,a1,0x1c
 8d0:	973e                	add	a4,a4,a5
 8d2:	fae68ae3          	beq	a3,a4,886 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72f73423          	sd	a5,1832(a4) # 1000 <freep>
}
 8e0:	6422                	ld	s0,8(sp)
 8e2:	0141                	addi	sp,sp,16
 8e4:	8082                	ret

00000000000008e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e6:	7139                	addi	sp,sp,-64
 8e8:	fc06                	sd	ra,56(sp)
 8ea:	f822                	sd	s0,48(sp)
 8ec:	f426                	sd	s1,40(sp)
 8ee:	f04a                	sd	s2,32(sp)
 8f0:	ec4e                	sd	s3,24(sp)
 8f2:	e852                	sd	s4,16(sp)
 8f4:	e456                	sd	s5,8(sp)
 8f6:	e05a                	sd	s6,0(sp)
 8f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8fa:	02051493          	slli	s1,a0,0x20
 8fe:	9081                	srli	s1,s1,0x20
 900:	04bd                	addi	s1,s1,15
 902:	8091                	srli	s1,s1,0x4
 904:	0014899b          	addiw	s3,s1,1
 908:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 90a:	00000517          	auipc	a0,0x0
 90e:	6f653503          	ld	a0,1782(a0) # 1000 <freep>
 912:	c515                	beqz	a0,93e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	02977f63          	bgeu	a4,s1,956 <malloc+0x70>
 91c:	8a4e                	mv	s4,s3
 91e:	0009871b          	sext.w	a4,s3
 922:	6685                	lui	a3,0x1
 924:	00d77363          	bgeu	a4,a3,92a <malloc+0x44>
 928:	6a05                	lui	s4,0x1
 92a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 932:	00000917          	auipc	s2,0x0
 936:	6ce90913          	addi	s2,s2,1742 # 1000 <freep>
  if(p == (char*)-1)
 93a:	5afd                	li	s5,-1
 93c:	a895                	j	9b0 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 93e:	00000797          	auipc	a5,0x0
 942:	6d278793          	addi	a5,a5,1746 # 1010 <base>
 946:	00000717          	auipc	a4,0x0
 94a:	6af73d23          	sd	a5,1722(a4) # 1000 <freep>
 94e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 950:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 954:	b7e1                	j	91c <malloc+0x36>
      if(p->s.size == nunits)
 956:	02e48c63          	beq	s1,a4,98e <malloc+0xa8>
        p->s.size -= nunits;
 95a:	4137073b          	subw	a4,a4,s3
 95e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 960:	02071693          	slli	a3,a4,0x20
 964:	01c6d713          	srli	a4,a3,0x1c
 968:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 96a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 96e:	00000717          	auipc	a4,0x0
 972:	68a73923          	sd	a0,1682(a4) # 1000 <freep>
      return (void*)(p + 1);
 976:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 97a:	70e2                	ld	ra,56(sp)
 97c:	7442                	ld	s0,48(sp)
 97e:	74a2                	ld	s1,40(sp)
 980:	7902                	ld	s2,32(sp)
 982:	69e2                	ld	s3,24(sp)
 984:	6a42                	ld	s4,16(sp)
 986:	6aa2                	ld	s5,8(sp)
 988:	6b02                	ld	s6,0(sp)
 98a:	6121                	addi	sp,sp,64
 98c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 98e:	6398                	ld	a4,0(a5)
 990:	e118                	sd	a4,0(a0)
 992:	bff1                	j	96e <malloc+0x88>
  hp->s.size = nu;
 994:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 998:	0541                	addi	a0,a0,16
 99a:	00000097          	auipc	ra,0x0
 99e:	eca080e7          	jalr	-310(ra) # 864 <free>
  return freep;
 9a2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9a6:	d971                	beqz	a0,97a <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9aa:	4798                	lw	a4,8(a5)
 9ac:	fa9775e3          	bgeu	a4,s1,956 <malloc+0x70>
    if(p == freep)
 9b0:	00093703          	ld	a4,0(s2)
 9b4:	853e                	mv	a0,a5
 9b6:	fef719e3          	bne	a4,a5,9a8 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9ba:	8552                	mv	a0,s4
 9bc:	00000097          	auipc	ra,0x0
 9c0:	b80080e7          	jalr	-1152(ra) # 53c <sbrk>
  if(p == (char*)-1)
 9c4:	fd5518e3          	bne	a0,s5,994 <malloc+0xae>
        return 0;
 9c8:	4501                	li	a0,0
 9ca:	bf45                	j	97a <malloc+0x94>
