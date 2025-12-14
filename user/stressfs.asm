
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	97a78793          	addi	a5,a5,-1670 # 990 <malloc+0x132>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	93450513          	addi	a0,a0,-1740 # 960 <malloc+0x102>
  34:	776000ef          	jal	7aa <printf>
  memset(data, 'a', sizeof(data));
  38:	20000613          	li	a2,512
  3c:	06100593          	li	a1,97
  40:	dd040513          	addi	a0,s0,-560
  44:	118000ef          	jal	15c <memset>

  for(i = 0; i < 4; i++)
  48:	4481                	li	s1,0
  4a:	4911                	li	s2,4
    if(fork() > 0)
  4c:	2ee000ef          	jal	33a <fork>
  50:	00a04563          	bgtz	a0,5a <main+0x5a>
  for(i = 0; i < 4; i++)
  54:	2485                	addiw	s1,s1,1
  56:	ff249be3          	bne	s1,s2,4c <main+0x4c>
      break;

  printf("write %d\n", i);
  5a:	85a6                	mv	a1,s1
  5c:	00001517          	auipc	a0,0x1
  60:	91c50513          	addi	a0,a0,-1764 # 978 <malloc+0x11a>
  64:	746000ef          	jal	7aa <printf>

  path[8] += i;
  68:	fd844783          	lbu	a5,-40(s0)
  6c:	9fa5                	addw	a5,a5,s1
  6e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  72:	20200593          	li	a1,514
  76:	fd040513          	addi	a0,s0,-48
  7a:	308000ef          	jal	382 <open>
  7e:	892a                	mv	s2,a0
  80:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  82:	20000613          	li	a2,512
  86:	dd040593          	addi	a1,s0,-560
  8a:	854a                	mv	a0,s2
  8c:	2d6000ef          	jal	362 <write>
  for(i = 0; i < 20; i++)
  90:	34fd                	addiw	s1,s1,-1
  92:	f8e5                	bnez	s1,82 <main+0x82>
  close(fd);
  94:	854a                	mv	a0,s2
  96:	2d4000ef          	jal	36a <close>

  printf("read\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	8ee50513          	addi	a0,a0,-1810 # 988 <malloc+0x12a>
  a2:	708000ef          	jal	7aa <printf>

  fd = open(path, O_RDONLY);
  a6:	4581                	li	a1,0
  a8:	fd040513          	addi	a0,s0,-48
  ac:	2d6000ef          	jal	382 <open>
  b0:	892a                	mv	s2,a0
  b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  b4:	20000613          	li	a2,512
  b8:	dd040593          	addi	a1,s0,-560
  bc:	854a                	mv	a0,s2
  be:	29c000ef          	jal	35a <read>
  for (i = 0; i < 20; i++)
  c2:	34fd                	addiw	s1,s1,-1
  c4:	f8e5                	bnez	s1,b4 <main+0xb4>
  close(fd);
  c6:	854a                	mv	a0,s2
  c8:	2a2000ef          	jal	36a <close>

  wait(0);
  cc:	4501                	li	a0,0
  ce:	27c000ef          	jal	34a <wait>

  exit(0);
  d2:	4501                	li	a0,0
  d4:	26e000ef          	jal	342 <exit>

00000000000000d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  extern int main();
  main();
  e0:	f21ff0ef          	jal	0 <main>
  exit(0);
  e4:	4501                	li	a0,0
  e6:	25c000ef          	jal	342 <exit>

00000000000000ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	87aa                	mv	a5,a0
  f2:	0585                	addi	a1,a1,1
  f4:	0785                	addi	a5,a5,1
  f6:	fff5c703          	lbu	a4,-1(a1)
  fa:	fee78fa3          	sb	a4,-1(a5)
  fe:	fb75                	bnez	a4,f2 <strcpy+0x8>
    ;
  return os;
}
 100:	6422                	ld	s0,8(sp)
 102:	0141                	addi	sp,sp,16
 104:	8082                	ret

0000000000000106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 106:	1141                	addi	sp,sp,-16
 108:	e422                	sd	s0,8(sp)
 10a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x1e>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x1e>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	6422                	ld	s0,8(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e422                	sd	s0,8(sp)
 136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 138:	00054783          	lbu	a5,0(a0)
 13c:	cf91                	beqz	a5,158 <strlen+0x26>
 13e:	0505                	addi	a0,a0,1
 140:	87aa                	mv	a5,a0
 142:	86be                	mv	a3,a5
 144:	0785                	addi	a5,a5,1
 146:	fff7c703          	lbu	a4,-1(a5)
 14a:	ff65                	bnez	a4,142 <strlen+0x10>
 14c:	40a6853b          	subw	a0,a3,a0
 150:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 152:	6422                	ld	s0,8(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  for(n = 0; s[n]; n++)
 158:	4501                	li	a0,0
 15a:	bfe5                	j	152 <strlen+0x20>

000000000000015c <memset>:

void*
memset(void *dst, int c, uint n)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 162:	ca19                	beqz	a2,178 <memset+0x1c>
 164:	87aa                	mv	a5,a0
 166:	1602                	slli	a2,a2,0x20
 168:	9201                	srli	a2,a2,0x20
 16a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 172:	0785                	addi	a5,a5,1
 174:	fee79de3          	bne	a5,a4,16e <memset+0x12>
  }
  return dst;
}
 178:	6422                	ld	s0,8(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e422                	sd	s0,8(sp)
 182:	0800                	addi	s0,sp,16
  for(; *s; s++)
 184:	00054783          	lbu	a5,0(a0)
 188:	cb99                	beqz	a5,19e <strchr+0x20>
    if(*s == c)
 18a:	00f58763          	beq	a1,a5,198 <strchr+0x1a>
  for(; *s; s++)
 18e:	0505                	addi	a0,a0,1
 190:	00054783          	lbu	a5,0(a0)
 194:	fbfd                	bnez	a5,18a <strchr+0xc>
      return (char*)s;
  return 0;
 196:	4501                	li	a0,0
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	addi	sp,sp,16
 19c:	8082                	ret
  return 0;
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strchr+0x1a>

00000000000001a2 <gets>:

char*
gets(char *buf, int max)
{
 1a2:	711d                	addi	sp,sp,-96
 1a4:	ec86                	sd	ra,88(sp)
 1a6:	e8a2                	sd	s0,80(sp)
 1a8:	e4a6                	sd	s1,72(sp)
 1aa:	e0ca                	sd	s2,64(sp)
 1ac:	fc4e                	sd	s3,56(sp)
 1ae:	f852                	sd	s4,48(sp)
 1b0:	f456                	sd	s5,40(sp)
 1b2:	f05a                	sd	s6,32(sp)
 1b4:	ec5e                	sd	s7,24(sp)
 1b6:	1080                	addi	s0,sp,96
 1b8:	8baa                	mv	s7,a0
 1ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	892a                	mv	s2,a0
 1be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1c0:	4aa9                	li	s5,10
 1c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1c4:	89a6                	mv	s3,s1
 1c6:	2485                	addiw	s1,s1,1
 1c8:	0344d663          	bge	s1,s4,1f4 <gets+0x52>
    cc = read(0, &c, 1);
 1cc:	4605                	li	a2,1
 1ce:	faf40593          	addi	a1,s0,-81
 1d2:	4501                	li	a0,0
 1d4:	186000ef          	jal	35a <read>
    if(cc < 1)
 1d8:	00a05e63          	blez	a0,1f4 <gets+0x52>
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e4:	01578763          	beq	a5,s5,1f2 <gets+0x50>
 1e8:	0905                	addi	s2,s2,1
 1ea:	fd679de3          	bne	a5,s6,1c4 <gets+0x22>
    buf[i++] = c;
 1ee:	89a6                	mv	s3,s1
 1f0:	a011                	j	1f4 <gets+0x52>
 1f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1f4:	99de                	add	s3,s3,s7
 1f6:	00098023          	sb	zero,0(s3)
  return buf;
}
 1fa:	855e                	mv	a0,s7
 1fc:	60e6                	ld	ra,88(sp)
 1fe:	6446                	ld	s0,80(sp)
 200:	64a6                	ld	s1,72(sp)
 202:	6906                	ld	s2,64(sp)
 204:	79e2                	ld	s3,56(sp)
 206:	7a42                	ld	s4,48(sp)
 208:	7aa2                	ld	s5,40(sp)
 20a:	7b02                	ld	s6,32(sp)
 20c:	6be2                	ld	s7,24(sp)
 20e:	6125                	addi	sp,sp,96
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	162000ef          	jal	382 <open>
  if(fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	16c000ef          	jal	39a <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	134000ef          	jal	36a <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	597d                	li	s2,-1
 24a:	bfcd                	j	23c <stat+0x2a>

000000000000024c <atoi>:

int
atoi(const char *s)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e422                	sd	s0,8(sp)
 250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 252:	00054683          	lbu	a3,0(a0)
 256:	fd06879b          	addiw	a5,a3,-48
 25a:	0ff7f793          	zext.b	a5,a5
 25e:	4625                	li	a2,9
 260:	02f66863          	bltu	a2,a5,290 <atoi+0x44>
 264:	872a                	mv	a4,a0
  n = 0;
 266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 268:	0705                	addi	a4,a4,1
 26a:	0025179b          	slliw	a5,a0,0x2
 26e:	9fa9                	addw	a5,a5,a0
 270:	0017979b          	slliw	a5,a5,0x1
 274:	9fb5                	addw	a5,a5,a3
 276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 27a:	00074683          	lbu	a3,0(a4)
 27e:	fd06879b          	addiw	a5,a3,-48
 282:	0ff7f793          	zext.b	a5,a5
 286:	fef671e3          	bgeu	a2,a5,268 <atoi+0x1c>
  return n;
}
 28a:	6422                	ld	s0,8(sp)
 28c:	0141                	addi	sp,sp,16
 28e:	8082                	ret
  n = 0;
 290:	4501                	li	a0,0
 292:	bfe5                	j	28a <atoi+0x3e>

0000000000000294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 29a:	02b57463          	bgeu	a0,a1,2c2 <memmove+0x2e>
    while(n-- > 0)
 29e:	00c05f63          	blez	a2,2bc <memmove+0x28>
 2a2:	1602                	slli	a2,a2,0x20
 2a4:	9201                	srli	a2,a2,0x20
 2a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ac:	0585                	addi	a1,a1,1
 2ae:	0705                	addi	a4,a4,1
 2b0:	fff5c683          	lbu	a3,-1(a1)
 2b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b8:	fef71ae3          	bne	a4,a5,2ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret
    dst += n;
 2c2:	00c50733          	add	a4,a0,a2
    src += n;
 2c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c8:	fec05ae3          	blez	a2,2bc <memmove+0x28>
 2cc:	fff6079b          	addiw	a5,a2,-1
 2d0:	1782                	slli	a5,a5,0x20
 2d2:	9381                	srli	a5,a5,0x20
 2d4:	fff7c793          	not	a5,a5
 2d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2da:	15fd                	addi	a1,a1,-1
 2dc:	177d                	addi	a4,a4,-1
 2de:	0005c683          	lbu	a3,0(a1)
 2e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x46>
 2ea:	bfc9                	j	2bc <memmove+0x28>

00000000000002ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2f2:	ca05                	beqz	a2,322 <memcmp+0x36>
 2f4:	fff6069b          	addiw	a3,a2,-1
 2f8:	1682                	slli	a3,a3,0x20
 2fa:	9281                	srli	a3,a3,0x20
 2fc:	0685                	addi	a3,a3,1
 2fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 300:	00054783          	lbu	a5,0(a0)
 304:	0005c703          	lbu	a4,0(a1)
 308:	00e79863          	bne	a5,a4,318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 30c:	0505                	addi	a0,a0,1
    p2++;
 30e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 310:	fed518e3          	bne	a0,a3,300 <memcmp+0x14>
  }
  return 0;
 314:	4501                	li	a0,0
 316:	a019                	j	31c <memcmp+0x30>
      return *p1 - *p2;
 318:	40e7853b          	subw	a0,a5,a4
}
 31c:	6422                	ld	s0,8(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret
  return 0;
 322:	4501                	li	a0,0
 324:	bfe5                	j	31c <memcmp+0x30>

0000000000000326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 326:	1141                	addi	sp,sp,-16
 328:	e406                	sd	ra,8(sp)
 32a:	e022                	sd	s0,0(sp)
 32c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 32e:	f67ff0ef          	jal	294 <memmove>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33a:	4885                	li	a7,1
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exit>:
.global exit
exit:
 li a7, SYS_exit
 342:	4889                	li	a7,2
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <wait>:
.global wait
wait:
 li a7, SYS_wait
 34a:	488d                	li	a7,3
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 352:	4891                	li	a7,4
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <read>:
.global read
read:
 li a7, SYS_read
 35a:	4895                	li	a7,5
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <close>:
.global close
close:
 li a7, SYS_close
 36a:	48d5                	li	a7,21
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <open>:
.global open
open:
 li a7, SYS_open
 382:	48bd                	li	a7,15
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38a:	48c5                	li	a7,17
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 392:	48c9                	li	a7,18
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39a:	48a1                	li	a7,8
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <link>:
.global link
link:
 li a7, SYS_link
 3a2:	48cd                	li	a7,19
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3aa:	48d1                	li	a7,20
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b2:	48a5                	li	a7,9
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ba:	48a9                	li	a7,10
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c2:	48ad                	li	a7,11
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3ca:	48b1                	li	a7,12
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3d2:	48b5                	li	a7,13
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3da:	48b9                	li	a7,14
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3e2:	48d9                	li	a7,22
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3ea:	48dd                	li	a7,23
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3f2:	48e1                	li	a7,24
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <rand>:
.global rand
rand:
 li a7, SYS_rand
 3fa:	48e5                	li	a7,25
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 402:	48e9                	li	a7,26
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 40a:	48ed                	li	a7,27
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 412:	48f1                	li	a7,28
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 41a:	48f5                	li	a7,29
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 422:	48f9                	li	a7,30
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 42a:	48fd                	li	a7,31
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 432:	1101                	addi	sp,sp,-32
 434:	ec06                	sd	ra,24(sp)
 436:	e822                	sd	s0,16(sp)
 438:	1000                	addi	s0,sp,32
 43a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43e:	4605                	li	a2,1
 440:	fef40593          	addi	a1,s0,-17
 444:	f1fff0ef          	jal	362 <write>
}
 448:	60e2                	ld	ra,24(sp)
 44a:	6442                	ld	s0,16(sp)
 44c:	6105                	addi	sp,sp,32
 44e:	8082                	ret

0000000000000450 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	7139                	addi	sp,sp,-64
 452:	fc06                	sd	ra,56(sp)
 454:	f822                	sd	s0,48(sp)
 456:	f426                	sd	s1,40(sp)
 458:	0080                	addi	s0,sp,64
 45a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45c:	c299                	beqz	a3,462 <printint+0x12>
 45e:	0805c963          	bltz	a1,4f0 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 462:	2581                	sext.w	a1,a1
  neg = 0;
 464:	4881                	li	a7,0
 466:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46c:	2601                	sext.w	a2,a2
 46e:	00000517          	auipc	a0,0x0
 472:	53a50513          	addi	a0,a0,1338 # 9a8 <digits>
 476:	883a                	mv	a6,a4
 478:	2705                	addiw	a4,a4,1
 47a:	02c5f7bb          	remuw	a5,a1,a2
 47e:	1782                	slli	a5,a5,0x20
 480:	9381                	srli	a5,a5,0x20
 482:	97aa                	add	a5,a5,a0
 484:	0007c783          	lbu	a5,0(a5)
 488:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48c:	0005879b          	sext.w	a5,a1
 490:	02c5d5bb          	divuw	a1,a1,a2
 494:	0685                	addi	a3,a3,1
 496:	fec7f0e3          	bgeu	a5,a2,476 <printint+0x26>
  if(neg)
 49a:	00088c63          	beqz	a7,4b2 <printint+0x62>
    buf[i++] = '-';
 49e:	fd070793          	addi	a5,a4,-48
 4a2:	00878733          	add	a4,a5,s0
 4a6:	02d00793          	li	a5,45
 4aa:	fef70823          	sb	a5,-16(a4)
 4ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b2:	02e05a63          	blez	a4,4e6 <printint+0x96>
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	fc040793          	addi	a5,s0,-64
 4be:	00e78933          	add	s2,a5,a4
 4c2:	fff78993          	addi	s3,a5,-1
 4c6:	99ba                	add	s3,s3,a4
 4c8:	377d                	addiw	a4,a4,-1
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	fff94583          	lbu	a1,-1(s2)
 4d6:	8526                	mv	a0,s1
 4d8:	f5bff0ef          	jal	432 <putc>
  while(--i >= 0)
 4dc:	197d                	addi	s2,s2,-1
 4de:	ff391ae3          	bne	s2,s3,4d2 <printint+0x82>
 4e2:	7902                	ld	s2,32(sp)
 4e4:	69e2                	ld	s3,24(sp)
}
 4e6:	70e2                	ld	ra,56(sp)
 4e8:	7442                	ld	s0,48(sp)
 4ea:	74a2                	ld	s1,40(sp)
 4ec:	6121                	addi	sp,sp,64
 4ee:	8082                	ret
    x = -xx;
 4f0:	40b005bb          	negw	a1,a1
    neg = 1;
 4f4:	4885                	li	a7,1
    x = -xx;
 4f6:	bf85                	j	466 <printint+0x16>

00000000000004f8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f8:	711d                	addi	sp,sp,-96
 4fa:	ec86                	sd	ra,88(sp)
 4fc:	e8a2                	sd	s0,80(sp)
 4fe:	e0ca                	sd	s2,64(sp)
 500:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 502:	0005c903          	lbu	s2,0(a1)
 506:	26090863          	beqz	s2,776 <vprintf+0x27e>
 50a:	e4a6                	sd	s1,72(sp)
 50c:	fc4e                	sd	s3,56(sp)
 50e:	f852                	sd	s4,48(sp)
 510:	f456                	sd	s5,40(sp)
 512:	f05a                	sd	s6,32(sp)
 514:	ec5e                	sd	s7,24(sp)
 516:	e862                	sd	s8,16(sp)
 518:	e466                	sd	s9,8(sp)
 51a:	8b2a                	mv	s6,a0
 51c:	8a2e                	mv	s4,a1
 51e:	8bb2                	mv	s7,a2
  state = 0;
 520:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 522:	4481                	li	s1,0
 524:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 526:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 52a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 52e:	06c00c93          	li	s9,108
 532:	a005                	j	552 <vprintf+0x5a>
        putc(fd, c0);
 534:	85ca                	mv	a1,s2
 536:	855a                	mv	a0,s6
 538:	efbff0ef          	jal	432 <putc>
 53c:	a019                	j	542 <vprintf+0x4a>
    } else if(state == '%'){
 53e:	03598263          	beq	s3,s5,562 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 542:	2485                	addiw	s1,s1,1
 544:	8726                	mv	a4,s1
 546:	009a07b3          	add	a5,s4,s1
 54a:	0007c903          	lbu	s2,0(a5)
 54e:	20090c63          	beqz	s2,766 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 552:	0009079b          	sext.w	a5,s2
    if(state == 0){
 556:	fe0994e3          	bnez	s3,53e <vprintf+0x46>
      if(c0 == '%'){
 55a:	fd579de3          	bne	a5,s5,534 <vprintf+0x3c>
        state = '%';
 55e:	89be                	mv	s3,a5
 560:	b7cd                	j	542 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 562:	00ea06b3          	add	a3,s4,a4
 566:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 56a:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 56c:	c681                	beqz	a3,574 <vprintf+0x7c>
 56e:	9752                	add	a4,a4,s4
 570:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 574:	03878f63          	beq	a5,s8,5b2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 578:	05978963          	beq	a5,s9,5ca <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 57c:	07500713          	li	a4,117
 580:	0ee78363          	beq	a5,a4,666 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 584:	07800713          	li	a4,120
 588:	12e78563          	beq	a5,a4,6b2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 58c:	07000713          	li	a4,112
 590:	14e78a63          	beq	a5,a4,6e4 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 594:	07300713          	li	a4,115
 598:	18e78a63          	beq	a5,a4,72c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 59c:	02500713          	li	a4,37
 5a0:	04e79563          	bne	a5,a4,5ea <vprintf+0xf2>
        putc(fd, '%');
 5a4:	02500593          	li	a1,37
 5a8:	855a                	mv	a0,s6
 5aa:	e89ff0ef          	jal	432 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	bf49                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4685                	li	a3,1
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	e91ff0ef          	jal	450 <printint>
 5c4:	8bca                	mv	s7,s2
      state = 0;
 5c6:	4981                	li	s3,0
 5c8:	bfad                	j	542 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5ca:	06400793          	li	a5,100
 5ce:	02f68963          	beq	a3,a5,600 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5d2:	06c00793          	li	a5,108
 5d6:	04f68263          	beq	a3,a5,61a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5da:	07500793          	li	a5,117
 5de:	0af68063          	beq	a3,a5,67e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5e2:	07800793          	li	a5,120
 5e6:	0ef68263          	beq	a3,a5,6ca <vprintf+0x1d2>
        putc(fd, '%');
 5ea:	02500593          	li	a1,37
 5ee:	855a                	mv	a0,s6
 5f0:	e43ff0ef          	jal	432 <putc>
        putc(fd, c0);
 5f4:	85ca                	mv	a1,s2
 5f6:	855a                	mv	a0,s6
 5f8:	e3bff0ef          	jal	432 <putc>
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b791                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 600:	008b8913          	addi	s2,s7,8
 604:	4685                	li	a3,1
 606:	4629                	li	a2,10
 608:	000ba583          	lw	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e43ff0ef          	jal	450 <printint>
        i += 1;
 612:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 614:	8bca                	mv	s7,s2
      state = 0;
 616:	4981                	li	s3,0
        i += 1;
 618:	b72d                	j	542 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61a:	06400793          	li	a5,100
 61e:	02f60763          	beq	a2,a5,64c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 622:	07500793          	li	a5,117
 626:	06f60963          	beq	a2,a5,698 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 62a:	07800793          	li	a5,120
 62e:	faf61ee3          	bne	a2,a5,5ea <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8913          	addi	s2,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000ba583          	lw	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e11ff0ef          	jal	450 <printint>
        i += 2;
 644:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8bca                	mv	s7,s2
      state = 0;
 648:	4981                	li	s3,0
        i += 2;
 64a:	bde5                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	008b8913          	addi	s2,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000ba583          	lw	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	df7ff0ef          	jal	450 <printint>
        i += 2;
 65e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	8bca                	mv	s7,s2
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	bdf9                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 666:	008b8913          	addi	s2,s7,8
 66a:	4681                	li	a3,0
 66c:	4629                	li	a2,10
 66e:	000ba583          	lw	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	dddff0ef          	jal	450 <printint>
 678:	8bca                	mv	s7,s2
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5d9                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b8913          	addi	s2,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000ba583          	lw	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	dc5ff0ef          	jal	450 <printint>
        i += 1;
 690:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
        i += 1;
 696:	b575                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	008b8913          	addi	s2,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000ba583          	lw	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	dabff0ef          	jal	450 <printint>
        i += 2;
 6aa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	8bca                	mv	s7,s2
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	bd49                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6b2:	008b8913          	addi	s2,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000ba583          	lw	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d91ff0ef          	jal	450 <printint>
 6c4:	8bca                	mv	s7,s2
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bdad                	j	542 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ca:	008b8913          	addi	s2,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000ba583          	lw	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d79ff0ef          	jal	450 <printint>
        i += 1;
 6dc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	8bca                	mv	s7,s2
      state = 0;
 6e0:	4981                	li	s3,0
        i += 1;
 6e2:	b585                	j	542 <vprintf+0x4a>
 6e4:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6e6:	008b8d13          	addi	s10,s7,8
 6ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ee:	03000593          	li	a1,48
 6f2:	855a                	mv	a0,s6
 6f4:	d3fff0ef          	jal	432 <putc>
  putc(fd, 'x');
 6f8:	07800593          	li	a1,120
 6fc:	855a                	mv	a0,s6
 6fe:	d35ff0ef          	jal	432 <putc>
 702:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 704:	00000b97          	auipc	s7,0x0
 708:	2a4b8b93          	addi	s7,s7,676 # 9a8 <digits>
 70c:	03c9d793          	srli	a5,s3,0x3c
 710:	97de                	add	a5,a5,s7
 712:	0007c583          	lbu	a1,0(a5)
 716:	855a                	mv	a0,s6
 718:	d1bff0ef          	jal	432 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71c:	0992                	slli	s3,s3,0x4
 71e:	397d                	addiw	s2,s2,-1
 720:	fe0916e3          	bnez	s2,70c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 724:	8bea                	mv	s7,s10
      state = 0;
 726:	4981                	li	s3,0
 728:	6d02                	ld	s10,0(sp)
 72a:	bd21                	j	542 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 72c:	008b8993          	addi	s3,s7,8
 730:	000bb903          	ld	s2,0(s7)
 734:	00090f63          	beqz	s2,752 <vprintf+0x25a>
        for(; *s; s++)
 738:	00094583          	lbu	a1,0(s2)
 73c:	c195                	beqz	a1,760 <vprintf+0x268>
          putc(fd, *s);
 73e:	855a                	mv	a0,s6
 740:	cf3ff0ef          	jal	432 <putc>
        for(; *s; s++)
 744:	0905                	addi	s2,s2,1
 746:	00094583          	lbu	a1,0(s2)
 74a:	f9f5                	bnez	a1,73e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 74c:	8bce                	mv	s7,s3
      state = 0;
 74e:	4981                	li	s3,0
 750:	bbcd                	j	542 <vprintf+0x4a>
          s = "(null)";
 752:	00000917          	auipc	s2,0x0
 756:	24e90913          	addi	s2,s2,590 # 9a0 <malloc+0x142>
        for(; *s; s++)
 75a:	02800593          	li	a1,40
 75e:	b7c5                	j	73e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 760:	8bce                	mv	s7,s3
      state = 0;
 762:	4981                	li	s3,0
 764:	bbf9                	j	542 <vprintf+0x4a>
 766:	64a6                	ld	s1,72(sp)
 768:	79e2                	ld	s3,56(sp)
 76a:	7a42                	ld	s4,48(sp)
 76c:	7aa2                	ld	s5,40(sp)
 76e:	7b02                	ld	s6,32(sp)
 770:	6be2                	ld	s7,24(sp)
 772:	6c42                	ld	s8,16(sp)
 774:	6ca2                	ld	s9,8(sp)
    }
  }
}
 776:	60e6                	ld	ra,88(sp)
 778:	6446                	ld	s0,80(sp)
 77a:	6906                	ld	s2,64(sp)
 77c:	6125                	addi	sp,sp,96
 77e:	8082                	ret

0000000000000780 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 780:	715d                	addi	sp,sp,-80
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e010                	sd	a2,0(s0)
 78a:	e414                	sd	a3,8(s0)
 78c:	e818                	sd	a4,16(s0)
 78e:	ec1c                	sd	a5,24(s0)
 790:	03043023          	sd	a6,32(s0)
 794:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 79c:	8622                	mv	a2,s0
 79e:	d5bff0ef          	jal	4f8 <vprintf>
}
 7a2:	60e2                	ld	ra,24(sp)
 7a4:	6442                	ld	s0,16(sp)
 7a6:	6161                	addi	sp,sp,80
 7a8:	8082                	ret

00000000000007aa <printf>:

void
printf(const char *fmt, ...)
{
 7aa:	711d                	addi	sp,sp,-96
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e40c                	sd	a1,8(s0)
 7b4:	e810                	sd	a2,16(s0)
 7b6:	ec14                	sd	a3,24(s0)
 7b8:	f018                	sd	a4,32(s0)
 7ba:	f41c                	sd	a5,40(s0)
 7bc:	03043823          	sd	a6,48(s0)
 7c0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7c4:	00840613          	addi	a2,s0,8
 7c8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7cc:	85aa                	mv	a1,a0
 7ce:	4505                	li	a0,1
 7d0:	d29ff0ef          	jal	4f8 <vprintf>
}
 7d4:	60e2                	ld	ra,24(sp)
 7d6:	6442                	ld	s0,16(sp)
 7d8:	6125                	addi	sp,sp,96
 7da:	8082                	ret

00000000000007dc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7dc:	1141                	addi	sp,sp,-16
 7de:	e422                	sd	s0,8(sp)
 7e0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7e2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	00001797          	auipc	a5,0x1
 7ea:	81a7b783          	ld	a5,-2022(a5) # 1000 <freep>
 7ee:	a02d                	j	818 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7f0:	4618                	lw	a4,8(a2)
 7f2:	9f2d                	addw	a4,a4,a1
 7f4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f8:	6398                	ld	a4,0(a5)
 7fa:	6310                	ld	a2,0(a4)
 7fc:	a83d                	j	83a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7fe:	ff852703          	lw	a4,-8(a0)
 802:	9f31                	addw	a4,a4,a2
 804:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 806:	ff053683          	ld	a3,-16(a0)
 80a:	a091                	j	84e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80c:	6398                	ld	a4,0(a5)
 80e:	00e7e463          	bltu	a5,a4,816 <free+0x3a>
 812:	00e6ea63          	bltu	a3,a4,826 <free+0x4a>
{
 816:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 818:	fed7fae3          	bgeu	a5,a3,80c <free+0x30>
 81c:	6398                	ld	a4,0(a5)
 81e:	00e6e463          	bltu	a3,a4,826 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 822:	fee7eae3          	bltu	a5,a4,816 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 826:	ff852583          	lw	a1,-8(a0)
 82a:	6390                	ld	a2,0(a5)
 82c:	02059813          	slli	a6,a1,0x20
 830:	01c85713          	srli	a4,a6,0x1c
 834:	9736                	add	a4,a4,a3
 836:	fae60de3          	beq	a2,a4,7f0 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 83e:	4790                	lw	a2,8(a5)
 840:	02061593          	slli	a1,a2,0x20
 844:	01c5d713          	srli	a4,a1,0x1c
 848:	973e                	add	a4,a4,a5
 84a:	fae68ae3          	beq	a3,a4,7fe <free+0x22>
    p->s.ptr = bp->s.ptr;
 84e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 850:	00000717          	auipc	a4,0x0
 854:	7af73823          	sd	a5,1968(a4) # 1000 <freep>
}
 858:	6422                	ld	s0,8(sp)
 85a:	0141                	addi	sp,sp,16
 85c:	8082                	ret

000000000000085e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 85e:	7139                	addi	sp,sp,-64
 860:	fc06                	sd	ra,56(sp)
 862:	f822                	sd	s0,48(sp)
 864:	f426                	sd	s1,40(sp)
 866:	ec4e                	sd	s3,24(sp)
 868:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	02051493          	slli	s1,a0,0x20
 86e:	9081                	srli	s1,s1,0x20
 870:	04bd                	addi	s1,s1,15
 872:	8091                	srli	s1,s1,0x4
 874:	0014899b          	addiw	s3,s1,1
 878:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 87a:	00000517          	auipc	a0,0x0
 87e:	78653503          	ld	a0,1926(a0) # 1000 <freep>
 882:	c915                	beqz	a0,8b6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 884:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 886:	4798                	lw	a4,8(a5)
 888:	08977a63          	bgeu	a4,s1,91c <malloc+0xbe>
 88c:	f04a                	sd	s2,32(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 894:	8a4e                	mv	s4,s3
 896:	0009871b          	sext.w	a4,s3
 89a:	6685                	lui	a3,0x1
 89c:	00d77363          	bgeu	a4,a3,8a2 <malloc+0x44>
 8a0:	6a05                	lui	s4,0x1
 8a2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8aa:	00000917          	auipc	s2,0x0
 8ae:	75690913          	addi	s2,s2,1878 # 1000 <freep>
  if(p == (char*)-1)
 8b2:	5afd                	li	s5,-1
 8b4:	a081                	j	8f4 <malloc+0x96>
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8be:	00000797          	auipc	a5,0x0
 8c2:	75278793          	addi	a5,a5,1874 # 1010 <base>
 8c6:	00000717          	auipc	a4,0x0
 8ca:	72f73d23          	sd	a5,1850(a4) # 1000 <freep>
 8ce:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8d0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8d4:	b7c1                	j	894 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8d6:	6398                	ld	a4,0(a5)
 8d8:	e118                	sd	a4,0(a0)
 8da:	a8a9                	j	934 <malloc+0xd6>
  hp->s.size = nu;
 8dc:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e0:	0541                	addi	a0,a0,16
 8e2:	efbff0ef          	jal	7dc <free>
  return freep;
 8e6:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8ea:	c12d                	beqz	a0,94c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ee:	4798                	lw	a4,8(a5)
 8f0:	02977263          	bgeu	a4,s1,914 <malloc+0xb6>
    if(p == freep)
 8f4:	00093703          	ld	a4,0(s2)
 8f8:	853e                	mv	a0,a5
 8fa:	fef719e3          	bne	a4,a5,8ec <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8fe:	8552                	mv	a0,s4
 900:	acbff0ef          	jal	3ca <sbrk>
  if(p == (char*)-1)
 904:	fd551ce3          	bne	a0,s5,8dc <malloc+0x7e>
        return 0;
 908:	4501                	li	a0,0
 90a:	7902                	ld	s2,32(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
 912:	a03d                	j	940 <malloc+0xe2>
 914:	7902                	ld	s2,32(sp)
 916:	6a42                	ld	s4,16(sp)
 918:	6aa2                	ld	s5,8(sp)
 91a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 91c:	fae48de3          	beq	s1,a4,8d6 <malloc+0x78>
        p->s.size -= nunits;
 920:	4137073b          	subw	a4,a4,s3
 924:	c798                	sw	a4,8(a5)
        p += p->s.size;
 926:	02071693          	slli	a3,a4,0x20
 92a:	01c6d713          	srli	a4,a3,0x1c
 92e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 930:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 934:	00000717          	auipc	a4,0x0
 938:	6ca73623          	sd	a0,1740(a4) # 1000 <freep>
      return (void*)(p + 1);
 93c:	01078513          	addi	a0,a5,16
  }
}
 940:	70e2                	ld	ra,56(sp)
 942:	7442                	ld	s0,48(sp)
 944:	74a2                	ld	s1,40(sp)
 946:	69e2                	ld	s3,24(sp)
 948:	6121                	addi	sp,sp,64
 94a:	8082                	ret
 94c:	7902                	ld	s2,32(sp)
 94e:	6a42                	ld	s4,16(sp)
 950:	6aa2                	ld	s5,8(sp)
 952:	6b02                	ld	s6,0(sp)
 954:	b7f5                	j	940 <malloc+0xe2>
