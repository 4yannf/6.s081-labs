
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user.h"

int main(){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	0880                	addi	s0,sp,80
  int p[2][2];
  int dividend = 0;
  const int mod = 2;

  pipe(p[dividend % mod]);
  10:	fc040513          	addi	a0,s0,-64
  14:	00000097          	auipc	ra,0x0
  18:	4de080e7          	jalr	1246(ra) # 4f2 <pipe>
  if(fork() == 0){
  1c:	00000097          	auipc	ra,0x0
  20:	4be080e7          	jalr	1214(ra) # 4da <fork>
  24:	1c051f63          	bnez	a0,202 <main+0x202>

    ++dividend;
    close(p[(dividend - 1) % mod][1]);
  28:	fc442503          	lw	a0,-60(s0)
  2c:	00000097          	auipc	ra,0x0
  30:	4de080e7          	jalr	1246(ra) # 50a <close>

    int prime;
    read(p[(dividend - 1) % mod][0], &prime, 4);
  34:	4611                	li	a2,4
  36:	fb840593          	addi	a1,s0,-72
  3a:	fc042503          	lw	a0,-64(s0)
  3e:	00000097          	auipc	ra,0x0
  42:	4bc080e7          	jalr	1212(ra) # 4fa <read>
    printf("prime %d\n", prime);
  46:	fb842583          	lw	a1,-72(s0)
  4a:	00001517          	auipc	a0,0x1
  4e:	9b650513          	addi	a0,a0,-1610 # a00 <malloc+0xee>
  52:	00001097          	auipc	ra,0x1
  56:	808080e7          	jalr	-2040(ra) # 85a <printf>
    ++dividend;
  5a:	4905                	li	s2,1
          close(p[(dividend - 1) % mod][1]);
          if(read(p[(dividend - 1) % mod][0], &prime, 4) == 0){
            close(p[(dividend - 1) % mod][0]);
            exit(0);
          }
          printf("prime %d\n", prime);
  5c:	00001997          	auipc	s3,0x1
  60:	9a498993          	addi	s3,s3,-1628 # a00 <malloc+0xee>
      if (read(p[(dividend - 1) % mod][0], &num, 4) == 0){
  64:	fff9079b          	addiw	a5,s2,-1
  68:	01f7d71b          	srliw	a4,a5,0x1f
  6c:	00e784bb          	addw	s1,a5,a4
  70:	8885                	andi	s1,s1,1
  72:	9c99                	subw	s1,s1,a4
  74:	00349793          	slli	a5,s1,0x3
  78:	fd078793          	addi	a5,a5,-48
  7c:	97a2                	add	a5,a5,s0
  7e:	4611                	li	a2,4
  80:	fbc40593          	addi	a1,s0,-68
  84:	ff07a503          	lw	a0,-16(a5)
  88:	00000097          	auipc	ra,0x0
  8c:	472080e7          	jalr	1138(ra) # 4fa <read>
  90:	cd2d                	beqz	a0,10a <main+0x10a>
      if(num % prime != 0){
  92:	fbc42783          	lw	a5,-68(s0)
  96:	fb842703          	lw	a4,-72(s0)
  9a:	02e7e7bb          	remw	a5,a5,a4
  9e:	d3f9                	beqz	a5,64 <main+0x64>
        pipe(p[dividend % mod]);
  a0:	01f9579b          	srliw	a5,s2,0x1f
  a4:	01278a3b          	addw	s4,a5,s2
  a8:	001a7a13          	andi	s4,s4,1
  ac:	40fa0a3b          	subw	s4,s4,a5
  b0:	003a1513          	slli	a0,s4,0x3
  b4:	fc040793          	addi	a5,s0,-64
  b8:	953e                	add	a0,a0,a5
  ba:	00000097          	auipc	ra,0x0
  be:	438080e7          	jalr	1080(ra) # 4f2 <pipe>
        if(fork() == 0){
  c2:	00000097          	auipc	ra,0x0
  c6:	418080e7          	jalr	1048(ra) # 4da <fork>
  ca:	e141                	bnez	a0,14a <main+0x14a>
          ++dividend;
  cc:	2905                	addiw	s2,s2,1
          close(p[(dividend - 1) % mod][1]);
  ce:	003a1493          	slli	s1,s4,0x3
  d2:	fd048793          	addi	a5,s1,-48
  d6:	008784b3          	add	s1,a5,s0
  da:	ff44a503          	lw	a0,-12(s1)
  de:	00000097          	auipc	ra,0x0
  e2:	42c080e7          	jalr	1068(ra) # 50a <close>
          if(read(p[(dividend - 1) % mod][0], &prime, 4) == 0){
  e6:	4611                	li	a2,4
  e8:	fb840593          	addi	a1,s0,-72
  ec:	ff04a503          	lw	a0,-16(s1)
  f0:	00000097          	auipc	ra,0x0
  f4:	40a080e7          	jalr	1034(ra) # 4fa <read>
  f8:	cd15                	beqz	a0,134 <main+0x134>
          printf("prime %d\n", prime);
  fa:	fb842583          	lw	a1,-72(s0)
  fe:	854e                	mv	a0,s3
 100:	00000097          	auipc	ra,0x0
 104:	75a080e7          	jalr	1882(ra) # 85a <printf>
    while(1){
 108:	bfb1                	j	64 <main+0x64>
        close(p[(dividend - 1) % mod][0]);
 10a:	048e                	slli	s1,s1,0x3
 10c:	fd048793          	addi	a5,s1,-48
 110:	008784b3          	add	s1,a5,s0
 114:	ff04a503          	lw	a0,-16(s1)
 118:	00000097          	auipc	ra,0x0
 11c:	3f2080e7          	jalr	1010(ra) # 50a <close>
        wait(0);
 120:	4501                	li	a0,0
 122:	00000097          	auipc	ra,0x0
 126:	3c8080e7          	jalr	968(ra) # 4ea <wait>
        exit(0);
 12a:	4501                	li	a0,0
 12c:	00000097          	auipc	ra,0x0
 130:	3b6080e7          	jalr	950(ra) # 4e2 <exit>
            close(p[(dividend - 1) % mod][0]);
 134:	ff04a503          	lw	a0,-16(s1)
 138:	00000097          	auipc	ra,0x0
 13c:	3d2080e7          	jalr	978(ra) # 50a <close>
            exit(0);
 140:	4501                	li	a0,0
 142:	00000097          	auipc	ra,0x0
 146:	3a0080e7          	jalr	928(ra) # 4e2 <exit>
        }
        else {
          close(p[dividend % mod][0]);
 14a:	003a1913          	slli	s2,s4,0x3
 14e:	fd090793          	addi	a5,s2,-48
 152:	00878933          	add	s2,a5,s0
 156:	ff092503          	lw	a0,-16(s2)
 15a:	00000097          	auipc	ra,0x0
 15e:	3b0080e7          	jalr	944(ra) # 50a <close>
          write(p[dividend % mod][1], &num, 4);
 162:	4611                	li	a2,4
 164:	fbc40593          	addi	a1,s0,-68
 168:	ff492503          	lw	a0,-12(s2)
 16c:	00000097          	auipc	ra,0x0
 170:	396080e7          	jalr	918(ra) # 502 <write>
      }
    }

    while(1){
      int num;
      if (read(p[(dividend - 1) % mod][0], &num, 4) == 0){
 174:	00349913          	slli	s2,s1,0x3
 178:	fd090793          	addi	a5,s2,-48
 17c:	00878933          	add	s2,a5,s0
        close(p[(dividend - 1) % mod][0]);
        wait(0);
        exit(0);
      }
      if(num % prime != 0){
        write(p[dividend % mod][1], &num, 4);
 180:	003a1993          	slli	s3,s4,0x3
 184:	fd098793          	addi	a5,s3,-48
 188:	008789b3          	add	s3,a5,s0
      if (read(p[(dividend - 1) % mod][0], &num, 4) == 0){
 18c:	4611                	li	a2,4
 18e:	fbc40593          	addi	a1,s0,-68
 192:	ff092503          	lw	a0,-16(s2)
 196:	00000097          	auipc	ra,0x0
 19a:	364080e7          	jalr	868(ra) # 4fa <read>
 19e:	c115                	beqz	a0,1c2 <main+0x1c2>
      if(num % prime != 0){
 1a0:	fbc42783          	lw	a5,-68(s0)
 1a4:	fb842703          	lw	a4,-72(s0)
 1a8:	02e7e7bb          	remw	a5,a5,a4
 1ac:	d3e5                	beqz	a5,18c <main+0x18c>
        write(p[dividend % mod][1], &num, 4);
 1ae:	4611                	li	a2,4
 1b0:	fbc40593          	addi	a1,s0,-68
 1b4:	ff49a503          	lw	a0,-12(s3)
 1b8:	00000097          	auipc	ra,0x0
 1bc:	34a080e7          	jalr	842(ra) # 502 <write>
    while(1){
 1c0:	b7f1                	j	18c <main+0x18c>
        close(p[dividend % mod][1]);
 1c2:	003a1793          	slli	a5,s4,0x3
 1c6:	fd078793          	addi	a5,a5,-48
 1ca:	97a2                	add	a5,a5,s0
 1cc:	ff47a503          	lw	a0,-12(a5)
 1d0:	00000097          	auipc	ra,0x0
 1d4:	33a080e7          	jalr	826(ra) # 50a <close>
        close(p[(dividend - 1) % mod][0]);
 1d8:	00349793          	slli	a5,s1,0x3
 1dc:	fd078793          	addi	a5,a5,-48
 1e0:	97a2                	add	a5,a5,s0
 1e2:	ff07a503          	lw	a0,-16(a5)
 1e6:	00000097          	auipc	ra,0x0
 1ea:	324080e7          	jalr	804(ra) # 50a <close>
        wait(0);
 1ee:	4501                	li	a0,0
 1f0:	00000097          	auipc	ra,0x0
 1f4:	2fa080e7          	jalr	762(ra) # 4ea <wait>
        exit(0);
 1f8:	4501                	li	a0,0
 1fa:	00000097          	auipc	ra,0x0
 1fe:	2e8080e7          	jalr	744(ra) # 4e2 <exit>



  }
  else {
    close(p[dividend % mod][0]);
 202:	fc042503          	lw	a0,-64(s0)
 206:	00000097          	auipc	ra,0x0
 20a:	304080e7          	jalr	772(ra) # 50a <close>
    int i;
    for(i = 2; i <= 35; ++i){
 20e:	4789                	li	a5,2
 210:	faf42e23          	sw	a5,-68(s0)
 214:	02300493          	li	s1,35
      write(p[dividend % mod][1], &i, 4);
 218:	4611                	li	a2,4
 21a:	fbc40593          	addi	a1,s0,-68
 21e:	fc442503          	lw	a0,-60(s0)
 222:	00000097          	auipc	ra,0x0
 226:	2e0080e7          	jalr	736(ra) # 502 <write>
    for(i = 2; i <= 35; ++i){
 22a:	fbc42783          	lw	a5,-68(s0)
 22e:	2785                	addiw	a5,a5,1
 230:	0007871b          	sext.w	a4,a5
 234:	faf42e23          	sw	a5,-68(s0)
 238:	fee4d0e3          	bge	s1,a4,218 <main+0x218>
    }
    close(p[dividend % mod][1]);
 23c:	fc442503          	lw	a0,-60(s0)
 240:	00000097          	auipc	ra,0x0
 244:	2ca080e7          	jalr	714(ra) # 50a <close>
    wait(0);
 248:	4501                	li	a0,0
 24a:	00000097          	auipc	ra,0x0
 24e:	2a0080e7          	jalr	672(ra) # 4ea <wait>
  }
  exit(0);
 252:	4501                	li	a0,0
 254:	00000097          	auipc	ra,0x0
 258:	28e080e7          	jalr	654(ra) # 4e2 <exit>

000000000000025c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 25c:	1141                	addi	sp,sp,-16
 25e:	e406                	sd	ra,8(sp)
 260:	e022                	sd	s0,0(sp)
 262:	0800                	addi	s0,sp,16
  extern int main();
  main();
 264:	00000097          	auipc	ra,0x0
 268:	d9c080e7          	jalr	-612(ra) # 0 <main>
  exit(0);
 26c:	4501                	li	a0,0
 26e:	00000097          	auipc	ra,0x0
 272:	274080e7          	jalr	628(ra) # 4e2 <exit>

0000000000000276 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 276:	1141                	addi	sp,sp,-16
 278:	e422                	sd	s0,8(sp)
 27a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 27c:	87aa                	mv	a5,a0
 27e:	0585                	addi	a1,a1,1
 280:	0785                	addi	a5,a5,1
 282:	fff5c703          	lbu	a4,-1(a1)
 286:	fee78fa3          	sb	a4,-1(a5)
 28a:	fb75                	bnez	a4,27e <strcpy+0x8>
    ;
  return os;
}
 28c:	6422                	ld	s0,8(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 292:	1141                	addi	sp,sp,-16
 294:	e422                	sd	s0,8(sp)
 296:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 298:	00054783          	lbu	a5,0(a0)
 29c:	cb91                	beqz	a5,2b0 <strcmp+0x1e>
 29e:	0005c703          	lbu	a4,0(a1)
 2a2:	00f71763          	bne	a4,a5,2b0 <strcmp+0x1e>
    p++, q++;
 2a6:	0505                	addi	a0,a0,1
 2a8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2aa:	00054783          	lbu	a5,0(a0)
 2ae:	fbe5                	bnez	a5,29e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b0:	0005c503          	lbu	a0,0(a1)
}
 2b4:	40a7853b          	subw	a0,a5,a0
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <strlen>:

uint
strlen(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c4:	00054783          	lbu	a5,0(a0)
 2c8:	cf91                	beqz	a5,2e4 <strlen+0x26>
 2ca:	0505                	addi	a0,a0,1
 2cc:	87aa                	mv	a5,a0
 2ce:	86be                	mv	a3,a5
 2d0:	0785                	addi	a5,a5,1
 2d2:	fff7c703          	lbu	a4,-1(a5)
 2d6:	ff65                	bnez	a4,2ce <strlen+0x10>
 2d8:	40a6853b          	subw	a0,a3,a0
 2dc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
  for(n = 0; s[n]; n++)
 2e4:	4501                	li	a0,0
 2e6:	bfe5                	j	2de <strlen+0x20>

00000000000002e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e422                	sd	s0,8(sp)
 2ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2ee:	ca19                	beqz	a2,304 <memset+0x1c>
 2f0:	87aa                	mv	a5,a0
 2f2:	1602                	slli	a2,a2,0x20
 2f4:	9201                	srli	a2,a2,0x20
 2f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2fe:	0785                	addi	a5,a5,1
 300:	fee79de3          	bne	a5,a4,2fa <memset+0x12>
  }
  return dst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char*
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e422                	sd	s0,8(sp)
 30e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 310:	00054783          	lbu	a5,0(a0)
 314:	cb99                	beqz	a5,32a <strchr+0x20>
    if(*s == c)
 316:	00f58763          	beq	a1,a5,324 <strchr+0x1a>
  for(; *s; s++)
 31a:	0505                	addi	a0,a0,1
 31c:	00054783          	lbu	a5,0(a0)
 320:	fbfd                	bnez	a5,316 <strchr+0xc>
      return (char*)s;
  return 0;
 322:	4501                	li	a0,0
}
 324:	6422                	ld	s0,8(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret
  return 0;
 32a:	4501                	li	a0,0
 32c:	bfe5                	j	324 <strchr+0x1a>

000000000000032e <gets>:

char*
gets(char *buf, int max)
{
 32e:	711d                	addi	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	1080                	addi	s0,sp,96
 344:	8baa                	mv	s7,a0
 346:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 348:	892a                	mv	s2,a0
 34a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 34c:	4aa9                	li	s5,10
 34e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 350:	89a6                	mv	s3,s1
 352:	2485                	addiw	s1,s1,1
 354:	0344d863          	bge	s1,s4,384 <gets+0x56>
    cc = read(0, &c, 1);
 358:	4605                	li	a2,1
 35a:	faf40593          	addi	a1,s0,-81
 35e:	4501                	li	a0,0
 360:	00000097          	auipc	ra,0x0
 364:	19a080e7          	jalr	410(ra) # 4fa <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x56>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x54>
 378:	0905                	addi	s2,s2,1
 37a:	fd679be3          	bne	a5,s6,350 <gets+0x22>
  for(i=0; i+1 < max; ){
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x56>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e426                	sd	s1,8(sp)
 3aa:	e04a                	sd	s2,0(sp)
 3ac:	1000                	addi	s0,sp,32
 3ae:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b0:	4581                	li	a1,0
 3b2:	00000097          	auipc	ra,0x0
 3b6:	170080e7          	jalr	368(ra) # 522 <open>
  if(fd < 0)
 3ba:	02054563          	bltz	a0,3e4 <stat+0x42>
 3be:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c0:	85ca                	mv	a1,s2
 3c2:	00000097          	auipc	ra,0x0
 3c6:	178080e7          	jalr	376(ra) # 53a <fstat>
 3ca:	892a                	mv	s2,a0
  close(fd);
 3cc:	8526                	mv	a0,s1
 3ce:	00000097          	auipc	ra,0x0
 3d2:	13c080e7          	jalr	316(ra) # 50a <close>
  return r;
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	64a2                	ld	s1,8(sp)
 3de:	6902                	ld	s2,0(sp)
 3e0:	6105                	addi	sp,sp,32
 3e2:	8082                	ret
    return -1;
 3e4:	597d                	li	s2,-1
 3e6:	bfc5                	j	3d6 <stat+0x34>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e422                	sd	s0,8(sp)
 3ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ee:	00054683          	lbu	a3,0(a0)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	4625                	li	a2,9
 3fc:	02f66863          	bltu	a2,a5,42c <atoi+0x44>
 400:	872a                	mv	a4,a0
  n = 0;
 402:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 404:	0705                	addi	a4,a4,1
 406:	0025179b          	slliw	a5,a0,0x2
 40a:	9fa9                	addw	a5,a5,a0
 40c:	0017979b          	slliw	a5,a5,0x1
 410:	9fb5                	addw	a5,a5,a3
 412:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 416:	00074683          	lbu	a3,0(a4)
 41a:	fd06879b          	addiw	a5,a3,-48
 41e:	0ff7f793          	zext.b	a5,a5
 422:	fef671e3          	bgeu	a2,a5,404 <atoi+0x1c>
  return n;
}
 426:	6422                	ld	s0,8(sp)
 428:	0141                	addi	sp,sp,16
 42a:	8082                	ret
  n = 0;
 42c:	4501                	li	a0,0
 42e:	bfe5                	j	426 <atoi+0x3e>

0000000000000430 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 430:	1141                	addi	sp,sp,-16
 432:	e422                	sd	s0,8(sp)
 434:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 436:	02b57463          	bgeu	a0,a1,45e <memmove+0x2e>
    while(n-- > 0)
 43a:	00c05f63          	blez	a2,458 <memmove+0x28>
 43e:	1602                	slli	a2,a2,0x20
 440:	9201                	srli	a2,a2,0x20
 442:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 446:	872a                	mv	a4,a0
      *dst++ = *src++;
 448:	0585                	addi	a1,a1,1
 44a:	0705                	addi	a4,a4,1
 44c:	fff5c683          	lbu	a3,-1(a1)
 450:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 454:	fee79ae3          	bne	a5,a4,448 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret
    dst += n;
 45e:	00c50733          	add	a4,a0,a2
    src += n;
 462:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 464:	fec05ae3          	blez	a2,458 <memmove+0x28>
 468:	fff6079b          	addiw	a5,a2,-1
 46c:	1782                	slli	a5,a5,0x20
 46e:	9381                	srli	a5,a5,0x20
 470:	fff7c793          	not	a5,a5
 474:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 476:	15fd                	addi	a1,a1,-1
 478:	177d                	addi	a4,a4,-1
 47a:	0005c683          	lbu	a3,0(a1)
 47e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 482:	fee79ae3          	bne	a5,a4,476 <memmove+0x46>
 486:	bfc9                	j	458 <memmove+0x28>

0000000000000488 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 488:	1141                	addi	sp,sp,-16
 48a:	e422                	sd	s0,8(sp)
 48c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 48e:	ca05                	beqz	a2,4be <memcmp+0x36>
 490:	fff6069b          	addiw	a3,a2,-1
 494:	1682                	slli	a3,a3,0x20
 496:	9281                	srli	a3,a3,0x20
 498:	0685                	addi	a3,a3,1
 49a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 49c:	00054783          	lbu	a5,0(a0)
 4a0:	0005c703          	lbu	a4,0(a1)
 4a4:	00e79863          	bne	a5,a4,4b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 4a8:	0505                	addi	a0,a0,1
    p2++;
 4aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4ac:	fed518e3          	bne	a0,a3,49c <memcmp+0x14>
  }
  return 0;
 4b0:	4501                	li	a0,0
 4b2:	a019                	j	4b8 <memcmp+0x30>
      return *p1 - *p2;
 4b4:	40e7853b          	subw	a0,a5,a4
}
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	addi	sp,sp,16
 4bc:	8082                	ret
  return 0;
 4be:	4501                	li	a0,0
 4c0:	bfe5                	j	4b8 <memcmp+0x30>

00000000000004c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c2:	1141                	addi	sp,sp,-16
 4c4:	e406                	sd	ra,8(sp)
 4c6:	e022                	sd	s0,0(sp)
 4c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ca:	00000097          	auipc	ra,0x0
 4ce:	f66080e7          	jalr	-154(ra) # 430 <memmove>
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4da:	4885                	li	a7,1
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4e2:	4889                	li	a7,2
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 4ea:	488d                	li	a7,3
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4f2:	4891                	li	a7,4
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <read>:
.global read
read:
 li a7, SYS_read
 4fa:	4895                	li	a7,5
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <write>:
.global write
write:
 li a7, SYS_write
 502:	48c1                	li	a7,16
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <close>:
.global close
close:
 li a7, SYS_close
 50a:	48d5                	li	a7,21
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <kill>:
.global kill
kill:
 li a7, SYS_kill
 512:	4899                	li	a7,6
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <exec>:
.global exec
exec:
 li a7, SYS_exec
 51a:	489d                	li	a7,7
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <open>:
.global open
open:
 li a7, SYS_open
 522:	48bd                	li	a7,15
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 52a:	48c5                	li	a7,17
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 532:	48c9                	li	a7,18
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 53a:	48a1                	li	a7,8
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <link>:
.global link
link:
 li a7, SYS_link
 542:	48cd                	li	a7,19
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 54a:	48d1                	li	a7,20
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 552:	48a5                	li	a7,9
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <dup>:
.global dup
dup:
 li a7, SYS_dup
 55a:	48a9                	li	a7,10
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 562:	48ad                	li	a7,11
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 56a:	48b1                	li	a7,12
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 572:	48b5                	li	a7,13
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 57a:	48b9                	li	a7,14
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <trace>:
.global trace
trace:
 li a7, SYS_trace
 582:	48d9                	li	a7,22
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 58a:	48dd                	li	a7,23
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 592:	1101                	addi	sp,sp,-32
 594:	ec06                	sd	ra,24(sp)
 596:	e822                	sd	s0,16(sp)
 598:	1000                	addi	s0,sp,32
 59a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 59e:	4605                	li	a2,1
 5a0:	fef40593          	addi	a1,s0,-17
 5a4:	00000097          	auipc	ra,0x0
 5a8:	f5e080e7          	jalr	-162(ra) # 502 <write>
}
 5ac:	60e2                	ld	ra,24(sp)
 5ae:	6442                	ld	s0,16(sp)
 5b0:	6105                	addi	sp,sp,32
 5b2:	8082                	ret

00000000000005b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5b4:	7139                	addi	sp,sp,-64
 5b6:	fc06                	sd	ra,56(sp)
 5b8:	f822                	sd	s0,48(sp)
 5ba:	f426                	sd	s1,40(sp)
 5bc:	f04a                	sd	s2,32(sp)
 5be:	ec4e                	sd	s3,24(sp)
 5c0:	0080                	addi	s0,sp,64
 5c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c4:	c299                	beqz	a3,5ca <printint+0x16>
 5c6:	0805c963          	bltz	a1,658 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ca:	2581                	sext.w	a1,a1
  neg = 0;
 5cc:	4881                	li	a7,0
 5ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5d4:	2601                	sext.w	a2,a2
 5d6:	00000517          	auipc	a0,0x0
 5da:	49a50513          	addi	a0,a0,1178 # a70 <digits>
 5de:	883a                	mv	a6,a4
 5e0:	2705                	addiw	a4,a4,1
 5e2:	02c5f7bb          	remuw	a5,a1,a2
 5e6:	1782                	slli	a5,a5,0x20
 5e8:	9381                	srli	a5,a5,0x20
 5ea:	97aa                	add	a5,a5,a0
 5ec:	0007c783          	lbu	a5,0(a5)
 5f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5f4:	0005879b          	sext.w	a5,a1
 5f8:	02c5d5bb          	divuw	a1,a1,a2
 5fc:	0685                	addi	a3,a3,1
 5fe:	fec7f0e3          	bgeu	a5,a2,5de <printint+0x2a>
  if(neg)
 602:	00088c63          	beqz	a7,61a <printint+0x66>
    buf[i++] = '-';
 606:	fd070793          	addi	a5,a4,-48
 60a:	00878733          	add	a4,a5,s0
 60e:	02d00793          	li	a5,45
 612:	fef70823          	sb	a5,-16(a4)
 616:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 61a:	02e05863          	blez	a4,64a <printint+0x96>
 61e:	fc040793          	addi	a5,s0,-64
 622:	00e78933          	add	s2,a5,a4
 626:	fff78993          	addi	s3,a5,-1
 62a:	99ba                	add	s3,s3,a4
 62c:	377d                	addiw	a4,a4,-1
 62e:	1702                	slli	a4,a4,0x20
 630:	9301                	srli	a4,a4,0x20
 632:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 636:	fff94583          	lbu	a1,-1(s2)
 63a:	8526                	mv	a0,s1
 63c:	00000097          	auipc	ra,0x0
 640:	f56080e7          	jalr	-170(ra) # 592 <putc>
  while(--i >= 0)
 644:	197d                	addi	s2,s2,-1
 646:	ff3918e3          	bne	s2,s3,636 <printint+0x82>
}
 64a:	70e2                	ld	ra,56(sp)
 64c:	7442                	ld	s0,48(sp)
 64e:	74a2                	ld	s1,40(sp)
 650:	7902                	ld	s2,32(sp)
 652:	69e2                	ld	s3,24(sp)
 654:	6121                	addi	sp,sp,64
 656:	8082                	ret
    x = -xx;
 658:	40b005bb          	negw	a1,a1
    neg = 1;
 65c:	4885                	li	a7,1
    x = -xx;
 65e:	bf85                	j	5ce <printint+0x1a>

0000000000000660 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 660:	715d                	addi	sp,sp,-80
 662:	e486                	sd	ra,72(sp)
 664:	e0a2                	sd	s0,64(sp)
 666:	fc26                	sd	s1,56(sp)
 668:	f84a                	sd	s2,48(sp)
 66a:	f44e                	sd	s3,40(sp)
 66c:	f052                	sd	s4,32(sp)
 66e:	ec56                	sd	s5,24(sp)
 670:	e85a                	sd	s6,16(sp)
 672:	e45e                	sd	s7,8(sp)
 674:	e062                	sd	s8,0(sp)
 676:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 678:	0005c903          	lbu	s2,0(a1)
 67c:	18090c63          	beqz	s2,814 <vprintf+0x1b4>
 680:	8aaa                	mv	s5,a0
 682:	8bb2                	mv	s7,a2
 684:	00158493          	addi	s1,a1,1
  state = 0;
 688:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 68a:	02500a13          	li	s4,37
 68e:	4b55                	li	s6,21
 690:	a839                	j	6ae <vprintf+0x4e>
        putc(fd, c);
 692:	85ca                	mv	a1,s2
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	efc080e7          	jalr	-260(ra) # 592 <putc>
 69e:	a019                	j	6a4 <vprintf+0x44>
    } else if(state == '%'){
 6a0:	01498d63          	beq	s3,s4,6ba <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 6a4:	0485                	addi	s1,s1,1
 6a6:	fff4c903          	lbu	s2,-1(s1)
 6aa:	16090563          	beqz	s2,814 <vprintf+0x1b4>
    if(state == 0){
 6ae:	fe0999e3          	bnez	s3,6a0 <vprintf+0x40>
      if(c == '%'){
 6b2:	ff4910e3          	bne	s2,s4,692 <vprintf+0x32>
        state = '%';
 6b6:	89d2                	mv	s3,s4
 6b8:	b7f5                	j	6a4 <vprintf+0x44>
      if(c == 'd'){
 6ba:	13490263          	beq	s2,s4,7de <vprintf+0x17e>
 6be:	f9d9079b          	addiw	a5,s2,-99
 6c2:	0ff7f793          	zext.b	a5,a5
 6c6:	12fb6563          	bltu	s6,a5,7f0 <vprintf+0x190>
 6ca:	f9d9079b          	addiw	a5,s2,-99
 6ce:	0ff7f713          	zext.b	a4,a5
 6d2:	10eb6f63          	bltu	s6,a4,7f0 <vprintf+0x190>
 6d6:	00271793          	slli	a5,a4,0x2
 6da:	00000717          	auipc	a4,0x0
 6de:	33e70713          	addi	a4,a4,830 # a18 <malloc+0x106>
 6e2:	97ba                	add	a5,a5,a4
 6e4:	439c                	lw	a5,0(a5)
 6e6:	97ba                	add	a5,a5,a4
 6e8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	8556                	mv	a0,s5
 6f8:	00000097          	auipc	ra,0x0
 6fc:	ebc080e7          	jalr	-324(ra) # 5b4 <printint>
 700:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 702:	4981                	li	s3,0
 704:	b745                	j	6a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b8913          	addi	s2,s7,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000ba583          	lw	a1,0(s7)
 712:	8556                	mv	a0,s5
 714:	00000097          	auipc	ra,0x0
 718:	ea0080e7          	jalr	-352(ra) # 5b4 <printint>
 71c:	8bca                	mv	s7,s2
      state = 0;
 71e:	4981                	li	s3,0
 720:	b751                	j	6a4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 722:	008b8913          	addi	s2,s7,8
 726:	4681                	li	a3,0
 728:	4641                	li	a2,16
 72a:	000ba583          	lw	a1,0(s7)
 72e:	8556                	mv	a0,s5
 730:	00000097          	auipc	ra,0x0
 734:	e84080e7          	jalr	-380(ra) # 5b4 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b7a5                	j	6a4 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 73e:	008b8c13          	addi	s8,s7,8
 742:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 746:	03000593          	li	a1,48
 74a:	8556                	mv	a0,s5
 74c:	00000097          	auipc	ra,0x0
 750:	e46080e7          	jalr	-442(ra) # 592 <putc>
  putc(fd, 'x');
 754:	07800593          	li	a1,120
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	e38080e7          	jalr	-456(ra) # 592 <putc>
 762:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 764:	00000b97          	auipc	s7,0x0
 768:	30cb8b93          	addi	s7,s7,780 # a70 <digits>
 76c:	03c9d793          	srli	a5,s3,0x3c
 770:	97de                	add	a5,a5,s7
 772:	0007c583          	lbu	a1,0(a5)
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	e1a080e7          	jalr	-486(ra) # 592 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 780:	0992                	slli	s3,s3,0x4
 782:	397d                	addiw	s2,s2,-1
 784:	fe0914e3          	bnez	s2,76c <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 788:	8be2                	mv	s7,s8
      state = 0;
 78a:	4981                	li	s3,0
 78c:	bf21                	j	6a4 <vprintf+0x44>
        s = va_arg(ap, char*);
 78e:	008b8993          	addi	s3,s7,8
 792:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 796:	02090163          	beqz	s2,7b8 <vprintf+0x158>
        while(*s != 0){
 79a:	00094583          	lbu	a1,0(s2)
 79e:	c9a5                	beqz	a1,80e <vprintf+0x1ae>
          putc(fd, *s);
 7a0:	8556                	mv	a0,s5
 7a2:	00000097          	auipc	ra,0x0
 7a6:	df0080e7          	jalr	-528(ra) # 592 <putc>
          s++;
 7aa:	0905                	addi	s2,s2,1
        while(*s != 0){
 7ac:	00094583          	lbu	a1,0(s2)
 7b0:	f9e5                	bnez	a1,7a0 <vprintf+0x140>
        s = va_arg(ap, char*);
 7b2:	8bce                	mv	s7,s3
      state = 0;
 7b4:	4981                	li	s3,0
 7b6:	b5fd                	j	6a4 <vprintf+0x44>
          s = "(null)";
 7b8:	00000917          	auipc	s2,0x0
 7bc:	25890913          	addi	s2,s2,600 # a10 <malloc+0xfe>
        while(*s != 0){
 7c0:	02800593          	li	a1,40
 7c4:	bff1                	j	7a0 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	000bc583          	lbu	a1,0(s7)
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	dc2080e7          	jalr	-574(ra) # 592 <putc>
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b5e1                	j	6a4 <vprintf+0x44>
        putc(fd, c);
 7de:	02500593          	li	a1,37
 7e2:	8556                	mv	a0,s5
 7e4:	00000097          	auipc	ra,0x0
 7e8:	dae080e7          	jalr	-594(ra) # 592 <putc>
      state = 0;
 7ec:	4981                	li	s3,0
 7ee:	bd5d                	j	6a4 <vprintf+0x44>
        putc(fd, '%');
 7f0:	02500593          	li	a1,37
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	d9c080e7          	jalr	-612(ra) # 592 <putc>
        putc(fd, c);
 7fe:	85ca                	mv	a1,s2
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	d90080e7          	jalr	-624(ra) # 592 <putc>
      state = 0;
 80a:	4981                	li	s3,0
 80c:	bd61                	j	6a4 <vprintf+0x44>
        s = va_arg(ap, char*);
 80e:	8bce                	mv	s7,s3
      state = 0;
 810:	4981                	li	s3,0
 812:	bd49                	j	6a4 <vprintf+0x44>
    }
  }
}
 814:	60a6                	ld	ra,72(sp)
 816:	6406                	ld	s0,64(sp)
 818:	74e2                	ld	s1,56(sp)
 81a:	7942                	ld	s2,48(sp)
 81c:	79a2                	ld	s3,40(sp)
 81e:	7a02                	ld	s4,32(sp)
 820:	6ae2                	ld	s5,24(sp)
 822:	6b42                	ld	s6,16(sp)
 824:	6ba2                	ld	s7,8(sp)
 826:	6c02                	ld	s8,0(sp)
 828:	6161                	addi	sp,sp,80
 82a:	8082                	ret

000000000000082c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 82c:	715d                	addi	sp,sp,-80
 82e:	ec06                	sd	ra,24(sp)
 830:	e822                	sd	s0,16(sp)
 832:	1000                	addi	s0,sp,32
 834:	e010                	sd	a2,0(s0)
 836:	e414                	sd	a3,8(s0)
 838:	e818                	sd	a4,16(s0)
 83a:	ec1c                	sd	a5,24(s0)
 83c:	03043023          	sd	a6,32(s0)
 840:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 844:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 848:	8622                	mv	a2,s0
 84a:	00000097          	auipc	ra,0x0
 84e:	e16080e7          	jalr	-490(ra) # 660 <vprintf>
}
 852:	60e2                	ld	ra,24(sp)
 854:	6442                	ld	s0,16(sp)
 856:	6161                	addi	sp,sp,80
 858:	8082                	ret

000000000000085a <printf>:

void
printf(const char *fmt, ...)
{
 85a:	711d                	addi	sp,sp,-96
 85c:	ec06                	sd	ra,24(sp)
 85e:	e822                	sd	s0,16(sp)
 860:	1000                	addi	s0,sp,32
 862:	e40c                	sd	a1,8(s0)
 864:	e810                	sd	a2,16(s0)
 866:	ec14                	sd	a3,24(s0)
 868:	f018                	sd	a4,32(s0)
 86a:	f41c                	sd	a5,40(s0)
 86c:	03043823          	sd	a6,48(s0)
 870:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 874:	00840613          	addi	a2,s0,8
 878:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 87c:	85aa                	mv	a1,a0
 87e:	4505                	li	a0,1
 880:	00000097          	auipc	ra,0x0
 884:	de0080e7          	jalr	-544(ra) # 660 <vprintf>
}
 888:	60e2                	ld	ra,24(sp)
 88a:	6442                	ld	s0,16(sp)
 88c:	6125                	addi	sp,sp,96
 88e:	8082                	ret

0000000000000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	1141                	addi	sp,sp,-16
 892:	e422                	sd	s0,8(sp)
 894:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 896:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89a:	00000797          	auipc	a5,0x0
 89e:	7667b783          	ld	a5,1894(a5) # 1000 <freep>
 8a2:	a02d                	j	8cc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8a4:	4618                	lw	a4,8(a2)
 8a6:	9f2d                	addw	a4,a4,a1
 8a8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	6310                	ld	a2,0(a4)
 8b0:	a83d                	j	8ee <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8b2:	ff852703          	lw	a4,-8(a0)
 8b6:	9f31                	addw	a4,a4,a2
 8b8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ba:	ff053683          	ld	a3,-16(a0)
 8be:	a091                	j	902 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	6398                	ld	a4,0(a5)
 8c2:	00e7e463          	bltu	a5,a4,8ca <free+0x3a>
 8c6:	00e6ea63          	bltu	a3,a4,8da <free+0x4a>
{
 8ca:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	fed7fae3          	bgeu	a5,a3,8c0 <free+0x30>
 8d0:	6398                	ld	a4,0(a5)
 8d2:	00e6e463          	bltu	a3,a4,8da <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d6:	fee7eae3          	bltu	a5,a4,8ca <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 8da:	ff852583          	lw	a1,-8(a0)
 8de:	6390                	ld	a2,0(a5)
 8e0:	02059813          	slli	a6,a1,0x20
 8e4:	01c85713          	srli	a4,a6,0x1c
 8e8:	9736                	add	a4,a4,a3
 8ea:	fae60de3          	beq	a2,a4,8a4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 8ee:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8f2:	4790                	lw	a2,8(a5)
 8f4:	02061593          	slli	a1,a2,0x20
 8f8:	01c5d713          	srli	a4,a1,0x1c
 8fc:	973e                	add	a4,a4,a5
 8fe:	fae68ae3          	beq	a3,a4,8b2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 902:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 904:	00000717          	auipc	a4,0x0
 908:	6ef73e23          	sd	a5,1788(a4) # 1000 <freep>
}
 90c:	6422                	ld	s0,8(sp)
 90e:	0141                	addi	sp,sp,16
 910:	8082                	ret

0000000000000912 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 912:	7139                	addi	sp,sp,-64
 914:	fc06                	sd	ra,56(sp)
 916:	f822                	sd	s0,48(sp)
 918:	f426                	sd	s1,40(sp)
 91a:	f04a                	sd	s2,32(sp)
 91c:	ec4e                	sd	s3,24(sp)
 91e:	e852                	sd	s4,16(sp)
 920:	e456                	sd	s5,8(sp)
 922:	e05a                	sd	s6,0(sp)
 924:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 926:	02051493          	slli	s1,a0,0x20
 92a:	9081                	srli	s1,s1,0x20
 92c:	04bd                	addi	s1,s1,15
 92e:	8091                	srli	s1,s1,0x4
 930:	0014899b          	addiw	s3,s1,1
 934:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 936:	00000517          	auipc	a0,0x0
 93a:	6ca53503          	ld	a0,1738(a0) # 1000 <freep>
 93e:	c515                	beqz	a0,96a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 940:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 942:	4798                	lw	a4,8(a5)
 944:	02977f63          	bgeu	a4,s1,982 <malloc+0x70>
  if(nu < 4096)
 948:	8a4e                	mv	s4,s3
 94a:	0009871b          	sext.w	a4,s3
 94e:	6685                	lui	a3,0x1
 950:	00d77363          	bgeu	a4,a3,956 <malloc+0x44>
 954:	6a05                	lui	s4,0x1
 956:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 95a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 95e:	00000917          	auipc	s2,0x0
 962:	6a290913          	addi	s2,s2,1698 # 1000 <freep>
  if(p == (char*)-1)
 966:	5afd                	li	s5,-1
 968:	a895                	j	9dc <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 96a:	00000797          	auipc	a5,0x0
 96e:	6a678793          	addi	a5,a5,1702 # 1010 <base>
 972:	00000717          	auipc	a4,0x0
 976:	68f73723          	sd	a5,1678(a4) # 1000 <freep>
 97a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 97c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 980:	b7e1                	j	948 <malloc+0x36>
      if(p->s.size == nunits)
 982:	02e48c63          	beq	s1,a4,9ba <malloc+0xa8>
        p->s.size -= nunits;
 986:	4137073b          	subw	a4,a4,s3
 98a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98c:	02071693          	slli	a3,a4,0x20
 990:	01c6d713          	srli	a4,a3,0x1c
 994:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 996:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99a:	00000717          	auipc	a4,0x0
 99e:	66a73323          	sd	a0,1638(a4) # 1000 <freep>
      return (void*)(p + 1);
 9a2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 9a6:	70e2                	ld	ra,56(sp)
 9a8:	7442                	ld	s0,48(sp)
 9aa:	74a2                	ld	s1,40(sp)
 9ac:	7902                	ld	s2,32(sp)
 9ae:	69e2                	ld	s3,24(sp)
 9b0:	6a42                	ld	s4,16(sp)
 9b2:	6aa2                	ld	s5,8(sp)
 9b4:	6b02                	ld	s6,0(sp)
 9b6:	6121                	addi	sp,sp,64
 9b8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9ba:	6398                	ld	a4,0(a5)
 9bc:	e118                	sd	a4,0(a0)
 9be:	bff1                	j	99a <malloc+0x88>
  hp->s.size = nu;
 9c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c4:	0541                	addi	a0,a0,16
 9c6:	00000097          	auipc	ra,0x0
 9ca:	eca080e7          	jalr	-310(ra) # 890 <free>
  return freep;
 9ce:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d2:	d971                	beqz	a0,9a6 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	fa9775e3          	bgeu	a4,s1,982 <malloc+0x70>
    if(p == freep)
 9dc:	00093703          	ld	a4,0(s2)
 9e0:	853e                	mv	a0,a5
 9e2:	fef719e3          	bne	a4,a5,9d4 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 9e6:	8552                	mv	a0,s4
 9e8:	00000097          	auipc	ra,0x0
 9ec:	b82080e7          	jalr	-1150(ra) # 56a <sbrk>
  if(p == (char*)-1)
 9f0:	fd5518e3          	bne	a0,s5,9c0 <malloc+0xae>
        return 0;
 9f4:	4501                	li	a0,0
 9f6:	bf45                	j	9a6 <malloc+0x94>
