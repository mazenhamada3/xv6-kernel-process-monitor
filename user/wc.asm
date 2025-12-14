
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <countfile>:

#define BUF 512

void
countfile(char *name, int flags, int *total_lines, int *total_words, int *total_chars, int *total_longest)
{
   0:	d6010113          	addi	sp,sp,-672
   4:	28113c23          	sd	ra,664(sp)
   8:	28813823          	sd	s0,656(sp)
   c:	23b13c23          	sd	s11,568(sp)
  10:	1500                	addi	s0,sp,672
  12:	d8a43023          	sd	a0,-640(s0)
  16:	d8b43423          	sd	a1,-632(s0)
  1a:	d6c43c23          	sd	a2,-648(s0)
  1e:	d6d43823          	sd	a3,-656(s0)
  22:	d6e43423          	sd	a4,-664(s0)
  26:	d6f43023          	sd	a5,-672(s0)
  int fd;
  if(strcmp(name, "-") == 0){
  2a:	00001597          	auipc	a1,0x1
  2e:	cc658593          	addi	a1,a1,-826 # cf0 <malloc+0x102>
  32:	464000ef          	jal	496 <strcmp>
  36:	8daa                	mv	s11,a0
  38:	e521                	bnez	a0,80 <countfile+0x80>
  3a:	28913423          	sd	s1,648(sp)
  3e:	29213023          	sd	s2,640(sp)
  42:	27313c23          	sd	s3,632(sp)
  46:	27413823          	sd	s4,624(sp)
  4a:	27513423          	sd	s5,616(sp)
  4e:	27613023          	sd	s6,608(sp)
  52:	25713c23          	sd	s7,600(sp)
  56:	25813823          	sd	s8,592(sp)
  5a:	25913423          	sd	s9,584(sp)
  5e:	25a13023          	sd	s10,576(sp)
  }

  char buf[BUF];
  int n;
  int lines = 0, words = 0, chars = 0, longest = 0, curlen = 0;
  int inword = 0;
  62:	4901                	li	s2,0
  int lines = 0, words = 0, chars = 0, longest = 0, curlen = 0;
  64:	4481                	li	s1,0
  66:	4981                	li	s3,0
  68:	4d01                	li	s10,0
  6a:	4c01                	li	s8,0
  6c:	4a81                	li	s5,0

  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(int i = 0; i < n; i++){
      chars++;
      char c = buf[i];
      if(c == '\n'){
  6e:	4a29                	li	s4,10
        curlen++;
      }
      if(c==' ' || c=='\n' || c=='\t' || c=='\r'){
        if(inword){
          words++;
          inword = 0;
  70:	4b81                	li	s7,0
  72:	02000b13          	li	s6,32
  76:	00800cb7          	lui	s9,0x800
  7a:	0ccd                	addi	s9,s9,19 # 800013 <base+0x7fe003>
  7c:	0ca6                	slli	s9,s9,0x9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  7e:	a09d                	j	e4 <countfile+0xe4>
    fd = open(name, O_RDONLY);
  80:	4581                	li	a1,0
  82:	d8043503          	ld	a0,-640(s0)
  86:	68c000ef          	jal	712 <open>
  8a:	8daa                	mv	s11,a0
    if(fd < 0){
  8c:	fa0557e3          	bgez	a0,3a <countfile+0x3a>
      fprintf(2, "wc: cannot open %s\n", name);
  90:	d8043603          	ld	a2,-640(s0)
  94:	00001597          	auipc	a1,0x1
  98:	c6458593          	addi	a1,a1,-924 # cf8 <malloc+0x10a>
  9c:	4509                	li	a0,2
  9e:	273000ef          	jal	b10 <fprintf>
      return;
  a2:	a271                	j	22e <countfile+0x22e>
        lines++;
  a4:	2a85                	addiw	s5,s5,1
        if(curlen > longest) longest = curlen;
  a6:	87ce                	mv	a5,s3
  a8:	0099d363          	bge	s3,s1,ae <countfile+0xae>
  ac:	87a6                	mv	a5,s1
  ae:	0007899b          	sext.w	s3,a5
        curlen = 0;
  b2:	84de                	mv	s1,s7
        if(inword){
  b4:	00090663          	beqz	s2,c0 <countfile+0xc0>
          words++;
  b8:	2c05                	addiw	s8,s8,1
          inword = 0;
  ba:	895e                	mv	s2,s7
  bc:	a011                	j	c0 <countfile+0xc0>
        curlen++;
  be:	8932                	mv	s2,a2
    for(int i = 0; i < n; i++){
  c0:	0705                	addi	a4,a4,1
  c2:	00e68f63          	beq	a3,a4,e0 <countfile+0xe0>
      char c = buf[i];
  c6:	00074783          	lbu	a5,0(a4)
      if(c == '\n'){
  ca:	fd478de3          	beq	a5,s4,a4 <countfile+0xa4>
        curlen++;
  ce:	2485                	addiw	s1,s1,1
      if(c==' ' || c=='\n' || c=='\t' || c=='\r'){
  d0:	fefb67e3          	bltu	s6,a5,be <countfile+0xbe>
  d4:	00fcd7b3          	srl	a5,s9,a5
  d8:	8b85                	andi	a5,a5,1
  da:	ffe9                	bnez	a5,b4 <countfile+0xb4>
        curlen++;
  dc:	8932                	mv	s2,a2
  de:	b7cd                	j	c0 <countfile+0xc0>
  e0:	00ad0d3b          	addw	s10,s10,a0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  e4:	20000613          	li	a2,512
  e8:	d9040593          	addi	a1,s0,-624
  ec:	856e                	mv	a0,s11
  ee:	5fc000ef          	jal	6ea <read>
  f2:	00a05863          	blez	a0,102 <countfile+0x102>
  f6:	d9040713          	addi	a4,s0,-624
  fa:	00e506b3          	add	a3,a0,a4
        curlen++;
  fe:	4605                	li	a2,1
 100:	b7d9                	j	c6 <countfile+0xc6>
      } else {
        inword = 1;
      }
    }
  }
  if(inword) words++;
 102:	00090363          	beqz	s2,108 <countfile+0x108>
 106:	2c05                	addiw	s8,s8,1

  if(fd != 0) close(fd);
 108:	0c0d9663          	bnez	s11,1d4 <countfile+0x1d4>

  // print depending on flags (flags bitfield: 1->lines,2->words,4->chars,8->longest)
  if((flags & 1) || flags == 0) printf("%d ", lines);
 10c:	d8843703          	ld	a4,-632(s0)
 110:	00177793          	andi	a5,a4,1
 114:	e391                	bnez	a5,118 <countfile+0x118>
 116:	eb01                	bnez	a4,126 <countfile+0x126>
 118:	85d6                	mv	a1,s5
 11a:	00001517          	auipc	a0,0x1
 11e:	bf650513          	addi	a0,a0,-1034 # d10 <malloc+0x122>
 122:	219000ef          	jal	b3a <printf>
  if((flags & 2) || flags == 0) printf("%d ", words);
 126:	d8843703          	ld	a4,-632(s0)
 12a:	00277793          	andi	a5,a4,2
 12e:	e391                	bnez	a5,132 <countfile+0x132>
 130:	e371                	bnez	a4,1f4 <countfile+0x1f4>
 132:	85e2                	mv	a1,s8
 134:	00001517          	auipc	a0,0x1
 138:	bdc50513          	addi	a0,a0,-1060 # d10 <malloc+0x122>
 13c:	1ff000ef          	jal	b3a <printf>
  if((flags & 4) || flags == 0) printf("%d ", chars);
 140:	d8843703          	ld	a4,-632(s0)
 144:	00477793          	andi	a5,a4,4
 148:	ebd1                	bnez	a5,1dc <countfile+0x1dc>
 14a:	eb4d                	bnez	a4,1fc <countfile+0x1fc>
 14c:	85ea                	mv	a1,s10
 14e:	00001517          	auipc	a0,0x1
 152:	bc250513          	addi	a0,a0,-1086 # d10 <malloc+0x122>
 156:	1e5000ef          	jal	b3a <printf>
  if((flags & 8) || flags == 0) printf("%d ", longest);
 15a:	85ce                	mv	a1,s3
 15c:	00001517          	auipc	a0,0x1
 160:	bb450513          	addi	a0,a0,-1100 # d10 <malloc+0x122>
 164:	1d7000ef          	jal	b3a <printf>
  printf("%s\n", name);
 168:	d8043583          	ld	a1,-640(s0)
 16c:	00001517          	auipc	a0,0x1
 170:	b9c50513          	addi	a0,a0,-1124 # d08 <malloc+0x11a>
 174:	1c7000ef          	jal	b3a <printf>

  *total_lines += lines;
 178:	d7843703          	ld	a4,-648(s0)
 17c:	431c                	lw	a5,0(a4)
 17e:	015787bb          	addw	a5,a5,s5
 182:	c31c                	sw	a5,0(a4)
  *total_words += words;
 184:	d7043703          	ld	a4,-656(s0)
 188:	431c                	lw	a5,0(a4)
 18a:	018787bb          	addw	a5,a5,s8
 18e:	c31c                	sw	a5,0(a4)
  *total_chars += chars;
 190:	d6843703          	ld	a4,-664(s0)
 194:	431c                	lw	a5,0(a4)
 196:	01a787bb          	addw	a5,a5,s10
 19a:	c31c                	sw	a5,0(a4)
  if(longest > *total_longest) *total_longest = longest;
 19c:	d6043703          	ld	a4,-672(s0)
 1a0:	431c                	lw	a5,0(a4)
 1a2:	0737d263          	bge	a5,s3,206 <countfile+0x206>
 1a6:	01372023          	sw	s3,0(a4)
 1aa:	28813483          	ld	s1,648(sp)
 1ae:	28013903          	ld	s2,640(sp)
 1b2:	27813983          	ld	s3,632(sp)
 1b6:	27013a03          	ld	s4,624(sp)
 1ba:	26813a83          	ld	s5,616(sp)
 1be:	26013b03          	ld	s6,608(sp)
 1c2:	25813b83          	ld	s7,600(sp)
 1c6:	25013c03          	ld	s8,592(sp)
 1ca:	24813c83          	ld	s9,584(sp)
 1ce:	24013d03          	ld	s10,576(sp)
 1d2:	a8b1                	j	22e <countfile+0x22e>
  if(fd != 0) close(fd);
 1d4:	856e                	mv	a0,s11
 1d6:	524000ef          	jal	6fa <close>
 1da:	bf0d                	j	10c <countfile+0x10c>
  if((flags & 4) || flags == 0) printf("%d ", chars);
 1dc:	85ea                	mv	a1,s10
 1de:	00001517          	auipc	a0,0x1
 1e2:	b3250513          	addi	a0,a0,-1230 # d10 <malloc+0x122>
 1e6:	155000ef          	jal	b3a <printf>
  if((flags & 8) || flags == 0) printf("%d ", longest);
 1ea:	d8843783          	ld	a5,-632(s0)
 1ee:	8ba1                	andi	a5,a5,8
 1f0:	f7ad                	bnez	a5,15a <countfile+0x15a>
 1f2:	bf9d                	j	168 <countfile+0x168>
  if((flags & 4) || flags == 0) printf("%d ", chars);
 1f4:	d8843783          	ld	a5,-632(s0)
 1f8:	8b91                	andi	a5,a5,4
 1fa:	f3ed                	bnez	a5,1dc <countfile+0x1dc>
  if((flags & 8) || flags == 0) printf("%d ", longest);
 1fc:	d8843783          	ld	a5,-632(s0)
 200:	8ba1                	andi	a5,a5,8
 202:	d3bd                	beqz	a5,168 <countfile+0x168>
 204:	bf99                	j	15a <countfile+0x15a>
 206:	28813483          	ld	s1,648(sp)
 20a:	28013903          	ld	s2,640(sp)
 20e:	27813983          	ld	s3,632(sp)
 212:	27013a03          	ld	s4,624(sp)
 216:	26813a83          	ld	s5,616(sp)
 21a:	26013b03          	ld	s6,608(sp)
 21e:	25813b83          	ld	s7,600(sp)
 222:	25013c03          	ld	s8,592(sp)
 226:	24813c83          	ld	s9,584(sp)
 22a:	24013d03          	ld	s10,576(sp)
}
 22e:	29813083          	ld	ra,664(sp)
 232:	29013403          	ld	s0,656(sp)
 236:	23813d83          	ld	s11,568(sp)
 23a:	2a010113          	addi	sp,sp,672
 23e:	8082                	ret

0000000000000240 <main>:

int
main(int argc, char *argv[])
{
 240:	7135                	addi	sp,sp,-160
 242:	ed06                	sd	ra,152(sp)
 244:	e922                	sd	s0,144(sp)
 246:	1100                	addi	s0,sp,160
 248:	f6b43423          	sd	a1,-152(s0)
  int flags = 0; // bit: 1 lines, 2 words, 4 chars, 8 longest
  int idx = 1;
  if(argc < 2){
 24c:	4785                	li	a5,1
 24e:	02a7dd63          	bge	a5,a0,288 <main+0x48>
 252:	e526                	sd	s1,136(sp)
 254:	e14a                	sd	s2,128(sp)
 256:	fcce                	sd	s3,120(sp)
 258:	f8d2                	sd	s4,112(sp)
 25a:	f4d6                	sd	s5,104(sp)
 25c:	f0da                	sd	s6,96(sp)
 25e:	ecde                	sd	s7,88(sp)
 260:	e8e2                	sd	s8,80(sp)
 262:	e4e6                	sd	s9,72(sp)
 264:	e0ea                	sd	s10,64(sp)
 266:	fc6e                	sd	s11,56(sp)
 268:	8d2a                	mv	s10,a0
 26a:	00858c13          	addi	s8,a1,8
  int idx = 1;
 26e:	4c85                	li	s9,1
  int flags = 0; // bit: 1 lines, 2 words, 4 chars, 8 longest
 270:	4981                	li	s3,0
    countfile("-", 0, &tl,&tw,&tc,&tL);
    exit(0);
  }

  // parse options that start with '-' and have letters
  while(idx < argc && argv[idx][0] == '-' && argv[idx][1] != '\0'){
 272:	02d00d93          	li	s11,45
    if(strcmp(argv[idx], "-") == 0) break;
    for(int i = 1; argv[idx][i]; i++){
      char c = argv[idx][i];
      if(c == 'l') flags |= 1;
 276:	06c00a13          	li	s4,108
      else if(c == 'w') flags |= 2;
 27a:	07700a93          	li	s5,119
      else if(c == 'c') flags |= 4;
 27e:	06300b13          	li	s6,99
      else if(c == 'L') flags |= 8;
 282:	04c00b93          	li	s7,76
 286:	a861                	j	31e <main+0xde>
 288:	e526                	sd	s1,136(sp)
 28a:	e14a                	sd	s2,128(sp)
 28c:	fcce                	sd	s3,120(sp)
 28e:	f8d2                	sd	s4,112(sp)
 290:	f4d6                	sd	s5,104(sp)
 292:	f0da                	sd	s6,96(sp)
 294:	ecde                	sd	s7,88(sp)
 296:	e8e2                	sd	s8,80(sp)
 298:	e4e6                	sd	s9,72(sp)
 29a:	e0ea                	sd	s10,64(sp)
 29c:	fc6e                	sd	s11,56(sp)
    int tl=0,tw=0,tc=0,tL=0;
 29e:	f6042823          	sw	zero,-144(s0)
 2a2:	f6042a23          	sw	zero,-140(s0)
 2a6:	f6042c23          	sw	zero,-136(s0)
 2aa:	f6042e23          	sw	zero,-132(s0)
    countfile("-", 0, &tl,&tw,&tc,&tL);
 2ae:	f7c40793          	addi	a5,s0,-132
 2b2:	f7840713          	addi	a4,s0,-136
 2b6:	f7440693          	addi	a3,s0,-140
 2ba:	f7040613          	addi	a2,s0,-144
 2be:	4581                	li	a1,0
 2c0:	00001517          	auipc	a0,0x1
 2c4:	a3050513          	addi	a0,a0,-1488 # cf0 <malloc+0x102>
 2c8:	d39ff0ef          	jal	0 <countfile>
    exit(0);
 2cc:	4501                	li	a0,0
 2ce:	404000ef          	jal	6d2 <exit>
      if(c == 'l') flags |= 1;
 2d2:	0019e993          	ori	s3,s3,1
    for(int i = 1; argv[idx][i]; i++){
 2d6:	0905                	addi	s2,s2,1
 2d8:	fff94483          	lbu	s1,-1(s2)
 2dc:	cc8d                	beqz	s1,316 <main+0xd6>
      if(c == 'l') flags |= 1;
 2de:	ff448ae3          	beq	s1,s4,2d2 <main+0x92>
      else if(c == 'w') flags |= 2;
 2e2:	01548963          	beq	s1,s5,2f4 <main+0xb4>
      else if(c == 'c') flags |= 4;
 2e6:	01648a63          	beq	s1,s6,2fa <main+0xba>
      else if(c == 'L') flags |= 8;
 2ea:	01749b63          	bne	s1,s7,300 <main+0xc0>
 2ee:	0089e993          	ori	s3,s3,8
 2f2:	b7d5                	j	2d6 <main+0x96>
      else if(c == 'w') flags |= 2;
 2f4:	0029e993          	ori	s3,s3,2
 2f8:	bff9                	j	2d6 <main+0x96>
      else if(c == 'c') flags |= 4;
 2fa:	0049e993          	ori	s3,s3,4
 2fe:	bfe1                	j	2d6 <main+0x96>
      else {
        fprintf(2, "wc: unknown flag -%c\n", c);
 300:	8626                	mv	a2,s1
 302:	00001597          	auipc	a1,0x1
 306:	a1658593          	addi	a1,a1,-1514 # d18 <malloc+0x12a>
 30a:	4509                	li	a0,2
 30c:	005000ef          	jal	b10 <fprintf>
        exit(1);
 310:	4505                	li	a0,1
 312:	3c0000ef          	jal	6d2 <exit>
      }
    }
    idx++;
 316:	2c85                	addiw	s9,s9,1
  while(idx < argc && argv[idx][0] == '-' && argv[idx][1] != '\0'){
 318:	0c21                	addi	s8,s8,8
 31a:	0f9d0863          	beq	s10,s9,40a <main+0x1ca>
 31e:	000c3903          	ld	s2,0(s8)
 322:	00094783          	lbu	a5,0(s2)
 326:	01b79f63          	bne	a5,s11,344 <main+0x104>
 32a:	00194483          	lbu	s1,1(s2)
 32e:	c899                	beqz	s1,344 <main+0x104>
    if(strcmp(argv[idx], "-") == 0) break;
 330:	00001597          	auipc	a1,0x1
 334:	9c058593          	addi	a1,a1,-1600 # cf0 <malloc+0x102>
 338:	854a                	mv	a0,s2
 33a:	15c000ef          	jal	496 <strcmp>
 33e:	c119                	beqz	a0,344 <main+0x104>
    for(int i = 1; argv[idx][i]; i++){
 340:	0909                	addi	s2,s2,2
 342:	bf71                	j	2de <main+0x9e>
  }

  if(idx >= argc){
 344:	0dacd363          	bge	s9,s10,40a <main+0x1ca>
    int tl=0,tw=0,tc=0,tL=0;
    countfile("-", flags, &tl,&tw,&tc,&tL);
    exit(0);
  }

  int total_lines=0, total_words=0, total_chars=0, total_longest=0;
 348:	f8042623          	sw	zero,-116(s0)
 34c:	f8042423          	sw	zero,-120(s0)
 350:	f8042223          	sw	zero,-124(s0)
 354:	f8042023          	sw	zero,-128(s0)
  int files = 0;
  for(int i = idx; i < argc; i++){
 358:	003c9493          	slli	s1,s9,0x3
 35c:	f6843703          	ld	a4,-152(s0)
 360:	94ba                	add	s1,s1,a4
 362:	419d0d3b          	subw	s10,s10,s9
 366:	020d1793          	slli	a5,s10,0x20
 36a:	9381                	srli	a5,a5,0x20
 36c:	97e6                	add	a5,a5,s9
 36e:	078e                	slli	a5,a5,0x3
 370:	00f70933          	add	s2,a4,a5
    countfile(argv[i], flags, &total_lines, &total_words, &total_chars, &total_longest);
 374:	f8040793          	addi	a5,s0,-128
 378:	f8440713          	addi	a4,s0,-124
 37c:	f8840693          	addi	a3,s0,-120
 380:	f8c40613          	addi	a2,s0,-116
 384:	85ce                	mv	a1,s3
 386:	6088                	ld	a0,0(s1)
 388:	c79ff0ef          	jal	0 <countfile>
  for(int i = idx; i < argc; i++){
 38c:	04a1                	addi	s1,s1,8
 38e:	ff2493e3          	bne	s1,s2,374 <main+0x134>
    files++;
  }

  if(files > 1){
 392:	2d01                	sext.w	s10,s10
 394:	4785                	li	a5,1
 396:	07a7d763          	bge	a5,s10,404 <main+0x1c4>
    // print totals
    if((flags & 1) || flags == 0) printf("%d ", total_lines);
 39a:	0019f793          	andi	a5,s3,1
 39e:	e399                	bnez	a5,3a4 <main+0x164>
 3a0:	00099a63          	bnez	s3,3b4 <main+0x174>
 3a4:	f8c42583          	lw	a1,-116(s0)
 3a8:	00001517          	auipc	a0,0x1
 3ac:	96850513          	addi	a0,a0,-1688 # d10 <malloc+0x122>
 3b0:	78a000ef          	jal	b3a <printf>
    if((flags & 2) || flags == 0) printf("%d ", total_words);
 3b4:	0029f793          	andi	a5,s3,2
 3b8:	e399                	bnez	a5,3be <main+0x17e>
 3ba:	08099f63          	bnez	s3,458 <main+0x218>
 3be:	f8842583          	lw	a1,-120(s0)
 3c2:	00001517          	auipc	a0,0x1
 3c6:	94e50513          	addi	a0,a0,-1714 # d10 <malloc+0x122>
 3ca:	770000ef          	jal	b3a <printf>
    if((flags & 4) || flags == 0) printf("%d ", total_chars);
 3ce:	0049f793          	andi	a5,s3,4
 3d2:	e7b5                	bnez	a5,43e <main+0x1fe>
 3d4:	08099563          	bnez	s3,45e <main+0x21e>
 3d8:	f8442583          	lw	a1,-124(s0)
 3dc:	00001517          	auipc	a0,0x1
 3e0:	93450513          	addi	a0,a0,-1740 # d10 <malloc+0x122>
 3e4:	756000ef          	jal	b3a <printf>
    if((flags & 8) || flags == 0) printf("%d ", total_longest);
 3e8:	f8042583          	lw	a1,-128(s0)
 3ec:	00001517          	auipc	a0,0x1
 3f0:	92450513          	addi	a0,a0,-1756 # d10 <malloc+0x122>
 3f4:	746000ef          	jal	b3a <printf>
    printf("total\n");
 3f8:	00001517          	auipc	a0,0x1
 3fc:	93850513          	addi	a0,a0,-1736 # d30 <malloc+0x142>
 400:	73a000ef          	jal	b3a <printf>
  }
  exit(0);
 404:	4501                	li	a0,0
 406:	2cc000ef          	jal	6d2 <exit>
    int tl=0,tw=0,tc=0,tL=0;
 40a:	f6042823          	sw	zero,-144(s0)
 40e:	f6042a23          	sw	zero,-140(s0)
 412:	f6042c23          	sw	zero,-136(s0)
 416:	f6042e23          	sw	zero,-132(s0)
    countfile("-", flags, &tl,&tw,&tc,&tL);
 41a:	f7c40793          	addi	a5,s0,-132
 41e:	f7840713          	addi	a4,s0,-136
 422:	f7440693          	addi	a3,s0,-140
 426:	f7040613          	addi	a2,s0,-144
 42a:	85ce                	mv	a1,s3
 42c:	00001517          	auipc	a0,0x1
 430:	8c450513          	addi	a0,a0,-1852 # cf0 <malloc+0x102>
 434:	bcdff0ef          	jal	0 <countfile>
    exit(0);
 438:	4501                	li	a0,0
 43a:	298000ef          	jal	6d2 <exit>
    if((flags & 4) || flags == 0) printf("%d ", total_chars);
 43e:	f8442583          	lw	a1,-124(s0)
 442:	00001517          	auipc	a0,0x1
 446:	8ce50513          	addi	a0,a0,-1842 # d10 <malloc+0x122>
 44a:	6f0000ef          	jal	b3a <printf>
    if((flags & 8) || flags == 0) printf("%d ", total_longest);
 44e:	0089f993          	andi	s3,s3,8
 452:	f8099be3          	bnez	s3,3e8 <main+0x1a8>
 456:	b74d                	j	3f8 <main+0x1b8>
    if((flags & 4) || flags == 0) printf("%d ", total_chars);
 458:	0049f793          	andi	a5,s3,4
 45c:	f3ed                	bnez	a5,43e <main+0x1fe>
    if((flags & 8) || flags == 0) printf("%d ", total_longest);
 45e:	0089f993          	andi	s3,s3,8
 462:	f8098be3          	beqz	s3,3f8 <main+0x1b8>
 466:	b749                	j	3e8 <main+0x1a8>

0000000000000468 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 468:	1141                	addi	sp,sp,-16
 46a:	e406                	sd	ra,8(sp)
 46c:	e022                	sd	s0,0(sp)
 46e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 470:	dd1ff0ef          	jal	240 <main>
  exit(0);
 474:	4501                	li	a0,0
 476:	25c000ef          	jal	6d2 <exit>

000000000000047a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 480:	87aa                	mv	a5,a0
 482:	0585                	addi	a1,a1,1
 484:	0785                	addi	a5,a5,1
 486:	fff5c703          	lbu	a4,-1(a1)
 48a:	fee78fa3          	sb	a4,-1(a5)
 48e:	fb75                	bnez	a4,482 <strcpy+0x8>
    ;
  return os;
}
 490:	6422                	ld	s0,8(sp)
 492:	0141                	addi	sp,sp,16
 494:	8082                	ret

0000000000000496 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 496:	1141                	addi	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 49c:	00054783          	lbu	a5,0(a0)
 4a0:	cb91                	beqz	a5,4b4 <strcmp+0x1e>
 4a2:	0005c703          	lbu	a4,0(a1)
 4a6:	00f71763          	bne	a4,a5,4b4 <strcmp+0x1e>
    p++, q++;
 4aa:	0505                	addi	a0,a0,1
 4ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4ae:	00054783          	lbu	a5,0(a0)
 4b2:	fbe5                	bnez	a5,4a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 4b4:	0005c503          	lbu	a0,0(a1)
}
 4b8:	40a7853b          	subw	a0,a5,a0
 4bc:	6422                	ld	s0,8(sp)
 4be:	0141                	addi	sp,sp,16
 4c0:	8082                	ret

00000000000004c2 <strlen>:

uint
strlen(const char *s)
{
 4c2:	1141                	addi	sp,sp,-16
 4c4:	e422                	sd	s0,8(sp)
 4c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4c8:	00054783          	lbu	a5,0(a0)
 4cc:	cf91                	beqz	a5,4e8 <strlen+0x26>
 4ce:	0505                	addi	a0,a0,1
 4d0:	87aa                	mv	a5,a0
 4d2:	86be                	mv	a3,a5
 4d4:	0785                	addi	a5,a5,1
 4d6:	fff7c703          	lbu	a4,-1(a5)
 4da:	ff65                	bnez	a4,4d2 <strlen+0x10>
 4dc:	40a6853b          	subw	a0,a3,a0
 4e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 4e2:	6422                	ld	s0,8(sp)
 4e4:	0141                	addi	sp,sp,16
 4e6:	8082                	ret
  for(n = 0; s[n]; n++)
 4e8:	4501                	li	a0,0
 4ea:	bfe5                	j	4e2 <strlen+0x20>

00000000000004ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 4ec:	1141                	addi	sp,sp,-16
 4ee:	e422                	sd	s0,8(sp)
 4f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 4f2:	ca19                	beqz	a2,508 <memset+0x1c>
 4f4:	87aa                	mv	a5,a0
 4f6:	1602                	slli	a2,a2,0x20
 4f8:	9201                	srli	a2,a2,0x20
 4fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 4fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 502:	0785                	addi	a5,a5,1
 504:	fee79de3          	bne	a5,a4,4fe <memset+0x12>
  }
  return dst;
}
 508:	6422                	ld	s0,8(sp)
 50a:	0141                	addi	sp,sp,16
 50c:	8082                	ret

000000000000050e <strchr>:

char*
strchr(const char *s, char c)
{
 50e:	1141                	addi	sp,sp,-16
 510:	e422                	sd	s0,8(sp)
 512:	0800                	addi	s0,sp,16
  for(; *s; s++)
 514:	00054783          	lbu	a5,0(a0)
 518:	cb99                	beqz	a5,52e <strchr+0x20>
    if(*s == c)
 51a:	00f58763          	beq	a1,a5,528 <strchr+0x1a>
  for(; *s; s++)
 51e:	0505                	addi	a0,a0,1
 520:	00054783          	lbu	a5,0(a0)
 524:	fbfd                	bnez	a5,51a <strchr+0xc>
      return (char*)s;
  return 0;
 526:	4501                	li	a0,0
}
 528:	6422                	ld	s0,8(sp)
 52a:	0141                	addi	sp,sp,16
 52c:	8082                	ret
  return 0;
 52e:	4501                	li	a0,0
 530:	bfe5                	j	528 <strchr+0x1a>

0000000000000532 <gets>:

char*
gets(char *buf, int max)
{
 532:	711d                	addi	sp,sp,-96
 534:	ec86                	sd	ra,88(sp)
 536:	e8a2                	sd	s0,80(sp)
 538:	e4a6                	sd	s1,72(sp)
 53a:	e0ca                	sd	s2,64(sp)
 53c:	fc4e                	sd	s3,56(sp)
 53e:	f852                	sd	s4,48(sp)
 540:	f456                	sd	s5,40(sp)
 542:	f05a                	sd	s6,32(sp)
 544:	ec5e                	sd	s7,24(sp)
 546:	1080                	addi	s0,sp,96
 548:	8baa                	mv	s7,a0
 54a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 54c:	892a                	mv	s2,a0
 54e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 550:	4aa9                	li	s5,10
 552:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 554:	89a6                	mv	s3,s1
 556:	2485                	addiw	s1,s1,1
 558:	0344d663          	bge	s1,s4,584 <gets+0x52>
    cc = read(0, &c, 1);
 55c:	4605                	li	a2,1
 55e:	faf40593          	addi	a1,s0,-81
 562:	4501                	li	a0,0
 564:	186000ef          	jal	6ea <read>
    if(cc < 1)
 568:	00a05e63          	blez	a0,584 <gets+0x52>
    buf[i++] = c;
 56c:	faf44783          	lbu	a5,-81(s0)
 570:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 574:	01578763          	beq	a5,s5,582 <gets+0x50>
 578:	0905                	addi	s2,s2,1
 57a:	fd679de3          	bne	a5,s6,554 <gets+0x22>
    buf[i++] = c;
 57e:	89a6                	mv	s3,s1
 580:	a011                	j	584 <gets+0x52>
 582:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 584:	99de                	add	s3,s3,s7
 586:	00098023          	sb	zero,0(s3)
  return buf;
}
 58a:	855e                	mv	a0,s7
 58c:	60e6                	ld	ra,88(sp)
 58e:	6446                	ld	s0,80(sp)
 590:	64a6                	ld	s1,72(sp)
 592:	6906                	ld	s2,64(sp)
 594:	79e2                	ld	s3,56(sp)
 596:	7a42                	ld	s4,48(sp)
 598:	7aa2                	ld	s5,40(sp)
 59a:	7b02                	ld	s6,32(sp)
 59c:	6be2                	ld	s7,24(sp)
 59e:	6125                	addi	sp,sp,96
 5a0:	8082                	ret

00000000000005a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 5a2:	1101                	addi	sp,sp,-32
 5a4:	ec06                	sd	ra,24(sp)
 5a6:	e822                	sd	s0,16(sp)
 5a8:	e04a                	sd	s2,0(sp)
 5aa:	1000                	addi	s0,sp,32
 5ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5ae:	4581                	li	a1,0
 5b0:	162000ef          	jal	712 <open>
  if(fd < 0)
 5b4:	02054263          	bltz	a0,5d8 <stat+0x36>
 5b8:	e426                	sd	s1,8(sp)
 5ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5bc:	85ca                	mv	a1,s2
 5be:	16c000ef          	jal	72a <fstat>
 5c2:	892a                	mv	s2,a0
  close(fd);
 5c4:	8526                	mv	a0,s1
 5c6:	134000ef          	jal	6fa <close>
  return r;
 5ca:	64a2                	ld	s1,8(sp)
}
 5cc:	854a                	mv	a0,s2
 5ce:	60e2                	ld	ra,24(sp)
 5d0:	6442                	ld	s0,16(sp)
 5d2:	6902                	ld	s2,0(sp)
 5d4:	6105                	addi	sp,sp,32
 5d6:	8082                	ret
    return -1;
 5d8:	597d                	li	s2,-1
 5da:	bfcd                	j	5cc <stat+0x2a>

00000000000005dc <atoi>:

int
atoi(const char *s)
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e422                	sd	s0,8(sp)
 5e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 5e2:	00054683          	lbu	a3,0(a0)
 5e6:	fd06879b          	addiw	a5,a3,-48
 5ea:	0ff7f793          	zext.b	a5,a5
 5ee:	4625                	li	a2,9
 5f0:	02f66863          	bltu	a2,a5,620 <atoi+0x44>
 5f4:	872a                	mv	a4,a0
  n = 0;
 5f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 5f8:	0705                	addi	a4,a4,1
 5fa:	0025179b          	slliw	a5,a0,0x2
 5fe:	9fa9                	addw	a5,a5,a0
 600:	0017979b          	slliw	a5,a5,0x1
 604:	9fb5                	addw	a5,a5,a3
 606:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 60a:	00074683          	lbu	a3,0(a4)
 60e:	fd06879b          	addiw	a5,a3,-48
 612:	0ff7f793          	zext.b	a5,a5
 616:	fef671e3          	bgeu	a2,a5,5f8 <atoi+0x1c>
  return n;
}
 61a:	6422                	ld	s0,8(sp)
 61c:	0141                	addi	sp,sp,16
 61e:	8082                	ret
  n = 0;
 620:	4501                	li	a0,0
 622:	bfe5                	j	61a <atoi+0x3e>

0000000000000624 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 624:	1141                	addi	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 62a:	02b57463          	bgeu	a0,a1,652 <memmove+0x2e>
    while(n-- > 0)
 62e:	00c05f63          	blez	a2,64c <memmove+0x28>
 632:	1602                	slli	a2,a2,0x20
 634:	9201                	srli	a2,a2,0x20
 636:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 63a:	872a                	mv	a4,a0
      *dst++ = *src++;
 63c:	0585                	addi	a1,a1,1
 63e:	0705                	addi	a4,a4,1
 640:	fff5c683          	lbu	a3,-1(a1)
 644:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 648:	fef71ae3          	bne	a4,a5,63c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 64c:	6422                	ld	s0,8(sp)
 64e:	0141                	addi	sp,sp,16
 650:	8082                	ret
    dst += n;
 652:	00c50733          	add	a4,a0,a2
    src += n;
 656:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 658:	fec05ae3          	blez	a2,64c <memmove+0x28>
 65c:	fff6079b          	addiw	a5,a2,-1
 660:	1782                	slli	a5,a5,0x20
 662:	9381                	srli	a5,a5,0x20
 664:	fff7c793          	not	a5,a5
 668:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 66a:	15fd                	addi	a1,a1,-1
 66c:	177d                	addi	a4,a4,-1
 66e:	0005c683          	lbu	a3,0(a1)
 672:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 676:	fee79ae3          	bne	a5,a4,66a <memmove+0x46>
 67a:	bfc9                	j	64c <memmove+0x28>

000000000000067c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 67c:	1141                	addi	sp,sp,-16
 67e:	e422                	sd	s0,8(sp)
 680:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 682:	ca05                	beqz	a2,6b2 <memcmp+0x36>
 684:	fff6069b          	addiw	a3,a2,-1
 688:	1682                	slli	a3,a3,0x20
 68a:	9281                	srli	a3,a3,0x20
 68c:	0685                	addi	a3,a3,1
 68e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 690:	00054783          	lbu	a5,0(a0)
 694:	0005c703          	lbu	a4,0(a1)
 698:	00e79863          	bne	a5,a4,6a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 69c:	0505                	addi	a0,a0,1
    p2++;
 69e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6a0:	fed518e3          	bne	a0,a3,690 <memcmp+0x14>
  }
  return 0;
 6a4:	4501                	li	a0,0
 6a6:	a019                	j	6ac <memcmp+0x30>
      return *p1 - *p2;
 6a8:	40e7853b          	subw	a0,a5,a4
}
 6ac:	6422                	ld	s0,8(sp)
 6ae:	0141                	addi	sp,sp,16
 6b0:	8082                	ret
  return 0;
 6b2:	4501                	li	a0,0
 6b4:	bfe5                	j	6ac <memcmp+0x30>

00000000000006b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 6be:	f67ff0ef          	jal	624 <memmove>
}
 6c2:	60a2                	ld	ra,8(sp)
 6c4:	6402                	ld	s0,0(sp)
 6c6:	0141                	addi	sp,sp,16
 6c8:	8082                	ret

00000000000006ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 6ca:	4885                	li	a7,1
 ecall
 6cc:	00000073          	ecall
 ret
 6d0:	8082                	ret

00000000000006d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 6d2:	4889                	li	a7,2
 ecall
 6d4:	00000073          	ecall
 ret
 6d8:	8082                	ret

00000000000006da <wait>:
.global wait
wait:
 li a7, SYS_wait
 6da:	488d                	li	a7,3
 ecall
 6dc:	00000073          	ecall
 ret
 6e0:	8082                	ret

00000000000006e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 6e2:	4891                	li	a7,4
 ecall
 6e4:	00000073          	ecall
 ret
 6e8:	8082                	ret

00000000000006ea <read>:
.global read
read:
 li a7, SYS_read
 6ea:	4895                	li	a7,5
 ecall
 6ec:	00000073          	ecall
 ret
 6f0:	8082                	ret

00000000000006f2 <write>:
.global write
write:
 li a7, SYS_write
 6f2:	48c1                	li	a7,16
 ecall
 6f4:	00000073          	ecall
 ret
 6f8:	8082                	ret

00000000000006fa <close>:
.global close
close:
 li a7, SYS_close
 6fa:	48d5                	li	a7,21
 ecall
 6fc:	00000073          	ecall
 ret
 700:	8082                	ret

0000000000000702 <kill>:
.global kill
kill:
 li a7, SYS_kill
 702:	4899                	li	a7,6
 ecall
 704:	00000073          	ecall
 ret
 708:	8082                	ret

000000000000070a <exec>:
.global exec
exec:
 li a7, SYS_exec
 70a:	489d                	li	a7,7
 ecall
 70c:	00000073          	ecall
 ret
 710:	8082                	ret

0000000000000712 <open>:
.global open
open:
 li a7, SYS_open
 712:	48bd                	li	a7,15
 ecall
 714:	00000073          	ecall
 ret
 718:	8082                	ret

000000000000071a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 71a:	48c5                	li	a7,17
 ecall
 71c:	00000073          	ecall
 ret
 720:	8082                	ret

0000000000000722 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 722:	48c9                	li	a7,18
 ecall
 724:	00000073          	ecall
 ret
 728:	8082                	ret

000000000000072a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 72a:	48a1                	li	a7,8
 ecall
 72c:	00000073          	ecall
 ret
 730:	8082                	ret

0000000000000732 <link>:
.global link
link:
 li a7, SYS_link
 732:	48cd                	li	a7,19
 ecall
 734:	00000073          	ecall
 ret
 738:	8082                	ret

000000000000073a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 73a:	48d1                	li	a7,20
 ecall
 73c:	00000073          	ecall
 ret
 740:	8082                	ret

0000000000000742 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 742:	48a5                	li	a7,9
 ecall
 744:	00000073          	ecall
 ret
 748:	8082                	ret

000000000000074a <dup>:
.global dup
dup:
 li a7, SYS_dup
 74a:	48a9                	li	a7,10
 ecall
 74c:	00000073          	ecall
 ret
 750:	8082                	ret

0000000000000752 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 752:	48ad                	li	a7,11
 ecall
 754:	00000073          	ecall
 ret
 758:	8082                	ret

000000000000075a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 75a:	48b1                	li	a7,12
 ecall
 75c:	00000073          	ecall
 ret
 760:	8082                	ret

0000000000000762 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 762:	48b5                	li	a7,13
 ecall
 764:	00000073          	ecall
 ret
 768:	8082                	ret

000000000000076a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 76a:	48b9                	li	a7,14
 ecall
 76c:	00000073          	ecall
 ret
 770:	8082                	ret

0000000000000772 <kbdint>:
.global kbdint
kbdint:
 li a7, SYS_kbdint
 772:	48d9                	li	a7,22
 ecall
 774:	00000073          	ecall
 ret
 778:	8082                	ret

000000000000077a <countsyscall>:
.global countsyscall
countsyscall:
 li a7, SYS_countsyscall
 77a:	48dd                	li	a7,23
 ecall
 77c:	00000073          	ecall
 ret
 780:	8082                	ret

0000000000000782 <getppid>:
.global getppid
getppid:
 li a7, SYS_getppid
 782:	48e1                	li	a7,24
 ecall
 784:	00000073          	ecall
 ret
 788:	8082                	ret

000000000000078a <rand>:
.global rand
rand:
 li a7, SYS_rand
 78a:	48e5                	li	a7,25
 ecall
 78c:	00000073          	ecall
 ret
 790:	8082                	ret

0000000000000792 <shutdown>:
.global shutdown
shutdown:
 li a7, SYS_shutdown
 792:	48e9                	li	a7,26
 ecall
 794:	00000073          	ecall
 ret
 798:	8082                	ret

000000000000079a <datetime>:
.global datetime
datetime:
 li a7, SYS_datetime
 79a:	48ed                	li	a7,27
 ecall
 79c:	00000073          	ecall
 ret
 7a0:	8082                	ret

00000000000007a2 <getptable>:
.global getptable
getptable:
 li a7, SYS_getptable
 7a2:	48f1                	li	a7,28
 ecall
 7a4:	00000073          	ecall
 ret
 7a8:	8082                	ret

00000000000007aa <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 7aa:	48f5                	li	a7,29
 ecall
 7ac:	00000073          	ecall
 ret
 7b0:	8082                	ret

00000000000007b2 <setscheduler>:
.global setscheduler
setscheduler:
 li a7, SYS_setscheduler
 7b2:	48f9                	li	a7,30
 ecall
 7b4:	00000073          	ecall
 ret
 7b8:	8082                	ret

00000000000007ba <getmetrics>:
.global getmetrics
getmetrics:
 li a7, SYS_getmetrics
 7ba:	48fd                	li	a7,31
 ecall
 7bc:	00000073          	ecall
 ret
 7c0:	8082                	ret

00000000000007c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7c2:	1101                	addi	sp,sp,-32
 7c4:	ec06                	sd	ra,24(sp)
 7c6:	e822                	sd	s0,16(sp)
 7c8:	1000                	addi	s0,sp,32
 7ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7ce:	4605                	li	a2,1
 7d0:	fef40593          	addi	a1,s0,-17
 7d4:	f1fff0ef          	jal	6f2 <write>
}
 7d8:	60e2                	ld	ra,24(sp)
 7da:	6442                	ld	s0,16(sp)
 7dc:	6105                	addi	sp,sp,32
 7de:	8082                	ret

00000000000007e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7e0:	7139                	addi	sp,sp,-64
 7e2:	fc06                	sd	ra,56(sp)
 7e4:	f822                	sd	s0,48(sp)
 7e6:	f426                	sd	s1,40(sp)
 7e8:	0080                	addi	s0,sp,64
 7ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 7ec:	c299                	beqz	a3,7f2 <printint+0x12>
 7ee:	0805c963          	bltz	a1,880 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 7f2:	2581                	sext.w	a1,a1
  neg = 0;
 7f4:	4881                	li	a7,0
 7f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 7fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 7fc:	2601                	sext.w	a2,a2
 7fe:	00000517          	auipc	a0,0x0
 802:	54250513          	addi	a0,a0,1346 # d40 <digits>
 806:	883a                	mv	a6,a4
 808:	2705                	addiw	a4,a4,1
 80a:	02c5f7bb          	remuw	a5,a1,a2
 80e:	1782                	slli	a5,a5,0x20
 810:	9381                	srli	a5,a5,0x20
 812:	97aa                	add	a5,a5,a0
 814:	0007c783          	lbu	a5,0(a5)
 818:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 81c:	0005879b          	sext.w	a5,a1
 820:	02c5d5bb          	divuw	a1,a1,a2
 824:	0685                	addi	a3,a3,1
 826:	fec7f0e3          	bgeu	a5,a2,806 <printint+0x26>
  if(neg)
 82a:	00088c63          	beqz	a7,842 <printint+0x62>
    buf[i++] = '-';
 82e:	fd070793          	addi	a5,a4,-48
 832:	00878733          	add	a4,a5,s0
 836:	02d00793          	li	a5,45
 83a:	fef70823          	sb	a5,-16(a4)
 83e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 842:	02e05a63          	blez	a4,876 <printint+0x96>
 846:	f04a                	sd	s2,32(sp)
 848:	ec4e                	sd	s3,24(sp)
 84a:	fc040793          	addi	a5,s0,-64
 84e:	00e78933          	add	s2,a5,a4
 852:	fff78993          	addi	s3,a5,-1
 856:	99ba                	add	s3,s3,a4
 858:	377d                	addiw	a4,a4,-1
 85a:	1702                	slli	a4,a4,0x20
 85c:	9301                	srli	a4,a4,0x20
 85e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 862:	fff94583          	lbu	a1,-1(s2)
 866:	8526                	mv	a0,s1
 868:	f5bff0ef          	jal	7c2 <putc>
  while(--i >= 0)
 86c:	197d                	addi	s2,s2,-1
 86e:	ff391ae3          	bne	s2,s3,862 <printint+0x82>
 872:	7902                	ld	s2,32(sp)
 874:	69e2                	ld	s3,24(sp)
}
 876:	70e2                	ld	ra,56(sp)
 878:	7442                	ld	s0,48(sp)
 87a:	74a2                	ld	s1,40(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
    x = -xx;
 880:	40b005bb          	negw	a1,a1
    neg = 1;
 884:	4885                	li	a7,1
    x = -xx;
 886:	bf85                	j	7f6 <printint+0x16>

0000000000000888 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 888:	711d                	addi	sp,sp,-96
 88a:	ec86                	sd	ra,88(sp)
 88c:	e8a2                	sd	s0,80(sp)
 88e:	e0ca                	sd	s2,64(sp)
 890:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 892:	0005c903          	lbu	s2,0(a1)
 896:	26090863          	beqz	s2,b06 <vprintf+0x27e>
 89a:	e4a6                	sd	s1,72(sp)
 89c:	fc4e                	sd	s3,56(sp)
 89e:	f852                	sd	s4,48(sp)
 8a0:	f456                	sd	s5,40(sp)
 8a2:	f05a                	sd	s6,32(sp)
 8a4:	ec5e                	sd	s7,24(sp)
 8a6:	e862                	sd	s8,16(sp)
 8a8:	e466                	sd	s9,8(sp)
 8aa:	8b2a                	mv	s6,a0
 8ac:	8a2e                	mv	s4,a1
 8ae:	8bb2                	mv	s7,a2
  state = 0;
 8b0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8b2:	4481                	li	s1,0
 8b4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8ba:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 8be:	06c00c93          	li	s9,108
 8c2:	a005                	j	8e2 <vprintf+0x5a>
        putc(fd, c0);
 8c4:	85ca                	mv	a1,s2
 8c6:	855a                	mv	a0,s6
 8c8:	efbff0ef          	jal	7c2 <putc>
 8cc:	a019                	j	8d2 <vprintf+0x4a>
    } else if(state == '%'){
 8ce:	03598263          	beq	s3,s5,8f2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 8d2:	2485                	addiw	s1,s1,1
 8d4:	8726                	mv	a4,s1
 8d6:	009a07b3          	add	a5,s4,s1
 8da:	0007c903          	lbu	s2,0(a5)
 8de:	20090c63          	beqz	s2,af6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 8e2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 8e6:	fe0994e3          	bnez	s3,8ce <vprintf+0x46>
      if(c0 == '%'){
 8ea:	fd579de3          	bne	a5,s5,8c4 <vprintf+0x3c>
        state = '%';
 8ee:	89be                	mv	s3,a5
 8f0:	b7cd                	j	8d2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 8f2:	00ea06b3          	add	a3,s4,a4
 8f6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 8fa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 8fc:	c681                	beqz	a3,904 <vprintf+0x7c>
 8fe:	9752                	add	a4,a4,s4
 900:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 904:	03878f63          	beq	a5,s8,942 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 908:	05978963          	beq	a5,s9,95a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 90c:	07500713          	li	a4,117
 910:	0ee78363          	beq	a5,a4,9f6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 914:	07800713          	li	a4,120
 918:	12e78563          	beq	a5,a4,a42 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 91c:	07000713          	li	a4,112
 920:	14e78a63          	beq	a5,a4,a74 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 924:	07300713          	li	a4,115
 928:	18e78a63          	beq	a5,a4,abc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 92c:	02500713          	li	a4,37
 930:	04e79563          	bne	a5,a4,97a <vprintf+0xf2>
        putc(fd, '%');
 934:	02500593          	li	a1,37
 938:	855a                	mv	a0,s6
 93a:	e89ff0ef          	jal	7c2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 93e:	4981                	li	s3,0
 940:	bf49                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 942:	008b8913          	addi	s2,s7,8
 946:	4685                	li	a3,1
 948:	4629                	li	a2,10
 94a:	000ba583          	lw	a1,0(s7)
 94e:	855a                	mv	a0,s6
 950:	e91ff0ef          	jal	7e0 <printint>
 954:	8bca                	mv	s7,s2
      state = 0;
 956:	4981                	li	s3,0
 958:	bfad                	j	8d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 95a:	06400793          	li	a5,100
 95e:	02f68963          	beq	a3,a5,990 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 962:	06c00793          	li	a5,108
 966:	04f68263          	beq	a3,a5,9aa <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 96a:	07500793          	li	a5,117
 96e:	0af68063          	beq	a3,a5,a0e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 972:	07800793          	li	a5,120
 976:	0ef68263          	beq	a3,a5,a5a <vprintf+0x1d2>
        putc(fd, '%');
 97a:	02500593          	li	a1,37
 97e:	855a                	mv	a0,s6
 980:	e43ff0ef          	jal	7c2 <putc>
        putc(fd, c0);
 984:	85ca                	mv	a1,s2
 986:	855a                	mv	a0,s6
 988:	e3bff0ef          	jal	7c2 <putc>
      state = 0;
 98c:	4981                	li	s3,0
 98e:	b791                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 990:	008b8913          	addi	s2,s7,8
 994:	4685                	li	a3,1
 996:	4629                	li	a2,10
 998:	000ba583          	lw	a1,0(s7)
 99c:	855a                	mv	a0,s6
 99e:	e43ff0ef          	jal	7e0 <printint>
        i += 1;
 9a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 9a4:	8bca                	mv	s7,s2
      state = 0;
 9a6:	4981                	li	s3,0
        i += 1;
 9a8:	b72d                	j	8d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 9aa:	06400793          	li	a5,100
 9ae:	02f60763          	beq	a2,a5,9dc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 9b2:	07500793          	li	a5,117
 9b6:	06f60963          	beq	a2,a5,a28 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 9ba:	07800793          	li	a5,120
 9be:	faf61ee3          	bne	a2,a5,97a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9c2:	008b8913          	addi	s2,s7,8
 9c6:	4681                	li	a3,0
 9c8:	4641                	li	a2,16
 9ca:	000ba583          	lw	a1,0(s7)
 9ce:	855a                	mv	a0,s6
 9d0:	e11ff0ef          	jal	7e0 <printint>
        i += 2;
 9d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 9d6:	8bca                	mv	s7,s2
      state = 0;
 9d8:	4981                	li	s3,0
        i += 2;
 9da:	bde5                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9dc:	008b8913          	addi	s2,s7,8
 9e0:	4685                	li	a3,1
 9e2:	4629                	li	a2,10
 9e4:	000ba583          	lw	a1,0(s7)
 9e8:	855a                	mv	a0,s6
 9ea:	df7ff0ef          	jal	7e0 <printint>
        i += 2;
 9ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 9f0:	8bca                	mv	s7,s2
      state = 0;
 9f2:	4981                	li	s3,0
        i += 2;
 9f4:	bdf9                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 9f6:	008b8913          	addi	s2,s7,8
 9fa:	4681                	li	a3,0
 9fc:	4629                	li	a2,10
 9fe:	000ba583          	lw	a1,0(s7)
 a02:	855a                	mv	a0,s6
 a04:	dddff0ef          	jal	7e0 <printint>
 a08:	8bca                	mv	s7,s2
      state = 0;
 a0a:	4981                	li	s3,0
 a0c:	b5d9                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a0e:	008b8913          	addi	s2,s7,8
 a12:	4681                	li	a3,0
 a14:	4629                	li	a2,10
 a16:	000ba583          	lw	a1,0(s7)
 a1a:	855a                	mv	a0,s6
 a1c:	dc5ff0ef          	jal	7e0 <printint>
        i += 1;
 a20:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a22:	8bca                	mv	s7,s2
      state = 0;
 a24:	4981                	li	s3,0
        i += 1;
 a26:	b575                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a28:	008b8913          	addi	s2,s7,8
 a2c:	4681                	li	a3,0
 a2e:	4629                	li	a2,10
 a30:	000ba583          	lw	a1,0(s7)
 a34:	855a                	mv	a0,s6
 a36:	dabff0ef          	jal	7e0 <printint>
        i += 2;
 a3a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 a3c:	8bca                	mv	s7,s2
      state = 0;
 a3e:	4981                	li	s3,0
        i += 2;
 a40:	bd49                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 a42:	008b8913          	addi	s2,s7,8
 a46:	4681                	li	a3,0
 a48:	4641                	li	a2,16
 a4a:	000ba583          	lw	a1,0(s7)
 a4e:	855a                	mv	a0,s6
 a50:	d91ff0ef          	jal	7e0 <printint>
 a54:	8bca                	mv	s7,s2
      state = 0;
 a56:	4981                	li	s3,0
 a58:	bdad                	j	8d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a5a:	008b8913          	addi	s2,s7,8
 a5e:	4681                	li	a3,0
 a60:	4641                	li	a2,16
 a62:	000ba583          	lw	a1,0(s7)
 a66:	855a                	mv	a0,s6
 a68:	d79ff0ef          	jal	7e0 <printint>
        i += 1;
 a6c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a6e:	8bca                	mv	s7,s2
      state = 0;
 a70:	4981                	li	s3,0
        i += 1;
 a72:	b585                	j	8d2 <vprintf+0x4a>
 a74:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 a76:	008b8d13          	addi	s10,s7,8
 a7a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a7e:	03000593          	li	a1,48
 a82:	855a                	mv	a0,s6
 a84:	d3fff0ef          	jal	7c2 <putc>
  putc(fd, 'x');
 a88:	07800593          	li	a1,120
 a8c:	855a                	mv	a0,s6
 a8e:	d35ff0ef          	jal	7c2 <putc>
 a92:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a94:	00000b97          	auipc	s7,0x0
 a98:	2acb8b93          	addi	s7,s7,684 # d40 <digits>
 a9c:	03c9d793          	srli	a5,s3,0x3c
 aa0:	97de                	add	a5,a5,s7
 aa2:	0007c583          	lbu	a1,0(a5)
 aa6:	855a                	mv	a0,s6
 aa8:	d1bff0ef          	jal	7c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 aac:	0992                	slli	s3,s3,0x4
 aae:	397d                	addiw	s2,s2,-1
 ab0:	fe0916e3          	bnez	s2,a9c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 ab4:	8bea                	mv	s7,s10
      state = 0;
 ab6:	4981                	li	s3,0
 ab8:	6d02                	ld	s10,0(sp)
 aba:	bd21                	j	8d2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 abc:	008b8993          	addi	s3,s7,8
 ac0:	000bb903          	ld	s2,0(s7)
 ac4:	00090f63          	beqz	s2,ae2 <vprintf+0x25a>
        for(; *s; s++)
 ac8:	00094583          	lbu	a1,0(s2)
 acc:	c195                	beqz	a1,af0 <vprintf+0x268>
          putc(fd, *s);
 ace:	855a                	mv	a0,s6
 ad0:	cf3ff0ef          	jal	7c2 <putc>
        for(; *s; s++)
 ad4:	0905                	addi	s2,s2,1
 ad6:	00094583          	lbu	a1,0(s2)
 ada:	f9f5                	bnez	a1,ace <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 adc:	8bce                	mv	s7,s3
      state = 0;
 ade:	4981                	li	s3,0
 ae0:	bbcd                	j	8d2 <vprintf+0x4a>
          s = "(null)";
 ae2:	00000917          	auipc	s2,0x0
 ae6:	25690913          	addi	s2,s2,598 # d38 <malloc+0x14a>
        for(; *s; s++)
 aea:	02800593          	li	a1,40
 aee:	b7c5                	j	ace <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 af0:	8bce                	mv	s7,s3
      state = 0;
 af2:	4981                	li	s3,0
 af4:	bbf9                	j	8d2 <vprintf+0x4a>
 af6:	64a6                	ld	s1,72(sp)
 af8:	79e2                	ld	s3,56(sp)
 afa:	7a42                	ld	s4,48(sp)
 afc:	7aa2                	ld	s5,40(sp)
 afe:	7b02                	ld	s6,32(sp)
 b00:	6be2                	ld	s7,24(sp)
 b02:	6c42                	ld	s8,16(sp)
 b04:	6ca2                	ld	s9,8(sp)
    }
  }
}
 b06:	60e6                	ld	ra,88(sp)
 b08:	6446                	ld	s0,80(sp)
 b0a:	6906                	ld	s2,64(sp)
 b0c:	6125                	addi	sp,sp,96
 b0e:	8082                	ret

0000000000000b10 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b10:	715d                	addi	sp,sp,-80
 b12:	ec06                	sd	ra,24(sp)
 b14:	e822                	sd	s0,16(sp)
 b16:	1000                	addi	s0,sp,32
 b18:	e010                	sd	a2,0(s0)
 b1a:	e414                	sd	a3,8(s0)
 b1c:	e818                	sd	a4,16(s0)
 b1e:	ec1c                	sd	a5,24(s0)
 b20:	03043023          	sd	a6,32(s0)
 b24:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b28:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b2c:	8622                	mv	a2,s0
 b2e:	d5bff0ef          	jal	888 <vprintf>
}
 b32:	60e2                	ld	ra,24(sp)
 b34:	6442                	ld	s0,16(sp)
 b36:	6161                	addi	sp,sp,80
 b38:	8082                	ret

0000000000000b3a <printf>:

void
printf(const char *fmt, ...)
{
 b3a:	711d                	addi	sp,sp,-96
 b3c:	ec06                	sd	ra,24(sp)
 b3e:	e822                	sd	s0,16(sp)
 b40:	1000                	addi	s0,sp,32
 b42:	e40c                	sd	a1,8(s0)
 b44:	e810                	sd	a2,16(s0)
 b46:	ec14                	sd	a3,24(s0)
 b48:	f018                	sd	a4,32(s0)
 b4a:	f41c                	sd	a5,40(s0)
 b4c:	03043823          	sd	a6,48(s0)
 b50:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 b54:	00840613          	addi	a2,s0,8
 b58:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 b5c:	85aa                	mv	a1,a0
 b5e:	4505                	li	a0,1
 b60:	d29ff0ef          	jal	888 <vprintf>
}
 b64:	60e2                	ld	ra,24(sp)
 b66:	6442                	ld	s0,16(sp)
 b68:	6125                	addi	sp,sp,96
 b6a:	8082                	ret

0000000000000b6c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b6c:	1141                	addi	sp,sp,-16
 b6e:	e422                	sd	s0,8(sp)
 b70:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b72:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b76:	00001797          	auipc	a5,0x1
 b7a:	48a7b783          	ld	a5,1162(a5) # 2000 <freep>
 b7e:	a02d                	j	ba8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 b80:	4618                	lw	a4,8(a2)
 b82:	9f2d                	addw	a4,a4,a1
 b84:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 b88:	6398                	ld	a4,0(a5)
 b8a:	6310                	ld	a2,0(a4)
 b8c:	a83d                	j	bca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 b8e:	ff852703          	lw	a4,-8(a0)
 b92:	9f31                	addw	a4,a4,a2
 b94:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 b96:	ff053683          	ld	a3,-16(a0)
 b9a:	a091                	j	bde <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b9c:	6398                	ld	a4,0(a5)
 b9e:	00e7e463          	bltu	a5,a4,ba6 <free+0x3a>
 ba2:	00e6ea63          	bltu	a3,a4,bb6 <free+0x4a>
{
 ba6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba8:	fed7fae3          	bgeu	a5,a3,b9c <free+0x30>
 bac:	6398                	ld	a4,0(a5)
 bae:	00e6e463          	bltu	a3,a4,bb6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb2:	fee7eae3          	bltu	a5,a4,ba6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 bb6:	ff852583          	lw	a1,-8(a0)
 bba:	6390                	ld	a2,0(a5)
 bbc:	02059813          	slli	a6,a1,0x20
 bc0:	01c85713          	srli	a4,a6,0x1c
 bc4:	9736                	add	a4,a4,a3
 bc6:	fae60de3          	beq	a2,a4,b80 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 bca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 bce:	4790                	lw	a2,8(a5)
 bd0:	02061593          	slli	a1,a2,0x20
 bd4:	01c5d713          	srli	a4,a1,0x1c
 bd8:	973e                	add	a4,a4,a5
 bda:	fae68ae3          	beq	a3,a4,b8e <free+0x22>
    p->s.ptr = bp->s.ptr;
 bde:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 be0:	00001717          	auipc	a4,0x1
 be4:	42f73023          	sd	a5,1056(a4) # 2000 <freep>
}
 be8:	6422                	ld	s0,8(sp)
 bea:	0141                	addi	sp,sp,16
 bec:	8082                	ret

0000000000000bee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 bee:	7139                	addi	sp,sp,-64
 bf0:	fc06                	sd	ra,56(sp)
 bf2:	f822                	sd	s0,48(sp)
 bf4:	f426                	sd	s1,40(sp)
 bf6:	ec4e                	sd	s3,24(sp)
 bf8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bfa:	02051493          	slli	s1,a0,0x20
 bfe:	9081                	srli	s1,s1,0x20
 c00:	04bd                	addi	s1,s1,15
 c02:	8091                	srli	s1,s1,0x4
 c04:	0014899b          	addiw	s3,s1,1
 c08:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 c0a:	00001517          	auipc	a0,0x1
 c0e:	3f653503          	ld	a0,1014(a0) # 2000 <freep>
 c12:	c915                	beqz	a0,c46 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c14:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c16:	4798                	lw	a4,8(a5)
 c18:	08977a63          	bgeu	a4,s1,cac <malloc+0xbe>
 c1c:	f04a                	sd	s2,32(sp)
 c1e:	e852                	sd	s4,16(sp)
 c20:	e456                	sd	s5,8(sp)
 c22:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c24:	8a4e                	mv	s4,s3
 c26:	0009871b          	sext.w	a4,s3
 c2a:	6685                	lui	a3,0x1
 c2c:	00d77363          	bgeu	a4,a3,c32 <malloc+0x44>
 c30:	6a05                	lui	s4,0x1
 c32:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c36:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c3a:	00001917          	auipc	s2,0x1
 c3e:	3c690913          	addi	s2,s2,966 # 2000 <freep>
  if(p == (char*)-1)
 c42:	5afd                	li	s5,-1
 c44:	a081                	j	c84 <malloc+0x96>
 c46:	f04a                	sd	s2,32(sp)
 c48:	e852                	sd	s4,16(sp)
 c4a:	e456                	sd	s5,8(sp)
 c4c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c4e:	00001797          	auipc	a5,0x1
 c52:	3c278793          	addi	a5,a5,962 # 2010 <base>
 c56:	00001717          	auipc	a4,0x1
 c5a:	3af73523          	sd	a5,938(a4) # 2000 <freep>
 c5e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 c60:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 c64:	b7c1                	j	c24 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 c66:	6398                	ld	a4,0(a5)
 c68:	e118                	sd	a4,0(a0)
 c6a:	a8a9                	j	cc4 <malloc+0xd6>
  hp->s.size = nu;
 c6c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 c70:	0541                	addi	a0,a0,16
 c72:	efbff0ef          	jal	b6c <free>
  return freep;
 c76:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 c7a:	c12d                	beqz	a0,cdc <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c7c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c7e:	4798                	lw	a4,8(a5)
 c80:	02977263          	bgeu	a4,s1,ca4 <malloc+0xb6>
    if(p == freep)
 c84:	00093703          	ld	a4,0(s2)
 c88:	853e                	mv	a0,a5
 c8a:	fef719e3          	bne	a4,a5,c7c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 c8e:	8552                	mv	a0,s4
 c90:	acbff0ef          	jal	75a <sbrk>
  if(p == (char*)-1)
 c94:	fd551ce3          	bne	a0,s5,c6c <malloc+0x7e>
        return 0;
 c98:	4501                	li	a0,0
 c9a:	7902                	ld	s2,32(sp)
 c9c:	6a42                	ld	s4,16(sp)
 c9e:	6aa2                	ld	s5,8(sp)
 ca0:	6b02                	ld	s6,0(sp)
 ca2:	a03d                	j	cd0 <malloc+0xe2>
 ca4:	7902                	ld	s2,32(sp)
 ca6:	6a42                	ld	s4,16(sp)
 ca8:	6aa2                	ld	s5,8(sp)
 caa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cac:	fae48de3          	beq	s1,a4,c66 <malloc+0x78>
        p->s.size -= nunits;
 cb0:	4137073b          	subw	a4,a4,s3
 cb4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 cb6:	02071693          	slli	a3,a4,0x20
 cba:	01c6d713          	srli	a4,a3,0x1c
 cbe:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 cc0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 cc4:	00001717          	auipc	a4,0x1
 cc8:	32a73e23          	sd	a0,828(a4) # 2000 <freep>
      return (void*)(p + 1);
 ccc:	01078513          	addi	a0,a5,16
  }
}
 cd0:	70e2                	ld	ra,56(sp)
 cd2:	7442                	ld	s0,48(sp)
 cd4:	74a2                	ld	s1,40(sp)
 cd6:	69e2                	ld	s3,24(sp)
 cd8:	6121                	addi	sp,sp,64
 cda:	8082                	ret
 cdc:	7902                	ld	s2,32(sp)
 cde:	6a42                	ld	s4,16(sp)
 ce0:	6aa2                	ld	s5,8(sp)
 ce2:	6b02                	ld	s6,0(sp)
 ce4:	b7f5                	j	cd0 <malloc+0xe2>
