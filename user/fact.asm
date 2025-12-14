
user/_fact:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <factorial>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

unsigned long factorial(int n) {
    if (n == 0 || n == 1)
   0:	4785                	li	a5,1
   2:	02a7f263          	bgeu	a5,a0,26 <factorial+0x26>
unsigned long factorial(int n) {
   6:	1101                	addi	sp,sp,-32
   8:	ec06                	sd	ra,24(sp)
   a:	e822                	sd	s0,16(sp)
   c:	e426                	sd	s1,8(sp)
   e:	1000                	addi	s0,sp,32
  10:	84aa                	mv	s1,a0
        return 1;
    return n * factorial(n - 1);
  12:	357d                	addiw	a0,a0,-1
  14:	fedff0ef          	jal	0 <factorial>
  18:	02a48533          	mul	a0,s1,a0
}
  1c:	60e2                	ld	ra,24(sp)
  1e:	6442                	ld	s0,16(sp)
  20:	64a2                	ld	s1,8(sp)
  22:	6105                	addi	sp,sp,32
  24:	8082                	ret
        return 1;
  26:	4505                	li	a0,1
}
  28:	8082                	ret

000000000000002a <main>:

int main(int argc, char *argv[]) {
  2a:	1101                	addi	sp,sp,-32
  2c:	ec06                	sd	ra,24(sp)
  2e:	e822                	sd	s0,16(sp)
  30:	1000                	addi	s0,sp,32
    if (argc != 2) {
  32:	4789                	li	a5,2
  34:	02f51c63          	bne	a0,a5,6c <main+0x42>
        fprintf(2, "Usage: fact number\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
  38:	6588                	ld	a0,8(a1)
  3a:	00054703          	lbu	a4,0(a0)
  3e:	03f00793          	li	a5,63
  42:	04f70063          	beq	a4,a5,82 <main+0x58>
  46:	e426                	sd	s1,8(sp)
        printf("Usage: fact number\n");
        printf("Calculate factorial of a non-negative integer\n");
        exit(0);
    }

    int num = atoi(argv[1]);
  48:	1fc000ef          	jal	244 <atoi>
  4c:	84aa                	mv	s1,a0

    if (num < 0) {
  4e:	04054a63          	bltz	a0,a2 <main+0x78>
        fprintf(2, "fact: number must be non-negative\n");
        exit(1);
    }

    if (num > 12) { // Prevent overflow for 32-bit integers
  52:	47b1                	li	a5,12
  54:	06a7d163          	bge	a5,a0,b6 <main+0x8c>
        fprintf(2, "fact: number too large (max 12)\n");
  58:	00001597          	auipc	a1,0x1
  5c:	96858593          	addi	a1,a1,-1688 # 9c0 <malloc+0x16a>
  60:	4509                	li	a0,2
  62:	716000ef          	jal	778 <fprintf>
        exit(1);
  66:	4505                	li	a0,1
  68:	2d2000ef          	jal	33a <exit>
  6c:	e426                	sd	s1,8(sp)
        fprintf(2, "Usage: fact number\n");
  6e:	00001597          	auipc	a1,0x1
  72:	8e258593          	addi	a1,a1,-1822 # 950 <malloc+0xfa>
  76:	4509                	li	a0,2
  78:	700000ef          	jal	778 <fprintf>
        exit(1);
  7c:	4505                	li	a0,1
  7e:	2bc000ef          	jal	33a <exit>
  82:	e426                	sd	s1,8(sp)
        printf("Usage: fact number\n");
  84:	00001517          	auipc	a0,0x1
  88:	8cc50513          	addi	a0,a0,-1844 # 950 <malloc+0xfa>
  8c:	716000ef          	jal	7a2 <printf>
        printf("Calculate factorial of a non-negative integer\n");
  90:	00001517          	auipc	a0,0x1
  94:	8d850513          	addi	a0,a0,-1832 # 968 <malloc+0x112>
  98:	70a000ef          	jal	7a2 <printf>
        exit(0);
  9c:	4501                	li	a0,0
  9e:	29c000ef          	jal	33a <exit>
        fprintf(2, "fact: number must be non-negative\n");
  a2:	00001597          	auipc	a1,0x1
  a6:	8f658593          	addi	a1,a1,-1802 # 998 <malloc+0x142>
  aa:	4509                	li	a0,2
  ac:	6cc000ef          	jal	778 <fprintf>
        exit(1);
  b0:	4505                	li	a0,1
  b2:	288000ef          	jal	33a <exit>
    }

    unsigned long result = factorial(num);
  b6:	f4bff0ef          	jal	0 <factorial>
  ba:	862a                	mv	a2,a0
    printf("%d! = %lu\n", num, result);
  bc:	85a6                	mv	a1,s1
  be:	00001517          	auipc	a0,0x1
  c2:	92a50513          	addi	a0,a0,-1750 # 9e8 <malloc+0x192>
  c6:	6dc000ef          	jal	7a2 <printf>
    exit(0);
  ca:	4501                	li	a0,0
  cc:	26e000ef          	jal	33a <exit>

00000000000000d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
  d8:	f53ff0ef          	jal	2a <main>
  exit(0);
  dc:	4501                	li	a0,0
  de:	25c000ef          	jal	33a <exit>

00000000000000e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e422                	sd	s0,8(sp)
  e6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e8:	87aa                	mv	a5,a0
  ea:	0585                	addi	a1,a1,1
  ec:	0785                	addi	a5,a5,1
  ee:	fff5c703          	lbu	a4,-1(a1)
  f2:	fee78fa3          	sb	a4,-1(a5)
  f6:	fb75                	bnez	a4,ea <strcpy+0x8>
    ;
  return os;
}
  f8:	6422                	ld	s0,8(sp)
  fa:	0141                	addi	sp,sp,16
  fc:	8082                	ret

00000000000000fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fe:	1141                	addi	sp,sp,-16
 100:	e422                	sd	s0,8(sp)
 102:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 104:	00054783          	lbu	a5,0(a0)
 108:	cb91                	beqz	a5,11c <strcmp+0x1e>
 10a:	0005c703          	lbu	a4,0(a1)
 10e:	00f71763          	bne	a4,a5,11c <strcmp+0x1e>
    p++, q++;
 112:	0505                	addi	a0,a0,1
 114:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbe5                	bnez	a5,10a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 11c:	0005c503          	lbu	a0,0(a1)
}
 120:	40a7853b          	subw	a0,a5,a0
 124:	6422                	ld	s0,8(sp)
 126:	0141                	addi	sp,sp,16
 128:	8082                	ret

000000000000012a <strlen>:

uint
strlen(const char *s)
{
 12a:	1141                	addi	sp,sp,-16
 12c:	e422                	sd	s0,8(sp)
 12e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 130:	00054783          	lbu	a5,0(a0)
 134:	cf91                	beqz	a5,150 <strlen+0x26>
 136:	0505                	addi	a0,a0,1
 138:	87aa                	mv	a5,a0
 13a:	86be                	mv	a3,a5
 13c:	0785                	addi	a5,a5,1
 13e:	fff7c703          	lbu	a4,-1(a5)
 142:	ff65                	bnez	a4,13a <strlen+0x10>
 144:	40a6853b          	subw	a0,a3,a0
 148:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 14a:	6422                	ld	s0,8(sp)
 14c:	0141                	addi	sp,sp,16
 14e:	8082                	ret
  for(n = 0; s[n]; n++)
 150:	4501                	li	a0,0
 152:	bfe5                	j	14a <strlen+0x20>

0000000000000154 <memset>:

void*
memset(void *dst, int c, uint n)
{
 154:	1141                	addi	sp,sp,-16
 156:	e422                	sd	s0,8(sp)
 158:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15a:	ca19                	beqz	a2,170 <memset+0x1c>
 15c:	87aa                	mv	a5,a0
 15e:	1602                	slli	a2,a2,0x20
 160:	9201                	srli	a2,a2,0x20
 162:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 166:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16a:	0785                	addi	a5,a5,1
 16c:	fee79de3          	bne	a5,a4,166 <memset+0x12>
  }
  return dst;
}
 170:	6422                	ld	s0,8(sp)
 172:	0141                	addi	sp,sp,16
 174:	8082                	ret

0000000000000176 <strchr>:

char*
strchr(const char *s, char c)
{
 176:	1141                	addi	sp,sp,-16
 178:	e422                	sd	s0,8(sp)
 17a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 17c:	00054783          	lbu	a5,0(a0)
 180:	cb99                	beqz	a5,196 <strchr+0x20>
    if(*s == c)
 182:	00f58763          	beq	a1,a5,190 <strchr+0x1a>
  for(; *s; s++)
 186:	0505                	addi	a0,a0,1
 188:	00054783          	lbu	a5,0(a0)
 18c:	fbfd                	bnez	a5,182 <strchr+0xc>
      return (char*)s;
  return 0;
 18e:	4501                	li	a0,0
}
 190:	6422                	ld	s0,8(sp)
 192:	0141                	addi	sp,sp,16
 194:	8082                	ret
  return 0;
 196:	4501                	li	a0,0
 198:	bfe5                	j	190 <strchr+0x1a>

000000000000019a <gets>:

char*
gets(char *buf, int max)
{
 19a:	711d                	addi	sp,sp,-96
 19c:	ec86                	sd	ra,88(sp)
 19e:	e8a2                	sd	s0,80(sp)
 1a0:	e4a6                	sd	s1,72(sp)
 1a2:	e0ca                	sd	s2,64(sp)
 1a4:	fc4e                	sd	s3,56(sp)
 1a6:	f852                	sd	s4,48(sp)
 1a8:	f456                	sd	s5,40(sp)
 1aa:	f05a                	sd	s6,32(sp)
 1ac:	ec5e                	sd	s7,24(sp)
 1ae:	1080                	addi	s0,sp,96
 1b0:	8baa                	mv	s7,a0
 1b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b4:	892a                	mv	s2,a0
 1b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1b8:	4aa9                	li	s5,10
 1ba:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1bc:	89a6                	mv	s3,s1
 1be:	2485                	addiw	s1,s1,1
 1c0:	0344d663          	bge	s1,s4,1ec <gets+0x52>
    cc = read(0, &c, 1);
 1c4:	4605                	li	a2,1
 1c6:	faf40593          	addi	a1,s0,-81
 1ca:	4501                	li	a0,0
 1cc:	186000ef          	jal	352 <read>
    if(cc < 1)
 1d0:	00a05e63          	blez	a0,1ec <gets+0x52>
    buf[i++] = c;
 1d4:	faf44783          	lbu	a5,-81(s0)
 1d8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1dc:	01578763          	beq	a5,s5,1ea <gets+0x50>
 1e0:	0905                	addi	s2,s2,1
 1e2:	fd679de3          	bne	a5,s6,1bc <gets+0x22>
    buf[i++] = c;
 1e6:	89a6                	mv	s3,s1
 1e8:	a011                	j	1ec <gets+0x52>
 1ea:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1ec:	99de                	add	s3,s3,s7
 1ee:	00098023          	sb	zero,0(s3)
  return buf;
}
 1f2:	855e                	mv	a0,s7
 1f4:	60e6                	ld	ra,88(sp)
 1f6:	6446                	ld	s0,80(sp)
 1f8:	64a6                	ld	s1,72(sp)
 1fa:	6906                	ld	s2,64(sp)
 1fc:	79e2                	ld	s3,56(sp)
 1fe:	7a42                	ld	s4,48(sp)
 200:	7aa2                	ld	s5,40(sp)
 202:	7b02                	ld	s6,32(sp)
 204:	6be2                	ld	s7,24(sp)
 206:	6125                	addi	sp,sp,96
 208:	8082                	ret

000000000000020a <stat>:

int
stat(const char *n, struct stat *st)
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	e04a                	sd	s2,0(sp)
 212:	1000                	addi	s0,sp,32
 214:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 216:	4581                	li	a1,0
 218:	162000ef          	jal	37a <open>
  if(fd < 0)
 21c:	02054263          	bltz	a0,240 <stat+0x36>
 220:	e426                	sd	s1,8(sp)
 222:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 224:	85ca                	mv	a1,s2
 226:	16c000ef          	jal	392 <fstat>
 22a:	892a                	mv	s2,a0
  close(fd);
 22c:	8526                	mv	a0,s1
 22e:	134000ef          	jal	362 <close>
  return r;
 232:	64a2                	ld	s1,8(sp)
}
 234:	854a                	mv	a0,s2
 236:	60e2                	ld	ra,24(sp)
 238:	6442                	ld	s0,16(sp)
 23a:	6902                	ld	s2,0(sp)
 23c:	6105                	addi	sp,sp,32
 23e:	8082                	ret
    return -1;
 240:	597d                	li	s2,-1
 242:	bfcd                	j	234 <stat+0x2a>

0000000000000244 <atoi>:

int
atoi(const char *s)
{
 244:	1141                	addi	sp,sp,-16
 246:	e422                	sd	s0,8(sp)
 248:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 24a:	00054683          	lbu	a3,0(a0)
 24e:	fd06879b          	addiw	a5,a3,-48
 252:	0ff7f793          	zext.b	a5,a5
 256:	4625                	li	a2,9
 258:	02f66863          	bltu	a2,a5,288 <atoi+0x44>
 25c:	872a                	mv	a4,a0
  n = 0;
 25e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 260:	0705                	addi	a4,a4,1
 262:	0025179b          	slliw	a5,a0,0x2
 266:	9fa9                	addw	a5,a5,a0
 268:	0017979b          	slliw	a5,a5,0x1
 26c:	9fb5                	addw	a5,a5,a3
 26e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 272:	00074683          	lbu	a3,0(a4)
 276:	fd06879b          	addiw	a5,a3,-48
 27a:	0ff7f793          	zext.b	a5,a5
 27e:	fef671e3          	bgeu	a2,a5,260 <atoi+0x1c>
  return n;
}
 282:	6422                	ld	s0,8(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  n = 0;
 288:	4501                	li	a0,0
 28a:	bfe5                	j	282 <atoi+0x3e>

000000000000028c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e422                	sd	s0,8(sp)
 290:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 292:	02b57463          	bgeu	a0,a1,2ba <memmove+0x2e>
    while(n-- > 0)
 296:	00c05f63          	blez	a2,2b4 <memmove+0x28>
 29a:	1602                	slli	a2,a2,0x20
 29c:	9201                	srli	a2,a2,0x20
 29e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2a2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2a4:	0585                	addi	a1,a1,1
 2a6:	0705                	addi	a4,a4,1
 2a8:	fff5c683          	lbu	a3,-1(a1)
 2ac:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2b0:	fef71ae3          	bne	a4,a5,2a4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2b4:	6422                	ld	s0,8(sp)
 2b6:	0141                	addi	sp,sp,16
 2b8:	8082                	ret
    dst += n;
 2ba:	00c50733          	add	a4,a0,a2
    src += n;
 2be:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2c0:	fec05ae3          	blez	a2,2b4 <memmove+0x28>
 2c4:	fff6079b          	addiw	a5,a2,-1
 2c8:	1782                	slli	a5,a5,0x20
 2ca:	9381                	srli	a5,a5,0x20
 2cc:	fff7c793          	not	a5,a5
 2d0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2d2:	15fd                	addi	a1,a1,-1
 2d4:	177d                	addi	a4,a4,-1
 2d6:	0005c683          	lbu	a3,0(a1)
 2da:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2de:	fee79ae3          	bne	a5,a4,2d2 <memmove+0x46>
 2e2:	bfc9                	j	2b4 <memmove+0x28>

00000000000002e4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ea:	ca05                	beqz	a2,31a <memcmp+0x36>
 2ec:	fff6069b          	addiw	a3,a2,-1
 2f0:	1682                	slli	a3,a3,0x20
 2f2:	9281                	srli	a3,a3,0x20
 2f4:	0685                	addi	a3,a3,1
 2f6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	0005c703          	lbu	a4,0(a1)
 300:	00e79863          	bne	a5,a4,310 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 304:	0505                	addi	a0,a0,1
    p2++;
 306:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 308:	fed518e3          	bne	a0,a3,2f8 <memcmp+0x14>
  }
  return 0;
 30c:	4501                	li	a0,0
 30e:	a019                	j	314 <memcmp+0x30>
      return *p1 - *p2;
 310:	40e7853b          	subw	a0,a5,a4
}
 314:	6422                	ld	s0,8(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
  return 0;
 31a:	4501                	li	a0,0
 31c:	bfe5                	j	314 <memcmp+0x30>

000000000000031e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 326:	f67ff0ef          	jal	28c <memmove>
}
 32a:	60a2                	ld	ra,8(sp)
 32c:	6402                	ld	s0,0(sp)
 32e:	0141                	addi	sp,sp,16
 330:	8082                	ret

0000000000000332 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 332:	4885                	li	a7,1
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <exit>:
.global exit
exit:
 li a7, SYS_exit
 33a:	4889                	li	a7,2
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <wait>:
.global wait
wait:
 li a7, SYS_wait
 342:	488d                	li	a7,3
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 34a:	4891                	li	a7,4
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <read>:
.global read
read:
 li a7, SYS_read
 352:	4895                	li	a7,5
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <write>:
.global write
write:
 li a7, SYS_write
 35a:	48c1                	li	a7,16
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <close>:
.global close
close:
 li a7, SYS_close
 362:	48d5                	li	a7,21
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <kill>:
.global kill
kill:
 li a7, SYS_kill
 36a:	4899                	li	a7,6
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <exec>:
.global exec
exec:
 li a7, SYS_exec
 372:	489d                	li	a7,7
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <open>:
.global open
open:
 li a7, SYS_open
 37a:	48bd                	li	a7,15
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 382:	48c5                	li	a7,17
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 38a:	48c9                	li	a7,18
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 392:	48a1                	li	a7,8
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <link>:
.global link
link:
 li a7, SYS_link
 39a:	48cd                	li	a7,19
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a2:	48d1                	li	a7,20
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3aa:	48a5                	li	a7,9
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b2:	48a9                	li	a7,10
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ba:	48ad                	li	a7,11
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3c2:	48b1                	li	a7,12
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3ca:	48b5                	li	a7,13
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d2:	48b9                	li	a7,14
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 3da:	48d9                	li	a7,22
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 3e2:	48dd                	li	a7,23
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 3ea:	48e1                	li	a7,24
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <rand>:
.global rand
rand:
 li a7, SYS_rand
 3f2:	48e5                	li	a7,25
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 3fa:	48e9                	li	a7,26
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 402:	48ed                	li	a7,27
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 40a:	48f1                	li	a7,28
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 412:	48f5                	li	a7,29
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 41a:	48f9                	li	a7,30
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 422:	48fd                	li	a7,31
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42a:	1101                	addi	sp,sp,-32
 42c:	ec06                	sd	ra,24(sp)
 42e:	e822                	sd	s0,16(sp)
 430:	1000                	addi	s0,sp,32
 432:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 436:	4605                	li	a2,1
 438:	fef40593          	addi	a1,s0,-17
 43c:	f1fff0ef          	jal	35a <write>
}
 440:	60e2                	ld	ra,24(sp)
 442:	6442                	ld	s0,16(sp)
 444:	6105                	addi	sp,sp,32
 446:	8082                	ret

0000000000000448 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 448:	7139                	addi	sp,sp,-64
 44a:	fc06                	sd	ra,56(sp)
 44c:	f822                	sd	s0,48(sp)
 44e:	f426                	sd	s1,40(sp)
 450:	0080                	addi	s0,sp,64
 452:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 454:	c299                	beqz	a3,45a <printint+0x12>
 456:	0805c963          	bltz	a1,4e8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 45a:	2581                	sext.w	a1,a1
  neg = 0;
 45c:	4881                	li	a7,0
 45e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 462:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 464:	2601                	sext.w	a2,a2
 466:	00000517          	auipc	a0,0x0
 46a:	59a50513          	addi	a0,a0,1434 # a00 <digits>
 46e:	883a                	mv	a6,a4
 470:	2705                	addiw	a4,a4,1
 472:	02c5f7bb          	remuw	a5,a1,a2
 476:	1782                	slli	a5,a5,0x20
 478:	9381                	srli	a5,a5,0x20
 47a:	97aa                	add	a5,a5,a0
 47c:	0007c783          	lbu	a5,0(a5)
 480:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 484:	0005879b          	sext.w	a5,a1
 488:	02c5d5bb          	divuw	a1,a1,a2
 48c:	0685                	addi	a3,a3,1
 48e:	fec7f0e3          	bgeu	a5,a2,46e <printint+0x26>
  if(neg)
 492:	00088c63          	beqz	a7,4aa <printint+0x62>
    buf[i++] = '-';
 496:	fd070793          	addi	a5,a4,-48
 49a:	00878733          	add	a4,a5,s0
 49e:	02d00793          	li	a5,45
 4a2:	fef70823          	sb	a5,-16(a4)
 4a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4aa:	02e05a63          	blez	a4,4de <printint+0x96>
 4ae:	f04a                	sd	s2,32(sp)
 4b0:	ec4e                	sd	s3,24(sp)
 4b2:	fc040793          	addi	a5,s0,-64
 4b6:	00e78933          	add	s2,a5,a4
 4ba:	fff78993          	addi	s3,a5,-1
 4be:	99ba                	add	s3,s3,a4
 4c0:	377d                	addiw	a4,a4,-1
 4c2:	1702                	slli	a4,a4,0x20
 4c4:	9301                	srli	a4,a4,0x20
 4c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ca:	fff94583          	lbu	a1,-1(s2)
 4ce:	8526                	mv	a0,s1
 4d0:	f5bff0ef          	jal	42a <putc>
  while(--i >= 0)
 4d4:	197d                	addi	s2,s2,-1
 4d6:	ff391ae3          	bne	s2,s3,4ca <printint+0x82>
 4da:	7902                	ld	s2,32(sp)
 4dc:	69e2                	ld	s3,24(sp)
}
 4de:	70e2                	ld	ra,56(sp)
 4e0:	7442                	ld	s0,48(sp)
 4e2:	74a2                	ld	s1,40(sp)
 4e4:	6121                	addi	sp,sp,64
 4e6:	8082                	ret
    x = -xx;
 4e8:	40b005bb          	negw	a1,a1
    neg = 1;
 4ec:	4885                	li	a7,1
    x = -xx;
 4ee:	bf85                	j	45e <printint+0x16>

00000000000004f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4f0:	711d                	addi	sp,sp,-96
 4f2:	ec86                	sd	ra,88(sp)
 4f4:	e8a2                	sd	s0,80(sp)
 4f6:	e0ca                	sd	s2,64(sp)
 4f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4fa:	0005c903          	lbu	s2,0(a1)
 4fe:	26090863          	beqz	s2,76e <vprintf+0x27e>
 502:	e4a6                	sd	s1,72(sp)
 504:	fc4e                	sd	s3,56(sp)
 506:	f852                	sd	s4,48(sp)
 508:	f456                	sd	s5,40(sp)
 50a:	f05a                	sd	s6,32(sp)
 50c:	ec5e                	sd	s7,24(sp)
 50e:	e862                	sd	s8,16(sp)
 510:	e466                	sd	s9,8(sp)
 512:	8b2a                	mv	s6,a0
 514:	8a2e                	mv	s4,a1
 516:	8bb2                	mv	s7,a2
  state = 0;
 518:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 51a:	4481                	li	s1,0
 51c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 51e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 522:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 526:	06c00c93          	li	s9,108
 52a:	a005                	j	54a <vprintf+0x5a>
        putc(fd, c0);
 52c:	85ca                	mv	a1,s2
 52e:	855a                	mv	a0,s6
 530:	efbff0ef          	jal	42a <putc>
 534:	a019                	j	53a <vprintf+0x4a>
    } else if(state == '%'){
 536:	03598263          	beq	s3,s5,55a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 53a:	2485                	addiw	s1,s1,1
 53c:	8726                	mv	a4,s1
 53e:	009a07b3          	add	a5,s4,s1
 542:	0007c903          	lbu	s2,0(a5)
 546:	20090c63          	beqz	s2,75e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 54a:	0009079b          	sext.w	a5,s2
    if(state == 0){
 54e:	fe0994e3          	bnez	s3,536 <vprintf+0x46>
      if(c0 == '%'){
 552:	fd579de3          	bne	a5,s5,52c <vprintf+0x3c>
        state = '%';
 556:	89be                	mv	s3,a5
 558:	b7cd                	j	53a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 55a:	00ea06b3          	add	a3,s4,a4
 55e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 562:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 564:	c681                	beqz	a3,56c <vprintf+0x7c>
 566:	9752                	add	a4,a4,s4
 568:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 56c:	03878f63          	beq	a5,s8,5aa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 570:	05978963          	beq	a5,s9,5c2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 574:	07500713          	li	a4,117
 578:	0ee78363          	beq	a5,a4,65e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 57c:	07800713          	li	a4,120
 580:	12e78563          	beq	a5,a4,6aa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 584:	07000713          	li	a4,112
 588:	14e78a63          	beq	a5,a4,6dc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 58c:	07300713          	li	a4,115
 590:	18e78a63          	beq	a5,a4,724 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 594:	02500713          	li	a4,37
 598:	04e79563          	bne	a5,a4,5e2 <vprintf+0xf2>
        putc(fd, '%');
 59c:	02500593          	li	a1,37
 5a0:	855a                	mv	a0,s6
 5a2:	e89ff0ef          	jal	42a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	bf49                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b8913          	addi	s2,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e91ff0ef          	jal	448 <printint>
 5bc:	8bca                	mv	s7,s2
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	bfad                	j	53a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5c2:	06400793          	li	a5,100
 5c6:	02f68963          	beq	a3,a5,5f8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5ca:	06c00793          	li	a5,108
 5ce:	04f68263          	beq	a3,a5,612 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 5d2:	07500793          	li	a5,117
 5d6:	0af68063          	beq	a3,a5,676 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 5da:	07800793          	li	a5,120
 5de:	0ef68263          	beq	a3,a5,6c2 <vprintf+0x1d2>
        putc(fd, '%');
 5e2:	02500593          	li	a1,37
 5e6:	855a                	mv	a0,s6
 5e8:	e43ff0ef          	jal	42a <putc>
        putc(fd, c0);
 5ec:	85ca                	mv	a1,s2
 5ee:	855a                	mv	a0,s6
 5f0:	e3bff0ef          	jal	42a <putc>
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b791                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e43ff0ef          	jal	448 <printint>
        i += 1;
 60a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8bca                	mv	s7,s2
      state = 0;
 60e:	4981                	li	s3,0
        i += 1;
 610:	b72d                	j	53a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 612:	06400793          	li	a5,100
 616:	02f60763          	beq	a2,a5,644 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 61a:	07500793          	li	a5,117
 61e:	06f60963          	beq	a2,a5,690 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 622:	07800793          	li	a5,120
 626:	faf61ee3          	bne	a2,a5,5e2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4681                	li	a3,0
 630:	4641                	li	a2,16
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e11ff0ef          	jal	448 <printint>
        i += 2;
 63c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 2;
 642:	bde5                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 644:	008b8913          	addi	s2,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	df7ff0ef          	jal	448 <printint>
        i += 2;
 656:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	bdf9                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 65e:	008b8913          	addi	s2,s7,8
 662:	4681                	li	a3,0
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	dddff0ef          	jal	448 <printint>
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	b5d9                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 676:	008b8913          	addi	s2,s7,8
 67a:	4681                	li	a3,0
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	dc5ff0ef          	jal	448 <printint>
        i += 1;
 688:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 1;
 68e:	b575                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	dabff0ef          	jal	448 <printint>
        i += 2;
 6a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a4:	8bca                	mv	s7,s2
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	bd49                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6aa:	008b8913          	addi	s2,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4641                	li	a2,16
 6b2:	000ba583          	lw	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	d91ff0ef          	jal	448 <printint>
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	bdad                	j	53a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4641                	li	a2,16
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	d79ff0ef          	jal	448 <printint>
        i += 1;
 6d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 1;
 6da:	b585                	j	53a <vprintf+0x4a>
 6dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6de:	008b8d13          	addi	s10,s7,8
 6e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6e6:	03000593          	li	a1,48
 6ea:	855a                	mv	a0,s6
 6ec:	d3fff0ef          	jal	42a <putc>
  putc(fd, 'x');
 6f0:	07800593          	li	a1,120
 6f4:	855a                	mv	a0,s6
 6f6:	d35ff0ef          	jal	42a <putc>
 6fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6fc:	00000b97          	auipc	s7,0x0
 700:	304b8b93          	addi	s7,s7,772 # a00 <digits>
 704:	03c9d793          	srli	a5,s3,0x3c
 708:	97de                	add	a5,a5,s7
 70a:	0007c583          	lbu	a1,0(a5)
 70e:	855a                	mv	a0,s6
 710:	d1bff0ef          	jal	42a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 714:	0992                	slli	s3,s3,0x4
 716:	397d                	addiw	s2,s2,-1
 718:	fe0916e3          	bnez	s2,704 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 71c:	8bea                	mv	s7,s10
      state = 0;
 71e:	4981                	li	s3,0
 720:	6d02                	ld	s10,0(sp)
 722:	bd21                	j	53a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 724:	008b8993          	addi	s3,s7,8
 728:	000bb903          	ld	s2,0(s7)
 72c:	00090f63          	beqz	s2,74a <vprintf+0x25a>
        for(; *s; s++)
 730:	00094583          	lbu	a1,0(s2)
 734:	c195                	beqz	a1,758 <vprintf+0x268>
          putc(fd, *s);
 736:	855a                	mv	a0,s6
 738:	cf3ff0ef          	jal	42a <putc>
        for(; *s; s++)
 73c:	0905                	addi	s2,s2,1
 73e:	00094583          	lbu	a1,0(s2)
 742:	f9f5                	bnez	a1,736 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	bbcd                	j	53a <vprintf+0x4a>
          s = "(null)";
 74a:	00000917          	auipc	s2,0x0
 74e:	2ae90913          	addi	s2,s2,686 # 9f8 <malloc+0x1a2>
        for(; *s; s++)
 752:	02800593          	li	a1,40
 756:	b7c5                	j	736 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 758:	8bce                	mv	s7,s3
      state = 0;
 75a:	4981                	li	s3,0
 75c:	bbf9                	j	53a <vprintf+0x4a>
 75e:	64a6                	ld	s1,72(sp)
 760:	79e2                	ld	s3,56(sp)
 762:	7a42                	ld	s4,48(sp)
 764:	7aa2                	ld	s5,40(sp)
 766:	7b02                	ld	s6,32(sp)
 768:	6be2                	ld	s7,24(sp)
 76a:	6c42                	ld	s8,16(sp)
 76c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 76e:	60e6                	ld	ra,88(sp)
 770:	6446                	ld	s0,80(sp)
 772:	6906                	ld	s2,64(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 778:	715d                	addi	sp,sp,-80
 77a:	ec06                	sd	ra,24(sp)
 77c:	e822                	sd	s0,16(sp)
 77e:	1000                	addi	s0,sp,32
 780:	e010                	sd	a2,0(s0)
 782:	e414                	sd	a3,8(s0)
 784:	e818                	sd	a4,16(s0)
 786:	ec1c                	sd	a5,24(s0)
 788:	03043023          	sd	a6,32(s0)
 78c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	8622                	mv	a2,s0
 796:	d5bff0ef          	jal	4f0 <vprintf>
}
 79a:	60e2                	ld	ra,24(sp)
 79c:	6442                	ld	s0,16(sp)
 79e:	6161                	addi	sp,sp,80
 7a0:	8082                	ret

00000000000007a2 <printf>:

void
printf(const char *fmt, ...)
{
 7a2:	711d                	addi	sp,sp,-96
 7a4:	ec06                	sd	ra,24(sp)
 7a6:	e822                	sd	s0,16(sp)
 7a8:	1000                	addi	s0,sp,32
 7aa:	e40c                	sd	a1,8(s0)
 7ac:	e810                	sd	a2,16(s0)
 7ae:	ec14                	sd	a3,24(s0)
 7b0:	f018                	sd	a4,32(s0)
 7b2:	f41c                	sd	a5,40(s0)
 7b4:	03043823          	sd	a6,48(s0)
 7b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7bc:	00840613          	addi	a2,s0,8
 7c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c4:	85aa                	mv	a1,a0
 7c6:	4505                	li	a0,1
 7c8:	d29ff0ef          	jal	4f0 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret

00000000000007d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d4:	1141                	addi	sp,sp,-16
 7d6:	e422                	sd	s0,8(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a02d                	j	810 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7e8:	4618                	lw	a4,8(a2)
 7ea:	9f2d                	addw	a4,a4,a1
 7ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f0:	6398                	ld	a4,0(a5)
 7f2:	6310                	ld	a2,0(a4)
 7f4:	a83d                	j	832 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7f6:	ff852703          	lw	a4,-8(a0)
 7fa:	9f31                	addw	a4,a4,a2
 7fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7fe:	ff053683          	ld	a3,-16(a0)
 802:	a091                	j	846 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	6398                	ld	a4,0(a5)
 806:	00e7e463          	bltu	a5,a4,80e <free+0x3a>
 80a:	00e6ea63          	bltu	a3,a4,81e <free+0x4a>
{
 80e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	fed7fae3          	bgeu	a5,a3,804 <free+0x30>
 814:	6398                	ld	a4,0(a5)
 816:	00e6e463          	bltu	a3,a4,81e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	fee7eae3          	bltu	a5,a4,80e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 81e:	ff852583          	lw	a1,-8(a0)
 822:	6390                	ld	a2,0(a5)
 824:	02059813          	slli	a6,a1,0x20
 828:	01c85713          	srli	a4,a6,0x1c
 82c:	9736                	add	a4,a4,a3
 82e:	fae60de3          	beq	a2,a4,7e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 832:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 836:	4790                	lw	a2,8(a5)
 838:	02061593          	slli	a1,a2,0x20
 83c:	01c5d713          	srli	a4,a1,0x1c
 840:	973e                	add	a4,a4,a5
 842:	fae68ae3          	beq	a3,a4,7f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 846:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 848:	00000717          	auipc	a4,0x0
 84c:	7af73c23          	sd	a5,1976(a4) # 1000 <freep>
}
 850:	6422                	ld	s0,8(sp)
 852:	0141                	addi	sp,sp,16
 854:	8082                	ret

0000000000000856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f426                	sd	s1,40(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	02051493          	slli	s1,a0,0x20
 866:	9081                	srli	s1,s1,0x20
 868:	04bd                	addi	s1,s1,15
 86a:	8091                	srli	s1,s1,0x4
 86c:	0014899b          	addiw	s3,s1,1
 870:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 872:	00000517          	auipc	a0,0x0
 876:	78e53503          	ld	a0,1934(a0) # 1000 <freep>
 87a:	c915                	beqz	a0,8ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	08977a63          	bgeu	a4,s1,914 <malloc+0xbe>
 884:	f04a                	sd	s2,32(sp)
 886:	e852                	sd	s4,16(sp)
 888:	e456                	sd	s5,8(sp)
 88a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 88c:	8a4e                	mv	s4,s3
 88e:	0009871b          	sext.w	a4,s3
 892:	6685                	lui	a3,0x1
 894:	00d77363          	bgeu	a4,a3,89a <malloc+0x44>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000917          	auipc	s2,0x0
 8a6:	75e90913          	addi	s2,s2,1886 # 1000 <freep>
  if(p == (char*)-1)
 8aa:	5afd                	li	s5,-1
 8ac:	a081                	j	8ec <malloc+0x96>
 8ae:	f04a                	sd	s2,32(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b6:	00000797          	auipc	a5,0x0
 8ba:	75a78793          	addi	a5,a5,1882 # 1010 <base>
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
 8c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8cc:	b7c1                	j	88c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ce:	6398                	ld	a4,0(a5)
 8d0:	e118                	sd	a4,0(a0)
 8d2:	a8a9                	j	92c <malloc+0xd6>
  hp->s.size = nu;
 8d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d8:	0541                	addi	a0,a0,16
 8da:	efbff0ef          	jal	7d4 <free>
  return freep;
 8de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8e2:	c12d                	beqz	a0,944 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e6:	4798                	lw	a4,8(a5)
 8e8:	02977263          	bgeu	a4,s1,90c <malloc+0xb6>
    if(p == freep)
 8ec:	00093703          	ld	a4,0(s2)
 8f0:	853e                	mv	a0,a5
 8f2:	fef719e3          	bne	a4,a5,8e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 8f6:	8552                	mv	a0,s4
 8f8:	acbff0ef          	jal	3c2 <sbrk>
  if(p == (char*)-1)
 8fc:	fd551ce3          	bne	a0,s5,8d4 <malloc+0x7e>
        return 0;
 900:	4501                	li	a0,0
 902:	7902                	ld	s2,32(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	a03d                	j	938 <malloc+0xe2>
 90c:	7902                	ld	s2,32(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 914:	fae48de3          	beq	s1,a4,8ce <malloc+0x78>
        p->s.size -= nunits;
 918:	4137073b          	subw	a4,a4,s3
 91c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91e:	02071693          	slli	a3,a4,0x20
 922:	01c6d713          	srli	a4,a3,0x1c
 926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92c:	00000717          	auipc	a4,0x0
 930:	6ca73a23          	sd	a0,1748(a4) # 1000 <freep>
      return (void*)(p + 1);
 934:	01078513          	addi	a0,a5,16
  }
}
 938:	70e2                	ld	ra,56(sp)
 93a:	7442                	ld	s0,48(sp)
 93c:	74a2                	ld	s1,40(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	b7f5                	j	938 <malloc+0xe2>
