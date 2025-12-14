
user/_cp:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/fcntl.h"

#define BSIZE 512

int main(int argc, char *argv[]) {
   0:	dd010113          	addi	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	1c00                	addi	s0,sp,560
    int src_fd, dst_fd;
    char buf[BSIZE];
    int n;

    if (argc != 3) {
   e:	478d                	li	a5,3
  10:	08f51063          	bne	a0,a5,90 <main+0x90>
  14:	20913c23          	sd	s1,536(sp)
  18:	21213823          	sd	s2,528(sp)
  1c:	21313423          	sd	s3,520(sp)
  20:	84ae                	mv	s1,a1
        fprintf(2, "Usage: cp source destination\n");
        exit(1);
    }

    if (argv[1][0] == '?') {
  22:	6588                	ld	a0,8(a1)
  24:	00054703          	lbu	a4,0(a0)
  28:	03f00793          	li	a5,63
  2c:	08f70263          	beq	a4,a5,b0 <main+0xb0>
        printf("Copy source file to destination\n");
        exit(0);
    }

    // Open source file
    if ((src_fd = open(argv[1], O_RDONLY)) < 0) {
  30:	4581                	li	a1,0
  32:	39e000ef          	jal	3d0 <open>
  36:	892a                	mv	s2,a0
  38:	08054b63          	bltz	a0,ce <main+0xce>
        fprintf(2, "cp: cannot open %s\n", argv[1]);
        exit(1);
    }

    // Create destination file
    if ((dst_fd = open(argv[2], O_CREATE | O_WRONLY)) < 0) {
  3c:	20100593          	li	a1,513
  40:	6888                	ld	a0,16(s1)
  42:	38e000ef          	jal	3d0 <open>
  46:	89aa                	mv	s3,a0
  48:	08054e63          	bltz	a0,e4 <main+0xe4>
        close(src_fd);
        exit(1);
    }

    // Copy data
    while ((n = read(src_fd, buf, sizeof(buf))) > 0) {
  4c:	20000613          	li	a2,512
  50:	dd040593          	addi	a1,s0,-560
  54:	854a                	mv	a0,s2
  56:	352000ef          	jal	3a8 <read>
  5a:	84aa                	mv	s1,a0
  5c:	0aa05263          	blez	a0,100 <main+0x100>
        if (write(dst_fd, buf, n) != n) {
  60:	8626                	mv	a2,s1
  62:	dd040593          	addi	a1,s0,-560
  66:	854e                	mv	a0,s3
  68:	348000ef          	jal	3b0 <write>
  6c:	fe9500e3          	beq	a0,s1,4c <main+0x4c>
            fprintf(2, "cp: write error\n");
  70:	00001597          	auipc	a1,0x1
  74:	9c058593          	addi	a1,a1,-1600 # a30 <malloc+0x184>
  78:	4509                	li	a0,2
  7a:	754000ef          	jal	7ce <fprintf>
            close(src_fd);
  7e:	854a                	mv	a0,s2
  80:	338000ef          	jal	3b8 <close>
            close(dst_fd);
  84:	854e                	mv	a0,s3
  86:	332000ef          	jal	3b8 <close>
            exit(1);
  8a:	4505                	li	a0,1
  8c:	304000ef          	jal	390 <exit>
  90:	20913c23          	sd	s1,536(sp)
  94:	21213823          	sd	s2,528(sp)
  98:	21313423          	sd	s3,520(sp)
        fprintf(2, "Usage: cp source destination\n");
  9c:	00001597          	auipc	a1,0x1
  a0:	91458593          	addi	a1,a1,-1772 # 9b0 <malloc+0x104>
  a4:	4509                	li	a0,2
  a6:	728000ef          	jal	7ce <fprintf>
        exit(1);
  aa:	4505                	li	a0,1
  ac:	2e4000ef          	jal	390 <exit>
        printf("Usage: cp source destination\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	90050513          	addi	a0,a0,-1792 # 9b0 <malloc+0x104>
  b8:	740000ef          	jal	7f8 <printf>
        printf("Copy source file to destination\n");
  bc:	00001517          	auipc	a0,0x1
  c0:	91c50513          	addi	a0,a0,-1764 # 9d8 <malloc+0x12c>
  c4:	734000ef          	jal	7f8 <printf>
        exit(0);
  c8:	4501                	li	a0,0
  ca:	2c6000ef          	jal	390 <exit>
        fprintf(2, "cp: cannot open %s\n", argv[1]);
  ce:	6490                	ld	a2,8(s1)
  d0:	00001597          	auipc	a1,0x1
  d4:	93058593          	addi	a1,a1,-1744 # a00 <malloc+0x154>
  d8:	4509                	li	a0,2
  da:	6f4000ef          	jal	7ce <fprintf>
        exit(1);
  de:	4505                	li	a0,1
  e0:	2b0000ef          	jal	390 <exit>
        fprintf(2, "cp: cannot create %s\n", argv[2]);
  e4:	6890                	ld	a2,16(s1)
  e6:	00001597          	auipc	a1,0x1
  ea:	93258593          	addi	a1,a1,-1742 # a18 <malloc+0x16c>
  ee:	4509                	li	a0,2
  f0:	6de000ef          	jal	7ce <fprintf>
        close(src_fd);
  f4:	854a                	mv	a0,s2
  f6:	2c2000ef          	jal	3b8 <close>
        exit(1);
  fa:	4505                	li	a0,1
  fc:	294000ef          	jal	390 <exit>
        }
    }

    if (n < 0) {
 100:	00054b63          	bltz	a0,116 <main+0x116>
        fprintf(2, "cp: read error\n");
    }

    close(src_fd);
 104:	854a                	mv	a0,s2
 106:	2b2000ef          	jal	3b8 <close>
    close(dst_fd);
 10a:	854e                	mv	a0,s3
 10c:	2ac000ef          	jal	3b8 <close>
    exit(0);
 110:	4501                	li	a0,0
 112:	27e000ef          	jal	390 <exit>
        fprintf(2, "cp: read error\n");
 116:	00001597          	auipc	a1,0x1
 11a:	93258593          	addi	a1,a1,-1742 # a48 <malloc+0x19c>
 11e:	4509                	li	a0,2
 120:	6ae000ef          	jal	7ce <fprintf>
 124:	b7c5                	j	104 <main+0x104>

0000000000000126 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 12e:	ed3ff0ef          	jal	0 <main>
  exit(0);
 132:	4501                	li	a0,0
 134:	25c000ef          	jal	390 <exit>

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
 216:	0344d663          	bge	s1,s4,242 <gets+0x52>
    cc = read(0, &c, 1);
 21a:	4605                	li	a2,1
 21c:	faf40593          	addi	a1,s0,-81
 220:	4501                	li	a0,0
 222:	186000ef          	jal	3a8 <read>
    if(cc < 1)
 226:	00a05e63          	blez	a0,242 <gets+0x52>
    buf[i++] = c;
 22a:	faf44783          	lbu	a5,-81(s0)
 22e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 232:	01578763          	beq	a5,s5,240 <gets+0x50>
 236:	0905                	addi	s2,s2,1
 238:	fd679de3          	bne	a5,s6,212 <gets+0x22>
    buf[i++] = c;
 23c:	89a6                	mv	s3,s1
 23e:	a011                	j	242 <gets+0x52>
 240:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 242:	99de                	add	s3,s3,s7
 244:	00098023          	sb	zero,0(s3)
  return buf;
}
 248:	855e                	mv	a0,s7
 24a:	60e6                	ld	ra,88(sp)
 24c:	6446                	ld	s0,80(sp)
 24e:	64a6                	ld	s1,72(sp)
 250:	6906                	ld	s2,64(sp)
 252:	79e2                	ld	s3,56(sp)
 254:	7a42                	ld	s4,48(sp)
 256:	7aa2                	ld	s5,40(sp)
 258:	7b02                	ld	s6,32(sp)
 25a:	6be2                	ld	s7,24(sp)
 25c:	6125                	addi	sp,sp,96
 25e:	8082                	ret

0000000000000260 <stat>:

int
stat(const char *n, struct stat *st)
{
 260:	1101                	addi	sp,sp,-32
 262:	ec06                	sd	ra,24(sp)
 264:	e822                	sd	s0,16(sp)
 266:	e04a                	sd	s2,0(sp)
 268:	1000                	addi	s0,sp,32
 26a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26c:	4581                	li	a1,0
 26e:	162000ef          	jal	3d0 <open>
  if(fd < 0)
 272:	02054263          	bltz	a0,296 <stat+0x36>
 276:	e426                	sd	s1,8(sp)
 278:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27a:	85ca                	mv	a1,s2
 27c:	16c000ef          	jal	3e8 <fstat>
 280:	892a                	mv	s2,a0
  close(fd);
 282:	8526                	mv	a0,s1
 284:	134000ef          	jal	3b8 <close>
  return r;
 288:	64a2                	ld	s1,8(sp)
}
 28a:	854a                	mv	a0,s2
 28c:	60e2                	ld	ra,24(sp)
 28e:	6442                	ld	s0,16(sp)
 290:	6902                	ld	s2,0(sp)
 292:	6105                	addi	sp,sp,32
 294:	8082                	ret
    return -1;
 296:	597d                	li	s2,-1
 298:	bfcd                	j	28a <stat+0x2a>

000000000000029a <atoi>:

int
atoi(const char *s)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e422                	sd	s0,8(sp)
 29e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2a0:	00054683          	lbu	a3,0(a0)
 2a4:	fd06879b          	addiw	a5,a3,-48
 2a8:	0ff7f793          	zext.b	a5,a5
 2ac:	4625                	li	a2,9
 2ae:	02f66863          	bltu	a2,a5,2de <atoi+0x44>
 2b2:	872a                	mv	a4,a0
  n = 0;
 2b4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b6:	0705                	addi	a4,a4,1
 2b8:	0025179b          	slliw	a5,a0,0x2
 2bc:	9fa9                	addw	a5,a5,a0
 2be:	0017979b          	slliw	a5,a5,0x1
 2c2:	9fb5                	addw	a5,a5,a3
 2c4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c8:	00074683          	lbu	a3,0(a4)
 2cc:	fd06879b          	addiw	a5,a3,-48
 2d0:	0ff7f793          	zext.b	a5,a5
 2d4:	fef671e3          	bgeu	a2,a5,2b6 <atoi+0x1c>
  return n;
}
 2d8:	6422                	ld	s0,8(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  n = 0;
 2de:	4501                	li	a0,0
 2e0:	bfe5                	j	2d8 <atoi+0x3e>

00000000000002e2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e8:	02b57463          	bgeu	a0,a1,310 <memmove+0x2e>
    while(n-- > 0)
 2ec:	00c05f63          	blez	a2,30a <memmove+0x28>
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fa:	0585                	addi	a1,a1,1
 2fc:	0705                	addi	a4,a4,1
 2fe:	fff5c683          	lbu	a3,-1(a1)
 302:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 306:	fef71ae3          	bne	a4,a5,2fa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30a:	6422                	ld	s0,8(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 316:	fec05ae3          	blez	a2,30a <memmove+0x28>
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 334:	fee79ae3          	bne	a5,a4,328 <memmove+0x46>
 338:	bfc9                	j	30a <memmove+0x28>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e422                	sd	s0,8(sp)
 33e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 340:	ca05                	beqz	a2,370 <memcmp+0x36>
 342:	fff6069b          	addiw	a3,a2,-1
 346:	1682                	slli	a3,a3,0x20
 348:	9281                	srli	a3,a3,0x20
 34a:	0685                	addi	a3,a3,1
 34c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 34e:	00054783          	lbu	a5,0(a0)
 352:	0005c703          	lbu	a4,0(a1)
 356:	00e79863          	bne	a5,a4,366 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35a:	0505                	addi	a0,a0,1
    p2++;
 35c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35e:	fed518e3          	bne	a0,a3,34e <memcmp+0x14>
  }
  return 0;
 362:	4501                	li	a0,0
 364:	a019                	j	36a <memcmp+0x30>
      return *p1 - *p2;
 366:	40e7853b          	subw	a0,a5,a4
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	addi	sp,sp,16
 36e:	8082                	ret
  return 0;
 370:	4501                	li	a0,0
 372:	bfe5                	j	36a <memcmp+0x30>

0000000000000374 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 374:	1141                	addi	sp,sp,-16
 376:	e406                	sd	ra,8(sp)
 378:	e022                	sd	s0,0(sp)
 37a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 37c:	f67ff0ef          	jal	2e2 <memmove>
}
 380:	60a2                	ld	ra,8(sp)
 382:	6402                	ld	s0,0(sp)
 384:	0141                	addi	sp,sp,16
 386:	8082                	ret

0000000000000388 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 388:	4885                	li	a7,1
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <exit>:
.global exit
exit:
 li a7, SYS_exit
 390:	4889                	li	a7,2
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <wait>:
.global wait
wait:
 li a7, SYS_wait
 398:	488d                	li	a7,3
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a0:	4891                	li	a7,4
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <read>:
.global read
read:
 li a7, SYS_read
 3a8:	4895                	li	a7,5
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <write>:
.global write
write:
 li a7, SYS_write
 3b0:	48c1                	li	a7,16
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <close>:
.global close
close:
 li a7, SYS_close
 3b8:	48d5                	li	a7,21
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c0:	4899                	li	a7,6
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c8:	489d                	li	a7,7
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <open>:
.global open
open:
 li a7, SYS_open
 3d0:	48bd                	li	a7,15
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d8:	48c5                	li	a7,17
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e0:	48c9                	li	a7,18
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e8:	48a1                	li	a7,8
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <link>:
.global link
link:
 li a7, SYS_link
 3f0:	48cd                	li	a7,19
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f8:	48d1                	li	a7,20
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 400:	48a5                	li	a7,9
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <dup>:
.global dup
dup:
 li a7, SYS_dup
 408:	48a9                	li	a7,10
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 410:	48ad                	li	a7,11
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 418:	48b1                	li	a7,12
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 420:	48b5                	li	a7,13
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 428:	48b9                	li	a7,14
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 430:	48d9                	li	a7,22
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 438:	48dd                	li	a7,23
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 440:	48e1                	li	a7,24
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <rand>:
.global rand
rand:
 li a7, SYS_rand
 448:	48e5                	li	a7,25
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 450:	48e9                	li	a7,26
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 458:	48ed                	li	a7,27
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 460:	48f1                	li	a7,28
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 468:	48f5                	li	a7,29
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 470:	48f9                	li	a7,30
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 478:	48fd                	li	a7,31
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 480:	1101                	addi	sp,sp,-32
 482:	ec06                	sd	ra,24(sp)
 484:	e822                	sd	s0,16(sp)
 486:	1000                	addi	s0,sp,32
 488:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48c:	4605                	li	a2,1
 48e:	fef40593          	addi	a1,s0,-17
 492:	f1fff0ef          	jal	3b0 <write>
}
 496:	60e2                	ld	ra,24(sp)
 498:	6442                	ld	s0,16(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret

000000000000049e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49e:	7139                	addi	sp,sp,-64
 4a0:	fc06                	sd	ra,56(sp)
 4a2:	f822                	sd	s0,48(sp)
 4a4:	f426                	sd	s1,40(sp)
 4a6:	0080                	addi	s0,sp,64
 4a8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4aa:	c299                	beqz	a3,4b0 <printint+0x12>
 4ac:	0805c963          	bltz	a1,53e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b0:	2581                	sext.w	a1,a1
  neg = 0;
 4b2:	4881                	li	a7,0
 4b4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4b8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ba:	2601                	sext.w	a2,a2
 4bc:	00000517          	auipc	a0,0x0
 4c0:	5a450513          	addi	a0,a0,1444 # a60 <digits>
 4c4:	883a                	mv	a6,a4
 4c6:	2705                	addiw	a4,a4,1
 4c8:	02c5f7bb          	remuw	a5,a1,a2
 4cc:	1782                	slli	a5,a5,0x20
 4ce:	9381                	srli	a5,a5,0x20
 4d0:	97aa                	add	a5,a5,a0
 4d2:	0007c783          	lbu	a5,0(a5)
 4d6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4da:	0005879b          	sext.w	a5,a1
 4de:	02c5d5bb          	divuw	a1,a1,a2
 4e2:	0685                	addi	a3,a3,1
 4e4:	fec7f0e3          	bgeu	a5,a2,4c4 <printint+0x26>
  if(neg)
 4e8:	00088c63          	beqz	a7,500 <printint+0x62>
    buf[i++] = '-';
 4ec:	fd070793          	addi	a5,a4,-48
 4f0:	00878733          	add	a4,a5,s0
 4f4:	02d00793          	li	a5,45
 4f8:	fef70823          	sb	a5,-16(a4)
 4fc:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 500:	02e05a63          	blez	a4,534 <printint+0x96>
 504:	f04a                	sd	s2,32(sp)
 506:	ec4e                	sd	s3,24(sp)
 508:	fc040793          	addi	a5,s0,-64
 50c:	00e78933          	add	s2,a5,a4
 510:	fff78993          	addi	s3,a5,-1
 514:	99ba                	add	s3,s3,a4
 516:	377d                	addiw	a4,a4,-1
 518:	1702                	slli	a4,a4,0x20
 51a:	9301                	srli	a4,a4,0x20
 51c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 520:	fff94583          	lbu	a1,-1(s2)
 524:	8526                	mv	a0,s1
 526:	f5bff0ef          	jal	480 <putc>
  while(--i >= 0)
 52a:	197d                	addi	s2,s2,-1
 52c:	ff391ae3          	bne	s2,s3,520 <printint+0x82>
 530:	7902                	ld	s2,32(sp)
 532:	69e2                	ld	s3,24(sp)
}
 534:	70e2                	ld	ra,56(sp)
 536:	7442                	ld	s0,48(sp)
 538:	74a2                	ld	s1,40(sp)
 53a:	6121                	addi	sp,sp,64
 53c:	8082                	ret
    x = -xx;
 53e:	40b005bb          	negw	a1,a1
    neg = 1;
 542:	4885                	li	a7,1
    x = -xx;
 544:	bf85                	j	4b4 <printint+0x16>

0000000000000546 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 546:	711d                	addi	sp,sp,-96
 548:	ec86                	sd	ra,88(sp)
 54a:	e8a2                	sd	s0,80(sp)
 54c:	e0ca                	sd	s2,64(sp)
 54e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 550:	0005c903          	lbu	s2,0(a1)
 554:	26090863          	beqz	s2,7c4 <vprintf+0x27e>
 558:	e4a6                	sd	s1,72(sp)
 55a:	fc4e                	sd	s3,56(sp)
 55c:	f852                	sd	s4,48(sp)
 55e:	f456                	sd	s5,40(sp)
 560:	f05a                	sd	s6,32(sp)
 562:	ec5e                	sd	s7,24(sp)
 564:	e862                	sd	s8,16(sp)
 566:	e466                	sd	s9,8(sp)
 568:	8b2a                	mv	s6,a0
 56a:	8a2e                	mv	s4,a1
 56c:	8bb2                	mv	s7,a2
  state = 0;
 56e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 570:	4481                	li	s1,0
 572:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 574:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 578:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 57c:	06c00c93          	li	s9,108
 580:	a005                	j	5a0 <vprintf+0x5a>
        putc(fd, c0);
 582:	85ca                	mv	a1,s2
 584:	855a                	mv	a0,s6
 586:	efbff0ef          	jal	480 <putc>
 58a:	a019                	j	590 <vprintf+0x4a>
    } else if(state == '%'){
 58c:	03598263          	beq	s3,s5,5b0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 590:	2485                	addiw	s1,s1,1
 592:	8726                	mv	a4,s1
 594:	009a07b3          	add	a5,s4,s1
 598:	0007c903          	lbu	s2,0(a5)
 59c:	20090c63          	beqz	s2,7b4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 5a0:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5a4:	fe0994e3          	bnez	s3,58c <vprintf+0x46>
      if(c0 == '%'){
 5a8:	fd579de3          	bne	a5,s5,582 <vprintf+0x3c>
        state = '%';
 5ac:	89be                	mv	s3,a5
 5ae:	b7cd                	j	590 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 5b0:	00ea06b3          	add	a3,s4,a4
 5b4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 5b8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 5ba:	c681                	beqz	a3,5c2 <vprintf+0x7c>
 5bc:	9752                	add	a4,a4,s4
 5be:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 5c2:	03878f63          	beq	a5,s8,600 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5c6:	05978963          	beq	a5,s9,618 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5ca:	07500713          	li	a4,117
 5ce:	0ee78363          	beq	a5,a4,6b4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5d2:	07800713          	li	a4,120
 5d6:	12e78563          	beq	a5,a4,700 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5da:	07000713          	li	a4,112
 5de:	14e78a63          	beq	a5,a4,732 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5e2:	07300713          	li	a4,115
 5e6:	18e78a63          	beq	a5,a4,77a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5ea:	02500713          	li	a4,37
 5ee:	04e79563          	bne	a5,a4,638 <vprintf+0xf2>
        putc(fd, '%');
 5f2:	02500593          	li	a1,37
 5f6:	855a                	mv	a0,s6
 5f8:	e89ff0ef          	jal	480 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bf49                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 600:	008b8913          	addi	s2,s7,8
 604:	4685                	li	a3,1
 606:	4629                	li	a2,10
 608:	000ba583          	lw	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	e91ff0ef          	jal	49e <printint>
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
 616:	bfad                	j	590 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 618:	06400793          	li	a5,100
 61c:	02f68963          	beq	a3,a5,64e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 620:	06c00793          	li	a5,108
 624:	04f68263          	beq	a3,a5,668 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 628:	07500793          	li	a5,117
 62c:	0af68063          	beq	a3,a5,6cc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 630:	07800793          	li	a5,120
 634:	0ef68263          	beq	a3,a5,718 <vprintf+0x1d2>
        putc(fd, '%');
 638:	02500593          	li	a1,37
 63c:	855a                	mv	a0,s6
 63e:	e43ff0ef          	jal	480 <putc>
        putc(fd, c0);
 642:	85ca                	mv	a1,s2
 644:	855a                	mv	a0,s6
 646:	e3bff0ef          	jal	480 <putc>
      state = 0;
 64a:	4981                	li	s3,0
 64c:	b791                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	008b8913          	addi	s2,s7,8
 652:	4685                	li	a3,1
 654:	4629                	li	a2,10
 656:	000ba583          	lw	a1,0(s7)
 65a:	855a                	mv	a0,s6
 65c:	e43ff0ef          	jal	49e <printint>
        i += 1;
 660:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 662:	8bca                	mv	s7,s2
      state = 0;
 664:	4981                	li	s3,0
        i += 1;
 666:	b72d                	j	590 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 668:	06400793          	li	a5,100
 66c:	02f60763          	beq	a2,a5,69a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 670:	07500793          	li	a5,117
 674:	06f60963          	beq	a2,a5,6e6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 678:	07800793          	li	a5,120
 67c:	faf61ee3          	bne	a2,a5,638 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 680:	008b8913          	addi	s2,s7,8
 684:	4681                	li	a3,0
 686:	4641                	li	a2,16
 688:	000ba583          	lw	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	e11ff0ef          	jal	49e <printint>
        i += 2;
 692:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	8bca                	mv	s7,s2
      state = 0;
 696:	4981                	li	s3,0
        i += 2;
 698:	bde5                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 69a:	008b8913          	addi	s2,s7,8
 69e:	4685                	li	a3,1
 6a0:	4629                	li	a2,10
 6a2:	000ba583          	lw	a1,0(s7)
 6a6:	855a                	mv	a0,s6
 6a8:	df7ff0ef          	jal	49e <printint>
        i += 2;
 6ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
        i += 2;
 6b2:	bdf9                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 6b4:	008b8913          	addi	s2,s7,8
 6b8:	4681                	li	a3,0
 6ba:	4629                	li	a2,10
 6bc:	000ba583          	lw	a1,0(s7)
 6c0:	855a                	mv	a0,s6
 6c2:	dddff0ef          	jal	49e <printint>
 6c6:	8bca                	mv	s7,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b5d9                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6cc:	008b8913          	addi	s2,s7,8
 6d0:	4681                	li	a3,0
 6d2:	4629                	li	a2,10
 6d4:	000ba583          	lw	a1,0(s7)
 6d8:	855a                	mv	a0,s6
 6da:	dc5ff0ef          	jal	49e <printint>
        i += 1;
 6de:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e0:	8bca                	mv	s7,s2
      state = 0;
 6e2:	4981                	li	s3,0
        i += 1;
 6e4:	b575                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6e6:	008b8913          	addi	s2,s7,8
 6ea:	4681                	li	a3,0
 6ec:	4629                	li	a2,10
 6ee:	000ba583          	lw	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	dabff0ef          	jal	49e <printint>
        i += 2;
 6f8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6fa:	8bca                	mv	s7,s2
      state = 0;
 6fc:	4981                	li	s3,0
        i += 2;
 6fe:	bd49                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 700:	008b8913          	addi	s2,s7,8
 704:	4681                	li	a3,0
 706:	4641                	li	a2,16
 708:	000ba583          	lw	a1,0(s7)
 70c:	855a                	mv	a0,s6
 70e:	d91ff0ef          	jal	49e <printint>
 712:	8bca                	mv	s7,s2
      state = 0;
 714:	4981                	li	s3,0
 716:	bdad                	j	590 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	008b8913          	addi	s2,s7,8
 71c:	4681                	li	a3,0
 71e:	4641                	li	a2,16
 720:	000ba583          	lw	a1,0(s7)
 724:	855a                	mv	a0,s6
 726:	d79ff0ef          	jal	49e <printint>
        i += 1;
 72a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 72c:	8bca                	mv	s7,s2
      state = 0;
 72e:	4981                	li	s3,0
        i += 1;
 730:	b585                	j	590 <vprintf+0x4a>
 732:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 734:	008b8d13          	addi	s10,s7,8
 738:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 73c:	03000593          	li	a1,48
 740:	855a                	mv	a0,s6
 742:	d3fff0ef          	jal	480 <putc>
  putc(fd, 'x');
 746:	07800593          	li	a1,120
 74a:	855a                	mv	a0,s6
 74c:	d35ff0ef          	jal	480 <putc>
 750:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 752:	00000b97          	auipc	s7,0x0
 756:	30eb8b93          	addi	s7,s7,782 # a60 <digits>
 75a:	03c9d793          	srli	a5,s3,0x3c
 75e:	97de                	add	a5,a5,s7
 760:	0007c583          	lbu	a1,0(a5)
 764:	855a                	mv	a0,s6
 766:	d1bff0ef          	jal	480 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 76a:	0992                	slli	s3,s3,0x4
 76c:	397d                	addiw	s2,s2,-1
 76e:	fe0916e3          	bnez	s2,75a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 772:	8bea                	mv	s7,s10
      state = 0;
 774:	4981                	li	s3,0
 776:	6d02                	ld	s10,0(sp)
 778:	bd21                	j	590 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 77a:	008b8993          	addi	s3,s7,8
 77e:	000bb903          	ld	s2,0(s7)
 782:	00090f63          	beqz	s2,7a0 <vprintf+0x25a>
        for(; *s; s++)
 786:	00094583          	lbu	a1,0(s2)
 78a:	c195                	beqz	a1,7ae <vprintf+0x268>
          putc(fd, *s);
 78c:	855a                	mv	a0,s6
 78e:	cf3ff0ef          	jal	480 <putc>
        for(; *s; s++)
 792:	0905                	addi	s2,s2,1
 794:	00094583          	lbu	a1,0(s2)
 798:	f9f5                	bnez	a1,78c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 79a:	8bce                	mv	s7,s3
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bbcd                	j	590 <vprintf+0x4a>
          s = "(null)";
 7a0:	00000917          	auipc	s2,0x0
 7a4:	2b890913          	addi	s2,s2,696 # a58 <malloc+0x1ac>
        for(; *s; s++)
 7a8:	02800593          	li	a1,40
 7ac:	b7c5                	j	78c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 7ae:	8bce                	mv	s7,s3
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bbf9                	j	590 <vprintf+0x4a>
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	79e2                	ld	s3,56(sp)
 7b8:	7a42                	ld	s4,48(sp)
 7ba:	7aa2                	ld	s5,40(sp)
 7bc:	7b02                	ld	s6,32(sp)
 7be:	6be2                	ld	s7,24(sp)
 7c0:	6c42                	ld	s8,16(sp)
 7c2:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7c4:	60e6                	ld	ra,88(sp)
 7c6:	6446                	ld	s0,80(sp)
 7c8:	6906                	ld	s2,64(sp)
 7ca:	6125                	addi	sp,sp,96
 7cc:	8082                	ret

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	addi	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ea:	8622                	mv	a2,s0
 7ec:	d5bff0ef          	jal	546 <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6161                	addi	sp,sp,80
 7f6:	8082                	ret

00000000000007f8 <printf>:

void
printf(const char *fmt, ...)
{
 7f8:	711d                	addi	sp,sp,-96
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e40c                	sd	a1,8(s0)
 802:	e810                	sd	a2,16(s0)
 804:	ec14                	sd	a3,24(s0)
 806:	f018                	sd	a4,32(s0)
 808:	f41c                	sd	a5,40(s0)
 80a:	03043823          	sd	a6,48(s0)
 80e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	00840613          	addi	a2,s0,8
 816:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81a:	85aa                	mv	a1,a0
 81c:	4505                	li	a0,1
 81e:	d29ff0ef          	jal	546 <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82a:	1141                	addi	sp,sp,-16
 82c:	e422                	sd	s0,8(sp)
 82e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 830:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	00000797          	auipc	a5,0x0
 838:	7cc7b783          	ld	a5,1996(a5) # 1000 <freep>
 83c:	a02d                	j	866 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 83e:	4618                	lw	a4,8(a2)
 840:	9f2d                	addw	a4,a4,a1
 842:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	6398                	ld	a4,0(a5)
 848:	6310                	ld	a2,0(a4)
 84a:	a83d                	j	888 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 84c:	ff852703          	lw	a4,-8(a0)
 850:	9f31                	addw	a4,a4,a2
 852:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 854:	ff053683          	ld	a3,-16(a0)
 858:	a091                	j	89c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	6398                	ld	a4,0(a5)
 85c:	00e7e463          	bltu	a5,a4,864 <free+0x3a>
 860:	00e6ea63          	bltu	a3,a4,874 <free+0x4a>
{
 864:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	fed7fae3          	bgeu	a5,a3,85a <free+0x30>
 86a:	6398                	ld	a4,0(a5)
 86c:	00e6e463          	bltu	a3,a4,874 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	fee7eae3          	bltu	a5,a4,864 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 874:	ff852583          	lw	a1,-8(a0)
 878:	6390                	ld	a2,0(a5)
 87a:	02059813          	slli	a6,a1,0x20
 87e:	01c85713          	srli	a4,a6,0x1c
 882:	9736                	add	a4,a4,a3
 884:	fae60de3          	beq	a2,a4,83e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 88c:	4790                	lw	a2,8(a5)
 88e:	02061593          	slli	a1,a2,0x20
 892:	01c5d713          	srli	a4,a1,0x1c
 896:	973e                	add	a4,a4,a5
 898:	fae68ae3          	beq	a3,a4,84c <free+0x22>
    p->s.ptr = bp->s.ptr;
 89c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
}
 8a6:	6422                	ld	s0,8(sp)
 8a8:	0141                	addi	sp,sp,16
 8aa:	8082                	ret

00000000000008ac <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ac:	7139                	addi	sp,sp,-64
 8ae:	fc06                	sd	ra,56(sp)
 8b0:	f822                	sd	s0,48(sp)
 8b2:	f426                	sd	s1,40(sp)
 8b4:	ec4e                	sd	s3,24(sp)
 8b6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b8:	02051493          	slli	s1,a0,0x20
 8bc:	9081                	srli	s1,s1,0x20
 8be:	04bd                	addi	s1,s1,15
 8c0:	8091                	srli	s1,s1,0x4
 8c2:	0014899b          	addiw	s3,s1,1
 8c6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8c8:	00000517          	auipc	a0,0x0
 8cc:	73853503          	ld	a0,1848(a0) # 1000 <freep>
 8d0:	c915                	beqz	a0,904 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d4:	4798                	lw	a4,8(a5)
 8d6:	08977a63          	bgeu	a4,s1,96a <malloc+0xbe>
 8da:	f04a                	sd	s2,32(sp)
 8dc:	e852                	sd	s4,16(sp)
 8de:	e456                	sd	s5,8(sp)
 8e0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e2:	8a4e                	mv	s4,s3
 8e4:	0009871b          	sext.w	a4,s3
 8e8:	6685                	lui	a3,0x1
 8ea:	00d77363          	bgeu	a4,a3,8f0 <malloc+0x44>
 8ee:	6a05                	lui	s4,0x1
 8f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8f8:	00000917          	auipc	s2,0x0
 8fc:	70890913          	addi	s2,s2,1800 # 1000 <freep>
  if(p == (char*)-1)
 900:	5afd                	li	s5,-1
 902:	a081                	j	942 <malloc+0x96>
 904:	f04a                	sd	s2,32(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90c:	00000797          	auipc	a5,0x0
 910:	70478793          	addi	a5,a5,1796 # 1010 <base>
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
 91c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 922:	b7c1                	j	8e2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	e118                	sd	a4,0(a0)
 928:	a8a9                	j	982 <malloc+0xd6>
  hp->s.size = nu;
 92a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 92e:	0541                	addi	a0,a0,16
 930:	efbff0ef          	jal	82a <free>
  return freep;
 934:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 938:	c12d                	beqz	a0,99a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	02977263          	bgeu	a4,s1,962 <malloc+0xb6>
    if(p == freep)
 942:	00093703          	ld	a4,0(s2)
 946:	853e                	mv	a0,a5
 948:	fef719e3          	bne	a4,a5,93a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 94c:	8552                	mv	a0,s4
 94e:	acbff0ef          	jal	418 <sbrk>
  if(p == (char*)-1)
 952:	fd551ce3          	bne	a0,s5,92a <malloc+0x7e>
        return 0;
 956:	4501                	li	a0,0
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
 960:	a03d                	j	98e <malloc+0xe2>
 962:	7902                	ld	s2,32(sp)
 964:	6a42                	ld	s4,16(sp)
 966:	6aa2                	ld	s5,8(sp)
 968:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 96a:	fae48de3          	beq	s1,a4,924 <malloc+0x78>
        p->s.size -= nunits;
 96e:	4137073b          	subw	a4,a4,s3
 972:	c798                	sw	a4,8(a5)
        p += p->s.size;
 974:	02071693          	slli	a3,a4,0x20
 978:	01c6d713          	srli	a4,a3,0x1c
 97c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 982:	00000717          	auipc	a4,0x0
 986:	66a73f23          	sd	a0,1662(a4) # 1000 <freep>
      return (void*)(p + 1);
 98a:	01078513          	addi	a0,a5,16
  }
}
 98e:	70e2                	ld	ra,56(sp)
 990:	7442                	ld	s0,48(sp)
 992:	74a2                	ld	s1,40(sp)
 994:	69e2                	ld	s3,24(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
 99a:	7902                	ld	s2,32(sp)
 99c:	6a42                	ld	s4,16(sp)
 99e:	6aa2                	ld	s5,8(sp)
 9a0:	6b02                	ld	s6,0(sp)
 9a2:	b7f5                	j	98e <malloc+0xe2>
