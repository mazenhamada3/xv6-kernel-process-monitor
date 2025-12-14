
user/_metrics:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	1800                	addi	s0,sp,48
  struct sched_metrics m;

  if (getmetrics(&m) < 0) {
   8:	fd840513          	addi	a0,s0,-40
   c:	3d0000ef          	jal	3dc <getmetrics>
  10:	04054c63          	bltz	a0,68 <main+0x68>
    fprintf(2, "Error getting metrics.\n");
    exit(1);
  }

  printf("Scheduler Metrics:\n");
  14:	00001517          	auipc	a0,0x1
  18:	91450513          	addi	a0,a0,-1772 # 928 <malloc+0x118>
  1c:	740000ef          	jal	75c <printf>
  printf("  Finished Processes: %lu\n", m.finished);
  20:	fe843583          	ld	a1,-24(s0)
  24:	00001517          	auipc	a0,0x1
  28:	91c50513          	addi	a0,a0,-1764 # 940 <malloc+0x130>
  2c:	730000ef          	jal	75c <printf>

  if (m.finished > 0) {
  30:	fe843783          	ld	a5,-24(s0)
  34:	c7a1                	beqz	a5,7c <main+0x7c>
      // We divide by 'finished' to get the average
      printf("  Avg Turnaround Time: %lu ticks\n", m.turnaround / m.finished);
  36:	fd843583          	ld	a1,-40(s0)
  3a:	02f5d5b3          	divu	a1,a1,a5
  3e:	00001517          	auipc	a0,0x1
  42:	92250513          	addi	a0,a0,-1758 # 960 <malloc+0x150>
  46:	716000ef          	jal	75c <printf>
      printf("  Avg Waiting Time: %lu ticks\n", m.waiting / m.finished);
  4a:	fe043583          	ld	a1,-32(s0)
  4e:	fe843783          	ld	a5,-24(s0)
  52:	02f5d5b3          	divu	a1,a1,a5
  56:	00001517          	auipc	a0,0x1
  5a:	93250513          	addi	a0,a0,-1742 # 988 <malloc+0x178>
  5e:	6fe000ef          	jal	75c <printf>
  } else {
      printf("  No processes finished yet.\n");
  }

  exit(0);
  62:	4501                	li	a0,0
  64:	290000ef          	jal	2f4 <exit>
    fprintf(2, "Error getting metrics.\n");
  68:	00001597          	auipc	a1,0x1
  6c:	8a858593          	addi	a1,a1,-1880 # 910 <malloc+0x100>
  70:	4509                	li	a0,2
  72:	6c0000ef          	jal	732 <fprintf>
    exit(1);
  76:	4505                	li	a0,1
  78:	27c000ef          	jal	2f4 <exit>
      printf("  No processes finished yet.\n");
  7c:	00001517          	auipc	a0,0x1
  80:	92c50513          	addi	a0,a0,-1748 # 9a8 <malloc+0x198>
  84:	6d8000ef          	jal	75c <printf>
  88:	bfe9                	j	62 <main+0x62>

000000000000008a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  extern int main();
  main();
  92:	f6fff0ef          	jal	0 <main>
  exit(0);
  96:	4501                	li	a0,0
  98:	25c000ef          	jal	2f4 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a2:	87aa                	mv	a5,a0
  a4:	0585                	addi	a1,a1,1
  a6:	0785                	addi	a5,a5,1
  a8:	fff5c703          	lbu	a4,-1(a1)
  ac:	fee78fa3          	sb	a4,-1(a5)
  b0:	fb75                	bnez	a4,a4 <strcpy+0x8>
    ;
  return os;
}
  b2:	6422                	ld	s0,8(sp)
  b4:	0141                	addi	sp,sp,16
  b6:	8082                	ret

00000000000000b8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b8:	1141                	addi	sp,sp,-16
  ba:	e422                	sd	s0,8(sp)
  bc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	cb91                	beqz	a5,d6 <strcmp+0x1e>
  c4:	0005c703          	lbu	a4,0(a1)
  c8:	00f71763          	bne	a4,a5,d6 <strcmp+0x1e>
    p++, q++;
  cc:	0505                	addi	a0,a0,1
  ce:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbe5                	bnez	a5,c4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  d6:	0005c503          	lbu	a0,0(a1)
}
  da:	40a7853b          	subw	a0,a5,a0
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret

00000000000000e4 <strlen>:

uint
strlen(const char *s)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e422                	sd	s0,8(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x26>
  f0:	0505                	addi	a0,a0,1
  f2:	87aa                	mv	a5,a0
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x10>
  fe:	40a6853b          	subw	a0,a3,a0
 102:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 104:	6422                	ld	s0,8(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfe5                	j	104 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e422                	sd	s0,8(sp)
 112:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 114:	ca19                	beqz	a2,12a <memset+0x1c>
 116:	87aa                	mv	a5,a0
 118:	1602                	slli	a2,a2,0x20
 11a:	9201                	srli	a2,a2,0x20
 11c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 120:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 124:	0785                	addi	a5,a5,1
 126:	fee79de3          	bne	a5,a4,120 <memset+0x12>
  }
  return dst;
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret

0000000000000130 <strchr>:

char*
strchr(const char *s, char c)
{
 130:	1141                	addi	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	addi	s0,sp,16
  for(; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	cb99                	beqz	a5,150 <strchr+0x20>
    if(*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1a>
  for(; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xc>
      return (char*)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  return 0;
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strchr+0x1a>

0000000000000154 <gets>:

char*
gets(char *buf, int max)
{
 154:	711d                	addi	sp,sp,-96
 156:	ec86                	sd	ra,88(sp)
 158:	e8a2                	sd	s0,80(sp)
 15a:	e4a6                	sd	s1,72(sp)
 15c:	e0ca                	sd	s2,64(sp)
 15e:	fc4e                	sd	s3,56(sp)
 160:	f852                	sd	s4,48(sp)
 162:	f456                	sd	s5,40(sp)
 164:	f05a                	sd	s6,32(sp)
 166:	ec5e                	sd	s7,24(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 172:	4aa9                	li	s5,10
 174:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 176:	89a6                	mv	s3,s1
 178:	2485                	addiw	s1,s1,1
 17a:	0344d663          	bge	s1,s4,1a6 <gets+0x52>
    cc = read(0, &c, 1);
 17e:	4605                	li	a2,1
 180:	faf40593          	addi	a1,s0,-81
 184:	4501                	li	a0,0
 186:	186000ef          	jal	30c <read>
    if(cc < 1)
 18a:	00a05e63          	blez	a0,1a6 <gets+0x52>
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 196:	01578763          	beq	a5,s5,1a4 <gets+0x50>
 19a:	0905                	addi	s2,s2,1
 19c:	fd679de3          	bne	a5,s6,176 <gets+0x22>
    buf[i++] = c;
 1a0:	89a6                	mv	s3,s1
 1a2:	a011                	j	1a6 <gets+0x52>
 1a4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1a6:	99de                	add	s3,s3,s7
 1a8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1ac:	855e                	mv	a0,s7
 1ae:	60e6                	ld	ra,88(sp)
 1b0:	6446                	ld	s0,80(sp)
 1b2:	64a6                	ld	s1,72(sp)
 1b4:	6906                	ld	s2,64(sp)
 1b6:	79e2                	ld	s3,56(sp)
 1b8:	7a42                	ld	s4,48(sp)
 1ba:	7aa2                	ld	s5,40(sp)
 1bc:	7b02                	ld	s6,32(sp)
 1be:	6be2                	ld	s7,24(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	162000ef          	jal	334 <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	16c000ef          	jal	34c <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	134000ef          	jal	31c <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	597d                	li	s2,-1
 1fc:	bfcd                	j	1ee <stat+0x2a>

00000000000001fe <atoi>:

int
atoi(const char *s)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e422                	sd	s0,8(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66863          	bltu	a2,a5,242 <atoi+0x44>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1c>
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <atoi+0x3e>

0000000000000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24c:	02b57463          	bgeu	a0,a1,274 <memmove+0x2e>
    while(n-- > 0)
 250:	00c05f63          	blez	a2,26e <memmove+0x28>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25c:	872a                	mv	a4,a0
      *dst++ = *src++;
 25e:	0585                	addi	a1,a1,1
 260:	0705                	addi	a4,a4,1
 262:	fff5c683          	lbu	a3,-1(a1)
 266:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 26a:	fef71ae3          	bne	a4,a5,25e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26e:	6422                	ld	s0,8(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    dst += n;
 274:	00c50733          	add	a4,a0,a2
    src += n;
 278:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 27a:	fec05ae3          	blez	a2,26e <memmove+0x28>
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 298:	fee79ae3          	bne	a5,a4,28c <memmove+0x46>
 29c:	bfc9                	j	26e <memmove+0x28>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e422                	sd	s0,8(sp)
 2a2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a4:	ca05                	beqz	a2,2d4 <memcmp+0x36>
 2a6:	fff6069b          	addiw	a3,a2,-1
 2aa:	1682                	slli	a3,a3,0x20
 2ac:	9281                	srli	a3,a3,0x20
 2ae:	0685                	addi	a3,a3,1
 2b0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2b2:	00054783          	lbu	a5,0(a0)
 2b6:	0005c703          	lbu	a4,0(a1)
 2ba:	00e79863          	bne	a5,a4,2ca <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2be:	0505                	addi	a0,a0,1
    p2++;
 2c0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c2:	fed518e3          	bne	a0,a3,2b2 <memcmp+0x14>
  }
  return 0;
 2c6:	4501                	li	a0,0
 2c8:	a019                	j	2ce <memcmp+0x30>
      return *p1 - *p2;
 2ca:	40e7853b          	subw	a0,a5,a4
}
 2ce:	6422                	ld	s0,8(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	bfe5                	j	2ce <memcmp+0x30>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ec:	4885                	li	a7,1
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f4:	4889                	li	a7,2
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2fc:	488d                	li	a7,3
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 304:	4891                	li	a7,4
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <read>:
.global read
read:
 li a7, SYS_read
 30c:	4895                	li	a7,5
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <write>:
.global write
write:
 li a7, SYS_write
 314:	48c1                	li	a7,16
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <close>:
.global close
close:
 li a7, SYS_close
 31c:	48d5                	li	a7,21
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <kill>:
.global kill
kill:
 li a7, SYS_kill
 324:	4899                	li	a7,6
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exec>:
.global exec
exec:
 li a7, SYS_exec
 32c:	489d                	li	a7,7
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <open>:
.global open
open:
 li a7, SYS_open
 334:	48bd                	li	a7,15
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 33c:	48c5                	li	a7,17
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 344:	48c9                	li	a7,18
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 34c:	48a1                	li	a7,8
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <link>:
.global link
link:
 li a7, SYS_link
 354:	48cd                	li	a7,19
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 35c:	48d1                	li	a7,20
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 364:	48a5                	li	a7,9
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <dup>:
.global dup
dup:
 li a7, SYS_dup
 36c:	48a9                	li	a7,10
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 374:	48ad                	li	a7,11
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 37c:	48b1                	li	a7,12
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 384:	48b5                	li	a7,13
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 38c:	48b9                	li	a7,14
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 394:	48d9                	li	a7,22
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 39c:	48dd                	li	a7,23
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3a4:	48e1                	li	a7,24
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <rand>:
.global rand
rand:
 li a7, SYS_rand
 3ac:	48e5                	li	a7,25
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 3b4:	48e9                	li	a7,26
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3bc:	48ed                	li	a7,27
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3c4:	48f1                	li	a7,28
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3cc:	48f5                	li	a7,29
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 3d4:	48f9                	li	a7,30
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 3dc:	48fd                	li	a7,31
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	f1fff0ef          	jal	314 <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 402:	7139                	addi	sp,sp,-64
 404:	fc06                	sd	ra,56(sp)
 406:	f822                	sd	s0,48(sp)
 408:	f426                	sd	s1,40(sp)
 40a:	0080                	addi	s0,sp,64
 40c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40e:	c299                	beqz	a3,414 <printint+0x12>
 410:	0805c963          	bltz	a1,4a2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 414:	2581                	sext.w	a1,a1
  neg = 0;
 416:	4881                	li	a7,0
 418:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 41c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41e:	2601                	sext.w	a2,a2
 420:	00000517          	auipc	a0,0x0
 424:	5b050513          	addi	a0,a0,1456 # 9d0 <digits>
 428:	883a                	mv	a6,a4
 42a:	2705                	addiw	a4,a4,1
 42c:	02c5f7bb          	remuw	a5,a1,a2
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	97aa                	add	a5,a5,a0
 436:	0007c783          	lbu	a5,0(a5)
 43a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 43e:	0005879b          	sext.w	a5,a1
 442:	02c5d5bb          	divuw	a1,a1,a2
 446:	0685                	addi	a3,a3,1
 448:	fec7f0e3          	bgeu	a5,a2,428 <printint+0x26>
  if(neg)
 44c:	00088c63          	beqz	a7,464 <printint+0x62>
    buf[i++] = '-';
 450:	fd070793          	addi	a5,a4,-48
 454:	00878733          	add	a4,a5,s0
 458:	02d00793          	li	a5,45
 45c:	fef70823          	sb	a5,-16(a4)
 460:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 464:	02e05a63          	blez	a4,498 <printint+0x96>
 468:	f04a                	sd	s2,32(sp)
 46a:	ec4e                	sd	s3,24(sp)
 46c:	fc040793          	addi	a5,s0,-64
 470:	00e78933          	add	s2,a5,a4
 474:	fff78993          	addi	s3,a5,-1
 478:	99ba                	add	s3,s3,a4
 47a:	377d                	addiw	a4,a4,-1
 47c:	1702                	slli	a4,a4,0x20
 47e:	9301                	srli	a4,a4,0x20
 480:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 484:	fff94583          	lbu	a1,-1(s2)
 488:	8526                	mv	a0,s1
 48a:	f5bff0ef          	jal	3e4 <putc>
  while(--i >= 0)
 48e:	197d                	addi	s2,s2,-1
 490:	ff391ae3          	bne	s2,s3,484 <printint+0x82>
 494:	7902                	ld	s2,32(sp)
 496:	69e2                	ld	s3,24(sp)
}
 498:	70e2                	ld	ra,56(sp)
 49a:	7442                	ld	s0,48(sp)
 49c:	74a2                	ld	s1,40(sp)
 49e:	6121                	addi	sp,sp,64
 4a0:	8082                	ret
    x = -xx;
 4a2:	40b005bb          	negw	a1,a1
    neg = 1;
 4a6:	4885                	li	a7,1
    x = -xx;
 4a8:	bf85                	j	418 <printint+0x16>

00000000000004aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4aa:	711d                	addi	sp,sp,-96
 4ac:	ec86                	sd	ra,88(sp)
 4ae:	e8a2                	sd	s0,80(sp)
 4b0:	e0ca                	sd	s2,64(sp)
 4b2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4b4:	0005c903          	lbu	s2,0(a1)
 4b8:	26090863          	beqz	s2,728 <vprintf+0x27e>
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	fc4e                	sd	s3,56(sp)
 4c0:	f852                	sd	s4,48(sp)
 4c2:	f456                	sd	s5,40(sp)
 4c4:	f05a                	sd	s6,32(sp)
 4c6:	ec5e                	sd	s7,24(sp)
 4c8:	e862                	sd	s8,16(sp)
 4ca:	e466                	sd	s9,8(sp)
 4cc:	8b2a                	mv	s6,a0
 4ce:	8a2e                	mv	s4,a1
 4d0:	8bb2                	mv	s7,a2
  state = 0;
 4d2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4d4:	4481                	li	s1,0
 4d6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4d8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4dc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4e0:	06c00c93          	li	s9,108
 4e4:	a005                	j	504 <vprintf+0x5a>
        putc(fd, c0);
 4e6:	85ca                	mv	a1,s2
 4e8:	855a                	mv	a0,s6
 4ea:	efbff0ef          	jal	3e4 <putc>
 4ee:	a019                	j	4f4 <vprintf+0x4a>
    } else if(state == '%'){
 4f0:	03598263          	beq	s3,s5,514 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4f4:	2485                	addiw	s1,s1,1
 4f6:	8726                	mv	a4,s1
 4f8:	009a07b3          	add	a5,s4,s1
 4fc:	0007c903          	lbu	s2,0(a5)
 500:	20090c63          	beqz	s2,718 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 504:	0009079b          	sext.w	a5,s2
    if(state == 0){
 508:	fe0994e3          	bnez	s3,4f0 <vprintf+0x46>
      if(c0 == '%'){
 50c:	fd579de3          	bne	a5,s5,4e6 <vprintf+0x3c>
        state = '%';
 510:	89be                	mv	s3,a5
 512:	b7cd                	j	4f4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 514:	00ea06b3          	add	a3,s4,a4
 518:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 51c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 51e:	c681                	beqz	a3,526 <vprintf+0x7c>
 520:	9752                	add	a4,a4,s4
 522:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 526:	03878f63          	beq	a5,s8,564 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 52a:	05978963          	beq	a5,s9,57c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 52e:	07500713          	li	a4,117
 532:	0ee78363          	beq	a5,a4,618 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 536:	07800713          	li	a4,120
 53a:	12e78563          	beq	a5,a4,664 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 53e:	07000713          	li	a4,112
 542:	14e78a63          	beq	a5,a4,696 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 546:	07300713          	li	a4,115
 54a:	18e78a63          	beq	a5,a4,6de <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 54e:	02500713          	li	a4,37
 552:	04e79563          	bne	a5,a4,59c <vprintf+0xf2>
        putc(fd, '%');
 556:	02500593          	li	a1,37
 55a:	855a                	mv	a0,s6
 55c:	e89ff0ef          	jal	3e4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 560:	4981                	li	s3,0
 562:	bf49                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 564:	008b8913          	addi	s2,s7,8
 568:	4685                	li	a3,1
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	e91ff0ef          	jal	402 <printint>
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	bfad                	j	4f4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	06400793          	li	a5,100
 580:	02f68963          	beq	a3,a5,5b2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 584:	06c00793          	li	a5,108
 588:	04f68263          	beq	a3,a5,5cc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 58c:	07500793          	li	a5,117
 590:	0af68063          	beq	a3,a5,630 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 594:	07800793          	li	a5,120
 598:	0ef68263          	beq	a3,a5,67c <vprintf+0x1d2>
        putc(fd, '%');
 59c:	02500593          	li	a1,37
 5a0:	855a                	mv	a0,s6
 5a2:	e43ff0ef          	jal	3e4 <putc>
        putc(fd, c0);
 5a6:	85ca                	mv	a1,s2
 5a8:	855a                	mv	a0,s6
 5aa:	e3bff0ef          	jal	3e4 <putc>
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b791                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e43ff0ef          	jal	402 <printint>
        i += 1;
 5c4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
        i += 1;
 5ca:	b72d                	j	4f4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	06400793          	li	a5,100
 5d0:	02f60763          	beq	a2,a5,5fe <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5d4:	07500793          	li	a5,117
 5d8:	06f60963          	beq	a2,a5,64a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5dc:	07800793          	li	a5,120
 5e0:	faf61ee3          	bne	a2,a5,59c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	008b8913          	addi	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	e11ff0ef          	jal	402 <printint>
        i += 2;
 5f6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
        i += 2;
 5fc:	bde5                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	df7ff0ef          	jal	402 <printint>
        i += 2;
 610:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 2;
 616:	bdf9                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 618:	008b8913          	addi	s2,s7,8
 61c:	4681                	li	a3,0
 61e:	4629                	li	a2,10
 620:	000ba583          	lw	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	dddff0ef          	jal	402 <printint>
 62a:	8bca                	mv	s7,s2
      state = 0;
 62c:	4981                	li	s3,0
 62e:	b5d9                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 630:	008b8913          	addi	s2,s7,8
 634:	4681                	li	a3,0
 636:	4629                	li	a2,10
 638:	000ba583          	lw	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	dc5ff0ef          	jal	402 <printint>
        i += 1;
 642:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	8bca                	mv	s7,s2
      state = 0;
 646:	4981                	li	s3,0
        i += 1;
 648:	b575                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	008b8913          	addi	s2,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000ba583          	lw	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	dabff0ef          	jal	402 <printint>
        i += 2;
 65c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	8bca                	mv	s7,s2
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	bd49                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 664:	008b8913          	addi	s2,s7,8
 668:	4681                	li	a3,0
 66a:	4641                	li	a2,16
 66c:	000ba583          	lw	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	d91ff0ef          	jal	402 <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	bdad                	j	4f4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67c:	008b8913          	addi	s2,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000ba583          	lw	a1,0(s7)
 688:	855a                	mv	a0,s6
 68a:	d79ff0ef          	jal	402 <printint>
        i += 1;
 68e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	8bca                	mv	s7,s2
      state = 0;
 692:	4981                	li	s3,0
        i += 1;
 694:	b585                	j	4f4 <vprintf+0x4a>
 696:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 698:	008b8d13          	addi	s10,s7,8
 69c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a0:	03000593          	li	a1,48
 6a4:	855a                	mv	a0,s6
 6a6:	d3fff0ef          	jal	3e4 <putc>
  putc(fd, 'x');
 6aa:	07800593          	li	a1,120
 6ae:	855a                	mv	a0,s6
 6b0:	d35ff0ef          	jal	3e4 <putc>
 6b4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b6:	00000b97          	auipc	s7,0x0
 6ba:	31ab8b93          	addi	s7,s7,794 # 9d0 <digits>
 6be:	03c9d793          	srli	a5,s3,0x3c
 6c2:	97de                	add	a5,a5,s7
 6c4:	0007c583          	lbu	a1,0(a5)
 6c8:	855a                	mv	a0,s6
 6ca:	d1bff0ef          	jal	3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ce:	0992                	slli	s3,s3,0x4
 6d0:	397d                	addiw	s2,s2,-1
 6d2:	fe0916e3          	bnez	s2,6be <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6d6:	8bea                	mv	s7,s10
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	6d02                	ld	s10,0(sp)
 6dc:	bd21                	j	4f4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6de:	008b8993          	addi	s3,s7,8
 6e2:	000bb903          	ld	s2,0(s7)
 6e6:	00090f63          	beqz	s2,704 <vprintf+0x25a>
        for(; *s; s++)
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	c195                	beqz	a1,712 <vprintf+0x268>
          putc(fd, *s);
 6f0:	855a                	mv	a0,s6
 6f2:	cf3ff0ef          	jal	3e4 <putc>
        for(; *s; s++)
 6f6:	0905                	addi	s2,s2,1
 6f8:	00094583          	lbu	a1,0(s2)
 6fc:	f9f5                	bnez	a1,6f0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	8bce                	mv	s7,s3
      state = 0;
 700:	4981                	li	s3,0
 702:	bbcd                	j	4f4 <vprintf+0x4a>
          s = "(null)";
 704:	00000917          	auipc	s2,0x0
 708:	2c490913          	addi	s2,s2,708 # 9c8 <malloc+0x1b8>
        for(; *s; s++)
 70c:	02800593          	li	a1,40
 710:	b7c5                	j	6f0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 712:	8bce                	mv	s7,s3
      state = 0;
 714:	4981                	li	s3,0
 716:	bbf9                	j	4f4 <vprintf+0x4a>
 718:	64a6                	ld	s1,72(sp)
 71a:	79e2                	ld	s3,56(sp)
 71c:	7a42                	ld	s4,48(sp)
 71e:	7aa2                	ld	s5,40(sp)
 720:	7b02                	ld	s6,32(sp)
 722:	6be2                	ld	s7,24(sp)
 724:	6c42                	ld	s8,16(sp)
 726:	6ca2                	ld	s9,8(sp)
    }
  }
}
 728:	60e6                	ld	ra,88(sp)
 72a:	6446                	ld	s0,80(sp)
 72c:	6906                	ld	s2,64(sp)
 72e:	6125                	addi	sp,sp,96
 730:	8082                	ret

0000000000000732 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 732:	715d                	addi	sp,sp,-80
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	addi	s0,sp,32
 73a:	e010                	sd	a2,0(s0)
 73c:	e414                	sd	a3,8(s0)
 73e:	e818                	sd	a4,16(s0)
 740:	ec1c                	sd	a5,24(s0)
 742:	03043023          	sd	a6,32(s0)
 746:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 74a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74e:	8622                	mv	a2,s0
 750:	d5bff0ef          	jal	4aa <vprintf>
}
 754:	60e2                	ld	ra,24(sp)
 756:	6442                	ld	s0,16(sp)
 758:	6161                	addi	sp,sp,80
 75a:	8082                	ret

000000000000075c <printf>:

void
printf(const char *fmt, ...)
{
 75c:	711d                	addi	sp,sp,-96
 75e:	ec06                	sd	ra,24(sp)
 760:	e822                	sd	s0,16(sp)
 762:	1000                	addi	s0,sp,32
 764:	e40c                	sd	a1,8(s0)
 766:	e810                	sd	a2,16(s0)
 768:	ec14                	sd	a3,24(s0)
 76a:	f018                	sd	a4,32(s0)
 76c:	f41c                	sd	a5,40(s0)
 76e:	03043823          	sd	a6,48(s0)
 772:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	00840613          	addi	a2,s0,8
 77a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77e:	85aa                	mv	a1,a0
 780:	4505                	li	a0,1
 782:	d29ff0ef          	jal	4aa <vprintf>
}
 786:	60e2                	ld	ra,24(sp)
 788:	6442                	ld	s0,16(sp)
 78a:	6125                	addi	sp,sp,96
 78c:	8082                	ret

000000000000078e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78e:	1141                	addi	sp,sp,-16
 790:	e422                	sd	s0,8(sp)
 792:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 794:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	00001797          	auipc	a5,0x1
 79c:	8687b783          	ld	a5,-1944(a5) # 1000 <freep>
 7a0:	a02d                	j	7ca <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7a2:	4618                	lw	a4,8(a2)
 7a4:	9f2d                	addw	a4,a4,a1
 7a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7aa:	6398                	ld	a4,0(a5)
 7ac:	6310                	ld	a2,0(a4)
 7ae:	a83d                	j	7ec <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7b0:	ff852703          	lw	a4,-8(a0)
 7b4:	9f31                	addw	a4,a4,a2
 7b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7b8:	ff053683          	ld	a3,-16(a0)
 7bc:	a091                	j	800 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	6398                	ld	a4,0(a5)
 7c0:	00e7e463          	bltu	a5,a4,7c8 <free+0x3a>
 7c4:	00e6ea63          	bltu	a3,a4,7d8 <free+0x4a>
{
 7c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	fed7fae3          	bgeu	a5,a3,7be <free+0x30>
 7ce:	6398                	ld	a4,0(a5)
 7d0:	00e6e463          	bltu	a3,a4,7d8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	fee7eae3          	bltu	a5,a4,7c8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7d8:	ff852583          	lw	a1,-8(a0)
 7dc:	6390                	ld	a2,0(a5)
 7de:	02059813          	slli	a6,a1,0x20
 7e2:	01c85713          	srli	a4,a6,0x1c
 7e6:	9736                	add	a4,a4,a3
 7e8:	fae60de3          	beq	a2,a4,7a2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7f0:	4790                	lw	a2,8(a5)
 7f2:	02061593          	slli	a1,a2,0x20
 7f6:	01c5d713          	srli	a4,a1,0x1c
 7fa:	973e                	add	a4,a4,a5
 7fc:	fae68ae3          	beq	a3,a4,7b0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 800:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 802:	00000717          	auipc	a4,0x0
 806:	7ef73f23          	sd	a5,2046(a4) # 1000 <freep>
}
 80a:	6422                	ld	s0,8(sp)
 80c:	0141                	addi	sp,sp,16
 80e:	8082                	ret

0000000000000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	7139                	addi	sp,sp,-64
 812:	fc06                	sd	ra,56(sp)
 814:	f822                	sd	s0,48(sp)
 816:	f426                	sd	s1,40(sp)
 818:	ec4e                	sd	s3,24(sp)
 81a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81c:	02051493          	slli	s1,a0,0x20
 820:	9081                	srli	s1,s1,0x20
 822:	04bd                	addi	s1,s1,15
 824:	8091                	srli	s1,s1,0x4
 826:	0014899b          	addiw	s3,s1,1
 82a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 82c:	00000517          	auipc	a0,0x0
 830:	7d453503          	ld	a0,2004(a0) # 1000 <freep>
 834:	c915                	beqz	a0,868 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 836:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 838:	4798                	lw	a4,8(a5)
 83a:	08977a63          	bgeu	a4,s1,8ce <malloc+0xbe>
 83e:	f04a                	sd	s2,32(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 846:	8a4e                	mv	s4,s3
 848:	0009871b          	sext.w	a4,s3
 84c:	6685                	lui	a3,0x1
 84e:	00d77363          	bgeu	a4,a3,854 <malloc+0x44>
 852:	6a05                	lui	s4,0x1
 854:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 858:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 85c:	00000917          	auipc	s2,0x0
 860:	7a490913          	addi	s2,s2,1956 # 1000 <freep>
  if(p == (char*)-1)
 864:	5afd                	li	s5,-1
 866:	a081                	j	8a6 <malloc+0x96>
 868:	f04a                	sd	s2,32(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 870:	00000797          	auipc	a5,0x0
 874:	7a078793          	addi	a5,a5,1952 # 1010 <base>
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
 880:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 882:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 886:	b7c1                	j	846 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 888:	6398                	ld	a4,0(a5)
 88a:	e118                	sd	a4,0(a0)
 88c:	a8a9                	j	8e6 <malloc+0xd6>
  hp->s.size = nu;
 88e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 892:	0541                	addi	a0,a0,16
 894:	efbff0ef          	jal	78e <free>
  return freep;
 898:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 89c:	c12d                	beqz	a0,8fe <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a0:	4798                	lw	a4,8(a5)
 8a2:	02977263          	bgeu	a4,s1,8c6 <malloc+0xb6>
    if(p == freep)
 8a6:	00093703          	ld	a4,0(s2)
 8aa:	853e                	mv	a0,a5
 8ac:	fef719e3          	bne	a4,a5,89e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	acbff0ef          	jal	37c <sbrk>
  if(p == (char*)-1)
 8b6:	fd551ce3          	bne	a0,s5,88e <malloc+0x7e>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	7902                	ld	s2,32(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	a03d                	j	8f2 <malloc+0xe2>
 8c6:	7902                	ld	s2,32(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ce:	fae48de3          	beq	s1,a4,888 <malloc+0x78>
        p->s.size -= nunits;
 8d2:	4137073b          	subw	a4,a4,s3
 8d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d8:	02071693          	slli	a3,a4,0x20
 8dc:	01c6d713          	srli	a4,a3,0x1c
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70a73d23          	sd	a0,1818(a4) # 1000 <freep>
      return (void*)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	74a2                	ld	s1,40(sp)
 8f8:	69e2                	ld	s3,24(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
 8fe:	7902                	ld	s2,32(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	b7f5                	j	8f2 <malloc+0xe2>
