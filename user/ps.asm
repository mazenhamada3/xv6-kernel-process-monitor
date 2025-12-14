
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

#define MAX_PROCS 64  // xv6 limit

int main() {
   0:	81010113          	addi	sp,sp,-2032
   4:	7e113423          	sd	ra,2024(sp)
   8:	7e813023          	sd	s0,2016(sp)
   c:	7c913c23          	sd	s1,2008(sp)
  10:	7d213823          	sd	s2,2000(sp)
  14:	7d313423          	sd	s3,1992(sp)
  18:	7f010413          	addi	s0,sp,2032
  1c:	dc010113          	addi	sp,sp,-576
    // ---- Part 1: getpid + getppid ----
    int pid = getpid();
  20:	3b0000ef          	jal	3d0 <getpid>
  24:	892a                	mv	s2,a0
    int ppid = getppid();
  26:	3da000ef          	jal	400 <getppid>
  2a:	84aa                	mv	s1,a0

    printf("Current Process:\n");
  2c:	00001517          	auipc	a0,0x1
  30:	94450513          	addi	a0,a0,-1724 # 970 <malloc+0x104>
  34:	784000ef          	jal	7b8 <printf>
    printf("  PID:  %d\n", pid);
  38:	85ca                	mv	a1,s2
  3a:	00001517          	auipc	a0,0x1
  3e:	94e50513          	addi	a0,a0,-1714 # 988 <malloc+0x11c>
  42:	776000ef          	jal	7b8 <printf>
    printf("  PPID: %d\n\n", ppid);
  46:	85a6                	mv	a1,s1
  48:	00001517          	auipc	a0,0x1
  4c:	95050513          	addi	a0,a0,-1712 # 998 <malloc+0x12c>
  50:	768000ef          	jal	7b8 <printf>

    // ---- Part 2: getptable ----
    struct procinfo ptable[MAX_PROCS];

    int n = getptable(MAX_PROCS, ptable);  // <-- no cast!
  54:	75fd                	lui	a1,0xfffff
  56:	5d058793          	addi	a5,a1,1488 # fffffffffffff5d0 <base+0xffffffffffffe5c0>
  5a:	008785b3          	add	a1,a5,s0
  5e:	04000513          	li	a0,64
  62:	3be000ef          	jal	420 <getptable>
    if (n <= 0) {
  66:	06a05763          	blez	a0,d4 <main+0xd4>
  6a:	892a                	mv	s2,a0
        printf("getptable failed.\n");
        exit(0);
    }

    printf("Process Table (%d processes):\n", n);
  6c:	85aa                	mv	a1,a0
  6e:	00001517          	auipc	a0,0x1
  72:	95250513          	addi	a0,a0,-1710 # 9c0 <malloc+0x154>
  76:	742000ef          	jal	7b8 <printf>
    printf("PID\tPPID\tSTATE\tSIZE\tNAME\n");
  7a:	00001517          	auipc	a0,0x1
  7e:	96650513          	addi	a0,a0,-1690 # 9e0 <malloc+0x174>
  82:	736000ef          	jal	7b8 <printf>
    printf("---------------------------------------------\n");
  86:	00001517          	auipc	a0,0x1
  8a:	97a50513          	addi	a0,a0,-1670 # a00 <malloc+0x194>
  8e:	72a000ef          	jal	7b8 <printf>

    for (int i = 0; i < n; i++) {
  92:	74fd                	lui	s1,0xfffff
  94:	5e848793          	addi	a5,s1,1512 # fffffffffffff5e8 <base+0xffffffffffffe5d8>
  98:	008784b3          	add	s1,a5,s0
  9c:	02800793          	li	a5,40
  a0:	02f90933          	mul	s2,s2,a5
  a4:	9926                	add	s2,s2,s1
        printf("%d\t%d\t%d\t%lu\t%s\n",
  a6:	00001997          	auipc	s3,0x1
  aa:	98a98993          	addi	s3,s3,-1654 # a30 <malloc+0x1c4>
  ae:	87a6                	mv	a5,s1
  b0:	ff84b703          	ld	a4,-8(s1)
  b4:	ff04a683          	lw	a3,-16(s1)
  b8:	fec4a603          	lw	a2,-20(s1)
  bc:	fe84a583          	lw	a1,-24(s1)
  c0:	854e                	mv	a0,s3
  c2:	6f6000ef          	jal	7b8 <printf>
    for (int i = 0; i < n; i++) {
  c6:	02848493          	addi	s1,s1,40
  ca:	ff2492e3          	bne	s1,s2,ae <main+0xae>
               ptable[i].state,
               ptable[i].sz,
               ptable[i].name);
    }

    exit(0);
  ce:	4501                	li	a0,0
  d0:	280000ef          	jal	350 <exit>
        printf("getptable failed.\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	8d450513          	addi	a0,a0,-1836 # 9a8 <malloc+0x13c>
  dc:	6dc000ef          	jal	7b8 <printf>
        exit(0);
  e0:	4501                	li	a0,0
  e2:	26e000ef          	jal	350 <exit>

00000000000000e6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  extern int main();
  main();
  ee:	f13ff0ef          	jal	0 <main>
  exit(0);
  f2:	4501                	li	a0,0
  f4:	25c000ef          	jal	350 <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  fe:	87aa                	mv	a5,a0
 100:	0585                	addi	a1,a1,1
 102:	0785                	addi	a5,a5,1
 104:	fff5c703          	lbu	a4,-1(a1)
 108:	fee78fa3          	sb	a4,-1(a5)
 10c:	fb75                	bnez	a4,100 <strcpy+0x8>
    ;
  return os;
}
 10e:	6422                	ld	s0,8(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret

0000000000000114 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 114:	1141                	addi	sp,sp,-16
 116:	e422                	sd	s0,8(sp)
 118:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 11a:	00054783          	lbu	a5,0(a0)
 11e:	cb91                	beqz	a5,132 <strcmp+0x1e>
 120:	0005c703          	lbu	a4,0(a1)
 124:	00f71763          	bne	a4,a5,132 <strcmp+0x1e>
    p++, q++;
 128:	0505                	addi	a0,a0,1
 12a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbe5                	bnez	a5,120 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 132:	0005c503          	lbu	a0,0(a1)
}
 136:	40a7853b          	subw	a0,a5,a0
 13a:	6422                	ld	s0,8(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <strlen>:

uint
strlen(const char *s)
{
 140:	1141                	addi	sp,sp,-16
 142:	e422                	sd	s0,8(sp)
 144:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf91                	beqz	a5,166 <strlen+0x26>
 14c:	0505                	addi	a0,a0,1
 14e:	87aa                	mv	a5,a0
 150:	86be                	mv	a3,a5
 152:	0785                	addi	a5,a5,1
 154:	fff7c703          	lbu	a4,-1(a5)
 158:	ff65                	bnez	a4,150 <strlen+0x10>
 15a:	40a6853b          	subw	a0,a3,a0
 15e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 160:	6422                	ld	s0,8(sp)
 162:	0141                	addi	sp,sp,16
 164:	8082                	ret
  for(n = 0; s[n]; n++)
 166:	4501                	li	a0,0
 168:	bfe5                	j	160 <strlen+0x20>

000000000000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 170:	ca19                	beqz	a2,186 <memset+0x1c>
 172:	87aa                	mv	a5,a0
 174:	1602                	slli	a2,a2,0x20
 176:	9201                	srli	a2,a2,0x20
 178:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 17c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 180:	0785                	addi	a5,a5,1
 182:	fee79de3          	bne	a5,a4,17c <memset+0x12>
  }
  return dst;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strchr>:

char*
strchr(const char *s, char c)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	addi	s0,sp,16
  for(; *s; s++)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb99                	beqz	a5,1ac <strchr+0x20>
    if(*s == c)
 198:	00f58763          	beq	a1,a5,1a6 <strchr+0x1a>
  for(; *s; s++)
 19c:	0505                	addi	a0,a0,1
 19e:	00054783          	lbu	a5,0(a0)
 1a2:	fbfd                	bnez	a5,198 <strchr+0xc>
      return (char*)s;
  return 0;
 1a4:	4501                	li	a0,0
}
 1a6:	6422                	ld	s0,8(sp)
 1a8:	0141                	addi	sp,sp,16
 1aa:	8082                	ret
  return 0;
 1ac:	4501                	li	a0,0
 1ae:	bfe5                	j	1a6 <strchr+0x1a>

00000000000001b0 <gets>:

char*
gets(char *buf, int max)
{
 1b0:	711d                	addi	sp,sp,-96
 1b2:	ec86                	sd	ra,88(sp)
 1b4:	e8a2                	sd	s0,80(sp)
 1b6:	e4a6                	sd	s1,72(sp)
 1b8:	e0ca                	sd	s2,64(sp)
 1ba:	fc4e                	sd	s3,56(sp)
 1bc:	f852                	sd	s4,48(sp)
 1be:	f456                	sd	s5,40(sp)
 1c0:	f05a                	sd	s6,32(sp)
 1c2:	ec5e                	sd	s7,24(sp)
 1c4:	1080                	addi	s0,sp,96
 1c6:	8baa                	mv	s7,a0
 1c8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ca:	892a                	mv	s2,a0
 1cc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1ce:	4aa9                	li	s5,10
 1d0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1d2:	89a6                	mv	s3,s1
 1d4:	2485                	addiw	s1,s1,1
 1d6:	0344d663          	bge	s1,s4,202 <gets+0x52>
    cc = read(0, &c, 1);
 1da:	4605                	li	a2,1
 1dc:	faf40593          	addi	a1,s0,-81
 1e0:	4501                	li	a0,0
 1e2:	186000ef          	jal	368 <read>
    if(cc < 1)
 1e6:	00a05e63          	blez	a0,202 <gets+0x52>
    buf[i++] = c;
 1ea:	faf44783          	lbu	a5,-81(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1f2:	01578763          	beq	a5,s5,200 <gets+0x50>
 1f6:	0905                	addi	s2,s2,1
 1f8:	fd679de3          	bne	a5,s6,1d2 <gets+0x22>
    buf[i++] = c;
 1fc:	89a6                	mv	s3,s1
 1fe:	a011                	j	202 <gets+0x52>
 200:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 202:	99de                	add	s3,s3,s7
 204:	00098023          	sb	zero,0(s3)
  return buf;
}
 208:	855e                	mv	a0,s7
 20a:	60e6                	ld	ra,88(sp)
 20c:	6446                	ld	s0,80(sp)
 20e:	64a6                	ld	s1,72(sp)
 210:	6906                	ld	s2,64(sp)
 212:	79e2                	ld	s3,56(sp)
 214:	7a42                	ld	s4,48(sp)
 216:	7aa2                	ld	s5,40(sp)
 218:	7b02                	ld	s6,32(sp)
 21a:	6be2                	ld	s7,24(sp)
 21c:	6125                	addi	sp,sp,96
 21e:	8082                	ret

0000000000000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	1101                	addi	sp,sp,-32
 222:	ec06                	sd	ra,24(sp)
 224:	e822                	sd	s0,16(sp)
 226:	e04a                	sd	s2,0(sp)
 228:	1000                	addi	s0,sp,32
 22a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 22c:	4581                	li	a1,0
 22e:	162000ef          	jal	390 <open>
  if(fd < 0)
 232:	02054263          	bltz	a0,256 <stat+0x36>
 236:	e426                	sd	s1,8(sp)
 238:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 23a:	85ca                	mv	a1,s2
 23c:	16c000ef          	jal	3a8 <fstat>
 240:	892a                	mv	s2,a0
  close(fd);
 242:	8526                	mv	a0,s1
 244:	134000ef          	jal	378 <close>
  return r;
 248:	64a2                	ld	s1,8(sp)
}
 24a:	854a                	mv	a0,s2
 24c:	60e2                	ld	ra,24(sp)
 24e:	6442                	ld	s0,16(sp)
 250:	6902                	ld	s2,0(sp)
 252:	6105                	addi	sp,sp,32
 254:	8082                	ret
    return -1;
 256:	597d                	li	s2,-1
 258:	bfcd                	j	24a <stat+0x2a>

000000000000025a <atoi>:

int
atoi(const char *s)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e422                	sd	s0,8(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054683          	lbu	a3,0(a0)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	4625                	li	a2,9
 26e:	02f66863          	bltu	a2,a5,29e <atoi+0x44>
 272:	872a                	mv	a4,a0
  n = 0;
 274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 276:	0705                	addi	a4,a4,1
 278:	0025179b          	slliw	a5,a0,0x2
 27c:	9fa9                	addw	a5,a5,a0
 27e:	0017979b          	slliw	a5,a5,0x1
 282:	9fb5                	addw	a5,a5,a3
 284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 288:	00074683          	lbu	a3,0(a4)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	fef671e3          	bgeu	a2,a5,276 <atoi+0x1c>
  return n;
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <atoi+0x3e>

00000000000002a2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a8:	02b57463          	bgeu	a0,a1,2d0 <memmove+0x2e>
    while(n-- > 0)
 2ac:	00c05f63          	blez	a2,2ca <memmove+0x28>
 2b0:	1602                	slli	a2,a2,0x20
 2b2:	9201                	srli	a2,a2,0x20
 2b4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ba:	0585                	addi	a1,a1,1
 2bc:	0705                	addi	a4,a4,1
 2be:	fff5c683          	lbu	a3,-1(a1)
 2c2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c6:	fef71ae3          	bne	a4,a5,2ba <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ca:	6422                	ld	s0,8(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
    dst += n;
 2d0:	00c50733          	add	a4,a0,a2
    src += n;
 2d4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2d6:	fec05ae3          	blez	a2,2ca <memmove+0x28>
 2da:	fff6079b          	addiw	a5,a2,-1
 2de:	1782                	slli	a5,a5,0x20
 2e0:	9381                	srli	a5,a5,0x20
 2e2:	fff7c793          	not	a5,a5
 2e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e8:	15fd                	addi	a1,a1,-1
 2ea:	177d                	addi	a4,a4,-1
 2ec:	0005c683          	lbu	a3,0(a1)
 2f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f4:	fee79ae3          	bne	a5,a4,2e8 <memmove+0x46>
 2f8:	bfc9                	j	2ca <memmove+0x28>

00000000000002fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e422                	sd	s0,8(sp)
 2fe:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 300:	ca05                	beqz	a2,330 <memcmp+0x36>
 302:	fff6069b          	addiw	a3,a2,-1
 306:	1682                	slli	a3,a3,0x20
 308:	9281                	srli	a3,a3,0x20
 30a:	0685                	addi	a3,a3,1
 30c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 30e:	00054783          	lbu	a5,0(a0)
 312:	0005c703          	lbu	a4,0(a1)
 316:	00e79863          	bne	a5,a4,326 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 31a:	0505                	addi	a0,a0,1
    p2++;
 31c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31e:	fed518e3          	bne	a0,a3,30e <memcmp+0x14>
  }
  return 0;
 322:	4501                	li	a0,0
 324:	a019                	j	32a <memcmp+0x30>
      return *p1 - *p2;
 326:	40e7853b          	subw	a0,a5,a4
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfe5                	j	32a <memcmp+0x30>

0000000000000334 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33c:	f67ff0ef          	jal	2a2 <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 348:	4885                	li	a7,1
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <exit>:
.global exit
exit:
 li a7, SYS_exit
 350:	4889                	li	a7,2
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <wait>:
.global wait
wait:
 li a7, SYS_wait
 358:	488d                	li	a7,3
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 360:	4891                	li	a7,4
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <read>:
.global read
read:
 li a7, SYS_read
 368:	4895                	li	a7,5
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <write>:
.global write
write:
 li a7, SYS_write
 370:	48c1                	li	a7,16
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <close>:
.global close
close:
 li a7, SYS_close
 378:	48d5                	li	a7,21
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <kill>:
.global kill
kill:
 li a7, SYS_kill
 380:	4899                	li	a7,6
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exec>:
.global exec
exec:
 li a7, SYS_exec
 388:	489d                	li	a7,7
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <open>:
.global open
open:
 li a7, SYS_open
 390:	48bd                	li	a7,15
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 398:	48c5                	li	a7,17
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3a0:	48c9                	li	a7,18
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3a8:	48a1                	li	a7,8
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <link>:
.global link
link:
 li a7, SYS_link
 3b0:	48cd                	li	a7,19
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3b8:	48d1                	li	a7,20
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3c0:	48a5                	li	a7,9
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3c8:	48a9                	li	a7,10
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3d0:	48ad                	li	a7,11
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3d8:	48b1                	li	a7,12
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3e0:	48b5                	li	a7,13
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3e8:	48b9                	li	a7,14
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3f0:	48d9                	li	a7,22
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3f8:	48dd                	li	a7,23
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 400:	48e1                	li	a7,24
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <rand>:
.global rand
rand:
 li a7, SYS_rand
 408:	48e5                	li	a7,25
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 410:	48e9                	li	a7,26
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 418:	48ed                	li	a7,27
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 420:	48f1                	li	a7,28
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 428:	48f5                	li	a7,29
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 430:	48f9                	li	a7,30
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 438:	48fd                	li	a7,31
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 440:	1101                	addi	sp,sp,-32
 442:	ec06                	sd	ra,24(sp)
 444:	e822                	sd	s0,16(sp)
 446:	1000                	addi	s0,sp,32
 448:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 44c:	4605                	li	a2,1
 44e:	fef40593          	addi	a1,s0,-17
 452:	f1fff0ef          	jal	370 <write>
}
 456:	60e2                	ld	ra,24(sp)
 458:	6442                	ld	s0,16(sp)
 45a:	6105                	addi	sp,sp,32
 45c:	8082                	ret

000000000000045e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 45e:	7139                	addi	sp,sp,-64
 460:	fc06                	sd	ra,56(sp)
 462:	f822                	sd	s0,48(sp)
 464:	f426                	sd	s1,40(sp)
 466:	0080                	addi	s0,sp,64
 468:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46a:	c299                	beqz	a3,470 <printint+0x12>
 46c:	0805c963          	bltz	a1,4fe <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 470:	2581                	sext.w	a1,a1
  neg = 0;
 472:	4881                	li	a7,0
 474:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 478:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 47a:	2601                	sext.w	a2,a2
 47c:	00000517          	auipc	a0,0x0
 480:	5d450513          	addi	a0,a0,1492 # a50 <digits>
 484:	883a                	mv	a6,a4
 486:	2705                	addiw	a4,a4,1
 488:	02c5f7bb          	remuw	a5,a1,a2
 48c:	1782                	slli	a5,a5,0x20
 48e:	9381                	srli	a5,a5,0x20
 490:	97aa                	add	a5,a5,a0
 492:	0007c783          	lbu	a5,0(a5)
 496:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 49a:	0005879b          	sext.w	a5,a1
 49e:	02c5d5bb          	divuw	a1,a1,a2
 4a2:	0685                	addi	a3,a3,1
 4a4:	fec7f0e3          	bgeu	a5,a2,484 <printint+0x26>
  if(neg)
 4a8:	00088c63          	beqz	a7,4c0 <printint+0x62>
    buf[i++] = '-';
 4ac:	fd070793          	addi	a5,a4,-48
 4b0:	00878733          	add	a4,a5,s0
 4b4:	02d00793          	li	a5,45
 4b8:	fef70823          	sb	a5,-16(a4)
 4bc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4c0:	02e05a63          	blez	a4,4f4 <printint+0x96>
 4c4:	f04a                	sd	s2,32(sp)
 4c6:	ec4e                	sd	s3,24(sp)
 4c8:	fc040793          	addi	a5,s0,-64
 4cc:	00e78933          	add	s2,a5,a4
 4d0:	fff78993          	addi	s3,a5,-1
 4d4:	99ba                	add	s3,s3,a4
 4d6:	377d                	addiw	a4,a4,-1
 4d8:	1702                	slli	a4,a4,0x20
 4da:	9301                	srli	a4,a4,0x20
 4dc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e0:	fff94583          	lbu	a1,-1(s2)
 4e4:	8526                	mv	a0,s1
 4e6:	f5bff0ef          	jal	440 <putc>
  while(--i >= 0)
 4ea:	197d                	addi	s2,s2,-1
 4ec:	ff391ae3          	bne	s2,s3,4e0 <printint+0x82>
 4f0:	7902                	ld	s2,32(sp)
 4f2:	69e2                	ld	s3,24(sp)
}
 4f4:	70e2                	ld	ra,56(sp)
 4f6:	7442                	ld	s0,48(sp)
 4f8:	74a2                	ld	s1,40(sp)
 4fa:	6121                	addi	sp,sp,64
 4fc:	8082                	ret
    x = -xx;
 4fe:	40b005bb          	negw	a1,a1
    neg = 1;
 502:	4885                	li	a7,1
    x = -xx;
 504:	bf85                	j	474 <printint+0x16>

0000000000000506 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 506:	711d                	addi	sp,sp,-96
 508:	ec86                	sd	ra,88(sp)
 50a:	e8a2                	sd	s0,80(sp)
 50c:	e0ca                	sd	s2,64(sp)
 50e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 510:	0005c903          	lbu	s2,0(a1)
 514:	26090863          	beqz	s2,784 <vprintf+0x27e>
 518:	e4a6                	sd	s1,72(sp)
 51a:	fc4e                	sd	s3,56(sp)
 51c:	f852                	sd	s4,48(sp)
 51e:	f456                	sd	s5,40(sp)
 520:	f05a                	sd	s6,32(sp)
 522:	ec5e                	sd	s7,24(sp)
 524:	e862                	sd	s8,16(sp)
 526:	e466                	sd	s9,8(sp)
 528:	8b2a                	mv	s6,a0
 52a:	8a2e                	mv	s4,a1
 52c:	8bb2                	mv	s7,a2
  state = 0;
 52e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 530:	4481                	li	s1,0
 532:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 534:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 538:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 53c:	06c00c93          	li	s9,108
 540:	a005                	j	560 <vprintf+0x5a>
        putc(fd, c0);
 542:	85ca                	mv	a1,s2
 544:	855a                	mv	a0,s6
 546:	efbff0ef          	jal	440 <putc>
 54a:	a019                	j	550 <vprintf+0x4a>
    } else if(state == '%'){
 54c:	03598263          	beq	s3,s5,570 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 550:	2485                	addiw	s1,s1,1
 552:	8726                	mv	a4,s1
 554:	009a07b3          	add	a5,s4,s1
 558:	0007c903          	lbu	s2,0(a5)
 55c:	20090c63          	beqz	s2,774 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 560:	0009079b          	sext.w	a5,s2
    if(state == 0){
 564:	fe0994e3          	bnez	s3,54c <vprintf+0x46>
      if(c0 == '%'){
 568:	fd579de3          	bne	a5,s5,542 <vprintf+0x3c>
        state = '%';
 56c:	89be                	mv	s3,a5
 56e:	b7cd                	j	550 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 570:	00ea06b3          	add	a3,s4,a4
 574:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 578:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 57a:	c681                	beqz	a3,582 <vprintf+0x7c>
 57c:	9752                	add	a4,a4,s4
 57e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 582:	03878f63          	beq	a5,s8,5c0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 586:	05978963          	beq	a5,s9,5d8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 58a:	07500713          	li	a4,117
 58e:	0ee78363          	beq	a5,a4,674 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 592:	07800713          	li	a4,120
 596:	12e78563          	beq	a5,a4,6c0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 59a:	07000713          	li	a4,112
 59e:	14e78a63          	beq	a5,a4,6f2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5a2:	07300713          	li	a4,115
 5a6:	18e78a63          	beq	a5,a4,73a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5aa:	02500713          	li	a4,37
 5ae:	04e79563          	bne	a5,a4,5f8 <vprintf+0xf2>
        putc(fd, '%');
 5b2:	02500593          	li	a1,37
 5b6:	855a                	mv	a0,s6
 5b8:	e89ff0ef          	jal	440 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5bc:	4981                	li	s3,0
 5be:	bf49                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b8913          	addi	s2,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	855a                	mv	a0,s6
 5ce:	e91ff0ef          	jal	45e <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	bfad                	j	550 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5d8:	06400793          	li	a5,100
 5dc:	02f68963          	beq	a3,a5,60e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e0:	06c00793          	li	a5,108
 5e4:	04f68263          	beq	a3,a5,628 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5e8:	07500793          	li	a5,117
 5ec:	0af68063          	beq	a3,a5,68c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5f0:	07800793          	li	a5,120
 5f4:	0ef68263          	beq	a3,a5,6d8 <vprintf+0x1d2>
        putc(fd, '%');
 5f8:	02500593          	li	a1,37
 5fc:	855a                	mv	a0,s6
 5fe:	e43ff0ef          	jal	440 <putc>
        putc(fd, c0);
 602:	85ca                	mv	a1,s2
 604:	855a                	mv	a0,s6
 606:	e3bff0ef          	jal	440 <putc>
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b791                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	008b8913          	addi	s2,s7,8
 612:	4685                	li	a3,1
 614:	4629                	li	a2,10
 616:	000ba583          	lw	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	e43ff0ef          	jal	45e <printint>
        i += 1;
 620:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 622:	8bca                	mv	s7,s2
      state = 0;
 624:	4981                	li	s3,0
        i += 1;
 626:	b72d                	j	550 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 628:	06400793          	li	a5,100
 62c:	02f60763          	beq	a2,a5,65a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 630:	07500793          	li	a5,117
 634:	06f60963          	beq	a2,a5,6a6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 638:	07800793          	li	a5,120
 63c:	faf61ee3          	bne	a2,a5,5f8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	008b8913          	addi	s2,s7,8
 644:	4681                	li	a3,0
 646:	4641                	li	a2,16
 648:	000ba583          	lw	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	e11ff0ef          	jal	45e <printint>
        i += 2;
 652:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	8bca                	mv	s7,s2
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	bde5                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	008b8913          	addi	s2,s7,8
 65e:	4685                	li	a3,1
 660:	4629                	li	a2,10
 662:	000ba583          	lw	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	df7ff0ef          	jal	45e <printint>
        i += 2;
 66c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 66e:	8bca                	mv	s7,s2
      state = 0;
 670:	4981                	li	s3,0
        i += 2;
 672:	bdf9                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 674:	008b8913          	addi	s2,s7,8
 678:	4681                	li	a3,0
 67a:	4629                	li	a2,10
 67c:	000ba583          	lw	a1,0(s7)
 680:	855a                	mv	a0,s6
 682:	dddff0ef          	jal	45e <printint>
 686:	8bca                	mv	s7,s2
      state = 0;
 688:	4981                	li	s3,0
 68a:	b5d9                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b8913          	addi	s2,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	dc5ff0ef          	jal	45e <printint>
        i += 1;
 69e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	8bca                	mv	s7,s2
      state = 0;
 6a2:	4981                	li	s3,0
        i += 1;
 6a4:	b575                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	008b8913          	addi	s2,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000ba583          	lw	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	dabff0ef          	jal	45e <printint>
        i += 2;
 6b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ba:	8bca                	mv	s7,s2
      state = 0;
 6bc:	4981                	li	s3,0
        i += 2;
 6be:	bd49                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6c0:	008b8913          	addi	s2,s7,8
 6c4:	4681                	li	a3,0
 6c6:	4641                	li	a2,16
 6c8:	000ba583          	lw	a1,0(s7)
 6cc:	855a                	mv	a0,s6
 6ce:	d91ff0ef          	jal	45e <printint>
 6d2:	8bca                	mv	s7,s2
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	bdad                	j	550 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d8:	008b8913          	addi	s2,s7,8
 6dc:	4681                	li	a3,0
 6de:	4641                	li	a2,16
 6e0:	000ba583          	lw	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	d79ff0ef          	jal	45e <printint>
        i += 1;
 6ea:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	8bca                	mv	s7,s2
      state = 0;
 6ee:	4981                	li	s3,0
        i += 1;
 6f0:	b585                	j	550 <vprintf+0x4a>
 6f2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6f4:	008b8d13          	addi	s10,s7,8
 6f8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6fc:	03000593          	li	a1,48
 700:	855a                	mv	a0,s6
 702:	d3fff0ef          	jal	440 <putc>
  putc(fd, 'x');
 706:	07800593          	li	a1,120
 70a:	855a                	mv	a0,s6
 70c:	d35ff0ef          	jal	440 <putc>
 710:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 712:	00000b97          	auipc	s7,0x0
 716:	33eb8b93          	addi	s7,s7,830 # a50 <digits>
 71a:	03c9d793          	srli	a5,s3,0x3c
 71e:	97de                	add	a5,a5,s7
 720:	0007c583          	lbu	a1,0(a5)
 724:	855a                	mv	a0,s6
 726:	d1bff0ef          	jal	440 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 72a:	0992                	slli	s3,s3,0x4
 72c:	397d                	addiw	s2,s2,-1
 72e:	fe0916e3          	bnez	s2,71a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 732:	8bea                	mv	s7,s10
      state = 0;
 734:	4981                	li	s3,0
 736:	6d02                	ld	s10,0(sp)
 738:	bd21                	j	550 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 73a:	008b8993          	addi	s3,s7,8
 73e:	000bb903          	ld	s2,0(s7)
 742:	00090f63          	beqz	s2,760 <vprintf+0x25a>
        for(; *s; s++)
 746:	00094583          	lbu	a1,0(s2)
 74a:	c195                	beqz	a1,76e <vprintf+0x268>
          putc(fd, *s);
 74c:	855a                	mv	a0,s6
 74e:	cf3ff0ef          	jal	440 <putc>
        for(; *s; s++)
 752:	0905                	addi	s2,s2,1
 754:	00094583          	lbu	a1,0(s2)
 758:	f9f5                	bnez	a1,74c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 75a:	8bce                	mv	s7,s3
      state = 0;
 75c:	4981                	li	s3,0
 75e:	bbcd                	j	550 <vprintf+0x4a>
          s = "(null)";
 760:	00000917          	auipc	s2,0x0
 764:	2e890913          	addi	s2,s2,744 # a48 <malloc+0x1dc>
        for(; *s; s++)
 768:	02800593          	li	a1,40
 76c:	b7c5                	j	74c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 76e:	8bce                	mv	s7,s3
      state = 0;
 770:	4981                	li	s3,0
 772:	bbf9                	j	550 <vprintf+0x4a>
 774:	64a6                	ld	s1,72(sp)
 776:	79e2                	ld	s3,56(sp)
 778:	7a42                	ld	s4,48(sp)
 77a:	7aa2                	ld	s5,40(sp)
 77c:	7b02                	ld	s6,32(sp)
 77e:	6be2                	ld	s7,24(sp)
 780:	6c42                	ld	s8,16(sp)
 782:	6ca2                	ld	s9,8(sp)
    }
  }
}
 784:	60e6                	ld	ra,88(sp)
 786:	6446                	ld	s0,80(sp)
 788:	6906                	ld	s2,64(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 78e:	715d                	addi	sp,sp,-80
 790:	ec06                	sd	ra,24(sp)
 792:	e822                	sd	s0,16(sp)
 794:	1000                	addi	s0,sp,32
 796:	e010                	sd	a2,0(s0)
 798:	e414                	sd	a3,8(s0)
 79a:	e818                	sd	a4,16(s0)
 79c:	ec1c                	sd	a5,24(s0)
 79e:	03043023          	sd	a6,32(s0)
 7a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7aa:	8622                	mv	a2,s0
 7ac:	d5bff0ef          	jal	506 <vprintf>
}
 7b0:	60e2                	ld	ra,24(sp)
 7b2:	6442                	ld	s0,16(sp)
 7b4:	6161                	addi	sp,sp,80
 7b6:	8082                	ret

00000000000007b8 <printf>:

void
printf(const char *fmt, ...)
{
 7b8:	711d                	addi	sp,sp,-96
 7ba:	ec06                	sd	ra,24(sp)
 7bc:	e822                	sd	s0,16(sp)
 7be:	1000                	addi	s0,sp,32
 7c0:	e40c                	sd	a1,8(s0)
 7c2:	e810                	sd	a2,16(s0)
 7c4:	ec14                	sd	a3,24(s0)
 7c6:	f018                	sd	a4,32(s0)
 7c8:	f41c                	sd	a5,40(s0)
 7ca:	03043823          	sd	a6,48(s0)
 7ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d2:	00840613          	addi	a2,s0,8
 7d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7da:	85aa                	mv	a1,a0
 7dc:	4505                	li	a0,1
 7de:	d29ff0ef          	jal	506 <vprintf>
}
 7e2:	60e2                	ld	ra,24(sp)
 7e4:	6442                	ld	s0,16(sp)
 7e6:	6125                	addi	sp,sp,96
 7e8:	8082                	ret

00000000000007ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ea:	1141                	addi	sp,sp,-16
 7ec:	e422                	sd	s0,8(sp)
 7ee:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	00001797          	auipc	a5,0x1
 7f8:	80c7b783          	ld	a5,-2036(a5) # 1000 <freep>
 7fc:	a02d                	j	826 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7fe:	4618                	lw	a4,8(a2)
 800:	9f2d                	addw	a4,a4,a1
 802:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	6398                	ld	a4,0(a5)
 808:	6310                	ld	a2,0(a4)
 80a:	a83d                	j	848 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80c:	ff852703          	lw	a4,-8(a0)
 810:	9f31                	addw	a4,a4,a2
 812:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 814:	ff053683          	ld	a3,-16(a0)
 818:	a091                	j	85c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x3a>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x4a>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x30>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059813          	slli	a6,a1,0x20
 83e:	01c85713          	srli	a4,a6,0x1c
 842:	9736                	add	a4,a4,a3
 844:	fae60de3          	beq	a2,a4,7fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061593          	slli	a1,a2,0x20
 852:	01c5d713          	srli	a4,a1,0x1c
 856:	973e                	add	a4,a4,a5
 858:	fae68ae3          	beq	a3,a4,80c <free+0x22>
    p->s.ptr = bp->s.ptr;
 85c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	6422                	ld	s0,8(sp)
 868:	0141                	addi	sp,sp,16
 86a:	8082                	ret

000000000000086c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f426                	sd	s1,40(sp)
 874:	ec4e                	sd	s3,24(sp)
 876:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 878:	02051493          	slli	s1,a0,0x20
 87c:	9081                	srli	s1,s1,0x20
 87e:	04bd                	addi	s1,s1,15
 880:	8091                	srli	s1,s1,0x4
 882:	0014899b          	addiw	s3,s1,1
 886:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 888:	00000517          	auipc	a0,0x0
 88c:	77853503          	ld	a0,1912(a0) # 1000 <freep>
 890:	c915                	beqz	a0,8c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	08977a63          	bgeu	a4,s1,92a <malloc+0xbe>
 89a:	f04a                	sd	s2,32(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a2:	8a4e                	mv	s4,s3
 8a4:	0009871b          	sext.w	a4,s3
 8a8:	6685                	lui	a3,0x1
 8aa:	00d77363          	bgeu	a4,a3,8b0 <malloc+0x44>
 8ae:	6a05                	lui	s4,0x1
 8b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b8:	00000917          	auipc	s2,0x0
 8bc:	74890913          	addi	s2,s2,1864 # 1000 <freep>
  if(p == (char*)-1)
 8c0:	5afd                	li	s5,-1
 8c2:	a081                	j	902 <malloc+0x96>
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	e852                	sd	s4,16(sp)
 8c8:	e456                	sd	s5,8(sp)
 8ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8cc:	00000797          	auipc	a5,0x0
 8d0:	74478793          	addi	a5,a5,1860 # 1010 <base>
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72f73623          	sd	a5,1836(a4) # 1000 <freep>
 8dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e2:	b7c1                	j	8a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e4:	6398                	ld	a4,0(a5)
 8e6:	e118                	sd	a4,0(a0)
 8e8:	a8a9                	j	942 <malloc+0xd6>
  hp->s.size = nu;
 8ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8ee:	0541                	addi	a0,a0,16
 8f0:	efbff0ef          	jal	7ea <free>
  return freep;
 8f4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f8:	c12d                	beqz	a0,95a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8fc:	4798                	lw	a4,8(a5)
 8fe:	02977263          	bgeu	a4,s1,922 <malloc+0xb6>
    if(p == freep)
 902:	00093703          	ld	a4,0(s2)
 906:	853e                	mv	a0,a5
 908:	fef719e3          	bne	a4,a5,8fa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 90c:	8552                	mv	a0,s4
 90e:	acbff0ef          	jal	3d8 <sbrk>
  if(p == (char*)-1)
 912:	fd551ce3          	bne	a0,s5,8ea <malloc+0x7e>
        return 0;
 916:	4501                	li	a0,0
 918:	7902                	ld	s2,32(sp)
 91a:	6a42                	ld	s4,16(sp)
 91c:	6aa2                	ld	s5,8(sp)
 91e:	6b02                	ld	s6,0(sp)
 920:	a03d                	j	94e <malloc+0xe2>
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 92a:	fae48de3          	beq	s1,a4,8e4 <malloc+0x78>
        p->s.size -= nunits;
 92e:	4137073b          	subw	a4,a4,s3
 932:	c798                	sw	a4,8(a5)
        p += p->s.size;
 934:	02071693          	slli	a3,a4,0x20
 938:	01c6d713          	srli	a4,a3,0x1c
 93c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 93e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 942:	00000717          	auipc	a4,0x0
 946:	6aa73f23          	sd	a0,1726(a4) # 1000 <freep>
      return (void*)(p + 1);
 94a:	01078513          	addi	a0,a5,16
  }
}
 94e:	70e2                	ld	ra,56(sp)
 950:	7442                	ld	s0,48(sp)
 952:	74a2                	ld	s1,40(sp)
 954:	69e2                	ld	s3,24(sp)
 956:	6121                	addi	sp,sp,64
 958:	8082                	ret
 95a:	7902                	ld	s2,32(sp)
 95c:	6a42                	ld	s4,16(sp)
 95e:	6aa2                	ld	s5,8(sp)
 960:	6b02                	ld	s6,0(sp)
 962:	b7f5                	j	94e <malloc+0xe2>
