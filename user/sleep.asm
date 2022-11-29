
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(argc <= 1){
   8:	4785                	li	a5,1
   a:	02a7d363          	bge	a5,a0,30 <main+0x30>
    fprintf(2, "usage: sheep [seconds]\n");
    exit(1);
  }

  int time = atoi(argv[1]);
   e:	6588                	ld	a0,8(a1)
  10:	00000097          	auipc	ra,0x0
  14:	1d2080e7          	jalr	466(ra) # 1e2 <atoi>
  if(sleep(time) == -1){
  18:	00000097          	auipc	ra,0x0
  1c:	354080e7          	jalr	852(ra) # 36c <sleep>
  20:	57fd                	li	a5,-1
  22:	02f50563          	beq	a0,a5,4c <main+0x4c>
    exit(1);
  }
  


  exit(0);
  26:	4501                	li	a0,0
  28:	00000097          	auipc	ra,0x0
  2c:	2b4080e7          	jalr	692(ra) # 2dc <exit>
    fprintf(2, "usage: sheep [seconds]\n");
  30:	00000597          	auipc	a1,0x0
  34:	7d058593          	addi	a1,a1,2000 # 800 <malloc+0xf4>
  38:	4509                	li	a0,2
  3a:	00000097          	auipc	ra,0x0
  3e:	5ec080e7          	jalr	1516(ra) # 626 <fprintf>
    exit(1);
  42:	4505                	li	a0,1
  44:	00000097          	auipc	ra,0x0
  48:	298080e7          	jalr	664(ra) # 2dc <exit>
    exit(1);
  4c:	4505                	li	a0,1
  4e:	00000097          	auipc	ra,0x0
  52:	28e080e7          	jalr	654(ra) # 2dc <exit>

0000000000000056 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5e:	00000097          	auipc	ra,0x0
  62:	fa2080e7          	jalr	-94(ra) # 0 <main>
  exit(0);
  66:	4501                	li	a0,0
  68:	00000097          	auipc	ra,0x0
  6c:	274080e7          	jalr	628(ra) # 2dc <exit>

0000000000000070 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  70:	1141                	addi	sp,sp,-16
  72:	e422                	sd	s0,8(sp)
  74:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  76:	87aa                	mv	a5,a0
  78:	0585                	addi	a1,a1,1
  7a:	0785                	addi	a5,a5,1
  7c:	fff5c703          	lbu	a4,-1(a1)
  80:	fee78fa3          	sb	a4,-1(a5)
  84:	fb75                	bnez	a4,78 <strcpy+0x8>
    ;
  return os;
}
  86:	6422                	ld	s0,8(sp)
  88:	0141                	addi	sp,sp,16
  8a:	8082                	ret

000000000000008c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	cb91                	beqz	a5,aa <strcmp+0x1e>
  98:	0005c703          	lbu	a4,0(a1)
  9c:	00f71763          	bne	a4,a5,aa <strcmp+0x1e>
    p++, q++;
  a0:	0505                	addi	a0,a0,1
  a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	fbe5                	bnez	a5,98 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  aa:	0005c503          	lbu	a0,0(a1)
}
  ae:	40a7853b          	subw	a0,a5,a0
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strlen>:

uint
strlen(const char *s)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cf91                	beqz	a5,de <strlen+0x26>
  c4:	0505                	addi	a0,a0,1
  c6:	87aa                	mv	a5,a0
  c8:	86be                	mv	a3,a5
  ca:	0785                	addi	a5,a5,1
  cc:	fff7c703          	lbu	a4,-1(a5)
  d0:	ff65                	bnez	a4,c8 <strlen+0x10>
  d2:	40a6853b          	subw	a0,a3,a0
  d6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  for(n = 0; s[n]; n++)
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strlen+0x20>

00000000000000e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e8:	ca19                	beqz	a2,fe <memset+0x1c>
  ea:	87aa                	mv	a5,a0
  ec:	1602                	slli	a2,a2,0x20
  ee:	9201                	srli	a2,a2,0x20
  f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f8:	0785                	addi	a5,a5,1
  fa:	fee79de3          	bne	a5,a4,f4 <memset+0x12>
  }
  return dst;
}
  fe:	6422                	ld	s0,8(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strchr>:

char*
strchr(const char *s, char c)
{
 104:	1141                	addi	sp,sp,-16
 106:	e422                	sd	s0,8(sp)
 108:	0800                	addi	s0,sp,16
  for(; *s; s++)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb99                	beqz	a5,124 <strchr+0x20>
    if(*s == c)
 110:	00f58763          	beq	a1,a5,11e <strchr+0x1a>
  for(; *s; s++)
 114:	0505                	addi	a0,a0,1
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbfd                	bnez	a5,110 <strchr+0xc>
      return (char*)s;
  return 0;
 11c:	4501                	li	a0,0
}
 11e:	6422                	ld	s0,8(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfe5                	j	11e <strchr+0x1a>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	1080                	addi	s0,sp,96
 13e:	8baa                	mv	s7,a0
 140:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	892a                	mv	s2,a0
 144:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 146:	4aa9                	li	s5,10
 148:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 14a:	89a6                	mv	s3,s1
 14c:	2485                	addiw	s1,s1,1
 14e:	0344d863          	bge	s1,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 152:	4605                	li	a2,1
 154:	faf40593          	addi	a1,s0,-81
 158:	4501                	li	a0,0
 15a:	00000097          	auipc	ra,0x0
 15e:	19a080e7          	jalr	410(ra) # 2f4 <read>
    if(cc < 1)
 162:	00a05e63          	blez	a0,17e <gets+0x56>
    buf[i++] = c;
 166:	faf44783          	lbu	a5,-81(s0)
 16a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 16e:	01578763          	beq	a5,s5,17c <gets+0x54>
 172:	0905                	addi	s2,s2,1
 174:	fd679be3          	bne	a5,s6,14a <gets+0x22>
  for(i=0; i+1 < max; ){
 178:	89a6                	mv	s3,s1
 17a:	a011                	j	17e <gets+0x56>
 17c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 17e:	99de                	add	s3,s3,s7
 180:	00098023          	sb	zero,0(s3)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6125                	addi	sp,sp,96
 19a:	8082                	ret

000000000000019c <stat>:

int
stat(const char *n, struct stat *st)
{
 19c:	1101                	addi	sp,sp,-32
 19e:	ec06                	sd	ra,24(sp)
 1a0:	e822                	sd	s0,16(sp)
 1a2:	e426                	sd	s1,8(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	00000097          	auipc	ra,0x0
 1b0:	170080e7          	jalr	368(ra) # 31c <open>
  if(fd < 0)
 1b4:	02054563          	bltz	a0,1de <stat+0x42>
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	00000097          	auipc	ra,0x0
 1c0:	178080e7          	jalr	376(ra) # 334 <fstat>
 1c4:	892a                	mv	s2,a0
  close(fd);
 1c6:	8526                	mv	a0,s1
 1c8:	00000097          	auipc	ra,0x0
 1cc:	13c080e7          	jalr	316(ra) # 304 <close>
  return r;
}
 1d0:	854a                	mv	a0,s2
 1d2:	60e2                	ld	ra,24(sp)
 1d4:	6442                	ld	s0,16(sp)
 1d6:	64a2                	ld	s1,8(sp)
 1d8:	6902                	ld	s2,0(sp)
 1da:	6105                	addi	sp,sp,32
 1dc:	8082                	ret
    return -1;
 1de:	597d                	li	s2,-1
 1e0:	bfc5                	j	1d0 <stat+0x34>

00000000000001e2 <atoi>:

int
atoi(const char *s)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e8:	00054683          	lbu	a3,0(a0)
 1ec:	fd06879b          	addiw	a5,a3,-48
 1f0:	0ff7f793          	zext.b	a5,a5
 1f4:	4625                	li	a2,9
 1f6:	02f66863          	bltu	a2,a5,226 <atoi+0x44>
 1fa:	872a                	mv	a4,a0
  n = 0;
 1fc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1fe:	0705                	addi	a4,a4,1
 200:	0025179b          	slliw	a5,a0,0x2
 204:	9fa9                	addw	a5,a5,a0
 206:	0017979b          	slliw	a5,a5,0x1
 20a:	9fb5                	addw	a5,a5,a3
 20c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 210:	00074683          	lbu	a3,0(a4)
 214:	fd06879b          	addiw	a5,a3,-48
 218:	0ff7f793          	zext.b	a5,a5
 21c:	fef671e3          	bgeu	a2,a5,1fe <atoi+0x1c>
  return n;
}
 220:	6422                	ld	s0,8(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfe5                	j	220 <atoi+0x3e>

000000000000022a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e422                	sd	s0,8(sp)
 22e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 230:	02b57463          	bgeu	a0,a1,258 <memmove+0x2e>
    while(n-- > 0)
 234:	00c05f63          	blez	a2,252 <memmove+0x28>
 238:	1602                	slli	a2,a2,0x20
 23a:	9201                	srli	a2,a2,0x20
 23c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 240:	872a                	mv	a4,a0
      *dst++ = *src++;
 242:	0585                	addi	a1,a1,1
 244:	0705                	addi	a4,a4,1
 246:	fff5c683          	lbu	a3,-1(a1)
 24a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24e:	fee79ae3          	bne	a5,a4,242 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 252:	6422                	ld	s0,8(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    dst += n;
 258:	00c50733          	add	a4,a0,a2
    src += n;
 25c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 25e:	fec05ae3          	blez	a2,252 <memmove+0x28>
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fee79ae3          	bne	a5,a4,270 <memmove+0x46>
 280:	bfc9                	j	252 <memmove+0x28>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e422                	sd	s0,8(sp)
 286:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 288:	ca05                	beqz	a2,2b8 <memcmp+0x36>
 28a:	fff6069b          	addiw	a3,a2,-1
 28e:	1682                	slli	a3,a3,0x20
 290:	9281                	srli	a3,a3,0x20
 292:	0685                	addi	a3,a3,1
 294:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 296:	00054783          	lbu	a5,0(a0)
 29a:	0005c703          	lbu	a4,0(a1)
 29e:	00e79863          	bne	a5,a4,2ae <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a2:	0505                	addi	a0,a0,1
    p2++;
 2a4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a6:	fed518e3          	bne	a0,a3,296 <memcmp+0x14>
  }
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	a019                	j	2b2 <memcmp+0x30>
      return *p1 - *p2;
 2ae:	40e7853b          	subw	a0,a5,a4
}
 2b2:	6422                	ld	s0,8(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfe5                	j	2b2 <memcmp+0x30>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	00000097          	auipc	ra,0x0
 2c8:	f66080e7          	jalr	-154(ra) # 22a <memmove>
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d4:	4885                	li	a7,1
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2dc:	4889                	li	a7,2
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e4:	488d                	li	a7,3
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ec:	4891                	li	a7,4
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <read>:
.global read
read:
 li a7, SYS_read
 2f4:	4895                	li	a7,5
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <write>:
.global write
write:
 li a7, SYS_write
 2fc:	48c1                	li	a7,16
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <close>:
.global close
close:
 li a7, SYS_close
 304:	48d5                	li	a7,21
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <kill>:
.global kill
kill:
 li a7, SYS_kill
 30c:	4899                	li	a7,6
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exec>:
.global exec
exec:
 li a7, SYS_exec
 314:	489d                	li	a7,7
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <open>:
.global open
open:
 li a7, SYS_open
 31c:	48bd                	li	a7,15
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 324:	48c5                	li	a7,17
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32c:	48c9                	li	a7,18
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 334:	48a1                	li	a7,8
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <link>:
.global link
link:
 li a7, SYS_link
 33c:	48cd                	li	a7,19
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 344:	48d1                	li	a7,20
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34c:	48a5                	li	a7,9
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <dup>:
.global dup
dup:
 li a7, SYS_dup
 354:	48a9                	li	a7,10
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35c:	48ad                	li	a7,11
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 364:	48b1                	li	a7,12
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 36c:	48b5                	li	a7,13
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 374:	48b9                	li	a7,14
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <trace>:
.global trace
trace:
 li a7, SYS_trace
 37c:	48d9                	li	a7,22
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sysinfo>:
.global sysinfo
sysinfo:
 li a7, SYS_sysinfo
 384:	48dd                	li	a7,23
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	00000097          	auipc	ra,0x0
 3a2:	f5e080e7          	jalr	-162(ra) # 2fc <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	7139                	addi	sp,sp,-64
 3b0:	fc06                	sd	ra,56(sp)
 3b2:	f822                	sd	s0,48(sp)
 3b4:	f426                	sd	s1,40(sp)
 3b6:	f04a                	sd	s2,32(sp)
 3b8:	ec4e                	sd	s3,24(sp)
 3ba:	0080                	addi	s0,sp,64
 3bc:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3be:	c299                	beqz	a3,3c4 <printint+0x16>
 3c0:	0805c963          	bltz	a1,452 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3c4:	2581                	sext.w	a1,a1
  neg = 0;
 3c6:	4881                	li	a7,0
 3c8:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3cc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ce:	2601                	sext.w	a2,a2
 3d0:	00000517          	auipc	a0,0x0
 3d4:	4a850513          	addi	a0,a0,1192 # 878 <digits>
 3d8:	883a                	mv	a6,a4
 3da:	2705                	addiw	a4,a4,1
 3dc:	02c5f7bb          	remuw	a5,a1,a2
 3e0:	1782                	slli	a5,a5,0x20
 3e2:	9381                	srli	a5,a5,0x20
 3e4:	97aa                	add	a5,a5,a0
 3e6:	0007c783          	lbu	a5,0(a5)
 3ea:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3ee:	0005879b          	sext.w	a5,a1
 3f2:	02c5d5bb          	divuw	a1,a1,a2
 3f6:	0685                	addi	a3,a3,1
 3f8:	fec7f0e3          	bgeu	a5,a2,3d8 <printint+0x2a>
  if(neg)
 3fc:	00088c63          	beqz	a7,414 <printint+0x66>
    buf[i++] = '-';
 400:	fd070793          	addi	a5,a4,-48
 404:	00878733          	add	a4,a5,s0
 408:	02d00793          	li	a5,45
 40c:	fef70823          	sb	a5,-16(a4)
 410:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 414:	02e05863          	blez	a4,444 <printint+0x96>
 418:	fc040793          	addi	a5,s0,-64
 41c:	00e78933          	add	s2,a5,a4
 420:	fff78993          	addi	s3,a5,-1
 424:	99ba                	add	s3,s3,a4
 426:	377d                	addiw	a4,a4,-1
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	fff94583          	lbu	a1,-1(s2)
 434:	8526                	mv	a0,s1
 436:	00000097          	auipc	ra,0x0
 43a:	f56080e7          	jalr	-170(ra) # 38c <putc>
  while(--i >= 0)
 43e:	197d                	addi	s2,s2,-1
 440:	ff3918e3          	bne	s2,s3,430 <printint+0x82>
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	74a2                	ld	s1,40(sp)
 44a:	7902                	ld	s2,32(sp)
 44c:	69e2                	ld	s3,24(sp)
 44e:	6121                	addi	sp,sp,64
 450:	8082                	ret
    x = -xx;
 452:	40b005bb          	negw	a1,a1
    neg = 1;
 456:	4885                	li	a7,1
    x = -xx;
 458:	bf85                	j	3c8 <printint+0x1a>

000000000000045a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45a:	715d                	addi	sp,sp,-80
 45c:	e486                	sd	ra,72(sp)
 45e:	e0a2                	sd	s0,64(sp)
 460:	fc26                	sd	s1,56(sp)
 462:	f84a                	sd	s2,48(sp)
 464:	f44e                	sd	s3,40(sp)
 466:	f052                	sd	s4,32(sp)
 468:	ec56                	sd	s5,24(sp)
 46a:	e85a                	sd	s6,16(sp)
 46c:	e45e                	sd	s7,8(sp)
 46e:	e062                	sd	s8,0(sp)
 470:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 472:	0005c903          	lbu	s2,0(a1)
 476:	18090c63          	beqz	s2,60e <vprintf+0x1b4>
 47a:	8aaa                	mv	s5,a0
 47c:	8bb2                	mv	s7,a2
 47e:	00158493          	addi	s1,a1,1
  state = 0;
 482:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 484:	02500a13          	li	s4,37
 488:	4b55                	li	s6,21
 48a:	a839                	j	4a8 <vprintf+0x4e>
        putc(fd, c);
 48c:	85ca                	mv	a1,s2
 48e:	8556                	mv	a0,s5
 490:	00000097          	auipc	ra,0x0
 494:	efc080e7          	jalr	-260(ra) # 38c <putc>
 498:	a019                	j	49e <vprintf+0x44>
    } else if(state == '%'){
 49a:	01498d63          	beq	s3,s4,4b4 <vprintf+0x5a>
  for(i = 0; fmt[i]; i++){
 49e:	0485                	addi	s1,s1,1
 4a0:	fff4c903          	lbu	s2,-1(s1)
 4a4:	16090563          	beqz	s2,60e <vprintf+0x1b4>
    if(state == 0){
 4a8:	fe0999e3          	bnez	s3,49a <vprintf+0x40>
      if(c == '%'){
 4ac:	ff4910e3          	bne	s2,s4,48c <vprintf+0x32>
        state = '%';
 4b0:	89d2                	mv	s3,s4
 4b2:	b7f5                	j	49e <vprintf+0x44>
      if(c == 'd'){
 4b4:	13490263          	beq	s2,s4,5d8 <vprintf+0x17e>
 4b8:	f9d9079b          	addiw	a5,s2,-99
 4bc:	0ff7f793          	zext.b	a5,a5
 4c0:	12fb6563          	bltu	s6,a5,5ea <vprintf+0x190>
 4c4:	f9d9079b          	addiw	a5,s2,-99
 4c8:	0ff7f713          	zext.b	a4,a5
 4cc:	10eb6f63          	bltu	s6,a4,5ea <vprintf+0x190>
 4d0:	00271793          	slli	a5,a4,0x2
 4d4:	00000717          	auipc	a4,0x0
 4d8:	34c70713          	addi	a4,a4,844 # 820 <malloc+0x114>
 4dc:	97ba                	add	a5,a5,a4
 4de:	439c                	lw	a5,0(a5)
 4e0:	97ba                	add	a5,a5,a4
 4e2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4e4:	008b8913          	addi	s2,s7,8
 4e8:	4685                	li	a3,1
 4ea:	4629                	li	a2,10
 4ec:	000ba583          	lw	a1,0(s7)
 4f0:	8556                	mv	a0,s5
 4f2:	00000097          	auipc	ra,0x0
 4f6:	ebc080e7          	jalr	-324(ra) # 3ae <printint>
 4fa:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4fc:	4981                	li	s3,0
 4fe:	b745                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 500:	008b8913          	addi	s2,s7,8
 504:	4681                	li	a3,0
 506:	4629                	li	a2,10
 508:	000ba583          	lw	a1,0(s7)
 50c:	8556                	mv	a0,s5
 50e:	00000097          	auipc	ra,0x0
 512:	ea0080e7          	jalr	-352(ra) # 3ae <printint>
 516:	8bca                	mv	s7,s2
      state = 0;
 518:	4981                	li	s3,0
 51a:	b751                	j	49e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 16, 0);
 51c:	008b8913          	addi	s2,s7,8
 520:	4681                	li	a3,0
 522:	4641                	li	a2,16
 524:	000ba583          	lw	a1,0(s7)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	e84080e7          	jalr	-380(ra) # 3ae <printint>
 532:	8bca                	mv	s7,s2
      state = 0;
 534:	4981                	li	s3,0
 536:	b7a5                	j	49e <vprintf+0x44>
        printptr(fd, va_arg(ap, uint64));
 538:	008b8c13          	addi	s8,s7,8
 53c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 540:	03000593          	li	a1,48
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	e46080e7          	jalr	-442(ra) # 38c <putc>
  putc(fd, 'x');
 54e:	07800593          	li	a1,120
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e38080e7          	jalr	-456(ra) # 38c <putc>
 55c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55e:	00000b97          	auipc	s7,0x0
 562:	31ab8b93          	addi	s7,s7,794 # 878 <digits>
 566:	03c9d793          	srli	a5,s3,0x3c
 56a:	97de                	add	a5,a5,s7
 56c:	0007c583          	lbu	a1,0(a5)
 570:	8556                	mv	a0,s5
 572:	00000097          	auipc	ra,0x0
 576:	e1a080e7          	jalr	-486(ra) # 38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 57a:	0992                	slli	s3,s3,0x4
 57c:	397d                	addiw	s2,s2,-1
 57e:	fe0914e3          	bnez	s2,566 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 582:	8be2                	mv	s7,s8
      state = 0;
 584:	4981                	li	s3,0
 586:	bf21                	j	49e <vprintf+0x44>
        s = va_arg(ap, char*);
 588:	008b8993          	addi	s3,s7,8
 58c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 590:	02090163          	beqz	s2,5b2 <vprintf+0x158>
        while(*s != 0){
 594:	00094583          	lbu	a1,0(s2)
 598:	c9a5                	beqz	a1,608 <vprintf+0x1ae>
          putc(fd, *s);
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	df0080e7          	jalr	-528(ra) # 38c <putc>
          s++;
 5a4:	0905                	addi	s2,s2,1
        while(*s != 0){
 5a6:	00094583          	lbu	a1,0(s2)
 5aa:	f9e5                	bnez	a1,59a <vprintf+0x140>
        s = va_arg(ap, char*);
 5ac:	8bce                	mv	s7,s3
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5fd                	j	49e <vprintf+0x44>
          s = "(null)";
 5b2:	00000917          	auipc	s2,0x0
 5b6:	26690913          	addi	s2,s2,614 # 818 <malloc+0x10c>
        while(*s != 0){
 5ba:	02800593          	li	a1,40
 5be:	bff1                	j	59a <vprintf+0x140>
        putc(fd, va_arg(ap, uint));
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	000bc583          	lbu	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	dc2080e7          	jalr	-574(ra) # 38c <putc>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b5e1                	j	49e <vprintf+0x44>
        putc(fd, c);
 5d8:	02500593          	li	a1,37
 5dc:	8556                	mv	a0,s5
 5de:	00000097          	auipc	ra,0x0
 5e2:	dae080e7          	jalr	-594(ra) # 38c <putc>
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bd5d                	j	49e <vprintf+0x44>
        putc(fd, '%');
 5ea:	02500593          	li	a1,37
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	d9c080e7          	jalr	-612(ra) # 38c <putc>
        putc(fd, c);
 5f8:	85ca                	mv	a1,s2
 5fa:	8556                	mv	a0,s5
 5fc:	00000097          	auipc	ra,0x0
 600:	d90080e7          	jalr	-624(ra) # 38c <putc>
      state = 0;
 604:	4981                	li	s3,0
 606:	bd61                	j	49e <vprintf+0x44>
        s = va_arg(ap, char*);
 608:	8bce                	mv	s7,s3
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bd49                	j	49e <vprintf+0x44>
    }
  }
}
 60e:	60a6                	ld	ra,72(sp)
 610:	6406                	ld	s0,64(sp)
 612:	74e2                	ld	s1,56(sp)
 614:	7942                	ld	s2,48(sp)
 616:	79a2                	ld	s3,40(sp)
 618:	7a02                	ld	s4,32(sp)
 61a:	6ae2                	ld	s5,24(sp)
 61c:	6b42                	ld	s6,16(sp)
 61e:	6ba2                	ld	s7,8(sp)
 620:	6c02                	ld	s8,0(sp)
 622:	6161                	addi	sp,sp,80
 624:	8082                	ret

0000000000000626 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 626:	715d                	addi	sp,sp,-80
 628:	ec06                	sd	ra,24(sp)
 62a:	e822                	sd	s0,16(sp)
 62c:	1000                	addi	s0,sp,32
 62e:	e010                	sd	a2,0(s0)
 630:	e414                	sd	a3,8(s0)
 632:	e818                	sd	a4,16(s0)
 634:	ec1c                	sd	a5,24(s0)
 636:	03043023          	sd	a6,32(s0)
 63a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 642:	8622                	mv	a2,s0
 644:	00000097          	auipc	ra,0x0
 648:	e16080e7          	jalr	-490(ra) # 45a <vprintf>
}
 64c:	60e2                	ld	ra,24(sp)
 64e:	6442                	ld	s0,16(sp)
 650:	6161                	addi	sp,sp,80
 652:	8082                	ret

0000000000000654 <printf>:

void
printf(const char *fmt, ...)
{
 654:	711d                	addi	sp,sp,-96
 656:	ec06                	sd	ra,24(sp)
 658:	e822                	sd	s0,16(sp)
 65a:	1000                	addi	s0,sp,32
 65c:	e40c                	sd	a1,8(s0)
 65e:	e810                	sd	a2,16(s0)
 660:	ec14                	sd	a3,24(s0)
 662:	f018                	sd	a4,32(s0)
 664:	f41c                	sd	a5,40(s0)
 666:	03043823          	sd	a6,48(s0)
 66a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66e:	00840613          	addi	a2,s0,8
 672:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 676:	85aa                	mv	a1,a0
 678:	4505                	li	a0,1
 67a:	00000097          	auipc	ra,0x0
 67e:	de0080e7          	jalr	-544(ra) # 45a <vprintf>
}
 682:	60e2                	ld	ra,24(sp)
 684:	6442                	ld	s0,16(sp)
 686:	6125                	addi	sp,sp,96
 688:	8082                	ret

000000000000068a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68a:	1141                	addi	sp,sp,-16
 68c:	e422                	sd	s0,8(sp)
 68e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 690:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 694:	00001797          	auipc	a5,0x1
 698:	96c7b783          	ld	a5,-1684(a5) # 1000 <freep>
 69c:	a02d                	j	6c6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69e:	4618                	lw	a4,8(a2)
 6a0:	9f2d                	addw	a4,a4,a1
 6a2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a6:	6398                	ld	a4,0(a5)
 6a8:	6310                	ld	a2,0(a4)
 6aa:	a83d                	j	6e8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6ac:	ff852703          	lw	a4,-8(a0)
 6b0:	9f31                	addw	a4,a4,a2
 6b2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b4:	ff053683          	ld	a3,-16(a0)
 6b8:	a091                	j	6fc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ba:	6398                	ld	a4,0(a5)
 6bc:	00e7e463          	bltu	a5,a4,6c4 <free+0x3a>
 6c0:	00e6ea63          	bltu	a3,a4,6d4 <free+0x4a>
{
 6c4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c6:	fed7fae3          	bgeu	a5,a3,6ba <free+0x30>
 6ca:	6398                	ld	a4,0(a5)
 6cc:	00e6e463          	bltu	a3,a4,6d4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6d0:	fee7eae3          	bltu	a5,a4,6c4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d4:	ff852583          	lw	a1,-8(a0)
 6d8:	6390                	ld	a2,0(a5)
 6da:	02059813          	slli	a6,a1,0x20
 6de:	01c85713          	srli	a4,a6,0x1c
 6e2:	9736                	add	a4,a4,a3
 6e4:	fae60de3          	beq	a2,a4,69e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ec:	4790                	lw	a2,8(a5)
 6ee:	02061593          	slli	a1,a2,0x20
 6f2:	01c5d713          	srli	a4,a1,0x1c
 6f6:	973e                	add	a4,a4,a5
 6f8:	fae68ae3          	beq	a3,a4,6ac <free+0x22>
    p->s.ptr = bp->s.ptr;
 6fc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fe:	00001717          	auipc	a4,0x1
 702:	90f73123          	sd	a5,-1790(a4) # 1000 <freep>
}
 706:	6422                	ld	s0,8(sp)
 708:	0141                	addi	sp,sp,16
 70a:	8082                	ret

000000000000070c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 70c:	7139                	addi	sp,sp,-64
 70e:	fc06                	sd	ra,56(sp)
 710:	f822                	sd	s0,48(sp)
 712:	f426                	sd	s1,40(sp)
 714:	f04a                	sd	s2,32(sp)
 716:	ec4e                	sd	s3,24(sp)
 718:	e852                	sd	s4,16(sp)
 71a:	e456                	sd	s5,8(sp)
 71c:	e05a                	sd	s6,0(sp)
 71e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 720:	02051493          	slli	s1,a0,0x20
 724:	9081                	srli	s1,s1,0x20
 726:	04bd                	addi	s1,s1,15
 728:	8091                	srli	s1,s1,0x4
 72a:	0014899b          	addiw	s3,s1,1
 72e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 730:	00001517          	auipc	a0,0x1
 734:	8d053503          	ld	a0,-1840(a0) # 1000 <freep>
 738:	c515                	beqz	a0,764 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 73a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 73c:	4798                	lw	a4,8(a5)
 73e:	02977f63          	bgeu	a4,s1,77c <malloc+0x70>
  if(nu < 4096)
 742:	8a4e                	mv	s4,s3
 744:	0009871b          	sext.w	a4,s3
 748:	6685                	lui	a3,0x1
 74a:	00d77363          	bgeu	a4,a3,750 <malloc+0x44>
 74e:	6a05                	lui	s4,0x1
 750:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 754:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 758:	00001917          	auipc	s2,0x1
 75c:	8a890913          	addi	s2,s2,-1880 # 1000 <freep>
  if(p == (char*)-1)
 760:	5afd                	li	s5,-1
 762:	a895                	j	7d6 <malloc+0xca>
    base.s.ptr = freep = prevp = &base;
 764:	00001797          	auipc	a5,0x1
 768:	8ac78793          	addi	a5,a5,-1876 # 1010 <base>
 76c:	00001717          	auipc	a4,0x1
 770:	88f73a23          	sd	a5,-1900(a4) # 1000 <freep>
 774:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 776:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 77a:	b7e1                	j	742 <malloc+0x36>
      if(p->s.size == nunits)
 77c:	02e48c63          	beq	s1,a4,7b4 <malloc+0xa8>
        p->s.size -= nunits;
 780:	4137073b          	subw	a4,a4,s3
 784:	c798                	sw	a4,8(a5)
        p += p->s.size;
 786:	02071693          	slli	a3,a4,0x20
 78a:	01c6d713          	srli	a4,a3,0x1c
 78e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 790:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 794:	00001717          	auipc	a4,0x1
 798:	86a73623          	sd	a0,-1940(a4) # 1000 <freep>
      return (void*)(p + 1);
 79c:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7a0:	70e2                	ld	ra,56(sp)
 7a2:	7442                	ld	s0,48(sp)
 7a4:	74a2                	ld	s1,40(sp)
 7a6:	7902                	ld	s2,32(sp)
 7a8:	69e2                	ld	s3,24(sp)
 7aa:	6a42                	ld	s4,16(sp)
 7ac:	6aa2                	ld	s5,8(sp)
 7ae:	6b02                	ld	s6,0(sp)
 7b0:	6121                	addi	sp,sp,64
 7b2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 7b4:	6398                	ld	a4,0(a5)
 7b6:	e118                	sd	a4,0(a0)
 7b8:	bff1                	j	794 <malloc+0x88>
  hp->s.size = nu;
 7ba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7be:	0541                	addi	a0,a0,16
 7c0:	00000097          	auipc	ra,0x0
 7c4:	eca080e7          	jalr	-310(ra) # 68a <free>
  return freep;
 7c8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7cc:	d971                	beqz	a0,7a0 <malloc+0x94>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d0:	4798                	lw	a4,8(a5)
 7d2:	fa9775e3          	bgeu	a4,s1,77c <malloc+0x70>
    if(p == freep)
 7d6:	00093703          	ld	a4,0(s2)
 7da:	853e                	mv	a0,a5
 7dc:	fef719e3          	bne	a4,a5,7ce <malloc+0xc2>
  p = sbrk(nu * sizeof(Header));
 7e0:	8552                	mv	a0,s4
 7e2:	00000097          	auipc	ra,0x0
 7e6:	b82080e7          	jalr	-1150(ra) # 364 <sbrk>
  if(p == (char*)-1)
 7ea:	fd5518e3          	bne	a0,s5,7ba <malloc+0xae>
        return 0;
 7ee:	4501                	li	a0,0
 7f0:	bf45                	j	7a0 <malloc+0x94>
