
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	08010113          	addi	sp,sp,128 # 8001a080 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	7a0050ef          	jal	ra,800057b6 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e3bd                	bnez	a5,80000092 <kfree+0x76>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00022797          	auipc	a5,0x22
    80000034:	15078793          	addi	a5,a5,336 # 80022180 <end>
    80000038:	04f56d63          	bltu	a0,a5,80000092 <kfree+0x76>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57963          	bgeu	a0,a5,80000092 <kfree+0x76>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	16a080e7          	jalr	362(ra) # 800001b2 <memset>

  

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	ac090913          	addi	s2,s2,-1344 # 80008b10 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	144080e7          	jalr	324(ra) # 8000619e <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  freemem += PGSIZE;
    8000006c:	00009717          	auipc	a4,0x9
    80000070:	a2470713          	addi	a4,a4,-1500 # 80008a90 <freemem>
    80000074:	631c                	ld	a5,0(a4)
    80000076:	6685                	lui	a3,0x1
    80000078:	97b6                	add	a5,a5,a3
    8000007a:	e31c                	sd	a5,0(a4)
  release(&kmem.lock);
    8000007c:	854a                	mv	a0,s2
    8000007e:	00006097          	auipc	ra,0x6
    80000082:	1d4080e7          	jalr	468(ra) # 80006252 <release>
}
    80000086:	60e2                	ld	ra,24(sp)
    80000088:	6442                	ld	s0,16(sp)
    8000008a:	64a2                	ld	s1,8(sp)
    8000008c:	6902                	ld	s2,0(sp)
    8000008e:	6105                	addi	sp,sp,32
    80000090:	8082                	ret
    panic("kfree");
    80000092:	00008517          	auipc	a0,0x8
    80000096:	f7e50513          	addi	a0,a0,-130 # 80008010 <etext+0x10>
    8000009a:	00006097          	auipc	ra,0x6
    8000009e:	bcc080e7          	jalr	-1076(ra) # 80005c66 <panic>

00000000800000a2 <freerange>:
{
    800000a2:	7179                	addi	sp,sp,-48
    800000a4:	f406                	sd	ra,40(sp)
    800000a6:	f022                	sd	s0,32(sp)
    800000a8:	ec26                	sd	s1,24(sp)
    800000aa:	e84a                	sd	s2,16(sp)
    800000ac:	e44e                	sd	s3,8(sp)
    800000ae:	e052                	sd	s4,0(sp)
    800000b0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000b2:	6785                	lui	a5,0x1
    800000b4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000b8:	00e504b3          	add	s1,a0,a4
    800000bc:	777d                	lui	a4,0xfffff
    800000be:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c0:	94be                	add	s1,s1,a5
    800000c2:	0095ee63          	bltu	a1,s1,800000de <freerange+0x3c>
    800000c6:	892e                	mv	s2,a1
    kfree(p);
    800000c8:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ca:	6985                	lui	s3,0x1
    kfree(p);
    800000cc:	01448533          	add	a0,s1,s4
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000d8:	94ce                	add	s1,s1,s3
    800000da:	fe9979e3          	bgeu	s2,s1,800000cc <freerange+0x2a>
}
    800000de:	70a2                	ld	ra,40(sp)
    800000e0:	7402                	ld	s0,32(sp)
    800000e2:	64e2                	ld	s1,24(sp)
    800000e4:	6942                	ld	s2,16(sp)
    800000e6:	69a2                	ld	s3,8(sp)
    800000e8:	6a02                	ld	s4,0(sp)
    800000ea:	6145                	addi	sp,sp,48
    800000ec:	8082                	ret

00000000800000ee <kinit>:
{
    800000ee:	1141                	addi	sp,sp,-16
    800000f0:	e406                	sd	ra,8(sp)
    800000f2:	e022                	sd	s0,0(sp)
    800000f4:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000f6:	00008597          	auipc	a1,0x8
    800000fa:	f2258593          	addi	a1,a1,-222 # 80008018 <etext+0x18>
    800000fe:	00009517          	auipc	a0,0x9
    80000102:	a1250513          	addi	a0,a0,-1518 # 80008b10 <kmem>
    80000106:	00006097          	auipc	ra,0x6
    8000010a:	008080e7          	jalr	8(ra) # 8000610e <initlock>
  freerange(end, (void*)PHYSTOP);
    8000010e:	45c5                	li	a1,17
    80000110:	05ee                	slli	a1,a1,0x1b
    80000112:	00022517          	auipc	a0,0x22
    80000116:	06e50513          	addi	a0,a0,110 # 80022180 <end>
    8000011a:	00000097          	auipc	ra,0x0
    8000011e:	f88080e7          	jalr	-120(ra) # 800000a2 <freerange>
}
    80000122:	60a2                	ld	ra,8(sp)
    80000124:	6402                	ld	s0,0(sp)
    80000126:	0141                	addi	sp,sp,16
    80000128:	8082                	ret

000000008000012a <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000012a:	1101                	addi	sp,sp,-32
    8000012c:	ec06                	sd	ra,24(sp)
    8000012e:	e822                	sd	s0,16(sp)
    80000130:	e426                	sd	s1,8(sp)
    80000132:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000134:	00009497          	auipc	s1,0x9
    80000138:	9dc48493          	addi	s1,s1,-1572 # 80008b10 <kmem>
    8000013c:	8526                	mv	a0,s1
    8000013e:	00006097          	auipc	ra,0x6
    80000142:	060080e7          	jalr	96(ra) # 8000619e <acquire>
  r = kmem.freelist;
    80000146:	6c84                	ld	s1,24(s1)
  if(r){
    80000148:	c0a1                	beqz	s1,80000188 <kalloc+0x5e>
    kmem.freelist = r->next;
    8000014a:	609c                	ld	a5,0(s1)
    8000014c:	00009517          	auipc	a0,0x9
    80000150:	9c450513          	addi	a0,a0,-1596 # 80008b10 <kmem>
    80000154:	ed1c                	sd	a5,24(a0)
    freemem -= PGSIZE;
    80000156:	00009717          	auipc	a4,0x9
    8000015a:	93a70713          	addi	a4,a4,-1734 # 80008a90 <freemem>
    8000015e:	631c                	ld	a5,0(a4)
    80000160:	76fd                	lui	a3,0xfffff
    80000162:	97b6                	add	a5,a5,a3
    80000164:	e31c                	sd	a5,0(a4)
  }
  release(&kmem.lock);
    80000166:	00006097          	auipc	ra,0x6
    8000016a:	0ec080e7          	jalr	236(ra) # 80006252 <release>

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000016e:	6605                	lui	a2,0x1
    80000170:	4595                	li	a1,5
    80000172:	8526                	mv	a0,s1
    80000174:	00000097          	auipc	ra,0x0
    80000178:	03e080e7          	jalr	62(ra) # 800001b2 <memset>
  }
  return (void*)r;
}
    8000017c:	8526                	mv	a0,s1
    8000017e:	60e2                	ld	ra,24(sp)
    80000180:	6442                	ld	s0,16(sp)
    80000182:	64a2                	ld	s1,8(sp)
    80000184:	6105                	addi	sp,sp,32
    80000186:	8082                	ret
  release(&kmem.lock);
    80000188:	00009517          	auipc	a0,0x9
    8000018c:	98850513          	addi	a0,a0,-1656 # 80008b10 <kmem>
    80000190:	00006097          	auipc	ra,0x6
    80000194:	0c2080e7          	jalr	194(ra) # 80006252 <release>
  if(r){
    80000198:	b7d5                	j	8000017c <kalloc+0x52>

000000008000019a <kfreemem>:


void kfreemem(struct sysinfo* info){
    8000019a:	1141                	addi	sp,sp,-16
    8000019c:	e422                	sd	s0,8(sp)
    8000019e:	0800                	addi	s0,sp,16
  
  info->freemem = freemem + 1;
    800001a0:	00009797          	auipc	a5,0x9
    800001a4:	8f07b783          	ld	a5,-1808(a5) # 80008a90 <freemem>
    800001a8:	0785                	addi	a5,a5,1
    800001aa:	e11c                	sd	a5,0(a0)
  
    800001ac:	6422                	ld	s0,8(sp)
    800001ae:	0141                	addi	sp,sp,16
    800001b0:	8082                	ret

00000000800001b2 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e422                	sd	s0,8(sp)
    800001b6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800001b8:	ca19                	beqz	a2,800001ce <memset+0x1c>
    800001ba:	87aa                	mv	a5,a0
    800001bc:	1602                	slli	a2,a2,0x20
    800001be:	9201                	srli	a2,a2,0x20
    800001c0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800001c4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800001c8:	0785                	addi	a5,a5,1
    800001ca:	fee79de3          	bne	a5,a4,800001c4 <memset+0x12>
  }
  return dst;
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret

00000000800001d4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800001d4:	1141                	addi	sp,sp,-16
    800001d6:	e422                	sd	s0,8(sp)
    800001d8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001da:	ca05                	beqz	a2,8000020a <memcmp+0x36>
    800001dc:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    800001e0:	1682                	slli	a3,a3,0x20
    800001e2:	9281                	srli	a3,a3,0x20
    800001e4:	0685                	addi	a3,a3,1 # fffffffffffff001 <end+0xffffffff7ffdce81>
    800001e6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001e8:	00054783          	lbu	a5,0(a0)
    800001ec:	0005c703          	lbu	a4,0(a1)
    800001f0:	00e79863          	bne	a5,a4,80000200 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001f4:	0505                	addi	a0,a0,1
    800001f6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001f8:	fed518e3          	bne	a0,a3,800001e8 <memcmp+0x14>
  }

  return 0;
    800001fc:	4501                	li	a0,0
    800001fe:	a019                	j	80000204 <memcmp+0x30>
      return *s1 - *s2;
    80000200:	40e7853b          	subw	a0,a5,a4
}
    80000204:	6422                	ld	s0,8(sp)
    80000206:	0141                	addi	sp,sp,16
    80000208:	8082                	ret
  return 0;
    8000020a:	4501                	li	a0,0
    8000020c:	bfe5                	j	80000204 <memcmp+0x30>

000000008000020e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000020e:	1141                	addi	sp,sp,-16
    80000210:	e422                	sd	s0,8(sp)
    80000212:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000214:	c205                	beqz	a2,80000234 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000216:	02a5e263          	bltu	a1,a0,8000023a <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000021a:	1602                	slli	a2,a2,0x20
    8000021c:	9201                	srli	a2,a2,0x20
    8000021e:	00c587b3          	add	a5,a1,a2
{
    80000222:	872a                	mv	a4,a0
      *d++ = *s++;
    80000224:	0585                	addi	a1,a1,1
    80000226:	0705                	addi	a4,a4,1
    80000228:	fff5c683          	lbu	a3,-1(a1)
    8000022c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000230:	fef59ae3          	bne	a1,a5,80000224 <memmove+0x16>

  return dst;
}
    80000234:	6422                	ld	s0,8(sp)
    80000236:	0141                	addi	sp,sp,16
    80000238:	8082                	ret
  if(s < d && s + n > d){
    8000023a:	02061693          	slli	a3,a2,0x20
    8000023e:	9281                	srli	a3,a3,0x20
    80000240:	00d58733          	add	a4,a1,a3
    80000244:	fce57be3          	bgeu	a0,a4,8000021a <memmove+0xc>
    d += n;
    80000248:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000024a:	fff6079b          	addiw	a5,a2,-1
    8000024e:	1782                	slli	a5,a5,0x20
    80000250:	9381                	srli	a5,a5,0x20
    80000252:	fff7c793          	not	a5,a5
    80000256:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000258:	177d                	addi	a4,a4,-1
    8000025a:	16fd                	addi	a3,a3,-1
    8000025c:	00074603          	lbu	a2,0(a4)
    80000260:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000264:	fee79ae3          	bne	a5,a4,80000258 <memmove+0x4a>
    80000268:	b7f1                	j	80000234 <memmove+0x26>

000000008000026a <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000026a:	1141                	addi	sp,sp,-16
    8000026c:	e406                	sd	ra,8(sp)
    8000026e:	e022                	sd	s0,0(sp)
    80000270:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000272:	00000097          	auipc	ra,0x0
    80000276:	f9c080e7          	jalr	-100(ra) # 8000020e <memmove>
}
    8000027a:	60a2                	ld	ra,8(sp)
    8000027c:	6402                	ld	s0,0(sp)
    8000027e:	0141                	addi	sp,sp,16
    80000280:	8082                	ret

0000000080000282 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000282:	1141                	addi	sp,sp,-16
    80000284:	e422                	sd	s0,8(sp)
    80000286:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000288:	ce11                	beqz	a2,800002a4 <strncmp+0x22>
    8000028a:	00054783          	lbu	a5,0(a0)
    8000028e:	cf89                	beqz	a5,800002a8 <strncmp+0x26>
    80000290:	0005c703          	lbu	a4,0(a1)
    80000294:	00f71a63          	bne	a4,a5,800002a8 <strncmp+0x26>
    n--, p++, q++;
    80000298:	367d                	addiw	a2,a2,-1
    8000029a:	0505                	addi	a0,a0,1
    8000029c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000029e:	f675                	bnez	a2,8000028a <strncmp+0x8>
  if(n == 0)
    return 0;
    800002a0:	4501                	li	a0,0
    800002a2:	a809                	j	800002b4 <strncmp+0x32>
    800002a4:	4501                	li	a0,0
    800002a6:	a039                	j	800002b4 <strncmp+0x32>
  if(n == 0)
    800002a8:	ca09                	beqz	a2,800002ba <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    800002aa:	00054503          	lbu	a0,0(a0)
    800002ae:	0005c783          	lbu	a5,0(a1)
    800002b2:	9d1d                	subw	a0,a0,a5
}
    800002b4:	6422                	ld	s0,8(sp)
    800002b6:	0141                	addi	sp,sp,16
    800002b8:	8082                	ret
    return 0;
    800002ba:	4501                	li	a0,0
    800002bc:	bfe5                	j	800002b4 <strncmp+0x32>

00000000800002be <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800002be:	1141                	addi	sp,sp,-16
    800002c0:	e422                	sd	s0,8(sp)
    800002c2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800002c4:	87aa                	mv	a5,a0
    800002c6:	86b2                	mv	a3,a2
    800002c8:	367d                	addiw	a2,a2,-1
    800002ca:	00d05963          	blez	a3,800002dc <strncpy+0x1e>
    800002ce:	0785                	addi	a5,a5,1
    800002d0:	0005c703          	lbu	a4,0(a1)
    800002d4:	fee78fa3          	sb	a4,-1(a5)
    800002d8:	0585                	addi	a1,a1,1
    800002da:	f775                	bnez	a4,800002c6 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002dc:	873e                	mv	a4,a5
    800002de:	9fb5                	addw	a5,a5,a3
    800002e0:	37fd                	addiw	a5,a5,-1
    800002e2:	00c05963          	blez	a2,800002f4 <strncpy+0x36>
    *s++ = 0;
    800002e6:	0705                	addi	a4,a4,1
    800002e8:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002ec:	40e786bb          	subw	a3,a5,a4
    800002f0:	fed04be3          	bgtz	a3,800002e6 <strncpy+0x28>
  return os;
}
    800002f4:	6422                	ld	s0,8(sp)
    800002f6:	0141                	addi	sp,sp,16
    800002f8:	8082                	ret

00000000800002fa <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002fa:	1141                	addi	sp,sp,-16
    800002fc:	e422                	sd	s0,8(sp)
    800002fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000300:	02c05363          	blez	a2,80000326 <safestrcpy+0x2c>
    80000304:	fff6069b          	addiw	a3,a2,-1
    80000308:	1682                	slli	a3,a3,0x20
    8000030a:	9281                	srli	a3,a3,0x20
    8000030c:	96ae                	add	a3,a3,a1
    8000030e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000310:	00d58963          	beq	a1,a3,80000322 <safestrcpy+0x28>
    80000314:	0585                	addi	a1,a1,1
    80000316:	0785                	addi	a5,a5,1
    80000318:	fff5c703          	lbu	a4,-1(a1)
    8000031c:	fee78fa3          	sb	a4,-1(a5)
    80000320:	fb65                	bnez	a4,80000310 <safestrcpy+0x16>
    ;
  *s = 0;
    80000322:	00078023          	sb	zero,0(a5)
  return os;
}
    80000326:	6422                	ld	s0,8(sp)
    80000328:	0141                	addi	sp,sp,16
    8000032a:	8082                	ret

000000008000032c <strlen>:

int
strlen(const char *s)
{
    8000032c:	1141                	addi	sp,sp,-16
    8000032e:	e422                	sd	s0,8(sp)
    80000330:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000332:	00054783          	lbu	a5,0(a0)
    80000336:	cf91                	beqz	a5,80000352 <strlen+0x26>
    80000338:	0505                	addi	a0,a0,1
    8000033a:	87aa                	mv	a5,a0
    8000033c:	86be                	mv	a3,a5
    8000033e:	0785                	addi	a5,a5,1
    80000340:	fff7c703          	lbu	a4,-1(a5)
    80000344:	ff65                	bnez	a4,8000033c <strlen+0x10>
    80000346:	40a6853b          	subw	a0,a3,a0
    8000034a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    8000034c:	6422                	ld	s0,8(sp)
    8000034e:	0141                	addi	sp,sp,16
    80000350:	8082                	ret
  for(n = 0; s[n]; n++)
    80000352:	4501                	li	a0,0
    80000354:	bfe5                	j	8000034c <strlen+0x20>

0000000080000356 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000356:	1141                	addi	sp,sp,-16
    80000358:	e406                	sd	ra,8(sp)
    8000035a:	e022                	sd	s0,0(sp)
    8000035c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000035e:	00001097          	auipc	ra,0x1
    80000362:	b00080e7          	jalr	-1280(ra) # 80000e5e <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000366:	00008717          	auipc	a4,0x8
    8000036a:	77a70713          	addi	a4,a4,1914 # 80008ae0 <started>
  if(cpuid() == 0){
    8000036e:	c139                	beqz	a0,800003b4 <main+0x5e>
    while(started == 0)
    80000370:	431c                	lw	a5,0(a4)
    80000372:	2781                	sext.w	a5,a5
    80000374:	dff5                	beqz	a5,80000370 <main+0x1a>
      ;
    __sync_synchronize();
    80000376:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000037a:	00001097          	auipc	ra,0x1
    8000037e:	ae4080e7          	jalr	-1308(ra) # 80000e5e <cpuid>
    80000382:	85aa                	mv	a1,a0
    80000384:	00008517          	auipc	a0,0x8
    80000388:	cb450513          	addi	a0,a0,-844 # 80008038 <etext+0x38>
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	924080e7          	jalr	-1756(ra) # 80005cb0 <printf>
    kvminithart();    // turn on paging
    80000394:	00000097          	auipc	ra,0x0
    80000398:	0d8080e7          	jalr	216(ra) # 8000046c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000039c:	00001097          	auipc	ra,0x1
    800003a0:	7c6080e7          	jalr	1990(ra) # 80001b62 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    800003a4:	00005097          	auipc	ra,0x5
    800003a8:	dcc080e7          	jalr	-564(ra) # 80005170 <plicinithart>
  }

  scheduler();        
    800003ac:	00001097          	auipc	ra,0x1
    800003b0:	fdc080e7          	jalr	-36(ra) # 80001388 <scheduler>
    consoleinit();
    800003b4:	00005097          	auipc	ra,0x5
    800003b8:	7c2080e7          	jalr	1986(ra) # 80005b76 <consoleinit>
    printfinit();
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	ad4080e7          	jalr	-1324(ra) # 80005e90 <printfinit>
    printf("\n");
    800003c4:	00008517          	auipc	a0,0x8
    800003c8:	c8450513          	addi	a0,a0,-892 # 80008048 <etext+0x48>
    800003cc:	00006097          	auipc	ra,0x6
    800003d0:	8e4080e7          	jalr	-1820(ra) # 80005cb0 <printf>
    printf("xv6 kernel is booting\n");
    800003d4:	00008517          	auipc	a0,0x8
    800003d8:	c4c50513          	addi	a0,a0,-948 # 80008020 <etext+0x20>
    800003dc:	00006097          	auipc	ra,0x6
    800003e0:	8d4080e7          	jalr	-1836(ra) # 80005cb0 <printf>
    printf("\n");
    800003e4:	00008517          	auipc	a0,0x8
    800003e8:	c6450513          	addi	a0,a0,-924 # 80008048 <etext+0x48>
    800003ec:	00006097          	auipc	ra,0x6
    800003f0:	8c4080e7          	jalr	-1852(ra) # 80005cb0 <printf>
    kinit();         // physical page allocator
    800003f4:	00000097          	auipc	ra,0x0
    800003f8:	cfa080e7          	jalr	-774(ra) # 800000ee <kinit>
    kvminit();       // create kernel page table
    800003fc:	00000097          	auipc	ra,0x0
    80000400:	326080e7          	jalr	806(ra) # 80000722 <kvminit>
    kvminithart();   // turn on paging
    80000404:	00000097          	auipc	ra,0x0
    80000408:	068080e7          	jalr	104(ra) # 8000046c <kvminithart>
    procinit();      // process table
    8000040c:	00001097          	auipc	ra,0x1
    80000410:	99e080e7          	jalr	-1634(ra) # 80000daa <procinit>
    trapinit();      // trap vectors
    80000414:	00001097          	auipc	ra,0x1
    80000418:	726080e7          	jalr	1830(ra) # 80001b3a <trapinit>
    trapinithart();  // install kernel trap vector
    8000041c:	00001097          	auipc	ra,0x1
    80000420:	746080e7          	jalr	1862(ra) # 80001b62 <trapinithart>
    plicinit();      // set up interrupt controller
    80000424:	00005097          	auipc	ra,0x5
    80000428:	d36080e7          	jalr	-714(ra) # 8000515a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000042c:	00005097          	auipc	ra,0x5
    80000430:	d44080e7          	jalr	-700(ra) # 80005170 <plicinithart>
    binit();         // buffer cache
    80000434:	00002097          	auipc	ra,0x2
    80000438:	f36080e7          	jalr	-202(ra) # 8000236a <binit>
    iinit();         // inode table
    8000043c:	00002097          	auipc	ra,0x2
    80000440:	5d4080e7          	jalr	1492(ra) # 80002a10 <iinit>
    fileinit();      // file table
    80000444:	00003097          	auipc	ra,0x3
    80000448:	54a080e7          	jalr	1354(ra) # 8000398e <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000044c:	00005097          	auipc	ra,0x5
    80000450:	e2c080e7          	jalr	-468(ra) # 80005278 <virtio_disk_init>
    userinit();      // first user process
    80000454:	00001097          	auipc	ra,0x1
    80000458:	d0e080e7          	jalr	-754(ra) # 80001162 <userinit>
    __sync_synchronize();
    8000045c:	0ff0000f          	fence
    started = 1;
    80000460:	4785                	li	a5,1
    80000462:	00008717          	auipc	a4,0x8
    80000466:	66f72f23          	sw	a5,1662(a4) # 80008ae0 <started>
    8000046a:	b789                	j	800003ac <main+0x56>

000000008000046c <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000046c:	1141                	addi	sp,sp,-16
    8000046e:	e422                	sd	s0,8(sp)
    80000470:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000472:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000476:	00008797          	auipc	a5,0x8
    8000047a:	6727b783          	ld	a5,1650(a5) # 80008ae8 <kernel_pagetable>
    8000047e:	83b1                	srli	a5,a5,0xc
    80000480:	577d                	li	a4,-1
    80000482:	177e                	slli	a4,a4,0x3f
    80000484:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000486:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000048a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000048e:	6422                	ld	s0,8(sp)
    80000490:	0141                	addi	sp,sp,16
    80000492:	8082                	ret

0000000080000494 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000494:	7139                	addi	sp,sp,-64
    80000496:	fc06                	sd	ra,56(sp)
    80000498:	f822                	sd	s0,48(sp)
    8000049a:	f426                	sd	s1,40(sp)
    8000049c:	f04a                	sd	s2,32(sp)
    8000049e:	ec4e                	sd	s3,24(sp)
    800004a0:	e852                	sd	s4,16(sp)
    800004a2:	e456                	sd	s5,8(sp)
    800004a4:	e05a                	sd	s6,0(sp)
    800004a6:	0080                	addi	s0,sp,64
    800004a8:	84aa                	mv	s1,a0
    800004aa:	89ae                	mv	s3,a1
    800004ac:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800004ae:	57fd                	li	a5,-1
    800004b0:	83e9                	srli	a5,a5,0x1a
    800004b2:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004b4:	4b31                	li	s6,12
  if(va >= MAXVA)
    800004b6:	04b7f263          	bgeu	a5,a1,800004fa <walk+0x66>
    panic("walk");
    800004ba:	00008517          	auipc	a0,0x8
    800004be:	b9650513          	addi	a0,a0,-1130 # 80008050 <etext+0x50>
    800004c2:	00005097          	auipc	ra,0x5
    800004c6:	7a4080e7          	jalr	1956(ra) # 80005c66 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800004ca:	060a8663          	beqz	s5,80000536 <walk+0xa2>
    800004ce:	00000097          	auipc	ra,0x0
    800004d2:	c5c080e7          	jalr	-932(ra) # 8000012a <kalloc>
    800004d6:	84aa                	mv	s1,a0
    800004d8:	c529                	beqz	a0,80000522 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800004da:	6605                	lui	a2,0x1
    800004dc:	4581                	li	a1,0
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	cd4080e7          	jalr	-812(ra) # 800001b2 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800004e6:	00c4d793          	srli	a5,s1,0xc
    800004ea:	07aa                	slli	a5,a5,0xa
    800004ec:	0017e793          	ori	a5,a5,1
    800004f0:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800004f4:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdce77>
    800004f6:	036a0063          	beq	s4,s6,80000516 <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800004fa:	0149d933          	srl	s2,s3,s4
    800004fe:	1ff97913          	andi	s2,s2,511
    80000502:	090e                	slli	s2,s2,0x3
    80000504:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000506:	00093483          	ld	s1,0(s2)
    8000050a:	0014f793          	andi	a5,s1,1
    8000050e:	dfd5                	beqz	a5,800004ca <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000510:	80a9                	srli	s1,s1,0xa
    80000512:	04b2                	slli	s1,s1,0xc
    80000514:	b7c5                	j	800004f4 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    80000516:	00c9d513          	srli	a0,s3,0xc
    8000051a:	1ff57513          	andi	a0,a0,511
    8000051e:	050e                	slli	a0,a0,0x3
    80000520:	9526                	add	a0,a0,s1
}
    80000522:	70e2                	ld	ra,56(sp)
    80000524:	7442                	ld	s0,48(sp)
    80000526:	74a2                	ld	s1,40(sp)
    80000528:	7902                	ld	s2,32(sp)
    8000052a:	69e2                	ld	s3,24(sp)
    8000052c:	6a42                	ld	s4,16(sp)
    8000052e:	6aa2                	ld	s5,8(sp)
    80000530:	6b02                	ld	s6,0(sp)
    80000532:	6121                	addi	sp,sp,64
    80000534:	8082                	ret
        return 0;
    80000536:	4501                	li	a0,0
    80000538:	b7ed                	j	80000522 <walk+0x8e>

000000008000053a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000053a:	57fd                	li	a5,-1
    8000053c:	83e9                	srli	a5,a5,0x1a
    8000053e:	00b7f463          	bgeu	a5,a1,80000546 <walkaddr+0xc>
    return 0;
    80000542:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000544:	8082                	ret
{
    80000546:	1141                	addi	sp,sp,-16
    80000548:	e406                	sd	ra,8(sp)
    8000054a:	e022                	sd	s0,0(sp)
    8000054c:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000054e:	4601                	li	a2,0
    80000550:	00000097          	auipc	ra,0x0
    80000554:	f44080e7          	jalr	-188(ra) # 80000494 <walk>
  if(pte == 0)
    80000558:	c105                	beqz	a0,80000578 <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000055a:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000055c:	0117f693          	andi	a3,a5,17
    80000560:	4745                	li	a4,17
    return 0;
    80000562:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000564:	00e68663          	beq	a3,a4,80000570 <walkaddr+0x36>
}
    80000568:	60a2                	ld	ra,8(sp)
    8000056a:	6402                	ld	s0,0(sp)
    8000056c:	0141                	addi	sp,sp,16
    8000056e:	8082                	ret
  pa = PTE2PA(*pte);
    80000570:	83a9                	srli	a5,a5,0xa
    80000572:	00c79513          	slli	a0,a5,0xc
  return pa;
    80000576:	bfcd                	j	80000568 <walkaddr+0x2e>
    return 0;
    80000578:	4501                	li	a0,0
    8000057a:	b7fd                	j	80000568 <walkaddr+0x2e>

000000008000057c <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000057c:	715d                	addi	sp,sp,-80
    8000057e:	e486                	sd	ra,72(sp)
    80000580:	e0a2                	sd	s0,64(sp)
    80000582:	fc26                	sd	s1,56(sp)
    80000584:	f84a                	sd	s2,48(sp)
    80000586:	f44e                	sd	s3,40(sp)
    80000588:	f052                	sd	s4,32(sp)
    8000058a:	ec56                	sd	s5,24(sp)
    8000058c:	e85a                	sd	s6,16(sp)
    8000058e:	e45e                	sd	s7,8(sp)
    80000590:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000592:	c639                	beqz	a2,800005e0 <mappages+0x64>
    80000594:	8aaa                	mv	s5,a0
    80000596:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80000598:	777d                	lui	a4,0xfffff
    8000059a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000059e:	fff58993          	addi	s3,a1,-1
    800005a2:	99b2                	add	s3,s3,a2
    800005a4:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    800005a8:	893e                	mv	s2,a5
    800005aa:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005ae:	6b85                	lui	s7,0x1
    800005b0:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    800005b4:	4605                	li	a2,1
    800005b6:	85ca                	mv	a1,s2
    800005b8:	8556                	mv	a0,s5
    800005ba:	00000097          	auipc	ra,0x0
    800005be:	eda080e7          	jalr	-294(ra) # 80000494 <walk>
    800005c2:	cd1d                	beqz	a0,80000600 <mappages+0x84>
    if(*pte & PTE_V)
    800005c4:	611c                	ld	a5,0(a0)
    800005c6:	8b85                	andi	a5,a5,1
    800005c8:	e785                	bnez	a5,800005f0 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005ca:	80b1                	srli	s1,s1,0xc
    800005cc:	04aa                	slli	s1,s1,0xa
    800005ce:	0164e4b3          	or	s1,s1,s6
    800005d2:	0014e493          	ori	s1,s1,1
    800005d6:	e104                	sd	s1,0(a0)
    if(a == last)
    800005d8:	05390063          	beq	s2,s3,80000618 <mappages+0x9c>
    a += PGSIZE;
    800005dc:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005de:	bfc9                	j	800005b0 <mappages+0x34>
    panic("mappages: size");
    800005e0:	00008517          	auipc	a0,0x8
    800005e4:	a7850513          	addi	a0,a0,-1416 # 80008058 <etext+0x58>
    800005e8:	00005097          	auipc	ra,0x5
    800005ec:	67e080e7          	jalr	1662(ra) # 80005c66 <panic>
      panic("mappages: remap");
    800005f0:	00008517          	auipc	a0,0x8
    800005f4:	a7850513          	addi	a0,a0,-1416 # 80008068 <etext+0x68>
    800005f8:	00005097          	auipc	ra,0x5
    800005fc:	66e080e7          	jalr	1646(ra) # 80005c66 <panic>
      return -1;
    80000600:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000602:	60a6                	ld	ra,72(sp)
    80000604:	6406                	ld	s0,64(sp)
    80000606:	74e2                	ld	s1,56(sp)
    80000608:	7942                	ld	s2,48(sp)
    8000060a:	79a2                	ld	s3,40(sp)
    8000060c:	7a02                	ld	s4,32(sp)
    8000060e:	6ae2                	ld	s5,24(sp)
    80000610:	6b42                	ld	s6,16(sp)
    80000612:	6ba2                	ld	s7,8(sp)
    80000614:	6161                	addi	sp,sp,80
    80000616:	8082                	ret
  return 0;
    80000618:	4501                	li	a0,0
    8000061a:	b7e5                	j	80000602 <mappages+0x86>

000000008000061c <kvmmap>:
{
    8000061c:	1141                	addi	sp,sp,-16
    8000061e:	e406                	sd	ra,8(sp)
    80000620:	e022                	sd	s0,0(sp)
    80000622:	0800                	addi	s0,sp,16
    80000624:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000626:	86b2                	mv	a3,a2
    80000628:	863e                	mv	a2,a5
    8000062a:	00000097          	auipc	ra,0x0
    8000062e:	f52080e7          	jalr	-174(ra) # 8000057c <mappages>
    80000632:	e509                	bnez	a0,8000063c <kvmmap+0x20>
}
    80000634:	60a2                	ld	ra,8(sp)
    80000636:	6402                	ld	s0,0(sp)
    80000638:	0141                	addi	sp,sp,16
    8000063a:	8082                	ret
    panic("kvmmap");
    8000063c:	00008517          	auipc	a0,0x8
    80000640:	a3c50513          	addi	a0,a0,-1476 # 80008078 <etext+0x78>
    80000644:	00005097          	auipc	ra,0x5
    80000648:	622080e7          	jalr	1570(ra) # 80005c66 <panic>

000000008000064c <kvmmake>:
{
    8000064c:	1101                	addi	sp,sp,-32
    8000064e:	ec06                	sd	ra,24(sp)
    80000650:	e822                	sd	s0,16(sp)
    80000652:	e426                	sd	s1,8(sp)
    80000654:	e04a                	sd	s2,0(sp)
    80000656:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000658:	00000097          	auipc	ra,0x0
    8000065c:	ad2080e7          	jalr	-1326(ra) # 8000012a <kalloc>
    80000660:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000662:	6605                	lui	a2,0x1
    80000664:	4581                	li	a1,0
    80000666:	00000097          	auipc	ra,0x0
    8000066a:	b4c080e7          	jalr	-1204(ra) # 800001b2 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000066e:	4719                	li	a4,6
    80000670:	6685                	lui	a3,0x1
    80000672:	10000637          	lui	a2,0x10000
    80000676:	100005b7          	lui	a1,0x10000
    8000067a:	8526                	mv	a0,s1
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	fa0080e7          	jalr	-96(ra) # 8000061c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10001637          	lui	a2,0x10001
    8000068c:	100015b7          	lui	a1,0x10001
    80000690:	8526                	mv	a0,s1
    80000692:	00000097          	auipc	ra,0x0
    80000696:	f8a080e7          	jalr	-118(ra) # 8000061c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000069a:	4719                	li	a4,6
    8000069c:	004006b7          	lui	a3,0x400
    800006a0:	0c000637          	lui	a2,0xc000
    800006a4:	0c0005b7          	lui	a1,0xc000
    800006a8:	8526                	mv	a0,s1
    800006aa:	00000097          	auipc	ra,0x0
    800006ae:	f72080e7          	jalr	-142(ra) # 8000061c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006b2:	00008917          	auipc	s2,0x8
    800006b6:	94e90913          	addi	s2,s2,-1714 # 80008000 <etext>
    800006ba:	4729                	li	a4,10
    800006bc:	80008697          	auipc	a3,0x80008
    800006c0:	94468693          	addi	a3,a3,-1724 # 8000 <_entry-0x7fff8000>
    800006c4:	4605                	li	a2,1
    800006c6:	067e                	slli	a2,a2,0x1f
    800006c8:	85b2                	mv	a1,a2
    800006ca:	8526                	mv	a0,s1
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	f50080e7          	jalr	-176(ra) # 8000061c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006d4:	4719                	li	a4,6
    800006d6:	46c5                	li	a3,17
    800006d8:	06ee                	slli	a3,a3,0x1b
    800006da:	412686b3          	sub	a3,a3,s2
    800006de:	864a                	mv	a2,s2
    800006e0:	85ca                	mv	a1,s2
    800006e2:	8526                	mv	a0,s1
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	f38080e7          	jalr	-200(ra) # 8000061c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006ec:	4729                	li	a4,10
    800006ee:	6685                	lui	a3,0x1
    800006f0:	00007617          	auipc	a2,0x7
    800006f4:	91060613          	addi	a2,a2,-1776 # 80007000 <_trampoline>
    800006f8:	040005b7          	lui	a1,0x4000
    800006fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800006fe:	05b2                	slli	a1,a1,0xc
    80000700:	8526                	mv	a0,s1
    80000702:	00000097          	auipc	ra,0x0
    80000706:	f1a080e7          	jalr	-230(ra) # 8000061c <kvmmap>
  proc_mapstacks(kpgtbl);
    8000070a:	8526                	mv	a0,s1
    8000070c:	00000097          	auipc	ra,0x0
    80000710:	608080e7          	jalr	1544(ra) # 80000d14 <proc_mapstacks>
}
    80000714:	8526                	mv	a0,s1
    80000716:	60e2                	ld	ra,24(sp)
    80000718:	6442                	ld	s0,16(sp)
    8000071a:	64a2                	ld	s1,8(sp)
    8000071c:	6902                	ld	s2,0(sp)
    8000071e:	6105                	addi	sp,sp,32
    80000720:	8082                	ret

0000000080000722 <kvminit>:
{
    80000722:	1141                	addi	sp,sp,-16
    80000724:	e406                	sd	ra,8(sp)
    80000726:	e022                	sd	s0,0(sp)
    80000728:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000072a:	00000097          	auipc	ra,0x0
    8000072e:	f22080e7          	jalr	-222(ra) # 8000064c <kvmmake>
    80000732:	00008797          	auipc	a5,0x8
    80000736:	3aa7bb23          	sd	a0,950(a5) # 80008ae8 <kernel_pagetable>
}
    8000073a:	60a2                	ld	ra,8(sp)
    8000073c:	6402                	ld	s0,0(sp)
    8000073e:	0141                	addi	sp,sp,16
    80000740:	8082                	ret

0000000080000742 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000742:	715d                	addi	sp,sp,-80
    80000744:	e486                	sd	ra,72(sp)
    80000746:	e0a2                	sd	s0,64(sp)
    80000748:	fc26                	sd	s1,56(sp)
    8000074a:	f84a                	sd	s2,48(sp)
    8000074c:	f44e                	sd	s3,40(sp)
    8000074e:	f052                	sd	s4,32(sp)
    80000750:	ec56                	sd	s5,24(sp)
    80000752:	e85a                	sd	s6,16(sp)
    80000754:	e45e                	sd	s7,8(sp)
    80000756:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000758:	03459793          	slli	a5,a1,0x34
    8000075c:	e795                	bnez	a5,80000788 <uvmunmap+0x46>
    8000075e:	8a2a                	mv	s4,a0
    80000760:	892e                	mv	s2,a1
    80000762:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000764:	0632                	slli	a2,a2,0xc
    80000766:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000076a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000076c:	6b05                	lui	s6,0x1
    8000076e:	0735e263          	bltu	a1,s3,800007d2 <uvmunmap+0x90>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80000772:	60a6                	ld	ra,72(sp)
    80000774:	6406                	ld	s0,64(sp)
    80000776:	74e2                	ld	s1,56(sp)
    80000778:	7942                	ld	s2,48(sp)
    8000077a:	79a2                	ld	s3,40(sp)
    8000077c:	7a02                	ld	s4,32(sp)
    8000077e:	6ae2                	ld	s5,24(sp)
    80000780:	6b42                	ld	s6,16(sp)
    80000782:	6ba2                	ld	s7,8(sp)
    80000784:	6161                	addi	sp,sp,80
    80000786:	8082                	ret
    panic("uvmunmap: not aligned");
    80000788:	00008517          	auipc	a0,0x8
    8000078c:	8f850513          	addi	a0,a0,-1800 # 80008080 <etext+0x80>
    80000790:	00005097          	auipc	ra,0x5
    80000794:	4d6080e7          	jalr	1238(ra) # 80005c66 <panic>
      panic("uvmunmap: walk");
    80000798:	00008517          	auipc	a0,0x8
    8000079c:	90050513          	addi	a0,a0,-1792 # 80008098 <etext+0x98>
    800007a0:	00005097          	auipc	ra,0x5
    800007a4:	4c6080e7          	jalr	1222(ra) # 80005c66 <panic>
      panic("uvmunmap: not mapped");
    800007a8:	00008517          	auipc	a0,0x8
    800007ac:	90050513          	addi	a0,a0,-1792 # 800080a8 <etext+0xa8>
    800007b0:	00005097          	auipc	ra,0x5
    800007b4:	4b6080e7          	jalr	1206(ra) # 80005c66 <panic>
      panic("uvmunmap: not a leaf");
    800007b8:	00008517          	auipc	a0,0x8
    800007bc:	90850513          	addi	a0,a0,-1784 # 800080c0 <etext+0xc0>
    800007c0:	00005097          	auipc	ra,0x5
    800007c4:	4a6080e7          	jalr	1190(ra) # 80005c66 <panic>
    *pte = 0;
    800007c8:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007cc:	995a                	add	s2,s2,s6
    800007ce:	fb3972e3          	bgeu	s2,s3,80000772 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    800007d2:	4601                	li	a2,0
    800007d4:	85ca                	mv	a1,s2
    800007d6:	8552                	mv	a0,s4
    800007d8:	00000097          	auipc	ra,0x0
    800007dc:	cbc080e7          	jalr	-836(ra) # 80000494 <walk>
    800007e0:	84aa                	mv	s1,a0
    800007e2:	d95d                	beqz	a0,80000798 <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    800007e4:	6108                	ld	a0,0(a0)
    800007e6:	00157793          	andi	a5,a0,1
    800007ea:	dfdd                	beqz	a5,800007a8 <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    800007ec:	3ff57793          	andi	a5,a0,1023
    800007f0:	fd7784e3          	beq	a5,s7,800007b8 <uvmunmap+0x76>
    if(do_free){
    800007f4:	fc0a8ae3          	beqz	s5,800007c8 <uvmunmap+0x86>
      uint64 pa = PTE2PA(*pte);
    800007f8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800007fa:	0532                	slli	a0,a0,0xc
    800007fc:	00000097          	auipc	ra,0x0
    80000800:	820080e7          	jalr	-2016(ra) # 8000001c <kfree>
    80000804:	b7d1                	j	800007c8 <uvmunmap+0x86>

0000000080000806 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000806:	1101                	addi	sp,sp,-32
    80000808:	ec06                	sd	ra,24(sp)
    8000080a:	e822                	sd	s0,16(sp)
    8000080c:	e426                	sd	s1,8(sp)
    8000080e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000810:	00000097          	auipc	ra,0x0
    80000814:	91a080e7          	jalr	-1766(ra) # 8000012a <kalloc>
    80000818:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000081a:	c519                	beqz	a0,80000828 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000081c:	6605                	lui	a2,0x1
    8000081e:	4581                	li	a1,0
    80000820:	00000097          	auipc	ra,0x0
    80000824:	992080e7          	jalr	-1646(ra) # 800001b2 <memset>
  return pagetable;
}
    80000828:	8526                	mv	a0,s1
    8000082a:	60e2                	ld	ra,24(sp)
    8000082c:	6442                	ld	s0,16(sp)
    8000082e:	64a2                	ld	s1,8(sp)
    80000830:	6105                	addi	sp,sp,32
    80000832:	8082                	ret

0000000080000834 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000834:	7179                	addi	sp,sp,-48
    80000836:	f406                	sd	ra,40(sp)
    80000838:	f022                	sd	s0,32(sp)
    8000083a:	ec26                	sd	s1,24(sp)
    8000083c:	e84a                	sd	s2,16(sp)
    8000083e:	e44e                	sd	s3,8(sp)
    80000840:	e052                	sd	s4,0(sp)
    80000842:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000844:	6785                	lui	a5,0x1
    80000846:	04f67863          	bgeu	a2,a5,80000896 <uvmfirst+0x62>
    8000084a:	8a2a                	mv	s4,a0
    8000084c:	89ae                	mv	s3,a1
    8000084e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80000850:	00000097          	auipc	ra,0x0
    80000854:	8da080e7          	jalr	-1830(ra) # 8000012a <kalloc>
    80000858:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000085a:	6605                	lui	a2,0x1
    8000085c:	4581                	li	a1,0
    8000085e:	00000097          	auipc	ra,0x0
    80000862:	954080e7          	jalr	-1708(ra) # 800001b2 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80000866:	4779                	li	a4,30
    80000868:	86ca                	mv	a3,s2
    8000086a:	6605                	lui	a2,0x1
    8000086c:	4581                	li	a1,0
    8000086e:	8552                	mv	a0,s4
    80000870:	00000097          	auipc	ra,0x0
    80000874:	d0c080e7          	jalr	-756(ra) # 8000057c <mappages>
  memmove(mem, src, sz);
    80000878:	8626                	mv	a2,s1
    8000087a:	85ce                	mv	a1,s3
    8000087c:	854a                	mv	a0,s2
    8000087e:	00000097          	auipc	ra,0x0
    80000882:	990080e7          	jalr	-1648(ra) # 8000020e <memmove>
}
    80000886:	70a2                	ld	ra,40(sp)
    80000888:	7402                	ld	s0,32(sp)
    8000088a:	64e2                	ld	s1,24(sp)
    8000088c:	6942                	ld	s2,16(sp)
    8000088e:	69a2                	ld	s3,8(sp)
    80000890:	6a02                	ld	s4,0(sp)
    80000892:	6145                	addi	sp,sp,48
    80000894:	8082                	ret
    panic("uvmfirst: more than a page");
    80000896:	00008517          	auipc	a0,0x8
    8000089a:	84250513          	addi	a0,a0,-1982 # 800080d8 <etext+0xd8>
    8000089e:	00005097          	auipc	ra,0x5
    800008a2:	3c8080e7          	jalr	968(ra) # 80005c66 <panic>

00000000800008a6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800008a6:	1101                	addi	sp,sp,-32
    800008a8:	ec06                	sd	ra,24(sp)
    800008aa:	e822                	sd	s0,16(sp)
    800008ac:	e426                	sd	s1,8(sp)
    800008ae:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800008b0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800008b2:	00b67d63          	bgeu	a2,a1,800008cc <uvmdealloc+0x26>
    800008b6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800008b8:	6785                	lui	a5,0x1
    800008ba:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008bc:	00f60733          	add	a4,a2,a5
    800008c0:	76fd                	lui	a3,0xfffff
    800008c2:	8f75                	and	a4,a4,a3
    800008c4:	97ae                	add	a5,a5,a1
    800008c6:	8ff5                	and	a5,a5,a3
    800008c8:	00f76863          	bltu	a4,a5,800008d8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800008cc:	8526                	mv	a0,s1
    800008ce:	60e2                	ld	ra,24(sp)
    800008d0:	6442                	ld	s0,16(sp)
    800008d2:	64a2                	ld	s1,8(sp)
    800008d4:	6105                	addi	sp,sp,32
    800008d6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008d8:	8f99                	sub	a5,a5,a4
    800008da:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008dc:	4685                	li	a3,1
    800008de:	0007861b          	sext.w	a2,a5
    800008e2:	85ba                	mv	a1,a4
    800008e4:	00000097          	auipc	ra,0x0
    800008e8:	e5e080e7          	jalr	-418(ra) # 80000742 <uvmunmap>
    800008ec:	b7c5                	j	800008cc <uvmdealloc+0x26>

00000000800008ee <uvmalloc>:
  if(newsz < oldsz)
    800008ee:	0ab66563          	bltu	a2,a1,80000998 <uvmalloc+0xaa>
{
    800008f2:	7139                	addi	sp,sp,-64
    800008f4:	fc06                	sd	ra,56(sp)
    800008f6:	f822                	sd	s0,48(sp)
    800008f8:	f426                	sd	s1,40(sp)
    800008fa:	f04a                	sd	s2,32(sp)
    800008fc:	ec4e                	sd	s3,24(sp)
    800008fe:	e852                	sd	s4,16(sp)
    80000900:	e456                	sd	s5,8(sp)
    80000902:	e05a                	sd	s6,0(sp)
    80000904:	0080                	addi	s0,sp,64
    80000906:	8aaa                	mv	s5,a0
    80000908:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000090a:	6785                	lui	a5,0x1
    8000090c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000090e:	95be                	add	a1,a1,a5
    80000910:	77fd                	lui	a5,0xfffff
    80000912:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000916:	08c9f363          	bgeu	s3,a2,8000099c <uvmalloc+0xae>
    8000091a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000091c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000920:	00000097          	auipc	ra,0x0
    80000924:	80a080e7          	jalr	-2038(ra) # 8000012a <kalloc>
    80000928:	84aa                	mv	s1,a0
    if(mem == 0){
    8000092a:	c51d                	beqz	a0,80000958 <uvmalloc+0x6a>
    memset(mem, 0, PGSIZE);
    8000092c:	6605                	lui	a2,0x1
    8000092e:	4581                	li	a1,0
    80000930:	00000097          	auipc	ra,0x0
    80000934:	882080e7          	jalr	-1918(ra) # 800001b2 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000938:	875a                	mv	a4,s6
    8000093a:	86a6                	mv	a3,s1
    8000093c:	6605                	lui	a2,0x1
    8000093e:	85ca                	mv	a1,s2
    80000940:	8556                	mv	a0,s5
    80000942:	00000097          	auipc	ra,0x0
    80000946:	c3a080e7          	jalr	-966(ra) # 8000057c <mappages>
    8000094a:	e90d                	bnez	a0,8000097c <uvmalloc+0x8e>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000094c:	6785                	lui	a5,0x1
    8000094e:	993e                	add	s2,s2,a5
    80000950:	fd4968e3          	bltu	s2,s4,80000920 <uvmalloc+0x32>
  return newsz;
    80000954:	8552                	mv	a0,s4
    80000956:	a809                	j	80000968 <uvmalloc+0x7a>
      uvmdealloc(pagetable, a, oldsz);
    80000958:	864e                	mv	a2,s3
    8000095a:	85ca                	mv	a1,s2
    8000095c:	8556                	mv	a0,s5
    8000095e:	00000097          	auipc	ra,0x0
    80000962:	f48080e7          	jalr	-184(ra) # 800008a6 <uvmdealloc>
      return 0;
    80000966:	4501                	li	a0,0
}
    80000968:	70e2                	ld	ra,56(sp)
    8000096a:	7442                	ld	s0,48(sp)
    8000096c:	74a2                	ld	s1,40(sp)
    8000096e:	7902                	ld	s2,32(sp)
    80000970:	69e2                	ld	s3,24(sp)
    80000972:	6a42                	ld	s4,16(sp)
    80000974:	6aa2                	ld	s5,8(sp)
    80000976:	6b02                	ld	s6,0(sp)
    80000978:	6121                	addi	sp,sp,64
    8000097a:	8082                	ret
      kfree(mem);
    8000097c:	8526                	mv	a0,s1
    8000097e:	fffff097          	auipc	ra,0xfffff
    80000982:	69e080e7          	jalr	1694(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000986:	864e                	mv	a2,s3
    80000988:	85ca                	mv	a1,s2
    8000098a:	8556                	mv	a0,s5
    8000098c:	00000097          	auipc	ra,0x0
    80000990:	f1a080e7          	jalr	-230(ra) # 800008a6 <uvmdealloc>
      return 0;
    80000994:	4501                	li	a0,0
    80000996:	bfc9                	j	80000968 <uvmalloc+0x7a>
    return oldsz;
    80000998:	852e                	mv	a0,a1
}
    8000099a:	8082                	ret
  return newsz;
    8000099c:	8532                	mv	a0,a2
    8000099e:	b7e9                	j	80000968 <uvmalloc+0x7a>

00000000800009a0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800009a0:	7179                	addi	sp,sp,-48
    800009a2:	f406                	sd	ra,40(sp)
    800009a4:	f022                	sd	s0,32(sp)
    800009a6:	ec26                	sd	s1,24(sp)
    800009a8:	e84a                	sd	s2,16(sp)
    800009aa:	e44e                	sd	s3,8(sp)
    800009ac:	e052                	sd	s4,0(sp)
    800009ae:	1800                	addi	s0,sp,48
    800009b0:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800009b2:	84aa                	mv	s1,a0
    800009b4:	6905                	lui	s2,0x1
    800009b6:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009b8:	4985                	li	s3,1
    800009ba:	a829                	j	800009d4 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800009bc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800009be:	00c79513          	slli	a0,a5,0xc
    800009c2:	00000097          	auipc	ra,0x0
    800009c6:	fde080e7          	jalr	-34(ra) # 800009a0 <freewalk>
      pagetable[i] = 0;
    800009ca:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800009ce:	04a1                	addi	s1,s1,8
    800009d0:	03248163          	beq	s1,s2,800009f2 <freewalk+0x52>
    pte_t pte = pagetable[i];
    800009d4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800009d6:	00f7f713          	andi	a4,a5,15
    800009da:	ff3701e3          	beq	a4,s3,800009bc <freewalk+0x1c>
    } else if(pte & PTE_V){
    800009de:	8b85                	andi	a5,a5,1
    800009e0:	d7fd                	beqz	a5,800009ce <freewalk+0x2e>
      panic("freewalk: leaf");
    800009e2:	00007517          	auipc	a0,0x7
    800009e6:	71650513          	addi	a0,a0,1814 # 800080f8 <etext+0xf8>
    800009ea:	00005097          	auipc	ra,0x5
    800009ee:	27c080e7          	jalr	636(ra) # 80005c66 <panic>
    }
  }
  kfree((void*)pagetable);
    800009f2:	8552                	mv	a0,s4
    800009f4:	fffff097          	auipc	ra,0xfffff
    800009f8:	628080e7          	jalr	1576(ra) # 8000001c <kfree>
}
    800009fc:	70a2                	ld	ra,40(sp)
    800009fe:	7402                	ld	s0,32(sp)
    80000a00:	64e2                	ld	s1,24(sp)
    80000a02:	6942                	ld	s2,16(sp)
    80000a04:	69a2                	ld	s3,8(sp)
    80000a06:	6a02                	ld	s4,0(sp)
    80000a08:	6145                	addi	sp,sp,48
    80000a0a:	8082                	ret

0000000080000a0c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a0c:	1101                	addi	sp,sp,-32
    80000a0e:	ec06                	sd	ra,24(sp)
    80000a10:	e822                	sd	s0,16(sp)
    80000a12:	e426                	sd	s1,8(sp)
    80000a14:	1000                	addi	s0,sp,32
    80000a16:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a18:	e999                	bnez	a1,80000a2e <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a1a:	8526                	mv	a0,s1
    80000a1c:	00000097          	auipc	ra,0x0
    80000a20:	f84080e7          	jalr	-124(ra) # 800009a0 <freewalk>
}
    80000a24:	60e2                	ld	ra,24(sp)
    80000a26:	6442                	ld	s0,16(sp)
    80000a28:	64a2                	ld	s1,8(sp)
    80000a2a:	6105                	addi	sp,sp,32
    80000a2c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000a2e:	6785                	lui	a5,0x1
    80000a30:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000a32:	95be                	add	a1,a1,a5
    80000a34:	4685                	li	a3,1
    80000a36:	00c5d613          	srli	a2,a1,0xc
    80000a3a:	4581                	li	a1,0
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	d06080e7          	jalr	-762(ra) # 80000742 <uvmunmap>
    80000a44:	bfd9                	j	80000a1a <uvmfree+0xe>

0000000080000a46 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000a46:	c679                	beqz	a2,80000b14 <uvmcopy+0xce>
{
    80000a48:	715d                	addi	sp,sp,-80
    80000a4a:	e486                	sd	ra,72(sp)
    80000a4c:	e0a2                	sd	s0,64(sp)
    80000a4e:	fc26                	sd	s1,56(sp)
    80000a50:	f84a                	sd	s2,48(sp)
    80000a52:	f44e                	sd	s3,40(sp)
    80000a54:	f052                	sd	s4,32(sp)
    80000a56:	ec56                	sd	s5,24(sp)
    80000a58:	e85a                	sd	s6,16(sp)
    80000a5a:	e45e                	sd	s7,8(sp)
    80000a5c:	0880                	addi	s0,sp,80
    80000a5e:	8b2a                	mv	s6,a0
    80000a60:	8aae                	mv	s5,a1
    80000a62:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a64:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80000a66:	4601                	li	a2,0
    80000a68:	85ce                	mv	a1,s3
    80000a6a:	855a                	mv	a0,s6
    80000a6c:	00000097          	auipc	ra,0x0
    80000a70:	a28080e7          	jalr	-1496(ra) # 80000494 <walk>
    80000a74:	c531                	beqz	a0,80000ac0 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80000a76:	6118                	ld	a4,0(a0)
    80000a78:	00177793          	andi	a5,a4,1
    80000a7c:	cbb1                	beqz	a5,80000ad0 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80000a7e:	00a75593          	srli	a1,a4,0xa
    80000a82:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000a86:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000a8a:	fffff097          	auipc	ra,0xfffff
    80000a8e:	6a0080e7          	jalr	1696(ra) # 8000012a <kalloc>
    80000a92:	892a                	mv	s2,a0
    80000a94:	c939                	beqz	a0,80000aea <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000a96:	6605                	lui	a2,0x1
    80000a98:	85de                	mv	a1,s7
    80000a9a:	fffff097          	auipc	ra,0xfffff
    80000a9e:	774080e7          	jalr	1908(ra) # 8000020e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000aa2:	8726                	mv	a4,s1
    80000aa4:	86ca                	mv	a3,s2
    80000aa6:	6605                	lui	a2,0x1
    80000aa8:	85ce                	mv	a1,s3
    80000aaa:	8556                	mv	a0,s5
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	ad0080e7          	jalr	-1328(ra) # 8000057c <mappages>
    80000ab4:	e515                	bnez	a0,80000ae0 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80000ab6:	6785                	lui	a5,0x1
    80000ab8:	99be                	add	s3,s3,a5
    80000aba:	fb49e6e3          	bltu	s3,s4,80000a66 <uvmcopy+0x20>
    80000abe:	a081                	j	80000afe <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	64850513          	addi	a0,a0,1608 # 80008108 <etext+0x108>
    80000ac8:	00005097          	auipc	ra,0x5
    80000acc:	19e080e7          	jalr	414(ra) # 80005c66 <panic>
      panic("uvmcopy: page not present");
    80000ad0:	00007517          	auipc	a0,0x7
    80000ad4:	65850513          	addi	a0,a0,1624 # 80008128 <etext+0x128>
    80000ad8:	00005097          	auipc	ra,0x5
    80000adc:	18e080e7          	jalr	398(ra) # 80005c66 <panic>
      kfree(mem);
    80000ae0:	854a                	mv	a0,s2
    80000ae2:	fffff097          	auipc	ra,0xfffff
    80000ae6:	53a080e7          	jalr	1338(ra) # 8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000aea:	4685                	li	a3,1
    80000aec:	00c9d613          	srli	a2,s3,0xc
    80000af0:	4581                	li	a1,0
    80000af2:	8556                	mv	a0,s5
    80000af4:	00000097          	auipc	ra,0x0
    80000af8:	c4e080e7          	jalr	-946(ra) # 80000742 <uvmunmap>
  return -1;
    80000afc:	557d                	li	a0,-1
}
    80000afe:	60a6                	ld	ra,72(sp)
    80000b00:	6406                	ld	s0,64(sp)
    80000b02:	74e2                	ld	s1,56(sp)
    80000b04:	7942                	ld	s2,48(sp)
    80000b06:	79a2                	ld	s3,40(sp)
    80000b08:	7a02                	ld	s4,32(sp)
    80000b0a:	6ae2                	ld	s5,24(sp)
    80000b0c:	6b42                	ld	s6,16(sp)
    80000b0e:	6ba2                	ld	s7,8(sp)
    80000b10:	6161                	addi	sp,sp,80
    80000b12:	8082                	ret
  return 0;
    80000b14:	4501                	li	a0,0
}
    80000b16:	8082                	ret

0000000080000b18 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000b18:	1141                	addi	sp,sp,-16
    80000b1a:	e406                	sd	ra,8(sp)
    80000b1c:	e022                	sd	s0,0(sp)
    80000b1e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000b20:	4601                	li	a2,0
    80000b22:	00000097          	auipc	ra,0x0
    80000b26:	972080e7          	jalr	-1678(ra) # 80000494 <walk>
  if(pte == 0)
    80000b2a:	c901                	beqz	a0,80000b3a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000b2c:	611c                	ld	a5,0(a0)
    80000b2e:	9bbd                	andi	a5,a5,-17
    80000b30:	e11c                	sd	a5,0(a0)
}
    80000b32:	60a2                	ld	ra,8(sp)
    80000b34:	6402                	ld	s0,0(sp)
    80000b36:	0141                	addi	sp,sp,16
    80000b38:	8082                	ret
    panic("uvmclear");
    80000b3a:	00007517          	auipc	a0,0x7
    80000b3e:	60e50513          	addi	a0,a0,1550 # 80008148 <etext+0x148>
    80000b42:	00005097          	auipc	ra,0x5
    80000b46:	124080e7          	jalr	292(ra) # 80005c66 <panic>

0000000080000b4a <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000b4a:	c6bd                	beqz	a3,80000bb8 <copyout+0x6e>
{
    80000b4c:	715d                	addi	sp,sp,-80
    80000b4e:	e486                	sd	ra,72(sp)
    80000b50:	e0a2                	sd	s0,64(sp)
    80000b52:	fc26                	sd	s1,56(sp)
    80000b54:	f84a                	sd	s2,48(sp)
    80000b56:	f44e                	sd	s3,40(sp)
    80000b58:	f052                	sd	s4,32(sp)
    80000b5a:	ec56                	sd	s5,24(sp)
    80000b5c:	e85a                	sd	s6,16(sp)
    80000b5e:	e45e                	sd	s7,8(sp)
    80000b60:	e062                	sd	s8,0(sp)
    80000b62:	0880                	addi	s0,sp,80
    80000b64:	8b2a                	mv	s6,a0
    80000b66:	8c2e                	mv	s8,a1
    80000b68:	8a32                	mv	s4,a2
    80000b6a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80000b6c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80000b6e:	6a85                	lui	s5,0x1
    80000b70:	a015                	j	80000b94 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b72:	9562                	add	a0,a0,s8
    80000b74:	0004861b          	sext.w	a2,s1
    80000b78:	85d2                	mv	a1,s4
    80000b7a:	41250533          	sub	a0,a0,s2
    80000b7e:	fffff097          	auipc	ra,0xfffff
    80000b82:	690080e7          	jalr	1680(ra) # 8000020e <memmove>

    len -= n;
    80000b86:	409989b3          	sub	s3,s3,s1
    src += n;
    80000b8a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80000b8c:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000b90:	02098263          	beqz	s3,80000bb4 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80000b94:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b98:	85ca                	mv	a1,s2
    80000b9a:	855a                	mv	a0,s6
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	99e080e7          	jalr	-1634(ra) # 8000053a <walkaddr>
    if(pa0 == 0)
    80000ba4:	cd01                	beqz	a0,80000bbc <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80000ba6:	418904b3          	sub	s1,s2,s8
    80000baa:	94d6                	add	s1,s1,s5
    80000bac:	fc99f3e3          	bgeu	s3,s1,80000b72 <copyout+0x28>
    80000bb0:	84ce                	mv	s1,s3
    80000bb2:	b7c1                	j	80000b72 <copyout+0x28>
  }
  return 0;
    80000bb4:	4501                	li	a0,0
    80000bb6:	a021                	j	80000bbe <copyout+0x74>
    80000bb8:	4501                	li	a0,0
}
    80000bba:	8082                	ret
      return -1;
    80000bbc:	557d                	li	a0,-1
}
    80000bbe:	60a6                	ld	ra,72(sp)
    80000bc0:	6406                	ld	s0,64(sp)
    80000bc2:	74e2                	ld	s1,56(sp)
    80000bc4:	7942                	ld	s2,48(sp)
    80000bc6:	79a2                	ld	s3,40(sp)
    80000bc8:	7a02                	ld	s4,32(sp)
    80000bca:	6ae2                	ld	s5,24(sp)
    80000bcc:	6b42                	ld	s6,16(sp)
    80000bce:	6ba2                	ld	s7,8(sp)
    80000bd0:	6c02                	ld	s8,0(sp)
    80000bd2:	6161                	addi	sp,sp,80
    80000bd4:	8082                	ret

0000000080000bd6 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000bd6:	caa5                	beqz	a3,80000c46 <copyin+0x70>
{
    80000bd8:	715d                	addi	sp,sp,-80
    80000bda:	e486                	sd	ra,72(sp)
    80000bdc:	e0a2                	sd	s0,64(sp)
    80000bde:	fc26                	sd	s1,56(sp)
    80000be0:	f84a                	sd	s2,48(sp)
    80000be2:	f44e                	sd	s3,40(sp)
    80000be4:	f052                	sd	s4,32(sp)
    80000be6:	ec56                	sd	s5,24(sp)
    80000be8:	e85a                	sd	s6,16(sp)
    80000bea:	e45e                	sd	s7,8(sp)
    80000bec:	e062                	sd	s8,0(sp)
    80000bee:	0880                	addi	s0,sp,80
    80000bf0:	8b2a                	mv	s6,a0
    80000bf2:	8a2e                	mv	s4,a1
    80000bf4:	8c32                	mv	s8,a2
    80000bf6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000bf8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000bfa:	6a85                	lui	s5,0x1
    80000bfc:	a01d                	j	80000c22 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bfe:	018505b3          	add	a1,a0,s8
    80000c02:	0004861b          	sext.w	a2,s1
    80000c06:	412585b3          	sub	a1,a1,s2
    80000c0a:	8552                	mv	a0,s4
    80000c0c:	fffff097          	auipc	ra,0xfffff
    80000c10:	602080e7          	jalr	1538(ra) # 8000020e <memmove>

    len -= n;
    80000c14:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000c18:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000c1a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000c1e:	02098263          	beqz	s3,80000c42 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000c22:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000c26:	85ca                	mv	a1,s2
    80000c28:	855a                	mv	a0,s6
    80000c2a:	00000097          	auipc	ra,0x0
    80000c2e:	910080e7          	jalr	-1776(ra) # 8000053a <walkaddr>
    if(pa0 == 0)
    80000c32:	cd01                	beqz	a0,80000c4a <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000c34:	418904b3          	sub	s1,s2,s8
    80000c38:	94d6                	add	s1,s1,s5
    80000c3a:	fc99f2e3          	bgeu	s3,s1,80000bfe <copyin+0x28>
    80000c3e:	84ce                	mv	s1,s3
    80000c40:	bf7d                	j	80000bfe <copyin+0x28>
  }
  return 0;
    80000c42:	4501                	li	a0,0
    80000c44:	a021                	j	80000c4c <copyin+0x76>
    80000c46:	4501                	li	a0,0
}
    80000c48:	8082                	ret
      return -1;
    80000c4a:	557d                	li	a0,-1
}
    80000c4c:	60a6                	ld	ra,72(sp)
    80000c4e:	6406                	ld	s0,64(sp)
    80000c50:	74e2                	ld	s1,56(sp)
    80000c52:	7942                	ld	s2,48(sp)
    80000c54:	79a2                	ld	s3,40(sp)
    80000c56:	7a02                	ld	s4,32(sp)
    80000c58:	6ae2                	ld	s5,24(sp)
    80000c5a:	6b42                	ld	s6,16(sp)
    80000c5c:	6ba2                	ld	s7,8(sp)
    80000c5e:	6c02                	ld	s8,0(sp)
    80000c60:	6161                	addi	sp,sp,80
    80000c62:	8082                	ret

0000000080000c64 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000c64:	c2dd                	beqz	a3,80000d0a <copyinstr+0xa6>
{
    80000c66:	715d                	addi	sp,sp,-80
    80000c68:	e486                	sd	ra,72(sp)
    80000c6a:	e0a2                	sd	s0,64(sp)
    80000c6c:	fc26                	sd	s1,56(sp)
    80000c6e:	f84a                	sd	s2,48(sp)
    80000c70:	f44e                	sd	s3,40(sp)
    80000c72:	f052                	sd	s4,32(sp)
    80000c74:	ec56                	sd	s5,24(sp)
    80000c76:	e85a                	sd	s6,16(sp)
    80000c78:	e45e                	sd	s7,8(sp)
    80000c7a:	0880                	addi	s0,sp,80
    80000c7c:	8a2a                	mv	s4,a0
    80000c7e:	8b2e                	mv	s6,a1
    80000c80:	8bb2                	mv	s7,a2
    80000c82:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80000c84:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000c86:	6985                	lui	s3,0x1
    80000c88:	a02d                	j	80000cb2 <copyinstr+0x4e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000c8a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c8e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000c90:	37fd                	addiw	a5,a5,-1
    80000c92:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000c96:	60a6                	ld	ra,72(sp)
    80000c98:	6406                	ld	s0,64(sp)
    80000c9a:	74e2                	ld	s1,56(sp)
    80000c9c:	7942                	ld	s2,48(sp)
    80000c9e:	79a2                	ld	s3,40(sp)
    80000ca0:	7a02                	ld	s4,32(sp)
    80000ca2:	6ae2                	ld	s5,24(sp)
    80000ca4:	6b42                	ld	s6,16(sp)
    80000ca6:	6ba2                	ld	s7,8(sp)
    80000ca8:	6161                	addi	sp,sp,80
    80000caa:	8082                	ret
    srcva = va0 + PGSIZE;
    80000cac:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80000cb0:	c8a9                	beqz	s1,80000d02 <copyinstr+0x9e>
    va0 = PGROUNDDOWN(srcva);
    80000cb2:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000cb6:	85ca                	mv	a1,s2
    80000cb8:	8552                	mv	a0,s4
    80000cba:	00000097          	auipc	ra,0x0
    80000cbe:	880080e7          	jalr	-1920(ra) # 8000053a <walkaddr>
    if(pa0 == 0)
    80000cc2:	c131                	beqz	a0,80000d06 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80000cc4:	417906b3          	sub	a3,s2,s7
    80000cc8:	96ce                	add	a3,a3,s3
    80000cca:	00d4f363          	bgeu	s1,a3,80000cd0 <copyinstr+0x6c>
    80000cce:	86a6                	mv	a3,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000cd0:	955e                	add	a0,a0,s7
    80000cd2:	41250533          	sub	a0,a0,s2
    while(n > 0){
    80000cd6:	daf9                	beqz	a3,80000cac <copyinstr+0x48>
    80000cd8:	87da                	mv	a5,s6
    80000cda:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000cdc:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ce0:	96da                	add	a3,a3,s6
    80000ce2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ce4:	00f60733          	add	a4,a2,a5
    80000ce8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdce80>
    80000cec:	df59                	beqz	a4,80000c8a <copyinstr+0x26>
        *dst = *p;
    80000cee:	00e78023          	sb	a4,0(a5)
      dst++;
    80000cf2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000cf4:	fed797e3          	bne	a5,a3,80000ce2 <copyinstr+0x7e>
    80000cf8:	14fd                	addi	s1,s1,-1
    80000cfa:	94c2                	add	s1,s1,a6
      --max;
    80000cfc:	8c8d                	sub	s1,s1,a1
      dst++;
    80000cfe:	8b3e                	mv	s6,a5
    80000d00:	b775                	j	80000cac <copyinstr+0x48>
    80000d02:	4781                	li	a5,0
    80000d04:	b771                	j	80000c90 <copyinstr+0x2c>
      return -1;
    80000d06:	557d                	li	a0,-1
    80000d08:	b779                	j	80000c96 <copyinstr+0x32>
  int got_null = 0;
    80000d0a:	4781                	li	a5,0
  if(got_null){
    80000d0c:	37fd                	addiw	a5,a5,-1
    80000d0e:	0007851b          	sext.w	a0,a5
}
    80000d12:	8082                	ret

0000000080000d14 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000d14:	7139                	addi	sp,sp,-64
    80000d16:	fc06                	sd	ra,56(sp)
    80000d18:	f822                	sd	s0,48(sp)
    80000d1a:	f426                	sd	s1,40(sp)
    80000d1c:	f04a                	sd	s2,32(sp)
    80000d1e:	ec4e                	sd	s3,24(sp)
    80000d20:	e852                	sd	s4,16(sp)
    80000d22:	e456                	sd	s5,8(sp)
    80000d24:	e05a                	sd	s6,0(sp)
    80000d26:	0080                	addi	s0,sp,64
    80000d28:	89aa                	mv	s3,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2a:	00008497          	auipc	s1,0x8
    80000d2e:	23648493          	addi	s1,s1,566 # 80008f60 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000d32:	8b26                	mv	s6,s1
    80000d34:	00007a97          	auipc	s5,0x7
    80000d38:	2cca8a93          	addi	s5,s5,716 # 80008000 <etext>
    80000d3c:	04000937          	lui	s2,0x4000
    80000d40:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d42:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	0000ea17          	auipc	s4,0xe
    80000d48:	e1ca0a13          	addi	s4,s4,-484 # 8000eb60 <tickslock>
    char *pa = kalloc();
    80000d4c:	fffff097          	auipc	ra,0xfffff
    80000d50:	3de080e7          	jalr	990(ra) # 8000012a <kalloc>
    80000d54:	862a                	mv	a2,a0
    if(pa == 0)
    80000d56:	c131                	beqz	a0,80000d9a <proc_mapstacks+0x86>
    uint64 va = KSTACK((int) (p - proc));
    80000d58:	416485b3          	sub	a1,s1,s6
    80000d5c:	8591                	srai	a1,a1,0x4
    80000d5e:	000ab783          	ld	a5,0(s5)
    80000d62:	02f585b3          	mul	a1,a1,a5
    80000d66:	2585                	addiw	a1,a1,1
    80000d68:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d6c:	4719                	li	a4,6
    80000d6e:	6685                	lui	a3,0x1
    80000d70:	40b905b3          	sub	a1,s2,a1
    80000d74:	854e                	mv	a0,s3
    80000d76:	00000097          	auipc	ra,0x0
    80000d7a:	8a6080e7          	jalr	-1882(ra) # 8000061c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d7e:	17048493          	addi	s1,s1,368
    80000d82:	fd4495e3          	bne	s1,s4,80000d4c <proc_mapstacks+0x38>
  }
}
    80000d86:	70e2                	ld	ra,56(sp)
    80000d88:	7442                	ld	s0,48(sp)
    80000d8a:	74a2                	ld	s1,40(sp)
    80000d8c:	7902                	ld	s2,32(sp)
    80000d8e:	69e2                	ld	s3,24(sp)
    80000d90:	6a42                	ld	s4,16(sp)
    80000d92:	6aa2                	ld	s5,8(sp)
    80000d94:	6b02                	ld	s6,0(sp)
    80000d96:	6121                	addi	sp,sp,64
    80000d98:	8082                	ret
      panic("kalloc");
    80000d9a:	00007517          	auipc	a0,0x7
    80000d9e:	3be50513          	addi	a0,a0,958 # 80008158 <etext+0x158>
    80000da2:	00005097          	auipc	ra,0x5
    80000da6:	ec4080e7          	jalr	-316(ra) # 80005c66 <panic>

0000000080000daa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000daa:	7139                	addi	sp,sp,-64
    80000dac:	fc06                	sd	ra,56(sp)
    80000dae:	f822                	sd	s0,48(sp)
    80000db0:	f426                	sd	s1,40(sp)
    80000db2:	f04a                	sd	s2,32(sp)
    80000db4:	ec4e                	sd	s3,24(sp)
    80000db6:	e852                	sd	s4,16(sp)
    80000db8:	e456                	sd	s5,8(sp)
    80000dba:	e05a                	sd	s6,0(sp)
    80000dbc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000dbe:	00007597          	auipc	a1,0x7
    80000dc2:	3a258593          	addi	a1,a1,930 # 80008160 <etext+0x160>
    80000dc6:	00008517          	auipc	a0,0x8
    80000dca:	d6a50513          	addi	a0,a0,-662 # 80008b30 <pid_lock>
    80000dce:	00005097          	auipc	ra,0x5
    80000dd2:	340080e7          	jalr	832(ra) # 8000610e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000dd6:	00007597          	auipc	a1,0x7
    80000dda:	39258593          	addi	a1,a1,914 # 80008168 <etext+0x168>
    80000dde:	00008517          	auipc	a0,0x8
    80000de2:	d6a50513          	addi	a0,a0,-662 # 80008b48 <wait_lock>
    80000de6:	00005097          	auipc	ra,0x5
    80000dea:	328080e7          	jalr	808(ra) # 8000610e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dee:	00008497          	auipc	s1,0x8
    80000df2:	17248493          	addi	s1,s1,370 # 80008f60 <proc>
      initlock(&p->lock, "proc");
    80000df6:	00007b17          	auipc	s6,0x7
    80000dfa:	382b0b13          	addi	s6,s6,898 # 80008178 <etext+0x178>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000dfe:	8aa6                	mv	s5,s1
    80000e00:	00007a17          	auipc	s4,0x7
    80000e04:	200a0a13          	addi	s4,s4,512 # 80008000 <etext>
    80000e08:	04000937          	lui	s2,0x4000
    80000e0c:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000e0e:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e10:	0000e997          	auipc	s3,0xe
    80000e14:	d5098993          	addi	s3,s3,-688 # 8000eb60 <tickslock>
      initlock(&p->lock, "proc");
    80000e18:	85da                	mv	a1,s6
    80000e1a:	8526                	mv	a0,s1
    80000e1c:	00005097          	auipc	ra,0x5
    80000e20:	2f2080e7          	jalr	754(ra) # 8000610e <initlock>
      p->state = UNUSED;
    80000e24:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000e28:	415487b3          	sub	a5,s1,s5
    80000e2c:	8791                	srai	a5,a5,0x4
    80000e2e:	000a3703          	ld	a4,0(s4)
    80000e32:	02e787b3          	mul	a5,a5,a4
    80000e36:	2785                	addiw	a5,a5,1
    80000e38:	00d7979b          	slliw	a5,a5,0xd
    80000e3c:	40f907b3          	sub	a5,s2,a5
    80000e40:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e42:	17048493          	addi	s1,s1,368
    80000e46:	fd3499e3          	bne	s1,s3,80000e18 <procinit+0x6e>
  }
}
    80000e4a:	70e2                	ld	ra,56(sp)
    80000e4c:	7442                	ld	s0,48(sp)
    80000e4e:	74a2                	ld	s1,40(sp)
    80000e50:	7902                	ld	s2,32(sp)
    80000e52:	69e2                	ld	s3,24(sp)
    80000e54:	6a42                	ld	s4,16(sp)
    80000e56:	6aa2                	ld	s5,8(sp)
    80000e58:	6b02                	ld	s6,0(sp)
    80000e5a:	6121                	addi	sp,sp,64
    80000e5c:	8082                	ret

0000000080000e5e <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e422                	sd	s0,8(sp)
    80000e62:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e64:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e66:	2501                	sext.w	a0,a0
    80000e68:	6422                	ld	s0,8(sp)
    80000e6a:	0141                	addi	sp,sp,16
    80000e6c:	8082                	ret

0000000080000e6e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e6e:	1141                	addi	sp,sp,-16
    80000e70:	e422                	sd	s0,8(sp)
    80000e72:	0800                	addi	s0,sp,16
    80000e74:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e7a:	00008517          	auipc	a0,0x8
    80000e7e:	ce650513          	addi	a0,a0,-794 # 80008b60 <cpus>
    80000e82:	953e                	add	a0,a0,a5
    80000e84:	6422                	ld	s0,8(sp)
    80000e86:	0141                	addi	sp,sp,16
    80000e88:	8082                	ret

0000000080000e8a <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e8a:	1101                	addi	sp,sp,-32
    80000e8c:	ec06                	sd	ra,24(sp)
    80000e8e:	e822                	sd	s0,16(sp)
    80000e90:	e426                	sd	s1,8(sp)
    80000e92:	1000                	addi	s0,sp,32
  push_off();
    80000e94:	00005097          	auipc	ra,0x5
    80000e98:	2be080e7          	jalr	702(ra) # 80006152 <push_off>
    80000e9c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e9e:	2781                	sext.w	a5,a5
    80000ea0:	079e                	slli	a5,a5,0x7
    80000ea2:	00008717          	auipc	a4,0x8
    80000ea6:	c8e70713          	addi	a4,a4,-882 # 80008b30 <pid_lock>
    80000eaa:	97ba                	add	a5,a5,a4
    80000eac:	7b84                	ld	s1,48(a5)
  pop_off();
    80000eae:	00005097          	auipc	ra,0x5
    80000eb2:	344080e7          	jalr	836(ra) # 800061f2 <pop_off>
  return p;
}
    80000eb6:	8526                	mv	a0,s1
    80000eb8:	60e2                	ld	ra,24(sp)
    80000eba:	6442                	ld	s0,16(sp)
    80000ebc:	64a2                	ld	s1,8(sp)
    80000ebe:	6105                	addi	sp,sp,32
    80000ec0:	8082                	ret

0000000080000ec2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000ec2:	1141                	addi	sp,sp,-16
    80000ec4:	e406                	sd	ra,8(sp)
    80000ec6:	e022                	sd	s0,0(sp)
    80000ec8:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000eca:	00000097          	auipc	ra,0x0
    80000ece:	fc0080e7          	jalr	-64(ra) # 80000e8a <myproc>
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	380080e7          	jalr	896(ra) # 80006252 <release>

  if (first) {
    80000eda:	00008797          	auipc	a5,0x8
    80000ede:	bbe7a783          	lw	a5,-1090(a5) # 80008a98 <first.1>
    80000ee2:	eb89                	bnez	a5,80000ef4 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    80000ee4:	00001097          	auipc	ra,0x1
    80000ee8:	c96080e7          	jalr	-874(ra) # 80001b7a <usertrapret>
}
    80000eec:	60a2                	ld	ra,8(sp)
    80000eee:	6402                	ld	s0,0(sp)
    80000ef0:	0141                	addi	sp,sp,16
    80000ef2:	8082                	ret
    first = 0;
    80000ef4:	00008797          	auipc	a5,0x8
    80000ef8:	ba07a223          	sw	zero,-1116(a5) # 80008a98 <first.1>
    fsinit(ROOTDEV);
    80000efc:	4505                	li	a0,1
    80000efe:	00002097          	auipc	ra,0x2
    80000f02:	a92080e7          	jalr	-1390(ra) # 80002990 <fsinit>
    80000f06:	bff9                	j	80000ee4 <forkret+0x22>

0000000080000f08 <allocpid>:
{
    80000f08:	1101                	addi	sp,sp,-32
    80000f0a:	ec06                	sd	ra,24(sp)
    80000f0c:	e822                	sd	s0,16(sp)
    80000f0e:	e426                	sd	s1,8(sp)
    80000f10:	e04a                	sd	s2,0(sp)
    80000f12:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f14:	00008917          	auipc	s2,0x8
    80000f18:	c1c90913          	addi	s2,s2,-996 # 80008b30 <pid_lock>
    80000f1c:	854a                	mv	a0,s2
    80000f1e:	00005097          	auipc	ra,0x5
    80000f22:	280080e7          	jalr	640(ra) # 8000619e <acquire>
  pid = nextpid;
    80000f26:	00008797          	auipc	a5,0x8
    80000f2a:	b7678793          	addi	a5,a5,-1162 # 80008a9c <nextpid>
    80000f2e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f30:	0014871b          	addiw	a4,s1,1
    80000f34:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f36:	854a                	mv	a0,s2
    80000f38:	00005097          	auipc	ra,0x5
    80000f3c:	31a080e7          	jalr	794(ra) # 80006252 <release>
}
    80000f40:	8526                	mv	a0,s1
    80000f42:	60e2                	ld	ra,24(sp)
    80000f44:	6442                	ld	s0,16(sp)
    80000f46:	64a2                	ld	s1,8(sp)
    80000f48:	6902                	ld	s2,0(sp)
    80000f4a:	6105                	addi	sp,sp,32
    80000f4c:	8082                	ret

0000000080000f4e <proc_pagetable>:
{
    80000f4e:	1101                	addi	sp,sp,-32
    80000f50:	ec06                	sd	ra,24(sp)
    80000f52:	e822                	sd	s0,16(sp)
    80000f54:	e426                	sd	s1,8(sp)
    80000f56:	e04a                	sd	s2,0(sp)
    80000f58:	1000                	addi	s0,sp,32
    80000f5a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	8aa080e7          	jalr	-1878(ra) # 80000806 <uvmcreate>
    80000f64:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f66:	c121                	beqz	a0,80000fa6 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f68:	4729                	li	a4,10
    80000f6a:	00006697          	auipc	a3,0x6
    80000f6e:	09668693          	addi	a3,a3,150 # 80007000 <_trampoline>
    80000f72:	6605                	lui	a2,0x1
    80000f74:	040005b7          	lui	a1,0x4000
    80000f78:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f7a:	05b2                	slli	a1,a1,0xc
    80000f7c:	fffff097          	auipc	ra,0xfffff
    80000f80:	600080e7          	jalr	1536(ra) # 8000057c <mappages>
    80000f84:	02054863          	bltz	a0,80000fb4 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f88:	4719                	li	a4,6
    80000f8a:	05893683          	ld	a3,88(s2)
    80000f8e:	6605                	lui	a2,0x1
    80000f90:	020005b7          	lui	a1,0x2000
    80000f94:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f96:	05b6                	slli	a1,a1,0xd
    80000f98:	8526                	mv	a0,s1
    80000f9a:	fffff097          	auipc	ra,0xfffff
    80000f9e:	5e2080e7          	jalr	1506(ra) # 8000057c <mappages>
    80000fa2:	02054163          	bltz	a0,80000fc4 <proc_pagetable+0x76>
}
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	60e2                	ld	ra,24(sp)
    80000faa:	6442                	ld	s0,16(sp)
    80000fac:	64a2                	ld	s1,8(sp)
    80000fae:	6902                	ld	s2,0(sp)
    80000fb0:	6105                	addi	sp,sp,32
    80000fb2:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb4:	4581                	li	a1,0
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	00000097          	auipc	ra,0x0
    80000fbc:	a54080e7          	jalr	-1452(ra) # 80000a0c <uvmfree>
    return 0;
    80000fc0:	4481                	li	s1,0
    80000fc2:	b7d5                	j	80000fa6 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc4:	4681                	li	a3,0
    80000fc6:	4605                	li	a2,1
    80000fc8:	040005b7          	lui	a1,0x4000
    80000fcc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fce:	05b2                	slli	a1,a1,0xc
    80000fd0:	8526                	mv	a0,s1
    80000fd2:	fffff097          	auipc	ra,0xfffff
    80000fd6:	770080e7          	jalr	1904(ra) # 80000742 <uvmunmap>
    uvmfree(pagetable, 0);
    80000fda:	4581                	li	a1,0
    80000fdc:	8526                	mv	a0,s1
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	a2e080e7          	jalr	-1490(ra) # 80000a0c <uvmfree>
    return 0;
    80000fe6:	4481                	li	s1,0
    80000fe8:	bf7d                	j	80000fa6 <proc_pagetable+0x58>

0000000080000fea <proc_freepagetable>:
{
    80000fea:	1101                	addi	sp,sp,-32
    80000fec:	ec06                	sd	ra,24(sp)
    80000fee:	e822                	sd	s0,16(sp)
    80000ff0:	e426                	sd	s1,8(sp)
    80000ff2:	e04a                	sd	s2,0(sp)
    80000ff4:	1000                	addi	s0,sp,32
    80000ff6:	84aa                	mv	s1,a0
    80000ff8:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ffa:	4681                	li	a3,0
    80000ffc:	4605                	li	a2,1
    80000ffe:	040005b7          	lui	a1,0x4000
    80001002:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001004:	05b2                	slli	a1,a1,0xc
    80001006:	fffff097          	auipc	ra,0xfffff
    8000100a:	73c080e7          	jalr	1852(ra) # 80000742 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000100e:	4681                	li	a3,0
    80001010:	4605                	li	a2,1
    80001012:	020005b7          	lui	a1,0x2000
    80001016:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001018:	05b6                	slli	a1,a1,0xd
    8000101a:	8526                	mv	a0,s1
    8000101c:	fffff097          	auipc	ra,0xfffff
    80001020:	726080e7          	jalr	1830(ra) # 80000742 <uvmunmap>
  uvmfree(pagetable, sz);
    80001024:	85ca                	mv	a1,s2
    80001026:	8526                	mv	a0,s1
    80001028:	00000097          	auipc	ra,0x0
    8000102c:	9e4080e7          	jalr	-1564(ra) # 80000a0c <uvmfree>
}
    80001030:	60e2                	ld	ra,24(sp)
    80001032:	6442                	ld	s0,16(sp)
    80001034:	64a2                	ld	s1,8(sp)
    80001036:	6902                	ld	s2,0(sp)
    80001038:	6105                	addi	sp,sp,32
    8000103a:	8082                	ret

000000008000103c <freeproc>:
{
    8000103c:	1101                	addi	sp,sp,-32
    8000103e:	ec06                	sd	ra,24(sp)
    80001040:	e822                	sd	s0,16(sp)
    80001042:	e426                	sd	s1,8(sp)
    80001044:	1000                	addi	s0,sp,32
    80001046:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001048:	6d28                	ld	a0,88(a0)
    8000104a:	c509                	beqz	a0,80001054 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000104c:	fffff097          	auipc	ra,0xfffff
    80001050:	fd0080e7          	jalr	-48(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001054:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001058:	68a8                	ld	a0,80(s1)
    8000105a:	c511                	beqz	a0,80001066 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000105c:	64ac                	ld	a1,72(s1)
    8000105e:	00000097          	auipc	ra,0x0
    80001062:	f8c080e7          	jalr	-116(ra) # 80000fea <proc_freepagetable>
  p->pagetable = 0;
    80001066:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    8000106a:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000106e:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001072:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001076:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    8000107a:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000107e:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001082:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001086:	0004ac23          	sw	zero,24(s1)
}
    8000108a:	60e2                	ld	ra,24(sp)
    8000108c:	6442                	ld	s0,16(sp)
    8000108e:	64a2                	ld	s1,8(sp)
    80001090:	6105                	addi	sp,sp,32
    80001092:	8082                	ret

0000000080001094 <allocproc>:
{
    80001094:	1101                	addi	sp,sp,-32
    80001096:	ec06                	sd	ra,24(sp)
    80001098:	e822                	sd	s0,16(sp)
    8000109a:	e426                	sd	s1,8(sp)
    8000109c:	e04a                	sd	s2,0(sp)
    8000109e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a0:	00008497          	auipc	s1,0x8
    800010a4:	ec048493          	addi	s1,s1,-320 # 80008f60 <proc>
    800010a8:	0000e917          	auipc	s2,0xe
    800010ac:	ab890913          	addi	s2,s2,-1352 # 8000eb60 <tickslock>
    acquire(&p->lock);
    800010b0:	8526                	mv	a0,s1
    800010b2:	00005097          	auipc	ra,0x5
    800010b6:	0ec080e7          	jalr	236(ra) # 8000619e <acquire>
    if(p->state == UNUSED) {
    800010ba:	4c9c                	lw	a5,24(s1)
    800010bc:	cf81                	beqz	a5,800010d4 <allocproc+0x40>
      release(&p->lock);
    800010be:	8526                	mv	a0,s1
    800010c0:	00005097          	auipc	ra,0x5
    800010c4:	192080e7          	jalr	402(ra) # 80006252 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010c8:	17048493          	addi	s1,s1,368
    800010cc:	ff2492e3          	bne	s1,s2,800010b0 <allocproc+0x1c>
  return 0;
    800010d0:	4481                	li	s1,0
    800010d2:	a889                	j	80001124 <allocproc+0x90>
  p->pid = allocpid();
    800010d4:	00000097          	auipc	ra,0x0
    800010d8:	e34080e7          	jalr	-460(ra) # 80000f08 <allocpid>
    800010dc:	d888                	sw	a0,48(s1)
  p->state = USED;
    800010de:	4785                	li	a5,1
    800010e0:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	048080e7          	jalr	72(ra) # 8000012a <kalloc>
    800010ea:	892a                	mv	s2,a0
    800010ec:	eca8                	sd	a0,88(s1)
    800010ee:	c131                	beqz	a0,80001132 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00000097          	auipc	ra,0x0
    800010f6:	e5c080e7          	jalr	-420(ra) # 80000f4e <proc_pagetable>
    800010fa:	892a                	mv	s2,a0
    800010fc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010fe:	c531                	beqz	a0,8000114a <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    80001100:	07000613          	li	a2,112
    80001104:	4581                	li	a1,0
    80001106:	06048513          	addi	a0,s1,96
    8000110a:	fffff097          	auipc	ra,0xfffff
    8000110e:	0a8080e7          	jalr	168(ra) # 800001b2 <memset>
  p->context.ra = (uint64)forkret;
    80001112:	00000797          	auipc	a5,0x0
    80001116:	db078793          	addi	a5,a5,-592 # 80000ec2 <forkret>
    8000111a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000111c:	60bc                	ld	a5,64(s1)
    8000111e:	6705                	lui	a4,0x1
    80001120:	97ba                	add	a5,a5,a4
    80001122:	f4bc                	sd	a5,104(s1)
}
    80001124:	8526                	mv	a0,s1
    80001126:	60e2                	ld	ra,24(sp)
    80001128:	6442                	ld	s0,16(sp)
    8000112a:	64a2                	ld	s1,8(sp)
    8000112c:	6902                	ld	s2,0(sp)
    8000112e:	6105                	addi	sp,sp,32
    80001130:	8082                	ret
    freeproc(p);
    80001132:	8526                	mv	a0,s1
    80001134:	00000097          	auipc	ra,0x0
    80001138:	f08080e7          	jalr	-248(ra) # 8000103c <freeproc>
    release(&p->lock);
    8000113c:	8526                	mv	a0,s1
    8000113e:	00005097          	auipc	ra,0x5
    80001142:	114080e7          	jalr	276(ra) # 80006252 <release>
    return 0;
    80001146:	84ca                	mv	s1,s2
    80001148:	bff1                	j	80001124 <allocproc+0x90>
    freeproc(p);
    8000114a:	8526                	mv	a0,s1
    8000114c:	00000097          	auipc	ra,0x0
    80001150:	ef0080e7          	jalr	-272(ra) # 8000103c <freeproc>
    release(&p->lock);
    80001154:	8526                	mv	a0,s1
    80001156:	00005097          	auipc	ra,0x5
    8000115a:	0fc080e7          	jalr	252(ra) # 80006252 <release>
    return 0;
    8000115e:	84ca                	mv	s1,s2
    80001160:	b7d1                	j	80001124 <allocproc+0x90>

0000000080001162 <userinit>:
{
    80001162:	1101                	addi	sp,sp,-32
    80001164:	ec06                	sd	ra,24(sp)
    80001166:	e822                	sd	s0,16(sp)
    80001168:	e426                	sd	s1,8(sp)
    8000116a:	1000                	addi	s0,sp,32
  p = allocproc();
    8000116c:	00000097          	auipc	ra,0x0
    80001170:	f28080e7          	jalr	-216(ra) # 80001094 <allocproc>
    80001174:	84aa                	mv	s1,a0
  initproc = p;
    80001176:	00008797          	auipc	a5,0x8
    8000117a:	96a7bd23          	sd	a0,-1670(a5) # 80008af0 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    8000117e:	03400613          	li	a2,52
    80001182:	00008597          	auipc	a1,0x8
    80001186:	91e58593          	addi	a1,a1,-1762 # 80008aa0 <initcode>
    8000118a:	6928                	ld	a0,80(a0)
    8000118c:	fffff097          	auipc	ra,0xfffff
    80001190:	6a8080e7          	jalr	1704(ra) # 80000834 <uvmfirst>
  p->sz = PGSIZE;
    80001194:	6785                	lui	a5,0x1
    80001196:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001198:	6cb8                	ld	a4,88(s1)
    8000119a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000119e:	6cb8                	ld	a4,88(s1)
    800011a0:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800011a2:	4641                	li	a2,16
    800011a4:	00007597          	auipc	a1,0x7
    800011a8:	fdc58593          	addi	a1,a1,-36 # 80008180 <etext+0x180>
    800011ac:	15848513          	addi	a0,s1,344
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	14a080e7          	jalr	330(ra) # 800002fa <safestrcpy>
  p->cwd = namei("/");
    800011b8:	00007517          	auipc	a0,0x7
    800011bc:	fd850513          	addi	a0,a0,-40 # 80008190 <etext+0x190>
    800011c0:	00002097          	auipc	ra,0x2
    800011c4:	1ee080e7          	jalr	494(ra) # 800033ae <namei>
    800011c8:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800011cc:	478d                	li	a5,3
    800011ce:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800011d0:	8526                	mv	a0,s1
    800011d2:	00005097          	auipc	ra,0x5
    800011d6:	080080e7          	jalr	128(ra) # 80006252 <release>
}
    800011da:	60e2                	ld	ra,24(sp)
    800011dc:	6442                	ld	s0,16(sp)
    800011de:	64a2                	ld	s1,8(sp)
    800011e0:	6105                	addi	sp,sp,32
    800011e2:	8082                	ret

00000000800011e4 <growproc>:
{
    800011e4:	1101                	addi	sp,sp,-32
    800011e6:	ec06                	sd	ra,24(sp)
    800011e8:	e822                	sd	s0,16(sp)
    800011ea:	e426                	sd	s1,8(sp)
    800011ec:	e04a                	sd	s2,0(sp)
    800011ee:	1000                	addi	s0,sp,32
    800011f0:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800011f2:	00000097          	auipc	ra,0x0
    800011f6:	c98080e7          	jalr	-872(ra) # 80000e8a <myproc>
    800011fa:	84aa                	mv	s1,a0
  sz = p->sz;
    800011fc:	652c                	ld	a1,72(a0)
  if(n > 0){
    800011fe:	01204c63          	bgtz	s2,80001216 <growproc+0x32>
  } else if(n < 0){
    80001202:	02094663          	bltz	s2,8000122e <growproc+0x4a>
  p->sz = sz;
    80001206:	e4ac                	sd	a1,72(s1)
  return 0;
    80001208:	4501                	li	a0,0
}
    8000120a:	60e2                	ld	ra,24(sp)
    8000120c:	6442                	ld	s0,16(sp)
    8000120e:	64a2                	ld	s1,8(sp)
    80001210:	6902                	ld	s2,0(sp)
    80001212:	6105                	addi	sp,sp,32
    80001214:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001216:	4691                	li	a3,4
    80001218:	00b90633          	add	a2,s2,a1
    8000121c:	6928                	ld	a0,80(a0)
    8000121e:	fffff097          	auipc	ra,0xfffff
    80001222:	6d0080e7          	jalr	1744(ra) # 800008ee <uvmalloc>
    80001226:	85aa                	mv	a1,a0
    80001228:	fd79                	bnez	a0,80001206 <growproc+0x22>
      return -1;
    8000122a:	557d                	li	a0,-1
    8000122c:	bff9                	j	8000120a <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000122e:	00b90633          	add	a2,s2,a1
    80001232:	6928                	ld	a0,80(a0)
    80001234:	fffff097          	auipc	ra,0xfffff
    80001238:	672080e7          	jalr	1650(ra) # 800008a6 <uvmdealloc>
    8000123c:	85aa                	mv	a1,a0
    8000123e:	b7e1                	j	80001206 <growproc+0x22>

0000000080001240 <fork>:
{
    80001240:	7139                	addi	sp,sp,-64
    80001242:	fc06                	sd	ra,56(sp)
    80001244:	f822                	sd	s0,48(sp)
    80001246:	f426                	sd	s1,40(sp)
    80001248:	f04a                	sd	s2,32(sp)
    8000124a:	ec4e                	sd	s3,24(sp)
    8000124c:	e852                	sd	s4,16(sp)
    8000124e:	e456                	sd	s5,8(sp)
    80001250:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001252:	00000097          	auipc	ra,0x0
    80001256:	c38080e7          	jalr	-968(ra) # 80000e8a <myproc>
    8000125a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	e38080e7          	jalr	-456(ra) # 80001094 <allocproc>
    80001264:	12050063          	beqz	a0,80001384 <fork+0x144>
    80001268:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000126a:	048ab603          	ld	a2,72(s5)
    8000126e:	692c                	ld	a1,80(a0)
    80001270:	050ab503          	ld	a0,80(s5)
    80001274:	fffff097          	auipc	ra,0xfffff
    80001278:	7d2080e7          	jalr	2002(ra) # 80000a46 <uvmcopy>
    8000127c:	04054863          	bltz	a0,800012cc <fork+0x8c>
  np->sz = p->sz;
    80001280:	048ab783          	ld	a5,72(s5)
    80001284:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001288:	058ab683          	ld	a3,88(s5)
    8000128c:	87b6                	mv	a5,a3
    8000128e:	0589b703          	ld	a4,88(s3)
    80001292:	12068693          	addi	a3,a3,288
    80001296:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    8000129a:	6788                	ld	a0,8(a5)
    8000129c:	6b8c                	ld	a1,16(a5)
    8000129e:	6f90                	ld	a2,24(a5)
    800012a0:	01073023          	sd	a6,0(a4)
    800012a4:	e708                	sd	a0,8(a4)
    800012a6:	eb0c                	sd	a1,16(a4)
    800012a8:	ef10                	sd	a2,24(a4)
    800012aa:	02078793          	addi	a5,a5,32
    800012ae:	02070713          	addi	a4,a4,32
    800012b2:	fed792e3          	bne	a5,a3,80001296 <fork+0x56>
  np->trapframe->a0 = 0;
    800012b6:	0589b783          	ld	a5,88(s3)
    800012ba:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800012be:	0d0a8493          	addi	s1,s5,208
    800012c2:	0d098913          	addi	s2,s3,208
    800012c6:	150a8a13          	addi	s4,s5,336
    800012ca:	a00d                	j	800012ec <fork+0xac>
    freeproc(np);
    800012cc:	854e                	mv	a0,s3
    800012ce:	00000097          	auipc	ra,0x0
    800012d2:	d6e080e7          	jalr	-658(ra) # 8000103c <freeproc>
    release(&np->lock);
    800012d6:	854e                	mv	a0,s3
    800012d8:	00005097          	auipc	ra,0x5
    800012dc:	f7a080e7          	jalr	-134(ra) # 80006252 <release>
    return -1;
    800012e0:	597d                	li	s2,-1
    800012e2:	a079                	j	80001370 <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800012e4:	04a1                	addi	s1,s1,8
    800012e6:	0921                	addi	s2,s2,8
    800012e8:	01448b63          	beq	s1,s4,800012fe <fork+0xbe>
    if(p->ofile[i])
    800012ec:	6088                	ld	a0,0(s1)
    800012ee:	d97d                	beqz	a0,800012e4 <fork+0xa4>
      np->ofile[i] = filedup(p->ofile[i]);
    800012f0:	00002097          	auipc	ra,0x2
    800012f4:	730080e7          	jalr	1840(ra) # 80003a20 <filedup>
    800012f8:	00a93023          	sd	a0,0(s2)
    800012fc:	b7e5                	j	800012e4 <fork+0xa4>
  np->cwd = idup(p->cwd);
    800012fe:	150ab503          	ld	a0,336(s5)
    80001302:	00002097          	auipc	ra,0x2
    80001306:	8c8080e7          	jalr	-1848(ra) # 80002bca <idup>
    8000130a:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000130e:	4641                	li	a2,16
    80001310:	158a8593          	addi	a1,s5,344
    80001314:	15898513          	addi	a0,s3,344
    80001318:	fffff097          	auipc	ra,0xfffff
    8000131c:	fe2080e7          	jalr	-30(ra) # 800002fa <safestrcpy>
  pid = np->pid;
    80001320:	0309a903          	lw	s2,48(s3)
  np->trace = p->trace;
    80001324:	168aa783          	lw	a5,360(s5)
    80001328:	16f9a423          	sw	a5,360(s3)
  release(&np->lock);
    8000132c:	854e                	mv	a0,s3
    8000132e:	00005097          	auipc	ra,0x5
    80001332:	f24080e7          	jalr	-220(ra) # 80006252 <release>
  acquire(&wait_lock);
    80001336:	00008497          	auipc	s1,0x8
    8000133a:	81248493          	addi	s1,s1,-2030 # 80008b48 <wait_lock>
    8000133e:	8526                	mv	a0,s1
    80001340:	00005097          	auipc	ra,0x5
    80001344:	e5e080e7          	jalr	-418(ra) # 8000619e <acquire>
  np->parent = p;
    80001348:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	f04080e7          	jalr	-252(ra) # 80006252 <release>
  acquire(&np->lock);
    80001356:	854e                	mv	a0,s3
    80001358:	00005097          	auipc	ra,0x5
    8000135c:	e46080e7          	jalr	-442(ra) # 8000619e <acquire>
  np->state = RUNNABLE;
    80001360:	478d                	li	a5,3
    80001362:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001366:	854e                	mv	a0,s3
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	eea080e7          	jalr	-278(ra) # 80006252 <release>
}
    80001370:	854a                	mv	a0,s2
    80001372:	70e2                	ld	ra,56(sp)
    80001374:	7442                	ld	s0,48(sp)
    80001376:	74a2                	ld	s1,40(sp)
    80001378:	7902                	ld	s2,32(sp)
    8000137a:	69e2                	ld	s3,24(sp)
    8000137c:	6a42                	ld	s4,16(sp)
    8000137e:	6aa2                	ld	s5,8(sp)
    80001380:	6121                	addi	sp,sp,64
    80001382:	8082                	ret
    return -1;
    80001384:	597d                	li	s2,-1
    80001386:	b7ed                	j	80001370 <fork+0x130>

0000000080001388 <scheduler>:
{
    80001388:	7139                	addi	sp,sp,-64
    8000138a:	fc06                	sd	ra,56(sp)
    8000138c:	f822                	sd	s0,48(sp)
    8000138e:	f426                	sd	s1,40(sp)
    80001390:	f04a                	sd	s2,32(sp)
    80001392:	ec4e                	sd	s3,24(sp)
    80001394:	e852                	sd	s4,16(sp)
    80001396:	e456                	sd	s5,8(sp)
    80001398:	e05a                	sd	s6,0(sp)
    8000139a:	0080                	addi	s0,sp,64
    8000139c:	8792                	mv	a5,tp
  int id = r_tp();
    8000139e:	2781                	sext.w	a5,a5
  c->proc = 0;
    800013a0:	00779a93          	slli	s5,a5,0x7
    800013a4:	00007717          	auipc	a4,0x7
    800013a8:	78c70713          	addi	a4,a4,1932 # 80008b30 <pid_lock>
    800013ac:	9756                	add	a4,a4,s5
    800013ae:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800013b2:	00007717          	auipc	a4,0x7
    800013b6:	7b670713          	addi	a4,a4,1974 # 80008b68 <cpus+0x8>
    800013ba:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800013bc:	498d                	li	s3,3
        p->state = RUNNING;
    800013be:	4b11                	li	s6,4
        c->proc = p;
    800013c0:	079e                	slli	a5,a5,0x7
    800013c2:	00007a17          	auipc	s4,0x7
    800013c6:	76ea0a13          	addi	s4,s4,1902 # 80008b30 <pid_lock>
    800013ca:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800013cc:	0000d917          	auipc	s2,0xd
    800013d0:	79490913          	addi	s2,s2,1940 # 8000eb60 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013d8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013dc:	10079073          	csrw	sstatus,a5
    800013e0:	00008497          	auipc	s1,0x8
    800013e4:	b8048493          	addi	s1,s1,-1152 # 80008f60 <proc>
    800013e8:	a811                	j	800013fc <scheduler+0x74>
      release(&p->lock);
    800013ea:	8526                	mv	a0,s1
    800013ec:	00005097          	auipc	ra,0x5
    800013f0:	e66080e7          	jalr	-410(ra) # 80006252 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800013f4:	17048493          	addi	s1,s1,368
    800013f8:	fd248ee3          	beq	s1,s2,800013d4 <scheduler+0x4c>
      acquire(&p->lock);
    800013fc:	8526                	mv	a0,s1
    800013fe:	00005097          	auipc	ra,0x5
    80001402:	da0080e7          	jalr	-608(ra) # 8000619e <acquire>
      if(p->state == RUNNABLE) {
    80001406:	4c9c                	lw	a5,24(s1)
    80001408:	ff3791e3          	bne	a5,s3,800013ea <scheduler+0x62>
        p->state = RUNNING;
    8000140c:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001410:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001414:	06048593          	addi	a1,s1,96
    80001418:	8556                	mv	a0,s5
    8000141a:	00000097          	auipc	ra,0x0
    8000141e:	6b6080e7          	jalr	1718(ra) # 80001ad0 <swtch>
        c->proc = 0;
    80001422:	020a3823          	sd	zero,48(s4)
    80001426:	b7d1                	j	800013ea <scheduler+0x62>

0000000080001428 <sched>:
{
    80001428:	7179                	addi	sp,sp,-48
    8000142a:	f406                	sd	ra,40(sp)
    8000142c:	f022                	sd	s0,32(sp)
    8000142e:	ec26                	sd	s1,24(sp)
    80001430:	e84a                	sd	s2,16(sp)
    80001432:	e44e                	sd	s3,8(sp)
    80001434:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	a54080e7          	jalr	-1452(ra) # 80000e8a <myproc>
    8000143e:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001440:	00005097          	auipc	ra,0x5
    80001444:	ce4080e7          	jalr	-796(ra) # 80006124 <holding>
    80001448:	c93d                	beqz	a0,800014be <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000144a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000144c:	2781                	sext.w	a5,a5
    8000144e:	079e                	slli	a5,a5,0x7
    80001450:	00007717          	auipc	a4,0x7
    80001454:	6e070713          	addi	a4,a4,1760 # 80008b30 <pid_lock>
    80001458:	97ba                	add	a5,a5,a4
    8000145a:	0a87a703          	lw	a4,168(a5)
    8000145e:	4785                	li	a5,1
    80001460:	06f71763          	bne	a4,a5,800014ce <sched+0xa6>
  if(p->state == RUNNING)
    80001464:	4c98                	lw	a4,24(s1)
    80001466:	4791                	li	a5,4
    80001468:	06f70b63          	beq	a4,a5,800014de <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000146c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001470:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001472:	efb5                	bnez	a5,800014ee <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001474:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001476:	00007917          	auipc	s2,0x7
    8000147a:	6ba90913          	addi	s2,s2,1722 # 80008b30 <pid_lock>
    8000147e:	2781                	sext.w	a5,a5
    80001480:	079e                	slli	a5,a5,0x7
    80001482:	97ca                	add	a5,a5,s2
    80001484:	0ac7a983          	lw	s3,172(a5)
    80001488:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	00007597          	auipc	a1,0x7
    80001492:	6da58593          	addi	a1,a1,1754 # 80008b68 <cpus+0x8>
    80001496:	95be                	add	a1,a1,a5
    80001498:	06048513          	addi	a0,s1,96
    8000149c:	00000097          	auipc	ra,0x0
    800014a0:	634080e7          	jalr	1588(ra) # 80001ad0 <swtch>
    800014a4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800014a6:	2781                	sext.w	a5,a5
    800014a8:	079e                	slli	a5,a5,0x7
    800014aa:	993e                	add	s2,s2,a5
    800014ac:	0b392623          	sw	s3,172(s2)
}
    800014b0:	70a2                	ld	ra,40(sp)
    800014b2:	7402                	ld	s0,32(sp)
    800014b4:	64e2                	ld	s1,24(sp)
    800014b6:	6942                	ld	s2,16(sp)
    800014b8:	69a2                	ld	s3,8(sp)
    800014ba:	6145                	addi	sp,sp,48
    800014bc:	8082                	ret
    panic("sched p->lock");
    800014be:	00007517          	auipc	a0,0x7
    800014c2:	cda50513          	addi	a0,a0,-806 # 80008198 <etext+0x198>
    800014c6:	00004097          	auipc	ra,0x4
    800014ca:	7a0080e7          	jalr	1952(ra) # 80005c66 <panic>
    panic("sched locks");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	cda50513          	addi	a0,a0,-806 # 800081a8 <etext+0x1a8>
    800014d6:	00004097          	auipc	ra,0x4
    800014da:	790080e7          	jalr	1936(ra) # 80005c66 <panic>
    panic("sched running");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	cda50513          	addi	a0,a0,-806 # 800081b8 <etext+0x1b8>
    800014e6:	00004097          	auipc	ra,0x4
    800014ea:	780080e7          	jalr	1920(ra) # 80005c66 <panic>
    panic("sched interruptible");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	cda50513          	addi	a0,a0,-806 # 800081c8 <etext+0x1c8>
    800014f6:	00004097          	auipc	ra,0x4
    800014fa:	770080e7          	jalr	1904(ra) # 80005c66 <panic>

00000000800014fe <yield>:
{
    800014fe:	1101                	addi	sp,sp,-32
    80001500:	ec06                	sd	ra,24(sp)
    80001502:	e822                	sd	s0,16(sp)
    80001504:	e426                	sd	s1,8(sp)
    80001506:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001508:	00000097          	auipc	ra,0x0
    8000150c:	982080e7          	jalr	-1662(ra) # 80000e8a <myproc>
    80001510:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001512:	00005097          	auipc	ra,0x5
    80001516:	c8c080e7          	jalr	-884(ra) # 8000619e <acquire>
  p->state = RUNNABLE;
    8000151a:	478d                	li	a5,3
    8000151c:	cc9c                	sw	a5,24(s1)
  sched();
    8000151e:	00000097          	auipc	ra,0x0
    80001522:	f0a080e7          	jalr	-246(ra) # 80001428 <sched>
  release(&p->lock);
    80001526:	8526                	mv	a0,s1
    80001528:	00005097          	auipc	ra,0x5
    8000152c:	d2a080e7          	jalr	-726(ra) # 80006252 <release>
}
    80001530:	60e2                	ld	ra,24(sp)
    80001532:	6442                	ld	s0,16(sp)
    80001534:	64a2                	ld	s1,8(sp)
    80001536:	6105                	addi	sp,sp,32
    80001538:	8082                	ret

000000008000153a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000153a:	7179                	addi	sp,sp,-48
    8000153c:	f406                	sd	ra,40(sp)
    8000153e:	f022                	sd	s0,32(sp)
    80001540:	ec26                	sd	s1,24(sp)
    80001542:	e84a                	sd	s2,16(sp)
    80001544:	e44e                	sd	s3,8(sp)
    80001546:	1800                	addi	s0,sp,48
    80001548:	89aa                	mv	s3,a0
    8000154a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	93e080e7          	jalr	-1730(ra) # 80000e8a <myproc>
    80001554:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001556:	00005097          	auipc	ra,0x5
    8000155a:	c48080e7          	jalr	-952(ra) # 8000619e <acquire>
  release(lk);
    8000155e:	854a                	mv	a0,s2
    80001560:	00005097          	auipc	ra,0x5
    80001564:	cf2080e7          	jalr	-782(ra) # 80006252 <release>

  // Go to sleep.
  p->chan = chan;
    80001568:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000156c:	4789                	li	a5,2
    8000156e:	cc9c                	sw	a5,24(s1)

  sched();
    80001570:	00000097          	auipc	ra,0x0
    80001574:	eb8080e7          	jalr	-328(ra) # 80001428 <sched>

  // Tidy up.
  p->chan = 0;
    80001578:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000157c:	8526                	mv	a0,s1
    8000157e:	00005097          	auipc	ra,0x5
    80001582:	cd4080e7          	jalr	-812(ra) # 80006252 <release>
  acquire(lk);
    80001586:	854a                	mv	a0,s2
    80001588:	00005097          	auipc	ra,0x5
    8000158c:	c16080e7          	jalr	-1002(ra) # 8000619e <acquire>
}
    80001590:	70a2                	ld	ra,40(sp)
    80001592:	7402                	ld	s0,32(sp)
    80001594:	64e2                	ld	s1,24(sp)
    80001596:	6942                	ld	s2,16(sp)
    80001598:	69a2                	ld	s3,8(sp)
    8000159a:	6145                	addi	sp,sp,48
    8000159c:	8082                	ret

000000008000159e <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000159e:	7139                	addi	sp,sp,-64
    800015a0:	fc06                	sd	ra,56(sp)
    800015a2:	f822                	sd	s0,48(sp)
    800015a4:	f426                	sd	s1,40(sp)
    800015a6:	f04a                	sd	s2,32(sp)
    800015a8:	ec4e                	sd	s3,24(sp)
    800015aa:	e852                	sd	s4,16(sp)
    800015ac:	e456                	sd	s5,8(sp)
    800015ae:	0080                	addi	s0,sp,64
    800015b0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800015b2:	00008497          	auipc	s1,0x8
    800015b6:	9ae48493          	addi	s1,s1,-1618 # 80008f60 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800015ba:	4989                	li	s3,2
        p->state = RUNNABLE;
    800015bc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800015be:	0000d917          	auipc	s2,0xd
    800015c2:	5a290913          	addi	s2,s2,1442 # 8000eb60 <tickslock>
    800015c6:	a811                	j	800015da <wakeup+0x3c>
      }
      release(&p->lock);
    800015c8:	8526                	mv	a0,s1
    800015ca:	00005097          	auipc	ra,0x5
    800015ce:	c88080e7          	jalr	-888(ra) # 80006252 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015d2:	17048493          	addi	s1,s1,368
    800015d6:	03248663          	beq	s1,s2,80001602 <wakeup+0x64>
    if(p != myproc()){
    800015da:	00000097          	auipc	ra,0x0
    800015de:	8b0080e7          	jalr	-1872(ra) # 80000e8a <myproc>
    800015e2:	fea488e3          	beq	s1,a0,800015d2 <wakeup+0x34>
      acquire(&p->lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	00005097          	auipc	ra,0x5
    800015ec:	bb6080e7          	jalr	-1098(ra) # 8000619e <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800015f0:	4c9c                	lw	a5,24(s1)
    800015f2:	fd379be3          	bne	a5,s3,800015c8 <wakeup+0x2a>
    800015f6:	709c                	ld	a5,32(s1)
    800015f8:	fd4798e3          	bne	a5,s4,800015c8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800015fc:	0154ac23          	sw	s5,24(s1)
    80001600:	b7e1                	j	800015c8 <wakeup+0x2a>
    }
  }
}
    80001602:	70e2                	ld	ra,56(sp)
    80001604:	7442                	ld	s0,48(sp)
    80001606:	74a2                	ld	s1,40(sp)
    80001608:	7902                	ld	s2,32(sp)
    8000160a:	69e2                	ld	s3,24(sp)
    8000160c:	6a42                	ld	s4,16(sp)
    8000160e:	6aa2                	ld	s5,8(sp)
    80001610:	6121                	addi	sp,sp,64
    80001612:	8082                	ret

0000000080001614 <reparent>:
{
    80001614:	7179                	addi	sp,sp,-48
    80001616:	f406                	sd	ra,40(sp)
    80001618:	f022                	sd	s0,32(sp)
    8000161a:	ec26                	sd	s1,24(sp)
    8000161c:	e84a                	sd	s2,16(sp)
    8000161e:	e44e                	sd	s3,8(sp)
    80001620:	e052                	sd	s4,0(sp)
    80001622:	1800                	addi	s0,sp,48
    80001624:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001626:	00008497          	auipc	s1,0x8
    8000162a:	93a48493          	addi	s1,s1,-1734 # 80008f60 <proc>
      pp->parent = initproc;
    8000162e:	00007a17          	auipc	s4,0x7
    80001632:	4c2a0a13          	addi	s4,s4,1218 # 80008af0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001636:	0000d997          	auipc	s3,0xd
    8000163a:	52a98993          	addi	s3,s3,1322 # 8000eb60 <tickslock>
    8000163e:	a029                	j	80001648 <reparent+0x34>
    80001640:	17048493          	addi	s1,s1,368
    80001644:	01348d63          	beq	s1,s3,8000165e <reparent+0x4a>
    if(pp->parent == p){
    80001648:	7c9c                	ld	a5,56(s1)
    8000164a:	ff279be3          	bne	a5,s2,80001640 <reparent+0x2c>
      pp->parent = initproc;
    8000164e:	000a3503          	ld	a0,0(s4)
    80001652:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001654:	00000097          	auipc	ra,0x0
    80001658:	f4a080e7          	jalr	-182(ra) # 8000159e <wakeup>
    8000165c:	b7d5                	j	80001640 <reparent+0x2c>
}
    8000165e:	70a2                	ld	ra,40(sp)
    80001660:	7402                	ld	s0,32(sp)
    80001662:	64e2                	ld	s1,24(sp)
    80001664:	6942                	ld	s2,16(sp)
    80001666:	69a2                	ld	s3,8(sp)
    80001668:	6a02                	ld	s4,0(sp)
    8000166a:	6145                	addi	sp,sp,48
    8000166c:	8082                	ret

000000008000166e <exit>:
{
    8000166e:	7179                	addi	sp,sp,-48
    80001670:	f406                	sd	ra,40(sp)
    80001672:	f022                	sd	s0,32(sp)
    80001674:	ec26                	sd	s1,24(sp)
    80001676:	e84a                	sd	s2,16(sp)
    80001678:	e44e                	sd	s3,8(sp)
    8000167a:	e052                	sd	s4,0(sp)
    8000167c:	1800                	addi	s0,sp,48
    8000167e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001680:	00000097          	auipc	ra,0x0
    80001684:	80a080e7          	jalr	-2038(ra) # 80000e8a <myproc>
    80001688:	89aa                	mv	s3,a0
  if(p == initproc)
    8000168a:	00007797          	auipc	a5,0x7
    8000168e:	4667b783          	ld	a5,1126(a5) # 80008af0 <initproc>
    80001692:	0d050493          	addi	s1,a0,208
    80001696:	15050913          	addi	s2,a0,336
    8000169a:	02a79363          	bne	a5,a0,800016c0 <exit+0x52>
    panic("init exiting");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	b4250513          	addi	a0,a0,-1214 # 800081e0 <etext+0x1e0>
    800016a6:	00004097          	auipc	ra,0x4
    800016aa:	5c0080e7          	jalr	1472(ra) # 80005c66 <panic>
      fileclose(f);
    800016ae:	00002097          	auipc	ra,0x2
    800016b2:	3c4080e7          	jalr	964(ra) # 80003a72 <fileclose>
      p->ofile[fd] = 0;
    800016b6:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800016ba:	04a1                	addi	s1,s1,8
    800016bc:	01248563          	beq	s1,s2,800016c6 <exit+0x58>
    if(p->ofile[fd]){
    800016c0:	6088                	ld	a0,0(s1)
    800016c2:	f575                	bnez	a0,800016ae <exit+0x40>
    800016c4:	bfdd                	j	800016ba <exit+0x4c>
  begin_op();
    800016c6:	00002097          	auipc	ra,0x2
    800016ca:	ee8080e7          	jalr	-280(ra) # 800035ae <begin_op>
  iput(p->cwd);
    800016ce:	1509b503          	ld	a0,336(s3)
    800016d2:	00001097          	auipc	ra,0x1
    800016d6:	6f0080e7          	jalr	1776(ra) # 80002dc2 <iput>
  end_op();
    800016da:	00002097          	auipc	ra,0x2
    800016de:	f4e080e7          	jalr	-178(ra) # 80003628 <end_op>
  p->cwd = 0;
    800016e2:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800016e6:	00007497          	auipc	s1,0x7
    800016ea:	46248493          	addi	s1,s1,1122 # 80008b48 <wait_lock>
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	aae080e7          	jalr	-1362(ra) # 8000619e <acquire>
  reparent(p);
    800016f8:	854e                	mv	a0,s3
    800016fa:	00000097          	auipc	ra,0x0
    800016fe:	f1a080e7          	jalr	-230(ra) # 80001614 <reparent>
  wakeup(p->parent);
    80001702:	0389b503          	ld	a0,56(s3)
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	e98080e7          	jalr	-360(ra) # 8000159e <wakeup>
  acquire(&p->lock);
    8000170e:	854e                	mv	a0,s3
    80001710:	00005097          	auipc	ra,0x5
    80001714:	a8e080e7          	jalr	-1394(ra) # 8000619e <acquire>
  p->xstate = status;
    80001718:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000171c:	4795                	li	a5,5
    8000171e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001722:	8526                	mv	a0,s1
    80001724:	00005097          	auipc	ra,0x5
    80001728:	b2e080e7          	jalr	-1234(ra) # 80006252 <release>
  sched();
    8000172c:	00000097          	auipc	ra,0x0
    80001730:	cfc080e7          	jalr	-772(ra) # 80001428 <sched>
  panic("zombie exit");
    80001734:	00007517          	auipc	a0,0x7
    80001738:	abc50513          	addi	a0,a0,-1348 # 800081f0 <etext+0x1f0>
    8000173c:	00004097          	auipc	ra,0x4
    80001740:	52a080e7          	jalr	1322(ra) # 80005c66 <panic>

0000000080001744 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001744:	7179                	addi	sp,sp,-48
    80001746:	f406                	sd	ra,40(sp)
    80001748:	f022                	sd	s0,32(sp)
    8000174a:	ec26                	sd	s1,24(sp)
    8000174c:	e84a                	sd	s2,16(sp)
    8000174e:	e44e                	sd	s3,8(sp)
    80001750:	1800                	addi	s0,sp,48
    80001752:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001754:	00008497          	auipc	s1,0x8
    80001758:	80c48493          	addi	s1,s1,-2036 # 80008f60 <proc>
    8000175c:	0000d997          	auipc	s3,0xd
    80001760:	40498993          	addi	s3,s3,1028 # 8000eb60 <tickslock>
    acquire(&p->lock);
    80001764:	8526                	mv	a0,s1
    80001766:	00005097          	auipc	ra,0x5
    8000176a:	a38080e7          	jalr	-1480(ra) # 8000619e <acquire>
    if(p->pid == pid){
    8000176e:	589c                	lw	a5,48(s1)
    80001770:	01278d63          	beq	a5,s2,8000178a <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	adc080e7          	jalr	-1316(ra) # 80006252 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000177e:	17048493          	addi	s1,s1,368
    80001782:	ff3491e3          	bne	s1,s3,80001764 <kill+0x20>
  }
  return -1;
    80001786:	557d                	li	a0,-1
    80001788:	a829                	j	800017a2 <kill+0x5e>
      p->killed = 1;
    8000178a:	4785                	li	a5,1
    8000178c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000178e:	4c98                	lw	a4,24(s1)
    80001790:	4789                	li	a5,2
    80001792:	00f70f63          	beq	a4,a5,800017b0 <kill+0x6c>
      release(&p->lock);
    80001796:	8526                	mv	a0,s1
    80001798:	00005097          	auipc	ra,0x5
    8000179c:	aba080e7          	jalr	-1350(ra) # 80006252 <release>
      return 0;
    800017a0:	4501                	li	a0,0
}
    800017a2:	70a2                	ld	ra,40(sp)
    800017a4:	7402                	ld	s0,32(sp)
    800017a6:	64e2                	ld	s1,24(sp)
    800017a8:	6942                	ld	s2,16(sp)
    800017aa:	69a2                	ld	s3,8(sp)
    800017ac:	6145                	addi	sp,sp,48
    800017ae:	8082                	ret
        p->state = RUNNABLE;
    800017b0:	478d                	li	a5,3
    800017b2:	cc9c                	sw	a5,24(s1)
    800017b4:	b7cd                	j	80001796 <kill+0x52>

00000000800017b6 <setkilled>:

void
setkilled(struct proc *p)
{
    800017b6:	1101                	addi	sp,sp,-32
    800017b8:	ec06                	sd	ra,24(sp)
    800017ba:	e822                	sd	s0,16(sp)
    800017bc:	e426                	sd	s1,8(sp)
    800017be:	1000                	addi	s0,sp,32
    800017c0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800017c2:	00005097          	auipc	ra,0x5
    800017c6:	9dc080e7          	jalr	-1572(ra) # 8000619e <acquire>
  p->killed = 1;
    800017ca:	4785                	li	a5,1
    800017cc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	00005097          	auipc	ra,0x5
    800017d4:	a82080e7          	jalr	-1406(ra) # 80006252 <release>
}
    800017d8:	60e2                	ld	ra,24(sp)
    800017da:	6442                	ld	s0,16(sp)
    800017dc:	64a2                	ld	s1,8(sp)
    800017de:	6105                	addi	sp,sp,32
    800017e0:	8082                	ret

00000000800017e2 <killed>:

int
killed(struct proc *p)
{
    800017e2:	1101                	addi	sp,sp,-32
    800017e4:	ec06                	sd	ra,24(sp)
    800017e6:	e822                	sd	s0,16(sp)
    800017e8:	e426                	sd	s1,8(sp)
    800017ea:	e04a                	sd	s2,0(sp)
    800017ec:	1000                	addi	s0,sp,32
    800017ee:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800017f0:	00005097          	auipc	ra,0x5
    800017f4:	9ae080e7          	jalr	-1618(ra) # 8000619e <acquire>
  k = p->killed;
    800017f8:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800017fc:	8526                	mv	a0,s1
    800017fe:	00005097          	auipc	ra,0x5
    80001802:	a54080e7          	jalr	-1452(ra) # 80006252 <release>
  return k;
}
    80001806:	854a                	mv	a0,s2
    80001808:	60e2                	ld	ra,24(sp)
    8000180a:	6442                	ld	s0,16(sp)
    8000180c:	64a2                	ld	s1,8(sp)
    8000180e:	6902                	ld	s2,0(sp)
    80001810:	6105                	addi	sp,sp,32
    80001812:	8082                	ret

0000000080001814 <wait>:
{
    80001814:	715d                	addi	sp,sp,-80
    80001816:	e486                	sd	ra,72(sp)
    80001818:	e0a2                	sd	s0,64(sp)
    8000181a:	fc26                	sd	s1,56(sp)
    8000181c:	f84a                	sd	s2,48(sp)
    8000181e:	f44e                	sd	s3,40(sp)
    80001820:	f052                	sd	s4,32(sp)
    80001822:	ec56                	sd	s5,24(sp)
    80001824:	e85a                	sd	s6,16(sp)
    80001826:	e45e                	sd	s7,8(sp)
    80001828:	e062                	sd	s8,0(sp)
    8000182a:	0880                	addi	s0,sp,80
    8000182c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000182e:	fffff097          	auipc	ra,0xfffff
    80001832:	65c080e7          	jalr	1628(ra) # 80000e8a <myproc>
    80001836:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001838:	00007517          	auipc	a0,0x7
    8000183c:	31050513          	addi	a0,a0,784 # 80008b48 <wait_lock>
    80001840:	00005097          	auipc	ra,0x5
    80001844:	95e080e7          	jalr	-1698(ra) # 8000619e <acquire>
    havekids = 0;
    80001848:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000184a:	4a15                	li	s4,5
        havekids = 1;
    8000184c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000184e:	0000d997          	auipc	s3,0xd
    80001852:	31298993          	addi	s3,s3,786 # 8000eb60 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001856:	00007c17          	auipc	s8,0x7
    8000185a:	2f2c0c13          	addi	s8,s8,754 # 80008b48 <wait_lock>
    8000185e:	a0d1                	j	80001922 <wait+0x10e>
          pid = pp->pid;
    80001860:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001864:	000b0e63          	beqz	s6,80001880 <wait+0x6c>
    80001868:	4691                	li	a3,4
    8000186a:	02c48613          	addi	a2,s1,44
    8000186e:	85da                	mv	a1,s6
    80001870:	05093503          	ld	a0,80(s2)
    80001874:	fffff097          	auipc	ra,0xfffff
    80001878:	2d6080e7          	jalr	726(ra) # 80000b4a <copyout>
    8000187c:	04054163          	bltz	a0,800018be <wait+0xaa>
          freeproc(pp);
    80001880:	8526                	mv	a0,s1
    80001882:	fffff097          	auipc	ra,0xfffff
    80001886:	7ba080e7          	jalr	1978(ra) # 8000103c <freeproc>
          release(&pp->lock);
    8000188a:	8526                	mv	a0,s1
    8000188c:	00005097          	auipc	ra,0x5
    80001890:	9c6080e7          	jalr	-1594(ra) # 80006252 <release>
          release(&wait_lock);
    80001894:	00007517          	auipc	a0,0x7
    80001898:	2b450513          	addi	a0,a0,692 # 80008b48 <wait_lock>
    8000189c:	00005097          	auipc	ra,0x5
    800018a0:	9b6080e7          	jalr	-1610(ra) # 80006252 <release>
}
    800018a4:	854e                	mv	a0,s3
    800018a6:	60a6                	ld	ra,72(sp)
    800018a8:	6406                	ld	s0,64(sp)
    800018aa:	74e2                	ld	s1,56(sp)
    800018ac:	7942                	ld	s2,48(sp)
    800018ae:	79a2                	ld	s3,40(sp)
    800018b0:	7a02                	ld	s4,32(sp)
    800018b2:	6ae2                	ld	s5,24(sp)
    800018b4:	6b42                	ld	s6,16(sp)
    800018b6:	6ba2                	ld	s7,8(sp)
    800018b8:	6c02                	ld	s8,0(sp)
    800018ba:	6161                	addi	sp,sp,80
    800018bc:	8082                	ret
            release(&pp->lock);
    800018be:	8526                	mv	a0,s1
    800018c0:	00005097          	auipc	ra,0x5
    800018c4:	992080e7          	jalr	-1646(ra) # 80006252 <release>
            release(&wait_lock);
    800018c8:	00007517          	auipc	a0,0x7
    800018cc:	28050513          	addi	a0,a0,640 # 80008b48 <wait_lock>
    800018d0:	00005097          	auipc	ra,0x5
    800018d4:	982080e7          	jalr	-1662(ra) # 80006252 <release>
            return -1;
    800018d8:	59fd                	li	s3,-1
    800018da:	b7e9                	j	800018a4 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018dc:	17048493          	addi	s1,s1,368
    800018e0:	03348463          	beq	s1,s3,80001908 <wait+0xf4>
      if(pp->parent == p){
    800018e4:	7c9c                	ld	a5,56(s1)
    800018e6:	ff279be3          	bne	a5,s2,800018dc <wait+0xc8>
        acquire(&pp->lock);
    800018ea:	8526                	mv	a0,s1
    800018ec:	00005097          	auipc	ra,0x5
    800018f0:	8b2080e7          	jalr	-1870(ra) # 8000619e <acquire>
        if(pp->state == ZOMBIE){
    800018f4:	4c9c                	lw	a5,24(s1)
    800018f6:	f74785e3          	beq	a5,s4,80001860 <wait+0x4c>
        release(&pp->lock);
    800018fa:	8526                	mv	a0,s1
    800018fc:	00005097          	auipc	ra,0x5
    80001900:	956080e7          	jalr	-1706(ra) # 80006252 <release>
        havekids = 1;
    80001904:	8756                	mv	a4,s5
    80001906:	bfd9                	j	800018dc <wait+0xc8>
    if(!havekids || killed(p)){
    80001908:	c31d                	beqz	a4,8000192e <wait+0x11a>
    8000190a:	854a                	mv	a0,s2
    8000190c:	00000097          	auipc	ra,0x0
    80001910:	ed6080e7          	jalr	-298(ra) # 800017e2 <killed>
    80001914:	ed09                	bnez	a0,8000192e <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001916:	85e2                	mv	a1,s8
    80001918:	854a                	mv	a0,s2
    8000191a:	00000097          	auipc	ra,0x0
    8000191e:	c20080e7          	jalr	-992(ra) # 8000153a <sleep>
    havekids = 0;
    80001922:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001924:	00007497          	auipc	s1,0x7
    80001928:	63c48493          	addi	s1,s1,1596 # 80008f60 <proc>
    8000192c:	bf65                	j	800018e4 <wait+0xd0>
      release(&wait_lock);
    8000192e:	00007517          	auipc	a0,0x7
    80001932:	21a50513          	addi	a0,a0,538 # 80008b48 <wait_lock>
    80001936:	00005097          	auipc	ra,0x5
    8000193a:	91c080e7          	jalr	-1764(ra) # 80006252 <release>
      return -1;
    8000193e:	59fd                	li	s3,-1
    80001940:	b795                	j	800018a4 <wait+0x90>

0000000080001942 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001942:	7179                	addi	sp,sp,-48
    80001944:	f406                	sd	ra,40(sp)
    80001946:	f022                	sd	s0,32(sp)
    80001948:	ec26                	sd	s1,24(sp)
    8000194a:	e84a                	sd	s2,16(sp)
    8000194c:	e44e                	sd	s3,8(sp)
    8000194e:	e052                	sd	s4,0(sp)
    80001950:	1800                	addi	s0,sp,48
    80001952:	84aa                	mv	s1,a0
    80001954:	892e                	mv	s2,a1
    80001956:	89b2                	mv	s3,a2
    80001958:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000195a:	fffff097          	auipc	ra,0xfffff
    8000195e:	530080e7          	jalr	1328(ra) # 80000e8a <myproc>
  if(user_dst){
    80001962:	c08d                	beqz	s1,80001984 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001964:	86d2                	mv	a3,s4
    80001966:	864e                	mv	a2,s3
    80001968:	85ca                	mv	a1,s2
    8000196a:	6928                	ld	a0,80(a0)
    8000196c:	fffff097          	auipc	ra,0xfffff
    80001970:	1de080e7          	jalr	478(ra) # 80000b4a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001974:	70a2                	ld	ra,40(sp)
    80001976:	7402                	ld	s0,32(sp)
    80001978:	64e2                	ld	s1,24(sp)
    8000197a:	6942                	ld	s2,16(sp)
    8000197c:	69a2                	ld	s3,8(sp)
    8000197e:	6a02                	ld	s4,0(sp)
    80001980:	6145                	addi	sp,sp,48
    80001982:	8082                	ret
    memmove((char *)dst, src, len);
    80001984:	000a061b          	sext.w	a2,s4
    80001988:	85ce                	mv	a1,s3
    8000198a:	854a                	mv	a0,s2
    8000198c:	fffff097          	auipc	ra,0xfffff
    80001990:	882080e7          	jalr	-1918(ra) # 8000020e <memmove>
    return 0;
    80001994:	8526                	mv	a0,s1
    80001996:	bff9                	j	80001974 <either_copyout+0x32>

0000000080001998 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001998:	7179                	addi	sp,sp,-48
    8000199a:	f406                	sd	ra,40(sp)
    8000199c:	f022                	sd	s0,32(sp)
    8000199e:	ec26                	sd	s1,24(sp)
    800019a0:	e84a                	sd	s2,16(sp)
    800019a2:	e44e                	sd	s3,8(sp)
    800019a4:	e052                	sd	s4,0(sp)
    800019a6:	1800                	addi	s0,sp,48
    800019a8:	892a                	mv	s2,a0
    800019aa:	84ae                	mv	s1,a1
    800019ac:	89b2                	mv	s3,a2
    800019ae:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800019b0:	fffff097          	auipc	ra,0xfffff
    800019b4:	4da080e7          	jalr	1242(ra) # 80000e8a <myproc>
  if(user_src){
    800019b8:	c08d                	beqz	s1,800019da <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800019ba:	86d2                	mv	a3,s4
    800019bc:	864e                	mv	a2,s3
    800019be:	85ca                	mv	a1,s2
    800019c0:	6928                	ld	a0,80(a0)
    800019c2:	fffff097          	auipc	ra,0xfffff
    800019c6:	214080e7          	jalr	532(ra) # 80000bd6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019ca:	70a2                	ld	ra,40(sp)
    800019cc:	7402                	ld	s0,32(sp)
    800019ce:	64e2                	ld	s1,24(sp)
    800019d0:	6942                	ld	s2,16(sp)
    800019d2:	69a2                	ld	s3,8(sp)
    800019d4:	6a02                	ld	s4,0(sp)
    800019d6:	6145                	addi	sp,sp,48
    800019d8:	8082                	ret
    memmove(dst, (char*)src, len);
    800019da:	000a061b          	sext.w	a2,s4
    800019de:	85ce                	mv	a1,s3
    800019e0:	854a                	mv	a0,s2
    800019e2:	fffff097          	auipc	ra,0xfffff
    800019e6:	82c080e7          	jalr	-2004(ra) # 8000020e <memmove>
    return 0;
    800019ea:	8526                	mv	a0,s1
    800019ec:	bff9                	j	800019ca <either_copyin+0x32>

00000000800019ee <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800019ee:	715d                	addi	sp,sp,-80
    800019f0:	e486                	sd	ra,72(sp)
    800019f2:	e0a2                	sd	s0,64(sp)
    800019f4:	fc26                	sd	s1,56(sp)
    800019f6:	f84a                	sd	s2,48(sp)
    800019f8:	f44e                	sd	s3,40(sp)
    800019fa:	f052                	sd	s4,32(sp)
    800019fc:	ec56                	sd	s5,24(sp)
    800019fe:	e85a                	sd	s6,16(sp)
    80001a00:	e45e                	sd	s7,8(sp)
    80001a02:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a04:	00006517          	auipc	a0,0x6
    80001a08:	64450513          	addi	a0,a0,1604 # 80008048 <etext+0x48>
    80001a0c:	00004097          	auipc	ra,0x4
    80001a10:	2a4080e7          	jalr	676(ra) # 80005cb0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a14:	00007497          	auipc	s1,0x7
    80001a18:	6a448493          	addi	s1,s1,1700 # 800090b8 <proc+0x158>
    80001a1c:	0000d917          	auipc	s2,0xd
    80001a20:	29c90913          	addi	s2,s2,668 # 8000ecb8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a24:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a26:	00006997          	auipc	s3,0x6
    80001a2a:	7da98993          	addi	s3,s3,2010 # 80008200 <etext+0x200>
    printf("%d %s %s", p->pid, state, p->name);
    80001a2e:	00006a97          	auipc	s5,0x6
    80001a32:	7daa8a93          	addi	s5,s5,2010 # 80008208 <etext+0x208>
    printf("\n");
    80001a36:	00006a17          	auipc	s4,0x6
    80001a3a:	612a0a13          	addi	s4,s4,1554 # 80008048 <etext+0x48>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3e:	00007b97          	auipc	s7,0x7
    80001a42:	80ab8b93          	addi	s7,s7,-2038 # 80008248 <states.0>
    80001a46:	a00d                	j	80001a68 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001a48:	ed86a583          	lw	a1,-296(a3)
    80001a4c:	8556                	mv	a0,s5
    80001a4e:	00004097          	auipc	ra,0x4
    80001a52:	262080e7          	jalr	610(ra) # 80005cb0 <printf>
    printf("\n");
    80001a56:	8552                	mv	a0,s4
    80001a58:	00004097          	auipc	ra,0x4
    80001a5c:	258080e7          	jalr	600(ra) # 80005cb0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a60:	17048493          	addi	s1,s1,368
    80001a64:	03248263          	beq	s1,s2,80001a88 <procdump+0x9a>
    if(p->state == UNUSED)
    80001a68:	86a6                	mv	a3,s1
    80001a6a:	ec04a783          	lw	a5,-320(s1)
    80001a6e:	dbed                	beqz	a5,80001a60 <procdump+0x72>
      state = "???";
    80001a70:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a72:	fcfb6be3          	bltu	s6,a5,80001a48 <procdump+0x5a>
    80001a76:	02079713          	slli	a4,a5,0x20
    80001a7a:	01d75793          	srli	a5,a4,0x1d
    80001a7e:	97de                	add	a5,a5,s7
    80001a80:	6390                	ld	a2,0(a5)
    80001a82:	f279                	bnez	a2,80001a48 <procdump+0x5a>
      state = "???";
    80001a84:	864e                	mv	a2,s3
    80001a86:	b7c9                	j	80001a48 <procdump+0x5a>
  }
}
    80001a88:	60a6                	ld	ra,72(sp)
    80001a8a:	6406                	ld	s0,64(sp)
    80001a8c:	74e2                	ld	s1,56(sp)
    80001a8e:	7942                	ld	s2,48(sp)
    80001a90:	79a2                	ld	s3,40(sp)
    80001a92:	7a02                	ld	s4,32(sp)
    80001a94:	6ae2                	ld	s5,24(sp)
    80001a96:	6b42                	ld	s6,16(sp)
    80001a98:	6ba2                	ld	s7,8(sp)
    80001a9a:	6161                	addi	sp,sp,80
    80001a9c:	8082                	ret

0000000080001a9e <knproc>:

void knproc(struct sysinfo* info){
    80001a9e:	1141                	addi	sp,sp,-16
    80001aa0:	e422                	sd	s0,8(sp)
    80001aa2:	0800                	addi	s0,sp,16
  struct proc *p;
  int cnt = 0;
    80001aa4:	4681                	li	a3,0
  for(p = proc; p < &proc[NPROC]; p++){
    80001aa6:	00007797          	auipc	a5,0x7
    80001aaa:	4ba78793          	addi	a5,a5,1210 # 80008f60 <proc>
    80001aae:	0000d617          	auipc	a2,0xd
    80001ab2:	0b260613          	addi	a2,a2,178 # 8000eb60 <tickslock>
    80001ab6:	a029                	j	80001ac0 <knproc+0x22>
    80001ab8:	17078793          	addi	a5,a5,368
    80001abc:	00c78663          	beq	a5,a2,80001ac8 <knproc+0x2a>
    if(p->state != UNUSED) ++cnt; 
    80001ac0:	4f98                	lw	a4,24(a5)
    80001ac2:	db7d                	beqz	a4,80001ab8 <knproc+0x1a>
    80001ac4:	2685                	addiw	a3,a3,1
    80001ac6:	bfcd                	j	80001ab8 <knproc+0x1a>
  }
  info->nproc = cnt;
    80001ac8:	e514                	sd	a3,8(a0)
    80001aca:	6422                	ld	s0,8(sp)
    80001acc:	0141                	addi	sp,sp,16
    80001ace:	8082                	ret

0000000080001ad0 <swtch>:
    80001ad0:	00153023          	sd	ra,0(a0)
    80001ad4:	00253423          	sd	sp,8(a0)
    80001ad8:	e900                	sd	s0,16(a0)
    80001ada:	ed04                	sd	s1,24(a0)
    80001adc:	03253023          	sd	s2,32(a0)
    80001ae0:	03353423          	sd	s3,40(a0)
    80001ae4:	03453823          	sd	s4,48(a0)
    80001ae8:	03553c23          	sd	s5,56(a0)
    80001aec:	05653023          	sd	s6,64(a0)
    80001af0:	05753423          	sd	s7,72(a0)
    80001af4:	05853823          	sd	s8,80(a0)
    80001af8:	05953c23          	sd	s9,88(a0)
    80001afc:	07a53023          	sd	s10,96(a0)
    80001b00:	07b53423          	sd	s11,104(a0)
    80001b04:	0005b083          	ld	ra,0(a1)
    80001b08:	0085b103          	ld	sp,8(a1)
    80001b0c:	6980                	ld	s0,16(a1)
    80001b0e:	6d84                	ld	s1,24(a1)
    80001b10:	0205b903          	ld	s2,32(a1)
    80001b14:	0285b983          	ld	s3,40(a1)
    80001b18:	0305ba03          	ld	s4,48(a1)
    80001b1c:	0385ba83          	ld	s5,56(a1)
    80001b20:	0405bb03          	ld	s6,64(a1)
    80001b24:	0485bb83          	ld	s7,72(a1)
    80001b28:	0505bc03          	ld	s8,80(a1)
    80001b2c:	0585bc83          	ld	s9,88(a1)
    80001b30:	0605bd03          	ld	s10,96(a1)
    80001b34:	0685bd83          	ld	s11,104(a1)
    80001b38:	8082                	ret

0000000080001b3a <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e406                	sd	ra,8(sp)
    80001b3e:	e022                	sd	s0,0(sp)
    80001b40:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b42:	00006597          	auipc	a1,0x6
    80001b46:	73658593          	addi	a1,a1,1846 # 80008278 <states.0+0x30>
    80001b4a:	0000d517          	auipc	a0,0xd
    80001b4e:	01650513          	addi	a0,a0,22 # 8000eb60 <tickslock>
    80001b52:	00004097          	auipc	ra,0x4
    80001b56:	5bc080e7          	jalr	1468(ra) # 8000610e <initlock>
}
    80001b5a:	60a2                	ld	ra,8(sp)
    80001b5c:	6402                	ld	s0,0(sp)
    80001b5e:	0141                	addi	sp,sp,16
    80001b60:	8082                	ret

0000000080001b62 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b62:	1141                	addi	sp,sp,-16
    80001b64:	e422                	sd	s0,8(sp)
    80001b66:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b68:	00003797          	auipc	a5,0x3
    80001b6c:	53878793          	addi	a5,a5,1336 # 800050a0 <kernelvec>
    80001b70:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b74:	6422                	ld	s0,8(sp)
    80001b76:	0141                	addi	sp,sp,16
    80001b78:	8082                	ret

0000000080001b7a <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001b7a:	1141                	addi	sp,sp,-16
    80001b7c:	e406                	sd	ra,8(sp)
    80001b7e:	e022                	sd	s0,0(sp)
    80001b80:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b82:	fffff097          	auipc	ra,0xfffff
    80001b86:	308080e7          	jalr	776(ra) # 80000e8a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b8a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b8e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b90:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b94:	00005697          	auipc	a3,0x5
    80001b98:	46c68693          	addi	a3,a3,1132 # 80007000 <_trampoline>
    80001b9c:	00005717          	auipc	a4,0x5
    80001ba0:	46470713          	addi	a4,a4,1124 # 80007000 <_trampoline>
    80001ba4:	8f15                	sub	a4,a4,a3
    80001ba6:	040007b7          	lui	a5,0x4000
    80001baa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001bac:	07b2                	slli	a5,a5,0xc
    80001bae:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001bb0:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001bb4:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001bb6:	18002673          	csrr	a2,satp
    80001bba:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001bbc:	6d30                	ld	a2,88(a0)
    80001bbe:	6138                	ld	a4,64(a0)
    80001bc0:	6585                	lui	a1,0x1
    80001bc2:	972e                	add	a4,a4,a1
    80001bc4:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bc6:	6d38                	ld	a4,88(a0)
    80001bc8:	00000617          	auipc	a2,0x0
    80001bcc:	13460613          	addi	a2,a2,308 # 80001cfc <usertrap>
    80001bd0:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bd2:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bd4:	8612                	mv	a2,tp
    80001bd6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bd8:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bdc:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001be0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001be4:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001be8:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bea:	6f18                	ld	a4,24(a4)
    80001bec:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bf0:	6928                	ld	a0,80(a0)
    80001bf2:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bf4:	00005717          	auipc	a4,0x5
    80001bf8:	4a870713          	addi	a4,a4,1192 # 8000709c <userret>
    80001bfc:	8f15                	sub	a4,a4,a3
    80001bfe:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001c00:	577d                	li	a4,-1
    80001c02:	177e                	slli	a4,a4,0x3f
    80001c04:	8d59                	or	a0,a0,a4
    80001c06:	9782                	jalr	a5
}
    80001c08:	60a2                	ld	ra,8(sp)
    80001c0a:	6402                	ld	s0,0(sp)
    80001c0c:	0141                	addi	sp,sp,16
    80001c0e:	8082                	ret

0000000080001c10 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001c1a:	0000d497          	auipc	s1,0xd
    80001c1e:	f4648493          	addi	s1,s1,-186 # 8000eb60 <tickslock>
    80001c22:	8526                	mv	a0,s1
    80001c24:	00004097          	auipc	ra,0x4
    80001c28:	57a080e7          	jalr	1402(ra) # 8000619e <acquire>
  ticks++;
    80001c2c:	00007517          	auipc	a0,0x7
    80001c30:	ecc50513          	addi	a0,a0,-308 # 80008af8 <ticks>
    80001c34:	411c                	lw	a5,0(a0)
    80001c36:	2785                	addiw	a5,a5,1
    80001c38:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001c3a:	00000097          	auipc	ra,0x0
    80001c3e:	964080e7          	jalr	-1692(ra) # 8000159e <wakeup>
  release(&tickslock);
    80001c42:	8526                	mv	a0,s1
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	60e080e7          	jalr	1550(ra) # 80006252 <release>
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret

0000000080001c56 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c56:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001c5a:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001c5c:	0807df63          	bgez	a5,80001cfa <devintr+0xa4>
{
    80001c60:	1101                	addi	sp,sp,-32
    80001c62:	ec06                	sd	ra,24(sp)
    80001c64:	e822                	sd	s0,16(sp)
    80001c66:	e426                	sd	s1,8(sp)
    80001c68:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001c6a:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001c6e:	46a5                	li	a3,9
    80001c70:	00d70d63          	beq	a4,a3,80001c8a <devintr+0x34>
  } else if(scause == 0x8000000000000001L){
    80001c74:	577d                	li	a4,-1
    80001c76:	177e                	slli	a4,a4,0x3f
    80001c78:	0705                	addi	a4,a4,1
    return 0;
    80001c7a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001c7c:	04e78e63          	beq	a5,a4,80001cd8 <devintr+0x82>
  }
}
    80001c80:	60e2                	ld	ra,24(sp)
    80001c82:	6442                	ld	s0,16(sp)
    80001c84:	64a2                	ld	s1,8(sp)
    80001c86:	6105                	addi	sp,sp,32
    80001c88:	8082                	ret
    int irq = plic_claim();
    80001c8a:	00003097          	auipc	ra,0x3
    80001c8e:	51e080e7          	jalr	1310(ra) # 800051a8 <plic_claim>
    80001c92:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c94:	47a9                	li	a5,10
    80001c96:	02f50763          	beq	a0,a5,80001cc4 <devintr+0x6e>
    } else if(irq == VIRTIO0_IRQ){
    80001c9a:	4785                	li	a5,1
    80001c9c:	02f50963          	beq	a0,a5,80001cce <devintr+0x78>
    return 1;
    80001ca0:	4505                	li	a0,1
    } else if(irq){
    80001ca2:	dcf9                	beqz	s1,80001c80 <devintr+0x2a>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ca4:	85a6                	mv	a1,s1
    80001ca6:	00006517          	auipc	a0,0x6
    80001caa:	5da50513          	addi	a0,a0,1498 # 80008280 <states.0+0x38>
    80001cae:	00004097          	auipc	ra,0x4
    80001cb2:	002080e7          	jalr	2(ra) # 80005cb0 <printf>
      plic_complete(irq);
    80001cb6:	8526                	mv	a0,s1
    80001cb8:	00003097          	auipc	ra,0x3
    80001cbc:	514080e7          	jalr	1300(ra) # 800051cc <plic_complete>
    return 1;
    80001cc0:	4505                	li	a0,1
    80001cc2:	bf7d                	j	80001c80 <devintr+0x2a>
      uartintr();
    80001cc4:	00004097          	auipc	ra,0x4
    80001cc8:	3fa080e7          	jalr	1018(ra) # 800060be <uartintr>
    if(irq)
    80001ccc:	b7ed                	j	80001cb6 <devintr+0x60>
      virtio_disk_intr();
    80001cce:	00004097          	auipc	ra,0x4
    80001cd2:	9c4080e7          	jalr	-1596(ra) # 80005692 <virtio_disk_intr>
    if(irq)
    80001cd6:	b7c5                	j	80001cb6 <devintr+0x60>
    if(cpuid() == 0){
    80001cd8:	fffff097          	auipc	ra,0xfffff
    80001cdc:	186080e7          	jalr	390(ra) # 80000e5e <cpuid>
    80001ce0:	c901                	beqz	a0,80001cf0 <devintr+0x9a>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001ce2:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001ce6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001ce8:	14479073          	csrw	sip,a5
    return 2;
    80001cec:	4509                	li	a0,2
    80001cee:	bf49                	j	80001c80 <devintr+0x2a>
      clockintr();
    80001cf0:	00000097          	auipc	ra,0x0
    80001cf4:	f20080e7          	jalr	-224(ra) # 80001c10 <clockintr>
    80001cf8:	b7ed                	j	80001ce2 <devintr+0x8c>
}
    80001cfa:	8082                	ret

0000000080001cfc <usertrap>:
{
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	e426                	sd	s1,8(sp)
    80001d04:	e04a                	sd	s2,0(sp)
    80001d06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d08:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001d0c:	1007f793          	andi	a5,a5,256
    80001d10:	e3b1                	bnez	a5,80001d54 <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d12:	00003797          	auipc	a5,0x3
    80001d16:	38e78793          	addi	a5,a5,910 # 800050a0 <kernelvec>
    80001d1a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001d1e:	fffff097          	auipc	ra,0xfffff
    80001d22:	16c080e7          	jalr	364(ra) # 80000e8a <myproc>
    80001d26:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001d28:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2a:	14102773          	csrr	a4,sepc
    80001d2e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d30:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001d34:	47a1                	li	a5,8
    80001d36:	02f70763          	beq	a4,a5,80001d64 <usertrap+0x68>
  } else if((which_dev = devintr()) != 0){
    80001d3a:	00000097          	auipc	ra,0x0
    80001d3e:	f1c080e7          	jalr	-228(ra) # 80001c56 <devintr>
    80001d42:	892a                	mv	s2,a0
    80001d44:	c151                	beqz	a0,80001dc8 <usertrap+0xcc>
  if(killed(p))
    80001d46:	8526                	mv	a0,s1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	a9a080e7          	jalr	-1382(ra) # 800017e2 <killed>
    80001d50:	c929                	beqz	a0,80001da2 <usertrap+0xa6>
    80001d52:	a099                	j	80001d98 <usertrap+0x9c>
    panic("usertrap: not from user mode");
    80001d54:	00006517          	auipc	a0,0x6
    80001d58:	54c50513          	addi	a0,a0,1356 # 800082a0 <states.0+0x58>
    80001d5c:	00004097          	auipc	ra,0x4
    80001d60:	f0a080e7          	jalr	-246(ra) # 80005c66 <panic>
    if(killed(p))
    80001d64:	00000097          	auipc	ra,0x0
    80001d68:	a7e080e7          	jalr	-1410(ra) # 800017e2 <killed>
    80001d6c:	e921                	bnez	a0,80001dbc <usertrap+0xc0>
    p->trapframe->epc += 4;
    80001d6e:	6cb8                	ld	a4,88(s1)
    80001d70:	6f1c                	ld	a5,24(a4)
    80001d72:	0791                	addi	a5,a5,4
    80001d74:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d76:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d7a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7e:	10079073          	csrw	sstatus,a5
    syscall();
    80001d82:	00000097          	auipc	ra,0x0
    80001d86:	2d4080e7          	jalr	724(ra) # 80002056 <syscall>
  if(killed(p))
    80001d8a:	8526                	mv	a0,s1
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	a56080e7          	jalr	-1450(ra) # 800017e2 <killed>
    80001d94:	c911                	beqz	a0,80001da8 <usertrap+0xac>
    80001d96:	4901                	li	s2,0
    exit(-1);
    80001d98:	557d                	li	a0,-1
    80001d9a:	00000097          	auipc	ra,0x0
    80001d9e:	8d4080e7          	jalr	-1836(ra) # 8000166e <exit>
  if(which_dev == 2)
    80001da2:	4789                	li	a5,2
    80001da4:	04f90f63          	beq	s2,a5,80001e02 <usertrap+0x106>
  usertrapret();
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	dd2080e7          	jalr	-558(ra) # 80001b7a <usertrapret>
}
    80001db0:	60e2                	ld	ra,24(sp)
    80001db2:	6442                	ld	s0,16(sp)
    80001db4:	64a2                	ld	s1,8(sp)
    80001db6:	6902                	ld	s2,0(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret
      exit(-1);
    80001dbc:	557d                	li	a0,-1
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	8b0080e7          	jalr	-1872(ra) # 8000166e <exit>
    80001dc6:	b765                	j	80001d6e <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dc8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001dcc:	5890                	lw	a2,48(s1)
    80001dce:	00006517          	auipc	a0,0x6
    80001dd2:	4f250513          	addi	a0,a0,1266 # 800082c0 <states.0+0x78>
    80001dd6:	00004097          	auipc	ra,0x4
    80001dda:	eda080e7          	jalr	-294(ra) # 80005cb0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dde:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001de2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001de6:	00006517          	auipc	a0,0x6
    80001dea:	50a50513          	addi	a0,a0,1290 # 800082f0 <states.0+0xa8>
    80001dee:	00004097          	auipc	ra,0x4
    80001df2:	ec2080e7          	jalr	-318(ra) # 80005cb0 <printf>
    setkilled(p);
    80001df6:	8526                	mv	a0,s1
    80001df8:	00000097          	auipc	ra,0x0
    80001dfc:	9be080e7          	jalr	-1602(ra) # 800017b6 <setkilled>
    80001e00:	b769                	j	80001d8a <usertrap+0x8e>
    yield();
    80001e02:	fffff097          	auipc	ra,0xfffff
    80001e06:	6fc080e7          	jalr	1788(ra) # 800014fe <yield>
    80001e0a:	bf79                	j	80001da8 <usertrap+0xac>

0000000080001e0c <kerneltrap>:
{
    80001e0c:	7179                	addi	sp,sp,-48
    80001e0e:	f406                	sd	ra,40(sp)
    80001e10:	f022                	sd	s0,32(sp)
    80001e12:	ec26                	sd	s1,24(sp)
    80001e14:	e84a                	sd	s2,16(sp)
    80001e16:	e44e                	sd	s3,8(sp)
    80001e18:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e1a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e1e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e22:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001e26:	1004f793          	andi	a5,s1,256
    80001e2a:	cb85                	beqz	a5,80001e5a <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e2c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e30:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001e32:	ef85                	bnez	a5,80001e6a <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80001e34:	00000097          	auipc	ra,0x0
    80001e38:	e22080e7          	jalr	-478(ra) # 80001c56 <devintr>
    80001e3c:	cd1d                	beqz	a0,80001e7a <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001e3e:	4789                	li	a5,2
    80001e40:	06f50a63          	beq	a0,a5,80001eb4 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e44:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e48:	10049073          	csrw	sstatus,s1
}
    80001e4c:	70a2                	ld	ra,40(sp)
    80001e4e:	7402                	ld	s0,32(sp)
    80001e50:	64e2                	ld	s1,24(sp)
    80001e52:	6942                	ld	s2,16(sp)
    80001e54:	69a2                	ld	s3,8(sp)
    80001e56:	6145                	addi	sp,sp,48
    80001e58:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e5a:	00006517          	auipc	a0,0x6
    80001e5e:	4b650513          	addi	a0,a0,1206 # 80008310 <states.0+0xc8>
    80001e62:	00004097          	auipc	ra,0x4
    80001e66:	e04080e7          	jalr	-508(ra) # 80005c66 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	4ce50513          	addi	a0,a0,1230 # 80008338 <states.0+0xf0>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	df4080e7          	jalr	-524(ra) # 80005c66 <panic>
    printf("scause %p\n", scause);
    80001e7a:	85ce                	mv	a1,s3
    80001e7c:	00006517          	auipc	a0,0x6
    80001e80:	4dc50513          	addi	a0,a0,1244 # 80008358 <states.0+0x110>
    80001e84:	00004097          	auipc	ra,0x4
    80001e88:	e2c080e7          	jalr	-468(ra) # 80005cb0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e8c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e90:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001e94:	00006517          	auipc	a0,0x6
    80001e98:	4d450513          	addi	a0,a0,1236 # 80008368 <states.0+0x120>
    80001e9c:	00004097          	auipc	ra,0x4
    80001ea0:	e14080e7          	jalr	-492(ra) # 80005cb0 <printf>
    panic("kerneltrap");
    80001ea4:	00006517          	auipc	a0,0x6
    80001ea8:	4dc50513          	addi	a0,a0,1244 # 80008380 <states.0+0x138>
    80001eac:	00004097          	auipc	ra,0x4
    80001eb0:	dba080e7          	jalr	-582(ra) # 80005c66 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001eb4:	fffff097          	auipc	ra,0xfffff
    80001eb8:	fd6080e7          	jalr	-42(ra) # 80000e8a <myproc>
    80001ebc:	d541                	beqz	a0,80001e44 <kerneltrap+0x38>
    80001ebe:	fffff097          	auipc	ra,0xfffff
    80001ec2:	fcc080e7          	jalr	-52(ra) # 80000e8a <myproc>
    80001ec6:	4d18                	lw	a4,24(a0)
    80001ec8:	4791                	li	a5,4
    80001eca:	f6f71de3          	bne	a4,a5,80001e44 <kerneltrap+0x38>
    yield();
    80001ece:	fffff097          	auipc	ra,0xfffff
    80001ed2:	630080e7          	jalr	1584(ra) # 800014fe <yield>
    80001ed6:	b7bd                	j	80001e44 <kerneltrap+0x38>

0000000080001ed8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ed8:	1101                	addi	sp,sp,-32
    80001eda:	ec06                	sd	ra,24(sp)
    80001edc:	e822                	sd	s0,16(sp)
    80001ede:	e426                	sd	s1,8(sp)
    80001ee0:	1000                	addi	s0,sp,32
    80001ee2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	fa6080e7          	jalr	-90(ra) # 80000e8a <myproc>
  switch (n) {
    80001eec:	4795                	li	a5,5
    80001eee:	0497e163          	bltu	a5,s1,80001f30 <argraw+0x58>
    80001ef2:	048a                	slli	s1,s1,0x2
    80001ef4:	00006717          	auipc	a4,0x6
    80001ef8:	64c70713          	addi	a4,a4,1612 # 80008540 <states.0+0x2f8>
    80001efc:	94ba                	add	s1,s1,a4
    80001efe:	409c                	lw	a5,0(s1)
    80001f00:	97ba                	add	a5,a5,a4
    80001f02:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001f04:	6d3c                	ld	a5,88(a0)
    80001f06:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001f08:	60e2                	ld	ra,24(sp)
    80001f0a:	6442                	ld	s0,16(sp)
    80001f0c:	64a2                	ld	s1,8(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    return p->trapframe->a1;
    80001f12:	6d3c                	ld	a5,88(a0)
    80001f14:	7fa8                	ld	a0,120(a5)
    80001f16:	bfcd                	j	80001f08 <argraw+0x30>
    return p->trapframe->a2;
    80001f18:	6d3c                	ld	a5,88(a0)
    80001f1a:	63c8                	ld	a0,128(a5)
    80001f1c:	b7f5                	j	80001f08 <argraw+0x30>
    return p->trapframe->a3;
    80001f1e:	6d3c                	ld	a5,88(a0)
    80001f20:	67c8                	ld	a0,136(a5)
    80001f22:	b7dd                	j	80001f08 <argraw+0x30>
    return p->trapframe->a4;
    80001f24:	6d3c                	ld	a5,88(a0)
    80001f26:	6bc8                	ld	a0,144(a5)
    80001f28:	b7c5                	j	80001f08 <argraw+0x30>
    return p->trapframe->a5;
    80001f2a:	6d3c                	ld	a5,88(a0)
    80001f2c:	6fc8                	ld	a0,152(a5)
    80001f2e:	bfe9                	j	80001f08 <argraw+0x30>
  panic("argraw");
    80001f30:	00006517          	auipc	a0,0x6
    80001f34:	46050513          	addi	a0,a0,1120 # 80008390 <states.0+0x148>
    80001f38:	00004097          	auipc	ra,0x4
    80001f3c:	d2e080e7          	jalr	-722(ra) # 80005c66 <panic>

0000000080001f40 <fetchaddr>:
{
    80001f40:	1101                	addi	sp,sp,-32
    80001f42:	ec06                	sd	ra,24(sp)
    80001f44:	e822                	sd	s0,16(sp)
    80001f46:	e426                	sd	s1,8(sp)
    80001f48:	e04a                	sd	s2,0(sp)
    80001f4a:	1000                	addi	s0,sp,32
    80001f4c:	84aa                	mv	s1,a0
    80001f4e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f50:	fffff097          	auipc	ra,0xfffff
    80001f54:	f3a080e7          	jalr	-198(ra) # 80000e8a <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001f58:	653c                	ld	a5,72(a0)
    80001f5a:	02f4f863          	bgeu	s1,a5,80001f8a <fetchaddr+0x4a>
    80001f5e:	00848713          	addi	a4,s1,8
    80001f62:	02e7e663          	bltu	a5,a4,80001f8e <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001f66:	46a1                	li	a3,8
    80001f68:	8626                	mv	a2,s1
    80001f6a:	85ca                	mv	a1,s2
    80001f6c:	6928                	ld	a0,80(a0)
    80001f6e:	fffff097          	auipc	ra,0xfffff
    80001f72:	c68080e7          	jalr	-920(ra) # 80000bd6 <copyin>
    80001f76:	00a03533          	snez	a0,a0
    80001f7a:	40a00533          	neg	a0,a0
}
    80001f7e:	60e2                	ld	ra,24(sp)
    80001f80:	6442                	ld	s0,16(sp)
    80001f82:	64a2                	ld	s1,8(sp)
    80001f84:	6902                	ld	s2,0(sp)
    80001f86:	6105                	addi	sp,sp,32
    80001f88:	8082                	ret
    return -1;
    80001f8a:	557d                	li	a0,-1
    80001f8c:	bfcd                	j	80001f7e <fetchaddr+0x3e>
    80001f8e:	557d                	li	a0,-1
    80001f90:	b7fd                	j	80001f7e <fetchaddr+0x3e>

0000000080001f92 <fetchstr>:
{
    80001f92:	7179                	addi	sp,sp,-48
    80001f94:	f406                	sd	ra,40(sp)
    80001f96:	f022                	sd	s0,32(sp)
    80001f98:	ec26                	sd	s1,24(sp)
    80001f9a:	e84a                	sd	s2,16(sp)
    80001f9c:	e44e                	sd	s3,8(sp)
    80001f9e:	1800                	addi	s0,sp,48
    80001fa0:	892a                	mv	s2,a0
    80001fa2:	84ae                	mv	s1,a1
    80001fa4:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	ee4080e7          	jalr	-284(ra) # 80000e8a <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001fae:	86ce                	mv	a3,s3
    80001fb0:	864a                	mv	a2,s2
    80001fb2:	85a6                	mv	a1,s1
    80001fb4:	6928                	ld	a0,80(a0)
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	cae080e7          	jalr	-850(ra) # 80000c64 <copyinstr>
    80001fbe:	00054e63          	bltz	a0,80001fda <fetchstr+0x48>
  return strlen(buf);
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	ffffe097          	auipc	ra,0xffffe
    80001fc8:	368080e7          	jalr	872(ra) # 8000032c <strlen>
}
    80001fcc:	70a2                	ld	ra,40(sp)
    80001fce:	7402                	ld	s0,32(sp)
    80001fd0:	64e2                	ld	s1,24(sp)
    80001fd2:	6942                	ld	s2,16(sp)
    80001fd4:	69a2                	ld	s3,8(sp)
    80001fd6:	6145                	addi	sp,sp,48
    80001fd8:	8082                	ret
    return -1;
    80001fda:	557d                	li	a0,-1
    80001fdc:	bfc5                	j	80001fcc <fetchstr+0x3a>

0000000080001fde <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001fde:	1101                	addi	sp,sp,-32
    80001fe0:	ec06                	sd	ra,24(sp)
    80001fe2:	e822                	sd	s0,16(sp)
    80001fe4:	e426                	sd	s1,8(sp)
    80001fe6:	1000                	addi	s0,sp,32
    80001fe8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001fea:	00000097          	auipc	ra,0x0
    80001fee:	eee080e7          	jalr	-274(ra) # 80001ed8 <argraw>
    80001ff2:	c088                	sw	a0,0(s1)
}
    80001ff4:	60e2                	ld	ra,24(sp)
    80001ff6:	6442                	ld	s0,16(sp)
    80001ff8:	64a2                	ld	s1,8(sp)
    80001ffa:	6105                	addi	sp,sp,32
    80001ffc:	8082                	ret

0000000080001ffe <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001ffe:	1101                	addi	sp,sp,-32
    80002000:	ec06                	sd	ra,24(sp)
    80002002:	e822                	sd	s0,16(sp)
    80002004:	e426                	sd	s1,8(sp)
    80002006:	1000                	addi	s0,sp,32
    80002008:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000200a:	00000097          	auipc	ra,0x0
    8000200e:	ece080e7          	jalr	-306(ra) # 80001ed8 <argraw>
    80002012:	e088                	sd	a0,0(s1)
}
    80002014:	60e2                	ld	ra,24(sp)
    80002016:	6442                	ld	s0,16(sp)
    80002018:	64a2                	ld	s1,8(sp)
    8000201a:	6105                	addi	sp,sp,32
    8000201c:	8082                	ret

000000008000201e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000201e:	7179                	addi	sp,sp,-48
    80002020:	f406                	sd	ra,40(sp)
    80002022:	f022                	sd	s0,32(sp)
    80002024:	ec26                	sd	s1,24(sp)
    80002026:	e84a                	sd	s2,16(sp)
    80002028:	1800                	addi	s0,sp,48
    8000202a:	84ae                	mv	s1,a1
    8000202c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    8000202e:	fd840593          	addi	a1,s0,-40
    80002032:	00000097          	auipc	ra,0x0
    80002036:	fcc080e7          	jalr	-52(ra) # 80001ffe <argaddr>
  return fetchstr(addr, buf, max);
    8000203a:	864a                	mv	a2,s2
    8000203c:	85a6                	mv	a1,s1
    8000203e:	fd843503          	ld	a0,-40(s0)
    80002042:	00000097          	auipc	ra,0x0
    80002046:	f50080e7          	jalr	-176(ra) # 80001f92 <fetchstr>
}
    8000204a:	70a2                	ld	ra,40(sp)
    8000204c:	7402                	ld	s0,32(sp)
    8000204e:	64e2                	ld	s1,24(sp)
    80002050:	6942                	ld	s2,16(sp)
    80002052:	6145                	addi	sp,sp,48
    80002054:	8082                	ret

0000000080002056 <syscall>:
[SYS_sysinfo]   "syscall sinfo",
};

void
syscall(void)
{
    80002056:	7179                	addi	sp,sp,-48
    80002058:	f406                	sd	ra,40(sp)
    8000205a:	f022                	sd	s0,32(sp)
    8000205c:	ec26                	sd	s1,24(sp)
    8000205e:	e84a                	sd	s2,16(sp)
    80002060:	e44e                	sd	s3,8(sp)
    80002062:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002064:	fffff097          	auipc	ra,0xfffff
    80002068:	e26080e7          	jalr	-474(ra) # 80000e8a <myproc>
    8000206c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000206e:	05853903          	ld	s2,88(a0)
    80002072:	0a893783          	ld	a5,168(s2)
    80002076:	0007899b          	sext.w	s3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000207a:	37fd                	addiw	a5,a5,-1
    8000207c:	4759                	li	a4,22
    8000207e:	04f76763          	bltu	a4,a5,800020cc <syscall+0x76>
    80002082:	00399713          	slli	a4,s3,0x3
    80002086:	00006797          	auipc	a5,0x6
    8000208a:	4d278793          	addi	a5,a5,1234 # 80008558 <syscalls>
    8000208e:	97ba                	add	a5,a5,a4
    80002090:	639c                	ld	a5,0(a5)
    80002092:	cf8d                	beqz	a5,800020cc <syscall+0x76>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002094:	9782                	jalr	a5
    80002096:	06a93823          	sd	a0,112(s2)
    if(1 << num & p->trace)
    8000209a:	1684a783          	lw	a5,360(s1)
    8000209e:	4137d7bb          	sraw	a5,a5,s3
    800020a2:	8b85                	andi	a5,a5,1
    800020a4:	c3b9                	beqz	a5,800020ea <syscall+0x94>
      printf("%d: syscall %s -> %d\n", p->pid, syscallNames[num], p->trapframe->a0);
    800020a6:	6cb8                	ld	a4,88(s1)
    800020a8:	098e                	slli	s3,s3,0x3
    800020aa:	00006797          	auipc	a5,0x6
    800020ae:	4ae78793          	addi	a5,a5,1198 # 80008558 <syscalls>
    800020b2:	97ce                	add	a5,a5,s3
    800020b4:	7b34                	ld	a3,112(a4)
    800020b6:	63f0                	ld	a2,192(a5)
    800020b8:	588c                	lw	a1,48(s1)
    800020ba:	00006517          	auipc	a0,0x6
    800020be:	2de50513          	addi	a0,a0,734 # 80008398 <states.0+0x150>
    800020c2:	00004097          	auipc	ra,0x4
    800020c6:	bee080e7          	jalr	-1042(ra) # 80005cb0 <printf>
    800020ca:	a005                	j	800020ea <syscall+0x94>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800020cc:	86ce                	mv	a3,s3
    800020ce:	15848613          	addi	a2,s1,344
    800020d2:	588c                	lw	a1,48(s1)
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	2dc50513          	addi	a0,a0,732 # 800083b0 <states.0+0x168>
    800020dc:	00004097          	auipc	ra,0x4
    800020e0:	bd4080e7          	jalr	-1068(ra) # 80005cb0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800020e4:	6cbc                	ld	a5,88(s1)
    800020e6:	577d                	li	a4,-1
    800020e8:	fbb8                	sd	a4,112(a5)
  }
}
    800020ea:	70a2                	ld	ra,40(sp)
    800020ec:	7402                	ld	s0,32(sp)
    800020ee:	64e2                	ld	s1,24(sp)
    800020f0:	6942                	ld	s2,16(sp)
    800020f2:	69a2                	ld	s3,8(sp)
    800020f4:	6145                	addi	sp,sp,48
    800020f6:	8082                	ret

00000000800020f8 <sys_exit>:
#include "proc.h"
#include "sysinfo.h"

uint64
sys_exit(void)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002100:	fec40593          	addi	a1,s0,-20
    80002104:	4501                	li	a0,0
    80002106:	00000097          	auipc	ra,0x0
    8000210a:	ed8080e7          	jalr	-296(ra) # 80001fde <argint>
  exit(n);
    8000210e:	fec42503          	lw	a0,-20(s0)
    80002112:	fffff097          	auipc	ra,0xfffff
    80002116:	55c080e7          	jalr	1372(ra) # 8000166e <exit>
  return 0;  // not reached
}
    8000211a:	4501                	li	a0,0
    8000211c:	60e2                	ld	ra,24(sp)
    8000211e:	6442                	ld	s0,16(sp)
    80002120:	6105                	addi	sp,sp,32
    80002122:	8082                	ret

0000000080002124 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002124:	1141                	addi	sp,sp,-16
    80002126:	e406                	sd	ra,8(sp)
    80002128:	e022                	sd	s0,0(sp)
    8000212a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000212c:	fffff097          	auipc	ra,0xfffff
    80002130:	d5e080e7          	jalr	-674(ra) # 80000e8a <myproc>
}
    80002134:	5908                	lw	a0,48(a0)
    80002136:	60a2                	ld	ra,8(sp)
    80002138:	6402                	ld	s0,0(sp)
    8000213a:	0141                	addi	sp,sp,16
    8000213c:	8082                	ret

000000008000213e <sys_fork>:

uint64
sys_fork(void)
{
    8000213e:	1141                	addi	sp,sp,-16
    80002140:	e406                	sd	ra,8(sp)
    80002142:	e022                	sd	s0,0(sp)
    80002144:	0800                	addi	s0,sp,16
  return fork();
    80002146:	fffff097          	auipc	ra,0xfffff
    8000214a:	0fa080e7          	jalr	250(ra) # 80001240 <fork>
}
    8000214e:	60a2                	ld	ra,8(sp)
    80002150:	6402                	ld	s0,0(sp)
    80002152:	0141                	addi	sp,sp,16
    80002154:	8082                	ret

0000000080002156 <sys_wait>:

uint64
sys_wait(void)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000215e:	fe840593          	addi	a1,s0,-24
    80002162:	4501                	li	a0,0
    80002164:	00000097          	auipc	ra,0x0
    80002168:	e9a080e7          	jalr	-358(ra) # 80001ffe <argaddr>
  return wait(p);
    8000216c:	fe843503          	ld	a0,-24(s0)
    80002170:	fffff097          	auipc	ra,0xfffff
    80002174:	6a4080e7          	jalr	1700(ra) # 80001814 <wait>
}
    80002178:	60e2                	ld	ra,24(sp)
    8000217a:	6442                	ld	s0,16(sp)
    8000217c:	6105                	addi	sp,sp,32
    8000217e:	8082                	ret

0000000080002180 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002180:	7179                	addi	sp,sp,-48
    80002182:	f406                	sd	ra,40(sp)
    80002184:	f022                	sd	s0,32(sp)
    80002186:	ec26                	sd	s1,24(sp)
    80002188:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000218a:	fdc40593          	addi	a1,s0,-36
    8000218e:	4501                	li	a0,0
    80002190:	00000097          	auipc	ra,0x0
    80002194:	e4e080e7          	jalr	-434(ra) # 80001fde <argint>
  addr = myproc()->sz;
    80002198:	fffff097          	auipc	ra,0xfffff
    8000219c:	cf2080e7          	jalr	-782(ra) # 80000e8a <myproc>
    800021a0:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021a2:	fdc42503          	lw	a0,-36(s0)
    800021a6:	fffff097          	auipc	ra,0xfffff
    800021aa:	03e080e7          	jalr	62(ra) # 800011e4 <growproc>
    800021ae:	00054863          	bltz	a0,800021be <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021b2:	8526                	mv	a0,s1
    800021b4:	70a2                	ld	ra,40(sp)
    800021b6:	7402                	ld	s0,32(sp)
    800021b8:	64e2                	ld	s1,24(sp)
    800021ba:	6145                	addi	sp,sp,48
    800021bc:	8082                	ret
    return -1;
    800021be:	54fd                	li	s1,-1
    800021c0:	bfcd                	j	800021b2 <sys_sbrk+0x32>

00000000800021c2 <sys_sleep>:

uint64
sys_sleep(void)
{
    800021c2:	7139                	addi	sp,sp,-64
    800021c4:	fc06                	sd	ra,56(sp)
    800021c6:	f822                	sd	s0,48(sp)
    800021c8:	f426                	sd	s1,40(sp)
    800021ca:	f04a                	sd	s2,32(sp)
    800021cc:	ec4e                	sd	s3,24(sp)
    800021ce:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800021d0:	fcc40593          	addi	a1,s0,-52
    800021d4:	4501                	li	a0,0
    800021d6:	00000097          	auipc	ra,0x0
    800021da:	e08080e7          	jalr	-504(ra) # 80001fde <argint>
  if(n < 0)
    800021de:	fcc42783          	lw	a5,-52(s0)
    800021e2:	0607cf63          	bltz	a5,80002260 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800021e6:	0000d517          	auipc	a0,0xd
    800021ea:	97a50513          	addi	a0,a0,-1670 # 8000eb60 <tickslock>
    800021ee:	00004097          	auipc	ra,0x4
    800021f2:	fb0080e7          	jalr	-80(ra) # 8000619e <acquire>
  ticks0 = ticks;
    800021f6:	00007917          	auipc	s2,0x7
    800021fa:	90292903          	lw	s2,-1790(s2) # 80008af8 <ticks>
  while(ticks - ticks0 < n){
    800021fe:	fcc42783          	lw	a5,-52(s0)
    80002202:	cf9d                	beqz	a5,80002240 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002204:	0000d997          	auipc	s3,0xd
    80002208:	95c98993          	addi	s3,s3,-1700 # 8000eb60 <tickslock>
    8000220c:	00007497          	auipc	s1,0x7
    80002210:	8ec48493          	addi	s1,s1,-1812 # 80008af8 <ticks>
    if(killed(myproc())){
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	c76080e7          	jalr	-906(ra) # 80000e8a <myproc>
    8000221c:	fffff097          	auipc	ra,0xfffff
    80002220:	5c6080e7          	jalr	1478(ra) # 800017e2 <killed>
    80002224:	e129                	bnez	a0,80002266 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    80002226:	85ce                	mv	a1,s3
    80002228:	8526                	mv	a0,s1
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	310080e7          	jalr	784(ra) # 8000153a <sleep>
  while(ticks - ticks0 < n){
    80002232:	409c                	lw	a5,0(s1)
    80002234:	412787bb          	subw	a5,a5,s2
    80002238:	fcc42703          	lw	a4,-52(s0)
    8000223c:	fce7ece3          	bltu	a5,a4,80002214 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002240:	0000d517          	auipc	a0,0xd
    80002244:	92050513          	addi	a0,a0,-1760 # 8000eb60 <tickslock>
    80002248:	00004097          	auipc	ra,0x4
    8000224c:	00a080e7          	jalr	10(ra) # 80006252 <release>
  return 0;
    80002250:	4501                	li	a0,0
}
    80002252:	70e2                	ld	ra,56(sp)
    80002254:	7442                	ld	s0,48(sp)
    80002256:	74a2                	ld	s1,40(sp)
    80002258:	7902                	ld	s2,32(sp)
    8000225a:	69e2                	ld	s3,24(sp)
    8000225c:	6121                	addi	sp,sp,64
    8000225e:	8082                	ret
    n = 0;
    80002260:	fc042623          	sw	zero,-52(s0)
    80002264:	b749                	j	800021e6 <sys_sleep+0x24>
      release(&tickslock);
    80002266:	0000d517          	auipc	a0,0xd
    8000226a:	8fa50513          	addi	a0,a0,-1798 # 8000eb60 <tickslock>
    8000226e:	00004097          	auipc	ra,0x4
    80002272:	fe4080e7          	jalr	-28(ra) # 80006252 <release>
      return -1;
    80002276:	557d                	li	a0,-1
    80002278:	bfe9                	j	80002252 <sys_sleep+0x90>

000000008000227a <sys_kill>:

uint64
sys_kill(void)
{
    8000227a:	1101                	addi	sp,sp,-32
    8000227c:	ec06                	sd	ra,24(sp)
    8000227e:	e822                	sd	s0,16(sp)
    80002280:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002282:	fec40593          	addi	a1,s0,-20
    80002286:	4501                	li	a0,0
    80002288:	00000097          	auipc	ra,0x0
    8000228c:	d56080e7          	jalr	-682(ra) # 80001fde <argint>
  return kill(pid);
    80002290:	fec42503          	lw	a0,-20(s0)
    80002294:	fffff097          	auipc	ra,0xfffff
    80002298:	4b0080e7          	jalr	1200(ra) # 80001744 <kill>
}
    8000229c:	60e2                	ld	ra,24(sp)
    8000229e:	6442                	ld	s0,16(sp)
    800022a0:	6105                	addi	sp,sp,32
    800022a2:	8082                	ret

00000000800022a4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022a4:	1101                	addi	sp,sp,-32
    800022a6:	ec06                	sd	ra,24(sp)
    800022a8:	e822                	sd	s0,16(sp)
    800022aa:	e426                	sd	s1,8(sp)
    800022ac:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022ae:	0000d517          	auipc	a0,0xd
    800022b2:	8b250513          	addi	a0,a0,-1870 # 8000eb60 <tickslock>
    800022b6:	00004097          	auipc	ra,0x4
    800022ba:	ee8080e7          	jalr	-280(ra) # 8000619e <acquire>
  xticks = ticks;
    800022be:	00007497          	auipc	s1,0x7
    800022c2:	83a4a483          	lw	s1,-1990(s1) # 80008af8 <ticks>
  release(&tickslock);
    800022c6:	0000d517          	auipc	a0,0xd
    800022ca:	89a50513          	addi	a0,a0,-1894 # 8000eb60 <tickslock>
    800022ce:	00004097          	auipc	ra,0x4
    800022d2:	f84080e7          	jalr	-124(ra) # 80006252 <release>
  return xticks;
}
    800022d6:	02049513          	slli	a0,s1,0x20
    800022da:	9101                	srli	a0,a0,0x20
    800022dc:	60e2                	ld	ra,24(sp)
    800022de:	6442                	ld	s0,16(sp)
    800022e0:	64a2                	ld	s1,8(sp)
    800022e2:	6105                	addi	sp,sp,32
    800022e4:	8082                	ret

00000000800022e6 <sys_trace>:

uint64
sys_trace(void){
    800022e6:	1101                	addi	sp,sp,-32
    800022e8:	ec06                	sd	ra,24(sp)
    800022ea:	e822                	sd	s0,16(sp)
    800022ec:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800022ee:	fec40593          	addi	a1,s0,-20
    800022f2:	4501                	li	a0,0
    800022f4:	00000097          	auipc	ra,0x0
    800022f8:	cea080e7          	jalr	-790(ra) # 80001fde <argint>
  myproc()->trace = n;
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	b8e080e7          	jalr	-1138(ra) # 80000e8a <myproc>
    80002304:	fec42783          	lw	a5,-20(s0)
    80002308:	16f52423          	sw	a5,360(a0)
  return 0;
}
    8000230c:	4501                	li	a0,0
    8000230e:	60e2                	ld	ra,24(sp)
    80002310:	6442                	ld	s0,16(sp)
    80002312:	6105                	addi	sp,sp,32
    80002314:	8082                	ret

0000000080002316 <sys_sysinfo>:

uint64
sys_sysinfo(void){
    80002316:	7179                	addi	sp,sp,-48
    80002318:	f406                	sd	ra,40(sp)
    8000231a:	f022                	sd	s0,32(sp)
    8000231c:	1800                	addi	s0,sp,48
  uint64 info;
  argaddr(0, &info);
    8000231e:	fe840593          	addi	a1,s0,-24
    80002322:	4501                	li	a0,0
    80002324:	00000097          	auipc	ra,0x0
    80002328:	cda080e7          	jalr	-806(ra) # 80001ffe <argaddr>
  
  struct sysinfo kinfo;
  kfreemem(&kinfo);
    8000232c:	fd840513          	addi	a0,s0,-40
    80002330:	ffffe097          	auipc	ra,0xffffe
    80002334:	e6a080e7          	jalr	-406(ra) # 8000019a <kfreemem>
  knproc(&kinfo);
    80002338:	fd840513          	addi	a0,s0,-40
    8000233c:	fffff097          	auipc	ra,0xfffff
    80002340:	762080e7          	jalr	1890(ra) # 80001a9e <knproc>
  struct proc *p = myproc();
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	b46080e7          	jalr	-1210(ra) # 80000e8a <myproc>
  if(copyout(p->pagetable, info, (char *)&kinfo, sizeof(kinfo)) < 0)
    8000234c:	46c1                	li	a3,16
    8000234e:	fd840613          	addi	a2,s0,-40
    80002352:	fe843583          	ld	a1,-24(s0)
    80002356:	6928                	ld	a0,80(a0)
    80002358:	ffffe097          	auipc	ra,0xffffe
    8000235c:	7f2080e7          	jalr	2034(ra) # 80000b4a <copyout>
    return -1;
  return 0;
}
    80002360:	957d                	srai	a0,a0,0x3f
    80002362:	70a2                	ld	ra,40(sp)
    80002364:	7402                	ld	s0,32(sp)
    80002366:	6145                	addi	sp,sp,48
    80002368:	8082                	ret

000000008000236a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000236a:	7179                	addi	sp,sp,-48
    8000236c:	f406                	sd	ra,40(sp)
    8000236e:	f022                	sd	s0,32(sp)
    80002370:	ec26                	sd	s1,24(sp)
    80002372:	e84a                	sd	s2,16(sp)
    80002374:	e44e                	sd	s3,8(sp)
    80002376:	e052                	sd	s4,0(sp)
    80002378:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000237a:	00006597          	auipc	a1,0x6
    8000237e:	35e58593          	addi	a1,a1,862 # 800086d8 <syscallNames+0xc0>
    80002382:	0000c517          	auipc	a0,0xc
    80002386:	7f650513          	addi	a0,a0,2038 # 8000eb78 <bcache>
    8000238a:	00004097          	auipc	ra,0x4
    8000238e:	d84080e7          	jalr	-636(ra) # 8000610e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002392:	00014797          	auipc	a5,0x14
    80002396:	7e678793          	addi	a5,a5,2022 # 80016b78 <bcache+0x8000>
    8000239a:	00015717          	auipc	a4,0x15
    8000239e:	a4670713          	addi	a4,a4,-1466 # 80016de0 <bcache+0x8268>
    800023a2:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a6:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023aa:	0000c497          	auipc	s1,0xc
    800023ae:	7e648493          	addi	s1,s1,2022 # 8000eb90 <bcache+0x18>
    b->next = bcache.head.next;
    800023b2:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023b4:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b6:	00006a17          	auipc	s4,0x6
    800023ba:	32aa0a13          	addi	s4,s4,810 # 800086e0 <syscallNames+0xc8>
    b->next = bcache.head.next;
    800023be:	2b893783          	ld	a5,696(s2)
    800023c2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023c4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023c8:	85d2                	mv	a1,s4
    800023ca:	01048513          	addi	a0,s1,16
    800023ce:	00001097          	auipc	ra,0x1
    800023d2:	496080e7          	jalr	1174(ra) # 80003864 <initsleeplock>
    bcache.head.next->prev = b;
    800023d6:	2b893783          	ld	a5,696(s2)
    800023da:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023dc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e0:	45848493          	addi	s1,s1,1112
    800023e4:	fd349de3          	bne	s1,s3,800023be <binit+0x54>
  }
}
    800023e8:	70a2                	ld	ra,40(sp)
    800023ea:	7402                	ld	s0,32(sp)
    800023ec:	64e2                	ld	s1,24(sp)
    800023ee:	6942                	ld	s2,16(sp)
    800023f0:	69a2                	ld	s3,8(sp)
    800023f2:	6a02                	ld	s4,0(sp)
    800023f4:	6145                	addi	sp,sp,48
    800023f6:	8082                	ret

00000000800023f8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023f8:	7179                	addi	sp,sp,-48
    800023fa:	f406                	sd	ra,40(sp)
    800023fc:	f022                	sd	s0,32(sp)
    800023fe:	ec26                	sd	s1,24(sp)
    80002400:	e84a                	sd	s2,16(sp)
    80002402:	e44e                	sd	s3,8(sp)
    80002404:	1800                	addi	s0,sp,48
    80002406:	892a                	mv	s2,a0
    80002408:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000240a:	0000c517          	auipc	a0,0xc
    8000240e:	76e50513          	addi	a0,a0,1902 # 8000eb78 <bcache>
    80002412:	00004097          	auipc	ra,0x4
    80002416:	d8c080e7          	jalr	-628(ra) # 8000619e <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000241a:	00015497          	auipc	s1,0x15
    8000241e:	a164b483          	ld	s1,-1514(s1) # 80016e30 <bcache+0x82b8>
    80002422:	00015797          	auipc	a5,0x15
    80002426:	9be78793          	addi	a5,a5,-1602 # 80016de0 <bcache+0x8268>
    8000242a:	02f48f63          	beq	s1,a5,80002468 <bread+0x70>
    8000242e:	873e                	mv	a4,a5
    80002430:	a021                	j	80002438 <bread+0x40>
    80002432:	68a4                	ld	s1,80(s1)
    80002434:	02e48a63          	beq	s1,a4,80002468 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002438:	449c                	lw	a5,8(s1)
    8000243a:	ff279ce3          	bne	a5,s2,80002432 <bread+0x3a>
    8000243e:	44dc                	lw	a5,12(s1)
    80002440:	ff3799e3          	bne	a5,s3,80002432 <bread+0x3a>
      b->refcnt++;
    80002444:	40bc                	lw	a5,64(s1)
    80002446:	2785                	addiw	a5,a5,1
    80002448:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000244a:	0000c517          	auipc	a0,0xc
    8000244e:	72e50513          	addi	a0,a0,1838 # 8000eb78 <bcache>
    80002452:	00004097          	auipc	ra,0x4
    80002456:	e00080e7          	jalr	-512(ra) # 80006252 <release>
      acquiresleep(&b->lock);
    8000245a:	01048513          	addi	a0,s1,16
    8000245e:	00001097          	auipc	ra,0x1
    80002462:	440080e7          	jalr	1088(ra) # 8000389e <acquiresleep>
      return b;
    80002466:	a8b9                	j	800024c4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002468:	00015497          	auipc	s1,0x15
    8000246c:	9c04b483          	ld	s1,-1600(s1) # 80016e28 <bcache+0x82b0>
    80002470:	00015797          	auipc	a5,0x15
    80002474:	97078793          	addi	a5,a5,-1680 # 80016de0 <bcache+0x8268>
    80002478:	00f48863          	beq	s1,a5,80002488 <bread+0x90>
    8000247c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000247e:	40bc                	lw	a5,64(s1)
    80002480:	cf81                	beqz	a5,80002498 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002482:	64a4                	ld	s1,72(s1)
    80002484:	fee49de3          	bne	s1,a4,8000247e <bread+0x86>
  panic("bget: no buffers");
    80002488:	00006517          	auipc	a0,0x6
    8000248c:	26050513          	addi	a0,a0,608 # 800086e8 <syscallNames+0xd0>
    80002490:	00003097          	auipc	ra,0x3
    80002494:	7d6080e7          	jalr	2006(ra) # 80005c66 <panic>
      b->dev = dev;
    80002498:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000249c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800024a0:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024a4:	4785                	li	a5,1
    800024a6:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a8:	0000c517          	auipc	a0,0xc
    800024ac:	6d050513          	addi	a0,a0,1744 # 8000eb78 <bcache>
    800024b0:	00004097          	auipc	ra,0x4
    800024b4:	da2080e7          	jalr	-606(ra) # 80006252 <release>
      acquiresleep(&b->lock);
    800024b8:	01048513          	addi	a0,s1,16
    800024bc:	00001097          	auipc	ra,0x1
    800024c0:	3e2080e7          	jalr	994(ra) # 8000389e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024c4:	409c                	lw	a5,0(s1)
    800024c6:	cb89                	beqz	a5,800024d8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024c8:	8526                	mv	a0,s1
    800024ca:	70a2                	ld	ra,40(sp)
    800024cc:	7402                	ld	s0,32(sp)
    800024ce:	64e2                	ld	s1,24(sp)
    800024d0:	6942                	ld	s2,16(sp)
    800024d2:	69a2                	ld	s3,8(sp)
    800024d4:	6145                	addi	sp,sp,48
    800024d6:	8082                	ret
    virtio_disk_rw(b, 0);
    800024d8:	4581                	li	a1,0
    800024da:	8526                	mv	a0,s1
    800024dc:	00003097          	auipc	ra,0x3
    800024e0:	f86080e7          	jalr	-122(ra) # 80005462 <virtio_disk_rw>
    b->valid = 1;
    800024e4:	4785                	li	a5,1
    800024e6:	c09c                	sw	a5,0(s1)
  return b;
    800024e8:	b7c5                	j	800024c8 <bread+0xd0>

00000000800024ea <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ea:	1101                	addi	sp,sp,-32
    800024ec:	ec06                	sd	ra,24(sp)
    800024ee:	e822                	sd	s0,16(sp)
    800024f0:	e426                	sd	s1,8(sp)
    800024f2:	1000                	addi	s0,sp,32
    800024f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f6:	0541                	addi	a0,a0,16
    800024f8:	00001097          	auipc	ra,0x1
    800024fc:	440080e7          	jalr	1088(ra) # 80003938 <holdingsleep>
    80002500:	cd01                	beqz	a0,80002518 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002502:	4585                	li	a1,1
    80002504:	8526                	mv	a0,s1
    80002506:	00003097          	auipc	ra,0x3
    8000250a:	f5c080e7          	jalr	-164(ra) # 80005462 <virtio_disk_rw>
}
    8000250e:	60e2                	ld	ra,24(sp)
    80002510:	6442                	ld	s0,16(sp)
    80002512:	64a2                	ld	s1,8(sp)
    80002514:	6105                	addi	sp,sp,32
    80002516:	8082                	ret
    panic("bwrite");
    80002518:	00006517          	auipc	a0,0x6
    8000251c:	1e850513          	addi	a0,a0,488 # 80008700 <syscallNames+0xe8>
    80002520:	00003097          	auipc	ra,0x3
    80002524:	746080e7          	jalr	1862(ra) # 80005c66 <panic>

0000000080002528 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002528:	1101                	addi	sp,sp,-32
    8000252a:	ec06                	sd	ra,24(sp)
    8000252c:	e822                	sd	s0,16(sp)
    8000252e:	e426                	sd	s1,8(sp)
    80002530:	e04a                	sd	s2,0(sp)
    80002532:	1000                	addi	s0,sp,32
    80002534:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002536:	01050913          	addi	s2,a0,16
    8000253a:	854a                	mv	a0,s2
    8000253c:	00001097          	auipc	ra,0x1
    80002540:	3fc080e7          	jalr	1020(ra) # 80003938 <holdingsleep>
    80002544:	c925                	beqz	a0,800025b4 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80002546:	854a                	mv	a0,s2
    80002548:	00001097          	auipc	ra,0x1
    8000254c:	3ac080e7          	jalr	940(ra) # 800038f4 <releasesleep>

  acquire(&bcache.lock);
    80002550:	0000c517          	auipc	a0,0xc
    80002554:	62850513          	addi	a0,a0,1576 # 8000eb78 <bcache>
    80002558:	00004097          	auipc	ra,0x4
    8000255c:	c46080e7          	jalr	-954(ra) # 8000619e <acquire>
  b->refcnt--;
    80002560:	40bc                	lw	a5,64(s1)
    80002562:	37fd                	addiw	a5,a5,-1
    80002564:	0007871b          	sext.w	a4,a5
    80002568:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000256a:	e71d                	bnez	a4,80002598 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000256c:	68b8                	ld	a4,80(s1)
    8000256e:	64bc                	ld	a5,72(s1)
    80002570:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002572:	68b8                	ld	a4,80(s1)
    80002574:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002576:	00014797          	auipc	a5,0x14
    8000257a:	60278793          	addi	a5,a5,1538 # 80016b78 <bcache+0x8000>
    8000257e:	2b87b703          	ld	a4,696(a5)
    80002582:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002584:	00015717          	auipc	a4,0x15
    80002588:	85c70713          	addi	a4,a4,-1956 # 80016de0 <bcache+0x8268>
    8000258c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000258e:	2b87b703          	ld	a4,696(a5)
    80002592:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002594:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002598:	0000c517          	auipc	a0,0xc
    8000259c:	5e050513          	addi	a0,a0,1504 # 8000eb78 <bcache>
    800025a0:	00004097          	auipc	ra,0x4
    800025a4:	cb2080e7          	jalr	-846(ra) # 80006252 <release>
}
    800025a8:	60e2                	ld	ra,24(sp)
    800025aa:	6442                	ld	s0,16(sp)
    800025ac:	64a2                	ld	s1,8(sp)
    800025ae:	6902                	ld	s2,0(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret
    panic("brelse");
    800025b4:	00006517          	auipc	a0,0x6
    800025b8:	15450513          	addi	a0,a0,340 # 80008708 <syscallNames+0xf0>
    800025bc:	00003097          	auipc	ra,0x3
    800025c0:	6aa080e7          	jalr	1706(ra) # 80005c66 <panic>

00000000800025c4 <bpin>:

void
bpin(struct buf *b) {
    800025c4:	1101                	addi	sp,sp,-32
    800025c6:	ec06                	sd	ra,24(sp)
    800025c8:	e822                	sd	s0,16(sp)
    800025ca:	e426                	sd	s1,8(sp)
    800025cc:	1000                	addi	s0,sp,32
    800025ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d0:	0000c517          	auipc	a0,0xc
    800025d4:	5a850513          	addi	a0,a0,1448 # 8000eb78 <bcache>
    800025d8:	00004097          	auipc	ra,0x4
    800025dc:	bc6080e7          	jalr	-1082(ra) # 8000619e <acquire>
  b->refcnt++;
    800025e0:	40bc                	lw	a5,64(s1)
    800025e2:	2785                	addiw	a5,a5,1
    800025e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e6:	0000c517          	auipc	a0,0xc
    800025ea:	59250513          	addi	a0,a0,1426 # 8000eb78 <bcache>
    800025ee:	00004097          	auipc	ra,0x4
    800025f2:	c64080e7          	jalr	-924(ra) # 80006252 <release>
}
    800025f6:	60e2                	ld	ra,24(sp)
    800025f8:	6442                	ld	s0,16(sp)
    800025fa:	64a2                	ld	s1,8(sp)
    800025fc:	6105                	addi	sp,sp,32
    800025fe:	8082                	ret

0000000080002600 <bunpin>:

void
bunpin(struct buf *b) {
    80002600:	1101                	addi	sp,sp,-32
    80002602:	ec06                	sd	ra,24(sp)
    80002604:	e822                	sd	s0,16(sp)
    80002606:	e426                	sd	s1,8(sp)
    80002608:	1000                	addi	s0,sp,32
    8000260a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000260c:	0000c517          	auipc	a0,0xc
    80002610:	56c50513          	addi	a0,a0,1388 # 8000eb78 <bcache>
    80002614:	00004097          	auipc	ra,0x4
    80002618:	b8a080e7          	jalr	-1142(ra) # 8000619e <acquire>
  b->refcnt--;
    8000261c:	40bc                	lw	a5,64(s1)
    8000261e:	37fd                	addiw	a5,a5,-1
    80002620:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002622:	0000c517          	auipc	a0,0xc
    80002626:	55650513          	addi	a0,a0,1366 # 8000eb78 <bcache>
    8000262a:	00004097          	auipc	ra,0x4
    8000262e:	c28080e7          	jalr	-984(ra) # 80006252 <release>
}
    80002632:	60e2                	ld	ra,24(sp)
    80002634:	6442                	ld	s0,16(sp)
    80002636:	64a2                	ld	s1,8(sp)
    80002638:	6105                	addi	sp,sp,32
    8000263a:	8082                	ret

000000008000263c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000263c:	1101                	addi	sp,sp,-32
    8000263e:	ec06                	sd	ra,24(sp)
    80002640:	e822                	sd	s0,16(sp)
    80002642:	e426                	sd	s1,8(sp)
    80002644:	e04a                	sd	s2,0(sp)
    80002646:	1000                	addi	s0,sp,32
    80002648:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000264a:	00d5d59b          	srliw	a1,a1,0xd
    8000264e:	00015797          	auipc	a5,0x15
    80002652:	c067a783          	lw	a5,-1018(a5) # 80017254 <sb+0x1c>
    80002656:	9dbd                	addw	a1,a1,a5
    80002658:	00000097          	auipc	ra,0x0
    8000265c:	da0080e7          	jalr	-608(ra) # 800023f8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002660:	0074f713          	andi	a4,s1,7
    80002664:	4785                	li	a5,1
    80002666:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000266a:	14ce                	slli	s1,s1,0x33
    8000266c:	90d9                	srli	s1,s1,0x36
    8000266e:	00950733          	add	a4,a0,s1
    80002672:	05874703          	lbu	a4,88(a4)
    80002676:	00e7f6b3          	and	a3,a5,a4
    8000267a:	c69d                	beqz	a3,800026a8 <bfree+0x6c>
    8000267c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000267e:	94aa                	add	s1,s1,a0
    80002680:	fff7c793          	not	a5,a5
    80002684:	8f7d                	and	a4,a4,a5
    80002686:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000268a:	00001097          	auipc	ra,0x1
    8000268e:	0f6080e7          	jalr	246(ra) # 80003780 <log_write>
  brelse(bp);
    80002692:	854a                	mv	a0,s2
    80002694:	00000097          	auipc	ra,0x0
    80002698:	e94080e7          	jalr	-364(ra) # 80002528 <brelse>
}
    8000269c:	60e2                	ld	ra,24(sp)
    8000269e:	6442                	ld	s0,16(sp)
    800026a0:	64a2                	ld	s1,8(sp)
    800026a2:	6902                	ld	s2,0(sp)
    800026a4:	6105                	addi	sp,sp,32
    800026a6:	8082                	ret
    panic("freeing free block");
    800026a8:	00006517          	auipc	a0,0x6
    800026ac:	06850513          	addi	a0,a0,104 # 80008710 <syscallNames+0xf8>
    800026b0:	00003097          	auipc	ra,0x3
    800026b4:	5b6080e7          	jalr	1462(ra) # 80005c66 <panic>

00000000800026b8 <balloc>:
{
    800026b8:	711d                	addi	sp,sp,-96
    800026ba:	ec86                	sd	ra,88(sp)
    800026bc:	e8a2                	sd	s0,80(sp)
    800026be:	e4a6                	sd	s1,72(sp)
    800026c0:	e0ca                	sd	s2,64(sp)
    800026c2:	fc4e                	sd	s3,56(sp)
    800026c4:	f852                	sd	s4,48(sp)
    800026c6:	f456                	sd	s5,40(sp)
    800026c8:	f05a                	sd	s6,32(sp)
    800026ca:	ec5e                	sd	s7,24(sp)
    800026cc:	e862                	sd	s8,16(sp)
    800026ce:	e466                	sd	s9,8(sp)
    800026d0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026d2:	00015797          	auipc	a5,0x15
    800026d6:	b6a7a783          	lw	a5,-1174(a5) # 8001723c <sb+0x4>
    800026da:	cff5                	beqz	a5,800027d6 <balloc+0x11e>
    800026dc:	8baa                	mv	s7,a0
    800026de:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026e0:	00015b17          	auipc	s6,0x15
    800026e4:	b58b0b13          	addi	s6,s6,-1192 # 80017238 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026e8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026ea:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ec:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026ee:	6c89                	lui	s9,0x2
    800026f0:	a061                	j	80002778 <balloc+0xc0>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026f2:	97ca                	add	a5,a5,s2
    800026f4:	8e55                	or	a2,a2,a3
    800026f6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800026fa:	854a                	mv	a0,s2
    800026fc:	00001097          	auipc	ra,0x1
    80002700:	084080e7          	jalr	132(ra) # 80003780 <log_write>
        brelse(bp);
    80002704:	854a                	mv	a0,s2
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	e22080e7          	jalr	-478(ra) # 80002528 <brelse>
  bp = bread(dev, bno);
    8000270e:	85a6                	mv	a1,s1
    80002710:	855e                	mv	a0,s7
    80002712:	00000097          	auipc	ra,0x0
    80002716:	ce6080e7          	jalr	-794(ra) # 800023f8 <bread>
    8000271a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000271c:	40000613          	li	a2,1024
    80002720:	4581                	li	a1,0
    80002722:	05850513          	addi	a0,a0,88
    80002726:	ffffe097          	auipc	ra,0xffffe
    8000272a:	a8c080e7          	jalr	-1396(ra) # 800001b2 <memset>
  log_write(bp);
    8000272e:	854a                	mv	a0,s2
    80002730:	00001097          	auipc	ra,0x1
    80002734:	050080e7          	jalr	80(ra) # 80003780 <log_write>
  brelse(bp);
    80002738:	854a                	mv	a0,s2
    8000273a:	00000097          	auipc	ra,0x0
    8000273e:	dee080e7          	jalr	-530(ra) # 80002528 <brelse>
}
    80002742:	8526                	mv	a0,s1
    80002744:	60e6                	ld	ra,88(sp)
    80002746:	6446                	ld	s0,80(sp)
    80002748:	64a6                	ld	s1,72(sp)
    8000274a:	6906                	ld	s2,64(sp)
    8000274c:	79e2                	ld	s3,56(sp)
    8000274e:	7a42                	ld	s4,48(sp)
    80002750:	7aa2                	ld	s5,40(sp)
    80002752:	7b02                	ld	s6,32(sp)
    80002754:	6be2                	ld	s7,24(sp)
    80002756:	6c42                	ld	s8,16(sp)
    80002758:	6ca2                	ld	s9,8(sp)
    8000275a:	6125                	addi	sp,sp,96
    8000275c:	8082                	ret
    brelse(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00000097          	auipc	ra,0x0
    80002764:	dc8080e7          	jalr	-568(ra) # 80002528 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002768:	015c87bb          	addw	a5,s9,s5
    8000276c:	00078a9b          	sext.w	s5,a5
    80002770:	004b2703          	lw	a4,4(s6)
    80002774:	06eaf163          	bgeu	s5,a4,800027d6 <balloc+0x11e>
    bp = bread(dev, BBLOCK(b, sb));
    80002778:	41fad79b          	sraiw	a5,s5,0x1f
    8000277c:	0137d79b          	srliw	a5,a5,0x13
    80002780:	015787bb          	addw	a5,a5,s5
    80002784:	40d7d79b          	sraiw	a5,a5,0xd
    80002788:	01cb2583          	lw	a1,28(s6)
    8000278c:	9dbd                	addw	a1,a1,a5
    8000278e:	855e                	mv	a0,s7
    80002790:	00000097          	auipc	ra,0x0
    80002794:	c68080e7          	jalr	-920(ra) # 800023f8 <bread>
    80002798:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000279a:	004b2503          	lw	a0,4(s6)
    8000279e:	000a849b          	sext.w	s1,s5
    800027a2:	8762                	mv	a4,s8
    800027a4:	faa4fde3          	bgeu	s1,a0,8000275e <balloc+0xa6>
      m = 1 << (bi % 8);
    800027a8:	00777693          	andi	a3,a4,7
    800027ac:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027b0:	41f7579b          	sraiw	a5,a4,0x1f
    800027b4:	01d7d79b          	srliw	a5,a5,0x1d
    800027b8:	9fb9                	addw	a5,a5,a4
    800027ba:	4037d79b          	sraiw	a5,a5,0x3
    800027be:	00f90633          	add	a2,s2,a5
    800027c2:	05864603          	lbu	a2,88(a2)
    800027c6:	00c6f5b3          	and	a1,a3,a2
    800027ca:	d585                	beqz	a1,800026f2 <balloc+0x3a>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027cc:	2705                	addiw	a4,a4,1
    800027ce:	2485                	addiw	s1,s1,1
    800027d0:	fd471ae3          	bne	a4,s4,800027a4 <balloc+0xec>
    800027d4:	b769                	j	8000275e <balloc+0xa6>
  printf("balloc: out of blocks\n");
    800027d6:	00006517          	auipc	a0,0x6
    800027da:	f5250513          	addi	a0,a0,-174 # 80008728 <syscallNames+0x110>
    800027de:	00003097          	auipc	ra,0x3
    800027e2:	4d2080e7          	jalr	1234(ra) # 80005cb0 <printf>
  return 0;
    800027e6:	4481                	li	s1,0
    800027e8:	bfa9                	j	80002742 <balloc+0x8a>

00000000800027ea <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ea:	7179                	addi	sp,sp,-48
    800027ec:	f406                	sd	ra,40(sp)
    800027ee:	f022                	sd	s0,32(sp)
    800027f0:	ec26                	sd	s1,24(sp)
    800027f2:	e84a                	sd	s2,16(sp)
    800027f4:	e44e                	sd	s3,8(sp)
    800027f6:	e052                	sd	s4,0(sp)
    800027f8:	1800                	addi	s0,sp,48
    800027fa:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027fc:	47ad                	li	a5,11
    800027fe:	02b7e863          	bltu	a5,a1,8000282e <bmap+0x44>
    if((addr = ip->addrs[bn]) == 0){
    80002802:	02059793          	slli	a5,a1,0x20
    80002806:	01e7d593          	srli	a1,a5,0x1e
    8000280a:	00b504b3          	add	s1,a0,a1
    8000280e:	0504a903          	lw	s2,80(s1)
    80002812:	06091e63          	bnez	s2,8000288e <bmap+0xa4>
      addr = balloc(ip->dev);
    80002816:	4108                	lw	a0,0(a0)
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	ea0080e7          	jalr	-352(ra) # 800026b8 <balloc>
    80002820:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002824:	06090563          	beqz	s2,8000288e <bmap+0xa4>
        return 0;
      ip->addrs[bn] = addr;
    80002828:	0524a823          	sw	s2,80(s1)
    8000282c:	a08d                	j	8000288e <bmap+0xa4>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000282e:	ff45849b          	addiw	s1,a1,-12
    80002832:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002836:	0ff00793          	li	a5,255
    8000283a:	08e7e563          	bltu	a5,a4,800028c4 <bmap+0xda>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000283e:	08052903          	lw	s2,128(a0)
    80002842:	00091d63          	bnez	s2,8000285c <bmap+0x72>
      addr = balloc(ip->dev);
    80002846:	4108                	lw	a0,0(a0)
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	e70080e7          	jalr	-400(ra) # 800026b8 <balloc>
    80002850:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002854:	02090d63          	beqz	s2,8000288e <bmap+0xa4>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002858:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000285c:	85ca                	mv	a1,s2
    8000285e:	0009a503          	lw	a0,0(s3)
    80002862:	00000097          	auipc	ra,0x0
    80002866:	b96080e7          	jalr	-1130(ra) # 800023f8 <bread>
    8000286a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000286c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002870:	02049713          	slli	a4,s1,0x20
    80002874:	01e75593          	srli	a1,a4,0x1e
    80002878:	00b784b3          	add	s1,a5,a1
    8000287c:	0004a903          	lw	s2,0(s1)
    80002880:	02090063          	beqz	s2,800028a0 <bmap+0xb6>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002884:	8552                	mv	a0,s4
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	ca2080e7          	jalr	-862(ra) # 80002528 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000288e:	854a                	mv	a0,s2
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6a02                	ld	s4,0(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
      addr = balloc(ip->dev);
    800028a0:	0009a503          	lw	a0,0(s3)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e14080e7          	jalr	-492(ra) # 800026b8 <balloc>
    800028ac:	0005091b          	sext.w	s2,a0
      if(addr){
    800028b0:	fc090ae3          	beqz	s2,80002884 <bmap+0x9a>
        a[bn] = addr;
    800028b4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028b8:	8552                	mv	a0,s4
    800028ba:	00001097          	auipc	ra,0x1
    800028be:	ec6080e7          	jalr	-314(ra) # 80003780 <log_write>
    800028c2:	b7c9                	j	80002884 <bmap+0x9a>
  panic("bmap: out of range");
    800028c4:	00006517          	auipc	a0,0x6
    800028c8:	e7c50513          	addi	a0,a0,-388 # 80008740 <syscallNames+0x128>
    800028cc:	00003097          	auipc	ra,0x3
    800028d0:	39a080e7          	jalr	922(ra) # 80005c66 <panic>

00000000800028d4 <iget>:
{
    800028d4:	7179                	addi	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	e052                	sd	s4,0(sp)
    800028e2:	1800                	addi	s0,sp,48
    800028e4:	89aa                	mv	s3,a0
    800028e6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028e8:	00015517          	auipc	a0,0x15
    800028ec:	97050513          	addi	a0,a0,-1680 # 80017258 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	8ae080e7          	jalr	-1874(ra) # 8000619e <acquire>
  empty = 0;
    800028f8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028fa:	00015497          	auipc	s1,0x15
    800028fe:	97648493          	addi	s1,s1,-1674 # 80017270 <itable+0x18>
    80002902:	00016697          	auipc	a3,0x16
    80002906:	3fe68693          	addi	a3,a3,1022 # 80018d00 <log>
    8000290a:	a039                	j	80002918 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000290c:	02090b63          	beqz	s2,80002942 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002910:	08848493          	addi	s1,s1,136
    80002914:	02d48a63          	beq	s1,a3,80002948 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002918:	449c                	lw	a5,8(s1)
    8000291a:	fef059e3          	blez	a5,8000290c <iget+0x38>
    8000291e:	4098                	lw	a4,0(s1)
    80002920:	ff3716e3          	bne	a4,s3,8000290c <iget+0x38>
    80002924:	40d8                	lw	a4,4(s1)
    80002926:	ff4713e3          	bne	a4,s4,8000290c <iget+0x38>
      ip->ref++;
    8000292a:	2785                	addiw	a5,a5,1
    8000292c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000292e:	00015517          	auipc	a0,0x15
    80002932:	92a50513          	addi	a0,a0,-1750 # 80017258 <itable>
    80002936:	00004097          	auipc	ra,0x4
    8000293a:	91c080e7          	jalr	-1764(ra) # 80006252 <release>
      return ip;
    8000293e:	8926                	mv	s2,s1
    80002940:	a03d                	j	8000296e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002942:	f7f9                	bnez	a5,80002910 <iget+0x3c>
    80002944:	8926                	mv	s2,s1
    80002946:	b7e9                	j	80002910 <iget+0x3c>
  if(empty == 0)
    80002948:	02090c63          	beqz	s2,80002980 <iget+0xac>
  ip->dev = dev;
    8000294c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002950:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002954:	4785                	li	a5,1
    80002956:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000295a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000295e:	00015517          	auipc	a0,0x15
    80002962:	8fa50513          	addi	a0,a0,-1798 # 80017258 <itable>
    80002966:	00004097          	auipc	ra,0x4
    8000296a:	8ec080e7          	jalr	-1812(ra) # 80006252 <release>
}
    8000296e:	854a                	mv	a0,s2
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6a02                	ld	s4,0(sp)
    8000297c:	6145                	addi	sp,sp,48
    8000297e:	8082                	ret
    panic("iget: no inodes");
    80002980:	00006517          	auipc	a0,0x6
    80002984:	dd850513          	addi	a0,a0,-552 # 80008758 <syscallNames+0x140>
    80002988:	00003097          	auipc	ra,0x3
    8000298c:	2de080e7          	jalr	734(ra) # 80005c66 <panic>

0000000080002990 <fsinit>:
fsinit(int dev) {
    80002990:	7179                	addi	sp,sp,-48
    80002992:	f406                	sd	ra,40(sp)
    80002994:	f022                	sd	s0,32(sp)
    80002996:	ec26                	sd	s1,24(sp)
    80002998:	e84a                	sd	s2,16(sp)
    8000299a:	e44e                	sd	s3,8(sp)
    8000299c:	1800                	addi	s0,sp,48
    8000299e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029a0:	4585                	li	a1,1
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a56080e7          	jalr	-1450(ra) # 800023f8 <bread>
    800029aa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029ac:	00015997          	auipc	s3,0x15
    800029b0:	88c98993          	addi	s3,s3,-1908 # 80017238 <sb>
    800029b4:	02000613          	li	a2,32
    800029b8:	05850593          	addi	a1,a0,88
    800029bc:	854e                	mv	a0,s3
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	850080e7          	jalr	-1968(ra) # 8000020e <memmove>
  brelse(bp);
    800029c6:	8526                	mv	a0,s1
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	b60080e7          	jalr	-1184(ra) # 80002528 <brelse>
  if(sb.magic != FSMAGIC)
    800029d0:	0009a703          	lw	a4,0(s3)
    800029d4:	102037b7          	lui	a5,0x10203
    800029d8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029dc:	02f71263          	bne	a4,a5,80002a00 <fsinit+0x70>
  initlog(dev, &sb);
    800029e0:	00015597          	auipc	a1,0x15
    800029e4:	85858593          	addi	a1,a1,-1960 # 80017238 <sb>
    800029e8:	854a                	mv	a0,s2
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	b2c080e7          	jalr	-1236(ra) # 80003516 <initlog>
}
    800029f2:	70a2                	ld	ra,40(sp)
    800029f4:	7402                	ld	s0,32(sp)
    800029f6:	64e2                	ld	s1,24(sp)
    800029f8:	6942                	ld	s2,16(sp)
    800029fa:	69a2                	ld	s3,8(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
    panic("invalid file system");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	d6850513          	addi	a0,a0,-664 # 80008768 <syscallNames+0x150>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	25e080e7          	jalr	606(ra) # 80005c66 <panic>

0000000080002a10 <iinit>:
{
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a1e:	00006597          	auipc	a1,0x6
    80002a22:	d6258593          	addi	a1,a1,-670 # 80008780 <syscallNames+0x168>
    80002a26:	00015517          	auipc	a0,0x15
    80002a2a:	83250513          	addi	a0,a0,-1998 # 80017258 <itable>
    80002a2e:	00003097          	auipc	ra,0x3
    80002a32:	6e0080e7          	jalr	1760(ra) # 8000610e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a36:	00015497          	auipc	s1,0x15
    80002a3a:	84a48493          	addi	s1,s1,-1974 # 80017280 <itable+0x28>
    80002a3e:	00016997          	auipc	s3,0x16
    80002a42:	2d298993          	addi	s3,s3,722 # 80018d10 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a46:	00006917          	auipc	s2,0x6
    80002a4a:	d4290913          	addi	s2,s2,-702 # 80008788 <syscallNames+0x170>
    80002a4e:	85ca                	mv	a1,s2
    80002a50:	8526                	mv	a0,s1
    80002a52:	00001097          	auipc	ra,0x1
    80002a56:	e12080e7          	jalr	-494(ra) # 80003864 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a5a:	08848493          	addi	s1,s1,136
    80002a5e:	ff3498e3          	bne	s1,s3,80002a4e <iinit+0x3e>
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6145                	addi	sp,sp,48
    80002a6e:	8082                	ret

0000000080002a70 <ialloc>:
{
    80002a70:	7139                	addi	sp,sp,-64
    80002a72:	fc06                	sd	ra,56(sp)
    80002a74:	f822                	sd	s0,48(sp)
    80002a76:	f426                	sd	s1,40(sp)
    80002a78:	f04a                	sd	s2,32(sp)
    80002a7a:	ec4e                	sd	s3,24(sp)
    80002a7c:	e852                	sd	s4,16(sp)
    80002a7e:	e456                	sd	s5,8(sp)
    80002a80:	e05a                	sd	s6,0(sp)
    80002a82:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a84:	00014717          	auipc	a4,0x14
    80002a88:	7c072703          	lw	a4,1984(a4) # 80017244 <sb+0xc>
    80002a8c:	4785                	li	a5,1
    80002a8e:	04e7f863          	bgeu	a5,a4,80002ade <ialloc+0x6e>
    80002a92:	8aaa                	mv	s5,a0
    80002a94:	8b2e                	mv	s6,a1
    80002a96:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a98:	00014a17          	auipc	s4,0x14
    80002a9c:	7a0a0a13          	addi	s4,s4,1952 # 80017238 <sb>
    80002aa0:	00495593          	srli	a1,s2,0x4
    80002aa4:	018a2783          	lw	a5,24(s4)
    80002aa8:	9dbd                	addw	a1,a1,a5
    80002aaa:	8556                	mv	a0,s5
    80002aac:	00000097          	auipc	ra,0x0
    80002ab0:	94c080e7          	jalr	-1716(ra) # 800023f8 <bread>
    80002ab4:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ab6:	05850993          	addi	s3,a0,88
    80002aba:	00f97793          	andi	a5,s2,15
    80002abe:	079a                	slli	a5,a5,0x6
    80002ac0:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ac2:	00099783          	lh	a5,0(s3)
    80002ac6:	cf9d                	beqz	a5,80002b04 <ialloc+0x94>
    brelse(bp);
    80002ac8:	00000097          	auipc	ra,0x0
    80002acc:	a60080e7          	jalr	-1440(ra) # 80002528 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ad0:	0905                	addi	s2,s2,1
    80002ad2:	00ca2703          	lw	a4,12(s4)
    80002ad6:	0009079b          	sext.w	a5,s2
    80002ada:	fce7e3e3          	bltu	a5,a4,80002aa0 <ialloc+0x30>
  printf("ialloc: no inodes\n");
    80002ade:	00006517          	auipc	a0,0x6
    80002ae2:	cb250513          	addi	a0,a0,-846 # 80008790 <syscallNames+0x178>
    80002ae6:	00003097          	auipc	ra,0x3
    80002aea:	1ca080e7          	jalr	458(ra) # 80005cb0 <printf>
  return 0;
    80002aee:	4501                	li	a0,0
}
    80002af0:	70e2                	ld	ra,56(sp)
    80002af2:	7442                	ld	s0,48(sp)
    80002af4:	74a2                	ld	s1,40(sp)
    80002af6:	7902                	ld	s2,32(sp)
    80002af8:	69e2                	ld	s3,24(sp)
    80002afa:	6a42                	ld	s4,16(sp)
    80002afc:	6aa2                	ld	s5,8(sp)
    80002afe:	6b02                	ld	s6,0(sp)
    80002b00:	6121                	addi	sp,sp,64
    80002b02:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b04:	04000613          	li	a2,64
    80002b08:	4581                	li	a1,0
    80002b0a:	854e                	mv	a0,s3
    80002b0c:	ffffd097          	auipc	ra,0xffffd
    80002b10:	6a6080e7          	jalr	1702(ra) # 800001b2 <memset>
      dip->type = type;
    80002b14:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b18:	8526                	mv	a0,s1
    80002b1a:	00001097          	auipc	ra,0x1
    80002b1e:	c66080e7          	jalr	-922(ra) # 80003780 <log_write>
      brelse(bp);
    80002b22:	8526                	mv	a0,s1
    80002b24:	00000097          	auipc	ra,0x0
    80002b28:	a04080e7          	jalr	-1532(ra) # 80002528 <brelse>
      return iget(dev, inum);
    80002b2c:	0009059b          	sext.w	a1,s2
    80002b30:	8556                	mv	a0,s5
    80002b32:	00000097          	auipc	ra,0x0
    80002b36:	da2080e7          	jalr	-606(ra) # 800028d4 <iget>
    80002b3a:	bf5d                	j	80002af0 <ialloc+0x80>

0000000080002b3c <iupdate>:
{
    80002b3c:	1101                	addi	sp,sp,-32
    80002b3e:	ec06                	sd	ra,24(sp)
    80002b40:	e822                	sd	s0,16(sp)
    80002b42:	e426                	sd	s1,8(sp)
    80002b44:	e04a                	sd	s2,0(sp)
    80002b46:	1000                	addi	s0,sp,32
    80002b48:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b4a:	415c                	lw	a5,4(a0)
    80002b4c:	0047d79b          	srliw	a5,a5,0x4
    80002b50:	00014597          	auipc	a1,0x14
    80002b54:	7005a583          	lw	a1,1792(a1) # 80017250 <sb+0x18>
    80002b58:	9dbd                	addw	a1,a1,a5
    80002b5a:	4108                	lw	a0,0(a0)
    80002b5c:	00000097          	auipc	ra,0x0
    80002b60:	89c080e7          	jalr	-1892(ra) # 800023f8 <bread>
    80002b64:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b66:	05850793          	addi	a5,a0,88
    80002b6a:	40d8                	lw	a4,4(s1)
    80002b6c:	8b3d                	andi	a4,a4,15
    80002b6e:	071a                	slli	a4,a4,0x6
    80002b70:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002b72:	04449703          	lh	a4,68(s1)
    80002b76:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002b7a:	04649703          	lh	a4,70(s1)
    80002b7e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002b82:	04849703          	lh	a4,72(s1)
    80002b86:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002b8a:	04a49703          	lh	a4,74(s1)
    80002b8e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002b92:	44f8                	lw	a4,76(s1)
    80002b94:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b96:	03400613          	li	a2,52
    80002b9a:	05048593          	addi	a1,s1,80
    80002b9e:	00c78513          	addi	a0,a5,12
    80002ba2:	ffffd097          	auipc	ra,0xffffd
    80002ba6:	66c080e7          	jalr	1644(ra) # 8000020e <memmove>
  log_write(bp);
    80002baa:	854a                	mv	a0,s2
    80002bac:	00001097          	auipc	ra,0x1
    80002bb0:	bd4080e7          	jalr	-1068(ra) # 80003780 <log_write>
  brelse(bp);
    80002bb4:	854a                	mv	a0,s2
    80002bb6:	00000097          	auipc	ra,0x0
    80002bba:	972080e7          	jalr	-1678(ra) # 80002528 <brelse>
}
    80002bbe:	60e2                	ld	ra,24(sp)
    80002bc0:	6442                	ld	s0,16(sp)
    80002bc2:	64a2                	ld	s1,8(sp)
    80002bc4:	6902                	ld	s2,0(sp)
    80002bc6:	6105                	addi	sp,sp,32
    80002bc8:	8082                	ret

0000000080002bca <idup>:
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	1000                	addi	s0,sp,32
    80002bd4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bd6:	00014517          	auipc	a0,0x14
    80002bda:	68250513          	addi	a0,a0,1666 # 80017258 <itable>
    80002bde:	00003097          	auipc	ra,0x3
    80002be2:	5c0080e7          	jalr	1472(ra) # 8000619e <acquire>
  ip->ref++;
    80002be6:	449c                	lw	a5,8(s1)
    80002be8:	2785                	addiw	a5,a5,1
    80002bea:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bec:	00014517          	auipc	a0,0x14
    80002bf0:	66c50513          	addi	a0,a0,1644 # 80017258 <itable>
    80002bf4:	00003097          	auipc	ra,0x3
    80002bf8:	65e080e7          	jalr	1630(ra) # 80006252 <release>
}
    80002bfc:	8526                	mv	a0,s1
    80002bfe:	60e2                	ld	ra,24(sp)
    80002c00:	6442                	ld	s0,16(sp)
    80002c02:	64a2                	ld	s1,8(sp)
    80002c04:	6105                	addi	sp,sp,32
    80002c06:	8082                	ret

0000000080002c08 <ilock>:
{
    80002c08:	1101                	addi	sp,sp,-32
    80002c0a:	ec06                	sd	ra,24(sp)
    80002c0c:	e822                	sd	s0,16(sp)
    80002c0e:	e426                	sd	s1,8(sp)
    80002c10:	e04a                	sd	s2,0(sp)
    80002c12:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c14:	c115                	beqz	a0,80002c38 <ilock+0x30>
    80002c16:	84aa                	mv	s1,a0
    80002c18:	451c                	lw	a5,8(a0)
    80002c1a:	00f05f63          	blez	a5,80002c38 <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c1e:	0541                	addi	a0,a0,16
    80002c20:	00001097          	auipc	ra,0x1
    80002c24:	c7e080e7          	jalr	-898(ra) # 8000389e <acquiresleep>
  if(ip->valid == 0){
    80002c28:	40bc                	lw	a5,64(s1)
    80002c2a:	cf99                	beqz	a5,80002c48 <ilock+0x40>
}
    80002c2c:	60e2                	ld	ra,24(sp)
    80002c2e:	6442                	ld	s0,16(sp)
    80002c30:	64a2                	ld	s1,8(sp)
    80002c32:	6902                	ld	s2,0(sp)
    80002c34:	6105                	addi	sp,sp,32
    80002c36:	8082                	ret
    panic("ilock");
    80002c38:	00006517          	auipc	a0,0x6
    80002c3c:	b7050513          	addi	a0,a0,-1168 # 800087a8 <syscallNames+0x190>
    80002c40:	00003097          	auipc	ra,0x3
    80002c44:	026080e7          	jalr	38(ra) # 80005c66 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c48:	40dc                	lw	a5,4(s1)
    80002c4a:	0047d79b          	srliw	a5,a5,0x4
    80002c4e:	00014597          	auipc	a1,0x14
    80002c52:	6025a583          	lw	a1,1538(a1) # 80017250 <sb+0x18>
    80002c56:	9dbd                	addw	a1,a1,a5
    80002c58:	4088                	lw	a0,0(s1)
    80002c5a:	fffff097          	auipc	ra,0xfffff
    80002c5e:	79e080e7          	jalr	1950(ra) # 800023f8 <bread>
    80002c62:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c64:	05850593          	addi	a1,a0,88
    80002c68:	40dc                	lw	a5,4(s1)
    80002c6a:	8bbd                	andi	a5,a5,15
    80002c6c:	079a                	slli	a5,a5,0x6
    80002c6e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c70:	00059783          	lh	a5,0(a1)
    80002c74:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c78:	00259783          	lh	a5,2(a1)
    80002c7c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c80:	00459783          	lh	a5,4(a1)
    80002c84:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c88:	00659783          	lh	a5,6(a1)
    80002c8c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c90:	459c                	lw	a5,8(a1)
    80002c92:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c94:	03400613          	li	a2,52
    80002c98:	05b1                	addi	a1,a1,12
    80002c9a:	05048513          	addi	a0,s1,80
    80002c9e:	ffffd097          	auipc	ra,0xffffd
    80002ca2:	570080e7          	jalr	1392(ra) # 8000020e <memmove>
    brelse(bp);
    80002ca6:	854a                	mv	a0,s2
    80002ca8:	00000097          	auipc	ra,0x0
    80002cac:	880080e7          	jalr	-1920(ra) # 80002528 <brelse>
    ip->valid = 1;
    80002cb0:	4785                	li	a5,1
    80002cb2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cb4:	04449783          	lh	a5,68(s1)
    80002cb8:	fbb5                	bnez	a5,80002c2c <ilock+0x24>
      panic("ilock: no type");
    80002cba:	00006517          	auipc	a0,0x6
    80002cbe:	af650513          	addi	a0,a0,-1290 # 800087b0 <syscallNames+0x198>
    80002cc2:	00003097          	auipc	ra,0x3
    80002cc6:	fa4080e7          	jalr	-92(ra) # 80005c66 <panic>

0000000080002cca <iunlock>:
{
    80002cca:	1101                	addi	sp,sp,-32
    80002ccc:	ec06                	sd	ra,24(sp)
    80002cce:	e822                	sd	s0,16(sp)
    80002cd0:	e426                	sd	s1,8(sp)
    80002cd2:	e04a                	sd	s2,0(sp)
    80002cd4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cd6:	c905                	beqz	a0,80002d06 <iunlock+0x3c>
    80002cd8:	84aa                	mv	s1,a0
    80002cda:	01050913          	addi	s2,a0,16
    80002cde:	854a                	mv	a0,s2
    80002ce0:	00001097          	auipc	ra,0x1
    80002ce4:	c58080e7          	jalr	-936(ra) # 80003938 <holdingsleep>
    80002ce8:	cd19                	beqz	a0,80002d06 <iunlock+0x3c>
    80002cea:	449c                	lw	a5,8(s1)
    80002cec:	00f05d63          	blez	a5,80002d06 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	00001097          	auipc	ra,0x1
    80002cf6:	c02080e7          	jalr	-1022(ra) # 800038f4 <releasesleep>
}
    80002cfa:	60e2                	ld	ra,24(sp)
    80002cfc:	6442                	ld	s0,16(sp)
    80002cfe:	64a2                	ld	s1,8(sp)
    80002d00:	6902                	ld	s2,0(sp)
    80002d02:	6105                	addi	sp,sp,32
    80002d04:	8082                	ret
    panic("iunlock");
    80002d06:	00006517          	auipc	a0,0x6
    80002d0a:	aba50513          	addi	a0,a0,-1350 # 800087c0 <syscallNames+0x1a8>
    80002d0e:	00003097          	auipc	ra,0x3
    80002d12:	f58080e7          	jalr	-168(ra) # 80005c66 <panic>

0000000080002d16 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d16:	7179                	addi	sp,sp,-48
    80002d18:	f406                	sd	ra,40(sp)
    80002d1a:	f022                	sd	s0,32(sp)
    80002d1c:	ec26                	sd	s1,24(sp)
    80002d1e:	e84a                	sd	s2,16(sp)
    80002d20:	e44e                	sd	s3,8(sp)
    80002d22:	e052                	sd	s4,0(sp)
    80002d24:	1800                	addi	s0,sp,48
    80002d26:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d28:	05050493          	addi	s1,a0,80
    80002d2c:	08050913          	addi	s2,a0,128
    80002d30:	a021                	j	80002d38 <itrunc+0x22>
    80002d32:	0491                	addi	s1,s1,4
    80002d34:	01248d63          	beq	s1,s2,80002d4e <itrunc+0x38>
    if(ip->addrs[i]){
    80002d38:	408c                	lw	a1,0(s1)
    80002d3a:	dde5                	beqz	a1,80002d32 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d3c:	0009a503          	lw	a0,0(s3)
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	8fc080e7          	jalr	-1796(ra) # 8000263c <bfree>
      ip->addrs[i] = 0;
    80002d48:	0004a023          	sw	zero,0(s1)
    80002d4c:	b7dd                	j	80002d32 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d4e:	0809a583          	lw	a1,128(s3)
    80002d52:	e185                	bnez	a1,80002d72 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d54:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d58:	854e                	mv	a0,s3
    80002d5a:	00000097          	auipc	ra,0x0
    80002d5e:	de2080e7          	jalr	-542(ra) # 80002b3c <iupdate>
}
    80002d62:	70a2                	ld	ra,40(sp)
    80002d64:	7402                	ld	s0,32(sp)
    80002d66:	64e2                	ld	s1,24(sp)
    80002d68:	6942                	ld	s2,16(sp)
    80002d6a:	69a2                	ld	s3,8(sp)
    80002d6c:	6a02                	ld	s4,0(sp)
    80002d6e:	6145                	addi	sp,sp,48
    80002d70:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d72:	0009a503          	lw	a0,0(s3)
    80002d76:	fffff097          	auipc	ra,0xfffff
    80002d7a:	682080e7          	jalr	1666(ra) # 800023f8 <bread>
    80002d7e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d80:	05850493          	addi	s1,a0,88
    80002d84:	45850913          	addi	s2,a0,1112
    80002d88:	a021                	j	80002d90 <itrunc+0x7a>
    80002d8a:	0491                	addi	s1,s1,4
    80002d8c:	01248b63          	beq	s1,s2,80002da2 <itrunc+0x8c>
      if(a[j])
    80002d90:	408c                	lw	a1,0(s1)
    80002d92:	dde5                	beqz	a1,80002d8a <itrunc+0x74>
        bfree(ip->dev, a[j]);
    80002d94:	0009a503          	lw	a0,0(s3)
    80002d98:	00000097          	auipc	ra,0x0
    80002d9c:	8a4080e7          	jalr	-1884(ra) # 8000263c <bfree>
    80002da0:	b7ed                	j	80002d8a <itrunc+0x74>
    brelse(bp);
    80002da2:	8552                	mv	a0,s4
    80002da4:	fffff097          	auipc	ra,0xfffff
    80002da8:	784080e7          	jalr	1924(ra) # 80002528 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dac:	0809a583          	lw	a1,128(s3)
    80002db0:	0009a503          	lw	a0,0(s3)
    80002db4:	00000097          	auipc	ra,0x0
    80002db8:	888080e7          	jalr	-1912(ra) # 8000263c <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dbc:	0809a023          	sw	zero,128(s3)
    80002dc0:	bf51                	j	80002d54 <itrunc+0x3e>

0000000080002dc2 <iput>:
{
    80002dc2:	1101                	addi	sp,sp,-32
    80002dc4:	ec06                	sd	ra,24(sp)
    80002dc6:	e822                	sd	s0,16(sp)
    80002dc8:	e426                	sd	s1,8(sp)
    80002dca:	e04a                	sd	s2,0(sp)
    80002dcc:	1000                	addi	s0,sp,32
    80002dce:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dd0:	00014517          	auipc	a0,0x14
    80002dd4:	48850513          	addi	a0,a0,1160 # 80017258 <itable>
    80002dd8:	00003097          	auipc	ra,0x3
    80002ddc:	3c6080e7          	jalr	966(ra) # 8000619e <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de0:	4498                	lw	a4,8(s1)
    80002de2:	4785                	li	a5,1
    80002de4:	02f70363          	beq	a4,a5,80002e0a <iput+0x48>
  ip->ref--;
    80002de8:	449c                	lw	a5,8(s1)
    80002dea:	37fd                	addiw	a5,a5,-1
    80002dec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002dee:	00014517          	auipc	a0,0x14
    80002df2:	46a50513          	addi	a0,a0,1130 # 80017258 <itable>
    80002df6:	00003097          	auipc	ra,0x3
    80002dfa:	45c080e7          	jalr	1116(ra) # 80006252 <release>
}
    80002dfe:	60e2                	ld	ra,24(sp)
    80002e00:	6442                	ld	s0,16(sp)
    80002e02:	64a2                	ld	s1,8(sp)
    80002e04:	6902                	ld	s2,0(sp)
    80002e06:	6105                	addi	sp,sp,32
    80002e08:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e0a:	40bc                	lw	a5,64(s1)
    80002e0c:	dff1                	beqz	a5,80002de8 <iput+0x26>
    80002e0e:	04a49783          	lh	a5,74(s1)
    80002e12:	fbf9                	bnez	a5,80002de8 <iput+0x26>
    acquiresleep(&ip->lock);
    80002e14:	01048913          	addi	s2,s1,16
    80002e18:	854a                	mv	a0,s2
    80002e1a:	00001097          	auipc	ra,0x1
    80002e1e:	a84080e7          	jalr	-1404(ra) # 8000389e <acquiresleep>
    release(&itable.lock);
    80002e22:	00014517          	auipc	a0,0x14
    80002e26:	43650513          	addi	a0,a0,1078 # 80017258 <itable>
    80002e2a:	00003097          	auipc	ra,0x3
    80002e2e:	428080e7          	jalr	1064(ra) # 80006252 <release>
    itrunc(ip);
    80002e32:	8526                	mv	a0,s1
    80002e34:	00000097          	auipc	ra,0x0
    80002e38:	ee2080e7          	jalr	-286(ra) # 80002d16 <itrunc>
    ip->type = 0;
    80002e3c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e40:	8526                	mv	a0,s1
    80002e42:	00000097          	auipc	ra,0x0
    80002e46:	cfa080e7          	jalr	-774(ra) # 80002b3c <iupdate>
    ip->valid = 0;
    80002e4a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e4e:	854a                	mv	a0,s2
    80002e50:	00001097          	auipc	ra,0x1
    80002e54:	aa4080e7          	jalr	-1372(ra) # 800038f4 <releasesleep>
    acquire(&itable.lock);
    80002e58:	00014517          	auipc	a0,0x14
    80002e5c:	40050513          	addi	a0,a0,1024 # 80017258 <itable>
    80002e60:	00003097          	auipc	ra,0x3
    80002e64:	33e080e7          	jalr	830(ra) # 8000619e <acquire>
    80002e68:	b741                	j	80002de8 <iput+0x26>

0000000080002e6a <iunlockput>:
{
    80002e6a:	1101                	addi	sp,sp,-32
    80002e6c:	ec06                	sd	ra,24(sp)
    80002e6e:	e822                	sd	s0,16(sp)
    80002e70:	e426                	sd	s1,8(sp)
    80002e72:	1000                	addi	s0,sp,32
    80002e74:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e76:	00000097          	auipc	ra,0x0
    80002e7a:	e54080e7          	jalr	-428(ra) # 80002cca <iunlock>
  iput(ip);
    80002e7e:	8526                	mv	a0,s1
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	f42080e7          	jalr	-190(ra) # 80002dc2 <iput>
}
    80002e88:	60e2                	ld	ra,24(sp)
    80002e8a:	6442                	ld	s0,16(sp)
    80002e8c:	64a2                	ld	s1,8(sp)
    80002e8e:	6105                	addi	sp,sp,32
    80002e90:	8082                	ret

0000000080002e92 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e92:	1141                	addi	sp,sp,-16
    80002e94:	e422                	sd	s0,8(sp)
    80002e96:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e98:	411c                	lw	a5,0(a0)
    80002e9a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002e9c:	415c                	lw	a5,4(a0)
    80002e9e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ea0:	04451783          	lh	a5,68(a0)
    80002ea4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ea8:	04a51783          	lh	a5,74(a0)
    80002eac:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eb0:	04c56783          	lwu	a5,76(a0)
    80002eb4:	e99c                	sd	a5,16(a1)
}
    80002eb6:	6422                	ld	s0,8(sp)
    80002eb8:	0141                	addi	sp,sp,16
    80002eba:	8082                	ret

0000000080002ebc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ebc:	457c                	lw	a5,76(a0)
    80002ebe:	0ed7e963          	bltu	a5,a3,80002fb0 <readi+0xf4>
{
    80002ec2:	7159                	addi	sp,sp,-112
    80002ec4:	f486                	sd	ra,104(sp)
    80002ec6:	f0a2                	sd	s0,96(sp)
    80002ec8:	eca6                	sd	s1,88(sp)
    80002eca:	e8ca                	sd	s2,80(sp)
    80002ecc:	e4ce                	sd	s3,72(sp)
    80002ece:	e0d2                	sd	s4,64(sp)
    80002ed0:	fc56                	sd	s5,56(sp)
    80002ed2:	f85a                	sd	s6,48(sp)
    80002ed4:	f45e                	sd	s7,40(sp)
    80002ed6:	f062                	sd	s8,32(sp)
    80002ed8:	ec66                	sd	s9,24(sp)
    80002eda:	e86a                	sd	s10,16(sp)
    80002edc:	e46e                	sd	s11,8(sp)
    80002ede:	1880                	addi	s0,sp,112
    80002ee0:	8b2a                	mv	s6,a0
    80002ee2:	8bae                	mv	s7,a1
    80002ee4:	8a32                	mv	s4,a2
    80002ee6:	84b6                	mv	s1,a3
    80002ee8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002eea:	9f35                	addw	a4,a4,a3
    return 0;
    80002eec:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002eee:	0ad76063          	bltu	a4,a3,80002f8e <readi+0xd2>
  if(off + n > ip->size)
    80002ef2:	00e7f463          	bgeu	a5,a4,80002efa <readi+0x3e>
    n = ip->size - off;
    80002ef6:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002efa:	0a0a8963          	beqz	s5,80002fac <readi+0xf0>
    80002efe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f00:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f04:	5c7d                	li	s8,-1
    80002f06:	a82d                	j	80002f40 <readi+0x84>
    80002f08:	020d1d93          	slli	s11,s10,0x20
    80002f0c:	020ddd93          	srli	s11,s11,0x20
    80002f10:	05890613          	addi	a2,s2,88
    80002f14:	86ee                	mv	a3,s11
    80002f16:	963a                	add	a2,a2,a4
    80002f18:	85d2                	mv	a1,s4
    80002f1a:	855e                	mv	a0,s7
    80002f1c:	fffff097          	auipc	ra,0xfffff
    80002f20:	a26080e7          	jalr	-1498(ra) # 80001942 <either_copyout>
    80002f24:	05850d63          	beq	a0,s8,80002f7e <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f28:	854a                	mv	a0,s2
    80002f2a:	fffff097          	auipc	ra,0xfffff
    80002f2e:	5fe080e7          	jalr	1534(ra) # 80002528 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f32:	013d09bb          	addw	s3,s10,s3
    80002f36:	009d04bb          	addw	s1,s10,s1
    80002f3a:	9a6e                	add	s4,s4,s11
    80002f3c:	0559f763          	bgeu	s3,s5,80002f8a <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f40:	00a4d59b          	srliw	a1,s1,0xa
    80002f44:	855a                	mv	a0,s6
    80002f46:	00000097          	auipc	ra,0x0
    80002f4a:	8a4080e7          	jalr	-1884(ra) # 800027ea <bmap>
    80002f4e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f52:	cd85                	beqz	a1,80002f8a <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f54:	000b2503          	lw	a0,0(s6)
    80002f58:	fffff097          	auipc	ra,0xfffff
    80002f5c:	4a0080e7          	jalr	1184(ra) # 800023f8 <bread>
    80002f60:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f62:	3ff4f713          	andi	a4,s1,1023
    80002f66:	40ec87bb          	subw	a5,s9,a4
    80002f6a:	413a86bb          	subw	a3,s5,s3
    80002f6e:	8d3e                	mv	s10,a5
    80002f70:	2781                	sext.w	a5,a5
    80002f72:	0006861b          	sext.w	a2,a3
    80002f76:	f8f679e3          	bgeu	a2,a5,80002f08 <readi+0x4c>
    80002f7a:	8d36                	mv	s10,a3
    80002f7c:	b771                	j	80002f08 <readi+0x4c>
      brelse(bp);
    80002f7e:	854a                	mv	a0,s2
    80002f80:	fffff097          	auipc	ra,0xfffff
    80002f84:	5a8080e7          	jalr	1448(ra) # 80002528 <brelse>
      tot = -1;
    80002f88:	59fd                	li	s3,-1
  }
  return tot;
    80002f8a:	0009851b          	sext.w	a0,s3
}
    80002f8e:	70a6                	ld	ra,104(sp)
    80002f90:	7406                	ld	s0,96(sp)
    80002f92:	64e6                	ld	s1,88(sp)
    80002f94:	6946                	ld	s2,80(sp)
    80002f96:	69a6                	ld	s3,72(sp)
    80002f98:	6a06                	ld	s4,64(sp)
    80002f9a:	7ae2                	ld	s5,56(sp)
    80002f9c:	7b42                	ld	s6,48(sp)
    80002f9e:	7ba2                	ld	s7,40(sp)
    80002fa0:	7c02                	ld	s8,32(sp)
    80002fa2:	6ce2                	ld	s9,24(sp)
    80002fa4:	6d42                	ld	s10,16(sp)
    80002fa6:	6da2                	ld	s11,8(sp)
    80002fa8:	6165                	addi	sp,sp,112
    80002faa:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fac:	89d6                	mv	s3,s5
    80002fae:	bff1                	j	80002f8a <readi+0xce>
    return 0;
    80002fb0:	4501                	li	a0,0
}
    80002fb2:	8082                	ret

0000000080002fb4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fb4:	457c                	lw	a5,76(a0)
    80002fb6:	10d7e863          	bltu	a5,a3,800030c6 <writei+0x112>
{
    80002fba:	7159                	addi	sp,sp,-112
    80002fbc:	f486                	sd	ra,104(sp)
    80002fbe:	f0a2                	sd	s0,96(sp)
    80002fc0:	eca6                	sd	s1,88(sp)
    80002fc2:	e8ca                	sd	s2,80(sp)
    80002fc4:	e4ce                	sd	s3,72(sp)
    80002fc6:	e0d2                	sd	s4,64(sp)
    80002fc8:	fc56                	sd	s5,56(sp)
    80002fca:	f85a                	sd	s6,48(sp)
    80002fcc:	f45e                	sd	s7,40(sp)
    80002fce:	f062                	sd	s8,32(sp)
    80002fd0:	ec66                	sd	s9,24(sp)
    80002fd2:	e86a                	sd	s10,16(sp)
    80002fd4:	e46e                	sd	s11,8(sp)
    80002fd6:	1880                	addi	s0,sp,112
    80002fd8:	8aaa                	mv	s5,a0
    80002fda:	8bae                	mv	s7,a1
    80002fdc:	8a32                	mv	s4,a2
    80002fde:	8936                	mv	s2,a3
    80002fe0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fe2:	00e687bb          	addw	a5,a3,a4
    80002fe6:	0ed7e263          	bltu	a5,a3,800030ca <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fea:	00043737          	lui	a4,0x43
    80002fee:	0ef76063          	bltu	a4,a5,800030ce <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff2:	0c0b0863          	beqz	s6,800030c2 <writei+0x10e>
    80002ff6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ff8:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ffc:	5c7d                	li	s8,-1
    80002ffe:	a091                	j	80003042 <writei+0x8e>
    80003000:	020d1d93          	slli	s11,s10,0x20
    80003004:	020ddd93          	srli	s11,s11,0x20
    80003008:	05848513          	addi	a0,s1,88
    8000300c:	86ee                	mv	a3,s11
    8000300e:	8652                	mv	a2,s4
    80003010:	85de                	mv	a1,s7
    80003012:	953a                	add	a0,a0,a4
    80003014:	fffff097          	auipc	ra,0xfffff
    80003018:	984080e7          	jalr	-1660(ra) # 80001998 <either_copyin>
    8000301c:	07850263          	beq	a0,s8,80003080 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003020:	8526                	mv	a0,s1
    80003022:	00000097          	auipc	ra,0x0
    80003026:	75e080e7          	jalr	1886(ra) # 80003780 <log_write>
    brelse(bp);
    8000302a:	8526                	mv	a0,s1
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	4fc080e7          	jalr	1276(ra) # 80002528 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003034:	013d09bb          	addw	s3,s10,s3
    80003038:	012d093b          	addw	s2,s10,s2
    8000303c:	9a6e                	add	s4,s4,s11
    8000303e:	0569f663          	bgeu	s3,s6,8000308a <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003042:	00a9559b          	srliw	a1,s2,0xa
    80003046:	8556                	mv	a0,s5
    80003048:	fffff097          	auipc	ra,0xfffff
    8000304c:	7a2080e7          	jalr	1954(ra) # 800027ea <bmap>
    80003050:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003054:	c99d                	beqz	a1,8000308a <writei+0xd6>
    bp = bread(ip->dev, addr);
    80003056:	000aa503          	lw	a0,0(s5)
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	39e080e7          	jalr	926(ra) # 800023f8 <bread>
    80003062:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	3ff97713          	andi	a4,s2,1023
    80003068:	40ec87bb          	subw	a5,s9,a4
    8000306c:	413b06bb          	subw	a3,s6,s3
    80003070:	8d3e                	mv	s10,a5
    80003072:	2781                	sext.w	a5,a5
    80003074:	0006861b          	sext.w	a2,a3
    80003078:	f8f674e3          	bgeu	a2,a5,80003000 <writei+0x4c>
    8000307c:	8d36                	mv	s10,a3
    8000307e:	b749                	j	80003000 <writei+0x4c>
      brelse(bp);
    80003080:	8526                	mv	a0,s1
    80003082:	fffff097          	auipc	ra,0xfffff
    80003086:	4a6080e7          	jalr	1190(ra) # 80002528 <brelse>
  }

  if(off > ip->size)
    8000308a:	04caa783          	lw	a5,76(s5)
    8000308e:	0127f463          	bgeu	a5,s2,80003096 <writei+0xe2>
    ip->size = off;
    80003092:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003096:	8556                	mv	a0,s5
    80003098:	00000097          	auipc	ra,0x0
    8000309c:	aa4080e7          	jalr	-1372(ra) # 80002b3c <iupdate>

  return tot;
    800030a0:	0009851b          	sext.w	a0,s3
}
    800030a4:	70a6                	ld	ra,104(sp)
    800030a6:	7406                	ld	s0,96(sp)
    800030a8:	64e6                	ld	s1,88(sp)
    800030aa:	6946                	ld	s2,80(sp)
    800030ac:	69a6                	ld	s3,72(sp)
    800030ae:	6a06                	ld	s4,64(sp)
    800030b0:	7ae2                	ld	s5,56(sp)
    800030b2:	7b42                	ld	s6,48(sp)
    800030b4:	7ba2                	ld	s7,40(sp)
    800030b6:	7c02                	ld	s8,32(sp)
    800030b8:	6ce2                	ld	s9,24(sp)
    800030ba:	6d42                	ld	s10,16(sp)
    800030bc:	6da2                	ld	s11,8(sp)
    800030be:	6165                	addi	sp,sp,112
    800030c0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c2:	89da                	mv	s3,s6
    800030c4:	bfc9                	j	80003096 <writei+0xe2>
    return -1;
    800030c6:	557d                	li	a0,-1
}
    800030c8:	8082                	ret
    return -1;
    800030ca:	557d                	li	a0,-1
    800030cc:	bfe1                	j	800030a4 <writei+0xf0>
    return -1;
    800030ce:	557d                	li	a0,-1
    800030d0:	bfd1                	j	800030a4 <writei+0xf0>

00000000800030d2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030d2:	1141                	addi	sp,sp,-16
    800030d4:	e406                	sd	ra,8(sp)
    800030d6:	e022                	sd	s0,0(sp)
    800030d8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030da:	4639                	li	a2,14
    800030dc:	ffffd097          	auipc	ra,0xffffd
    800030e0:	1a6080e7          	jalr	422(ra) # 80000282 <strncmp>
}
    800030e4:	60a2                	ld	ra,8(sp)
    800030e6:	6402                	ld	s0,0(sp)
    800030e8:	0141                	addi	sp,sp,16
    800030ea:	8082                	ret

00000000800030ec <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ec:	7139                	addi	sp,sp,-64
    800030ee:	fc06                	sd	ra,56(sp)
    800030f0:	f822                	sd	s0,48(sp)
    800030f2:	f426                	sd	s1,40(sp)
    800030f4:	f04a                	sd	s2,32(sp)
    800030f6:	ec4e                	sd	s3,24(sp)
    800030f8:	e852                	sd	s4,16(sp)
    800030fa:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800030fc:	04451703          	lh	a4,68(a0)
    80003100:	4785                	li	a5,1
    80003102:	00f71a63          	bne	a4,a5,80003116 <dirlookup+0x2a>
    80003106:	892a                	mv	s2,a0
    80003108:	89ae                	mv	s3,a1
    8000310a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000310c:	457c                	lw	a5,76(a0)
    8000310e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003110:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003112:	e79d                	bnez	a5,80003140 <dirlookup+0x54>
    80003114:	a8a5                	j	8000318c <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003116:	00005517          	auipc	a0,0x5
    8000311a:	6b250513          	addi	a0,a0,1714 # 800087c8 <syscallNames+0x1b0>
    8000311e:	00003097          	auipc	ra,0x3
    80003122:	b48080e7          	jalr	-1208(ra) # 80005c66 <panic>
      panic("dirlookup read");
    80003126:	00005517          	auipc	a0,0x5
    8000312a:	6ba50513          	addi	a0,a0,1722 # 800087e0 <syscallNames+0x1c8>
    8000312e:	00003097          	auipc	ra,0x3
    80003132:	b38080e7          	jalr	-1224(ra) # 80005c66 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003136:	24c1                	addiw	s1,s1,16
    80003138:	04c92783          	lw	a5,76(s2)
    8000313c:	04f4f763          	bgeu	s1,a5,8000318a <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003140:	4741                	li	a4,16
    80003142:	86a6                	mv	a3,s1
    80003144:	fc040613          	addi	a2,s0,-64
    80003148:	4581                	li	a1,0
    8000314a:	854a                	mv	a0,s2
    8000314c:	00000097          	auipc	ra,0x0
    80003150:	d70080e7          	jalr	-656(ra) # 80002ebc <readi>
    80003154:	47c1                	li	a5,16
    80003156:	fcf518e3          	bne	a0,a5,80003126 <dirlookup+0x3a>
    if(de.inum == 0)
    8000315a:	fc045783          	lhu	a5,-64(s0)
    8000315e:	dfe1                	beqz	a5,80003136 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003160:	fc240593          	addi	a1,s0,-62
    80003164:	854e                	mv	a0,s3
    80003166:	00000097          	auipc	ra,0x0
    8000316a:	f6c080e7          	jalr	-148(ra) # 800030d2 <namecmp>
    8000316e:	f561                	bnez	a0,80003136 <dirlookup+0x4a>
      if(poff)
    80003170:	000a0463          	beqz	s4,80003178 <dirlookup+0x8c>
        *poff = off;
    80003174:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003178:	fc045583          	lhu	a1,-64(s0)
    8000317c:	00092503          	lw	a0,0(s2)
    80003180:	fffff097          	auipc	ra,0xfffff
    80003184:	754080e7          	jalr	1876(ra) # 800028d4 <iget>
    80003188:	a011                	j	8000318c <dirlookup+0xa0>
  return 0;
    8000318a:	4501                	li	a0,0
}
    8000318c:	70e2                	ld	ra,56(sp)
    8000318e:	7442                	ld	s0,48(sp)
    80003190:	74a2                	ld	s1,40(sp)
    80003192:	7902                	ld	s2,32(sp)
    80003194:	69e2                	ld	s3,24(sp)
    80003196:	6a42                	ld	s4,16(sp)
    80003198:	6121                	addi	sp,sp,64
    8000319a:	8082                	ret

000000008000319c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000319c:	711d                	addi	sp,sp,-96
    8000319e:	ec86                	sd	ra,88(sp)
    800031a0:	e8a2                	sd	s0,80(sp)
    800031a2:	e4a6                	sd	s1,72(sp)
    800031a4:	e0ca                	sd	s2,64(sp)
    800031a6:	fc4e                	sd	s3,56(sp)
    800031a8:	f852                	sd	s4,48(sp)
    800031aa:	f456                	sd	s5,40(sp)
    800031ac:	f05a                	sd	s6,32(sp)
    800031ae:	ec5e                	sd	s7,24(sp)
    800031b0:	e862                	sd	s8,16(sp)
    800031b2:	e466                	sd	s9,8(sp)
    800031b4:	1080                	addi	s0,sp,96
    800031b6:	84aa                	mv	s1,a0
    800031b8:	8b2e                	mv	s6,a1
    800031ba:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031bc:	00054703          	lbu	a4,0(a0)
    800031c0:	02f00793          	li	a5,47
    800031c4:	02f70263          	beq	a4,a5,800031e8 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031c8:	ffffe097          	auipc	ra,0xffffe
    800031cc:	cc2080e7          	jalr	-830(ra) # 80000e8a <myproc>
    800031d0:	15053503          	ld	a0,336(a0)
    800031d4:	00000097          	auipc	ra,0x0
    800031d8:	9f6080e7          	jalr	-1546(ra) # 80002bca <idup>
    800031dc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800031de:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800031e2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031e4:	4b85                	li	s7,1
    800031e6:	a875                	j	800032a2 <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    800031e8:	4585                	li	a1,1
    800031ea:	4505                	li	a0,1
    800031ec:	fffff097          	auipc	ra,0xfffff
    800031f0:	6e8080e7          	jalr	1768(ra) # 800028d4 <iget>
    800031f4:	8a2a                	mv	s4,a0
    800031f6:	b7e5                	j	800031de <namex+0x42>
      iunlockput(ip);
    800031f8:	8552                	mv	a0,s4
    800031fa:	00000097          	auipc	ra,0x0
    800031fe:	c70080e7          	jalr	-912(ra) # 80002e6a <iunlockput>
      return 0;
    80003202:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003204:	8552                	mv	a0,s4
    80003206:	60e6                	ld	ra,88(sp)
    80003208:	6446                	ld	s0,80(sp)
    8000320a:	64a6                	ld	s1,72(sp)
    8000320c:	6906                	ld	s2,64(sp)
    8000320e:	79e2                	ld	s3,56(sp)
    80003210:	7a42                	ld	s4,48(sp)
    80003212:	7aa2                	ld	s5,40(sp)
    80003214:	7b02                	ld	s6,32(sp)
    80003216:	6be2                	ld	s7,24(sp)
    80003218:	6c42                	ld	s8,16(sp)
    8000321a:	6ca2                	ld	s9,8(sp)
    8000321c:	6125                	addi	sp,sp,96
    8000321e:	8082                	ret
      iunlock(ip);
    80003220:	8552                	mv	a0,s4
    80003222:	00000097          	auipc	ra,0x0
    80003226:	aa8080e7          	jalr	-1368(ra) # 80002cca <iunlock>
      return ip;
    8000322a:	bfe9                	j	80003204 <namex+0x68>
      iunlockput(ip);
    8000322c:	8552                	mv	a0,s4
    8000322e:	00000097          	auipc	ra,0x0
    80003232:	c3c080e7          	jalr	-964(ra) # 80002e6a <iunlockput>
      return 0;
    80003236:	8a4e                	mv	s4,s3
    80003238:	b7f1                	j	80003204 <namex+0x68>
  len = path - s;
    8000323a:	40998633          	sub	a2,s3,s1
    8000323e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003242:	099c5863          	bge	s8,s9,800032d2 <namex+0x136>
    memmove(name, s, DIRSIZ);
    80003246:	4639                	li	a2,14
    80003248:	85a6                	mv	a1,s1
    8000324a:	8556                	mv	a0,s5
    8000324c:	ffffd097          	auipc	ra,0xffffd
    80003250:	fc2080e7          	jalr	-62(ra) # 8000020e <memmove>
    80003254:	84ce                	mv	s1,s3
  while(*path == '/')
    80003256:	0004c783          	lbu	a5,0(s1)
    8000325a:	01279763          	bne	a5,s2,80003268 <namex+0xcc>
    path++;
    8000325e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003260:	0004c783          	lbu	a5,0(s1)
    80003264:	ff278de3          	beq	a5,s2,8000325e <namex+0xc2>
    ilock(ip);
    80003268:	8552                	mv	a0,s4
    8000326a:	00000097          	auipc	ra,0x0
    8000326e:	99e080e7          	jalr	-1634(ra) # 80002c08 <ilock>
    if(ip->type != T_DIR){
    80003272:	044a1783          	lh	a5,68(s4)
    80003276:	f97791e3          	bne	a5,s7,800031f8 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    8000327a:	000b0563          	beqz	s6,80003284 <namex+0xe8>
    8000327e:	0004c783          	lbu	a5,0(s1)
    80003282:	dfd9                	beqz	a5,80003220 <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003284:	4601                	li	a2,0
    80003286:	85d6                	mv	a1,s5
    80003288:	8552                	mv	a0,s4
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	e62080e7          	jalr	-414(ra) # 800030ec <dirlookup>
    80003292:	89aa                	mv	s3,a0
    80003294:	dd41                	beqz	a0,8000322c <namex+0x90>
    iunlockput(ip);
    80003296:	8552                	mv	a0,s4
    80003298:	00000097          	auipc	ra,0x0
    8000329c:	bd2080e7          	jalr	-1070(ra) # 80002e6a <iunlockput>
    ip = next;
    800032a0:	8a4e                	mv	s4,s3
  while(*path == '/')
    800032a2:	0004c783          	lbu	a5,0(s1)
    800032a6:	01279763          	bne	a5,s2,800032b4 <namex+0x118>
    path++;
    800032aa:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ac:	0004c783          	lbu	a5,0(s1)
    800032b0:	ff278de3          	beq	a5,s2,800032aa <namex+0x10e>
  if(*path == 0)
    800032b4:	cb9d                	beqz	a5,800032ea <namex+0x14e>
  while(*path != '/' && *path != 0)
    800032b6:	0004c783          	lbu	a5,0(s1)
    800032ba:	89a6                	mv	s3,s1
  len = path - s;
    800032bc:	4c81                	li	s9,0
    800032be:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800032c0:	01278963          	beq	a5,s2,800032d2 <namex+0x136>
    800032c4:	dbbd                	beqz	a5,8000323a <namex+0x9e>
    path++;
    800032c6:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800032c8:	0009c783          	lbu	a5,0(s3)
    800032cc:	ff279ce3          	bne	a5,s2,800032c4 <namex+0x128>
    800032d0:	b7ad                	j	8000323a <namex+0x9e>
    memmove(name, s, len);
    800032d2:	2601                	sext.w	a2,a2
    800032d4:	85a6                	mv	a1,s1
    800032d6:	8556                	mv	a0,s5
    800032d8:	ffffd097          	auipc	ra,0xffffd
    800032dc:	f36080e7          	jalr	-202(ra) # 8000020e <memmove>
    name[len] = 0;
    800032e0:	9cd6                	add	s9,s9,s5
    800032e2:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800032e6:	84ce                	mv	s1,s3
    800032e8:	b7bd                	j	80003256 <namex+0xba>
  if(nameiparent){
    800032ea:	f00b0de3          	beqz	s6,80003204 <namex+0x68>
    iput(ip);
    800032ee:	8552                	mv	a0,s4
    800032f0:	00000097          	auipc	ra,0x0
    800032f4:	ad2080e7          	jalr	-1326(ra) # 80002dc2 <iput>
    return 0;
    800032f8:	4a01                	li	s4,0
    800032fa:	b729                	j	80003204 <namex+0x68>

00000000800032fc <dirlink>:
{
    800032fc:	7139                	addi	sp,sp,-64
    800032fe:	fc06                	sd	ra,56(sp)
    80003300:	f822                	sd	s0,48(sp)
    80003302:	f426                	sd	s1,40(sp)
    80003304:	f04a                	sd	s2,32(sp)
    80003306:	ec4e                	sd	s3,24(sp)
    80003308:	e852                	sd	s4,16(sp)
    8000330a:	0080                	addi	s0,sp,64
    8000330c:	892a                	mv	s2,a0
    8000330e:	8a2e                	mv	s4,a1
    80003310:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003312:	4601                	li	a2,0
    80003314:	00000097          	auipc	ra,0x0
    80003318:	dd8080e7          	jalr	-552(ra) # 800030ec <dirlookup>
    8000331c:	e93d                	bnez	a0,80003392 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000331e:	04c92483          	lw	s1,76(s2)
    80003322:	c49d                	beqz	s1,80003350 <dirlink+0x54>
    80003324:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003326:	4741                	li	a4,16
    80003328:	86a6                	mv	a3,s1
    8000332a:	fc040613          	addi	a2,s0,-64
    8000332e:	4581                	li	a1,0
    80003330:	854a                	mv	a0,s2
    80003332:	00000097          	auipc	ra,0x0
    80003336:	b8a080e7          	jalr	-1142(ra) # 80002ebc <readi>
    8000333a:	47c1                	li	a5,16
    8000333c:	06f51163          	bne	a0,a5,8000339e <dirlink+0xa2>
    if(de.inum == 0)
    80003340:	fc045783          	lhu	a5,-64(s0)
    80003344:	c791                	beqz	a5,80003350 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003346:	24c1                	addiw	s1,s1,16
    80003348:	04c92783          	lw	a5,76(s2)
    8000334c:	fcf4ede3          	bltu	s1,a5,80003326 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003350:	4639                	li	a2,14
    80003352:	85d2                	mv	a1,s4
    80003354:	fc240513          	addi	a0,s0,-62
    80003358:	ffffd097          	auipc	ra,0xffffd
    8000335c:	f66080e7          	jalr	-154(ra) # 800002be <strncpy>
  de.inum = inum;
    80003360:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003364:	4741                	li	a4,16
    80003366:	86a6                	mv	a3,s1
    80003368:	fc040613          	addi	a2,s0,-64
    8000336c:	4581                	li	a1,0
    8000336e:	854a                	mv	a0,s2
    80003370:	00000097          	auipc	ra,0x0
    80003374:	c44080e7          	jalr	-956(ra) # 80002fb4 <writei>
    80003378:	1541                	addi	a0,a0,-16
    8000337a:	00a03533          	snez	a0,a0
    8000337e:	40a00533          	neg	a0,a0
}
    80003382:	70e2                	ld	ra,56(sp)
    80003384:	7442                	ld	s0,48(sp)
    80003386:	74a2                	ld	s1,40(sp)
    80003388:	7902                	ld	s2,32(sp)
    8000338a:	69e2                	ld	s3,24(sp)
    8000338c:	6a42                	ld	s4,16(sp)
    8000338e:	6121                	addi	sp,sp,64
    80003390:	8082                	ret
    iput(ip);
    80003392:	00000097          	auipc	ra,0x0
    80003396:	a30080e7          	jalr	-1488(ra) # 80002dc2 <iput>
    return -1;
    8000339a:	557d                	li	a0,-1
    8000339c:	b7dd                	j	80003382 <dirlink+0x86>
      panic("dirlink read");
    8000339e:	00005517          	auipc	a0,0x5
    800033a2:	45250513          	addi	a0,a0,1106 # 800087f0 <syscallNames+0x1d8>
    800033a6:	00003097          	auipc	ra,0x3
    800033aa:	8c0080e7          	jalr	-1856(ra) # 80005c66 <panic>

00000000800033ae <namei>:

struct inode*
namei(char *path)
{
    800033ae:	1101                	addi	sp,sp,-32
    800033b0:	ec06                	sd	ra,24(sp)
    800033b2:	e822                	sd	s0,16(sp)
    800033b4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033b6:	fe040613          	addi	a2,s0,-32
    800033ba:	4581                	li	a1,0
    800033bc:	00000097          	auipc	ra,0x0
    800033c0:	de0080e7          	jalr	-544(ra) # 8000319c <namex>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033cc:	1141                	addi	sp,sp,-16
    800033ce:	e406                	sd	ra,8(sp)
    800033d0:	e022                	sd	s0,0(sp)
    800033d2:	0800                	addi	s0,sp,16
    800033d4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033d6:	4585                	li	a1,1
    800033d8:	00000097          	auipc	ra,0x0
    800033dc:	dc4080e7          	jalr	-572(ra) # 8000319c <namex>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	e04a                	sd	s2,0(sp)
    800033f2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033f4:	00016917          	auipc	s2,0x16
    800033f8:	90c90913          	addi	s2,s2,-1780 # 80018d00 <log>
    800033fc:	01892583          	lw	a1,24(s2)
    80003400:	02892503          	lw	a0,40(s2)
    80003404:	fffff097          	auipc	ra,0xfffff
    80003408:	ff4080e7          	jalr	-12(ra) # 800023f8 <bread>
    8000340c:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000340e:	02c92603          	lw	a2,44(s2)
    80003412:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003414:	00c05f63          	blez	a2,80003432 <write_head+0x4a>
    80003418:	00016717          	auipc	a4,0x16
    8000341c:	91870713          	addi	a4,a4,-1768 # 80018d30 <log+0x30>
    80003420:	87aa                	mv	a5,a0
    80003422:	060a                	slli	a2,a2,0x2
    80003424:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003426:	4314                	lw	a3,0(a4)
    80003428:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000342a:	0711                	addi	a4,a4,4
    8000342c:	0791                	addi	a5,a5,4
    8000342e:	fec79ce3          	bne	a5,a2,80003426 <write_head+0x3e>
  }
  bwrite(buf);
    80003432:	8526                	mv	a0,s1
    80003434:	fffff097          	auipc	ra,0xfffff
    80003438:	0b6080e7          	jalr	182(ra) # 800024ea <bwrite>
  brelse(buf);
    8000343c:	8526                	mv	a0,s1
    8000343e:	fffff097          	auipc	ra,0xfffff
    80003442:	0ea080e7          	jalr	234(ra) # 80002528 <brelse>
}
    80003446:	60e2                	ld	ra,24(sp)
    80003448:	6442                	ld	s0,16(sp)
    8000344a:	64a2                	ld	s1,8(sp)
    8000344c:	6902                	ld	s2,0(sp)
    8000344e:	6105                	addi	sp,sp,32
    80003450:	8082                	ret

0000000080003452 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003452:	00016797          	auipc	a5,0x16
    80003456:	8da7a783          	lw	a5,-1830(a5) # 80018d2c <log+0x2c>
    8000345a:	0af05d63          	blez	a5,80003514 <install_trans+0xc2>
{
    8000345e:	7139                	addi	sp,sp,-64
    80003460:	fc06                	sd	ra,56(sp)
    80003462:	f822                	sd	s0,48(sp)
    80003464:	f426                	sd	s1,40(sp)
    80003466:	f04a                	sd	s2,32(sp)
    80003468:	ec4e                	sd	s3,24(sp)
    8000346a:	e852                	sd	s4,16(sp)
    8000346c:	e456                	sd	s5,8(sp)
    8000346e:	e05a                	sd	s6,0(sp)
    80003470:	0080                	addi	s0,sp,64
    80003472:	8b2a                	mv	s6,a0
    80003474:	00016a97          	auipc	s5,0x16
    80003478:	8bca8a93          	addi	s5,s5,-1860 # 80018d30 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347c:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000347e:	00016997          	auipc	s3,0x16
    80003482:	88298993          	addi	s3,s3,-1918 # 80018d00 <log>
    80003486:	a00d                	j	800034a8 <install_trans+0x56>
    brelse(lbuf);
    80003488:	854a                	mv	a0,s2
    8000348a:	fffff097          	auipc	ra,0xfffff
    8000348e:	09e080e7          	jalr	158(ra) # 80002528 <brelse>
    brelse(dbuf);
    80003492:	8526                	mv	a0,s1
    80003494:	fffff097          	auipc	ra,0xfffff
    80003498:	094080e7          	jalr	148(ra) # 80002528 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349c:	2a05                	addiw	s4,s4,1
    8000349e:	0a91                	addi	s5,s5,4
    800034a0:	02c9a783          	lw	a5,44(s3)
    800034a4:	04fa5e63          	bge	s4,a5,80003500 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a8:	0189a583          	lw	a1,24(s3)
    800034ac:	014585bb          	addw	a1,a1,s4
    800034b0:	2585                	addiw	a1,a1,1
    800034b2:	0289a503          	lw	a0,40(s3)
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	f42080e7          	jalr	-190(ra) # 800023f8 <bread>
    800034be:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c0:	000aa583          	lw	a1,0(s5)
    800034c4:	0289a503          	lw	a0,40(s3)
    800034c8:	fffff097          	auipc	ra,0xfffff
    800034cc:	f30080e7          	jalr	-208(ra) # 800023f8 <bread>
    800034d0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d2:	40000613          	li	a2,1024
    800034d6:	05890593          	addi	a1,s2,88
    800034da:	05850513          	addi	a0,a0,88
    800034de:	ffffd097          	auipc	ra,0xffffd
    800034e2:	d30080e7          	jalr	-720(ra) # 8000020e <memmove>
    bwrite(dbuf);  // write dst to disk
    800034e6:	8526                	mv	a0,s1
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	002080e7          	jalr	2(ra) # 800024ea <bwrite>
    if(recovering == 0)
    800034f0:	f80b1ce3          	bnez	s6,80003488 <install_trans+0x36>
      bunpin(dbuf);
    800034f4:	8526                	mv	a0,s1
    800034f6:	fffff097          	auipc	ra,0xfffff
    800034fa:	10a080e7          	jalr	266(ra) # 80002600 <bunpin>
    800034fe:	b769                	j	80003488 <install_trans+0x36>
}
    80003500:	70e2                	ld	ra,56(sp)
    80003502:	7442                	ld	s0,48(sp)
    80003504:	74a2                	ld	s1,40(sp)
    80003506:	7902                	ld	s2,32(sp)
    80003508:	69e2                	ld	s3,24(sp)
    8000350a:	6a42                	ld	s4,16(sp)
    8000350c:	6aa2                	ld	s5,8(sp)
    8000350e:	6b02                	ld	s6,0(sp)
    80003510:	6121                	addi	sp,sp,64
    80003512:	8082                	ret
    80003514:	8082                	ret

0000000080003516 <initlog>:
{
    80003516:	7179                	addi	sp,sp,-48
    80003518:	f406                	sd	ra,40(sp)
    8000351a:	f022                	sd	s0,32(sp)
    8000351c:	ec26                	sd	s1,24(sp)
    8000351e:	e84a                	sd	s2,16(sp)
    80003520:	e44e                	sd	s3,8(sp)
    80003522:	1800                	addi	s0,sp,48
    80003524:	892a                	mv	s2,a0
    80003526:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003528:	00015497          	auipc	s1,0x15
    8000352c:	7d848493          	addi	s1,s1,2008 # 80018d00 <log>
    80003530:	00005597          	auipc	a1,0x5
    80003534:	2d058593          	addi	a1,a1,720 # 80008800 <syscallNames+0x1e8>
    80003538:	8526                	mv	a0,s1
    8000353a:	00003097          	auipc	ra,0x3
    8000353e:	bd4080e7          	jalr	-1068(ra) # 8000610e <initlock>
  log.start = sb->logstart;
    80003542:	0149a583          	lw	a1,20(s3)
    80003546:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003548:	0109a783          	lw	a5,16(s3)
    8000354c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000354e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003552:	854a                	mv	a0,s2
    80003554:	fffff097          	auipc	ra,0xfffff
    80003558:	ea4080e7          	jalr	-348(ra) # 800023f8 <bread>
  log.lh.n = lh->n;
    8000355c:	4d30                	lw	a2,88(a0)
    8000355e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003560:	00c05f63          	blez	a2,8000357e <initlog+0x68>
    80003564:	87aa                	mv	a5,a0
    80003566:	00015717          	auipc	a4,0x15
    8000356a:	7ca70713          	addi	a4,a4,1994 # 80018d30 <log+0x30>
    8000356e:	060a                	slli	a2,a2,0x2
    80003570:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003572:	4ff4                	lw	a3,92(a5)
    80003574:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003576:	0791                	addi	a5,a5,4
    80003578:	0711                	addi	a4,a4,4
    8000357a:	fec79ce3          	bne	a5,a2,80003572 <initlog+0x5c>
  brelse(buf);
    8000357e:	fffff097          	auipc	ra,0xfffff
    80003582:	faa080e7          	jalr	-86(ra) # 80002528 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003586:	4505                	li	a0,1
    80003588:	00000097          	auipc	ra,0x0
    8000358c:	eca080e7          	jalr	-310(ra) # 80003452 <install_trans>
  log.lh.n = 0;
    80003590:	00015797          	auipc	a5,0x15
    80003594:	7807ae23          	sw	zero,1948(a5) # 80018d2c <log+0x2c>
  write_head(); // clear the log
    80003598:	00000097          	auipc	ra,0x0
    8000359c:	e50080e7          	jalr	-432(ra) # 800033e8 <write_head>
}
    800035a0:	70a2                	ld	ra,40(sp)
    800035a2:	7402                	ld	s0,32(sp)
    800035a4:	64e2                	ld	s1,24(sp)
    800035a6:	6942                	ld	s2,16(sp)
    800035a8:	69a2                	ld	s3,8(sp)
    800035aa:	6145                	addi	sp,sp,48
    800035ac:	8082                	ret

00000000800035ae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ae:	1101                	addi	sp,sp,-32
    800035b0:	ec06                	sd	ra,24(sp)
    800035b2:	e822                	sd	s0,16(sp)
    800035b4:	e426                	sd	s1,8(sp)
    800035b6:	e04a                	sd	s2,0(sp)
    800035b8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ba:	00015517          	auipc	a0,0x15
    800035be:	74650513          	addi	a0,a0,1862 # 80018d00 <log>
    800035c2:	00003097          	auipc	ra,0x3
    800035c6:	bdc080e7          	jalr	-1060(ra) # 8000619e <acquire>
  while(1){
    if(log.committing){
    800035ca:	00015497          	auipc	s1,0x15
    800035ce:	73648493          	addi	s1,s1,1846 # 80018d00 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d2:	4979                	li	s2,30
    800035d4:	a039                	j	800035e2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035d6:	85a6                	mv	a1,s1
    800035d8:	8526                	mv	a0,s1
    800035da:	ffffe097          	auipc	ra,0xffffe
    800035de:	f60080e7          	jalr	-160(ra) # 8000153a <sleep>
    if(log.committing){
    800035e2:	50dc                	lw	a5,36(s1)
    800035e4:	fbed                	bnez	a5,800035d6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035e6:	5098                	lw	a4,32(s1)
    800035e8:	2705                	addiw	a4,a4,1
    800035ea:	0027179b          	slliw	a5,a4,0x2
    800035ee:	9fb9                	addw	a5,a5,a4
    800035f0:	0017979b          	slliw	a5,a5,0x1
    800035f4:	54d4                	lw	a3,44(s1)
    800035f6:	9fb5                	addw	a5,a5,a3
    800035f8:	00f95963          	bge	s2,a5,8000360a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035fc:	85a6                	mv	a1,s1
    800035fe:	8526                	mv	a0,s1
    80003600:	ffffe097          	auipc	ra,0xffffe
    80003604:	f3a080e7          	jalr	-198(ra) # 8000153a <sleep>
    80003608:	bfe9                	j	800035e2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000360a:	00015517          	auipc	a0,0x15
    8000360e:	6f650513          	addi	a0,a0,1782 # 80018d00 <log>
    80003612:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003614:	00003097          	auipc	ra,0x3
    80003618:	c3e080e7          	jalr	-962(ra) # 80006252 <release>
      break;
    }
  }
}
    8000361c:	60e2                	ld	ra,24(sp)
    8000361e:	6442                	ld	s0,16(sp)
    80003620:	64a2                	ld	s1,8(sp)
    80003622:	6902                	ld	s2,0(sp)
    80003624:	6105                	addi	sp,sp,32
    80003626:	8082                	ret

0000000080003628 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003628:	7139                	addi	sp,sp,-64
    8000362a:	fc06                	sd	ra,56(sp)
    8000362c:	f822                	sd	s0,48(sp)
    8000362e:	f426                	sd	s1,40(sp)
    80003630:	f04a                	sd	s2,32(sp)
    80003632:	ec4e                	sd	s3,24(sp)
    80003634:	e852                	sd	s4,16(sp)
    80003636:	e456                	sd	s5,8(sp)
    80003638:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000363a:	00015497          	auipc	s1,0x15
    8000363e:	6c648493          	addi	s1,s1,1734 # 80018d00 <log>
    80003642:	8526                	mv	a0,s1
    80003644:	00003097          	auipc	ra,0x3
    80003648:	b5a080e7          	jalr	-1190(ra) # 8000619e <acquire>
  log.outstanding -= 1;
    8000364c:	509c                	lw	a5,32(s1)
    8000364e:	37fd                	addiw	a5,a5,-1
    80003650:	0007891b          	sext.w	s2,a5
    80003654:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003656:	50dc                	lw	a5,36(s1)
    80003658:	e7b9                	bnez	a5,800036a6 <end_op+0x7e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000365a:	04091e63          	bnez	s2,800036b6 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    8000365e:	00015497          	auipc	s1,0x15
    80003662:	6a248493          	addi	s1,s1,1698 # 80018d00 <log>
    80003666:	4785                	li	a5,1
    80003668:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000366a:	8526                	mv	a0,s1
    8000366c:	00003097          	auipc	ra,0x3
    80003670:	be6080e7          	jalr	-1050(ra) # 80006252 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003674:	54dc                	lw	a5,44(s1)
    80003676:	06f04763          	bgtz	a5,800036e4 <end_op+0xbc>
    acquire(&log.lock);
    8000367a:	00015497          	auipc	s1,0x15
    8000367e:	68648493          	addi	s1,s1,1670 # 80018d00 <log>
    80003682:	8526                	mv	a0,s1
    80003684:	00003097          	auipc	ra,0x3
    80003688:	b1a080e7          	jalr	-1254(ra) # 8000619e <acquire>
    log.committing = 0;
    8000368c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003690:	8526                	mv	a0,s1
    80003692:	ffffe097          	auipc	ra,0xffffe
    80003696:	f0c080e7          	jalr	-244(ra) # 8000159e <wakeup>
    release(&log.lock);
    8000369a:	8526                	mv	a0,s1
    8000369c:	00003097          	auipc	ra,0x3
    800036a0:	bb6080e7          	jalr	-1098(ra) # 80006252 <release>
}
    800036a4:	a03d                	j	800036d2 <end_op+0xaa>
    panic("log.committing");
    800036a6:	00005517          	auipc	a0,0x5
    800036aa:	16250513          	addi	a0,a0,354 # 80008808 <syscallNames+0x1f0>
    800036ae:	00002097          	auipc	ra,0x2
    800036b2:	5b8080e7          	jalr	1464(ra) # 80005c66 <panic>
    wakeup(&log);
    800036b6:	00015497          	auipc	s1,0x15
    800036ba:	64a48493          	addi	s1,s1,1610 # 80018d00 <log>
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	ede080e7          	jalr	-290(ra) # 8000159e <wakeup>
  release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	b88080e7          	jalr	-1144(ra) # 80006252 <release>
}
    800036d2:	70e2                	ld	ra,56(sp)
    800036d4:	7442                	ld	s0,48(sp)
    800036d6:	74a2                	ld	s1,40(sp)
    800036d8:	7902                	ld	s2,32(sp)
    800036da:	69e2                	ld	s3,24(sp)
    800036dc:	6a42                	ld	s4,16(sp)
    800036de:	6aa2                	ld	s5,8(sp)
    800036e0:	6121                	addi	sp,sp,64
    800036e2:	8082                	ret
  for (tail = 0; tail < log.lh.n; tail++) {
    800036e4:	00015a97          	auipc	s5,0x15
    800036e8:	64ca8a93          	addi	s5,s5,1612 # 80018d30 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036ec:	00015a17          	auipc	s4,0x15
    800036f0:	614a0a13          	addi	s4,s4,1556 # 80018d00 <log>
    800036f4:	018a2583          	lw	a1,24(s4)
    800036f8:	012585bb          	addw	a1,a1,s2
    800036fc:	2585                	addiw	a1,a1,1
    800036fe:	028a2503          	lw	a0,40(s4)
    80003702:	fffff097          	auipc	ra,0xfffff
    80003706:	cf6080e7          	jalr	-778(ra) # 800023f8 <bread>
    8000370a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000370c:	000aa583          	lw	a1,0(s5)
    80003710:	028a2503          	lw	a0,40(s4)
    80003714:	fffff097          	auipc	ra,0xfffff
    80003718:	ce4080e7          	jalr	-796(ra) # 800023f8 <bread>
    8000371c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000371e:	40000613          	li	a2,1024
    80003722:	05850593          	addi	a1,a0,88
    80003726:	05848513          	addi	a0,s1,88
    8000372a:	ffffd097          	auipc	ra,0xffffd
    8000372e:	ae4080e7          	jalr	-1308(ra) # 8000020e <memmove>
    bwrite(to);  // write the log
    80003732:	8526                	mv	a0,s1
    80003734:	fffff097          	auipc	ra,0xfffff
    80003738:	db6080e7          	jalr	-586(ra) # 800024ea <bwrite>
    brelse(from);
    8000373c:	854e                	mv	a0,s3
    8000373e:	fffff097          	auipc	ra,0xfffff
    80003742:	dea080e7          	jalr	-534(ra) # 80002528 <brelse>
    brelse(to);
    80003746:	8526                	mv	a0,s1
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	de0080e7          	jalr	-544(ra) # 80002528 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003750:	2905                	addiw	s2,s2,1
    80003752:	0a91                	addi	s5,s5,4
    80003754:	02ca2783          	lw	a5,44(s4)
    80003758:	f8f94ee3          	blt	s2,a5,800036f4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000375c:	00000097          	auipc	ra,0x0
    80003760:	c8c080e7          	jalr	-884(ra) # 800033e8 <write_head>
    install_trans(0); // Now install writes to home locations
    80003764:	4501                	li	a0,0
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	cec080e7          	jalr	-788(ra) # 80003452 <install_trans>
    log.lh.n = 0;
    8000376e:	00015797          	auipc	a5,0x15
    80003772:	5a07af23          	sw	zero,1470(a5) # 80018d2c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003776:	00000097          	auipc	ra,0x0
    8000377a:	c72080e7          	jalr	-910(ra) # 800033e8 <write_head>
    8000377e:	bdf5                	j	8000367a <end_op+0x52>

0000000080003780 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003780:	1101                	addi	sp,sp,-32
    80003782:	ec06                	sd	ra,24(sp)
    80003784:	e822                	sd	s0,16(sp)
    80003786:	e426                	sd	s1,8(sp)
    80003788:	e04a                	sd	s2,0(sp)
    8000378a:	1000                	addi	s0,sp,32
    8000378c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000378e:	00015917          	auipc	s2,0x15
    80003792:	57290913          	addi	s2,s2,1394 # 80018d00 <log>
    80003796:	854a                	mv	a0,s2
    80003798:	00003097          	auipc	ra,0x3
    8000379c:	a06080e7          	jalr	-1530(ra) # 8000619e <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037a0:	02c92603          	lw	a2,44(s2)
    800037a4:	47f5                	li	a5,29
    800037a6:	06c7c563          	blt	a5,a2,80003810 <log_write+0x90>
    800037aa:	00015797          	auipc	a5,0x15
    800037ae:	5727a783          	lw	a5,1394(a5) # 80018d1c <log+0x1c>
    800037b2:	37fd                	addiw	a5,a5,-1
    800037b4:	04f65e63          	bge	a2,a5,80003810 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037b8:	00015797          	auipc	a5,0x15
    800037bc:	5687a783          	lw	a5,1384(a5) # 80018d20 <log+0x20>
    800037c0:	06f05063          	blez	a5,80003820 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037c4:	4781                	li	a5,0
    800037c6:	06c05563          	blez	a2,80003830 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ca:	44cc                	lw	a1,12(s1)
    800037cc:	00015717          	auipc	a4,0x15
    800037d0:	56470713          	addi	a4,a4,1380 # 80018d30 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037d4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d6:	4314                	lw	a3,0(a4)
    800037d8:	04b68c63          	beq	a3,a1,80003830 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037dc:	2785                	addiw	a5,a5,1
    800037de:	0711                	addi	a4,a4,4
    800037e0:	fef61be3          	bne	a2,a5,800037d6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037e4:	0621                	addi	a2,a2,8
    800037e6:	060a                	slli	a2,a2,0x2
    800037e8:	00015797          	auipc	a5,0x15
    800037ec:	51878793          	addi	a5,a5,1304 # 80018d00 <log>
    800037f0:	97b2                	add	a5,a5,a2
    800037f2:	44d8                	lw	a4,12(s1)
    800037f4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037f6:	8526                	mv	a0,s1
    800037f8:	fffff097          	auipc	ra,0xfffff
    800037fc:	dcc080e7          	jalr	-564(ra) # 800025c4 <bpin>
    log.lh.n++;
    80003800:	00015717          	auipc	a4,0x15
    80003804:	50070713          	addi	a4,a4,1280 # 80018d00 <log>
    80003808:	575c                	lw	a5,44(a4)
    8000380a:	2785                	addiw	a5,a5,1
    8000380c:	d75c                	sw	a5,44(a4)
    8000380e:	a82d                	j	80003848 <log_write+0xc8>
    panic("too big a transaction");
    80003810:	00005517          	auipc	a0,0x5
    80003814:	00850513          	addi	a0,a0,8 # 80008818 <syscallNames+0x200>
    80003818:	00002097          	auipc	ra,0x2
    8000381c:	44e080e7          	jalr	1102(ra) # 80005c66 <panic>
    panic("log_write outside of trans");
    80003820:	00005517          	auipc	a0,0x5
    80003824:	01050513          	addi	a0,a0,16 # 80008830 <syscallNames+0x218>
    80003828:	00002097          	auipc	ra,0x2
    8000382c:	43e080e7          	jalr	1086(ra) # 80005c66 <panic>
  log.lh.block[i] = b->blockno;
    80003830:	00878693          	addi	a3,a5,8
    80003834:	068a                	slli	a3,a3,0x2
    80003836:	00015717          	auipc	a4,0x15
    8000383a:	4ca70713          	addi	a4,a4,1226 # 80018d00 <log>
    8000383e:	9736                	add	a4,a4,a3
    80003840:	44d4                	lw	a3,12(s1)
    80003842:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003844:	faf609e3          	beq	a2,a5,800037f6 <log_write+0x76>
  }
  release(&log.lock);
    80003848:	00015517          	auipc	a0,0x15
    8000384c:	4b850513          	addi	a0,a0,1208 # 80018d00 <log>
    80003850:	00003097          	auipc	ra,0x3
    80003854:	a02080e7          	jalr	-1534(ra) # 80006252 <release>
}
    80003858:	60e2                	ld	ra,24(sp)
    8000385a:	6442                	ld	s0,16(sp)
    8000385c:	64a2                	ld	s1,8(sp)
    8000385e:	6902                	ld	s2,0(sp)
    80003860:	6105                	addi	sp,sp,32
    80003862:	8082                	ret

0000000080003864 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003864:	1101                	addi	sp,sp,-32
    80003866:	ec06                	sd	ra,24(sp)
    80003868:	e822                	sd	s0,16(sp)
    8000386a:	e426                	sd	s1,8(sp)
    8000386c:	e04a                	sd	s2,0(sp)
    8000386e:	1000                	addi	s0,sp,32
    80003870:	84aa                	mv	s1,a0
    80003872:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003874:	00005597          	auipc	a1,0x5
    80003878:	fdc58593          	addi	a1,a1,-36 # 80008850 <syscallNames+0x238>
    8000387c:	0521                	addi	a0,a0,8
    8000387e:	00003097          	auipc	ra,0x3
    80003882:	890080e7          	jalr	-1904(ra) # 8000610e <initlock>
  lk->name = name;
    80003886:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000388a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000388e:	0204a423          	sw	zero,40(s1)
}
    80003892:	60e2                	ld	ra,24(sp)
    80003894:	6442                	ld	s0,16(sp)
    80003896:	64a2                	ld	s1,8(sp)
    80003898:	6902                	ld	s2,0(sp)
    8000389a:	6105                	addi	sp,sp,32
    8000389c:	8082                	ret

000000008000389e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000389e:	1101                	addi	sp,sp,-32
    800038a0:	ec06                	sd	ra,24(sp)
    800038a2:	e822                	sd	s0,16(sp)
    800038a4:	e426                	sd	s1,8(sp)
    800038a6:	e04a                	sd	s2,0(sp)
    800038a8:	1000                	addi	s0,sp,32
    800038aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ac:	00850913          	addi	s2,a0,8
    800038b0:	854a                	mv	a0,s2
    800038b2:	00003097          	auipc	ra,0x3
    800038b6:	8ec080e7          	jalr	-1812(ra) # 8000619e <acquire>
  while (lk->locked) {
    800038ba:	409c                	lw	a5,0(s1)
    800038bc:	cb89                	beqz	a5,800038ce <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038be:	85ca                	mv	a1,s2
    800038c0:	8526                	mv	a0,s1
    800038c2:	ffffe097          	auipc	ra,0xffffe
    800038c6:	c78080e7          	jalr	-904(ra) # 8000153a <sleep>
  while (lk->locked) {
    800038ca:	409c                	lw	a5,0(s1)
    800038cc:	fbed                	bnez	a5,800038be <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038ce:	4785                	li	a5,1
    800038d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038d2:	ffffd097          	auipc	ra,0xffffd
    800038d6:	5b8080e7          	jalr	1464(ra) # 80000e8a <myproc>
    800038da:	591c                	lw	a5,48(a0)
    800038dc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038de:	854a                	mv	a0,s2
    800038e0:	00003097          	auipc	ra,0x3
    800038e4:	972080e7          	jalr	-1678(ra) # 80006252 <release>
}
    800038e8:	60e2                	ld	ra,24(sp)
    800038ea:	6442                	ld	s0,16(sp)
    800038ec:	64a2                	ld	s1,8(sp)
    800038ee:	6902                	ld	s2,0(sp)
    800038f0:	6105                	addi	sp,sp,32
    800038f2:	8082                	ret

00000000800038f4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038f4:	1101                	addi	sp,sp,-32
    800038f6:	ec06                	sd	ra,24(sp)
    800038f8:	e822                	sd	s0,16(sp)
    800038fa:	e426                	sd	s1,8(sp)
    800038fc:	e04a                	sd	s2,0(sp)
    800038fe:	1000                	addi	s0,sp,32
    80003900:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003902:	00850913          	addi	s2,a0,8
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	896080e7          	jalr	-1898(ra) # 8000619e <acquire>
  lk->locked = 0;
    80003910:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003914:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003918:	8526                	mv	a0,s1
    8000391a:	ffffe097          	auipc	ra,0xffffe
    8000391e:	c84080e7          	jalr	-892(ra) # 8000159e <wakeup>
  release(&lk->lk);
    80003922:	854a                	mv	a0,s2
    80003924:	00003097          	auipc	ra,0x3
    80003928:	92e080e7          	jalr	-1746(ra) # 80006252 <release>
}
    8000392c:	60e2                	ld	ra,24(sp)
    8000392e:	6442                	ld	s0,16(sp)
    80003930:	64a2                	ld	s1,8(sp)
    80003932:	6902                	ld	s2,0(sp)
    80003934:	6105                	addi	sp,sp,32
    80003936:	8082                	ret

0000000080003938 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003938:	7179                	addi	sp,sp,-48
    8000393a:	f406                	sd	ra,40(sp)
    8000393c:	f022                	sd	s0,32(sp)
    8000393e:	ec26                	sd	s1,24(sp)
    80003940:	e84a                	sd	s2,16(sp)
    80003942:	e44e                	sd	s3,8(sp)
    80003944:	1800                	addi	s0,sp,48
    80003946:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	850080e7          	jalr	-1968(ra) # 8000619e <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003956:	409c                	lw	a5,0(s1)
    80003958:	ef99                	bnez	a5,80003976 <holdingsleep+0x3e>
    8000395a:	4481                	li	s1,0
  release(&lk->lk);
    8000395c:	854a                	mv	a0,s2
    8000395e:	00003097          	auipc	ra,0x3
    80003962:	8f4080e7          	jalr	-1804(ra) # 80006252 <release>
  return r;
}
    80003966:	8526                	mv	a0,s1
    80003968:	70a2                	ld	ra,40(sp)
    8000396a:	7402                	ld	s0,32(sp)
    8000396c:	64e2                	ld	s1,24(sp)
    8000396e:	6942                	ld	s2,16(sp)
    80003970:	69a2                	ld	s3,8(sp)
    80003972:	6145                	addi	sp,sp,48
    80003974:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003976:	0284a983          	lw	s3,40(s1)
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	510080e7          	jalr	1296(ra) # 80000e8a <myproc>
    80003982:	5904                	lw	s1,48(a0)
    80003984:	413484b3          	sub	s1,s1,s3
    80003988:	0014b493          	seqz	s1,s1
    8000398c:	bfc1                	j	8000395c <holdingsleep+0x24>

000000008000398e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000398e:	1141                	addi	sp,sp,-16
    80003990:	e406                	sd	ra,8(sp)
    80003992:	e022                	sd	s0,0(sp)
    80003994:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003996:	00005597          	auipc	a1,0x5
    8000399a:	eca58593          	addi	a1,a1,-310 # 80008860 <syscallNames+0x248>
    8000399e:	00015517          	auipc	a0,0x15
    800039a2:	4aa50513          	addi	a0,a0,1194 # 80018e48 <ftable>
    800039a6:	00002097          	auipc	ra,0x2
    800039aa:	768080e7          	jalr	1896(ra) # 8000610e <initlock>
}
    800039ae:	60a2                	ld	ra,8(sp)
    800039b0:	6402                	ld	s0,0(sp)
    800039b2:	0141                	addi	sp,sp,16
    800039b4:	8082                	ret

00000000800039b6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039b6:	1101                	addi	sp,sp,-32
    800039b8:	ec06                	sd	ra,24(sp)
    800039ba:	e822                	sd	s0,16(sp)
    800039bc:	e426                	sd	s1,8(sp)
    800039be:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039c0:	00015517          	auipc	a0,0x15
    800039c4:	48850513          	addi	a0,a0,1160 # 80018e48 <ftable>
    800039c8:	00002097          	auipc	ra,0x2
    800039cc:	7d6080e7          	jalr	2006(ra) # 8000619e <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039d0:	00015497          	auipc	s1,0x15
    800039d4:	49048493          	addi	s1,s1,1168 # 80018e60 <ftable+0x18>
    800039d8:	00016717          	auipc	a4,0x16
    800039dc:	42870713          	addi	a4,a4,1064 # 80019e00 <disk>
    if(f->ref == 0){
    800039e0:	40dc                	lw	a5,4(s1)
    800039e2:	cf99                	beqz	a5,80003a00 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039e4:	02848493          	addi	s1,s1,40
    800039e8:	fee49ce3          	bne	s1,a4,800039e0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800039ec:	00015517          	auipc	a0,0x15
    800039f0:	45c50513          	addi	a0,a0,1116 # 80018e48 <ftable>
    800039f4:	00003097          	auipc	ra,0x3
    800039f8:	85e080e7          	jalr	-1954(ra) # 80006252 <release>
  return 0;
    800039fc:	4481                	li	s1,0
    800039fe:	a819                	j	80003a14 <filealloc+0x5e>
      f->ref = 1;
    80003a00:	4785                	li	a5,1
    80003a02:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a04:	00015517          	auipc	a0,0x15
    80003a08:	44450513          	addi	a0,a0,1092 # 80018e48 <ftable>
    80003a0c:	00003097          	auipc	ra,0x3
    80003a10:	846080e7          	jalr	-1978(ra) # 80006252 <release>
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a20:	1101                	addi	sp,sp,-32
    80003a22:	ec06                	sd	ra,24(sp)
    80003a24:	e822                	sd	s0,16(sp)
    80003a26:	e426                	sd	s1,8(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a2c:	00015517          	auipc	a0,0x15
    80003a30:	41c50513          	addi	a0,a0,1052 # 80018e48 <ftable>
    80003a34:	00002097          	auipc	ra,0x2
    80003a38:	76a080e7          	jalr	1898(ra) # 8000619e <acquire>
  if(f->ref < 1)
    80003a3c:	40dc                	lw	a5,4(s1)
    80003a3e:	02f05263          	blez	a5,80003a62 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a42:	2785                	addiw	a5,a5,1
    80003a44:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a46:	00015517          	auipc	a0,0x15
    80003a4a:	40250513          	addi	a0,a0,1026 # 80018e48 <ftable>
    80003a4e:	00003097          	auipc	ra,0x3
    80003a52:	804080e7          	jalr	-2044(ra) # 80006252 <release>
  return f;
}
    80003a56:	8526                	mv	a0,s1
    80003a58:	60e2                	ld	ra,24(sp)
    80003a5a:	6442                	ld	s0,16(sp)
    80003a5c:	64a2                	ld	s1,8(sp)
    80003a5e:	6105                	addi	sp,sp,32
    80003a60:	8082                	ret
    panic("filedup");
    80003a62:	00005517          	auipc	a0,0x5
    80003a66:	e0650513          	addi	a0,a0,-506 # 80008868 <syscallNames+0x250>
    80003a6a:	00002097          	auipc	ra,0x2
    80003a6e:	1fc080e7          	jalr	508(ra) # 80005c66 <panic>

0000000080003a72 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a72:	7139                	addi	sp,sp,-64
    80003a74:	fc06                	sd	ra,56(sp)
    80003a76:	f822                	sd	s0,48(sp)
    80003a78:	f426                	sd	s1,40(sp)
    80003a7a:	f04a                	sd	s2,32(sp)
    80003a7c:	ec4e                	sd	s3,24(sp)
    80003a7e:	e852                	sd	s4,16(sp)
    80003a80:	e456                	sd	s5,8(sp)
    80003a82:	0080                	addi	s0,sp,64
    80003a84:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a86:	00015517          	auipc	a0,0x15
    80003a8a:	3c250513          	addi	a0,a0,962 # 80018e48 <ftable>
    80003a8e:	00002097          	auipc	ra,0x2
    80003a92:	710080e7          	jalr	1808(ra) # 8000619e <acquire>
  if(f->ref < 1)
    80003a96:	40dc                	lw	a5,4(s1)
    80003a98:	06f05163          	blez	a5,80003afa <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003a9c:	37fd                	addiw	a5,a5,-1
    80003a9e:	0007871b          	sext.w	a4,a5
    80003aa2:	c0dc                	sw	a5,4(s1)
    80003aa4:	06e04363          	bgtz	a4,80003b0a <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003aa8:	0004a903          	lw	s2,0(s1)
    80003aac:	0094ca83          	lbu	s5,9(s1)
    80003ab0:	0104ba03          	ld	s4,16(s1)
    80003ab4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ab8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003abc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ac0:	00015517          	auipc	a0,0x15
    80003ac4:	38850513          	addi	a0,a0,904 # 80018e48 <ftable>
    80003ac8:	00002097          	auipc	ra,0x2
    80003acc:	78a080e7          	jalr	1930(ra) # 80006252 <release>

  if(ff.type == FD_PIPE){
    80003ad0:	4785                	li	a5,1
    80003ad2:	04f90d63          	beq	s2,a5,80003b2c <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ad6:	3979                	addiw	s2,s2,-2
    80003ad8:	4785                	li	a5,1
    80003ada:	0527e063          	bltu	a5,s2,80003b1a <fileclose+0xa8>
    begin_op();
    80003ade:	00000097          	auipc	ra,0x0
    80003ae2:	ad0080e7          	jalr	-1328(ra) # 800035ae <begin_op>
    iput(ff.ip);
    80003ae6:	854e                	mv	a0,s3
    80003ae8:	fffff097          	auipc	ra,0xfffff
    80003aec:	2da080e7          	jalr	730(ra) # 80002dc2 <iput>
    end_op();
    80003af0:	00000097          	auipc	ra,0x0
    80003af4:	b38080e7          	jalr	-1224(ra) # 80003628 <end_op>
    80003af8:	a00d                	j	80003b1a <fileclose+0xa8>
    panic("fileclose");
    80003afa:	00005517          	auipc	a0,0x5
    80003afe:	d7650513          	addi	a0,a0,-650 # 80008870 <syscallNames+0x258>
    80003b02:	00002097          	auipc	ra,0x2
    80003b06:	164080e7          	jalr	356(ra) # 80005c66 <panic>
    release(&ftable.lock);
    80003b0a:	00015517          	auipc	a0,0x15
    80003b0e:	33e50513          	addi	a0,a0,830 # 80018e48 <ftable>
    80003b12:	00002097          	auipc	ra,0x2
    80003b16:	740080e7          	jalr	1856(ra) # 80006252 <release>
  }
}
    80003b1a:	70e2                	ld	ra,56(sp)
    80003b1c:	7442                	ld	s0,48(sp)
    80003b1e:	74a2                	ld	s1,40(sp)
    80003b20:	7902                	ld	s2,32(sp)
    80003b22:	69e2                	ld	s3,24(sp)
    80003b24:	6a42                	ld	s4,16(sp)
    80003b26:	6aa2                	ld	s5,8(sp)
    80003b28:	6121                	addi	sp,sp,64
    80003b2a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b2c:	85d6                	mv	a1,s5
    80003b2e:	8552                	mv	a0,s4
    80003b30:	00000097          	auipc	ra,0x0
    80003b34:	348080e7          	jalr	840(ra) # 80003e78 <pipeclose>
    80003b38:	b7cd                	j	80003b1a <fileclose+0xa8>

0000000080003b3a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b3a:	715d                	addi	sp,sp,-80
    80003b3c:	e486                	sd	ra,72(sp)
    80003b3e:	e0a2                	sd	s0,64(sp)
    80003b40:	fc26                	sd	s1,56(sp)
    80003b42:	f84a                	sd	s2,48(sp)
    80003b44:	f44e                	sd	s3,40(sp)
    80003b46:	0880                	addi	s0,sp,80
    80003b48:	84aa                	mv	s1,a0
    80003b4a:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	33e080e7          	jalr	830(ra) # 80000e8a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b54:	409c                	lw	a5,0(s1)
    80003b56:	37f9                	addiw	a5,a5,-2
    80003b58:	4705                	li	a4,1
    80003b5a:	04f76763          	bltu	a4,a5,80003ba8 <filestat+0x6e>
    80003b5e:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	0a6080e7          	jalr	166(ra) # 80002c08 <ilock>
    stati(f->ip, &st);
    80003b6a:	fb840593          	addi	a1,s0,-72
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	322080e7          	jalr	802(ra) # 80002e92 <stati>
    iunlock(f->ip);
    80003b78:	6c88                	ld	a0,24(s1)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	150080e7          	jalr	336(ra) # 80002cca <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b82:	46e1                	li	a3,24
    80003b84:	fb840613          	addi	a2,s0,-72
    80003b88:	85ce                	mv	a1,s3
    80003b8a:	05093503          	ld	a0,80(s2)
    80003b8e:	ffffd097          	auipc	ra,0xffffd
    80003b92:	fbc080e7          	jalr	-68(ra) # 80000b4a <copyout>
    80003b96:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003b9a:	60a6                	ld	ra,72(sp)
    80003b9c:	6406                	ld	s0,64(sp)
    80003b9e:	74e2                	ld	s1,56(sp)
    80003ba0:	7942                	ld	s2,48(sp)
    80003ba2:	79a2                	ld	s3,40(sp)
    80003ba4:	6161                	addi	sp,sp,80
    80003ba6:	8082                	ret
  return -1;
    80003ba8:	557d                	li	a0,-1
    80003baa:	bfc5                	j	80003b9a <filestat+0x60>

0000000080003bac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bac:	7179                	addi	sp,sp,-48
    80003bae:	f406                	sd	ra,40(sp)
    80003bb0:	f022                	sd	s0,32(sp)
    80003bb2:	ec26                	sd	s1,24(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	e44e                	sd	s3,8(sp)
    80003bb8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bba:	00854783          	lbu	a5,8(a0)
    80003bbe:	c3d5                	beqz	a5,80003c62 <fileread+0xb6>
    80003bc0:	84aa                	mv	s1,a0
    80003bc2:	89ae                	mv	s3,a1
    80003bc4:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc6:	411c                	lw	a5,0(a0)
    80003bc8:	4705                	li	a4,1
    80003bca:	04e78963          	beq	a5,a4,80003c1c <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bce:	470d                	li	a4,3
    80003bd0:	04e78d63          	beq	a5,a4,80003c2a <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd4:	4709                	li	a4,2
    80003bd6:	06e79e63          	bne	a5,a4,80003c52 <fileread+0xa6>
    ilock(f->ip);
    80003bda:	6d08                	ld	a0,24(a0)
    80003bdc:	fffff097          	auipc	ra,0xfffff
    80003be0:	02c080e7          	jalr	44(ra) # 80002c08 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be4:	874a                	mv	a4,s2
    80003be6:	5094                	lw	a3,32(s1)
    80003be8:	864e                	mv	a2,s3
    80003bea:	4585                	li	a1,1
    80003bec:	6c88                	ld	a0,24(s1)
    80003bee:	fffff097          	auipc	ra,0xfffff
    80003bf2:	2ce080e7          	jalr	718(ra) # 80002ebc <readi>
    80003bf6:	892a                	mv	s2,a0
    80003bf8:	00a05563          	blez	a0,80003c02 <fileread+0x56>
      f->off += r;
    80003bfc:	509c                	lw	a5,32(s1)
    80003bfe:	9fa9                	addw	a5,a5,a0
    80003c00:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c02:	6c88                	ld	a0,24(s1)
    80003c04:	fffff097          	auipc	ra,0xfffff
    80003c08:	0c6080e7          	jalr	198(ra) # 80002cca <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c0c:	854a                	mv	a0,s2
    80003c0e:	70a2                	ld	ra,40(sp)
    80003c10:	7402                	ld	s0,32(sp)
    80003c12:	64e2                	ld	s1,24(sp)
    80003c14:	6942                	ld	s2,16(sp)
    80003c16:	69a2                	ld	s3,8(sp)
    80003c18:	6145                	addi	sp,sp,48
    80003c1a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c1c:	6908                	ld	a0,16(a0)
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	3c2080e7          	jalr	962(ra) # 80003fe0 <piperead>
    80003c26:	892a                	mv	s2,a0
    80003c28:	b7d5                	j	80003c0c <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c2a:	02451783          	lh	a5,36(a0)
    80003c2e:	03079693          	slli	a3,a5,0x30
    80003c32:	92c1                	srli	a3,a3,0x30
    80003c34:	4725                	li	a4,9
    80003c36:	02d76863          	bltu	a4,a3,80003c66 <fileread+0xba>
    80003c3a:	0792                	slli	a5,a5,0x4
    80003c3c:	00015717          	auipc	a4,0x15
    80003c40:	16c70713          	addi	a4,a4,364 # 80018da8 <devsw>
    80003c44:	97ba                	add	a5,a5,a4
    80003c46:	639c                	ld	a5,0(a5)
    80003c48:	c38d                	beqz	a5,80003c6a <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003c4a:	4505                	li	a0,1
    80003c4c:	9782                	jalr	a5
    80003c4e:	892a                	mv	s2,a0
    80003c50:	bf75                	j	80003c0c <fileread+0x60>
    panic("fileread");
    80003c52:	00005517          	auipc	a0,0x5
    80003c56:	c2e50513          	addi	a0,a0,-978 # 80008880 <syscallNames+0x268>
    80003c5a:	00002097          	auipc	ra,0x2
    80003c5e:	00c080e7          	jalr	12(ra) # 80005c66 <panic>
    return -1;
    80003c62:	597d                	li	s2,-1
    80003c64:	b765                	j	80003c0c <fileread+0x60>
      return -1;
    80003c66:	597d                	li	s2,-1
    80003c68:	b755                	j	80003c0c <fileread+0x60>
    80003c6a:	597d                	li	s2,-1
    80003c6c:	b745                	j	80003c0c <fileread+0x60>

0000000080003c6e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c6e:	00954783          	lbu	a5,9(a0)
    80003c72:	10078e63          	beqz	a5,80003d8e <filewrite+0x120>
{
    80003c76:	715d                	addi	sp,sp,-80
    80003c78:	e486                	sd	ra,72(sp)
    80003c7a:	e0a2                	sd	s0,64(sp)
    80003c7c:	fc26                	sd	s1,56(sp)
    80003c7e:	f84a                	sd	s2,48(sp)
    80003c80:	f44e                	sd	s3,40(sp)
    80003c82:	f052                	sd	s4,32(sp)
    80003c84:	ec56                	sd	s5,24(sp)
    80003c86:	e85a                	sd	s6,16(sp)
    80003c88:	e45e                	sd	s7,8(sp)
    80003c8a:	e062                	sd	s8,0(sp)
    80003c8c:	0880                	addi	s0,sp,80
    80003c8e:	892a                	mv	s2,a0
    80003c90:	8b2e                	mv	s6,a1
    80003c92:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c94:	411c                	lw	a5,0(a0)
    80003c96:	4705                	li	a4,1
    80003c98:	02e78263          	beq	a5,a4,80003cbc <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c9c:	470d                	li	a4,3
    80003c9e:	02e78563          	beq	a5,a4,80003cc8 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003ca2:	4709                	li	a4,2
    80003ca4:	0ce79d63          	bne	a5,a4,80003d7e <filewrite+0x110>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca8:	0ac05b63          	blez	a2,80003d5e <filewrite+0xf0>
    int i = 0;
    80003cac:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003cae:	6b85                	lui	s7,0x1
    80003cb0:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cb4:	6c05                	lui	s8,0x1
    80003cb6:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003cba:	a851                	j	80003d4e <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003cbc:	6908                	ld	a0,16(a0)
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	22a080e7          	jalr	554(ra) # 80003ee8 <pipewrite>
    80003cc6:	a045                	j	80003d66 <filewrite+0xf8>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cc8:	02451783          	lh	a5,36(a0)
    80003ccc:	03079693          	slli	a3,a5,0x30
    80003cd0:	92c1                	srli	a3,a3,0x30
    80003cd2:	4725                	li	a4,9
    80003cd4:	0ad76f63          	bltu	a4,a3,80003d92 <filewrite+0x124>
    80003cd8:	0792                	slli	a5,a5,0x4
    80003cda:	00015717          	auipc	a4,0x15
    80003cde:	0ce70713          	addi	a4,a4,206 # 80018da8 <devsw>
    80003ce2:	97ba                	add	a5,a5,a4
    80003ce4:	679c                	ld	a5,8(a5)
    80003ce6:	cbc5                	beqz	a5,80003d96 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003ce8:	4505                	li	a0,1
    80003cea:	9782                	jalr	a5
    80003cec:	a8ad                	j	80003d66 <filewrite+0xf8>
      if(n1 > max)
    80003cee:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003cf2:	00000097          	auipc	ra,0x0
    80003cf6:	8bc080e7          	jalr	-1860(ra) # 800035ae <begin_op>
      ilock(f->ip);
    80003cfa:	01893503          	ld	a0,24(s2)
    80003cfe:	fffff097          	auipc	ra,0xfffff
    80003d02:	f0a080e7          	jalr	-246(ra) # 80002c08 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d06:	8756                	mv	a4,s5
    80003d08:	02092683          	lw	a3,32(s2)
    80003d0c:	01698633          	add	a2,s3,s6
    80003d10:	4585                	li	a1,1
    80003d12:	01893503          	ld	a0,24(s2)
    80003d16:	fffff097          	auipc	ra,0xfffff
    80003d1a:	29e080e7          	jalr	670(ra) # 80002fb4 <writei>
    80003d1e:	84aa                	mv	s1,a0
    80003d20:	00a05763          	blez	a0,80003d2e <filewrite+0xc0>
        f->off += r;
    80003d24:	02092783          	lw	a5,32(s2)
    80003d28:	9fa9                	addw	a5,a5,a0
    80003d2a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d2e:	01893503          	ld	a0,24(s2)
    80003d32:	fffff097          	auipc	ra,0xfffff
    80003d36:	f98080e7          	jalr	-104(ra) # 80002cca <iunlock>
      end_op();
    80003d3a:	00000097          	auipc	ra,0x0
    80003d3e:	8ee080e7          	jalr	-1810(ra) # 80003628 <end_op>

      if(r != n1){
    80003d42:	009a9f63          	bne	s5,s1,80003d60 <filewrite+0xf2>
        // error from writei
        break;
      }
      i += r;
    80003d46:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003d4a:	0149db63          	bge	s3,s4,80003d60 <filewrite+0xf2>
      int n1 = n - i;
    80003d4e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003d52:	0004879b          	sext.w	a5,s1
    80003d56:	f8fbdce3          	bge	s7,a5,80003cee <filewrite+0x80>
    80003d5a:	84e2                	mv	s1,s8
    80003d5c:	bf49                	j	80003cee <filewrite+0x80>
    int i = 0;
    80003d5e:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003d60:	033a1d63          	bne	s4,s3,80003d9a <filewrite+0x12c>
    80003d64:	8552                	mv	a0,s4
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d66:	60a6                	ld	ra,72(sp)
    80003d68:	6406                	ld	s0,64(sp)
    80003d6a:	74e2                	ld	s1,56(sp)
    80003d6c:	7942                	ld	s2,48(sp)
    80003d6e:	79a2                	ld	s3,40(sp)
    80003d70:	7a02                	ld	s4,32(sp)
    80003d72:	6ae2                	ld	s5,24(sp)
    80003d74:	6b42                	ld	s6,16(sp)
    80003d76:	6ba2                	ld	s7,8(sp)
    80003d78:	6c02                	ld	s8,0(sp)
    80003d7a:	6161                	addi	sp,sp,80
    80003d7c:	8082                	ret
    panic("filewrite");
    80003d7e:	00005517          	auipc	a0,0x5
    80003d82:	b1250513          	addi	a0,a0,-1262 # 80008890 <syscallNames+0x278>
    80003d86:	00002097          	auipc	ra,0x2
    80003d8a:	ee0080e7          	jalr	-288(ra) # 80005c66 <panic>
    return -1;
    80003d8e:	557d                	li	a0,-1
}
    80003d90:	8082                	ret
      return -1;
    80003d92:	557d                	li	a0,-1
    80003d94:	bfc9                	j	80003d66 <filewrite+0xf8>
    80003d96:	557d                	li	a0,-1
    80003d98:	b7f9                	j	80003d66 <filewrite+0xf8>
    ret = (i == n ? n : -1);
    80003d9a:	557d                	li	a0,-1
    80003d9c:	b7e9                	j	80003d66 <filewrite+0xf8>

0000000080003d9e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003d9e:	7179                	addi	sp,sp,-48
    80003da0:	f406                	sd	ra,40(sp)
    80003da2:	f022                	sd	s0,32(sp)
    80003da4:	ec26                	sd	s1,24(sp)
    80003da6:	e84a                	sd	s2,16(sp)
    80003da8:	e44e                	sd	s3,8(sp)
    80003daa:	e052                	sd	s4,0(sp)
    80003dac:	1800                	addi	s0,sp,48
    80003dae:	84aa                	mv	s1,a0
    80003db0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db2:	0005b023          	sd	zero,0(a1)
    80003db6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dba:	00000097          	auipc	ra,0x0
    80003dbe:	bfc080e7          	jalr	-1028(ra) # 800039b6 <filealloc>
    80003dc2:	e088                	sd	a0,0(s1)
    80003dc4:	c551                	beqz	a0,80003e50 <pipealloc+0xb2>
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	bf0080e7          	jalr	-1040(ra) # 800039b6 <filealloc>
    80003dce:	00aa3023          	sd	a0,0(s4)
    80003dd2:	c92d                	beqz	a0,80003e44 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd4:	ffffc097          	auipc	ra,0xffffc
    80003dd8:	356080e7          	jalr	854(ra) # 8000012a <kalloc>
    80003ddc:	892a                	mv	s2,a0
    80003dde:	c125                	beqz	a0,80003e3e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003de0:	4985                	li	s3,1
    80003de2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003de6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003dea:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dee:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003df2:	00004597          	auipc	a1,0x4
    80003df6:	61658593          	addi	a1,a1,1558 # 80008408 <states.0+0x1c0>
    80003dfa:	00002097          	auipc	ra,0x2
    80003dfe:	314080e7          	jalr	788(ra) # 8000610e <initlock>
  (*f0)->type = FD_PIPE;
    80003e02:	609c                	ld	a5,0(s1)
    80003e04:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e08:	609c                	ld	a5,0(s1)
    80003e0a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e0e:	609c                	ld	a5,0(s1)
    80003e10:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e14:	609c                	ld	a5,0(s1)
    80003e16:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e1a:	000a3783          	ld	a5,0(s4)
    80003e1e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e22:	000a3783          	ld	a5,0(s4)
    80003e26:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e32:	000a3783          	ld	a5,0(s4)
    80003e36:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e3a:	4501                	li	a0,0
    80003e3c:	a025                	j	80003e64 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e3e:	6088                	ld	a0,0(s1)
    80003e40:	e501                	bnez	a0,80003e48 <pipealloc+0xaa>
    80003e42:	a039                	j	80003e50 <pipealloc+0xb2>
    80003e44:	6088                	ld	a0,0(s1)
    80003e46:	c51d                	beqz	a0,80003e74 <pipealloc+0xd6>
    fileclose(*f0);
    80003e48:	00000097          	auipc	ra,0x0
    80003e4c:	c2a080e7          	jalr	-982(ra) # 80003a72 <fileclose>
  if(*f1)
    80003e50:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e54:	557d                	li	a0,-1
  if(*f1)
    80003e56:	c799                	beqz	a5,80003e64 <pipealloc+0xc6>
    fileclose(*f1);
    80003e58:	853e                	mv	a0,a5
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	c18080e7          	jalr	-1000(ra) # 80003a72 <fileclose>
  return -1;
    80003e62:	557d                	li	a0,-1
}
    80003e64:	70a2                	ld	ra,40(sp)
    80003e66:	7402                	ld	s0,32(sp)
    80003e68:	64e2                	ld	s1,24(sp)
    80003e6a:	6942                	ld	s2,16(sp)
    80003e6c:	69a2                	ld	s3,8(sp)
    80003e6e:	6a02                	ld	s4,0(sp)
    80003e70:	6145                	addi	sp,sp,48
    80003e72:	8082                	ret
  return -1;
    80003e74:	557d                	li	a0,-1
    80003e76:	b7fd                	j	80003e64 <pipealloc+0xc6>

0000000080003e78 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e78:	1101                	addi	sp,sp,-32
    80003e7a:	ec06                	sd	ra,24(sp)
    80003e7c:	e822                	sd	s0,16(sp)
    80003e7e:	e426                	sd	s1,8(sp)
    80003e80:	e04a                	sd	s2,0(sp)
    80003e82:	1000                	addi	s0,sp,32
    80003e84:	84aa                	mv	s1,a0
    80003e86:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e88:	00002097          	auipc	ra,0x2
    80003e8c:	316080e7          	jalr	790(ra) # 8000619e <acquire>
  if(writable){
    80003e90:	02090d63          	beqz	s2,80003eca <pipeclose+0x52>
    pi->writeopen = 0;
    80003e94:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e98:	21848513          	addi	a0,s1,536
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	702080e7          	jalr	1794(ra) # 8000159e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ea4:	2204b783          	ld	a5,544(s1)
    80003ea8:	eb95                	bnez	a5,80003edc <pipeclose+0x64>
    release(&pi->lock);
    80003eaa:	8526                	mv	a0,s1
    80003eac:	00002097          	auipc	ra,0x2
    80003eb0:	3a6080e7          	jalr	934(ra) # 80006252 <release>
    kfree((char*)pi);
    80003eb4:	8526                	mv	a0,s1
    80003eb6:	ffffc097          	auipc	ra,0xffffc
    80003eba:	166080e7          	jalr	358(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003ebe:	60e2                	ld	ra,24(sp)
    80003ec0:	6442                	ld	s0,16(sp)
    80003ec2:	64a2                	ld	s1,8(sp)
    80003ec4:	6902                	ld	s2,0(sp)
    80003ec6:	6105                	addi	sp,sp,32
    80003ec8:	8082                	ret
    pi->readopen = 0;
    80003eca:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ece:	21c48513          	addi	a0,s1,540
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	6cc080e7          	jalr	1740(ra) # 8000159e <wakeup>
    80003eda:	b7e9                	j	80003ea4 <pipeclose+0x2c>
    release(&pi->lock);
    80003edc:	8526                	mv	a0,s1
    80003ede:	00002097          	auipc	ra,0x2
    80003ee2:	374080e7          	jalr	884(ra) # 80006252 <release>
}
    80003ee6:	bfe1                	j	80003ebe <pipeclose+0x46>

0000000080003ee8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ee8:	711d                	addi	sp,sp,-96
    80003eea:	ec86                	sd	ra,88(sp)
    80003eec:	e8a2                	sd	s0,80(sp)
    80003eee:	e4a6                	sd	s1,72(sp)
    80003ef0:	e0ca                	sd	s2,64(sp)
    80003ef2:	fc4e                	sd	s3,56(sp)
    80003ef4:	f852                	sd	s4,48(sp)
    80003ef6:	f456                	sd	s5,40(sp)
    80003ef8:	f05a                	sd	s6,32(sp)
    80003efa:	ec5e                	sd	s7,24(sp)
    80003efc:	e862                	sd	s8,16(sp)
    80003efe:	1080                	addi	s0,sp,96
    80003f00:	84aa                	mv	s1,a0
    80003f02:	8aae                	mv	s5,a1
    80003f04:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f06:	ffffd097          	auipc	ra,0xffffd
    80003f0a:	f84080e7          	jalr	-124(ra) # 80000e8a <myproc>
    80003f0e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f10:	8526                	mv	a0,s1
    80003f12:	00002097          	auipc	ra,0x2
    80003f16:	28c080e7          	jalr	652(ra) # 8000619e <acquire>
  while(i < n){
    80003f1a:	0b405663          	blez	s4,80003fc6 <pipewrite+0xde>
  int i = 0;
    80003f1e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f20:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f22:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f26:	21c48b93          	addi	s7,s1,540
    80003f2a:	a089                	j	80003f6c <pipewrite+0x84>
      release(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	324080e7          	jalr	804(ra) # 80006252 <release>
      return -1;
    80003f36:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f38:	854a                	mv	a0,s2
    80003f3a:	60e6                	ld	ra,88(sp)
    80003f3c:	6446                	ld	s0,80(sp)
    80003f3e:	64a6                	ld	s1,72(sp)
    80003f40:	6906                	ld	s2,64(sp)
    80003f42:	79e2                	ld	s3,56(sp)
    80003f44:	7a42                	ld	s4,48(sp)
    80003f46:	7aa2                	ld	s5,40(sp)
    80003f48:	7b02                	ld	s6,32(sp)
    80003f4a:	6be2                	ld	s7,24(sp)
    80003f4c:	6c42                	ld	s8,16(sp)
    80003f4e:	6125                	addi	sp,sp,96
    80003f50:	8082                	ret
      wakeup(&pi->nread);
    80003f52:	8562                	mv	a0,s8
    80003f54:	ffffd097          	auipc	ra,0xffffd
    80003f58:	64a080e7          	jalr	1610(ra) # 8000159e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f5c:	85a6                	mv	a1,s1
    80003f5e:	855e                	mv	a0,s7
    80003f60:	ffffd097          	auipc	ra,0xffffd
    80003f64:	5da080e7          	jalr	1498(ra) # 8000153a <sleep>
  while(i < n){
    80003f68:	07495063          	bge	s2,s4,80003fc8 <pipewrite+0xe0>
    if(pi->readopen == 0 || killed(pr)){
    80003f6c:	2204a783          	lw	a5,544(s1)
    80003f70:	dfd5                	beqz	a5,80003f2c <pipewrite+0x44>
    80003f72:	854e                	mv	a0,s3
    80003f74:	ffffe097          	auipc	ra,0xffffe
    80003f78:	86e080e7          	jalr	-1938(ra) # 800017e2 <killed>
    80003f7c:	f945                	bnez	a0,80003f2c <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f7e:	2184a783          	lw	a5,536(s1)
    80003f82:	21c4a703          	lw	a4,540(s1)
    80003f86:	2007879b          	addiw	a5,a5,512
    80003f8a:	fcf704e3          	beq	a4,a5,80003f52 <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f8e:	4685                	li	a3,1
    80003f90:	01590633          	add	a2,s2,s5
    80003f94:	faf40593          	addi	a1,s0,-81
    80003f98:	0509b503          	ld	a0,80(s3)
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	c3a080e7          	jalr	-966(ra) # 80000bd6 <copyin>
    80003fa4:	03650263          	beq	a0,s6,80003fc8 <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fa8:	21c4a783          	lw	a5,540(s1)
    80003fac:	0017871b          	addiw	a4,a5,1
    80003fb0:	20e4ae23          	sw	a4,540(s1)
    80003fb4:	1ff7f793          	andi	a5,a5,511
    80003fb8:	97a6                	add	a5,a5,s1
    80003fba:	faf44703          	lbu	a4,-81(s0)
    80003fbe:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fc2:	2905                	addiw	s2,s2,1
    80003fc4:	b755                	j	80003f68 <pipewrite+0x80>
  int i = 0;
    80003fc6:	4901                	li	s2,0
  wakeup(&pi->nread);
    80003fc8:	21848513          	addi	a0,s1,536
    80003fcc:	ffffd097          	auipc	ra,0xffffd
    80003fd0:	5d2080e7          	jalr	1490(ra) # 8000159e <wakeup>
  release(&pi->lock);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	27c080e7          	jalr	636(ra) # 80006252 <release>
  return i;
    80003fde:	bfa9                	j	80003f38 <pipewrite+0x50>

0000000080003fe0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fe0:	715d                	addi	sp,sp,-80
    80003fe2:	e486                	sd	ra,72(sp)
    80003fe4:	e0a2                	sd	s0,64(sp)
    80003fe6:	fc26                	sd	s1,56(sp)
    80003fe8:	f84a                	sd	s2,48(sp)
    80003fea:	f44e                	sd	s3,40(sp)
    80003fec:	f052                	sd	s4,32(sp)
    80003fee:	ec56                	sd	s5,24(sp)
    80003ff0:	e85a                	sd	s6,16(sp)
    80003ff2:	0880                	addi	s0,sp,80
    80003ff4:	84aa                	mv	s1,a0
    80003ff6:	892e                	mv	s2,a1
    80003ff8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	e90080e7          	jalr	-368(ra) # 80000e8a <myproc>
    80004002:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004004:	8526                	mv	a0,s1
    80004006:	00002097          	auipc	ra,0x2
    8000400a:	198080e7          	jalr	408(ra) # 8000619e <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400e:	2184a703          	lw	a4,536(s1)
    80004012:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004016:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000401a:	02f71763          	bne	a4,a5,80004048 <piperead+0x68>
    8000401e:	2244a783          	lw	a5,548(s1)
    80004022:	c39d                	beqz	a5,80004048 <piperead+0x68>
    if(killed(pr)){
    80004024:	8552                	mv	a0,s4
    80004026:	ffffd097          	auipc	ra,0xffffd
    8000402a:	7bc080e7          	jalr	1980(ra) # 800017e2 <killed>
    8000402e:	e949                	bnez	a0,800040c0 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004030:	85a6                	mv	a1,s1
    80004032:	854e                	mv	a0,s3
    80004034:	ffffd097          	auipc	ra,0xffffd
    80004038:	506080e7          	jalr	1286(ra) # 8000153a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403c:	2184a703          	lw	a4,536(s1)
    80004040:	21c4a783          	lw	a5,540(s1)
    80004044:	fcf70de3          	beq	a4,a5,8000401e <piperead+0x3e>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004048:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000404a:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000404c:	05505463          	blez	s5,80004094 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004050:	2184a783          	lw	a5,536(s1)
    80004054:	21c4a703          	lw	a4,540(s1)
    80004058:	02f70e63          	beq	a4,a5,80004094 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000405c:	0017871b          	addiw	a4,a5,1
    80004060:	20e4ac23          	sw	a4,536(s1)
    80004064:	1ff7f793          	andi	a5,a5,511
    80004068:	97a6                	add	a5,a5,s1
    8000406a:	0187c783          	lbu	a5,24(a5)
    8000406e:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004072:	4685                	li	a3,1
    80004074:	fbf40613          	addi	a2,s0,-65
    80004078:	85ca                	mv	a1,s2
    8000407a:	050a3503          	ld	a0,80(s4)
    8000407e:	ffffd097          	auipc	ra,0xffffd
    80004082:	acc080e7          	jalr	-1332(ra) # 80000b4a <copyout>
    80004086:	01650763          	beq	a0,s6,80004094 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000408a:	2985                	addiw	s3,s3,1
    8000408c:	0905                	addi	s2,s2,1
    8000408e:	fd3a91e3          	bne	s5,s3,80004050 <piperead+0x70>
    80004092:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004094:	21c48513          	addi	a0,s1,540
    80004098:	ffffd097          	auipc	ra,0xffffd
    8000409c:	506080e7          	jalr	1286(ra) # 8000159e <wakeup>
  release(&pi->lock);
    800040a0:	8526                	mv	a0,s1
    800040a2:	00002097          	auipc	ra,0x2
    800040a6:	1b0080e7          	jalr	432(ra) # 80006252 <release>
  return i;
}
    800040aa:	854e                	mv	a0,s3
    800040ac:	60a6                	ld	ra,72(sp)
    800040ae:	6406                	ld	s0,64(sp)
    800040b0:	74e2                	ld	s1,56(sp)
    800040b2:	7942                	ld	s2,48(sp)
    800040b4:	79a2                	ld	s3,40(sp)
    800040b6:	7a02                	ld	s4,32(sp)
    800040b8:	6ae2                	ld	s5,24(sp)
    800040ba:	6b42                	ld	s6,16(sp)
    800040bc:	6161                	addi	sp,sp,80
    800040be:	8082                	ret
      release(&pi->lock);
    800040c0:	8526                	mv	a0,s1
    800040c2:	00002097          	auipc	ra,0x2
    800040c6:	190080e7          	jalr	400(ra) # 80006252 <release>
      return -1;
    800040ca:	59fd                	li	s3,-1
    800040cc:	bff9                	j	800040aa <piperead+0xca>

00000000800040ce <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800040ce:	1141                	addi	sp,sp,-16
    800040d0:	e422                	sd	s0,8(sp)
    800040d2:	0800                	addi	s0,sp,16
    800040d4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040d6:	8905                	andi	a0,a0,1
    800040d8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800040da:	8b89                	andi	a5,a5,2
    800040dc:	c399                	beqz	a5,800040e2 <flags2perm+0x14>
      perm |= PTE_W;
    800040de:	00456513          	ori	a0,a0,4
    return perm;
}
    800040e2:	6422                	ld	s0,8(sp)
    800040e4:	0141                	addi	sp,sp,16
    800040e6:	8082                	ret

00000000800040e8 <exec>:

int
exec(char *path, char **argv)
{
    800040e8:	df010113          	addi	sp,sp,-528
    800040ec:	20113423          	sd	ra,520(sp)
    800040f0:	20813023          	sd	s0,512(sp)
    800040f4:	ffa6                	sd	s1,504(sp)
    800040f6:	fbca                	sd	s2,496(sp)
    800040f8:	f7ce                	sd	s3,488(sp)
    800040fa:	f3d2                	sd	s4,480(sp)
    800040fc:	efd6                	sd	s5,472(sp)
    800040fe:	ebda                	sd	s6,464(sp)
    80004100:	e7de                	sd	s7,456(sp)
    80004102:	e3e2                	sd	s8,448(sp)
    80004104:	ff66                	sd	s9,440(sp)
    80004106:	fb6a                	sd	s10,432(sp)
    80004108:	f76e                	sd	s11,424(sp)
    8000410a:	0c00                	addi	s0,sp,528
    8000410c:	892a                	mv	s2,a0
    8000410e:	dea43c23          	sd	a0,-520(s0)
    80004112:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004116:	ffffd097          	auipc	ra,0xffffd
    8000411a:	d74080e7          	jalr	-652(ra) # 80000e8a <myproc>
    8000411e:	84aa                	mv	s1,a0

  begin_op();
    80004120:	fffff097          	auipc	ra,0xfffff
    80004124:	48e080e7          	jalr	1166(ra) # 800035ae <begin_op>

  if((ip = namei(path)) == 0){
    80004128:	854a                	mv	a0,s2
    8000412a:	fffff097          	auipc	ra,0xfffff
    8000412e:	284080e7          	jalr	644(ra) # 800033ae <namei>
    80004132:	c92d                	beqz	a0,800041a4 <exec+0xbc>
    80004134:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	ad2080e7          	jalr	-1326(ra) # 80002c08 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000413e:	04000713          	li	a4,64
    80004142:	4681                	li	a3,0
    80004144:	e5040613          	addi	a2,s0,-432
    80004148:	4581                	li	a1,0
    8000414a:	8552                	mv	a0,s4
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	d70080e7          	jalr	-656(ra) # 80002ebc <readi>
    80004154:	04000793          	li	a5,64
    80004158:	00f51a63          	bne	a0,a5,8000416c <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000415c:	e5042703          	lw	a4,-432(s0)
    80004160:	464c47b7          	lui	a5,0x464c4
    80004164:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004168:	04f70463          	beq	a4,a5,800041b0 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000416c:	8552                	mv	a0,s4
    8000416e:	fffff097          	auipc	ra,0xfffff
    80004172:	cfc080e7          	jalr	-772(ra) # 80002e6a <iunlockput>
    end_op();
    80004176:	fffff097          	auipc	ra,0xfffff
    8000417a:	4b2080e7          	jalr	1202(ra) # 80003628 <end_op>
  }
  return -1;
    8000417e:	557d                	li	a0,-1
}
    80004180:	20813083          	ld	ra,520(sp)
    80004184:	20013403          	ld	s0,512(sp)
    80004188:	74fe                	ld	s1,504(sp)
    8000418a:	795e                	ld	s2,496(sp)
    8000418c:	79be                	ld	s3,488(sp)
    8000418e:	7a1e                	ld	s4,480(sp)
    80004190:	6afe                	ld	s5,472(sp)
    80004192:	6b5e                	ld	s6,464(sp)
    80004194:	6bbe                	ld	s7,456(sp)
    80004196:	6c1e                	ld	s8,448(sp)
    80004198:	7cfa                	ld	s9,440(sp)
    8000419a:	7d5a                	ld	s10,432(sp)
    8000419c:	7dba                	ld	s11,424(sp)
    8000419e:	21010113          	addi	sp,sp,528
    800041a2:	8082                	ret
    end_op();
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	484080e7          	jalr	1156(ra) # 80003628 <end_op>
    return -1;
    800041ac:	557d                	li	a0,-1
    800041ae:	bfc9                	j	80004180 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800041b0:	8526                	mv	a0,s1
    800041b2:	ffffd097          	auipc	ra,0xffffd
    800041b6:	d9c080e7          	jalr	-612(ra) # 80000f4e <proc_pagetable>
    800041ba:	8b2a                	mv	s6,a0
    800041bc:	d945                	beqz	a0,8000416c <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041be:	e7042d03          	lw	s10,-400(s0)
    800041c2:	e8845783          	lhu	a5,-376(s0)
    800041c6:	10078463          	beqz	a5,800042ce <exec+0x1e6>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041ca:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041cc:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800041ce:	6c85                	lui	s9,0x1
    800041d0:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041d4:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041d8:	6a85                	lui	s5,0x1
    800041da:	a0b5                	j	80004246 <exec+0x15e>
      panic("loadseg: address should exist");
    800041dc:	00004517          	auipc	a0,0x4
    800041e0:	6c450513          	addi	a0,a0,1732 # 800088a0 <syscallNames+0x288>
    800041e4:	00002097          	auipc	ra,0x2
    800041e8:	a82080e7          	jalr	-1406(ra) # 80005c66 <panic>
    if(sz - i < PGSIZE)
    800041ec:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041ee:	8726                	mv	a4,s1
    800041f0:	012c06bb          	addw	a3,s8,s2
    800041f4:	4581                	li	a1,0
    800041f6:	8552                	mv	a0,s4
    800041f8:	fffff097          	auipc	ra,0xfffff
    800041fc:	cc4080e7          	jalr	-828(ra) # 80002ebc <readi>
    80004200:	2501                	sext.w	a0,a0
    80004202:	24a49863          	bne	s1,a0,80004452 <exec+0x36a>
  for(i = 0; i < sz; i += PGSIZE){
    80004206:	012a893b          	addw	s2,s5,s2
    8000420a:	03397563          	bgeu	s2,s3,80004234 <exec+0x14c>
    pa = walkaddr(pagetable, va + i);
    8000420e:	02091593          	slli	a1,s2,0x20
    80004212:	9181                	srli	a1,a1,0x20
    80004214:	95de                	add	a1,a1,s7
    80004216:	855a                	mv	a0,s6
    80004218:	ffffc097          	auipc	ra,0xffffc
    8000421c:	322080e7          	jalr	802(ra) # 8000053a <walkaddr>
    80004220:	862a                	mv	a2,a0
    if(pa == 0)
    80004222:	dd4d                	beqz	a0,800041dc <exec+0xf4>
    if(sz - i < PGSIZE)
    80004224:	412984bb          	subw	s1,s3,s2
    80004228:	0004879b          	sext.w	a5,s1
    8000422c:	fcfcf0e3          	bgeu	s9,a5,800041ec <exec+0x104>
    80004230:	84d6                	mv	s1,s5
    80004232:	bf6d                	j	800041ec <exec+0x104>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004234:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004238:	2d85                	addiw	s11,s11,1
    8000423a:	038d0d1b          	addiw	s10,s10,56
    8000423e:	e8845783          	lhu	a5,-376(s0)
    80004242:	08fdd763          	bge	s11,a5,800042d0 <exec+0x1e8>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004246:	2d01                	sext.w	s10,s10
    80004248:	03800713          	li	a4,56
    8000424c:	86ea                	mv	a3,s10
    8000424e:	e1840613          	addi	a2,s0,-488
    80004252:	4581                	li	a1,0
    80004254:	8552                	mv	a0,s4
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	c66080e7          	jalr	-922(ra) # 80002ebc <readi>
    8000425e:	03800793          	li	a5,56
    80004262:	1ef51663          	bne	a0,a5,8000444e <exec+0x366>
    if(ph.type != ELF_PROG_LOAD)
    80004266:	e1842783          	lw	a5,-488(s0)
    8000426a:	4705                	li	a4,1
    8000426c:	fce796e3          	bne	a5,a4,80004238 <exec+0x150>
    if(ph.memsz < ph.filesz)
    80004270:	e4043483          	ld	s1,-448(s0)
    80004274:	e3843783          	ld	a5,-456(s0)
    80004278:	1ef4e863          	bltu	s1,a5,80004468 <exec+0x380>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000427c:	e2843783          	ld	a5,-472(s0)
    80004280:	94be                	add	s1,s1,a5
    80004282:	1ef4e663          	bltu	s1,a5,8000446e <exec+0x386>
    if(ph.vaddr % PGSIZE != 0)
    80004286:	df043703          	ld	a4,-528(s0)
    8000428a:	8ff9                	and	a5,a5,a4
    8000428c:	1e079463          	bnez	a5,80004474 <exec+0x38c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004290:	e1c42503          	lw	a0,-484(s0)
    80004294:	00000097          	auipc	ra,0x0
    80004298:	e3a080e7          	jalr	-454(ra) # 800040ce <flags2perm>
    8000429c:	86aa                	mv	a3,a0
    8000429e:	8626                	mv	a2,s1
    800042a0:	85ca                	mv	a1,s2
    800042a2:	855a                	mv	a0,s6
    800042a4:	ffffc097          	auipc	ra,0xffffc
    800042a8:	64a080e7          	jalr	1610(ra) # 800008ee <uvmalloc>
    800042ac:	e0a43423          	sd	a0,-504(s0)
    800042b0:	1c050563          	beqz	a0,8000447a <exec+0x392>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042b4:	e2843b83          	ld	s7,-472(s0)
    800042b8:	e2042c03          	lw	s8,-480(s0)
    800042bc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042c0:	00098463          	beqz	s3,800042c8 <exec+0x1e0>
    800042c4:	4901                	li	s2,0
    800042c6:	b7a1                	j	8000420e <exec+0x126>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042c8:	e0843903          	ld	s2,-504(s0)
    800042cc:	b7b5                	j	80004238 <exec+0x150>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042ce:	4901                	li	s2,0
  iunlockput(ip);
    800042d0:	8552                	mv	a0,s4
    800042d2:	fffff097          	auipc	ra,0xfffff
    800042d6:	b98080e7          	jalr	-1128(ra) # 80002e6a <iunlockput>
  end_op();
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	34e080e7          	jalr	846(ra) # 80003628 <end_op>
  p = myproc();
    800042e2:	ffffd097          	auipc	ra,0xffffd
    800042e6:	ba8080e7          	jalr	-1112(ra) # 80000e8a <myproc>
    800042ea:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042ec:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800042f0:	6985                	lui	s3,0x1
    800042f2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042f4:	99ca                	add	s3,s3,s2
    800042f6:	77fd                	lui	a5,0xfffff
    800042f8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042fc:	4691                	li	a3,4
    800042fe:	6609                	lui	a2,0x2
    80004300:	964e                	add	a2,a2,s3
    80004302:	85ce                	mv	a1,s3
    80004304:	855a                	mv	a0,s6
    80004306:	ffffc097          	auipc	ra,0xffffc
    8000430a:	5e8080e7          	jalr	1512(ra) # 800008ee <uvmalloc>
    8000430e:	892a                	mv	s2,a0
    80004310:	e0a43423          	sd	a0,-504(s0)
    80004314:	e509                	bnez	a0,8000431e <exec+0x236>
  if(pagetable)
    80004316:	e1343423          	sd	s3,-504(s0)
    8000431a:	4a01                	li	s4,0
    8000431c:	aa1d                	j	80004452 <exec+0x36a>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000431e:	75f9                	lui	a1,0xffffe
    80004320:	95aa                	add	a1,a1,a0
    80004322:	855a                	mv	a0,s6
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	7f4080e7          	jalr	2036(ra) # 80000b18 <uvmclear>
  stackbase = sp - PGSIZE;
    8000432c:	7bfd                	lui	s7,0xfffff
    8000432e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004330:	e0043783          	ld	a5,-512(s0)
    80004334:	6388                	ld	a0,0(a5)
    80004336:	c52d                	beqz	a0,800043a0 <exec+0x2b8>
    80004338:	e9040993          	addi	s3,s0,-368
    8000433c:	f9040c13          	addi	s8,s0,-112
    80004340:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004342:	ffffc097          	auipc	ra,0xffffc
    80004346:	fea080e7          	jalr	-22(ra) # 8000032c <strlen>
    8000434a:	0015079b          	addiw	a5,a0,1
    8000434e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004352:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004356:	13796563          	bltu	s2,s7,80004480 <exec+0x398>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000435a:	e0043d03          	ld	s10,-512(s0)
    8000435e:	000d3a03          	ld	s4,0(s10)
    80004362:	8552                	mv	a0,s4
    80004364:	ffffc097          	auipc	ra,0xffffc
    80004368:	fc8080e7          	jalr	-56(ra) # 8000032c <strlen>
    8000436c:	0015069b          	addiw	a3,a0,1
    80004370:	8652                	mv	a2,s4
    80004372:	85ca                	mv	a1,s2
    80004374:	855a                	mv	a0,s6
    80004376:	ffffc097          	auipc	ra,0xffffc
    8000437a:	7d4080e7          	jalr	2004(ra) # 80000b4a <copyout>
    8000437e:	10054363          	bltz	a0,80004484 <exec+0x39c>
    ustack[argc] = sp;
    80004382:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004386:	0485                	addi	s1,s1,1
    80004388:	008d0793          	addi	a5,s10,8
    8000438c:	e0f43023          	sd	a5,-512(s0)
    80004390:	008d3503          	ld	a0,8(s10)
    80004394:	c909                	beqz	a0,800043a6 <exec+0x2be>
    if(argc >= MAXARG)
    80004396:	09a1                	addi	s3,s3,8
    80004398:	fb8995e3          	bne	s3,s8,80004342 <exec+0x25a>
  ip = 0;
    8000439c:	4a01                	li	s4,0
    8000439e:	a855                	j	80004452 <exec+0x36a>
  sp = sz;
    800043a0:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    800043a4:	4481                	li	s1,0
  ustack[argc] = 0;
    800043a6:	00349793          	slli	a5,s1,0x3
    800043aa:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdce10>
    800043ae:	97a2                	add	a5,a5,s0
    800043b0:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043b4:	00148693          	addi	a3,s1,1
    800043b8:	068e                	slli	a3,a3,0x3
    800043ba:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043be:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800043c2:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800043c6:	f57968e3          	bltu	s2,s7,80004316 <exec+0x22e>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ca:	e9040613          	addi	a2,s0,-368
    800043ce:	85ca                	mv	a1,s2
    800043d0:	855a                	mv	a0,s6
    800043d2:	ffffc097          	auipc	ra,0xffffc
    800043d6:	778080e7          	jalr	1912(ra) # 80000b4a <copyout>
    800043da:	0a054763          	bltz	a0,80004488 <exec+0x3a0>
  p->trapframe->a1 = sp;
    800043de:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043e2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043e6:	df843783          	ld	a5,-520(s0)
    800043ea:	0007c703          	lbu	a4,0(a5)
    800043ee:	cf11                	beqz	a4,8000440a <exec+0x322>
    800043f0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043f2:	02f00693          	li	a3,47
    800043f6:	a039                	j	80004404 <exec+0x31c>
      last = s+1;
    800043f8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043fc:	0785                	addi	a5,a5,1
    800043fe:	fff7c703          	lbu	a4,-1(a5)
    80004402:	c701                	beqz	a4,8000440a <exec+0x322>
    if(*s == '/')
    80004404:	fed71ce3          	bne	a4,a3,800043fc <exec+0x314>
    80004408:	bfc5                	j	800043f8 <exec+0x310>
  safestrcpy(p->name, last, sizeof(p->name));
    8000440a:	4641                	li	a2,16
    8000440c:	df843583          	ld	a1,-520(s0)
    80004410:	158a8513          	addi	a0,s5,344
    80004414:	ffffc097          	auipc	ra,0xffffc
    80004418:	ee6080e7          	jalr	-282(ra) # 800002fa <safestrcpy>
  oldpagetable = p->pagetable;
    8000441c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004420:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004424:	e0843783          	ld	a5,-504(s0)
    80004428:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000442c:	058ab783          	ld	a5,88(s5)
    80004430:	e6843703          	ld	a4,-408(s0)
    80004434:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004436:	058ab783          	ld	a5,88(s5)
    8000443a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000443e:	85e6                	mv	a1,s9
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	baa080e7          	jalr	-1110(ra) # 80000fea <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004448:	0004851b          	sext.w	a0,s1
    8000444c:	bb15                	j	80004180 <exec+0x98>
    8000444e:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004452:	e0843583          	ld	a1,-504(s0)
    80004456:	855a                	mv	a0,s6
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	b92080e7          	jalr	-1134(ra) # 80000fea <proc_freepagetable>
  return -1;
    80004460:	557d                	li	a0,-1
  if(ip){
    80004462:	d00a0fe3          	beqz	s4,80004180 <exec+0x98>
    80004466:	b319                	j	8000416c <exec+0x84>
    80004468:	e1243423          	sd	s2,-504(s0)
    8000446c:	b7dd                	j	80004452 <exec+0x36a>
    8000446e:	e1243423          	sd	s2,-504(s0)
    80004472:	b7c5                	j	80004452 <exec+0x36a>
    80004474:	e1243423          	sd	s2,-504(s0)
    80004478:	bfe9                	j	80004452 <exec+0x36a>
    8000447a:	e1243423          	sd	s2,-504(s0)
    8000447e:	bfd1                	j	80004452 <exec+0x36a>
  ip = 0;
    80004480:	4a01                	li	s4,0
    80004482:	bfc1                	j	80004452 <exec+0x36a>
    80004484:	4a01                	li	s4,0
  if(pagetable)
    80004486:	b7f1                	j	80004452 <exec+0x36a>
  sz = sz1;
    80004488:	e0843983          	ld	s3,-504(s0)
    8000448c:	b569                	j	80004316 <exec+0x22e>

000000008000448e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000448e:	7179                	addi	sp,sp,-48
    80004490:	f406                	sd	ra,40(sp)
    80004492:	f022                	sd	s0,32(sp)
    80004494:	ec26                	sd	s1,24(sp)
    80004496:	e84a                	sd	s2,16(sp)
    80004498:	1800                	addi	s0,sp,48
    8000449a:	892e                	mv	s2,a1
    8000449c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000449e:	fdc40593          	addi	a1,s0,-36
    800044a2:	ffffe097          	auipc	ra,0xffffe
    800044a6:	b3c080e7          	jalr	-1220(ra) # 80001fde <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044aa:	fdc42703          	lw	a4,-36(s0)
    800044ae:	47bd                	li	a5,15
    800044b0:	02e7eb63          	bltu	a5,a4,800044e6 <argfd+0x58>
    800044b4:	ffffd097          	auipc	ra,0xffffd
    800044b8:	9d6080e7          	jalr	-1578(ra) # 80000e8a <myproc>
    800044bc:	fdc42703          	lw	a4,-36(s0)
    800044c0:	01a70793          	addi	a5,a4,26
    800044c4:	078e                	slli	a5,a5,0x3
    800044c6:	953e                	add	a0,a0,a5
    800044c8:	611c                	ld	a5,0(a0)
    800044ca:	c385                	beqz	a5,800044ea <argfd+0x5c>
    return -1;
  if(pfd)
    800044cc:	00090463          	beqz	s2,800044d4 <argfd+0x46>
    *pfd = fd;
    800044d0:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044d4:	4501                	li	a0,0
  if(pf)
    800044d6:	c091                	beqz	s1,800044da <argfd+0x4c>
    *pf = f;
    800044d8:	e09c                	sd	a5,0(s1)
}
    800044da:	70a2                	ld	ra,40(sp)
    800044dc:	7402                	ld	s0,32(sp)
    800044de:	64e2                	ld	s1,24(sp)
    800044e0:	6942                	ld	s2,16(sp)
    800044e2:	6145                	addi	sp,sp,48
    800044e4:	8082                	ret
    return -1;
    800044e6:	557d                	li	a0,-1
    800044e8:	bfcd                	j	800044da <argfd+0x4c>
    800044ea:	557d                	li	a0,-1
    800044ec:	b7fd                	j	800044da <argfd+0x4c>

00000000800044ee <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ee:	1101                	addi	sp,sp,-32
    800044f0:	ec06                	sd	ra,24(sp)
    800044f2:	e822                	sd	s0,16(sp)
    800044f4:	e426                	sd	s1,8(sp)
    800044f6:	1000                	addi	s0,sp,32
    800044f8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044fa:	ffffd097          	auipc	ra,0xffffd
    800044fe:	990080e7          	jalr	-1648(ra) # 80000e8a <myproc>
    80004502:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004504:	0d050793          	addi	a5,a0,208
    80004508:	4501                	li	a0,0
    8000450a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000450c:	6398                	ld	a4,0(a5)
    8000450e:	cb19                	beqz	a4,80004524 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004510:	2505                	addiw	a0,a0,1
    80004512:	07a1                	addi	a5,a5,8
    80004514:	fed51ce3          	bne	a0,a3,8000450c <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004518:	557d                	li	a0,-1
}
    8000451a:	60e2                	ld	ra,24(sp)
    8000451c:	6442                	ld	s0,16(sp)
    8000451e:	64a2                	ld	s1,8(sp)
    80004520:	6105                	addi	sp,sp,32
    80004522:	8082                	ret
      p->ofile[fd] = f;
    80004524:	01a50793          	addi	a5,a0,26
    80004528:	078e                	slli	a5,a5,0x3
    8000452a:	963e                	add	a2,a2,a5
    8000452c:	e204                	sd	s1,0(a2)
      return fd;
    8000452e:	b7f5                	j	8000451a <fdalloc+0x2c>

0000000080004530 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004530:	715d                	addi	sp,sp,-80
    80004532:	e486                	sd	ra,72(sp)
    80004534:	e0a2                	sd	s0,64(sp)
    80004536:	fc26                	sd	s1,56(sp)
    80004538:	f84a                	sd	s2,48(sp)
    8000453a:	f44e                	sd	s3,40(sp)
    8000453c:	f052                	sd	s4,32(sp)
    8000453e:	ec56                	sd	s5,24(sp)
    80004540:	e85a                	sd	s6,16(sp)
    80004542:	0880                	addi	s0,sp,80
    80004544:	8b2e                	mv	s6,a1
    80004546:	89b2                	mv	s3,a2
    80004548:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000454a:	fb040593          	addi	a1,s0,-80
    8000454e:	fffff097          	auipc	ra,0xfffff
    80004552:	e7e080e7          	jalr	-386(ra) # 800033cc <nameiparent>
    80004556:	84aa                	mv	s1,a0
    80004558:	14050b63          	beqz	a0,800046ae <create+0x17e>
    return 0;

  ilock(dp);
    8000455c:	ffffe097          	auipc	ra,0xffffe
    80004560:	6ac080e7          	jalr	1708(ra) # 80002c08 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004564:	4601                	li	a2,0
    80004566:	fb040593          	addi	a1,s0,-80
    8000456a:	8526                	mv	a0,s1
    8000456c:	fffff097          	auipc	ra,0xfffff
    80004570:	b80080e7          	jalr	-1152(ra) # 800030ec <dirlookup>
    80004574:	8aaa                	mv	s5,a0
    80004576:	c921                	beqz	a0,800045c6 <create+0x96>
    iunlockput(dp);
    80004578:	8526                	mv	a0,s1
    8000457a:	fffff097          	auipc	ra,0xfffff
    8000457e:	8f0080e7          	jalr	-1808(ra) # 80002e6a <iunlockput>
    ilock(ip);
    80004582:	8556                	mv	a0,s5
    80004584:	ffffe097          	auipc	ra,0xffffe
    80004588:	684080e7          	jalr	1668(ra) # 80002c08 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000458c:	4789                	li	a5,2
    8000458e:	02fb1563          	bne	s6,a5,800045b8 <create+0x88>
    80004592:	044ad783          	lhu	a5,68(s5)
    80004596:	37f9                	addiw	a5,a5,-2
    80004598:	17c2                	slli	a5,a5,0x30
    8000459a:	93c1                	srli	a5,a5,0x30
    8000459c:	4705                	li	a4,1
    8000459e:	00f76d63          	bltu	a4,a5,800045b8 <create+0x88>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800045a2:	8556                	mv	a0,s5
    800045a4:	60a6                	ld	ra,72(sp)
    800045a6:	6406                	ld	s0,64(sp)
    800045a8:	74e2                	ld	s1,56(sp)
    800045aa:	7942                	ld	s2,48(sp)
    800045ac:	79a2                	ld	s3,40(sp)
    800045ae:	7a02                	ld	s4,32(sp)
    800045b0:	6ae2                	ld	s5,24(sp)
    800045b2:	6b42                	ld	s6,16(sp)
    800045b4:	6161                	addi	sp,sp,80
    800045b6:	8082                	ret
    iunlockput(ip);
    800045b8:	8556                	mv	a0,s5
    800045ba:	fffff097          	auipc	ra,0xfffff
    800045be:	8b0080e7          	jalr	-1872(ra) # 80002e6a <iunlockput>
    return 0;
    800045c2:	4a81                	li	s5,0
    800045c4:	bff9                	j	800045a2 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045c6:	85da                	mv	a1,s6
    800045c8:	4088                	lw	a0,0(s1)
    800045ca:	ffffe097          	auipc	ra,0xffffe
    800045ce:	4a6080e7          	jalr	1190(ra) # 80002a70 <ialloc>
    800045d2:	8a2a                	mv	s4,a0
    800045d4:	c529                	beqz	a0,8000461e <create+0xee>
  ilock(ip);
    800045d6:	ffffe097          	auipc	ra,0xffffe
    800045da:	632080e7          	jalr	1586(ra) # 80002c08 <ilock>
  ip->major = major;
    800045de:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800045e2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800045e6:	4905                	li	s2,1
    800045e8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800045ec:	8552                	mv	a0,s4
    800045ee:	ffffe097          	auipc	ra,0xffffe
    800045f2:	54e080e7          	jalr	1358(ra) # 80002b3c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045f6:	032b0b63          	beq	s6,s2,8000462c <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    800045fa:	004a2603          	lw	a2,4(s4)
    800045fe:	fb040593          	addi	a1,s0,-80
    80004602:	8526                	mv	a0,s1
    80004604:	fffff097          	auipc	ra,0xfffff
    80004608:	cf8080e7          	jalr	-776(ra) # 800032fc <dirlink>
    8000460c:	06054f63          	bltz	a0,8000468a <create+0x15a>
  iunlockput(dp);
    80004610:	8526                	mv	a0,s1
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	858080e7          	jalr	-1960(ra) # 80002e6a <iunlockput>
  return ip;
    8000461a:	8ad2                	mv	s5,s4
    8000461c:	b759                	j	800045a2 <create+0x72>
    iunlockput(dp);
    8000461e:	8526                	mv	a0,s1
    80004620:	fffff097          	auipc	ra,0xfffff
    80004624:	84a080e7          	jalr	-1974(ra) # 80002e6a <iunlockput>
    return 0;
    80004628:	8ad2                	mv	s5,s4
    8000462a:	bfa5                	j	800045a2 <create+0x72>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000462c:	004a2603          	lw	a2,4(s4)
    80004630:	00004597          	auipc	a1,0x4
    80004634:	29058593          	addi	a1,a1,656 # 800088c0 <syscallNames+0x2a8>
    80004638:	8552                	mv	a0,s4
    8000463a:	fffff097          	auipc	ra,0xfffff
    8000463e:	cc2080e7          	jalr	-830(ra) # 800032fc <dirlink>
    80004642:	04054463          	bltz	a0,8000468a <create+0x15a>
    80004646:	40d0                	lw	a2,4(s1)
    80004648:	00004597          	auipc	a1,0x4
    8000464c:	28058593          	addi	a1,a1,640 # 800088c8 <syscallNames+0x2b0>
    80004650:	8552                	mv	a0,s4
    80004652:	fffff097          	auipc	ra,0xfffff
    80004656:	caa080e7          	jalr	-854(ra) # 800032fc <dirlink>
    8000465a:	02054863          	bltz	a0,8000468a <create+0x15a>
  if(dirlink(dp, name, ip->inum) < 0)
    8000465e:	004a2603          	lw	a2,4(s4)
    80004662:	fb040593          	addi	a1,s0,-80
    80004666:	8526                	mv	a0,s1
    80004668:	fffff097          	auipc	ra,0xfffff
    8000466c:	c94080e7          	jalr	-876(ra) # 800032fc <dirlink>
    80004670:	00054d63          	bltz	a0,8000468a <create+0x15a>
    dp->nlink++;  // for ".."
    80004674:	04a4d783          	lhu	a5,74(s1)
    80004678:	2785                	addiw	a5,a5,1
    8000467a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000467e:	8526                	mv	a0,s1
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	4bc080e7          	jalr	1212(ra) # 80002b3c <iupdate>
    80004688:	b761                	j	80004610 <create+0xe0>
  ip->nlink = 0;
    8000468a:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000468e:	8552                	mv	a0,s4
    80004690:	ffffe097          	auipc	ra,0xffffe
    80004694:	4ac080e7          	jalr	1196(ra) # 80002b3c <iupdate>
  iunlockput(ip);
    80004698:	8552                	mv	a0,s4
    8000469a:	ffffe097          	auipc	ra,0xffffe
    8000469e:	7d0080e7          	jalr	2000(ra) # 80002e6a <iunlockput>
  iunlockput(dp);
    800046a2:	8526                	mv	a0,s1
    800046a4:	ffffe097          	auipc	ra,0xffffe
    800046a8:	7c6080e7          	jalr	1990(ra) # 80002e6a <iunlockput>
  return 0;
    800046ac:	bddd                	j	800045a2 <create+0x72>
    return 0;
    800046ae:	8aaa                	mv	s5,a0
    800046b0:	bdcd                	j	800045a2 <create+0x72>

00000000800046b2 <sys_dup>:
{
    800046b2:	7179                	addi	sp,sp,-48
    800046b4:	f406                	sd	ra,40(sp)
    800046b6:	f022                	sd	s0,32(sp)
    800046b8:	ec26                	sd	s1,24(sp)
    800046ba:	e84a                	sd	s2,16(sp)
    800046bc:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800046be:	fd840613          	addi	a2,s0,-40
    800046c2:	4581                	li	a1,0
    800046c4:	4501                	li	a0,0
    800046c6:	00000097          	auipc	ra,0x0
    800046ca:	dc8080e7          	jalr	-568(ra) # 8000448e <argfd>
    return -1;
    800046ce:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800046d0:	02054363          	bltz	a0,800046f6 <sys_dup+0x44>
  if((fd=fdalloc(f)) < 0)
    800046d4:	fd843903          	ld	s2,-40(s0)
    800046d8:	854a                	mv	a0,s2
    800046da:	00000097          	auipc	ra,0x0
    800046de:	e14080e7          	jalr	-492(ra) # 800044ee <fdalloc>
    800046e2:	84aa                	mv	s1,a0
    return -1;
    800046e4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800046e6:	00054863          	bltz	a0,800046f6 <sys_dup+0x44>
  filedup(f);
    800046ea:	854a                	mv	a0,s2
    800046ec:	fffff097          	auipc	ra,0xfffff
    800046f0:	334080e7          	jalr	820(ra) # 80003a20 <filedup>
  return fd;
    800046f4:	87a6                	mv	a5,s1
}
    800046f6:	853e                	mv	a0,a5
    800046f8:	70a2                	ld	ra,40(sp)
    800046fa:	7402                	ld	s0,32(sp)
    800046fc:	64e2                	ld	s1,24(sp)
    800046fe:	6942                	ld	s2,16(sp)
    80004700:	6145                	addi	sp,sp,48
    80004702:	8082                	ret

0000000080004704 <sys_read>:
{
    80004704:	7179                	addi	sp,sp,-48
    80004706:	f406                	sd	ra,40(sp)
    80004708:	f022                	sd	s0,32(sp)
    8000470a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000470c:	fd840593          	addi	a1,s0,-40
    80004710:	4505                	li	a0,1
    80004712:	ffffe097          	auipc	ra,0xffffe
    80004716:	8ec080e7          	jalr	-1812(ra) # 80001ffe <argaddr>
  argint(2, &n);
    8000471a:	fe440593          	addi	a1,s0,-28
    8000471e:	4509                	li	a0,2
    80004720:	ffffe097          	auipc	ra,0xffffe
    80004724:	8be080e7          	jalr	-1858(ra) # 80001fde <argint>
  if(argfd(0, 0, &f) < 0)
    80004728:	fe840613          	addi	a2,s0,-24
    8000472c:	4581                	li	a1,0
    8000472e:	4501                	li	a0,0
    80004730:	00000097          	auipc	ra,0x0
    80004734:	d5e080e7          	jalr	-674(ra) # 8000448e <argfd>
    80004738:	87aa                	mv	a5,a0
    return -1;
    8000473a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000473c:	0007cc63          	bltz	a5,80004754 <sys_read+0x50>
  return fileread(f, p, n);
    80004740:	fe442603          	lw	a2,-28(s0)
    80004744:	fd843583          	ld	a1,-40(s0)
    80004748:	fe843503          	ld	a0,-24(s0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	460080e7          	jalr	1120(ra) # 80003bac <fileread>
}
    80004754:	70a2                	ld	ra,40(sp)
    80004756:	7402                	ld	s0,32(sp)
    80004758:	6145                	addi	sp,sp,48
    8000475a:	8082                	ret

000000008000475c <sys_write>:
{
    8000475c:	7179                	addi	sp,sp,-48
    8000475e:	f406                	sd	ra,40(sp)
    80004760:	f022                	sd	s0,32(sp)
    80004762:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004764:	fd840593          	addi	a1,s0,-40
    80004768:	4505                	li	a0,1
    8000476a:	ffffe097          	auipc	ra,0xffffe
    8000476e:	894080e7          	jalr	-1900(ra) # 80001ffe <argaddr>
  argint(2, &n);
    80004772:	fe440593          	addi	a1,s0,-28
    80004776:	4509                	li	a0,2
    80004778:	ffffe097          	auipc	ra,0xffffe
    8000477c:	866080e7          	jalr	-1946(ra) # 80001fde <argint>
  if(argfd(0, 0, &f) < 0)
    80004780:	fe840613          	addi	a2,s0,-24
    80004784:	4581                	li	a1,0
    80004786:	4501                	li	a0,0
    80004788:	00000097          	auipc	ra,0x0
    8000478c:	d06080e7          	jalr	-762(ra) # 8000448e <argfd>
    80004790:	87aa                	mv	a5,a0
    return -1;
    80004792:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004794:	0007cc63          	bltz	a5,800047ac <sys_write+0x50>
  return filewrite(f, p, n);
    80004798:	fe442603          	lw	a2,-28(s0)
    8000479c:	fd843583          	ld	a1,-40(s0)
    800047a0:	fe843503          	ld	a0,-24(s0)
    800047a4:	fffff097          	auipc	ra,0xfffff
    800047a8:	4ca080e7          	jalr	1226(ra) # 80003c6e <filewrite>
}
    800047ac:	70a2                	ld	ra,40(sp)
    800047ae:	7402                	ld	s0,32(sp)
    800047b0:	6145                	addi	sp,sp,48
    800047b2:	8082                	ret

00000000800047b4 <sys_close>:
{
    800047b4:	1101                	addi	sp,sp,-32
    800047b6:	ec06                	sd	ra,24(sp)
    800047b8:	e822                	sd	s0,16(sp)
    800047ba:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800047bc:	fe040613          	addi	a2,s0,-32
    800047c0:	fec40593          	addi	a1,s0,-20
    800047c4:	4501                	li	a0,0
    800047c6:	00000097          	auipc	ra,0x0
    800047ca:	cc8080e7          	jalr	-824(ra) # 8000448e <argfd>
    return -1;
    800047ce:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800047d0:	02054463          	bltz	a0,800047f8 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800047d4:	ffffc097          	auipc	ra,0xffffc
    800047d8:	6b6080e7          	jalr	1718(ra) # 80000e8a <myproc>
    800047dc:	fec42783          	lw	a5,-20(s0)
    800047e0:	07e9                	addi	a5,a5,26
    800047e2:	078e                	slli	a5,a5,0x3
    800047e4:	953e                	add	a0,a0,a5
    800047e6:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800047ea:	fe043503          	ld	a0,-32(s0)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	284080e7          	jalr	644(ra) # 80003a72 <fileclose>
  return 0;
    800047f6:	4781                	li	a5,0
}
    800047f8:	853e                	mv	a0,a5
    800047fa:	60e2                	ld	ra,24(sp)
    800047fc:	6442                	ld	s0,16(sp)
    800047fe:	6105                	addi	sp,sp,32
    80004800:	8082                	ret

0000000080004802 <sys_fstat>:
{
    80004802:	1101                	addi	sp,sp,-32
    80004804:	ec06                	sd	ra,24(sp)
    80004806:	e822                	sd	s0,16(sp)
    80004808:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000480a:	fe040593          	addi	a1,s0,-32
    8000480e:	4505                	li	a0,1
    80004810:	ffffd097          	auipc	ra,0xffffd
    80004814:	7ee080e7          	jalr	2030(ra) # 80001ffe <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004818:	fe840613          	addi	a2,s0,-24
    8000481c:	4581                	li	a1,0
    8000481e:	4501                	li	a0,0
    80004820:	00000097          	auipc	ra,0x0
    80004824:	c6e080e7          	jalr	-914(ra) # 8000448e <argfd>
    80004828:	87aa                	mv	a5,a0
    return -1;
    8000482a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000482c:	0007ca63          	bltz	a5,80004840 <sys_fstat+0x3e>
  return filestat(f, st);
    80004830:	fe043583          	ld	a1,-32(s0)
    80004834:	fe843503          	ld	a0,-24(s0)
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	302080e7          	jalr	770(ra) # 80003b3a <filestat>
}
    80004840:	60e2                	ld	ra,24(sp)
    80004842:	6442                	ld	s0,16(sp)
    80004844:	6105                	addi	sp,sp,32
    80004846:	8082                	ret

0000000080004848 <sys_link>:
{
    80004848:	7169                	addi	sp,sp,-304
    8000484a:	f606                	sd	ra,296(sp)
    8000484c:	f222                	sd	s0,288(sp)
    8000484e:	ee26                	sd	s1,280(sp)
    80004850:	ea4a                	sd	s2,272(sp)
    80004852:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004854:	08000613          	li	a2,128
    80004858:	ed040593          	addi	a1,s0,-304
    8000485c:	4501                	li	a0,0
    8000485e:	ffffd097          	auipc	ra,0xffffd
    80004862:	7c0080e7          	jalr	1984(ra) # 8000201e <argstr>
    return -1;
    80004866:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004868:	10054e63          	bltz	a0,80004984 <sys_link+0x13c>
    8000486c:	08000613          	li	a2,128
    80004870:	f5040593          	addi	a1,s0,-176
    80004874:	4505                	li	a0,1
    80004876:	ffffd097          	auipc	ra,0xffffd
    8000487a:	7a8080e7          	jalr	1960(ra) # 8000201e <argstr>
    return -1;
    8000487e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004880:	10054263          	bltz	a0,80004984 <sys_link+0x13c>
  begin_op();
    80004884:	fffff097          	auipc	ra,0xfffff
    80004888:	d2a080e7          	jalr	-726(ra) # 800035ae <begin_op>
  if((ip = namei(old)) == 0){
    8000488c:	ed040513          	addi	a0,s0,-304
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	b1e080e7          	jalr	-1250(ra) # 800033ae <namei>
    80004898:	84aa                	mv	s1,a0
    8000489a:	c551                	beqz	a0,80004926 <sys_link+0xde>
  ilock(ip);
    8000489c:	ffffe097          	auipc	ra,0xffffe
    800048a0:	36c080e7          	jalr	876(ra) # 80002c08 <ilock>
  if(ip->type == T_DIR){
    800048a4:	04449703          	lh	a4,68(s1)
    800048a8:	4785                	li	a5,1
    800048aa:	08f70463          	beq	a4,a5,80004932 <sys_link+0xea>
  ip->nlink++;
    800048ae:	04a4d783          	lhu	a5,74(s1)
    800048b2:	2785                	addiw	a5,a5,1
    800048b4:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048b8:	8526                	mv	a0,s1
    800048ba:	ffffe097          	auipc	ra,0xffffe
    800048be:	282080e7          	jalr	642(ra) # 80002b3c <iupdate>
  iunlock(ip);
    800048c2:	8526                	mv	a0,s1
    800048c4:	ffffe097          	auipc	ra,0xffffe
    800048c8:	406080e7          	jalr	1030(ra) # 80002cca <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800048cc:	fd040593          	addi	a1,s0,-48
    800048d0:	f5040513          	addi	a0,s0,-176
    800048d4:	fffff097          	auipc	ra,0xfffff
    800048d8:	af8080e7          	jalr	-1288(ra) # 800033cc <nameiparent>
    800048dc:	892a                	mv	s2,a0
    800048de:	c935                	beqz	a0,80004952 <sys_link+0x10a>
  ilock(dp);
    800048e0:	ffffe097          	auipc	ra,0xffffe
    800048e4:	328080e7          	jalr	808(ra) # 80002c08 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800048e8:	00092703          	lw	a4,0(s2)
    800048ec:	409c                	lw	a5,0(s1)
    800048ee:	04f71d63          	bne	a4,a5,80004948 <sys_link+0x100>
    800048f2:	40d0                	lw	a2,4(s1)
    800048f4:	fd040593          	addi	a1,s0,-48
    800048f8:	854a                	mv	a0,s2
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	a02080e7          	jalr	-1534(ra) # 800032fc <dirlink>
    80004902:	04054363          	bltz	a0,80004948 <sys_link+0x100>
  iunlockput(dp);
    80004906:	854a                	mv	a0,s2
    80004908:	ffffe097          	auipc	ra,0xffffe
    8000490c:	562080e7          	jalr	1378(ra) # 80002e6a <iunlockput>
  iput(ip);
    80004910:	8526                	mv	a0,s1
    80004912:	ffffe097          	auipc	ra,0xffffe
    80004916:	4b0080e7          	jalr	1200(ra) # 80002dc2 <iput>
  end_op();
    8000491a:	fffff097          	auipc	ra,0xfffff
    8000491e:	d0e080e7          	jalr	-754(ra) # 80003628 <end_op>
  return 0;
    80004922:	4781                	li	a5,0
    80004924:	a085                	j	80004984 <sys_link+0x13c>
    end_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	d02080e7          	jalr	-766(ra) # 80003628 <end_op>
    return -1;
    8000492e:	57fd                	li	a5,-1
    80004930:	a891                	j	80004984 <sys_link+0x13c>
    iunlockput(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	536080e7          	jalr	1334(ra) # 80002e6a <iunlockput>
    end_op();
    8000493c:	fffff097          	auipc	ra,0xfffff
    80004940:	cec080e7          	jalr	-788(ra) # 80003628 <end_op>
    return -1;
    80004944:	57fd                	li	a5,-1
    80004946:	a83d                	j	80004984 <sys_link+0x13c>
    iunlockput(dp);
    80004948:	854a                	mv	a0,s2
    8000494a:	ffffe097          	auipc	ra,0xffffe
    8000494e:	520080e7          	jalr	1312(ra) # 80002e6a <iunlockput>
  ilock(ip);
    80004952:	8526                	mv	a0,s1
    80004954:	ffffe097          	auipc	ra,0xffffe
    80004958:	2b4080e7          	jalr	692(ra) # 80002c08 <ilock>
  ip->nlink--;
    8000495c:	04a4d783          	lhu	a5,74(s1)
    80004960:	37fd                	addiw	a5,a5,-1
    80004962:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004966:	8526                	mv	a0,s1
    80004968:	ffffe097          	auipc	ra,0xffffe
    8000496c:	1d4080e7          	jalr	468(ra) # 80002b3c <iupdate>
  iunlockput(ip);
    80004970:	8526                	mv	a0,s1
    80004972:	ffffe097          	auipc	ra,0xffffe
    80004976:	4f8080e7          	jalr	1272(ra) # 80002e6a <iunlockput>
  end_op();
    8000497a:	fffff097          	auipc	ra,0xfffff
    8000497e:	cae080e7          	jalr	-850(ra) # 80003628 <end_op>
  return -1;
    80004982:	57fd                	li	a5,-1
}
    80004984:	853e                	mv	a0,a5
    80004986:	70b2                	ld	ra,296(sp)
    80004988:	7412                	ld	s0,288(sp)
    8000498a:	64f2                	ld	s1,280(sp)
    8000498c:	6952                	ld	s2,272(sp)
    8000498e:	6155                	addi	sp,sp,304
    80004990:	8082                	ret

0000000080004992 <sys_unlink>:
{
    80004992:	7151                	addi	sp,sp,-240
    80004994:	f586                	sd	ra,232(sp)
    80004996:	f1a2                	sd	s0,224(sp)
    80004998:	eda6                	sd	s1,216(sp)
    8000499a:	e9ca                	sd	s2,208(sp)
    8000499c:	e5ce                	sd	s3,200(sp)
    8000499e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800049a0:	08000613          	li	a2,128
    800049a4:	f3040593          	addi	a1,s0,-208
    800049a8:	4501                	li	a0,0
    800049aa:	ffffd097          	auipc	ra,0xffffd
    800049ae:	674080e7          	jalr	1652(ra) # 8000201e <argstr>
    800049b2:	18054163          	bltz	a0,80004b34 <sys_unlink+0x1a2>
  begin_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	bf8080e7          	jalr	-1032(ra) # 800035ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800049be:	fb040593          	addi	a1,s0,-80
    800049c2:	f3040513          	addi	a0,s0,-208
    800049c6:	fffff097          	auipc	ra,0xfffff
    800049ca:	a06080e7          	jalr	-1530(ra) # 800033cc <nameiparent>
    800049ce:	84aa                	mv	s1,a0
    800049d0:	c979                	beqz	a0,80004aa6 <sys_unlink+0x114>
  ilock(dp);
    800049d2:	ffffe097          	auipc	ra,0xffffe
    800049d6:	236080e7          	jalr	566(ra) # 80002c08 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800049da:	00004597          	auipc	a1,0x4
    800049de:	ee658593          	addi	a1,a1,-282 # 800088c0 <syscallNames+0x2a8>
    800049e2:	fb040513          	addi	a0,s0,-80
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	6ec080e7          	jalr	1772(ra) # 800030d2 <namecmp>
    800049ee:	14050a63          	beqz	a0,80004b42 <sys_unlink+0x1b0>
    800049f2:	00004597          	auipc	a1,0x4
    800049f6:	ed658593          	addi	a1,a1,-298 # 800088c8 <syscallNames+0x2b0>
    800049fa:	fb040513          	addi	a0,s0,-80
    800049fe:	ffffe097          	auipc	ra,0xffffe
    80004a02:	6d4080e7          	jalr	1748(ra) # 800030d2 <namecmp>
    80004a06:	12050e63          	beqz	a0,80004b42 <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004a0a:	f2c40613          	addi	a2,s0,-212
    80004a0e:	fb040593          	addi	a1,s0,-80
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	6d8080e7          	jalr	1752(ra) # 800030ec <dirlookup>
    80004a1c:	892a                	mv	s2,a0
    80004a1e:	12050263          	beqz	a0,80004b42 <sys_unlink+0x1b0>
  ilock(ip);
    80004a22:	ffffe097          	auipc	ra,0xffffe
    80004a26:	1e6080e7          	jalr	486(ra) # 80002c08 <ilock>
  if(ip->nlink < 1)
    80004a2a:	04a91783          	lh	a5,74(s2)
    80004a2e:	08f05263          	blez	a5,80004ab2 <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004a32:	04491703          	lh	a4,68(s2)
    80004a36:	4785                	li	a5,1
    80004a38:	08f70563          	beq	a4,a5,80004ac2 <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80004a3c:	4641                	li	a2,16
    80004a3e:	4581                	li	a1,0
    80004a40:	fc040513          	addi	a0,s0,-64
    80004a44:	ffffb097          	auipc	ra,0xffffb
    80004a48:	76e080e7          	jalr	1902(ra) # 800001b2 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004a4c:	4741                	li	a4,16
    80004a4e:	f2c42683          	lw	a3,-212(s0)
    80004a52:	fc040613          	addi	a2,s0,-64
    80004a56:	4581                	li	a1,0
    80004a58:	8526                	mv	a0,s1
    80004a5a:	ffffe097          	auipc	ra,0xffffe
    80004a5e:	55a080e7          	jalr	1370(ra) # 80002fb4 <writei>
    80004a62:	47c1                	li	a5,16
    80004a64:	0af51563          	bne	a0,a5,80004b0e <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    80004a68:	04491703          	lh	a4,68(s2)
    80004a6c:	4785                	li	a5,1
    80004a6e:	0af70863          	beq	a4,a5,80004b1e <sys_unlink+0x18c>
  iunlockput(dp);
    80004a72:	8526                	mv	a0,s1
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	3f6080e7          	jalr	1014(ra) # 80002e6a <iunlockput>
  ip->nlink--;
    80004a7c:	04a95783          	lhu	a5,74(s2)
    80004a80:	37fd                	addiw	a5,a5,-1
    80004a82:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004a86:	854a                	mv	a0,s2
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	0b4080e7          	jalr	180(ra) # 80002b3c <iupdate>
  iunlockput(ip);
    80004a90:	854a                	mv	a0,s2
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	3d8080e7          	jalr	984(ra) # 80002e6a <iunlockput>
  end_op();
    80004a9a:	fffff097          	auipc	ra,0xfffff
    80004a9e:	b8e080e7          	jalr	-1138(ra) # 80003628 <end_op>
  return 0;
    80004aa2:	4501                	li	a0,0
    80004aa4:	a84d                	j	80004b56 <sys_unlink+0x1c4>
    end_op();
    80004aa6:	fffff097          	auipc	ra,0xfffff
    80004aaa:	b82080e7          	jalr	-1150(ra) # 80003628 <end_op>
    return -1;
    80004aae:	557d                	li	a0,-1
    80004ab0:	a05d                	j	80004b56 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    80004ab2:	00004517          	auipc	a0,0x4
    80004ab6:	e1e50513          	addi	a0,a0,-482 # 800088d0 <syscallNames+0x2b8>
    80004aba:	00001097          	auipc	ra,0x1
    80004abe:	1ac080e7          	jalr	428(ra) # 80005c66 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004ac2:	04c92703          	lw	a4,76(s2)
    80004ac6:	02000793          	li	a5,32
    80004aca:	f6e7f9e3          	bgeu	a5,a4,80004a3c <sys_unlink+0xaa>
    80004ace:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ad2:	4741                	li	a4,16
    80004ad4:	86ce                	mv	a3,s3
    80004ad6:	f1840613          	addi	a2,s0,-232
    80004ada:	4581                	li	a1,0
    80004adc:	854a                	mv	a0,s2
    80004ade:	ffffe097          	auipc	ra,0xffffe
    80004ae2:	3de080e7          	jalr	990(ra) # 80002ebc <readi>
    80004ae6:	47c1                	li	a5,16
    80004ae8:	00f51b63          	bne	a0,a5,80004afe <sys_unlink+0x16c>
    if(de.inum != 0)
    80004aec:	f1845783          	lhu	a5,-232(s0)
    80004af0:	e7a1                	bnez	a5,80004b38 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004af2:	29c1                	addiw	s3,s3,16
    80004af4:	04c92783          	lw	a5,76(s2)
    80004af8:	fcf9ede3          	bltu	s3,a5,80004ad2 <sys_unlink+0x140>
    80004afc:	b781                	j	80004a3c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80004afe:	00004517          	auipc	a0,0x4
    80004b02:	dea50513          	addi	a0,a0,-534 # 800088e8 <syscallNames+0x2d0>
    80004b06:	00001097          	auipc	ra,0x1
    80004b0a:	160080e7          	jalr	352(ra) # 80005c66 <panic>
    panic("unlink: writei");
    80004b0e:	00004517          	auipc	a0,0x4
    80004b12:	df250513          	addi	a0,a0,-526 # 80008900 <syscallNames+0x2e8>
    80004b16:	00001097          	auipc	ra,0x1
    80004b1a:	150080e7          	jalr	336(ra) # 80005c66 <panic>
    dp->nlink--;
    80004b1e:	04a4d783          	lhu	a5,74(s1)
    80004b22:	37fd                	addiw	a5,a5,-1
    80004b24:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004b28:	8526                	mv	a0,s1
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	012080e7          	jalr	18(ra) # 80002b3c <iupdate>
    80004b32:	b781                	j	80004a72 <sys_unlink+0xe0>
    return -1;
    80004b34:	557d                	li	a0,-1
    80004b36:	a005                	j	80004b56 <sys_unlink+0x1c4>
    iunlockput(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	330080e7          	jalr	816(ra) # 80002e6a <iunlockput>
  iunlockput(dp);
    80004b42:	8526                	mv	a0,s1
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	326080e7          	jalr	806(ra) # 80002e6a <iunlockput>
  end_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	adc080e7          	jalr	-1316(ra) # 80003628 <end_op>
  return -1;
    80004b54:	557d                	li	a0,-1
}
    80004b56:	70ae                	ld	ra,232(sp)
    80004b58:	740e                	ld	s0,224(sp)
    80004b5a:	64ee                	ld	s1,216(sp)
    80004b5c:	694e                	ld	s2,208(sp)
    80004b5e:	69ae                	ld	s3,200(sp)
    80004b60:	616d                	addi	sp,sp,240
    80004b62:	8082                	ret

0000000080004b64 <sys_open>:

uint64
sys_open(void)
{
    80004b64:	7131                	addi	sp,sp,-192
    80004b66:	fd06                	sd	ra,184(sp)
    80004b68:	f922                	sd	s0,176(sp)
    80004b6a:	f526                	sd	s1,168(sp)
    80004b6c:	f14a                	sd	s2,160(sp)
    80004b6e:	ed4e                	sd	s3,152(sp)
    80004b70:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004b72:	f4c40593          	addi	a1,s0,-180
    80004b76:	4505                	li	a0,1
    80004b78:	ffffd097          	auipc	ra,0xffffd
    80004b7c:	466080e7          	jalr	1126(ra) # 80001fde <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b80:	08000613          	li	a2,128
    80004b84:	f5040593          	addi	a1,s0,-176
    80004b88:	4501                	li	a0,0
    80004b8a:	ffffd097          	auipc	ra,0xffffd
    80004b8e:	494080e7          	jalr	1172(ra) # 8000201e <argstr>
    80004b92:	87aa                	mv	a5,a0
    return -1;
    80004b94:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004b96:	0a07c863          	bltz	a5,80004c46 <sys_open+0xe2>

  begin_op();
    80004b9a:	fffff097          	auipc	ra,0xfffff
    80004b9e:	a14080e7          	jalr	-1516(ra) # 800035ae <begin_op>

  if(omode & O_CREATE){
    80004ba2:	f4c42783          	lw	a5,-180(s0)
    80004ba6:	2007f793          	andi	a5,a5,512
    80004baa:	cbdd                	beqz	a5,80004c60 <sys_open+0xfc>
    ip = create(path, T_FILE, 0, 0);
    80004bac:	4681                	li	a3,0
    80004bae:	4601                	li	a2,0
    80004bb0:	4589                	li	a1,2
    80004bb2:	f5040513          	addi	a0,s0,-176
    80004bb6:	00000097          	auipc	ra,0x0
    80004bba:	97a080e7          	jalr	-1670(ra) # 80004530 <create>
    80004bbe:	84aa                	mv	s1,a0
    if(ip == 0){
    80004bc0:	c951                	beqz	a0,80004c54 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004bc2:	04449703          	lh	a4,68(s1)
    80004bc6:	478d                	li	a5,3
    80004bc8:	00f71763          	bne	a4,a5,80004bd6 <sys_open+0x72>
    80004bcc:	0464d703          	lhu	a4,70(s1)
    80004bd0:	47a5                	li	a5,9
    80004bd2:	0ce7ec63          	bltu	a5,a4,80004caa <sys_open+0x146>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004bd6:	fffff097          	auipc	ra,0xfffff
    80004bda:	de0080e7          	jalr	-544(ra) # 800039b6 <filealloc>
    80004bde:	892a                	mv	s2,a0
    80004be0:	c56d                	beqz	a0,80004cca <sys_open+0x166>
    80004be2:	00000097          	auipc	ra,0x0
    80004be6:	90c080e7          	jalr	-1780(ra) # 800044ee <fdalloc>
    80004bea:	89aa                	mv	s3,a0
    80004bec:	0c054a63          	bltz	a0,80004cc0 <sys_open+0x15c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004bf0:	04449703          	lh	a4,68(s1)
    80004bf4:	478d                	li	a5,3
    80004bf6:	0ef70563          	beq	a4,a5,80004ce0 <sys_open+0x17c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004bfa:	4789                	li	a5,2
    80004bfc:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004c00:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004c04:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004c08:	f4c42783          	lw	a5,-180(s0)
    80004c0c:	0017c713          	xori	a4,a5,1
    80004c10:	8b05                	andi	a4,a4,1
    80004c12:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004c16:	0037f713          	andi	a4,a5,3
    80004c1a:	00e03733          	snez	a4,a4
    80004c1e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004c22:	4007f793          	andi	a5,a5,1024
    80004c26:	c791                	beqz	a5,80004c32 <sys_open+0xce>
    80004c28:	04449703          	lh	a4,68(s1)
    80004c2c:	4789                	li	a5,2
    80004c2e:	0cf70063          	beq	a4,a5,80004cee <sys_open+0x18a>
    itrunc(ip);
  }

  iunlock(ip);
    80004c32:	8526                	mv	a0,s1
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	096080e7          	jalr	150(ra) # 80002cca <iunlock>
  end_op();
    80004c3c:	fffff097          	auipc	ra,0xfffff
    80004c40:	9ec080e7          	jalr	-1556(ra) # 80003628 <end_op>

  return fd;
    80004c44:	854e                	mv	a0,s3
}
    80004c46:	70ea                	ld	ra,184(sp)
    80004c48:	744a                	ld	s0,176(sp)
    80004c4a:	74aa                	ld	s1,168(sp)
    80004c4c:	790a                	ld	s2,160(sp)
    80004c4e:	69ea                	ld	s3,152(sp)
    80004c50:	6129                	addi	sp,sp,192
    80004c52:	8082                	ret
      end_op();
    80004c54:	fffff097          	auipc	ra,0xfffff
    80004c58:	9d4080e7          	jalr	-1580(ra) # 80003628 <end_op>
      return -1;
    80004c5c:	557d                	li	a0,-1
    80004c5e:	b7e5                	j	80004c46 <sys_open+0xe2>
    if((ip = namei(path)) == 0){
    80004c60:	f5040513          	addi	a0,s0,-176
    80004c64:	ffffe097          	auipc	ra,0xffffe
    80004c68:	74a080e7          	jalr	1866(ra) # 800033ae <namei>
    80004c6c:	84aa                	mv	s1,a0
    80004c6e:	c905                	beqz	a0,80004c9e <sys_open+0x13a>
    ilock(ip);
    80004c70:	ffffe097          	auipc	ra,0xffffe
    80004c74:	f98080e7          	jalr	-104(ra) # 80002c08 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004c78:	04449703          	lh	a4,68(s1)
    80004c7c:	4785                	li	a5,1
    80004c7e:	f4f712e3          	bne	a4,a5,80004bc2 <sys_open+0x5e>
    80004c82:	f4c42783          	lw	a5,-180(s0)
    80004c86:	dba1                	beqz	a5,80004bd6 <sys_open+0x72>
      iunlockput(ip);
    80004c88:	8526                	mv	a0,s1
    80004c8a:	ffffe097          	auipc	ra,0xffffe
    80004c8e:	1e0080e7          	jalr	480(ra) # 80002e6a <iunlockput>
      end_op();
    80004c92:	fffff097          	auipc	ra,0xfffff
    80004c96:	996080e7          	jalr	-1642(ra) # 80003628 <end_op>
      return -1;
    80004c9a:	557d                	li	a0,-1
    80004c9c:	b76d                	j	80004c46 <sys_open+0xe2>
      end_op();
    80004c9e:	fffff097          	auipc	ra,0xfffff
    80004ca2:	98a080e7          	jalr	-1654(ra) # 80003628 <end_op>
      return -1;
    80004ca6:	557d                	li	a0,-1
    80004ca8:	bf79                	j	80004c46 <sys_open+0xe2>
    iunlockput(ip);
    80004caa:	8526                	mv	a0,s1
    80004cac:	ffffe097          	auipc	ra,0xffffe
    80004cb0:	1be080e7          	jalr	446(ra) # 80002e6a <iunlockput>
    end_op();
    80004cb4:	fffff097          	auipc	ra,0xfffff
    80004cb8:	974080e7          	jalr	-1676(ra) # 80003628 <end_op>
    return -1;
    80004cbc:	557d                	li	a0,-1
    80004cbe:	b761                	j	80004c46 <sys_open+0xe2>
      fileclose(f);
    80004cc0:	854a                	mv	a0,s2
    80004cc2:	fffff097          	auipc	ra,0xfffff
    80004cc6:	db0080e7          	jalr	-592(ra) # 80003a72 <fileclose>
    iunlockput(ip);
    80004cca:	8526                	mv	a0,s1
    80004ccc:	ffffe097          	auipc	ra,0xffffe
    80004cd0:	19e080e7          	jalr	414(ra) # 80002e6a <iunlockput>
    end_op();
    80004cd4:	fffff097          	auipc	ra,0xfffff
    80004cd8:	954080e7          	jalr	-1708(ra) # 80003628 <end_op>
    return -1;
    80004cdc:	557d                	li	a0,-1
    80004cde:	b7a5                	j	80004c46 <sys_open+0xe2>
    f->type = FD_DEVICE;
    80004ce0:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80004ce4:	04649783          	lh	a5,70(s1)
    80004ce8:	02f91223          	sh	a5,36(s2)
    80004cec:	bf21                	j	80004c04 <sys_open+0xa0>
    itrunc(ip);
    80004cee:	8526                	mv	a0,s1
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	026080e7          	jalr	38(ra) # 80002d16 <itrunc>
    80004cf8:	bf2d                	j	80004c32 <sys_open+0xce>

0000000080004cfa <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004cfa:	7175                	addi	sp,sp,-144
    80004cfc:	e506                	sd	ra,136(sp)
    80004cfe:	e122                	sd	s0,128(sp)
    80004d00:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004d02:	fffff097          	auipc	ra,0xfffff
    80004d06:	8ac080e7          	jalr	-1876(ra) # 800035ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004d0a:	08000613          	li	a2,128
    80004d0e:	f7040593          	addi	a1,s0,-144
    80004d12:	4501                	li	a0,0
    80004d14:	ffffd097          	auipc	ra,0xffffd
    80004d18:	30a080e7          	jalr	778(ra) # 8000201e <argstr>
    80004d1c:	02054963          	bltz	a0,80004d4e <sys_mkdir+0x54>
    80004d20:	4681                	li	a3,0
    80004d22:	4601                	li	a2,0
    80004d24:	4585                	li	a1,1
    80004d26:	f7040513          	addi	a0,s0,-144
    80004d2a:	00000097          	auipc	ra,0x0
    80004d2e:	806080e7          	jalr	-2042(ra) # 80004530 <create>
    80004d32:	cd11                	beqz	a0,80004d4e <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004d34:	ffffe097          	auipc	ra,0xffffe
    80004d38:	136080e7          	jalr	310(ra) # 80002e6a <iunlockput>
  end_op();
    80004d3c:	fffff097          	auipc	ra,0xfffff
    80004d40:	8ec080e7          	jalr	-1812(ra) # 80003628 <end_op>
  return 0;
    80004d44:	4501                	li	a0,0
}
    80004d46:	60aa                	ld	ra,136(sp)
    80004d48:	640a                	ld	s0,128(sp)
    80004d4a:	6149                	addi	sp,sp,144
    80004d4c:	8082                	ret
    end_op();
    80004d4e:	fffff097          	auipc	ra,0xfffff
    80004d52:	8da080e7          	jalr	-1830(ra) # 80003628 <end_op>
    return -1;
    80004d56:	557d                	li	a0,-1
    80004d58:	b7fd                	j	80004d46 <sys_mkdir+0x4c>

0000000080004d5a <sys_mknod>:

uint64
sys_mknod(void)
{
    80004d5a:	7135                	addi	sp,sp,-160
    80004d5c:	ed06                	sd	ra,152(sp)
    80004d5e:	e922                	sd	s0,144(sp)
    80004d60:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004d62:	fffff097          	auipc	ra,0xfffff
    80004d66:	84c080e7          	jalr	-1972(ra) # 800035ae <begin_op>
  argint(1, &major);
    80004d6a:	f6c40593          	addi	a1,s0,-148
    80004d6e:	4505                	li	a0,1
    80004d70:	ffffd097          	auipc	ra,0xffffd
    80004d74:	26e080e7          	jalr	622(ra) # 80001fde <argint>
  argint(2, &minor);
    80004d78:	f6840593          	addi	a1,s0,-152
    80004d7c:	4509                	li	a0,2
    80004d7e:	ffffd097          	auipc	ra,0xffffd
    80004d82:	260080e7          	jalr	608(ra) # 80001fde <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004d86:	08000613          	li	a2,128
    80004d8a:	f7040593          	addi	a1,s0,-144
    80004d8e:	4501                	li	a0,0
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	28e080e7          	jalr	654(ra) # 8000201e <argstr>
    80004d98:	02054b63          	bltz	a0,80004dce <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004d9c:	f6841683          	lh	a3,-152(s0)
    80004da0:	f6c41603          	lh	a2,-148(s0)
    80004da4:	458d                	li	a1,3
    80004da6:	f7040513          	addi	a0,s0,-144
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	786080e7          	jalr	1926(ra) # 80004530 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004db2:	cd11                	beqz	a0,80004dce <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004db4:	ffffe097          	auipc	ra,0xffffe
    80004db8:	0b6080e7          	jalr	182(ra) # 80002e6a <iunlockput>
  end_op();
    80004dbc:	fffff097          	auipc	ra,0xfffff
    80004dc0:	86c080e7          	jalr	-1940(ra) # 80003628 <end_op>
  return 0;
    80004dc4:	4501                	li	a0,0
}
    80004dc6:	60ea                	ld	ra,152(sp)
    80004dc8:	644a                	ld	s0,144(sp)
    80004dca:	610d                	addi	sp,sp,160
    80004dcc:	8082                	ret
    end_op();
    80004dce:	fffff097          	auipc	ra,0xfffff
    80004dd2:	85a080e7          	jalr	-1958(ra) # 80003628 <end_op>
    return -1;
    80004dd6:	557d                	li	a0,-1
    80004dd8:	b7fd                	j	80004dc6 <sys_mknod+0x6c>

0000000080004dda <sys_chdir>:

uint64
sys_chdir(void)
{
    80004dda:	7135                	addi	sp,sp,-160
    80004ddc:	ed06                	sd	ra,152(sp)
    80004dde:	e922                	sd	s0,144(sp)
    80004de0:	e526                	sd	s1,136(sp)
    80004de2:	e14a                	sd	s2,128(sp)
    80004de4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004de6:	ffffc097          	auipc	ra,0xffffc
    80004dea:	0a4080e7          	jalr	164(ra) # 80000e8a <myproc>
    80004dee:	892a                	mv	s2,a0
  
  begin_op();
    80004df0:	ffffe097          	auipc	ra,0xffffe
    80004df4:	7be080e7          	jalr	1982(ra) # 800035ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004df8:	08000613          	li	a2,128
    80004dfc:	f6040593          	addi	a1,s0,-160
    80004e00:	4501                	li	a0,0
    80004e02:	ffffd097          	auipc	ra,0xffffd
    80004e06:	21c080e7          	jalr	540(ra) # 8000201e <argstr>
    80004e0a:	04054b63          	bltz	a0,80004e60 <sys_chdir+0x86>
    80004e0e:	f6040513          	addi	a0,s0,-160
    80004e12:	ffffe097          	auipc	ra,0xffffe
    80004e16:	59c080e7          	jalr	1436(ra) # 800033ae <namei>
    80004e1a:	84aa                	mv	s1,a0
    80004e1c:	c131                	beqz	a0,80004e60 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80004e1e:	ffffe097          	auipc	ra,0xffffe
    80004e22:	dea080e7          	jalr	-534(ra) # 80002c08 <ilock>
  if(ip->type != T_DIR){
    80004e26:	04449703          	lh	a4,68(s1)
    80004e2a:	4785                	li	a5,1
    80004e2c:	04f71063          	bne	a4,a5,80004e6c <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004e30:	8526                	mv	a0,s1
    80004e32:	ffffe097          	auipc	ra,0xffffe
    80004e36:	e98080e7          	jalr	-360(ra) # 80002cca <iunlock>
  iput(p->cwd);
    80004e3a:	15093503          	ld	a0,336(s2)
    80004e3e:	ffffe097          	auipc	ra,0xffffe
    80004e42:	f84080e7          	jalr	-124(ra) # 80002dc2 <iput>
  end_op();
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	7e2080e7          	jalr	2018(ra) # 80003628 <end_op>
  p->cwd = ip;
    80004e4e:	14993823          	sd	s1,336(s2)
  return 0;
    80004e52:	4501                	li	a0,0
}
    80004e54:	60ea                	ld	ra,152(sp)
    80004e56:	644a                	ld	s0,144(sp)
    80004e58:	64aa                	ld	s1,136(sp)
    80004e5a:	690a                	ld	s2,128(sp)
    80004e5c:	610d                	addi	sp,sp,160
    80004e5e:	8082                	ret
    end_op();
    80004e60:	ffffe097          	auipc	ra,0xffffe
    80004e64:	7c8080e7          	jalr	1992(ra) # 80003628 <end_op>
    return -1;
    80004e68:	557d                	li	a0,-1
    80004e6a:	b7ed                	j	80004e54 <sys_chdir+0x7a>
    iunlockput(ip);
    80004e6c:	8526                	mv	a0,s1
    80004e6e:	ffffe097          	auipc	ra,0xffffe
    80004e72:	ffc080e7          	jalr	-4(ra) # 80002e6a <iunlockput>
    end_op();
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	7b2080e7          	jalr	1970(ra) # 80003628 <end_op>
    return -1;
    80004e7e:	557d                	li	a0,-1
    80004e80:	bfd1                	j	80004e54 <sys_chdir+0x7a>

0000000080004e82 <sys_exec>:

uint64
sys_exec(void)
{
    80004e82:	7121                	addi	sp,sp,-448
    80004e84:	ff06                	sd	ra,440(sp)
    80004e86:	fb22                	sd	s0,432(sp)
    80004e88:	f726                	sd	s1,424(sp)
    80004e8a:	f34a                	sd	s2,416(sp)
    80004e8c:	ef4e                	sd	s3,408(sp)
    80004e8e:	eb52                	sd	s4,400(sp)
    80004e90:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004e92:	e4840593          	addi	a1,s0,-440
    80004e96:	4505                	li	a0,1
    80004e98:	ffffd097          	auipc	ra,0xffffd
    80004e9c:	166080e7          	jalr	358(ra) # 80001ffe <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004ea0:	08000613          	li	a2,128
    80004ea4:	f5040593          	addi	a1,s0,-176
    80004ea8:	4501                	li	a0,0
    80004eaa:	ffffd097          	auipc	ra,0xffffd
    80004eae:	174080e7          	jalr	372(ra) # 8000201e <argstr>
    80004eb2:	87aa                	mv	a5,a0
    return -1;
    80004eb4:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004eb6:	0c07c263          	bltz	a5,80004f7a <sys_exec+0xf8>
  }
  memset(argv, 0, sizeof(argv));
    80004eba:	10000613          	li	a2,256
    80004ebe:	4581                	li	a1,0
    80004ec0:	e5040513          	addi	a0,s0,-432
    80004ec4:	ffffb097          	auipc	ra,0xffffb
    80004ec8:	2ee080e7          	jalr	750(ra) # 800001b2 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004ecc:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80004ed0:	89a6                	mv	s3,s1
    80004ed2:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80004ed4:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ed8:	00391513          	slli	a0,s2,0x3
    80004edc:	e4040593          	addi	a1,s0,-448
    80004ee0:	e4843783          	ld	a5,-440(s0)
    80004ee4:	953e                	add	a0,a0,a5
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	05a080e7          	jalr	90(ra) # 80001f40 <fetchaddr>
    80004eee:	02054a63          	bltz	a0,80004f22 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80004ef2:	e4043783          	ld	a5,-448(s0)
    80004ef6:	c3b9                	beqz	a5,80004f3c <sys_exec+0xba>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80004ef8:	ffffb097          	auipc	ra,0xffffb
    80004efc:	232080e7          	jalr	562(ra) # 8000012a <kalloc>
    80004f00:	85aa                	mv	a1,a0
    80004f02:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004f06:	cd11                	beqz	a0,80004f22 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004f08:	6605                	lui	a2,0x1
    80004f0a:	e4043503          	ld	a0,-448(s0)
    80004f0e:	ffffd097          	auipc	ra,0xffffd
    80004f12:	084080e7          	jalr	132(ra) # 80001f92 <fetchstr>
    80004f16:	00054663          	bltz	a0,80004f22 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    80004f1a:	0905                	addi	s2,s2,1
    80004f1c:	09a1                	addi	s3,s3,8
    80004f1e:	fb491de3          	bne	s2,s4,80004ed8 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f22:	f5040913          	addi	s2,s0,-176
    80004f26:	6088                	ld	a0,0(s1)
    80004f28:	c921                	beqz	a0,80004f78 <sys_exec+0xf6>
    kfree(argv[i]);
    80004f2a:	ffffb097          	auipc	ra,0xffffb
    80004f2e:	0f2080e7          	jalr	242(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f32:	04a1                	addi	s1,s1,8
    80004f34:	ff2499e3          	bne	s1,s2,80004f26 <sys_exec+0xa4>
  return -1;
    80004f38:	557d                	li	a0,-1
    80004f3a:	a081                	j	80004f7a <sys_exec+0xf8>
      argv[i] = 0;
    80004f3c:	0009079b          	sext.w	a5,s2
    80004f40:	078e                	slli	a5,a5,0x3
    80004f42:	fd078793          	addi	a5,a5,-48
    80004f46:	97a2                	add	a5,a5,s0
    80004f48:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80004f4c:	e5040593          	addi	a1,s0,-432
    80004f50:	f5040513          	addi	a0,s0,-176
    80004f54:	fffff097          	auipc	ra,0xfffff
    80004f58:	194080e7          	jalr	404(ra) # 800040e8 <exec>
    80004f5c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f5e:	f5040993          	addi	s3,s0,-176
    80004f62:	6088                	ld	a0,0(s1)
    80004f64:	c901                	beqz	a0,80004f74 <sys_exec+0xf2>
    kfree(argv[i]);
    80004f66:	ffffb097          	auipc	ra,0xffffb
    80004f6a:	0b6080e7          	jalr	182(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004f6e:	04a1                	addi	s1,s1,8
    80004f70:	ff3499e3          	bne	s1,s3,80004f62 <sys_exec+0xe0>
  return ret;
    80004f74:	854a                	mv	a0,s2
    80004f76:	a011                	j	80004f7a <sys_exec+0xf8>
  return -1;
    80004f78:	557d                	li	a0,-1
}
    80004f7a:	70fa                	ld	ra,440(sp)
    80004f7c:	745a                	ld	s0,432(sp)
    80004f7e:	74ba                	ld	s1,424(sp)
    80004f80:	791a                	ld	s2,416(sp)
    80004f82:	69fa                	ld	s3,408(sp)
    80004f84:	6a5a                	ld	s4,400(sp)
    80004f86:	6139                	addi	sp,sp,448
    80004f88:	8082                	ret

0000000080004f8a <sys_pipe>:

uint64
sys_pipe(void)
{
    80004f8a:	7139                	addi	sp,sp,-64
    80004f8c:	fc06                	sd	ra,56(sp)
    80004f8e:	f822                	sd	s0,48(sp)
    80004f90:	f426                	sd	s1,40(sp)
    80004f92:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004f94:	ffffc097          	auipc	ra,0xffffc
    80004f98:	ef6080e7          	jalr	-266(ra) # 80000e8a <myproc>
    80004f9c:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004f9e:	fd840593          	addi	a1,s0,-40
    80004fa2:	4501                	li	a0,0
    80004fa4:	ffffd097          	auipc	ra,0xffffd
    80004fa8:	05a080e7          	jalr	90(ra) # 80001ffe <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004fac:	fc840593          	addi	a1,s0,-56
    80004fb0:	fd040513          	addi	a0,s0,-48
    80004fb4:	fffff097          	auipc	ra,0xfffff
    80004fb8:	dea080e7          	jalr	-534(ra) # 80003d9e <pipealloc>
    return -1;
    80004fbc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004fbe:	0c054463          	bltz	a0,80005086 <sys_pipe+0xfc>
  fd0 = -1;
    80004fc2:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004fc6:	fd043503          	ld	a0,-48(s0)
    80004fca:	fffff097          	auipc	ra,0xfffff
    80004fce:	524080e7          	jalr	1316(ra) # 800044ee <fdalloc>
    80004fd2:	fca42223          	sw	a0,-60(s0)
    80004fd6:	08054b63          	bltz	a0,8000506c <sys_pipe+0xe2>
    80004fda:	fc843503          	ld	a0,-56(s0)
    80004fde:	fffff097          	auipc	ra,0xfffff
    80004fe2:	510080e7          	jalr	1296(ra) # 800044ee <fdalloc>
    80004fe6:	fca42023          	sw	a0,-64(s0)
    80004fea:	06054863          	bltz	a0,8000505a <sys_pipe+0xd0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004fee:	4691                	li	a3,4
    80004ff0:	fc440613          	addi	a2,s0,-60
    80004ff4:	fd843583          	ld	a1,-40(s0)
    80004ff8:	68a8                	ld	a0,80(s1)
    80004ffa:	ffffc097          	auipc	ra,0xffffc
    80004ffe:	b50080e7          	jalr	-1200(ra) # 80000b4a <copyout>
    80005002:	02054063          	bltz	a0,80005022 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005006:	4691                	li	a3,4
    80005008:	fc040613          	addi	a2,s0,-64
    8000500c:	fd843583          	ld	a1,-40(s0)
    80005010:	0591                	addi	a1,a1,4
    80005012:	68a8                	ld	a0,80(s1)
    80005014:	ffffc097          	auipc	ra,0xffffc
    80005018:	b36080e7          	jalr	-1226(ra) # 80000b4a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000501c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000501e:	06055463          	bgez	a0,80005086 <sys_pipe+0xfc>
    p->ofile[fd0] = 0;
    80005022:	fc442783          	lw	a5,-60(s0)
    80005026:	07e9                	addi	a5,a5,26
    80005028:	078e                	slli	a5,a5,0x3
    8000502a:	97a6                	add	a5,a5,s1
    8000502c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005030:	fc042783          	lw	a5,-64(s0)
    80005034:	07e9                	addi	a5,a5,26
    80005036:	078e                	slli	a5,a5,0x3
    80005038:	94be                	add	s1,s1,a5
    8000503a:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    8000503e:	fd043503          	ld	a0,-48(s0)
    80005042:	fffff097          	auipc	ra,0xfffff
    80005046:	a30080e7          	jalr	-1488(ra) # 80003a72 <fileclose>
    fileclose(wf);
    8000504a:	fc843503          	ld	a0,-56(s0)
    8000504e:	fffff097          	auipc	ra,0xfffff
    80005052:	a24080e7          	jalr	-1500(ra) # 80003a72 <fileclose>
    return -1;
    80005056:	57fd                	li	a5,-1
    80005058:	a03d                	j	80005086 <sys_pipe+0xfc>
    if(fd0 >= 0)
    8000505a:	fc442783          	lw	a5,-60(s0)
    8000505e:	0007c763          	bltz	a5,8000506c <sys_pipe+0xe2>
      p->ofile[fd0] = 0;
    80005062:	07e9                	addi	a5,a5,26
    80005064:	078e                	slli	a5,a5,0x3
    80005066:	97a6                	add	a5,a5,s1
    80005068:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000506c:	fd043503          	ld	a0,-48(s0)
    80005070:	fffff097          	auipc	ra,0xfffff
    80005074:	a02080e7          	jalr	-1534(ra) # 80003a72 <fileclose>
    fileclose(wf);
    80005078:	fc843503          	ld	a0,-56(s0)
    8000507c:	fffff097          	auipc	ra,0xfffff
    80005080:	9f6080e7          	jalr	-1546(ra) # 80003a72 <fileclose>
    return -1;
    80005084:	57fd                	li	a5,-1
}
    80005086:	853e                	mv	a0,a5
    80005088:	70e2                	ld	ra,56(sp)
    8000508a:	7442                	ld	s0,48(sp)
    8000508c:	74a2                	ld	s1,40(sp)
    8000508e:	6121                	addi	sp,sp,64
    80005090:	8082                	ret
	...

00000000800050a0 <kernelvec>:
    800050a0:	7111                	addi	sp,sp,-256
    800050a2:	e006                	sd	ra,0(sp)
    800050a4:	e40a                	sd	sp,8(sp)
    800050a6:	e80e                	sd	gp,16(sp)
    800050a8:	ec12                	sd	tp,24(sp)
    800050aa:	f016                	sd	t0,32(sp)
    800050ac:	f41a                	sd	t1,40(sp)
    800050ae:	f81e                	sd	t2,48(sp)
    800050b0:	fc22                	sd	s0,56(sp)
    800050b2:	e0a6                	sd	s1,64(sp)
    800050b4:	e4aa                	sd	a0,72(sp)
    800050b6:	e8ae                	sd	a1,80(sp)
    800050b8:	ecb2                	sd	a2,88(sp)
    800050ba:	f0b6                	sd	a3,96(sp)
    800050bc:	f4ba                	sd	a4,104(sp)
    800050be:	f8be                	sd	a5,112(sp)
    800050c0:	fcc2                	sd	a6,120(sp)
    800050c2:	e146                	sd	a7,128(sp)
    800050c4:	e54a                	sd	s2,136(sp)
    800050c6:	e94e                	sd	s3,144(sp)
    800050c8:	ed52                	sd	s4,152(sp)
    800050ca:	f156                	sd	s5,160(sp)
    800050cc:	f55a                	sd	s6,168(sp)
    800050ce:	f95e                	sd	s7,176(sp)
    800050d0:	fd62                	sd	s8,184(sp)
    800050d2:	e1e6                	sd	s9,192(sp)
    800050d4:	e5ea                	sd	s10,200(sp)
    800050d6:	e9ee                	sd	s11,208(sp)
    800050d8:	edf2                	sd	t3,216(sp)
    800050da:	f1f6                	sd	t4,224(sp)
    800050dc:	f5fa                	sd	t5,232(sp)
    800050de:	f9fe                	sd	t6,240(sp)
    800050e0:	d2dfc0ef          	jal	ra,80001e0c <kerneltrap>
    800050e4:	6082                	ld	ra,0(sp)
    800050e6:	6122                	ld	sp,8(sp)
    800050e8:	61c2                	ld	gp,16(sp)
    800050ea:	7282                	ld	t0,32(sp)
    800050ec:	7322                	ld	t1,40(sp)
    800050ee:	73c2                	ld	t2,48(sp)
    800050f0:	7462                	ld	s0,56(sp)
    800050f2:	6486                	ld	s1,64(sp)
    800050f4:	6526                	ld	a0,72(sp)
    800050f6:	65c6                	ld	a1,80(sp)
    800050f8:	6666                	ld	a2,88(sp)
    800050fa:	7686                	ld	a3,96(sp)
    800050fc:	7726                	ld	a4,104(sp)
    800050fe:	77c6                	ld	a5,112(sp)
    80005100:	7866                	ld	a6,120(sp)
    80005102:	688a                	ld	a7,128(sp)
    80005104:	692a                	ld	s2,136(sp)
    80005106:	69ca                	ld	s3,144(sp)
    80005108:	6a6a                	ld	s4,152(sp)
    8000510a:	7a8a                	ld	s5,160(sp)
    8000510c:	7b2a                	ld	s6,168(sp)
    8000510e:	7bca                	ld	s7,176(sp)
    80005110:	7c6a                	ld	s8,184(sp)
    80005112:	6c8e                	ld	s9,192(sp)
    80005114:	6d2e                	ld	s10,200(sp)
    80005116:	6dce                	ld	s11,208(sp)
    80005118:	6e6e                	ld	t3,216(sp)
    8000511a:	7e8e                	ld	t4,224(sp)
    8000511c:	7f2e                	ld	t5,232(sp)
    8000511e:	7fce                	ld	t6,240(sp)
    80005120:	6111                	addi	sp,sp,256
    80005122:	10200073          	sret
    80005126:	00000013          	nop
    8000512a:	00000013          	nop
    8000512e:	0001                	nop

0000000080005130 <timervec>:
    80005130:	34051573          	csrrw	a0,mscratch,a0
    80005134:	e10c                	sd	a1,0(a0)
    80005136:	e510                	sd	a2,8(a0)
    80005138:	e914                	sd	a3,16(a0)
    8000513a:	6d0c                	ld	a1,24(a0)
    8000513c:	7110                	ld	a2,32(a0)
    8000513e:	6194                	ld	a3,0(a1)
    80005140:	96b2                	add	a3,a3,a2
    80005142:	e194                	sd	a3,0(a1)
    80005144:	4589                	li	a1,2
    80005146:	14459073          	csrw	sip,a1
    8000514a:	6914                	ld	a3,16(a0)
    8000514c:	6510                	ld	a2,8(a0)
    8000514e:	610c                	ld	a1,0(a0)
    80005150:	34051573          	csrrw	a0,mscratch,a0
    80005154:	30200073          	mret
	...

000000008000515a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000515a:	1141                	addi	sp,sp,-16
    8000515c:	e422                	sd	s0,8(sp)
    8000515e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005160:	0c0007b7          	lui	a5,0xc000
    80005164:	4705                	li	a4,1
    80005166:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005168:	c3d8                	sw	a4,4(a5)
}
    8000516a:	6422                	ld	s0,8(sp)
    8000516c:	0141                	addi	sp,sp,16
    8000516e:	8082                	ret

0000000080005170 <plicinithart>:

void
plicinithart(void)
{
    80005170:	1141                	addi	sp,sp,-16
    80005172:	e406                	sd	ra,8(sp)
    80005174:	e022                	sd	s0,0(sp)
    80005176:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005178:	ffffc097          	auipc	ra,0xffffc
    8000517c:	ce6080e7          	jalr	-794(ra) # 80000e5e <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005180:	0085171b          	slliw	a4,a0,0x8
    80005184:	0c0027b7          	lui	a5,0xc002
    80005188:	97ba                	add	a5,a5,a4
    8000518a:	40200713          	li	a4,1026
    8000518e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005192:	00d5151b          	slliw	a0,a0,0xd
    80005196:	0c2017b7          	lui	a5,0xc201
    8000519a:	97aa                	add	a5,a5,a0
    8000519c:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret

00000000800051a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800051a8:	1141                	addi	sp,sp,-16
    800051aa:	e406                	sd	ra,8(sp)
    800051ac:	e022                	sd	s0,0(sp)
    800051ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800051b0:	ffffc097          	auipc	ra,0xffffc
    800051b4:	cae080e7          	jalr	-850(ra) # 80000e5e <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800051b8:	00d5151b          	slliw	a0,a0,0xd
    800051bc:	0c2017b7          	lui	a5,0xc201
    800051c0:	97aa                	add	a5,a5,a0
  return irq;
}
    800051c2:	43c8                	lw	a0,4(a5)
    800051c4:	60a2                	ld	ra,8(sp)
    800051c6:	6402                	ld	s0,0(sp)
    800051c8:	0141                	addi	sp,sp,16
    800051ca:	8082                	ret

00000000800051cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800051cc:	1101                	addi	sp,sp,-32
    800051ce:	ec06                	sd	ra,24(sp)
    800051d0:	e822                	sd	s0,16(sp)
    800051d2:	e426                	sd	s1,8(sp)
    800051d4:	1000                	addi	s0,sp,32
    800051d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800051d8:	ffffc097          	auipc	ra,0xffffc
    800051dc:	c86080e7          	jalr	-890(ra) # 80000e5e <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800051e0:	00d5151b          	slliw	a0,a0,0xd
    800051e4:	0c2017b7          	lui	a5,0xc201
    800051e8:	97aa                	add	a5,a5,a0
    800051ea:	c3c4                	sw	s1,4(a5)
}
    800051ec:	60e2                	ld	ra,24(sp)
    800051ee:	6442                	ld	s0,16(sp)
    800051f0:	64a2                	ld	s1,8(sp)
    800051f2:	6105                	addi	sp,sp,32
    800051f4:	8082                	ret

00000000800051f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800051f6:	1141                	addi	sp,sp,-16
    800051f8:	e406                	sd	ra,8(sp)
    800051fa:	e022                	sd	s0,0(sp)
    800051fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800051fe:	479d                	li	a5,7
    80005200:	04a7cc63          	blt	a5,a0,80005258 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005204:	00015797          	auipc	a5,0x15
    80005208:	bfc78793          	addi	a5,a5,-1028 # 80019e00 <disk>
    8000520c:	97aa                	add	a5,a5,a0
    8000520e:	0187c783          	lbu	a5,24(a5)
    80005212:	ebb9                	bnez	a5,80005268 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005214:	00451693          	slli	a3,a0,0x4
    80005218:	00015797          	auipc	a5,0x15
    8000521c:	be878793          	addi	a5,a5,-1048 # 80019e00 <disk>
    80005220:	6398                	ld	a4,0(a5)
    80005222:	9736                	add	a4,a4,a3
    80005224:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005228:	6398                	ld	a4,0(a5)
    8000522a:	9736                	add	a4,a4,a3
    8000522c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005230:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005234:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005238:	97aa                	add	a5,a5,a0
    8000523a:	4705                	li	a4,1
    8000523c:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005240:	00015517          	auipc	a0,0x15
    80005244:	bd850513          	addi	a0,a0,-1064 # 80019e18 <disk+0x18>
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	356080e7          	jalr	854(ra) # 8000159e <wakeup>
}
    80005250:	60a2                	ld	ra,8(sp)
    80005252:	6402                	ld	s0,0(sp)
    80005254:	0141                	addi	sp,sp,16
    80005256:	8082                	ret
    panic("free_desc 1");
    80005258:	00003517          	auipc	a0,0x3
    8000525c:	6b850513          	addi	a0,a0,1720 # 80008910 <syscallNames+0x2f8>
    80005260:	00001097          	auipc	ra,0x1
    80005264:	a06080e7          	jalr	-1530(ra) # 80005c66 <panic>
    panic("free_desc 2");
    80005268:	00003517          	auipc	a0,0x3
    8000526c:	6b850513          	addi	a0,a0,1720 # 80008920 <syscallNames+0x308>
    80005270:	00001097          	auipc	ra,0x1
    80005274:	9f6080e7          	jalr	-1546(ra) # 80005c66 <panic>

0000000080005278 <virtio_disk_init>:
{
    80005278:	1101                	addi	sp,sp,-32
    8000527a:	ec06                	sd	ra,24(sp)
    8000527c:	e822                	sd	s0,16(sp)
    8000527e:	e426                	sd	s1,8(sp)
    80005280:	e04a                	sd	s2,0(sp)
    80005282:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005284:	00003597          	auipc	a1,0x3
    80005288:	6ac58593          	addi	a1,a1,1708 # 80008930 <syscallNames+0x318>
    8000528c:	00015517          	auipc	a0,0x15
    80005290:	c9c50513          	addi	a0,a0,-868 # 80019f28 <disk+0x128>
    80005294:	00001097          	auipc	ra,0x1
    80005298:	e7a080e7          	jalr	-390(ra) # 8000610e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000529c:	100017b7          	lui	a5,0x10001
    800052a0:	4398                	lw	a4,0(a5)
    800052a2:	2701                	sext.w	a4,a4
    800052a4:	747277b7          	lui	a5,0x74727
    800052a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800052ac:	14f71b63          	bne	a4,a5,80005402 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052b0:	100017b7          	lui	a5,0x10001
    800052b4:	43dc                	lw	a5,4(a5)
    800052b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800052b8:	4709                	li	a4,2
    800052ba:	14e79463          	bne	a5,a4,80005402 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052be:	100017b7          	lui	a5,0x10001
    800052c2:	479c                	lw	a5,8(a5)
    800052c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800052c6:	12e79e63          	bne	a5,a4,80005402 <virtio_disk_init+0x18a>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800052ca:	100017b7          	lui	a5,0x10001
    800052ce:	47d8                	lw	a4,12(a5)
    800052d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800052d2:	554d47b7          	lui	a5,0x554d4
    800052d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800052da:	12f71463          	bne	a4,a5,80005402 <virtio_disk_init+0x18a>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052de:	100017b7          	lui	a5,0x10001
    800052e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800052e6:	4705                	li	a4,1
    800052e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052ea:	470d                	li	a4,3
    800052ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800052ee:	4b98                	lw	a4,16(a5)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800052f0:	c7ffe6b7          	lui	a3,0xc7ffe
    800052f4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc5df>
    800052f8:	8f75                	and	a4,a4,a3
    800052fa:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800052fc:	472d                	li	a4,11
    800052fe:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005300:	5bbc                	lw	a5,112(a5)
    80005302:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005306:	8ba1                	andi	a5,a5,8
    80005308:	10078563          	beqz	a5,80005412 <virtio_disk_init+0x19a>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000530c:	100017b7          	lui	a5,0x10001
    80005310:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005314:	43fc                	lw	a5,68(a5)
    80005316:	2781                	sext.w	a5,a5
    80005318:	10079563          	bnez	a5,80005422 <virtio_disk_init+0x1aa>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000531c:	100017b7          	lui	a5,0x10001
    80005320:	5bdc                	lw	a5,52(a5)
    80005322:	2781                	sext.w	a5,a5
  if(max == 0)
    80005324:	10078763          	beqz	a5,80005432 <virtio_disk_init+0x1ba>
  if(max < NUM)
    80005328:	471d                	li	a4,7
    8000532a:	10f77c63          	bgeu	a4,a5,80005442 <virtio_disk_init+0x1ca>
  disk.desc = kalloc();
    8000532e:	ffffb097          	auipc	ra,0xffffb
    80005332:	dfc080e7          	jalr	-516(ra) # 8000012a <kalloc>
    80005336:	00015497          	auipc	s1,0x15
    8000533a:	aca48493          	addi	s1,s1,-1334 # 80019e00 <disk>
    8000533e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005340:	ffffb097          	auipc	ra,0xffffb
    80005344:	dea080e7          	jalr	-534(ra) # 8000012a <kalloc>
    80005348:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000534a:	ffffb097          	auipc	ra,0xffffb
    8000534e:	de0080e7          	jalr	-544(ra) # 8000012a <kalloc>
    80005352:	87aa                	mv	a5,a0
    80005354:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005356:	6088                	ld	a0,0(s1)
    80005358:	cd6d                	beqz	a0,80005452 <virtio_disk_init+0x1da>
    8000535a:	00015717          	auipc	a4,0x15
    8000535e:	aae73703          	ld	a4,-1362(a4) # 80019e08 <disk+0x8>
    80005362:	cb65                	beqz	a4,80005452 <virtio_disk_init+0x1da>
    80005364:	c7fd                	beqz	a5,80005452 <virtio_disk_init+0x1da>
  memset(disk.desc, 0, PGSIZE);
    80005366:	6605                	lui	a2,0x1
    80005368:	4581                	li	a1,0
    8000536a:	ffffb097          	auipc	ra,0xffffb
    8000536e:	e48080e7          	jalr	-440(ra) # 800001b2 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005372:	00015497          	auipc	s1,0x15
    80005376:	a8e48493          	addi	s1,s1,-1394 # 80019e00 <disk>
    8000537a:	6605                	lui	a2,0x1
    8000537c:	4581                	li	a1,0
    8000537e:	6488                	ld	a0,8(s1)
    80005380:	ffffb097          	auipc	ra,0xffffb
    80005384:	e32080e7          	jalr	-462(ra) # 800001b2 <memset>
  memset(disk.used, 0, PGSIZE);
    80005388:	6605                	lui	a2,0x1
    8000538a:	4581                	li	a1,0
    8000538c:	6888                	ld	a0,16(s1)
    8000538e:	ffffb097          	auipc	ra,0xffffb
    80005392:	e24080e7          	jalr	-476(ra) # 800001b2 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005396:	100017b7          	lui	a5,0x10001
    8000539a:	4721                	li	a4,8
    8000539c:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000539e:	4098                	lw	a4,0(s1)
    800053a0:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800053a4:	40d8                	lw	a4,4(s1)
    800053a6:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800053aa:	6498                	ld	a4,8(s1)
    800053ac:	0007069b          	sext.w	a3,a4
    800053b0:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800053b4:	9701                	srai	a4,a4,0x20
    800053b6:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800053ba:	6898                	ld	a4,16(s1)
    800053bc:	0007069b          	sext.w	a3,a4
    800053c0:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800053c4:	9701                	srai	a4,a4,0x20
    800053c6:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800053ca:	4705                	li	a4,1
    800053cc:	c3f8                	sw	a4,68(a5)
    disk.free[i] = 1;
    800053ce:	00e48c23          	sb	a4,24(s1)
    800053d2:	00e48ca3          	sb	a4,25(s1)
    800053d6:	00e48d23          	sb	a4,26(s1)
    800053da:	00e48da3          	sb	a4,27(s1)
    800053de:	00e48e23          	sb	a4,28(s1)
    800053e2:	00e48ea3          	sb	a4,29(s1)
    800053e6:	00e48f23          	sb	a4,30(s1)
    800053ea:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800053ee:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800053f2:	0727a823          	sw	s2,112(a5)
}
    800053f6:	60e2                	ld	ra,24(sp)
    800053f8:	6442                	ld	s0,16(sp)
    800053fa:	64a2                	ld	s1,8(sp)
    800053fc:	6902                	ld	s2,0(sp)
    800053fe:	6105                	addi	sp,sp,32
    80005400:	8082                	ret
    panic("could not find virtio disk");
    80005402:	00003517          	auipc	a0,0x3
    80005406:	53e50513          	addi	a0,a0,1342 # 80008940 <syscallNames+0x328>
    8000540a:	00001097          	auipc	ra,0x1
    8000540e:	85c080e7          	jalr	-1956(ra) # 80005c66 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005412:	00003517          	auipc	a0,0x3
    80005416:	54e50513          	addi	a0,a0,1358 # 80008960 <syscallNames+0x348>
    8000541a:	00001097          	auipc	ra,0x1
    8000541e:	84c080e7          	jalr	-1972(ra) # 80005c66 <panic>
    panic("virtio disk should not be ready");
    80005422:	00003517          	auipc	a0,0x3
    80005426:	55e50513          	addi	a0,a0,1374 # 80008980 <syscallNames+0x368>
    8000542a:	00001097          	auipc	ra,0x1
    8000542e:	83c080e7          	jalr	-1988(ra) # 80005c66 <panic>
    panic("virtio disk has no queue 0");
    80005432:	00003517          	auipc	a0,0x3
    80005436:	56e50513          	addi	a0,a0,1390 # 800089a0 <syscallNames+0x388>
    8000543a:	00001097          	auipc	ra,0x1
    8000543e:	82c080e7          	jalr	-2004(ra) # 80005c66 <panic>
    panic("virtio disk max queue too short");
    80005442:	00003517          	auipc	a0,0x3
    80005446:	57e50513          	addi	a0,a0,1406 # 800089c0 <syscallNames+0x3a8>
    8000544a:	00001097          	auipc	ra,0x1
    8000544e:	81c080e7          	jalr	-2020(ra) # 80005c66 <panic>
    panic("virtio disk kalloc");
    80005452:	00003517          	auipc	a0,0x3
    80005456:	58e50513          	addi	a0,a0,1422 # 800089e0 <syscallNames+0x3c8>
    8000545a:	00001097          	auipc	ra,0x1
    8000545e:	80c080e7          	jalr	-2036(ra) # 80005c66 <panic>

0000000080005462 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005462:	7159                	addi	sp,sp,-112
    80005464:	f486                	sd	ra,104(sp)
    80005466:	f0a2                	sd	s0,96(sp)
    80005468:	eca6                	sd	s1,88(sp)
    8000546a:	e8ca                	sd	s2,80(sp)
    8000546c:	e4ce                	sd	s3,72(sp)
    8000546e:	e0d2                	sd	s4,64(sp)
    80005470:	fc56                	sd	s5,56(sp)
    80005472:	f85a                	sd	s6,48(sp)
    80005474:	f45e                	sd	s7,40(sp)
    80005476:	f062                	sd	s8,32(sp)
    80005478:	ec66                	sd	s9,24(sp)
    8000547a:	e86a                	sd	s10,16(sp)
    8000547c:	1880                	addi	s0,sp,112
    8000547e:	8a2a                	mv	s4,a0
    80005480:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005482:	00c52c83          	lw	s9,12(a0)
    80005486:	001c9c9b          	slliw	s9,s9,0x1
    8000548a:	1c82                	slli	s9,s9,0x20
    8000548c:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005490:	00015517          	auipc	a0,0x15
    80005494:	a9850513          	addi	a0,a0,-1384 # 80019f28 <disk+0x128>
    80005498:	00001097          	auipc	ra,0x1
    8000549c:	d06080e7          	jalr	-762(ra) # 8000619e <acquire>
  for(int i = 0; i < 3; i++){
    800054a0:	4901                	li	s2,0
  for(int i = 0; i < NUM; i++){
    800054a2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800054a4:	00015b17          	auipc	s6,0x15
    800054a8:	95cb0b13          	addi	s6,s6,-1700 # 80019e00 <disk>
  for(int i = 0; i < 3; i++){
    800054ac:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800054ae:	00015c17          	auipc	s8,0x15
    800054b2:	a7ac0c13          	addi	s8,s8,-1414 # 80019f28 <disk+0x128>
    800054b6:	a095                	j	8000551a <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800054b8:	00fb0733          	add	a4,s6,a5
    800054bc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800054c0:	c11c                	sw	a5,0(a0)
    if(idx[i] < 0){
    800054c2:	0207c563          	bltz	a5,800054ec <virtio_disk_rw+0x8a>
  for(int i = 0; i < 3; i++){
    800054c6:	2605                	addiw	a2,a2,1 # 1001 <_entry-0x7fffefff>
    800054c8:	0591                	addi	a1,a1,4
    800054ca:	05560d63          	beq	a2,s5,80005524 <virtio_disk_rw+0xc2>
    idx[i] = alloc_desc();
    800054ce:	852e                	mv	a0,a1
  for(int i = 0; i < NUM; i++){
    800054d0:	00015717          	auipc	a4,0x15
    800054d4:	93070713          	addi	a4,a4,-1744 # 80019e00 <disk>
    800054d8:	87ca                	mv	a5,s2
    if(disk.free[i]){
    800054da:	01874683          	lbu	a3,24(a4)
    800054de:	fee9                	bnez	a3,800054b8 <virtio_disk_rw+0x56>
  for(int i = 0; i < NUM; i++){
    800054e0:	2785                	addiw	a5,a5,1
    800054e2:	0705                	addi	a4,a4,1
    800054e4:	fe979be3          	bne	a5,s1,800054da <virtio_disk_rw+0x78>
    idx[i] = alloc_desc();
    800054e8:	57fd                	li	a5,-1
    800054ea:	c11c                	sw	a5,0(a0)
      for(int j = 0; j < i; j++)
    800054ec:	00c05e63          	blez	a2,80005508 <virtio_disk_rw+0xa6>
    800054f0:	060a                	slli	a2,a2,0x2
    800054f2:	01360d33          	add	s10,a2,s3
        free_desc(idx[j]);
    800054f6:	0009a503          	lw	a0,0(s3)
    800054fa:	00000097          	auipc	ra,0x0
    800054fe:	cfc080e7          	jalr	-772(ra) # 800051f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005502:	0991                	addi	s3,s3,4
    80005504:	ffa999e3          	bne	s3,s10,800054f6 <virtio_disk_rw+0x94>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005508:	85e2                	mv	a1,s8
    8000550a:	00015517          	auipc	a0,0x15
    8000550e:	90e50513          	addi	a0,a0,-1778 # 80019e18 <disk+0x18>
    80005512:	ffffc097          	auipc	ra,0xffffc
    80005516:	028080e7          	jalr	40(ra) # 8000153a <sleep>
  for(int i = 0; i < 3; i++){
    8000551a:	f9040993          	addi	s3,s0,-112
{
    8000551e:	85ce                	mv	a1,s3
  for(int i = 0; i < 3; i++){
    80005520:	864a                	mv	a2,s2
    80005522:	b775                	j	800054ce <virtio_disk_rw+0x6c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005524:	f9042503          	lw	a0,-112(s0)
    80005528:	00a50713          	addi	a4,a0,10
    8000552c:	0712                	slli	a4,a4,0x4

  if(write)
    8000552e:	00015797          	auipc	a5,0x15
    80005532:	8d278793          	addi	a5,a5,-1838 # 80019e00 <disk>
    80005536:	00e786b3          	add	a3,a5,a4
    8000553a:	01703633          	snez	a2,s7
    8000553e:	c690                	sw	a2,8(a3)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005540:	0006a623          	sw	zero,12(a3)
  buf0->sector = sector;
    80005544:	0196b823          	sd	s9,16(a3)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005548:	f6070613          	addi	a2,a4,-160
    8000554c:	6394                	ld	a3,0(a5)
    8000554e:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005550:	00870593          	addi	a1,a4,8
    80005554:	95be                	add	a1,a1,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005556:	e28c                	sd	a1,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005558:	0007b803          	ld	a6,0(a5)
    8000555c:	9642                	add	a2,a2,a6
    8000555e:	46c1                	li	a3,16
    80005560:	c614                	sw	a3,8(a2)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005562:	4585                	li	a1,1
    80005564:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[0]].next = idx[1];
    80005568:	f9442683          	lw	a3,-108(s0)
    8000556c:	00d61723          	sh	a3,14(a2)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005570:	0692                	slli	a3,a3,0x4
    80005572:	9836                	add	a6,a6,a3
    80005574:	058a0613          	addi	a2,s4,88
    80005578:	00c83023          	sd	a2,0(a6)
  disk.desc[idx[1]].len = BSIZE;
    8000557c:	0007b803          	ld	a6,0(a5)
    80005580:	96c2                	add	a3,a3,a6
    80005582:	40000613          	li	a2,1024
    80005586:	c690                	sw	a2,8(a3)
  if(write)
    80005588:	001bb613          	seqz	a2,s7
    8000558c:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005590:	00166613          	ori	a2,a2,1
    80005594:	00c69623          	sh	a2,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005598:	f9842603          	lw	a2,-104(s0)
    8000559c:	00c69723          	sh	a2,14(a3)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800055a0:	00250693          	addi	a3,a0,2
    800055a4:	0692                	slli	a3,a3,0x4
    800055a6:	96be                	add	a3,a3,a5
    800055a8:	58fd                	li	a7,-1
    800055aa:	01168823          	sb	a7,16(a3)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800055ae:	0612                	slli	a2,a2,0x4
    800055b0:	9832                	add	a6,a6,a2
    800055b2:	f9070713          	addi	a4,a4,-112
    800055b6:	973e                	add	a4,a4,a5
    800055b8:	00e83023          	sd	a4,0(a6)
  disk.desc[idx[2]].len = 1;
    800055bc:	6398                	ld	a4,0(a5)
    800055be:	9732                	add	a4,a4,a2
    800055c0:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800055c2:	4609                	li	a2,2
    800055c4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[2]].next = 0;
    800055c8:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800055cc:	00ba2223          	sw	a1,4(s4)
  disk.info[idx[0]].b = b;
    800055d0:	0146b423          	sd	s4,8(a3)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800055d4:	6794                	ld	a3,8(a5)
    800055d6:	0026d703          	lhu	a4,2(a3)
    800055da:	8b1d                	andi	a4,a4,7
    800055dc:	0706                	slli	a4,a4,0x1
    800055de:	96ba                	add	a3,a3,a4
    800055e0:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800055e4:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800055e8:	6798                	ld	a4,8(a5)
    800055ea:	00275783          	lhu	a5,2(a4)
    800055ee:	2785                	addiw	a5,a5,1
    800055f0:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800055f4:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005600:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005604:	00015917          	auipc	s2,0x15
    80005608:	92490913          	addi	s2,s2,-1756 # 80019f28 <disk+0x128>
  while(b->disk == 1) {
    8000560c:	4485                	li	s1,1
    8000560e:	00b79c63          	bne	a5,a1,80005626 <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80005612:	85ca                	mv	a1,s2
    80005614:	8552                	mv	a0,s4
    80005616:	ffffc097          	auipc	ra,0xffffc
    8000561a:	f24080e7          	jalr	-220(ra) # 8000153a <sleep>
  while(b->disk == 1) {
    8000561e:	004a2783          	lw	a5,4(s4)
    80005622:	fe9788e3          	beq	a5,s1,80005612 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80005626:	f9042903          	lw	s2,-112(s0)
    8000562a:	00290713          	addi	a4,s2,2
    8000562e:	0712                	slli	a4,a4,0x4
    80005630:	00014797          	auipc	a5,0x14
    80005634:	7d078793          	addi	a5,a5,2000 # 80019e00 <disk>
    80005638:	97ba                	add	a5,a5,a4
    8000563a:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000563e:	00014997          	auipc	s3,0x14
    80005642:	7c298993          	addi	s3,s3,1986 # 80019e00 <disk>
    80005646:	00491713          	slli	a4,s2,0x4
    8000564a:	0009b783          	ld	a5,0(s3)
    8000564e:	97ba                	add	a5,a5,a4
    80005650:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005654:	854a                	mv	a0,s2
    80005656:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    8000565a:	00000097          	auipc	ra,0x0
    8000565e:	b9c080e7          	jalr	-1124(ra) # 800051f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005662:	8885                	andi	s1,s1,1
    80005664:	f0ed                	bnez	s1,80005646 <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005666:	00015517          	auipc	a0,0x15
    8000566a:	8c250513          	addi	a0,a0,-1854 # 80019f28 <disk+0x128>
    8000566e:	00001097          	auipc	ra,0x1
    80005672:	be4080e7          	jalr	-1052(ra) # 80006252 <release>
}
    80005676:	70a6                	ld	ra,104(sp)
    80005678:	7406                	ld	s0,96(sp)
    8000567a:	64e6                	ld	s1,88(sp)
    8000567c:	6946                	ld	s2,80(sp)
    8000567e:	69a6                	ld	s3,72(sp)
    80005680:	6a06                	ld	s4,64(sp)
    80005682:	7ae2                	ld	s5,56(sp)
    80005684:	7b42                	ld	s6,48(sp)
    80005686:	7ba2                	ld	s7,40(sp)
    80005688:	7c02                	ld	s8,32(sp)
    8000568a:	6ce2                	ld	s9,24(sp)
    8000568c:	6d42                	ld	s10,16(sp)
    8000568e:	6165                	addi	sp,sp,112
    80005690:	8082                	ret

0000000080005692 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005692:	1101                	addi	sp,sp,-32
    80005694:	ec06                	sd	ra,24(sp)
    80005696:	e822                	sd	s0,16(sp)
    80005698:	e426                	sd	s1,8(sp)
    8000569a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000569c:	00014497          	auipc	s1,0x14
    800056a0:	76448493          	addi	s1,s1,1892 # 80019e00 <disk>
    800056a4:	00015517          	auipc	a0,0x15
    800056a8:	88450513          	addi	a0,a0,-1916 # 80019f28 <disk+0x128>
    800056ac:	00001097          	auipc	ra,0x1
    800056b0:	af2080e7          	jalr	-1294(ra) # 8000619e <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800056b4:	10001737          	lui	a4,0x10001
    800056b8:	533c                	lw	a5,96(a4)
    800056ba:	8b8d                	andi	a5,a5,3
    800056bc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800056be:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800056c2:	689c                	ld	a5,16(s1)
    800056c4:	0204d703          	lhu	a4,32(s1)
    800056c8:	0027d783          	lhu	a5,2(a5)
    800056cc:	04f70863          	beq	a4,a5,8000571c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800056d0:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800056d4:	6898                	ld	a4,16(s1)
    800056d6:	0204d783          	lhu	a5,32(s1)
    800056da:	8b9d                	andi	a5,a5,7
    800056dc:	078e                	slli	a5,a5,0x3
    800056de:	97ba                	add	a5,a5,a4
    800056e0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800056e2:	00278713          	addi	a4,a5,2
    800056e6:	0712                	slli	a4,a4,0x4
    800056e8:	9726                	add	a4,a4,s1
    800056ea:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800056ee:	e721                	bnez	a4,80005736 <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800056f0:	0789                	addi	a5,a5,2
    800056f2:	0792                	slli	a5,a5,0x4
    800056f4:	97a6                	add	a5,a5,s1
    800056f6:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800056f8:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800056fc:	ffffc097          	auipc	ra,0xffffc
    80005700:	ea2080e7          	jalr	-350(ra) # 8000159e <wakeup>

    disk.used_idx += 1;
    80005704:	0204d783          	lhu	a5,32(s1)
    80005708:	2785                	addiw	a5,a5,1
    8000570a:	17c2                	slli	a5,a5,0x30
    8000570c:	93c1                	srli	a5,a5,0x30
    8000570e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005712:	6898                	ld	a4,16(s1)
    80005714:	00275703          	lhu	a4,2(a4)
    80005718:	faf71ce3          	bne	a4,a5,800056d0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000571c:	00015517          	auipc	a0,0x15
    80005720:	80c50513          	addi	a0,a0,-2036 # 80019f28 <disk+0x128>
    80005724:	00001097          	auipc	ra,0x1
    80005728:	b2e080e7          	jalr	-1234(ra) # 80006252 <release>
}
    8000572c:	60e2                	ld	ra,24(sp)
    8000572e:	6442                	ld	s0,16(sp)
    80005730:	64a2                	ld	s1,8(sp)
    80005732:	6105                	addi	sp,sp,32
    80005734:	8082                	ret
      panic("virtio_disk_intr status");
    80005736:	00003517          	auipc	a0,0x3
    8000573a:	2c250513          	addi	a0,a0,706 # 800089f8 <syscallNames+0x3e0>
    8000573e:	00000097          	auipc	ra,0x0
    80005742:	528080e7          	jalr	1320(ra) # 80005c66 <panic>

0000000080005746 <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005746:	1141                	addi	sp,sp,-16
    80005748:	e422                	sd	s0,8(sp)
    8000574a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000574c:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005750:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005754:	0037979b          	slliw	a5,a5,0x3
    80005758:	02004737          	lui	a4,0x2004
    8000575c:	97ba                	add	a5,a5,a4
    8000575e:	0200c737          	lui	a4,0x200c
    80005762:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005766:	000f4637          	lui	a2,0xf4
    8000576a:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    8000576e:	9732                	add	a4,a4,a2
    80005770:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005772:	00259693          	slli	a3,a1,0x2
    80005776:	96ae                	add	a3,a3,a1
    80005778:	068e                	slli	a3,a3,0x3
    8000577a:	00014717          	auipc	a4,0x14
    8000577e:	7c670713          	addi	a4,a4,1990 # 80019f40 <timer_scratch>
    80005782:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005784:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005786:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005788:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000578c:	00000797          	auipc	a5,0x0
    80005790:	9a478793          	addi	a5,a5,-1628 # 80005130 <timervec>
    80005794:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005798:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000579c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057a0:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800057a4:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800057a8:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800057ac:	30479073          	csrw	mie,a5
}
    800057b0:	6422                	ld	s0,8(sp)
    800057b2:	0141                	addi	sp,sp,16
    800057b4:	8082                	ret

00000000800057b6 <start>:
{
    800057b6:	1141                	addi	sp,sp,-16
    800057b8:	e406                	sd	ra,8(sp)
    800057ba:	e022                	sd	s0,0(sp)
    800057bc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800057be:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800057c2:	7779                	lui	a4,0xffffe
    800057c4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc67f>
    800057c8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800057ca:	6705                	lui	a4,0x1
    800057cc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800057d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800057d2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800057d6:	ffffb797          	auipc	a5,0xffffb
    800057da:	b8078793          	addi	a5,a5,-1152 # 80000356 <main>
    800057de:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800057e2:	4781                	li	a5,0
    800057e4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800057e8:	67c1                	lui	a5,0x10
    800057ea:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800057ec:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800057f0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800057f4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800057f8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800057fc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005800:	57fd                	li	a5,-1
    80005802:	83a9                	srli	a5,a5,0xa
    80005804:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005808:	47bd                	li	a5,15
    8000580a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000580e:	00000097          	auipc	ra,0x0
    80005812:	f38080e7          	jalr	-200(ra) # 80005746 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005816:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000581a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000581c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000581e:	30200073          	mret
}
    80005822:	60a2                	ld	ra,8(sp)
    80005824:	6402                	ld	s0,0(sp)
    80005826:	0141                	addi	sp,sp,16
    80005828:	8082                	ret

000000008000582a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000582a:	715d                	addi	sp,sp,-80
    8000582c:	e486                	sd	ra,72(sp)
    8000582e:	e0a2                	sd	s0,64(sp)
    80005830:	fc26                	sd	s1,56(sp)
    80005832:	f84a                	sd	s2,48(sp)
    80005834:	f44e                	sd	s3,40(sp)
    80005836:	f052                	sd	s4,32(sp)
    80005838:	ec56                	sd	s5,24(sp)
    8000583a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000583c:	04c05763          	blez	a2,8000588a <consolewrite+0x60>
    80005840:	8a2a                	mv	s4,a0
    80005842:	84ae                	mv	s1,a1
    80005844:	89b2                	mv	s3,a2
    80005846:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005848:	5afd                	li	s5,-1
    8000584a:	4685                	li	a3,1
    8000584c:	8626                	mv	a2,s1
    8000584e:	85d2                	mv	a1,s4
    80005850:	fbf40513          	addi	a0,s0,-65
    80005854:	ffffc097          	auipc	ra,0xffffc
    80005858:	144080e7          	jalr	324(ra) # 80001998 <either_copyin>
    8000585c:	01550d63          	beq	a0,s5,80005876 <consolewrite+0x4c>
      break;
    uartputc(c);
    80005860:	fbf44503          	lbu	a0,-65(s0)
    80005864:	00000097          	auipc	ra,0x0
    80005868:	780080e7          	jalr	1920(ra) # 80005fe4 <uartputc>
  for(i = 0; i < n; i++){
    8000586c:	2905                	addiw	s2,s2,1
    8000586e:	0485                	addi	s1,s1,1
    80005870:	fd299de3          	bne	s3,s2,8000584a <consolewrite+0x20>
    80005874:	894e                	mv	s2,s3
  }

  return i;
}
    80005876:	854a                	mv	a0,s2
    80005878:	60a6                	ld	ra,72(sp)
    8000587a:	6406                	ld	s0,64(sp)
    8000587c:	74e2                	ld	s1,56(sp)
    8000587e:	7942                	ld	s2,48(sp)
    80005880:	79a2                	ld	s3,40(sp)
    80005882:	7a02                	ld	s4,32(sp)
    80005884:	6ae2                	ld	s5,24(sp)
    80005886:	6161                	addi	sp,sp,80
    80005888:	8082                	ret
  for(i = 0; i < n; i++){
    8000588a:	4901                	li	s2,0
    8000588c:	b7ed                	j	80005876 <consolewrite+0x4c>

000000008000588e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000588e:	711d                	addi	sp,sp,-96
    80005890:	ec86                	sd	ra,88(sp)
    80005892:	e8a2                	sd	s0,80(sp)
    80005894:	e4a6                	sd	s1,72(sp)
    80005896:	e0ca                	sd	s2,64(sp)
    80005898:	fc4e                	sd	s3,56(sp)
    8000589a:	f852                	sd	s4,48(sp)
    8000589c:	f456                	sd	s5,40(sp)
    8000589e:	f05a                	sd	s6,32(sp)
    800058a0:	ec5e                	sd	s7,24(sp)
    800058a2:	1080                	addi	s0,sp,96
    800058a4:	8aaa                	mv	s5,a0
    800058a6:	8a2e                	mv	s4,a1
    800058a8:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800058aa:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    800058ae:	0001c517          	auipc	a0,0x1c
    800058b2:	7d250513          	addi	a0,a0,2002 # 80022080 <cons>
    800058b6:	00001097          	auipc	ra,0x1
    800058ba:	8e8080e7          	jalr	-1816(ra) # 8000619e <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800058be:	0001c497          	auipc	s1,0x1c
    800058c2:	7c248493          	addi	s1,s1,1986 # 80022080 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800058c6:	0001d917          	auipc	s2,0x1d
    800058ca:	85290913          	addi	s2,s2,-1966 # 80022118 <cons+0x98>
  while(n > 0){
    800058ce:	09305263          	blez	s3,80005952 <consoleread+0xc4>
    while(cons.r == cons.w){
    800058d2:	0984a783          	lw	a5,152(s1)
    800058d6:	09c4a703          	lw	a4,156(s1)
    800058da:	02f71763          	bne	a4,a5,80005908 <consoleread+0x7a>
      if(killed(myproc())){
    800058de:	ffffb097          	auipc	ra,0xffffb
    800058e2:	5ac080e7          	jalr	1452(ra) # 80000e8a <myproc>
    800058e6:	ffffc097          	auipc	ra,0xffffc
    800058ea:	efc080e7          	jalr	-260(ra) # 800017e2 <killed>
    800058ee:	ed2d                	bnez	a0,80005968 <consoleread+0xda>
      sleep(&cons.r, &cons.lock);
    800058f0:	85a6                	mv	a1,s1
    800058f2:	854a                	mv	a0,s2
    800058f4:	ffffc097          	auipc	ra,0xffffc
    800058f8:	c46080e7          	jalr	-954(ra) # 8000153a <sleep>
    while(cons.r == cons.w){
    800058fc:	0984a783          	lw	a5,152(s1)
    80005900:	09c4a703          	lw	a4,156(s1)
    80005904:	fcf70de3          	beq	a4,a5,800058de <consoleread+0x50>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005908:	0001c717          	auipc	a4,0x1c
    8000590c:	77870713          	addi	a4,a4,1912 # 80022080 <cons>
    80005910:	0017869b          	addiw	a3,a5,1
    80005914:	08d72c23          	sw	a3,152(a4)
    80005918:	07f7f693          	andi	a3,a5,127
    8000591c:	9736                	add	a4,a4,a3
    8000591e:	01874703          	lbu	a4,24(a4)
    80005922:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005926:	4691                	li	a3,4
    80005928:	06db8463          	beq	s7,a3,80005990 <consoleread+0x102>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000592c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005930:	4685                	li	a3,1
    80005932:	faf40613          	addi	a2,s0,-81
    80005936:	85d2                	mv	a1,s4
    80005938:	8556                	mv	a0,s5
    8000593a:	ffffc097          	auipc	ra,0xffffc
    8000593e:	008080e7          	jalr	8(ra) # 80001942 <either_copyout>
    80005942:	57fd                	li	a5,-1
    80005944:	00f50763          	beq	a0,a5,80005952 <consoleread+0xc4>
      break;

    dst++;
    80005948:	0a05                	addi	s4,s4,1
    --n;
    8000594a:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    8000594c:	47a9                	li	a5,10
    8000594e:	f8fb90e3          	bne	s7,a5,800058ce <consoleread+0x40>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005952:	0001c517          	auipc	a0,0x1c
    80005956:	72e50513          	addi	a0,a0,1838 # 80022080 <cons>
    8000595a:	00001097          	auipc	ra,0x1
    8000595e:	8f8080e7          	jalr	-1800(ra) # 80006252 <release>

  return target - n;
    80005962:	413b053b          	subw	a0,s6,s3
    80005966:	a811                	j	8000597a <consoleread+0xec>
        release(&cons.lock);
    80005968:	0001c517          	auipc	a0,0x1c
    8000596c:	71850513          	addi	a0,a0,1816 # 80022080 <cons>
    80005970:	00001097          	auipc	ra,0x1
    80005974:	8e2080e7          	jalr	-1822(ra) # 80006252 <release>
        return -1;
    80005978:	557d                	li	a0,-1
}
    8000597a:	60e6                	ld	ra,88(sp)
    8000597c:	6446                	ld	s0,80(sp)
    8000597e:	64a6                	ld	s1,72(sp)
    80005980:	6906                	ld	s2,64(sp)
    80005982:	79e2                	ld	s3,56(sp)
    80005984:	7a42                	ld	s4,48(sp)
    80005986:	7aa2                	ld	s5,40(sp)
    80005988:	7b02                	ld	s6,32(sp)
    8000598a:	6be2                	ld	s7,24(sp)
    8000598c:	6125                	addi	sp,sp,96
    8000598e:	8082                	ret
      if(n < target){
    80005990:	0009871b          	sext.w	a4,s3
    80005994:	fb677fe3          	bgeu	a4,s6,80005952 <consoleread+0xc4>
        cons.r--;
    80005998:	0001c717          	auipc	a4,0x1c
    8000599c:	78f72023          	sw	a5,1920(a4) # 80022118 <cons+0x98>
    800059a0:	bf4d                	j	80005952 <consoleread+0xc4>

00000000800059a2 <consputc>:
{
    800059a2:	1141                	addi	sp,sp,-16
    800059a4:	e406                	sd	ra,8(sp)
    800059a6:	e022                	sd	s0,0(sp)
    800059a8:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800059aa:	10000793          	li	a5,256
    800059ae:	00f50a63          	beq	a0,a5,800059c2 <consputc+0x20>
    uartputc_sync(c);
    800059b2:	00000097          	auipc	ra,0x0
    800059b6:	560080e7          	jalr	1376(ra) # 80005f12 <uartputc_sync>
}
    800059ba:	60a2                	ld	ra,8(sp)
    800059bc:	6402                	ld	s0,0(sp)
    800059be:	0141                	addi	sp,sp,16
    800059c0:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800059c2:	4521                	li	a0,8
    800059c4:	00000097          	auipc	ra,0x0
    800059c8:	54e080e7          	jalr	1358(ra) # 80005f12 <uartputc_sync>
    800059cc:	02000513          	li	a0,32
    800059d0:	00000097          	auipc	ra,0x0
    800059d4:	542080e7          	jalr	1346(ra) # 80005f12 <uartputc_sync>
    800059d8:	4521                	li	a0,8
    800059da:	00000097          	auipc	ra,0x0
    800059de:	538080e7          	jalr	1336(ra) # 80005f12 <uartputc_sync>
    800059e2:	bfe1                	j	800059ba <consputc+0x18>

00000000800059e4 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800059e4:	1101                	addi	sp,sp,-32
    800059e6:	ec06                	sd	ra,24(sp)
    800059e8:	e822                	sd	s0,16(sp)
    800059ea:	e426                	sd	s1,8(sp)
    800059ec:	e04a                	sd	s2,0(sp)
    800059ee:	1000                	addi	s0,sp,32
    800059f0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800059f2:	0001c517          	auipc	a0,0x1c
    800059f6:	68e50513          	addi	a0,a0,1678 # 80022080 <cons>
    800059fa:	00000097          	auipc	ra,0x0
    800059fe:	7a4080e7          	jalr	1956(ra) # 8000619e <acquire>

  switch(c){
    80005a02:	47d5                	li	a5,21
    80005a04:	0af48663          	beq	s1,a5,80005ab0 <consoleintr+0xcc>
    80005a08:	0297ca63          	blt	a5,s1,80005a3c <consoleintr+0x58>
    80005a0c:	47a1                	li	a5,8
    80005a0e:	0ef48763          	beq	s1,a5,80005afc <consoleintr+0x118>
    80005a12:	47c1                	li	a5,16
    80005a14:	10f49a63          	bne	s1,a5,80005b28 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005a18:	ffffc097          	auipc	ra,0xffffc
    80005a1c:	fd6080e7          	jalr	-42(ra) # 800019ee <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005a20:	0001c517          	auipc	a0,0x1c
    80005a24:	66050513          	addi	a0,a0,1632 # 80022080 <cons>
    80005a28:	00001097          	auipc	ra,0x1
    80005a2c:	82a080e7          	jalr	-2006(ra) # 80006252 <release>
}
    80005a30:	60e2                	ld	ra,24(sp)
    80005a32:	6442                	ld	s0,16(sp)
    80005a34:	64a2                	ld	s1,8(sp)
    80005a36:	6902                	ld	s2,0(sp)
    80005a38:	6105                	addi	sp,sp,32
    80005a3a:	8082                	ret
  switch(c){
    80005a3c:	07f00793          	li	a5,127
    80005a40:	0af48e63          	beq	s1,a5,80005afc <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005a44:	0001c717          	auipc	a4,0x1c
    80005a48:	63c70713          	addi	a4,a4,1596 # 80022080 <cons>
    80005a4c:	0a072783          	lw	a5,160(a4)
    80005a50:	09872703          	lw	a4,152(a4)
    80005a54:	9f99                	subw	a5,a5,a4
    80005a56:	07f00713          	li	a4,127
    80005a5a:	fcf763e3          	bltu	a4,a5,80005a20 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005a5e:	47b5                	li	a5,13
    80005a60:	0cf48763          	beq	s1,a5,80005b2e <consoleintr+0x14a>
      consputc(c);
    80005a64:	8526                	mv	a0,s1
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	f3c080e7          	jalr	-196(ra) # 800059a2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005a6e:	0001c797          	auipc	a5,0x1c
    80005a72:	61278793          	addi	a5,a5,1554 # 80022080 <cons>
    80005a76:	0a07a683          	lw	a3,160(a5)
    80005a7a:	0016871b          	addiw	a4,a3,1
    80005a7e:	0007061b          	sext.w	a2,a4
    80005a82:	0ae7a023          	sw	a4,160(a5)
    80005a86:	07f6f693          	andi	a3,a3,127
    80005a8a:	97b6                	add	a5,a5,a3
    80005a8c:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005a90:	47a9                	li	a5,10
    80005a92:	0cf48563          	beq	s1,a5,80005b5c <consoleintr+0x178>
    80005a96:	4791                	li	a5,4
    80005a98:	0cf48263          	beq	s1,a5,80005b5c <consoleintr+0x178>
    80005a9c:	0001c797          	auipc	a5,0x1c
    80005aa0:	67c7a783          	lw	a5,1660(a5) # 80022118 <cons+0x98>
    80005aa4:	9f1d                	subw	a4,a4,a5
    80005aa6:	08000793          	li	a5,128
    80005aaa:	f6f71be3          	bne	a4,a5,80005a20 <consoleintr+0x3c>
    80005aae:	a07d                	j	80005b5c <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ab0:	0001c717          	auipc	a4,0x1c
    80005ab4:	5d070713          	addi	a4,a4,1488 # 80022080 <cons>
    80005ab8:	0a072783          	lw	a5,160(a4)
    80005abc:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ac0:	0001c497          	auipc	s1,0x1c
    80005ac4:	5c048493          	addi	s1,s1,1472 # 80022080 <cons>
    while(cons.e != cons.w &&
    80005ac8:	4929                	li	s2,10
    80005aca:	f4f70be3          	beq	a4,a5,80005a20 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ace:	37fd                	addiw	a5,a5,-1
    80005ad0:	07f7f713          	andi	a4,a5,127
    80005ad4:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ad6:	01874703          	lbu	a4,24(a4)
    80005ada:	f52703e3          	beq	a4,s2,80005a20 <consoleintr+0x3c>
      cons.e--;
    80005ade:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ae2:	10000513          	li	a0,256
    80005ae6:	00000097          	auipc	ra,0x0
    80005aea:	ebc080e7          	jalr	-324(ra) # 800059a2 <consputc>
    while(cons.e != cons.w &&
    80005aee:	0a04a783          	lw	a5,160(s1)
    80005af2:	09c4a703          	lw	a4,156(s1)
    80005af6:	fcf71ce3          	bne	a4,a5,80005ace <consoleintr+0xea>
    80005afa:	b71d                	j	80005a20 <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005afc:	0001c717          	auipc	a4,0x1c
    80005b00:	58470713          	addi	a4,a4,1412 # 80022080 <cons>
    80005b04:	0a072783          	lw	a5,160(a4)
    80005b08:	09c72703          	lw	a4,156(a4)
    80005b0c:	f0f70ae3          	beq	a4,a5,80005a20 <consoleintr+0x3c>
      cons.e--;
    80005b10:	37fd                	addiw	a5,a5,-1
    80005b12:	0001c717          	auipc	a4,0x1c
    80005b16:	60f72723          	sw	a5,1550(a4) # 80022120 <cons+0xa0>
      consputc(BACKSPACE);
    80005b1a:	10000513          	li	a0,256
    80005b1e:	00000097          	auipc	ra,0x0
    80005b22:	e84080e7          	jalr	-380(ra) # 800059a2 <consputc>
    80005b26:	bded                	j	80005a20 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005b28:	ee048ce3          	beqz	s1,80005a20 <consoleintr+0x3c>
    80005b2c:	bf21                	j	80005a44 <consoleintr+0x60>
      consputc(c);
    80005b2e:	4529                	li	a0,10
    80005b30:	00000097          	auipc	ra,0x0
    80005b34:	e72080e7          	jalr	-398(ra) # 800059a2 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005b38:	0001c797          	auipc	a5,0x1c
    80005b3c:	54878793          	addi	a5,a5,1352 # 80022080 <cons>
    80005b40:	0a07a703          	lw	a4,160(a5)
    80005b44:	0017069b          	addiw	a3,a4,1
    80005b48:	0006861b          	sext.w	a2,a3
    80005b4c:	0ad7a023          	sw	a3,160(a5)
    80005b50:	07f77713          	andi	a4,a4,127
    80005b54:	97ba                	add	a5,a5,a4
    80005b56:	4729                	li	a4,10
    80005b58:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005b5c:	0001c797          	auipc	a5,0x1c
    80005b60:	5cc7a023          	sw	a2,1472(a5) # 8002211c <cons+0x9c>
        wakeup(&cons.r);
    80005b64:	0001c517          	auipc	a0,0x1c
    80005b68:	5b450513          	addi	a0,a0,1460 # 80022118 <cons+0x98>
    80005b6c:	ffffc097          	auipc	ra,0xffffc
    80005b70:	a32080e7          	jalr	-1486(ra) # 8000159e <wakeup>
    80005b74:	b575                	j	80005a20 <consoleintr+0x3c>

0000000080005b76 <consoleinit>:

void
consoleinit(void)
{
    80005b76:	1141                	addi	sp,sp,-16
    80005b78:	e406                	sd	ra,8(sp)
    80005b7a:	e022                	sd	s0,0(sp)
    80005b7c:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005b7e:	00003597          	auipc	a1,0x3
    80005b82:	e9258593          	addi	a1,a1,-366 # 80008a10 <syscallNames+0x3f8>
    80005b86:	0001c517          	auipc	a0,0x1c
    80005b8a:	4fa50513          	addi	a0,a0,1274 # 80022080 <cons>
    80005b8e:	00000097          	auipc	ra,0x0
    80005b92:	580080e7          	jalr	1408(ra) # 8000610e <initlock>

  uartinit();
    80005b96:	00000097          	auipc	ra,0x0
    80005b9a:	32c080e7          	jalr	812(ra) # 80005ec2 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005b9e:	00013797          	auipc	a5,0x13
    80005ba2:	20a78793          	addi	a5,a5,522 # 80018da8 <devsw>
    80005ba6:	00000717          	auipc	a4,0x0
    80005baa:	ce870713          	addi	a4,a4,-792 # 8000588e <consoleread>
    80005bae:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005bb0:	00000717          	auipc	a4,0x0
    80005bb4:	c7a70713          	addi	a4,a4,-902 # 8000582a <consolewrite>
    80005bb8:	ef98                	sd	a4,24(a5)
}
    80005bba:	60a2                	ld	ra,8(sp)
    80005bbc:	6402                	ld	s0,0(sp)
    80005bbe:	0141                	addi	sp,sp,16
    80005bc0:	8082                	ret

0000000080005bc2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005bc2:	7179                	addi	sp,sp,-48
    80005bc4:	f406                	sd	ra,40(sp)
    80005bc6:	f022                	sd	s0,32(sp)
    80005bc8:	ec26                	sd	s1,24(sp)
    80005bca:	e84a                	sd	s2,16(sp)
    80005bcc:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005bce:	c219                	beqz	a2,80005bd4 <printint+0x12>
    80005bd0:	08054763          	bltz	a0,80005c5e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005bd4:	2501                	sext.w	a0,a0
    80005bd6:	4881                	li	a7,0
    80005bd8:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005bdc:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005bde:	2581                	sext.w	a1,a1
    80005be0:	00003617          	auipc	a2,0x3
    80005be4:	e6060613          	addi	a2,a2,-416 # 80008a40 <digits>
    80005be8:	883a                	mv	a6,a4
    80005bea:	2705                	addiw	a4,a4,1
    80005bec:	02b577bb          	remuw	a5,a0,a1
    80005bf0:	1782                	slli	a5,a5,0x20
    80005bf2:	9381                	srli	a5,a5,0x20
    80005bf4:	97b2                	add	a5,a5,a2
    80005bf6:	0007c783          	lbu	a5,0(a5)
    80005bfa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005bfe:	0005079b          	sext.w	a5,a0
    80005c02:	02b5553b          	divuw	a0,a0,a1
    80005c06:	0685                	addi	a3,a3,1
    80005c08:	feb7f0e3          	bgeu	a5,a1,80005be8 <printint+0x26>

  if(sign)
    80005c0c:	00088c63          	beqz	a7,80005c24 <printint+0x62>
    buf[i++] = '-';
    80005c10:	fe070793          	addi	a5,a4,-32
    80005c14:	00878733          	add	a4,a5,s0
    80005c18:	02d00793          	li	a5,45
    80005c1c:	fef70823          	sb	a5,-16(a4)
    80005c20:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005c24:	02e05763          	blez	a4,80005c52 <printint+0x90>
    80005c28:	fd040793          	addi	a5,s0,-48
    80005c2c:	00e784b3          	add	s1,a5,a4
    80005c30:	fff78913          	addi	s2,a5,-1
    80005c34:	993a                	add	s2,s2,a4
    80005c36:	377d                	addiw	a4,a4,-1
    80005c38:	1702                	slli	a4,a4,0x20
    80005c3a:	9301                	srli	a4,a4,0x20
    80005c3c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005c40:	fff4c503          	lbu	a0,-1(s1)
    80005c44:	00000097          	auipc	ra,0x0
    80005c48:	d5e080e7          	jalr	-674(ra) # 800059a2 <consputc>
  while(--i >= 0)
    80005c4c:	14fd                	addi	s1,s1,-1
    80005c4e:	ff2499e3          	bne	s1,s2,80005c40 <printint+0x7e>
}
    80005c52:	70a2                	ld	ra,40(sp)
    80005c54:	7402                	ld	s0,32(sp)
    80005c56:	64e2                	ld	s1,24(sp)
    80005c58:	6942                	ld	s2,16(sp)
    80005c5a:	6145                	addi	sp,sp,48
    80005c5c:	8082                	ret
    x = -xx;
    80005c5e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005c62:	4885                	li	a7,1
    x = -xx;
    80005c64:	bf95                	j	80005bd8 <printint+0x16>

0000000080005c66 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005c66:	1101                	addi	sp,sp,-32
    80005c68:	ec06                	sd	ra,24(sp)
    80005c6a:	e822                	sd	s0,16(sp)
    80005c6c:	e426                	sd	s1,8(sp)
    80005c6e:	1000                	addi	s0,sp,32
    80005c70:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005c72:	0001c797          	auipc	a5,0x1c
    80005c76:	4c07a723          	sw	zero,1230(a5) # 80022140 <pr+0x18>
  printf("panic: ");
    80005c7a:	00003517          	auipc	a0,0x3
    80005c7e:	d9e50513          	addi	a0,a0,-610 # 80008a18 <syscallNames+0x400>
    80005c82:	00000097          	auipc	ra,0x0
    80005c86:	02e080e7          	jalr	46(ra) # 80005cb0 <printf>
  printf(s);
    80005c8a:	8526                	mv	a0,s1
    80005c8c:	00000097          	auipc	ra,0x0
    80005c90:	024080e7          	jalr	36(ra) # 80005cb0 <printf>
  printf("\n");
    80005c94:	00002517          	auipc	a0,0x2
    80005c98:	3b450513          	addi	a0,a0,948 # 80008048 <etext+0x48>
    80005c9c:	00000097          	auipc	ra,0x0
    80005ca0:	014080e7          	jalr	20(ra) # 80005cb0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ca4:	4785                	li	a5,1
    80005ca6:	00003717          	auipc	a4,0x3
    80005caa:	e4f72b23          	sw	a5,-426(a4) # 80008afc <panicked>
  for(;;)
    80005cae:	a001                	j	80005cae <panic+0x48>

0000000080005cb0 <printf>:
{
    80005cb0:	7131                	addi	sp,sp,-192
    80005cb2:	fc86                	sd	ra,120(sp)
    80005cb4:	f8a2                	sd	s0,112(sp)
    80005cb6:	f4a6                	sd	s1,104(sp)
    80005cb8:	f0ca                	sd	s2,96(sp)
    80005cba:	ecce                	sd	s3,88(sp)
    80005cbc:	e8d2                	sd	s4,80(sp)
    80005cbe:	e4d6                	sd	s5,72(sp)
    80005cc0:	e0da                	sd	s6,64(sp)
    80005cc2:	fc5e                	sd	s7,56(sp)
    80005cc4:	f862                	sd	s8,48(sp)
    80005cc6:	f466                	sd	s9,40(sp)
    80005cc8:	f06a                	sd	s10,32(sp)
    80005cca:	ec6e                	sd	s11,24(sp)
    80005ccc:	0100                	addi	s0,sp,128
    80005cce:	8a2a                	mv	s4,a0
    80005cd0:	e40c                	sd	a1,8(s0)
    80005cd2:	e810                	sd	a2,16(s0)
    80005cd4:	ec14                	sd	a3,24(s0)
    80005cd6:	f018                	sd	a4,32(s0)
    80005cd8:	f41c                	sd	a5,40(s0)
    80005cda:	03043823          	sd	a6,48(s0)
    80005cde:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ce2:	0001cd97          	auipc	s11,0x1c
    80005ce6:	45edad83          	lw	s11,1118(s11) # 80022140 <pr+0x18>
  if(locking)
    80005cea:	020d9b63          	bnez	s11,80005d20 <printf+0x70>
  if (fmt == 0)
    80005cee:	040a0263          	beqz	s4,80005d32 <printf+0x82>
  va_start(ap, fmt);
    80005cf2:	00840793          	addi	a5,s0,8
    80005cf6:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005cfa:	000a4503          	lbu	a0,0(s4)
    80005cfe:	14050f63          	beqz	a0,80005e5c <printf+0x1ac>
    80005d02:	4981                	li	s3,0
    if(c != '%'){
    80005d04:	02500a93          	li	s5,37
    switch(c){
    80005d08:	07000b93          	li	s7,112
  consputc('x');
    80005d0c:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005d0e:	00003b17          	auipc	s6,0x3
    80005d12:	d32b0b13          	addi	s6,s6,-718 # 80008a40 <digits>
    switch(c){
    80005d16:	07300c93          	li	s9,115
    80005d1a:	06400c13          	li	s8,100
    80005d1e:	a82d                	j	80005d58 <printf+0xa8>
    acquire(&pr.lock);
    80005d20:	0001c517          	auipc	a0,0x1c
    80005d24:	40850513          	addi	a0,a0,1032 # 80022128 <pr>
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	476080e7          	jalr	1142(ra) # 8000619e <acquire>
    80005d30:	bf7d                	j	80005cee <printf+0x3e>
    panic("null fmt");
    80005d32:	00003517          	auipc	a0,0x3
    80005d36:	cf650513          	addi	a0,a0,-778 # 80008a28 <syscallNames+0x410>
    80005d3a:	00000097          	auipc	ra,0x0
    80005d3e:	f2c080e7          	jalr	-212(ra) # 80005c66 <panic>
      consputc(c);
    80005d42:	00000097          	auipc	ra,0x0
    80005d46:	c60080e7          	jalr	-928(ra) # 800059a2 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005d4a:	2985                	addiw	s3,s3,1
    80005d4c:	013a07b3          	add	a5,s4,s3
    80005d50:	0007c503          	lbu	a0,0(a5)
    80005d54:	10050463          	beqz	a0,80005e5c <printf+0x1ac>
    if(c != '%'){
    80005d58:	ff5515e3          	bne	a0,s5,80005d42 <printf+0x92>
    c = fmt[++i] & 0xff;
    80005d5c:	2985                	addiw	s3,s3,1
    80005d5e:	013a07b3          	add	a5,s4,s3
    80005d62:	0007c783          	lbu	a5,0(a5)
    80005d66:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005d6a:	cbed                	beqz	a5,80005e5c <printf+0x1ac>
    switch(c){
    80005d6c:	05778a63          	beq	a5,s7,80005dc0 <printf+0x110>
    80005d70:	02fbf663          	bgeu	s7,a5,80005d9c <printf+0xec>
    80005d74:	09978863          	beq	a5,s9,80005e04 <printf+0x154>
    80005d78:	07800713          	li	a4,120
    80005d7c:	0ce79563          	bne	a5,a4,80005e46 <printf+0x196>
      printint(va_arg(ap, int), 16, 1);
    80005d80:	f8843783          	ld	a5,-120(s0)
    80005d84:	00878713          	addi	a4,a5,8
    80005d88:	f8e43423          	sd	a4,-120(s0)
    80005d8c:	4605                	li	a2,1
    80005d8e:	85ea                	mv	a1,s10
    80005d90:	4388                	lw	a0,0(a5)
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	e30080e7          	jalr	-464(ra) # 80005bc2 <printint>
      break;
    80005d9a:	bf45                	j	80005d4a <printf+0x9a>
    switch(c){
    80005d9c:	09578f63          	beq	a5,s5,80005e3a <printf+0x18a>
    80005da0:	0b879363          	bne	a5,s8,80005e46 <printf+0x196>
      printint(va_arg(ap, int), 10, 1);
    80005da4:	f8843783          	ld	a5,-120(s0)
    80005da8:	00878713          	addi	a4,a5,8
    80005dac:	f8e43423          	sd	a4,-120(s0)
    80005db0:	4605                	li	a2,1
    80005db2:	45a9                	li	a1,10
    80005db4:	4388                	lw	a0,0(a5)
    80005db6:	00000097          	auipc	ra,0x0
    80005dba:	e0c080e7          	jalr	-500(ra) # 80005bc2 <printint>
      break;
    80005dbe:	b771                	j	80005d4a <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005dc0:	f8843783          	ld	a5,-120(s0)
    80005dc4:	00878713          	addi	a4,a5,8
    80005dc8:	f8e43423          	sd	a4,-120(s0)
    80005dcc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80005dd0:	03000513          	li	a0,48
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	bce080e7          	jalr	-1074(ra) # 800059a2 <consputc>
  consputc('x');
    80005ddc:	07800513          	li	a0,120
    80005de0:	00000097          	auipc	ra,0x0
    80005de4:	bc2080e7          	jalr	-1086(ra) # 800059a2 <consputc>
    80005de8:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005dea:	03c95793          	srli	a5,s2,0x3c
    80005dee:	97da                	add	a5,a5,s6
    80005df0:	0007c503          	lbu	a0,0(a5)
    80005df4:	00000097          	auipc	ra,0x0
    80005df8:	bae080e7          	jalr	-1106(ra) # 800059a2 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005dfc:	0912                	slli	s2,s2,0x4
    80005dfe:	34fd                	addiw	s1,s1,-1
    80005e00:	f4ed                	bnez	s1,80005dea <printf+0x13a>
    80005e02:	b7a1                	j	80005d4a <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80005e04:	f8843783          	ld	a5,-120(s0)
    80005e08:	00878713          	addi	a4,a5,8
    80005e0c:	f8e43423          	sd	a4,-120(s0)
    80005e10:	6384                	ld	s1,0(a5)
    80005e12:	cc89                	beqz	s1,80005e2c <printf+0x17c>
      for(; *s; s++)
    80005e14:	0004c503          	lbu	a0,0(s1)
    80005e18:	d90d                	beqz	a0,80005d4a <printf+0x9a>
        consputc(*s);
    80005e1a:	00000097          	auipc	ra,0x0
    80005e1e:	b88080e7          	jalr	-1144(ra) # 800059a2 <consputc>
      for(; *s; s++)
    80005e22:	0485                	addi	s1,s1,1
    80005e24:	0004c503          	lbu	a0,0(s1)
    80005e28:	f96d                	bnez	a0,80005e1a <printf+0x16a>
    80005e2a:	b705                	j	80005d4a <printf+0x9a>
        s = "(null)";
    80005e2c:	00003497          	auipc	s1,0x3
    80005e30:	bf448493          	addi	s1,s1,-1036 # 80008a20 <syscallNames+0x408>
      for(; *s; s++)
    80005e34:	02800513          	li	a0,40
    80005e38:	b7cd                	j	80005e1a <printf+0x16a>
      consputc('%');
    80005e3a:	8556                	mv	a0,s5
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	b66080e7          	jalr	-1178(ra) # 800059a2 <consputc>
      break;
    80005e44:	b719                	j	80005d4a <printf+0x9a>
      consputc('%');
    80005e46:	8556                	mv	a0,s5
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	b5a080e7          	jalr	-1190(ra) # 800059a2 <consputc>
      consputc(c);
    80005e50:	8526                	mv	a0,s1
    80005e52:	00000097          	auipc	ra,0x0
    80005e56:	b50080e7          	jalr	-1200(ra) # 800059a2 <consputc>
      break;
    80005e5a:	bdc5                	j	80005d4a <printf+0x9a>
  if(locking)
    80005e5c:	020d9163          	bnez	s11,80005e7e <printf+0x1ce>
}
    80005e60:	70e6                	ld	ra,120(sp)
    80005e62:	7446                	ld	s0,112(sp)
    80005e64:	74a6                	ld	s1,104(sp)
    80005e66:	7906                	ld	s2,96(sp)
    80005e68:	69e6                	ld	s3,88(sp)
    80005e6a:	6a46                	ld	s4,80(sp)
    80005e6c:	6aa6                	ld	s5,72(sp)
    80005e6e:	6b06                	ld	s6,64(sp)
    80005e70:	7be2                	ld	s7,56(sp)
    80005e72:	7c42                	ld	s8,48(sp)
    80005e74:	7ca2                	ld	s9,40(sp)
    80005e76:	7d02                	ld	s10,32(sp)
    80005e78:	6de2                	ld	s11,24(sp)
    80005e7a:	6129                	addi	sp,sp,192
    80005e7c:	8082                	ret
    release(&pr.lock);
    80005e7e:	0001c517          	auipc	a0,0x1c
    80005e82:	2aa50513          	addi	a0,a0,682 # 80022128 <pr>
    80005e86:	00000097          	auipc	ra,0x0
    80005e8a:	3cc080e7          	jalr	972(ra) # 80006252 <release>
}
    80005e8e:	bfc9                	j	80005e60 <printf+0x1b0>

0000000080005e90 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005e90:	1101                	addi	sp,sp,-32
    80005e92:	ec06                	sd	ra,24(sp)
    80005e94:	e822                	sd	s0,16(sp)
    80005e96:	e426                	sd	s1,8(sp)
    80005e98:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80005e9a:	0001c497          	auipc	s1,0x1c
    80005e9e:	28e48493          	addi	s1,s1,654 # 80022128 <pr>
    80005ea2:	00003597          	auipc	a1,0x3
    80005ea6:	b9658593          	addi	a1,a1,-1130 # 80008a38 <syscallNames+0x420>
    80005eaa:	8526                	mv	a0,s1
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	262080e7          	jalr	610(ra) # 8000610e <initlock>
  pr.locking = 1;
    80005eb4:	4785                	li	a5,1
    80005eb6:	cc9c                	sw	a5,24(s1)
}
    80005eb8:	60e2                	ld	ra,24(sp)
    80005eba:	6442                	ld	s0,16(sp)
    80005ebc:	64a2                	ld	s1,8(sp)
    80005ebe:	6105                	addi	sp,sp,32
    80005ec0:	8082                	ret

0000000080005ec2 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80005ec2:	1141                	addi	sp,sp,-16
    80005ec4:	e406                	sd	ra,8(sp)
    80005ec6:	e022                	sd	s0,0(sp)
    80005ec8:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005eca:	100007b7          	lui	a5,0x10000
    80005ece:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ed2:	f8000713          	li	a4,-128
    80005ed6:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005eda:	470d                	li	a4,3
    80005edc:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005ee0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005ee4:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005ee8:	469d                	li	a3,7
    80005eea:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005eee:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005ef2:	00003597          	auipc	a1,0x3
    80005ef6:	b6658593          	addi	a1,a1,-1178 # 80008a58 <digits+0x18>
    80005efa:	0001c517          	auipc	a0,0x1c
    80005efe:	24e50513          	addi	a0,a0,590 # 80022148 <uart_tx_lock>
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	20c080e7          	jalr	524(ra) # 8000610e <initlock>
}
    80005f0a:	60a2                	ld	ra,8(sp)
    80005f0c:	6402                	ld	s0,0(sp)
    80005f0e:	0141                	addi	sp,sp,16
    80005f10:	8082                	ret

0000000080005f12 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005f12:	1101                	addi	sp,sp,-32
    80005f14:	ec06                	sd	ra,24(sp)
    80005f16:	e822                	sd	s0,16(sp)
    80005f18:	e426                	sd	s1,8(sp)
    80005f1a:	1000                	addi	s0,sp,32
    80005f1c:	84aa                	mv	s1,a0
  push_off();
    80005f1e:	00000097          	auipc	ra,0x0
    80005f22:	234080e7          	jalr	564(ra) # 80006152 <push_off>

  if(panicked){
    80005f26:	00003797          	auipc	a5,0x3
    80005f2a:	bd67a783          	lw	a5,-1066(a5) # 80008afc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f2e:	10000737          	lui	a4,0x10000
  if(panicked){
    80005f32:	c391                	beqz	a5,80005f36 <uartputc_sync+0x24>
    for(;;)
    80005f34:	a001                	j	80005f34 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005f36:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80005f3a:	0207f793          	andi	a5,a5,32
    80005f3e:	dfe5                	beqz	a5,80005f36 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80005f40:	0ff4f513          	zext.b	a0,s1
    80005f44:	100007b7          	lui	a5,0x10000
    80005f48:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80005f4c:	00000097          	auipc	ra,0x0
    80005f50:	2a6080e7          	jalr	678(ra) # 800061f2 <pop_off>
}
    80005f54:	60e2                	ld	ra,24(sp)
    80005f56:	6442                	ld	s0,16(sp)
    80005f58:	64a2                	ld	s1,8(sp)
    80005f5a:	6105                	addi	sp,sp,32
    80005f5c:	8082                	ret

0000000080005f5e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80005f5e:	00003797          	auipc	a5,0x3
    80005f62:	ba27b783          	ld	a5,-1118(a5) # 80008b00 <uart_tx_r>
    80005f66:	00003717          	auipc	a4,0x3
    80005f6a:	ba273703          	ld	a4,-1118(a4) # 80008b08 <uart_tx_w>
    80005f6e:	06f70a63          	beq	a4,a5,80005fe2 <uartstart+0x84>
{
    80005f72:	7139                	addi	sp,sp,-64
    80005f74:	fc06                	sd	ra,56(sp)
    80005f76:	f822                	sd	s0,48(sp)
    80005f78:	f426                	sd	s1,40(sp)
    80005f7a:	f04a                	sd	s2,32(sp)
    80005f7c:	ec4e                	sd	s3,24(sp)
    80005f7e:	e852                	sd	s4,16(sp)
    80005f80:	e456                	sd	s5,8(sp)
    80005f82:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005f84:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005f88:	0001ca17          	auipc	s4,0x1c
    80005f8c:	1c0a0a13          	addi	s4,s4,448 # 80022148 <uart_tx_lock>
    uart_tx_r += 1;
    80005f90:	00003497          	auipc	s1,0x3
    80005f94:	b7048493          	addi	s1,s1,-1168 # 80008b00 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80005f98:	00003997          	auipc	s3,0x3
    80005f9c:	b7098993          	addi	s3,s3,-1168 # 80008b08 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80005fa0:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80005fa4:	02077713          	andi	a4,a4,32
    80005fa8:	c705                	beqz	a4,80005fd0 <uartstart+0x72>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80005faa:	01f7f713          	andi	a4,a5,31
    80005fae:	9752                	add	a4,a4,s4
    80005fb0:	01874a83          	lbu	s5,24(a4)
    uart_tx_r += 1;
    80005fb4:	0785                	addi	a5,a5,1
    80005fb6:	e09c                	sd	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80005fb8:	8526                	mv	a0,s1
    80005fba:	ffffb097          	auipc	ra,0xffffb
    80005fbe:	5e4080e7          	jalr	1508(ra) # 8000159e <wakeup>
    
    WriteReg(THR, c);
    80005fc2:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80005fc6:	609c                	ld	a5,0(s1)
    80005fc8:	0009b703          	ld	a4,0(s3)
    80005fcc:	fcf71ae3          	bne	a4,a5,80005fa0 <uartstart+0x42>
  }
}
    80005fd0:	70e2                	ld	ra,56(sp)
    80005fd2:	7442                	ld	s0,48(sp)
    80005fd4:	74a2                	ld	s1,40(sp)
    80005fd6:	7902                	ld	s2,32(sp)
    80005fd8:	69e2                	ld	s3,24(sp)
    80005fda:	6a42                	ld	s4,16(sp)
    80005fdc:	6aa2                	ld	s5,8(sp)
    80005fde:	6121                	addi	sp,sp,64
    80005fe0:	8082                	ret
    80005fe2:	8082                	ret

0000000080005fe4 <uartputc>:
{
    80005fe4:	7179                	addi	sp,sp,-48
    80005fe6:	f406                	sd	ra,40(sp)
    80005fe8:	f022                	sd	s0,32(sp)
    80005fea:	ec26                	sd	s1,24(sp)
    80005fec:	e84a                	sd	s2,16(sp)
    80005fee:	e44e                	sd	s3,8(sp)
    80005ff0:	e052                	sd	s4,0(sp)
    80005ff2:	1800                	addi	s0,sp,48
    80005ff4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005ff6:	0001c517          	auipc	a0,0x1c
    80005ffa:	15250513          	addi	a0,a0,338 # 80022148 <uart_tx_lock>
    80005ffe:	00000097          	auipc	ra,0x0
    80006002:	1a0080e7          	jalr	416(ra) # 8000619e <acquire>
  if(panicked){
    80006006:	00003797          	auipc	a5,0x3
    8000600a:	af67a783          	lw	a5,-1290(a5) # 80008afc <panicked>
    8000600e:	e7c9                	bnez	a5,80006098 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006010:	00003717          	auipc	a4,0x3
    80006014:	af873703          	ld	a4,-1288(a4) # 80008b08 <uart_tx_w>
    80006018:	00003797          	auipc	a5,0x3
    8000601c:	ae87b783          	ld	a5,-1304(a5) # 80008b00 <uart_tx_r>
    80006020:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80006024:	0001c997          	auipc	s3,0x1c
    80006028:	12498993          	addi	s3,s3,292 # 80022148 <uart_tx_lock>
    8000602c:	00003497          	auipc	s1,0x3
    80006030:	ad448493          	addi	s1,s1,-1324 # 80008b00 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006034:	00003917          	auipc	s2,0x3
    80006038:	ad490913          	addi	s2,s2,-1324 # 80008b08 <uart_tx_w>
    8000603c:	00e79f63          	bne	a5,a4,8000605a <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80006040:	85ce                	mv	a1,s3
    80006042:	8526                	mv	a0,s1
    80006044:	ffffb097          	auipc	ra,0xffffb
    80006048:	4f6080e7          	jalr	1270(ra) # 8000153a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000604c:	00093703          	ld	a4,0(s2)
    80006050:	609c                	ld	a5,0(s1)
    80006052:	02078793          	addi	a5,a5,32
    80006056:	fee785e3          	beq	a5,a4,80006040 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    8000605a:	0001c497          	auipc	s1,0x1c
    8000605e:	0ee48493          	addi	s1,s1,238 # 80022148 <uart_tx_lock>
    80006062:	01f77793          	andi	a5,a4,31
    80006066:	97a6                	add	a5,a5,s1
    80006068:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    8000606c:	0705                	addi	a4,a4,1
    8000606e:	00003797          	auipc	a5,0x3
    80006072:	a8e7bd23          	sd	a4,-1382(a5) # 80008b08 <uart_tx_w>
  uartstart();
    80006076:	00000097          	auipc	ra,0x0
    8000607a:	ee8080e7          	jalr	-280(ra) # 80005f5e <uartstart>
  release(&uart_tx_lock);
    8000607e:	8526                	mv	a0,s1
    80006080:	00000097          	auipc	ra,0x0
    80006084:	1d2080e7          	jalr	466(ra) # 80006252 <release>
}
    80006088:	70a2                	ld	ra,40(sp)
    8000608a:	7402                	ld	s0,32(sp)
    8000608c:	64e2                	ld	s1,24(sp)
    8000608e:	6942                	ld	s2,16(sp)
    80006090:	69a2                	ld	s3,8(sp)
    80006092:	6a02                	ld	s4,0(sp)
    80006094:	6145                	addi	sp,sp,48
    80006096:	8082                	ret
    for(;;)
    80006098:	a001                	j	80006098 <uartputc+0xb4>

000000008000609a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000609a:	1141                	addi	sp,sp,-16
    8000609c:	e422                	sd	s0,8(sp)
    8000609e:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800060a0:	100007b7          	lui	a5,0x10000
    800060a4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800060a8:	8b85                	andi	a5,a5,1
    800060aa:	cb81                	beqz	a5,800060ba <uartgetc+0x20>
    // input data is ready.
    return ReadReg(RHR);
    800060ac:	100007b7          	lui	a5,0x10000
    800060b0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800060b4:	6422                	ld	s0,8(sp)
    800060b6:	0141                	addi	sp,sp,16
    800060b8:	8082                	ret
    return -1;
    800060ba:	557d                	li	a0,-1
    800060bc:	bfe5                	j	800060b4 <uartgetc+0x1a>

00000000800060be <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800060be:	1101                	addi	sp,sp,-32
    800060c0:	ec06                	sd	ra,24(sp)
    800060c2:	e822                	sd	s0,16(sp)
    800060c4:	e426                	sd	s1,8(sp)
    800060c6:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800060c8:	54fd                	li	s1,-1
    800060ca:	a029                	j	800060d4 <uartintr+0x16>
      break;
    consoleintr(c);
    800060cc:	00000097          	auipc	ra,0x0
    800060d0:	918080e7          	jalr	-1768(ra) # 800059e4 <consoleintr>
    int c = uartgetc();
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	fc6080e7          	jalr	-58(ra) # 8000609a <uartgetc>
    if(c == -1)
    800060dc:	fe9518e3          	bne	a0,s1,800060cc <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800060e0:	0001c497          	auipc	s1,0x1c
    800060e4:	06848493          	addi	s1,s1,104 # 80022148 <uart_tx_lock>
    800060e8:	8526                	mv	a0,s1
    800060ea:	00000097          	auipc	ra,0x0
    800060ee:	0b4080e7          	jalr	180(ra) # 8000619e <acquire>
  uartstart();
    800060f2:	00000097          	auipc	ra,0x0
    800060f6:	e6c080e7          	jalr	-404(ra) # 80005f5e <uartstart>
  release(&uart_tx_lock);
    800060fa:	8526                	mv	a0,s1
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	156080e7          	jalr	342(ra) # 80006252 <release>
}
    80006104:	60e2                	ld	ra,24(sp)
    80006106:	6442                	ld	s0,16(sp)
    80006108:	64a2                	ld	s1,8(sp)
    8000610a:	6105                	addi	sp,sp,32
    8000610c:	8082                	ret

000000008000610e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000610e:	1141                	addi	sp,sp,-16
    80006110:	e422                	sd	s0,8(sp)
    80006112:	0800                	addi	s0,sp,16
  lk->name = name;
    80006114:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006116:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000611a:	00053823          	sd	zero,16(a0)
}
    8000611e:	6422                	ld	s0,8(sp)
    80006120:	0141                	addi	sp,sp,16
    80006122:	8082                	ret

0000000080006124 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006124:	411c                	lw	a5,0(a0)
    80006126:	e399                	bnez	a5,8000612c <holding+0x8>
    80006128:	4501                	li	a0,0
  return r;
}
    8000612a:	8082                	ret
{
    8000612c:	1101                	addi	sp,sp,-32
    8000612e:	ec06                	sd	ra,24(sp)
    80006130:	e822                	sd	s0,16(sp)
    80006132:	e426                	sd	s1,8(sp)
    80006134:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006136:	6904                	ld	s1,16(a0)
    80006138:	ffffb097          	auipc	ra,0xffffb
    8000613c:	d36080e7          	jalr	-714(ra) # 80000e6e <mycpu>
    80006140:	40a48533          	sub	a0,s1,a0
    80006144:	00153513          	seqz	a0,a0
}
    80006148:	60e2                	ld	ra,24(sp)
    8000614a:	6442                	ld	s0,16(sp)
    8000614c:	64a2                	ld	s1,8(sp)
    8000614e:	6105                	addi	sp,sp,32
    80006150:	8082                	ret

0000000080006152 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006152:	1101                	addi	sp,sp,-32
    80006154:	ec06                	sd	ra,24(sp)
    80006156:	e822                	sd	s0,16(sp)
    80006158:	e426                	sd	s1,8(sp)
    8000615a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000615c:	100024f3          	csrr	s1,sstatus
    80006160:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006164:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006166:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    8000616a:	ffffb097          	auipc	ra,0xffffb
    8000616e:	d04080e7          	jalr	-764(ra) # 80000e6e <mycpu>
    80006172:	5d3c                	lw	a5,120(a0)
    80006174:	cf89                	beqz	a5,8000618e <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006176:	ffffb097          	auipc	ra,0xffffb
    8000617a:	cf8080e7          	jalr	-776(ra) # 80000e6e <mycpu>
    8000617e:	5d3c                	lw	a5,120(a0)
    80006180:	2785                	addiw	a5,a5,1
    80006182:	dd3c                	sw	a5,120(a0)
}
    80006184:	60e2                	ld	ra,24(sp)
    80006186:	6442                	ld	s0,16(sp)
    80006188:	64a2                	ld	s1,8(sp)
    8000618a:	6105                	addi	sp,sp,32
    8000618c:	8082                	ret
    mycpu()->intena = old;
    8000618e:	ffffb097          	auipc	ra,0xffffb
    80006192:	ce0080e7          	jalr	-800(ra) # 80000e6e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006196:	8085                	srli	s1,s1,0x1
    80006198:	8885                	andi	s1,s1,1
    8000619a:	dd64                	sw	s1,124(a0)
    8000619c:	bfe9                	j	80006176 <push_off+0x24>

000000008000619e <acquire>:
{
    8000619e:	1101                	addi	sp,sp,-32
    800061a0:	ec06                	sd	ra,24(sp)
    800061a2:	e822                	sd	s0,16(sp)
    800061a4:	e426                	sd	s1,8(sp)
    800061a6:	1000                	addi	s0,sp,32
    800061a8:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800061aa:	00000097          	auipc	ra,0x0
    800061ae:	fa8080e7          	jalr	-88(ra) # 80006152 <push_off>
  if(holding(lk))
    800061b2:	8526                	mv	a0,s1
    800061b4:	00000097          	auipc	ra,0x0
    800061b8:	f70080e7          	jalr	-144(ra) # 80006124 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061bc:	4705                	li	a4,1
  if(holding(lk))
    800061be:	e115                	bnez	a0,800061e2 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800061c0:	87ba                	mv	a5,a4
    800061c2:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800061c6:	2781                	sext.w	a5,a5
    800061c8:	ffe5                	bnez	a5,800061c0 <acquire+0x22>
  __sync_synchronize();
    800061ca:	0ff0000f          	fence
  lk->cpu = mycpu();
    800061ce:	ffffb097          	auipc	ra,0xffffb
    800061d2:	ca0080e7          	jalr	-864(ra) # 80000e6e <mycpu>
    800061d6:	e888                	sd	a0,16(s1)
}
    800061d8:	60e2                	ld	ra,24(sp)
    800061da:	6442                	ld	s0,16(sp)
    800061dc:	64a2                	ld	s1,8(sp)
    800061de:	6105                	addi	sp,sp,32
    800061e0:	8082                	ret
    panic("acquire");
    800061e2:	00003517          	auipc	a0,0x3
    800061e6:	87e50513          	addi	a0,a0,-1922 # 80008a60 <digits+0x20>
    800061ea:	00000097          	auipc	ra,0x0
    800061ee:	a7c080e7          	jalr	-1412(ra) # 80005c66 <panic>

00000000800061f2 <pop_off>:

void
pop_off(void)
{
    800061f2:	1141                	addi	sp,sp,-16
    800061f4:	e406                	sd	ra,8(sp)
    800061f6:	e022                	sd	s0,0(sp)
    800061f8:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800061fa:	ffffb097          	auipc	ra,0xffffb
    800061fe:	c74080e7          	jalr	-908(ra) # 80000e6e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006202:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006206:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006208:	e78d                	bnez	a5,80006232 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    8000620a:	5d3c                	lw	a5,120(a0)
    8000620c:	02f05b63          	blez	a5,80006242 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80006210:	37fd                	addiw	a5,a5,-1
    80006212:	0007871b          	sext.w	a4,a5
    80006216:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006218:	eb09                	bnez	a4,8000622a <pop_off+0x38>
    8000621a:	5d7c                	lw	a5,124(a0)
    8000621c:	c799                	beqz	a5,8000622a <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000621e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006222:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006226:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000622a:	60a2                	ld	ra,8(sp)
    8000622c:	6402                	ld	s0,0(sp)
    8000622e:	0141                	addi	sp,sp,16
    80006230:	8082                	ret
    panic("pop_off - interruptible");
    80006232:	00003517          	auipc	a0,0x3
    80006236:	83650513          	addi	a0,a0,-1994 # 80008a68 <digits+0x28>
    8000623a:	00000097          	auipc	ra,0x0
    8000623e:	a2c080e7          	jalr	-1492(ra) # 80005c66 <panic>
    panic("pop_off");
    80006242:	00003517          	auipc	a0,0x3
    80006246:	83e50513          	addi	a0,a0,-1986 # 80008a80 <digits+0x40>
    8000624a:	00000097          	auipc	ra,0x0
    8000624e:	a1c080e7          	jalr	-1508(ra) # 80005c66 <panic>

0000000080006252 <release>:
{
    80006252:	1101                	addi	sp,sp,-32
    80006254:	ec06                	sd	ra,24(sp)
    80006256:	e822                	sd	s0,16(sp)
    80006258:	e426                	sd	s1,8(sp)
    8000625a:	1000                	addi	s0,sp,32
    8000625c:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	ec6080e7          	jalr	-314(ra) # 80006124 <holding>
    80006266:	c115                	beqz	a0,8000628a <release+0x38>
  lk->cpu = 0;
    80006268:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000626c:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80006270:	0f50000f          	fence	iorw,ow
    80006274:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006278:	00000097          	auipc	ra,0x0
    8000627c:	f7a080e7          	jalr	-134(ra) # 800061f2 <pop_off>
}
    80006280:	60e2                	ld	ra,24(sp)
    80006282:	6442                	ld	s0,16(sp)
    80006284:	64a2                	ld	s1,8(sp)
    80006286:	6105                	addi	sp,sp,32
    80006288:	8082                	ret
    panic("release");
    8000628a:	00002517          	auipc	a0,0x2
    8000628e:	7fe50513          	addi	a0,a0,2046 # 80008a88 <digits+0x48>
    80006292:	00000097          	auipc	ra,0x0
    80006296:	9d4080e7          	jalr	-1580(ra) # 80005c66 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
