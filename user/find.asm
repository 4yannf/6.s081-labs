
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

void find(char *path, char *tarFile){
   0:	da010113          	addi	sp,sp,-608
   4:	24113c23          	sd	ra,600(sp)
   8:	24813823          	sd	s0,592(sp)
   c:	24913423          	sd	s1,584(sp)
  10:	25213023          	sd	s2,576(sp)
  14:	23313c23          	sd	s3,568(sp)
  18:	23413823          	sd	s4,560(sp)
  1c:	1480                	addi	s0,sp,608
  1e:	892a                	mv	s2,a0
  20:	89ae                	mv	s3,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  22:	4581                	li	a1,0
  24:	00000097          	auipc	ra,0x0
  28:	4ae080e7          	jalr	1198(ra) # 4d2 <open>
  2c:	04054e63          	bltz	a0,88 <find+0x88>
  30:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  32:	da840593          	addi	a1,s0,-600
  36:	00000097          	auipc	ra,0x0
  3a:	4b4080e7          	jalr	1204(ra) # 4ea <fstat>
  3e:	06054063          	bltz	a0,9e <find+0x9e>
    fprintf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  42:	db041783          	lh	a5,-592(s0)
  46:	4705                	li	a4,1
  48:	06e78b63          	beq	a5,a4,be <find+0xbe>
  4c:	37f9                	addiw	a5,a5,-2
  4e:	17c2                	slli	a5,a5,0x30
  50:	93c1                	srli	a5,a5,0x30
  52:	00f76c63          	bltu	a4,a5,6a <find+0x6a>
    // char *name = fmtname(path);
    // if(strcmp(name, tarFile) == 0) {
    //   fprintf(1, "%s\n", path);
    // }
    // else fprintf(1, "find: cannot find %s", name);
    fprintf(2, "find: %s is not a dirctory\n", path);
  56:	864a                	mv	a2,s2
  58:	00001597          	auipc	a1,0x1
  5c:	98858593          	addi	a1,a1,-1656 # 9e0 <malloc+0x11e>
  60:	4509                	li	a0,2
  62:	00000097          	auipc	ra,0x0
  66:	77a080e7          	jalr	1914(ra) # 7dc <fprintf>
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
      }
    }
    break;
  }
}
  6a:	25813083          	ld	ra,600(sp)
  6e:	25013403          	ld	s0,592(sp)
  72:	24813483          	ld	s1,584(sp)
  76:	24013903          	ld	s2,576(sp)
  7a:	23813983          	ld	s3,568(sp)
  7e:	23013a03          	ld	s4,560(sp)
  82:	26010113          	addi	sp,sp,608
  86:	8082                	ret
    fprintf(2, "find: cannot open %s\n", path);
  88:	864a                	mv	a2,s2
  8a:	00001597          	auipc	a1,0x1
  8e:	92658593          	addi	a1,a1,-1754 # 9b0 <malloc+0xee>
  92:	4509                	li	a0,2
  94:	00000097          	auipc	ra,0x0
  98:	748080e7          	jalr	1864(ra) # 7dc <fprintf>
    return;
  9c:	b7f9                	j	6a <find+0x6a>
    fprintf(2, "find: cannot stat %s\n", path);
  9e:	864a                	mv	a2,s2
  a0:	00001597          	auipc	a1,0x1
  a4:	92858593          	addi	a1,a1,-1752 # 9c8 <malloc+0x106>
  a8:	4509                	li	a0,2
  aa:	00000097          	auipc	ra,0x0
  ae:	732080e7          	jalr	1842(ra) # 7dc <fprintf>
    close(fd);
  b2:	8526                	mv	a0,s1
  b4:	00000097          	auipc	ra,0x0
  b8:	406080e7          	jalr	1030(ra) # 4ba <close>
    return;
  bc:	b77d                	j	6a <find+0x6a>
    strcpy(buf, path);
  be:	85ca                	mv	a1,s2
  c0:	dd040513          	addi	a0,s0,-560
  c4:	00000097          	auipc	ra,0x0
  c8:	162080e7          	jalr	354(ra) # 226 <strcpy>
    p = buf+strlen(buf);
  cc:	dd040513          	addi	a0,s0,-560
  d0:	00000097          	auipc	ra,0x0
  d4:	19e080e7          	jalr	414(ra) # 26e <strlen>
  d8:	1502                	slli	a0,a0,0x20
  da:	9101                	srli	a0,a0,0x20
  dc:	dd040793          	addi	a5,s0,-560
  e0:	97aa                	add	a5,a5,a0
    *p++ = '/';
  e2:	00178913          	addi	s2,a5,1
  e6:	02f00713          	li	a4,47
  ea:	00e78023          	sb	a4,0(a5)
      if(st.type == T_DIR) {
  ee:	4a05                	li	s4,1
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
  f0:	4641                	li	a2,16
  f2:	dc040593          	addi	a1,s0,-576
  f6:	8526                	mv	a0,s1
  f8:	00000097          	auipc	ra,0x0
  fc:	3b2080e7          	jalr	946(ra) # 4aa <read>
 100:	47c1                	li	a5,16
 102:	f6f514e3          	bne	a0,a5,6a <find+0x6a>
      if(de.inum == 0)
 106:	dc045783          	lhu	a5,-576(s0)
 10a:	d3fd                	beqz	a5,f0 <find+0xf0>
      memmove(p, de.name, DIRSIZ);
 10c:	4639                	li	a2,14
 10e:	dc240593          	addi	a1,s0,-574
 112:	854a                	mv	a0,s2
 114:	00000097          	auipc	ra,0x0
 118:	2cc080e7          	jalr	716(ra) # 3e0 <memmove>
      if(stat(buf, &st) < 0){
 11c:	da840593          	addi	a1,s0,-600
 120:	dd040513          	addi	a0,s0,-560
 124:	00000097          	auipc	ra,0x0
 128:	22e080e7          	jalr	558(ra) # 352 <stat>
 12c:	02054963          	bltz	a0,15e <find+0x15e>
      if(st.type == T_DIR) {
 130:	db041783          	lh	a5,-592(s0)
 134:	05478063          	beq	a5,s4,174 <find+0x174>
        if(!strcmp(de.name, tarFile)) printf("%s\n",buf);
 138:	85ce                	mv	a1,s3
 13a:	dc240513          	addi	a0,s0,-574
 13e:	00000097          	auipc	ra,0x0
 142:	104080e7          	jalr	260(ra) # 242 <strcmp>
 146:	f54d                	bnez	a0,f0 <find+0xf0>
 148:	dd040593          	addi	a1,s0,-560
 14c:	00001517          	auipc	a0,0x1
 150:	8c450513          	addi	a0,a0,-1852 # a10 <malloc+0x14e>
 154:	00000097          	auipc	ra,0x0
 158:	6b6080e7          	jalr	1718(ra) # 80a <printf>
 15c:	bf51                	j	f0 <find+0xf0>
        printf("find: cannot stat %s\n", buf);
 15e:	dd040593          	addi	a1,s0,-560
 162:	00001517          	auipc	a0,0x1
 166:	86650513          	addi	a0,a0,-1946 # 9c8 <malloc+0x106>
 16a:	00000097          	auipc	ra,0x0
 16e:	6a0080e7          	jalr	1696(ra) # 80a <printf>
        continue;
 172:	bfbd                	j	f0 <find+0xf0>
        if(strcmp(de.name, ".") && strcmp(de.name, ".."))
 174:	00001597          	auipc	a1,0x1
 178:	88c58593          	addi	a1,a1,-1908 # a00 <malloc+0x13e>
 17c:	dc240513          	addi	a0,s0,-574
 180:	00000097          	auipc	ra,0x0
 184:	0c2080e7          	jalr	194(ra) # 242 <strcmp>
 188:	d525                	beqz	a0,f0 <find+0xf0>
 18a:	00001597          	auipc	a1,0x1
 18e:	87e58593          	addi	a1,a1,-1922 # a08 <malloc+0x146>
 192:	dc240513          	addi	a0,s0,-574
 196:	00000097          	auipc	ra,0x0
 19a:	0ac080e7          	jalr	172(ra) # 242 <strcmp>
 19e:	d929                	beqz	a0,f0 <find+0xf0>
          find(buf, tarFile);
 1a0:	85ce                	mv	a1,s3
 1a2:	dd040513          	addi	a0,s0,-560
 1a6:	00000097          	auipc	ra,0x0
 1aa:	e5a080e7          	jalr	-422(ra) # 0 <find>
 1ae:	b789                	j	f0 <find+0xf0>

00000000000001b0 <main>:

int main(int argc, char* argv[]){
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e406                	sd	ra,8(sp)
 1b4:	e022                	sd	s0,0(sp)
 1b6:	0800                	addi	s0,sp,16
  if(argc < 2){
 1b8:	4705                	li	a4,1
 1ba:	02a75163          	bge	a4,a0,1dc <main+0x2c>
 1be:	87ae                	mv	a5,a1
    fprintf(2, "usage: find [dir] [file]\n");
    exit(1);
  }

  if(argc == 2){
 1c0:	4709                	li	a4,2
 1c2:	02e50b63          	beq	a0,a4,1f8 <main+0x48>
    find(".", argv[1]);
  }
  else {
    find(argv[1], argv[2]);
 1c6:	698c                	ld	a1,16(a1)
 1c8:	6788                	ld	a0,8(a5)
 1ca:	00000097          	auipc	ra,0x0
 1ce:	e36080e7          	jalr	-458(ra) # 0 <find>
  }
  exit(0);
 1d2:	4501                	li	a0,0
 1d4:	00000097          	auipc	ra,0x0
 1d8:	2be080e7          	jalr	702(ra) # 492 <exit>
    fprintf(2, "usage: find [dir] [file]\n");
 1dc:	00001597          	auipc	a1,0x1
 1e0:	83c58593          	addi	a1,a1,-1988 # a18 <malloc+0x156>
 1e4:	4509                	li	a0,2
 1e6:	00000097          	auipc	ra,0x0
 1ea:	5f6080e7          	jalr	1526(ra) # 7dc <fprintf>
    exit(1);
 1ee:	4505                	li	a0,1
 1f0:	00000097          	auipc	ra,0x0
 1f4:	2a2080e7          	jalr	674(ra) # 492 <exit>
    find(".", argv[1]);
 1f8:	658c                	ld	a1,8(a1)
 1fa:	00001517          	auipc	a0,0x1
 1fe:	80650513          	addi	a0,a0,-2042 # a00 <malloc+0x13e>
 202:	00000097          	auipc	ra,0x0
 206:	dfe080e7          	jalr	-514(ra) # 0 <find>
 20a:	b7e1                	j	1d2 <main+0x22>

000000000000020c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  extern int main();
  main();
 214:	00000097          	auipc	ra,0x0
 218:	f9c080e7          	jalr	-100(ra) # 1b0 <main>
  exit(0);
 21c:	4501                	li	a0,0
 21e:	00000097          	auipc	ra,0x0
 222:	274080e7          	jalr	628(ra) # 492 <exit>

0000000000000226 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 226:	1141                	addi	sp,sp,-16
 228:	e422                	sd	s0,8(sp)
 22a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 22c:	87aa                	mv	a5,a0
 22e:	0585                	addi	a1,a1,1
 230:	0785                	addi	a5,a5,1
 232:	fff5c703          	lbu	a4,-1(a1)
 236:	fee78fa3          	sb	a4,-1(a5)
 23a:	fb75                	bnez	a4,22e <strcpy+0x8>
    ;
  return os;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret

0000000000000242 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 242:	1141                	addi	sp,sp,-16
 244:	e422                	sd	s0,8(sp)
 246:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 248:	00054783          	lbu	a5,0(a0)
 24c:	cb91                	beqz	a5,260 <strcmp+0x1e>
 24e:	0005c703          	lbu	a4,0(a1)
 252:	00f71763          	bne	a4,a5,260 <strcmp+0x1e>
    p++, q++;
 256:	0505                	addi	a0,a0,1
 258:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 25a:	00054783          	lbu	a5,0(a0)
 25e:	fbe5                	bnez	a5,24e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 260:	0005c503          	lbu	a0,0(a1)
}
 264:	40a7853b          	subw	a0,a5,a0
 268:	6422                	ld	s0,8(sp)
 26a:	0141                	addi	sp,sp,16
 26c:	8082                	ret

000000000000026e <strlen>:

uint
strlen(const char *s)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 274:	00054783          	lbu	a5,0(a0)
 278:	cf91                	beqz	a5,294 <strlen+0x26>
 27a:	0505                	addi	a0,a0,1
 27c:	87aa                	mv	a5,a0
 27e:	86be                	mv	a3,a5
 280:	0785                	addi	a5,a5,1
 282:	fff7c703          	lbu	a4,-1(a5)
 286:	ff65                	bnez	a4,27e <strlen+0x10>
 288:	40a6853b          	subw	a0,a3,a0
 28c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 28e:	6422                	ld	s0,8(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  for(n = 0; s[n]; n++)
 294:	4501                	li	a0,0
 296:	bfe5                	j	28e <strlen+0x20>

0000000000000298 <memset>:

void*
memset(void *dst, int c, uint n)
{
 298:	1141                	addi	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 29e:	ca19                	beqz	a2,2b4 <memset+0x1c>
 2a0:	87aa                	mv	a5,a0
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ae:	0785                	addi	a5,a5,1
 2b0:	fee79de3          	bne	a5,a4,2aa <memset+0x12>
  }
  return dst;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret

00000000000002ba <strchr>:

char*
strchr(const char *s, char c)
{
 2ba:	1141                	addi	sp,sp,-16
 2bc:	e422                	sd	s0,8(sp)
 2be:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cb99                	beqz	a5,2da <strchr+0x20>
    if(*s == c)
 2c6:	00f58763          	beq	a1,a5,2d4 <strchr+0x1a>
  for(; *s; s++)
 2ca:	0505                	addi	a0,a0,1
 2cc:	00054783          	lbu	a5,0(a0)
 2d0:	fbfd                	bnez	a5,2c6 <strchr+0xc>
      return (char*)s;
  return 0;
 2d2:	4501                	li	a0,0
}
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  return 0;
 2da:	4501                	li	a0,0
 2dc:	bfe5                	j	2d4 <strchr+0x1a>

00000000000002de <gets>:

char*
gets(char *buf, int max)
{
 2de:	711d                	addi	sp,sp,-96
 2e0:	ec86                	sd	ra,88(sp)
 2e2:	e8a2                	sd	s0,80(sp)
 2e4:	e4a6                	sd	s1,72(sp)
 2e6:	e0ca                	sd	s2,64(sp)
 2e8:	fc4e                	sd	s3,56(sp)
 2ea:	f852                	sd	s4,48(sp)
 2ec:	f456                	sd	s5,40(sp)
 2ee:	f05a                	sd	s6,32(sp)
 2f0:	ec5e                	sd	s7,24(sp)
 2f2:	1080                	addi	s0,sp,96
 2f4:	8baa                	mv	s7,a0
 2f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f8:	892a                	mv	s2,a0
 2fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2fc:	4aa9                	li	s5,10
 2fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 300:	89a6                	mv	s3,s1
 302:	2485                	addiw	s1,s1,1
 304:	0344d863          	bge	s1,s4,334 <gets+0x56>
    cc = read(0, &c, 1);
 308:	4605                	li	a2,1
 30a:	faf40593          	addi	a1,s0,-81
 30e:	4501                	li	a0,0
 310:	00000097          	auipc	ra,0x0
 314:	19a080e7          	jalr	410(ra) # 4aa <read>
    if(cc < 1)
 318:	00a05e63          	blez	a0,334 <gets+0x56>
    buf[i++] = c;
 31c:	faf44783          	lbu	a5,-81(s0)
 320:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 324:	01578763          	beq	a5,s5,332 <gets+0x54>
 328:	0905                	addi	s2,s2,1
 32a:	fd679be3          	bne	a5,s6,300 <gets+0x22>
  for(i=0; i+1 < max; ){
 32e:	89a6                	mv	s3,s1
 330:	a011                	j	334 <gets+0x56>
 332:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 334:	99de                	add	s3,s3,s7
 336:	00098023          	sb	zero,0(s3)
  return buf;
}
 33a:	855e                	mv	a0,s7
 33c:	60e6                	ld	ra,88(sp)
 33e:	6446                	ld	s0,80(sp)
 340:	64a6                	ld	s1,72(sp)
 342:	6906                	ld	s2,64(sp)
 344:	79e2                	ld	s3,56(sp)
 346:	7a42                	ld	s4,48(sp)
 348:	7aa2                	ld	s5,40(sp)
 34a:	7b02                	ld	s6,32(sp)
 34c:	6be2                	ld	s7,24(sp)
 34e:	6125                	addi	sp,sp,96
 350:	8082                	ret

0000000000000352 <stat>:

int
stat(const char *n, struct stat *st)
{
 352:	1101                	addi	sp,sp,-32
 354:	ec06                	sd	ra,24(sp)
 356:	e822                	sd	s0,16(sp)
 358:	e426                	sd	s1,8(sp)
 35a:	e04a                	sd	s2,0(sp)
 35c:	1000                	addi	s0,sp,32
 35e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 360:	4581                	li	a1,0
 362:	00000097          	auipc	ra,0x0
 366:	170080e7          	jalr	368(ra) # 4d2 <open>
  if(fd < 0)
 36a:	02054563          	bltz	a0,394 <stat+0x42>
 36e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 370:	85ca                	mv	a1,s2
 372:	00000097          	auipc	ra,0x0
 376:	178080e7          	jalr	376(ra) # 4ea <fstat>
 37a:	892a                	mv	s2,a0
  close(fd);
 37c:	8526                	mv	a0,s1
 37e:	00000097          	auipc	ra,0x0
 382:	13c080e7          	jalr	316(ra) # 4ba <close>
  return r;
}
 386:	854a                	mv	a0,s2
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	64a2                	ld	s1,8(sp)
 38e:	6902                	ld	s2,0(sp)
 390:	6105                	addi	sp,sp,32
 392:	8082                	ret
    return -1;
 394:	597d                	li	s2,-1
 396:	bfc5                	j	386 <stat+0x34>

0000000000000398 <atoi>:

int
atoi(const char *s)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e422                	sd	s0,8(sp)
 39c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 39e:	00054683          	lbu	a3,0(a0)
 3a2:	fd06879b          	addiw	a5,a3,-48
 3a6:	0ff7f793          	zext.b	a5,a5
 3aa:	4625                	li	a2,9
 3ac:	02f66863          	bltu	a2,a5,3dc <atoi+0x44>
 3b0:	872a                	mv	a4,a0
  n = 0;
 3b2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3b4:	0705                	addi	a4,a4,1
 3b6:	0025179b          	slliw	a5,a0,0x2
 3ba:	9fa9                	addw	a5,a5,a0
 3bc:	0017979b          	slliw	a5,a5,0x1
 3c0:	9fb5                	addw	a5,a5,a3
 3c2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3c6:	00074683          	lbu	a3,0(a4)
 3ca:	fd06879b          	addiw	a5,a3,-48
 3ce:	0ff7f793          	zext.b	a5,a5
 3d2:	fef671e3          	bgeu	a2,a5,3b4 <atoi+0x1c>
  return n;
}
 3d6:	6422                	ld	s0,8(sp)
 3d8:	0141                	addi	sp,sp,16
 3da:	8082                	ret
  n = 0;
 3dc:	4501                	li	a0,0
 3de:	bfe5                	j	3d6 <atoi+0x3e>

00000000000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	1141                	addi	sp,sp,-16
 3e2:	e422                	sd	s0,8(sp)
 3e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3e6:	02b57463          	bgeu	a0,a1,40e <memmove+0x2e>
    while(n-- > 0)
 3ea:	00c05f63          	blez	a2,408 <memmove+0x28>
 3ee:	1602                	slli	a2,a2,0x20
 3f0:	9201                	srli	a2,a2,0x20
 3f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3f8:	0585                	addi	a1,a1,1
 3fa:	0705                	addi	a4,a4,1
 3fc:	fff5c683          	lbu	a3,-1(a1)
 400:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 404:	fee79ae3          	bne	a5,a4,3f8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 408:	6422                	ld	s0,8(sp)
 40a:	0141                	addi	sp,sp,16
 40c:	8082                	ret
    dst += n;
 40e:	00c50733          	add	a4,a0,a2
    src += n;
 412:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 414:	fec05ae3          	blez	a2,408 <memmove+0x28>
 418:	fff6079b          	addiw	a5,a2,-1
 41c:	1782                	slli	a5,a5,0x20
 41e:	9381                	srli	a5,a5,0x20
 420:	fff7c793          	not	a5,a5
 424:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 426:	15fd                	addi	a1,a1,-1
 428:	177d                	addi	a4,a4,-1
 42a:	0005c683          	lbu	a3,0(a1)
 42e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 432:	fee79ae3          	bne	a5,a4,426 <memmove+0x46>
 436:	bfc9                	j	408 <memmove+0x28>

0000000000000438 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 438:	1141                	addi	sp,sp,-16
 43a:	e422                	sd	s0,8(sp)
 43c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 43e:	ca05                	beqz	a2,46e <memcmp+0x36>
 440:	fff6069b          	addiw	a3,a2,-1
 444:	1682                	slli	a3,a3,0x20
 446:	9281                	srli	a3,a3,0x20
 448:	0685                	addi	a3,a3,1
 44a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 44c:	00054783          	lbu	a5,0(a0)
 450:	0005c703          	lbu	a4,0(a1)
 454:	00e79863          	bne	a5,a4,464 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 458:	0505                	addi	a0,a0,1
    p2++;
 45a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 45c:	fed518e3          	bne	a0,a3,44c <memcmp+0x14>
  }
  return 0;
 460:	4501                	li	a0,0
 462:	a019                	j	468 <memcmp+0x30>
      return *p1 - *p2;
 464:	40e7853b          	subw	a0,a5,a4
}
 468:	6422                	ld	s0,8(sp)
 46a:	0141                	addi	sp,sp,16
 46c:	8082                	ret
  return 0;
 46e:	4501                	li	a0,0
 470:	bfe5                	j	468 <memcmp+0x30>

0000000000000472 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 472:	1141                	addi	sp,sp,-16
 474:	e406                	sd	ra,8(sp)
 476:	e022                	sd	s0,0(sp)
 478:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 47a:	00000097          	auipc	ra,0x0
 47e:	f66080e7          	jalr	-154(ra) # 3e0 <memmove>
}
 482:	60a2                	ld	ra,8(sp)
 484:	6402                	ld	s0,0(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret

000000000000048a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 48a:	4885                	li	a7,1
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <exit>:
.global exit
exit:
 li a7, SYS_exit
 492:	4889                	li	a7,2
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <wait>:
.global wait
wait:
 li a7, SYS_wait
 49a:	488d                	li	a7,3
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4a2:	4891                	li	a7,4
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <read>:
.global read
read:
 li a7, SYS_read
 4aa:	4895                	li	a7,5
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <write>:
.global write
write:
 li a7, SYS_write
 4b2:	48c1                	li	a7,16
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <close>:
.global close
close:
 li a7, SYS_close
 4ba:	48d5                	li	a7,21
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4c2:	4899                	li	a7,6
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ca:	489d                	li	a7,7
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <open>:
.global open
open:
 li a7, SYS_open
 4d2:	48bd                	li	a7,15
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4da:	48c5                	li	a7,17
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4e2:	48c9                	li	a7,18
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4ea:	48a1                	li	a7,8
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <link>:
.global link
link:
 li a7, SYS_link
 4f2:	48cd                	li	a7,19
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4fa:	48d1                	li	a7,20
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 502:	48a5                	li	a7,9
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <dup>:
.global dup
dup:
 li a7, SYS_dup
 50a:	48a9                	li	a7,10
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 512:	48ad                	li	a7,11
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 51a:	48b1                	li	a7,12
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 522:	48b5                	li	a7,13
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 52a:	48b9                	li	a7,14
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <trace>:
.global trace
trace:
 li a7, SYS_trace
 532:	48d9                	li	a7,22
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 53a:	48dd                	li	a7,23
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 542:	1101                	addi	sp,sp,-32
 544:	ec06                	sd	ra,24(sp)
 546:	e822                	sd	s0,16(sp)
 548:	1000                	addi	s0,sp,32
 54a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 54e:	4605                	li	a2,1
 550:	fef40593          	addi	a1,s0,-17
 554:	00000097          	auipc	ra,0x0
 558:	f5e080e7          	jalr	-162(ra) # 4b2 <write>
}
 55c:	60e2                	ld	ra,24(sp)
 55e:	6442                	ld	s0,16(sp)
 560:	6105                	addi	sp,sp,32
 562:	8082                	ret

0000000000000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	7139                	addi	sp,sp,-64
 566:	fc06                	sd	ra,56(sp)
 568:	f822                	sd	s0,48(sp)
 56a:	f426                	sd	s1,40(sp)
 56c:	f04a                	sd	s2,32(sp)
 56e:	ec4e                	sd	s3,24(sp)
 570:	0080                	addi	s0,sp,64
 572:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 574:	c299                	beqz	a3,57a <printint+0x16>
 576:	0805c963          	bltz	a1,608 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 57a:	2581                	sext.w	a1,a1
  neg = 0;
 57c:	4881                	li	a7,0
 57e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 582:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 584:	2601                	sext.w	a2,a2
 586:	00000517          	auipc	a0,0x0
 58a:	51250513          	addi	a0,a0,1298 # a98 <digits>
 58e:	883a                	mv	a6,a4
 590:	2705                	addiw	a4,a4,1
 592:	02c5f7bb          	remuw	a5,a1,a2
 596:	1782                	slli	a5,a5,0x20
 598:	9381                	srli	a5,a5,0x20
 59a:	97aa                	add	a5,a5,a0
 59c:	0007c783          	lbu	a5,0(a5)
 5a0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a4:	0005879b          	sext.w	a5,a1
 5a8:	02c5d5bb          	divuw	a1,a1,a2
 5ac:	0685                	addi	a3,a3,1
 5ae:	fec7f0e3          	bgeu	a5,a2,58e <printint+0x2a>
  if(neg)
 5b2:	00088c63          	beqz	a7,5ca <printint+0x66>
    buf[i++] = '-';
 5b6:	fd070793          	addi	a5,a4,-48
 5ba:	00878733          	add	a4,a5,s0
 5be:	02d00793          	li	a5,45
 5c2:	fef70823          	sb	a5,-16(a4)
 5c6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5ca:	02e05863          	blez	a4,5fa <printint+0x96>
 5ce:	fc040793          	addi	a5,s0,-64
 5d2:	00e78933          	add	s2,a5,a4
 5d6:	fff78993          	addi	s3,a5,-1
 5da:	99ba                	add	s3,s3,a4
 5dc:	377d                	addiw	a4,a4,-1
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e6:	fff94583          	lbu	a1,-1(s2)
 5ea:	8526                	mv	a0,s1
 5ec:	00000097          	auipc	ra,0x0
 5f0:	f56080e7          	jalr	-170(ra) # 542 <putc>
  while(--i >= 0)
 5f4:	197d                	addi	s2,s2,-1
 5f6:	ff3918e3          	bne	s2,s3,5e6 <printint+0x82>
}
 5fa:	70e2                	ld	ra,56(sp)
 5fc:	7442                	ld	s0,48(sp)
 5fe:	74a2                	ld	s1,40(sp)
 600:	7902                	ld	s2,32(sp)
 602:	69e2                	ld	s3,24(sp)
 604:	6121                	addi	sp,sp,64
 606:	8082                	ret
    x = -xx;
 608:	40b005bb          	negw	a1,a1
    neg = 1;
 60c:	4885                	li	a7,1
    x = -xx;
 60e:	bf85                	j	57e <printint+0x1a>

0000000000000610 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 610:	715d                	addi	sp,sp,-80
 612:	e486                	sd	ra,72(sp)
 614:	e0a2                	sd	s0,64(sp)
 616:	fc26                	sd	s1,56(sp)
 618:	f84a                	sd	s2,48(sp)
 61a:	f44e                	sd	s3,40(sp)
 61c:	f052                	sd	s4,32(sp)
 61e:	ec56                	sd	s5,24(sp)
 620:	e85a                	sd	s6,16(sp)
 622:	e45e                	sd	s7,8(sp)
 624:	e062                	sd	s8,0(sp)
 626:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 628:	0005c903          	lbu	s2,0(a1)
 62c:	18090c63          	beqz	s2,7c4 <vprintf+0x1b4>
 630:	8aaa                	mv	s5,a0
 632:	8bb2                	mv	s7,a2
 634:	00158493          	addi	s1,a1,1
  state = 0;
 638:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 63a:	02500a13          	li	s4,37
 63e:	4b55                	li	s6,21
 640:	a839                	j	65e <vprintf+0x4e>
        putc(fd, c);
 642:	85ca                	mv	a1,s2
 644:	8556                	mv	a0,s5
 646:	00000097          	auipc	ra,0x0
 64a:	efc080e7          	jalr	-260(ra) # 542 <putc>
 64e:	a019                	j	654 <vprintf+0x44>
    } else if(state == '%'){
 650:	01498d63          	beq	s3,s4,66a <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 654:	0485                	addi	s1,s1,1
 656:	fff4c903          	lbu	s2,-1(s1)
 65a:	16090563          	beqz	s2,7c4 <vprintf+0x1b4>
    if(state == 0){
 65e:	fe0999e3          	bnez	s3,650 <vprintf+0x40>
      if(c == '%'){
 662:	ff4910e3          	bne	s2,s4,642 <vprintf+0x32>
        state = '%';
 666:	89d2                	mv	s3,s4
 668:	b7f5                	j	654 <vprintf+0x44>
      if(c == 'd'){
 66a:	13490263          	beq	s2,s4,78e <vprintf+0x17e>
 66e:	f9d9079b          	addiw	a5,s2,-99
 672:	0ff7f793          	zext.b	a5,a5
 676:	12fb6563          	bltu	s6,a5,7a0 <vprintf+0x190>
 67a:	f9d9079b          	addiw	a5,s2,-99
 67e:	0ff7f713          	zext.b	a4,a5
 682:	10eb6f63          	bltu	s6,a4,7a0 <vprintf+0x190>
 686:	00271793          	slli	a5,a4,0x2
 68a:	00000717          	auipc	a4,0x0
 68e:	3b670713          	addi	a4,a4,950 # a40 <malloc+0x17e>
 692:	97ba                	add	a5,a5,a4
 694:	439c                	lw	a5,0(a5)
 696:	97ba                	add	a5,a5,a4
 698:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4685                	li	a3,1
 6a0:	4629                	li	a2,10
 6a2:	000ba583          	lw	a1,0(s7)
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	ebc080e7          	jalr	-324(ra) # 564 <printint>
 6b0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b745                	j	654 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b6:	008b8913          	addi	s2,s7,8
 6ba:	4681                	li	a3,0
 6bc:	4629                	li	a2,10
 6be:	000ba583          	lw	a1,0(s7)
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	ea0080e7          	jalr	-352(ra) # 564 <printint>
 6cc:	8bca                	mv	s7,s2
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b751                	j	654 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 6d2:	008b8913          	addi	s2,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000ba583          	lw	a1,0(s7)
 6de:	8556                	mv	a0,s5
 6e0:	00000097          	auipc	ra,0x0
 6e4:	e84080e7          	jalr	-380(ra) # 564 <printint>
 6e8:	8bca                	mv	s7,s2
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b7a5                	j	654 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 6ee:	008b8c13          	addi	s8,s7,8
 6f2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f6:	03000593          	li	a1,48
 6fa:	8556                	mv	a0,s5
 6fc:	00000097          	auipc	ra,0x0
 700:	e46080e7          	jalr	-442(ra) # 542 <putc>
  putc(fd, 'x');
 704:	07800593          	li	a1,120
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	e38080e7          	jalr	-456(ra) # 542 <putc>
 712:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 714:	00000b97          	auipc	s7,0x0
 718:	384b8b93          	addi	s7,s7,900 # a98 <digits>
 71c:	03c9d793          	srli	a5,s3,0x3c
 720:	97de                	add	a5,a5,s7
 722:	0007c583          	lbu	a1,0(a5)
 726:	8556                	mv	a0,s5
 728:	00000097          	auipc	ra,0x0
 72c:	e1a080e7          	jalr	-486(ra) # 542 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 730:	0992                	slli	s3,s3,0x4
 732:	397d                	addiw	s2,s2,-1
 734:	fe0914e3          	bnez	s2,71c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 738:	8be2                	mv	s7,s8
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bf21                	j	654 <vprintf+0x44>
        s = va_arg(ap, char*);
 73e:	008b8993          	addi	s3,s7,8
 742:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 746:	02090163          	beqz	s2,768 <vprintf+0x158>
        while(*s != 0){
 74a:	00094583          	lbu	a1,0(s2)
 74e:	c9a5                	beqz	a1,7be <vprintf+0x1ae>
          putc(fd, *s);
 750:	8556                	mv	a0,s5
 752:	00000097          	auipc	ra,0x0
 756:	df0080e7          	jalr	-528(ra) # 542 <putc>
          s++;
 75a:	0905                	addi	s2,s2,1
        while(*s != 0){
 75c:	00094583          	lbu	a1,0(s2)
 760:	f9e5                	bnez	a1,750 <vprintf+0x140>
        s = va_arg(ap, char*);
 762:	8bce                	mv	s7,s3
      state = 0;
 764:	4981                	li	s3,0
 766:	b5fd                	j	654 <vprintf+0x44>
          s = "(null)";
 768:	00000917          	auipc	s2,0x0
 76c:	2d090913          	addi	s2,s2,720 # a38 <malloc+0x176>
        while(*s != 0){
 770:	02800593          	li	a1,40
 774:	bff1                	j	750 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 776:	008b8913          	addi	s2,s7,8
 77a:	000bc583          	lbu	a1,0(s7)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	dc2080e7          	jalr	-574(ra) # 542 <putc>
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b5e1                	j	654 <vprintf+0x44>
        putc(fd, c);
 78e:	02500593          	li	a1,37
 792:	8556                	mv	a0,s5
 794:	00000097          	auipc	ra,0x0
 798:	dae080e7          	jalr	-594(ra) # 542 <putc>
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bd5d                	j	654 <vprintf+0x44>
        putc(fd, '%');
 7a0:	02500593          	li	a1,37
 7a4:	8556                	mv	a0,s5
 7a6:	00000097          	auipc	ra,0x0
 7aa:	d9c080e7          	jalr	-612(ra) # 542 <putc>
        putc(fd, c);
 7ae:	85ca                	mv	a1,s2
 7b0:	8556                	mv	a0,s5
 7b2:	00000097          	auipc	ra,0x0
 7b6:	d90080e7          	jalr	-624(ra) # 542 <putc>
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	bd61                	j	654 <vprintf+0x44>
        s = va_arg(ap, char*);
 7be:	8bce                	mv	s7,s3
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bd49                	j	654 <vprintf+0x44>
    }
  }
}
 7c4:	60a6                	ld	ra,72(sp)
 7c6:	6406                	ld	s0,64(sp)
 7c8:	74e2                	ld	s1,56(sp)
 7ca:	7942                	ld	s2,48(sp)
 7cc:	79a2                	ld	s3,40(sp)
 7ce:	7a02                	ld	s4,32(sp)
 7d0:	6ae2                	ld	s5,24(sp)
 7d2:	6b42                	ld	s6,16(sp)
 7d4:	6ba2                	ld	s7,8(sp)
 7d6:	6c02                	ld	s8,0(sp)
 7d8:	6161                	addi	sp,sp,80
 7da:	8082                	ret

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7f8:	8622                	mv	a2,s0
 7fa:	00000097          	auipc	ra,0x0
 7fe:	e16080e7          	jalr	-490(ra) # 610 <vprintf>
}
 802:	60e2                	ld	ra,24(sp)
 804:	6442                	ld	s0,16(sp)
 806:	6161                	addi	sp,sp,80
 808:	8082                	ret

000000000000080a <printf>:

void
printf(const char *fmt, ...)
{
 80a:	711d                	addi	sp,sp,-96
 80c:	ec06                	sd	ra,24(sp)
 80e:	e822                	sd	s0,16(sp)
 810:	1000                	addi	s0,sp,32
 812:	e40c                	sd	a1,8(s0)
 814:	e810                	sd	a2,16(s0)
 816:	ec14                	sd	a3,24(s0)
 818:	f018                	sd	a4,32(s0)
 81a:	f41c                	sd	a5,40(s0)
 81c:	03043823          	sd	a6,48(s0)
 820:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	00840613          	addi	a2,s0,8
 828:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 82c:	85aa                	mv	a1,a0
 82e:	4505                	li	a0,1
 830:	00000097          	auipc	ra,0x0
 834:	de0080e7          	jalr	-544(ra) # 610 <vprintf>
}
 838:	60e2                	ld	ra,24(sp)
 83a:	6442                	ld	s0,16(sp)
 83c:	6125                	addi	sp,sp,96
 83e:	8082                	ret

0000000000000840 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 840:	1141                	addi	sp,sp,-16
 842:	e422                	sd	s0,8(sp)
 844:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 846:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	00000797          	auipc	a5,0x0
 84e:	7b67b783          	ld	a5,1974(a5) # 1000 <freep>
 852:	a02d                	j	87c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 854:	4618                	lw	a4,8(a2)
 856:	9f2d                	addw	a4,a4,a1
 858:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 85c:	6398                	ld	a4,0(a5)
 85e:	6310                	ld	a2,0(a4)
 860:	a83d                	j	89e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 862:	ff852703          	lw	a4,-8(a0)
 866:	9f31                	addw	a4,a4,a2
 868:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 86a:	ff053683          	ld	a3,-16(a0)
 86e:	a091                	j	8b2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	6398                	ld	a4,0(a5)
 872:	00e7e463          	bltu	a5,a4,87a <free+0x3a>
 876:	00e6ea63          	bltu	a3,a4,88a <free+0x4a>
{
 87a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87c:	fed7fae3          	bgeu	a5,a3,870 <free+0x30>
 880:	6398                	ld	a4,0(a5)
 882:	00e6e463          	bltu	a3,a4,88a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 886:	fee7eae3          	bltu	a5,a4,87a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 88a:	ff852583          	lw	a1,-8(a0)
 88e:	6390                	ld	a2,0(a5)
 890:	02059813          	slli	a6,a1,0x20
 894:	01c85713          	srli	a4,a6,0x1c
 898:	9736                	add	a4,a4,a3
 89a:	fae60de3          	beq	a2,a4,854 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8a2:	4790                	lw	a2,8(a5)
 8a4:	02061593          	slli	a1,a2,0x20
 8a8:	01c5d713          	srli	a4,a1,0x1c
 8ac:	973e                	add	a4,a4,a5
 8ae:	fae68ae3          	beq	a3,a4,862 <free+0x22>
    p->s.ptr = bp->s.ptr;
 8b2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74f73623          	sd	a5,1868(a4) # 1000 <freep>
}
 8bc:	6422                	ld	s0,8(sp)
 8be:	0141                	addi	sp,sp,16
 8c0:	8082                	ret

00000000000008c2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c2:	7139                	addi	sp,sp,-64
 8c4:	fc06                	sd	ra,56(sp)
 8c6:	f822                	sd	s0,48(sp)
 8c8:	f426                	sd	s1,40(sp)
 8ca:	f04a                	sd	s2,32(sp)
 8cc:	ec4e                	sd	s3,24(sp)
 8ce:	e852                	sd	s4,16(sp)
 8d0:	e456                	sd	s5,8(sp)
 8d2:	e05a                	sd	s6,0(sp)
 8d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d6:	02051493          	slli	s1,a0,0x20
 8da:	9081                	srli	s1,s1,0x20
 8dc:	04bd                	addi	s1,s1,15
 8de:	8091                	srli	s1,s1,0x4
 8e0:	0014899b          	addiw	s3,s1,1
 8e4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8e6:	00000517          	auipc	a0,0x0
 8ea:	71a53503          	ld	a0,1818(a0) # 1000 <freep>
 8ee:	c515                	beqz	a0,91a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f2:	4798                	lw	a4,8(a5)
 8f4:	02977f63          	bgeu	a4,s1,932 <malloc+0x70>
  if(nu < 4096)
 8f8:	8a4e                	mv	s4,s3
 8fa:	0009871b          	sext.w	a4,s3
 8fe:	6685                	lui	a3,0x1
 900:	00d77363          	bgeu	a4,a3,906 <malloc+0x44>
 904:	6a05                	lui	s4,0x1
 906:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 90a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 90e:	00000917          	auipc	s2,0x0
 912:	6f290913          	addi	s2,s2,1778 # 1000 <freep>
  if(p == (char*)-1)
 916:	5afd                	li	s5,-1
 918:	a895                	j	98c <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 91a:	00000797          	auipc	a5,0x0
 91e:	6f678793          	addi	a5,a5,1782 # 1010 <base>
 922:	00000717          	auipc	a4,0x0
 926:	6cf73f23          	sd	a5,1758(a4) # 1000 <freep>
 92a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 930:	b7e1                	j	8f8 <malloc+0x36>
      if(p->s.size == nunits)
 932:	02e48c63          	beq	s1,a4,96a <malloc+0xa8>
        p->s.size -= nunits;
 936:	4137073b          	subw	a4,a4,s3
 93a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93c:	02071693          	slli	a3,a4,0x20
 940:	01c6d713          	srli	a4,a3,0x1c
 944:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 946:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94a:	00000717          	auipc	a4,0x0
 94e:	6aa73b23          	sd	a0,1718(a4) # 1000 <freep>
      return (void*)(p + 1);
 952:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 956:	70e2                	ld	ra,56(sp)
 958:	7442                	ld	s0,48(sp)
 95a:	74a2                	ld	s1,40(sp)
 95c:	7902                	ld	s2,32(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
 966:	6121                	addi	sp,sp,64
 968:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 96a:	6398                	ld	a4,0(a5)
 96c:	e118                	sd	a4,0(a0)
 96e:	bff1                	j	94a <malloc+0x88>
  hp->s.size = nu;
 970:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 974:	0541                	addi	a0,a0,16
 976:	00000097          	auipc	ra,0x0
 97a:	eca080e7          	jalr	-310(ra) # 840 <free>
  return freep;
 97e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 982:	d971                	beqz	a0,956 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 984:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 986:	4798                	lw	a4,8(a5)
 988:	fa9775e3          	bgeu	a4,s1,932 <malloc+0x70>
    if(p == freep)
 98c:	00093703          	ld	a4,0(s2)
 990:	853e                	mv	a0,a5
 992:	fef719e3          	bne	a4,a5,984 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 996:	8552                	mv	a0,s4
 998:	00000097          	auipc	ra,0x0
 99c:	b82080e7          	jalr	-1150(ra) # 51a <sbrk>
  if(p == (char*)-1)
 9a0:	fd5518e3          	bne	a0,s5,970 <malloc+0xae>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	bf45                	j	956 <malloc+0x94>
