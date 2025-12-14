
user/_diff:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <read_file_lines>:
#include "kernel/fcntl.h"

#define MAX_LINES 1000
#define LINE_LENGTH 256

int read_file_lines(char *filename, char lines[][LINE_LENGTH], int *line_count) {
   0:	ca010113          	addi	sp,sp,-864
   4:	34113c23          	sd	ra,856(sp)
   8:	34813823          	sd	s0,848(sp)
   c:	34913423          	sd	s1,840(sp)
  10:	33613023          	sd	s6,800(sp)
  14:	31913423          	sd	s9,776(sp)
  18:	1680                	addi	s0,sp,864
  1a:	84aa                	mv	s1,a0
  1c:	8cae                	mv	s9,a1
  1e:	8b32                	mv	s6,a2
    int fd, n, i;
    char buf[512];
    char current_line[LINE_LENGTH];
    int curr_pos = 0;

    if ((fd = open(filename, O_RDONLY)) < 0) {
  20:	4581                	li	a1,0
  22:	596000ef          	jal	5b8 <open>
  26:	04054863          	bltz	a0,76 <read_file_lines+0x76>
  2a:	35213023          	sd	s2,832(sp)
  2e:	33313c23          	sd	s3,824(sp)
  32:	33413823          	sd	s4,816(sp)
  36:	33513423          	sd	s5,808(sp)
  3a:	31713c23          	sd	s7,792(sp)
  3e:	31813823          	sd	s8,784(sp)
  42:	31a13023          	sd	s10,768(sp)
  46:	8c2a                	mv	s8,a0
        fprintf(2, "diff: cannot open %s\n", filename);
        return -1;
    }

    *line_count = 0;
  48:	000b2023          	sw	zero,0(s6)
    int curr_pos = 0;
  4c:	4901                	li	s2,0
                if (*line_count < MAX_LINES) {
                    strcpy(lines[*line_count], current_line);
                    (*line_count)++;
                }
                curr_pos = 0;
            } else if (curr_pos < LINE_LENGTH - 1) {
  4e:	0fe00a93          	li	s5,254
                if (*line_count < MAX_LINES) {
  52:	3e700d13          	li	s10,999
                curr_pos = 0;
  56:	4b81                	li	s7,0
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
  58:	20000613          	li	a2,512
  5c:	da040593          	addi	a1,s0,-608
  60:	8562                	mv	a0,s8
  62:	52e000ef          	jal	590 <read>
  66:	06a05963          	blez	a0,d8 <read_file_lines+0xd8>
        for (i = 0; i < n; i++) {
  6a:	da040493          	addi	s1,s0,-608
  6e:	009509b3          	add	s3,a0,s1
            if (buf[i] == '\n') {
  72:	4a29                	li	s4,10
  74:	a80d                	j	a6 <read_file_lines+0xa6>
        fprintf(2, "diff: cannot open %s\n", filename);
  76:	8626                	mv	a2,s1
  78:	00001597          	auipc	a1,0x1
  7c:	b1858593          	addi	a1,a1,-1256 # b90 <malloc+0xfc>
  80:	4509                	li	a0,2
  82:	135000ef          	jal	9b6 <fprintf>
        return -1;
  86:	557d                	li	a0,-1
  88:	a841                	j	118 <read_file_lines+0x118>
                current_line[curr_pos] = '\0';
  8a:	fa090793          	addi	a5,s2,-96
  8e:	00878933          	add	s2,a5,s0
  92:	d0090023          	sb	zero,-768(s2)
                if (*line_count < MAX_LINES) {
  96:	000b2503          	lw	a0,0(s6)
                curr_pos = 0;
  9a:	895e                	mv	s2,s7
                if (*line_count < MAX_LINES) {
  9c:	02ad5263          	bge	s10,a0,c0 <read_file_lines+0xc0>
        for (i = 0; i < n; i++) {
  a0:	0485                	addi	s1,s1,1
  a2:	fb348be3          	beq	s1,s3,58 <read_file_lines+0x58>
            if (buf[i] == '\n') {
  a6:	0004c783          	lbu	a5,0(s1)
  aa:	ff4780e3          	beq	a5,s4,8a <read_file_lines+0x8a>
            } else if (curr_pos < LINE_LENGTH - 1) {
  ae:	ff2ac9e3          	blt	s5,s2,a0 <read_file_lines+0xa0>
                current_line[curr_pos++] = buf[i];
  b2:	fa090713          	addi	a4,s2,-96
  b6:	9722                	add	a4,a4,s0
  b8:	d0f70023          	sb	a5,-768(a4)
  bc:	2905                	addiw	s2,s2,1
  be:	b7cd                	j	a0 <read_file_lines+0xa0>
                    strcpy(lines[*line_count], current_line);
  c0:	0522                	slli	a0,a0,0x8
  c2:	ca040593          	addi	a1,s0,-864
  c6:	9566                	add	a0,a0,s9
  c8:	258000ef          	jal	320 <strcpy>
                    (*line_count)++;
  cc:	000b2783          	lw	a5,0(s6)
  d0:	2785                	addiw	a5,a5,1
  d2:	00fb2023          	sw	a5,0(s6)
  d6:	b7e9                	j	a0 <read_file_lines+0xa0>
            }
        }
    }

    // Handle last line if no newline
    if (curr_pos > 0) {
  d8:	01205e63          	blez	s2,f4 <read_file_lines+0xf4>
        current_line[curr_pos] = '\0';
  dc:	fa090793          	addi	a5,s2,-96
  e0:	00878933          	add	s2,a5,s0
  e4:	d0090023          	sb	zero,-768(s2)
        if (*line_count < MAX_LINES) {
  e8:	000b2783          	lw	a5,0(s6)
  ec:	3e700713          	li	a4,999
  f0:	04f75163          	bge	a4,a5,132 <read_file_lines+0x132>
            strcpy(lines[*line_count], current_line);
            (*line_count)++;
        }
    }

    close(fd);
  f4:	8562                	mv	a0,s8
  f6:	4aa000ef          	jal	5a0 <close>
    return 0;
  fa:	4501                	li	a0,0
  fc:	34013903          	ld	s2,832(sp)
 100:	33813983          	ld	s3,824(sp)
 104:	33013a03          	ld	s4,816(sp)
 108:	32813a83          	ld	s5,808(sp)
 10c:	31813b83          	ld	s7,792(sp)
 110:	31013c03          	ld	s8,784(sp)
 114:	30013d03          	ld	s10,768(sp)
}
 118:	35813083          	ld	ra,856(sp)
 11c:	35013403          	ld	s0,848(sp)
 120:	34813483          	ld	s1,840(sp)
 124:	32013b03          	ld	s6,800(sp)
 128:	30813c83          	ld	s9,776(sp)
 12c:	36010113          	addi	sp,sp,864
 130:	8082                	ret
            strcpy(lines[*line_count], current_line);
 132:	07a2                	slli	a5,a5,0x8
 134:	ca040593          	addi	a1,s0,-864
 138:	00fc8533          	add	a0,s9,a5
 13c:	1e4000ef          	jal	320 <strcpy>
            (*line_count)++;
 140:	000b2783          	lw	a5,0(s6)
 144:	2785                	addiw	a5,a5,1
 146:	00fb2023          	sw	a5,0(s6)
 14a:	b76d                	j	f4 <read_file_lines+0xf4>

000000000000014c <main>:

int main(int argc, char *argv[]) {
 14c:	7175                	addi	sp,sp,-144
 14e:	e506                	sd	ra,136(sp)
 150:	e122                	sd	s0,128(sp)
 152:	fca6                	sd	s1,120(sp)
 154:	f8ca                	sd	s2,112(sp)
 156:	f4ce                	sd	s3,104(sp)
 158:	f0d2                	sd	s4,96(sp)
 15a:	ecd6                	sd	s5,88(sp)
 15c:	e8da                	sd	s6,80(sp)
 15e:	e4de                	sd	s7,72(sp)
 160:	e0e2                	sd	s8,64(sp)
 162:	fc66                	sd	s9,56(sp)
 164:	f86a                	sd	s10,48(sp)
 166:	f46e                	sd	s11,40(sp)
 168:	0900                	addi	s0,sp,144
 16a:	fff832b7          	lui	t0,0xfff83
 16e:	9116                	add	sp,sp,t0
    char file1_lines[MAX_LINES][LINE_LENGTH];
    char file2_lines[MAX_LINES][LINE_LENGTH];
    int file1_count, file2_count;
    int i, identical = 1;

    if (argc != 3) {
 170:	478d                	li	a5,3
 172:	04f51263          	bne	a0,a5,1b6 <main+0x6a>
 176:	84ae                	mv	s1,a1
        fprintf(2, "Usage: diff file1 file2\n");
        exit(1);
    }

    if (strcmp(argv[1], "?") == 0) {
 178:	0085b903          	ld	s2,8(a1)
 17c:	00001597          	auipc	a1,0x1
 180:	a4c58593          	addi	a1,a1,-1460 # bc8 <malloc+0x134>
 184:	854a                	mv	a0,s2
 186:	1b6000ef          	jal	33c <strcmp>
 18a:	e121                	bnez	a0,1ca <main+0x7e>
        printf("Usage: diff file1 file2\n");
 18c:	00001517          	auipc	a0,0x1
 190:	a1c50513          	addi	a0,a0,-1508 # ba8 <malloc+0x114>
 194:	04d000ef          	jal	9e0 <printf>
        printf("Compare two files line by line\n");
 198:	00001517          	auipc	a0,0x1
 19c:	a3850513          	addi	a0,a0,-1480 # bd0 <malloc+0x13c>
 1a0:	041000ef          	jal	9e0 <printf>
        printf("Show differences with line numbers\n");
 1a4:	00001517          	auipc	a0,0x1
 1a8:	a4c50513          	addi	a0,a0,-1460 # bf0 <malloc+0x15c>
 1ac:	035000ef          	jal	9e0 <printf>
        exit(0);
 1b0:	4501                	li	a0,0
 1b2:	3c6000ef          	jal	578 <exit>
        fprintf(2, "Usage: diff file1 file2\n");
 1b6:	00001597          	auipc	a1,0x1
 1ba:	9f258593          	addi	a1,a1,-1550 # ba8 <malloc+0x114>
 1be:	4509                	li	a0,2
 1c0:	7f6000ef          	jal	9b6 <fprintf>
        exit(1);
 1c4:	4505                	li	a0,1
 1c6:	3b2000ef          	jal	578 <exit>
    }

    // Read both files
    if (read_file_lines(argv[1], file1_lines, &file1_count) < 0 ||
 1ca:	fff83637          	lui	a2,0xfff83
 1ce:	fffc25b7          	lui	a1,0xfffc2
 1d2:	80058593          	addi	a1,a1,-2048 # fffffffffffc1800 <base+0xfffffffffffbf7f0>
 1d6:	f8c60793          	addi	a5,a2,-116 # fffffffffff82f8c <base+0xfffffffffff80f7c>
 1da:	00878633          	add	a2,a5,s0
 1de:	f9058793          	addi	a5,a1,-112
 1e2:	008785b3          	add	a1,a5,s0
 1e6:	854a                	mv	a0,s2
 1e8:	e19ff0ef          	jal	0 <read_file_lines>
 1ec:	08054563          	bltz	a0,276 <main+0x12a>
        read_file_lines(argv[2], file2_lines, &file2_count) < 0) {
 1f0:	fff83637          	lui	a2,0xfff83
 1f4:	f8860793          	addi	a5,a2,-120 # fffffffffff82f88 <base+0xfffffffffff80f78>
 1f8:	00878633          	add	a2,a5,s0
 1fc:	fff835b7          	lui	a1,0xfff83
 200:	f9058793          	addi	a5,a1,-112 # fffffffffff82f90 <base+0xfffffffffff80f80>
 204:	008785b3          	add	a1,a5,s0
 208:	6888                	ld	a0,16(s1)
 20a:	df7ff0ef          	jal	0 <read_file_lines>
    if (read_file_lines(argv[1], file1_lines, &file1_count) < 0 ||
 20e:	06054463          	bltz	a0,276 <main+0x12a>
        exit(1);
    }

    // Compare lines
    int max_lines = (file1_count > file2_count) ? file1_count : file2_count;
 212:	fff837b7          	lui	a5,0xfff83
 216:	f9078793          	addi	a5,a5,-112 # fffffffffff82f90 <base+0xfffffffffff80f80>
 21a:	97a2                	add	a5,a5,s0
 21c:	fff83737          	lui	a4,0xfff83
 220:	f7870693          	addi	a3,a4,-136 # fffffffffff82f78 <base+0xfffffffffff80f68>
 224:	96a2                	add	a3,a3,s0
 226:	e29c                	sd	a5,0(a3)
 228:	629c                	ld	a5,0(a3)
 22a:	ff87ac03          	lw	s8,-8(a5)
 22e:	629c                	ld	a5,0(a3)
 230:	ffc7ab83          	lw	s7,-4(a5)
 234:	8b62                	mv	s6,s8
 236:	017c5363          	bge	s8,s7,23c <main+0xf0>
 23a:	8b5e                	mv	s6,s7
 23c:	2b01                	sext.w	s6,s6

    for (i = 0; i < max_lines; i++) {
 23e:	0d605163          	blez	s6,300 <main+0x1b4>
 242:	fff83a37          	lui	s4,0xfff83
 246:	f90a0793          	addi	a5,s4,-112 # fffffffffff82f90 <base+0xfffffffffff80f80>
 24a:	00878a33          	add	s4,a5,s0
 24e:	fffc29b7          	lui	s3,0xfffc2
 252:	80098993          	addi	s3,s3,-2048 # fffffffffffc1800 <base+0xfffffffffffbf7f0>
 256:	f9098793          	addi	a5,s3,-112
 25a:	008789b3          	add	s3,a5,s0
 25e:	4a85                	li	s5,1
    int i, identical = 1;
 260:	4c85                	li	s9,1
    for (i = 0; i < max_lines; i++) {
 262:	4901                	li	s2,0
            printf("< %s\n", file1_lines[i]);
            identical = 0;
        } else if (strcmp(file1_lines[i], file2_lines[i]) != 0) {
            printf("Line %d differs:\n", i + 1);
            printf("< %s\n", file1_lines[i]);
            printf("> %s\n", file2_lines[i]);
 264:	00001d97          	auipc	s11,0x1
 268:	9ccd8d93          	addi	s11,s11,-1588 # c30 <malloc+0x19c>
            printf("Line %d only in %s:\n", i + 1, argv[1]);
 26c:	00001d17          	auipc	s10,0x1
 270:	9acd0d13          	addi	s10,s10,-1620 # c18 <malloc+0x184>
 274:	a035                	j	2a0 <main+0x154>
        exit(1);
 276:	4505                	li	a0,1
 278:	300000ef          	jal	578 <exit>
            printf("Line %d only in %s:\n", i + 1, argv[2]);
 27c:	6890                	ld	a2,16(s1)
 27e:	85d6                	mv	a1,s5
 280:	856a                	mv	a0,s10
 282:	75e000ef          	jal	9e0 <printf>
            printf("> %s\n", file2_lines[i]);
 286:	85d2                	mv	a1,s4
 288:	856e                	mv	a0,s11
 28a:	756000ef          	jal	9e0 <printf>
            identical = 0;
 28e:	4c81                	li	s9,0
    for (i = 0; i < max_lines; i++) {
 290:	2905                	addiw	s2,s2,1
 292:	2a85                	addiw	s5,s5,1
 294:	100a0a13          	addi	s4,s4,256
 298:	10098993          	addi	s3,s3,256
 29c:	052b0d63          	beq	s6,s2,2f6 <main+0x1aa>
        if (i >= file1_count) {
 2a0:	fd795ee3          	bge	s2,s7,27c <main+0x130>
        } else if (i >= file2_count) {
 2a4:	03895b63          	bge	s2,s8,2da <main+0x18e>
        } else if (strcmp(file1_lines[i], file2_lines[i]) != 0) {
 2a8:	85d2                	mv	a1,s4
 2aa:	854e                	mv	a0,s3
 2ac:	090000ef          	jal	33c <strcmp>
 2b0:	d165                	beqz	a0,290 <main+0x144>
            printf("Line %d differs:\n", i + 1);
 2b2:	85d6                	mv	a1,s5
 2b4:	00001517          	auipc	a0,0x1
 2b8:	98c50513          	addi	a0,a0,-1652 # c40 <malloc+0x1ac>
 2bc:	724000ef          	jal	9e0 <printf>
            printf("< %s\n", file1_lines[i]);
 2c0:	85ce                	mv	a1,s3
 2c2:	00001517          	auipc	a0,0x1
 2c6:	97650513          	addi	a0,a0,-1674 # c38 <malloc+0x1a4>
 2ca:	716000ef          	jal	9e0 <printf>
            printf("> %s\n", file2_lines[i]);
 2ce:	85d2                	mv	a1,s4
 2d0:	856e                	mv	a0,s11
 2d2:	70e000ef          	jal	9e0 <printf>
            identical = 0;
 2d6:	4c81                	li	s9,0
 2d8:	bf65                	j	290 <main+0x144>
            printf("Line %d only in %s:\n", i + 1, argv[1]);
 2da:	6490                	ld	a2,8(s1)
 2dc:	85d6                	mv	a1,s5
 2de:	856a                	mv	a0,s10
 2e0:	700000ef          	jal	9e0 <printf>
            printf("< %s\n", file1_lines[i]);
 2e4:	85ce                	mv	a1,s3
 2e6:	00001517          	auipc	a0,0x1
 2ea:	95250513          	addi	a0,a0,-1710 # c38 <malloc+0x1a4>
 2ee:	6f2000ef          	jal	9e0 <printf>
            identical = 0;
 2f2:	4c81                	li	s9,0
 2f4:	bf71                	j	290 <main+0x144>
        }
    }

    if (identical) {
 2f6:	000c9563          	bnez	s9,300 <main+0x1b4>
        printf("Files are identical\n");
    }

    exit(0);
 2fa:	4501                	li	a0,0
 2fc:	27c000ef          	jal	578 <exit>
        printf("Files are identical\n");
 300:	00001517          	auipc	a0,0x1
 304:	95850513          	addi	a0,a0,-1704 # c58 <malloc+0x1c4>
 308:	6d8000ef          	jal	9e0 <printf>
 30c:	b7fd                	j	2fa <main+0x1ae>

000000000000030e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  extern int main();
  main();
 316:	e37ff0ef          	jal	14c <main>
  exit(0);
 31a:	4501                	li	a0,0
 31c:	25c000ef          	jal	578 <exit>

0000000000000320 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 326:	87aa                	mv	a5,a0
 328:	0585                	addi	a1,a1,1
 32a:	0785                	addi	a5,a5,1
 32c:	fff5c703          	lbu	a4,-1(a1)
 330:	fee78fa3          	sb	a4,-1(a5)
 334:	fb75                	bnez	a4,328 <strcpy+0x8>
    ;
  return os;
}
 336:	6422                	ld	s0,8(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret

000000000000033c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33c:	1141                	addi	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 342:	00054783          	lbu	a5,0(a0)
 346:	cb91                	beqz	a5,35a <strcmp+0x1e>
 348:	0005c703          	lbu	a4,0(a1)
 34c:	00f71763          	bne	a4,a5,35a <strcmp+0x1e>
    p++, q++;
 350:	0505                	addi	a0,a0,1
 352:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 354:	00054783          	lbu	a5,0(a0)
 358:	fbe5                	bnez	a5,348 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 35a:	0005c503          	lbu	a0,0(a1)
}
 35e:	40a7853b          	subw	a0,a5,a0
 362:	6422                	ld	s0,8(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strlen>:

uint
strlen(const char *s)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 36e:	00054783          	lbu	a5,0(a0)
 372:	cf91                	beqz	a5,38e <strlen+0x26>
 374:	0505                	addi	a0,a0,1
 376:	87aa                	mv	a5,a0
 378:	86be                	mv	a3,a5
 37a:	0785                	addi	a5,a5,1
 37c:	fff7c703          	lbu	a4,-1(a5)
 380:	ff65                	bnez	a4,378 <strlen+0x10>
 382:	40a6853b          	subw	a0,a3,a0
 386:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 388:	6422                	ld	s0,8(sp)
 38a:	0141                	addi	sp,sp,16
 38c:	8082                	ret
  for(n = 0; s[n]; n++)
 38e:	4501                	li	a0,0
 390:	bfe5                	j	388 <strlen+0x20>

0000000000000392 <memset>:

void*
memset(void *dst, int c, uint n)
{
 392:	1141                	addi	sp,sp,-16
 394:	e422                	sd	s0,8(sp)
 396:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 398:	ca19                	beqz	a2,3ae <memset+0x1c>
 39a:	87aa                	mv	a5,a0
 39c:	1602                	slli	a2,a2,0x20
 39e:	9201                	srli	a2,a2,0x20
 3a0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3a4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3a8:	0785                	addi	a5,a5,1
 3aa:	fee79de3          	bne	a5,a4,3a4 <memset+0x12>
  }
  return dst;
}
 3ae:	6422                	ld	s0,8(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret

00000000000003b4 <strchr>:

char*
strchr(const char *s, char c)
{
 3b4:	1141                	addi	sp,sp,-16
 3b6:	e422                	sd	s0,8(sp)
 3b8:	0800                	addi	s0,sp,16
  for(; *s; s++)
 3ba:	00054783          	lbu	a5,0(a0)
 3be:	cb99                	beqz	a5,3d4 <strchr+0x20>
    if(*s == c)
 3c0:	00f58763          	beq	a1,a5,3ce <strchr+0x1a>
  for(; *s; s++)
 3c4:	0505                	addi	a0,a0,1
 3c6:	00054783          	lbu	a5,0(a0)
 3ca:	fbfd                	bnez	a5,3c0 <strchr+0xc>
      return (char*)s;
  return 0;
 3cc:	4501                	li	a0,0
}
 3ce:	6422                	ld	s0,8(sp)
 3d0:	0141                	addi	sp,sp,16
 3d2:	8082                	ret
  return 0;
 3d4:	4501                	li	a0,0
 3d6:	bfe5                	j	3ce <strchr+0x1a>

00000000000003d8 <gets>:

char*
gets(char *buf, int max)
{
 3d8:	711d                	addi	sp,sp,-96
 3da:	ec86                	sd	ra,88(sp)
 3dc:	e8a2                	sd	s0,80(sp)
 3de:	e4a6                	sd	s1,72(sp)
 3e0:	e0ca                	sd	s2,64(sp)
 3e2:	fc4e                	sd	s3,56(sp)
 3e4:	f852                	sd	s4,48(sp)
 3e6:	f456                	sd	s5,40(sp)
 3e8:	f05a                	sd	s6,32(sp)
 3ea:	ec5e                	sd	s7,24(sp)
 3ec:	1080                	addi	s0,sp,96
 3ee:	8baa                	mv	s7,a0
 3f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3f2:	892a                	mv	s2,a0
 3f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3f6:	4aa9                	li	s5,10
 3f8:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3fa:	89a6                	mv	s3,s1
 3fc:	2485                	addiw	s1,s1,1
 3fe:	0344d663          	bge	s1,s4,42a <gets+0x52>
    cc = read(0, &c, 1);
 402:	4605                	li	a2,1
 404:	faf40593          	addi	a1,s0,-81
 408:	4501                	li	a0,0
 40a:	186000ef          	jal	590 <read>
    if(cc < 1)
 40e:	00a05e63          	blez	a0,42a <gets+0x52>
    buf[i++] = c;
 412:	faf44783          	lbu	a5,-81(s0)
 416:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 41a:	01578763          	beq	a5,s5,428 <gets+0x50>
 41e:	0905                	addi	s2,s2,1
 420:	fd679de3          	bne	a5,s6,3fa <gets+0x22>
    buf[i++] = c;
 424:	89a6                	mv	s3,s1
 426:	a011                	j	42a <gets+0x52>
 428:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 42a:	99de                	add	s3,s3,s7
 42c:	00098023          	sb	zero,0(s3)
  return buf;
}
 430:	855e                	mv	a0,s7
 432:	60e6                	ld	ra,88(sp)
 434:	6446                	ld	s0,80(sp)
 436:	64a6                	ld	s1,72(sp)
 438:	6906                	ld	s2,64(sp)
 43a:	79e2                	ld	s3,56(sp)
 43c:	7a42                	ld	s4,48(sp)
 43e:	7aa2                	ld	s5,40(sp)
 440:	7b02                	ld	s6,32(sp)
 442:	6be2                	ld	s7,24(sp)
 444:	6125                	addi	sp,sp,96
 446:	8082                	ret

0000000000000448 <stat>:

int
stat(const char *n, struct stat *st)
{
 448:	1101                	addi	sp,sp,-32
 44a:	ec06                	sd	ra,24(sp)
 44c:	e822                	sd	s0,16(sp)
 44e:	e04a                	sd	s2,0(sp)
 450:	1000                	addi	s0,sp,32
 452:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 454:	4581                	li	a1,0
 456:	162000ef          	jal	5b8 <open>
  if(fd < 0)
 45a:	02054263          	bltz	a0,47e <stat+0x36>
 45e:	e426                	sd	s1,8(sp)
 460:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 462:	85ca                	mv	a1,s2
 464:	16c000ef          	jal	5d0 <fstat>
 468:	892a                	mv	s2,a0
  close(fd);
 46a:	8526                	mv	a0,s1
 46c:	134000ef          	jal	5a0 <close>
  return r;
 470:	64a2                	ld	s1,8(sp)
}
 472:	854a                	mv	a0,s2
 474:	60e2                	ld	ra,24(sp)
 476:	6442                	ld	s0,16(sp)
 478:	6902                	ld	s2,0(sp)
 47a:	6105                	addi	sp,sp,32
 47c:	8082                	ret
    return -1;
 47e:	597d                	li	s2,-1
 480:	bfcd                	j	472 <stat+0x2a>

0000000000000482 <atoi>:

int
atoi(const char *s)
{
 482:	1141                	addi	sp,sp,-16
 484:	e422                	sd	s0,8(sp)
 486:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 488:	00054683          	lbu	a3,0(a0)
 48c:	fd06879b          	addiw	a5,a3,-48
 490:	0ff7f793          	zext.b	a5,a5
 494:	4625                	li	a2,9
 496:	02f66863          	bltu	a2,a5,4c6 <atoi+0x44>
 49a:	872a                	mv	a4,a0
  n = 0;
 49c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 49e:	0705                	addi	a4,a4,1
 4a0:	0025179b          	slliw	a5,a0,0x2
 4a4:	9fa9                	addw	a5,a5,a0
 4a6:	0017979b          	slliw	a5,a5,0x1
 4aa:	9fb5                	addw	a5,a5,a3
 4ac:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 4b0:	00074683          	lbu	a3,0(a4)
 4b4:	fd06879b          	addiw	a5,a3,-48
 4b8:	0ff7f793          	zext.b	a5,a5
 4bc:	fef671e3          	bgeu	a2,a5,49e <atoi+0x1c>
  return n;
}
 4c0:	6422                	ld	s0,8(sp)
 4c2:	0141                	addi	sp,sp,16
 4c4:	8082                	ret
  n = 0;
 4c6:	4501                	li	a0,0
 4c8:	bfe5                	j	4c0 <atoi+0x3e>

00000000000004ca <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4ca:	1141                	addi	sp,sp,-16
 4cc:	e422                	sd	s0,8(sp)
 4ce:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4d0:	02b57463          	bgeu	a0,a1,4f8 <memmove+0x2e>
    while(n-- > 0)
 4d4:	00c05f63          	blez	a2,4f2 <memmove+0x28>
 4d8:	1602                	slli	a2,a2,0x20
 4da:	9201                	srli	a2,a2,0x20
 4dc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4e0:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e2:	0585                	addi	a1,a1,1
 4e4:	0705                	addi	a4,a4,1
 4e6:	fff5c683          	lbu	a3,-1(a1)
 4ea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ee:	fef71ae3          	bne	a4,a5,4e2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f2:	6422                	ld	s0,8(sp)
 4f4:	0141                	addi	sp,sp,16
 4f6:	8082                	ret
    dst += n;
 4f8:	00c50733          	add	a4,a0,a2
    src += n;
 4fc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fe:	fec05ae3          	blez	a2,4f2 <memmove+0x28>
 502:	fff6079b          	addiw	a5,a2,-1
 506:	1782                	slli	a5,a5,0x20
 508:	9381                	srli	a5,a5,0x20
 50a:	fff7c793          	not	a5,a5
 50e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 510:	15fd                	addi	a1,a1,-1
 512:	177d                	addi	a4,a4,-1
 514:	0005c683          	lbu	a3,0(a1)
 518:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 51c:	fee79ae3          	bne	a5,a4,510 <memmove+0x46>
 520:	bfc9                	j	4f2 <memmove+0x28>

0000000000000522 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 522:	1141                	addi	sp,sp,-16
 524:	e422                	sd	s0,8(sp)
 526:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 528:	ca05                	beqz	a2,558 <memcmp+0x36>
 52a:	fff6069b          	addiw	a3,a2,-1
 52e:	1682                	slli	a3,a3,0x20
 530:	9281                	srli	a3,a3,0x20
 532:	0685                	addi	a3,a3,1
 534:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 536:	00054783          	lbu	a5,0(a0)
 53a:	0005c703          	lbu	a4,0(a1)
 53e:	00e79863          	bne	a5,a4,54e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 542:	0505                	addi	a0,a0,1
    p2++;
 544:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 546:	fed518e3          	bne	a0,a3,536 <memcmp+0x14>
  }
  return 0;
 54a:	4501                	li	a0,0
 54c:	a019                	j	552 <memcmp+0x30>
      return *p1 - *p2;
 54e:	40e7853b          	subw	a0,a5,a4
}
 552:	6422                	ld	s0,8(sp)
 554:	0141                	addi	sp,sp,16
 556:	8082                	ret
  return 0;
 558:	4501                	li	a0,0
 55a:	bfe5                	j	552 <memcmp+0x30>

000000000000055c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 55c:	1141                	addi	sp,sp,-16
 55e:	e406                	sd	ra,8(sp)
 560:	e022                	sd	s0,0(sp)
 562:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 564:	f67ff0ef          	jal	4ca <memmove>
}
 568:	60a2                	ld	ra,8(sp)
 56a:	6402                	ld	s0,0(sp)
 56c:	0141                	addi	sp,sp,16
 56e:	8082                	ret

0000000000000570 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 570:	4885                	li	a7,1
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <exit>:
.global exit
exit:
 li a7, SYS_exit
 578:	4889                	li	a7,2
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <wait>:
.global wait
wait:
 li a7, SYS_wait
 580:	488d                	li	a7,3
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 588:	4891                	li	a7,4
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <read>:
.global read
read:
 li a7, SYS_read
 590:	4895                	li	a7,5
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <write>:
.global write
write:
 li a7, SYS_write
 598:	48c1                	li	a7,16
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <close>:
.global close
close:
 li a7, SYS_close
 5a0:	48d5                	li	a7,21
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 5a8:	4899                	li	a7,6
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b0:	489d                	li	a7,7
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <open>:
.global open
open:
 li a7, SYS_open
 5b8:	48bd                	li	a7,15
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c0:	48c5                	li	a7,17
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5c8:	48c9                	li	a7,18
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d0:	48a1                	li	a7,8
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <link>:
.global link
link:
 li a7, SYS_link
 5d8:	48cd                	li	a7,19
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e0:	48d1                	li	a7,20
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5e8:	48a5                	li	a7,9
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f0:	48a9                	li	a7,10
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5f8:	48ad                	li	a7,11
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 600:	48b1                	li	a7,12
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 608:	48b5                	li	a7,13
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 610:	48b9                	li	a7,14
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 618:	48d9                	li	a7,22
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 620:	48dd                	li	a7,23
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 628:	48e1                	li	a7,24
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <rand>:
.global rand
rand:
 li a7, SYS_rand
 630:	48e5                	li	a7,25
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 638:	48e9                	li	a7,26
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 640:	48ed                	li	a7,27
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 648:	48f1                	li	a7,28
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 650:	48f5                	li	a7,29
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 658:	48f9                	li	a7,30
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 660:	48fd                	li	a7,31
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 668:	1101                	addi	sp,sp,-32
 66a:	ec06                	sd	ra,24(sp)
 66c:	e822                	sd	s0,16(sp)
 66e:	1000                	addi	s0,sp,32
 670:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 674:	4605                	li	a2,1
 676:	fef40593          	addi	a1,s0,-17
 67a:	f1fff0ef          	jal	598 <write>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6105                	addi	sp,sp,32
 684:	8082                	ret

0000000000000686 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 686:	7139                	addi	sp,sp,-64
 688:	fc06                	sd	ra,56(sp)
 68a:	f822                	sd	s0,48(sp)
 68c:	f426                	sd	s1,40(sp)
 68e:	0080                	addi	s0,sp,64
 690:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 692:	c299                	beqz	a3,698 <printint+0x12>
 694:	0805c963          	bltz	a1,726 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 698:	2581                	sext.w	a1,a1
  neg = 0;
 69a:	4881                	li	a7,0
 69c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 6a0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6a2:	2601                	sext.w	a2,a2
 6a4:	00000517          	auipc	a0,0x0
 6a8:	5d450513          	addi	a0,a0,1492 # c78 <digits>
 6ac:	883a                	mv	a6,a4
 6ae:	2705                	addiw	a4,a4,1
 6b0:	02c5f7bb          	remuw	a5,a1,a2
 6b4:	1782                	slli	a5,a5,0x20
 6b6:	9381                	srli	a5,a5,0x20
 6b8:	97aa                	add	a5,a5,a0
 6ba:	0007c783          	lbu	a5,0(a5)
 6be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 6c2:	0005879b          	sext.w	a5,a1
 6c6:	02c5d5bb          	divuw	a1,a1,a2
 6ca:	0685                	addi	a3,a3,1
 6cc:	fec7f0e3          	bgeu	a5,a2,6ac <printint+0x26>
  if(neg)
 6d0:	00088c63          	beqz	a7,6e8 <printint+0x62>
    buf[i++] = '-';
 6d4:	fd070793          	addi	a5,a4,-48
 6d8:	00878733          	add	a4,a5,s0
 6dc:	02d00793          	li	a5,45
 6e0:	fef70823          	sb	a5,-16(a4)
 6e4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 6e8:	02e05a63          	blez	a4,71c <printint+0x96>
 6ec:	f04a                	sd	s2,32(sp)
 6ee:	ec4e                	sd	s3,24(sp)
 6f0:	fc040793          	addi	a5,s0,-64
 6f4:	00e78933          	add	s2,a5,a4
 6f8:	fff78993          	addi	s3,a5,-1
 6fc:	99ba                	add	s3,s3,a4
 6fe:	377d                	addiw	a4,a4,-1
 700:	1702                	slli	a4,a4,0x20
 702:	9301                	srli	a4,a4,0x20
 704:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 708:	fff94583          	lbu	a1,-1(s2)
 70c:	8526                	mv	a0,s1
 70e:	f5bff0ef          	jal	668 <putc>
  while(--i >= 0)
 712:	197d                	addi	s2,s2,-1
 714:	ff391ae3          	bne	s2,s3,708 <printint+0x82>
 718:	7902                	ld	s2,32(sp)
 71a:	69e2                	ld	s3,24(sp)
}
 71c:	70e2                	ld	ra,56(sp)
 71e:	7442                	ld	s0,48(sp)
 720:	74a2                	ld	s1,40(sp)
 722:	6121                	addi	sp,sp,64
 724:	8082                	ret
    x = -xx;
 726:	40b005bb          	negw	a1,a1
    neg = 1;
 72a:	4885                	li	a7,1
    x = -xx;
 72c:	bf85                	j	69c <printint+0x16>

000000000000072e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 72e:	711d                	addi	sp,sp,-96
 730:	ec86                	sd	ra,88(sp)
 732:	e8a2                	sd	s0,80(sp)
 734:	e0ca                	sd	s2,64(sp)
 736:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 738:	0005c903          	lbu	s2,0(a1)
 73c:	26090863          	beqz	s2,9ac <vprintf+0x27e>
 740:	e4a6                	sd	s1,72(sp)
 742:	fc4e                	sd	s3,56(sp)
 744:	f852                	sd	s4,48(sp)
 746:	f456                	sd	s5,40(sp)
 748:	f05a                	sd	s6,32(sp)
 74a:	ec5e                	sd	s7,24(sp)
 74c:	e862                	sd	s8,16(sp)
 74e:	e466                	sd	s9,8(sp)
 750:	8b2a                	mv	s6,a0
 752:	8a2e                	mv	s4,a1
 754:	8bb2                	mv	s7,a2
  state = 0;
 756:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 758:	4481                	li	s1,0
 75a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 75c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 760:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 764:	06c00c93          	li	s9,108
 768:	a005                	j	788 <vprintf+0x5a>
        putc(fd, c0);
 76a:	85ca                	mv	a1,s2
 76c:	855a                	mv	a0,s6
 76e:	efbff0ef          	jal	668 <putc>
 772:	a019                	j	778 <vprintf+0x4a>
    } else if(state == '%'){
 774:	03598263          	beq	s3,s5,798 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 778:	2485                	addiw	s1,s1,1
 77a:	8726                	mv	a4,s1
 77c:	009a07b3          	add	a5,s4,s1
 780:	0007c903          	lbu	s2,0(a5)
 784:	20090c63          	beqz	s2,99c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 788:	0009079b          	sext.w	a5,s2
    if(state == 0){
 78c:	fe0994e3          	bnez	s3,774 <vprintf+0x46>
      if(c0 == '%'){
 790:	fd579de3          	bne	a5,s5,76a <vprintf+0x3c>
        state = '%';
 794:	89be                	mv	s3,a5
 796:	b7cd                	j	778 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 798:	00ea06b3          	add	a3,s4,a4
 79c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 7a0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 7a2:	c681                	beqz	a3,7aa <vprintf+0x7c>
 7a4:	9752                	add	a4,a4,s4
 7a6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 7aa:	03878f63          	beq	a5,s8,7e8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 7ae:	05978963          	beq	a5,s9,800 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 7b2:	07500713          	li	a4,117
 7b6:	0ee78363          	beq	a5,a4,89c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 7ba:	07800713          	li	a4,120
 7be:	12e78563          	beq	a5,a4,8e8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 7c2:	07000713          	li	a4,112
 7c6:	14e78a63          	beq	a5,a4,91a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 7ca:	07300713          	li	a4,115
 7ce:	18e78a63          	beq	a5,a4,962 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 7d2:	02500713          	li	a4,37
 7d6:	04e79563          	bne	a5,a4,820 <vprintf+0xf2>
        putc(fd, '%');
 7da:	02500593          	li	a1,37
 7de:	855a                	mv	a0,s6
 7e0:	e89ff0ef          	jal	668 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	bf49                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 7e8:	008b8913          	addi	s2,s7,8
 7ec:	4685                	li	a3,1
 7ee:	4629                	li	a2,10
 7f0:	000ba583          	lw	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	e91ff0ef          	jal	686 <printint>
 7fa:	8bca                	mv	s7,s2
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	bfad                	j	778 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 800:	06400793          	li	a5,100
 804:	02f68963          	beq	a3,a5,836 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 808:	06c00793          	li	a5,108
 80c:	04f68263          	beq	a3,a5,850 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 810:	07500793          	li	a5,117
 814:	0af68063          	beq	a3,a5,8b4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 818:	07800793          	li	a5,120
 81c:	0ef68263          	beq	a3,a5,900 <vprintf+0x1d2>
        putc(fd, '%');
 820:	02500593          	li	a1,37
 824:	855a                	mv	a0,s6
 826:	e43ff0ef          	jal	668 <putc>
        putc(fd, c0);
 82a:	85ca                	mv	a1,s2
 82c:	855a                	mv	a0,s6
 82e:	e3bff0ef          	jal	668 <putc>
      state = 0;
 832:	4981                	li	s3,0
 834:	b791                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 836:	008b8913          	addi	s2,s7,8
 83a:	4685                	li	a3,1
 83c:	4629                	li	a2,10
 83e:	000ba583          	lw	a1,0(s7)
 842:	855a                	mv	a0,s6
 844:	e43ff0ef          	jal	686 <printint>
        i += 1;
 848:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 84a:	8bca                	mv	s7,s2
      state = 0;
 84c:	4981                	li	s3,0
        i += 1;
 84e:	b72d                	j	778 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 850:	06400793          	li	a5,100
 854:	02f60763          	beq	a2,a5,882 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 858:	07500793          	li	a5,117
 85c:	06f60963          	beq	a2,a5,8ce <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 860:	07800793          	li	a5,120
 864:	faf61ee3          	bne	a2,a5,820 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 868:	008b8913          	addi	s2,s7,8
 86c:	4681                	li	a3,0
 86e:	4641                	li	a2,16
 870:	000ba583          	lw	a1,0(s7)
 874:	855a                	mv	a0,s6
 876:	e11ff0ef          	jal	686 <printint>
        i += 2;
 87a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 87c:	8bca                	mv	s7,s2
      state = 0;
 87e:	4981                	li	s3,0
        i += 2;
 880:	bde5                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 882:	008b8913          	addi	s2,s7,8
 886:	4685                	li	a3,1
 888:	4629                	li	a2,10
 88a:	000ba583          	lw	a1,0(s7)
 88e:	855a                	mv	a0,s6
 890:	df7ff0ef          	jal	686 <printint>
        i += 2;
 894:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 896:	8bca                	mv	s7,s2
      state = 0;
 898:	4981                	li	s3,0
        i += 2;
 89a:	bdf9                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 89c:	008b8913          	addi	s2,s7,8
 8a0:	4681                	li	a3,0
 8a2:	4629                	li	a2,10
 8a4:	000ba583          	lw	a1,0(s7)
 8a8:	855a                	mv	a0,s6
 8aa:	dddff0ef          	jal	686 <printint>
 8ae:	8bca                	mv	s7,s2
      state = 0;
 8b0:	4981                	li	s3,0
 8b2:	b5d9                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8b4:	008b8913          	addi	s2,s7,8
 8b8:	4681                	li	a3,0
 8ba:	4629                	li	a2,10
 8bc:	000ba583          	lw	a1,0(s7)
 8c0:	855a                	mv	a0,s6
 8c2:	dc5ff0ef          	jal	686 <printint>
        i += 1;
 8c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8c8:	8bca                	mv	s7,s2
      state = 0;
 8ca:	4981                	li	s3,0
        i += 1;
 8cc:	b575                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8ce:	008b8913          	addi	s2,s7,8
 8d2:	4681                	li	a3,0
 8d4:	4629                	li	a2,10
 8d6:	000ba583          	lw	a1,0(s7)
 8da:	855a                	mv	a0,s6
 8dc:	dabff0ef          	jal	686 <printint>
        i += 2;
 8e0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 8e2:	8bca                	mv	s7,s2
      state = 0;
 8e4:	4981                	li	s3,0
        i += 2;
 8e6:	bd49                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 8e8:	008b8913          	addi	s2,s7,8
 8ec:	4681                	li	a3,0
 8ee:	4641                	li	a2,16
 8f0:	000ba583          	lw	a1,0(s7)
 8f4:	855a                	mv	a0,s6
 8f6:	d91ff0ef          	jal	686 <printint>
 8fa:	8bca                	mv	s7,s2
      state = 0;
 8fc:	4981                	li	s3,0
 8fe:	bdad                	j	778 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 900:	008b8913          	addi	s2,s7,8
 904:	4681                	li	a3,0
 906:	4641                	li	a2,16
 908:	000ba583          	lw	a1,0(s7)
 90c:	855a                	mv	a0,s6
 90e:	d79ff0ef          	jal	686 <printint>
        i += 1;
 912:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 914:	8bca                	mv	s7,s2
      state = 0;
 916:	4981                	li	s3,0
        i += 1;
 918:	b585                	j	778 <vprintf+0x4a>
 91a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 91c:	008b8d13          	addi	s10,s7,8
 920:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 924:	03000593          	li	a1,48
 928:	855a                	mv	a0,s6
 92a:	d3fff0ef          	jal	668 <putc>
  putc(fd, 'x');
 92e:	07800593          	li	a1,120
 932:	855a                	mv	a0,s6
 934:	d35ff0ef          	jal	668 <putc>
 938:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 93a:	00000b97          	auipc	s7,0x0
 93e:	33eb8b93          	addi	s7,s7,830 # c78 <digits>
 942:	03c9d793          	srli	a5,s3,0x3c
 946:	97de                	add	a5,a5,s7
 948:	0007c583          	lbu	a1,0(a5)
 94c:	855a                	mv	a0,s6
 94e:	d1bff0ef          	jal	668 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 952:	0992                	slli	s3,s3,0x4
 954:	397d                	addiw	s2,s2,-1
 956:	fe0916e3          	bnez	s2,942 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 95a:	8bea                	mv	s7,s10
      state = 0;
 95c:	4981                	li	s3,0
 95e:	6d02                	ld	s10,0(sp)
 960:	bd21                	j	778 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 962:	008b8993          	addi	s3,s7,8
 966:	000bb903          	ld	s2,0(s7)
 96a:	00090f63          	beqz	s2,988 <vprintf+0x25a>
        for(; *s; s++)
 96e:	00094583          	lbu	a1,0(s2)
 972:	c195                	beqz	a1,996 <vprintf+0x268>
          putc(fd, *s);
 974:	855a                	mv	a0,s6
 976:	cf3ff0ef          	jal	668 <putc>
        for(; *s; s++)
 97a:	0905                	addi	s2,s2,1
 97c:	00094583          	lbu	a1,0(s2)
 980:	f9f5                	bnez	a1,974 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 982:	8bce                	mv	s7,s3
      state = 0;
 984:	4981                	li	s3,0
 986:	bbcd                	j	778 <vprintf+0x4a>
          s = "(null)";
 988:	00000917          	auipc	s2,0x0
 98c:	2e890913          	addi	s2,s2,744 # c70 <malloc+0x1dc>
        for(; *s; s++)
 990:	02800593          	li	a1,40
 994:	b7c5                	j	974 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 996:	8bce                	mv	s7,s3
      state = 0;
 998:	4981                	li	s3,0
 99a:	bbf9                	j	778 <vprintf+0x4a>
 99c:	64a6                	ld	s1,72(sp)
 99e:	79e2                	ld	s3,56(sp)
 9a0:	7a42                	ld	s4,48(sp)
 9a2:	7aa2                	ld	s5,40(sp)
 9a4:	7b02                	ld	s6,32(sp)
 9a6:	6be2                	ld	s7,24(sp)
 9a8:	6c42                	ld	s8,16(sp)
 9aa:	6ca2                	ld	s9,8(sp)
    }
  }
}
 9ac:	60e6                	ld	ra,88(sp)
 9ae:	6446                	ld	s0,80(sp)
 9b0:	6906                	ld	s2,64(sp)
 9b2:	6125                	addi	sp,sp,96
 9b4:	8082                	ret

00000000000009b6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 9b6:	715d                	addi	sp,sp,-80
 9b8:	ec06                	sd	ra,24(sp)
 9ba:	e822                	sd	s0,16(sp)
 9bc:	1000                	addi	s0,sp,32
 9be:	e010                	sd	a2,0(s0)
 9c0:	e414                	sd	a3,8(s0)
 9c2:	e818                	sd	a4,16(s0)
 9c4:	ec1c                	sd	a5,24(s0)
 9c6:	03043023          	sd	a6,32(s0)
 9ca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9ce:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9d2:	8622                	mv	a2,s0
 9d4:	d5bff0ef          	jal	72e <vprintf>
}
 9d8:	60e2                	ld	ra,24(sp)
 9da:	6442                	ld	s0,16(sp)
 9dc:	6161                	addi	sp,sp,80
 9de:	8082                	ret

00000000000009e0 <printf>:

void
printf(const char *fmt, ...)
{
 9e0:	711d                	addi	sp,sp,-96
 9e2:	ec06                	sd	ra,24(sp)
 9e4:	e822                	sd	s0,16(sp)
 9e6:	1000                	addi	s0,sp,32
 9e8:	e40c                	sd	a1,8(s0)
 9ea:	e810                	sd	a2,16(s0)
 9ec:	ec14                	sd	a3,24(s0)
 9ee:	f018                	sd	a4,32(s0)
 9f0:	f41c                	sd	a5,40(s0)
 9f2:	03043823          	sd	a6,48(s0)
 9f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9fa:	00840613          	addi	a2,s0,8
 9fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a02:	85aa                	mv	a1,a0
 a04:	4505                	li	a0,1
 a06:	d29ff0ef          	jal	72e <vprintf>
}
 a0a:	60e2                	ld	ra,24(sp)
 a0c:	6442                	ld	s0,16(sp)
 a0e:	6125                	addi	sp,sp,96
 a10:	8082                	ret

0000000000000a12 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a12:	1141                	addi	sp,sp,-16
 a14:	e422                	sd	s0,8(sp)
 a16:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a18:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a1c:	00001797          	auipc	a5,0x1
 a20:	5e47b783          	ld	a5,1508(a5) # 2000 <freep>
 a24:	a02d                	j	a4e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a26:	4618                	lw	a4,8(a2)
 a28:	9f2d                	addw	a4,a4,a1
 a2a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a2e:	6398                	ld	a4,0(a5)
 a30:	6310                	ld	a2,0(a4)
 a32:	a83d                	j	a70 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a34:	ff852703          	lw	a4,-8(a0)
 a38:	9f31                	addw	a4,a4,a2
 a3a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a3c:	ff053683          	ld	a3,-16(a0)
 a40:	a091                	j	a84 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a42:	6398                	ld	a4,0(a5)
 a44:	00e7e463          	bltu	a5,a4,a4c <free+0x3a>
 a48:	00e6ea63          	bltu	a3,a4,a5c <free+0x4a>
{
 a4c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a4e:	fed7fae3          	bgeu	a5,a3,a42 <free+0x30>
 a52:	6398                	ld	a4,0(a5)
 a54:	00e6e463          	bltu	a3,a4,a5c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a58:	fee7eae3          	bltu	a5,a4,a4c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 a5c:	ff852583          	lw	a1,-8(a0)
 a60:	6390                	ld	a2,0(a5)
 a62:	02059813          	slli	a6,a1,0x20
 a66:	01c85713          	srli	a4,a6,0x1c
 a6a:	9736                	add	a4,a4,a3
 a6c:	fae60de3          	beq	a2,a4,a26 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a70:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a74:	4790                	lw	a2,8(a5)
 a76:	02061593          	slli	a1,a2,0x20
 a7a:	01c5d713          	srli	a4,a1,0x1c
 a7e:	973e                	add	a4,a4,a5
 a80:	fae68ae3          	beq	a3,a4,a34 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a84:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a86:	00001717          	auipc	a4,0x1
 a8a:	56f73d23          	sd	a5,1402(a4) # 2000 <freep>
}
 a8e:	6422                	ld	s0,8(sp)
 a90:	0141                	addi	sp,sp,16
 a92:	8082                	ret

0000000000000a94 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a94:	7139                	addi	sp,sp,-64
 a96:	fc06                	sd	ra,56(sp)
 a98:	f822                	sd	s0,48(sp)
 a9a:	f426                	sd	s1,40(sp)
 a9c:	ec4e                	sd	s3,24(sp)
 a9e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 aa0:	02051493          	slli	s1,a0,0x20
 aa4:	9081                	srli	s1,s1,0x20
 aa6:	04bd                	addi	s1,s1,15
 aa8:	8091                	srli	s1,s1,0x4
 aaa:	0014899b          	addiw	s3,s1,1
 aae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 ab0:	00001517          	auipc	a0,0x1
 ab4:	55053503          	ld	a0,1360(a0) # 2000 <freep>
 ab8:	c915                	beqz	a0,aec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 abc:	4798                	lw	a4,8(a5)
 abe:	08977a63          	bgeu	a4,s1,b52 <malloc+0xbe>
 ac2:	f04a                	sd	s2,32(sp)
 ac4:	e852                	sd	s4,16(sp)
 ac6:	e456                	sd	s5,8(sp)
 ac8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 aca:	8a4e                	mv	s4,s3
 acc:	0009871b          	sext.w	a4,s3
 ad0:	6685                	lui	a3,0x1
 ad2:	00d77363          	bgeu	a4,a3,ad8 <malloc+0x44>
 ad6:	6a05                	lui	s4,0x1
 ad8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 adc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ae0:	00001917          	auipc	s2,0x1
 ae4:	52090913          	addi	s2,s2,1312 # 2000 <freep>
  if(p == (char*)-1)
 ae8:	5afd                	li	s5,-1
 aea:	a081                	j	b2a <malloc+0x96>
 aec:	f04a                	sd	s2,32(sp)
 aee:	e852                	sd	s4,16(sp)
 af0:	e456                	sd	s5,8(sp)
 af2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 af4:	00001797          	auipc	a5,0x1
 af8:	51c78793          	addi	a5,a5,1308 # 2010 <base>
 afc:	00001717          	auipc	a4,0x1
 b00:	50f73223          	sd	a5,1284(a4) # 2000 <freep>
 b04:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b06:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b0a:	b7c1                	j	aca <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b0c:	6398                	ld	a4,0(a5)
 b0e:	e118                	sd	a4,0(a0)
 b10:	a8a9                	j	b6a <malloc+0xd6>
  hp->s.size = nu;
 b12:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b16:	0541                	addi	a0,a0,16
 b18:	efbff0ef          	jal	a12 <free>
  return freep;
 b1c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b20:	c12d                	beqz	a0,b82 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b22:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b24:	4798                	lw	a4,8(a5)
 b26:	02977263          	bgeu	a4,s1,b4a <malloc+0xb6>
    if(p == freep)
 b2a:	00093703          	ld	a4,0(s2)
 b2e:	853e                	mv	a0,a5
 b30:	fef719e3          	bne	a4,a5,b22 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b34:	8552                	mv	a0,s4
 b36:	acbff0ef          	jal	600 <sbrk>
  if(p == (char*)-1)
 b3a:	fd551ce3          	bne	a0,s5,b12 <malloc+0x7e>
        return 0;
 b3e:	4501                	li	a0,0
 b40:	7902                	ld	s2,32(sp)
 b42:	6a42                	ld	s4,16(sp)
 b44:	6aa2                	ld	s5,8(sp)
 b46:	6b02                	ld	s6,0(sp)
 b48:	a03d                	j	b76 <malloc+0xe2>
 b4a:	7902                	ld	s2,32(sp)
 b4c:	6a42                	ld	s4,16(sp)
 b4e:	6aa2                	ld	s5,8(sp)
 b50:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b52:	fae48de3          	beq	s1,a4,b0c <malloc+0x78>
        p->s.size -= nunits;
 b56:	4137073b          	subw	a4,a4,s3
 b5a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b5c:	02071693          	slli	a3,a4,0x20
 b60:	01c6d713          	srli	a4,a3,0x1c
 b64:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b66:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b6a:	00001717          	auipc	a4,0x1
 b6e:	48a73b23          	sd	a0,1174(a4) # 2000 <freep>
      return (void*)(p + 1);
 b72:	01078513          	addi	a0,a5,16
  }
}
 b76:	70e2                	ld	ra,56(sp)
 b78:	7442                	ld	s0,48(sp)
 b7a:	74a2                	ld	s1,40(sp)
 b7c:	69e2                	ld	s3,24(sp)
 b7e:	6121                	addi	sp,sp,64
 b80:	8082                	ret
 b82:	7902                	ld	s2,32(sp)
 b84:	6a42                	ld	s4,16(sp)
 b86:	6aa2                	ld	s5,8(sp)
 b88:	6b02                	ld	s6,0(sp)
 b8a:	b7f5                	j	b76 <malloc+0xe2>
