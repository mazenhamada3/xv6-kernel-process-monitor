
user/_spin:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;
  int j;
  int x = 0;

  if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50e63          	beq	a0,a5,26 <main+0x26>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: spin <iterations>\n");
  12:	00001597          	auipc	a1,0x1
  16:	8ee58593          	addi	a1,a1,-1810 # 900 <malloc+0xfe>
  1a:	4509                	li	a0,2
  1c:	708000ef          	jal	724 <fprintf>
    exit(1);
  20:	4505                	li	a0,1
  22:	2c4000ef          	jal	2e6 <exit>
  26:	e426                	sd	s1,8(sp)
  28:	e04a                	sd	s2,0(sp)
  }

  int t = atoi(argv[1]);
  2a:	6588                	ld	a0,8(a1)
  2c:	1c4000ef          	jal	1f0 <atoi>
  30:	84aa                	mv	s1,a0
  int pid = getpid();
  32:	334000ef          	jal	366 <getpid>
  36:	892a                	mv	s2,a0

  printf("(%d) spin started\n", pid);
  38:	85aa                	mv	a1,a0
  3a:	00001517          	auipc	a0,0x1
  3e:	8e650513          	addi	a0,a0,-1818 # 920 <malloc+0x11e>
  42:	70c000ef          	jal	74e <printf>
  int x = 0;
  46:	4601                	li	a2,0

  // Outer loop: 't' times
  for(i = 0; i < t; i++){
  48:	4681                	li	a3,0
    // Inner loop: 1 million times
    for(j = 0; j < 1000000; j++){
  4a:	4581                	li	a1,0
  4c:	000f4737          	lui	a4,0xf4
  50:	24070713          	addi	a4,a4,576 # f4240 <base+0xf3230>
  for(i = 0; i < t; i++){
  54:	00905a63          	blez	s1,68 <main+0x68>
    for(j = 0; j < 1000000; j++){
  58:	87ae                	mv	a5,a1
       x += j;
  5a:	9e3d                	addw	a2,a2,a5
    for(j = 0; j < 1000000; j++){
  5c:	2785                	addiw	a5,a5,1
  5e:	fee79ee3          	bne	a5,a4,5a <main+0x5a>
  for(i = 0; i < t; i++){
  62:	2685                	addiw	a3,a3,1
  64:	fed49ae3          	bne	s1,a3,58 <main+0x58>
    }
  }

  // IMPORTANT: We print 'x' here.
  // This forces the compiler to actually run the loop above!
  printf("(%d) spin finished val=%d\n", pid, x);
  68:	85ca                	mv	a1,s2
  6a:	00001517          	auipc	a0,0x1
  6e:	8ce50513          	addi	a0,a0,-1842 # 938 <malloc+0x136>
  72:	6dc000ef          	jal	74e <printf>
  exit(0);
  76:	4501                	li	a0,0
  78:	26e000ef          	jal	2e6 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  extern int main();
  main();
  84:	f7dff0ef          	jal	0 <main>
  exit(0);
  88:	4501                	li	a0,0
  8a:	25c000ef          	jal	2e6 <exit>

000000000000008e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  8e:	1141                	addi	sp,sp,-16
  90:	e422                	sd	s0,8(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0x8>
    ;
  return os;
}
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cb91                	beqz	a5,c8 <strcmp+0x1e>
  b6:	0005c703          	lbu	a4,0(a1)
  ba:	00f71763          	bne	a4,a5,c8 <strcmp+0x1e>
    p++, q++;
  be:	0505                	addi	a0,a0,1
  c0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	fbe5                	bnez	a5,b6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c8:	0005c503          	lbu	a0,0(a1)
}
  cc:	40a7853b          	subw	a0,a5,a0
  d0:	6422                	ld	s0,8(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret

00000000000000d6 <strlen>:

uint
strlen(const char *s)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e422                	sd	s0,8(sp)
  da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf91                	beqz	a5,fc <strlen+0x26>
  e2:	0505                	addi	a0,a0,1
  e4:	87aa                	mv	a5,a0
  e6:	86be                	mv	a3,a5
  e8:	0785                	addi	a5,a5,1
  ea:	fff7c703          	lbu	a4,-1(a5)
  ee:	ff65                	bnez	a4,e6 <strlen+0x10>
  f0:	40a6853b          	subw	a0,a3,a0
  f4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  f6:	6422                	ld	s0,8(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  for(n = 0; s[n]; n++)
  fc:	4501                	li	a0,0
  fe:	bfe5                	j	f6 <strlen+0x20>

0000000000000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	1141                	addi	sp,sp,-16
 102:	e422                	sd	s0,8(sp)
 104:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 106:	ca19                	beqz	a2,11c <memset+0x1c>
 108:	87aa                	mv	a5,a0
 10a:	1602                	slli	a2,a2,0x20
 10c:	9201                	srli	a2,a2,0x20
 10e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 112:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 116:	0785                	addi	a5,a5,1
 118:	fee79de3          	bne	a5,a4,112 <memset+0x12>
  }
  return dst;
}
 11c:	6422                	ld	s0,8(sp)
 11e:	0141                	addi	sp,sp,16
 120:	8082                	ret

0000000000000122 <strchr>:

char*
strchr(const char *s, char c)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  for(; *s; s++)
 128:	00054783          	lbu	a5,0(a0)
 12c:	cb99                	beqz	a5,142 <strchr+0x20>
    if(*s == c)
 12e:	00f58763          	beq	a1,a5,13c <strchr+0x1a>
  for(; *s; s++)
 132:	0505                	addi	a0,a0,1
 134:	00054783          	lbu	a5,0(a0)
 138:	fbfd                	bnez	a5,12e <strchr+0xc>
      return (char*)s;
  return 0;
 13a:	4501                	li	a0,0
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret
  return 0;
 142:	4501                	li	a0,0
 144:	bfe5                	j	13c <strchr+0x1a>

0000000000000146 <gets>:

char*
gets(char *buf, int max)
{
 146:	711d                	addi	sp,sp,-96
 148:	ec86                	sd	ra,88(sp)
 14a:	e8a2                	sd	s0,80(sp)
 14c:	e4a6                	sd	s1,72(sp)
 14e:	e0ca                	sd	s2,64(sp)
 150:	fc4e                	sd	s3,56(sp)
 152:	f852                	sd	s4,48(sp)
 154:	f456                	sd	s5,40(sp)
 156:	f05a                	sd	s6,32(sp)
 158:	ec5e                	sd	s7,24(sp)
 15a:	1080                	addi	s0,sp,96
 15c:	8baa                	mv	s7,a0
 15e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	892a                	mv	s2,a0
 162:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 164:	4aa9                	li	s5,10
 166:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 168:	89a6                	mv	s3,s1
 16a:	2485                	addiw	s1,s1,1
 16c:	0344d663          	bge	s1,s4,198 <gets+0x52>
    cc = read(0, &c, 1);
 170:	4605                	li	a2,1
 172:	faf40593          	addi	a1,s0,-81
 176:	4501                	li	a0,0
 178:	186000ef          	jal	2fe <read>
    if(cc < 1)
 17c:	00a05e63          	blez	a0,198 <gets+0x52>
    buf[i++] = c;
 180:	faf44783          	lbu	a5,-81(s0)
 184:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 188:	01578763          	beq	a5,s5,196 <gets+0x50>
 18c:	0905                	addi	s2,s2,1
 18e:	fd679de3          	bne	a5,s6,168 <gets+0x22>
    buf[i++] = c;
 192:	89a6                	mv	s3,s1
 194:	a011                	j	198 <gets+0x52>
 196:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 198:	99de                	add	s3,s3,s7
 19a:	00098023          	sb	zero,0(s3)
  return buf;
}
 19e:	855e                	mv	a0,s7
 1a0:	60e6                	ld	ra,88(sp)
 1a2:	6446                	ld	s0,80(sp)
 1a4:	64a6                	ld	s1,72(sp)
 1a6:	6906                	ld	s2,64(sp)
 1a8:	79e2                	ld	s3,56(sp)
 1aa:	7a42                	ld	s4,48(sp)
 1ac:	7aa2                	ld	s5,40(sp)
 1ae:	7b02                	ld	s6,32(sp)
 1b0:	6be2                	ld	s7,24(sp)
 1b2:	6125                	addi	sp,sp,96
 1b4:	8082                	ret

00000000000001b6 <stat>:

int
stat(const char *n, struct stat *st)
{
 1b6:	1101                	addi	sp,sp,-32
 1b8:	ec06                	sd	ra,24(sp)
 1ba:	e822                	sd	s0,16(sp)
 1bc:	e04a                	sd	s2,0(sp)
 1be:	1000                	addi	s0,sp,32
 1c0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c2:	4581                	li	a1,0
 1c4:	162000ef          	jal	326 <open>
  if(fd < 0)
 1c8:	02054263          	bltz	a0,1ec <stat+0x36>
 1cc:	e426                	sd	s1,8(sp)
 1ce:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d0:	85ca                	mv	a1,s2
 1d2:	16c000ef          	jal	33e <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	134000ef          	jal	30e <close>
  return r;
 1de:	64a2                	ld	s1,8(sp)
}
 1e0:	854a                	mv	a0,s2
 1e2:	60e2                	ld	ra,24(sp)
 1e4:	6442                	ld	s0,16(sp)
 1e6:	6902                	ld	s2,0(sp)
 1e8:	6105                	addi	sp,sp,32
 1ea:	8082                	ret
    return -1;
 1ec:	597d                	li	s2,-1
 1ee:	bfcd                	j	1e0 <stat+0x2a>

00000000000001f0 <atoi>:

int
atoi(const char *s)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1f6:	00054683          	lbu	a3,0(a0)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	4625                	li	a2,9
 204:	02f66863          	bltu	a2,a5,234 <atoi+0x44>
 208:	872a                	mv	a4,a0
  n = 0;
 20a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 20c:	0705                	addi	a4,a4,1
 20e:	0025179b          	slliw	a5,a0,0x2
 212:	9fa9                	addw	a5,a5,a0
 214:	0017979b          	slliw	a5,a5,0x1
 218:	9fb5                	addw	a5,a5,a3
 21a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 21e:	00074683          	lbu	a3,0(a4)
 222:	fd06879b          	addiw	a5,a3,-48
 226:	0ff7f793          	zext.b	a5,a5
 22a:	fef671e3          	bgeu	a2,a5,20c <atoi+0x1c>
  return n;
}
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
  n = 0;
 234:	4501                	li	a0,0
 236:	bfe5                	j	22e <atoi+0x3e>

0000000000000238 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 238:	1141                	addi	sp,sp,-16
 23a:	e422                	sd	s0,8(sp)
 23c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23e:	02b57463          	bgeu	a0,a1,266 <memmove+0x2e>
    while(n-- > 0)
 242:	00c05f63          	blez	a2,260 <memmove+0x28>
 246:	1602                	slli	a2,a2,0x20
 248:	9201                	srli	a2,a2,0x20
 24a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24e:	872a                	mv	a4,a0
      *dst++ = *src++;
 250:	0585                	addi	a1,a1,1
 252:	0705                	addi	a4,a4,1
 254:	fff5c683          	lbu	a3,-1(a1)
 258:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 25c:	fef71ae3          	bne	a4,a5,250 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 260:	6422                	ld	s0,8(sp)
 262:	0141                	addi	sp,sp,16
 264:	8082                	ret
    dst += n;
 266:	00c50733          	add	a4,a0,a2
    src += n;
 26a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 26c:	fec05ae3          	blez	a2,260 <memmove+0x28>
 270:	fff6079b          	addiw	a5,a2,-1
 274:	1782                	slli	a5,a5,0x20
 276:	9381                	srli	a5,a5,0x20
 278:	fff7c793          	not	a5,a5
 27c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27e:	15fd                	addi	a1,a1,-1
 280:	177d                	addi	a4,a4,-1
 282:	0005c683          	lbu	a3,0(a1)
 286:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x46>
 28e:	bfc9                	j	260 <memmove+0x28>

0000000000000290 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 290:	1141                	addi	sp,sp,-16
 292:	e422                	sd	s0,8(sp)
 294:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 296:	ca05                	beqz	a2,2c6 <memcmp+0x36>
 298:	fff6069b          	addiw	a3,a2,-1
 29c:	1682                	slli	a3,a3,0x20
 29e:	9281                	srli	a3,a3,0x20
 2a0:	0685                	addi	a3,a3,1
 2a2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2a4:	00054783          	lbu	a5,0(a0)
 2a8:	0005c703          	lbu	a4,0(a1)
 2ac:	00e79863          	bne	a5,a4,2bc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2b0:	0505                	addi	a0,a0,1
    p2++;
 2b2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b4:	fed518e3          	bne	a0,a3,2a4 <memcmp+0x14>
  }
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	a019                	j	2c0 <memcmp+0x30>
      return *p1 - *p2;
 2bc:	40e7853b          	subw	a0,a5,a4
}
 2c0:	6422                	ld	s0,8(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	bfe5                	j	2c0 <memcmp+0x30>

00000000000002ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ca:	1141                	addi	sp,sp,-16
 2cc:	e406                	sd	ra,8(sp)
 2ce:	e022                	sd	s0,0(sp)
 2d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d2:	f67ff0ef          	jal	238 <memmove>
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret

00000000000002de <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2de:	4885                	li	a7,1
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2e6:	4889                	li	a7,2
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ee:	488d                	li	a7,3
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2f6:	4891                	li	a7,4
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <read>:
.global read
read:
 li a7, SYS_read
 2fe:	4895                	li	a7,5
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <write>:
.global write
write:
 li a7, SYS_write
 306:	48c1                	li	a7,16
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <close>:
.global close
close:
 li a7, SYS_close
 30e:	48d5                	li	a7,21
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <kill>:
.global kill
kill:
 li a7, SYS_kill
 316:	4899                	li	a7,6
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <exec>:
.global exec
exec:
 li a7, SYS_exec
 31e:	489d                	li	a7,7
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <open>:
.global open
open:
 li a7, SYS_open
 326:	48bd                	li	a7,15
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 32e:	48c5                	li	a7,17
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 336:	48c9                	li	a7,18
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 33e:	48a1                	li	a7,8
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <link>:
.global link
link:
 li a7, SYS_link
 346:	48cd                	li	a7,19
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 34e:	48d1                	li	a7,20
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 356:	48a5                	li	a7,9
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <dup>:
.global dup
dup:
 li a7, SYS_dup
 35e:	48a9                	li	a7,10
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 366:	48ad                	li	a7,11
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 36e:	48b1                	li	a7,12
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 376:	48b5                	li	a7,13
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 37e:	48b9                	li	a7,14
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 386:	48d9                	li	a7,22
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 38e:	48dd                	li	a7,23
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 396:	48e1                	li	a7,24
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <rand>:
.global rand
rand:
 li a7, SYS_rand
 39e:	48e5                	li	a7,25
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 3a6:	48e9                	li	a7,26
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3ae:	48ed                	li	a7,27
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3b6:	48f1                	li	a7,28
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3be:	48f5                	li	a7,29
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 3c6:	48f9                	li	a7,30
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 3ce:	48fd                	li	a7,31
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d6:	1101                	addi	sp,sp,-32
 3d8:	ec06                	sd	ra,24(sp)
 3da:	e822                	sd	s0,16(sp)
 3dc:	1000                	addi	s0,sp,32
 3de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e2:	4605                	li	a2,1
 3e4:	fef40593          	addi	a1,s0,-17
 3e8:	f1fff0ef          	jal	306 <write>
}
 3ec:	60e2                	ld	ra,24(sp)
 3ee:	6442                	ld	s0,16(sp)
 3f0:	6105                	addi	sp,sp,32
 3f2:	8082                	ret

00000000000003f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3f4:	7139                	addi	sp,sp,-64
 3f6:	fc06                	sd	ra,56(sp)
 3f8:	f822                	sd	s0,48(sp)
 3fa:	f426                	sd	s1,40(sp)
 3fc:	0080                	addi	s0,sp,64
 3fe:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 400:	c299                	beqz	a3,406 <printint+0x12>
 402:	0805c963          	bltz	a1,494 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 406:	2581                	sext.w	a1,a1
  neg = 0;
 408:	4881                	li	a7,0
 40a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 40e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 410:	2601                	sext.w	a2,a2
 412:	00000517          	auipc	a0,0x0
 416:	54e50513          	addi	a0,a0,1358 # 960 <digits>
 41a:	883a                	mv	a6,a4
 41c:	2705                	addiw	a4,a4,1
 41e:	02c5f7bb          	remuw	a5,a1,a2
 422:	1782                	slli	a5,a5,0x20
 424:	9381                	srli	a5,a5,0x20
 426:	97aa                	add	a5,a5,a0
 428:	0007c783          	lbu	a5,0(a5)
 42c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 430:	0005879b          	sext.w	a5,a1
 434:	02c5d5bb          	divuw	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fec7f0e3          	bgeu	a5,a2,41a <printint+0x26>
  if(neg)
 43e:	00088c63          	beqz	a7,456 <printint+0x62>
    buf[i++] = '-';
 442:	fd070793          	addi	a5,a4,-48
 446:	00878733          	add	a4,a5,s0
 44a:	02d00793          	li	a5,45
 44e:	fef70823          	sb	a5,-16(a4)
 452:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 456:	02e05a63          	blez	a4,48a <printint+0x96>
 45a:	f04a                	sd	s2,32(sp)
 45c:	ec4e                	sd	s3,24(sp)
 45e:	fc040793          	addi	a5,s0,-64
 462:	00e78933          	add	s2,a5,a4
 466:	fff78993          	addi	s3,a5,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	377d                	addiw	a4,a4,-1
 46e:	1702                	slli	a4,a4,0x20
 470:	9301                	srli	a4,a4,0x20
 472:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 476:	fff94583          	lbu	a1,-1(s2)
 47a:	8526                	mv	a0,s1
 47c:	f5bff0ef          	jal	3d6 <putc>
  while(--i >= 0)
 480:	197d                	addi	s2,s2,-1
 482:	ff391ae3          	bne	s2,s3,476 <printint+0x82>
 486:	7902                	ld	s2,32(sp)
 488:	69e2                	ld	s3,24(sp)
}
 48a:	70e2                	ld	ra,56(sp)
 48c:	7442                	ld	s0,48(sp)
 48e:	74a2                	ld	s1,40(sp)
 490:	6121                	addi	sp,sp,64
 492:	8082                	ret
    x = -xx;
 494:	40b005bb          	negw	a1,a1
    neg = 1;
 498:	4885                	li	a7,1
    x = -xx;
 49a:	bf85                	j	40a <printint+0x16>

000000000000049c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 49c:	711d                	addi	sp,sp,-96
 49e:	ec86                	sd	ra,88(sp)
 4a0:	e8a2                	sd	s0,80(sp)
 4a2:	e0ca                	sd	s2,64(sp)
 4a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a6:	0005c903          	lbu	s2,0(a1)
 4aa:	26090863          	beqz	s2,71a <vprintf+0x27e>
 4ae:	e4a6                	sd	s1,72(sp)
 4b0:	fc4e                	sd	s3,56(sp)
 4b2:	f852                	sd	s4,48(sp)
 4b4:	f456                	sd	s5,40(sp)
 4b6:	f05a                	sd	s6,32(sp)
 4b8:	ec5e                	sd	s7,24(sp)
 4ba:	e862                	sd	s8,16(sp)
 4bc:	e466                	sd	s9,8(sp)
 4be:	8b2a                	mv	s6,a0
 4c0:	8a2e                	mv	s4,a1
 4c2:	8bb2                	mv	s7,a2
  state = 0;
 4c4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4c6:	4481                	li	s1,0
 4c8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ca:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4ce:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4d2:	06c00c93          	li	s9,108
 4d6:	a005                	j	4f6 <vprintf+0x5a>
        putc(fd, c0);
 4d8:	85ca                	mv	a1,s2
 4da:	855a                	mv	a0,s6
 4dc:	efbff0ef          	jal	3d6 <putc>
 4e0:	a019                	j	4e6 <vprintf+0x4a>
    } else if(state == '%'){
 4e2:	03598263          	beq	s3,s5,506 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4e6:	2485                	addiw	s1,s1,1
 4e8:	8726                	mv	a4,s1
 4ea:	009a07b3          	add	a5,s4,s1
 4ee:	0007c903          	lbu	s2,0(a5)
 4f2:	20090c63          	beqz	s2,70a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4f6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4fa:	fe0994e3          	bnez	s3,4e2 <vprintf+0x46>
      if(c0 == '%'){
 4fe:	fd579de3          	bne	a5,s5,4d8 <vprintf+0x3c>
        state = '%';
 502:	89be                	mv	s3,a5
 504:	b7cd                	j	4e6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 506:	00ea06b3          	add	a3,s4,a4
 50a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 50e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 510:	c681                	beqz	a3,518 <vprintf+0x7c>
 512:	9752                	add	a4,a4,s4
 514:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 518:	03878f63          	beq	a5,s8,556 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 51c:	05978963          	beq	a5,s9,56e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 520:	07500713          	li	a4,117
 524:	0ee78363          	beq	a5,a4,60a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 528:	07800713          	li	a4,120
 52c:	12e78563          	beq	a5,a4,656 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 530:	07000713          	li	a4,112
 534:	14e78a63          	beq	a5,a4,688 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 538:	07300713          	li	a4,115
 53c:	18e78a63          	beq	a5,a4,6d0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 540:	02500713          	li	a4,37
 544:	04e79563          	bne	a5,a4,58e <vprintf+0xf2>
        putc(fd, '%');
 548:	02500593          	li	a1,37
 54c:	855a                	mv	a0,s6
 54e:	e89ff0ef          	jal	3d6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 552:	4981                	li	s3,0
 554:	bf49                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8913          	addi	s2,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	e91ff0ef          	jal	3f4 <printint>
 568:	8bca                	mv	s7,s2
      state = 0;
 56a:	4981                	li	s3,0
 56c:	bfad                	j	4e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 56e:	06400793          	li	a5,100
 572:	02f68963          	beq	a3,a5,5a4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 576:	06c00793          	li	a5,108
 57a:	04f68263          	beq	a3,a5,5be <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 57e:	07500793          	li	a5,117
 582:	0af68063          	beq	a3,a5,622 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 586:	07800793          	li	a5,120
 58a:	0ef68263          	beq	a3,a5,66e <vprintf+0x1d2>
        putc(fd, '%');
 58e:	02500593          	li	a1,37
 592:	855a                	mv	a0,s6
 594:	e43ff0ef          	jal	3d6 <putc>
        putc(fd, c0);
 598:	85ca                	mv	a1,s2
 59a:	855a                	mv	a0,s6
 59c:	e3bff0ef          	jal	3d6 <putc>
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	b791                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4685                	li	a3,1
 5aa:	4629                	li	a2,10
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e43ff0ef          	jal	3f4 <printint>
        i += 1;
 5b6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b8:	8bca                	mv	s7,s2
      state = 0;
 5ba:	4981                	li	s3,0
        i += 1;
 5bc:	b72d                	j	4e6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5be:	06400793          	li	a5,100
 5c2:	02f60763          	beq	a2,a5,5f0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5c6:	07500793          	li	a5,117
 5ca:	06f60963          	beq	a2,a5,63c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5ce:	07800793          	li	a5,120
 5d2:	faf61ee3          	bne	a2,a5,58e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d6:	008b8913          	addi	s2,s7,8
 5da:	4681                	li	a3,0
 5dc:	4641                	li	a2,16
 5de:	000ba583          	lw	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e11ff0ef          	jal	3f4 <printint>
        i += 2;
 5e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	8bca                	mv	s7,s2
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	bde5                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8913          	addi	s2,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000ba583          	lw	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	df7ff0ef          	jal	3f4 <printint>
        i += 2;
 602:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8bca                	mv	s7,s2
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bdf9                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 60a:	008b8913          	addi	s2,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	dddff0ef          	jal	3f4 <printint>
 61c:	8bca                	mv	s7,s2
      state = 0;
 61e:	4981                	li	s3,0
 620:	b5d9                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8913          	addi	s2,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	dc5ff0ef          	jal	3f4 <printint>
        i += 1;
 634:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8bca                	mv	s7,s2
      state = 0;
 638:	4981                	li	s3,0
        i += 1;
 63a:	b575                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8913          	addi	s2,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000ba583          	lw	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dabff0ef          	jal	3f4 <printint>
        i += 2;
 64e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8bca                	mv	s7,s2
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	bd49                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 656:	008b8913          	addi	s2,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000ba583          	lw	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	d91ff0ef          	jal	3f4 <printint>
 668:	8bca                	mv	s7,s2
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bdad                	j	4e6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8913          	addi	s2,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000ba583          	lw	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	d79ff0ef          	jal	3f4 <printint>
        i += 1;
 680:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8bca                	mv	s7,s2
      state = 0;
 684:	4981                	li	s3,0
        i += 1;
 686:	b585                	j	4e6 <vprintf+0x4a>
 688:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 68a:	008b8d13          	addi	s10,s7,8
 68e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 692:	03000593          	li	a1,48
 696:	855a                	mv	a0,s6
 698:	d3fff0ef          	jal	3d6 <putc>
  putc(fd, 'x');
 69c:	07800593          	li	a1,120
 6a0:	855a                	mv	a0,s6
 6a2:	d35ff0ef          	jal	3d6 <putc>
 6a6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a8:	00000b97          	auipc	s7,0x0
 6ac:	2b8b8b93          	addi	s7,s7,696 # 960 <digits>
 6b0:	03c9d793          	srli	a5,s3,0x3c
 6b4:	97de                	add	a5,a5,s7
 6b6:	0007c583          	lbu	a1,0(a5)
 6ba:	855a                	mv	a0,s6
 6bc:	d1bff0ef          	jal	3d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c0:	0992                	slli	s3,s3,0x4
 6c2:	397d                	addiw	s2,s2,-1
 6c4:	fe0916e3          	bnez	s2,6b0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6c8:	8bea                	mv	s7,s10
      state = 0;
 6ca:	4981                	li	s3,0
 6cc:	6d02                	ld	s10,0(sp)
 6ce:	bd21                	j	4e6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6d0:	008b8993          	addi	s3,s7,8
 6d4:	000bb903          	ld	s2,0(s7)
 6d8:	00090f63          	beqz	s2,6f6 <vprintf+0x25a>
        for(; *s; s++)
 6dc:	00094583          	lbu	a1,0(s2)
 6e0:	c195                	beqz	a1,704 <vprintf+0x268>
          putc(fd, *s);
 6e2:	855a                	mv	a0,s6
 6e4:	cf3ff0ef          	jal	3d6 <putc>
        for(; *s; s++)
 6e8:	0905                	addi	s2,s2,1
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	f9f5                	bnez	a1,6e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	8bce                	mv	s7,s3
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bbcd                	j	4e6 <vprintf+0x4a>
          s = "(null)";
 6f6:	00000917          	auipc	s2,0x0
 6fa:	26290913          	addi	s2,s2,610 # 958 <malloc+0x156>
        for(; *s; s++)
 6fe:	02800593          	li	a1,40
 702:	b7c5                	j	6e2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 704:	8bce                	mv	s7,s3
      state = 0;
 706:	4981                	li	s3,0
 708:	bbf9                	j	4e6 <vprintf+0x4a>
 70a:	64a6                	ld	s1,72(sp)
 70c:	79e2                	ld	s3,56(sp)
 70e:	7a42                	ld	s4,48(sp)
 710:	7aa2                	ld	s5,40(sp)
 712:	7b02                	ld	s6,32(sp)
 714:	6be2                	ld	s7,24(sp)
 716:	6c42                	ld	s8,16(sp)
 718:	6ca2                	ld	s9,8(sp)
    }
  }
}
 71a:	60e6                	ld	ra,88(sp)
 71c:	6446                	ld	s0,80(sp)
 71e:	6906                	ld	s2,64(sp)
 720:	6125                	addi	sp,sp,96
 722:	8082                	ret

0000000000000724 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 724:	715d                	addi	sp,sp,-80
 726:	ec06                	sd	ra,24(sp)
 728:	e822                	sd	s0,16(sp)
 72a:	1000                	addi	s0,sp,32
 72c:	e010                	sd	a2,0(s0)
 72e:	e414                	sd	a3,8(s0)
 730:	e818                	sd	a4,16(s0)
 732:	ec1c                	sd	a5,24(s0)
 734:	03043023          	sd	a6,32(s0)
 738:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 740:	8622                	mv	a2,s0
 742:	d5bff0ef          	jal	49c <vprintf>
}
 746:	60e2                	ld	ra,24(sp)
 748:	6442                	ld	s0,16(sp)
 74a:	6161                	addi	sp,sp,80
 74c:	8082                	ret

000000000000074e <printf>:

void
printf(const char *fmt, ...)
{
 74e:	711d                	addi	sp,sp,-96
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	addi	s0,sp,32
 756:	e40c                	sd	a1,8(s0)
 758:	e810                	sd	a2,16(s0)
 75a:	ec14                	sd	a3,24(s0)
 75c:	f018                	sd	a4,32(s0)
 75e:	f41c                	sd	a5,40(s0)
 760:	03043823          	sd	a6,48(s0)
 764:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 768:	00840613          	addi	a2,s0,8
 76c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 770:	85aa                	mv	a1,a0
 772:	4505                	li	a0,1
 774:	d29ff0ef          	jal	49c <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret

0000000000000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	1141                	addi	sp,sp,-16
 782:	e422                	sd	s0,8(sp)
 784:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 786:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78a:	00001797          	auipc	a5,0x1
 78e:	8767b783          	ld	a5,-1930(a5) # 1000 <freep>
 792:	a02d                	j	7bc <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 794:	4618                	lw	a4,8(a2)
 796:	9f2d                	addw	a4,a4,a1
 798:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 79c:	6398                	ld	a4,0(a5)
 79e:	6310                	ld	a2,0(a4)
 7a0:	a83d                	j	7de <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7a2:	ff852703          	lw	a4,-8(a0)
 7a6:	9f31                	addw	a4,a4,a2
 7a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7aa:	ff053683          	ld	a3,-16(a0)
 7ae:	a091                	j	7f2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	6398                	ld	a4,0(a5)
 7b2:	00e7e463          	bltu	a5,a4,7ba <free+0x3a>
 7b6:	00e6ea63          	bltu	a3,a4,7ca <free+0x4a>
{
 7ba:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	fed7fae3          	bgeu	a5,a3,7b0 <free+0x30>
 7c0:	6398                	ld	a4,0(a5)
 7c2:	00e6e463          	bltu	a3,a4,7ca <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	fee7eae3          	bltu	a5,a4,7ba <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7ca:	ff852583          	lw	a1,-8(a0)
 7ce:	6390                	ld	a2,0(a5)
 7d0:	02059813          	slli	a6,a1,0x20
 7d4:	01c85713          	srli	a4,a6,0x1c
 7d8:	9736                	add	a4,a4,a3
 7da:	fae60de3          	beq	a2,a4,794 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7de:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7e2:	4790                	lw	a2,8(a5)
 7e4:	02061593          	slli	a1,a2,0x20
 7e8:	01c5d713          	srli	a4,a1,0x1c
 7ec:	973e                	add	a4,a4,a5
 7ee:	fae68ae3          	beq	a3,a4,7a2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7f2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f4:	00001717          	auipc	a4,0x1
 7f8:	80f73623          	sd	a5,-2036(a4) # 1000 <freep>
}
 7fc:	6422                	ld	s0,8(sp)
 7fe:	0141                	addi	sp,sp,16
 800:	8082                	ret

0000000000000802 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 802:	7139                	addi	sp,sp,-64
 804:	fc06                	sd	ra,56(sp)
 806:	f822                	sd	s0,48(sp)
 808:	f426                	sd	s1,40(sp)
 80a:	ec4e                	sd	s3,24(sp)
 80c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80e:	02051493          	slli	s1,a0,0x20
 812:	9081                	srli	s1,s1,0x20
 814:	04bd                	addi	s1,s1,15
 816:	8091                	srli	s1,s1,0x4
 818:	0014899b          	addiw	s3,s1,1
 81c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 81e:	00000517          	auipc	a0,0x0
 822:	7e253503          	ld	a0,2018(a0) # 1000 <freep>
 826:	c915                	beqz	a0,85a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	08977a63          	bgeu	a4,s1,8c0 <malloc+0xbe>
 830:	f04a                	sd	s2,32(sp)
 832:	e852                	sd	s4,16(sp)
 834:	e456                	sd	s5,8(sp)
 836:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 838:	8a4e                	mv	s4,s3
 83a:	0009871b          	sext.w	a4,s3
 83e:	6685                	lui	a3,0x1
 840:	00d77363          	bgeu	a4,a3,846 <malloc+0x44>
 844:	6a05                	lui	s4,0x1
 846:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 84e:	00000917          	auipc	s2,0x0
 852:	7b290913          	addi	s2,s2,1970 # 1000 <freep>
  if(p == (char*)-1)
 856:	5afd                	li	s5,-1
 858:	a081                	j	898 <malloc+0x96>
 85a:	f04a                	sd	s2,32(sp)
 85c:	e852                	sd	s4,16(sp)
 85e:	e456                	sd	s5,8(sp)
 860:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 862:	00000797          	auipc	a5,0x0
 866:	7ae78793          	addi	a5,a5,1966 # 1010 <base>
 86a:	00000717          	auipc	a4,0x0
 86e:	78f73b23          	sd	a5,1942(a4) # 1000 <freep>
 872:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 874:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 878:	b7c1                	j	838 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 87a:	6398                	ld	a4,0(a5)
 87c:	e118                	sd	a4,0(a0)
 87e:	a8a9                	j	8d8 <malloc+0xd6>
  hp->s.size = nu;
 880:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 884:	0541                	addi	a0,a0,16
 886:	efbff0ef          	jal	780 <free>
  return freep;
 88a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 88e:	c12d                	beqz	a0,8f0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 892:	4798                	lw	a4,8(a5)
 894:	02977263          	bgeu	a4,s1,8b8 <malloc+0xb6>
    if(p == freep)
 898:	00093703          	ld	a4,0(s2)
 89c:	853e                	mv	a0,a5
 89e:	fef719e3          	bne	a4,a5,890 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8a2:	8552                	mv	a0,s4
 8a4:	acbff0ef          	jal	36e <sbrk>
  if(p == (char*)-1)
 8a8:	fd551ce3          	bne	a0,s5,880 <malloc+0x7e>
        return 0;
 8ac:	4501                	li	a0,0
 8ae:	7902                	ld	s2,32(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
 8b6:	a03d                	j	8e4 <malloc+0xe2>
 8b8:	7902                	ld	s2,32(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c0:	fae48de3          	beq	s1,a4,87a <malloc+0x78>
        p->s.size -= nunits;
 8c4:	4137073b          	subw	a4,a4,s3
 8c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ca:	02071693          	slli	a3,a4,0x20
 8ce:	01c6d713          	srli	a4,a3,0x1c
 8d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72a73423          	sd	a0,1832(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e0:	01078513          	addi	a0,a5,16
  }
}
 8e4:	70e2                	ld	ra,56(sp)
 8e6:	7442                	ld	s0,48(sp)
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	69e2                	ld	s3,24(sp)
 8ec:	6121                	addi	sp,sp,64
 8ee:	8082                	ret
 8f0:	7902                	ld	s2,32(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	b7f5                	j	8e4 <malloc+0xe2>
