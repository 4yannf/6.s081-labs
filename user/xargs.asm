
user/_xargs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user.h"
#include "kernel/param.h"

int main(int argc, char *argv[]){
   0:	cb010113          	addi	sp,sp,-848
   4:	34113423          	sd	ra,840(sp)
   8:	34813023          	sd	s0,832(sp)
   c:	32913c23          	sd	s1,824(sp)
  10:	33213823          	sd	s2,816(sp)
  14:	33313423          	sd	s3,808(sp)
  18:	33413023          	sd	s4,800(sp)
  1c:	31513c23          	sd	s5,792(sp)
  20:	0e80                	addi	s0,sp,848
  if(argc < 2){
  22:	4785                	li	a5,1
  24:	00a7d963          	bge	a5,a0,36 <main+0x36>
  28:	89aa                	mv	s3,a0
  2a:	8a2e                	mv	s4,a1
    fprintf(2, "usage: xargs [command]\n");
    exit(1);
  }
  
  char *command = argv[1];
  2c:	0085ba83          	ld	s5,8(a1)
  char buf[512];
  int p = 0;
  30:	4481                	li	s1,0
    int n;
    char ch;
    n = read(0, &ch, 1);

    if(n == 0) break;
    else if(ch == '\n'){
  32:	4929                	li	s2,10
  34:	a825                	j	6c <main+0x6c>
    fprintf(2, "usage: xargs [command]\n");
  36:	00001597          	auipc	a1,0x1
  3a:	86a58593          	addi	a1,a1,-1942 # 8a0 <malloc+0xe6>
  3e:	4509                	li	a0,2
  40:	00000097          	auipc	ra,0x0
  44:	694080e7          	jalr	1684(ra) # 6d4 <fprintf>
    exit(1);
  48:	4505                	li	a0,1
  4a:	00000097          	auipc	ra,0x0
  4e:	340080e7          	jalr	832(ra) # 38a <exit>
      if(fork() == 0){
  52:	00000097          	auipc	ra,0x0
  56:	330080e7          	jalr	816(ra) # 382 <fork>
  5a:	cd0d                	beqz	a0,94 <main+0x94>
        exec(command, execArgv);
        exit(0);
      }
      else {
        p = 0;
        buf[p] = '\0';
  5c:	dc040023          	sb	zero,-576(s0)
        wait(0);
  60:	4501                	li	a0,0
  62:	00000097          	auipc	ra,0x0
  66:	330080e7          	jalr	816(ra) # 392 <wait>
        p = 0;
  6a:	4481                	li	s1,0
    n = read(0, &ch, 1);
  6c:	4605                	li	a2,1
  6e:	cbf40593          	addi	a1,s0,-833
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	32e080e7          	jalr	814(ra) # 3a2 <read>
    if(n == 0) break;
  7c:	cd3d                	beqz	a0,fa <main+0xfa>
    else if(ch == '\n'){
  7e:	cbf44783          	lbu	a5,-833(s0)
  82:	fd2788e3          	beq	a5,s2,52 <main+0x52>
      }
    }
    else {
      buf[p++] = ch;
  86:	fc048713          	addi	a4,s1,-64
  8a:	9722                	add	a4,a4,s0
  8c:	e0f70023          	sb	a5,-512(a4)
  90:	2485                	addiw	s1,s1,1
  while(1){
  92:	bfe9                	j	6c <main+0x6c>
        execArgv[0] = command;
  94:	cd543023          	sd	s5,-832(s0)
        for(i = 0; i < argc - 2; ++i){
  98:	4789                	li	a5,2
  9a:	0337d463          	bge	a5,s3,c2 <main+0xc2>
  9e:	010a0793          	addi	a5,s4,16
  a2:	cc840713          	addi	a4,s0,-824
  a6:	ffd9861b          	addiw	a2,s3,-3
  aa:	02061693          	slli	a3,a2,0x20
  ae:	01d6d613          	srli	a2,a3,0x1d
  b2:	0a61                	addi	s4,s4,24
  b4:	9652                	add	a2,a2,s4
          execArgv[i + 1] = argv[i + 2];
  b6:	6394                	ld	a3,0(a5)
  b8:	e314                	sd	a3,0(a4)
        for(i = 0; i < argc - 2; ++i){
  ba:	07a1                	addi	a5,a5,8
  bc:	0721                	addi	a4,a4,8
  be:	fec79ce3          	bne	a5,a2,b6 <main+0xb6>
        buf[p] = '\0';
  c2:	fc048793          	addi	a5,s1,-64
  c6:	008784b3          	add	s1,a5,s0
  ca:	e0048023          	sb	zero,-512(s1)
        execArgv[argc - 1] = buf;
  ce:	fff9879b          	addiw	a5,s3,-1
  d2:	078e                	slli	a5,a5,0x3
  d4:	fc078793          	addi	a5,a5,-64
  d8:	97a2                	add	a5,a5,s0
  da:	dc040713          	addi	a4,s0,-576
  de:	d0e7b023          	sd	a4,-768(a5)
        exec(command, execArgv);
  e2:	cc040593          	addi	a1,s0,-832
  e6:	8556                	mv	a0,s5
  e8:	00000097          	auipc	ra,0x0
  ec:	2da080e7          	jalr	730(ra) # 3c2 <exec>
        exit(0);
  f0:	4501                	li	a0,0
  f2:	00000097          	auipc	ra,0x0
  f6:	298080e7          	jalr	664(ra) # 38a <exit>
    }
  }
  exit(0);
  fa:	4501                	li	a0,0
  fc:	00000097          	auipc	ra,0x0
 100:	28e080e7          	jalr	654(ra) # 38a <exit>

0000000000000104 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 10c:	00000097          	auipc	ra,0x0
 110:	ef4080e7          	jalr	-268(ra) # 0 <main>
  exit(0);
 114:	4501                	li	a0,0
 116:	00000097          	auipc	ra,0x0
 11a:	274080e7          	jalr	628(ra) # 38a <exit>

000000000000011e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e422                	sd	s0,8(sp)
 122:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 124:	87aa                	mv	a5,a0
 126:	0585                	addi	a1,a1,1
 128:	0785                	addi	a5,a5,1
 12a:	fff5c703          	lbu	a4,-1(a1)
 12e:	fee78fa3          	sb	a4,-1(a5)
 132:	fb75                	bnez	a4,126 <strcpy+0x8>
    ;
  return os;
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret

000000000000013a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13a:	1141                	addi	sp,sp,-16
 13c:	e422                	sd	s0,8(sp)
 13e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 140:	00054783          	lbu	a5,0(a0)
 144:	cb91                	beqz	a5,158 <strcmp+0x1e>
 146:	0005c703          	lbu	a4,0(a1)
 14a:	00f71763          	bne	a4,a5,158 <strcmp+0x1e>
    p++, q++;
 14e:	0505                	addi	a0,a0,1
 150:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	fbe5                	bnez	a5,146 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 158:	0005c503          	lbu	a0,0(a1)
}
 15c:	40a7853b          	subw	a0,a5,a0
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret

0000000000000166 <strlen>:

uint
strlen(const char *s)
{
 166:	1141                	addi	sp,sp,-16
 168:	e422                	sd	s0,8(sp)
 16a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16c:	00054783          	lbu	a5,0(a0)
 170:	cf91                	beqz	a5,18c <strlen+0x26>
 172:	0505                	addi	a0,a0,1
 174:	87aa                	mv	a5,a0
 176:	86be                	mv	a3,a5
 178:	0785                	addi	a5,a5,1
 17a:	fff7c703          	lbu	a4,-1(a5)
 17e:	ff65                	bnez	a4,176 <strlen+0x10>
 180:	40a6853b          	subw	a0,a3,a0
 184:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret
  for(n = 0; s[n]; n++)
 18c:	4501                	li	a0,0
 18e:	bfe5                	j	186 <strlen+0x20>

0000000000000190 <memset>:

void*
memset(void *dst, int c, uint n)
{
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1c>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x12>
  }
  return dst;
}
 1ac:	6422                	ld	s0,8(sp)
 1ae:	0141                	addi	sp,sp,16
 1b0:	8082                	ret

00000000000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	1141                	addi	sp,sp,-16
 1b4:	e422                	sd	s0,8(sp)
 1b6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	cb99                	beqz	a5,1d2 <strchr+0x20>
    if(*s == c)
 1be:	00f58763          	beq	a1,a5,1cc <strchr+0x1a>
  for(; *s; s++)
 1c2:	0505                	addi	a0,a0,1
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	fbfd                	bnez	a5,1be <strchr+0xc>
      return (char*)s;
  return 0;
 1ca:	4501                	li	a0,0
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <strchr+0x1a>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	1080                	addi	s0,sp,96
 1ec:	8baa                	mv	s7,a0
 1ee:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f0:	892a                	mv	s2,a0
 1f2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f4:	4aa9                	li	s5,10
 1f6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1f8:	89a6                	mv	s3,s1
 1fa:	2485                	addiw	s1,s1,1
 1fc:	0344d863          	bge	s1,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 200:	4605                	li	a2,1
 202:	faf40593          	addi	a1,s0,-81
 206:	4501                	li	a0,0
 208:	00000097          	auipc	ra,0x0
 20c:	19a080e7          	jalr	410(ra) # 3a2 <read>
    if(cc < 1)
 210:	00a05e63          	blez	a0,22c <gets+0x56>
    buf[i++] = c;
 214:	faf44783          	lbu	a5,-81(s0)
 218:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21c:	01578763          	beq	a5,s5,22a <gets+0x54>
 220:	0905                	addi	s2,s2,1
 222:	fd679be3          	bne	a5,s6,1f8 <gets+0x22>
  for(i=0; i+1 < max; ){
 226:	89a6                	mv	s3,s1
 228:	a011                	j	22c <gets+0x56>
 22a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 22c:	99de                	add	s3,s3,s7
 22e:	00098023          	sb	zero,0(s3)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6125                	addi	sp,sp,96
 248:	8082                	ret

000000000000024a <stat>:

int
stat(const char *n, struct stat *st)
{
 24a:	1101                	addi	sp,sp,-32
 24c:	ec06                	sd	ra,24(sp)
 24e:	e822                	sd	s0,16(sp)
 250:	e426                	sd	s1,8(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	00000097          	auipc	ra,0x0
 25e:	170080e7          	jalr	368(ra) # 3ca <open>
  if(fd < 0)
 262:	02054563          	bltz	a0,28c <stat+0x42>
 266:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 268:	85ca                	mv	a1,s2
 26a:	00000097          	auipc	ra,0x0
 26e:	178080e7          	jalr	376(ra) # 3e2 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	00000097          	auipc	ra,0x0
 27a:	13c080e7          	jalr	316(ra) # 3b2 <close>
  return r;
}
 27e:	854a                	mv	a0,s2
 280:	60e2                	ld	ra,24(sp)
 282:	6442                	ld	s0,16(sp)
 284:	64a2                	ld	s1,8(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	597d                	li	s2,-1
 28e:	bfc5                	j	27e <stat+0x34>

0000000000000290 <atoi>:

int
atoi(const char *s)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4625                	li	a2,9
 2a4:	02f66863          	bltu	a2,a5,2d4 <atoi+0x44>
 2a8:	872a                	mv	a4,a0
  n = 0;
 2aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ac:	0705                	addi	a4,a4,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb5                	addw	a5,a5,a3
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	00074683          	lbu	a3,0(a4)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	fef671e3          	bgeu	a2,a5,2ac <atoi+0x1c>
  return n;
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  n = 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <atoi+0x3e>

00000000000002d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2de:	02b57463          	bgeu	a0,a1,306 <memmove+0x2e>
    while(n-- > 0)
 2e2:	00c05f63          	blez	a2,300 <memmove+0x28>
 2e6:	1602                	slli	a2,a2,0x20
 2e8:	9201                	srli	a2,a2,0x20
 2ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ee:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f0:	0585                	addi	a1,a1,1
 2f2:	0705                	addi	a4,a4,1
 2f4:	fff5c683          	lbu	a3,-1(a1)
 2f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fc:	fee79ae3          	bne	a5,a4,2f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 300:	6422                	ld	s0,8(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
    dst += n;
 306:	00c50733          	add	a4,a0,a2
    src += n;
 30a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 30c:	fec05ae3          	blez	a2,300 <memmove+0x28>
 310:	fff6079b          	addiw	a5,a2,-1
 314:	1782                	slli	a5,a5,0x20
 316:	9381                	srli	a5,a5,0x20
 318:	fff7c793          	not	a5,a5
 31c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31e:	15fd                	addi	a1,a1,-1
 320:	177d                	addi	a4,a4,-1
 322:	0005c683          	lbu	a3,0(a1)
 326:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32a:	fee79ae3          	bne	a5,a4,31e <memmove+0x46>
 32e:	bfc9                	j	300 <memmove+0x28>

0000000000000330 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e422                	sd	s0,8(sp)
 334:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 336:	ca05                	beqz	a2,366 <memcmp+0x36>
 338:	fff6069b          	addiw	a3,a2,-1
 33c:	1682                	slli	a3,a3,0x20
 33e:	9281                	srli	a3,a3,0x20
 340:	0685                	addi	a3,a3,1
 342:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 344:	00054783          	lbu	a5,0(a0)
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00e79863          	bne	a5,a4,35c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 350:	0505                	addi	a0,a0,1
    p2++;
 352:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 354:	fed518e3          	bne	a0,a3,344 <memcmp+0x14>
  }
  return 0;
 358:	4501                	li	a0,0
 35a:	a019                	j	360 <memcmp+0x30>
      return *p1 - *p2;
 35c:	40e7853b          	subw	a0,a5,a4
}
 360:	6422                	ld	s0,8(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfe5                	j	360 <memcmp+0x30>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	00000097          	auipc	ra,0x0
 376:	f66080e7          	jalr	-154(ra) # 2d8 <memmove>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 382:	4885                	li	a7,1
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exit>:
.global exit
exit:
 li a7, SYS_exit
 38a:	4889                	li	a7,2
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <wait>:
.global wait
wait:
 li a7, SYS_wait
 392:	488d                	li	a7,3
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39a:	4891                	li	a7,4
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <read>:
.global read
read:
 li a7, SYS_read
 3a2:	4895                	li	a7,5
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <write>:
.global write
write:
 li a7, SYS_write
 3aa:	48c1                	li	a7,16
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <close>:
.global close
close:
 li a7, SYS_close
 3b2:	48d5                	li	a7,21
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <open>:
.global open
open:
 li a7, SYS_open
 3ca:	48bd                	li	a7,15
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d2:	48c5                	li	a7,17
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3da:	48c9                	li	a7,18
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e2:	48a1                	li	a7,8
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <link>:
.global link
link:
 li a7, SYS_link
 3ea:	48cd                	li	a7,19
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f2:	48d1                	li	a7,20
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fa:	48a5                	li	a7,9
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <dup>:
.global dup
dup:
 li a7, SYS_dup
 402:	48a9                	li	a7,10
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40a:	48ad                	li	a7,11
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 412:	48b1                	li	a7,12
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41a:	48b5                	li	a7,13
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 422:	48b9                	li	a7,14
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <trace>:
.global trace
trace:
 li a7, SYS_trace
 42a:	48d9                	li	a7,22
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 432:	48dd                	li	a7,23
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43a:	1101                	addi	sp,sp,-32
 43c:	ec06                	sd	ra,24(sp)
 43e:	e822                	sd	s0,16(sp)
 440:	1000                	addi	s0,sp,32
 442:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 446:	4605                	li	a2,1
 448:	fef40593          	addi	a1,s0,-17
 44c:	00000097          	auipc	ra,0x0
 450:	f5e080e7          	jalr	-162(ra) # 3aa <write>
}
 454:	60e2                	ld	ra,24(sp)
 456:	6442                	ld	s0,16(sp)
 458:	6105                	addi	sp,sp,32
 45a:	8082                	ret

000000000000045c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45c:	7139                	addi	sp,sp,-64
 45e:	fc06                	sd	ra,56(sp)
 460:	f822                	sd	s0,48(sp)
 462:	f426                	sd	s1,40(sp)
 464:	f04a                	sd	s2,32(sp)
 466:	ec4e                	sd	s3,24(sp)
 468:	0080                	addi	s0,sp,64
 46a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46c:	c299                	beqz	a3,472 <printint+0x16>
 46e:	0805c963          	bltz	a1,500 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 472:	2581                	sext.w	a1,a1
  neg = 0;
 474:	4881                	li	a7,0
 476:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 47a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47c:	2601                	sext.w	a2,a2
 47e:	00000517          	auipc	a0,0x0
 482:	49a50513          	addi	a0,a0,1178 # 918 <digits>
 486:	883a                	mv	a6,a4
 488:	2705                	addiw	a4,a4,1
 48a:	02c5f7bb          	remuw	a5,a1,a2
 48e:	1782                	slli	a5,a5,0x20
 490:	9381                	srli	a5,a5,0x20
 492:	97aa                	add	a5,a5,a0
 494:	0007c783          	lbu	a5,0(a5)
 498:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49c:	0005879b          	sext.w	a5,a1
 4a0:	02c5d5bb          	divuw	a1,a1,a2
 4a4:	0685                	addi	a3,a3,1
 4a6:	fec7f0e3          	bgeu	a5,a2,486 <printint+0x2a>
  if(neg)
 4aa:	00088c63          	beqz	a7,4c2 <printint+0x66>
    buf[i++] = '-';
 4ae:	fd070793          	addi	a5,a4,-48
 4b2:	00878733          	add	a4,a5,s0
 4b6:	02d00793          	li	a5,45
 4ba:	fef70823          	sb	a5,-16(a4)
 4be:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c2:	02e05863          	blez	a4,4f2 <printint+0x96>
 4c6:	fc040793          	addi	a5,s0,-64
 4ca:	00e78933          	add	s2,a5,a4
 4ce:	fff78993          	addi	s3,a5,-1
 4d2:	99ba                	add	s3,s3,a4
 4d4:	377d                	addiw	a4,a4,-1
 4d6:	1702                	slli	a4,a4,0x20
 4d8:	9301                	srli	a4,a4,0x20
 4da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4de:	fff94583          	lbu	a1,-1(s2)
 4e2:	8526                	mv	a0,s1
 4e4:	00000097          	auipc	ra,0x0
 4e8:	f56080e7          	jalr	-170(ra) # 43a <putc>
  while(--i >= 0)
 4ec:	197d                	addi	s2,s2,-1
 4ee:	ff3918e3          	bne	s2,s3,4de <printint+0x82>
}
 4f2:	70e2                	ld	ra,56(sp)
 4f4:	7442                	ld	s0,48(sp)
 4f6:	74a2                	ld	s1,40(sp)
 4f8:	7902                	ld	s2,32(sp)
 4fa:	69e2                	ld	s3,24(sp)
 4fc:	6121                	addi	sp,sp,64
 4fe:	8082                	ret
    x = -xx;
 500:	40b005bb          	negw	a1,a1
    neg = 1;
 504:	4885                	li	a7,1
    x = -xx;
 506:	bf85                	j	476 <printint+0x1a>

0000000000000508 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 508:	715d                	addi	sp,sp,-80
 50a:	e486                	sd	ra,72(sp)
 50c:	e0a2                	sd	s0,64(sp)
 50e:	fc26                	sd	s1,56(sp)
 510:	f84a                	sd	s2,48(sp)
 512:	f44e                	sd	s3,40(sp)
 514:	f052                	sd	s4,32(sp)
 516:	ec56                	sd	s5,24(sp)
 518:	e85a                	sd	s6,16(sp)
 51a:	e45e                	sd	s7,8(sp)
 51c:	e062                	sd	s8,0(sp)
 51e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 520:	0005c903          	lbu	s2,0(a1)
 524:	18090c63          	beqz	s2,6bc <vprintf+0x1b4>
 528:	8aaa                	mv	s5,a0
 52a:	8bb2                	mv	s7,a2
 52c:	00158493          	addi	s1,a1,1
  state = 0;
 530:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 532:	02500a13          	li	s4,37
 536:	4b55                	li	s6,21
 538:	a839                	j	556 <vprintf+0x4e>
        putc(fd, c);
 53a:	85ca                	mv	a1,s2
 53c:	8556                	mv	a0,s5
 53e:	00000097          	auipc	ra,0x0
 542:	efc080e7          	jalr	-260(ra) # 43a <putc>
 546:	a019                	j	54c <vprintf+0x44>
    } else if(state == '%'){
 548:	01498d63          	beq	s3,s4,562 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 54c:	0485                	addi	s1,s1,1
 54e:	fff4c903          	lbu	s2,-1(s1)
 552:	16090563          	beqz	s2,6bc <vprintf+0x1b4>
    if(state == 0){
 556:	fe0999e3          	bnez	s3,548 <vprintf+0x40>
      if(c == '%'){
 55a:	ff4910e3          	bne	s2,s4,53a <vprintf+0x32>
        state = '%';
 55e:	89d2                	mv	s3,s4
 560:	b7f5                	j	54c <vprintf+0x44>
      if(c == 'd'){
 562:	13490263          	beq	s2,s4,686 <vprintf+0x17e>
 566:	f9d9079b          	addiw	a5,s2,-99
 56a:	0ff7f793          	zext.b	a5,a5
 56e:	12fb6563          	bltu	s6,a5,698 <vprintf+0x190>
 572:	f9d9079b          	addiw	a5,s2,-99
 576:	0ff7f713          	zext.b	a4,a5
 57a:	10eb6f63          	bltu	s6,a4,698 <vprintf+0x190>
 57e:	00271793          	slli	a5,a4,0x2
 582:	00000717          	auipc	a4,0x0
 586:	33e70713          	addi	a4,a4,830 # 8c0 <malloc+0x106>
 58a:	97ba                	add	a5,a5,a4
 58c:	439c                	lw	a5,0(a5)
 58e:	97ba                	add	a5,a5,a4
 590:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	8556                	mv	a0,s5
 5a0:	00000097          	auipc	ra,0x0
 5a4:	ebc080e7          	jalr	-324(ra) # 45c <printint>
 5a8:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b745                	j	54c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	008b8913          	addi	s2,s7,8
 5b2:	4681                	li	a3,0
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ea0080e7          	jalr	-352(ra) # 45c <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	b751                	j	54c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 5ca:	008b8913          	addi	s2,s7,8
 5ce:	4681                	li	a3,0
 5d0:	4641                	li	a2,16
 5d2:	000ba583          	lw	a1,0(s7)
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	e84080e7          	jalr	-380(ra) # 45c <printint>
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b7a5                	j	54c <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 5e6:	008b8c13          	addi	s8,s7,8
 5ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ee:	03000593          	li	a1,48
 5f2:	8556                	mv	a0,s5
 5f4:	00000097          	auipc	ra,0x0
 5f8:	e46080e7          	jalr	-442(ra) # 43a <putc>
  putc(fd, 'x');
 5fc:	07800593          	li	a1,120
 600:	8556                	mv	a0,s5
 602:	00000097          	auipc	ra,0x0
 606:	e38080e7          	jalr	-456(ra) # 43a <putc>
 60a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60c:	00000b97          	auipc	s7,0x0
 610:	30cb8b93          	addi	s7,s7,780 # 918 <digits>
 614:	03c9d793          	srli	a5,s3,0x3c
 618:	97de                	add	a5,a5,s7
 61a:	0007c583          	lbu	a1,0(a5)
 61e:	8556                	mv	a0,s5
 620:	00000097          	auipc	ra,0x0
 624:	e1a080e7          	jalr	-486(ra) # 43a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 628:	0992                	slli	s3,s3,0x4
 62a:	397d                	addiw	s2,s2,-1
 62c:	fe0914e3          	bnez	s2,614 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 630:	8be2                	mv	s7,s8
      state = 0;
 632:	4981                	li	s3,0
 634:	bf21                	j	54c <vprintf+0x44>
        s = va_arg(ap, char*);
 636:	008b8993          	addi	s3,s7,8
 63a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 63e:	02090163          	beqz	s2,660 <vprintf+0x158>
        while(*s != 0){
 642:	00094583          	lbu	a1,0(s2)
 646:	c9a5                	beqz	a1,6b6 <vprintf+0x1ae>
          putc(fd, *s);
 648:	8556                	mv	a0,s5
 64a:	00000097          	auipc	ra,0x0
 64e:	df0080e7          	jalr	-528(ra) # 43a <putc>
          s++;
 652:	0905                	addi	s2,s2,1
        while(*s != 0){
 654:	00094583          	lbu	a1,0(s2)
 658:	f9e5                	bnez	a1,648 <vprintf+0x140>
        s = va_arg(ap, char*);
 65a:	8bce                	mv	s7,s3
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b5fd                	j	54c <vprintf+0x44>
          s = "(null)";
 660:	00000917          	auipc	s2,0x0
 664:	25890913          	addi	s2,s2,600 # 8b8 <malloc+0xfe>
        while(*s != 0){
 668:	02800593          	li	a1,40
 66c:	bff1                	j	648 <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 66e:	008b8913          	addi	s2,s7,8
 672:	000bc583          	lbu	a1,0(s7)
 676:	8556                	mv	a0,s5
 678:	00000097          	auipc	ra,0x0
 67c:	dc2080e7          	jalr	-574(ra) # 43a <putc>
 680:	8bca                	mv	s7,s2
      state = 0;
 682:	4981                	li	s3,0
 684:	b5e1                	j	54c <vprintf+0x44>
        putc(fd, c);
 686:	02500593          	li	a1,37
 68a:	8556                	mv	a0,s5
 68c:	00000097          	auipc	ra,0x0
 690:	dae080e7          	jalr	-594(ra) # 43a <putc>
      state = 0;
 694:	4981                	li	s3,0
 696:	bd5d                	j	54c <vprintf+0x44>
        putc(fd, '%');
 698:	02500593          	li	a1,37
 69c:	8556                	mv	a0,s5
 69e:	00000097          	auipc	ra,0x0
 6a2:	d9c080e7          	jalr	-612(ra) # 43a <putc>
        putc(fd, c);
 6a6:	85ca                	mv	a1,s2
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	d90080e7          	jalr	-624(ra) # 43a <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd61                	j	54c <vprintf+0x44>
        s = va_arg(ap, char*);
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	bd49                	j	54c <vprintf+0x44>
    }
  }
}
 6bc:	60a6                	ld	ra,72(sp)
 6be:	6406                	ld	s0,64(sp)
 6c0:	74e2                	ld	s1,56(sp)
 6c2:	7942                	ld	s2,48(sp)
 6c4:	79a2                	ld	s3,40(sp)
 6c6:	7a02                	ld	s4,32(sp)
 6c8:	6ae2                	ld	s5,24(sp)
 6ca:	6b42                	ld	s6,16(sp)
 6cc:	6ba2                	ld	s7,8(sp)
 6ce:	6c02                	ld	s8,0(sp)
 6d0:	6161                	addi	sp,sp,80
 6d2:	8082                	ret

00000000000006d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6d4:	715d                	addi	sp,sp,-80
 6d6:	ec06                	sd	ra,24(sp)
 6d8:	e822                	sd	s0,16(sp)
 6da:	1000                	addi	s0,sp,32
 6dc:	e010                	sd	a2,0(s0)
 6de:	e414                	sd	a3,8(s0)
 6e0:	e818                	sd	a4,16(s0)
 6e2:	ec1c                	sd	a5,24(s0)
 6e4:	03043023          	sd	a6,32(s0)
 6e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6f0:	8622                	mv	a2,s0
 6f2:	00000097          	auipc	ra,0x0
 6f6:	e16080e7          	jalr	-490(ra) # 508 <vprintf>
}
 6fa:	60e2                	ld	ra,24(sp)
 6fc:	6442                	ld	s0,16(sp)
 6fe:	6161                	addi	sp,sp,80
 700:	8082                	ret

0000000000000702 <printf>:

void
printf(const char *fmt, ...)
{
 702:	711d                	addi	sp,sp,-96
 704:	ec06                	sd	ra,24(sp)
 706:	e822                	sd	s0,16(sp)
 708:	1000                	addi	s0,sp,32
 70a:	e40c                	sd	a1,8(s0)
 70c:	e810                	sd	a2,16(s0)
 70e:	ec14                	sd	a3,24(s0)
 710:	f018                	sd	a4,32(s0)
 712:	f41c                	sd	a5,40(s0)
 714:	03043823          	sd	a6,48(s0)
 718:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	00840613          	addi	a2,s0,8
 720:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 724:	85aa                	mv	a1,a0
 726:	4505                	li	a0,1
 728:	00000097          	auipc	ra,0x0
 72c:	de0080e7          	jalr	-544(ra) # 508 <vprintf>
}
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6125                	addi	sp,sp,96
 736:	8082                	ret

0000000000000738 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 738:	1141                	addi	sp,sp,-16
 73a:	e422                	sd	s0,8(sp)
 73c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	00001797          	auipc	a5,0x1
 746:	8be7b783          	ld	a5,-1858(a5) # 1000 <freep>
 74a:	a02d                	j	774 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 74c:	4618                	lw	a4,8(a2)
 74e:	9f2d                	addw	a4,a4,a1
 750:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 754:	6398                	ld	a4,0(a5)
 756:	6310                	ld	a2,0(a4)
 758:	a83d                	j	796 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 75a:	ff852703          	lw	a4,-8(a0)
 75e:	9f31                	addw	a4,a4,a2
 760:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 762:	ff053683          	ld	a3,-16(a0)
 766:	a091                	j	7aa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	6398                	ld	a4,0(a5)
 76a:	00e7e463          	bltu	a5,a4,772 <free+0x3a>
 76e:	00e6ea63          	bltu	a3,a4,782 <free+0x4a>
{
 772:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 774:	fed7fae3          	bgeu	a5,a3,768 <free+0x30>
 778:	6398                	ld	a4,0(a5)
 77a:	00e6e463          	bltu	a3,a4,782 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77e:	fee7eae3          	bltu	a5,a4,772 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 782:	ff852583          	lw	a1,-8(a0)
 786:	6390                	ld	a2,0(a5)
 788:	02059813          	slli	a6,a1,0x20
 78c:	01c85713          	srli	a4,a6,0x1c
 790:	9736                	add	a4,a4,a3
 792:	fae60de3          	beq	a2,a4,74c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 796:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 79a:	4790                	lw	a2,8(a5)
 79c:	02061593          	slli	a1,a2,0x20
 7a0:	01c5d713          	srli	a4,a1,0x1c
 7a4:	973e                	add	a4,a4,a5
 7a6:	fae68ae3          	beq	a3,a4,75a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ac:	00001717          	auipc	a4,0x1
 7b0:	84f73a23          	sd	a5,-1964(a4) # 1000 <freep>
}
 7b4:	6422                	ld	s0,8(sp)
 7b6:	0141                	addi	sp,sp,16
 7b8:	8082                	ret

00000000000007ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ba:	7139                	addi	sp,sp,-64
 7bc:	fc06                	sd	ra,56(sp)
 7be:	f822                	sd	s0,48(sp)
 7c0:	f426                	sd	s1,40(sp)
 7c2:	f04a                	sd	s2,32(sp)
 7c4:	ec4e                	sd	s3,24(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
 7cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ce:	02051493          	slli	s1,a0,0x20
 7d2:	9081                	srli	s1,s1,0x20
 7d4:	04bd                	addi	s1,s1,15
 7d6:	8091                	srli	s1,s1,0x4
 7d8:	0014899b          	addiw	s3,s1,1
 7dc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7de:	00001517          	auipc	a0,0x1
 7e2:	82253503          	ld	a0,-2014(a0) # 1000 <freep>
 7e6:	c515                	beqz	a0,812 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ea:	4798                	lw	a4,8(a5)
 7ec:	02977f63          	bgeu	a4,s1,82a <malloc+0x70>
  if(nu < 4096)
 7f0:	8a4e                	mv	s4,s3
 7f2:	0009871b          	sext.w	a4,s3
 7f6:	6685                	lui	a3,0x1
 7f8:	00d77363          	bgeu	a4,a3,7fe <malloc+0x44>
 7fc:	6a05                	lui	s4,0x1
 7fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 802:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 806:	00000917          	auipc	s2,0x0
 80a:	7fa90913          	addi	s2,s2,2042 # 1000 <freep>
  if(p == (char*)-1)
 80e:	5afd                	li	s5,-1
 810:	a895                	j	884 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 812:	00000797          	auipc	a5,0x0
 816:	7fe78793          	addi	a5,a5,2046 # 1010 <base>
 81a:	00000717          	auipc	a4,0x0
 81e:	7ef73323          	sd	a5,2022(a4) # 1000 <freep>
 822:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 824:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 828:	b7e1                	j	7f0 <malloc+0x36>
      if(p->s.size == nunits)
 82a:	02e48c63          	beq	s1,a4,862 <malloc+0xa8>
        p->s.size -= nunits;
 82e:	4137073b          	subw	a4,a4,s3
 832:	c798                	sw	a4,8(a5)
        p += p->s.size;
 834:	02071693          	slli	a3,a4,0x20
 838:	01c6d713          	srli	a4,a3,0x1c
 83c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 83e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 842:	00000717          	auipc	a4,0x0
 846:	7aa73f23          	sd	a0,1982(a4) # 1000 <freep>
      return (void*)(p + 1);
 84a:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 84e:	70e2                	ld	ra,56(sp)
 850:	7442                	ld	s0,48(sp)
 852:	74a2                	ld	s1,40(sp)
 854:	7902                	ld	s2,32(sp)
 856:	69e2                	ld	s3,24(sp)
 858:	6a42                	ld	s4,16(sp)
 85a:	6aa2                	ld	s5,8(sp)
 85c:	6b02                	ld	s6,0(sp)
 85e:	6121                	addi	sp,sp,64
 860:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 862:	6398                	ld	a4,0(a5)
 864:	e118                	sd	a4,0(a0)
 866:	bff1                	j	842 <malloc+0x88>
  hp->s.size = nu;
 868:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86c:	0541                	addi	a0,a0,16
 86e:	00000097          	auipc	ra,0x0
 872:	eca080e7          	jalr	-310(ra) # 738 <free>
  return freep;
 876:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87a:	d971                	beqz	a0,84e <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	fa9775e3          	bgeu	a4,s1,82a <malloc+0x70>
    if(p == freep)
 884:	00093703          	ld	a4,0(s2)
 888:	853e                	mv	a0,a5
 88a:	fef719e3          	bne	a4,a5,87c <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	00000097          	auipc	ra,0x0
 894:	b82080e7          	jalr	-1150(ra) # 412 <sbrk>
  if(p == (char*)-1)
 898:	fd5518e3          	bne	a0,s5,868 <malloc+0xae>
        return 0;
 89c:	4501                	li	a0,0
 89e:	bf45                	j	84e <malloc+0x94>
