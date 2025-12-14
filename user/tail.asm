
user/_tail:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

#define MAX_LINES 1000
#define LINE_LENGTH 256

int main(int argc, char *argv[]) {
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	e466                	sd	s9,8(sp)
  18:	e06a                	sd	s10,0(sp)
  1a:	1080                	addi	s0,sp,96
  1c:	fffc12b7          	lui	t0,0xfffc1
  20:	5f028293          	addi	t0,t0,1520 # fffffffffffc15f0 <base+0xfffffffffffc05e0>
  24:	9116                	add	sp,sp,t0
    int current_pos = 0;
    int num_lines = 10; // default
    char *filename = 0;

    // Parse arguments
    for (i = 1; i < argc; i++) {
  26:	4785                	li	a5,1
  28:	12a7d163          	bge	a5,a0,14a <main+0x14a>
  2c:	8b2a                	mv	s6,a0
  2e:	8bae                	mv	s7,a1
    char *filename = 0;
  30:	4a01                	li	s4,0
    int num_lines = 10; // default
  32:	49a9                	li	s3,10
    for (i = 1; i < argc; i++) {
  34:	4485                	li	s1,1
        if (strcmp(argv[i], "-n") == 0) {
  36:	00001c17          	auipc	s8,0x1
  3a:	a9ac0c13          	addi	s8,s8,-1382 # ad0 <malloc+0xfe>
            }
            if (num_lines > MAX_LINES) {
                fprintf(2, "tail: too many lines requested (max %d)\n", MAX_LINES);
                exit(1);
            }
        } else if (strcmp(argv[i], "?") == 0) {
  3e:	00001c97          	auipc	s9,0x1
  42:	b12c8c93          	addi	s9,s9,-1262 # b50 <malloc+0x17e>
            if (num_lines > MAX_LINES) {
  46:	3e800d13          	li	s10,1000
  4a:	a835                	j	86 <main+0x86>
                fprintf(2, "tail: -n requires a number\n");
  4c:	00001597          	auipc	a1,0x1
  50:	a8c58593          	addi	a1,a1,-1396 # ad8 <malloc+0x106>
  54:	4509                	li	a0,2
  56:	09f000ef          	jal	8f4 <fprintf>
                exit(1);
  5a:	4505                	li	a0,1
  5c:	45a000ef          	jal	4b6 <exit>
                fprintf(2, "tail: line count must be positive\n");
  60:	00001597          	auipc	a1,0x1
  64:	a9858593          	addi	a1,a1,-1384 # af8 <malloc+0x126>
  68:	4509                	li	a0,2
  6a:	08b000ef          	jal	8f4 <fprintf>
                exit(1);
  6e:	4505                	li	a0,1
  70:	446000ef          	jal	4b6 <exit>
        } else if (strcmp(argv[i], "?") == 0) {
  74:	85e6                	mv	a1,s9
  76:	8556                	mv	a0,s5
  78:	202000ef          	jal	27a <strcmp>
  7c:	c929                	beqz	a0,ce <main+0xce>
            printf("Usage: tail [-n lines] [filename]\n");
            printf("Display last N lines of file (default 10)\n");
            exit(0);
        } else {
            filename = argv[i];
  7e:	8a56                	mv	s4,s5
    for (i = 1; i < argc; i++) {
  80:	2485                	addiw	s1,s1,1
  82:	0764d563          	bge	s1,s6,ec <main+0xec>
        if (strcmp(argv[i], "-n") == 0) {
  86:	00349913          	slli	s2,s1,0x3
  8a:	012b87b3          	add	a5,s7,s2
  8e:	0007ba83          	ld	s5,0(a5)
  92:	85e2                	mv	a1,s8
  94:	8556                	mv	a0,s5
  96:	1e4000ef          	jal	27a <strcmp>
  9a:	fd69                	bnez	a0,74 <main+0x74>
            if (i + 1 >= argc) {
  9c:	2485                	addiw	s1,s1,1
  9e:	fb64d7e3          	bge	s1,s6,4c <main+0x4c>
            num_lines = atoi(argv[++i]);
  a2:	995e                	add	s2,s2,s7
  a4:	00893503          	ld	a0,8(s2)
  a8:	318000ef          	jal	3c0 <atoi>
  ac:	89aa                	mv	s3,a0
            if (num_lines <= 0) {
  ae:	faa059e3          	blez	a0,60 <main+0x60>
            if (num_lines > MAX_LINES) {
  b2:	fcad57e3          	bge	s10,a0,80 <main+0x80>
                fprintf(2, "tail: too many lines requested (max %d)\n", MAX_LINES);
  b6:	3e800613          	li	a2,1000
  ba:	00001597          	auipc	a1,0x1
  be:	a6658593          	addi	a1,a1,-1434 # b20 <malloc+0x14e>
  c2:	4509                	li	a0,2
  c4:	031000ef          	jal	8f4 <fprintf>
                exit(1);
  c8:	4505                	li	a0,1
  ca:	3ec000ef          	jal	4b6 <exit>
            printf("Usage: tail [-n lines] [filename]\n");
  ce:	00001517          	auipc	a0,0x1
  d2:	a8a50513          	addi	a0,a0,-1398 # b58 <malloc+0x186>
  d6:	049000ef          	jal	91e <printf>
            printf("Display last N lines of file (default 10)\n");
  da:	00001517          	auipc	a0,0x1
  de:	aa650513          	addi	a0,a0,-1370 # b80 <malloc+0x1ae>
  e2:	03d000ef          	jal	91e <printf>
            exit(0);
  e6:	4501                	li	a0,0
  e8:	3ce000ef          	jal	4b6 <exit>
        }
    }

    // Open file or use stdin
    if (filename) {
  ec:	060a0363          	beqz	s4,152 <main+0x152>
        if ((fd = open(filename, O_RDONLY)) < 0) {
  f0:	4581                	li	a1,0
  f2:	8552                	mv	a0,s4
  f4:	402000ef          	jal	4f6 <open>
  f8:	8baa                	mv	s7,a0
  fa:	04055d63          	bgez	a0,154 <main+0x154>
            fprintf(2, "tail: cannot open %s\n", filename);
  fe:	8652                	mv	a2,s4
 100:	00001597          	auipc	a1,0x1
 104:	ab058593          	addi	a1,a1,-1360 # bb0 <malloc+0x1de>
 108:	4509                	li	a0,2
 10a:	7ea000ef          	jal	8f4 <fprintf>
            exit(1);
 10e:	4505                	li	a0,1
 110:	3a6000ef          	jal	4b6 <exit>

    // Read file and store lines in circular buffer
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
        for (i = 0; i < n; i++) {
            if (buf[i] == '\n') {
                lines[line_count % MAX_LINES][current_pos] = '\0';
 114:	0354e73b          	remw	a4,s1,s5
 118:	0722                	slli	a4,a4,0x8
 11a:	974a                	add	a4,a4,s2
 11c:	9762                	add	a4,a4,s8
 11e:	60070023          	sb	zero,1536(a4)
                line_count++;
 122:	2485                	addiw	s1,s1,1
                current_pos = 0;
 124:	8c2e                	mv	s8,a1
        for (i = 0; i < n; i++) {
 126:	0785                	addi	a5,a5,1
 128:	04a78263          	beq	a5,a0,16c <main+0x16c>
            if (buf[i] == '\n') {
 12c:	0007c683          	lbu	a3,0(a5)
 130:	fec682e3          	beq	a3,a2,114 <main+0x114>
            } else if (current_pos < LINE_LENGTH - 1) {
 134:	ff8b49e3          	blt	s6,s8,126 <main+0x126>
                lines[line_count % MAX_LINES][current_pos++] = buf[i];
 138:	0354e73b          	remw	a4,s1,s5
 13c:	0722                	slli	a4,a4,0x8
 13e:	974a                	add	a4,a4,s2
 140:	9762                	add	a4,a4,s8
 142:	60d70023          	sb	a3,1536(a4)
 146:	2c05                	addiw	s8,s8,1
 148:	bff9                	j	126 <main+0x126>
    char *filename = 0;
 14a:	4a01                	li	s4,0
    int num_lines = 10; // default
 14c:	49a9                	li	s3,10
        fd = 0; // stdin
 14e:	4b81                	li	s7,0
 150:	a011                	j	154 <main+0x154>
 152:	4b81                	li	s7,0
 154:	4c01                	li	s8,0
 156:	4481                	li	s1,0
            } else if (current_pos < LINE_LENGTH - 1) {
 158:	0fe00b13          	li	s6,254
                lines[line_count % MAX_LINES][current_pos++] = buf[i];
 15c:	fffc1937          	lui	s2,0xfffc1
 160:	fa090793          	addi	a5,s2,-96 # fffffffffffc0fa0 <base+0xfffffffffffbff90>
 164:	00878933          	add	s2,a5,s0
 168:	3e800a93          	li	s5,1000
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
 16c:	20000613          	li	a2,512
 170:	da040593          	addi	a1,s0,-608
 174:	855e                	mv	a0,s7
 176:	358000ef          	jal	4ce <read>
 17a:	00a05863          	blez	a0,18a <main+0x18a>
 17e:	da040793          	addi	a5,s0,-608
 182:	953e                	add	a0,a0,a5
            if (buf[i] == '\n') {
 184:	4629                	li	a2,10
                current_pos = 0;
 186:	4581                	li	a1,0
 188:	b755                	j	12c <main+0x12c>
            }
        }
    }

    if (n < 0) {
 18a:	0a054563          	bltz	a0,234 <main+0x234>
        fprintf(2, "tail: read error\n");
        exit(1);
    }

    // Handle case where file doesn't end with newline
    if (current_pos > 0) {
 18e:	03805863          	blez	s8,1be <main+0x1be>
        lines[line_count % MAX_LINES][current_pos] = '\0';
 192:	fffc1737          	lui	a4,0xfffc1
 196:	3e800793          	li	a5,1000
 19a:	02f4e7bb          	remw	a5,s1,a5
 19e:	07a2                	slli	a5,a5,0x8
 1a0:	fa070713          	addi	a4,a4,-96 # fffffffffffc0fa0 <base+0xfffffffffffbff90>
 1a4:	9722                	add	a4,a4,s0
 1a6:	fffc1637          	lui	a2,0xfffc1
 1aa:	59860693          	addi	a3,a2,1432 # fffffffffffc1598 <base+0xfffffffffffc0588>
 1ae:	96a2                	add	a3,a3,s0
 1b0:	e298                	sd	a4,0(a3)
 1b2:	6298                	ld	a4,0(a3)
 1b4:	97ba                	add	a5,a5,a4
 1b6:	97e2                	add	a5,a5,s8
 1b8:	60078023          	sb	zero,1536(a5)
        line_count++;
 1bc:	2485                	addiw	s1,s1,1
    }

    // Determine start line for output
    int start_line = (line_count > num_lines) ? (line_count - num_lines) : 0;
 1be:	4901                	li	s2,0
 1c0:	0099d963          	bge	s3,s1,1d2 <main+0x1d2>
 1c4:	4134893b          	subw	s2,s1,s3
    if (start_line < 0) start_line = 0;
 1c8:	02091793          	slli	a5,s2,0x20
 1cc:	0607ce63          	bltz	a5,248 <main+0x248>
 1d0:	2901                	sext.w	s2,s2

    // Print the last N lines
    for (i = start_line; i < line_count && i < start_line + num_lines; i++) {
 1d2:	04995963          	bge	s2,s1,224 <main+0x224>
 1d6:	013909bb          	addw	s3,s2,s3
 1da:	05395563          	bge	s2,s3,224 <main+0x224>
        printf("%s\n", lines[i % MAX_LINES]);
 1de:	fffc17b7          	lui	a5,0xfffc1
 1e2:	5a078793          	addi	a5,a5,1440 # fffffffffffc15a0 <base+0xfffffffffffc0590>
 1e6:	97a2                	add	a5,a5,s0
 1e8:	fffc1737          	lui	a4,0xfffc1
 1ec:	59870713          	addi	a4,a4,1432 # fffffffffffc1598 <base+0xfffffffffffc0588>
 1f0:	9722                	add	a4,a4,s0
 1f2:	e31c                	sd	a5,0(a4)
 1f4:	3e800b13          	li	s6,1000
 1f8:	00001a97          	auipc	s5,0x1
 1fc:	9e8a8a93          	addi	s5,s5,-1560 # be0 <malloc+0x20e>
 200:	036965bb          	remw	a1,s2,s6
 204:	05a2                	slli	a1,a1,0x8
 206:	fffc17b7          	lui	a5,0xfffc1
 20a:	59878793          	addi	a5,a5,1432 # fffffffffffc1598 <base+0xfffffffffffc0588>
 20e:	97a2                	add	a5,a5,s0
 210:	639c                	ld	a5,0(a5)
 212:	95be                	add	a1,a1,a5
 214:	8556                	mv	a0,s5
 216:	708000ef          	jal	91e <printf>
    for (i = start_line; i < line_count && i < start_line + num_lines; i++) {
 21a:	2905                	addiw	s2,s2,1
 21c:	01248463          	beq	s1,s2,224 <main+0x224>
 220:	ff3910e3          	bne	s2,s3,200 <main+0x200>
    }

    if (filename) close(fd);
 224:	000a0563          	beqz	s4,22e <main+0x22e>
 228:	855e                	mv	a0,s7
 22a:	2b4000ef          	jal	4de <close>
    exit(0);
 22e:	4501                	li	a0,0
 230:	286000ef          	jal	4b6 <exit>
        fprintf(2, "tail: read error\n");
 234:	00001597          	auipc	a1,0x1
 238:	99458593          	addi	a1,a1,-1644 # bc8 <malloc+0x1f6>
 23c:	4509                	li	a0,2
 23e:	6b6000ef          	jal	8f4 <fprintf>
        exit(1);
 242:	4505                	li	a0,1
 244:	272000ef          	jal	4b6 <exit>
    if (start_line < 0) start_line = 0;
 248:	4901                	li	s2,0
 24a:	b759                	j	1d0 <main+0x1d0>

000000000000024c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  extern int main();
  main();
 254:	dadff0ef          	jal	0 <main>
  exit(0);
 258:	4501                	li	a0,0
 25a:	25c000ef          	jal	4b6 <exit>

000000000000025e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 264:	87aa                	mv	a5,a0
 266:	0585                	addi	a1,a1,1
 268:	0785                	addi	a5,a5,1
 26a:	fff5c703          	lbu	a4,-1(a1)
 26e:	fee78fa3          	sb	a4,-1(a5)
 272:	fb75                	bnez	a4,266 <strcpy+0x8>
    ;
  return os;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 280:	00054783          	lbu	a5,0(a0)
 284:	cb91                	beqz	a5,298 <strcmp+0x1e>
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00f71763          	bne	a4,a5,298 <strcmp+0x1e>
    p++, q++;
 28e:	0505                	addi	a0,a0,1
 290:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	fbe5                	bnez	a5,286 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 298:	0005c503          	lbu	a0,0(a1)
}
 29c:	40a7853b          	subw	a0,a5,a0
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <strlen>:

uint
strlen(const char *s)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	cf91                	beqz	a5,2cc <strlen+0x26>
 2b2:	0505                	addi	a0,a0,1
 2b4:	87aa                	mv	a5,a0
 2b6:	86be                	mv	a3,a5
 2b8:	0785                	addi	a5,a5,1
 2ba:	fff7c703          	lbu	a4,-1(a5)
 2be:	ff65                	bnez	a4,2b6 <strlen+0x10>
 2c0:	40a6853b          	subw	a0,a3,a0
 2c4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  for(n = 0; s[n]; n++)
 2cc:	4501                	li	a0,0
 2ce:	bfe5                	j	2c6 <strlen+0x20>

00000000000002d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d6:	ca19                	beqz	a2,2ec <memset+0x1c>
 2d8:	87aa                	mv	a5,a0
 2da:	1602                	slli	a2,a2,0x20
 2dc:	9201                	srli	a2,a2,0x20
 2de:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2e6:	0785                	addi	a5,a5,1
 2e8:	fee79de3          	bne	a5,a4,2e2 <memset+0x12>
  }
  return dst;
}
 2ec:	6422                	ld	s0,8(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strchr>:

char*
strchr(const char *s, char c)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e422                	sd	s0,8(sp)
 2f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	cb99                	beqz	a5,312 <strchr+0x20>
    if(*s == c)
 2fe:	00f58763          	beq	a1,a5,30c <strchr+0x1a>
  for(; *s; s++)
 302:	0505                	addi	a0,a0,1
 304:	00054783          	lbu	a5,0(a0)
 308:	fbfd                	bnez	a5,2fe <strchr+0xc>
      return (char*)s;
  return 0;
 30a:	4501                	li	a0,0
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	addi	sp,sp,16
 310:	8082                	ret
  return 0;
 312:	4501                	li	a0,0
 314:	bfe5                	j	30c <strchr+0x1a>

0000000000000316 <gets>:

char*
gets(char *buf, int max)
{
 316:	711d                	addi	sp,sp,-96
 318:	ec86                	sd	ra,88(sp)
 31a:	e8a2                	sd	s0,80(sp)
 31c:	e4a6                	sd	s1,72(sp)
 31e:	e0ca                	sd	s2,64(sp)
 320:	fc4e                	sd	s3,56(sp)
 322:	f852                	sd	s4,48(sp)
 324:	f456                	sd	s5,40(sp)
 326:	f05a                	sd	s6,32(sp)
 328:	ec5e                	sd	s7,24(sp)
 32a:	1080                	addi	s0,sp,96
 32c:	8baa                	mv	s7,a0
 32e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 330:	892a                	mv	s2,a0
 332:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 334:	4aa9                	li	s5,10
 336:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 338:	89a6                	mv	s3,s1
 33a:	2485                	addiw	s1,s1,1
 33c:	0344d663          	bge	s1,s4,368 <gets+0x52>
    cc = read(0, &c, 1);
 340:	4605                	li	a2,1
 342:	faf40593          	addi	a1,s0,-81
 346:	4501                	li	a0,0
 348:	186000ef          	jal	4ce <read>
    if(cc < 1)
 34c:	00a05e63          	blez	a0,368 <gets+0x52>
    buf[i++] = c;
 350:	faf44783          	lbu	a5,-81(s0)
 354:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 358:	01578763          	beq	a5,s5,366 <gets+0x50>
 35c:	0905                	addi	s2,s2,1
 35e:	fd679de3          	bne	a5,s6,338 <gets+0x22>
    buf[i++] = c;
 362:	89a6                	mv	s3,s1
 364:	a011                	j	368 <gets+0x52>
 366:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 368:	99de                	add	s3,s3,s7
 36a:	00098023          	sb	zero,0(s3)
  return buf;
}
 36e:	855e                	mv	a0,s7
 370:	60e6                	ld	ra,88(sp)
 372:	6446                	ld	s0,80(sp)
 374:	64a6                	ld	s1,72(sp)
 376:	6906                	ld	s2,64(sp)
 378:	79e2                	ld	s3,56(sp)
 37a:	7a42                	ld	s4,48(sp)
 37c:	7aa2                	ld	s5,40(sp)
 37e:	7b02                	ld	s6,32(sp)
 380:	6be2                	ld	s7,24(sp)
 382:	6125                	addi	sp,sp,96
 384:	8082                	ret

0000000000000386 <stat>:

int
stat(const char *n, struct stat *st)
{
 386:	1101                	addi	sp,sp,-32
 388:	ec06                	sd	ra,24(sp)
 38a:	e822                	sd	s0,16(sp)
 38c:	e04a                	sd	s2,0(sp)
 38e:	1000                	addi	s0,sp,32
 390:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 392:	4581                	li	a1,0
 394:	162000ef          	jal	4f6 <open>
  if(fd < 0)
 398:	02054263          	bltz	a0,3bc <stat+0x36>
 39c:	e426                	sd	s1,8(sp)
 39e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3a0:	85ca                	mv	a1,s2
 3a2:	16c000ef          	jal	50e <fstat>
 3a6:	892a                	mv	s2,a0
  close(fd);
 3a8:	8526                	mv	a0,s1
 3aa:	134000ef          	jal	4de <close>
  return r;
 3ae:	64a2                	ld	s1,8(sp)
}
 3b0:	854a                	mv	a0,s2
 3b2:	60e2                	ld	ra,24(sp)
 3b4:	6442                	ld	s0,16(sp)
 3b6:	6902                	ld	s2,0(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret
    return -1;
 3bc:	597d                	li	s2,-1
 3be:	bfcd                	j	3b0 <stat+0x2a>

00000000000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3c6:	00054683          	lbu	a3,0(a0)
 3ca:	fd06879b          	addiw	a5,a3,-48
 3ce:	0ff7f793          	zext.b	a5,a5
 3d2:	4625                	li	a2,9
 3d4:	02f66863          	bltu	a2,a5,404 <atoi+0x44>
 3d8:	872a                	mv	a4,a0
  n = 0;
 3da:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3dc:	0705                	addi	a4,a4,1
 3de:	0025179b          	slliw	a5,a0,0x2
 3e2:	9fa9                	addw	a5,a5,a0
 3e4:	0017979b          	slliw	a5,a5,0x1
 3e8:	9fb5                	addw	a5,a5,a3
 3ea:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3ee:	00074683          	lbu	a3,0(a4)
 3f2:	fd06879b          	addiw	a5,a3,-48
 3f6:	0ff7f793          	zext.b	a5,a5
 3fa:	fef671e3          	bgeu	a2,a5,3dc <atoi+0x1c>
  return n;
}
 3fe:	6422                	ld	s0,8(sp)
 400:	0141                	addi	sp,sp,16
 402:	8082                	ret
  n = 0;
 404:	4501                	li	a0,0
 406:	bfe5                	j	3fe <atoi+0x3e>

0000000000000408 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 408:	1141                	addi	sp,sp,-16
 40a:	e422                	sd	s0,8(sp)
 40c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 40e:	02b57463          	bgeu	a0,a1,436 <memmove+0x2e>
    while(n-- > 0)
 412:	00c05f63          	blez	a2,430 <memmove+0x28>
 416:	1602                	slli	a2,a2,0x20
 418:	9201                	srli	a2,a2,0x20
 41a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 41e:	872a                	mv	a4,a0
      *dst++ = *src++;
 420:	0585                	addi	a1,a1,1
 422:	0705                	addi	a4,a4,1
 424:	fff5c683          	lbu	a3,-1(a1)
 428:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 42c:	fef71ae3          	bne	a4,a5,420 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 430:	6422                	ld	s0,8(sp)
 432:	0141                	addi	sp,sp,16
 434:	8082                	ret
    dst += n;
 436:	00c50733          	add	a4,a0,a2
    src += n;
 43a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 43c:	fec05ae3          	blez	a2,430 <memmove+0x28>
 440:	fff6079b          	addiw	a5,a2,-1
 444:	1782                	slli	a5,a5,0x20
 446:	9381                	srli	a5,a5,0x20
 448:	fff7c793          	not	a5,a5
 44c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 44e:	15fd                	addi	a1,a1,-1
 450:	177d                	addi	a4,a4,-1
 452:	0005c683          	lbu	a3,0(a1)
 456:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x46>
 45e:	bfc9                	j	430 <memmove+0x28>

0000000000000460 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 460:	1141                	addi	sp,sp,-16
 462:	e422                	sd	s0,8(sp)
 464:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 466:	ca05                	beqz	a2,496 <memcmp+0x36>
 468:	fff6069b          	addiw	a3,a2,-1
 46c:	1682                	slli	a3,a3,0x20
 46e:	9281                	srli	a3,a3,0x20
 470:	0685                	addi	a3,a3,1
 472:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 474:	00054783          	lbu	a5,0(a0)
 478:	0005c703          	lbu	a4,0(a1)
 47c:	00e79863          	bne	a5,a4,48c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 480:	0505                	addi	a0,a0,1
    p2++;
 482:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 484:	fed518e3          	bne	a0,a3,474 <memcmp+0x14>
  }
  return 0;
 488:	4501                	li	a0,0
 48a:	a019                	j	490 <memcmp+0x30>
      return *p1 - *p2;
 48c:	40e7853b          	subw	a0,a5,a4
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret
  return 0;
 496:	4501                	li	a0,0
 498:	bfe5                	j	490 <memcmp+0x30>

000000000000049a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4a2:	f67ff0ef          	jal	408 <memmove>
}
 4a6:	60a2                	ld	ra,8(sp)
 4a8:	6402                	ld	s0,0(sp)
 4aa:	0141                	addi	sp,sp,16
 4ac:	8082                	ret

00000000000004ae <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ae:	4885                	li	a7,1
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4b6:	4889                	li	a7,2
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <wait>:
.global wait
wait:
 li a7, SYS_wait
 4be:	488d                	li	a7,3
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4c6:	4891                	li	a7,4
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <read>:
.global read
read:
 li a7, SYS_read
 4ce:	4895                	li	a7,5
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <write>:
.global write
write:
 li a7, SYS_write
 4d6:	48c1                	li	a7,16
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <close>:
.global close
close:
 li a7, SYS_close
 4de:	48d5                	li	a7,21
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4e6:	4899                	li	a7,6
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ee:	489d                	li	a7,7
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <open>:
.global open
open:
 li a7, SYS_open
 4f6:	48bd                	li	a7,15
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4fe:	48c5                	li	a7,17
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 506:	48c9                	li	a7,18
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 50e:	48a1                	li	a7,8
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <link>:
.global link
link:
 li a7, SYS_link
 516:	48cd                	li	a7,19
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 51e:	48d1                	li	a7,20
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 526:	48a5                	li	a7,9
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <dup>:
.global dup
dup:
 li a7, SYS_dup
 52e:	48a9                	li	a7,10
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 536:	48ad                	li	a7,11
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 53e:	48b1                	li	a7,12
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 546:	48b5                	li	a7,13
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 54e:	48b9                	li	a7,14
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 556:	48d9                	li	a7,22
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 55e:	48dd                	li	a7,23
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 566:	48e1                	li	a7,24
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <rand>:
.global rand
rand:
 li a7, SYS_rand
 56e:	48e5                	li	a7,25
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 576:	48e9                	li	a7,26
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 57e:	48ed                	li	a7,27
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 586:	48f1                	li	a7,28
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 58e:	48f5                	li	a7,29
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 596:	48f9                	li	a7,30
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 59e:	48fd                	li	a7,31
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5a6:	1101                	addi	sp,sp,-32
 5a8:	ec06                	sd	ra,24(sp)
 5aa:	e822                	sd	s0,16(sp)
 5ac:	1000                	addi	s0,sp,32
 5ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b2:	4605                	li	a2,1
 5b4:	fef40593          	addi	a1,s0,-17
 5b8:	f1fff0ef          	jal	4d6 <write>
}
 5bc:	60e2                	ld	ra,24(sp)
 5be:	6442                	ld	s0,16(sp)
 5c0:	6105                	addi	sp,sp,32
 5c2:	8082                	ret

00000000000005c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c4:	7139                	addi	sp,sp,-64
 5c6:	fc06                	sd	ra,56(sp)
 5c8:	f822                	sd	s0,48(sp)
 5ca:	f426                	sd	s1,40(sp)
 5cc:	0080                	addi	s0,sp,64
 5ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d0:	c299                	beqz	a3,5d6 <printint+0x12>
 5d2:	0805c963          	bltz	a1,664 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5d6:	2581                	sext.w	a1,a1
  neg = 0;
 5d8:	4881                	li	a7,0
 5da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e0:	2601                	sext.w	a2,a2
 5e2:	00000517          	auipc	a0,0x0
 5e6:	60e50513          	addi	a0,a0,1550 # bf0 <digits>
 5ea:	883a                	mv	a6,a4
 5ec:	2705                	addiw	a4,a4,1
 5ee:	02c5f7bb          	remuw	a5,a1,a2
 5f2:	1782                	slli	a5,a5,0x20
 5f4:	9381                	srli	a5,a5,0x20
 5f6:	97aa                	add	a5,a5,a0
 5f8:	0007c783          	lbu	a5,0(a5)
 5fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 600:	0005879b          	sext.w	a5,a1
 604:	02c5d5bb          	divuw	a1,a1,a2
 608:	0685                	addi	a3,a3,1
 60a:	fec7f0e3          	bgeu	a5,a2,5ea <printint+0x26>
  if(neg)
 60e:	00088c63          	beqz	a7,626 <printint+0x62>
    buf[i++] = '-';
 612:	fd070793          	addi	a5,a4,-48
 616:	00878733          	add	a4,a5,s0
 61a:	02d00793          	li	a5,45
 61e:	fef70823          	sb	a5,-16(a4)
 622:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 626:	02e05a63          	blez	a4,65a <printint+0x96>
 62a:	f04a                	sd	s2,32(sp)
 62c:	ec4e                	sd	s3,24(sp)
 62e:	fc040793          	addi	a5,s0,-64
 632:	00e78933          	add	s2,a5,a4
 636:	fff78993          	addi	s3,a5,-1
 63a:	99ba                	add	s3,s3,a4
 63c:	377d                	addiw	a4,a4,-1
 63e:	1702                	slli	a4,a4,0x20
 640:	9301                	srli	a4,a4,0x20
 642:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 646:	fff94583          	lbu	a1,-1(s2)
 64a:	8526                	mv	a0,s1
 64c:	f5bff0ef          	jal	5a6 <putc>
  while(--i >= 0)
 650:	197d                	addi	s2,s2,-1
 652:	ff391ae3          	bne	s2,s3,646 <printint+0x82>
 656:	7902                	ld	s2,32(sp)
 658:	69e2                	ld	s3,24(sp)
}
 65a:	70e2                	ld	ra,56(sp)
 65c:	7442                	ld	s0,48(sp)
 65e:	74a2                	ld	s1,40(sp)
 660:	6121                	addi	sp,sp,64
 662:	8082                	ret
    x = -xx;
 664:	40b005bb          	negw	a1,a1
    neg = 1;
 668:	4885                	li	a7,1
    x = -xx;
 66a:	bf85                	j	5da <printint+0x16>

000000000000066c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 66c:	711d                	addi	sp,sp,-96
 66e:	ec86                	sd	ra,88(sp)
 670:	e8a2                	sd	s0,80(sp)
 672:	e0ca                	sd	s2,64(sp)
 674:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 676:	0005c903          	lbu	s2,0(a1)
 67a:	26090863          	beqz	s2,8ea <vprintf+0x27e>
 67e:	e4a6                	sd	s1,72(sp)
 680:	fc4e                	sd	s3,56(sp)
 682:	f852                	sd	s4,48(sp)
 684:	f456                	sd	s5,40(sp)
 686:	f05a                	sd	s6,32(sp)
 688:	ec5e                	sd	s7,24(sp)
 68a:	e862                	sd	s8,16(sp)
 68c:	e466                	sd	s9,8(sp)
 68e:	8b2a                	mv	s6,a0
 690:	8a2e                	mv	s4,a1
 692:	8bb2                	mv	s7,a2
  state = 0;
 694:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 696:	4481                	li	s1,0
 698:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 69e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a2:	06c00c93          	li	s9,108
 6a6:	a005                	j	6c6 <vprintf+0x5a>
        putc(fd, c0);
 6a8:	85ca                	mv	a1,s2
 6aa:	855a                	mv	a0,s6
 6ac:	efbff0ef          	jal	5a6 <putc>
 6b0:	a019                	j	6b6 <vprintf+0x4a>
    } else if(state == '%'){
 6b2:	03598263          	beq	s3,s5,6d6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6b6:	2485                	addiw	s1,s1,1
 6b8:	8726                	mv	a4,s1
 6ba:	009a07b3          	add	a5,s4,s1
 6be:	0007c903          	lbu	s2,0(a5)
 6c2:	20090c63          	beqz	s2,8da <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6c6:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ca:	fe0994e3          	bnez	s3,6b2 <vprintf+0x46>
      if(c0 == '%'){
 6ce:	fd579de3          	bne	a5,s5,6a8 <vprintf+0x3c>
        state = '%';
 6d2:	89be                	mv	s3,a5
 6d4:	b7cd                	j	6b6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6d6:	00ea06b3          	add	a3,s4,a4
 6da:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6de:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e0:	c681                	beqz	a3,6e8 <vprintf+0x7c>
 6e2:	9752                	add	a4,a4,s4
 6e4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6e8:	03878f63          	beq	a5,s8,726 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6ec:	05978963          	beq	a5,s9,73e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f0:	07500713          	li	a4,117
 6f4:	0ee78363          	beq	a5,a4,7da <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6f8:	07800713          	li	a4,120
 6fc:	12e78563          	beq	a5,a4,826 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 700:	07000713          	li	a4,112
 704:	14e78a63          	beq	a5,a4,858 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 708:	07300713          	li	a4,115
 70c:	18e78a63          	beq	a5,a4,8a0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 710:	02500713          	li	a4,37
 714:	04e79563          	bne	a5,a4,75e <vprintf+0xf2>
        putc(fd, '%');
 718:	02500593          	li	a1,37
 71c:	855a                	mv	a0,s6
 71e:	e89ff0ef          	jal	5a6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 722:	4981                	li	s3,0
 724:	bf49                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 726:	008b8913          	addi	s2,s7,8
 72a:	4685                	li	a3,1
 72c:	4629                	li	a2,10
 72e:	000ba583          	lw	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	e91ff0ef          	jal	5c4 <printint>
 738:	8bca                	mv	s7,s2
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bfad                	j	6b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 73e:	06400793          	li	a5,100
 742:	02f68963          	beq	a3,a5,774 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 746:	06c00793          	li	a5,108
 74a:	04f68263          	beq	a3,a5,78e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 74e:	07500793          	li	a5,117
 752:	0af68063          	beq	a3,a5,7f2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 756:	07800793          	li	a5,120
 75a:	0ef68263          	beq	a3,a5,83e <vprintf+0x1d2>
        putc(fd, '%');
 75e:	02500593          	li	a1,37
 762:	855a                	mv	a0,s6
 764:	e43ff0ef          	jal	5a6 <putc>
        putc(fd, c0);
 768:	85ca                	mv	a1,s2
 76a:	855a                	mv	a0,s6
 76c:	e3bff0ef          	jal	5a6 <putc>
      state = 0;
 770:	4981                	li	s3,0
 772:	b791                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	008b8913          	addi	s2,s7,8
 778:	4685                	li	a3,1
 77a:	4629                	li	a2,10
 77c:	000ba583          	lw	a1,0(s7)
 780:	855a                	mv	a0,s6
 782:	e43ff0ef          	jal	5c4 <printint>
        i += 1;
 786:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
        i += 1;
 78c:	b72d                	j	6b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78e:	06400793          	li	a5,100
 792:	02f60763          	beq	a2,a5,7c0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 796:	07500793          	li	a5,117
 79a:	06f60963          	beq	a2,a5,80c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79e:	07800793          	li	a5,120
 7a2:	faf61ee3          	bne	a2,a5,75e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a6:	008b8913          	addi	s2,s7,8
 7aa:	4681                	li	a3,0
 7ac:	4641                	li	a2,16
 7ae:	000ba583          	lw	a1,0(s7)
 7b2:	855a                	mv	a0,s6
 7b4:	e11ff0ef          	jal	5c4 <printint>
        i += 2;
 7b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7ba:	8bca                	mv	s7,s2
      state = 0;
 7bc:	4981                	li	s3,0
        i += 2;
 7be:	bde5                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c0:	008b8913          	addi	s2,s7,8
 7c4:	4685                	li	a3,1
 7c6:	4629                	li	a2,10
 7c8:	000ba583          	lw	a1,0(s7)
 7cc:	855a                	mv	a0,s6
 7ce:	df7ff0ef          	jal	5c4 <printint>
        i += 2;
 7d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d4:	8bca                	mv	s7,s2
      state = 0;
 7d6:	4981                	li	s3,0
        i += 2;
 7d8:	bdf9                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7da:	008b8913          	addi	s2,s7,8
 7de:	4681                	li	a3,0
 7e0:	4629                	li	a2,10
 7e2:	000ba583          	lw	a1,0(s7)
 7e6:	855a                	mv	a0,s6
 7e8:	dddff0ef          	jal	5c4 <printint>
 7ec:	8bca                	mv	s7,s2
      state = 0;
 7ee:	4981                	li	s3,0
 7f0:	b5d9                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f2:	008b8913          	addi	s2,s7,8
 7f6:	4681                	li	a3,0
 7f8:	4629                	li	a2,10
 7fa:	000ba583          	lw	a1,0(s7)
 7fe:	855a                	mv	a0,s6
 800:	dc5ff0ef          	jal	5c4 <printint>
        i += 1;
 804:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 806:	8bca                	mv	s7,s2
      state = 0;
 808:	4981                	li	s3,0
        i += 1;
 80a:	b575                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 80c:	008b8913          	addi	s2,s7,8
 810:	4681                	li	a3,0
 812:	4629                	li	a2,10
 814:	000ba583          	lw	a1,0(s7)
 818:	855a                	mv	a0,s6
 81a:	dabff0ef          	jal	5c4 <printint>
        i += 2;
 81e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 820:	8bca                	mv	s7,s2
      state = 0;
 822:	4981                	li	s3,0
        i += 2;
 824:	bd49                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 826:	008b8913          	addi	s2,s7,8
 82a:	4681                	li	a3,0
 82c:	4641                	li	a2,16
 82e:	000ba583          	lw	a1,0(s7)
 832:	855a                	mv	a0,s6
 834:	d91ff0ef          	jal	5c4 <printint>
 838:	8bca                	mv	s7,s2
      state = 0;
 83a:	4981                	li	s3,0
 83c:	bdad                	j	6b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83e:	008b8913          	addi	s2,s7,8
 842:	4681                	li	a3,0
 844:	4641                	li	a2,16
 846:	000ba583          	lw	a1,0(s7)
 84a:	855a                	mv	a0,s6
 84c:	d79ff0ef          	jal	5c4 <printint>
        i += 1;
 850:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 852:	8bca                	mv	s7,s2
      state = 0;
 854:	4981                	li	s3,0
        i += 1;
 856:	b585                	j	6b6 <vprintf+0x4a>
 858:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 85a:	008b8d13          	addi	s10,s7,8
 85e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 862:	03000593          	li	a1,48
 866:	855a                	mv	a0,s6
 868:	d3fff0ef          	jal	5a6 <putc>
  putc(fd, 'x');
 86c:	07800593          	li	a1,120
 870:	855a                	mv	a0,s6
 872:	d35ff0ef          	jal	5a6 <putc>
 876:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 878:	00000b97          	auipc	s7,0x0
 87c:	378b8b93          	addi	s7,s7,888 # bf0 <digits>
 880:	03c9d793          	srli	a5,s3,0x3c
 884:	97de                	add	a5,a5,s7
 886:	0007c583          	lbu	a1,0(a5)
 88a:	855a                	mv	a0,s6
 88c:	d1bff0ef          	jal	5a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 890:	0992                	slli	s3,s3,0x4
 892:	397d                	addiw	s2,s2,-1
 894:	fe0916e3          	bnez	s2,880 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 898:	8bea                	mv	s7,s10
      state = 0;
 89a:	4981                	li	s3,0
 89c:	6d02                	ld	s10,0(sp)
 89e:	bd21                	j	6b6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8a0:	008b8993          	addi	s3,s7,8
 8a4:	000bb903          	ld	s2,0(s7)
 8a8:	00090f63          	beqz	s2,8c6 <vprintf+0x25a>
        for(; *s; s++)
 8ac:	00094583          	lbu	a1,0(s2)
 8b0:	c195                	beqz	a1,8d4 <vprintf+0x268>
          putc(fd, *s);
 8b2:	855a                	mv	a0,s6
 8b4:	cf3ff0ef          	jal	5a6 <putc>
        for(; *s; s++)
 8b8:	0905                	addi	s2,s2,1
 8ba:	00094583          	lbu	a1,0(s2)
 8be:	f9f5                	bnez	a1,8b2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c0:	8bce                	mv	s7,s3
      state = 0;
 8c2:	4981                	li	s3,0
 8c4:	bbcd                	j	6b6 <vprintf+0x4a>
          s = "(null)";
 8c6:	00000917          	auipc	s2,0x0
 8ca:	32290913          	addi	s2,s2,802 # be8 <malloc+0x216>
        for(; *s; s++)
 8ce:	02800593          	li	a1,40
 8d2:	b7c5                	j	8b2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d4:	8bce                	mv	s7,s3
      state = 0;
 8d6:	4981                	li	s3,0
 8d8:	bbf9                	j	6b6 <vprintf+0x4a>
 8da:	64a6                	ld	s1,72(sp)
 8dc:	79e2                	ld	s3,56(sp)
 8de:	7a42                	ld	s4,48(sp)
 8e0:	7aa2                	ld	s5,40(sp)
 8e2:	7b02                	ld	s6,32(sp)
 8e4:	6be2                	ld	s7,24(sp)
 8e6:	6c42                	ld	s8,16(sp)
 8e8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ea:	60e6                	ld	ra,88(sp)
 8ec:	6446                	ld	s0,80(sp)
 8ee:	6906                	ld	s2,64(sp)
 8f0:	6125                	addi	sp,sp,96
 8f2:	8082                	ret

00000000000008f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f4:	715d                	addi	sp,sp,-80
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	addi	s0,sp,32
 8fc:	e010                	sd	a2,0(s0)
 8fe:	e414                	sd	a3,8(s0)
 900:	e818                	sd	a4,16(s0)
 902:	ec1c                	sd	a5,24(s0)
 904:	03043023          	sd	a6,32(s0)
 908:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 910:	8622                	mv	a2,s0
 912:	d5bff0ef          	jal	66c <vprintf>
}
 916:	60e2                	ld	ra,24(sp)
 918:	6442                	ld	s0,16(sp)
 91a:	6161                	addi	sp,sp,80
 91c:	8082                	ret

000000000000091e <printf>:

void
printf(const char *fmt, ...)
{
 91e:	711d                	addi	sp,sp,-96
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	1000                	addi	s0,sp,32
 926:	e40c                	sd	a1,8(s0)
 928:	e810                	sd	a2,16(s0)
 92a:	ec14                	sd	a3,24(s0)
 92c:	f018                	sd	a4,32(s0)
 92e:	f41c                	sd	a5,40(s0)
 930:	03043823          	sd	a6,48(s0)
 934:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 938:	00840613          	addi	a2,s0,8
 93c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 940:	85aa                	mv	a1,a0
 942:	4505                	li	a0,1
 944:	d29ff0ef          	jal	66c <vprintf>
}
 948:	60e2                	ld	ra,24(sp)
 94a:	6442                	ld	s0,16(sp)
 94c:	6125                	addi	sp,sp,96
 94e:	8082                	ret

0000000000000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	1141                	addi	sp,sp,-16
 952:	e422                	sd	s0,8(sp)
 954:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 956:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95a:	00000797          	auipc	a5,0x0
 95e:	6a67b783          	ld	a5,1702(a5) # 1000 <freep>
 962:	a02d                	j	98c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 964:	4618                	lw	a4,8(a2)
 966:	9f2d                	addw	a4,a4,a1
 968:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 96c:	6398                	ld	a4,0(a5)
 96e:	6310                	ld	a2,0(a4)
 970:	a83d                	j	9ae <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 972:	ff852703          	lw	a4,-8(a0)
 976:	9f31                	addw	a4,a4,a2
 978:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 97a:	ff053683          	ld	a3,-16(a0)
 97e:	a091                	j	9c2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	6398                	ld	a4,0(a5)
 982:	00e7e463          	bltu	a5,a4,98a <free+0x3a>
 986:	00e6ea63          	bltu	a3,a4,99a <free+0x4a>
{
 98a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98c:	fed7fae3          	bgeu	a5,a3,980 <free+0x30>
 990:	6398                	ld	a4,0(a5)
 992:	00e6e463          	bltu	a3,a4,99a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 996:	fee7eae3          	bltu	a5,a4,98a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 99a:	ff852583          	lw	a1,-8(a0)
 99e:	6390                	ld	a2,0(a5)
 9a0:	02059813          	slli	a6,a1,0x20
 9a4:	01c85713          	srli	a4,a6,0x1c
 9a8:	9736                	add	a4,a4,a3
 9aa:	fae60de3          	beq	a2,a4,964 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b2:	4790                	lw	a2,8(a5)
 9b4:	02061593          	slli	a1,a2,0x20
 9b8:	01c5d713          	srli	a4,a1,0x1c
 9bc:	973e                	add	a4,a4,a5
 9be:	fae68ae3          	beq	a3,a4,972 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c4:	00000717          	auipc	a4,0x0
 9c8:	62f73e23          	sd	a5,1596(a4) # 1000 <freep>
}
 9cc:	6422                	ld	s0,8(sp)
 9ce:	0141                	addi	sp,sp,16
 9d0:	8082                	ret

00000000000009d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d2:	7139                	addi	sp,sp,-64
 9d4:	fc06                	sd	ra,56(sp)
 9d6:	f822                	sd	s0,48(sp)
 9d8:	f426                	sd	s1,40(sp)
 9da:	ec4e                	sd	s3,24(sp)
 9dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9de:	02051493          	slli	s1,a0,0x20
 9e2:	9081                	srli	s1,s1,0x20
 9e4:	04bd                	addi	s1,s1,15
 9e6:	8091                	srli	s1,s1,0x4
 9e8:	0014899b          	addiw	s3,s1,1
 9ec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ee:	00000517          	auipc	a0,0x0
 9f2:	61253503          	ld	a0,1554(a0) # 1000 <freep>
 9f6:	c915                	beqz	a0,a2a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fa:	4798                	lw	a4,8(a5)
 9fc:	08977a63          	bgeu	a4,s1,a90 <malloc+0xbe>
 a00:	f04a                	sd	s2,32(sp)
 a02:	e852                	sd	s4,16(sp)
 a04:	e456                	sd	s5,8(sp)
 a06:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a08:	8a4e                	mv	s4,s3
 a0a:	0009871b          	sext.w	a4,s3
 a0e:	6685                	lui	a3,0x1
 a10:	00d77363          	bgeu	a4,a3,a16 <malloc+0x44>
 a14:	6a05                	lui	s4,0x1
 a16:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a1e:	00000917          	auipc	s2,0x0
 a22:	5e290913          	addi	s2,s2,1506 # 1000 <freep>
  if(p == (char*)-1)
 a26:	5afd                	li	s5,-1
 a28:	a081                	j	a68 <malloc+0x96>
 a2a:	f04a                	sd	s2,32(sp)
 a2c:	e852                	sd	s4,16(sp)
 a2e:	e456                	sd	s5,8(sp)
 a30:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a32:	00000797          	auipc	a5,0x0
 a36:	5de78793          	addi	a5,a5,1502 # 1010 <base>
 a3a:	00000717          	auipc	a4,0x0
 a3e:	5cf73323          	sd	a5,1478(a4) # 1000 <freep>
 a42:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a44:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a48:	b7c1                	j	a08 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a4a:	6398                	ld	a4,0(a5)
 a4c:	e118                	sd	a4,0(a0)
 a4e:	a8a9                	j	aa8 <malloc+0xd6>
  hp->s.size = nu;
 a50:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a54:	0541                	addi	a0,a0,16
 a56:	efbff0ef          	jal	950 <free>
  return freep;
 a5a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a5e:	c12d                	beqz	a0,ac0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a62:	4798                	lw	a4,8(a5)
 a64:	02977263          	bgeu	a4,s1,a88 <malloc+0xb6>
    if(p == freep)
 a68:	00093703          	ld	a4,0(s2)
 a6c:	853e                	mv	a0,a5
 a6e:	fef719e3          	bne	a4,a5,a60 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a72:	8552                	mv	a0,s4
 a74:	acbff0ef          	jal	53e <sbrk>
  if(p == (char*)-1)
 a78:	fd551ce3          	bne	a0,s5,a50 <malloc+0x7e>
        return 0;
 a7c:	4501                	li	a0,0
 a7e:	7902                	ld	s2,32(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	a03d                	j	ab4 <malloc+0xe2>
 a88:	7902                	ld	s2,32(sp)
 a8a:	6a42                	ld	s4,16(sp)
 a8c:	6aa2                	ld	s5,8(sp)
 a8e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a90:	fae48de3          	beq	s1,a4,a4a <malloc+0x78>
        p->s.size -= nunits;
 a94:	4137073b          	subw	a4,a4,s3
 a98:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a9a:	02071693          	slli	a3,a4,0x20
 a9e:	01c6d713          	srli	a4,a3,0x1c
 aa2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa8:	00000717          	auipc	a4,0x0
 aac:	54a73c23          	sd	a0,1368(a4) # 1000 <freep>
      return (void*)(p + 1);
 ab0:	01078513          	addi	a0,a5,16
  }
}
 ab4:	70e2                	ld	ra,56(sp)
 ab6:	7442                	ld	s0,48(sp)
 ab8:	74a2                	ld	s1,40(sp)
 aba:	69e2                	ld	s3,24(sp)
 abc:	6121                	addi	sp,sp,64
 abe:	8082                	ret
 ac0:	7902                	ld	s2,32(sp)
 ac2:	6a42                	ld	s4,16(sp)
 ac4:	6aa2                	ld	s5,8(sp)
 ac6:	6b02                	ld	s6,0(sp)
 ac8:	b7f5                	j	ab4 <malloc+0xe2>
