
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2) {
   8:	4789                	li	a5,2
   a:	02f51263          	bne	a0,a5,2e <main+0x2e>
        fprintf(2, "Usage: sleep ticks\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
   e:	6588                	ld	a0,8(a1)
  10:	00054703          	lbu	a4,0(a0)
  14:	03f00793          	li	a5,63
  18:	02f70563          	beq	a4,a5,42 <main+0x42>
        printf("Usage: sleep ticks\n");
        printf("Pause execution for specified number of ticks\n");
        exit(0);
    }

    int ticks = atoi(argv[1]);
  1c:	1cc000ef          	jal	1e8 <atoi>
    if (ticks < 0) {
  20:	04054063          	bltz	a0,60 <main+0x60>
        fprintf(2, "sleep: ticks must be non-negative\n");
        exit(1);
    }

    sleep(ticks);
  24:	34a000ef          	jal	36e <sleep>
    exit(0);
  28:	4501                	li	a0,0
  2a:	2b4000ef          	jal	2de <exit>
        fprintf(2, "Usage: sleep ticks\n");
  2e:	00001597          	auipc	a1,0x1
  32:	8d258593          	addi	a1,a1,-1838 # 900 <malloc+0x106>
  36:	4509                	li	a0,2
  38:	6e4000ef          	jal	71c <fprintf>
        exit(1);
  3c:	4505                	li	a0,1
  3e:	2a0000ef          	jal	2de <exit>
        printf("Usage: sleep ticks\n");
  42:	00001517          	auipc	a0,0x1
  46:	8be50513          	addi	a0,a0,-1858 # 900 <malloc+0x106>
  4a:	6fc000ef          	jal	746 <printf>
        printf("Pause execution for specified number of ticks\n");
  4e:	00001517          	auipc	a0,0x1
  52:	8ca50513          	addi	a0,a0,-1846 # 918 <malloc+0x11e>
  56:	6f0000ef          	jal	746 <printf>
        exit(0);
  5a:	4501                	li	a0,0
  5c:	282000ef          	jal	2de <exit>
        fprintf(2, "sleep: ticks must be non-negative\n");
  60:	00001597          	auipc	a1,0x1
  64:	8e858593          	addi	a1,a1,-1816 # 948 <malloc+0x14e>
  68:	4509                	li	a0,2
  6a:	6b2000ef          	jal	71c <fprintf>
        exit(1);
  6e:	4505                	li	a0,1
  70:	26e000ef          	jal	2de <exit>

0000000000000074 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  74:	1141                	addi	sp,sp,-16
  76:	e406                	sd	ra,8(sp)
  78:	e022                	sd	s0,0(sp)
  7a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  7c:	f85ff0ef          	jal	0 <main>
  exit(0);
  80:	4501                	li	a0,0
  82:	25c000ef          	jal	2de <exit>

0000000000000086 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  86:	1141                	addi	sp,sp,-16
  88:	e422                	sd	s0,8(sp)
  8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8c:	87aa                	mv	a5,a0
  8e:	0585                	addi	a1,a1,1
  90:	0785                	addi	a5,a5,1
  92:	fff5c703          	lbu	a4,-1(a1)
  96:	fee78fa3          	sb	a4,-1(a5)
  9a:	fb75                	bnez	a4,8e <strcpy+0x8>
    ;
  return os;
}
  9c:	6422                	ld	s0,8(sp)
  9e:	0141                	addi	sp,sp,16
  a0:	8082                	ret

00000000000000a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  a8:	00054783          	lbu	a5,0(a0)
  ac:	cb91                	beqz	a5,c0 <strcmp+0x1e>
  ae:	0005c703          	lbu	a4,0(a1)
  b2:	00f71763          	bne	a4,a5,c0 <strcmp+0x1e>
    p++, q++;
  b6:	0505                	addi	a0,a0,1
  b8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ba:	00054783          	lbu	a5,0(a0)
  be:	fbe5                	bnez	a5,ae <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  c0:	0005c503          	lbu	a0,0(a1)
}
  c4:	40a7853b          	subw	a0,a5,a0
  c8:	6422                	ld	s0,8(sp)
  ca:	0141                	addi	sp,sp,16
  cc:	8082                	ret

00000000000000ce <strlen>:

uint
strlen(const char *s)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e422                	sd	s0,8(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf91                	beqz	a5,f4 <strlen+0x26>
  da:	0505                	addi	a0,a0,1
  dc:	87aa                	mv	a5,a0
  de:	86be                	mv	a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	ff65                	bnez	a4,de <strlen+0x10>
  e8:	40a6853b          	subw	a0,a3,a0
  ec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ee:	6422                	ld	s0,8(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  for(n = 0; s[n]; n++)
  f4:	4501                	li	a0,0
  f6:	bfe5                	j	ee <strlen+0x20>

00000000000000f8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e422                	sd	s0,8(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fe:	ca19                	beqz	a2,114 <memset+0x1c>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x12>
  }
  return dst;
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret

000000000000011a <strchr>:

char*
strchr(const char *s, char c)
{
 11a:	1141                	addi	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb99                	beqz	a5,13a <strchr+0x20>
    if(*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1a>
  for(; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xc>
      return (char*)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	6422                	ld	s0,8(sp)
 136:	0141                	addi	sp,sp,16
 138:	8082                	ret
  return 0;
 13a:	4501                	li	a0,0
 13c:	bfe5                	j	134 <strchr+0x1a>

000000000000013e <gets>:

char*
gets(char *buf, int max)
{
 13e:	711d                	addi	sp,sp,-96
 140:	ec86                	sd	ra,88(sp)
 142:	e8a2                	sd	s0,80(sp)
 144:	e4a6                	sd	s1,72(sp)
 146:	e0ca                	sd	s2,64(sp)
 148:	fc4e                	sd	s3,56(sp)
 14a:	f852                	sd	s4,48(sp)
 14c:	f456                	sd	s5,40(sp)
 14e:	f05a                	sd	s6,32(sp)
 150:	ec5e                	sd	s7,24(sp)
 152:	1080                	addi	s0,sp,96
 154:	8baa                	mv	s7,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 15c:	4aa9                	li	s5,10
 15e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 160:	89a6                	mv	s3,s1
 162:	2485                	addiw	s1,s1,1
 164:	0344d663          	bge	s1,s4,190 <gets+0x52>
    cc = read(0, &c, 1);
 168:	4605                	li	a2,1
 16a:	faf40593          	addi	a1,s0,-81
 16e:	4501                	li	a0,0
 170:	186000ef          	jal	2f6 <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x52>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x50>
 184:	0905                	addi	s2,s2,1
 186:	fd679de3          	bne	a5,s6,160 <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x52>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	addi	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	addi	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	addi	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	162000ef          	jal	31e <open>
  if(fd < 0)
 1c0:	02054263          	bltz	a0,1e4 <stat+0x36>
 1c4:	e426                	sd	s1,8(sp)
 1c6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c8:	85ca                	mv	a1,s2
 1ca:	16c000ef          	jal	336 <fstat>
 1ce:	892a                	mv	s2,a0
  close(fd);
 1d0:	8526                	mv	a0,s1
 1d2:	134000ef          	jal	306 <close>
  return r;
 1d6:	64a2                	ld	s1,8(sp)
}
 1d8:	854a                	mv	a0,s2
 1da:	60e2                	ld	ra,24(sp)
 1dc:	6442                	ld	s0,16(sp)
 1de:	6902                	ld	s2,0(sp)
 1e0:	6105                	addi	sp,sp,32
 1e2:	8082                	ret
    return -1;
 1e4:	597d                	li	s2,-1
 1e6:	bfcd                	j	1d8 <stat+0x2a>

00000000000001e8 <atoi>:

int
atoi(const char *s)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e422                	sd	s0,8(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054683          	lbu	a3,0(a0)
 1f2:	fd06879b          	addiw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	4625                	li	a2,9
 1fc:	02f66863          	bltu	a2,a5,22c <atoi+0x44>
 200:	872a                	mv	a4,a0
  n = 0;
 202:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 204:	0705                	addi	a4,a4,1
 206:	0025179b          	slliw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	slliw	a5,a5,0x1
 210:	9fb5                	addw	a5,a5,a3
 212:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	00074683          	lbu	a3,0(a4)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	fef671e3          	bgeu	a2,a5,204 <atoi+0x1c>
  return n;
}
 226:	6422                	ld	s0,8(sp)
 228:	0141                	addi	sp,sp,16
 22a:	8082                	ret
  n = 0;
 22c:	4501                	li	a0,0
 22e:	bfe5                	j	226 <atoi+0x3e>

0000000000000230 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 230:	1141                	addi	sp,sp,-16
 232:	e422                	sd	s0,8(sp)
 234:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 236:	02b57463          	bgeu	a0,a1,25e <memmove+0x2e>
    while(n-- > 0)
 23a:	00c05f63          	blez	a2,258 <memmove+0x28>
 23e:	1602                	slli	a2,a2,0x20
 240:	9201                	srli	a2,a2,0x20
 242:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 246:	872a                	mv	a4,a0
      *dst++ = *src++;
 248:	0585                	addi	a1,a1,1
 24a:	0705                	addi	a4,a4,1
 24c:	fff5c683          	lbu	a3,-1(a1)
 250:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 254:	fef71ae3          	bne	a4,a5,248 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret
    dst += n;
 25e:	00c50733          	add	a4,a0,a2
    src += n;
 262:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 264:	fec05ae3          	blez	a2,258 <memmove+0x28>
 268:	fff6079b          	addiw	a5,a2,-1
 26c:	1782                	slli	a5,a5,0x20
 26e:	9381                	srli	a5,a5,0x20
 270:	fff7c793          	not	a5,a5
 274:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 276:	15fd                	addi	a1,a1,-1
 278:	177d                	addi	a4,a4,-1
 27a:	0005c683          	lbu	a3,0(a1)
 27e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 282:	fee79ae3          	bne	a5,a4,276 <memmove+0x46>
 286:	bfc9                	j	258 <memmove+0x28>

0000000000000288 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ca05                	beqz	a2,2be <memcmp+0x36>
 290:	fff6069b          	addiw	a3,a2,-1
 294:	1682                	slli	a3,a3,0x20
 296:	9281                	srli	a3,a3,0x20
 298:	0685                	addi	a3,a3,1
 29a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	0005c703          	lbu	a4,0(a1)
 2a4:	00e79863          	bne	a5,a4,2b4 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2a8:	0505                	addi	a0,a0,1
    p2++;
 2aa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ac:	fed518e3          	bne	a0,a3,29c <memcmp+0x14>
  }
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	a019                	j	2b8 <memcmp+0x30>
      return *p1 - *p2;
 2b4:	40e7853b          	subw	a0,a5,a4
}
 2b8:	6422                	ld	s0,8(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret
  return 0;
 2be:	4501                	li	a0,0
 2c0:	bfe5                	j	2b8 <memcmp+0x30>

00000000000002c2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ca:	f67ff0ef          	jal	230 <memmove>
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret

00000000000002d6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d6:	4885                	li	a7,1
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <exit>:
.global exit
exit:
 li a7, SYS_exit
 2de:	4889                	li	a7,2
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e6:	488d                	li	a7,3
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ee:	4891                	li	a7,4
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <read>:
.global read
read:
 li a7, SYS_read
 2f6:	4895                	li	a7,5
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <write>:
.global write
write:
 li a7, SYS_write
 2fe:	48c1                	li	a7,16
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <close>:
.global close
close:
 li a7, SYS_close
 306:	48d5                	li	a7,21
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <kill>:
.global kill
kill:
 li a7, SYS_kill
 30e:	4899                	li	a7,6
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <exec>:
.global exec
exec:
 li a7, SYS_exec
 316:	489d                	li	a7,7
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <open>:
.global open
open:
 li a7, SYS_open
 31e:	48bd                	li	a7,15
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 326:	48c5                	li	a7,17
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32e:	48c9                	li	a7,18
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 336:	48a1                	li	a7,8
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <link>:
.global link
link:
 li a7, SYS_link
 33e:	48cd                	li	a7,19
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 346:	48d1                	li	a7,20
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34e:	48a5                	li	a7,9
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <dup>:
.global dup
dup:
 li a7, SYS_dup
 356:	48a9                	li	a7,10
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35e:	48ad                	li	a7,11
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 366:	48b1                	li	a7,12
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 36e:	48b5                	li	a7,13
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 376:	48b9                	li	a7,14
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 37e:	48d9                	li	a7,22
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 386:	48dd                	li	a7,23
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 38e:	48e1                	li	a7,24
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <rand>:
.global rand
rand:
 li a7, SYS_rand
 396:	48e5                	li	a7,25
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 39e:	48e9                	li	a7,26
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 3a6:	48ed                	li	a7,27
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 3ae:	48f1                	li	a7,28
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 3b6:	48f5                	li	a7,29
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 3be:	48f9                	li	a7,30
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 3c6:	48fd                	li	a7,31
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ce:	1101                	addi	sp,sp,-32
 3d0:	ec06                	sd	ra,24(sp)
 3d2:	e822                	sd	s0,16(sp)
 3d4:	1000                	addi	s0,sp,32
 3d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3da:	4605                	li	a2,1
 3dc:	fef40593          	addi	a1,s0,-17
 3e0:	f1fff0ef          	jal	2fe <write>
}
 3e4:	60e2                	ld	ra,24(sp)
 3e6:	6442                	ld	s0,16(sp)
 3e8:	6105                	addi	sp,sp,32
 3ea:	8082                	ret

00000000000003ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	7139                	addi	sp,sp,-64
 3ee:	fc06                	sd	ra,56(sp)
 3f0:	f822                	sd	s0,48(sp)
 3f2:	f426                	sd	s1,40(sp)
 3f4:	0080                	addi	s0,sp,64
 3f6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f8:	c299                	beqz	a3,3fe <printint+0x12>
 3fa:	0805c963          	bltz	a1,48c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fe:	2581                	sext.w	a1,a1
  neg = 0;
 400:	4881                	li	a7,0
 402:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 406:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 408:	2601                	sext.w	a2,a2
 40a:	00000517          	auipc	a0,0x0
 40e:	56e50513          	addi	a0,a0,1390 # 978 <digits>
 412:	883a                	mv	a6,a4
 414:	2705                	addiw	a4,a4,1
 416:	02c5f7bb          	remuw	a5,a1,a2
 41a:	1782                	slli	a5,a5,0x20
 41c:	9381                	srli	a5,a5,0x20
 41e:	97aa                	add	a5,a5,a0
 420:	0007c783          	lbu	a5,0(a5)
 424:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 428:	0005879b          	sext.w	a5,a1
 42c:	02c5d5bb          	divuw	a1,a1,a2
 430:	0685                	addi	a3,a3,1
 432:	fec7f0e3          	bgeu	a5,a2,412 <printint+0x26>
  if(neg)
 436:	00088c63          	beqz	a7,44e <printint+0x62>
    buf[i++] = '-';
 43a:	fd070793          	addi	a5,a4,-48
 43e:	00878733          	add	a4,a5,s0
 442:	02d00793          	li	a5,45
 446:	fef70823          	sb	a5,-16(a4)
 44a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 44e:	02e05a63          	blez	a4,482 <printint+0x96>
 452:	f04a                	sd	s2,32(sp)
 454:	ec4e                	sd	s3,24(sp)
 456:	fc040793          	addi	a5,s0,-64
 45a:	00e78933          	add	s2,a5,a4
 45e:	fff78993          	addi	s3,a5,-1
 462:	99ba                	add	s3,s3,a4
 464:	377d                	addiw	a4,a4,-1
 466:	1702                	slli	a4,a4,0x20
 468:	9301                	srli	a4,a4,0x20
 46a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46e:	fff94583          	lbu	a1,-1(s2)
 472:	8526                	mv	a0,s1
 474:	f5bff0ef          	jal	3ce <putc>
  while(--i >= 0)
 478:	197d                	addi	s2,s2,-1
 47a:	ff391ae3          	bne	s2,s3,46e <printint+0x82>
 47e:	7902                	ld	s2,32(sp)
 480:	69e2                	ld	s3,24(sp)
}
 482:	70e2                	ld	ra,56(sp)
 484:	7442                	ld	s0,48(sp)
 486:	74a2                	ld	s1,40(sp)
 488:	6121                	addi	sp,sp,64
 48a:	8082                	ret
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4885                	li	a7,1
    x = -xx;
 492:	bf85                	j	402 <printint+0x16>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e0ca                	sd	s2,64(sp)
 49c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c903          	lbu	s2,0(a1)
 4a2:	26090863          	beqz	s2,712 <vprintf+0x27e>
 4a6:	e4a6                	sd	s1,72(sp)
 4a8:	fc4e                	sd	s3,56(sp)
 4aa:	f852                	sd	s4,48(sp)
 4ac:	f456                	sd	s5,40(sp)
 4ae:	f05a                	sd	s6,32(sp)
 4b0:	ec5e                	sd	s7,24(sp)
 4b2:	e862                	sd	s8,16(sp)
 4b4:	e466                	sd	s9,8(sp)
 4b6:	8b2a                	mv	s6,a0
 4b8:	8a2e                	mv	s4,a1
 4ba:	8bb2                	mv	s7,a2
  state = 0;
 4bc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4be:	4481                	li	s1,0
 4c0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4ca:	06c00c93          	li	s9,108
 4ce:	a005                	j	4ee <vprintf+0x5a>
        putc(fd, c0);
 4d0:	85ca                	mv	a1,s2
 4d2:	855a                	mv	a0,s6
 4d4:	efbff0ef          	jal	3ce <putc>
 4d8:	a019                	j	4de <vprintf+0x4a>
    } else if(state == '%'){
 4da:	03598263          	beq	s3,s5,4fe <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 4de:	2485                	addiw	s1,s1,1
 4e0:	8726                	mv	a4,s1
 4e2:	009a07b3          	add	a5,s4,s1
 4e6:	0007c903          	lbu	s2,0(a5)
 4ea:	20090c63          	beqz	s2,702 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 4ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 4f2:	fe0994e3          	bnez	s3,4da <vprintf+0x46>
      if(c0 == '%'){
 4f6:	fd579de3          	bne	a5,s5,4d0 <vprintf+0x3c>
        state = '%';
 4fa:	89be                	mv	s3,a5
 4fc:	b7cd                	j	4de <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fe:	00ea06b3          	add	a3,s4,a4
 502:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 506:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 508:	c681                	beqz	a3,510 <vprintf+0x7c>
 50a:	9752                	add	a4,a4,s4
 50c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 510:	03878f63          	beq	a5,s8,54e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 514:	05978963          	beq	a5,s9,566 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 518:	07500713          	li	a4,117
 51c:	0ee78363          	beq	a5,a4,602 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 520:	07800713          	li	a4,120
 524:	12e78563          	beq	a5,a4,64e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 528:	07000713          	li	a4,112
 52c:	14e78a63          	beq	a5,a4,680 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 530:	07300713          	li	a4,115
 534:	18e78a63          	beq	a5,a4,6c8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 538:	02500713          	li	a4,37
 53c:	04e79563          	bne	a5,a4,586 <vprintf+0xf2>
        putc(fd, '%');
 540:	02500593          	li	a1,37
 544:	855a                	mv	a0,s6
 546:	e89ff0ef          	jal	3ce <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 54a:	4981                	li	s3,0
 54c:	bf49                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 54e:	008b8913          	addi	s2,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000ba583          	lw	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	e91ff0ef          	jal	3ec <printint>
 560:	8bca                	mv	s7,s2
      state = 0;
 562:	4981                	li	s3,0
 564:	bfad                	j	4de <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 566:	06400793          	li	a5,100
 56a:	02f68963          	beq	a3,a5,59c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 56e:	06c00793          	li	a5,108
 572:	04f68263          	beq	a3,a5,5b6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 576:	07500793          	li	a5,117
 57a:	0af68063          	beq	a3,a5,61a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 57e:	07800793          	li	a5,120
 582:	0ef68263          	beq	a3,a5,666 <vprintf+0x1d2>
        putc(fd, '%');
 586:	02500593          	li	a1,37
 58a:	855a                	mv	a0,s6
 58c:	e43ff0ef          	jal	3ce <putc>
        putc(fd, c0);
 590:	85ca                	mv	a1,s2
 592:	855a                	mv	a0,s6
 594:	e3bff0ef          	jal	3ce <putc>
      state = 0;
 598:	4981                	li	s3,0
 59a:	b791                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	008b8913          	addi	s2,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000ba583          	lw	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e43ff0ef          	jal	3ec <printint>
        i += 1;
 5ae:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	8bca                	mv	s7,s2
      state = 0;
 5b2:	4981                	li	s3,0
        i += 1;
 5b4:	b72d                	j	4de <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5b6:	06400793          	li	a5,100
 5ba:	02f60763          	beq	a2,a5,5e8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 5be:	07500793          	li	a5,117
 5c2:	06f60963          	beq	a2,a5,634 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 5c6:	07800793          	li	a5,120
 5ca:	faf61ee3          	bne	a2,a5,586 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ce:	008b8913          	addi	s2,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4641                	li	a2,16
 5d6:	000ba583          	lw	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e11ff0ef          	jal	3ec <printint>
        i += 2;
 5e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e2:	8bca                	mv	s7,s2
      state = 0;
 5e4:	4981                	li	s3,0
        i += 2;
 5e6:	bde5                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e8:	008b8913          	addi	s2,s7,8
 5ec:	4685                	li	a3,1
 5ee:	4629                	li	a2,10
 5f0:	000ba583          	lw	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	df7ff0ef          	jal	3ec <printint>
        i += 2;
 5fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fc:	8bca                	mv	s7,s2
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	bdf9                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 602:	008b8913          	addi	s2,s7,8
 606:	4681                	li	a3,0
 608:	4629                	li	a2,10
 60a:	000ba583          	lw	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	dddff0ef          	jal	3ec <printint>
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
 618:	b5d9                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 61a:	008b8913          	addi	s2,s7,8
 61e:	4681                	li	a3,0
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	dc5ff0ef          	jal	3ec <printint>
        i += 1;
 62c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	8bca                	mv	s7,s2
      state = 0;
 630:	4981                	li	s3,0
        i += 1;
 632:	b575                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 634:	008b8913          	addi	s2,s7,8
 638:	4681                	li	a3,0
 63a:	4629                	li	a2,10
 63c:	000ba583          	lw	a1,0(s7)
 640:	855a                	mv	a0,s6
 642:	dabff0ef          	jal	3ec <printint>
        i += 2;
 646:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	8bca                	mv	s7,s2
      state = 0;
 64a:	4981                	li	s3,0
        i += 2;
 64c:	bd49                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 64e:	008b8913          	addi	s2,s7,8
 652:	4681                	li	a3,0
 654:	4641                	li	a2,16
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	d91ff0ef          	jal	3ec <printint>
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
 664:	bdad                	j	4de <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 666:	008b8913          	addi	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4641                	li	a2,16
 66e:	000ba583          	lw	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	d79ff0ef          	jal	3ec <printint>
        i += 1;
 678:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	8bca                	mv	s7,s2
      state = 0;
 67c:	4981                	li	s3,0
        i += 1;
 67e:	b585                	j	4de <vprintf+0x4a>
 680:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 682:	008b8d13          	addi	s10,s7,8
 686:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 68a:	03000593          	li	a1,48
 68e:	855a                	mv	a0,s6
 690:	d3fff0ef          	jal	3ce <putc>
  putc(fd, 'x');
 694:	07800593          	li	a1,120
 698:	855a                	mv	a0,s6
 69a:	d35ff0ef          	jal	3ce <putc>
 69e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	00000b97          	auipc	s7,0x0
 6a4:	2d8b8b93          	addi	s7,s7,728 # 978 <digits>
 6a8:	03c9d793          	srli	a5,s3,0x3c
 6ac:	97de                	add	a5,a5,s7
 6ae:	0007c583          	lbu	a1,0(a5)
 6b2:	855a                	mv	a0,s6
 6b4:	d1bff0ef          	jal	3ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b8:	0992                	slli	s3,s3,0x4
 6ba:	397d                	addiw	s2,s2,-1
 6bc:	fe0916e3          	bnez	s2,6a8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 6c0:	8bea                	mv	s7,s10
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	6d02                	ld	s10,0(sp)
 6c6:	bd21                	j	4de <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 6c8:	008b8993          	addi	s3,s7,8
 6cc:	000bb903          	ld	s2,0(s7)
 6d0:	00090f63          	beqz	s2,6ee <vprintf+0x25a>
        for(; *s; s++)
 6d4:	00094583          	lbu	a1,0(s2)
 6d8:	c195                	beqz	a1,6fc <vprintf+0x268>
          putc(fd, *s);
 6da:	855a                	mv	a0,s6
 6dc:	cf3ff0ef          	jal	3ce <putc>
        for(; *s; s++)
 6e0:	0905                	addi	s2,s2,1
 6e2:	00094583          	lbu	a1,0(s2)
 6e6:	f9f5                	bnez	a1,6da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bbcd                	j	4de <vprintf+0x4a>
          s = "(null)";
 6ee:	00000917          	auipc	s2,0x0
 6f2:	28290913          	addi	s2,s2,642 # 970 <malloc+0x176>
        for(; *s; s++)
 6f6:	02800593          	li	a1,40
 6fa:	b7c5                	j	6da <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6fc:	8bce                	mv	s7,s3
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bbf9                	j	4de <vprintf+0x4a>
 702:	64a6                	ld	s1,72(sp)
 704:	79e2                	ld	s3,56(sp)
 706:	7a42                	ld	s4,48(sp)
 708:	7aa2                	ld	s5,40(sp)
 70a:	7b02                	ld	s6,32(sp)
 70c:	6be2                	ld	s7,24(sp)
 70e:	6c42                	ld	s8,16(sp)
 710:	6ca2                	ld	s9,8(sp)
    }
  }
}
 712:	60e6                	ld	ra,88(sp)
 714:	6446                	ld	s0,80(sp)
 716:	6906                	ld	s2,64(sp)
 718:	6125                	addi	sp,sp,96
 71a:	8082                	ret

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 738:	8622                	mv	a2,s0
 73a:	d5bff0ef          	jal	494 <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <printf>:

void
printf(const char *fmt, ...)
{
 746:	711d                	addi	sp,sp,-96
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e40c                	sd	a1,8(s0)
 750:	e810                	sd	a2,16(s0)
 752:	ec14                	sd	a3,24(s0)
 754:	f018                	sd	a4,32(s0)
 756:	f41c                	sd	a5,40(s0)
 758:	03043823          	sd	a6,48(s0)
 75c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	00840613          	addi	a2,s0,8
 764:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 768:	85aa                	mv	a1,a0
 76a:	4505                	li	a0,1
 76c:	d29ff0ef          	jal	494 <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e422                	sd	s0,8(sp)
 77c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	00001797          	auipc	a5,0x1
 786:	87e7b783          	ld	a5,-1922(a5) # 1000 <freep>
 78a:	a02d                	j	7b4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 78c:	4618                	lw	a4,8(a2)
 78e:	9f2d                	addw	a4,a4,a1
 790:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 794:	6398                	ld	a4,0(a5)
 796:	6310                	ld	a2,0(a4)
 798:	a83d                	j	7d6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 79a:	ff852703          	lw	a4,-8(a0)
 79e:	9f31                	addw	a4,a4,a2
 7a0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7a2:	ff053683          	ld	a3,-16(a0)
 7a6:	a091                	j	7ea <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e7e463          	bltu	a5,a4,7b2 <free+0x3a>
 7ae:	00e6ea63          	bltu	a3,a4,7c2 <free+0x4a>
{
 7b2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b4:	fed7fae3          	bgeu	a5,a3,7a8 <free+0x30>
 7b8:	6398                	ld	a4,0(a5)
 7ba:	00e6e463          	bltu	a3,a4,7c2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7be:	fee7eae3          	bltu	a5,a4,7b2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7c2:	ff852583          	lw	a1,-8(a0)
 7c6:	6390                	ld	a2,0(a5)
 7c8:	02059813          	slli	a6,a1,0x20
 7cc:	01c85713          	srli	a4,a6,0x1c
 7d0:	9736                	add	a4,a4,a3
 7d2:	fae60de3          	beq	a2,a4,78c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7da:	4790                	lw	a2,8(a5)
 7dc:	02061593          	slli	a1,a2,0x20
 7e0:	01c5d713          	srli	a4,a1,0x1c
 7e4:	973e                	add	a4,a4,a5
 7e6:	fae68ae3          	beq	a3,a4,79a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7ea:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7ec:	00001717          	auipc	a4,0x1
 7f0:	80f73a23          	sd	a5,-2028(a4) # 1000 <freep>
}
 7f4:	6422                	ld	s0,8(sp)
 7f6:	0141                	addi	sp,sp,16
 7f8:	8082                	ret

00000000000007fa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7fa:	7139                	addi	sp,sp,-64
 7fc:	fc06                	sd	ra,56(sp)
 7fe:	f822                	sd	s0,48(sp)
 800:	f426                	sd	s1,40(sp)
 802:	ec4e                	sd	s3,24(sp)
 804:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 806:	02051493          	slli	s1,a0,0x20
 80a:	9081                	srli	s1,s1,0x20
 80c:	04bd                	addi	s1,s1,15
 80e:	8091                	srli	s1,s1,0x4
 810:	0014899b          	addiw	s3,s1,1
 814:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 816:	00000517          	auipc	a0,0x0
 81a:	7ea53503          	ld	a0,2026(a0) # 1000 <freep>
 81e:	c915                	beqz	a0,852 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	08977a63          	bgeu	a4,s1,8b8 <malloc+0xbe>
 828:	f04a                	sd	s2,32(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 830:	8a4e                	mv	s4,s3
 832:	0009871b          	sext.w	a4,s3
 836:	6685                	lui	a3,0x1
 838:	00d77363          	bgeu	a4,a3,83e <malloc+0x44>
 83c:	6a05                	lui	s4,0x1
 83e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 842:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 846:	00000917          	auipc	s2,0x0
 84a:	7ba90913          	addi	s2,s2,1978 # 1000 <freep>
  if(p == (char*)-1)
 84e:	5afd                	li	s5,-1
 850:	a081                	j	890 <malloc+0x96>
 852:	f04a                	sd	s2,32(sp)
 854:	e852                	sd	s4,16(sp)
 856:	e456                	sd	s5,8(sp)
 858:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85a:	00000797          	auipc	a5,0x0
 85e:	7b678793          	addi	a5,a5,1974 # 1010 <base>
 862:	00000717          	auipc	a4,0x0
 866:	78f73f23          	sd	a5,1950(a4) # 1000 <freep>
 86a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 870:	b7c1                	j	830 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 872:	6398                	ld	a4,0(a5)
 874:	e118                	sd	a4,0(a0)
 876:	a8a9                	j	8d0 <malloc+0xd6>
  hp->s.size = nu;
 878:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 87c:	0541                	addi	a0,a0,16
 87e:	efbff0ef          	jal	778 <free>
  return freep;
 882:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 886:	c12d                	beqz	a0,8e8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 888:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 88a:	4798                	lw	a4,8(a5)
 88c:	02977263          	bgeu	a4,s1,8b0 <malloc+0xb6>
    if(p == freep)
 890:	00093703          	ld	a4,0(s2)
 894:	853e                	mv	a0,a5
 896:	fef719e3          	bne	a4,a5,888 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 89a:	8552                	mv	a0,s4
 89c:	acbff0ef          	jal	366 <sbrk>
  if(p == (char*)-1)
 8a0:	fd551ce3          	bne	a0,s5,878 <malloc+0x7e>
        return 0;
 8a4:	4501                	li	a0,0
 8a6:	7902                	ld	s2,32(sp)
 8a8:	6a42                	ld	s4,16(sp)
 8aa:	6aa2                	ld	s5,8(sp)
 8ac:	6b02                	ld	s6,0(sp)
 8ae:	a03d                	j	8dc <malloc+0xe2>
 8b0:	7902                	ld	s2,32(sp)
 8b2:	6a42                	ld	s4,16(sp)
 8b4:	6aa2                	ld	s5,8(sp)
 8b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b8:	fae48de3          	beq	s1,a4,872 <malloc+0x78>
        p->s.size -= nunits;
 8bc:	4137073b          	subw	a4,a4,s3
 8c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c2:	02071693          	slli	a3,a4,0x20
 8c6:	01c6d713          	srli	a4,a3,0x1c
 8ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d0:	00000717          	auipc	a4,0x0
 8d4:	72a73823          	sd	a0,1840(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d8:	01078513          	addi	a0,a5,16
  }
}
 8dc:	70e2                	ld	ra,56(sp)
 8de:	7442                	ld	s0,48(sp)
 8e0:	74a2                	ld	s1,40(sp)
 8e2:	69e2                	ld	s3,24(sp)
 8e4:	6121                	addi	sp,sp,64
 8e6:	8082                	ret
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	b7f5                	j	8dc <malloc+0xe2>
