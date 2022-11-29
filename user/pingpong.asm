
user/_pingpong:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user.h"

int main(){
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	0880                	addi	s0,sp,80
  int p1[2], p2[2];
  pipe(p1);
   8:	fe840513          	addi	a0,s0,-24
   c:	00000097          	auipc	ra,0x0
  10:	3a8080e7          	jalr	936(ra) # 3b4 <pipe>
  pipe(p2);
  14:	fe040513          	addi	a0,s0,-32
  18:	00000097          	auipc	ra,0x0
  1c:	39c080e7          	jalr	924(ra) # 3b4 <pipe>
  int buf[10];

  if(fork() == 0){
  20:	00000097          	auipc	ra,0x0
  24:	37c080e7          	jalr	892(ra) # 39c <fork>
  28:	e141                	bnez	a0,a8 <main+0xa8>
    close(p1[1]);
  2a:	fec42503          	lw	a0,-20(s0)
  2e:	00000097          	auipc	ra,0x0
  32:	39e080e7          	jalr	926(ra) # 3cc <close>
    close(p2[0]);
  36:	fe042503          	lw	a0,-32(s0)
  3a:	00000097          	auipc	ra,0x0
  3e:	392080e7          	jalr	914(ra) # 3cc <close>
    read(p1[0], buf, 1);
  42:	4605                	li	a2,1
  44:	fb840593          	addi	a1,s0,-72
  48:	fe842503          	lw	a0,-24(s0)
  4c:	00000097          	auipc	ra,0x0
  50:	370080e7          	jalr	880(ra) # 3bc <read>
    fprintf(1, "%d: received ping\n", getpid());
  54:	00000097          	auipc	ra,0x0
  58:	3d0080e7          	jalr	976(ra) # 424 <getpid>
  5c:	862a                	mv	a2,a0
  5e:	00001597          	auipc	a1,0x1
  62:	86258593          	addi	a1,a1,-1950 # 8c0 <malloc+0xec>
  66:	4505                	li	a0,1
  68:	00000097          	auipc	ra,0x0
  6c:	686080e7          	jalr	1670(ra) # 6ee <fprintf>
    write(p2[1], "a", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	86658593          	addi	a1,a1,-1946 # 8d8 <malloc+0x104>
  7a:	fe442503          	lw	a0,-28(s0)
  7e:	00000097          	auipc	ra,0x0
  82:	346080e7          	jalr	838(ra) # 3c4 <write>
    close(p1[0]);
  86:	fe842503          	lw	a0,-24(s0)
  8a:	00000097          	auipc	ra,0x0
  8e:	342080e7          	jalr	834(ra) # 3cc <close>
    close(p2[1]); 
  92:	fe442503          	lw	a0,-28(s0)
  96:	00000097          	auipc	ra,0x0
  9a:	336080e7          	jalr	822(ra) # 3cc <close>
    read(p2[0], buf, 1);
    fprintf(1, "%d: received pong\n", getpid());
    close(p1[1]);
    close(p2[0]);
  }
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	304080e7          	jalr	772(ra) # 3a4 <exit>
    close(p1[0]);
  a8:	fe842503          	lw	a0,-24(s0)
  ac:	00000097          	auipc	ra,0x0
  b0:	320080e7          	jalr	800(ra) # 3cc <close>
    close(p2[1]);
  b4:	fe442503          	lw	a0,-28(s0)
  b8:	00000097          	auipc	ra,0x0
  bc:	314080e7          	jalr	788(ra) # 3cc <close>
    write(p1[1], "a", 1);
  c0:	4605                	li	a2,1
  c2:	00001597          	auipc	a1,0x1
  c6:	81658593          	addi	a1,a1,-2026 # 8d8 <malloc+0x104>
  ca:	fec42503          	lw	a0,-20(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	2f6080e7          	jalr	758(ra) # 3c4 <write>
    read(p2[0], buf, 1);
  d6:	4605                	li	a2,1
  d8:	fb840593          	addi	a1,s0,-72
  dc:	fe042503          	lw	a0,-32(s0)
  e0:	00000097          	auipc	ra,0x0
  e4:	2dc080e7          	jalr	732(ra) # 3bc <read>
    fprintf(1, "%d: received pong\n", getpid());
  e8:	00000097          	auipc	ra,0x0
  ec:	33c080e7          	jalr	828(ra) # 424 <getpid>
  f0:	862a                	mv	a2,a0
  f2:	00000597          	auipc	a1,0x0
  f6:	7ee58593          	addi	a1,a1,2030 # 8e0 <malloc+0x10c>
  fa:	4505                	li	a0,1
  fc:	00000097          	auipc	ra,0x0
 100:	5f2080e7          	jalr	1522(ra) # 6ee <fprintf>
    close(p1[1]);
 104:	fec42503          	lw	a0,-20(s0)
 108:	00000097          	auipc	ra,0x0
 10c:	2c4080e7          	jalr	708(ra) # 3cc <close>
    close(p2[0]);
 110:	fe042503          	lw	a0,-32(s0)
 114:	00000097          	auipc	ra,0x0
 118:	2b8080e7          	jalr	696(ra) # 3cc <close>
 11c:	b749                	j	9e <main+0x9e>

000000000000011e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  extern int main();
  main();
 126:	00000097          	auipc	ra,0x0
 12a:	eda080e7          	jalr	-294(ra) # 0 <main>
  exit(0);
 12e:	4501                	li	a0,0
 130:	00000097          	auipc	ra,0x0
 134:	274080e7          	jalr	628(ra) # 3a4 <exit>

0000000000000138 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 138:	1141                	addi	sp,sp,-16
 13a:	e422                	sd	s0,8(sp)
 13c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 13e:	87aa                	mv	a5,a0
 140:	0585                	addi	a1,a1,1
 142:	0785                	addi	a5,a5,1
 144:	fff5c703          	lbu	a4,-1(a1)
 148:	fee78fa3          	sb	a4,-1(a5)
 14c:	fb75                	bnez	a4,140 <strcpy+0x8>
    ;
  return os;
}
 14e:	6422                	ld	s0,8(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret

0000000000000154 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	cb91                	beqz	a5,172 <strcmp+0x1e>
 160:	0005c703          	lbu	a4,0(a1)
 164:	00f71763          	bne	a4,a5,172 <strcmp+0x1e>
    p++, q++;
 168:	0505                	addi	a0,a0,1
 16a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 16c:	00054783          	lbu	a5,0(a0)
 170:	fbe5                	bnez	a5,160 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 172:	0005c503          	lbu	a0,0(a1)
}
 176:	40a7853b          	subw	a0,a5,a0
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	addi	sp,sp,16
 17e:	8082                	ret

0000000000000180 <strlen>:

uint
strlen(const char *s)
{
 180:	1141                	addi	sp,sp,-16
 182:	e422                	sd	s0,8(sp)
 184:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cf91                	beqz	a5,1a6 <strlen+0x26>
 18c:	0505                	addi	a0,a0,1
 18e:	87aa                	mv	a5,a0
 190:	86be                	mv	a3,a5
 192:	0785                	addi	a5,a5,1
 194:	fff7c703          	lbu	a4,-1(a5)
 198:	ff65                	bnez	a4,190 <strlen+0x10>
 19a:	40a6853b          	subw	a0,a3,a0
 19e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	addi	sp,sp,16
 1a4:	8082                	ret
  for(n = 0; s[n]; n++)
 1a6:	4501                	li	a0,0
 1a8:	bfe5                	j	1a0 <strlen+0x20>

00000000000001aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1b0:	ca19                	beqz	a2,1c6 <memset+0x1c>
 1b2:	87aa                	mv	a5,a0
 1b4:	1602                	slli	a2,a2,0x20
 1b6:	9201                	srli	a2,a2,0x20
 1b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1c0:	0785                	addi	a5,a5,1
 1c2:	fee79de3          	bne	a5,a4,1bc <memset+0x12>
  }
  return dst;
}
 1c6:	6422                	ld	s0,8(sp)
 1c8:	0141                	addi	sp,sp,16
 1ca:	8082                	ret

00000000000001cc <strchr>:

char*
strchr(const char *s, char c)
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e422                	sd	s0,8(sp)
 1d0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1d2:	00054783          	lbu	a5,0(a0)
 1d6:	cb99                	beqz	a5,1ec <strchr+0x20>
    if(*s == c)
 1d8:	00f58763          	beq	a1,a5,1e6 <strchr+0x1a>
  for(; *s; s++)
 1dc:	0505                	addi	a0,a0,1
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbfd                	bnez	a5,1d8 <strchr+0xc>
      return (char*)s;
  return 0;
 1e4:	4501                	li	a0,0
}
 1e6:	6422                	ld	s0,8(sp)
 1e8:	0141                	addi	sp,sp,16
 1ea:	8082                	ret
  return 0;
 1ec:	4501                	li	a0,0
 1ee:	bfe5                	j	1e6 <strchr+0x1a>

00000000000001f0 <gets>:

char*
gets(char *buf, int max)
{
 1f0:	711d                	addi	sp,sp,-96
 1f2:	ec86                	sd	ra,88(sp)
 1f4:	e8a2                	sd	s0,80(sp)
 1f6:	e4a6                	sd	s1,72(sp)
 1f8:	e0ca                	sd	s2,64(sp)
 1fa:	fc4e                	sd	s3,56(sp)
 1fc:	f852                	sd	s4,48(sp)
 1fe:	f456                	sd	s5,40(sp)
 200:	f05a                	sd	s6,32(sp)
 202:	ec5e                	sd	s7,24(sp)
 204:	1080                	addi	s0,sp,96
 206:	8baa                	mv	s7,a0
 208:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20a:	892a                	mv	s2,a0
 20c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 20e:	4aa9                	li	s5,10
 210:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 212:	89a6                	mv	s3,s1
 214:	2485                	addiw	s1,s1,1
 216:	0344d863          	bge	s1,s4,246 <gets+0x56>
    cc = read(0, &c, 1);
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	00000097          	auipc	ra,0x0
 226:	19a080e7          	jalr	410(ra) # 3bc <read>
    if(cc < 1)
 22a:	00a05e63          	blez	a0,246 <gets+0x56>
    buf[i++] = c;
 22e:	faf44783          	lbu	a5,-81(s0)
 232:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 236:	01578763          	beq	a5,s5,244 <gets+0x54>
 23a:	0905                	addi	s2,s2,1
 23c:	fd679be3          	bne	a5,s6,212 <gets+0x22>
  for(i=0; i+1 < max; ){
 240:	89a6                	mv	s3,s1
 242:	a011                	j	246 <gets+0x56>
 244:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 246:	99de                	add	s3,s3,s7
 248:	00098023          	sb	zero,0(s3)
  return buf;
}
 24c:	855e                	mv	a0,s7
 24e:	60e6                	ld	ra,88(sp)
 250:	6446                	ld	s0,80(sp)
 252:	64a6                	ld	s1,72(sp)
 254:	6906                	ld	s2,64(sp)
 256:	79e2                	ld	s3,56(sp)
 258:	7a42                	ld	s4,48(sp)
 25a:	7aa2                	ld	s5,40(sp)
 25c:	7b02                	ld	s6,32(sp)
 25e:	6be2                	ld	s7,24(sp)
 260:	6125                	addi	sp,sp,96
 262:	8082                	ret

0000000000000264 <stat>:

int
stat(const char *n, struct stat *st)
{
 264:	1101                	addi	sp,sp,-32
 266:	ec06                	sd	ra,24(sp)
 268:	e822                	sd	s0,16(sp)
 26a:	e426                	sd	s1,8(sp)
 26c:	e04a                	sd	s2,0(sp)
 26e:	1000                	addi	s0,sp,32
 270:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 272:	4581                	li	a1,0
 274:	00000097          	auipc	ra,0x0
 278:	170080e7          	jalr	368(ra) # 3e4 <open>
  if(fd < 0)
 27c:	02054563          	bltz	a0,2a6 <stat+0x42>
 280:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 282:	85ca                	mv	a1,s2
 284:	00000097          	auipc	ra,0x0
 288:	178080e7          	jalr	376(ra) # 3fc <fstat>
 28c:	892a                	mv	s2,a0
  close(fd);
 28e:	8526                	mv	a0,s1
 290:	00000097          	auipc	ra,0x0
 294:	13c080e7          	jalr	316(ra) # 3cc <close>
  return r;
}
 298:	854a                	mv	a0,s2
 29a:	60e2                	ld	ra,24(sp)
 29c:	6442                	ld	s0,16(sp)
 29e:	64a2                	ld	s1,8(sp)
 2a0:	6902                	ld	s2,0(sp)
 2a2:	6105                	addi	sp,sp,32
 2a4:	8082                	ret
    return -1;
 2a6:	597d                	li	s2,-1
 2a8:	bfc5                	j	298 <stat+0x34>

00000000000002aa <atoi>:

int
atoi(const char *s)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b0:	00054683          	lbu	a3,0(a0)
 2b4:	fd06879b          	addiw	a5,a3,-48
 2b8:	0ff7f793          	zext.b	a5,a5
 2bc:	4625                	li	a2,9
 2be:	02f66863          	bltu	a2,a5,2ee <atoi+0x44>
 2c2:	872a                	mv	a4,a0
  n = 0;
 2c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2c6:	0705                	addi	a4,a4,1
 2c8:	0025179b          	slliw	a5,a0,0x2
 2cc:	9fa9                	addw	a5,a5,a0
 2ce:	0017979b          	slliw	a5,a5,0x1
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2d8:	00074683          	lbu	a3,0(a4)
 2dc:	fd06879b          	addiw	a5,a3,-48
 2e0:	0ff7f793          	zext.b	a5,a5
 2e4:	fef671e3          	bgeu	a2,a5,2c6 <atoi+0x1c>
  return n;
}
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret
  n = 0;
 2ee:	4501                	li	a0,0
 2f0:	bfe5                	j	2e8 <atoi+0x3e>

00000000000002f2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2f8:	02b57463          	bgeu	a0,a1,320 <memmove+0x2e>
    while(n-- > 0)
 2fc:	00c05f63          	blez	a2,31a <memmove+0x28>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 308:	872a                	mv	a4,a0
      *dst++ = *src++;
 30a:	0585                	addi	a1,a1,1
 30c:	0705                	addi	a4,a4,1
 30e:	fff5c683          	lbu	a3,-1(a1)
 312:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 316:	fee79ae3          	bne	a5,a4,30a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret
    dst += n;
 320:	00c50733          	add	a4,a0,a2
    src += n;
 324:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 326:	fec05ae3          	blez	a2,31a <memmove+0x28>
 32a:	fff6079b          	addiw	a5,a2,-1
 32e:	1782                	slli	a5,a5,0x20
 330:	9381                	srli	a5,a5,0x20
 332:	fff7c793          	not	a5,a5
 336:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 338:	15fd                	addi	a1,a1,-1
 33a:	177d                	addi	a4,a4,-1
 33c:	0005c683          	lbu	a3,0(a1)
 340:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 344:	fee79ae3          	bne	a5,a4,338 <memmove+0x46>
 348:	bfc9                	j	31a <memmove+0x28>

000000000000034a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 350:	ca05                	beqz	a2,380 <memcmp+0x36>
 352:	fff6069b          	addiw	a3,a2,-1
 356:	1682                	slli	a3,a3,0x20
 358:	9281                	srli	a3,a3,0x20
 35a:	0685                	addi	a3,a3,1
 35c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 35e:	00054783          	lbu	a5,0(a0)
 362:	0005c703          	lbu	a4,0(a1)
 366:	00e79863          	bne	a5,a4,376 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 36a:	0505                	addi	a0,a0,1
    p2++;
 36c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 36e:	fed518e3          	bne	a0,a3,35e <memcmp+0x14>
  }
  return 0;
 372:	4501                	li	a0,0
 374:	a019                	j	37a <memcmp+0x30>
      return *p1 - *p2;
 376:	40e7853b          	subw	a0,a5,a4
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret
  return 0;
 380:	4501                	li	a0,0
 382:	bfe5                	j	37a <memcmp+0x30>

0000000000000384 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 38c:	00000097          	auipc	ra,0x0
 390:	f66080e7          	jalr	-154(ra) # 2f2 <memmove>
}
 394:	60a2                	ld	ra,8(sp)
 396:	6402                	ld	s0,0(sp)
 398:	0141                	addi	sp,sp,16
 39a:	8082                	ret

000000000000039c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 39c:	4885                	li	a7,1
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3a4:	4889                	li	a7,2
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ac:	488d                	li	a7,3
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3b4:	4891                	li	a7,4
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <read>:
.global read
read:
 li a7, SYS_read
 3bc:	4895                	li	a7,5
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <write>:
.global write
write:
 li a7, SYS_write
 3c4:	48c1                	li	a7,16
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <close>:
.global close
close:
 li a7, SYS_close
 3cc:	48d5                	li	a7,21
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3d4:	4899                	li	a7,6
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <exec>:
.global exec
exec:
 li a7, SYS_exec
 3dc:	489d                	li	a7,7
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <open>:
.global open
open:
 li a7, SYS_open
 3e4:	48bd                	li	a7,15
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ec:	48c5                	li	a7,17
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3f4:	48c9                	li	a7,18
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3fc:	48a1                	li	a7,8
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <link>:
.global link
link:
 li a7, SYS_link
 404:	48cd                	li	a7,19
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 40c:	48d1                	li	a7,20
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 414:	48a5                	li	a7,9
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <dup>:
.global dup
dup:
 li a7, SYS_dup
 41c:	48a9                	li	a7,10
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 424:	48ad                	li	a7,11
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 42c:	48b1                	li	a7,12
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 434:	48b5                	li	a7,13
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 43c:	48b9                	li	a7,14
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <trace>:
.global trace
trace:
 li a7, SYS_trace
 444:	48d9                	li	a7,22
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 44c:	48dd                	li	a7,23
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 454:	1101                	addi	sp,sp,-32
 456:	ec06                	sd	ra,24(sp)
 458:	e822                	sd	s0,16(sp)
 45a:	1000                	addi	s0,sp,32
 45c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 460:	4605                	li	a2,1
 462:	fef40593          	addi	a1,s0,-17
 466:	00000097          	auipc	ra,0x0
 46a:	f5e080e7          	jalr	-162(ra) # 3c4 <write>
}
 46e:	60e2                	ld	ra,24(sp)
 470:	6442                	ld	s0,16(sp)
 472:	6105                	addi	sp,sp,32
 474:	8082                	ret

0000000000000476 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 476:	7139                	addi	sp,sp,-64
 478:	fc06                	sd	ra,56(sp)
 47a:	f822                	sd	s0,48(sp)
 47c:	f426                	sd	s1,40(sp)
 47e:	f04a                	sd	s2,32(sp)
 480:	ec4e                	sd	s3,24(sp)
 482:	0080                	addi	s0,sp,64
 484:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	c299                	beqz	a3,48c <printint+0x16>
 488:	0805c963          	bltz	a1,51a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48c:	2581                	sext.w	a1,a1
  neg = 0;
 48e:	4881                	li	a7,0
 490:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 494:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 496:	2601                	sext.w	a2,a2
 498:	00000517          	auipc	a0,0x0
 49c:	4c050513          	addi	a0,a0,1216 # 958 <digits>
 4a0:	883a                	mv	a6,a4
 4a2:	2705                	addiw	a4,a4,1
 4a4:	02c5f7bb          	remuw	a5,a1,a2
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	97aa                	add	a5,a5,a0
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b6:	0005879b          	sext.w	a5,a1
 4ba:	02c5d5bb          	divuw	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec7f0e3          	bgeu	a5,a2,4a0 <printint+0x2a>
  if(neg)
 4c4:	00088c63          	beqz	a7,4dc <printint+0x66>
    buf[i++] = '-';
 4c8:	fd070793          	addi	a5,a4,-48
 4cc:	00878733          	add	a4,a5,s0
 4d0:	02d00793          	li	a5,45
 4d4:	fef70823          	sb	a5,-16(a4)
 4d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4dc:	02e05863          	blez	a4,50c <printint+0x96>
 4e0:	fc040793          	addi	a5,s0,-64
 4e4:	00e78933          	add	s2,a5,a4
 4e8:	fff78993          	addi	s3,a5,-1
 4ec:	99ba                	add	s3,s3,a4
 4ee:	377d                	addiw	a4,a4,-1
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f8:	fff94583          	lbu	a1,-1(s2)
 4fc:	8526                	mv	a0,s1
 4fe:	00000097          	auipc	ra,0x0
 502:	f56080e7          	jalr	-170(ra) # 454 <putc>
  while(--i >= 0)
 506:	197d                	addi	s2,s2,-1
 508:	ff3918e3          	bne	s2,s3,4f8 <printint+0x82>
}
 50c:	70e2                	ld	ra,56(sp)
 50e:	7442                	ld	s0,48(sp)
 510:	74a2                	ld	s1,40(sp)
 512:	7902                	ld	s2,32(sp)
 514:	69e2                	ld	s3,24(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret
    x = -xx;
 51a:	40b005bb          	negw	a1,a1
    neg = 1;
 51e:	4885                	li	a7,1
    x = -xx;
 520:	bf85                	j	490 <printint+0x1a>

0000000000000522 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 522:	715d                	addi	sp,sp,-80
 524:	e486                	sd	ra,72(sp)
 526:	e0a2                	sd	s0,64(sp)
 528:	fc26                	sd	s1,56(sp)
 52a:	f84a                	sd	s2,48(sp)
 52c:	f44e                	sd	s3,40(sp)
 52e:	f052                	sd	s4,32(sp)
 530:	ec56                	sd	s5,24(sp)
 532:	e85a                	sd	s6,16(sp)
 534:	e45e                	sd	s7,8(sp)
 536:	e062                	sd	s8,0(sp)
 538:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 53a:	0005c903          	lbu	s2,0(a1)
 53e:	18090c63          	beqz	s2,6d6 <vprintf+0x1b4>
 542:	8aaa                	mv	s5,a0
 544:	8bb2                	mv	s7,a2
 546:	00158493          	addi	s1,a1,1
  state = 0;
 54a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54c:	02500a13          	li	s4,37
 550:	4b55                	li	s6,21
 552:	a839                	j	570 <vprintf+0x4e>
        putc(fd, c);
 554:	85ca                	mv	a1,s2
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	efc080e7          	jalr	-260(ra) # 454 <putc>
 560:	a019                	j	566 <vprintf+0x44>
    } else if(state == '%'){
 562:	01498d63          	beq	s3,s4,57c <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 566:	0485                	addi	s1,s1,1
 568:	fff4c903          	lbu	s2,-1(s1)
 56c:	16090563          	beqz	s2,6d6 <vprintf+0x1b4>
    if(state == 0){
 570:	fe0999e3          	bnez	s3,562 <vprintf+0x40>
      if(c == '%'){
 574:	ff4910e3          	bne	s2,s4,554 <vprintf+0x32>
        state = '%';
 578:	89d2                	mv	s3,s4
 57a:	b7f5                	j	566 <vprintf+0x44>
      if(c == 'd'){
 57c:	13490263          	beq	s2,s4,6a0 <vprintf+0x17e>
 580:	f9d9079b          	addiw	a5,s2,-99
 584:	0ff7f793          	zext.b	a5,a5
 588:	12fb6563          	bltu	s6,a5,6b2 <vprintf+0x190>
 58c:	f9d9079b          	addiw	a5,s2,-99
 590:	0ff7f713          	zext.b	a4,a5
 594:	10eb6f63          	bltu	s6,a4,6b2 <vprintf+0x190>
 598:	00271793          	slli	a5,a4,0x2
 59c:	00000717          	auipc	a4,0x0
 5a0:	36470713          	addi	a4,a4,868 # 900 <malloc+0x12c>
 5a4:	97ba                	add	a5,a5,a4
 5a6:	439c                	lw	a5,0(a5)
 5a8:	97ba                	add	a5,a5,a4
 5aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ebc080e7          	jalr	-324(ra) # 476 <printint>
 5c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b745                	j	566 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ea0080e7          	jalr	-352(ra) # 476 <printint>
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b751                	j	566 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e84080e7          	jalr	-380(ra) # 476 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b7a5                	j	566 <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 600:	008b8c13          	addi	s8,s7,8
 604:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 608:	03000593          	li	a1,48
 60c:	8556                	mv	a0,s5
 60e:	00000097          	auipc	ra,0x0
 612:	e46080e7          	jalr	-442(ra) # 454 <putc>
  putc(fd, 'x');
 616:	07800593          	li	a1,120
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	e38080e7          	jalr	-456(ra) # 454 <putc>
 624:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 626:	00000b97          	auipc	s7,0x0
 62a:	332b8b93          	addi	s7,s7,818 # 958 <digits>
 62e:	03c9d793          	srli	a5,s3,0x3c
 632:	97de                	add	a5,a5,s7
 634:	0007c583          	lbu	a1,0(a5)
 638:	8556                	mv	a0,s5
 63a:	00000097          	auipc	ra,0x0
 63e:	e1a080e7          	jalr	-486(ra) # 454 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 642:	0992                	slli	s3,s3,0x4
 644:	397d                	addiw	s2,s2,-1
 646:	fe0914e3          	bnez	s2,62e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 64a:	8be2                	mv	s7,s8
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bf21                	j	566 <vprintf+0x44>
        s = va_arg(ap, char*);
 650:	008b8993          	addi	s3,s7,8
 654:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 658:	02090163          	beqz	s2,67a <vprintf+0x158>
        while(*s != 0){
 65c:	00094583          	lbu	a1,0(s2)
 660:	c9a5                	beqz	a1,6d0 <vprintf+0x1ae>
          putc(fd, *s);
 662:	8556                	mv	a0,s5
 664:	00000097          	auipc	ra,0x0
 668:	df0080e7          	jalr	-528(ra) # 454 <putc>
          s++;
 66c:	0905                	addi	s2,s2,1
        while(*s != 0){
 66e:	00094583          	lbu	a1,0(s2)
 672:	f9e5                	bnez	a1,662 <vprintf+0x140>
        s = va_arg(ap, char*);
 674:	8bce                	mv	s7,s3
      state = 0;
 676:	4981                	li	s3,0
 678:	b5fd                	j	566 <vprintf+0x44>
          s = "(null)";
 67a:	00000917          	auipc	s2,0x0
 67e:	27e90913          	addi	s2,s2,638 # 8f8 <malloc+0x124>
        while(*s != 0){
 682:	02800593          	li	a1,40
 686:	bff1                	j	662 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 688:	008b8913          	addi	s2,s7,8
 68c:	000bc583          	lbu	a1,0(s7)
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	dc2080e7          	jalr	-574(ra) # 454 <putc>
 69a:	8bca                	mv	s7,s2
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b5e1                	j	566 <vprintf+0x44>
        putc(fd, c);
 6a0:	02500593          	li	a1,37
 6a4:	8556                	mv	a0,s5
 6a6:	00000097          	auipc	ra,0x0
 6aa:	dae080e7          	jalr	-594(ra) # 454 <putc>
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	bd5d                	j	566 <vprintf+0x44>
        putc(fd, '%');
 6b2:	02500593          	li	a1,37
 6b6:	8556                	mv	a0,s5
 6b8:	00000097          	auipc	ra,0x0
 6bc:	d9c080e7          	jalr	-612(ra) # 454 <putc>
        putc(fd, c);
 6c0:	85ca                	mv	a1,s2
 6c2:	8556                	mv	a0,s5
 6c4:	00000097          	auipc	ra,0x0
 6c8:	d90080e7          	jalr	-624(ra) # 454 <putc>
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	bd61                	j	566 <vprintf+0x44>
        s = va_arg(ap, char*);
 6d0:	8bce                	mv	s7,s3
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	bd49                	j	566 <vprintf+0x44>
    }
  }
}
 6d6:	60a6                	ld	ra,72(sp)
 6d8:	6406                	ld	s0,64(sp)
 6da:	74e2                	ld	s1,56(sp)
 6dc:	7942                	ld	s2,48(sp)
 6de:	79a2                	ld	s3,40(sp)
 6e0:	7a02                	ld	s4,32(sp)
 6e2:	6ae2                	ld	s5,24(sp)
 6e4:	6b42                	ld	s6,16(sp)
 6e6:	6ba2                	ld	s7,8(sp)
 6e8:	6c02                	ld	s8,0(sp)
 6ea:	6161                	addi	sp,sp,80
 6ec:	8082                	ret

00000000000006ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6ee:	715d                	addi	sp,sp,-80
 6f0:	ec06                	sd	ra,24(sp)
 6f2:	e822                	sd	s0,16(sp)
 6f4:	1000                	addi	s0,sp,32
 6f6:	e010                	sd	a2,0(s0)
 6f8:	e414                	sd	a3,8(s0)
 6fa:	e818                	sd	a4,16(s0)
 6fc:	ec1c                	sd	a5,24(s0)
 6fe:	03043023          	sd	a6,32(s0)
 702:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70a:	8622                	mv	a2,s0
 70c:	00000097          	auipc	ra,0x0
 710:	e16080e7          	jalr	-490(ra) # 522 <vprintf>
}
 714:	60e2                	ld	ra,24(sp)
 716:	6442                	ld	s0,16(sp)
 718:	6161                	addi	sp,sp,80
 71a:	8082                	ret

000000000000071c <printf>:

void
printf(const char *fmt, ...)
{
 71c:	711d                	addi	sp,sp,-96
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e40c                	sd	a1,8(s0)
 726:	e810                	sd	a2,16(s0)
 728:	ec14                	sd	a3,24(s0)
 72a:	f018                	sd	a4,32(s0)
 72c:	f41c                	sd	a5,40(s0)
 72e:	03043823          	sd	a6,48(s0)
 732:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 736:	00840613          	addi	a2,s0,8
 73a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73e:	85aa                	mv	a1,a0
 740:	4505                	li	a0,1
 742:	00000097          	auipc	ra,0x0
 746:	de0080e7          	jalr	-544(ra) # 522 <vprintf>
}
 74a:	60e2                	ld	ra,24(sp)
 74c:	6442                	ld	s0,16(sp)
 74e:	6125                	addi	sp,sp,96
 750:	8082                	ret

0000000000000752 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 752:	1141                	addi	sp,sp,-16
 754:	e422                	sd	s0,8(sp)
 756:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 758:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75c:	00001797          	auipc	a5,0x1
 760:	8a47b783          	ld	a5,-1884(a5) # 1000 <freep>
 764:	a02d                	j	78e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 766:	4618                	lw	a4,8(a2)
 768:	9f2d                	addw	a4,a4,a1
 76a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	6398                	ld	a4,0(a5)
 770:	6310                	ld	a2,0(a4)
 772:	a83d                	j	7b0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 774:	ff852703          	lw	a4,-8(a0)
 778:	9f31                	addw	a4,a4,a2
 77a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77c:	ff053683          	ld	a3,-16(a0)
 780:	a091                	j	7c4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 782:	6398                	ld	a4,0(a5)
 784:	00e7e463          	bltu	a5,a4,78c <free+0x3a>
 788:	00e6ea63          	bltu	a3,a4,79c <free+0x4a>
{
 78c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	fed7fae3          	bgeu	a5,a3,782 <free+0x30>
 792:	6398                	ld	a4,0(a5)
 794:	00e6e463          	bltu	a3,a4,79c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	fee7eae3          	bltu	a5,a4,78c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059813          	slli	a6,a1,0x20
 7a6:	01c85713          	srli	a4,a6,0x1c
 7aa:	9736                	add	a4,a4,a3
 7ac:	fae60de3          	beq	a2,a4,766 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061593          	slli	a1,a2,0x20
 7ba:	01c5d713          	srli	a4,a1,0x1c
 7be:	973e                	add	a4,a4,a5
 7c0:	fae68ae3          	beq	a3,a4,774 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	6422                	ld	s0,8(sp)
 7d0:	0141                	addi	sp,sp,16
 7d2:	8082                	ret

00000000000007d4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d4:	7139                	addi	sp,sp,-64
 7d6:	fc06                	sd	ra,56(sp)
 7d8:	f822                	sd	s0,48(sp)
 7da:	f426                	sd	s1,40(sp)
 7dc:	f04a                	sd	s2,32(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	e852                	sd	s4,16(sp)
 7e2:	e456                	sd	s5,8(sp)
 7e4:	e05a                	sd	s6,0(sp)
 7e6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e8:	02051493          	slli	s1,a0,0x20
 7ec:	9081                	srli	s1,s1,0x20
 7ee:	04bd                	addi	s1,s1,15
 7f0:	8091                	srli	s1,s1,0x4
 7f2:	0014899b          	addiw	s3,s1,1
 7f6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7f8:	00001517          	auipc	a0,0x1
 7fc:	80853503          	ld	a0,-2040(a0) # 1000 <freep>
 800:	c515                	beqz	a0,82c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 802:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 804:	4798                	lw	a4,8(a5)
 806:	02977f63          	bgeu	a4,s1,844 <malloc+0x70>
  if(nu < 4096)
 80a:	8a4e                	mv	s4,s3
 80c:	0009871b          	sext.w	a4,s3
 810:	6685                	lui	a3,0x1
 812:	00d77363          	bgeu	a4,a3,818 <malloc+0x44>
 816:	6a05                	lui	s4,0x1
 818:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 820:	00000917          	auipc	s2,0x0
 824:	7e090913          	addi	s2,s2,2016 # 1000 <freep>
  if(p == (char*)-1)
 828:	5afd                	li	s5,-1
 82a:	a895                	j	89e <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 82c:	00000797          	auipc	a5,0x0
 830:	7e478793          	addi	a5,a5,2020 # 1010 <base>
 834:	00000717          	auipc	a4,0x0
 838:	7cf73623          	sd	a5,1996(a4) # 1000 <freep>
 83c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 83e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 842:	b7e1                	j	80a <malloc+0x36>
      if(p->s.size == nunits)
 844:	02e48c63          	beq	s1,a4,87c <malloc+0xa8>
        p->s.size -= nunits;
 848:	4137073b          	subw	a4,a4,s3
 84c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 84e:	02071693          	slli	a3,a4,0x20
 852:	01c6d713          	srli	a4,a3,0x1c
 856:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 858:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 85c:	00000717          	auipc	a4,0x0
 860:	7aa73223          	sd	a0,1956(a4) # 1000 <freep>
      return (void*)(p + 1);
 864:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 868:	70e2                	ld	ra,56(sp)
 86a:	7442                	ld	s0,48(sp)
 86c:	74a2                	ld	s1,40(sp)
 86e:	7902                	ld	s2,32(sp)
 870:	69e2                	ld	s3,24(sp)
 872:	6a42                	ld	s4,16(sp)
 874:	6aa2                	ld	s5,8(sp)
 876:	6b02                	ld	s6,0(sp)
 878:	6121                	addi	sp,sp,64
 87a:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 87c:	6398                	ld	a4,0(a5)
 87e:	e118                	sd	a4,0(a0)
 880:	bff1                	j	85c <malloc+0x88>
  hp->s.size = nu;
 882:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 886:	0541                	addi	a0,a0,16
 888:	00000097          	auipc	ra,0x0
 88c:	eca080e7          	jalr	-310(ra) # 752 <free>
  return freep;
 890:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 894:	d971                	beqz	a0,868 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 896:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 898:	4798                	lw	a4,8(a5)
 89a:	fa9775e3          	bgeu	a4,s1,844 <malloc+0x70>
    if(p == freep)
 89e:	00093703          	ld	a4,0(s2)
 8a2:	853e                	mv	a0,a5
 8a4:	fef719e3          	bne	a4,a5,896 <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 8a8:	8552                	mv	a0,s4
 8aa:	00000097          	auipc	ra,0x0
 8ae:	b82080e7          	jalr	-1150(ra) # 42c <sbrk>
  if(p == (char*)-1)
 8b2:	fd5518e3          	bne	a0,s5,882 <malloc+0xae>
        return 0;
 8b6:	4501                	li	a0,0
 8b8:	bf45                	j	868 <malloc+0x94>
