
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	5f013103          	ld	sp,1520(sp) # 8000b5f0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9847>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	df078793          	addi	a5,a5,-528 # 80000e70 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	41c020ef          	jal	80002516 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	043000ef          	jal	80000948 <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00013517          	auipc	a0,0x13
    80000158:	51c50513          	addi	a0,a0,1308 # 80013670 <cons>
    8000015c:	2a7000ef          	jal	80000c02 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00013497          	auipc	s1,0x13
    80000164:	51048493          	addi	s1,s1,1296 # 80013670 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00013917          	auipc	s2,0x13
    8000016c:	5a090913          	addi	s2,s2,1440 # 80013708 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	780010ef          	jal	80001900 <myproc>
    80000184:	224020ef          	jal	800023a8 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	767010ef          	jal	800020f4 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00013717          	auipc	a4,0x13
    800001a4:	4d070713          	addi	a4,a4,1232 # 80013670 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	2fa020ef          	jal	800024cc <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00013517          	auipc	a0,0x13
    800001ee:	48650513          	addi	a0,a0,1158 # 80013670 <cons>
    800001f2:	2a9000ef          	jal	80000c9a <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00013717          	auipc	a4,0x13
    80000218:	4ef72a23          	sw	a5,1268(a4) # 80013708 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00013517          	auipc	a0,0x13
    8000022e:	44650513          	addi	a0,a0,1094 # 80013670 <cons>
    80000232:	269000ef          	jal	80000c9a <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	612000ef          	jal	80000862 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	604000ef          	jal	80000862 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5fc000ef          	jal	80000862 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5f6000ef          	jal	80000862 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00013517          	auipc	a0,0x13
    80000282:	3f250513          	addi	a0,a0,1010 # 80013670 <cons>
    80000286:	17d000ef          	jal	80000c02 <acquire>

  kbd_intr_count++;
    8000028a:	0000b717          	auipc	a4,0xb
    8000028e:	38670713          	addi	a4,a4,902 # 8000b610 <kbd_intr_count>
    80000292:	431c                	lw	a5,0(a4)
    80000294:	2785                	addiw	a5,a5,1
    80000296:	c31c                	sw	a5,0(a4)
  switch(c){
    80000298:	47d5                	li	a5,21
    8000029a:	08f48f63          	beq	s1,a5,80000338 <consoleintr+0xc6>
    8000029e:	0297c563          	blt	a5,s1,800002c8 <consoleintr+0x56>
    800002a2:	47a1                	li	a5,8
    800002a4:	0ef48463          	beq	s1,a5,8000038c <consoleintr+0x11a>
    800002a8:	47c1                	li	a5,16
    800002aa:	10f49563          	bne	s1,a5,800003b4 <consoleintr+0x142>
  case C('P'):  // Print process list.
    procdump();
    800002ae:	2b2020ef          	jal	80002560 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002b2:	00013517          	auipc	a0,0x13
    800002b6:	3be50513          	addi	a0,a0,958 # 80013670 <cons>
    800002ba:	1e1000ef          	jal	80000c9a <release>
}
    800002be:	60e2                	ld	ra,24(sp)
    800002c0:	6442                	ld	s0,16(sp)
    800002c2:	64a2                	ld	s1,8(sp)
    800002c4:	6105                	addi	sp,sp,32
    800002c6:	8082                	ret
  switch(c){
    800002c8:	07f00793          	li	a5,127
    800002cc:	0cf48063          	beq	s1,a5,8000038c <consoleintr+0x11a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002d0:	00013717          	auipc	a4,0x13
    800002d4:	3a070713          	addi	a4,a4,928 # 80013670 <cons>
    800002d8:	0a072783          	lw	a5,160(a4)
    800002dc:	09872703          	lw	a4,152(a4)
    800002e0:	9f99                	subw	a5,a5,a4
    800002e2:	07f00713          	li	a4,127
    800002e6:	fcf766e3          	bltu	a4,a5,800002b2 <consoleintr+0x40>
      c = (c == '\r') ? '\n' : c;
    800002ea:	47b5                	li	a5,13
    800002ec:	0cf48763          	beq	s1,a5,800003ba <consoleintr+0x148>
      consputc(c);
    800002f0:	8526                	mv	a0,s1
    800002f2:	f4fff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002f6:	00013797          	auipc	a5,0x13
    800002fa:	37a78793          	addi	a5,a5,890 # 80013670 <cons>
    800002fe:	0a07a683          	lw	a3,160(a5)
    80000302:	0016871b          	addiw	a4,a3,1
    80000306:	0007061b          	sext.w	a2,a4
    8000030a:	0ae7a023          	sw	a4,160(a5)
    8000030e:	07f6f693          	andi	a3,a3,127
    80000312:	97b6                	add	a5,a5,a3
    80000314:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000318:	47a9                	li	a5,10
    8000031a:	0cf48563          	beq	s1,a5,800003e4 <consoleintr+0x172>
    8000031e:	4791                	li	a5,4
    80000320:	0cf48263          	beq	s1,a5,800003e4 <consoleintr+0x172>
    80000324:	00013797          	auipc	a5,0x13
    80000328:	3e47a783          	lw	a5,996(a5) # 80013708 <cons+0x98>
    8000032c:	9f1d                	subw	a4,a4,a5
    8000032e:	08000793          	li	a5,128
    80000332:	f8f710e3          	bne	a4,a5,800002b2 <consoleintr+0x40>
    80000336:	a07d                	j	800003e4 <consoleintr+0x172>
    80000338:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000033a:	00013717          	auipc	a4,0x13
    8000033e:	33670713          	addi	a4,a4,822 # 80013670 <cons>
    80000342:	0a072783          	lw	a5,160(a4)
    80000346:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	00013497          	auipc	s1,0x13
    8000034e:	32648493          	addi	s1,s1,806 # 80013670 <cons>
    while(cons.e != cons.w &&
    80000352:	4929                	li	s2,10
    80000354:	02f70863          	beq	a4,a5,80000384 <consoleintr+0x112>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000358:	37fd                	addiw	a5,a5,-1
    8000035a:	07f7f713          	andi	a4,a5,127
    8000035e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000360:	01874703          	lbu	a4,24(a4)
    80000364:	03270263          	beq	a4,s2,80000388 <consoleintr+0x116>
      cons.e--;
    80000368:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000036c:	10000513          	li	a0,256
    80000370:	ed1ff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000374:	0a04a783          	lw	a5,160(s1)
    80000378:	09c4a703          	lw	a4,156(s1)
    8000037c:	fcf71ee3          	bne	a4,a5,80000358 <consoleintr+0xe6>
    80000380:	6902                	ld	s2,0(sp)
    80000382:	bf05                	j	800002b2 <consoleintr+0x40>
    80000384:	6902                	ld	s2,0(sp)
    80000386:	b735                	j	800002b2 <consoleintr+0x40>
    80000388:	6902                	ld	s2,0(sp)
    8000038a:	b725                	j	800002b2 <consoleintr+0x40>
    if(cons.e != cons.w){
    8000038c:	00013717          	auipc	a4,0x13
    80000390:	2e470713          	addi	a4,a4,740 # 80013670 <cons>
    80000394:	0a072783          	lw	a5,160(a4)
    80000398:	09c72703          	lw	a4,156(a4)
    8000039c:	f0f70be3          	beq	a4,a5,800002b2 <consoleintr+0x40>
      cons.e--;
    800003a0:	37fd                	addiw	a5,a5,-1
    800003a2:	00013717          	auipc	a4,0x13
    800003a6:	36f72723          	sw	a5,878(a4) # 80013710 <cons+0xa0>
      consputc(BACKSPACE);
    800003aa:	10000513          	li	a0,256
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
    800003b2:	b701                	j	800002b2 <consoleintr+0x40>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003b4:	ee048fe3          	beqz	s1,800002b2 <consoleintr+0x40>
    800003b8:	bf21                	j	800002d0 <consoleintr+0x5e>
      consputc(c);
    800003ba:	4529                	li	a0,10
    800003bc:	e85ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003c0:	00013797          	auipc	a5,0x13
    800003c4:	2b078793          	addi	a5,a5,688 # 80013670 <cons>
    800003c8:	0a07a703          	lw	a4,160(a5)
    800003cc:	0017069b          	addiw	a3,a4,1
    800003d0:	0006861b          	sext.w	a2,a3
    800003d4:	0ad7a023          	sw	a3,160(a5)
    800003d8:	07f77713          	andi	a4,a4,127
    800003dc:	97ba                	add	a5,a5,a4
    800003de:	4729                	li	a4,10
    800003e0:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003e4:	00013797          	auipc	a5,0x13
    800003e8:	32c7a423          	sw	a2,808(a5) # 8001370c <cons+0x9c>
        wakeup(&cons.r);
    800003ec:	00013517          	auipc	a0,0x13
    800003f0:	31c50513          	addi	a0,a0,796 # 80013708 <cons+0x98>
    800003f4:	54d010ef          	jal	80002140 <wakeup>
    800003f8:	bd6d                	j	800002b2 <consoleintr+0x40>

00000000800003fa <consoleinit>:

void
consoleinit(void)
{
    800003fa:	1141                	addi	sp,sp,-16
    800003fc:	e406                	sd	ra,8(sp)
    800003fe:	e022                	sd	s0,0(sp)
    80000400:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000402:	00008597          	auipc	a1,0x8
    80000406:	bfe58593          	addi	a1,a1,-1026 # 80008000 <etext>
    8000040a:	00013517          	auipc	a0,0x13
    8000040e:	26650513          	addi	a0,a0,614 # 80013670 <cons>
    80000412:	770000ef          	jal	80000b82 <initlock>

  uartinit();
    80000416:	3f4000ef          	jal	8000080a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000041a:	00024797          	auipc	a5,0x24
    8000041e:	a0678793          	addi	a5,a5,-1530 # 80023e20 <devsw>
    80000422:	00000717          	auipc	a4,0x0
    80000426:	d1470713          	addi	a4,a4,-748 # 80000136 <consoleread>
    8000042a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000042c:	00000717          	auipc	a4,0x0
    80000430:	ca470713          	addi	a4,a4,-860 # 800000d0 <consolewrite>
    80000434:	ef98                	sd	a4,24(a5)
}
    80000436:	60a2                	ld	ra,8(sp)
    80000438:	6402                	ld	s0,0(sp)
    8000043a:	0141                	addi	sp,sp,16
    8000043c:	8082                	ret

000000008000043e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000043e:	7179                	addi	sp,sp,-48
    80000440:	f406                	sd	ra,40(sp)
    80000442:	f022                	sd	s0,32(sp)
    80000444:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000446:	c219                	beqz	a2,8000044c <printint+0xe>
    80000448:	08054063          	bltz	a0,800004c8 <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000044c:	4881                	li	a7,0
    8000044e:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000452:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000454:	00008617          	auipc	a2,0x8
    80000458:	3dc60613          	addi	a2,a2,988 # 80008830 <digits>
    8000045c:	883e                	mv	a6,a5
    8000045e:	2785                	addiw	a5,a5,1
    80000460:	02b57733          	remu	a4,a0,a1
    80000464:	9732                	add	a4,a4,a2
    80000466:	00074703          	lbu	a4,0(a4)
    8000046a:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    8000046e:	872a                	mv	a4,a0
    80000470:	02b55533          	divu	a0,a0,a1
    80000474:	0685                	addi	a3,a3,1
    80000476:	feb773e3          	bgeu	a4,a1,8000045c <printint+0x1e>

  if(sign)
    8000047a:	00088a63          	beqz	a7,8000048e <printint+0x50>
    buf[i++] = '-';
    8000047e:	1781                	addi	a5,a5,-32
    80000480:	97a2                	add	a5,a5,s0
    80000482:	02d00713          	li	a4,45
    80000486:	fee78823          	sb	a4,-16(a5)
    8000048a:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    8000048e:	02f05963          	blez	a5,800004c0 <printint+0x82>
    80000492:	ec26                	sd	s1,24(sp)
    80000494:	e84a                	sd	s2,16(sp)
    80000496:	fd040713          	addi	a4,s0,-48
    8000049a:	00f704b3          	add	s1,a4,a5
    8000049e:	fff70913          	addi	s2,a4,-1
    800004a2:	993e                	add	s2,s2,a5
    800004a4:	37fd                	addiw	a5,a5,-1
    800004a6:	1782                	slli	a5,a5,0x20
    800004a8:	9381                	srli	a5,a5,0x20
    800004aa:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004ae:	fff4c503          	lbu	a0,-1(s1)
    800004b2:	d8fff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004b6:	14fd                	addi	s1,s1,-1
    800004b8:	ff249be3          	bne	s1,s2,800004ae <printint+0x70>
    800004bc:	64e2                	ld	s1,24(sp)
    800004be:	6942                	ld	s2,16(sp)
}
    800004c0:	70a2                	ld	ra,40(sp)
    800004c2:	7402                	ld	s0,32(sp)
    800004c4:	6145                	addi	sp,sp,48
    800004c6:	8082                	ret
    x = -xx;
    800004c8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004cc:	4885                	li	a7,1
    x = -xx;
    800004ce:	b741                	j	8000044e <printint+0x10>

00000000800004d0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004d0:	7155                	addi	sp,sp,-208
    800004d2:	e506                	sd	ra,136(sp)
    800004d4:	e122                	sd	s0,128(sp)
    800004d6:	f0d2                	sd	s4,96(sp)
    800004d8:	0900                	addi	s0,sp,144
    800004da:	8a2a                	mv	s4,a0
    800004dc:	e40c                	sd	a1,8(s0)
    800004de:	e810                	sd	a2,16(s0)
    800004e0:	ec14                	sd	a3,24(s0)
    800004e2:	f018                	sd	a4,32(s0)
    800004e4:	f41c                	sd	a5,40(s0)
    800004e6:	03043823          	sd	a6,48(s0)
    800004ea:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004ee:	00013797          	auipc	a5,0x13
    800004f2:	2427a783          	lw	a5,578(a5) # 80013730 <pr+0x18>
    800004f6:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004fa:	e3a1                	bnez	a5,8000053a <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004fc:	00840793          	addi	a5,s0,8
    80000500:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000504:	00054503          	lbu	a0,0(a0)
    80000508:	26050763          	beqz	a0,80000776 <printf+0x2a6>
    8000050c:	fca6                	sd	s1,120(sp)
    8000050e:	f8ca                	sd	s2,112(sp)
    80000510:	f4ce                	sd	s3,104(sp)
    80000512:	ecd6                	sd	s5,88(sp)
    80000514:	e8da                	sd	s6,80(sp)
    80000516:	e0e2                	sd	s8,64(sp)
    80000518:	fc66                	sd	s9,56(sp)
    8000051a:	f86a                	sd	s10,48(sp)
    8000051c:	f46e                	sd	s11,40(sp)
    8000051e:	4981                	li	s3,0
    if(cx != '%'){
    80000520:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000524:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    80000528:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000052c:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000530:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000534:	07000d93          	li	s11,112
    80000538:	a815                	j	8000056c <printf+0x9c>
    acquire(&pr.lock);
    8000053a:	00013517          	auipc	a0,0x13
    8000053e:	1de50513          	addi	a0,a0,478 # 80013718 <pr>
    80000542:	6c0000ef          	jal	80000c02 <acquire>
  va_start(ap, fmt);
    80000546:	00840793          	addi	a5,s0,8
    8000054a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	000a4503          	lbu	a0,0(s4)
    80000552:	fd4d                	bnez	a0,8000050c <printf+0x3c>
    80000554:	a481                	j	80000794 <printf+0x2c4>
      consputc(cx);
    80000556:	cebff0ef          	jal	80000240 <consputc>
      continue;
    8000055a:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055c:	0014899b          	addiw	s3,s1,1
    80000560:	013a07b3          	add	a5,s4,s3
    80000564:	0007c503          	lbu	a0,0(a5)
    80000568:	1e050b63          	beqz	a0,8000075e <printf+0x28e>
    if(cx != '%'){
    8000056c:	ff5515e3          	bne	a0,s5,80000556 <printf+0x86>
    i++;
    80000570:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000574:	009a07b3          	add	a5,s4,s1
    80000578:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000057c:	1e090163          	beqz	s2,8000075e <printf+0x28e>
    80000580:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000584:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000586:	c789                	beqz	a5,80000590 <printf+0xc0>
    80000588:	009a0733          	add	a4,s4,s1
    8000058c:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000590:	03690763          	beq	s2,s6,800005be <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000594:	05890163          	beq	s2,s8,800005d6 <printf+0x106>
    } else if(c0 == 'u'){
    80000598:	0d990b63          	beq	s2,s9,8000066e <printf+0x19e>
    } else if(c0 == 'x'){
    8000059c:	13a90163          	beq	s2,s10,800006be <printf+0x1ee>
    } else if(c0 == 'p'){
    800005a0:	13b90b63          	beq	s2,s11,800006d6 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005a4:	07300793          	li	a5,115
    800005a8:	16f90a63          	beq	s2,a5,8000071c <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005ac:	1b590463          	beq	s2,s5,80000754 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005b0:	8556                	mv	a0,s5
    800005b2:	c8fff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005b6:	854a                	mv	a0,s2
    800005b8:	c89ff0ef          	jal	80000240 <consputc>
    800005bc:	b745                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005be:	f8843783          	ld	a5,-120(s0)
    800005c2:	00878713          	addi	a4,a5,8
    800005c6:	f8e43423          	sd	a4,-120(s0)
    800005ca:	4605                	li	a2,1
    800005cc:	45a9                	li	a1,10
    800005ce:	4388                	lw	a0,0(a5)
    800005d0:	e6fff0ef          	jal	8000043e <printint>
    800005d4:	b761                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005d6:	03678663          	beq	a5,s6,80000602 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005da:	05878263          	beq	a5,s8,8000061e <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005de:	0b978463          	beq	a5,s9,80000686 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005e2:	fda797e3          	bne	a5,s10,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005e6:	f8843783          	ld	a5,-120(s0)
    800005ea:	00878713          	addi	a4,a5,8
    800005ee:	f8e43423          	sd	a4,-120(s0)
    800005f2:	4601                	li	a2,0
    800005f4:	45c1                	li	a1,16
    800005f6:	6388                	ld	a0,0(a5)
    800005f8:	e47ff0ef          	jal	8000043e <printint>
      i += 1;
    800005fc:	0029849b          	addiw	s1,s3,2
    80000600:	bfb1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000602:	f8843783          	ld	a5,-120(s0)
    80000606:	00878713          	addi	a4,a5,8
    8000060a:	f8e43423          	sd	a4,-120(s0)
    8000060e:	4605                	li	a2,1
    80000610:	45a9                	li	a1,10
    80000612:	6388                	ld	a0,0(a5)
    80000614:	e2bff0ef          	jal	8000043e <printint>
      i += 1;
    80000618:	0029849b          	addiw	s1,s3,2
    8000061c:	b781                	j	8000055c <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    8000061e:	06400793          	li	a5,100
    80000622:	02f68863          	beq	a3,a5,80000652 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000626:	07500793          	li	a5,117
    8000062a:	06f68c63          	beq	a3,a5,800006a2 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000062e:	07800793          	li	a5,120
    80000632:	f6f69fe3          	bne	a3,a5,800005b0 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000636:	f8843783          	ld	a5,-120(s0)
    8000063a:	00878713          	addi	a4,a5,8
    8000063e:	f8e43423          	sd	a4,-120(s0)
    80000642:	4601                	li	a2,0
    80000644:	45c1                	li	a1,16
    80000646:	6388                	ld	a0,0(a5)
    80000648:	df7ff0ef          	jal	8000043e <printint>
      i += 2;
    8000064c:	0039849b          	addiw	s1,s3,3
    80000650:	b731                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000652:	f8843783          	ld	a5,-120(s0)
    80000656:	00878713          	addi	a4,a5,8
    8000065a:	f8e43423          	sd	a4,-120(s0)
    8000065e:	4605                	li	a2,1
    80000660:	45a9                	li	a1,10
    80000662:	6388                	ld	a0,0(a5)
    80000664:	ddbff0ef          	jal	8000043e <printint>
      i += 2;
    80000668:	0039849b          	addiw	s1,s3,3
    8000066c:	bdc5                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    8000066e:	f8843783          	ld	a5,-120(s0)
    80000672:	00878713          	addi	a4,a5,8
    80000676:	f8e43423          	sd	a4,-120(s0)
    8000067a:	4601                	li	a2,0
    8000067c:	45a9                	li	a1,10
    8000067e:	4388                	lw	a0,0(a5)
    80000680:	dbfff0ef          	jal	8000043e <printint>
    80000684:	bde1                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4601                	li	a2,0
    80000694:	45a9                	li	a1,10
    80000696:	6388                	ld	a0,0(a5)
    80000698:	da7ff0ef          	jal	8000043e <printint>
      i += 1;
    8000069c:	0029849b          	addiw	s1,s3,2
    800006a0:	bd75                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	4601                	li	a2,0
    800006b0:	45a9                	li	a1,10
    800006b2:	6388                	ld	a0,0(a5)
    800006b4:	d8bff0ef          	jal	8000043e <printint>
      i += 2;
    800006b8:	0039849b          	addiw	s1,s3,3
    800006bc:	b545                	j	8000055c <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006be:	f8843783          	ld	a5,-120(s0)
    800006c2:	00878713          	addi	a4,a5,8
    800006c6:	f8e43423          	sd	a4,-120(s0)
    800006ca:	4601                	li	a2,0
    800006cc:	45c1                	li	a1,16
    800006ce:	4388                	lw	a0,0(a5)
    800006d0:	d6fff0ef          	jal	8000043e <printint>
    800006d4:	b561                	j	8000055c <printf+0x8c>
    800006d6:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006d8:	f8843783          	ld	a5,-120(s0)
    800006dc:	00878713          	addi	a4,a5,8
    800006e0:	f8e43423          	sd	a4,-120(s0)
    800006e4:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006e8:	03000513          	li	a0,48
    800006ec:	b55ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006f0:	07800513          	li	a0,120
    800006f4:	b4dff0ef          	jal	80000240 <consputc>
    800006f8:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006fa:	00008b97          	auipc	s7,0x8
    800006fe:	136b8b93          	addi	s7,s7,310 # 80008830 <digits>
    80000702:	03c9d793          	srli	a5,s3,0x3c
    80000706:	97de                	add	a5,a5,s7
    80000708:	0007c503          	lbu	a0,0(a5)
    8000070c:	b35ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000710:	0992                	slli	s3,s3,0x4
    80000712:	397d                	addiw	s2,s2,-1
    80000714:	fe0917e3          	bnez	s2,80000702 <printf+0x232>
    80000718:	6ba6                	ld	s7,72(sp)
    8000071a:	b589                	j	8000055c <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000071c:	f8843783          	ld	a5,-120(s0)
    80000720:	00878713          	addi	a4,a5,8
    80000724:	f8e43423          	sd	a4,-120(s0)
    80000728:	0007b903          	ld	s2,0(a5)
    8000072c:	00090d63          	beqz	s2,80000746 <printf+0x276>
      for(; *s; s++)
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	e20504e3          	beqz	a0,8000055c <printf+0x8c>
        consputc(*s);
    80000738:	b09ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000073c:	0905                	addi	s2,s2,1
    8000073e:	00094503          	lbu	a0,0(s2)
    80000742:	f97d                	bnez	a0,80000738 <printf+0x268>
    80000744:	bd21                	j	8000055c <printf+0x8c>
        s = "(null)";
    80000746:	00008917          	auipc	s2,0x8
    8000074a:	8c290913          	addi	s2,s2,-1854 # 80008008 <etext+0x8>
      for(; *s; s++)
    8000074e:	02800513          	li	a0,40
    80000752:	b7dd                	j	80000738 <printf+0x268>
      consputc('%');
    80000754:	02500513          	li	a0,37
    80000758:	ae9ff0ef          	jal	80000240 <consputc>
    8000075c:	b501                	j	8000055c <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    8000075e:	f7843783          	ld	a5,-136(s0)
    80000762:	e385                	bnez	a5,80000782 <printf+0x2b2>
    80000764:	74e6                	ld	s1,120(sp)
    80000766:	7946                	ld	s2,112(sp)
    80000768:	79a6                	ld	s3,104(sp)
    8000076a:	6ae6                	ld	s5,88(sp)
    8000076c:	6b46                	ld	s6,80(sp)
    8000076e:	6c06                	ld	s8,64(sp)
    80000770:	7ce2                	ld	s9,56(sp)
    80000772:	7d42                	ld	s10,48(sp)
    80000774:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000776:	4501                	li	a0,0
    80000778:	60aa                	ld	ra,136(sp)
    8000077a:	640a                	ld	s0,128(sp)
    8000077c:	7a06                	ld	s4,96(sp)
    8000077e:	6169                	addi	sp,sp,208
    80000780:	8082                	ret
    80000782:	74e6                	ld	s1,120(sp)
    80000784:	7946                	ld	s2,112(sp)
    80000786:	79a6                	ld	s3,104(sp)
    80000788:	6ae6                	ld	s5,88(sp)
    8000078a:	6b46                	ld	s6,80(sp)
    8000078c:	6c06                	ld	s8,64(sp)
    8000078e:	7ce2                	ld	s9,56(sp)
    80000790:	7d42                	ld	s10,48(sp)
    80000792:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000794:	00013517          	auipc	a0,0x13
    80000798:	f8450513          	addi	a0,a0,-124 # 80013718 <pr>
    8000079c:	4fe000ef          	jal	80000c9a <release>
    800007a0:	bfd9                	j	80000776 <printf+0x2a6>

00000000800007a2 <panic>:

void
panic(char *s)
{
    800007a2:	1101                	addi	sp,sp,-32
    800007a4:	ec06                	sd	ra,24(sp)
    800007a6:	e822                	sd	s0,16(sp)
    800007a8:	e426                	sd	s1,8(sp)
    800007aa:	1000                	addi	s0,sp,32
    800007ac:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007ae:	00013797          	auipc	a5,0x13
    800007b2:	f807a123          	sw	zero,-126(a5) # 80013730 <pr+0x18>
  printf("panic: ");
    800007b6:	00008517          	auipc	a0,0x8
    800007ba:	86250513          	addi	a0,a0,-1950 # 80008018 <etext+0x18>
    800007be:	d13ff0ef          	jal	800004d0 <printf>
  printf("%s\n", s);
    800007c2:	85a6                	mv	a1,s1
    800007c4:	00008517          	auipc	a0,0x8
    800007c8:	85c50513          	addi	a0,a0,-1956 # 80008020 <etext+0x20>
    800007cc:	d05ff0ef          	jal	800004d0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007d0:	4785                	li	a5,1
    800007d2:	0000b717          	auipc	a4,0xb
    800007d6:	e4f72123          	sw	a5,-446(a4) # 8000b614 <panicked>
  for(;;)
    800007da:	a001                	j	800007da <panic+0x38>

00000000800007dc <printfinit>:
    ;
}

void
printfinit(void)
{
    800007dc:	1101                	addi	sp,sp,-32
    800007de:	ec06                	sd	ra,24(sp)
    800007e0:	e822                	sd	s0,16(sp)
    800007e2:	e426                	sd	s1,8(sp)
    800007e4:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007e6:	00013497          	auipc	s1,0x13
    800007ea:	f3248493          	addi	s1,s1,-206 # 80013718 <pr>
    800007ee:	00008597          	auipc	a1,0x8
    800007f2:	83a58593          	addi	a1,a1,-1990 # 80008028 <etext+0x28>
    800007f6:	8526                	mv	a0,s1
    800007f8:	38a000ef          	jal	80000b82 <initlock>
  pr.locking = 1;
    800007fc:	4785                	li	a5,1
    800007fe:	cc9c                	sw	a5,24(s1)
}
    80000800:	60e2                	ld	ra,24(sp)
    80000802:	6442                	ld	s0,16(sp)
    80000804:	64a2                	ld	s1,8(sp)
    80000806:	6105                	addi	sp,sp,32
    80000808:	8082                	ret

000000008000080a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000080a:	1141                	addi	sp,sp,-16
    8000080c:	e406                	sd	ra,8(sp)
    8000080e:	e022                	sd	s0,0(sp)
    80000810:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000812:	100007b7          	lui	a5,0x10000
    80000816:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000081a:	10000737          	lui	a4,0x10000
    8000081e:	f8000693          	li	a3,-128
    80000822:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000826:	468d                	li	a3,3
    80000828:	10000637          	lui	a2,0x10000
    8000082c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000830:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000834:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000838:	10000737          	lui	a4,0x10000
    8000083c:	461d                	li	a2,7
    8000083e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000842:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000846:	00007597          	auipc	a1,0x7
    8000084a:	7ea58593          	addi	a1,a1,2026 # 80008030 <etext+0x30>
    8000084e:	00013517          	auipc	a0,0x13
    80000852:	eea50513          	addi	a0,a0,-278 # 80013738 <uart_tx_lock>
    80000856:	32c000ef          	jal	80000b82 <initlock>
}
    8000085a:	60a2                	ld	ra,8(sp)
    8000085c:	6402                	ld	s0,0(sp)
    8000085e:	0141                	addi	sp,sp,16
    80000860:	8082                	ret

0000000080000862 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000862:	1101                	addi	sp,sp,-32
    80000864:	ec06                	sd	ra,24(sp)
    80000866:	e822                	sd	s0,16(sp)
    80000868:	e426                	sd	s1,8(sp)
    8000086a:	1000                	addi	s0,sp,32
    8000086c:	84aa                	mv	s1,a0
  push_off();
    8000086e:	354000ef          	jal	80000bc2 <push_off>

  if(panicked){
    80000872:	0000b797          	auipc	a5,0xb
    80000876:	da27a783          	lw	a5,-606(a5) # 8000b614 <panicked>
    8000087a:	e795                	bnez	a5,800008a6 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000087c:	10000737          	lui	a4,0x10000
    80000880:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000882:	00074783          	lbu	a5,0(a4)
    80000886:	0207f793          	andi	a5,a5,32
    8000088a:	dfe5                	beqz	a5,80000882 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000088c:	0ff4f513          	zext.b	a0,s1
    80000890:	100007b7          	lui	a5,0x10000
    80000894:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000898:	3ae000ef          	jal	80000c46 <pop_off>
}
    8000089c:	60e2                	ld	ra,24(sp)
    8000089e:	6442                	ld	s0,16(sp)
    800008a0:	64a2                	ld	s1,8(sp)
    800008a2:	6105                	addi	sp,sp,32
    800008a4:	8082                	ret
    for(;;)
    800008a6:	a001                	j	800008a6 <uartputc_sync+0x44>

00000000800008a8 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008a8:	0000b797          	auipc	a5,0xb
    800008ac:	d707b783          	ld	a5,-656(a5) # 8000b618 <uart_tx_r>
    800008b0:	0000b717          	auipc	a4,0xb
    800008b4:	d7073703          	ld	a4,-656(a4) # 8000b620 <uart_tx_w>
    800008b8:	08f70263          	beq	a4,a5,8000093c <uartstart+0x94>
{
    800008bc:	7139                	addi	sp,sp,-64
    800008be:	fc06                	sd	ra,56(sp)
    800008c0:	f822                	sd	s0,48(sp)
    800008c2:	f426                	sd	s1,40(sp)
    800008c4:	f04a                	sd	s2,32(sp)
    800008c6:	ec4e                	sd	s3,24(sp)
    800008c8:	e852                	sd	s4,16(sp)
    800008ca:	e456                	sd	s5,8(sp)
    800008cc:	e05a                	sd	s6,0(sp)
    800008ce:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d0:	10000937          	lui	s2,0x10000
    800008d4:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008d6:	00013a97          	auipc	s5,0x13
    800008da:	e62a8a93          	addi	s5,s5,-414 # 80013738 <uart_tx_lock>
    uart_tx_r += 1;
    800008de:	0000b497          	auipc	s1,0xb
    800008e2:	d3a48493          	addi	s1,s1,-710 # 8000b618 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008e6:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ea:	0000b997          	auipc	s3,0xb
    800008ee:	d3698993          	addi	s3,s3,-714 # 8000b620 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f2:	00094703          	lbu	a4,0(s2)
    800008f6:	02077713          	andi	a4,a4,32
    800008fa:	c71d                	beqz	a4,80000928 <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008fc:	01f7f713          	andi	a4,a5,31
    80000900:	9756                	add	a4,a4,s5
    80000902:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000906:	0785                	addi	a5,a5,1
    80000908:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000090a:	8526                	mv	a0,s1
    8000090c:	035010ef          	jal	80002140 <wakeup>
    WriteReg(THR, c);
    80000910:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000914:	609c                	ld	a5,0(s1)
    80000916:	0009b703          	ld	a4,0(s3)
    8000091a:	fcf71ce3          	bne	a4,a5,800008f2 <uartstart+0x4a>
      ReadReg(ISR);
    8000091e:	100007b7          	lui	a5,0x10000
    80000922:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000924:	0007c783          	lbu	a5,0(a5)
  }
}
    80000928:	70e2                	ld	ra,56(sp)
    8000092a:	7442                	ld	s0,48(sp)
    8000092c:	74a2                	ld	s1,40(sp)
    8000092e:	7902                	ld	s2,32(sp)
    80000930:	69e2                	ld	s3,24(sp)
    80000932:	6a42                	ld	s4,16(sp)
    80000934:	6aa2                	ld	s5,8(sp)
    80000936:	6b02                	ld	s6,0(sp)
    80000938:	6121                	addi	sp,sp,64
    8000093a:	8082                	ret
      ReadReg(ISR);
    8000093c:	100007b7          	lui	a5,0x10000
    80000940:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000942:	0007c783          	lbu	a5,0(a5)
      return;
    80000946:	8082                	ret

0000000080000948 <uartputc>:
{
    80000948:	7179                	addi	sp,sp,-48
    8000094a:	f406                	sd	ra,40(sp)
    8000094c:	f022                	sd	s0,32(sp)
    8000094e:	ec26                	sd	s1,24(sp)
    80000950:	e84a                	sd	s2,16(sp)
    80000952:	e44e                	sd	s3,8(sp)
    80000954:	e052                	sd	s4,0(sp)
    80000956:	1800                	addi	s0,sp,48
    80000958:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000095a:	00013517          	auipc	a0,0x13
    8000095e:	dde50513          	addi	a0,a0,-546 # 80013738 <uart_tx_lock>
    80000962:	2a0000ef          	jal	80000c02 <acquire>
  if(panicked){
    80000966:	0000b797          	auipc	a5,0xb
    8000096a:	cae7a783          	lw	a5,-850(a5) # 8000b614 <panicked>
    8000096e:	efbd                	bnez	a5,800009ec <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000970:	0000b717          	auipc	a4,0xb
    80000974:	cb073703          	ld	a4,-848(a4) # 8000b620 <uart_tx_w>
    80000978:	0000b797          	auipc	a5,0xb
    8000097c:	ca07b783          	ld	a5,-864(a5) # 8000b618 <uart_tx_r>
    80000980:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000984:	00013997          	auipc	s3,0x13
    80000988:	db498993          	addi	s3,s3,-588 # 80013738 <uart_tx_lock>
    8000098c:	0000b497          	auipc	s1,0xb
    80000990:	c8c48493          	addi	s1,s1,-884 # 8000b618 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000b917          	auipc	s2,0xb
    80000998:	c8c90913          	addi	s2,s2,-884 # 8000b620 <uart_tx_w>
    8000099c:	00e79d63          	bne	a5,a4,800009b6 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a0:	85ce                	mv	a1,s3
    800009a2:	8526                	mv	a0,s1
    800009a4:	750010ef          	jal	800020f4 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a8:	00093703          	ld	a4,0(s2)
    800009ac:	609c                	ld	a5,0(s1)
    800009ae:	02078793          	addi	a5,a5,32
    800009b2:	fee787e3          	beq	a5,a4,800009a0 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009b6:	00013497          	auipc	s1,0x13
    800009ba:	d8248493          	addi	s1,s1,-638 # 80013738 <uart_tx_lock>
    800009be:	01f77793          	andi	a5,a4,31
    800009c2:	97a6                	add	a5,a5,s1
    800009c4:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009c8:	0705                	addi	a4,a4,1
    800009ca:	0000b797          	auipc	a5,0xb
    800009ce:	c4e7bb23          	sd	a4,-938(a5) # 8000b620 <uart_tx_w>
  uartstart();
    800009d2:	ed7ff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    800009d6:	8526                	mv	a0,s1
    800009d8:	2c2000ef          	jal	80000c9a <release>
}
    800009dc:	70a2                	ld	ra,40(sp)
    800009de:	7402                	ld	s0,32(sp)
    800009e0:	64e2                	ld	s1,24(sp)
    800009e2:	6942                	ld	s2,16(sp)
    800009e4:	69a2                	ld	s3,8(sp)
    800009e6:	6a02                	ld	s4,0(sp)
    800009e8:	6145                	addi	sp,sp,48
    800009ea:	8082                	ret
    for(;;)
    800009ec:	a001                	j	800009ec <uartputc+0xa4>

00000000800009ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ee:	1141                	addi	sp,sp,-16
    800009f0:	e422                	sd	s0,8(sp)
    800009f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009fa:	0007c783          	lbu	a5,0(a5)
    800009fe:	8b85                	andi	a5,a5,1
    80000a00:	cb81                	beqz	a5,80000a10 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a02:	100007b7          	lui	a5,0x10000
    80000a06:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a0a:	6422                	ld	s0,8(sp)
    80000a0c:	0141                	addi	sp,sp,16
    80000a0e:	8082                	ret
    return -1;
    80000a10:	557d                	li	a0,-1
    80000a12:	bfe5                	j	80000a0a <uartgetc+0x1c>

0000000080000a14 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a14:	1101                	addi	sp,sp,-32
    80000a16:	ec06                	sd	ra,24(sp)
    80000a18:	e822                	sd	s0,16(sp)
    80000a1a:	e426                	sd	s1,8(sp)
    80000a1c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a1e:	54fd                	li	s1,-1
    80000a20:	a019                	j	80000a26 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a22:	851ff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a26:	fc9ff0ef          	jal	800009ee <uartgetc>
    if(c == -1)
    80000a2a:	fe951ce3          	bne	a0,s1,80000a22 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a2e:	00013497          	auipc	s1,0x13
    80000a32:	d0a48493          	addi	s1,s1,-758 # 80013738 <uart_tx_lock>
    80000a36:	8526                	mv	a0,s1
    80000a38:	1ca000ef          	jal	80000c02 <acquire>
  uartstart();
    80000a3c:	e6dff0ef          	jal	800008a8 <uartstart>
  release(&uart_tx_lock);
    80000a40:	8526                	mv	a0,s1
    80000a42:	258000ef          	jal	80000c9a <release>
}
    80000a46:	60e2                	ld	ra,24(sp)
    80000a48:	6442                	ld	s0,16(sp)
    80000a4a:	64a2                	ld	s1,8(sp)
    80000a4c:	6105                	addi	sp,sp,32
    80000a4e:	8082                	ret

0000000080000a50 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a50:	1101                	addi	sp,sp,-32
    80000a52:	ec06                	sd	ra,24(sp)
    80000a54:	e822                	sd	s0,16(sp)
    80000a56:	e426                	sd	s1,8(sp)
    80000a58:	e04a                	sd	s2,0(sp)
    80000a5a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a5c:	03451793          	slli	a5,a0,0x34
    80000a60:	e7a9                	bnez	a5,80000aaa <kfree+0x5a>
    80000a62:	84aa                	mv	s1,a0
    80000a64:	00024797          	auipc	a5,0x24
    80000a68:	55478793          	addi	a5,a5,1364 # 80024fb8 <end>
    80000a6c:	02f56f63          	bltu	a0,a5,80000aaa <kfree+0x5a>
    80000a70:	47c5                	li	a5,17
    80000a72:	07ee                	slli	a5,a5,0x1b
    80000a74:	02f57b63          	bgeu	a0,a5,80000aaa <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a78:	6605                	lui	a2,0x1
    80000a7a:	4585                	li	a1,1
    80000a7c:	25a000ef          	jal	80000cd6 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a80:	00013917          	auipc	s2,0x13
    80000a84:	cf090913          	addi	s2,s2,-784 # 80013770 <kmem>
    80000a88:	854a                	mv	a0,s2
    80000a8a:	178000ef          	jal	80000c02 <acquire>
  r->next = kmem.freelist;
    80000a8e:	01893783          	ld	a5,24(s2)
    80000a92:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a94:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a98:	854a                	mv	a0,s2
    80000a9a:	200000ef          	jal	80000c9a <release>
}
    80000a9e:	60e2                	ld	ra,24(sp)
    80000aa0:	6442                	ld	s0,16(sp)
    80000aa2:	64a2                	ld	s1,8(sp)
    80000aa4:	6902                	ld	s2,0(sp)
    80000aa6:	6105                	addi	sp,sp,32
    80000aa8:	8082                	ret
    panic("kfree");
    80000aaa:	00007517          	auipc	a0,0x7
    80000aae:	58e50513          	addi	a0,a0,1422 # 80008038 <etext+0x38>
    80000ab2:	cf1ff0ef          	jal	800007a2 <panic>

0000000080000ab6 <freerange>:
{
    80000ab6:	7179                	addi	sp,sp,-48
    80000ab8:	f406                	sd	ra,40(sp)
    80000aba:	f022                	sd	s0,32(sp)
    80000abc:	ec26                	sd	s1,24(sp)
    80000abe:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ac0:	6785                	lui	a5,0x1
    80000ac2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ac6:	00e504b3          	add	s1,a0,a4
    80000aca:	777d                	lui	a4,0xfffff
    80000acc:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94be                	add	s1,s1,a5
    80000ad0:	0295e263          	bltu	a1,s1,80000af4 <freerange+0x3e>
    80000ad4:	e84a                	sd	s2,16(sp)
    80000ad6:	e44e                	sd	s3,8(sp)
    80000ad8:	e052                	sd	s4,0(sp)
    80000ada:	892e                	mv	s2,a1
    kfree(p);
    80000adc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ade:	6985                	lui	s3,0x1
    kfree(p);
    80000ae0:	01448533          	add	a0,s1,s4
    80000ae4:	f6dff0ef          	jal	80000a50 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	94ce                	add	s1,s1,s3
    80000aea:	fe997be3          	bgeu	s2,s1,80000ae0 <freerange+0x2a>
    80000aee:	6942                	ld	s2,16(sp)
    80000af0:	69a2                	ld	s3,8(sp)
    80000af2:	6a02                	ld	s4,0(sp)
}
    80000af4:	70a2                	ld	ra,40(sp)
    80000af6:	7402                	ld	s0,32(sp)
    80000af8:	64e2                	ld	s1,24(sp)
    80000afa:	6145                	addi	sp,sp,48
    80000afc:	8082                	ret

0000000080000afe <kinit>:
{
    80000afe:	1141                	addi	sp,sp,-16
    80000b00:	e406                	sd	ra,8(sp)
    80000b02:	e022                	sd	s0,0(sp)
    80000b04:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b06:	00007597          	auipc	a1,0x7
    80000b0a:	53a58593          	addi	a1,a1,1338 # 80008040 <etext+0x40>
    80000b0e:	00013517          	auipc	a0,0x13
    80000b12:	c6250513          	addi	a0,a0,-926 # 80013770 <kmem>
    80000b16:	06c000ef          	jal	80000b82 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b1a:	45c5                	li	a1,17
    80000b1c:	05ee                	slli	a1,a1,0x1b
    80000b1e:	00024517          	auipc	a0,0x24
    80000b22:	49a50513          	addi	a0,a0,1178 # 80024fb8 <end>
    80000b26:	f91ff0ef          	jal	80000ab6 <freerange>
}
    80000b2a:	60a2                	ld	ra,8(sp)
    80000b2c:	6402                	ld	s0,0(sp)
    80000b2e:	0141                	addi	sp,sp,16
    80000b30:	8082                	ret

0000000080000b32 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b32:	1101                	addi	sp,sp,-32
    80000b34:	ec06                	sd	ra,24(sp)
    80000b36:	e822                	sd	s0,16(sp)
    80000b38:	e426                	sd	s1,8(sp)
    80000b3a:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b3c:	00013497          	auipc	s1,0x13
    80000b40:	c3448493          	addi	s1,s1,-972 # 80013770 <kmem>
    80000b44:	8526                	mv	a0,s1
    80000b46:	0bc000ef          	jal	80000c02 <acquire>
  r = kmem.freelist;
    80000b4a:	6c84                	ld	s1,24(s1)
  if(r)
    80000b4c:	c485                	beqz	s1,80000b74 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b4e:	609c                	ld	a5,0(s1)
    80000b50:	00013517          	auipc	a0,0x13
    80000b54:	c2050513          	addi	a0,a0,-992 # 80013770 <kmem>
    80000b58:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b5a:	140000ef          	jal	80000c9a <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b5e:	6605                	lui	a2,0x1
    80000b60:	4595                	li	a1,5
    80000b62:	8526                	mv	a0,s1
    80000b64:	172000ef          	jal	80000cd6 <memset>
  return (void*)r;
}
    80000b68:	8526                	mv	a0,s1
    80000b6a:	60e2                	ld	ra,24(sp)
    80000b6c:	6442                	ld	s0,16(sp)
    80000b6e:	64a2                	ld	s1,8(sp)
    80000b70:	6105                	addi	sp,sp,32
    80000b72:	8082                	ret
  release(&kmem.lock);
    80000b74:	00013517          	auipc	a0,0x13
    80000b78:	bfc50513          	addi	a0,a0,-1028 # 80013770 <kmem>
    80000b7c:	11e000ef          	jal	80000c9a <release>
  if(r)
    80000b80:	b7e5                	j	80000b68 <kalloc+0x36>

0000000080000b82 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b82:	1141                	addi	sp,sp,-16
    80000b84:	e422                	sd	s0,8(sp)
    80000b86:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b88:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b8a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8e:	00053823          	sd	zero,16(a0)
}
    80000b92:	6422                	ld	s0,8(sp)
    80000b94:	0141                	addi	sp,sp,16
    80000b96:	8082                	ret

0000000080000b98 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b98:	411c                	lw	a5,0(a0)
    80000b9a:	e399                	bnez	a5,80000ba0 <holding+0x8>
    80000b9c:	4501                	li	a0,0
  return r;
}
    80000b9e:	8082                	ret
{
    80000ba0:	1101                	addi	sp,sp,-32
    80000ba2:	ec06                	sd	ra,24(sp)
    80000ba4:	e822                	sd	s0,16(sp)
    80000ba6:	e426                	sd	s1,8(sp)
    80000ba8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000baa:	6904                	ld	s1,16(a0)
    80000bac:	539000ef          	jal	800018e4 <mycpu>
    80000bb0:	40a48533          	sub	a0,s1,a0
    80000bb4:	00153513          	seqz	a0,a0
}
    80000bb8:	60e2                	ld	ra,24(sp)
    80000bba:	6442                	ld	s0,16(sp)
    80000bbc:	64a2                	ld	s1,8(sp)
    80000bbe:	6105                	addi	sp,sp,32
    80000bc0:	8082                	ret

0000000080000bc2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc2:	1101                	addi	sp,sp,-32
    80000bc4:	ec06                	sd	ra,24(sp)
    80000bc6:	e822                	sd	s0,16(sp)
    80000bc8:	e426                	sd	s1,8(sp)
    80000bca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bcc:	100024f3          	csrr	s1,sstatus
    80000bd0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd4:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd6:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bda:	50b000ef          	jal	800018e4 <mycpu>
    80000bde:	5d3c                	lw	a5,120(a0)
    80000be0:	cb99                	beqz	a5,80000bf6 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be2:	503000ef          	jal	800018e4 <mycpu>
    80000be6:	5d3c                	lw	a5,120(a0)
    80000be8:	2785                	addiw	a5,a5,1
    80000bea:	dd3c                	sw	a5,120(a0)
}
    80000bec:	60e2                	ld	ra,24(sp)
    80000bee:	6442                	ld	s0,16(sp)
    80000bf0:	64a2                	ld	s1,8(sp)
    80000bf2:	6105                	addi	sp,sp,32
    80000bf4:	8082                	ret
    mycpu()->intena = old;
    80000bf6:	4ef000ef          	jal	800018e4 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bfa:	8085                	srli	s1,s1,0x1
    80000bfc:	8885                	andi	s1,s1,1
    80000bfe:	dd64                	sw	s1,124(a0)
    80000c00:	b7cd                	j	80000be2 <push_off+0x20>

0000000080000c02 <acquire>:
{
    80000c02:	1101                	addi	sp,sp,-32
    80000c04:	ec06                	sd	ra,24(sp)
    80000c06:	e822                	sd	s0,16(sp)
    80000c08:	e426                	sd	s1,8(sp)
    80000c0a:	1000                	addi	s0,sp,32
    80000c0c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c0e:	fb5ff0ef          	jal	80000bc2 <push_off>
  if(holding(lk))
    80000c12:	8526                	mv	a0,s1
    80000c14:	f85ff0ef          	jal	80000b98 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c18:	4705                	li	a4,1
  if(holding(lk))
    80000c1a:	e105                	bnez	a0,80000c3a <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c1c:	87ba                	mv	a5,a4
    80000c1e:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c22:	2781                	sext.w	a5,a5
    80000c24:	ffe5                	bnez	a5,80000c1c <acquire+0x1a>
  __sync_synchronize();
    80000c26:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c2a:	4bb000ef          	jal	800018e4 <mycpu>
    80000c2e:	e888                	sd	a0,16(s1)
}
    80000c30:	60e2                	ld	ra,24(sp)
    80000c32:	6442                	ld	s0,16(sp)
    80000c34:	64a2                	ld	s1,8(sp)
    80000c36:	6105                	addi	sp,sp,32
    80000c38:	8082                	ret
    panic("acquire");
    80000c3a:	00007517          	auipc	a0,0x7
    80000c3e:	40e50513          	addi	a0,a0,1038 # 80008048 <etext+0x48>
    80000c42:	b61ff0ef          	jal	800007a2 <panic>

0000000080000c46 <pop_off>:

void
pop_off(void)
{
    80000c46:	1141                	addi	sp,sp,-16
    80000c48:	e406                	sd	ra,8(sp)
    80000c4a:	e022                	sd	s0,0(sp)
    80000c4c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c4e:	497000ef          	jal	800018e4 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c52:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c56:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c58:	e78d                	bnez	a5,80000c82 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c5a:	5d3c                	lw	a5,120(a0)
    80000c5c:	02f05963          	blez	a5,80000c8e <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c60:	37fd                	addiw	a5,a5,-1
    80000c62:	0007871b          	sext.w	a4,a5
    80000c66:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c68:	eb09                	bnez	a4,80000c7a <pop_off+0x34>
    80000c6a:	5d7c                	lw	a5,124(a0)
    80000c6c:	c799                	beqz	a5,80000c7a <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c76:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c7a:	60a2                	ld	ra,8(sp)
    80000c7c:	6402                	ld	s0,0(sp)
    80000c7e:	0141                	addi	sp,sp,16
    80000c80:	8082                	ret
    panic("pop_off - interruptible");
    80000c82:	00007517          	auipc	a0,0x7
    80000c86:	3ce50513          	addi	a0,a0,974 # 80008050 <etext+0x50>
    80000c8a:	b19ff0ef          	jal	800007a2 <panic>
    panic("pop_off");
    80000c8e:	00007517          	auipc	a0,0x7
    80000c92:	3da50513          	addi	a0,a0,986 # 80008068 <etext+0x68>
    80000c96:	b0dff0ef          	jal	800007a2 <panic>

0000000080000c9a <release>:
{
    80000c9a:	1101                	addi	sp,sp,-32
    80000c9c:	ec06                	sd	ra,24(sp)
    80000c9e:	e822                	sd	s0,16(sp)
    80000ca0:	e426                	sd	s1,8(sp)
    80000ca2:	1000                	addi	s0,sp,32
    80000ca4:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000ca6:	ef3ff0ef          	jal	80000b98 <holding>
    80000caa:	c105                	beqz	a0,80000cca <release+0x30>
  lk->cpu = 0;
    80000cac:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cb0:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cb4:	0310000f          	fence	rw,w
    80000cb8:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cbc:	f8bff0ef          	jal	80000c46 <pop_off>
}
    80000cc0:	60e2                	ld	ra,24(sp)
    80000cc2:	6442                	ld	s0,16(sp)
    80000cc4:	64a2                	ld	s1,8(sp)
    80000cc6:	6105                	addi	sp,sp,32
    80000cc8:	8082                	ret
    panic("release");
    80000cca:	00007517          	auipc	a0,0x7
    80000cce:	3a650513          	addi	a0,a0,934 # 80008070 <etext+0x70>
    80000cd2:	ad1ff0ef          	jal	800007a2 <panic>

0000000080000cd6 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cd6:	1141                	addi	sp,sp,-16
    80000cd8:	e422                	sd	s0,8(sp)
    80000cda:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cdc:	ca19                	beqz	a2,80000cf2 <memset+0x1c>
    80000cde:	87aa                	mv	a5,a0
    80000ce0:	1602                	slli	a2,a2,0x20
    80000ce2:	9201                	srli	a2,a2,0x20
    80000ce4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x12>
  }
  return dst;
}
    80000cf2:	6422                	ld	s0,8(sp)
    80000cf4:	0141                	addi	sp,sp,16
    80000cf6:	8082                	ret

0000000080000cf8 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cf8:	1141                	addi	sp,sp,-16
    80000cfa:	e422                	sd	s0,8(sp)
    80000cfc:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cfe:	ca05                	beqz	a2,80000d2e <memcmp+0x36>
    80000d00:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d04:	1682                	slli	a3,a3,0x20
    80000d06:	9281                	srli	a3,a3,0x20
    80000d08:	0685                	addi	a3,a3,1
    80000d0a:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79863          	bne	a5,a4,80000d24 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x14>
  }

  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	a019                	j	80000d28 <memcmp+0x30>
      return *s1 - *s2;
    80000d24:	40e7853b          	subw	a0,a5,a4
}
    80000d28:	6422                	ld	s0,8(sp)
    80000d2a:	0141                	addi	sp,sp,16
    80000d2c:	8082                	ret
  return 0;
    80000d2e:	4501                	li	a0,0
    80000d30:	bfe5                	j	80000d28 <memcmp+0x30>

0000000080000d32 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d38:	c205                	beqz	a2,80000d58 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d3a:	02a5e263          	bltu	a1,a0,80000d5e <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d3e:	1602                	slli	a2,a2,0x20
    80000d40:	9201                	srli	a2,a2,0x20
    80000d42:	00c587b3          	add	a5,a1,a2
{
    80000d46:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d48:	0585                	addi	a1,a1,1
    80000d4a:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffda049>
    80000d4c:	fff5c683          	lbu	a3,-1(a1)
    80000d50:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d54:	feb79ae3          	bne	a5,a1,80000d48 <memmove+0x16>

  return dst;
}
    80000d58:	6422                	ld	s0,8(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret
  if(s < d && s + n > d){
    80000d5e:	02061693          	slli	a3,a2,0x20
    80000d62:	9281                	srli	a3,a3,0x20
    80000d64:	00d58733          	add	a4,a1,a3
    80000d68:	fce57be3          	bgeu	a0,a4,80000d3e <memmove+0xc>
    d += n;
    80000d6c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d6e:	fff6079b          	addiw	a5,a2,-1
    80000d72:	1782                	slli	a5,a5,0x20
    80000d74:	9381                	srli	a5,a5,0x20
    80000d76:	fff7c793          	not	a5,a5
    80000d7a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d7c:	177d                	addi	a4,a4,-1
    80000d7e:	16fd                	addi	a3,a3,-1
    80000d80:	00074603          	lbu	a2,0(a4)
    80000d84:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d88:	fef71ae3          	bne	a4,a5,80000d7c <memmove+0x4a>
    80000d8c:	b7f1                	j	80000d58 <memmove+0x26>

0000000080000d8e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d8e:	1141                	addi	sp,sp,-16
    80000d90:	e406                	sd	ra,8(sp)
    80000d92:	e022                	sd	s0,0(sp)
    80000d94:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d96:	f9dff0ef          	jal	80000d32 <memmove>
}
    80000d9a:	60a2                	ld	ra,8(sp)
    80000d9c:	6402                	ld	s0,0(sp)
    80000d9e:	0141                	addi	sp,sp,16
    80000da0:	8082                	ret

0000000080000da2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e422                	sd	s0,8(sp)
    80000da6:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000da8:	ce11                	beqz	a2,80000dc4 <strncmp+0x22>
    80000daa:	00054783          	lbu	a5,0(a0)
    80000dae:	cf89                	beqz	a5,80000dc8 <strncmp+0x26>
    80000db0:	0005c703          	lbu	a4,0(a1)
    80000db4:	00f71a63          	bne	a4,a5,80000dc8 <strncmp+0x26>
    n--, p++, q++;
    80000db8:	367d                	addiw	a2,a2,-1
    80000dba:	0505                	addi	a0,a0,1
    80000dbc:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000dbe:	f675                	bnez	a2,80000daa <strncmp+0x8>
  if(n == 0)
    return 0;
    80000dc0:	4501                	li	a0,0
    80000dc2:	a801                	j	80000dd2 <strncmp+0x30>
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	6422                	ld	s0,8(sp)
    80000dd4:	0141                	addi	sp,sp,16
    80000dd6:	8082                	ret

0000000080000dd8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dd8:	1141                	addi	sp,sp,-16
    80000dda:	e422                	sd	s0,8(sp)
    80000ddc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dde:	87aa                	mv	a5,a0
    80000de0:	86b2                	mv	a3,a2
    80000de2:	367d                	addiw	a2,a2,-1
    80000de4:	02d05563          	blez	a3,80000e0e <strncpy+0x36>
    80000de8:	0785                	addi	a5,a5,1
    80000dea:	0005c703          	lbu	a4,0(a1)
    80000dee:	fee78fa3          	sb	a4,-1(a5)
    80000df2:	0585                	addi	a1,a1,1
    80000df4:	f775                	bnez	a4,80000de0 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000df6:	873e                	mv	a4,a5
    80000df8:	9fb5                	addw	a5,a5,a3
    80000dfa:	37fd                	addiw	a5,a5,-1
    80000dfc:	00c05963          	blez	a2,80000e0e <strncpy+0x36>
    *s++ = 0;
    80000e00:	0705                	addi	a4,a4,1
    80000e02:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e06:	40e786bb          	subw	a3,a5,a4
    80000e0a:	fed04be3          	bgtz	a3,80000e00 <strncpy+0x28>
  return os;
}
    80000e0e:	6422                	ld	s0,8(sp)
    80000e10:	0141                	addi	sp,sp,16
    80000e12:	8082                	ret

0000000080000e14 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e422                	sd	s0,8(sp)
    80000e18:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e1a:	02c05363          	blez	a2,80000e40 <safestrcpy+0x2c>
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	1682                	slli	a3,a3,0x20
    80000e24:	9281                	srli	a3,a3,0x20
    80000e26:	96ae                	add	a3,a3,a1
    80000e28:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e2a:	00d58963          	beq	a1,a3,80000e3c <safestrcpy+0x28>
    80000e2e:	0585                	addi	a1,a1,1
    80000e30:	0785                	addi	a5,a5,1
    80000e32:	fff5c703          	lbu	a4,-1(a1)
    80000e36:	fee78fa3          	sb	a4,-1(a5)
    80000e3a:	fb65                	bnez	a4,80000e2a <safestrcpy+0x16>
    ;
  *s = 0;
    80000e3c:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <strlen>:

int
strlen(const char *s)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e4c:	00054783          	lbu	a5,0(a0)
    80000e50:	cf91                	beqz	a5,80000e6c <strlen+0x26>
    80000e52:	0505                	addi	a0,a0,1
    80000e54:	87aa                	mv	a5,a0
    80000e56:	86be                	mv	a3,a5
    80000e58:	0785                	addi	a5,a5,1
    80000e5a:	fff7c703          	lbu	a4,-1(a5)
    80000e5e:	ff65                	bnez	a4,80000e56 <strlen+0x10>
    80000e60:	40a6853b          	subw	a0,a3,a0
    80000e64:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e66:	6422                	ld	s0,8(sp)
    80000e68:	0141                	addi	sp,sp,16
    80000e6a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e6c:	4501                	li	a0,0
    80000e6e:	bfe5                	j	80000e66 <strlen+0x20>

0000000080000e70 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e70:	1141                	addi	sp,sp,-16
    80000e72:	e406                	sd	ra,8(sp)
    80000e74:	e022                	sd	s0,0(sp)
    80000e76:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e78:	25d000ef          	jal	800018d4 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e7c:	0000a717          	auipc	a4,0xa
    80000e80:	7ac70713          	addi	a4,a4,1964 # 8000b628 <started>
  if(cpuid() == 0){
    80000e84:	c51d                	beqz	a0,80000eb2 <main+0x42>
    while(started == 0)
    80000e86:	431c                	lw	a5,0(a4)
    80000e88:	2781                	sext.w	a5,a5
    80000e8a:	dff5                	beqz	a5,80000e86 <main+0x16>
      ;
    __sync_synchronize();
    80000e8c:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e90:	245000ef          	jal	800018d4 <cpuid>
    80000e94:	85aa                	mv	a1,a0
    80000e96:	00007517          	auipc	a0,0x7
    80000e9a:	20250513          	addi	a0,a0,514 # 80008098 <etext+0x98>
    80000e9e:	e32ff0ef          	jal	800004d0 <printf>
    kvminithart();    // turn on paging
    80000ea2:	080000ef          	jal	80000f22 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000ea6:	121010ef          	jal	800027c6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000eaa:	1ff040ef          	jal	800058a8 <plicinithart>
  }

  scheduler();
    80000eae:	75d000ef          	jal	80001e0a <scheduler>
    consoleinit();
    80000eb2:	d48ff0ef          	jal	800003fa <consoleinit>
    printfinit();
    80000eb6:	927ff0ef          	jal	800007dc <printfinit>
    printf("\n");
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	1be50513          	addi	a0,a0,446 # 80008078 <etext+0x78>
    80000ec2:	e0eff0ef          	jal	800004d0 <printf>
    printf("xv6 kernel is booting\n");
    80000ec6:	00007517          	auipc	a0,0x7
    80000eca:	1ba50513          	addi	a0,a0,442 # 80008080 <etext+0x80>
    80000ece:	e02ff0ef          	jal	800004d0 <printf>
    printf("\n");
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1a650513          	addi	a0,a0,422 # 80008078 <etext+0x78>
    80000eda:	df6ff0ef          	jal	800004d0 <printf>
    kinit();         // physical page allocator
    80000ede:	c21ff0ef          	jal	80000afe <kinit>
    kvminit();       // create kernel page table
    80000ee2:	2dc000ef          	jal	800011be <kvminit>
    kvminithart();   // turn on paging
    80000ee6:	03c000ef          	jal	80000f22 <kvminithart>
    procinit();      // process table
    80000eea:	135000ef          	jal	8000181e <procinit>
    trapinit();      // trap vectors
    80000eee:	0b5010ef          	jal	800027a2 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ef2:	0d5010ef          	jal	800027c6 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ef6:	199040ef          	jal	8000588e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000efa:	1af040ef          	jal	800058a8 <plicinithart>
    binit();         // buffer cache
    80000efe:	15c020ef          	jal	8000305a <binit>
    iinit();         // inode table
    80000f02:	74e020ef          	jal	80003650 <iinit>
    fileinit();      // file table
    80000f06:	4fa030ef          	jal	80004400 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f0a:	28f040ef          	jal	80005998 <virtio_disk_init>
    userinit();      // first user process
    80000f0e:	489000ef          	jal	80001b96 <userinit>
    __sync_synchronize();
    80000f12:	0330000f          	fence	rw,rw
    started = 1;
    80000f16:	4785                	li	a5,1
    80000f18:	0000a717          	auipc	a4,0xa
    80000f1c:	70f72823          	sw	a5,1808(a4) # 8000b628 <started>
    80000f20:	b779                	j	80000eae <main+0x3e>

0000000080000f22 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f22:	1141                	addi	sp,sp,-16
    80000f24:	e422                	sd	s0,8(sp)
    80000f26:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f28:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f2c:	0000a797          	auipc	a5,0xa
    80000f30:	7047b783          	ld	a5,1796(a5) # 8000b630 <kernel_pagetable>
    80000f34:	83b1                	srli	a5,a5,0xc
    80000f36:	577d                	li	a4,-1
    80000f38:	177e                	slli	a4,a4,0x3f
    80000f3a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f3c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f40:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f44:	6422                	ld	s0,8(sp)
    80000f46:	0141                	addi	sp,sp,16
    80000f48:	8082                	ret

0000000080000f4a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f4a:	7139                	addi	sp,sp,-64
    80000f4c:	fc06                	sd	ra,56(sp)
    80000f4e:	f822                	sd	s0,48(sp)
    80000f50:	f426                	sd	s1,40(sp)
    80000f52:	f04a                	sd	s2,32(sp)
    80000f54:	ec4e                	sd	s3,24(sp)
    80000f56:	e852                	sd	s4,16(sp)
    80000f58:	e456                	sd	s5,8(sp)
    80000f5a:	e05a                	sd	s6,0(sp)
    80000f5c:	0080                	addi	s0,sp,64
    80000f5e:	84aa                	mv	s1,a0
    80000f60:	89ae                	mv	s3,a1
    80000f62:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f64:	57fd                	li	a5,-1
    80000f66:	83e9                	srli	a5,a5,0x1a
    80000f68:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f6a:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f6c:	02b7fc63          	bgeu	a5,a1,80000fa4 <walk+0x5a>
    panic("walk");
    80000f70:	00007517          	auipc	a0,0x7
    80000f74:	14050513          	addi	a0,a0,320 # 800080b0 <etext+0xb0>
    80000f78:	82bff0ef          	jal	800007a2 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f7c:	060a8263          	beqz	s5,80000fe0 <walk+0x96>
    80000f80:	bb3ff0ef          	jal	80000b32 <kalloc>
    80000f84:	84aa                	mv	s1,a0
    80000f86:	c139                	beqz	a0,80000fcc <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f88:	6605                	lui	a2,0x1
    80000f8a:	4581                	li	a1,0
    80000f8c:	d4bff0ef          	jal	80000cd6 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f90:	00c4d793          	srli	a5,s1,0xc
    80000f94:	07aa                	slli	a5,a5,0xa
    80000f96:	0017e793          	ori	a5,a5,1
    80000f9a:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f9e:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffda03f>
    80000fa0:	036a0063          	beq	s4,s6,80000fc0 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fa4:	0149d933          	srl	s2,s3,s4
    80000fa8:	1ff97913          	andi	s2,s2,511
    80000fac:	090e                	slli	s2,s2,0x3
    80000fae:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fb0:	00093483          	ld	s1,0(s2)
    80000fb4:	0014f793          	andi	a5,s1,1
    80000fb8:	d3f1                	beqz	a5,80000f7c <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fba:	80a9                	srli	s1,s1,0xa
    80000fbc:	04b2                	slli	s1,s1,0xc
    80000fbe:	b7c5                	j	80000f9e <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fc0:	00c9d513          	srli	a0,s3,0xc
    80000fc4:	1ff57513          	andi	a0,a0,511
    80000fc8:	050e                	slli	a0,a0,0x3
    80000fca:	9526                	add	a0,a0,s1
}
    80000fcc:	70e2                	ld	ra,56(sp)
    80000fce:	7442                	ld	s0,48(sp)
    80000fd0:	74a2                	ld	s1,40(sp)
    80000fd2:	7902                	ld	s2,32(sp)
    80000fd4:	69e2                	ld	s3,24(sp)
    80000fd6:	6a42                	ld	s4,16(sp)
    80000fd8:	6aa2                	ld	s5,8(sp)
    80000fda:	6b02                	ld	s6,0(sp)
    80000fdc:	6121                	addi	sp,sp,64
    80000fde:	8082                	ret
        return 0;
    80000fe0:	4501                	li	a0,0
    80000fe2:	b7ed                	j	80000fcc <walk+0x82>

0000000080000fe4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000fe4:	57fd                	li	a5,-1
    80000fe6:	83e9                	srli	a5,a5,0x1a
    80000fe8:	00b7f463          	bgeu	a5,a1,80000ff0 <walkaddr+0xc>
    return 0;
    80000fec:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fee:	8082                	ret
{
    80000ff0:	1141                	addi	sp,sp,-16
    80000ff2:	e406                	sd	ra,8(sp)
    80000ff4:	e022                	sd	s0,0(sp)
    80000ff6:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000ff8:	4601                	li	a2,0
    80000ffa:	f51ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80000ffe:	c105                	beqz	a0,8000101e <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001000:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001002:	0117f693          	andi	a3,a5,17
    80001006:	4745                	li	a4,17
    return 0;
    80001008:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000100a:	00e68663          	beq	a3,a4,80001016 <walkaddr+0x32>
}
    8000100e:	60a2                	ld	ra,8(sp)
    80001010:	6402                	ld	s0,0(sp)
    80001012:	0141                	addi	sp,sp,16
    80001014:	8082                	ret
  pa = PTE2PA(*pte);
    80001016:	83a9                	srli	a5,a5,0xa
    80001018:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000101c:	bfcd                	j	8000100e <walkaddr+0x2a>
    return 0;
    8000101e:	4501                	li	a0,0
    80001020:	b7fd                	j	8000100e <walkaddr+0x2a>

0000000080001022 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001022:	715d                	addi	sp,sp,-80
    80001024:	e486                	sd	ra,72(sp)
    80001026:	e0a2                	sd	s0,64(sp)
    80001028:	fc26                	sd	s1,56(sp)
    8000102a:	f84a                	sd	s2,48(sp)
    8000102c:	f44e                	sd	s3,40(sp)
    8000102e:	f052                	sd	s4,32(sp)
    80001030:	ec56                	sd	s5,24(sp)
    80001032:	e85a                	sd	s6,16(sp)
    80001034:	e45e                	sd	s7,8(sp)
    80001036:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001038:	03459793          	slli	a5,a1,0x34
    8000103c:	e7a9                	bnez	a5,80001086 <mappages+0x64>
    8000103e:	8aaa                	mv	s5,a0
    80001040:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001042:	03461793          	slli	a5,a2,0x34
    80001046:	e7b1                	bnez	a5,80001092 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001048:	ca39                	beqz	a2,8000109e <mappages+0x7c>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    8000104a:	77fd                	lui	a5,0xfffff
    8000104c:	963e                	add	a2,a2,a5
    8000104e:	00b609b3          	add	s3,a2,a1
  a = va;
    80001052:	892e                	mv	s2,a1
    80001054:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001058:	6b85                	lui	s7,0x1
    8000105a:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4605                	li	a2,1
    80001060:	85ca                	mv	a1,s2
    80001062:	8556                	mv	a0,s5
    80001064:	ee7ff0ef          	jal	80000f4a <walk>
    80001068:	c539                	beqz	a0,800010b6 <mappages+0x94>
    if(*pte & PTE_V)
    8000106a:	611c                	ld	a5,0(a0)
    8000106c:	8b85                	andi	a5,a5,1
    8000106e:	ef95                	bnez	a5,800010aa <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001070:	80b1                	srli	s1,s1,0xc
    80001072:	04aa                	slli	s1,s1,0xa
    80001074:	0164e4b3          	or	s1,s1,s6
    80001078:	0014e493          	ori	s1,s1,1
    8000107c:	e104                	sd	s1,0(a0)
    if(a == last)
    8000107e:	05390863          	beq	s2,s3,800010ce <mappages+0xac>
    a += PGSIZE;
    80001082:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001084:	bfd9                	j	8000105a <mappages+0x38>
    panic("mappages: va not aligned");
    80001086:	00007517          	auipc	a0,0x7
    8000108a:	03250513          	addi	a0,a0,50 # 800080b8 <etext+0xb8>
    8000108e:	f14ff0ef          	jal	800007a2 <panic>
    panic("mappages: size not aligned");
    80001092:	00007517          	auipc	a0,0x7
    80001096:	04650513          	addi	a0,a0,70 # 800080d8 <etext+0xd8>
    8000109a:	f08ff0ef          	jal	800007a2 <panic>
    panic("mappages: size");
    8000109e:	00007517          	auipc	a0,0x7
    800010a2:	05a50513          	addi	a0,a0,90 # 800080f8 <etext+0xf8>
    800010a6:	efcff0ef          	jal	800007a2 <panic>
      panic("mappages: remap");
    800010aa:	00007517          	auipc	a0,0x7
    800010ae:	05e50513          	addi	a0,a0,94 # 80008108 <etext+0x108>
    800010b2:	ef0ff0ef          	jal	800007a2 <panic>
      return -1;
    800010b6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010b8:	60a6                	ld	ra,72(sp)
    800010ba:	6406                	ld	s0,64(sp)
    800010bc:	74e2                	ld	s1,56(sp)
    800010be:	7942                	ld	s2,48(sp)
    800010c0:	79a2                	ld	s3,40(sp)
    800010c2:	7a02                	ld	s4,32(sp)
    800010c4:	6ae2                	ld	s5,24(sp)
    800010c6:	6b42                	ld	s6,16(sp)
    800010c8:	6ba2                	ld	s7,8(sp)
    800010ca:	6161                	addi	sp,sp,80
    800010cc:	8082                	ret
  return 0;
    800010ce:	4501                	li	a0,0
    800010d0:	b7e5                	j	800010b8 <mappages+0x96>

00000000800010d2 <kvmmap>:
{
    800010d2:	1141                	addi	sp,sp,-16
    800010d4:	e406                	sd	ra,8(sp)
    800010d6:	e022                	sd	s0,0(sp)
    800010d8:	0800                	addi	s0,sp,16
    800010da:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010dc:	86b2                	mv	a3,a2
    800010de:	863e                	mv	a2,a5
    800010e0:	f43ff0ef          	jal	80001022 <mappages>
    800010e4:	e509                	bnez	a0,800010ee <kvmmap+0x1c>
}
    800010e6:	60a2                	ld	ra,8(sp)
    800010e8:	6402                	ld	s0,0(sp)
    800010ea:	0141                	addi	sp,sp,16
    800010ec:	8082                	ret
    panic("kvmmap");
    800010ee:	00007517          	auipc	a0,0x7
    800010f2:	02a50513          	addi	a0,a0,42 # 80008118 <etext+0x118>
    800010f6:	eacff0ef          	jal	800007a2 <panic>

00000000800010fa <kvmmake>:
{
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	e04a                	sd	s2,0(sp)
    80001104:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001106:	a2dff0ef          	jal	80000b32 <kalloc>
    8000110a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000110c:	6605                	lui	a2,0x1
    8000110e:	4581                	li	a1,0
    80001110:	bc7ff0ef          	jal	80000cd6 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10000637          	lui	a2,0x10000
    8000111c:	100005b7          	lui	a1,0x10000
    80001120:	8526                	mv	a0,s1
    80001122:	fb1ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001126:	4719                	li	a4,6
    80001128:	6685                	lui	a3,0x1
    8000112a:	10001637          	lui	a2,0x10001
    8000112e:	100015b7          	lui	a1,0x10001
    80001132:	8526                	mv	a0,s1
    80001134:	f9fff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001138:	4719                	li	a4,6
    8000113a:	040006b7          	lui	a3,0x4000
    8000113e:	0c000637          	lui	a2,0xc000
    80001142:	0c0005b7          	lui	a1,0xc000
    80001146:	8526                	mv	a0,s1
    80001148:	f8bff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000114c:	00007917          	auipc	s2,0x7
    80001150:	eb490913          	addi	s2,s2,-332 # 80008000 <etext>
    80001154:	4729                	li	a4,10
    80001156:	80007697          	auipc	a3,0x80007
    8000115a:	eaa68693          	addi	a3,a3,-342 # 8000 <_entry-0x7fff8000>
    8000115e:	4605                	li	a2,1
    80001160:	067e                	slli	a2,a2,0x1f
    80001162:	85b2                	mv	a1,a2
    80001164:	8526                	mv	a0,s1
    80001166:	f6dff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000116a:	46c5                	li	a3,17
    8000116c:	06ee                	slli	a3,a3,0x1b
    8000116e:	4719                	li	a4,6
    80001170:	412686b3          	sub	a3,a3,s2
    80001174:	864a                	mv	a2,s2
    80001176:	85ca                	mv	a1,s2
    80001178:	8526                	mv	a0,s1
    8000117a:	f59ff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000117e:	4729                	li	a4,10
    80001180:	6685                	lui	a3,0x1
    80001182:	00006617          	auipc	a2,0x6
    80001186:	e7e60613          	addi	a2,a2,-386 # 80007000 <_trampoline>
    8000118a:	040005b7          	lui	a1,0x4000
    8000118e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001190:	05b2                	slli	a1,a1,0xc
    80001192:	8526                	mv	a0,s1
    80001194:	f3fff0ef          	jal	800010d2 <kvmmap>
  kvmmap(kpgtbl, 0x100000, 0x100000, PGSIZE, PTE_R | PTE_W);
    80001198:	4719                	li	a4,6
    8000119a:	6685                	lui	a3,0x1
    8000119c:	00100637          	lui	a2,0x100
    800011a0:	001005b7          	lui	a1,0x100
    800011a4:	8526                	mv	a0,s1
    800011a6:	f2dff0ef          	jal	800010d2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011aa:	8526                	mv	a0,s1
    800011ac:	5da000ef          	jal	80001786 <proc_mapstacks>
}
    800011b0:	8526                	mv	a0,s1
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6902                	ld	s2,0(sp)
    800011ba:	6105                	addi	sp,sp,32
    800011bc:	8082                	ret

00000000800011be <kvminit>:
{
    800011be:	1141                	addi	sp,sp,-16
    800011c0:	e406                	sd	ra,8(sp)
    800011c2:	e022                	sd	s0,0(sp)
    800011c4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011c6:	f35ff0ef          	jal	800010fa <kvmmake>
    800011ca:	0000a797          	auipc	a5,0xa
    800011ce:	46a7b323          	sd	a0,1126(a5) # 8000b630 <kernel_pagetable>
}
    800011d2:	60a2                	ld	ra,8(sp)
    800011d4:	6402                	ld	s0,0(sp)
    800011d6:	0141                	addi	sp,sp,16
    800011d8:	8082                	ret

00000000800011da <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011da:	715d                	addi	sp,sp,-80
    800011dc:	e486                	sd	ra,72(sp)
    800011de:	e0a2                	sd	s0,64(sp)
    800011e0:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011e2:	03459793          	slli	a5,a1,0x34
    800011e6:	e39d                	bnez	a5,8000120c <uvmunmap+0x32>
    800011e8:	f84a                	sd	s2,48(sp)
    800011ea:	f44e                	sd	s3,40(sp)
    800011ec:	f052                	sd	s4,32(sp)
    800011ee:	ec56                	sd	s5,24(sp)
    800011f0:	e85a                	sd	s6,16(sp)
    800011f2:	e45e                	sd	s7,8(sp)
    800011f4:	8a2a                	mv	s4,a0
    800011f6:	892e                	mv	s2,a1
    800011f8:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800011fa:	0632                	slli	a2,a2,0xc
    800011fc:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001200:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001202:	6b05                	lui	s6,0x1
    80001204:	0735ff63          	bgeu	a1,s3,80001282 <uvmunmap+0xa8>
    80001208:	fc26                	sd	s1,56(sp)
    8000120a:	a0a9                	j	80001254 <uvmunmap+0x7a>
    8000120c:	fc26                	sd	s1,56(sp)
    8000120e:	f84a                	sd	s2,48(sp)
    80001210:	f44e                	sd	s3,40(sp)
    80001212:	f052                	sd	s4,32(sp)
    80001214:	ec56                	sd	s5,24(sp)
    80001216:	e85a                	sd	s6,16(sp)
    80001218:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000121a:	00007517          	auipc	a0,0x7
    8000121e:	f0650513          	addi	a0,a0,-250 # 80008120 <etext+0x120>
    80001222:	d80ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: walk");
    80001226:	00007517          	auipc	a0,0x7
    8000122a:	f1250513          	addi	a0,a0,-238 # 80008138 <etext+0x138>
    8000122e:	d74ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not mapped");
    80001232:	00007517          	auipc	a0,0x7
    80001236:	f1650513          	addi	a0,a0,-234 # 80008148 <etext+0x148>
    8000123a:	d68ff0ef          	jal	800007a2 <panic>
      panic("uvmunmap: not a leaf");
    8000123e:	00007517          	auipc	a0,0x7
    80001242:	f2250513          	addi	a0,a0,-222 # 80008160 <etext+0x160>
    80001246:	d5cff0ef          	jal	800007a2 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000124a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000124e:	995a                	add	s2,s2,s6
    80001250:	03397863          	bgeu	s2,s3,80001280 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001254:	4601                	li	a2,0
    80001256:	85ca                	mv	a1,s2
    80001258:	8552                	mv	a0,s4
    8000125a:	cf1ff0ef          	jal	80000f4a <walk>
    8000125e:	84aa                	mv	s1,a0
    80001260:	d179                	beqz	a0,80001226 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001262:	6108                	ld	a0,0(a0)
    80001264:	00157793          	andi	a5,a0,1
    80001268:	d7e9                	beqz	a5,80001232 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000126a:	3ff57793          	andi	a5,a0,1023
    8000126e:	fd7788e3          	beq	a5,s7,8000123e <uvmunmap+0x64>
    if(do_free){
    80001272:	fc0a8ce3          	beqz	s5,8000124a <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001276:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001278:	0532                	slli	a0,a0,0xc
    8000127a:	fd6ff0ef          	jal	80000a50 <kfree>
    8000127e:	b7f1                	j	8000124a <uvmunmap+0x70>
    80001280:	74e2                	ld	s1,56(sp)
    80001282:	7942                	ld	s2,48(sp)
    80001284:	79a2                	ld	s3,40(sp)
    80001286:	7a02                	ld	s4,32(sp)
    80001288:	6ae2                	ld	s5,24(sp)
    8000128a:	6b42                	ld	s6,16(sp)
    8000128c:	6ba2                	ld	s7,8(sp)
  }
}
    8000128e:	60a6                	ld	ra,72(sp)
    80001290:	6406                	ld	s0,64(sp)
    80001292:	6161                	addi	sp,sp,80
    80001294:	8082                	ret

0000000080001296 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001296:	1101                	addi	sp,sp,-32
    80001298:	ec06                	sd	ra,24(sp)
    8000129a:	e822                	sd	s0,16(sp)
    8000129c:	e426                	sd	s1,8(sp)
    8000129e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012a0:	893ff0ef          	jal	80000b32 <kalloc>
    800012a4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012a6:	c509                	beqz	a0,800012b0 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012a8:	6605                	lui	a2,0x1
    800012aa:	4581                	li	a1,0
    800012ac:	a2bff0ef          	jal	80000cd6 <memset>
  return pagetable;
}
    800012b0:	8526                	mv	a0,s1
    800012b2:	60e2                	ld	ra,24(sp)
    800012b4:	6442                	ld	s0,16(sp)
    800012b6:	64a2                	ld	s1,8(sp)
    800012b8:	6105                	addi	sp,sp,32
    800012ba:	8082                	ret

00000000800012bc <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012bc:	7179                	addi	sp,sp,-48
    800012be:	f406                	sd	ra,40(sp)
    800012c0:	f022                	sd	s0,32(sp)
    800012c2:	ec26                	sd	s1,24(sp)
    800012c4:	e84a                	sd	s2,16(sp)
    800012c6:	e44e                	sd	s3,8(sp)
    800012c8:	e052                	sd	s4,0(sp)
    800012ca:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012cc:	6785                	lui	a5,0x1
    800012ce:	04f67063          	bgeu	a2,a5,8000130e <uvmfirst+0x52>
    800012d2:	8a2a                	mv	s4,a0
    800012d4:	89ae                	mv	s3,a1
    800012d6:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012d8:	85bff0ef          	jal	80000b32 <kalloc>
    800012dc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012de:	6605                	lui	a2,0x1
    800012e0:	4581                	li	a1,0
    800012e2:	9f5ff0ef          	jal	80000cd6 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012e6:	4779                	li	a4,30
    800012e8:	86ca                	mv	a3,s2
    800012ea:	6605                	lui	a2,0x1
    800012ec:	4581                	li	a1,0
    800012ee:	8552                	mv	a0,s4
    800012f0:	d33ff0ef          	jal	80001022 <mappages>
  memmove(mem, src, sz);
    800012f4:	8626                	mv	a2,s1
    800012f6:	85ce                	mv	a1,s3
    800012f8:	854a                	mv	a0,s2
    800012fa:	a39ff0ef          	jal	80000d32 <memmove>
}
    800012fe:	70a2                	ld	ra,40(sp)
    80001300:	7402                	ld	s0,32(sp)
    80001302:	64e2                	ld	s1,24(sp)
    80001304:	6942                	ld	s2,16(sp)
    80001306:	69a2                	ld	s3,8(sp)
    80001308:	6a02                	ld	s4,0(sp)
    8000130a:	6145                	addi	sp,sp,48
    8000130c:	8082                	ret
    panic("uvmfirst: more than a page");
    8000130e:	00007517          	auipc	a0,0x7
    80001312:	e6a50513          	addi	a0,a0,-406 # 80008178 <etext+0x178>
    80001316:	c8cff0ef          	jal	800007a2 <panic>

000000008000131a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000131a:	1101                	addi	sp,sp,-32
    8000131c:	ec06                	sd	ra,24(sp)
    8000131e:	e822                	sd	s0,16(sp)
    80001320:	e426                	sd	s1,8(sp)
    80001322:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001324:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001326:	00b67d63          	bgeu	a2,a1,80001340 <uvmdealloc+0x26>
    8000132a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000132c:	6785                	lui	a5,0x1
    8000132e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001330:	00f60733          	add	a4,a2,a5
    80001334:	76fd                	lui	a3,0xfffff
    80001336:	8f75                	and	a4,a4,a3
    80001338:	97ae                	add	a5,a5,a1
    8000133a:	8ff5                	and	a5,a5,a3
    8000133c:	00f76863          	bltu	a4,a5,8000134c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001340:	8526                	mv	a0,s1
    80001342:	60e2                	ld	ra,24(sp)
    80001344:	6442                	ld	s0,16(sp)
    80001346:	64a2                	ld	s1,8(sp)
    80001348:	6105                	addi	sp,sp,32
    8000134a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000134c:	8f99                	sub	a5,a5,a4
    8000134e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001350:	4685                	li	a3,1
    80001352:	0007861b          	sext.w	a2,a5
    80001356:	85ba                	mv	a1,a4
    80001358:	e83ff0ef          	jal	800011da <uvmunmap>
    8000135c:	b7d5                	j	80001340 <uvmdealloc+0x26>

000000008000135e <uvmalloc>:
  if(newsz < oldsz)
    8000135e:	08b66f63          	bltu	a2,a1,800013fc <uvmalloc+0x9e>
{
    80001362:	7139                	addi	sp,sp,-64
    80001364:	fc06                	sd	ra,56(sp)
    80001366:	f822                	sd	s0,48(sp)
    80001368:	ec4e                	sd	s3,24(sp)
    8000136a:	e852                	sd	s4,16(sp)
    8000136c:	e456                	sd	s5,8(sp)
    8000136e:	0080                	addi	s0,sp,64
    80001370:	8aaa                	mv	s5,a0
    80001372:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001374:	6785                	lui	a5,0x1
    80001376:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001378:	95be                	add	a1,a1,a5
    8000137a:	77fd                	lui	a5,0xfffff
    8000137c:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001380:	08c9f063          	bgeu	s3,a2,80001400 <uvmalloc+0xa2>
    80001384:	f426                	sd	s1,40(sp)
    80001386:	f04a                	sd	s2,32(sp)
    80001388:	e05a                	sd	s6,0(sp)
    8000138a:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000138c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001390:	fa2ff0ef          	jal	80000b32 <kalloc>
    80001394:	84aa                	mv	s1,a0
    if(mem == 0){
    80001396:	c515                	beqz	a0,800013c2 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001398:	6605                	lui	a2,0x1
    8000139a:	4581                	li	a1,0
    8000139c:	93bff0ef          	jal	80000cd6 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013a0:	875a                	mv	a4,s6
    800013a2:	86a6                	mv	a3,s1
    800013a4:	6605                	lui	a2,0x1
    800013a6:	85ca                	mv	a1,s2
    800013a8:	8556                	mv	a0,s5
    800013aa:	c79ff0ef          	jal	80001022 <mappages>
    800013ae:	e915                	bnez	a0,800013e2 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013b0:	6785                	lui	a5,0x1
    800013b2:	993e                	add	s2,s2,a5
    800013b4:	fd496ee3          	bltu	s2,s4,80001390 <uvmalloc+0x32>
  return newsz;
    800013b8:	8552                	mv	a0,s4
    800013ba:	74a2                	ld	s1,40(sp)
    800013bc:	7902                	ld	s2,32(sp)
    800013be:	6b02                	ld	s6,0(sp)
    800013c0:	a811                	j	800013d4 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013c2:	864e                	mv	a2,s3
    800013c4:	85ca                	mv	a1,s2
    800013c6:	8556                	mv	a0,s5
    800013c8:	f53ff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013cc:	4501                	li	a0,0
    800013ce:	74a2                	ld	s1,40(sp)
    800013d0:	7902                	ld	s2,32(sp)
    800013d2:	6b02                	ld	s6,0(sp)
}
    800013d4:	70e2                	ld	ra,56(sp)
    800013d6:	7442                	ld	s0,48(sp)
    800013d8:	69e2                	ld	s3,24(sp)
    800013da:	6a42                	ld	s4,16(sp)
    800013dc:	6aa2                	ld	s5,8(sp)
    800013de:	6121                	addi	sp,sp,64
    800013e0:	8082                	ret
      kfree(mem);
    800013e2:	8526                	mv	a0,s1
    800013e4:	e6cff0ef          	jal	80000a50 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013e8:	864e                	mv	a2,s3
    800013ea:	85ca                	mv	a1,s2
    800013ec:	8556                	mv	a0,s5
    800013ee:	f2dff0ef          	jal	8000131a <uvmdealloc>
      return 0;
    800013f2:	4501                	li	a0,0
    800013f4:	74a2                	ld	s1,40(sp)
    800013f6:	7902                	ld	s2,32(sp)
    800013f8:	6b02                	ld	s6,0(sp)
    800013fa:	bfe9                	j	800013d4 <uvmalloc+0x76>
    return oldsz;
    800013fc:	852e                	mv	a0,a1
}
    800013fe:	8082                	ret
  return newsz;
    80001400:	8532                	mv	a0,a2
    80001402:	bfc9                	j	800013d4 <uvmalloc+0x76>

0000000080001404 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001404:	7179                	addi	sp,sp,-48
    80001406:	f406                	sd	ra,40(sp)
    80001408:	f022                	sd	s0,32(sp)
    8000140a:	ec26                	sd	s1,24(sp)
    8000140c:	e84a                	sd	s2,16(sp)
    8000140e:	e44e                	sd	s3,8(sp)
    80001410:	e052                	sd	s4,0(sp)
    80001412:	1800                	addi	s0,sp,48
    80001414:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001416:	84aa                	mv	s1,a0
    80001418:	6905                	lui	s2,0x1
    8000141a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000141c:	4985                	li	s3,1
    8000141e:	a819                	j	80001434 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001420:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001422:	00c79513          	slli	a0,a5,0xc
    80001426:	fdfff0ef          	jal	80001404 <freewalk>
      pagetable[i] = 0;
    8000142a:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    8000142e:	04a1                	addi	s1,s1,8
    80001430:	01248f63          	beq	s1,s2,8000144e <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001434:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001436:	00f7f713          	andi	a4,a5,15
    8000143a:	ff3703e3          	beq	a4,s3,80001420 <freewalk+0x1c>
    } else if(pte & PTE_V){
    8000143e:	8b85                	andi	a5,a5,1
    80001440:	d7fd                	beqz	a5,8000142e <freewalk+0x2a>
      panic("freewalk: leaf");
    80001442:	00007517          	auipc	a0,0x7
    80001446:	d5650513          	addi	a0,a0,-682 # 80008198 <etext+0x198>
    8000144a:	b58ff0ef          	jal	800007a2 <panic>
    }
  }
  kfree((void*)pagetable);
    8000144e:	8552                	mv	a0,s4
    80001450:	e00ff0ef          	jal	80000a50 <kfree>
}
    80001454:	70a2                	ld	ra,40(sp)
    80001456:	7402                	ld	s0,32(sp)
    80001458:	64e2                	ld	s1,24(sp)
    8000145a:	6942                	ld	s2,16(sp)
    8000145c:	69a2                	ld	s3,8(sp)
    8000145e:	6a02                	ld	s4,0(sp)
    80001460:	6145                	addi	sp,sp,48
    80001462:	8082                	ret

0000000080001464 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001464:	1101                	addi	sp,sp,-32
    80001466:	ec06                	sd	ra,24(sp)
    80001468:	e822                	sd	s0,16(sp)
    8000146a:	e426                	sd	s1,8(sp)
    8000146c:	1000                	addi	s0,sp,32
    8000146e:	84aa                	mv	s1,a0
  if(sz > 0)
    80001470:	e989                	bnez	a1,80001482 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001472:	8526                	mv	a0,s1
    80001474:	f91ff0ef          	jal	80001404 <freewalk>
}
    80001478:	60e2                	ld	ra,24(sp)
    8000147a:	6442                	ld	s0,16(sp)
    8000147c:	64a2                	ld	s1,8(sp)
    8000147e:	6105                	addi	sp,sp,32
    80001480:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001482:	6785                	lui	a5,0x1
    80001484:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001486:	95be                	add	a1,a1,a5
    80001488:	4685                	li	a3,1
    8000148a:	00c5d613          	srli	a2,a1,0xc
    8000148e:	4581                	li	a1,0
    80001490:	d4bff0ef          	jal	800011da <uvmunmap>
    80001494:	bff9                	j	80001472 <uvmfree+0xe>

0000000080001496 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001496:	c65d                	beqz	a2,80001544 <uvmcopy+0xae>
{
    80001498:	715d                	addi	sp,sp,-80
    8000149a:	e486                	sd	ra,72(sp)
    8000149c:	e0a2                	sd	s0,64(sp)
    8000149e:	fc26                	sd	s1,56(sp)
    800014a0:	f84a                	sd	s2,48(sp)
    800014a2:	f44e                	sd	s3,40(sp)
    800014a4:	f052                	sd	s4,32(sp)
    800014a6:	ec56                	sd	s5,24(sp)
    800014a8:	e85a                	sd	s6,16(sp)
    800014aa:	e45e                	sd	s7,8(sp)
    800014ac:	0880                	addi	s0,sp,80
    800014ae:	8b2a                	mv	s6,a0
    800014b0:	8aae                	mv	s5,a1
    800014b2:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014b4:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014b6:	4601                	li	a2,0
    800014b8:	85ce                	mv	a1,s3
    800014ba:	855a                	mv	a0,s6
    800014bc:	a8fff0ef          	jal	80000f4a <walk>
    800014c0:	c121                	beqz	a0,80001500 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014c2:	6118                	ld	a4,0(a0)
    800014c4:	00177793          	andi	a5,a4,1
    800014c8:	c3b1                	beqz	a5,8000150c <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014ca:	00a75593          	srli	a1,a4,0xa
    800014ce:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014d2:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014d6:	e5cff0ef          	jal	80000b32 <kalloc>
    800014da:	892a                	mv	s2,a0
    800014dc:	c129                	beqz	a0,8000151e <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014de:	6605                	lui	a2,0x1
    800014e0:	85de                	mv	a1,s7
    800014e2:	851ff0ef          	jal	80000d32 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014e6:	8726                	mv	a4,s1
    800014e8:	86ca                	mv	a3,s2
    800014ea:	6605                	lui	a2,0x1
    800014ec:	85ce                	mv	a1,s3
    800014ee:	8556                	mv	a0,s5
    800014f0:	b33ff0ef          	jal	80001022 <mappages>
    800014f4:	e115                	bnez	a0,80001518 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    800014f6:	6785                	lui	a5,0x1
    800014f8:	99be                	add	s3,s3,a5
    800014fa:	fb49eee3          	bltu	s3,s4,800014b6 <uvmcopy+0x20>
    800014fe:	a805                	j	8000152e <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001500:	00007517          	auipc	a0,0x7
    80001504:	ca850513          	addi	a0,a0,-856 # 800081a8 <etext+0x1a8>
    80001508:	a9aff0ef          	jal	800007a2 <panic>
      panic("uvmcopy: page not present");
    8000150c:	00007517          	auipc	a0,0x7
    80001510:	cbc50513          	addi	a0,a0,-836 # 800081c8 <etext+0x1c8>
    80001514:	a8eff0ef          	jal	800007a2 <panic>
      kfree(mem);
    80001518:	854a                	mv	a0,s2
    8000151a:	d36ff0ef          	jal	80000a50 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000151e:	4685                	li	a3,1
    80001520:	00c9d613          	srli	a2,s3,0xc
    80001524:	4581                	li	a1,0
    80001526:	8556                	mv	a0,s5
    80001528:	cb3ff0ef          	jal	800011da <uvmunmap>
  return -1;
    8000152c:	557d                	li	a0,-1
}
    8000152e:	60a6                	ld	ra,72(sp)
    80001530:	6406                	ld	s0,64(sp)
    80001532:	74e2                	ld	s1,56(sp)
    80001534:	7942                	ld	s2,48(sp)
    80001536:	79a2                	ld	s3,40(sp)
    80001538:	7a02                	ld	s4,32(sp)
    8000153a:	6ae2                	ld	s5,24(sp)
    8000153c:	6b42                	ld	s6,16(sp)
    8000153e:	6ba2                	ld	s7,8(sp)
    80001540:	6161                	addi	sp,sp,80
    80001542:	8082                	ret
  return 0;
    80001544:	4501                	li	a0,0
}
    80001546:	8082                	ret

0000000080001548 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001548:	1141                	addi	sp,sp,-16
    8000154a:	e406                	sd	ra,8(sp)
    8000154c:	e022                	sd	s0,0(sp)
    8000154e:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001550:	4601                	li	a2,0
    80001552:	9f9ff0ef          	jal	80000f4a <walk>
  if(pte == 0)
    80001556:	c901                	beqz	a0,80001566 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001558:	611c                	ld	a5,0(a0)
    8000155a:	9bbd                	andi	a5,a5,-17
    8000155c:	e11c                	sd	a5,0(a0)
}
    8000155e:	60a2                	ld	ra,8(sp)
    80001560:	6402                	ld	s0,0(sp)
    80001562:	0141                	addi	sp,sp,16
    80001564:	8082                	ret
    panic("uvmclear");
    80001566:	00007517          	auipc	a0,0x7
    8000156a:	c8250513          	addi	a0,a0,-894 # 800081e8 <etext+0x1e8>
    8000156e:	a34ff0ef          	jal	800007a2 <panic>

0000000080001572 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001572:	cad1                	beqz	a3,80001606 <copyout+0x94>
{
    80001574:	711d                	addi	sp,sp,-96
    80001576:	ec86                	sd	ra,88(sp)
    80001578:	e8a2                	sd	s0,80(sp)
    8000157a:	e4a6                	sd	s1,72(sp)
    8000157c:	fc4e                	sd	s3,56(sp)
    8000157e:	f456                	sd	s5,40(sp)
    80001580:	f05a                	sd	s6,32(sp)
    80001582:	ec5e                	sd	s7,24(sp)
    80001584:	1080                	addi	s0,sp,96
    80001586:	8baa                	mv	s7,a0
    80001588:	8aae                	mv	s5,a1
    8000158a:	8b32                	mv	s6,a2
    8000158c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000158e:	74fd                	lui	s1,0xfffff
    80001590:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001592:	57fd                	li	a5,-1
    80001594:	83e9                	srli	a5,a5,0x1a
    80001596:	0697ea63          	bltu	a5,s1,8000160a <copyout+0x98>
    8000159a:	e0ca                	sd	s2,64(sp)
    8000159c:	f852                	sd	s4,48(sp)
    8000159e:	e862                	sd	s8,16(sp)
    800015a0:	e466                	sd	s9,8(sp)
    800015a2:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015a4:	4cd5                	li	s9,21
    800015a6:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015a8:	8c3e                	mv	s8,a5
    800015aa:	a025                	j	800015d2 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015ac:	83a9                	srli	a5,a5,0xa
    800015ae:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015b0:	409a8533          	sub	a0,s5,s1
    800015b4:	0009061b          	sext.w	a2,s2
    800015b8:	85da                	mv	a1,s6
    800015ba:	953e                	add	a0,a0,a5
    800015bc:	f76ff0ef          	jal	80000d32 <memmove>

    len -= n;
    800015c0:	412989b3          	sub	s3,s3,s2
    src += n;
    800015c4:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015c6:	02098963          	beqz	s3,800015f8 <copyout+0x86>
    if(va0 >= MAXVA)
    800015ca:	054c6263          	bltu	s8,s4,8000160e <copyout+0x9c>
    800015ce:	84d2                	mv	s1,s4
    800015d0:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015d2:	4601                	li	a2,0
    800015d4:	85a6                	mv	a1,s1
    800015d6:	855e                	mv	a0,s7
    800015d8:	973ff0ef          	jal	80000f4a <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015dc:	c121                	beqz	a0,8000161c <copyout+0xaa>
    800015de:	611c                	ld	a5,0(a0)
    800015e0:	0157f713          	andi	a4,a5,21
    800015e4:	05971b63          	bne	a4,s9,8000163a <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015e8:	01a48a33          	add	s4,s1,s10
    800015ec:	415a0933          	sub	s2,s4,s5
    if(n > len)
    800015f0:	fb29fee3          	bgeu	s3,s2,800015ac <copyout+0x3a>
    800015f4:	894e                	mv	s2,s3
    800015f6:	bf5d                	j	800015ac <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    800015f8:	4501                	li	a0,0
    800015fa:	6906                	ld	s2,64(sp)
    800015fc:	7a42                	ld	s4,48(sp)
    800015fe:	6c42                	ld	s8,16(sp)
    80001600:	6ca2                	ld	s9,8(sp)
    80001602:	6d02                	ld	s10,0(sp)
    80001604:	a015                	j	80001628 <copyout+0xb6>
    80001606:	4501                	li	a0,0
}
    80001608:	8082                	ret
      return -1;
    8000160a:	557d                	li	a0,-1
    8000160c:	a831                	j	80001628 <copyout+0xb6>
    8000160e:	557d                	li	a0,-1
    80001610:	6906                	ld	s2,64(sp)
    80001612:	7a42                	ld	s4,48(sp)
    80001614:	6c42                	ld	s8,16(sp)
    80001616:	6ca2                	ld	s9,8(sp)
    80001618:	6d02                	ld	s10,0(sp)
    8000161a:	a039                	j	80001628 <copyout+0xb6>
      return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	6906                	ld	s2,64(sp)
    80001620:	7a42                	ld	s4,48(sp)
    80001622:	6c42                	ld	s8,16(sp)
    80001624:	6ca2                	ld	s9,8(sp)
    80001626:	6d02                	ld	s10,0(sp)
}
    80001628:	60e6                	ld	ra,88(sp)
    8000162a:	6446                	ld	s0,80(sp)
    8000162c:	64a6                	ld	s1,72(sp)
    8000162e:	79e2                	ld	s3,56(sp)
    80001630:	7aa2                	ld	s5,40(sp)
    80001632:	7b02                	ld	s6,32(sp)
    80001634:	6be2                	ld	s7,24(sp)
    80001636:	6125                	addi	sp,sp,96
    80001638:	8082                	ret
      return -1;
    8000163a:	557d                	li	a0,-1
    8000163c:	6906                	ld	s2,64(sp)
    8000163e:	7a42                	ld	s4,48(sp)
    80001640:	6c42                	ld	s8,16(sp)
    80001642:	6ca2                	ld	s9,8(sp)
    80001644:	6d02                	ld	s10,0(sp)
    80001646:	b7cd                	j	80001628 <copyout+0xb6>

0000000080001648 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001648:	c6a5                	beqz	a3,800016b0 <copyin+0x68>
{
    8000164a:	715d                	addi	sp,sp,-80
    8000164c:	e486                	sd	ra,72(sp)
    8000164e:	e0a2                	sd	s0,64(sp)
    80001650:	fc26                	sd	s1,56(sp)
    80001652:	f84a                	sd	s2,48(sp)
    80001654:	f44e                	sd	s3,40(sp)
    80001656:	f052                	sd	s4,32(sp)
    80001658:	ec56                	sd	s5,24(sp)
    8000165a:	e85a                	sd	s6,16(sp)
    8000165c:	e45e                	sd	s7,8(sp)
    8000165e:	e062                	sd	s8,0(sp)
    80001660:	0880                	addi	s0,sp,80
    80001662:	8b2a                	mv	s6,a0
    80001664:	8a2e                	mv	s4,a1
    80001666:	8c32                	mv	s8,a2
    80001668:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000166a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000166c:	6a85                	lui	s5,0x1
    8000166e:	a00d                	j	80001690 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001670:	018505b3          	add	a1,a0,s8
    80001674:	0004861b          	sext.w	a2,s1
    80001678:	412585b3          	sub	a1,a1,s2
    8000167c:	8552                	mv	a0,s4
    8000167e:	eb4ff0ef          	jal	80000d32 <memmove>

    len -= n;
    80001682:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001686:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001688:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000168c:	02098063          	beqz	s3,800016ac <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001690:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001694:	85ca                	mv	a1,s2
    80001696:	855a                	mv	a0,s6
    80001698:	94dff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    8000169c:	cd01                	beqz	a0,800016b4 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    8000169e:	418904b3          	sub	s1,s2,s8
    800016a2:	94d6                	add	s1,s1,s5
    if(n > len)
    800016a4:	fc99f6e3          	bgeu	s3,s1,80001670 <copyin+0x28>
    800016a8:	84ce                	mv	s1,s3
    800016aa:	b7d9                	j	80001670 <copyin+0x28>
  }
  return 0;
    800016ac:	4501                	li	a0,0
    800016ae:	a021                	j	800016b6 <copyin+0x6e>
    800016b0:	4501                	li	a0,0
}
    800016b2:	8082                	ret
      return -1;
    800016b4:	557d                	li	a0,-1
}
    800016b6:	60a6                	ld	ra,72(sp)
    800016b8:	6406                	ld	s0,64(sp)
    800016ba:	74e2                	ld	s1,56(sp)
    800016bc:	7942                	ld	s2,48(sp)
    800016be:	79a2                	ld	s3,40(sp)
    800016c0:	7a02                	ld	s4,32(sp)
    800016c2:	6ae2                	ld	s5,24(sp)
    800016c4:	6b42                	ld	s6,16(sp)
    800016c6:	6ba2                	ld	s7,8(sp)
    800016c8:	6c02                	ld	s8,0(sp)
    800016ca:	6161                	addi	sp,sp,80
    800016cc:	8082                	ret

00000000800016ce <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016ce:	c6dd                	beqz	a3,8000177c <copyinstr+0xae>
{
    800016d0:	715d                	addi	sp,sp,-80
    800016d2:	e486                	sd	ra,72(sp)
    800016d4:	e0a2                	sd	s0,64(sp)
    800016d6:	fc26                	sd	s1,56(sp)
    800016d8:	f84a                	sd	s2,48(sp)
    800016da:	f44e                	sd	s3,40(sp)
    800016dc:	f052                	sd	s4,32(sp)
    800016de:	ec56                	sd	s5,24(sp)
    800016e0:	e85a                	sd	s6,16(sp)
    800016e2:	e45e                	sd	s7,8(sp)
    800016e4:	0880                	addi	s0,sp,80
    800016e6:	8a2a                	mv	s4,a0
    800016e8:	8b2e                	mv	s6,a1
    800016ea:	8bb2                	mv	s7,a2
    800016ec:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800016ee:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800016f0:	6985                	lui	s3,0x1
    800016f2:	a825                	j	8000172a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800016f4:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800016f8:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800016fa:	37fd                	addiw	a5,a5,-1
    800016fc:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001700:	60a6                	ld	ra,72(sp)
    80001702:	6406                	ld	s0,64(sp)
    80001704:	74e2                	ld	s1,56(sp)
    80001706:	7942                	ld	s2,48(sp)
    80001708:	79a2                	ld	s3,40(sp)
    8000170a:	7a02                	ld	s4,32(sp)
    8000170c:	6ae2                	ld	s5,24(sp)
    8000170e:	6b42                	ld	s6,16(sp)
    80001710:	6ba2                	ld	s7,8(sp)
    80001712:	6161                	addi	sp,sp,80
    80001714:	8082                	ret
    80001716:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000171a:	9742                	add	a4,a4,a6
      --max;
    8000171c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001720:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001724:	04e58463          	beq	a1,a4,8000176c <copyinstr+0x9e>
{
    80001728:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000172a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000172e:	85a6                	mv	a1,s1
    80001730:	8552                	mv	a0,s4
    80001732:	8b3ff0ef          	jal	80000fe4 <walkaddr>
    if(pa0 == 0)
    80001736:	cd0d                	beqz	a0,80001770 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001738:	417486b3          	sub	a3,s1,s7
    8000173c:	96ce                	add	a3,a3,s3
    if(n > max)
    8000173e:	00d97363          	bgeu	s2,a3,80001744 <copyinstr+0x76>
    80001742:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001744:	955e                	add	a0,a0,s7
    80001746:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001748:	c695                	beqz	a3,80001774 <copyinstr+0xa6>
    8000174a:	87da                	mv	a5,s6
    8000174c:	885a                	mv	a6,s6
      if(*p == '\0'){
    8000174e:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001752:	96da                	add	a3,a3,s6
    80001754:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001756:	00f60733          	add	a4,a2,a5
    8000175a:	00074703          	lbu	a4,0(a4)
    8000175e:	db59                	beqz	a4,800016f4 <copyinstr+0x26>
        *dst = *p;
    80001760:	00e78023          	sb	a4,0(a5)
      dst++;
    80001764:	0785                	addi	a5,a5,1
    while(n > 0){
    80001766:	fed797e3          	bne	a5,a3,80001754 <copyinstr+0x86>
    8000176a:	b775                	j	80001716 <copyinstr+0x48>
    8000176c:	4781                	li	a5,0
    8000176e:	b771                	j	800016fa <copyinstr+0x2c>
      return -1;
    80001770:	557d                	li	a0,-1
    80001772:	b779                	j	80001700 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001774:	6b85                	lui	s7,0x1
    80001776:	9ba6                	add	s7,s7,s1
    80001778:	87da                	mv	a5,s6
    8000177a:	b77d                	j	80001728 <copyinstr+0x5a>
  int got_null = 0;
    8000177c:	4781                	li	a5,0
  if(got_null){
    8000177e:	37fd                	addiw	a5,a5,-1
    80001780:	0007851b          	sext.w	a0,a5
}
    80001784:	8082                	ret

0000000080001786 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001786:	7139                	addi	sp,sp,-64
    80001788:	fc06                	sd	ra,56(sp)
    8000178a:	f822                	sd	s0,48(sp)
    8000178c:	f426                	sd	s1,40(sp)
    8000178e:	f04a                	sd	s2,32(sp)
    80001790:	ec4e                	sd	s3,24(sp)
    80001792:	e852                	sd	s4,16(sp)
    80001794:	e456                	sd	s5,8(sp)
    80001796:	e05a                	sd	s6,0(sp)
    80001798:	0080                	addi	s0,sp,64
    8000179a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000179c:	00012497          	auipc	s1,0x12
    800017a0:	43c48493          	addi	s1,s1,1084 # 80013bd8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017a4:	8b26                	mv	s6,s1
    800017a6:	faaab937          	lui	s2,0xfaaab
    800017aa:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa85af3>
    800017ae:	0932                	slli	s2,s2,0xc
    800017b0:	aab90913          	addi	s2,s2,-1365
    800017b4:	0932                	slli	s2,s2,0xc
    800017b6:	aab90913          	addi	s2,s2,-1365
    800017ba:	0932                	slli	s2,s2,0xc
    800017bc:	aab90913          	addi	s2,s2,-1365
    800017c0:	040009b7          	lui	s3,0x4000
    800017c4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017c6:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017c8:	00018a97          	auipc	s5,0x18
    800017cc:	410a8a93          	addi	s5,s5,1040 # 80019bd8 <tickslock>
    char *pa = kalloc();
    800017d0:	b62ff0ef          	jal	80000b32 <kalloc>
    800017d4:	862a                	mv	a2,a0
    if(pa == 0)
    800017d6:	cd15                	beqz	a0,80001812 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017d8:	416485b3          	sub	a1,s1,s6
    800017dc:	859d                	srai	a1,a1,0x7
    800017de:	032585b3          	mul	a1,a1,s2
    800017e2:	2585                	addiw	a1,a1,1 # 100001 <_entry-0x7fefffff>
    800017e4:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017e8:	4719                	li	a4,6
    800017ea:	6685                	lui	a3,0x1
    800017ec:	40b985b3          	sub	a1,s3,a1
    800017f0:	8552                	mv	a0,s4
    800017f2:	8e1ff0ef          	jal	800010d2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017f6:	18048493          	addi	s1,s1,384
    800017fa:	fd549be3          	bne	s1,s5,800017d0 <proc_mapstacks+0x4a>
  }
}
    800017fe:	70e2                	ld	ra,56(sp)
    80001800:	7442                	ld	s0,48(sp)
    80001802:	74a2                	ld	s1,40(sp)
    80001804:	7902                	ld	s2,32(sp)
    80001806:	69e2                	ld	s3,24(sp)
    80001808:	6a42                	ld	s4,16(sp)
    8000180a:	6aa2                	ld	s5,8(sp)
    8000180c:	6b02                	ld	s6,0(sp)
    8000180e:	6121                	addi	sp,sp,64
    80001810:	8082                	ret
      panic("kalloc");
    80001812:	00007517          	auipc	a0,0x7
    80001816:	9e650513          	addi	a0,a0,-1562 # 800081f8 <etext+0x1f8>
    8000181a:	f89fe0ef          	jal	800007a2 <panic>

000000008000181e <procinit>:

// initialize the proc table.
void
procinit(void)
{
    8000181e:	7139                	addi	sp,sp,-64
    80001820:	fc06                	sd	ra,56(sp)
    80001822:	f822                	sd	s0,48(sp)
    80001824:	f426                	sd	s1,40(sp)
    80001826:	f04a                	sd	s2,32(sp)
    80001828:	ec4e                	sd	s3,24(sp)
    8000182a:	e852                	sd	s4,16(sp)
    8000182c:	e456                	sd	s5,8(sp)
    8000182e:	e05a                	sd	s6,0(sp)
    80001830:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001832:	00007597          	auipc	a1,0x7
    80001836:	9ce58593          	addi	a1,a1,-1586 # 80008200 <etext+0x200>
    8000183a:	00012517          	auipc	a0,0x12
    8000183e:	f5650513          	addi	a0,a0,-170 # 80013790 <pid_lock>
    80001842:	b40ff0ef          	jal	80000b82 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001846:	00007597          	auipc	a1,0x7
    8000184a:	9c258593          	addi	a1,a1,-1598 # 80008208 <etext+0x208>
    8000184e:	00012517          	auipc	a0,0x12
    80001852:	f5a50513          	addi	a0,a0,-166 # 800137a8 <wait_lock>
    80001856:	b2cff0ef          	jal	80000b82 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000185a:	00012497          	auipc	s1,0x12
    8000185e:	37e48493          	addi	s1,s1,894 # 80013bd8 <proc>
      initlock(&p->lock, "proc");
    80001862:	00007b17          	auipc	s6,0x7
    80001866:	9b6b0b13          	addi	s6,s6,-1610 # 80008218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000186a:	8aa6                	mv	s5,s1
    8000186c:	faaab937          	lui	s2,0xfaaab
    80001870:	aab90913          	addi	s2,s2,-1365 # fffffffffaaaaaab <end+0xffffffff7aa85af3>
    80001874:	0932                	slli	s2,s2,0xc
    80001876:	aab90913          	addi	s2,s2,-1365
    8000187a:	0932                	slli	s2,s2,0xc
    8000187c:	aab90913          	addi	s2,s2,-1365
    80001880:	0932                	slli	s2,s2,0xc
    80001882:	aab90913          	addi	s2,s2,-1365
    80001886:	040009b7          	lui	s3,0x4000
    8000188a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000188c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000188e:	00018a17          	auipc	s4,0x18
    80001892:	34aa0a13          	addi	s4,s4,842 # 80019bd8 <tickslock>
      initlock(&p->lock, "proc");
    80001896:	85da                	mv	a1,s6
    80001898:	8526                	mv	a0,s1
    8000189a:	ae8ff0ef          	jal	80000b82 <initlock>
      p->state = UNUSED;
    8000189e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018a2:	415487b3          	sub	a5,s1,s5
    800018a6:	879d                	srai	a5,a5,0x7
    800018a8:	032787b3          	mul	a5,a5,s2
    800018ac:	2785                	addiw	a5,a5,1
    800018ae:	00d7979b          	slliw	a5,a5,0xd
    800018b2:	40f987b3          	sub	a5,s3,a5
    800018b6:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	18048493          	addi	s1,s1,384
    800018bc:	fd449de3          	bne	s1,s4,80001896 <procinit+0x78>
  }
}
    800018c0:	70e2                	ld	ra,56(sp)
    800018c2:	7442                	ld	s0,48(sp)
    800018c4:	74a2                	ld	s1,40(sp)
    800018c6:	7902                	ld	s2,32(sp)
    800018c8:	69e2                	ld	s3,24(sp)
    800018ca:	6a42                	ld	s4,16(sp)
    800018cc:	6aa2                	ld	s5,8(sp)
    800018ce:	6b02                	ld	s6,0(sp)
    800018d0:	6121                	addi	sp,sp,64
    800018d2:	8082                	ret

00000000800018d4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018d4:	1141                	addi	sp,sp,-16
    800018d6:	e422                	sd	s0,8(sp)
    800018d8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018da:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018dc:	2501                	sext.w	a0,a0
    800018de:	6422                	ld	s0,8(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018e4:	1141                	addi	sp,sp,-16
    800018e6:	e422                	sd	s0,8(sp)
    800018e8:	0800                	addi	s0,sp,16
    800018ea:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018ec:	2781                	sext.w	a5,a5
    800018ee:	079e                	slli	a5,a5,0x7
  return c;
}
    800018f0:	00012517          	auipc	a0,0x12
    800018f4:	ed050513          	addi	a0,a0,-304 # 800137c0 <cpus>
    800018f8:	953e                	add	a0,a0,a5
    800018fa:	6422                	ld	s0,8(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001900:	1101                	addi	sp,sp,-32
    80001902:	ec06                	sd	ra,24(sp)
    80001904:	e822                	sd	s0,16(sp)
    80001906:	e426                	sd	s1,8(sp)
    80001908:	1000                	addi	s0,sp,32
  push_off();
    8000190a:	ab8ff0ef          	jal	80000bc2 <push_off>
    8000190e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001910:	2781                	sext.w	a5,a5
    80001912:	079e                	slli	a5,a5,0x7
    80001914:	00012717          	auipc	a4,0x12
    80001918:	e7c70713          	addi	a4,a4,-388 # 80013790 <pid_lock>
    8000191c:	97ba                	add	a5,a5,a4
    8000191e:	7b84                	ld	s1,48(a5)
  pop_off();
    80001920:	b26ff0ef          	jal	80000c46 <pop_off>
  return p;
}
    80001924:	8526                	mv	a0,s1
    80001926:	60e2                	ld	ra,24(sp)
    80001928:	6442                	ld	s0,16(sp)
    8000192a:	64a2                	ld	s1,8(sp)
    8000192c:	6105                	addi	sp,sp,32
    8000192e:	8082                	ret

0000000080001930 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001930:	1141                	addi	sp,sp,-16
    80001932:	e406                	sd	ra,8(sp)
    80001934:	e022                	sd	s0,0(sp)
    80001936:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001938:	fc9ff0ef          	jal	80001900 <myproc>
    8000193c:	b5eff0ef          	jal	80000c9a <release>

  if (first) {
    80001940:	0000a797          	auipc	a5,0xa
    80001944:	c607a783          	lw	a5,-928(a5) # 8000b5a0 <first.1>
    80001948:	e799                	bnez	a5,80001956 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    8000194a:	695000ef          	jal	800027de <usertrapret>
}
    8000194e:	60a2                	ld	ra,8(sp)
    80001950:	6402                	ld	s0,0(sp)
    80001952:	0141                	addi	sp,sp,16
    80001954:	8082                	ret
    fsinit(ROOTDEV);
    80001956:	4505                	li	a0,1
    80001958:	48d010ef          	jal	800035e4 <fsinit>
    first = 0;
    8000195c:	0000a797          	auipc	a5,0xa
    80001960:	c407a223          	sw	zero,-956(a5) # 8000b5a0 <first.1>
    __sync_synchronize();
    80001964:	0330000f          	fence	rw,rw
    80001968:	b7cd                	j	8000194a <forkret+0x1a>

000000008000196a <allocpid>:
{
    8000196a:	1101                	addi	sp,sp,-32
    8000196c:	ec06                	sd	ra,24(sp)
    8000196e:	e822                	sd	s0,16(sp)
    80001970:	e426                	sd	s1,8(sp)
    80001972:	e04a                	sd	s2,0(sp)
    80001974:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001976:	00012917          	auipc	s2,0x12
    8000197a:	e1a90913          	addi	s2,s2,-486 # 80013790 <pid_lock>
    8000197e:	854a                	mv	a0,s2
    80001980:	a82ff0ef          	jal	80000c02 <acquire>
  pid = nextpid;
    80001984:	0000a797          	auipc	a5,0xa
    80001988:	c2078793          	addi	a5,a5,-992 # 8000b5a4 <nextpid>
    8000198c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000198e:	0014871b          	addiw	a4,s1,1
    80001992:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001994:	854a                	mv	a0,s2
    80001996:	b04ff0ef          	jal	80000c9a <release>
}
    8000199a:	8526                	mv	a0,s1
    8000199c:	60e2                	ld	ra,24(sp)
    8000199e:	6442                	ld	s0,16(sp)
    800019a0:	64a2                	ld	s1,8(sp)
    800019a2:	6902                	ld	s2,0(sp)
    800019a4:	6105                	addi	sp,sp,32
    800019a6:	8082                	ret

00000000800019a8 <proc_pagetable>:
{
    800019a8:	1101                	addi	sp,sp,-32
    800019aa:	ec06                	sd	ra,24(sp)
    800019ac:	e822                	sd	s0,16(sp)
    800019ae:	e426                	sd	s1,8(sp)
    800019b0:	e04a                	sd	s2,0(sp)
    800019b2:	1000                	addi	s0,sp,32
    800019b4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019b6:	8e1ff0ef          	jal	80001296 <uvmcreate>
    800019ba:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019bc:	cd05                	beqz	a0,800019f4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019be:	4729                	li	a4,10
    800019c0:	00005697          	auipc	a3,0x5
    800019c4:	64068693          	addi	a3,a3,1600 # 80007000 <_trampoline>
    800019c8:	6605                	lui	a2,0x1
    800019ca:	040005b7          	lui	a1,0x4000
    800019ce:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019d0:	05b2                	slli	a1,a1,0xc
    800019d2:	e50ff0ef          	jal	80001022 <mappages>
    800019d6:	02054663          	bltz	a0,80001a02 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    800019da:	4719                	li	a4,6
    800019dc:	05893683          	ld	a3,88(s2)
    800019e0:	6605                	lui	a2,0x1
    800019e2:	020005b7          	lui	a1,0x2000
    800019e6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019e8:	05b6                	slli	a1,a1,0xd
    800019ea:	8526                	mv	a0,s1
    800019ec:	e36ff0ef          	jal	80001022 <mappages>
    800019f0:	00054f63          	bltz	a0,80001a0e <proc_pagetable+0x66>
}
    800019f4:	8526                	mv	a0,s1
    800019f6:	60e2                	ld	ra,24(sp)
    800019f8:	6442                	ld	s0,16(sp)
    800019fa:	64a2                	ld	s1,8(sp)
    800019fc:	6902                	ld	s2,0(sp)
    800019fe:	6105                	addi	sp,sp,32
    80001a00:	8082                	ret
    uvmfree(pagetable, 0);
    80001a02:	4581                	li	a1,0
    80001a04:	8526                	mv	a0,s1
    80001a06:	a5fff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001a0a:	4481                	li	s1,0
    80001a0c:	b7e5                	j	800019f4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a0e:	4681                	li	a3,0
    80001a10:	4605                	li	a2,1
    80001a12:	040005b7          	lui	a1,0x4000
    80001a16:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a18:	05b2                	slli	a1,a1,0xc
    80001a1a:	8526                	mv	a0,s1
    80001a1c:	fbeff0ef          	jal	800011da <uvmunmap>
    uvmfree(pagetable, 0);
    80001a20:	4581                	li	a1,0
    80001a22:	8526                	mv	a0,s1
    80001a24:	a41ff0ef          	jal	80001464 <uvmfree>
    return 0;
    80001a28:	4481                	li	s1,0
    80001a2a:	b7e9                	j	800019f4 <proc_pagetable+0x4c>

0000000080001a2c <proc_freepagetable>:
{
    80001a2c:	1101                	addi	sp,sp,-32
    80001a2e:	ec06                	sd	ra,24(sp)
    80001a30:	e822                	sd	s0,16(sp)
    80001a32:	e426                	sd	s1,8(sp)
    80001a34:	e04a                	sd	s2,0(sp)
    80001a36:	1000                	addi	s0,sp,32
    80001a38:	84aa                	mv	s1,a0
    80001a3a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a3c:	4681                	li	a3,0
    80001a3e:	4605                	li	a2,1
    80001a40:	040005b7          	lui	a1,0x4000
    80001a44:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a46:	05b2                	slli	a1,a1,0xc
    80001a48:	f92ff0ef          	jal	800011da <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a4c:	4681                	li	a3,0
    80001a4e:	4605                	li	a2,1
    80001a50:	020005b7          	lui	a1,0x2000
    80001a54:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a56:	05b6                	slli	a1,a1,0xd
    80001a58:	8526                	mv	a0,s1
    80001a5a:	f80ff0ef          	jal	800011da <uvmunmap>
  uvmfree(pagetable, sz);
    80001a5e:	85ca                	mv	a1,s2
    80001a60:	8526                	mv	a0,s1
    80001a62:	a03ff0ef          	jal	80001464 <uvmfree>
}
    80001a66:	60e2                	ld	ra,24(sp)
    80001a68:	6442                	ld	s0,16(sp)
    80001a6a:	64a2                	ld	s1,8(sp)
    80001a6c:	6902                	ld	s2,0(sp)
    80001a6e:	6105                	addi	sp,sp,32
    80001a70:	8082                	ret

0000000080001a72 <freeproc>:
{
    80001a72:	1101                	addi	sp,sp,-32
    80001a74:	ec06                	sd	ra,24(sp)
    80001a76:	e822                	sd	s0,16(sp)
    80001a78:	e426                	sd	s1,8(sp)
    80001a7a:	1000                	addi	s0,sp,32
    80001a7c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001a7e:	6d28                	ld	a0,88(a0)
    80001a80:	c119                	beqz	a0,80001a86 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001a82:	fcffe0ef          	jal	80000a50 <kfree>
  p->trapframe = 0;
    80001a86:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001a8a:	68a8                	ld	a0,80(s1)
    80001a8c:	c501                	beqz	a0,80001a94 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001a8e:	64ac                	ld	a1,72(s1)
    80001a90:	f9dff0ef          	jal	80001a2c <proc_freepagetable>
  p->pagetable = 0;
    80001a94:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001a98:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001a9c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001aa0:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001aa4:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001aa8:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001aac:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ab0:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ab4:	0004ac23          	sw	zero,24(s1)
  p->creation_time = ticks;
    80001ab8:	0000a797          	auipc	a5,0xa
    80001abc:	ba87a783          	lw	a5,-1112(a5) # 8000b660 <ticks>
    80001ac0:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001ac4:	1604a623          	sw	zero,364(s1)
}
    80001ac8:	60e2                	ld	ra,24(sp)
    80001aca:	6442                	ld	s0,16(sp)
    80001acc:	64a2                	ld	s1,8(sp)
    80001ace:	6105                	addi	sp,sp,32
    80001ad0:	8082                	ret

0000000080001ad2 <allocproc>:
{
    80001ad2:	1101                	addi	sp,sp,-32
    80001ad4:	ec06                	sd	ra,24(sp)
    80001ad6:	e822                	sd	s0,16(sp)
    80001ad8:	e426                	sd	s1,8(sp)
    80001ada:	e04a                	sd	s2,0(sp)
    80001adc:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ade:	00012497          	auipc	s1,0x12
    80001ae2:	0fa48493          	addi	s1,s1,250 # 80013bd8 <proc>
    80001ae6:	00018917          	auipc	s2,0x18
    80001aea:	0f290913          	addi	s2,s2,242 # 80019bd8 <tickslock>
    acquire(&p->lock);
    80001aee:	8526                	mv	a0,s1
    80001af0:	912ff0ef          	jal	80000c02 <acquire>
    if(p->state == UNUSED) {
    80001af4:	4c9c                	lw	a5,24(s1)
    80001af6:	cb91                	beqz	a5,80001b0a <allocproc+0x38>
      release(&p->lock);
    80001af8:	8526                	mv	a0,s1
    80001afa:	9a0ff0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001afe:	18048493          	addi	s1,s1,384
    80001b02:	ff2496e3          	bne	s1,s2,80001aee <allocproc+0x1c>
  return 0;
    80001b06:	4481                	li	s1,0
    80001b08:	a085                	j	80001b68 <allocproc+0x96>
  p->pid = allocpid();
    80001b0a:	e61ff0ef          	jal	8000196a <allocpid>
    80001b0e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b10:	4785                	li	a5,1
    80001b12:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b14:	81eff0ef          	jal	80000b32 <kalloc>
    80001b18:	892a                	mv	s2,a0
    80001b1a:	eca8                	sd	a0,88(s1)
    80001b1c:	cd29                	beqz	a0,80001b76 <allocproc+0xa4>
  p->pagetable = proc_pagetable(p);
    80001b1e:	8526                	mv	a0,s1
    80001b20:	e89ff0ef          	jal	800019a8 <proc_pagetable>
    80001b24:	892a                	mv	s2,a0
    80001b26:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001b28:	cd39                	beqz	a0,80001b86 <allocproc+0xb4>
  memset(&p->context, 0, sizeof(p->context));
    80001b2a:	07000613          	li	a2,112
    80001b2e:	4581                	li	a1,0
    80001b30:	06048513          	addi	a0,s1,96
    80001b34:	9a2ff0ef          	jal	80000cd6 <memset>
  p->context.ra = (uint64)forkret;
    80001b38:	00000797          	auipc	a5,0x0
    80001b3c:	df878793          	addi	a5,a5,-520 # 80001930 <forkret>
    80001b40:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b42:	60bc                	ld	a5,64(s1)
    80001b44:	6705                	lui	a4,0x1
    80001b46:	97ba                	add	a5,a5,a4
    80001b48:	f4bc                	sd	a5,104(s1)
  p->creation_time = ticks;
    80001b4a:	0000a797          	auipc	a5,0xa
    80001b4e:	b167a783          	lw	a5,-1258(a5) # 8000b660 <ticks>
    80001b52:	16f4a423          	sw	a5,360(s1)
  p->run_time = 0;
    80001b56:	1604a623          	sw	zero,364(s1)
  p->priority = 10;           // Default priority
    80001b5a:	47a9                	li	a5,10
    80001b5c:	16f4a823          	sw	a5,368(s1)
  p->total_waiting_time = 0;  // Reset waiting stats
    80001b60:	1604ac23          	sw	zero,376(s1)
  p->last_runnable_time = 0;
    80001b64:	1604aa23          	sw	zero,372(s1)
}
    80001b68:	8526                	mv	a0,s1
    80001b6a:	60e2                	ld	ra,24(sp)
    80001b6c:	6442                	ld	s0,16(sp)
    80001b6e:	64a2                	ld	s1,8(sp)
    80001b70:	6902                	ld	s2,0(sp)
    80001b72:	6105                	addi	sp,sp,32
    80001b74:	8082                	ret
    freeproc(p);
    80001b76:	8526                	mv	a0,s1
    80001b78:	efbff0ef          	jal	80001a72 <freeproc>
    release(&p->lock);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	91cff0ef          	jal	80000c9a <release>
    return 0;
    80001b82:	84ca                	mv	s1,s2
    80001b84:	b7d5                	j	80001b68 <allocproc+0x96>
    freeproc(p);
    80001b86:	8526                	mv	a0,s1
    80001b88:	eebff0ef          	jal	80001a72 <freeproc>
    release(&p->lock);
    80001b8c:	8526                	mv	a0,s1
    80001b8e:	90cff0ef          	jal	80000c9a <release>
    return 0;
    80001b92:	84ca                	mv	s1,s2
    80001b94:	bfd1                	j	80001b68 <allocproc+0x96>

0000000080001b96 <userinit>:
{
    80001b96:	1101                	addi	sp,sp,-32
    80001b98:	ec06                	sd	ra,24(sp)
    80001b9a:	e822                	sd	s0,16(sp)
    80001b9c:	e426                	sd	s1,8(sp)
    80001b9e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ba0:	f33ff0ef          	jal	80001ad2 <allocproc>
    80001ba4:	84aa                	mv	s1,a0
  initproc = p;
    80001ba6:	0000a797          	auipc	a5,0xa
    80001baa:	aaa7b923          	sd	a0,-1358(a5) # 8000b658 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001bae:	03400613          	li	a2,52
    80001bb2:	0000a597          	auipc	a1,0xa
    80001bb6:	9fe58593          	addi	a1,a1,-1538 # 8000b5b0 <initcode>
    80001bba:	6928                	ld	a0,80(a0)
    80001bbc:	f00ff0ef          	jal	800012bc <uvmfirst>
  p->sz = PGSIZE;
    80001bc0:	6785                	lui	a5,0x1
    80001bc2:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001bc4:	6cb8                	ld	a4,88(s1)
    80001bc6:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001bca:	6cb8                	ld	a4,88(s1)
    80001bcc:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001bce:	4641                	li	a2,16
    80001bd0:	00006597          	auipc	a1,0x6
    80001bd4:	65058593          	addi	a1,a1,1616 # 80008220 <etext+0x220>
    80001bd8:	15848513          	addi	a0,s1,344
    80001bdc:	a38ff0ef          	jal	80000e14 <safestrcpy>
  p->cwd = namei("/");
    80001be0:	00006517          	auipc	a0,0x6
    80001be4:	65050513          	addi	a0,a0,1616 # 80008230 <etext+0x230>
    80001be8:	30a020ef          	jal	80003ef2 <namei>
    80001bec:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bf0:	478d                	li	a5,3
    80001bf2:	cc9c                	sw	a5,24(s1)
  p->last_runnable_time = ticks;
    80001bf4:	0000a797          	auipc	a5,0xa
    80001bf8:	a6c7a783          	lw	a5,-1428(a5) # 8000b660 <ticks>
    80001bfc:	16f4aa23          	sw	a5,372(s1)
  release(&p->lock);
    80001c00:	8526                	mv	a0,s1
    80001c02:	898ff0ef          	jal	80000c9a <release>
}
    80001c06:	60e2                	ld	ra,24(sp)
    80001c08:	6442                	ld	s0,16(sp)
    80001c0a:	64a2                	ld	s1,8(sp)
    80001c0c:	6105                	addi	sp,sp,32
    80001c0e:	8082                	ret

0000000080001c10 <growproc>:
{
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	e04a                	sd	s2,0(sp)
    80001c1a:	1000                	addi	s0,sp,32
    80001c1c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001c1e:	ce3ff0ef          	jal	80001900 <myproc>
    80001c22:	84aa                	mv	s1,a0
  sz = p->sz;
    80001c24:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001c26:	01204c63          	bgtz	s2,80001c3e <growproc+0x2e>
  } else if(n < 0){
    80001c2a:	02094463          	bltz	s2,80001c52 <growproc+0x42>
  p->sz = sz;
    80001c2e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001c30:	4501                	li	a0,0
}
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6902                	ld	s2,0(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c3e:	4691                	li	a3,4
    80001c40:	00b90633          	add	a2,s2,a1
    80001c44:	6928                	ld	a0,80(a0)
    80001c46:	f18ff0ef          	jal	8000135e <uvmalloc>
    80001c4a:	85aa                	mv	a1,a0
    80001c4c:	f16d                	bnez	a0,80001c2e <growproc+0x1e>
      return -1;
    80001c4e:	557d                	li	a0,-1
    80001c50:	b7cd                	j	80001c32 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c52:	00b90633          	add	a2,s2,a1
    80001c56:	6928                	ld	a0,80(a0)
    80001c58:	ec2ff0ef          	jal	8000131a <uvmdealloc>
    80001c5c:	85aa                	mv	a1,a0
    80001c5e:	bfc1                	j	80001c2e <growproc+0x1e>

0000000080001c60 <fork>:
{
    80001c60:	7139                	addi	sp,sp,-64
    80001c62:	fc06                	sd	ra,56(sp)
    80001c64:	f822                	sd	s0,48(sp)
    80001c66:	f04a                	sd	s2,32(sp)
    80001c68:	e456                	sd	s5,8(sp)
    80001c6a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c6c:	c95ff0ef          	jal	80001900 <myproc>
    80001c70:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001c72:	e61ff0ef          	jal	80001ad2 <allocproc>
    80001c76:	10050063          	beqz	a0,80001d76 <fork+0x116>
    80001c7a:	ec4e                	sd	s3,24(sp)
    80001c7c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001c7e:	048ab603          	ld	a2,72(s5)
    80001c82:	692c                	ld	a1,80(a0)
    80001c84:	050ab503          	ld	a0,80(s5)
    80001c88:	80fff0ef          	jal	80001496 <uvmcopy>
    80001c8c:	04054a63          	bltz	a0,80001ce0 <fork+0x80>
    80001c90:	f426                	sd	s1,40(sp)
    80001c92:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c94:	048ab783          	ld	a5,72(s5)
    80001c98:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001c9c:	058ab683          	ld	a3,88(s5)
    80001ca0:	87b6                	mv	a5,a3
    80001ca2:	0589b703          	ld	a4,88(s3)
    80001ca6:	12068693          	addi	a3,a3,288
    80001caa:	0007b803          	ld	a6,0(a5)
    80001cae:	6788                	ld	a0,8(a5)
    80001cb0:	6b8c                	ld	a1,16(a5)
    80001cb2:	6f90                	ld	a2,24(a5)
    80001cb4:	01073023          	sd	a6,0(a4)
    80001cb8:	e708                	sd	a0,8(a4)
    80001cba:	eb0c                	sd	a1,16(a4)
    80001cbc:	ef10                	sd	a2,24(a4)
    80001cbe:	02078793          	addi	a5,a5,32
    80001cc2:	02070713          	addi	a4,a4,32
    80001cc6:	fed792e3          	bne	a5,a3,80001caa <fork+0x4a>
  np->trapframe->a0 = 0;
    80001cca:	0589b783          	ld	a5,88(s3)
    80001cce:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001cd2:	0d0a8493          	addi	s1,s5,208
    80001cd6:	0d098913          	addi	s2,s3,208
    80001cda:	150a8a13          	addi	s4,s5,336
    80001cde:	a831                	j	80001cfa <fork+0x9a>
    freeproc(np);
    80001ce0:	854e                	mv	a0,s3
    80001ce2:	d91ff0ef          	jal	80001a72 <freeproc>
    release(&np->lock);
    80001ce6:	854e                	mv	a0,s3
    80001ce8:	fb3fe0ef          	jal	80000c9a <release>
    return -1;
    80001cec:	597d                	li	s2,-1
    80001cee:	69e2                	ld	s3,24(sp)
    80001cf0:	a8a5                	j	80001d68 <fork+0x108>
  for(i = 0; i < NOFILE; i++)
    80001cf2:	04a1                	addi	s1,s1,8
    80001cf4:	0921                	addi	s2,s2,8
    80001cf6:	01448963          	beq	s1,s4,80001d08 <fork+0xa8>
    if(p->ofile[i])
    80001cfa:	6088                	ld	a0,0(s1)
    80001cfc:	d97d                	beqz	a0,80001cf2 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cfe:	784020ef          	jal	80004482 <filedup>
    80001d02:	00a93023          	sd	a0,0(s2)
    80001d06:	b7f5                	j	80001cf2 <fork+0x92>
  np->cwd = idup(p->cwd);
    80001d08:	150ab503          	ld	a0,336(s5)
    80001d0c:	2d7010ef          	jal	800037e2 <idup>
    80001d10:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d14:	4641                	li	a2,16
    80001d16:	158a8593          	addi	a1,s5,344
    80001d1a:	15898513          	addi	a0,s3,344
    80001d1e:	8f6ff0ef          	jal	80000e14 <safestrcpy>
  pid = np->pid;
    80001d22:	0309a903          	lw	s2,48(s3)
  release(&np->lock);
    80001d26:	854e                	mv	a0,s3
    80001d28:	f73fe0ef          	jal	80000c9a <release>
  acquire(&wait_lock);
    80001d2c:	00012497          	auipc	s1,0x12
    80001d30:	a7c48493          	addi	s1,s1,-1412 # 800137a8 <wait_lock>
    80001d34:	8526                	mv	a0,s1
    80001d36:	ecdfe0ef          	jal	80000c02 <acquire>
  np->parent = p;
    80001d3a:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	f5bfe0ef          	jal	80000c9a <release>
  acquire(&np->lock);
    80001d44:	854e                	mv	a0,s3
    80001d46:	ebdfe0ef          	jal	80000c02 <acquire>
  np->state = RUNNABLE;
    80001d4a:	478d                	li	a5,3
    80001d4c:	00f9ac23          	sw	a5,24(s3)
  np->last_runnable_time = ticks;
    80001d50:	0000a797          	auipc	a5,0xa
    80001d54:	9107a783          	lw	a5,-1776(a5) # 8000b660 <ticks>
    80001d58:	16f9aa23          	sw	a5,372(s3)
  release(&np->lock);
    80001d5c:	854e                	mv	a0,s3
    80001d5e:	f3dfe0ef          	jal	80000c9a <release>
  return pid;
    80001d62:	74a2                	ld	s1,40(sp)
    80001d64:	69e2                	ld	s3,24(sp)
    80001d66:	6a42                	ld	s4,16(sp)
}
    80001d68:	854a                	mv	a0,s2
    80001d6a:	70e2                	ld	ra,56(sp)
    80001d6c:	7442                	ld	s0,48(sp)
    80001d6e:	7902                	ld	s2,32(sp)
    80001d70:	6aa2                	ld	s5,8(sp)
    80001d72:	6121                	addi	sp,sp,64
    80001d74:	8082                	ret
    return -1;
    80001d76:	597d                	li	s2,-1
    80001d78:	bfc5                	j	80001d68 <fork+0x108>

0000000080001d7a <update_time>:
{
    80001d7a:	7179                	addi	sp,sp,-48
    80001d7c:	f406                	sd	ra,40(sp)
    80001d7e:	f022                	sd	s0,32(sp)
    80001d80:	ec26                	sd	s1,24(sp)
    80001d82:	e84a                	sd	s2,16(sp)
    80001d84:	e44e                	sd	s3,8(sp)
    80001d86:	1800                	addi	s0,sp,48
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d88:	00012497          	auipc	s1,0x12
    80001d8c:	e5048493          	addi	s1,s1,-432 # 80013bd8 <proc>
    if (p->state == RUNNING) {
    80001d90:	4991                	li	s3,4
  for (p = proc; p < &proc[NPROC]; p++) {
    80001d92:	00018917          	auipc	s2,0x18
    80001d96:	e4690913          	addi	s2,s2,-442 # 80019bd8 <tickslock>
    80001d9a:	a801                	j	80001daa <update_time+0x30>
    release(&p->lock);
    80001d9c:	8526                	mv	a0,s1
    80001d9e:	efdfe0ef          	jal	80000c9a <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001da2:	18048493          	addi	s1,s1,384
    80001da6:	01248e63          	beq	s1,s2,80001dc2 <update_time+0x48>
    acquire(&p->lock);
    80001daa:	8526                	mv	a0,s1
    80001dac:	e57fe0ef          	jal	80000c02 <acquire>
    if (p->state == RUNNING) {
    80001db0:	4c9c                	lw	a5,24(s1)
    80001db2:	ff3795e3          	bne	a5,s3,80001d9c <update_time+0x22>
      p->run_time++;
    80001db6:	16c4a783          	lw	a5,364(s1)
    80001dba:	2785                	addiw	a5,a5,1
    80001dbc:	16f4a623          	sw	a5,364(s1)
    80001dc0:	bff1                	j	80001d9c <update_time+0x22>
}
    80001dc2:	70a2                	ld	ra,40(sp)
    80001dc4:	7402                	ld	s0,32(sp)
    80001dc6:	64e2                	ld	s1,24(sp)
    80001dc8:	6942                	ld	s2,16(sp)
    80001dca:	69a2                	ld	s3,8(sp)
    80001dcc:	6145                	addi	sp,sp,48
    80001dce:	8082                	ret

0000000080001dd0 <choose_next_process>:
struct proc *choose_next_process() {
    80001dd0:	1141                	addi	sp,sp,-16
    80001dd2:	e422                	sd	s0,8(sp)
    80001dd4:	0800                	addi	s0,sp,16
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001dd6:	0000a797          	auipc	a5,0xa
    80001dda:	8627a783          	lw	a5,-1950(a5) # 8000b638 <sched_mode>
  return 0;
    80001dde:	4501                	li	a0,0
  if(sched_mode == SCHED_ROUND_ROBIN) {
    80001de0:	e395                	bnez	a5,80001e04 <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001de2:	00012517          	auipc	a0,0x12
    80001de6:	df650513          	addi	a0,a0,-522 # 80013bd8 <proc>
      if (p->state == RUNNABLE)
    80001dea:	470d                	li	a4,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dec:	00018697          	auipc	a3,0x18
    80001df0:	dec68693          	addi	a3,a3,-532 # 80019bd8 <tickslock>
      if (p->state == RUNNABLE)
    80001df4:	4d1c                	lw	a5,24(a0)
    80001df6:	00e78763          	beq	a5,a4,80001e04 <choose_next_process+0x34>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001dfa:	18050513          	addi	a0,a0,384
    80001dfe:	fed51be3          	bne	a0,a3,80001df4 <choose_next_process+0x24>
  return 0;
    80001e02:	4501                	li	a0,0
}
    80001e04:	6422                	ld	s0,8(sp)
    80001e06:	0141                	addi	sp,sp,16
    80001e08:	8082                	ret

0000000080001e0a <scheduler>:
{
    80001e0a:	715d                	addi	sp,sp,-80
    80001e0c:	e486                	sd	ra,72(sp)
    80001e0e:	e0a2                	sd	s0,64(sp)
    80001e10:	fc26                	sd	s1,56(sp)
    80001e12:	f84a                	sd	s2,48(sp)
    80001e14:	f44e                	sd	s3,40(sp)
    80001e16:	f052                	sd	s4,32(sp)
    80001e18:	ec56                	sd	s5,24(sp)
    80001e1a:	e85a                	sd	s6,16(sp)
    80001e1c:	e45e                	sd	s7,8(sp)
    80001e1e:	e062                	sd	s8,0(sp)
    80001e20:	0880                	addi	s0,sp,80
    80001e22:	8792                	mv	a5,tp
  int id = r_tp();
    80001e24:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001e26:	00779a93          	slli	s5,a5,0x7
    80001e2a:	00012717          	auipc	a4,0x12
    80001e2e:	96670713          	addi	a4,a4,-1690 # 80013790 <pid_lock>
    80001e32:	9756                	add	a4,a4,s5
    80001e34:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e38:	00012717          	auipc	a4,0x12
    80001e3c:	99070713          	addi	a4,a4,-1648 # 800137c8 <cpus+0x8>
    80001e40:	9aba                	add	s5,s5,a4
    if (sched_mode == SCHED_ROUND_ROBIN) {
    80001e42:	00009b97          	auipc	s7,0x9
    80001e46:	7f6b8b93          	addi	s7,s7,2038 # 8000b638 <sched_mode>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e4a:	00018917          	auipc	s2,0x18
    80001e4e:	d8e90913          	addi	s2,s2,-626 # 80019bd8 <tickslock>
        c->proc = p;
    80001e52:	079e                	slli	a5,a5,0x7
    80001e54:	00012a17          	auipc	s4,0x12
    80001e58:	93ca0a13          	addi	s4,s4,-1732 # 80013790 <pid_lock>
    80001e5c:	9a3e                	add	s4,s4,a5
             p->total_waiting_time += ticks - p->last_runnable_time;
    80001e5e:	0000ab17          	auipc	s6,0xa
    80001e62:	802b0b13          	addi	s6,s6,-2046 # 8000b660 <ticks>
    80001e66:	a899                	j	80001ebc <scheduler+0xb2>
          p->state = RUNNING;
    80001e68:	0184ac23          	sw	s8,24(s1)
          c->proc = p;
    80001e6c:	029a3823          	sd	s1,48(s4)
          swtch(&c->context, &p->context);
    80001e70:	06048593          	addi	a1,s1,96
    80001e74:	8556                	mv	a0,s5
    80001e76:	0c3000ef          	jal	80002738 <swtch>
          c->proc = 0;
    80001e7a:	020a3823          	sd	zero,48(s4)
        release(&p->lock);
    80001e7e:	8526                	mv	a0,s1
    80001e80:	e1bfe0ef          	jal	80000c9a <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001e84:	18048493          	addi	s1,s1,384
    80001e88:	03248a63          	beq	s1,s2,80001ebc <scheduler+0xb2>
        acquire(&p->lock);
    80001e8c:	8526                	mv	a0,s1
    80001e8e:	d75fe0ef          	jal	80000c02 <acquire>
        if(p->state == RUNNABLE){
    80001e92:	4c9c                	lw	a5,24(s1)
    80001e94:	ff3795e3          	bne	a5,s3,80001e7e <scheduler+0x74>
          if(p->last_runnable_time > 0)
    80001e98:	1744a703          	lw	a4,372(s1)
    80001e9c:	d771                	beqz	a4,80001e68 <scheduler+0x5e>
             p->total_waiting_time += ticks - p->last_runnable_time;
    80001e9e:	1784a683          	lw	a3,376(s1)
    80001ea2:	000b2783          	lw	a5,0(s6)
    80001ea6:	9fb5                	addw	a5,a5,a3
    80001ea8:	9f99                	subw	a5,a5,a4
    80001eaa:	16f4ac23          	sw	a5,376(s1)
    80001eae:	bf6d                	j	80001e68 <scheduler+0x5e>
    else if (sched_mode == SCHED_FCFS) {
    80001eb0:	4705                	li	a4,1
    80001eb2:	02e78563          	beq	a5,a4,80001edc <scheduler+0xd2>
    else if (sched_mode == SCHED_PRIORITY) {
    80001eb6:	4709                	li	a4,2
    80001eb8:	0ae78263          	beq	a5,a4,80001f5c <scheduler+0x152>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ebc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ec0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec4:	10079073          	csrw	sstatus,a5
    if (sched_mode == SCHED_ROUND_ROBIN) {
    80001ec8:	000ba783          	lw	a5,0(s7)
    80001ecc:	f3f5                	bnez	a5,80001eb0 <scheduler+0xa6>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ece:	00012497          	auipc	s1,0x12
    80001ed2:	d0a48493          	addi	s1,s1,-758 # 80013bd8 <proc>
        if(p->state == RUNNABLE){
    80001ed6:	498d                	li	s3,3
          p->state = RUNNING;
    80001ed8:	4c11                	li	s8,4
    80001eda:	bf4d                	j	80001e8c <scheduler+0x82>
      struct proc *min_p = 0;
    80001edc:	4981                	li	s3,0
      for(p = proc; p < &proc[NPROC]; p++){
    80001ede:	00012497          	auipc	s1,0x12
    80001ee2:	cfa48493          	addi	s1,s1,-774 # 80013bd8 <proc>
        if(p->state == RUNNABLE){
    80001ee6:	4c0d                	li	s8,3
    80001ee8:	a801                	j	80001ef8 <scheduler+0xee>
        release(&p->lock);
    80001eea:	8526                	mv	a0,s1
    80001eec:	daffe0ef          	jal	80000c9a <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001ef0:	18048493          	addi	s1,s1,384
    80001ef4:	03248763          	beq	s1,s2,80001f22 <scheduler+0x118>
        acquire(&p->lock);
    80001ef8:	8526                	mv	a0,s1
    80001efa:	d09fe0ef          	jal	80000c02 <acquire>
        if(p->state == RUNNABLE){
    80001efe:	4c9c                	lw	a5,24(s1)
    80001f00:	ff8795e3          	bne	a5,s8,80001eea <scheduler+0xe0>
          if(min_p == 0 || p->creation_time < min_p->creation_time){
    80001f04:	00098d63          	beqz	s3,80001f1e <scheduler+0x114>
    80001f08:	1684a703          	lw	a4,360(s1)
    80001f0c:	1689a783          	lw	a5,360(s3)
    80001f10:	fcf77de3          	bgeu	a4,a5,80001eea <scheduler+0xe0>
            if(min_p) release(&min_p->lock); // Release the old candidate
    80001f14:	854e                	mv	a0,s3
    80001f16:	d85fe0ef          	jal	80000c9a <release>
            min_p = p; // Keep holding the lock on the new candidate
    80001f1a:	89a6                	mv	s3,s1
    80001f1c:	bfd1                	j	80001ef0 <scheduler+0xe6>
    80001f1e:	89a6                	mv	s3,s1
    80001f20:	bfc1                	j	80001ef0 <scheduler+0xe6>
      if(min_p != 0){
    80001f22:	f8098de3          	beqz	s3,80001ebc <scheduler+0xb2>
        if(p->last_runnable_time > 0)
    80001f26:	1749a703          	lw	a4,372(s3)
    80001f2a:	cb09                	beqz	a4,80001f3c <scheduler+0x132>
             p->total_waiting_time += ticks - p->last_runnable_time;
    80001f2c:	1789a683          	lw	a3,376(s3)
    80001f30:	000b2783          	lw	a5,0(s6)
    80001f34:	9fb5                	addw	a5,a5,a3
    80001f36:	9f99                	subw	a5,a5,a4
    80001f38:	16f9ac23          	sw	a5,376(s3)
        p->state = RUNNING;
    80001f3c:	4791                	li	a5,4
    80001f3e:	00f9ac23          	sw	a5,24(s3)
        c->proc = p;
    80001f42:	033a3823          	sd	s3,48(s4)
        swtch(&c->context, &p->context);
    80001f46:	06098593          	addi	a1,s3,96
    80001f4a:	8556                	mv	a0,s5
    80001f4c:	7ec000ef          	jal	80002738 <swtch>
        c->proc = 0;
    80001f50:	020a3823          	sd	zero,48(s4)
        release(&p->lock);
    80001f54:	854e                	mv	a0,s3
    80001f56:	d45fe0ef          	jal	80000c9a <release>
    80001f5a:	b78d                	j	80001ebc <scheduler+0xb2>
      struct proc *high_p = 0;
    80001f5c:	4981                	li	s3,0
      for(p = proc; p < &proc[NPROC]; p++){
    80001f5e:	00012497          	auipc	s1,0x12
    80001f62:	c7a48493          	addi	s1,s1,-902 # 80013bd8 <proc>
        if(p->state == RUNNABLE){
    80001f66:	4c0d                	li	s8,3
    80001f68:	a801                	j	80001f78 <scheduler+0x16e>
        release(&p->lock);
    80001f6a:	8526                	mv	a0,s1
    80001f6c:	d2ffe0ef          	jal	80000c9a <release>
      for(p = proc; p < &proc[NPROC]; p++){
    80001f70:	18048493          	addi	s1,s1,384
    80001f74:	03248f63          	beq	s1,s2,80001fb2 <scheduler+0x1a8>
        acquire(&p->lock);
    80001f78:	8526                	mv	a0,s1
    80001f7a:	c89fe0ef          	jal	80000c02 <acquire>
        if(p->state == RUNNABLE){
    80001f7e:	4c9c                	lw	a5,24(s1)
    80001f80:	ff8795e3          	bne	a5,s8,80001f6a <scheduler+0x160>
          if(high_p == 0 || p->priority < high_p->priority || (p->priority == high_p->priority && p->creation_time < high_p->creation_time)){
    80001f84:	02098563          	beqz	s3,80001fae <scheduler+0x1a4>
    80001f88:	1704a703          	lw	a4,368(s1)
    80001f8c:	1709a783          	lw	a5,368(s3)
    80001f90:	00f74a63          	blt	a4,a5,80001fa4 <scheduler+0x19a>
    80001f94:	fcf71be3          	bne	a4,a5,80001f6a <scheduler+0x160>
    80001f98:	1684a703          	lw	a4,360(s1)
    80001f9c:	1689a783          	lw	a5,360(s3)
    80001fa0:	fcf775e3          	bgeu	a4,a5,80001f6a <scheduler+0x160>
            if(high_p) release(&high_p->lock); // Release the old candidate
    80001fa4:	854e                	mv	a0,s3
    80001fa6:	cf5fe0ef          	jal	80000c9a <release>
            high_p = p; // Keep holding the lock on the new candidate
    80001faa:	89a6                	mv	s3,s1
    80001fac:	b7d1                	j	80001f70 <scheduler+0x166>
    80001fae:	89a6                	mv	s3,s1
    80001fb0:	b7c1                	j	80001f70 <scheduler+0x166>
      if(high_p != 0){
    80001fb2:	f00985e3          	beqz	s3,80001ebc <scheduler+0xb2>
        if(p->last_runnable_time > 0)
    80001fb6:	1749a703          	lw	a4,372(s3)
    80001fba:	cb09                	beqz	a4,80001fcc <scheduler+0x1c2>
             p->total_waiting_time += ticks - p->last_runnable_time;
    80001fbc:	1789a683          	lw	a3,376(s3)
    80001fc0:	000b2783          	lw	a5,0(s6)
    80001fc4:	9fb5                	addw	a5,a5,a3
    80001fc6:	9f99                	subw	a5,a5,a4
    80001fc8:	16f9ac23          	sw	a5,376(s3)
        p->state = RUNNING;
    80001fcc:	4791                	li	a5,4
    80001fce:	00f9ac23          	sw	a5,24(s3)
        c->proc = p;
    80001fd2:	033a3823          	sd	s3,48(s4)
        swtch(&c->context, &p->context);
    80001fd6:	06098593          	addi	a1,s3,96
    80001fda:	8556                	mv	a0,s5
    80001fdc:	75c000ef          	jal	80002738 <swtch>
        c->proc = 0;
    80001fe0:	020a3823          	sd	zero,48(s4)
        release(&p->lock);
    80001fe4:	854e                	mv	a0,s3
    80001fe6:	cb5fe0ef          	jal	80000c9a <release>
    80001fea:	bdc9                	j	80001ebc <scheduler+0xb2>

0000000080001fec <sched>:
{
    80001fec:	7179                	addi	sp,sp,-48
    80001fee:	f406                	sd	ra,40(sp)
    80001ff0:	f022                	sd	s0,32(sp)
    80001ff2:	ec26                	sd	s1,24(sp)
    80001ff4:	e84a                	sd	s2,16(sp)
    80001ff6:	e44e                	sd	s3,8(sp)
    80001ff8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001ffa:	907ff0ef          	jal	80001900 <myproc>
    80001ffe:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002000:	b99fe0ef          	jal	80000b98 <holding>
    80002004:	c92d                	beqz	a0,80002076 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002006:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002008:	2781                	sext.w	a5,a5
    8000200a:	079e                	slli	a5,a5,0x7
    8000200c:	00011717          	auipc	a4,0x11
    80002010:	78470713          	addi	a4,a4,1924 # 80013790 <pid_lock>
    80002014:	97ba                	add	a5,a5,a4
    80002016:	0a87a703          	lw	a4,168(a5)
    8000201a:	4785                	li	a5,1
    8000201c:	06f71363          	bne	a4,a5,80002082 <sched+0x96>
  if(p->state == RUNNING)
    80002020:	4c98                	lw	a4,24(s1)
    80002022:	4791                	li	a5,4
    80002024:	06f70563          	beq	a4,a5,8000208e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002028:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000202c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000202e:	e7b5                	bnez	a5,8000209a <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002030:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002032:	00011917          	auipc	s2,0x11
    80002036:	75e90913          	addi	s2,s2,1886 # 80013790 <pid_lock>
    8000203a:	2781                	sext.w	a5,a5
    8000203c:	079e                	slli	a5,a5,0x7
    8000203e:	97ca                	add	a5,a5,s2
    80002040:	0ac7a983          	lw	s3,172(a5)
    80002044:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002046:	2781                	sext.w	a5,a5
    80002048:	079e                	slli	a5,a5,0x7
    8000204a:	00011597          	auipc	a1,0x11
    8000204e:	77e58593          	addi	a1,a1,1918 # 800137c8 <cpus+0x8>
    80002052:	95be                	add	a1,a1,a5
    80002054:	06048513          	addi	a0,s1,96
    80002058:	6e0000ef          	jal	80002738 <swtch>
    8000205c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000205e:	2781                	sext.w	a5,a5
    80002060:	079e                	slli	a5,a5,0x7
    80002062:	993e                	add	s2,s2,a5
    80002064:	0b392623          	sw	s3,172(s2)
}
    80002068:	70a2                	ld	ra,40(sp)
    8000206a:	7402                	ld	s0,32(sp)
    8000206c:	64e2                	ld	s1,24(sp)
    8000206e:	6942                	ld	s2,16(sp)
    80002070:	69a2                	ld	s3,8(sp)
    80002072:	6145                	addi	sp,sp,48
    80002074:	8082                	ret
    panic("sched p->lock");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	1c250513          	addi	a0,a0,450 # 80008238 <etext+0x238>
    8000207e:	f24fe0ef          	jal	800007a2 <panic>
    panic("sched locks");
    80002082:	00006517          	auipc	a0,0x6
    80002086:	1c650513          	addi	a0,a0,454 # 80008248 <etext+0x248>
    8000208a:	f18fe0ef          	jal	800007a2 <panic>
    panic("sched running");
    8000208e:	00006517          	auipc	a0,0x6
    80002092:	1ca50513          	addi	a0,a0,458 # 80008258 <etext+0x258>
    80002096:	f0cfe0ef          	jal	800007a2 <panic>
    panic("sched interruptible");
    8000209a:	00006517          	auipc	a0,0x6
    8000209e:	1ce50513          	addi	a0,a0,462 # 80008268 <etext+0x268>
    800020a2:	f00fe0ef          	jal	800007a2 <panic>

00000000800020a6 <yield>:
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800020b0:	851ff0ef          	jal	80001900 <myproc>
    800020b4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020b6:	b4dfe0ef          	jal	80000c02 <acquire>
  if (sched_mode == SCHED_FCFS) {
    800020ba:	00009717          	auipc	a4,0x9
    800020be:	57e72703          	lw	a4,1406(a4) # 8000b638 <sched_mode>
    800020c2:	4785                	li	a5,1
    800020c4:	02f70463          	beq	a4,a5,800020ec <yield+0x46>
  p->state = RUNNABLE;
    800020c8:	478d                	li	a5,3
    800020ca:	cc9c                	sw	a5,24(s1)
  p->last_runnable_time = ticks; // Mark exactly when we started waiting
    800020cc:	00009797          	auipc	a5,0x9
    800020d0:	5947a783          	lw	a5,1428(a5) # 8000b660 <ticks>
    800020d4:	16f4aa23          	sw	a5,372(s1)
  sched();
    800020d8:	f15ff0ef          	jal	80001fec <sched>
  release(&p->lock);
    800020dc:	8526                	mv	a0,s1
    800020de:	bbdfe0ef          	jal	80000c9a <release>
}
    800020e2:	60e2                	ld	ra,24(sp)
    800020e4:	6442                	ld	s0,16(sp)
    800020e6:	64a2                	ld	s1,8(sp)
    800020e8:	6105                	addi	sp,sp,32
    800020ea:	8082                	ret
      release(&p->lock);
    800020ec:	8526                	mv	a0,s1
    800020ee:	badfe0ef          	jal	80000c9a <release>
      return;
    800020f2:	bfc5                	j	800020e2 <yield+0x3c>

00000000800020f4 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800020f4:	7179                	addi	sp,sp,-48
    800020f6:	f406                	sd	ra,40(sp)
    800020f8:	f022                	sd	s0,32(sp)
    800020fa:	ec26                	sd	s1,24(sp)
    800020fc:	e84a                	sd	s2,16(sp)
    800020fe:	e44e                	sd	s3,8(sp)
    80002100:	1800                	addi	s0,sp,48
    80002102:	89aa                	mv	s3,a0
    80002104:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002106:	ffaff0ef          	jal	80001900 <myproc>
    8000210a:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000210c:	af7fe0ef          	jal	80000c02 <acquire>
  release(lk);
    80002110:	854a                	mv	a0,s2
    80002112:	b89fe0ef          	jal	80000c9a <release>

  // Go to sleep.
  p->chan = chan;
    80002116:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000211a:	4789                	li	a5,2
    8000211c:	cc9c                	sw	a5,24(s1)

  sched();
    8000211e:	ecfff0ef          	jal	80001fec <sched>

  // Tidy up.
  p->chan = 0;
    80002122:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80002126:	8526                	mv	a0,s1
    80002128:	b73fe0ef          	jal	80000c9a <release>
  acquire(lk);
    8000212c:	854a                	mv	a0,s2
    8000212e:	ad5fe0ef          	jal	80000c02 <acquire>
}
    80002132:	70a2                	ld	ra,40(sp)
    80002134:	7402                	ld	s0,32(sp)
    80002136:	64e2                	ld	s1,24(sp)
    80002138:	6942                	ld	s2,16(sp)
    8000213a:	69a2                	ld	s3,8(sp)
    8000213c:	6145                	addi	sp,sp,48
    8000213e:	8082                	ret

0000000080002140 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002140:	7139                	addi	sp,sp,-64
    80002142:	fc06                	sd	ra,56(sp)
    80002144:	f822                	sd	s0,48(sp)
    80002146:	f426                	sd	s1,40(sp)
    80002148:	f04a                	sd	s2,32(sp)
    8000214a:	ec4e                	sd	s3,24(sp)
    8000214c:	e852                	sd	s4,16(sp)
    8000214e:	e456                	sd	s5,8(sp)
    80002150:	e05a                	sd	s6,0(sp)
    80002152:	0080                	addi	s0,sp,64
    80002154:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002156:	00012497          	auipc	s1,0x12
    8000215a:	a8248493          	addi	s1,s1,-1406 # 80013bd8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000215e:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002160:	4b0d                	li	s6,3
        //p3
        p->last_runnable_time = ticks;
    80002162:	00009a97          	auipc	s5,0x9
    80002166:	4fea8a93          	addi	s5,s5,1278 # 8000b660 <ticks>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000216a:	00018917          	auipc	s2,0x18
    8000216e:	a6e90913          	addi	s2,s2,-1426 # 80019bd8 <tickslock>
    80002172:	a801                	j	80002182 <wakeup+0x42>
      }
      release(&p->lock);
    80002174:	8526                	mv	a0,s1
    80002176:	b25fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000217a:	18048493          	addi	s1,s1,384
    8000217e:	03248663          	beq	s1,s2,800021aa <wakeup+0x6a>
    if(p != myproc()){
    80002182:	f7eff0ef          	jal	80001900 <myproc>
    80002186:	fea48ae3          	beq	s1,a0,8000217a <wakeup+0x3a>
      acquire(&p->lock);
    8000218a:	8526                	mv	a0,s1
    8000218c:	a77fe0ef          	jal	80000c02 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002190:	4c9c                	lw	a5,24(s1)
    80002192:	ff3791e3          	bne	a5,s3,80002174 <wakeup+0x34>
    80002196:	709c                	ld	a5,32(s1)
    80002198:	fd479ee3          	bne	a5,s4,80002174 <wakeup+0x34>
        p->state = RUNNABLE;
    8000219c:	0164ac23          	sw	s6,24(s1)
        p->last_runnable_time = ticks;
    800021a0:	000aa783          	lw	a5,0(s5)
    800021a4:	16f4aa23          	sw	a5,372(s1)
    800021a8:	b7f1                	j	80002174 <wakeup+0x34>
    }
  }
}
    800021aa:	70e2                	ld	ra,56(sp)
    800021ac:	7442                	ld	s0,48(sp)
    800021ae:	74a2                	ld	s1,40(sp)
    800021b0:	7902                	ld	s2,32(sp)
    800021b2:	69e2                	ld	s3,24(sp)
    800021b4:	6a42                	ld	s4,16(sp)
    800021b6:	6aa2                	ld	s5,8(sp)
    800021b8:	6b02                	ld	s6,0(sp)
    800021ba:	6121                	addi	sp,sp,64
    800021bc:	8082                	ret

00000000800021be <reparent>:
{
    800021be:	7179                	addi	sp,sp,-48
    800021c0:	f406                	sd	ra,40(sp)
    800021c2:	f022                	sd	s0,32(sp)
    800021c4:	ec26                	sd	s1,24(sp)
    800021c6:	e84a                	sd	s2,16(sp)
    800021c8:	e44e                	sd	s3,8(sp)
    800021ca:	e052                	sd	s4,0(sp)
    800021cc:	1800                	addi	s0,sp,48
    800021ce:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021d0:	00012497          	auipc	s1,0x12
    800021d4:	a0848493          	addi	s1,s1,-1528 # 80013bd8 <proc>
      pp->parent = initproc;
    800021d8:	00009a17          	auipc	s4,0x9
    800021dc:	480a0a13          	addi	s4,s4,1152 # 8000b658 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800021e0:	00018997          	auipc	s3,0x18
    800021e4:	9f898993          	addi	s3,s3,-1544 # 80019bd8 <tickslock>
    800021e8:	a029                	j	800021f2 <reparent+0x34>
    800021ea:	18048493          	addi	s1,s1,384
    800021ee:	01348b63          	beq	s1,s3,80002204 <reparent+0x46>
    if(pp->parent == p){
    800021f2:	7c9c                	ld	a5,56(s1)
    800021f4:	ff279be3          	bne	a5,s2,800021ea <reparent+0x2c>
      pp->parent = initproc;
    800021f8:	000a3503          	ld	a0,0(s4)
    800021fc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800021fe:	f43ff0ef          	jal	80002140 <wakeup>
    80002202:	b7e5                	j	800021ea <reparent+0x2c>
}
    80002204:	70a2                	ld	ra,40(sp)
    80002206:	7402                	ld	s0,32(sp)
    80002208:	64e2                	ld	s1,24(sp)
    8000220a:	6942                	ld	s2,16(sp)
    8000220c:	69a2                	ld	s3,8(sp)
    8000220e:	6a02                	ld	s4,0(sp)
    80002210:	6145                	addi	sp,sp,48
    80002212:	8082                	ret

0000000080002214 <exit>:
{
    80002214:	7179                	addi	sp,sp,-48
    80002216:	f406                	sd	ra,40(sp)
    80002218:	f022                	sd	s0,32(sp)
    8000221a:	e052                	sd	s4,0(sp)
    8000221c:	1800                	addi	s0,sp,48
    8000221e:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002220:	ee0ff0ef          	jal	80001900 <myproc>
  if(p == initproc)
    80002224:	00009797          	auipc	a5,0x9
    80002228:	4347b783          	ld	a5,1076(a5) # 8000b658 <initproc>
    8000222c:	06a78563          	beq	a5,a0,80002296 <exit+0x82>
    80002230:	ec26                	sd	s1,24(sp)
    80002232:	e84a                	sd	s2,16(sp)
    80002234:	e44e                	sd	s3,8(sp)
    80002236:	89aa                	mv	s3,a0
  acquire(&metrics_lock);
    80002238:	00012497          	auipc	s1,0x12
    8000223c:	98848493          	addi	s1,s1,-1656 # 80013bc0 <metrics_lock>
    80002240:	8526                	mv	a0,s1
    80002242:	9c1fe0ef          	jal	80000c02 <acquire>
  total_turnaround_time += (ticks - p->creation_time);
    80002246:	00009717          	auipc	a4,0x9
    8000224a:	40a70713          	addi	a4,a4,1034 # 8000b650 <total_turnaround_time>
    8000224e:	00009797          	auipc	a5,0x9
    80002252:	4127a783          	lw	a5,1042(a5) # 8000b660 <ticks>
    80002256:	1689a683          	lw	a3,360(s3)
    8000225a:	9f95                	subw	a5,a5,a3
    8000225c:	1782                	slli	a5,a5,0x20
    8000225e:	9381                	srli	a5,a5,0x20
    80002260:	6314                	ld	a3,0(a4)
    80002262:	97b6                	add	a5,a5,a3
    80002264:	e31c                	sd	a5,0(a4)
  total_waiting_time_sum += p->total_waiting_time;
    80002266:	00009717          	auipc	a4,0x9
    8000226a:	3e270713          	addi	a4,a4,994 # 8000b648 <total_waiting_time_sum>
    8000226e:	1789e783          	lwu	a5,376(s3)
    80002272:	6314                	ld	a3,0(a4)
    80002274:	97b6                	add	a5,a5,a3
    80002276:	e31c                	sd	a5,0(a4)
  finished_processes++;
    80002278:	00009717          	auipc	a4,0x9
    8000227c:	3c870713          	addi	a4,a4,968 # 8000b640 <finished_processes>
    80002280:	631c                	ld	a5,0(a4)
    80002282:	0785                	addi	a5,a5,1
    80002284:	e31c                	sd	a5,0(a4)
  release(&metrics_lock);
    80002286:	8526                	mv	a0,s1
    80002288:	a13fe0ef          	jal	80000c9a <release>
  for(int fd = 0; fd < NOFILE; fd++){
    8000228c:	0d098493          	addi	s1,s3,208
    80002290:	15098913          	addi	s2,s3,336
    80002294:	a00d                	j	800022b6 <exit+0xa2>
    80002296:	ec26                	sd	s1,24(sp)
    80002298:	e84a                	sd	s2,16(sp)
    8000229a:	e44e                	sd	s3,8(sp)
    panic("init exiting");
    8000229c:	00006517          	auipc	a0,0x6
    800022a0:	fe450513          	addi	a0,a0,-28 # 80008280 <etext+0x280>
    800022a4:	cfefe0ef          	jal	800007a2 <panic>
      fileclose(f);
    800022a8:	220020ef          	jal	800044c8 <fileclose>
      p->ofile[fd] = 0;
    800022ac:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800022b0:	04a1                	addi	s1,s1,8
    800022b2:	01248563          	beq	s1,s2,800022bc <exit+0xa8>
    if(p->ofile[fd]){
    800022b6:	6088                	ld	a0,0(s1)
    800022b8:	f965                	bnez	a0,800022a8 <exit+0x94>
    800022ba:	bfdd                	j	800022b0 <exit+0x9c>
  begin_op();
    800022bc:	5f3010ef          	jal	800040ae <begin_op>
  iput(p->cwd);
    800022c0:	1509b503          	ld	a0,336(s3)
    800022c4:	6d6010ef          	jal	8000399a <iput>
  end_op();
    800022c8:	651010ef          	jal	80004118 <end_op>
  p->cwd = 0;
    800022cc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800022d0:	00011497          	auipc	s1,0x11
    800022d4:	4d848493          	addi	s1,s1,1240 # 800137a8 <wait_lock>
    800022d8:	8526                	mv	a0,s1
    800022da:	929fe0ef          	jal	80000c02 <acquire>
  reparent(p);
    800022de:	854e                	mv	a0,s3
    800022e0:	edfff0ef          	jal	800021be <reparent>
  wakeup(p->parent);
    800022e4:	0389b503          	ld	a0,56(s3)
    800022e8:	e59ff0ef          	jal	80002140 <wakeup>
  acquire(&p->lock);
    800022ec:	854e                	mv	a0,s3
    800022ee:	915fe0ef          	jal	80000c02 <acquire>
  p->xstate = status;
    800022f2:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800022f6:	4795                	li	a5,5
    800022f8:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800022fc:	8526                	mv	a0,s1
    800022fe:	99dfe0ef          	jal	80000c9a <release>
  sched();
    80002302:	cebff0ef          	jal	80001fec <sched>
  panic("zombie exit");
    80002306:	00006517          	auipc	a0,0x6
    8000230a:	f8a50513          	addi	a0,a0,-118 # 80008290 <etext+0x290>
    8000230e:	c94fe0ef          	jal	800007a2 <panic>

0000000080002312 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002312:	7179                	addi	sp,sp,-48
    80002314:	f406                	sd	ra,40(sp)
    80002316:	f022                	sd	s0,32(sp)
    80002318:	ec26                	sd	s1,24(sp)
    8000231a:	e84a                	sd	s2,16(sp)
    8000231c:	e44e                	sd	s3,8(sp)
    8000231e:	1800                	addi	s0,sp,48
    80002320:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002322:	00012497          	auipc	s1,0x12
    80002326:	8b648493          	addi	s1,s1,-1866 # 80013bd8 <proc>
    8000232a:	00018997          	auipc	s3,0x18
    8000232e:	8ae98993          	addi	s3,s3,-1874 # 80019bd8 <tickslock>
    acquire(&p->lock);
    80002332:	8526                	mv	a0,s1
    80002334:	8cffe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid){
    80002338:	589c                	lw	a5,48(s1)
    8000233a:	01278b63          	beq	a5,s2,80002350 <kill+0x3e>
        p->last_runnable_time = ticks;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000233e:	8526                	mv	a0,s1
    80002340:	95bfe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002344:	18048493          	addi	s1,s1,384
    80002348:	ff3495e3          	bne	s1,s3,80002332 <kill+0x20>
  }
  return -1;
    8000234c:	557d                	li	a0,-1
    8000234e:	a819                	j	80002364 <kill+0x52>
      p->killed = 1;
    80002350:	4785                	li	a5,1
    80002352:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002354:	4c98                	lw	a4,24(s1)
    80002356:	4789                	li	a5,2
    80002358:	00f70d63          	beq	a4,a5,80002372 <kill+0x60>
      release(&p->lock);
    8000235c:	8526                	mv	a0,s1
    8000235e:	93dfe0ef          	jal	80000c9a <release>
      return 0;
    80002362:	4501                	li	a0,0
}
    80002364:	70a2                	ld	ra,40(sp)
    80002366:	7402                	ld	s0,32(sp)
    80002368:	64e2                	ld	s1,24(sp)
    8000236a:	6942                	ld	s2,16(sp)
    8000236c:	69a2                	ld	s3,8(sp)
    8000236e:	6145                	addi	sp,sp,48
    80002370:	8082                	ret
        p->state = RUNNABLE;
    80002372:	478d                	li	a5,3
    80002374:	cc9c                	sw	a5,24(s1)
        p->last_runnable_time = ticks;
    80002376:	00009797          	auipc	a5,0x9
    8000237a:	2ea7a783          	lw	a5,746(a5) # 8000b660 <ticks>
    8000237e:	16f4aa23          	sw	a5,372(s1)
    80002382:	bfe9                	j	8000235c <kill+0x4a>

0000000080002384 <setkilled>:

void
setkilled(struct proc *p)
{
    80002384:	1101                	addi	sp,sp,-32
    80002386:	ec06                	sd	ra,24(sp)
    80002388:	e822                	sd	s0,16(sp)
    8000238a:	e426                	sd	s1,8(sp)
    8000238c:	1000                	addi	s0,sp,32
    8000238e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002390:	873fe0ef          	jal	80000c02 <acquire>
  p->killed = 1;
    80002394:	4785                	li	a5,1
    80002396:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002398:	8526                	mv	a0,s1
    8000239a:	901fe0ef          	jal	80000c9a <release>
}
    8000239e:	60e2                	ld	ra,24(sp)
    800023a0:	6442                	ld	s0,16(sp)
    800023a2:	64a2                	ld	s1,8(sp)
    800023a4:	6105                	addi	sp,sp,32
    800023a6:	8082                	ret

00000000800023a8 <killed>:

int
killed(struct proc *p)
{
    800023a8:	1101                	addi	sp,sp,-32
    800023aa:	ec06                	sd	ra,24(sp)
    800023ac:	e822                	sd	s0,16(sp)
    800023ae:	e426                	sd	s1,8(sp)
    800023b0:	e04a                	sd	s2,0(sp)
    800023b2:	1000                	addi	s0,sp,32
    800023b4:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    800023b6:	84dfe0ef          	jal	80000c02 <acquire>
  k = p->killed;
    800023ba:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800023be:	8526                	mv	a0,s1
    800023c0:	8dbfe0ef          	jal	80000c9a <release>
  return k;
}
    800023c4:	854a                	mv	a0,s2
    800023c6:	60e2                	ld	ra,24(sp)
    800023c8:	6442                	ld	s0,16(sp)
    800023ca:	64a2                	ld	s1,8(sp)
    800023cc:	6902                	ld	s2,0(sp)
    800023ce:	6105                	addi	sp,sp,32
    800023d0:	8082                	ret

00000000800023d2 <wait>:
{
    800023d2:	715d                	addi	sp,sp,-80
    800023d4:	e486                	sd	ra,72(sp)
    800023d6:	e0a2                	sd	s0,64(sp)
    800023d8:	fc26                	sd	s1,56(sp)
    800023da:	f84a                	sd	s2,48(sp)
    800023dc:	f44e                	sd	s3,40(sp)
    800023de:	f052                	sd	s4,32(sp)
    800023e0:	ec56                	sd	s5,24(sp)
    800023e2:	e85a                	sd	s6,16(sp)
    800023e4:	e45e                	sd	s7,8(sp)
    800023e6:	e062                	sd	s8,0(sp)
    800023e8:	0880                	addi	s0,sp,80
    800023ea:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800023ec:	d14ff0ef          	jal	80001900 <myproc>
    800023f0:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800023f2:	00011517          	auipc	a0,0x11
    800023f6:	3b650513          	addi	a0,a0,950 # 800137a8 <wait_lock>
    800023fa:	809fe0ef          	jal	80000c02 <acquire>
    havekids = 0;
    800023fe:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002400:	4a15                	li	s4,5
        havekids = 1;
    80002402:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002404:	00017997          	auipc	s3,0x17
    80002408:	7d498993          	addi	s3,s3,2004 # 80019bd8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000240c:	00011c17          	auipc	s8,0x11
    80002410:	39cc0c13          	addi	s8,s8,924 # 800137a8 <wait_lock>
    80002414:	a871                	j	800024b0 <wait+0xde>
          pid = pp->pid;
    80002416:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000241a:	000b0c63          	beqz	s6,80002432 <wait+0x60>
    8000241e:	4691                	li	a3,4
    80002420:	02c48613          	addi	a2,s1,44
    80002424:	85da                	mv	a1,s6
    80002426:	05093503          	ld	a0,80(s2)
    8000242a:	948ff0ef          	jal	80001572 <copyout>
    8000242e:	02054b63          	bltz	a0,80002464 <wait+0x92>
          freeproc(pp);
    80002432:	8526                	mv	a0,s1
    80002434:	e3eff0ef          	jal	80001a72 <freeproc>
          release(&pp->lock);
    80002438:	8526                	mv	a0,s1
    8000243a:	861fe0ef          	jal	80000c9a <release>
          release(&wait_lock);
    8000243e:	00011517          	auipc	a0,0x11
    80002442:	36a50513          	addi	a0,a0,874 # 800137a8 <wait_lock>
    80002446:	855fe0ef          	jal	80000c9a <release>
}
    8000244a:	854e                	mv	a0,s3
    8000244c:	60a6                	ld	ra,72(sp)
    8000244e:	6406                	ld	s0,64(sp)
    80002450:	74e2                	ld	s1,56(sp)
    80002452:	7942                	ld	s2,48(sp)
    80002454:	79a2                	ld	s3,40(sp)
    80002456:	7a02                	ld	s4,32(sp)
    80002458:	6ae2                	ld	s5,24(sp)
    8000245a:	6b42                	ld	s6,16(sp)
    8000245c:	6ba2                	ld	s7,8(sp)
    8000245e:	6c02                	ld	s8,0(sp)
    80002460:	6161                	addi	sp,sp,80
    80002462:	8082                	ret
            release(&pp->lock);
    80002464:	8526                	mv	a0,s1
    80002466:	835fe0ef          	jal	80000c9a <release>
            release(&wait_lock);
    8000246a:	00011517          	auipc	a0,0x11
    8000246e:	33e50513          	addi	a0,a0,830 # 800137a8 <wait_lock>
    80002472:	829fe0ef          	jal	80000c9a <release>
            return -1;
    80002476:	59fd                	li	s3,-1
    80002478:	bfc9                	j	8000244a <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000247a:	18048493          	addi	s1,s1,384
    8000247e:	03348063          	beq	s1,s3,8000249e <wait+0xcc>
      if(pp->parent == p){
    80002482:	7c9c                	ld	a5,56(s1)
    80002484:	ff279be3          	bne	a5,s2,8000247a <wait+0xa8>
        acquire(&pp->lock);
    80002488:	8526                	mv	a0,s1
    8000248a:	f78fe0ef          	jal	80000c02 <acquire>
        if(pp->state == ZOMBIE){
    8000248e:	4c9c                	lw	a5,24(s1)
    80002490:	f94783e3          	beq	a5,s4,80002416 <wait+0x44>
        release(&pp->lock);
    80002494:	8526                	mv	a0,s1
    80002496:	805fe0ef          	jal	80000c9a <release>
        havekids = 1;
    8000249a:	8756                	mv	a4,s5
    8000249c:	bff9                	j	8000247a <wait+0xa8>
    if(!havekids || killed(p)){
    8000249e:	cf19                	beqz	a4,800024bc <wait+0xea>
    800024a0:	854a                	mv	a0,s2
    800024a2:	f07ff0ef          	jal	800023a8 <killed>
    800024a6:	e919                	bnez	a0,800024bc <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800024a8:	85e2                	mv	a1,s8
    800024aa:	854a                	mv	a0,s2
    800024ac:	c49ff0ef          	jal	800020f4 <sleep>
    havekids = 0;
    800024b0:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800024b2:	00011497          	auipc	s1,0x11
    800024b6:	72648493          	addi	s1,s1,1830 # 80013bd8 <proc>
    800024ba:	b7e1                	j	80002482 <wait+0xb0>
      release(&wait_lock);
    800024bc:	00011517          	auipc	a0,0x11
    800024c0:	2ec50513          	addi	a0,a0,748 # 800137a8 <wait_lock>
    800024c4:	fd6fe0ef          	jal	80000c9a <release>
      return -1;
    800024c8:	59fd                	li	s3,-1
    800024ca:	b741                	j	8000244a <wait+0x78>

00000000800024cc <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800024cc:	7179                	addi	sp,sp,-48
    800024ce:	f406                	sd	ra,40(sp)
    800024d0:	f022                	sd	s0,32(sp)
    800024d2:	ec26                	sd	s1,24(sp)
    800024d4:	e84a                	sd	s2,16(sp)
    800024d6:	e44e                	sd	s3,8(sp)
    800024d8:	e052                	sd	s4,0(sp)
    800024da:	1800                	addi	s0,sp,48
    800024dc:	84aa                	mv	s1,a0
    800024de:	892e                	mv	s2,a1
    800024e0:	89b2                	mv	s3,a2
    800024e2:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024e4:	c1cff0ef          	jal	80001900 <myproc>
  if(user_dst){
    800024e8:	cc99                	beqz	s1,80002506 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800024ea:	86d2                	mv	a3,s4
    800024ec:	864e                	mv	a2,s3
    800024ee:	85ca                	mv	a1,s2
    800024f0:	6928                	ld	a0,80(a0)
    800024f2:	880ff0ef          	jal	80001572 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800024f6:	70a2                	ld	ra,40(sp)
    800024f8:	7402                	ld	s0,32(sp)
    800024fa:	64e2                	ld	s1,24(sp)
    800024fc:	6942                	ld	s2,16(sp)
    800024fe:	69a2                	ld	s3,8(sp)
    80002500:	6a02                	ld	s4,0(sp)
    80002502:	6145                	addi	sp,sp,48
    80002504:	8082                	ret
    memmove((char *)dst, src, len);
    80002506:	000a061b          	sext.w	a2,s4
    8000250a:	85ce                	mv	a1,s3
    8000250c:	854a                	mv	a0,s2
    8000250e:	825fe0ef          	jal	80000d32 <memmove>
    return 0;
    80002512:	8526                	mv	a0,s1
    80002514:	b7cd                	j	800024f6 <either_copyout+0x2a>

0000000080002516 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002516:	7179                	addi	sp,sp,-48
    80002518:	f406                	sd	ra,40(sp)
    8000251a:	f022                	sd	s0,32(sp)
    8000251c:	ec26                	sd	s1,24(sp)
    8000251e:	e84a                	sd	s2,16(sp)
    80002520:	e44e                	sd	s3,8(sp)
    80002522:	e052                	sd	s4,0(sp)
    80002524:	1800                	addi	s0,sp,48
    80002526:	892a                	mv	s2,a0
    80002528:	84ae                	mv	s1,a1
    8000252a:	89b2                	mv	s3,a2
    8000252c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000252e:	bd2ff0ef          	jal	80001900 <myproc>
  if(user_src){
    80002532:	cc99                	beqz	s1,80002550 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002534:	86d2                	mv	a3,s4
    80002536:	864e                	mv	a2,s3
    80002538:	85ca                	mv	a1,s2
    8000253a:	6928                	ld	a0,80(a0)
    8000253c:	90cff0ef          	jal	80001648 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002540:	70a2                	ld	ra,40(sp)
    80002542:	7402                	ld	s0,32(sp)
    80002544:	64e2                	ld	s1,24(sp)
    80002546:	6942                	ld	s2,16(sp)
    80002548:	69a2                	ld	s3,8(sp)
    8000254a:	6a02                	ld	s4,0(sp)
    8000254c:	6145                	addi	sp,sp,48
    8000254e:	8082                	ret
    memmove(dst, (char*)src, len);
    80002550:	000a061b          	sext.w	a2,s4
    80002554:	85ce                	mv	a1,s3
    80002556:	854a                	mv	a0,s2
    80002558:	fdafe0ef          	jal	80000d32 <memmove>
    return 0;
    8000255c:	8526                	mv	a0,s1
    8000255e:	b7cd                	j	80002540 <either_copyin+0x2a>

0000000080002560 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002560:	715d                	addi	sp,sp,-80
    80002562:	e486                	sd	ra,72(sp)
    80002564:	e0a2                	sd	s0,64(sp)
    80002566:	fc26                	sd	s1,56(sp)
    80002568:	f84a                	sd	s2,48(sp)
    8000256a:	f44e                	sd	s3,40(sp)
    8000256c:	f052                	sd	s4,32(sp)
    8000256e:	ec56                	sd	s5,24(sp)
    80002570:	e85a                	sd	s6,16(sp)
    80002572:	e45e                	sd	s7,8(sp)
    80002574:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002576:	00006517          	auipc	a0,0x6
    8000257a:	b0250513          	addi	a0,a0,-1278 # 80008078 <etext+0x78>
    8000257e:	f53fd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002582:	00011497          	auipc	s1,0x11
    80002586:	7ae48493          	addi	s1,s1,1966 # 80013d30 <proc+0x158>
    8000258a:	00017917          	auipc	s2,0x17
    8000258e:	7a690913          	addi	s2,s2,1958 # 80019d30 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002592:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002594:	00006997          	auipc	s3,0x6
    80002598:	d0c98993          	addi	s3,s3,-756 # 800082a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000259c:	00006a97          	auipc	s5,0x6
    800025a0:	d0ca8a93          	addi	s5,s5,-756 # 800082a8 <etext+0x2a8>
    printf("\n");
    800025a4:	00006a17          	auipc	s4,0x6
    800025a8:	ad4a0a13          	addi	s4,s4,-1324 # 80008078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025ac:	00006b97          	auipc	s7,0x6
    800025b0:	29cb8b93          	addi	s7,s7,668 # 80008848 <states.0>
    800025b4:	a829                	j	800025ce <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800025b6:	ed86a583          	lw	a1,-296(a3)
    800025ba:	8556                	mv	a0,s5
    800025bc:	f15fd0ef          	jal	800004d0 <printf>
    printf("\n");
    800025c0:	8552                	mv	a0,s4
    800025c2:	f0ffd0ef          	jal	800004d0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800025c6:	18048493          	addi	s1,s1,384
    800025ca:	03248263          	beq	s1,s2,800025ee <procdump+0x8e>
    if(p->state == UNUSED)
    800025ce:	86a6                	mv	a3,s1
    800025d0:	ec04a783          	lw	a5,-320(s1)
    800025d4:	dbed                	beqz	a5,800025c6 <procdump+0x66>
      state = "???";
    800025d6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800025d8:	fcfb6fe3          	bltu	s6,a5,800025b6 <procdump+0x56>
    800025dc:	02079713          	slli	a4,a5,0x20
    800025e0:	01d75793          	srli	a5,a4,0x1d
    800025e4:	97de                	add	a5,a5,s7
    800025e6:	6390                	ld	a2,0(a5)
    800025e8:	f679                	bnez	a2,800025b6 <procdump+0x56>
      state = "???";
    800025ea:	864e                	mv	a2,s3
    800025ec:	b7e9                	j	800025b6 <procdump+0x56>
  }
}
    800025ee:	60a6                	ld	ra,72(sp)
    800025f0:	6406                	ld	s0,64(sp)
    800025f2:	74e2                	ld	s1,56(sp)
    800025f4:	7942                	ld	s2,48(sp)
    800025f6:	79a2                	ld	s3,40(sp)
    800025f8:	7a02                	ld	s4,32(sp)
    800025fa:	6ae2                	ld	s5,24(sp)
    800025fc:	6b42                	ld	s6,16(sp)
    800025fe:	6ba2                	ld	s7,8(sp)
    80002600:	6161                	addi	sp,sp,80
    80002602:	8082                	ret

0000000080002604 <setpriority>:
//p3
int
setpriority(int pid, int priority)
{
    80002604:	7179                	addi	sp,sp,-48
    80002606:	f406                	sd	ra,40(sp)
    80002608:	f022                	sd	s0,32(sp)
    8000260a:	ec26                	sd	s1,24(sp)
    8000260c:	e84a                	sd	s2,16(sp)
    8000260e:	e44e                	sd	s3,8(sp)
    80002610:	e052                	sd	s4,0(sp)
    80002612:	1800                	addi	s0,sp,48
    80002614:	892a                	mv	s2,a0
    80002616:	8a2e                	mv	s4,a1
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002618:	00011497          	auipc	s1,0x11
    8000261c:	5c048493          	addi	s1,s1,1472 # 80013bd8 <proc>
    80002620:	00017997          	auipc	s3,0x17
    80002624:	5b898993          	addi	s3,s3,1464 # 80019bd8 <tickslock>
    80002628:	a821                	j	80002640 <setpriority+0x3c>
      p->priority = priority;
      release(&p->lock);

      // If we are in Priority Mode, yield to check if we need to switch
      if (sched_mode == SCHED_PRIORITY) {
        yield();
    8000262a:	a7dff0ef          	jal	800020a6 <yield>
      }
      return 0;
    8000262e:	4501                	li	a0,0
    80002630:	a82d                	j	8000266a <setpriority+0x66>
    }
    release(&p->lock);
    80002632:	8526                	mv	a0,s1
    80002634:	e66fe0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002638:	18048493          	addi	s1,s1,384
    8000263c:	03348f63          	beq	s1,s3,8000267a <setpriority+0x76>
    acquire(&p->lock);
    80002640:	8526                	mv	a0,s1
    80002642:	dc0fe0ef          	jal	80000c02 <acquire>
    if(p->pid == pid && p->state != UNUSED){
    80002646:	589c                	lw	a5,48(s1)
    80002648:	ff2795e3          	bne	a5,s2,80002632 <setpriority+0x2e>
    8000264c:	4c9c                	lw	a5,24(s1)
    8000264e:	d3f5                	beqz	a5,80002632 <setpriority+0x2e>
      p->priority = priority;
    80002650:	1744a823          	sw	s4,368(s1)
      release(&p->lock);
    80002654:	8526                	mv	a0,s1
    80002656:	e44fe0ef          	jal	80000c9a <release>
      if (sched_mode == SCHED_PRIORITY) {
    8000265a:	00009717          	auipc	a4,0x9
    8000265e:	fde72703          	lw	a4,-34(a4) # 8000b638 <sched_mode>
    80002662:	4789                	li	a5,2
      return 0;
    80002664:	4501                	li	a0,0
      if (sched_mode == SCHED_PRIORITY) {
    80002666:	fcf702e3          	beq	a4,a5,8000262a <setpriority+0x26>
  }
  return -1;
}
    8000266a:	70a2                	ld	ra,40(sp)
    8000266c:	7402                	ld	s0,32(sp)
    8000266e:	64e2                	ld	s1,24(sp)
    80002670:	6942                	ld	s2,16(sp)
    80002672:	69a2                	ld	s3,8(sp)
    80002674:	6a02                	ld	s4,0(sp)
    80002676:	6145                	addi	sp,sp,48
    80002678:	8082                	ret
  return -1;
    8000267a:	557d                	li	a0,-1
    8000267c:	b7fd                	j	8000266a <setpriority+0x66>

000000008000267e <setscheduler>:

// Sets the scheduling policy.
int
setscheduler(int policy)
{
  if (policy < SCHED_ROUND_ROBIN || policy > SCHED_PRIORITY) {
    8000267e:	4789                	li	a5,2
    80002680:	04a7ec63          	bltu	a5,a0,800026d8 <setscheduler+0x5a>
{
    80002684:	1101                	addi	sp,sp,-32
    80002686:	ec06                	sd	ra,24(sp)
    80002688:	e822                	sd	s0,16(sp)
    8000268a:	e426                	sd	s1,8(sp)
    8000268c:	e04a                	sd	s2,0(sp)
    8000268e:	1000                	addi	s0,sp,32
    80002690:	892a                	mv	s2,a0
    return -1;
  }

  // Reset metrics when policy changes
  acquire(&metrics_lock);
    80002692:	00011497          	auipc	s1,0x11
    80002696:	52e48493          	addi	s1,s1,1326 # 80013bc0 <metrics_lock>
    8000269a:	8526                	mv	a0,s1
    8000269c:	d66fe0ef          	jal	80000c02 <acquire>
  total_turnaround_time = 0;
    800026a0:	00009797          	auipc	a5,0x9
    800026a4:	fa07b823          	sd	zero,-80(a5) # 8000b650 <total_turnaround_time>
  total_waiting_time_sum = 0;
    800026a8:	00009797          	auipc	a5,0x9
    800026ac:	fa07b023          	sd	zero,-96(a5) # 8000b648 <total_waiting_time_sum>
  finished_processes = 0;
    800026b0:	00009797          	auipc	a5,0x9
    800026b4:	f807b823          	sd	zero,-112(a5) # 8000b640 <finished_processes>
  release(&metrics_lock);
    800026b8:	8526                	mv	a0,s1
    800026ba:	de0fe0ef          	jal	80000c9a <release>

  sched_mode = policy;
    800026be:	00009797          	auipc	a5,0x9
    800026c2:	f727ad23          	sw	s2,-134(a5) # 8000b638 <sched_mode>
  yield(); // Trigger a reschedule
    800026c6:	9e1ff0ef          	jal	800020a6 <yield>
  return 0;
    800026ca:	4501                	li	a0,0
}
    800026cc:	60e2                	ld	ra,24(sp)
    800026ce:	6442                	ld	s0,16(sp)
    800026d0:	64a2                	ld	s1,8(sp)
    800026d2:	6902                	ld	s2,0(sp)
    800026d4:	6105                	addi	sp,sp,32
    800026d6:	8082                	ret
    return -1;
    800026d8:	557d                	li	a0,-1
}
    800026da:	8082                	ret

00000000800026dc <populate_metrics>:

// Helper to pass metrics data to the system call
void
populate_metrics(uint64 *turnaround, uint64 *waiting, uint64 *finished)
{
    800026dc:	7179                	addi	sp,sp,-48
    800026de:	f406                	sd	ra,40(sp)
    800026e0:	f022                	sd	s0,32(sp)
    800026e2:	ec26                	sd	s1,24(sp)
    800026e4:	e84a                	sd	s2,16(sp)
    800026e6:	e44e                	sd	s3,8(sp)
    800026e8:	e052                	sd	s4,0(sp)
    800026ea:	1800                	addi	s0,sp,48
    800026ec:	89aa                	mv	s3,a0
    800026ee:	892e                	mv	s2,a1
    800026f0:	84b2                	mv	s1,a2
  acquire(&metrics_lock);
    800026f2:	00011a17          	auipc	s4,0x11
    800026f6:	4cea0a13          	addi	s4,s4,1230 # 80013bc0 <metrics_lock>
    800026fa:	8552                	mv	a0,s4
    800026fc:	d06fe0ef          	jal	80000c02 <acquire>
  *turnaround = total_turnaround_time;
    80002700:	00009797          	auipc	a5,0x9
    80002704:	f507b783          	ld	a5,-176(a5) # 8000b650 <total_turnaround_time>
    80002708:	00f9b023          	sd	a5,0(s3)
  *waiting = total_waiting_time_sum;
    8000270c:	00009797          	auipc	a5,0x9
    80002710:	f3c7b783          	ld	a5,-196(a5) # 8000b648 <total_waiting_time_sum>
    80002714:	00f93023          	sd	a5,0(s2)
  *finished = finished_processes;
    80002718:	00009797          	auipc	a5,0x9
    8000271c:	f287b783          	ld	a5,-216(a5) # 8000b640 <finished_processes>
    80002720:	e09c                	sd	a5,0(s1)
  release(&metrics_lock);
    80002722:	8552                	mv	a0,s4
    80002724:	d76fe0ef          	jal	80000c9a <release>
}
    80002728:	70a2                	ld	ra,40(sp)
    8000272a:	7402                	ld	s0,32(sp)
    8000272c:	64e2                	ld	s1,24(sp)
    8000272e:	6942                	ld	s2,16(sp)
    80002730:	69a2                	ld	s3,8(sp)
    80002732:	6a02                	ld	s4,0(sp)
    80002734:	6145                	addi	sp,sp,48
    80002736:	8082                	ret

0000000080002738 <swtch>:
    80002738:	00153023          	sd	ra,0(a0)
    8000273c:	00253423          	sd	sp,8(a0)
    80002740:	e900                	sd	s0,16(a0)
    80002742:	ed04                	sd	s1,24(a0)
    80002744:	03253023          	sd	s2,32(a0)
    80002748:	03353423          	sd	s3,40(a0)
    8000274c:	03453823          	sd	s4,48(a0)
    80002750:	03553c23          	sd	s5,56(a0)
    80002754:	05653023          	sd	s6,64(a0)
    80002758:	05753423          	sd	s7,72(a0)
    8000275c:	05853823          	sd	s8,80(a0)
    80002760:	05953c23          	sd	s9,88(a0)
    80002764:	07a53023          	sd	s10,96(a0)
    80002768:	07b53423          	sd	s11,104(a0)
    8000276c:	0005b083          	ld	ra,0(a1)
    80002770:	0085b103          	ld	sp,8(a1)
    80002774:	6980                	ld	s0,16(a1)
    80002776:	6d84                	ld	s1,24(a1)
    80002778:	0205b903          	ld	s2,32(a1)
    8000277c:	0285b983          	ld	s3,40(a1)
    80002780:	0305ba03          	ld	s4,48(a1)
    80002784:	0385ba83          	ld	s5,56(a1)
    80002788:	0405bb03          	ld	s6,64(a1)
    8000278c:	0485bb83          	ld	s7,72(a1)
    80002790:	0505bc03          	ld	s8,80(a1)
    80002794:	0585bc83          	ld	s9,88(a1)
    80002798:	0605bd03          	ld	s10,96(a1)
    8000279c:	0685bd83          	ld	s11,104(a1)
    800027a0:	8082                	ret

00000000800027a2 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800027a2:	1141                	addi	sp,sp,-16
    800027a4:	e406                	sd	ra,8(sp)
    800027a6:	e022                	sd	s0,0(sp)
    800027a8:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800027aa:	00006597          	auipc	a1,0x6
    800027ae:	b3e58593          	addi	a1,a1,-1218 # 800082e8 <etext+0x2e8>
    800027b2:	00017517          	auipc	a0,0x17
    800027b6:	42650513          	addi	a0,a0,1062 # 80019bd8 <tickslock>
    800027ba:	bc8fe0ef          	jal	80000b82 <initlock>
}
    800027be:	60a2                	ld	ra,8(sp)
    800027c0:	6402                	ld	s0,0(sp)
    800027c2:	0141                	addi	sp,sp,16
    800027c4:	8082                	ret

00000000800027c6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800027c6:	1141                	addi	sp,sp,-16
    800027c8:	e422                	sd	s0,8(sp)
    800027ca:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027cc:	00003797          	auipc	a5,0x3
    800027d0:	06478793          	addi	a5,a5,100 # 80005830 <kernelvec>
    800027d4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800027d8:	6422                	ld	s0,8(sp)
    800027da:	0141                	addi	sp,sp,16
    800027dc:	8082                	ret

00000000800027de <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800027de:	1141                	addi	sp,sp,-16
    800027e0:	e406                	sd	ra,8(sp)
    800027e2:	e022                	sd	s0,0(sp)
    800027e4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027e6:	91aff0ef          	jal	80001900 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027ea:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027ee:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027f0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027f4:	00005697          	auipc	a3,0x5
    800027f8:	80c68693          	addi	a3,a3,-2036 # 80007000 <_trampoline>
    800027fc:	00005717          	auipc	a4,0x5
    80002800:	80470713          	addi	a4,a4,-2044 # 80007000 <_trampoline>
    80002804:	8f15                	sub	a4,a4,a3
    80002806:	040007b7          	lui	a5,0x4000
    8000280a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    8000280c:	07b2                	slli	a5,a5,0xc
    8000280e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002810:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002814:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002816:	18002673          	csrr	a2,satp
    8000281a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000281c:	6d30                	ld	a2,88(a0)
    8000281e:	6138                	ld	a4,64(a0)
    80002820:	6585                	lui	a1,0x1
    80002822:	972e                	add	a4,a4,a1
    80002824:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002826:	6d38                	ld	a4,88(a0)
    80002828:	00000617          	auipc	a2,0x0
    8000282c:	11a60613          	addi	a2,a2,282 # 80002942 <usertrap>
    80002830:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002832:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002834:	8612                	mv	a2,tp
    80002836:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002838:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000283c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002840:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002844:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002848:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000284a:	6f18                	ld	a4,24(a4)
    8000284c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002850:	6928                	ld	a0,80(a0)
    80002852:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002854:	00005717          	auipc	a4,0x5
    80002858:	84870713          	addi	a4,a4,-1976 # 8000709c <userret>
    8000285c:	8f15                	sub	a4,a4,a3
    8000285e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002860:	577d                	li	a4,-1
    80002862:	177e                	slli	a4,a4,0x3f
    80002864:	8d59                	or	a0,a0,a4
    80002866:	9782                	jalr	a5
}
    80002868:	60a2                	ld	ra,8(sp)
    8000286a:	6402                	ld	s0,0(sp)
    8000286c:	0141                	addi	sp,sp,16
    8000286e:	8082                	ret

0000000080002870 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002870:	1101                	addi	sp,sp,-32
    80002872:	ec06                	sd	ra,24(sp)
    80002874:	e822                	sd	s0,16(sp)
    80002876:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002878:	85cff0ef          	jal	800018d4 <cpuid>
    8000287c:	cd11                	beqz	a0,80002898 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000287e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002882:	000f4737          	lui	a4,0xf4
    80002886:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000288a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000288c:	14d79073          	csrw	stimecmp,a5
}
    80002890:	60e2                	ld	ra,24(sp)
    80002892:	6442                	ld	s0,16(sp)
    80002894:	6105                	addi	sp,sp,32
    80002896:	8082                	ret
    80002898:	e426                	sd	s1,8(sp)
    8000289a:	e04a                	sd	s2,0(sp)
    acquire(&tickslock);
    8000289c:	00017917          	auipc	s2,0x17
    800028a0:	33c90913          	addi	s2,s2,828 # 80019bd8 <tickslock>
    800028a4:	854a                	mv	a0,s2
    800028a6:	b5cfe0ef          	jal	80000c02 <acquire>
    ticks++;
    800028aa:	00009497          	auipc	s1,0x9
    800028ae:	db648493          	addi	s1,s1,-586 # 8000b660 <ticks>
    800028b2:	409c                	lw	a5,0(s1)
    800028b4:	2785                	addiw	a5,a5,1
    800028b6:	c09c                	sw	a5,0(s1)
    update_time();
    800028b8:	cc2ff0ef          	jal	80001d7a <update_time>
    wakeup(&ticks);
    800028bc:	8526                	mv	a0,s1
    800028be:	883ff0ef          	jal	80002140 <wakeup>
    release(&tickslock);
    800028c2:	854a                	mv	a0,s2
    800028c4:	bd6fe0ef          	jal	80000c9a <release>
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6902                	ld	s2,0(sp)
    800028cc:	bf4d                	j	8000287e <clockintr+0xe>

00000000800028ce <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800028ce:	1101                	addi	sp,sp,-32
    800028d0:	ec06                	sd	ra,24(sp)
    800028d2:	e822                	sd	s0,16(sp)
    800028d4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028d6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800028da:	57fd                	li	a5,-1
    800028dc:	17fe                	slli	a5,a5,0x3f
    800028de:	07a5                	addi	a5,a5,9
    800028e0:	00f70c63          	beq	a4,a5,800028f8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800028e4:	57fd                	li	a5,-1
    800028e6:	17fe                	slli	a5,a5,0x3f
    800028e8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800028ea:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028ec:	04f70763          	beq	a4,a5,8000293a <devintr+0x6c>
  }
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	6105                	addi	sp,sp,32
    800028f6:	8082                	ret
    800028f8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800028fa:	7e3020ef          	jal	800058dc <plic_claim>
    800028fe:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002900:	47a9                	li	a5,10
    80002902:	00f50963          	beq	a0,a5,80002914 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002906:	4785                	li	a5,1
    80002908:	00f50963          	beq	a0,a5,8000291a <devintr+0x4c>
    return 1;
    8000290c:	4505                	li	a0,1
    } else if(irq){
    8000290e:	e889                	bnez	s1,80002920 <devintr+0x52>
    80002910:	64a2                	ld	s1,8(sp)
    80002912:	bff9                	j	800028f0 <devintr+0x22>
      uartintr();
    80002914:	900fe0ef          	jal	80000a14 <uartintr>
    if(irq)
    80002918:	a819                	j	8000292e <devintr+0x60>
      virtio_disk_intr();
    8000291a:	488030ef          	jal	80005da2 <virtio_disk_intr>
    if(irq)
    8000291e:	a801                	j	8000292e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002920:	85a6                	mv	a1,s1
    80002922:	00006517          	auipc	a0,0x6
    80002926:	9ce50513          	addi	a0,a0,-1586 # 800082f0 <etext+0x2f0>
    8000292a:	ba7fd0ef          	jal	800004d0 <printf>
      plic_complete(irq);
    8000292e:	8526                	mv	a0,s1
    80002930:	7cd020ef          	jal	800058fc <plic_complete>
    return 1;
    80002934:	4505                	li	a0,1
    80002936:	64a2                	ld	s1,8(sp)
    80002938:	bf65                	j	800028f0 <devintr+0x22>
    clockintr();
    8000293a:	f37ff0ef          	jal	80002870 <clockintr>
    return 2;
    8000293e:	4509                	li	a0,2
    80002940:	bf45                	j	800028f0 <devintr+0x22>

0000000080002942 <usertrap>:
{
    80002942:	1101                	addi	sp,sp,-32
    80002944:	ec06                	sd	ra,24(sp)
    80002946:	e822                	sd	s0,16(sp)
    80002948:	e426                	sd	s1,8(sp)
    8000294a:	e04a                	sd	s2,0(sp)
    8000294c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000294e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002952:	1007f793          	andi	a5,a5,256
    80002956:	ef85                	bnez	a5,8000298e <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002958:	00003797          	auipc	a5,0x3
    8000295c:	ed878793          	addi	a5,a5,-296 # 80005830 <kernelvec>
    80002960:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002964:	f9dfe0ef          	jal	80001900 <myproc>
    80002968:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000296a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000296c:	14102773          	csrr	a4,sepc
    80002970:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002972:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002976:	47a1                	li	a5,8
    80002978:	02f70163          	beq	a4,a5,8000299a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    8000297c:	f53ff0ef          	jal	800028ce <devintr>
    80002980:	892a                	mv	s2,a0
    80002982:	c135                	beqz	a0,800029e6 <usertrap+0xa4>
  if(killed(p))
    80002984:	8526                	mv	a0,s1
    80002986:	a23ff0ef          	jal	800023a8 <killed>
    8000298a:	cd1d                	beqz	a0,800029c8 <usertrap+0x86>
    8000298c:	a81d                	j	800029c2 <usertrap+0x80>
    panic("usertrap: not from user mode");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	98250513          	addi	a0,a0,-1662 # 80008310 <etext+0x310>
    80002996:	e0dfd0ef          	jal	800007a2 <panic>
    if(killed(p))
    8000299a:	a0fff0ef          	jal	800023a8 <killed>
    8000299e:	e121                	bnez	a0,800029de <usertrap+0x9c>
    p->trapframe->epc += 4;
    800029a0:	6cb8                	ld	a4,88(s1)
    800029a2:	6f1c                	ld	a5,24(a4)
    800029a4:	0791                	addi	a5,a5,4
    800029a6:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029ac:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029b0:	10079073          	csrw	sstatus,a5
    syscall();
    800029b4:	248000ef          	jal	80002bfc <syscall>
  if(killed(p))
    800029b8:	8526                	mv	a0,s1
    800029ba:	9efff0ef          	jal	800023a8 <killed>
    800029be:	c901                	beqz	a0,800029ce <usertrap+0x8c>
    800029c0:	4901                	li	s2,0
    exit(-1);
    800029c2:	557d                	li	a0,-1
    800029c4:	851ff0ef          	jal	80002214 <exit>
  if(which_dev == 2)
    800029c8:	4789                	li	a5,2
    800029ca:	04f90563          	beq	s2,a5,80002a14 <usertrap+0xd2>
  usertrapret();
    800029ce:	e11ff0ef          	jal	800027de <usertrapret>
}
    800029d2:	60e2                	ld	ra,24(sp)
    800029d4:	6442                	ld	s0,16(sp)
    800029d6:	64a2                	ld	s1,8(sp)
    800029d8:	6902                	ld	s2,0(sp)
    800029da:	6105                	addi	sp,sp,32
    800029dc:	8082                	ret
      exit(-1);
    800029de:	557d                	li	a0,-1
    800029e0:	835ff0ef          	jal	80002214 <exit>
    800029e4:	bf75                	j	800029a0 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029e6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800029ea:	5890                	lw	a2,48(s1)
    800029ec:	00006517          	auipc	a0,0x6
    800029f0:	94450513          	addi	a0,a0,-1724 # 80008330 <etext+0x330>
    800029f4:	addfd0ef          	jal	800004d0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029f8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029fc:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	96050513          	addi	a0,a0,-1696 # 80008360 <etext+0x360>
    80002a08:	ac9fd0ef          	jal	800004d0 <printf>
    setkilled(p);
    80002a0c:	8526                	mv	a0,s1
    80002a0e:	977ff0ef          	jal	80002384 <setkilled>
    80002a12:	b75d                	j	800029b8 <usertrap+0x76>
    yield();
    80002a14:	e92ff0ef          	jal	800020a6 <yield>
    80002a18:	bf5d                	j	800029ce <usertrap+0x8c>

0000000080002a1a <kerneltrap>:
{
    80002a1a:	7179                	addi	sp,sp,-48
    80002a1c:	f406                	sd	ra,40(sp)
    80002a1e:	f022                	sd	s0,32(sp)
    80002a20:	ec26                	sd	s1,24(sp)
    80002a22:	e84a                	sd	s2,16(sp)
    80002a24:	e44e                	sd	s3,8(sp)
    80002a26:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a28:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a2c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a30:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002a34:	1004f793          	andi	a5,s1,256
    80002a38:	c795                	beqz	a5,80002a64 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002a3a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002a3e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80002a40:	eb85                	bnez	a5,80002a70 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80002a42:	e8dff0ef          	jal	800028ce <devintr>
    80002a46:	c91d                	beqz	a0,80002a7c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002a48:	4789                	li	a5,2
    80002a4a:	04f50a63          	beq	a0,a5,80002a9e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a4e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a52:	10049073          	csrw	sstatus,s1
}
    80002a56:	70a2                	ld	ra,40(sp)
    80002a58:	7402                	ld	s0,32(sp)
    80002a5a:	64e2                	ld	s1,24(sp)
    80002a5c:	6942                	ld	s2,16(sp)
    80002a5e:	69a2                	ld	s3,8(sp)
    80002a60:	6145                	addi	sp,sp,48
    80002a62:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a64:	00006517          	auipc	a0,0x6
    80002a68:	92450513          	addi	a0,a0,-1756 # 80008388 <etext+0x388>
    80002a6c:	d37fd0ef          	jal	800007a2 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a70:	00006517          	auipc	a0,0x6
    80002a74:	94050513          	addi	a0,a0,-1728 # 800083b0 <etext+0x3b0>
    80002a78:	d2bfd0ef          	jal	800007a2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a7c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a80:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002a84:	85ce                	mv	a1,s3
    80002a86:	00006517          	auipc	a0,0x6
    80002a8a:	94a50513          	addi	a0,a0,-1718 # 800083d0 <etext+0x3d0>
    80002a8e:	a43fd0ef          	jal	800004d0 <printf>
    panic("kerneltrap");
    80002a92:	00006517          	auipc	a0,0x6
    80002a96:	96650513          	addi	a0,a0,-1690 # 800083f8 <etext+0x3f8>
    80002a9a:	d09fd0ef          	jal	800007a2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002a9e:	e63fe0ef          	jal	80001900 <myproc>
    80002aa2:	d555                	beqz	a0,80002a4e <kerneltrap+0x34>
    yield();
    80002aa4:	e02ff0ef          	jal	800020a6 <yield>
    80002aa8:	b75d                	j	80002a4e <kerneltrap+0x34>

0000000080002aaa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002aaa:	1101                	addi	sp,sp,-32
    80002aac:	ec06                	sd	ra,24(sp)
    80002aae:	e822                	sd	s0,16(sp)
    80002ab0:	e426                	sd	s1,8(sp)
    80002ab2:	1000                	addi	s0,sp,32
    80002ab4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002ab6:	e4bfe0ef          	jal	80001900 <myproc>
  switch (n) {
    80002aba:	4795                	li	a5,5
    80002abc:	0497e163          	bltu	a5,s1,80002afe <argraw+0x54>
    80002ac0:	048a                	slli	s1,s1,0x2
    80002ac2:	00006717          	auipc	a4,0x6
    80002ac6:	db670713          	addi	a4,a4,-586 # 80008878 <states.0+0x30>
    80002aca:	94ba                	add	s1,s1,a4
    80002acc:	409c                	lw	a5,0(s1)
    80002ace:	97ba                	add	a5,a5,a4
    80002ad0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002ad2:	6d3c                	ld	a5,88(a0)
    80002ad4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	64a2                	ld	s1,8(sp)
    80002adc:	6105                	addi	sp,sp,32
    80002ade:	8082                	ret
    return p->trapframe->a1;
    80002ae0:	6d3c                	ld	a5,88(a0)
    80002ae2:	7fa8                	ld	a0,120(a5)
    80002ae4:	bfcd                	j	80002ad6 <argraw+0x2c>
    return p->trapframe->a2;
    80002ae6:	6d3c                	ld	a5,88(a0)
    80002ae8:	63c8                	ld	a0,128(a5)
    80002aea:	b7f5                	j	80002ad6 <argraw+0x2c>
    return p->trapframe->a3;
    80002aec:	6d3c                	ld	a5,88(a0)
    80002aee:	67c8                	ld	a0,136(a5)
    80002af0:	b7dd                	j	80002ad6 <argraw+0x2c>
    return p->trapframe->a4;
    80002af2:	6d3c                	ld	a5,88(a0)
    80002af4:	6bc8                	ld	a0,144(a5)
    80002af6:	b7c5                	j	80002ad6 <argraw+0x2c>
    return p->trapframe->a5;
    80002af8:	6d3c                	ld	a5,88(a0)
    80002afa:	6fc8                	ld	a0,152(a5)
    80002afc:	bfe9                	j	80002ad6 <argraw+0x2c>
  panic("argraw");
    80002afe:	00006517          	auipc	a0,0x6
    80002b02:	90a50513          	addi	a0,a0,-1782 # 80008408 <etext+0x408>
    80002b06:	c9dfd0ef          	jal	800007a2 <panic>

0000000080002b0a <fetchaddr>:
{
    80002b0a:	1101                	addi	sp,sp,-32
    80002b0c:	ec06                	sd	ra,24(sp)
    80002b0e:	e822                	sd	s0,16(sp)
    80002b10:	e426                	sd	s1,8(sp)
    80002b12:	e04a                	sd	s2,0(sp)
    80002b14:	1000                	addi	s0,sp,32
    80002b16:	84aa                	mv	s1,a0
    80002b18:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002b1a:	de7fe0ef          	jal	80001900 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002b1e:	653c                	ld	a5,72(a0)
    80002b20:	02f4f663          	bgeu	s1,a5,80002b4c <fetchaddr+0x42>
    80002b24:	00848713          	addi	a4,s1,8
    80002b28:	02e7e463          	bltu	a5,a4,80002b50 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002b2c:	46a1                	li	a3,8
    80002b2e:	8626                	mv	a2,s1
    80002b30:	85ca                	mv	a1,s2
    80002b32:	6928                	ld	a0,80(a0)
    80002b34:	b15fe0ef          	jal	80001648 <copyin>
    80002b38:	00a03533          	snez	a0,a0
    80002b3c:	40a00533          	neg	a0,a0
}
    80002b40:	60e2                	ld	ra,24(sp)
    80002b42:	6442                	ld	s0,16(sp)
    80002b44:	64a2                	ld	s1,8(sp)
    80002b46:	6902                	ld	s2,0(sp)
    80002b48:	6105                	addi	sp,sp,32
    80002b4a:	8082                	ret
    return -1;
    80002b4c:	557d                	li	a0,-1
    80002b4e:	bfcd                	j	80002b40 <fetchaddr+0x36>
    80002b50:	557d                	li	a0,-1
    80002b52:	b7fd                	j	80002b40 <fetchaddr+0x36>

0000000080002b54 <fetchstr>:
{
    80002b54:	7179                	addi	sp,sp,-48
    80002b56:	f406                	sd	ra,40(sp)
    80002b58:	f022                	sd	s0,32(sp)
    80002b5a:	ec26                	sd	s1,24(sp)
    80002b5c:	e84a                	sd	s2,16(sp)
    80002b5e:	e44e                	sd	s3,8(sp)
    80002b60:	1800                	addi	s0,sp,48
    80002b62:	892a                	mv	s2,a0
    80002b64:	84ae                	mv	s1,a1
    80002b66:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b68:	d99fe0ef          	jal	80001900 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002b6c:	86ce                	mv	a3,s3
    80002b6e:	864a                	mv	a2,s2
    80002b70:	85a6                	mv	a1,s1
    80002b72:	6928                	ld	a0,80(a0)
    80002b74:	b5bfe0ef          	jal	800016ce <copyinstr>
    80002b78:	00054c63          	bltz	a0,80002b90 <fetchstr+0x3c>
  return strlen(buf);
    80002b7c:	8526                	mv	a0,s1
    80002b7e:	ac8fe0ef          	jal	80000e46 <strlen>
}
    80002b82:	70a2                	ld	ra,40(sp)
    80002b84:	7402                	ld	s0,32(sp)
    80002b86:	64e2                	ld	s1,24(sp)
    80002b88:	6942                	ld	s2,16(sp)
    80002b8a:	69a2                	ld	s3,8(sp)
    80002b8c:	6145                	addi	sp,sp,48
    80002b8e:	8082                	ret
    return -1;
    80002b90:	557d                	li	a0,-1
    80002b92:	bfc5                	j	80002b82 <fetchstr+0x2e>

0000000080002b94 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b94:	1101                	addi	sp,sp,-32
    80002b96:	ec06                	sd	ra,24(sp)
    80002b98:	e822                	sd	s0,16(sp)
    80002b9a:	e426                	sd	s1,8(sp)
    80002b9c:	1000                	addi	s0,sp,32
    80002b9e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ba0:	f0bff0ef          	jal	80002aaa <argraw>
    80002ba4:	c088                	sw	a0,0(s1)
}
    80002ba6:	60e2                	ld	ra,24(sp)
    80002ba8:	6442                	ld	s0,16(sp)
    80002baa:	64a2                	ld	s1,8(sp)
    80002bac:	6105                	addi	sp,sp,32
    80002bae:	8082                	ret

0000000080002bb0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002bb0:	1101                	addi	sp,sp,-32
    80002bb2:	ec06                	sd	ra,24(sp)
    80002bb4:	e822                	sd	s0,16(sp)
    80002bb6:	e426                	sd	s1,8(sp)
    80002bb8:	1000                	addi	s0,sp,32
    80002bba:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002bbc:	eefff0ef          	jal	80002aaa <argraw>
    80002bc0:	e088                	sd	a0,0(s1)
}
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6105                	addi	sp,sp,32
    80002bca:	8082                	ret

0000000080002bcc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002bcc:	7179                	addi	sp,sp,-48
    80002bce:	f406                	sd	ra,40(sp)
    80002bd0:	f022                	sd	s0,32(sp)
    80002bd2:	ec26                	sd	s1,24(sp)
    80002bd4:	e84a                	sd	s2,16(sp)
    80002bd6:	1800                	addi	s0,sp,48
    80002bd8:	84ae                	mv	s1,a1
    80002bda:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002bdc:	fd840593          	addi	a1,s0,-40
    80002be0:	fd1ff0ef          	jal	80002bb0 <argaddr>
  return fetchstr(addr, buf, max);
    80002be4:	864a                	mv	a2,s2
    80002be6:	85a6                	mv	a1,s1
    80002be8:	fd843503          	ld	a0,-40(s0)
    80002bec:	f69ff0ef          	jal	80002b54 <fetchstr>
}
    80002bf0:	70a2                	ld	ra,40(sp)
    80002bf2:	7402                	ld	s0,32(sp)
    80002bf4:	64e2                	ld	s1,24(sp)
    80002bf6:	6942                	ld	s2,16(sp)
    80002bf8:	6145                	addi	sp,sp,48
    80002bfa:	8082                	ret

0000000080002bfc <syscall>:
[SYS_getmetrics]   sys_getmetrics,
};

void
syscall(void)
{
    80002bfc:	1101                	addi	sp,sp,-32
    80002bfe:	ec06                	sd	ra,24(sp)
    80002c00:	e822                	sd	s0,16(sp)
    80002c02:	e426                	sd	s1,8(sp)
    80002c04:	e04a                	sd	s2,0(sp)
    80002c06:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002c08:	cf9fe0ef          	jal	80001900 <myproc>
    80002c0c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002c0e:	05853903          	ld	s2,88(a0)
    80002c12:	0a893783          	ld	a5,168(s2)
    80002c16:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002c1a:	37fd                	addiw	a5,a5,-1
    80002c1c:	4779                	li	a4,30
    80002c1e:	02f76663          	bltu	a4,a5,80002c4a <syscall+0x4e>
    80002c22:	00369713          	slli	a4,a3,0x3
    80002c26:	00006797          	auipc	a5,0x6
    80002c2a:	c6a78793          	addi	a5,a5,-918 # 80008890 <syscalls>
    80002c2e:	97ba                	add	a5,a5,a4
    80002c30:	6398                	ld	a4,0(a5)
    80002c32:	cf01                	beqz	a4,80002c4a <syscall+0x4e>
    total_syscalls++;
    80002c34:	00009697          	auipc	a3,0x9
    80002c38:	a3068693          	addi	a3,a3,-1488 # 8000b664 <total_syscalls>
    80002c3c:	429c                	lw	a5,0(a3)
    80002c3e:	2785                	addiw	a5,a5,1
    80002c40:	c29c                	sw	a5,0(a3)
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c42:	9702                	jalr	a4
    80002c44:	06a93823          	sd	a0,112(s2)
    80002c48:	a829                	j	80002c62 <syscall+0x66>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c4a:	15848613          	addi	a2,s1,344
    80002c4e:	588c                	lw	a1,48(s1)
    80002c50:	00005517          	auipc	a0,0x5
    80002c54:	7c050513          	addi	a0,a0,1984 # 80008410 <etext+0x410>
    80002c58:	879fd0ef          	jal	800004d0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c5c:	6cbc                	ld	a5,88(s1)
    80002c5e:	577d                	li	a4,-1
    80002c60:	fbb8                	sd	a4,112(a5)
  }
}
    80002c62:	60e2                	ld	ra,24(sp)
    80002c64:	6442                	ld	s0,16(sp)
    80002c66:	64a2                	ld	s1,8(sp)
    80002c68:	6902                	ld	s2,0(sp)
    80002c6a:	6105                	addi	sp,sp,32
    80002c6c:	8082                	ret

0000000080002c6e <sys_exit>:
extern void populate_metrics(uint64 *turnaround, uint64 *waiting, uint64 *finished);

extern struct proc proc[NPROC];
uint64
sys_exit(void)
{
    80002c6e:	1101                	addi	sp,sp,-32
    80002c70:	ec06                	sd	ra,24(sp)
    80002c72:	e822                	sd	s0,16(sp)
    80002c74:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c76:	fec40593          	addi	a1,s0,-20
    80002c7a:	4501                	li	a0,0
    80002c7c:	f19ff0ef          	jal	80002b94 <argint>
  exit(n);
    80002c80:	fec42503          	lw	a0,-20(s0)
    80002c84:	d90ff0ef          	jal	80002214 <exit>
  return 0;  // not reached
}
    80002c88:	4501                	li	a0,0
    80002c8a:	60e2                	ld	ra,24(sp)
    80002c8c:	6442                	ld	s0,16(sp)
    80002c8e:	6105                	addi	sp,sp,32
    80002c90:	8082                	ret

0000000080002c92 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c92:	1141                	addi	sp,sp,-16
    80002c94:	e406                	sd	ra,8(sp)
    80002c96:	e022                	sd	s0,0(sp)
    80002c98:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c9a:	c67fe0ef          	jal	80001900 <myproc>
}
    80002c9e:	5908                	lw	a0,48(a0)
    80002ca0:	60a2                	ld	ra,8(sp)
    80002ca2:	6402                	ld	s0,0(sp)
    80002ca4:	0141                	addi	sp,sp,16
    80002ca6:	8082                	ret

0000000080002ca8 <sys_fork>:

uint64
sys_fork(void)
{
    80002ca8:	1141                	addi	sp,sp,-16
    80002caa:	e406                	sd	ra,8(sp)
    80002cac:	e022                	sd	s0,0(sp)
    80002cae:	0800                	addi	s0,sp,16
  return fork();
    80002cb0:	fb1fe0ef          	jal	80001c60 <fork>
}
    80002cb4:	60a2                	ld	ra,8(sp)
    80002cb6:	6402                	ld	s0,0(sp)
    80002cb8:	0141                	addi	sp,sp,16
    80002cba:	8082                	ret

0000000080002cbc <sys_wait>:

uint64
sys_wait(void)
{
    80002cbc:	1101                	addi	sp,sp,-32
    80002cbe:	ec06                	sd	ra,24(sp)
    80002cc0:	e822                	sd	s0,16(sp)
    80002cc2:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002cc4:	fe840593          	addi	a1,s0,-24
    80002cc8:	4501                	li	a0,0
    80002cca:	ee7ff0ef          	jal	80002bb0 <argaddr>
  return wait(p);
    80002cce:	fe843503          	ld	a0,-24(s0)
    80002cd2:	f00ff0ef          	jal	800023d2 <wait>
}
    80002cd6:	60e2                	ld	ra,24(sp)
    80002cd8:	6442                	ld	s0,16(sp)
    80002cda:	6105                	addi	sp,sp,32
    80002cdc:	8082                	ret

0000000080002cde <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002cde:	7179                	addi	sp,sp,-48
    80002ce0:	f406                	sd	ra,40(sp)
    80002ce2:	f022                	sd	s0,32(sp)
    80002ce4:	ec26                	sd	s1,24(sp)
    80002ce6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002ce8:	fdc40593          	addi	a1,s0,-36
    80002cec:	4501                	li	a0,0
    80002cee:	ea7ff0ef          	jal	80002b94 <argint>
  addr = myproc()->sz;
    80002cf2:	c0ffe0ef          	jal	80001900 <myproc>
    80002cf6:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002cf8:	fdc42503          	lw	a0,-36(s0)
    80002cfc:	f15fe0ef          	jal	80001c10 <growproc>
    80002d00:	00054863          	bltz	a0,80002d10 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002d04:	8526                	mv	a0,s1
    80002d06:	70a2                	ld	ra,40(sp)
    80002d08:	7402                	ld	s0,32(sp)
    80002d0a:	64e2                	ld	s1,24(sp)
    80002d0c:	6145                	addi	sp,sp,48
    80002d0e:	8082                	ret
    return -1;
    80002d10:	54fd                	li	s1,-1
    80002d12:	bfcd                	j	80002d04 <sys_sbrk+0x26>

0000000080002d14 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002d14:	7139                	addi	sp,sp,-64
    80002d16:	fc06                	sd	ra,56(sp)
    80002d18:	f822                	sd	s0,48(sp)
    80002d1a:	f04a                	sd	s2,32(sp)
    80002d1c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002d1e:	fcc40593          	addi	a1,s0,-52
    80002d22:	4501                	li	a0,0
    80002d24:	e71ff0ef          	jal	80002b94 <argint>
  if(n < 0)
    80002d28:	fcc42783          	lw	a5,-52(s0)
    80002d2c:	0607c763          	bltz	a5,80002d9a <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002d30:	00017517          	auipc	a0,0x17
    80002d34:	ea850513          	addi	a0,a0,-344 # 80019bd8 <tickslock>
    80002d38:	ecbfd0ef          	jal	80000c02 <acquire>
  ticks0 = ticks;
    80002d3c:	00009917          	auipc	s2,0x9
    80002d40:	92492903          	lw	s2,-1756(s2) # 8000b660 <ticks>
  while(ticks - ticks0 < n){
    80002d44:	fcc42783          	lw	a5,-52(s0)
    80002d48:	cf8d                	beqz	a5,80002d82 <sys_sleep+0x6e>
    80002d4a:	f426                	sd	s1,40(sp)
    80002d4c:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d4e:	00017997          	auipc	s3,0x17
    80002d52:	e8a98993          	addi	s3,s3,-374 # 80019bd8 <tickslock>
    80002d56:	00009497          	auipc	s1,0x9
    80002d5a:	90a48493          	addi	s1,s1,-1782 # 8000b660 <ticks>
    if(killed(myproc())){
    80002d5e:	ba3fe0ef          	jal	80001900 <myproc>
    80002d62:	e46ff0ef          	jal	800023a8 <killed>
    80002d66:	ed0d                	bnez	a0,80002da0 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002d68:	85ce                	mv	a1,s3
    80002d6a:	8526                	mv	a0,s1
    80002d6c:	b88ff0ef          	jal	800020f4 <sleep>
  while(ticks - ticks0 < n){
    80002d70:	409c                	lw	a5,0(s1)
    80002d72:	412787bb          	subw	a5,a5,s2
    80002d76:	fcc42703          	lw	a4,-52(s0)
    80002d7a:	fee7e2e3          	bltu	a5,a4,80002d5e <sys_sleep+0x4a>
    80002d7e:	74a2                	ld	s1,40(sp)
    80002d80:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d82:	00017517          	auipc	a0,0x17
    80002d86:	e5650513          	addi	a0,a0,-426 # 80019bd8 <tickslock>
    80002d8a:	f11fd0ef          	jal	80000c9a <release>
  return 0;
    80002d8e:	4501                	li	a0,0
}
    80002d90:	70e2                	ld	ra,56(sp)
    80002d92:	7442                	ld	s0,48(sp)
    80002d94:	7902                	ld	s2,32(sp)
    80002d96:	6121                	addi	sp,sp,64
    80002d98:	8082                	ret
    n = 0;
    80002d9a:	fc042623          	sw	zero,-52(s0)
    80002d9e:	bf49                	j	80002d30 <sys_sleep+0x1c>
      release(&tickslock);
    80002da0:	00017517          	auipc	a0,0x17
    80002da4:	e3850513          	addi	a0,a0,-456 # 80019bd8 <tickslock>
    80002da8:	ef3fd0ef          	jal	80000c9a <release>
      return -1;
    80002dac:	557d                	li	a0,-1
    80002dae:	74a2                	ld	s1,40(sp)
    80002db0:	69e2                	ld	s3,24(sp)
    80002db2:	bff9                	j	80002d90 <sys_sleep+0x7c>

0000000080002db4 <sys_kill>:

uint64
sys_kill(void)
{
    80002db4:	1101                	addi	sp,sp,-32
    80002db6:	ec06                	sd	ra,24(sp)
    80002db8:	e822                	sd	s0,16(sp)
    80002dba:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002dbc:	fec40593          	addi	a1,s0,-20
    80002dc0:	4501                	li	a0,0
    80002dc2:	dd3ff0ef          	jal	80002b94 <argint>
  return kill(pid);
    80002dc6:	fec42503          	lw	a0,-20(s0)
    80002dca:	d48ff0ef          	jal	80002312 <kill>
}
    80002dce:	60e2                	ld	ra,24(sp)
    80002dd0:	6442                	ld	s0,16(sp)
    80002dd2:	6105                	addi	sp,sp,32
    80002dd4:	8082                	ret

0000000080002dd6 <sys_getppid>:


int
sys_getppid(void)
{
    80002dd6:	1141                	addi	sp,sp,-16
    80002dd8:	e406                	sd	ra,8(sp)
    80002dda:	e022                	sd	s0,0(sp)
    80002ddc:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002dde:	b23fe0ef          	jal	80001900 <myproc>
    if(p->parent)
    80002de2:	7d1c                	ld	a5,56(a0)
        return p->parent->pid;
    return 0;
    80002de4:	4501                	li	a0,0
    if(p->parent)
    80002de6:	c391                	beqz	a5,80002dea <sys_getppid+0x14>
        return p->parent->pid;
    80002de8:	5b88                	lw	a0,48(a5)
}
    80002dea:	60a2                	ld	ra,8(sp)
    80002dec:	6402                	ld	s0,0(sp)
    80002dee:	0141                	addi	sp,sp,16
    80002df0:	8082                	ret

0000000080002df2 <sys_getptable>:

uint64
sys_getptable(void)
{
    80002df2:	7119                	addi	sp,sp,-128
    80002df4:	fc86                	sd	ra,120(sp)
    80002df6:	f8a2                	sd	s0,112(sp)
    80002df8:	0100                	addi	s0,sp,128
    uint64 user_buf;   // pointer passed by user
    int n;

    // get arguments: (int nproc, struct procinfo *buf)
    argint(0, &n);
    80002dfa:	fb440593          	addi	a1,s0,-76
    80002dfe:	4501                	li	a0,0
    80002e00:	d95ff0ef          	jal	80002b94 <argint>
    argaddr(1, &user_buf);
    80002e04:	fb840593          	addi	a1,s0,-72
    80002e08:	4505                	li	a0,1
    80002e0a:	da7ff0ef          	jal	80002bb0 <argaddr>

    if (n < 1 || user_buf == 0)
    80002e0e:	fb442783          	lw	a5,-76(s0)
        return 0;
    80002e12:	4501                	li	a0,0
    if (n < 1 || user_buf == 0)
    80002e14:	00f05563          	blez	a5,80002e1e <sys_getptable+0x2c>
    80002e18:	fb843503          	ld	a0,-72(s0)
    80002e1c:	e509                	bnez	a0,80002e26 <sys_getptable+0x34>
        }
        release(&p->lock);
    }

    return count; // number of processes copied
}
    80002e1e:	70e6                	ld	ra,120(sp)
    80002e20:	7446                	ld	s0,112(sp)
    80002e22:	6109                	addi	sp,sp,128
    80002e24:	8082                	ret
    80002e26:	f4a6                	sd	s1,104(sp)
    80002e28:	f0ca                	sd	s2,96(sp)
    80002e2a:	ecce                	sd	s3,88(sp)
    80002e2c:	e8d2                	sd	s4,80(sp)
    80002e2e:	e4d6                	sd	s5,72(sp)
    struct proc *mp = myproc();
    80002e30:	ad1fe0ef          	jal	80001900 <myproc>
    80002e34:	8a2a                	mv	s4,a0
    int count = 0;
    80002e36:	4901                	li	s2,0
    for (p = proc; p < &proc[NPROC] && count < n; p++) {
    80002e38:	00011497          	auipc	s1,0x11
    80002e3c:	da048493          	addi	s1,s1,-608 # 80013bd8 <proc>
            info.ppid = p->parent ? p->parent->pid : 0;
    80002e40:	4a81                	li	s5,0
    for (p = proc; p < &proc[NPROC] && count < n; p++) {
    80002e42:	00017997          	auipc	s3,0x17
    80002e46:	d9698993          	addi	s3,s3,-618 # 80019bd8 <tickslock>
    80002e4a:	a881                	j	80002e9a <sys_getptable+0xa8>
            info.ppid = p->parent ? p->parent->pid : 0;
    80002e4c:	f8e42623          	sw	a4,-116(s0)
            info.state = p->state;
    80002e50:	f8f42823          	sw	a5,-112(s0)
            info.sz = p->sz;
    80002e54:	64bc                	ld	a5,72(s1)
    80002e56:	f8f43c23          	sd	a5,-104(s0)
            safestrcpy(info.name, p->name, sizeof(info.name));
    80002e5a:	4641                	li	a2,16
    80002e5c:	15848593          	addi	a1,s1,344
    80002e60:	fa040513          	addi	a0,s0,-96
    80002e64:	fb1fd0ef          	jal	80000e14 <safestrcpy>
                        user_buf + count * sizeof(info),
    80002e68:	00291793          	slli	a5,s2,0x2
    80002e6c:	97ca                	add	a5,a5,s2
    80002e6e:	078e                	slli	a5,a5,0x3
            if (copyout(mp->pagetable,
    80002e70:	02800693          	li	a3,40
    80002e74:	f8840613          	addi	a2,s0,-120
    80002e78:	fb843583          	ld	a1,-72(s0)
    80002e7c:	95be                	add	a1,a1,a5
    80002e7e:	050a3503          	ld	a0,80(s4)
    80002e82:	ef0fe0ef          	jal	80001572 <copyout>
    80002e86:	02054b63          	bltz	a0,80002ebc <sys_getptable+0xca>
            count++;
    80002e8a:	2905                	addiw	s2,s2,1
        release(&p->lock);
    80002e8c:	8526                	mv	a0,s1
    80002e8e:	e0dfd0ef          	jal	80000c9a <release>
    for (p = proc; p < &proc[NPROC] && count < n; p++) {
    80002e92:	18048493          	addi	s1,s1,384
    80002e96:	03348d63          	beq	s1,s3,80002ed0 <sys_getptable+0xde>
    80002e9a:	fb442783          	lw	a5,-76(s0)
    80002e9e:	02f95963          	bge	s2,a5,80002ed0 <sys_getptable+0xde>
        acquire(&p->lock);
    80002ea2:	8526                	mv	a0,s1
    80002ea4:	d5ffd0ef          	jal	80000c02 <acquire>
        if (p->state != UNUSED) {
    80002ea8:	4c9c                	lw	a5,24(s1)
    80002eaa:	d3ed                	beqz	a5,80002e8c <sys_getptable+0x9a>
            info.pid = p->pid;
    80002eac:	5898                	lw	a4,48(s1)
    80002eae:	f8e42423          	sw	a4,-120(s0)
            info.ppid = p->parent ? p->parent->pid : 0;
    80002eb2:	7c94                	ld	a3,56(s1)
    80002eb4:	8756                	mv	a4,s5
    80002eb6:	dad9                	beqz	a3,80002e4c <sys_getptable+0x5a>
    80002eb8:	5a98                	lw	a4,48(a3)
    80002eba:	bf49                	j	80002e4c <sys_getptable+0x5a>
                release(&p->lock);
    80002ebc:	8526                	mv	a0,s1
    80002ebe:	dddfd0ef          	jal	80000c9a <release>
                return 0;
    80002ec2:	4501                	li	a0,0
    80002ec4:	74a6                	ld	s1,104(sp)
    80002ec6:	7906                	ld	s2,96(sp)
    80002ec8:	69e6                	ld	s3,88(sp)
    80002eca:	6a46                	ld	s4,80(sp)
    80002ecc:	6aa6                	ld	s5,72(sp)
    80002ece:	bf81                	j	80002e1e <sys_getptable+0x2c>
    return count; // number of processes copied
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	74a6                	ld	s1,104(sp)
    80002ed4:	7906                	ld	s2,96(sp)
    80002ed6:	69e6                	ld	s3,88(sp)
    80002ed8:	6a46                	ld	s4,80(sp)
    80002eda:	6aa6                	ld	s5,72(sp)
    80002edc:	b789                	j	80002e1e <sys_getptable+0x2c>

0000000080002ede <sys_setpriority>:

//p3
uint64
sys_setpriority(void)
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	1000                	addi	s0,sp,32
  int pid, priority;
  argint(0, &pid);       // Direct call, no "if" check
    80002ee6:	fec40593          	addi	a1,s0,-20
    80002eea:	4501                	li	a0,0
    80002eec:	ca9ff0ef          	jal	80002b94 <argint>
  argint(1, &priority);
    80002ef0:	fe840593          	addi	a1,s0,-24
    80002ef4:	4505                	li	a0,1
    80002ef6:	c9fff0ef          	jal	80002b94 <argint>
  return setpriority(pid, priority);
    80002efa:	fe842583          	lw	a1,-24(s0)
    80002efe:	fec42503          	lw	a0,-20(s0)
    80002f02:	f02ff0ef          	jal	80002604 <setpriority>
}
    80002f06:	60e2                	ld	ra,24(sp)
    80002f08:	6442                	ld	s0,16(sp)
    80002f0a:	6105                	addi	sp,sp,32
    80002f0c:	8082                	ret

0000000080002f0e <sys_setscheduler>:

uint64
sys_setscheduler(void)
{
    80002f0e:	1101                	addi	sp,sp,-32
    80002f10:	ec06                	sd	ra,24(sp)
    80002f12:	e822                	sd	s0,16(sp)
    80002f14:	1000                	addi	s0,sp,32
  int policy;
  argint(0, &policy);    // Direct call, no "if" check
    80002f16:	fec40593          	addi	a1,s0,-20
    80002f1a:	4501                	li	a0,0
    80002f1c:	c79ff0ef          	jal	80002b94 <argint>
  return setscheduler(policy);
    80002f20:	fec42503          	lw	a0,-20(s0)
    80002f24:	f5aff0ef          	jal	8000267e <setscheduler>
}
    80002f28:	60e2                	ld	ra,24(sp)
    80002f2a:	6442                	ld	s0,16(sp)
    80002f2c:	6105                	addi	sp,sp,32
    80002f2e:	8082                	ret

0000000080002f30 <sys_getmetrics>:

uint64
sys_getmetrics(void)
{
    80002f30:	7135                	addi	sp,sp,-160
    80002f32:	ed06                	sd	ra,152(sp)
    80002f34:	e922                	sd	s0,144(sp)
    80002f36:	1100                	addi	s0,sp,160
  uint64 addr;
  argaddr(0, &addr);
    80002f38:	f9840593          	addi	a1,s0,-104
    80002f3c:	4501                	li	a0,0
    80002f3e:	c73ff0ef          	jal	80002bb0 <argaddr>

  // 1. Calculate Global Averages
  uint64 t, w, f;
  populate_metrics(&t, &w, &f);
    80002f42:	f8040613          	addi	a2,s0,-128
    80002f46:	f8840593          	addi	a1,s0,-120
    80002f4a:	f9040513          	addi	a0,s0,-112
    80002f4e:	f8eff0ef          	jal	800026dc <populate_metrics>
    uint64 turnaround;
    uint64 waiting;
    uint64 finished;
  } m;

  m.turnaround = t;
    80002f52:	f9043783          	ld	a5,-112(s0)
    80002f56:	f6f43423          	sd	a5,-152(s0)
  m.waiting = w;
    80002f5a:	f8843783          	ld	a5,-120(s0)
    80002f5e:	f6f43823          	sd	a5,-144(s0)
  m.finished = f;
    80002f62:	f8043783          	ld	a5,-128(s0)
    80002f66:	f6f43c23          	sd	a5,-136(s0)

  if(copyout(myproc()->pagetable, addr, (char *)&m, sizeof(m)) < 0)
    80002f6a:	997fe0ef          	jal	80001900 <myproc>
    80002f6e:	46e1                	li	a3,24
    80002f70:	f6840613          	addi	a2,s0,-152
    80002f74:	f9843583          	ld	a1,-104(s0)
    80002f78:	6928                	ld	a0,80(a0)
    80002f7a:	df8fe0ef          	jal	80001572 <copyout>
    return -1;
    80002f7e:	57fd                	li	a5,-1
  if(copyout(myproc()->pagetable, addr, (char *)&m, sizeof(m)) < 0)
    80002f80:	0c054863          	bltz	a0,80003050 <sys_getmetrics+0x120>
    80002f84:	e526                	sd	s1,136(sp)
    80002f86:	e14a                	sd	s2,128(sp)
    80002f88:	fcce                	sd	s3,120(sp)
    80002f8a:	f8d2                	sd	s4,112(sp)
    80002f8c:	f4d6                	sd	s5,104(sp)
    80002f8e:	f0da                	sd	s6,96(sp)
    80002f90:	ecde                	sd	s7,88(sp)
    80002f92:	e8e2                	sd	s8,80(sp)
    80002f94:	e4e6                	sd	s9,72(sp)

  // 2. PRINT ACTIVE PROCESSES (The "Lazy" Way)
  // We print directly from the kernel to the console.
  struct proc *p;
  printf("\n--- Active Process List (Kernel Print) ---\n");
    80002f96:	00005517          	auipc	a0,0x5
    80002f9a:	4b250513          	addi	a0,a0,1202 # 80008448 <etext+0x448>
    80002f9e:	d32fd0ef          	jal	800004d0 <printf>
  printf("PID\tPrio\tState\tWaitT\tCreated\n");
    80002fa2:	00005517          	auipc	a0,0x5
    80002fa6:	4d650513          	addi	a0,a0,1238 # 80008478 <etext+0x478>
    80002faa:	d26fd0ef          	jal	800004d0 <printf>

  for(p = proc; p < &proc[NPROC]; p++){
    80002fae:	00011497          	auipc	s1,0x11
    80002fb2:	c2a48493          	addi	s1,s1,-982 # 80013bd8 <proc>
    if(p->state != UNUSED){
       // Calculate current age (turnaround so far)
       // int age = ticks - p->creation_time;

       const char *state_name = "???";
       if(p->state == SLEEPING) state_name = "SLEEP";
    80002fb6:	4a89                	li	s5,2
    80002fb8:	00005a17          	auipc	s4,0x5
    80002fbc:	478a0a13          	addi	s4,s4,1144 # 80008430 <etext+0x430>
       else if(p->state == RUNNABLE) state_name = "RUNBL";
       else if(p->state == RUNNING) state_name = "RUN";

       printf("%d\t%d\t%s\t%d\t%d\n",
    80002fc0:	00005997          	auipc	s3,0x5
    80002fc4:	4d898993          	addi	s3,s3,1240 # 80008498 <etext+0x498>
       else if(p->state == RUNNABLE) state_name = "RUNBL";
    80002fc8:	4b8d                	li	s7,3
    80002fca:	00005b17          	auipc	s6,0x5
    80002fce:	46eb0b13          	addi	s6,s6,1134 # 80008438 <etext+0x438>
       else if(p->state == RUNNING) state_name = "RUN";
    80002fd2:	00005c17          	auipc	s8,0x5
    80002fd6:	46ec0c13          	addi	s8,s8,1134 # 80008440 <etext+0x440>
       const char *state_name = "???";
    80002fda:	00005c97          	auipc	s9,0x5
    80002fde:	2c6c8c93          	addi	s9,s9,710 # 800082a0 <etext+0x2a0>
  for(p = proc; p < &proc[NPROC]; p++){
    80002fe2:	00017917          	auipc	s2,0x17
    80002fe6:	bf690913          	addi	s2,s2,-1034 # 80019bd8 <tickslock>
    80002fea:	a015                	j	8000300e <sys_getmetrics+0xde>
       printf("%d\t%d\t%s\t%d\t%d\n",
    80002fec:	1684a783          	lw	a5,360(s1)
    80002ff0:	1784a703          	lw	a4,376(s1)
    80002ff4:	1704a603          	lw	a2,368(s1)
    80002ff8:	588c                	lw	a1,48(s1)
    80002ffa:	854e                	mv	a0,s3
    80002ffc:	cd4fd0ef          	jal	800004d0 <printf>
              p->pid, p->priority, state_name, p->total_waiting_time, p->creation_time);
    }
    release(&p->lock);
    80003000:	8526                	mv	a0,s1
    80003002:	c99fd0ef          	jal	80000c9a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80003006:	18048493          	addi	s1,s1,384
    8000300a:	03248363          	beq	s1,s2,80003030 <sys_getmetrics+0x100>
    acquire(&p->lock);
    8000300e:	8526                	mv	a0,s1
    80003010:	bf3fd0ef          	jal	80000c02 <acquire>
    if(p->state != UNUSED){
    80003014:	4c9c                	lw	a5,24(s1)
    80003016:	d7ed                	beqz	a5,80003000 <sys_getmetrics+0xd0>
       if(p->state == SLEEPING) state_name = "SLEEP";
    80003018:	86d2                	mv	a3,s4
    8000301a:	fd5789e3          	beq	a5,s5,80002fec <sys_getmetrics+0xbc>
       else if(p->state == RUNNABLE) state_name = "RUNBL";
    8000301e:	86da                	mv	a3,s6
    80003020:	fd7786e3          	beq	a5,s7,80002fec <sys_getmetrics+0xbc>
       else if(p->state == RUNNING) state_name = "RUN";
    80003024:	4711                	li	a4,4
    80003026:	86e2                	mv	a3,s8
    80003028:	fce782e3          	beq	a5,a4,80002fec <sys_getmetrics+0xbc>
       const char *state_name = "???";
    8000302c:	86e6                	mv	a3,s9
    8000302e:	bf7d                	j	80002fec <sys_getmetrics+0xbc>
  }
  printf("------------------------------------------\n");
    80003030:	00005517          	auipc	a0,0x5
    80003034:	47850513          	addi	a0,a0,1144 # 800084a8 <etext+0x4a8>
    80003038:	c98fd0ef          	jal	800004d0 <printf>

  return 0;
    8000303c:	4781                	li	a5,0
    8000303e:	64aa                	ld	s1,136(sp)
    80003040:	690a                	ld	s2,128(sp)
    80003042:	79e6                	ld	s3,120(sp)
    80003044:	7a46                	ld	s4,112(sp)
    80003046:	7aa6                	ld	s5,104(sp)
    80003048:	7b06                	ld	s6,96(sp)
    8000304a:	6be6                	ld	s7,88(sp)
    8000304c:	6c46                	ld	s8,80(sp)
    8000304e:	6ca6                	ld	s9,72(sp)
}
    80003050:	853e                	mv	a0,a5
    80003052:	60ea                	ld	ra,152(sp)
    80003054:	644a                	ld	s0,144(sp)
    80003056:	610d                	addi	sp,sp,160
    80003058:	8082                	ret

000000008000305a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000305a:	7179                	addi	sp,sp,-48
    8000305c:	f406                	sd	ra,40(sp)
    8000305e:	f022                	sd	s0,32(sp)
    80003060:	ec26                	sd	s1,24(sp)
    80003062:	e84a                	sd	s2,16(sp)
    80003064:	e44e                	sd	s3,8(sp)
    80003066:	e052                	sd	s4,0(sp)
    80003068:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000306a:	00005597          	auipc	a1,0x5
    8000306e:	46e58593          	addi	a1,a1,1134 # 800084d8 <etext+0x4d8>
    80003072:	00017517          	auipc	a0,0x17
    80003076:	b7e50513          	addi	a0,a0,-1154 # 80019bf0 <bcache>
    8000307a:	b09fd0ef          	jal	80000b82 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000307e:	0001f797          	auipc	a5,0x1f
    80003082:	b7278793          	addi	a5,a5,-1166 # 80021bf0 <bcache+0x8000>
    80003086:	0001f717          	auipc	a4,0x1f
    8000308a:	dd270713          	addi	a4,a4,-558 # 80021e58 <bcache+0x8268>
    8000308e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003092:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003096:	00017497          	auipc	s1,0x17
    8000309a:	b7248493          	addi	s1,s1,-1166 # 80019c08 <bcache+0x18>
    b->next = bcache.head.next;
    8000309e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800030a0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800030a2:	00005a17          	auipc	s4,0x5
    800030a6:	43ea0a13          	addi	s4,s4,1086 # 800084e0 <etext+0x4e0>
    b->next = bcache.head.next;
    800030aa:	2b893783          	ld	a5,696(s2)
    800030ae:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800030b0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800030b4:	85d2                	mv	a1,s4
    800030b6:	01048513          	addi	a0,s1,16
    800030ba:	248010ef          	jal	80004302 <initsleeplock>
    bcache.head.next->prev = b;
    800030be:	2b893783          	ld	a5,696(s2)
    800030c2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800030c4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800030c8:	45848493          	addi	s1,s1,1112
    800030cc:	fd349fe3          	bne	s1,s3,800030aa <binit+0x50>
  }
}
    800030d0:	70a2                	ld	ra,40(sp)
    800030d2:	7402                	ld	s0,32(sp)
    800030d4:	64e2                	ld	s1,24(sp)
    800030d6:	6942                	ld	s2,16(sp)
    800030d8:	69a2                	ld	s3,8(sp)
    800030da:	6a02                	ld	s4,0(sp)
    800030dc:	6145                	addi	sp,sp,48
    800030de:	8082                	ret

00000000800030e0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800030e0:	7179                	addi	sp,sp,-48
    800030e2:	f406                	sd	ra,40(sp)
    800030e4:	f022                	sd	s0,32(sp)
    800030e6:	ec26                	sd	s1,24(sp)
    800030e8:	e84a                	sd	s2,16(sp)
    800030ea:	e44e                	sd	s3,8(sp)
    800030ec:	1800                	addi	s0,sp,48
    800030ee:	892a                	mv	s2,a0
    800030f0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800030f2:	00017517          	auipc	a0,0x17
    800030f6:	afe50513          	addi	a0,a0,-1282 # 80019bf0 <bcache>
    800030fa:	b09fd0ef          	jal	80000c02 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030fe:	0001f497          	auipc	s1,0x1f
    80003102:	daa4b483          	ld	s1,-598(s1) # 80021ea8 <bcache+0x82b8>
    80003106:	0001f797          	auipc	a5,0x1f
    8000310a:	d5278793          	addi	a5,a5,-686 # 80021e58 <bcache+0x8268>
    8000310e:	02f48b63          	beq	s1,a5,80003144 <bread+0x64>
    80003112:	873e                	mv	a4,a5
    80003114:	a021                	j	8000311c <bread+0x3c>
    80003116:	68a4                	ld	s1,80(s1)
    80003118:	02e48663          	beq	s1,a4,80003144 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000311c:	449c                	lw	a5,8(s1)
    8000311e:	ff279ce3          	bne	a5,s2,80003116 <bread+0x36>
    80003122:	44dc                	lw	a5,12(s1)
    80003124:	ff3799e3          	bne	a5,s3,80003116 <bread+0x36>
      b->refcnt++;
    80003128:	40bc                	lw	a5,64(s1)
    8000312a:	2785                	addiw	a5,a5,1
    8000312c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000312e:	00017517          	auipc	a0,0x17
    80003132:	ac250513          	addi	a0,a0,-1342 # 80019bf0 <bcache>
    80003136:	b65fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    8000313a:	01048513          	addi	a0,s1,16
    8000313e:	1fa010ef          	jal	80004338 <acquiresleep>
      return b;
    80003142:	a889                	j	80003194 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003144:	0001f497          	auipc	s1,0x1f
    80003148:	d5c4b483          	ld	s1,-676(s1) # 80021ea0 <bcache+0x82b0>
    8000314c:	0001f797          	auipc	a5,0x1f
    80003150:	d0c78793          	addi	a5,a5,-756 # 80021e58 <bcache+0x8268>
    80003154:	00f48863          	beq	s1,a5,80003164 <bread+0x84>
    80003158:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000315a:	40bc                	lw	a5,64(s1)
    8000315c:	cb91                	beqz	a5,80003170 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000315e:	64a4                	ld	s1,72(s1)
    80003160:	fee49de3          	bne	s1,a4,8000315a <bread+0x7a>
  panic("bget: no buffers");
    80003164:	00005517          	auipc	a0,0x5
    80003168:	38450513          	addi	a0,a0,900 # 800084e8 <etext+0x4e8>
    8000316c:	e36fd0ef          	jal	800007a2 <panic>
      b->dev = dev;
    80003170:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003174:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003178:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000317c:	4785                	li	a5,1
    8000317e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003180:	00017517          	auipc	a0,0x17
    80003184:	a7050513          	addi	a0,a0,-1424 # 80019bf0 <bcache>
    80003188:	b13fd0ef          	jal	80000c9a <release>
      acquiresleep(&b->lock);
    8000318c:	01048513          	addi	a0,s1,16
    80003190:	1a8010ef          	jal	80004338 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003194:	409c                	lw	a5,0(s1)
    80003196:	cb89                	beqz	a5,800031a8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003198:	8526                	mv	a0,s1
    8000319a:	70a2                	ld	ra,40(sp)
    8000319c:	7402                	ld	s0,32(sp)
    8000319e:	64e2                	ld	s1,24(sp)
    800031a0:	6942                	ld	s2,16(sp)
    800031a2:	69a2                	ld	s3,8(sp)
    800031a4:	6145                	addi	sp,sp,48
    800031a6:	8082                	ret
    virtio_disk_rw(b, 0);
    800031a8:	4581                	li	a1,0
    800031aa:	8526                	mv	a0,s1
    800031ac:	1e5020ef          	jal	80005b90 <virtio_disk_rw>
    b->valid = 1;
    800031b0:	4785                	li	a5,1
    800031b2:	c09c                	sw	a5,0(s1)
  return b;
    800031b4:	b7d5                	j	80003198 <bread+0xb8>

00000000800031b6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800031b6:	1101                	addi	sp,sp,-32
    800031b8:	ec06                	sd	ra,24(sp)
    800031ba:	e822                	sd	s0,16(sp)
    800031bc:	e426                	sd	s1,8(sp)
    800031be:	1000                	addi	s0,sp,32
    800031c0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031c2:	0541                	addi	a0,a0,16
    800031c4:	1f2010ef          	jal	800043b6 <holdingsleep>
    800031c8:	c911                	beqz	a0,800031dc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800031ca:	4585                	li	a1,1
    800031cc:	8526                	mv	a0,s1
    800031ce:	1c3020ef          	jal	80005b90 <virtio_disk_rw>
}
    800031d2:	60e2                	ld	ra,24(sp)
    800031d4:	6442                	ld	s0,16(sp)
    800031d6:	64a2                	ld	s1,8(sp)
    800031d8:	6105                	addi	sp,sp,32
    800031da:	8082                	ret
    panic("bwrite");
    800031dc:	00005517          	auipc	a0,0x5
    800031e0:	32450513          	addi	a0,a0,804 # 80008500 <etext+0x500>
    800031e4:	dbefd0ef          	jal	800007a2 <panic>

00000000800031e8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800031e8:	1101                	addi	sp,sp,-32
    800031ea:	ec06                	sd	ra,24(sp)
    800031ec:	e822                	sd	s0,16(sp)
    800031ee:	e426                	sd	s1,8(sp)
    800031f0:	e04a                	sd	s2,0(sp)
    800031f2:	1000                	addi	s0,sp,32
    800031f4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031f6:	01050913          	addi	s2,a0,16
    800031fa:	854a                	mv	a0,s2
    800031fc:	1ba010ef          	jal	800043b6 <holdingsleep>
    80003200:	c135                	beqz	a0,80003264 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80003202:	854a                	mv	a0,s2
    80003204:	17a010ef          	jal	8000437e <releasesleep>

  acquire(&bcache.lock);
    80003208:	00017517          	auipc	a0,0x17
    8000320c:	9e850513          	addi	a0,a0,-1560 # 80019bf0 <bcache>
    80003210:	9f3fd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    80003214:	40bc                	lw	a5,64(s1)
    80003216:	37fd                	addiw	a5,a5,-1
    80003218:	0007871b          	sext.w	a4,a5
    8000321c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000321e:	e71d                	bnez	a4,8000324c <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003220:	68b8                	ld	a4,80(s1)
    80003222:	64bc                	ld	a5,72(s1)
    80003224:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003226:	68b8                	ld	a4,80(s1)
    80003228:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000322a:	0001f797          	auipc	a5,0x1f
    8000322e:	9c678793          	addi	a5,a5,-1594 # 80021bf0 <bcache+0x8000>
    80003232:	2b87b703          	ld	a4,696(a5)
    80003236:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003238:	0001f717          	auipc	a4,0x1f
    8000323c:	c2070713          	addi	a4,a4,-992 # 80021e58 <bcache+0x8268>
    80003240:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003242:	2b87b703          	ld	a4,696(a5)
    80003246:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003248:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000324c:	00017517          	auipc	a0,0x17
    80003250:	9a450513          	addi	a0,a0,-1628 # 80019bf0 <bcache>
    80003254:	a47fd0ef          	jal	80000c9a <release>
}
    80003258:	60e2                	ld	ra,24(sp)
    8000325a:	6442                	ld	s0,16(sp)
    8000325c:	64a2                	ld	s1,8(sp)
    8000325e:	6902                	ld	s2,0(sp)
    80003260:	6105                	addi	sp,sp,32
    80003262:	8082                	ret
    panic("brelse");
    80003264:	00005517          	auipc	a0,0x5
    80003268:	2a450513          	addi	a0,a0,676 # 80008508 <etext+0x508>
    8000326c:	d36fd0ef          	jal	800007a2 <panic>

0000000080003270 <bpin>:

void
bpin(struct buf *b) {
    80003270:	1101                	addi	sp,sp,-32
    80003272:	ec06                	sd	ra,24(sp)
    80003274:	e822                	sd	s0,16(sp)
    80003276:	e426                	sd	s1,8(sp)
    80003278:	1000                	addi	s0,sp,32
    8000327a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000327c:	00017517          	auipc	a0,0x17
    80003280:	97450513          	addi	a0,a0,-1676 # 80019bf0 <bcache>
    80003284:	97ffd0ef          	jal	80000c02 <acquire>
  b->refcnt++;
    80003288:	40bc                	lw	a5,64(s1)
    8000328a:	2785                	addiw	a5,a5,1
    8000328c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000328e:	00017517          	auipc	a0,0x17
    80003292:	96250513          	addi	a0,a0,-1694 # 80019bf0 <bcache>
    80003296:	a05fd0ef          	jal	80000c9a <release>
}
    8000329a:	60e2                	ld	ra,24(sp)
    8000329c:	6442                	ld	s0,16(sp)
    8000329e:	64a2                	ld	s1,8(sp)
    800032a0:	6105                	addi	sp,sp,32
    800032a2:	8082                	ret

00000000800032a4 <bunpin>:

void
bunpin(struct buf *b) {
    800032a4:	1101                	addi	sp,sp,-32
    800032a6:	ec06                	sd	ra,24(sp)
    800032a8:	e822                	sd	s0,16(sp)
    800032aa:	e426                	sd	s1,8(sp)
    800032ac:	1000                	addi	s0,sp,32
    800032ae:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800032b0:	00017517          	auipc	a0,0x17
    800032b4:	94050513          	addi	a0,a0,-1728 # 80019bf0 <bcache>
    800032b8:	94bfd0ef          	jal	80000c02 <acquire>
  b->refcnt--;
    800032bc:	40bc                	lw	a5,64(s1)
    800032be:	37fd                	addiw	a5,a5,-1
    800032c0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800032c2:	00017517          	auipc	a0,0x17
    800032c6:	92e50513          	addi	a0,a0,-1746 # 80019bf0 <bcache>
    800032ca:	9d1fd0ef          	jal	80000c9a <release>
}
    800032ce:	60e2                	ld	ra,24(sp)
    800032d0:	6442                	ld	s0,16(sp)
    800032d2:	64a2                	ld	s1,8(sp)
    800032d4:	6105                	addi	sp,sp,32
    800032d6:	8082                	ret

00000000800032d8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032d8:	1101                	addi	sp,sp,-32
    800032da:	ec06                	sd	ra,24(sp)
    800032dc:	e822                	sd	s0,16(sp)
    800032de:	e426                	sd	s1,8(sp)
    800032e0:	e04a                	sd	s2,0(sp)
    800032e2:	1000                	addi	s0,sp,32
    800032e4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032e6:	00d5d59b          	srliw	a1,a1,0xd
    800032ea:	0001f797          	auipc	a5,0x1f
    800032ee:	fe27a783          	lw	a5,-30(a5) # 800222cc <sb+0x1c>
    800032f2:	9dbd                	addw	a1,a1,a5
    800032f4:	dedff0ef          	jal	800030e0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032f8:	0074f713          	andi	a4,s1,7
    800032fc:	4785                	li	a5,1
    800032fe:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003302:	14ce                	slli	s1,s1,0x33
    80003304:	90d9                	srli	s1,s1,0x36
    80003306:	00950733          	add	a4,a0,s1
    8000330a:	05874703          	lbu	a4,88(a4)
    8000330e:	00e7f6b3          	and	a3,a5,a4
    80003312:	c29d                	beqz	a3,80003338 <bfree+0x60>
    80003314:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003316:	94aa                	add	s1,s1,a0
    80003318:	fff7c793          	not	a5,a5
    8000331c:	8f7d                	and	a4,a4,a5
    8000331e:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003322:	711000ef          	jal	80004232 <log_write>
  brelse(bp);
    80003326:	854a                	mv	a0,s2
    80003328:	ec1ff0ef          	jal	800031e8 <brelse>
}
    8000332c:	60e2                	ld	ra,24(sp)
    8000332e:	6442                	ld	s0,16(sp)
    80003330:	64a2                	ld	s1,8(sp)
    80003332:	6902                	ld	s2,0(sp)
    80003334:	6105                	addi	sp,sp,32
    80003336:	8082                	ret
    panic("freeing free block");
    80003338:	00005517          	auipc	a0,0x5
    8000333c:	1d850513          	addi	a0,a0,472 # 80008510 <etext+0x510>
    80003340:	c62fd0ef          	jal	800007a2 <panic>

0000000080003344 <balloc>:
{
    80003344:	711d                	addi	sp,sp,-96
    80003346:	ec86                	sd	ra,88(sp)
    80003348:	e8a2                	sd	s0,80(sp)
    8000334a:	e4a6                	sd	s1,72(sp)
    8000334c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000334e:	0001f797          	auipc	a5,0x1f
    80003352:	f667a783          	lw	a5,-154(a5) # 800222b4 <sb+0x4>
    80003356:	0e078f63          	beqz	a5,80003454 <balloc+0x110>
    8000335a:	e0ca                	sd	s2,64(sp)
    8000335c:	fc4e                	sd	s3,56(sp)
    8000335e:	f852                	sd	s4,48(sp)
    80003360:	f456                	sd	s5,40(sp)
    80003362:	f05a                	sd	s6,32(sp)
    80003364:	ec5e                	sd	s7,24(sp)
    80003366:	e862                	sd	s8,16(sp)
    80003368:	e466                	sd	s9,8(sp)
    8000336a:	8baa                	mv	s7,a0
    8000336c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000336e:	0001fb17          	auipc	s6,0x1f
    80003372:	f42b0b13          	addi	s6,s6,-190 # 800222b0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003376:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003378:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000337a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000337c:	6c89                	lui	s9,0x2
    8000337e:	a0b5                	j	800033ea <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003380:	97ca                	add	a5,a5,s2
    80003382:	8e55                	or	a2,a2,a3
    80003384:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003388:	854a                	mv	a0,s2
    8000338a:	6a9000ef          	jal	80004232 <log_write>
        brelse(bp);
    8000338e:	854a                	mv	a0,s2
    80003390:	e59ff0ef          	jal	800031e8 <brelse>
  bp = bread(dev, bno);
    80003394:	85a6                	mv	a1,s1
    80003396:	855e                	mv	a0,s7
    80003398:	d49ff0ef          	jal	800030e0 <bread>
    8000339c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000339e:	40000613          	li	a2,1024
    800033a2:	4581                	li	a1,0
    800033a4:	05850513          	addi	a0,a0,88
    800033a8:	92ffd0ef          	jal	80000cd6 <memset>
  log_write(bp);
    800033ac:	854a                	mv	a0,s2
    800033ae:	685000ef          	jal	80004232 <log_write>
  brelse(bp);
    800033b2:	854a                	mv	a0,s2
    800033b4:	e35ff0ef          	jal	800031e8 <brelse>
}
    800033b8:	6906                	ld	s2,64(sp)
    800033ba:	79e2                	ld	s3,56(sp)
    800033bc:	7a42                	ld	s4,48(sp)
    800033be:	7aa2                	ld	s5,40(sp)
    800033c0:	7b02                	ld	s6,32(sp)
    800033c2:	6be2                	ld	s7,24(sp)
    800033c4:	6c42                	ld	s8,16(sp)
    800033c6:	6ca2                	ld	s9,8(sp)
}
    800033c8:	8526                	mv	a0,s1
    800033ca:	60e6                	ld	ra,88(sp)
    800033cc:	6446                	ld	s0,80(sp)
    800033ce:	64a6                	ld	s1,72(sp)
    800033d0:	6125                	addi	sp,sp,96
    800033d2:	8082                	ret
    brelse(bp);
    800033d4:	854a                	mv	a0,s2
    800033d6:	e13ff0ef          	jal	800031e8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800033da:	015c87bb          	addw	a5,s9,s5
    800033de:	00078a9b          	sext.w	s5,a5
    800033e2:	004b2703          	lw	a4,4(s6)
    800033e6:	04eaff63          	bgeu	s5,a4,80003444 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800033ea:	41fad79b          	sraiw	a5,s5,0x1f
    800033ee:	0137d79b          	srliw	a5,a5,0x13
    800033f2:	015787bb          	addw	a5,a5,s5
    800033f6:	40d7d79b          	sraiw	a5,a5,0xd
    800033fa:	01cb2583          	lw	a1,28(s6)
    800033fe:	9dbd                	addw	a1,a1,a5
    80003400:	855e                	mv	a0,s7
    80003402:	cdfff0ef          	jal	800030e0 <bread>
    80003406:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003408:	004b2503          	lw	a0,4(s6)
    8000340c:	000a849b          	sext.w	s1,s5
    80003410:	8762                	mv	a4,s8
    80003412:	fca4f1e3          	bgeu	s1,a0,800033d4 <balloc+0x90>
      m = 1 << (bi % 8);
    80003416:	00777693          	andi	a3,a4,7
    8000341a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000341e:	41f7579b          	sraiw	a5,a4,0x1f
    80003422:	01d7d79b          	srliw	a5,a5,0x1d
    80003426:	9fb9                	addw	a5,a5,a4
    80003428:	4037d79b          	sraiw	a5,a5,0x3
    8000342c:	00f90633          	add	a2,s2,a5
    80003430:	05864603          	lbu	a2,88(a2)
    80003434:	00c6f5b3          	and	a1,a3,a2
    80003438:	d5a1                	beqz	a1,80003380 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000343a:	2705                	addiw	a4,a4,1
    8000343c:	2485                	addiw	s1,s1,1
    8000343e:	fd471ae3          	bne	a4,s4,80003412 <balloc+0xce>
    80003442:	bf49                	j	800033d4 <balloc+0x90>
    80003444:	6906                	ld	s2,64(sp)
    80003446:	79e2                	ld	s3,56(sp)
    80003448:	7a42                	ld	s4,48(sp)
    8000344a:	7aa2                	ld	s5,40(sp)
    8000344c:	7b02                	ld	s6,32(sp)
    8000344e:	6be2                	ld	s7,24(sp)
    80003450:	6c42                	ld	s8,16(sp)
    80003452:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003454:	00005517          	auipc	a0,0x5
    80003458:	0d450513          	addi	a0,a0,212 # 80008528 <etext+0x528>
    8000345c:	874fd0ef          	jal	800004d0 <printf>
  return 0;
    80003460:	4481                	li	s1,0
    80003462:	b79d                	j	800033c8 <balloc+0x84>

0000000080003464 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003464:	7179                	addi	sp,sp,-48
    80003466:	f406                	sd	ra,40(sp)
    80003468:	f022                	sd	s0,32(sp)
    8000346a:	ec26                	sd	s1,24(sp)
    8000346c:	e84a                	sd	s2,16(sp)
    8000346e:	e44e                	sd	s3,8(sp)
    80003470:	1800                	addi	s0,sp,48
    80003472:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003474:	47ad                	li	a5,11
    80003476:	02b7e663          	bltu	a5,a1,800034a2 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    8000347a:	02059793          	slli	a5,a1,0x20
    8000347e:	01e7d593          	srli	a1,a5,0x1e
    80003482:	00b504b3          	add	s1,a0,a1
    80003486:	0504a903          	lw	s2,80(s1)
    8000348a:	06091a63          	bnez	s2,800034fe <bmap+0x9a>
      addr = balloc(ip->dev);
    8000348e:	4108                	lw	a0,0(a0)
    80003490:	eb5ff0ef          	jal	80003344 <balloc>
    80003494:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003498:	06090363          	beqz	s2,800034fe <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    8000349c:	0524a823          	sw	s2,80(s1)
    800034a0:	a8b9                	j	800034fe <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800034a2:	ff45849b          	addiw	s1,a1,-12
    800034a6:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800034aa:	0ff00793          	li	a5,255
    800034ae:	06e7ee63          	bltu	a5,a4,8000352a <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800034b2:	08052903          	lw	s2,128(a0)
    800034b6:	00091d63          	bnez	s2,800034d0 <bmap+0x6c>
      addr = balloc(ip->dev);
    800034ba:	4108                	lw	a0,0(a0)
    800034bc:	e89ff0ef          	jal	80003344 <balloc>
    800034c0:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800034c4:	02090d63          	beqz	s2,800034fe <bmap+0x9a>
    800034c8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800034ca:	0929a023          	sw	s2,128(s3)
    800034ce:	a011                	j	800034d2 <bmap+0x6e>
    800034d0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800034d2:	85ca                	mv	a1,s2
    800034d4:	0009a503          	lw	a0,0(s3)
    800034d8:	c09ff0ef          	jal	800030e0 <bread>
    800034dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800034e2:	02049713          	slli	a4,s1,0x20
    800034e6:	01e75593          	srli	a1,a4,0x1e
    800034ea:	00b784b3          	add	s1,a5,a1
    800034ee:	0004a903          	lw	s2,0(s1)
    800034f2:	00090e63          	beqz	s2,8000350e <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800034f6:	8552                	mv	a0,s4
    800034f8:	cf1ff0ef          	jal	800031e8 <brelse>
    return addr;
    800034fc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800034fe:	854a                	mv	a0,s2
    80003500:	70a2                	ld	ra,40(sp)
    80003502:	7402                	ld	s0,32(sp)
    80003504:	64e2                	ld	s1,24(sp)
    80003506:	6942                	ld	s2,16(sp)
    80003508:	69a2                	ld	s3,8(sp)
    8000350a:	6145                	addi	sp,sp,48
    8000350c:	8082                	ret
      addr = balloc(ip->dev);
    8000350e:	0009a503          	lw	a0,0(s3)
    80003512:	e33ff0ef          	jal	80003344 <balloc>
    80003516:	0005091b          	sext.w	s2,a0
      if(addr){
    8000351a:	fc090ee3          	beqz	s2,800034f6 <bmap+0x92>
        a[bn] = addr;
    8000351e:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003522:	8552                	mv	a0,s4
    80003524:	50f000ef          	jal	80004232 <log_write>
    80003528:	b7f9                	j	800034f6 <bmap+0x92>
    8000352a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000352c:	00005517          	auipc	a0,0x5
    80003530:	01450513          	addi	a0,a0,20 # 80008540 <etext+0x540>
    80003534:	a6efd0ef          	jal	800007a2 <panic>

0000000080003538 <iget>:
{
    80003538:	7179                	addi	sp,sp,-48
    8000353a:	f406                	sd	ra,40(sp)
    8000353c:	f022                	sd	s0,32(sp)
    8000353e:	ec26                	sd	s1,24(sp)
    80003540:	e84a                	sd	s2,16(sp)
    80003542:	e44e                	sd	s3,8(sp)
    80003544:	e052                	sd	s4,0(sp)
    80003546:	1800                	addi	s0,sp,48
    80003548:	89aa                	mv	s3,a0
    8000354a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000354c:	0001f517          	auipc	a0,0x1f
    80003550:	d8450513          	addi	a0,a0,-636 # 800222d0 <itable>
    80003554:	eaefd0ef          	jal	80000c02 <acquire>
  empty = 0;
    80003558:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000355a:	0001f497          	auipc	s1,0x1f
    8000355e:	d8e48493          	addi	s1,s1,-626 # 800222e8 <itable+0x18>
    80003562:	00021697          	auipc	a3,0x21
    80003566:	81668693          	addi	a3,a3,-2026 # 80023d78 <log>
    8000356a:	a039                	j	80003578 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000356c:	02090963          	beqz	s2,8000359e <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003570:	08848493          	addi	s1,s1,136
    80003574:	02d48863          	beq	s1,a3,800035a4 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003578:	449c                	lw	a5,8(s1)
    8000357a:	fef059e3          	blez	a5,8000356c <iget+0x34>
    8000357e:	4098                	lw	a4,0(s1)
    80003580:	ff3716e3          	bne	a4,s3,8000356c <iget+0x34>
    80003584:	40d8                	lw	a4,4(s1)
    80003586:	ff4713e3          	bne	a4,s4,8000356c <iget+0x34>
      ip->ref++;
    8000358a:	2785                	addiw	a5,a5,1
    8000358c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000358e:	0001f517          	auipc	a0,0x1f
    80003592:	d4250513          	addi	a0,a0,-702 # 800222d0 <itable>
    80003596:	f04fd0ef          	jal	80000c9a <release>
      return ip;
    8000359a:	8926                	mv	s2,s1
    8000359c:	a02d                	j	800035c6 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000359e:	fbe9                	bnez	a5,80003570 <iget+0x38>
      empty = ip;
    800035a0:	8926                	mv	s2,s1
    800035a2:	b7f9                	j	80003570 <iget+0x38>
  if(empty == 0)
    800035a4:	02090a63          	beqz	s2,800035d8 <iget+0xa0>
  ip->dev = dev;
    800035a8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035ac:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035b0:	4785                	li	a5,1
    800035b2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035b6:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800035ba:	0001f517          	auipc	a0,0x1f
    800035be:	d1650513          	addi	a0,a0,-746 # 800222d0 <itable>
    800035c2:	ed8fd0ef          	jal	80000c9a <release>
}
    800035c6:	854a                	mv	a0,s2
    800035c8:	70a2                	ld	ra,40(sp)
    800035ca:	7402                	ld	s0,32(sp)
    800035cc:	64e2                	ld	s1,24(sp)
    800035ce:	6942                	ld	s2,16(sp)
    800035d0:	69a2                	ld	s3,8(sp)
    800035d2:	6a02                	ld	s4,0(sp)
    800035d4:	6145                	addi	sp,sp,48
    800035d6:	8082                	ret
    panic("iget: no inodes");
    800035d8:	00005517          	auipc	a0,0x5
    800035dc:	f8050513          	addi	a0,a0,-128 # 80008558 <etext+0x558>
    800035e0:	9c2fd0ef          	jal	800007a2 <panic>

00000000800035e4 <fsinit>:
fsinit(int dev) {
    800035e4:	7179                	addi	sp,sp,-48
    800035e6:	f406                	sd	ra,40(sp)
    800035e8:	f022                	sd	s0,32(sp)
    800035ea:	ec26                	sd	s1,24(sp)
    800035ec:	e84a                	sd	s2,16(sp)
    800035ee:	e44e                	sd	s3,8(sp)
    800035f0:	1800                	addi	s0,sp,48
    800035f2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800035f4:	4585                	li	a1,1
    800035f6:	aebff0ef          	jal	800030e0 <bread>
    800035fa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800035fc:	0001f997          	auipc	s3,0x1f
    80003600:	cb498993          	addi	s3,s3,-844 # 800222b0 <sb>
    80003604:	02000613          	li	a2,32
    80003608:	05850593          	addi	a1,a0,88
    8000360c:	854e                	mv	a0,s3
    8000360e:	f24fd0ef          	jal	80000d32 <memmove>
  brelse(bp);
    80003612:	8526                	mv	a0,s1
    80003614:	bd5ff0ef          	jal	800031e8 <brelse>
  if(sb.magic != FSMAGIC)
    80003618:	0009a703          	lw	a4,0(s3)
    8000361c:	102037b7          	lui	a5,0x10203
    80003620:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003624:	02f71063          	bne	a4,a5,80003644 <fsinit+0x60>
  initlog(dev, &sb);
    80003628:	0001f597          	auipc	a1,0x1f
    8000362c:	c8858593          	addi	a1,a1,-888 # 800222b0 <sb>
    80003630:	854a                	mv	a0,s2
    80003632:	1f9000ef          	jal	8000402a <initlog>
}
    80003636:	70a2                	ld	ra,40(sp)
    80003638:	7402                	ld	s0,32(sp)
    8000363a:	64e2                	ld	s1,24(sp)
    8000363c:	6942                	ld	s2,16(sp)
    8000363e:	69a2                	ld	s3,8(sp)
    80003640:	6145                	addi	sp,sp,48
    80003642:	8082                	ret
    panic("invalid file system");
    80003644:	00005517          	auipc	a0,0x5
    80003648:	f2450513          	addi	a0,a0,-220 # 80008568 <etext+0x568>
    8000364c:	956fd0ef          	jal	800007a2 <panic>

0000000080003650 <iinit>:
{
    80003650:	7179                	addi	sp,sp,-48
    80003652:	f406                	sd	ra,40(sp)
    80003654:	f022                	sd	s0,32(sp)
    80003656:	ec26                	sd	s1,24(sp)
    80003658:	e84a                	sd	s2,16(sp)
    8000365a:	e44e                	sd	s3,8(sp)
    8000365c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000365e:	00005597          	auipc	a1,0x5
    80003662:	f2258593          	addi	a1,a1,-222 # 80008580 <etext+0x580>
    80003666:	0001f517          	auipc	a0,0x1f
    8000366a:	c6a50513          	addi	a0,a0,-918 # 800222d0 <itable>
    8000366e:	d14fd0ef          	jal	80000b82 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003672:	0001f497          	auipc	s1,0x1f
    80003676:	c8648493          	addi	s1,s1,-890 # 800222f8 <itable+0x28>
    8000367a:	00020997          	auipc	s3,0x20
    8000367e:	70e98993          	addi	s3,s3,1806 # 80023d88 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003682:	00005917          	auipc	s2,0x5
    80003686:	f0690913          	addi	s2,s2,-250 # 80008588 <etext+0x588>
    8000368a:	85ca                	mv	a1,s2
    8000368c:	8526                	mv	a0,s1
    8000368e:	475000ef          	jal	80004302 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003692:	08848493          	addi	s1,s1,136
    80003696:	ff349ae3          	bne	s1,s3,8000368a <iinit+0x3a>
}
    8000369a:	70a2                	ld	ra,40(sp)
    8000369c:	7402                	ld	s0,32(sp)
    8000369e:	64e2                	ld	s1,24(sp)
    800036a0:	6942                	ld	s2,16(sp)
    800036a2:	69a2                	ld	s3,8(sp)
    800036a4:	6145                	addi	sp,sp,48
    800036a6:	8082                	ret

00000000800036a8 <ialloc>:
{
    800036a8:	7139                	addi	sp,sp,-64
    800036aa:	fc06                	sd	ra,56(sp)
    800036ac:	f822                	sd	s0,48(sp)
    800036ae:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800036b0:	0001f717          	auipc	a4,0x1f
    800036b4:	c0c72703          	lw	a4,-1012(a4) # 800222bc <sb+0xc>
    800036b8:	4785                	li	a5,1
    800036ba:	06e7f063          	bgeu	a5,a4,8000371a <ialloc+0x72>
    800036be:	f426                	sd	s1,40(sp)
    800036c0:	f04a                	sd	s2,32(sp)
    800036c2:	ec4e                	sd	s3,24(sp)
    800036c4:	e852                	sd	s4,16(sp)
    800036c6:	e456                	sd	s5,8(sp)
    800036c8:	e05a                	sd	s6,0(sp)
    800036ca:	8aaa                	mv	s5,a0
    800036cc:	8b2e                	mv	s6,a1
    800036ce:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800036d0:	0001fa17          	auipc	s4,0x1f
    800036d4:	be0a0a13          	addi	s4,s4,-1056 # 800222b0 <sb>
    800036d8:	00495593          	srli	a1,s2,0x4
    800036dc:	018a2783          	lw	a5,24(s4)
    800036e0:	9dbd                	addw	a1,a1,a5
    800036e2:	8556                	mv	a0,s5
    800036e4:	9fdff0ef          	jal	800030e0 <bread>
    800036e8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800036ea:	05850993          	addi	s3,a0,88
    800036ee:	00f97793          	andi	a5,s2,15
    800036f2:	079a                	slli	a5,a5,0x6
    800036f4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800036f6:	00099783          	lh	a5,0(s3)
    800036fa:	cb9d                	beqz	a5,80003730 <ialloc+0x88>
    brelse(bp);
    800036fc:	aedff0ef          	jal	800031e8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003700:	0905                	addi	s2,s2,1
    80003702:	00ca2703          	lw	a4,12(s4)
    80003706:	0009079b          	sext.w	a5,s2
    8000370a:	fce7e7e3          	bltu	a5,a4,800036d8 <ialloc+0x30>
    8000370e:	74a2                	ld	s1,40(sp)
    80003710:	7902                	ld	s2,32(sp)
    80003712:	69e2                	ld	s3,24(sp)
    80003714:	6a42                	ld	s4,16(sp)
    80003716:	6aa2                	ld	s5,8(sp)
    80003718:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000371a:	00005517          	auipc	a0,0x5
    8000371e:	e7650513          	addi	a0,a0,-394 # 80008590 <etext+0x590>
    80003722:	daffc0ef          	jal	800004d0 <printf>
  return 0;
    80003726:	4501                	li	a0,0
}
    80003728:	70e2                	ld	ra,56(sp)
    8000372a:	7442                	ld	s0,48(sp)
    8000372c:	6121                	addi	sp,sp,64
    8000372e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003730:	04000613          	li	a2,64
    80003734:	4581                	li	a1,0
    80003736:	854e                	mv	a0,s3
    80003738:	d9efd0ef          	jal	80000cd6 <memset>
      dip->type = type;
    8000373c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003740:	8526                	mv	a0,s1
    80003742:	2f1000ef          	jal	80004232 <log_write>
      brelse(bp);
    80003746:	8526                	mv	a0,s1
    80003748:	aa1ff0ef          	jal	800031e8 <brelse>
      return iget(dev, inum);
    8000374c:	0009059b          	sext.w	a1,s2
    80003750:	8556                	mv	a0,s5
    80003752:	de7ff0ef          	jal	80003538 <iget>
    80003756:	74a2                	ld	s1,40(sp)
    80003758:	7902                	ld	s2,32(sp)
    8000375a:	69e2                	ld	s3,24(sp)
    8000375c:	6a42                	ld	s4,16(sp)
    8000375e:	6aa2                	ld	s5,8(sp)
    80003760:	6b02                	ld	s6,0(sp)
    80003762:	b7d9                	j	80003728 <ialloc+0x80>

0000000080003764 <iupdate>:
{
    80003764:	1101                	addi	sp,sp,-32
    80003766:	ec06                	sd	ra,24(sp)
    80003768:	e822                	sd	s0,16(sp)
    8000376a:	e426                	sd	s1,8(sp)
    8000376c:	e04a                	sd	s2,0(sp)
    8000376e:	1000                	addi	s0,sp,32
    80003770:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003772:	415c                	lw	a5,4(a0)
    80003774:	0047d79b          	srliw	a5,a5,0x4
    80003778:	0001f597          	auipc	a1,0x1f
    8000377c:	b505a583          	lw	a1,-1200(a1) # 800222c8 <sb+0x18>
    80003780:	9dbd                	addw	a1,a1,a5
    80003782:	4108                	lw	a0,0(a0)
    80003784:	95dff0ef          	jal	800030e0 <bread>
    80003788:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000378a:	05850793          	addi	a5,a0,88
    8000378e:	40d8                	lw	a4,4(s1)
    80003790:	8b3d                	andi	a4,a4,15
    80003792:	071a                	slli	a4,a4,0x6
    80003794:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003796:	04449703          	lh	a4,68(s1)
    8000379a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000379e:	04649703          	lh	a4,70(s1)
    800037a2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800037a6:	04849703          	lh	a4,72(s1)
    800037aa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800037ae:	04a49703          	lh	a4,74(s1)
    800037b2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800037b6:	44f8                	lw	a4,76(s1)
    800037b8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800037ba:	03400613          	li	a2,52
    800037be:	05048593          	addi	a1,s1,80
    800037c2:	00c78513          	addi	a0,a5,12
    800037c6:	d6cfd0ef          	jal	80000d32 <memmove>
  log_write(bp);
    800037ca:	854a                	mv	a0,s2
    800037cc:	267000ef          	jal	80004232 <log_write>
  brelse(bp);
    800037d0:	854a                	mv	a0,s2
    800037d2:	a17ff0ef          	jal	800031e8 <brelse>
}
    800037d6:	60e2                	ld	ra,24(sp)
    800037d8:	6442                	ld	s0,16(sp)
    800037da:	64a2                	ld	s1,8(sp)
    800037dc:	6902                	ld	s2,0(sp)
    800037de:	6105                	addi	sp,sp,32
    800037e0:	8082                	ret

00000000800037e2 <idup>:
{
    800037e2:	1101                	addi	sp,sp,-32
    800037e4:	ec06                	sd	ra,24(sp)
    800037e6:	e822                	sd	s0,16(sp)
    800037e8:	e426                	sd	s1,8(sp)
    800037ea:	1000                	addi	s0,sp,32
    800037ec:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037ee:	0001f517          	auipc	a0,0x1f
    800037f2:	ae250513          	addi	a0,a0,-1310 # 800222d0 <itable>
    800037f6:	c0cfd0ef          	jal	80000c02 <acquire>
  ip->ref++;
    800037fa:	449c                	lw	a5,8(s1)
    800037fc:	2785                	addiw	a5,a5,1
    800037fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003800:	0001f517          	auipc	a0,0x1f
    80003804:	ad050513          	addi	a0,a0,-1328 # 800222d0 <itable>
    80003808:	c92fd0ef          	jal	80000c9a <release>
}
    8000380c:	8526                	mv	a0,s1
    8000380e:	60e2                	ld	ra,24(sp)
    80003810:	6442                	ld	s0,16(sp)
    80003812:	64a2                	ld	s1,8(sp)
    80003814:	6105                	addi	sp,sp,32
    80003816:	8082                	ret

0000000080003818 <ilock>:
{
    80003818:	1101                	addi	sp,sp,-32
    8000381a:	ec06                	sd	ra,24(sp)
    8000381c:	e822                	sd	s0,16(sp)
    8000381e:	e426                	sd	s1,8(sp)
    80003820:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003822:	cd19                	beqz	a0,80003840 <ilock+0x28>
    80003824:	84aa                	mv	s1,a0
    80003826:	451c                	lw	a5,8(a0)
    80003828:	00f05c63          	blez	a5,80003840 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000382c:	0541                	addi	a0,a0,16
    8000382e:	30b000ef          	jal	80004338 <acquiresleep>
  if(ip->valid == 0){
    80003832:	40bc                	lw	a5,64(s1)
    80003834:	cf89                	beqz	a5,8000384e <ilock+0x36>
}
    80003836:	60e2                	ld	ra,24(sp)
    80003838:	6442                	ld	s0,16(sp)
    8000383a:	64a2                	ld	s1,8(sp)
    8000383c:	6105                	addi	sp,sp,32
    8000383e:	8082                	ret
    80003840:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003842:	00005517          	auipc	a0,0x5
    80003846:	d6650513          	addi	a0,a0,-666 # 800085a8 <etext+0x5a8>
    8000384a:	f59fc0ef          	jal	800007a2 <panic>
    8000384e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003850:	40dc                	lw	a5,4(s1)
    80003852:	0047d79b          	srliw	a5,a5,0x4
    80003856:	0001f597          	auipc	a1,0x1f
    8000385a:	a725a583          	lw	a1,-1422(a1) # 800222c8 <sb+0x18>
    8000385e:	9dbd                	addw	a1,a1,a5
    80003860:	4088                	lw	a0,0(s1)
    80003862:	87fff0ef          	jal	800030e0 <bread>
    80003866:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003868:	05850593          	addi	a1,a0,88
    8000386c:	40dc                	lw	a5,4(s1)
    8000386e:	8bbd                	andi	a5,a5,15
    80003870:	079a                	slli	a5,a5,0x6
    80003872:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003874:	00059783          	lh	a5,0(a1)
    80003878:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000387c:	00259783          	lh	a5,2(a1)
    80003880:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003884:	00459783          	lh	a5,4(a1)
    80003888:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000388c:	00659783          	lh	a5,6(a1)
    80003890:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003894:	459c                	lw	a5,8(a1)
    80003896:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003898:	03400613          	li	a2,52
    8000389c:	05b1                	addi	a1,a1,12
    8000389e:	05048513          	addi	a0,s1,80
    800038a2:	c90fd0ef          	jal	80000d32 <memmove>
    brelse(bp);
    800038a6:	854a                	mv	a0,s2
    800038a8:	941ff0ef          	jal	800031e8 <brelse>
    ip->valid = 1;
    800038ac:	4785                	li	a5,1
    800038ae:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800038b0:	04449783          	lh	a5,68(s1)
    800038b4:	c399                	beqz	a5,800038ba <ilock+0xa2>
    800038b6:	6902                	ld	s2,0(sp)
    800038b8:	bfbd                	j	80003836 <ilock+0x1e>
      panic("ilock: no type");
    800038ba:	00005517          	auipc	a0,0x5
    800038be:	cf650513          	addi	a0,a0,-778 # 800085b0 <etext+0x5b0>
    800038c2:	ee1fc0ef          	jal	800007a2 <panic>

00000000800038c6 <iunlock>:
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800038d2:	c505                	beqz	a0,800038fa <iunlock+0x34>
    800038d4:	84aa                	mv	s1,a0
    800038d6:	01050913          	addi	s2,a0,16
    800038da:	854a                	mv	a0,s2
    800038dc:	2db000ef          	jal	800043b6 <holdingsleep>
    800038e0:	cd09                	beqz	a0,800038fa <iunlock+0x34>
    800038e2:	449c                	lw	a5,8(s1)
    800038e4:	00f05b63          	blez	a5,800038fa <iunlock+0x34>
  releasesleep(&ip->lock);
    800038e8:	854a                	mv	a0,s2
    800038ea:	295000ef          	jal	8000437e <releasesleep>
}
    800038ee:	60e2                	ld	ra,24(sp)
    800038f0:	6442                	ld	s0,16(sp)
    800038f2:	64a2                	ld	s1,8(sp)
    800038f4:	6902                	ld	s2,0(sp)
    800038f6:	6105                	addi	sp,sp,32
    800038f8:	8082                	ret
    panic("iunlock");
    800038fa:	00005517          	auipc	a0,0x5
    800038fe:	cc650513          	addi	a0,a0,-826 # 800085c0 <etext+0x5c0>
    80003902:	ea1fc0ef          	jal	800007a2 <panic>

0000000080003906 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003906:	7179                	addi	sp,sp,-48
    80003908:	f406                	sd	ra,40(sp)
    8000390a:	f022                	sd	s0,32(sp)
    8000390c:	ec26                	sd	s1,24(sp)
    8000390e:	e84a                	sd	s2,16(sp)
    80003910:	e44e                	sd	s3,8(sp)
    80003912:	1800                	addi	s0,sp,48
    80003914:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003916:	05050493          	addi	s1,a0,80
    8000391a:	08050913          	addi	s2,a0,128
    8000391e:	a021                	j	80003926 <itrunc+0x20>
    80003920:	0491                	addi	s1,s1,4
    80003922:	01248b63          	beq	s1,s2,80003938 <itrunc+0x32>
    if(ip->addrs[i]){
    80003926:	408c                	lw	a1,0(s1)
    80003928:	dde5                	beqz	a1,80003920 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000392a:	0009a503          	lw	a0,0(s3)
    8000392e:	9abff0ef          	jal	800032d8 <bfree>
      ip->addrs[i] = 0;
    80003932:	0004a023          	sw	zero,0(s1)
    80003936:	b7ed                	j	80003920 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003938:	0809a583          	lw	a1,128(s3)
    8000393c:	ed89                	bnez	a1,80003956 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000393e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003942:	854e                	mv	a0,s3
    80003944:	e21ff0ef          	jal	80003764 <iupdate>
}
    80003948:	70a2                	ld	ra,40(sp)
    8000394a:	7402                	ld	s0,32(sp)
    8000394c:	64e2                	ld	s1,24(sp)
    8000394e:	6942                	ld	s2,16(sp)
    80003950:	69a2                	ld	s3,8(sp)
    80003952:	6145                	addi	sp,sp,48
    80003954:	8082                	ret
    80003956:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003958:	0009a503          	lw	a0,0(s3)
    8000395c:	f84ff0ef          	jal	800030e0 <bread>
    80003960:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003962:	05850493          	addi	s1,a0,88
    80003966:	45850913          	addi	s2,a0,1112
    8000396a:	a021                	j	80003972 <itrunc+0x6c>
    8000396c:	0491                	addi	s1,s1,4
    8000396e:	01248963          	beq	s1,s2,80003980 <itrunc+0x7a>
      if(a[j])
    80003972:	408c                	lw	a1,0(s1)
    80003974:	dde5                	beqz	a1,8000396c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003976:	0009a503          	lw	a0,0(s3)
    8000397a:	95fff0ef          	jal	800032d8 <bfree>
    8000397e:	b7fd                	j	8000396c <itrunc+0x66>
    brelse(bp);
    80003980:	8552                	mv	a0,s4
    80003982:	867ff0ef          	jal	800031e8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003986:	0809a583          	lw	a1,128(s3)
    8000398a:	0009a503          	lw	a0,0(s3)
    8000398e:	94bff0ef          	jal	800032d8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003992:	0809a023          	sw	zero,128(s3)
    80003996:	6a02                	ld	s4,0(sp)
    80003998:	b75d                	j	8000393e <itrunc+0x38>

000000008000399a <iput>:
{
    8000399a:	1101                	addi	sp,sp,-32
    8000399c:	ec06                	sd	ra,24(sp)
    8000399e:	e822                	sd	s0,16(sp)
    800039a0:	e426                	sd	s1,8(sp)
    800039a2:	1000                	addi	s0,sp,32
    800039a4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800039a6:	0001f517          	auipc	a0,0x1f
    800039aa:	92a50513          	addi	a0,a0,-1750 # 800222d0 <itable>
    800039ae:	a54fd0ef          	jal	80000c02 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039b2:	4498                	lw	a4,8(s1)
    800039b4:	4785                	li	a5,1
    800039b6:	02f70063          	beq	a4,a5,800039d6 <iput+0x3c>
  ip->ref--;
    800039ba:	449c                	lw	a5,8(s1)
    800039bc:	37fd                	addiw	a5,a5,-1
    800039be:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800039c0:	0001f517          	auipc	a0,0x1f
    800039c4:	91050513          	addi	a0,a0,-1776 # 800222d0 <itable>
    800039c8:	ad2fd0ef          	jal	80000c9a <release>
}
    800039cc:	60e2                	ld	ra,24(sp)
    800039ce:	6442                	ld	s0,16(sp)
    800039d0:	64a2                	ld	s1,8(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039d6:	40bc                	lw	a5,64(s1)
    800039d8:	d3ed                	beqz	a5,800039ba <iput+0x20>
    800039da:	04a49783          	lh	a5,74(s1)
    800039de:	fff1                	bnez	a5,800039ba <iput+0x20>
    800039e0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800039e2:	01048913          	addi	s2,s1,16
    800039e6:	854a                	mv	a0,s2
    800039e8:	151000ef          	jal	80004338 <acquiresleep>
    release(&itable.lock);
    800039ec:	0001f517          	auipc	a0,0x1f
    800039f0:	8e450513          	addi	a0,a0,-1820 # 800222d0 <itable>
    800039f4:	aa6fd0ef          	jal	80000c9a <release>
    itrunc(ip);
    800039f8:	8526                	mv	a0,s1
    800039fa:	f0dff0ef          	jal	80003906 <itrunc>
    ip->type = 0;
    800039fe:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003a02:	8526                	mv	a0,s1
    80003a04:	d61ff0ef          	jal	80003764 <iupdate>
    ip->valid = 0;
    80003a08:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003a0c:	854a                	mv	a0,s2
    80003a0e:	171000ef          	jal	8000437e <releasesleep>
    acquire(&itable.lock);
    80003a12:	0001f517          	auipc	a0,0x1f
    80003a16:	8be50513          	addi	a0,a0,-1858 # 800222d0 <itable>
    80003a1a:	9e8fd0ef          	jal	80000c02 <acquire>
    80003a1e:	6902                	ld	s2,0(sp)
    80003a20:	bf69                	j	800039ba <iput+0x20>

0000000080003a22 <iunlockput>:
{
    80003a22:	1101                	addi	sp,sp,-32
    80003a24:	ec06                	sd	ra,24(sp)
    80003a26:	e822                	sd	s0,16(sp)
    80003a28:	e426                	sd	s1,8(sp)
    80003a2a:	1000                	addi	s0,sp,32
    80003a2c:	84aa                	mv	s1,a0
  iunlock(ip);
    80003a2e:	e99ff0ef          	jal	800038c6 <iunlock>
  iput(ip);
    80003a32:	8526                	mv	a0,s1
    80003a34:	f67ff0ef          	jal	8000399a <iput>
}
    80003a38:	60e2                	ld	ra,24(sp)
    80003a3a:	6442                	ld	s0,16(sp)
    80003a3c:	64a2                	ld	s1,8(sp)
    80003a3e:	6105                	addi	sp,sp,32
    80003a40:	8082                	ret

0000000080003a42 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003a42:	1141                	addi	sp,sp,-16
    80003a44:	e422                	sd	s0,8(sp)
    80003a46:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003a48:	411c                	lw	a5,0(a0)
    80003a4a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003a4c:	415c                	lw	a5,4(a0)
    80003a4e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003a50:	04451783          	lh	a5,68(a0)
    80003a54:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003a58:	04a51783          	lh	a5,74(a0)
    80003a5c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003a60:	04c56783          	lwu	a5,76(a0)
    80003a64:	e99c                	sd	a5,16(a1)
}
    80003a66:	6422                	ld	s0,8(sp)
    80003a68:	0141                	addi	sp,sp,16
    80003a6a:	8082                	ret

0000000080003a6c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003a6c:	457c                	lw	a5,76(a0)
    80003a6e:	0ed7eb63          	bltu	a5,a3,80003b64 <readi+0xf8>
{
    80003a72:	7159                	addi	sp,sp,-112
    80003a74:	f486                	sd	ra,104(sp)
    80003a76:	f0a2                	sd	s0,96(sp)
    80003a78:	eca6                	sd	s1,88(sp)
    80003a7a:	e0d2                	sd	s4,64(sp)
    80003a7c:	fc56                	sd	s5,56(sp)
    80003a7e:	f85a                	sd	s6,48(sp)
    80003a80:	f45e                	sd	s7,40(sp)
    80003a82:	1880                	addi	s0,sp,112
    80003a84:	8b2a                	mv	s6,a0
    80003a86:	8bae                	mv	s7,a1
    80003a88:	8a32                	mv	s4,a2
    80003a8a:	84b6                	mv	s1,a3
    80003a8c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003a8e:	9f35                	addw	a4,a4,a3
    return 0;
    80003a90:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003a92:	0cd76063          	bltu	a4,a3,80003b52 <readi+0xe6>
    80003a96:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003a98:	00e7f463          	bgeu	a5,a4,80003aa0 <readi+0x34>
    n = ip->size - off;
    80003a9c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003aa0:	080a8f63          	beqz	s5,80003b3e <readi+0xd2>
    80003aa4:	e8ca                	sd	s2,80(sp)
    80003aa6:	f062                	sd	s8,32(sp)
    80003aa8:	ec66                	sd	s9,24(sp)
    80003aaa:	e86a                	sd	s10,16(sp)
    80003aac:	e46e                	sd	s11,8(sp)
    80003aae:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003ab0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003ab4:	5c7d                	li	s8,-1
    80003ab6:	a80d                	j	80003ae8 <readi+0x7c>
    80003ab8:	020d1d93          	slli	s11,s10,0x20
    80003abc:	020ddd93          	srli	s11,s11,0x20
    80003ac0:	05890613          	addi	a2,s2,88
    80003ac4:	86ee                	mv	a3,s11
    80003ac6:	963a                	add	a2,a2,a4
    80003ac8:	85d2                	mv	a1,s4
    80003aca:	855e                	mv	a0,s7
    80003acc:	a01fe0ef          	jal	800024cc <either_copyout>
    80003ad0:	05850763          	beq	a0,s8,80003b1e <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003ad4:	854a                	mv	a0,s2
    80003ad6:	f12ff0ef          	jal	800031e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ada:	013d09bb          	addw	s3,s10,s3
    80003ade:	009d04bb          	addw	s1,s10,s1
    80003ae2:	9a6e                	add	s4,s4,s11
    80003ae4:	0559f763          	bgeu	s3,s5,80003b32 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003ae8:	00a4d59b          	srliw	a1,s1,0xa
    80003aec:	855a                	mv	a0,s6
    80003aee:	977ff0ef          	jal	80003464 <bmap>
    80003af2:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003af6:	c5b1                	beqz	a1,80003b42 <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003af8:	000b2503          	lw	a0,0(s6)
    80003afc:	de4ff0ef          	jal	800030e0 <bread>
    80003b00:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b02:	3ff4f713          	andi	a4,s1,1023
    80003b06:	40ec87bb          	subw	a5,s9,a4
    80003b0a:	413a86bb          	subw	a3,s5,s3
    80003b0e:	8d3e                	mv	s10,a5
    80003b10:	2781                	sext.w	a5,a5
    80003b12:	0006861b          	sext.w	a2,a3
    80003b16:	faf671e3          	bgeu	a2,a5,80003ab8 <readi+0x4c>
    80003b1a:	8d36                	mv	s10,a3
    80003b1c:	bf71                	j	80003ab8 <readi+0x4c>
      brelse(bp);
    80003b1e:	854a                	mv	a0,s2
    80003b20:	ec8ff0ef          	jal	800031e8 <brelse>
      tot = -1;
    80003b24:	59fd                	li	s3,-1
      break;
    80003b26:	6946                	ld	s2,80(sp)
    80003b28:	7c02                	ld	s8,32(sp)
    80003b2a:	6ce2                	ld	s9,24(sp)
    80003b2c:	6d42                	ld	s10,16(sp)
    80003b2e:	6da2                	ld	s11,8(sp)
    80003b30:	a831                	j	80003b4c <readi+0xe0>
    80003b32:	6946                	ld	s2,80(sp)
    80003b34:	7c02                	ld	s8,32(sp)
    80003b36:	6ce2                	ld	s9,24(sp)
    80003b38:	6d42                	ld	s10,16(sp)
    80003b3a:	6da2                	ld	s11,8(sp)
    80003b3c:	a801                	j	80003b4c <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b3e:	89d6                	mv	s3,s5
    80003b40:	a031                	j	80003b4c <readi+0xe0>
    80003b42:	6946                	ld	s2,80(sp)
    80003b44:	7c02                	ld	s8,32(sp)
    80003b46:	6ce2                	ld	s9,24(sp)
    80003b48:	6d42                	ld	s10,16(sp)
    80003b4a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003b4c:	0009851b          	sext.w	a0,s3
    80003b50:	69a6                	ld	s3,72(sp)
}
    80003b52:	70a6                	ld	ra,104(sp)
    80003b54:	7406                	ld	s0,96(sp)
    80003b56:	64e6                	ld	s1,88(sp)
    80003b58:	6a06                	ld	s4,64(sp)
    80003b5a:	7ae2                	ld	s5,56(sp)
    80003b5c:	7b42                	ld	s6,48(sp)
    80003b5e:	7ba2                	ld	s7,40(sp)
    80003b60:	6165                	addi	sp,sp,112
    80003b62:	8082                	ret
    return 0;
    80003b64:	4501                	li	a0,0
}
    80003b66:	8082                	ret

0000000080003b68 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b68:	457c                	lw	a5,76(a0)
    80003b6a:	10d7e063          	bltu	a5,a3,80003c6a <writei+0x102>
{
    80003b6e:	7159                	addi	sp,sp,-112
    80003b70:	f486                	sd	ra,104(sp)
    80003b72:	f0a2                	sd	s0,96(sp)
    80003b74:	e8ca                	sd	s2,80(sp)
    80003b76:	e0d2                	sd	s4,64(sp)
    80003b78:	fc56                	sd	s5,56(sp)
    80003b7a:	f85a                	sd	s6,48(sp)
    80003b7c:	f45e                	sd	s7,40(sp)
    80003b7e:	1880                	addi	s0,sp,112
    80003b80:	8aaa                	mv	s5,a0
    80003b82:	8bae                	mv	s7,a1
    80003b84:	8a32                	mv	s4,a2
    80003b86:	8936                	mv	s2,a3
    80003b88:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b8a:	00e687bb          	addw	a5,a3,a4
    80003b8e:	0ed7e063          	bltu	a5,a3,80003c6e <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003b92:	00043737          	lui	a4,0x43
    80003b96:	0cf76e63          	bltu	a4,a5,80003c72 <writei+0x10a>
    80003b9a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003b9c:	0a0b0f63          	beqz	s6,80003c5a <writei+0xf2>
    80003ba0:	eca6                	sd	s1,88(sp)
    80003ba2:	f062                	sd	s8,32(sp)
    80003ba4:	ec66                	sd	s9,24(sp)
    80003ba6:	e86a                	sd	s10,16(sp)
    80003ba8:	e46e                	sd	s11,8(sp)
    80003baa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bac:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003bb0:	5c7d                	li	s8,-1
    80003bb2:	a825                	j	80003bea <writei+0x82>
    80003bb4:	020d1d93          	slli	s11,s10,0x20
    80003bb8:	020ddd93          	srli	s11,s11,0x20
    80003bbc:	05848513          	addi	a0,s1,88
    80003bc0:	86ee                	mv	a3,s11
    80003bc2:	8652                	mv	a2,s4
    80003bc4:	85de                	mv	a1,s7
    80003bc6:	953a                	add	a0,a0,a4
    80003bc8:	94ffe0ef          	jal	80002516 <either_copyin>
    80003bcc:	05850a63          	beq	a0,s8,80003c20 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003bd0:	8526                	mv	a0,s1
    80003bd2:	660000ef          	jal	80004232 <log_write>
    brelse(bp);
    80003bd6:	8526                	mv	a0,s1
    80003bd8:	e10ff0ef          	jal	800031e8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003bdc:	013d09bb          	addw	s3,s10,s3
    80003be0:	012d093b          	addw	s2,s10,s2
    80003be4:	9a6e                	add	s4,s4,s11
    80003be6:	0569f063          	bgeu	s3,s6,80003c26 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003bea:	00a9559b          	srliw	a1,s2,0xa
    80003bee:	8556                	mv	a0,s5
    80003bf0:	875ff0ef          	jal	80003464 <bmap>
    80003bf4:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003bf8:	c59d                	beqz	a1,80003c26 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80003bfa:	000aa503          	lw	a0,0(s5)
    80003bfe:	ce2ff0ef          	jal	800030e0 <bread>
    80003c02:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c04:	3ff97713          	andi	a4,s2,1023
    80003c08:	40ec87bb          	subw	a5,s9,a4
    80003c0c:	413b06bb          	subw	a3,s6,s3
    80003c10:	8d3e                	mv	s10,a5
    80003c12:	2781                	sext.w	a5,a5
    80003c14:	0006861b          	sext.w	a2,a3
    80003c18:	f8f67ee3          	bgeu	a2,a5,80003bb4 <writei+0x4c>
    80003c1c:	8d36                	mv	s10,a3
    80003c1e:	bf59                	j	80003bb4 <writei+0x4c>
      brelse(bp);
    80003c20:	8526                	mv	a0,s1
    80003c22:	dc6ff0ef          	jal	800031e8 <brelse>
  }

  if(off > ip->size)
    80003c26:	04caa783          	lw	a5,76(s5)
    80003c2a:	0327fa63          	bgeu	a5,s2,80003c5e <writei+0xf6>
    ip->size = off;
    80003c2e:	052aa623          	sw	s2,76(s5)
    80003c32:	64e6                	ld	s1,88(sp)
    80003c34:	7c02                	ld	s8,32(sp)
    80003c36:	6ce2                	ld	s9,24(sp)
    80003c38:	6d42                	ld	s10,16(sp)
    80003c3a:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003c3c:	8556                	mv	a0,s5
    80003c3e:	b27ff0ef          	jal	80003764 <iupdate>

  return tot;
    80003c42:	0009851b          	sext.w	a0,s3
    80003c46:	69a6                	ld	s3,72(sp)
}
    80003c48:	70a6                	ld	ra,104(sp)
    80003c4a:	7406                	ld	s0,96(sp)
    80003c4c:	6946                	ld	s2,80(sp)
    80003c4e:	6a06                	ld	s4,64(sp)
    80003c50:	7ae2                	ld	s5,56(sp)
    80003c52:	7b42                	ld	s6,48(sp)
    80003c54:	7ba2                	ld	s7,40(sp)
    80003c56:	6165                	addi	sp,sp,112
    80003c58:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c5a:	89da                	mv	s3,s6
    80003c5c:	b7c5                	j	80003c3c <writei+0xd4>
    80003c5e:	64e6                	ld	s1,88(sp)
    80003c60:	7c02                	ld	s8,32(sp)
    80003c62:	6ce2                	ld	s9,24(sp)
    80003c64:	6d42                	ld	s10,16(sp)
    80003c66:	6da2                	ld	s11,8(sp)
    80003c68:	bfd1                	j	80003c3c <writei+0xd4>
    return -1;
    80003c6a:	557d                	li	a0,-1
}
    80003c6c:	8082                	ret
    return -1;
    80003c6e:	557d                	li	a0,-1
    80003c70:	bfe1                	j	80003c48 <writei+0xe0>
    return -1;
    80003c72:	557d                	li	a0,-1
    80003c74:	bfd1                	j	80003c48 <writei+0xe0>

0000000080003c76 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003c76:	1141                	addi	sp,sp,-16
    80003c78:	e406                	sd	ra,8(sp)
    80003c7a:	e022                	sd	s0,0(sp)
    80003c7c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003c7e:	4639                	li	a2,14
    80003c80:	922fd0ef          	jal	80000da2 <strncmp>
}
    80003c84:	60a2                	ld	ra,8(sp)
    80003c86:	6402                	ld	s0,0(sp)
    80003c88:	0141                	addi	sp,sp,16
    80003c8a:	8082                	ret

0000000080003c8c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003c8c:	7139                	addi	sp,sp,-64
    80003c8e:	fc06                	sd	ra,56(sp)
    80003c90:	f822                	sd	s0,48(sp)
    80003c92:	f426                	sd	s1,40(sp)
    80003c94:	f04a                	sd	s2,32(sp)
    80003c96:	ec4e                	sd	s3,24(sp)
    80003c98:	e852                	sd	s4,16(sp)
    80003c9a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003c9c:	04451703          	lh	a4,68(a0)
    80003ca0:	4785                	li	a5,1
    80003ca2:	00f71a63          	bne	a4,a5,80003cb6 <dirlookup+0x2a>
    80003ca6:	892a                	mv	s2,a0
    80003ca8:	89ae                	mv	s3,a1
    80003caa:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cac:	457c                	lw	a5,76(a0)
    80003cae:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003cb0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cb2:	e39d                	bnez	a5,80003cd8 <dirlookup+0x4c>
    80003cb4:	a095                	j	80003d18 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003cb6:	00005517          	auipc	a0,0x5
    80003cba:	91250513          	addi	a0,a0,-1774 # 800085c8 <etext+0x5c8>
    80003cbe:	ae5fc0ef          	jal	800007a2 <panic>
      panic("dirlookup read");
    80003cc2:	00005517          	auipc	a0,0x5
    80003cc6:	91e50513          	addi	a0,a0,-1762 # 800085e0 <etext+0x5e0>
    80003cca:	ad9fc0ef          	jal	800007a2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003cce:	24c1                	addiw	s1,s1,16
    80003cd0:	04c92783          	lw	a5,76(s2)
    80003cd4:	04f4f163          	bgeu	s1,a5,80003d16 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cd8:	4741                	li	a4,16
    80003cda:	86a6                	mv	a3,s1
    80003cdc:	fc040613          	addi	a2,s0,-64
    80003ce0:	4581                	li	a1,0
    80003ce2:	854a                	mv	a0,s2
    80003ce4:	d89ff0ef          	jal	80003a6c <readi>
    80003ce8:	47c1                	li	a5,16
    80003cea:	fcf51ce3          	bne	a0,a5,80003cc2 <dirlookup+0x36>
    if(de.inum == 0)
    80003cee:	fc045783          	lhu	a5,-64(s0)
    80003cf2:	dff1                	beqz	a5,80003cce <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003cf4:	fc240593          	addi	a1,s0,-62
    80003cf8:	854e                	mv	a0,s3
    80003cfa:	f7dff0ef          	jal	80003c76 <namecmp>
    80003cfe:	f961                	bnez	a0,80003cce <dirlookup+0x42>
      if(poff)
    80003d00:	000a0463          	beqz	s4,80003d08 <dirlookup+0x7c>
        *poff = off;
    80003d04:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003d08:	fc045583          	lhu	a1,-64(s0)
    80003d0c:	00092503          	lw	a0,0(s2)
    80003d10:	829ff0ef          	jal	80003538 <iget>
    80003d14:	a011                	j	80003d18 <dirlookup+0x8c>
  return 0;
    80003d16:	4501                	li	a0,0
}
    80003d18:	70e2                	ld	ra,56(sp)
    80003d1a:	7442                	ld	s0,48(sp)
    80003d1c:	74a2                	ld	s1,40(sp)
    80003d1e:	7902                	ld	s2,32(sp)
    80003d20:	69e2                	ld	s3,24(sp)
    80003d22:	6a42                	ld	s4,16(sp)
    80003d24:	6121                	addi	sp,sp,64
    80003d26:	8082                	ret

0000000080003d28 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003d28:	711d                	addi	sp,sp,-96
    80003d2a:	ec86                	sd	ra,88(sp)
    80003d2c:	e8a2                	sd	s0,80(sp)
    80003d2e:	e4a6                	sd	s1,72(sp)
    80003d30:	e0ca                	sd	s2,64(sp)
    80003d32:	fc4e                	sd	s3,56(sp)
    80003d34:	f852                	sd	s4,48(sp)
    80003d36:	f456                	sd	s5,40(sp)
    80003d38:	f05a                	sd	s6,32(sp)
    80003d3a:	ec5e                	sd	s7,24(sp)
    80003d3c:	e862                	sd	s8,16(sp)
    80003d3e:	e466                	sd	s9,8(sp)
    80003d40:	1080                	addi	s0,sp,96
    80003d42:	84aa                	mv	s1,a0
    80003d44:	8b2e                	mv	s6,a1
    80003d46:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003d48:	00054703          	lbu	a4,0(a0)
    80003d4c:	02f00793          	li	a5,47
    80003d50:	00f70e63          	beq	a4,a5,80003d6c <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003d54:	badfd0ef          	jal	80001900 <myproc>
    80003d58:	15053503          	ld	a0,336(a0)
    80003d5c:	a87ff0ef          	jal	800037e2 <idup>
    80003d60:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003d62:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003d66:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003d68:	4b85                	li	s7,1
    80003d6a:	a871                	j	80003e06 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003d6c:	4585                	li	a1,1
    80003d6e:	4505                	li	a0,1
    80003d70:	fc8ff0ef          	jal	80003538 <iget>
    80003d74:	8a2a                	mv	s4,a0
    80003d76:	b7f5                	j	80003d62 <namex+0x3a>
      iunlockput(ip);
    80003d78:	8552                	mv	a0,s4
    80003d7a:	ca9ff0ef          	jal	80003a22 <iunlockput>
      return 0;
    80003d7e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003d80:	8552                	mv	a0,s4
    80003d82:	60e6                	ld	ra,88(sp)
    80003d84:	6446                	ld	s0,80(sp)
    80003d86:	64a6                	ld	s1,72(sp)
    80003d88:	6906                	ld	s2,64(sp)
    80003d8a:	79e2                	ld	s3,56(sp)
    80003d8c:	7a42                	ld	s4,48(sp)
    80003d8e:	7aa2                	ld	s5,40(sp)
    80003d90:	7b02                	ld	s6,32(sp)
    80003d92:	6be2                	ld	s7,24(sp)
    80003d94:	6c42                	ld	s8,16(sp)
    80003d96:	6ca2                	ld	s9,8(sp)
    80003d98:	6125                	addi	sp,sp,96
    80003d9a:	8082                	ret
      iunlock(ip);
    80003d9c:	8552                	mv	a0,s4
    80003d9e:	b29ff0ef          	jal	800038c6 <iunlock>
      return ip;
    80003da2:	bff9                	j	80003d80 <namex+0x58>
      iunlockput(ip);
    80003da4:	8552                	mv	a0,s4
    80003da6:	c7dff0ef          	jal	80003a22 <iunlockput>
      return 0;
    80003daa:	8a4e                	mv	s4,s3
    80003dac:	bfd1                	j	80003d80 <namex+0x58>
  len = path - s;
    80003dae:	40998633          	sub	a2,s3,s1
    80003db2:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003db6:	099c5063          	bge	s8,s9,80003e36 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003dba:	4639                	li	a2,14
    80003dbc:	85a6                	mv	a1,s1
    80003dbe:	8556                	mv	a0,s5
    80003dc0:	f73fc0ef          	jal	80000d32 <memmove>
    80003dc4:	84ce                	mv	s1,s3
  while(*path == '/')
    80003dc6:	0004c783          	lbu	a5,0(s1)
    80003dca:	01279763          	bne	a5,s2,80003dd8 <namex+0xb0>
    path++;
    80003dce:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003dd0:	0004c783          	lbu	a5,0(s1)
    80003dd4:	ff278de3          	beq	a5,s2,80003dce <namex+0xa6>
    ilock(ip);
    80003dd8:	8552                	mv	a0,s4
    80003dda:	a3fff0ef          	jal	80003818 <ilock>
    if(ip->type != T_DIR){
    80003dde:	044a1783          	lh	a5,68(s4)
    80003de2:	f9779be3          	bne	a5,s7,80003d78 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003de6:	000b0563          	beqz	s6,80003df0 <namex+0xc8>
    80003dea:	0004c783          	lbu	a5,0(s1)
    80003dee:	d7dd                	beqz	a5,80003d9c <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003df0:	4601                	li	a2,0
    80003df2:	85d6                	mv	a1,s5
    80003df4:	8552                	mv	a0,s4
    80003df6:	e97ff0ef          	jal	80003c8c <dirlookup>
    80003dfa:	89aa                	mv	s3,a0
    80003dfc:	d545                	beqz	a0,80003da4 <namex+0x7c>
    iunlockput(ip);
    80003dfe:	8552                	mv	a0,s4
    80003e00:	c23ff0ef          	jal	80003a22 <iunlockput>
    ip = next;
    80003e04:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003e06:	0004c783          	lbu	a5,0(s1)
    80003e0a:	01279763          	bne	a5,s2,80003e18 <namex+0xf0>
    path++;
    80003e0e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003e10:	0004c783          	lbu	a5,0(s1)
    80003e14:	ff278de3          	beq	a5,s2,80003e0e <namex+0xe6>
  if(*path == 0)
    80003e18:	cb8d                	beqz	a5,80003e4a <namex+0x122>
  while(*path != '/' && *path != 0)
    80003e1a:	0004c783          	lbu	a5,0(s1)
    80003e1e:	89a6                	mv	s3,s1
  len = path - s;
    80003e20:	4c81                	li	s9,0
    80003e22:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003e24:	01278963          	beq	a5,s2,80003e36 <namex+0x10e>
    80003e28:	d3d9                	beqz	a5,80003dae <namex+0x86>
    path++;
    80003e2a:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003e2c:	0009c783          	lbu	a5,0(s3)
    80003e30:	ff279ce3          	bne	a5,s2,80003e28 <namex+0x100>
    80003e34:	bfad                	j	80003dae <namex+0x86>
    memmove(name, s, len);
    80003e36:	2601                	sext.w	a2,a2
    80003e38:	85a6                	mv	a1,s1
    80003e3a:	8556                	mv	a0,s5
    80003e3c:	ef7fc0ef          	jal	80000d32 <memmove>
    name[len] = 0;
    80003e40:	9cd6                	add	s9,s9,s5
    80003e42:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003e46:	84ce                	mv	s1,s3
    80003e48:	bfbd                	j	80003dc6 <namex+0x9e>
  if(nameiparent){
    80003e4a:	f20b0be3          	beqz	s6,80003d80 <namex+0x58>
    iput(ip);
    80003e4e:	8552                	mv	a0,s4
    80003e50:	b4bff0ef          	jal	8000399a <iput>
    return 0;
    80003e54:	4a01                	li	s4,0
    80003e56:	b72d                	j	80003d80 <namex+0x58>

0000000080003e58 <dirlink>:
{
    80003e58:	7139                	addi	sp,sp,-64
    80003e5a:	fc06                	sd	ra,56(sp)
    80003e5c:	f822                	sd	s0,48(sp)
    80003e5e:	f04a                	sd	s2,32(sp)
    80003e60:	ec4e                	sd	s3,24(sp)
    80003e62:	e852                	sd	s4,16(sp)
    80003e64:	0080                	addi	s0,sp,64
    80003e66:	892a                	mv	s2,a0
    80003e68:	8a2e                	mv	s4,a1
    80003e6a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e6c:	4601                	li	a2,0
    80003e6e:	e1fff0ef          	jal	80003c8c <dirlookup>
    80003e72:	e535                	bnez	a0,80003ede <dirlink+0x86>
    80003e74:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e76:	04c92483          	lw	s1,76(s2)
    80003e7a:	c48d                	beqz	s1,80003ea4 <dirlink+0x4c>
    80003e7c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003e7e:	4741                	li	a4,16
    80003e80:	86a6                	mv	a3,s1
    80003e82:	fc040613          	addi	a2,s0,-64
    80003e86:	4581                	li	a1,0
    80003e88:	854a                	mv	a0,s2
    80003e8a:	be3ff0ef          	jal	80003a6c <readi>
    80003e8e:	47c1                	li	a5,16
    80003e90:	04f51b63          	bne	a0,a5,80003ee6 <dirlink+0x8e>
    if(de.inum == 0)
    80003e94:	fc045783          	lhu	a5,-64(s0)
    80003e98:	c791                	beqz	a5,80003ea4 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003e9a:	24c1                	addiw	s1,s1,16
    80003e9c:	04c92783          	lw	a5,76(s2)
    80003ea0:	fcf4efe3          	bltu	s1,a5,80003e7e <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003ea4:	4639                	li	a2,14
    80003ea6:	85d2                	mv	a1,s4
    80003ea8:	fc240513          	addi	a0,s0,-62
    80003eac:	f2dfc0ef          	jal	80000dd8 <strncpy>
  de.inum = inum;
    80003eb0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003eb4:	4741                	li	a4,16
    80003eb6:	86a6                	mv	a3,s1
    80003eb8:	fc040613          	addi	a2,s0,-64
    80003ebc:	4581                	li	a1,0
    80003ebe:	854a                	mv	a0,s2
    80003ec0:	ca9ff0ef          	jal	80003b68 <writei>
    80003ec4:	1541                	addi	a0,a0,-16
    80003ec6:	00a03533          	snez	a0,a0
    80003eca:	40a00533          	neg	a0,a0
    80003ece:	74a2                	ld	s1,40(sp)
}
    80003ed0:	70e2                	ld	ra,56(sp)
    80003ed2:	7442                	ld	s0,48(sp)
    80003ed4:	7902                	ld	s2,32(sp)
    80003ed6:	69e2                	ld	s3,24(sp)
    80003ed8:	6a42                	ld	s4,16(sp)
    80003eda:	6121                	addi	sp,sp,64
    80003edc:	8082                	ret
    iput(ip);
    80003ede:	abdff0ef          	jal	8000399a <iput>
    return -1;
    80003ee2:	557d                	li	a0,-1
    80003ee4:	b7f5                	j	80003ed0 <dirlink+0x78>
      panic("dirlink read");
    80003ee6:	00004517          	auipc	a0,0x4
    80003eea:	70a50513          	addi	a0,a0,1802 # 800085f0 <etext+0x5f0>
    80003eee:	8b5fc0ef          	jal	800007a2 <panic>

0000000080003ef2 <namei>:

struct inode*
namei(char *path)
{
    80003ef2:	1101                	addi	sp,sp,-32
    80003ef4:	ec06                	sd	ra,24(sp)
    80003ef6:	e822                	sd	s0,16(sp)
    80003ef8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003efa:	fe040613          	addi	a2,s0,-32
    80003efe:	4581                	li	a1,0
    80003f00:	e29ff0ef          	jal	80003d28 <namex>
}
    80003f04:	60e2                	ld	ra,24(sp)
    80003f06:	6442                	ld	s0,16(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret

0000000080003f0c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003f0c:	1141                	addi	sp,sp,-16
    80003f0e:	e406                	sd	ra,8(sp)
    80003f10:	e022                	sd	s0,0(sp)
    80003f12:	0800                	addi	s0,sp,16
    80003f14:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003f16:	4585                	li	a1,1
    80003f18:	e11ff0ef          	jal	80003d28 <namex>
}
    80003f1c:	60a2                	ld	ra,8(sp)
    80003f1e:	6402                	ld	s0,0(sp)
    80003f20:	0141                	addi	sp,sp,16
    80003f22:	8082                	ret

0000000080003f24 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003f24:	1101                	addi	sp,sp,-32
    80003f26:	ec06                	sd	ra,24(sp)
    80003f28:	e822                	sd	s0,16(sp)
    80003f2a:	e426                	sd	s1,8(sp)
    80003f2c:	e04a                	sd	s2,0(sp)
    80003f2e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003f30:	00020917          	auipc	s2,0x20
    80003f34:	e4890913          	addi	s2,s2,-440 # 80023d78 <log>
    80003f38:	01892583          	lw	a1,24(s2)
    80003f3c:	02892503          	lw	a0,40(s2)
    80003f40:	9a0ff0ef          	jal	800030e0 <bread>
    80003f44:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003f46:	02c92603          	lw	a2,44(s2)
    80003f4a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003f4c:	00c05f63          	blez	a2,80003f6a <write_head+0x46>
    80003f50:	00020717          	auipc	a4,0x20
    80003f54:	e5870713          	addi	a4,a4,-424 # 80023da8 <log+0x30>
    80003f58:	87aa                	mv	a5,a0
    80003f5a:	060a                	slli	a2,a2,0x2
    80003f5c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003f5e:	4314                	lw	a3,0(a4)
    80003f60:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003f62:	0711                	addi	a4,a4,4
    80003f64:	0791                	addi	a5,a5,4
    80003f66:	fec79ce3          	bne	a5,a2,80003f5e <write_head+0x3a>
  }
  bwrite(buf);
    80003f6a:	8526                	mv	a0,s1
    80003f6c:	a4aff0ef          	jal	800031b6 <bwrite>
  brelse(buf);
    80003f70:	8526                	mv	a0,s1
    80003f72:	a76ff0ef          	jal	800031e8 <brelse>
}
    80003f76:	60e2                	ld	ra,24(sp)
    80003f78:	6442                	ld	s0,16(sp)
    80003f7a:	64a2                	ld	s1,8(sp)
    80003f7c:	6902                	ld	s2,0(sp)
    80003f7e:	6105                	addi	sp,sp,32
    80003f80:	8082                	ret

0000000080003f82 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f82:	00020797          	auipc	a5,0x20
    80003f86:	e227a783          	lw	a5,-478(a5) # 80023da4 <log+0x2c>
    80003f8a:	08f05f63          	blez	a5,80004028 <install_trans+0xa6>
{
    80003f8e:	7139                	addi	sp,sp,-64
    80003f90:	fc06                	sd	ra,56(sp)
    80003f92:	f822                	sd	s0,48(sp)
    80003f94:	f426                	sd	s1,40(sp)
    80003f96:	f04a                	sd	s2,32(sp)
    80003f98:	ec4e                	sd	s3,24(sp)
    80003f9a:	e852                	sd	s4,16(sp)
    80003f9c:	e456                	sd	s5,8(sp)
    80003f9e:	e05a                	sd	s6,0(sp)
    80003fa0:	0080                	addi	s0,sp,64
    80003fa2:	8b2a                	mv	s6,a0
    80003fa4:	00020a97          	auipc	s5,0x20
    80003fa8:	e04a8a93          	addi	s5,s5,-508 # 80023da8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fac:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fae:	00020997          	auipc	s3,0x20
    80003fb2:	dca98993          	addi	s3,s3,-566 # 80023d78 <log>
    80003fb6:	a829                	j	80003fd0 <install_trans+0x4e>
    brelse(lbuf);
    80003fb8:	854a                	mv	a0,s2
    80003fba:	a2eff0ef          	jal	800031e8 <brelse>
    brelse(dbuf);
    80003fbe:	8526                	mv	a0,s1
    80003fc0:	a28ff0ef          	jal	800031e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fc4:	2a05                	addiw	s4,s4,1
    80003fc6:	0a91                	addi	s5,s5,4
    80003fc8:	02c9a783          	lw	a5,44(s3)
    80003fcc:	04fa5463          	bge	s4,a5,80004014 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003fd0:	0189a583          	lw	a1,24(s3)
    80003fd4:	014585bb          	addw	a1,a1,s4
    80003fd8:	2585                	addiw	a1,a1,1
    80003fda:	0289a503          	lw	a0,40(s3)
    80003fde:	902ff0ef          	jal	800030e0 <bread>
    80003fe2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003fe4:	000aa583          	lw	a1,0(s5)
    80003fe8:	0289a503          	lw	a0,40(s3)
    80003fec:	8f4ff0ef          	jal	800030e0 <bread>
    80003ff0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ff2:	40000613          	li	a2,1024
    80003ff6:	05890593          	addi	a1,s2,88
    80003ffa:	05850513          	addi	a0,a0,88
    80003ffe:	d35fc0ef          	jal	80000d32 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004002:	8526                	mv	a0,s1
    80004004:	9b2ff0ef          	jal	800031b6 <bwrite>
    if(recovering == 0)
    80004008:	fa0b18e3          	bnez	s6,80003fb8 <install_trans+0x36>
      bunpin(dbuf);
    8000400c:	8526                	mv	a0,s1
    8000400e:	a96ff0ef          	jal	800032a4 <bunpin>
    80004012:	b75d                	j	80003fb8 <install_trans+0x36>
}
    80004014:	70e2                	ld	ra,56(sp)
    80004016:	7442                	ld	s0,48(sp)
    80004018:	74a2                	ld	s1,40(sp)
    8000401a:	7902                	ld	s2,32(sp)
    8000401c:	69e2                	ld	s3,24(sp)
    8000401e:	6a42                	ld	s4,16(sp)
    80004020:	6aa2                	ld	s5,8(sp)
    80004022:	6b02                	ld	s6,0(sp)
    80004024:	6121                	addi	sp,sp,64
    80004026:	8082                	ret
    80004028:	8082                	ret

000000008000402a <initlog>:
{
    8000402a:	7179                	addi	sp,sp,-48
    8000402c:	f406                	sd	ra,40(sp)
    8000402e:	f022                	sd	s0,32(sp)
    80004030:	ec26                	sd	s1,24(sp)
    80004032:	e84a                	sd	s2,16(sp)
    80004034:	e44e                	sd	s3,8(sp)
    80004036:	1800                	addi	s0,sp,48
    80004038:	892a                	mv	s2,a0
    8000403a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000403c:	00020497          	auipc	s1,0x20
    80004040:	d3c48493          	addi	s1,s1,-708 # 80023d78 <log>
    80004044:	00004597          	auipc	a1,0x4
    80004048:	5bc58593          	addi	a1,a1,1468 # 80008600 <etext+0x600>
    8000404c:	8526                	mv	a0,s1
    8000404e:	b35fc0ef          	jal	80000b82 <initlock>
  log.start = sb->logstart;
    80004052:	0149a583          	lw	a1,20(s3)
    80004056:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004058:	0109a783          	lw	a5,16(s3)
    8000405c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000405e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004062:	854a                	mv	a0,s2
    80004064:	87cff0ef          	jal	800030e0 <bread>
  log.lh.n = lh->n;
    80004068:	4d30                	lw	a2,88(a0)
    8000406a:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000406c:	00c05f63          	blez	a2,8000408a <initlog+0x60>
    80004070:	87aa                	mv	a5,a0
    80004072:	00020717          	auipc	a4,0x20
    80004076:	d3670713          	addi	a4,a4,-714 # 80023da8 <log+0x30>
    8000407a:	060a                	slli	a2,a2,0x2
    8000407c:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000407e:	4ff4                	lw	a3,92(a5)
    80004080:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004082:	0791                	addi	a5,a5,4
    80004084:	0711                	addi	a4,a4,4
    80004086:	fec79ce3          	bne	a5,a2,8000407e <initlog+0x54>
  brelse(buf);
    8000408a:	95eff0ef          	jal	800031e8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000408e:	4505                	li	a0,1
    80004090:	ef3ff0ef          	jal	80003f82 <install_trans>
  log.lh.n = 0;
    80004094:	00020797          	auipc	a5,0x20
    80004098:	d007a823          	sw	zero,-752(a5) # 80023da4 <log+0x2c>
  write_head(); // clear the log
    8000409c:	e89ff0ef          	jal	80003f24 <write_head>
}
    800040a0:	70a2                	ld	ra,40(sp)
    800040a2:	7402                	ld	s0,32(sp)
    800040a4:	64e2                	ld	s1,24(sp)
    800040a6:	6942                	ld	s2,16(sp)
    800040a8:	69a2                	ld	s3,8(sp)
    800040aa:	6145                	addi	sp,sp,48
    800040ac:	8082                	ret

00000000800040ae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800040ae:	1101                	addi	sp,sp,-32
    800040b0:	ec06                	sd	ra,24(sp)
    800040b2:	e822                	sd	s0,16(sp)
    800040b4:	e426                	sd	s1,8(sp)
    800040b6:	e04a                	sd	s2,0(sp)
    800040b8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800040ba:	00020517          	auipc	a0,0x20
    800040be:	cbe50513          	addi	a0,a0,-834 # 80023d78 <log>
    800040c2:	b41fc0ef          	jal	80000c02 <acquire>
  while(1){
    if(log.committing){
    800040c6:	00020497          	auipc	s1,0x20
    800040ca:	cb248493          	addi	s1,s1,-846 # 80023d78 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040ce:	4979                	li	s2,30
    800040d0:	a029                	j	800040da <begin_op+0x2c>
      sleep(&log, &log.lock);
    800040d2:	85a6                	mv	a1,s1
    800040d4:	8526                	mv	a0,s1
    800040d6:	81efe0ef          	jal	800020f4 <sleep>
    if(log.committing){
    800040da:	50dc                	lw	a5,36(s1)
    800040dc:	fbfd                	bnez	a5,800040d2 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800040de:	5098                	lw	a4,32(s1)
    800040e0:	2705                	addiw	a4,a4,1
    800040e2:	0027179b          	slliw	a5,a4,0x2
    800040e6:	9fb9                	addw	a5,a5,a4
    800040e8:	0017979b          	slliw	a5,a5,0x1
    800040ec:	54d4                	lw	a3,44(s1)
    800040ee:	9fb5                	addw	a5,a5,a3
    800040f0:	00f95763          	bge	s2,a5,800040fe <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800040f4:	85a6                	mv	a1,s1
    800040f6:	8526                	mv	a0,s1
    800040f8:	ffdfd0ef          	jal	800020f4 <sleep>
    800040fc:	bff9                	j	800040da <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800040fe:	00020517          	auipc	a0,0x20
    80004102:	c7a50513          	addi	a0,a0,-902 # 80023d78 <log>
    80004106:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004108:	b93fc0ef          	jal	80000c9a <release>
      break;
    }
  }
}
    8000410c:	60e2                	ld	ra,24(sp)
    8000410e:	6442                	ld	s0,16(sp)
    80004110:	64a2                	ld	s1,8(sp)
    80004112:	6902                	ld	s2,0(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret

0000000080004118 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004118:	7139                	addi	sp,sp,-64
    8000411a:	fc06                	sd	ra,56(sp)
    8000411c:	f822                	sd	s0,48(sp)
    8000411e:	f426                	sd	s1,40(sp)
    80004120:	f04a                	sd	s2,32(sp)
    80004122:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004124:	00020497          	auipc	s1,0x20
    80004128:	c5448493          	addi	s1,s1,-940 # 80023d78 <log>
    8000412c:	8526                	mv	a0,s1
    8000412e:	ad5fc0ef          	jal	80000c02 <acquire>
  log.outstanding -= 1;
    80004132:	509c                	lw	a5,32(s1)
    80004134:	37fd                	addiw	a5,a5,-1
    80004136:	0007891b          	sext.w	s2,a5
    8000413a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000413c:	50dc                	lw	a5,36(s1)
    8000413e:	ef9d                	bnez	a5,8000417c <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80004140:	04091763          	bnez	s2,8000418e <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80004144:	00020497          	auipc	s1,0x20
    80004148:	c3448493          	addi	s1,s1,-972 # 80023d78 <log>
    8000414c:	4785                	li	a5,1
    8000414e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004150:	8526                	mv	a0,s1
    80004152:	b49fc0ef          	jal	80000c9a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004156:	54dc                	lw	a5,44(s1)
    80004158:	04f04b63          	bgtz	a5,800041ae <end_op+0x96>
    acquire(&log.lock);
    8000415c:	00020497          	auipc	s1,0x20
    80004160:	c1c48493          	addi	s1,s1,-996 # 80023d78 <log>
    80004164:	8526                	mv	a0,s1
    80004166:	a9dfc0ef          	jal	80000c02 <acquire>
    log.committing = 0;
    8000416a:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000416e:	8526                	mv	a0,s1
    80004170:	fd1fd0ef          	jal	80002140 <wakeup>
    release(&log.lock);
    80004174:	8526                	mv	a0,s1
    80004176:	b25fc0ef          	jal	80000c9a <release>
}
    8000417a:	a025                	j	800041a2 <end_op+0x8a>
    8000417c:	ec4e                	sd	s3,24(sp)
    8000417e:	e852                	sd	s4,16(sp)
    80004180:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004182:	00004517          	auipc	a0,0x4
    80004186:	48650513          	addi	a0,a0,1158 # 80008608 <etext+0x608>
    8000418a:	e18fc0ef          	jal	800007a2 <panic>
    wakeup(&log);
    8000418e:	00020497          	auipc	s1,0x20
    80004192:	bea48493          	addi	s1,s1,-1046 # 80023d78 <log>
    80004196:	8526                	mv	a0,s1
    80004198:	fa9fd0ef          	jal	80002140 <wakeup>
  release(&log.lock);
    8000419c:	8526                	mv	a0,s1
    8000419e:	afdfc0ef          	jal	80000c9a <release>
}
    800041a2:	70e2                	ld	ra,56(sp)
    800041a4:	7442                	ld	s0,48(sp)
    800041a6:	74a2                	ld	s1,40(sp)
    800041a8:	7902                	ld	s2,32(sp)
    800041aa:	6121                	addi	sp,sp,64
    800041ac:	8082                	ret
    800041ae:	ec4e                	sd	s3,24(sp)
    800041b0:	e852                	sd	s4,16(sp)
    800041b2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800041b4:	00020a97          	auipc	s5,0x20
    800041b8:	bf4a8a93          	addi	s5,s5,-1036 # 80023da8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800041bc:	00020a17          	auipc	s4,0x20
    800041c0:	bbca0a13          	addi	s4,s4,-1092 # 80023d78 <log>
    800041c4:	018a2583          	lw	a1,24(s4)
    800041c8:	012585bb          	addw	a1,a1,s2
    800041cc:	2585                	addiw	a1,a1,1
    800041ce:	028a2503          	lw	a0,40(s4)
    800041d2:	f0ffe0ef          	jal	800030e0 <bread>
    800041d6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800041d8:	000aa583          	lw	a1,0(s5)
    800041dc:	028a2503          	lw	a0,40(s4)
    800041e0:	f01fe0ef          	jal	800030e0 <bread>
    800041e4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800041e6:	40000613          	li	a2,1024
    800041ea:	05850593          	addi	a1,a0,88
    800041ee:	05848513          	addi	a0,s1,88
    800041f2:	b41fc0ef          	jal	80000d32 <memmove>
    bwrite(to);  // write the log
    800041f6:	8526                	mv	a0,s1
    800041f8:	fbffe0ef          	jal	800031b6 <bwrite>
    brelse(from);
    800041fc:	854e                	mv	a0,s3
    800041fe:	febfe0ef          	jal	800031e8 <brelse>
    brelse(to);
    80004202:	8526                	mv	a0,s1
    80004204:	fe5fe0ef          	jal	800031e8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004208:	2905                	addiw	s2,s2,1
    8000420a:	0a91                	addi	s5,s5,4
    8000420c:	02ca2783          	lw	a5,44(s4)
    80004210:	faf94ae3          	blt	s2,a5,800041c4 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004214:	d11ff0ef          	jal	80003f24 <write_head>
    install_trans(0); // Now install writes to home locations
    80004218:	4501                	li	a0,0
    8000421a:	d69ff0ef          	jal	80003f82 <install_trans>
    log.lh.n = 0;
    8000421e:	00020797          	auipc	a5,0x20
    80004222:	b807a323          	sw	zero,-1146(a5) # 80023da4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004226:	cffff0ef          	jal	80003f24 <write_head>
    8000422a:	69e2                	ld	s3,24(sp)
    8000422c:	6a42                	ld	s4,16(sp)
    8000422e:	6aa2                	ld	s5,8(sp)
    80004230:	b735                	j	8000415c <end_op+0x44>

0000000080004232 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004232:	1101                	addi	sp,sp,-32
    80004234:	ec06                	sd	ra,24(sp)
    80004236:	e822                	sd	s0,16(sp)
    80004238:	e426                	sd	s1,8(sp)
    8000423a:	e04a                	sd	s2,0(sp)
    8000423c:	1000                	addi	s0,sp,32
    8000423e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004240:	00020917          	auipc	s2,0x20
    80004244:	b3890913          	addi	s2,s2,-1224 # 80023d78 <log>
    80004248:	854a                	mv	a0,s2
    8000424a:	9b9fc0ef          	jal	80000c02 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000424e:	02c92603          	lw	a2,44(s2)
    80004252:	47f5                	li	a5,29
    80004254:	06c7c363          	blt	a5,a2,800042ba <log_write+0x88>
    80004258:	00020797          	auipc	a5,0x20
    8000425c:	b3c7a783          	lw	a5,-1220(a5) # 80023d94 <log+0x1c>
    80004260:	37fd                	addiw	a5,a5,-1
    80004262:	04f65c63          	bge	a2,a5,800042ba <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004266:	00020797          	auipc	a5,0x20
    8000426a:	b327a783          	lw	a5,-1230(a5) # 80023d98 <log+0x20>
    8000426e:	04f05c63          	blez	a5,800042c6 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004272:	4781                	li	a5,0
    80004274:	04c05f63          	blez	a2,800042d2 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004278:	44cc                	lw	a1,12(s1)
    8000427a:	00020717          	auipc	a4,0x20
    8000427e:	b2e70713          	addi	a4,a4,-1234 # 80023da8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004282:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004284:	4314                	lw	a3,0(a4)
    80004286:	04b68663          	beq	a3,a1,800042d2 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    8000428a:	2785                	addiw	a5,a5,1
    8000428c:	0711                	addi	a4,a4,4
    8000428e:	fef61be3          	bne	a2,a5,80004284 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004292:	0621                	addi	a2,a2,8
    80004294:	060a                	slli	a2,a2,0x2
    80004296:	00020797          	auipc	a5,0x20
    8000429a:	ae278793          	addi	a5,a5,-1310 # 80023d78 <log>
    8000429e:	97b2                	add	a5,a5,a2
    800042a0:	44d8                	lw	a4,12(s1)
    800042a2:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800042a4:	8526                	mv	a0,s1
    800042a6:	fcbfe0ef          	jal	80003270 <bpin>
    log.lh.n++;
    800042aa:	00020717          	auipc	a4,0x20
    800042ae:	ace70713          	addi	a4,a4,-1330 # 80023d78 <log>
    800042b2:	575c                	lw	a5,44(a4)
    800042b4:	2785                	addiw	a5,a5,1
    800042b6:	d75c                	sw	a5,44(a4)
    800042b8:	a80d                	j	800042ea <log_write+0xb8>
    panic("too big a transaction");
    800042ba:	00004517          	auipc	a0,0x4
    800042be:	35e50513          	addi	a0,a0,862 # 80008618 <etext+0x618>
    800042c2:	ce0fc0ef          	jal	800007a2 <panic>
    panic("log_write outside of trans");
    800042c6:	00004517          	auipc	a0,0x4
    800042ca:	36a50513          	addi	a0,a0,874 # 80008630 <etext+0x630>
    800042ce:	cd4fc0ef          	jal	800007a2 <panic>
  log.lh.block[i] = b->blockno;
    800042d2:	00878693          	addi	a3,a5,8
    800042d6:	068a                	slli	a3,a3,0x2
    800042d8:	00020717          	auipc	a4,0x20
    800042dc:	aa070713          	addi	a4,a4,-1376 # 80023d78 <log>
    800042e0:	9736                	add	a4,a4,a3
    800042e2:	44d4                	lw	a3,12(s1)
    800042e4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800042e6:	faf60fe3          	beq	a2,a5,800042a4 <log_write+0x72>
  }
  release(&log.lock);
    800042ea:	00020517          	auipc	a0,0x20
    800042ee:	a8e50513          	addi	a0,a0,-1394 # 80023d78 <log>
    800042f2:	9a9fc0ef          	jal	80000c9a <release>
}
    800042f6:	60e2                	ld	ra,24(sp)
    800042f8:	6442                	ld	s0,16(sp)
    800042fa:	64a2                	ld	s1,8(sp)
    800042fc:	6902                	ld	s2,0(sp)
    800042fe:	6105                	addi	sp,sp,32
    80004300:	8082                	ret

0000000080004302 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004302:	1101                	addi	sp,sp,-32
    80004304:	ec06                	sd	ra,24(sp)
    80004306:	e822                	sd	s0,16(sp)
    80004308:	e426                	sd	s1,8(sp)
    8000430a:	e04a                	sd	s2,0(sp)
    8000430c:	1000                	addi	s0,sp,32
    8000430e:	84aa                	mv	s1,a0
    80004310:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004312:	00004597          	auipc	a1,0x4
    80004316:	33e58593          	addi	a1,a1,830 # 80008650 <etext+0x650>
    8000431a:	0521                	addi	a0,a0,8
    8000431c:	867fc0ef          	jal	80000b82 <initlock>
  lk->name = name;
    80004320:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004324:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004328:	0204a423          	sw	zero,40(s1)
}
    8000432c:	60e2                	ld	ra,24(sp)
    8000432e:	6442                	ld	s0,16(sp)
    80004330:	64a2                	ld	s1,8(sp)
    80004332:	6902                	ld	s2,0(sp)
    80004334:	6105                	addi	sp,sp,32
    80004336:	8082                	ret

0000000080004338 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004338:	1101                	addi	sp,sp,-32
    8000433a:	ec06                	sd	ra,24(sp)
    8000433c:	e822                	sd	s0,16(sp)
    8000433e:	e426                	sd	s1,8(sp)
    80004340:	e04a                	sd	s2,0(sp)
    80004342:	1000                	addi	s0,sp,32
    80004344:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004346:	00850913          	addi	s2,a0,8
    8000434a:	854a                	mv	a0,s2
    8000434c:	8b7fc0ef          	jal	80000c02 <acquire>
  while (lk->locked) {
    80004350:	409c                	lw	a5,0(s1)
    80004352:	c799                	beqz	a5,80004360 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004354:	85ca                	mv	a1,s2
    80004356:	8526                	mv	a0,s1
    80004358:	d9dfd0ef          	jal	800020f4 <sleep>
  while (lk->locked) {
    8000435c:	409c                	lw	a5,0(s1)
    8000435e:	fbfd                	bnez	a5,80004354 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004360:	4785                	li	a5,1
    80004362:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004364:	d9cfd0ef          	jal	80001900 <myproc>
    80004368:	591c                	lw	a5,48(a0)
    8000436a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000436c:	854a                	mv	a0,s2
    8000436e:	92dfc0ef          	jal	80000c9a <release>
}
    80004372:	60e2                	ld	ra,24(sp)
    80004374:	6442                	ld	s0,16(sp)
    80004376:	64a2                	ld	s1,8(sp)
    80004378:	6902                	ld	s2,0(sp)
    8000437a:	6105                	addi	sp,sp,32
    8000437c:	8082                	ret

000000008000437e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000437e:	1101                	addi	sp,sp,-32
    80004380:	ec06                	sd	ra,24(sp)
    80004382:	e822                	sd	s0,16(sp)
    80004384:	e426                	sd	s1,8(sp)
    80004386:	e04a                	sd	s2,0(sp)
    80004388:	1000                	addi	s0,sp,32
    8000438a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000438c:	00850913          	addi	s2,a0,8
    80004390:	854a                	mv	a0,s2
    80004392:	871fc0ef          	jal	80000c02 <acquire>
  lk->locked = 0;
    80004396:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000439a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000439e:	8526                	mv	a0,s1
    800043a0:	da1fd0ef          	jal	80002140 <wakeup>
  release(&lk->lk);
    800043a4:	854a                	mv	a0,s2
    800043a6:	8f5fc0ef          	jal	80000c9a <release>
}
    800043aa:	60e2                	ld	ra,24(sp)
    800043ac:	6442                	ld	s0,16(sp)
    800043ae:	64a2                	ld	s1,8(sp)
    800043b0:	6902                	ld	s2,0(sp)
    800043b2:	6105                	addi	sp,sp,32
    800043b4:	8082                	ret

00000000800043b6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800043b6:	7179                	addi	sp,sp,-48
    800043b8:	f406                	sd	ra,40(sp)
    800043ba:	f022                	sd	s0,32(sp)
    800043bc:	ec26                	sd	s1,24(sp)
    800043be:	e84a                	sd	s2,16(sp)
    800043c0:	1800                	addi	s0,sp,48
    800043c2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800043c4:	00850913          	addi	s2,a0,8
    800043c8:	854a                	mv	a0,s2
    800043ca:	839fc0ef          	jal	80000c02 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800043ce:	409c                	lw	a5,0(s1)
    800043d0:	ef81                	bnez	a5,800043e8 <holdingsleep+0x32>
    800043d2:	4481                	li	s1,0
  release(&lk->lk);
    800043d4:	854a                	mv	a0,s2
    800043d6:	8c5fc0ef          	jal	80000c9a <release>
  return r;
}
    800043da:	8526                	mv	a0,s1
    800043dc:	70a2                	ld	ra,40(sp)
    800043de:	7402                	ld	s0,32(sp)
    800043e0:	64e2                	ld	s1,24(sp)
    800043e2:	6942                	ld	s2,16(sp)
    800043e4:	6145                	addi	sp,sp,48
    800043e6:	8082                	ret
    800043e8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800043ea:	0284a983          	lw	s3,40(s1)
    800043ee:	d12fd0ef          	jal	80001900 <myproc>
    800043f2:	5904                	lw	s1,48(a0)
    800043f4:	413484b3          	sub	s1,s1,s3
    800043f8:	0014b493          	seqz	s1,s1
    800043fc:	69a2                	ld	s3,8(sp)
    800043fe:	bfd9                	j	800043d4 <holdingsleep+0x1e>

0000000080004400 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004400:	1141                	addi	sp,sp,-16
    80004402:	e406                	sd	ra,8(sp)
    80004404:	e022                	sd	s0,0(sp)
    80004406:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004408:	00004597          	auipc	a1,0x4
    8000440c:	25858593          	addi	a1,a1,600 # 80008660 <etext+0x660>
    80004410:	00020517          	auipc	a0,0x20
    80004414:	ab050513          	addi	a0,a0,-1360 # 80023ec0 <ftable>
    80004418:	f6afc0ef          	jal	80000b82 <initlock>
}
    8000441c:	60a2                	ld	ra,8(sp)
    8000441e:	6402                	ld	s0,0(sp)
    80004420:	0141                	addi	sp,sp,16
    80004422:	8082                	ret

0000000080004424 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004424:	1101                	addi	sp,sp,-32
    80004426:	ec06                	sd	ra,24(sp)
    80004428:	e822                	sd	s0,16(sp)
    8000442a:	e426                	sd	s1,8(sp)
    8000442c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000442e:	00020517          	auipc	a0,0x20
    80004432:	a9250513          	addi	a0,a0,-1390 # 80023ec0 <ftable>
    80004436:	fccfc0ef          	jal	80000c02 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000443a:	00020497          	auipc	s1,0x20
    8000443e:	a9e48493          	addi	s1,s1,-1378 # 80023ed8 <ftable+0x18>
    80004442:	00021717          	auipc	a4,0x21
    80004446:	a3670713          	addi	a4,a4,-1482 # 80024e78 <disk>
    if(f->ref == 0){
    8000444a:	40dc                	lw	a5,4(s1)
    8000444c:	cf89                	beqz	a5,80004466 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000444e:	02848493          	addi	s1,s1,40
    80004452:	fee49ce3          	bne	s1,a4,8000444a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004456:	00020517          	auipc	a0,0x20
    8000445a:	a6a50513          	addi	a0,a0,-1430 # 80023ec0 <ftable>
    8000445e:	83dfc0ef          	jal	80000c9a <release>
  return 0;
    80004462:	4481                	li	s1,0
    80004464:	a809                	j	80004476 <filealloc+0x52>
      f->ref = 1;
    80004466:	4785                	li	a5,1
    80004468:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000446a:	00020517          	auipc	a0,0x20
    8000446e:	a5650513          	addi	a0,a0,-1450 # 80023ec0 <ftable>
    80004472:	829fc0ef          	jal	80000c9a <release>
}
    80004476:	8526                	mv	a0,s1
    80004478:	60e2                	ld	ra,24(sp)
    8000447a:	6442                	ld	s0,16(sp)
    8000447c:	64a2                	ld	s1,8(sp)
    8000447e:	6105                	addi	sp,sp,32
    80004480:	8082                	ret

0000000080004482 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004482:	1101                	addi	sp,sp,-32
    80004484:	ec06                	sd	ra,24(sp)
    80004486:	e822                	sd	s0,16(sp)
    80004488:	e426                	sd	s1,8(sp)
    8000448a:	1000                	addi	s0,sp,32
    8000448c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000448e:	00020517          	auipc	a0,0x20
    80004492:	a3250513          	addi	a0,a0,-1486 # 80023ec0 <ftable>
    80004496:	f6cfc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    8000449a:	40dc                	lw	a5,4(s1)
    8000449c:	02f05063          	blez	a5,800044bc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800044a0:	2785                	addiw	a5,a5,1
    800044a2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800044a4:	00020517          	auipc	a0,0x20
    800044a8:	a1c50513          	addi	a0,a0,-1508 # 80023ec0 <ftable>
    800044ac:	feefc0ef          	jal	80000c9a <release>
  return f;
}
    800044b0:	8526                	mv	a0,s1
    800044b2:	60e2                	ld	ra,24(sp)
    800044b4:	6442                	ld	s0,16(sp)
    800044b6:	64a2                	ld	s1,8(sp)
    800044b8:	6105                	addi	sp,sp,32
    800044ba:	8082                	ret
    panic("filedup");
    800044bc:	00004517          	auipc	a0,0x4
    800044c0:	1ac50513          	addi	a0,a0,428 # 80008668 <etext+0x668>
    800044c4:	adefc0ef          	jal	800007a2 <panic>

00000000800044c8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800044c8:	7139                	addi	sp,sp,-64
    800044ca:	fc06                	sd	ra,56(sp)
    800044cc:	f822                	sd	s0,48(sp)
    800044ce:	f426                	sd	s1,40(sp)
    800044d0:	0080                	addi	s0,sp,64
    800044d2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044d4:	00020517          	auipc	a0,0x20
    800044d8:	9ec50513          	addi	a0,a0,-1556 # 80023ec0 <ftable>
    800044dc:	f26fc0ef          	jal	80000c02 <acquire>
  if(f->ref < 1)
    800044e0:	40dc                	lw	a5,4(s1)
    800044e2:	04f05a63          	blez	a5,80004536 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800044e6:	37fd                	addiw	a5,a5,-1
    800044e8:	0007871b          	sext.w	a4,a5
    800044ec:	c0dc                	sw	a5,4(s1)
    800044ee:	04e04e63          	bgtz	a4,8000454a <fileclose+0x82>
    800044f2:	f04a                	sd	s2,32(sp)
    800044f4:	ec4e                	sd	s3,24(sp)
    800044f6:	e852                	sd	s4,16(sp)
    800044f8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044fa:	0004a903          	lw	s2,0(s1)
    800044fe:	0094ca83          	lbu	s5,9(s1)
    80004502:	0104ba03          	ld	s4,16(s1)
    80004506:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000450a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000450e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004512:	00020517          	auipc	a0,0x20
    80004516:	9ae50513          	addi	a0,a0,-1618 # 80023ec0 <ftable>
    8000451a:	f80fc0ef          	jal	80000c9a <release>

  if(ff.type == FD_PIPE){
    8000451e:	4785                	li	a5,1
    80004520:	04f90063          	beq	s2,a5,80004560 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004524:	3979                	addiw	s2,s2,-2
    80004526:	4785                	li	a5,1
    80004528:	0527f563          	bgeu	a5,s2,80004572 <fileclose+0xaa>
    8000452c:	7902                	ld	s2,32(sp)
    8000452e:	69e2                	ld	s3,24(sp)
    80004530:	6a42                	ld	s4,16(sp)
    80004532:	6aa2                	ld	s5,8(sp)
    80004534:	a00d                	j	80004556 <fileclose+0x8e>
    80004536:	f04a                	sd	s2,32(sp)
    80004538:	ec4e                	sd	s3,24(sp)
    8000453a:	e852                	sd	s4,16(sp)
    8000453c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000453e:	00004517          	auipc	a0,0x4
    80004542:	13250513          	addi	a0,a0,306 # 80008670 <etext+0x670>
    80004546:	a5cfc0ef          	jal	800007a2 <panic>
    release(&ftable.lock);
    8000454a:	00020517          	auipc	a0,0x20
    8000454e:	97650513          	addi	a0,a0,-1674 # 80023ec0 <ftable>
    80004552:	f48fc0ef          	jal	80000c9a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004556:	70e2                	ld	ra,56(sp)
    80004558:	7442                	ld	s0,48(sp)
    8000455a:	74a2                	ld	s1,40(sp)
    8000455c:	6121                	addi	sp,sp,64
    8000455e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004560:	85d6                	mv	a1,s5
    80004562:	8552                	mv	a0,s4
    80004564:	336000ef          	jal	8000489a <pipeclose>
    80004568:	7902                	ld	s2,32(sp)
    8000456a:	69e2                	ld	s3,24(sp)
    8000456c:	6a42                	ld	s4,16(sp)
    8000456e:	6aa2                	ld	s5,8(sp)
    80004570:	b7dd                	j	80004556 <fileclose+0x8e>
    begin_op();
    80004572:	b3dff0ef          	jal	800040ae <begin_op>
    iput(ff.ip);
    80004576:	854e                	mv	a0,s3
    80004578:	c22ff0ef          	jal	8000399a <iput>
    end_op();
    8000457c:	b9dff0ef          	jal	80004118 <end_op>
    80004580:	7902                	ld	s2,32(sp)
    80004582:	69e2                	ld	s3,24(sp)
    80004584:	6a42                	ld	s4,16(sp)
    80004586:	6aa2                	ld	s5,8(sp)
    80004588:	b7f9                	j	80004556 <fileclose+0x8e>

000000008000458a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000458a:	715d                	addi	sp,sp,-80
    8000458c:	e486                	sd	ra,72(sp)
    8000458e:	e0a2                	sd	s0,64(sp)
    80004590:	fc26                	sd	s1,56(sp)
    80004592:	f44e                	sd	s3,40(sp)
    80004594:	0880                	addi	s0,sp,80
    80004596:	84aa                	mv	s1,a0
    80004598:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    8000459a:	b66fd0ef          	jal	80001900 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000459e:	409c                	lw	a5,0(s1)
    800045a0:	37f9                	addiw	a5,a5,-2
    800045a2:	4705                	li	a4,1
    800045a4:	04f76063          	bltu	a4,a5,800045e4 <filestat+0x5a>
    800045a8:	f84a                	sd	s2,48(sp)
    800045aa:	892a                	mv	s2,a0
    ilock(f->ip);
    800045ac:	6c88                	ld	a0,24(s1)
    800045ae:	a6aff0ef          	jal	80003818 <ilock>
    stati(f->ip, &st);
    800045b2:	fb840593          	addi	a1,s0,-72
    800045b6:	6c88                	ld	a0,24(s1)
    800045b8:	c8aff0ef          	jal	80003a42 <stati>
    iunlock(f->ip);
    800045bc:	6c88                	ld	a0,24(s1)
    800045be:	b08ff0ef          	jal	800038c6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045c2:	46e1                	li	a3,24
    800045c4:	fb840613          	addi	a2,s0,-72
    800045c8:	85ce                	mv	a1,s3
    800045ca:	05093503          	ld	a0,80(s2)
    800045ce:	fa5fc0ef          	jal	80001572 <copyout>
    800045d2:	41f5551b          	sraiw	a0,a0,0x1f
    800045d6:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800045d8:	60a6                	ld	ra,72(sp)
    800045da:	6406                	ld	s0,64(sp)
    800045dc:	74e2                	ld	s1,56(sp)
    800045de:	79a2                	ld	s3,40(sp)
    800045e0:	6161                	addi	sp,sp,80
    800045e2:	8082                	ret
  return -1;
    800045e4:	557d                	li	a0,-1
    800045e6:	bfcd                	j	800045d8 <filestat+0x4e>

00000000800045e8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045e8:	7179                	addi	sp,sp,-48
    800045ea:	f406                	sd	ra,40(sp)
    800045ec:	f022                	sd	s0,32(sp)
    800045ee:	e84a                	sd	s2,16(sp)
    800045f0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045f2:	00854783          	lbu	a5,8(a0)
    800045f6:	cfd1                	beqz	a5,80004692 <fileread+0xaa>
    800045f8:	ec26                	sd	s1,24(sp)
    800045fa:	e44e                	sd	s3,8(sp)
    800045fc:	84aa                	mv	s1,a0
    800045fe:	89ae                	mv	s3,a1
    80004600:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004602:	411c                	lw	a5,0(a0)
    80004604:	4705                	li	a4,1
    80004606:	04e78363          	beq	a5,a4,8000464c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000460a:	470d                	li	a4,3
    8000460c:	04e78763          	beq	a5,a4,8000465a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004610:	4709                	li	a4,2
    80004612:	06e79a63          	bne	a5,a4,80004686 <fileread+0x9e>
    ilock(f->ip);
    80004616:	6d08                	ld	a0,24(a0)
    80004618:	a00ff0ef          	jal	80003818 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000461c:	874a                	mv	a4,s2
    8000461e:	5094                	lw	a3,32(s1)
    80004620:	864e                	mv	a2,s3
    80004622:	4585                	li	a1,1
    80004624:	6c88                	ld	a0,24(s1)
    80004626:	c46ff0ef          	jal	80003a6c <readi>
    8000462a:	892a                	mv	s2,a0
    8000462c:	00a05563          	blez	a0,80004636 <fileread+0x4e>
      f->off += r;
    80004630:	509c                	lw	a5,32(s1)
    80004632:	9fa9                	addw	a5,a5,a0
    80004634:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004636:	6c88                	ld	a0,24(s1)
    80004638:	a8eff0ef          	jal	800038c6 <iunlock>
    8000463c:	64e2                	ld	s1,24(sp)
    8000463e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004640:	854a                	mv	a0,s2
    80004642:	70a2                	ld	ra,40(sp)
    80004644:	7402                	ld	s0,32(sp)
    80004646:	6942                	ld	s2,16(sp)
    80004648:	6145                	addi	sp,sp,48
    8000464a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000464c:	6908                	ld	a0,16(a0)
    8000464e:	388000ef          	jal	800049d6 <piperead>
    80004652:	892a                	mv	s2,a0
    80004654:	64e2                	ld	s1,24(sp)
    80004656:	69a2                	ld	s3,8(sp)
    80004658:	b7e5                	j	80004640 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000465a:	02451783          	lh	a5,36(a0)
    8000465e:	03079693          	slli	a3,a5,0x30
    80004662:	92c1                	srli	a3,a3,0x30
    80004664:	4725                	li	a4,9
    80004666:	02d76863          	bltu	a4,a3,80004696 <fileread+0xae>
    8000466a:	0792                	slli	a5,a5,0x4
    8000466c:	0001f717          	auipc	a4,0x1f
    80004670:	7b470713          	addi	a4,a4,1972 # 80023e20 <devsw>
    80004674:	97ba                	add	a5,a5,a4
    80004676:	639c                	ld	a5,0(a5)
    80004678:	c39d                	beqz	a5,8000469e <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    8000467a:	4505                	li	a0,1
    8000467c:	9782                	jalr	a5
    8000467e:	892a                	mv	s2,a0
    80004680:	64e2                	ld	s1,24(sp)
    80004682:	69a2                	ld	s3,8(sp)
    80004684:	bf75                	j	80004640 <fileread+0x58>
    panic("fileread");
    80004686:	00004517          	auipc	a0,0x4
    8000468a:	ffa50513          	addi	a0,a0,-6 # 80008680 <etext+0x680>
    8000468e:	914fc0ef          	jal	800007a2 <panic>
    return -1;
    80004692:	597d                	li	s2,-1
    80004694:	b775                	j	80004640 <fileread+0x58>
      return -1;
    80004696:	597d                	li	s2,-1
    80004698:	64e2                	ld	s1,24(sp)
    8000469a:	69a2                	ld	s3,8(sp)
    8000469c:	b755                	j	80004640 <fileread+0x58>
    8000469e:	597d                	li	s2,-1
    800046a0:	64e2                	ld	s1,24(sp)
    800046a2:	69a2                	ld	s3,8(sp)
    800046a4:	bf71                	j	80004640 <fileread+0x58>

00000000800046a6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800046a6:	00954783          	lbu	a5,9(a0)
    800046aa:	10078b63          	beqz	a5,800047c0 <filewrite+0x11a>
{
    800046ae:	715d                	addi	sp,sp,-80
    800046b0:	e486                	sd	ra,72(sp)
    800046b2:	e0a2                	sd	s0,64(sp)
    800046b4:	f84a                	sd	s2,48(sp)
    800046b6:	f052                	sd	s4,32(sp)
    800046b8:	e85a                	sd	s6,16(sp)
    800046ba:	0880                	addi	s0,sp,80
    800046bc:	892a                	mv	s2,a0
    800046be:	8b2e                	mv	s6,a1
    800046c0:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046c2:	411c                	lw	a5,0(a0)
    800046c4:	4705                	li	a4,1
    800046c6:	02e78763          	beq	a5,a4,800046f4 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046ca:	470d                	li	a4,3
    800046cc:	02e78863          	beq	a5,a4,800046fc <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046d0:	4709                	li	a4,2
    800046d2:	0ce79c63          	bne	a5,a4,800047aa <filewrite+0x104>
    800046d6:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046d8:	0ac05863          	blez	a2,80004788 <filewrite+0xe2>
    800046dc:	fc26                	sd	s1,56(sp)
    800046de:	ec56                	sd	s5,24(sp)
    800046e0:	e45e                	sd	s7,8(sp)
    800046e2:	e062                	sd	s8,0(sp)
    int i = 0;
    800046e4:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800046e6:	6b85                	lui	s7,0x1
    800046e8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800046ec:	6c05                	lui	s8,0x1
    800046ee:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800046f2:	a8b5                	j	8000476e <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800046f4:	6908                	ld	a0,16(a0)
    800046f6:	1fc000ef          	jal	800048f2 <pipewrite>
    800046fa:	a04d                	j	8000479c <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046fc:	02451783          	lh	a5,36(a0)
    80004700:	03079693          	slli	a3,a5,0x30
    80004704:	92c1                	srli	a3,a3,0x30
    80004706:	4725                	li	a4,9
    80004708:	0ad76e63          	bltu	a4,a3,800047c4 <filewrite+0x11e>
    8000470c:	0792                	slli	a5,a5,0x4
    8000470e:	0001f717          	auipc	a4,0x1f
    80004712:	71270713          	addi	a4,a4,1810 # 80023e20 <devsw>
    80004716:	97ba                	add	a5,a5,a4
    80004718:	679c                	ld	a5,8(a5)
    8000471a:	c7dd                	beqz	a5,800047c8 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000471c:	4505                	li	a0,1
    8000471e:	9782                	jalr	a5
    80004720:	a8b5                	j	8000479c <filewrite+0xf6>
      if(n1 > max)
    80004722:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004726:	989ff0ef          	jal	800040ae <begin_op>
      ilock(f->ip);
    8000472a:	01893503          	ld	a0,24(s2)
    8000472e:	8eaff0ef          	jal	80003818 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004732:	8756                	mv	a4,s5
    80004734:	02092683          	lw	a3,32(s2)
    80004738:	01698633          	add	a2,s3,s6
    8000473c:	4585                	li	a1,1
    8000473e:	01893503          	ld	a0,24(s2)
    80004742:	c26ff0ef          	jal	80003b68 <writei>
    80004746:	84aa                	mv	s1,a0
    80004748:	00a05763          	blez	a0,80004756 <filewrite+0xb0>
        f->off += r;
    8000474c:	02092783          	lw	a5,32(s2)
    80004750:	9fa9                	addw	a5,a5,a0
    80004752:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004756:	01893503          	ld	a0,24(s2)
    8000475a:	96cff0ef          	jal	800038c6 <iunlock>
      end_op();
    8000475e:	9bbff0ef          	jal	80004118 <end_op>

      if(r != n1){
    80004762:	029a9563          	bne	s5,s1,8000478c <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004766:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000476a:	0149da63          	bge	s3,s4,8000477e <filewrite+0xd8>
      int n1 = n - i;
    8000476e:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004772:	0004879b          	sext.w	a5,s1
    80004776:	fafbd6e3          	bge	s7,a5,80004722 <filewrite+0x7c>
    8000477a:	84e2                	mv	s1,s8
    8000477c:	b75d                	j	80004722 <filewrite+0x7c>
    8000477e:	74e2                	ld	s1,56(sp)
    80004780:	6ae2                	ld	s5,24(sp)
    80004782:	6ba2                	ld	s7,8(sp)
    80004784:	6c02                	ld	s8,0(sp)
    80004786:	a039                	j	80004794 <filewrite+0xee>
    int i = 0;
    80004788:	4981                	li	s3,0
    8000478a:	a029                	j	80004794 <filewrite+0xee>
    8000478c:	74e2                	ld	s1,56(sp)
    8000478e:	6ae2                	ld	s5,24(sp)
    80004790:	6ba2                	ld	s7,8(sp)
    80004792:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004794:	033a1c63          	bne	s4,s3,800047cc <filewrite+0x126>
    80004798:	8552                	mv	a0,s4
    8000479a:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000479c:	60a6                	ld	ra,72(sp)
    8000479e:	6406                	ld	s0,64(sp)
    800047a0:	7942                	ld	s2,48(sp)
    800047a2:	7a02                	ld	s4,32(sp)
    800047a4:	6b42                	ld	s6,16(sp)
    800047a6:	6161                	addi	sp,sp,80
    800047a8:	8082                	ret
    800047aa:	fc26                	sd	s1,56(sp)
    800047ac:	f44e                	sd	s3,40(sp)
    800047ae:	ec56                	sd	s5,24(sp)
    800047b0:	e45e                	sd	s7,8(sp)
    800047b2:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800047b4:	00004517          	auipc	a0,0x4
    800047b8:	edc50513          	addi	a0,a0,-292 # 80008690 <etext+0x690>
    800047bc:	fe7fb0ef          	jal	800007a2 <panic>
    return -1;
    800047c0:	557d                	li	a0,-1
}
    800047c2:	8082                	ret
      return -1;
    800047c4:	557d                	li	a0,-1
    800047c6:	bfd9                	j	8000479c <filewrite+0xf6>
    800047c8:	557d                	li	a0,-1
    800047ca:	bfc9                	j	8000479c <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800047cc:	557d                	li	a0,-1
    800047ce:	79a2                	ld	s3,40(sp)
    800047d0:	b7f1                	j	8000479c <filewrite+0xf6>

00000000800047d2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047d2:	7179                	addi	sp,sp,-48
    800047d4:	f406                	sd	ra,40(sp)
    800047d6:	f022                	sd	s0,32(sp)
    800047d8:	ec26                	sd	s1,24(sp)
    800047da:	e052                	sd	s4,0(sp)
    800047dc:	1800                	addi	s0,sp,48
    800047de:	84aa                	mv	s1,a0
    800047e0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800047e2:	0005b023          	sd	zero,0(a1)
    800047e6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800047ea:	c3bff0ef          	jal	80004424 <filealloc>
    800047ee:	e088                	sd	a0,0(s1)
    800047f0:	c549                	beqz	a0,8000487a <pipealloc+0xa8>
    800047f2:	c33ff0ef          	jal	80004424 <filealloc>
    800047f6:	00aa3023          	sd	a0,0(s4)
    800047fa:	cd25                	beqz	a0,80004872 <pipealloc+0xa0>
    800047fc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800047fe:	b34fc0ef          	jal	80000b32 <kalloc>
    80004802:	892a                	mv	s2,a0
    80004804:	c12d                	beqz	a0,80004866 <pipealloc+0x94>
    80004806:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004808:	4985                	li	s3,1
    8000480a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000480e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004812:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004816:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000481a:	00004597          	auipc	a1,0x4
    8000481e:	e8658593          	addi	a1,a1,-378 # 800086a0 <etext+0x6a0>
    80004822:	b60fc0ef          	jal	80000b82 <initlock>
  (*f0)->type = FD_PIPE;
    80004826:	609c                	ld	a5,0(s1)
    80004828:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000482c:	609c                	ld	a5,0(s1)
    8000482e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004832:	609c                	ld	a5,0(s1)
    80004834:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004838:	609c                	ld	a5,0(s1)
    8000483a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000483e:	000a3783          	ld	a5,0(s4)
    80004842:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004846:	000a3783          	ld	a5,0(s4)
    8000484a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000484e:	000a3783          	ld	a5,0(s4)
    80004852:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004856:	000a3783          	ld	a5,0(s4)
    8000485a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000485e:	4501                	li	a0,0
    80004860:	6942                	ld	s2,16(sp)
    80004862:	69a2                	ld	s3,8(sp)
    80004864:	a01d                	j	8000488a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004866:	6088                	ld	a0,0(s1)
    80004868:	c119                	beqz	a0,8000486e <pipealloc+0x9c>
    8000486a:	6942                	ld	s2,16(sp)
    8000486c:	a029                	j	80004876 <pipealloc+0xa4>
    8000486e:	6942                	ld	s2,16(sp)
    80004870:	a029                	j	8000487a <pipealloc+0xa8>
    80004872:	6088                	ld	a0,0(s1)
    80004874:	c10d                	beqz	a0,80004896 <pipealloc+0xc4>
    fileclose(*f0);
    80004876:	c53ff0ef          	jal	800044c8 <fileclose>
  if(*f1)
    8000487a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000487e:	557d                	li	a0,-1
  if(*f1)
    80004880:	c789                	beqz	a5,8000488a <pipealloc+0xb8>
    fileclose(*f1);
    80004882:	853e                	mv	a0,a5
    80004884:	c45ff0ef          	jal	800044c8 <fileclose>
  return -1;
    80004888:	557d                	li	a0,-1
}
    8000488a:	70a2                	ld	ra,40(sp)
    8000488c:	7402                	ld	s0,32(sp)
    8000488e:	64e2                	ld	s1,24(sp)
    80004890:	6a02                	ld	s4,0(sp)
    80004892:	6145                	addi	sp,sp,48
    80004894:	8082                	ret
  return -1;
    80004896:	557d                	li	a0,-1
    80004898:	bfcd                	j	8000488a <pipealloc+0xb8>

000000008000489a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000489a:	1101                	addi	sp,sp,-32
    8000489c:	ec06                	sd	ra,24(sp)
    8000489e:	e822                	sd	s0,16(sp)
    800048a0:	e426                	sd	s1,8(sp)
    800048a2:	e04a                	sd	s2,0(sp)
    800048a4:	1000                	addi	s0,sp,32
    800048a6:	84aa                	mv	s1,a0
    800048a8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048aa:	b58fc0ef          	jal	80000c02 <acquire>
  if(writable){
    800048ae:	02090763          	beqz	s2,800048dc <pipeclose+0x42>
    pi->writeopen = 0;
    800048b2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048b6:	21848513          	addi	a0,s1,536
    800048ba:	887fd0ef          	jal	80002140 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048be:	2204b783          	ld	a5,544(s1)
    800048c2:	e785                	bnez	a5,800048ea <pipeclose+0x50>
    release(&pi->lock);
    800048c4:	8526                	mv	a0,s1
    800048c6:	bd4fc0ef          	jal	80000c9a <release>
    kfree((char*)pi);
    800048ca:	8526                	mv	a0,s1
    800048cc:	984fc0ef          	jal	80000a50 <kfree>
  } else
    release(&pi->lock);
}
    800048d0:	60e2                	ld	ra,24(sp)
    800048d2:	6442                	ld	s0,16(sp)
    800048d4:	64a2                	ld	s1,8(sp)
    800048d6:	6902                	ld	s2,0(sp)
    800048d8:	6105                	addi	sp,sp,32
    800048da:	8082                	ret
    pi->readopen = 0;
    800048dc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800048e0:	21c48513          	addi	a0,s1,540
    800048e4:	85dfd0ef          	jal	80002140 <wakeup>
    800048e8:	bfd9                	j	800048be <pipeclose+0x24>
    release(&pi->lock);
    800048ea:	8526                	mv	a0,s1
    800048ec:	baefc0ef          	jal	80000c9a <release>
}
    800048f0:	b7c5                	j	800048d0 <pipeclose+0x36>

00000000800048f2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800048f2:	711d                	addi	sp,sp,-96
    800048f4:	ec86                	sd	ra,88(sp)
    800048f6:	e8a2                	sd	s0,80(sp)
    800048f8:	e4a6                	sd	s1,72(sp)
    800048fa:	e0ca                	sd	s2,64(sp)
    800048fc:	fc4e                	sd	s3,56(sp)
    800048fe:	f852                	sd	s4,48(sp)
    80004900:	f456                	sd	s5,40(sp)
    80004902:	1080                	addi	s0,sp,96
    80004904:	84aa                	mv	s1,a0
    80004906:	8aae                	mv	s5,a1
    80004908:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000490a:	ff7fc0ef          	jal	80001900 <myproc>
    8000490e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004910:	8526                	mv	a0,s1
    80004912:	af0fc0ef          	jal	80000c02 <acquire>
  while(i < n){
    80004916:	0b405a63          	blez	s4,800049ca <pipewrite+0xd8>
    8000491a:	f05a                	sd	s6,32(sp)
    8000491c:	ec5e                	sd	s7,24(sp)
    8000491e:	e862                	sd	s8,16(sp)
  int i = 0;
    80004920:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004922:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004924:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004928:	21c48b93          	addi	s7,s1,540
    8000492c:	a81d                	j	80004962 <pipewrite+0x70>
      release(&pi->lock);
    8000492e:	8526                	mv	a0,s1
    80004930:	b6afc0ef          	jal	80000c9a <release>
      return -1;
    80004934:	597d                	li	s2,-1
    80004936:	7b02                	ld	s6,32(sp)
    80004938:	6be2                	ld	s7,24(sp)
    8000493a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000493c:	854a                	mv	a0,s2
    8000493e:	60e6                	ld	ra,88(sp)
    80004940:	6446                	ld	s0,80(sp)
    80004942:	64a6                	ld	s1,72(sp)
    80004944:	6906                	ld	s2,64(sp)
    80004946:	79e2                	ld	s3,56(sp)
    80004948:	7a42                	ld	s4,48(sp)
    8000494a:	7aa2                	ld	s5,40(sp)
    8000494c:	6125                	addi	sp,sp,96
    8000494e:	8082                	ret
      wakeup(&pi->nread);
    80004950:	8562                	mv	a0,s8
    80004952:	feefd0ef          	jal	80002140 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004956:	85a6                	mv	a1,s1
    80004958:	855e                	mv	a0,s7
    8000495a:	f9afd0ef          	jal	800020f4 <sleep>
  while(i < n){
    8000495e:	05495b63          	bge	s2,s4,800049b4 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004962:	2204a783          	lw	a5,544(s1)
    80004966:	d7e1                	beqz	a5,8000492e <pipewrite+0x3c>
    80004968:	854e                	mv	a0,s3
    8000496a:	a3ffd0ef          	jal	800023a8 <killed>
    8000496e:	f161                	bnez	a0,8000492e <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004970:	2184a783          	lw	a5,536(s1)
    80004974:	21c4a703          	lw	a4,540(s1)
    80004978:	2007879b          	addiw	a5,a5,512
    8000497c:	fcf70ae3          	beq	a4,a5,80004950 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004980:	4685                	li	a3,1
    80004982:	01590633          	add	a2,s2,s5
    80004986:	faf40593          	addi	a1,s0,-81
    8000498a:	0509b503          	ld	a0,80(s3)
    8000498e:	cbbfc0ef          	jal	80001648 <copyin>
    80004992:	03650e63          	beq	a0,s6,800049ce <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004996:	21c4a783          	lw	a5,540(s1)
    8000499a:	0017871b          	addiw	a4,a5,1
    8000499e:	20e4ae23          	sw	a4,540(s1)
    800049a2:	1ff7f793          	andi	a5,a5,511
    800049a6:	97a6                	add	a5,a5,s1
    800049a8:	faf44703          	lbu	a4,-81(s0)
    800049ac:	00e78c23          	sb	a4,24(a5)
      i++;
    800049b0:	2905                	addiw	s2,s2,1
    800049b2:	b775                	j	8000495e <pipewrite+0x6c>
    800049b4:	7b02                	ld	s6,32(sp)
    800049b6:	6be2                	ld	s7,24(sp)
    800049b8:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800049ba:	21848513          	addi	a0,s1,536
    800049be:	f82fd0ef          	jal	80002140 <wakeup>
  release(&pi->lock);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ad6fc0ef          	jal	80000c9a <release>
  return i;
    800049c8:	bf95                	j	8000493c <pipewrite+0x4a>
  int i = 0;
    800049ca:	4901                	li	s2,0
    800049cc:	b7fd                	j	800049ba <pipewrite+0xc8>
    800049ce:	7b02                	ld	s6,32(sp)
    800049d0:	6be2                	ld	s7,24(sp)
    800049d2:	6c42                	ld	s8,16(sp)
    800049d4:	b7dd                	j	800049ba <pipewrite+0xc8>

00000000800049d6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800049d6:	715d                	addi	sp,sp,-80
    800049d8:	e486                	sd	ra,72(sp)
    800049da:	e0a2                	sd	s0,64(sp)
    800049dc:	fc26                	sd	s1,56(sp)
    800049de:	f84a                	sd	s2,48(sp)
    800049e0:	f44e                	sd	s3,40(sp)
    800049e2:	f052                	sd	s4,32(sp)
    800049e4:	ec56                	sd	s5,24(sp)
    800049e6:	0880                	addi	s0,sp,80
    800049e8:	84aa                	mv	s1,a0
    800049ea:	892e                	mv	s2,a1
    800049ec:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800049ee:	f13fc0ef          	jal	80001900 <myproc>
    800049f2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800049f4:	8526                	mv	a0,s1
    800049f6:	a0cfc0ef          	jal	80000c02 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800049fa:	2184a703          	lw	a4,536(s1)
    800049fe:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a02:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a06:	02f71563          	bne	a4,a5,80004a30 <piperead+0x5a>
    80004a0a:	2244a783          	lw	a5,548(s1)
    80004a0e:	cb85                	beqz	a5,80004a3e <piperead+0x68>
    if(killed(pr)){
    80004a10:	8552                	mv	a0,s4
    80004a12:	997fd0ef          	jal	800023a8 <killed>
    80004a16:	ed19                	bnez	a0,80004a34 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a18:	85a6                	mv	a1,s1
    80004a1a:	854e                	mv	a0,s3
    80004a1c:	ed8fd0ef          	jal	800020f4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a20:	2184a703          	lw	a4,536(s1)
    80004a24:	21c4a783          	lw	a5,540(s1)
    80004a28:	fef701e3          	beq	a4,a5,80004a0a <piperead+0x34>
    80004a2c:	e85a                	sd	s6,16(sp)
    80004a2e:	a809                	j	80004a40 <piperead+0x6a>
    80004a30:	e85a                	sd	s6,16(sp)
    80004a32:	a039                	j	80004a40 <piperead+0x6a>
      release(&pi->lock);
    80004a34:	8526                	mv	a0,s1
    80004a36:	a64fc0ef          	jal	80000c9a <release>
      return -1;
    80004a3a:	59fd                	li	s3,-1
    80004a3c:	a8b1                	j	80004a98 <piperead+0xc2>
    80004a3e:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a40:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a42:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a44:	05505263          	blez	s5,80004a88 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004a48:	2184a783          	lw	a5,536(s1)
    80004a4c:	21c4a703          	lw	a4,540(s1)
    80004a50:	02f70c63          	beq	a4,a5,80004a88 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004a54:	0017871b          	addiw	a4,a5,1
    80004a58:	20e4ac23          	sw	a4,536(s1)
    80004a5c:	1ff7f793          	andi	a5,a5,511
    80004a60:	97a6                	add	a5,a5,s1
    80004a62:	0187c783          	lbu	a5,24(a5)
    80004a66:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004a6a:	4685                	li	a3,1
    80004a6c:	fbf40613          	addi	a2,s0,-65
    80004a70:	85ca                	mv	a1,s2
    80004a72:	050a3503          	ld	a0,80(s4)
    80004a76:	afdfc0ef          	jal	80001572 <copyout>
    80004a7a:	01650763          	beq	a0,s6,80004a88 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004a7e:	2985                	addiw	s3,s3,1
    80004a80:	0905                	addi	s2,s2,1
    80004a82:	fd3a93e3          	bne	s5,s3,80004a48 <piperead+0x72>
    80004a86:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004a88:	21c48513          	addi	a0,s1,540
    80004a8c:	eb4fd0ef          	jal	80002140 <wakeup>
  release(&pi->lock);
    80004a90:	8526                	mv	a0,s1
    80004a92:	a08fc0ef          	jal	80000c9a <release>
    80004a96:	6b42                	ld	s6,16(sp)
  return i;
}
    80004a98:	854e                	mv	a0,s3
    80004a9a:	60a6                	ld	ra,72(sp)
    80004a9c:	6406                	ld	s0,64(sp)
    80004a9e:	74e2                	ld	s1,56(sp)
    80004aa0:	7942                	ld	s2,48(sp)
    80004aa2:	79a2                	ld	s3,40(sp)
    80004aa4:	7a02                	ld	s4,32(sp)
    80004aa6:	6ae2                	ld	s5,24(sp)
    80004aa8:	6161                	addi	sp,sp,80
    80004aaa:	8082                	ret

0000000080004aac <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004aac:	1141                	addi	sp,sp,-16
    80004aae:	e422                	sd	s0,8(sp)
    80004ab0:	0800                	addi	s0,sp,16
    80004ab2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004ab4:	8905                	andi	a0,a0,1
    80004ab6:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004ab8:	8b89                	andi	a5,a5,2
    80004aba:	c399                	beqz	a5,80004ac0 <flags2perm+0x14>
      perm |= PTE_W;
    80004abc:	00456513          	ori	a0,a0,4
    return perm;
}
    80004ac0:	6422                	ld	s0,8(sp)
    80004ac2:	0141                	addi	sp,sp,16
    80004ac4:	8082                	ret

0000000080004ac6 <exec>:

int
exec(char *path, char **argv)
{
    80004ac6:	df010113          	addi	sp,sp,-528
    80004aca:	20113423          	sd	ra,520(sp)
    80004ace:	20813023          	sd	s0,512(sp)
    80004ad2:	ffa6                	sd	s1,504(sp)
    80004ad4:	fbca                	sd	s2,496(sp)
    80004ad6:	0c00                	addi	s0,sp,528
    80004ad8:	892a                	mv	s2,a0
    80004ada:	dea43c23          	sd	a0,-520(s0)
    80004ade:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ae2:	e1ffc0ef          	jal	80001900 <myproc>
    80004ae6:	84aa                	mv	s1,a0

  begin_op();
    80004ae8:	dc6ff0ef          	jal	800040ae <begin_op>

  if((ip = namei(path)) == 0){
    80004aec:	854a                	mv	a0,s2
    80004aee:	c04ff0ef          	jal	80003ef2 <namei>
    80004af2:	c931                	beqz	a0,80004b46 <exec+0x80>
    80004af4:	f3d2                	sd	s4,480(sp)
    80004af6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004af8:	d21fe0ef          	jal	80003818 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004afc:	04000713          	li	a4,64
    80004b00:	4681                	li	a3,0
    80004b02:	e5040613          	addi	a2,s0,-432
    80004b06:	4581                	li	a1,0
    80004b08:	8552                	mv	a0,s4
    80004b0a:	f63fe0ef          	jal	80003a6c <readi>
    80004b0e:	04000793          	li	a5,64
    80004b12:	00f51a63          	bne	a0,a5,80004b26 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004b16:	e5042703          	lw	a4,-432(s0)
    80004b1a:	464c47b7          	lui	a5,0x464c4
    80004b1e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004b22:	02f70663          	beq	a4,a5,80004b4e <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004b26:	8552                	mv	a0,s4
    80004b28:	efbfe0ef          	jal	80003a22 <iunlockput>
    end_op();
    80004b2c:	decff0ef          	jal	80004118 <end_op>
  }
  return -1;
    80004b30:	557d                	li	a0,-1
    80004b32:	7a1e                	ld	s4,480(sp)
}
    80004b34:	20813083          	ld	ra,520(sp)
    80004b38:	20013403          	ld	s0,512(sp)
    80004b3c:	74fe                	ld	s1,504(sp)
    80004b3e:	795e                	ld	s2,496(sp)
    80004b40:	21010113          	addi	sp,sp,528
    80004b44:	8082                	ret
    end_op();
    80004b46:	dd2ff0ef          	jal	80004118 <end_op>
    return -1;
    80004b4a:	557d                	li	a0,-1
    80004b4c:	b7e5                	j	80004b34 <exec+0x6e>
    80004b4e:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80004b50:	8526                	mv	a0,s1
    80004b52:	e57fc0ef          	jal	800019a8 <proc_pagetable>
    80004b56:	8b2a                	mv	s6,a0
    80004b58:	2c050b63          	beqz	a0,80004e2e <exec+0x368>
    80004b5c:	f7ce                	sd	s3,488(sp)
    80004b5e:	efd6                	sd	s5,472(sp)
    80004b60:	e7de                	sd	s7,456(sp)
    80004b62:	e3e2                	sd	s8,448(sp)
    80004b64:	ff66                	sd	s9,440(sp)
    80004b66:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b68:	e7042d03          	lw	s10,-400(s0)
    80004b6c:	e8845783          	lhu	a5,-376(s0)
    80004b70:	12078963          	beqz	a5,80004ca2 <exec+0x1dc>
    80004b74:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b76:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004b78:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004b7a:	6c85                	lui	s9,0x1
    80004b7c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004b80:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004b84:	6a85                	lui	s5,0x1
    80004b86:	a085                	j	80004be6 <exec+0x120>
      panic("loadseg: address should exist");
    80004b88:	00004517          	auipc	a0,0x4
    80004b8c:	b2050513          	addi	a0,a0,-1248 # 800086a8 <etext+0x6a8>
    80004b90:	c13fb0ef          	jal	800007a2 <panic>
    if(sz - i < PGSIZE)
    80004b94:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004b96:	8726                	mv	a4,s1
    80004b98:	012c06bb          	addw	a3,s8,s2
    80004b9c:	4581                	li	a1,0
    80004b9e:	8552                	mv	a0,s4
    80004ba0:	ecdfe0ef          	jal	80003a6c <readi>
    80004ba4:	2501                	sext.w	a0,a0
    80004ba6:	24a49a63          	bne	s1,a0,80004dfa <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004baa:	012a893b          	addw	s2,s5,s2
    80004bae:	03397363          	bgeu	s2,s3,80004bd4 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004bb2:	02091593          	slli	a1,s2,0x20
    80004bb6:	9181                	srli	a1,a1,0x20
    80004bb8:	95de                	add	a1,a1,s7
    80004bba:	855a                	mv	a0,s6
    80004bbc:	c28fc0ef          	jal	80000fe4 <walkaddr>
    80004bc0:	862a                	mv	a2,a0
    if(pa == 0)
    80004bc2:	d179                	beqz	a0,80004b88 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004bc4:	412984bb          	subw	s1,s3,s2
    80004bc8:	0004879b          	sext.w	a5,s1
    80004bcc:	fcfcf4e3          	bgeu	s9,a5,80004b94 <exec+0xce>
    80004bd0:	84d6                	mv	s1,s5
    80004bd2:	b7c9                	j	80004b94 <exec+0xce>
    sz = sz1;
    80004bd4:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004bd8:	2d85                	addiw	s11,s11,1
    80004bda:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004bde:	e8845783          	lhu	a5,-376(s0)
    80004be2:	08fdd063          	bge	s11,a5,80004c62 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004be6:	2d01                	sext.w	s10,s10
    80004be8:	03800713          	li	a4,56
    80004bec:	86ea                	mv	a3,s10
    80004bee:	e1840613          	addi	a2,s0,-488
    80004bf2:	4581                	li	a1,0
    80004bf4:	8552                	mv	a0,s4
    80004bf6:	e77fe0ef          	jal	80003a6c <readi>
    80004bfa:	03800793          	li	a5,56
    80004bfe:	1cf51663          	bne	a0,a5,80004dca <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004c02:	e1842783          	lw	a5,-488(s0)
    80004c06:	4705                	li	a4,1
    80004c08:	fce798e3          	bne	a5,a4,80004bd8 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80004c0c:	e4043483          	ld	s1,-448(s0)
    80004c10:	e3843783          	ld	a5,-456(s0)
    80004c14:	1af4ef63          	bltu	s1,a5,80004dd2 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004c18:	e2843783          	ld	a5,-472(s0)
    80004c1c:	94be                	add	s1,s1,a5
    80004c1e:	1af4ee63          	bltu	s1,a5,80004dda <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80004c22:	df043703          	ld	a4,-528(s0)
    80004c26:	8ff9                	and	a5,a5,a4
    80004c28:	1a079d63          	bnez	a5,80004de2 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004c2c:	e1c42503          	lw	a0,-484(s0)
    80004c30:	e7dff0ef          	jal	80004aac <flags2perm>
    80004c34:	86aa                	mv	a3,a0
    80004c36:	8626                	mv	a2,s1
    80004c38:	85ca                	mv	a1,s2
    80004c3a:	855a                	mv	a0,s6
    80004c3c:	f22fc0ef          	jal	8000135e <uvmalloc>
    80004c40:	e0a43423          	sd	a0,-504(s0)
    80004c44:	1a050363          	beqz	a0,80004dea <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004c48:	e2843b83          	ld	s7,-472(s0)
    80004c4c:	e2042c03          	lw	s8,-480(s0)
    80004c50:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004c54:	00098463          	beqz	s3,80004c5c <exec+0x196>
    80004c58:	4901                	li	s2,0
    80004c5a:	bfa1                	j	80004bb2 <exec+0xec>
    sz = sz1;
    80004c5c:	e0843903          	ld	s2,-504(s0)
    80004c60:	bfa5                	j	80004bd8 <exec+0x112>
    80004c62:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004c64:	8552                	mv	a0,s4
    80004c66:	dbdfe0ef          	jal	80003a22 <iunlockput>
  end_op();
    80004c6a:	caeff0ef          	jal	80004118 <end_op>
  p = myproc();
    80004c6e:	c93fc0ef          	jal	80001900 <myproc>
    80004c72:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004c74:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004c78:	6985                	lui	s3,0x1
    80004c7a:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004c7c:	99ca                	add	s3,s3,s2
    80004c7e:	77fd                	lui	a5,0xfffff
    80004c80:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004c84:	4691                	li	a3,4
    80004c86:	6609                	lui	a2,0x2
    80004c88:	964e                	add	a2,a2,s3
    80004c8a:	85ce                	mv	a1,s3
    80004c8c:	855a                	mv	a0,s6
    80004c8e:	ed0fc0ef          	jal	8000135e <uvmalloc>
    80004c92:	892a                	mv	s2,a0
    80004c94:	e0a43423          	sd	a0,-504(s0)
    80004c98:	e519                	bnez	a0,80004ca6 <exec+0x1e0>
  if(pagetable)
    80004c9a:	e1343423          	sd	s3,-504(s0)
    80004c9e:	4a01                	li	s4,0
    80004ca0:	aab1                	j	80004dfc <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004ca2:	4901                	li	s2,0
    80004ca4:	b7c1                	j	80004c64 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004ca6:	75f9                	lui	a1,0xffffe
    80004ca8:	95aa                	add	a1,a1,a0
    80004caa:	855a                	mv	a0,s6
    80004cac:	89dfc0ef          	jal	80001548 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004cb0:	7bfd                	lui	s7,0xfffff
    80004cb2:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004cb4:	e0043783          	ld	a5,-512(s0)
    80004cb8:	6388                	ld	a0,0(a5)
    80004cba:	cd39                	beqz	a0,80004d18 <exec+0x252>
    80004cbc:	e9040993          	addi	s3,s0,-368
    80004cc0:	f9040c13          	addi	s8,s0,-112
    80004cc4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004cc6:	980fc0ef          	jal	80000e46 <strlen>
    80004cca:	0015079b          	addiw	a5,a0,1
    80004cce:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004cd2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004cd6:	11796e63          	bltu	s2,s7,80004df2 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004cda:	e0043d03          	ld	s10,-512(s0)
    80004cde:	000d3a03          	ld	s4,0(s10)
    80004ce2:	8552                	mv	a0,s4
    80004ce4:	962fc0ef          	jal	80000e46 <strlen>
    80004ce8:	0015069b          	addiw	a3,a0,1
    80004cec:	8652                	mv	a2,s4
    80004cee:	85ca                	mv	a1,s2
    80004cf0:	855a                	mv	a0,s6
    80004cf2:	881fc0ef          	jal	80001572 <copyout>
    80004cf6:	10054063          	bltz	a0,80004df6 <exec+0x330>
    ustack[argc] = sp;
    80004cfa:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004cfe:	0485                	addi	s1,s1,1
    80004d00:	008d0793          	addi	a5,s10,8
    80004d04:	e0f43023          	sd	a5,-512(s0)
    80004d08:	008d3503          	ld	a0,8(s10)
    80004d0c:	c909                	beqz	a0,80004d1e <exec+0x258>
    if(argc >= MAXARG)
    80004d0e:	09a1                	addi	s3,s3,8
    80004d10:	fb899be3          	bne	s3,s8,80004cc6 <exec+0x200>
  ip = 0;
    80004d14:	4a01                	li	s4,0
    80004d16:	a0dd                	j	80004dfc <exec+0x336>
  sp = sz;
    80004d18:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004d1c:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d1e:	00349793          	slli	a5,s1,0x3
    80004d22:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9fd8>
    80004d26:	97a2                	add	a5,a5,s0
    80004d28:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004d2c:	00148693          	addi	a3,s1,1
    80004d30:	068e                	slli	a3,a3,0x3
    80004d32:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d36:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004d3a:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004d3e:	f5796ee3          	bltu	s2,s7,80004c9a <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d42:	e9040613          	addi	a2,s0,-368
    80004d46:	85ca                	mv	a1,s2
    80004d48:	855a                	mv	a0,s6
    80004d4a:	829fc0ef          	jal	80001572 <copyout>
    80004d4e:	0e054263          	bltz	a0,80004e32 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004d52:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004d56:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004d5a:	df843783          	ld	a5,-520(s0)
    80004d5e:	0007c703          	lbu	a4,0(a5)
    80004d62:	cf11                	beqz	a4,80004d7e <exec+0x2b8>
    80004d64:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004d66:	02f00693          	li	a3,47
    80004d6a:	a039                	j	80004d78 <exec+0x2b2>
      last = s+1;
    80004d6c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004d70:	0785                	addi	a5,a5,1
    80004d72:	fff7c703          	lbu	a4,-1(a5)
    80004d76:	c701                	beqz	a4,80004d7e <exec+0x2b8>
    if(*s == '/')
    80004d78:	fed71ce3          	bne	a4,a3,80004d70 <exec+0x2aa>
    80004d7c:	bfc5                	j	80004d6c <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004d7e:	4641                	li	a2,16
    80004d80:	df843583          	ld	a1,-520(s0)
    80004d84:	158a8513          	addi	a0,s5,344
    80004d88:	88cfc0ef          	jal	80000e14 <safestrcpy>
  oldpagetable = p->pagetable;
    80004d8c:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004d90:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004d94:	e0843783          	ld	a5,-504(s0)
    80004d98:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004d9c:	058ab783          	ld	a5,88(s5)
    80004da0:	e6843703          	ld	a4,-408(s0)
    80004da4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004da6:	058ab783          	ld	a5,88(s5)
    80004daa:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004dae:	85e6                	mv	a1,s9
    80004db0:	c7dfc0ef          	jal	80001a2c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004db4:	0004851b          	sext.w	a0,s1
    80004db8:	79be                	ld	s3,488(sp)
    80004dba:	7a1e                	ld	s4,480(sp)
    80004dbc:	6afe                	ld	s5,472(sp)
    80004dbe:	6b5e                	ld	s6,464(sp)
    80004dc0:	6bbe                	ld	s7,456(sp)
    80004dc2:	6c1e                	ld	s8,448(sp)
    80004dc4:	7cfa                	ld	s9,440(sp)
    80004dc6:	7d5a                	ld	s10,432(sp)
    80004dc8:	b3b5                	j	80004b34 <exec+0x6e>
    80004dca:	e1243423          	sd	s2,-504(s0)
    80004dce:	7dba                	ld	s11,424(sp)
    80004dd0:	a035                	j	80004dfc <exec+0x336>
    80004dd2:	e1243423          	sd	s2,-504(s0)
    80004dd6:	7dba                	ld	s11,424(sp)
    80004dd8:	a015                	j	80004dfc <exec+0x336>
    80004dda:	e1243423          	sd	s2,-504(s0)
    80004dde:	7dba                	ld	s11,424(sp)
    80004de0:	a831                	j	80004dfc <exec+0x336>
    80004de2:	e1243423          	sd	s2,-504(s0)
    80004de6:	7dba                	ld	s11,424(sp)
    80004de8:	a811                	j	80004dfc <exec+0x336>
    80004dea:	e1243423          	sd	s2,-504(s0)
    80004dee:	7dba                	ld	s11,424(sp)
    80004df0:	a031                	j	80004dfc <exec+0x336>
  ip = 0;
    80004df2:	4a01                	li	s4,0
    80004df4:	a021                	j	80004dfc <exec+0x336>
    80004df6:	4a01                	li	s4,0
  if(pagetable)
    80004df8:	a011                	j	80004dfc <exec+0x336>
    80004dfa:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004dfc:	e0843583          	ld	a1,-504(s0)
    80004e00:	855a                	mv	a0,s6
    80004e02:	c2bfc0ef          	jal	80001a2c <proc_freepagetable>
  return -1;
    80004e06:	557d                	li	a0,-1
  if(ip){
    80004e08:	000a1b63          	bnez	s4,80004e1e <exec+0x358>
    80004e0c:	79be                	ld	s3,488(sp)
    80004e0e:	7a1e                	ld	s4,480(sp)
    80004e10:	6afe                	ld	s5,472(sp)
    80004e12:	6b5e                	ld	s6,464(sp)
    80004e14:	6bbe                	ld	s7,456(sp)
    80004e16:	6c1e                	ld	s8,448(sp)
    80004e18:	7cfa                	ld	s9,440(sp)
    80004e1a:	7d5a                	ld	s10,432(sp)
    80004e1c:	bb21                	j	80004b34 <exec+0x6e>
    80004e1e:	79be                	ld	s3,488(sp)
    80004e20:	6afe                	ld	s5,472(sp)
    80004e22:	6b5e                	ld	s6,464(sp)
    80004e24:	6bbe                	ld	s7,456(sp)
    80004e26:	6c1e                	ld	s8,448(sp)
    80004e28:	7cfa                	ld	s9,440(sp)
    80004e2a:	7d5a                	ld	s10,432(sp)
    80004e2c:	b9ed                	j	80004b26 <exec+0x60>
    80004e2e:	6b5e                	ld	s6,464(sp)
    80004e30:	b9dd                	j	80004b26 <exec+0x60>
  sz = sz1;
    80004e32:	e0843983          	ld	s3,-504(s0)
    80004e36:	b595                	j	80004c9a <exec+0x1d4>

0000000080004e38 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004e38:	7179                	addi	sp,sp,-48
    80004e3a:	f406                	sd	ra,40(sp)
    80004e3c:	f022                	sd	s0,32(sp)
    80004e3e:	ec26                	sd	s1,24(sp)
    80004e40:	e84a                	sd	s2,16(sp)
    80004e42:	1800                	addi	s0,sp,48
    80004e44:	892e                	mv	s2,a1
    80004e46:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004e48:	fdc40593          	addi	a1,s0,-36
    80004e4c:	d49fd0ef          	jal	80002b94 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004e50:	fdc42703          	lw	a4,-36(s0)
    80004e54:	47bd                	li	a5,15
    80004e56:	02e7e963          	bltu	a5,a4,80004e88 <argfd+0x50>
    80004e5a:	aa7fc0ef          	jal	80001900 <myproc>
    80004e5e:	fdc42703          	lw	a4,-36(s0)
    80004e62:	01a70793          	addi	a5,a4,26
    80004e66:	078e                	slli	a5,a5,0x3
    80004e68:	953e                	add	a0,a0,a5
    80004e6a:	611c                	ld	a5,0(a0)
    80004e6c:	c385                	beqz	a5,80004e8c <argfd+0x54>
    return -1;
  if(pfd)
    80004e6e:	00090463          	beqz	s2,80004e76 <argfd+0x3e>
    *pfd = fd;
    80004e72:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004e76:	4501                	li	a0,0
  if(pf)
    80004e78:	c091                	beqz	s1,80004e7c <argfd+0x44>
    *pf = f;
    80004e7a:	e09c                	sd	a5,0(s1)
}
    80004e7c:	70a2                	ld	ra,40(sp)
    80004e7e:	7402                	ld	s0,32(sp)
    80004e80:	64e2                	ld	s1,24(sp)
    80004e82:	6942                	ld	s2,16(sp)
    80004e84:	6145                	addi	sp,sp,48
    80004e86:	8082                	ret
    return -1;
    80004e88:	557d                	li	a0,-1
    80004e8a:	bfcd                	j	80004e7c <argfd+0x44>
    80004e8c:	557d                	li	a0,-1
    80004e8e:	b7fd                	j	80004e7c <argfd+0x44>

0000000080004e90 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004e90:	1101                	addi	sp,sp,-32
    80004e92:	ec06                	sd	ra,24(sp)
    80004e94:	e822                	sd	s0,16(sp)
    80004e96:	e426                	sd	s1,8(sp)
    80004e98:	1000                	addi	s0,sp,32
    80004e9a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004e9c:	a65fc0ef          	jal	80001900 <myproc>
    80004ea0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004ea2:	0d050793          	addi	a5,a0,208
    80004ea6:	4501                	li	a0,0
    80004ea8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004eaa:	6398                	ld	a4,0(a5)
    80004eac:	cb19                	beqz	a4,80004ec2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004eae:	2505                	addiw	a0,a0,1
    80004eb0:	07a1                	addi	a5,a5,8
    80004eb2:	fed51ce3          	bne	a0,a3,80004eaa <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004eb6:	557d                	li	a0,-1
}
    80004eb8:	60e2                	ld	ra,24(sp)
    80004eba:	6442                	ld	s0,16(sp)
    80004ebc:	64a2                	ld	s1,8(sp)
    80004ebe:	6105                	addi	sp,sp,32
    80004ec0:	8082                	ret
      p->ofile[fd] = f;
    80004ec2:	01a50793          	addi	a5,a0,26
    80004ec6:	078e                	slli	a5,a5,0x3
    80004ec8:	963e                	add	a2,a2,a5
    80004eca:	e204                	sd	s1,0(a2)
      return fd;
    80004ecc:	b7f5                	j	80004eb8 <fdalloc+0x28>

0000000080004ece <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004ece:	715d                	addi	sp,sp,-80
    80004ed0:	e486                	sd	ra,72(sp)
    80004ed2:	e0a2                	sd	s0,64(sp)
    80004ed4:	fc26                	sd	s1,56(sp)
    80004ed6:	f84a                	sd	s2,48(sp)
    80004ed8:	f44e                	sd	s3,40(sp)
    80004eda:	ec56                	sd	s5,24(sp)
    80004edc:	e85a                	sd	s6,16(sp)
    80004ede:	0880                	addi	s0,sp,80
    80004ee0:	8b2e                	mv	s6,a1
    80004ee2:	89b2                	mv	s3,a2
    80004ee4:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004ee6:	fb040593          	addi	a1,s0,-80
    80004eea:	822ff0ef          	jal	80003f0c <nameiparent>
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	10050a63          	beqz	a0,80005004 <create+0x136>
    return 0;

  ilock(dp);
    80004ef4:	925fe0ef          	jal	80003818 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004ef8:	4601                	li	a2,0
    80004efa:	fb040593          	addi	a1,s0,-80
    80004efe:	8526                	mv	a0,s1
    80004f00:	d8dfe0ef          	jal	80003c8c <dirlookup>
    80004f04:	8aaa                	mv	s5,a0
    80004f06:	c129                	beqz	a0,80004f48 <create+0x7a>
    iunlockput(dp);
    80004f08:	8526                	mv	a0,s1
    80004f0a:	b19fe0ef          	jal	80003a22 <iunlockput>
    ilock(ip);
    80004f0e:	8556                	mv	a0,s5
    80004f10:	909fe0ef          	jal	80003818 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004f14:	4789                	li	a5,2
    80004f16:	02fb1463          	bne	s6,a5,80004f3e <create+0x70>
    80004f1a:	044ad783          	lhu	a5,68(s5)
    80004f1e:	37f9                	addiw	a5,a5,-2
    80004f20:	17c2                	slli	a5,a5,0x30
    80004f22:	93c1                	srli	a5,a5,0x30
    80004f24:	4705                	li	a4,1
    80004f26:	00f76c63          	bltu	a4,a5,80004f3e <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004f2a:	8556                	mv	a0,s5
    80004f2c:	60a6                	ld	ra,72(sp)
    80004f2e:	6406                	ld	s0,64(sp)
    80004f30:	74e2                	ld	s1,56(sp)
    80004f32:	7942                	ld	s2,48(sp)
    80004f34:	79a2                	ld	s3,40(sp)
    80004f36:	6ae2                	ld	s5,24(sp)
    80004f38:	6b42                	ld	s6,16(sp)
    80004f3a:	6161                	addi	sp,sp,80
    80004f3c:	8082                	ret
    iunlockput(ip);
    80004f3e:	8556                	mv	a0,s5
    80004f40:	ae3fe0ef          	jal	80003a22 <iunlockput>
    return 0;
    80004f44:	4a81                	li	s5,0
    80004f46:	b7d5                	j	80004f2a <create+0x5c>
    80004f48:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004f4a:	85da                	mv	a1,s6
    80004f4c:	4088                	lw	a0,0(s1)
    80004f4e:	f5afe0ef          	jal	800036a8 <ialloc>
    80004f52:	8a2a                	mv	s4,a0
    80004f54:	cd15                	beqz	a0,80004f90 <create+0xc2>
  ilock(ip);
    80004f56:	8c3fe0ef          	jal	80003818 <ilock>
  ip->major = major;
    80004f5a:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004f5e:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004f62:	4905                	li	s2,1
    80004f64:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004f68:	8552                	mv	a0,s4
    80004f6a:	ffafe0ef          	jal	80003764 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004f6e:	032b0763          	beq	s6,s2,80004f9c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004f72:	004a2603          	lw	a2,4(s4)
    80004f76:	fb040593          	addi	a1,s0,-80
    80004f7a:	8526                	mv	a0,s1
    80004f7c:	eddfe0ef          	jal	80003e58 <dirlink>
    80004f80:	06054563          	bltz	a0,80004fea <create+0x11c>
  iunlockput(dp);
    80004f84:	8526                	mv	a0,s1
    80004f86:	a9dfe0ef          	jal	80003a22 <iunlockput>
  return ip;
    80004f8a:	8ad2                	mv	s5,s4
    80004f8c:	7a02                	ld	s4,32(sp)
    80004f8e:	bf71                	j	80004f2a <create+0x5c>
    iunlockput(dp);
    80004f90:	8526                	mv	a0,s1
    80004f92:	a91fe0ef          	jal	80003a22 <iunlockput>
    return 0;
    80004f96:	8ad2                	mv	s5,s4
    80004f98:	7a02                	ld	s4,32(sp)
    80004f9a:	bf41                	j	80004f2a <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004f9c:	004a2603          	lw	a2,4(s4)
    80004fa0:	00003597          	auipc	a1,0x3
    80004fa4:	72858593          	addi	a1,a1,1832 # 800086c8 <etext+0x6c8>
    80004fa8:	8552                	mv	a0,s4
    80004faa:	eaffe0ef          	jal	80003e58 <dirlink>
    80004fae:	02054e63          	bltz	a0,80004fea <create+0x11c>
    80004fb2:	40d0                	lw	a2,4(s1)
    80004fb4:	00003597          	auipc	a1,0x3
    80004fb8:	71c58593          	addi	a1,a1,1820 # 800086d0 <etext+0x6d0>
    80004fbc:	8552                	mv	a0,s4
    80004fbe:	e9bfe0ef          	jal	80003e58 <dirlink>
    80004fc2:	02054463          	bltz	a0,80004fea <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004fc6:	004a2603          	lw	a2,4(s4)
    80004fca:	fb040593          	addi	a1,s0,-80
    80004fce:	8526                	mv	a0,s1
    80004fd0:	e89fe0ef          	jal	80003e58 <dirlink>
    80004fd4:	00054b63          	bltz	a0,80004fea <create+0x11c>
    dp->nlink++;  // for ".."
    80004fd8:	04a4d783          	lhu	a5,74(s1)
    80004fdc:	2785                	addiw	a5,a5,1
    80004fde:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004fe2:	8526                	mv	a0,s1
    80004fe4:	f80fe0ef          	jal	80003764 <iupdate>
    80004fe8:	bf71                	j	80004f84 <create+0xb6>
  ip->nlink = 0;
    80004fea:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004fee:	8552                	mv	a0,s4
    80004ff0:	f74fe0ef          	jal	80003764 <iupdate>
  iunlockput(ip);
    80004ff4:	8552                	mv	a0,s4
    80004ff6:	a2dfe0ef          	jal	80003a22 <iunlockput>
  iunlockput(dp);
    80004ffa:	8526                	mv	a0,s1
    80004ffc:	a27fe0ef          	jal	80003a22 <iunlockput>
  return 0;
    80005000:	7a02                	ld	s4,32(sp)
    80005002:	b725                	j	80004f2a <create+0x5c>
    return 0;
    80005004:	8aaa                	mv	s5,a0
    80005006:	b715                	j	80004f2a <create+0x5c>

0000000080005008 <sys_dup>:
{
    80005008:	7179                	addi	sp,sp,-48
    8000500a:	f406                	sd	ra,40(sp)
    8000500c:	f022                	sd	s0,32(sp)
    8000500e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005010:	fd840613          	addi	a2,s0,-40
    80005014:	4581                	li	a1,0
    80005016:	4501                	li	a0,0
    80005018:	e21ff0ef          	jal	80004e38 <argfd>
    return -1;
    8000501c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000501e:	02054363          	bltz	a0,80005044 <sys_dup+0x3c>
    80005022:	ec26                	sd	s1,24(sp)
    80005024:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005026:	fd843903          	ld	s2,-40(s0)
    8000502a:	854a                	mv	a0,s2
    8000502c:	e65ff0ef          	jal	80004e90 <fdalloc>
    80005030:	84aa                	mv	s1,a0
    return -1;
    80005032:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005034:	00054d63          	bltz	a0,8000504e <sys_dup+0x46>
  filedup(f);
    80005038:	854a                	mv	a0,s2
    8000503a:	c48ff0ef          	jal	80004482 <filedup>
  return fd;
    8000503e:	87a6                	mv	a5,s1
    80005040:	64e2                	ld	s1,24(sp)
    80005042:	6942                	ld	s2,16(sp)
}
    80005044:	853e                	mv	a0,a5
    80005046:	70a2                	ld	ra,40(sp)
    80005048:	7402                	ld	s0,32(sp)
    8000504a:	6145                	addi	sp,sp,48
    8000504c:	8082                	ret
    8000504e:	64e2                	ld	s1,24(sp)
    80005050:	6942                	ld	s2,16(sp)
    80005052:	bfcd                	j	80005044 <sys_dup+0x3c>

0000000080005054 <sys_read>:
{
    80005054:	7179                	addi	sp,sp,-48
    80005056:	f406                	sd	ra,40(sp)
    80005058:	f022                	sd	s0,32(sp)
    8000505a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000505c:	fd840593          	addi	a1,s0,-40
    80005060:	4505                	li	a0,1
    80005062:	b4ffd0ef          	jal	80002bb0 <argaddr>
  argint(2, &n);
    80005066:	fe440593          	addi	a1,s0,-28
    8000506a:	4509                	li	a0,2
    8000506c:	b29fd0ef          	jal	80002b94 <argint>
  if(argfd(0, 0, &f) < 0)
    80005070:	fe840613          	addi	a2,s0,-24
    80005074:	4581                	li	a1,0
    80005076:	4501                	li	a0,0
    80005078:	dc1ff0ef          	jal	80004e38 <argfd>
    8000507c:	87aa                	mv	a5,a0
    return -1;
    8000507e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005080:	0007ca63          	bltz	a5,80005094 <sys_read+0x40>
  return fileread(f, p, n);
    80005084:	fe442603          	lw	a2,-28(s0)
    80005088:	fd843583          	ld	a1,-40(s0)
    8000508c:	fe843503          	ld	a0,-24(s0)
    80005090:	d58ff0ef          	jal	800045e8 <fileread>
}
    80005094:	70a2                	ld	ra,40(sp)
    80005096:	7402                	ld	s0,32(sp)
    80005098:	6145                	addi	sp,sp,48
    8000509a:	8082                	ret

000000008000509c <sys_write>:
{
    8000509c:	7179                	addi	sp,sp,-48
    8000509e:	f406                	sd	ra,40(sp)
    800050a0:	f022                	sd	s0,32(sp)
    800050a2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800050a4:	fd840593          	addi	a1,s0,-40
    800050a8:	4505                	li	a0,1
    800050aa:	b07fd0ef          	jal	80002bb0 <argaddr>
  argint(2, &n);
    800050ae:	fe440593          	addi	a1,s0,-28
    800050b2:	4509                	li	a0,2
    800050b4:	ae1fd0ef          	jal	80002b94 <argint>
  if(argfd(0, 0, &f) < 0)
    800050b8:	fe840613          	addi	a2,s0,-24
    800050bc:	4581                	li	a1,0
    800050be:	4501                	li	a0,0
    800050c0:	d79ff0ef          	jal	80004e38 <argfd>
    800050c4:	87aa                	mv	a5,a0
    return -1;
    800050c6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800050c8:	0007ca63          	bltz	a5,800050dc <sys_write+0x40>
  return filewrite(f, p, n);
    800050cc:	fe442603          	lw	a2,-28(s0)
    800050d0:	fd843583          	ld	a1,-40(s0)
    800050d4:	fe843503          	ld	a0,-24(s0)
    800050d8:	dceff0ef          	jal	800046a6 <filewrite>
}
    800050dc:	70a2                	ld	ra,40(sp)
    800050de:	7402                	ld	s0,32(sp)
    800050e0:	6145                	addi	sp,sp,48
    800050e2:	8082                	ret

00000000800050e4 <sys_close>:
{
    800050e4:	1101                	addi	sp,sp,-32
    800050e6:	ec06                	sd	ra,24(sp)
    800050e8:	e822                	sd	s0,16(sp)
    800050ea:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800050ec:	fe040613          	addi	a2,s0,-32
    800050f0:	fec40593          	addi	a1,s0,-20
    800050f4:	4501                	li	a0,0
    800050f6:	d43ff0ef          	jal	80004e38 <argfd>
    return -1;
    800050fa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800050fc:	02054063          	bltz	a0,8000511c <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80005100:	801fc0ef          	jal	80001900 <myproc>
    80005104:	fec42783          	lw	a5,-20(s0)
    80005108:	07e9                	addi	a5,a5,26
    8000510a:	078e                	slli	a5,a5,0x3
    8000510c:	953e                	add	a0,a0,a5
    8000510e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005112:	fe043503          	ld	a0,-32(s0)
    80005116:	bb2ff0ef          	jal	800044c8 <fileclose>
  return 0;
    8000511a:	4781                	li	a5,0
}
    8000511c:	853e                	mv	a0,a5
    8000511e:	60e2                	ld	ra,24(sp)
    80005120:	6442                	ld	s0,16(sp)
    80005122:	6105                	addi	sp,sp,32
    80005124:	8082                	ret

0000000080005126 <sys_fstat>:
{
    80005126:	1101                	addi	sp,sp,-32
    80005128:	ec06                	sd	ra,24(sp)
    8000512a:	e822                	sd	s0,16(sp)
    8000512c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000512e:	fe040593          	addi	a1,s0,-32
    80005132:	4505                	li	a0,1
    80005134:	a7dfd0ef          	jal	80002bb0 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005138:	fe840613          	addi	a2,s0,-24
    8000513c:	4581                	li	a1,0
    8000513e:	4501                	li	a0,0
    80005140:	cf9ff0ef          	jal	80004e38 <argfd>
    80005144:	87aa                	mv	a5,a0
    return -1;
    80005146:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005148:	0007c863          	bltz	a5,80005158 <sys_fstat+0x32>
  return filestat(f, st);
    8000514c:	fe043583          	ld	a1,-32(s0)
    80005150:	fe843503          	ld	a0,-24(s0)
    80005154:	c36ff0ef          	jal	8000458a <filestat>
}
    80005158:	60e2                	ld	ra,24(sp)
    8000515a:	6442                	ld	s0,16(sp)
    8000515c:	6105                	addi	sp,sp,32
    8000515e:	8082                	ret

0000000080005160 <sys_link>:
{
    80005160:	7169                	addi	sp,sp,-304
    80005162:	f606                	sd	ra,296(sp)
    80005164:	f222                	sd	s0,288(sp)
    80005166:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005168:	08000613          	li	a2,128
    8000516c:	ed040593          	addi	a1,s0,-304
    80005170:	4501                	li	a0,0
    80005172:	a5bfd0ef          	jal	80002bcc <argstr>
    return -1;
    80005176:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005178:	0c054e63          	bltz	a0,80005254 <sys_link+0xf4>
    8000517c:	08000613          	li	a2,128
    80005180:	f5040593          	addi	a1,s0,-176
    80005184:	4505                	li	a0,1
    80005186:	a47fd0ef          	jal	80002bcc <argstr>
    return -1;
    8000518a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000518c:	0c054463          	bltz	a0,80005254 <sys_link+0xf4>
    80005190:	ee26                	sd	s1,280(sp)
  begin_op();
    80005192:	f1dfe0ef          	jal	800040ae <begin_op>
  if((ip = namei(old)) == 0){
    80005196:	ed040513          	addi	a0,s0,-304
    8000519a:	d59fe0ef          	jal	80003ef2 <namei>
    8000519e:	84aa                	mv	s1,a0
    800051a0:	c53d                	beqz	a0,8000520e <sys_link+0xae>
  ilock(ip);
    800051a2:	e76fe0ef          	jal	80003818 <ilock>
  if(ip->type == T_DIR){
    800051a6:	04449703          	lh	a4,68(s1)
    800051aa:	4785                	li	a5,1
    800051ac:	06f70663          	beq	a4,a5,80005218 <sys_link+0xb8>
    800051b0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800051b2:	04a4d783          	lhu	a5,74(s1)
    800051b6:	2785                	addiw	a5,a5,1
    800051b8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800051bc:	8526                	mv	a0,s1
    800051be:	da6fe0ef          	jal	80003764 <iupdate>
  iunlock(ip);
    800051c2:	8526                	mv	a0,s1
    800051c4:	f02fe0ef          	jal	800038c6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800051c8:	fd040593          	addi	a1,s0,-48
    800051cc:	f5040513          	addi	a0,s0,-176
    800051d0:	d3dfe0ef          	jal	80003f0c <nameiparent>
    800051d4:	892a                	mv	s2,a0
    800051d6:	cd21                	beqz	a0,8000522e <sys_link+0xce>
  ilock(dp);
    800051d8:	e40fe0ef          	jal	80003818 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800051dc:	00092703          	lw	a4,0(s2)
    800051e0:	409c                	lw	a5,0(s1)
    800051e2:	04f71363          	bne	a4,a5,80005228 <sys_link+0xc8>
    800051e6:	40d0                	lw	a2,4(s1)
    800051e8:	fd040593          	addi	a1,s0,-48
    800051ec:	854a                	mv	a0,s2
    800051ee:	c6bfe0ef          	jal	80003e58 <dirlink>
    800051f2:	02054b63          	bltz	a0,80005228 <sys_link+0xc8>
  iunlockput(dp);
    800051f6:	854a                	mv	a0,s2
    800051f8:	82bfe0ef          	jal	80003a22 <iunlockput>
  iput(ip);
    800051fc:	8526                	mv	a0,s1
    800051fe:	f9cfe0ef          	jal	8000399a <iput>
  end_op();
    80005202:	f17fe0ef          	jal	80004118 <end_op>
  return 0;
    80005206:	4781                	li	a5,0
    80005208:	64f2                	ld	s1,280(sp)
    8000520a:	6952                	ld	s2,272(sp)
    8000520c:	a0a1                	j	80005254 <sys_link+0xf4>
    end_op();
    8000520e:	f0bfe0ef          	jal	80004118 <end_op>
    return -1;
    80005212:	57fd                	li	a5,-1
    80005214:	64f2                	ld	s1,280(sp)
    80005216:	a83d                	j	80005254 <sys_link+0xf4>
    iunlockput(ip);
    80005218:	8526                	mv	a0,s1
    8000521a:	809fe0ef          	jal	80003a22 <iunlockput>
    end_op();
    8000521e:	efbfe0ef          	jal	80004118 <end_op>
    return -1;
    80005222:	57fd                	li	a5,-1
    80005224:	64f2                	ld	s1,280(sp)
    80005226:	a03d                	j	80005254 <sys_link+0xf4>
    iunlockput(dp);
    80005228:	854a                	mv	a0,s2
    8000522a:	ff8fe0ef          	jal	80003a22 <iunlockput>
  ilock(ip);
    8000522e:	8526                	mv	a0,s1
    80005230:	de8fe0ef          	jal	80003818 <ilock>
  ip->nlink--;
    80005234:	04a4d783          	lhu	a5,74(s1)
    80005238:	37fd                	addiw	a5,a5,-1
    8000523a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000523e:	8526                	mv	a0,s1
    80005240:	d24fe0ef          	jal	80003764 <iupdate>
  iunlockput(ip);
    80005244:	8526                	mv	a0,s1
    80005246:	fdcfe0ef          	jal	80003a22 <iunlockput>
  end_op();
    8000524a:	ecffe0ef          	jal	80004118 <end_op>
  return -1;
    8000524e:	57fd                	li	a5,-1
    80005250:	64f2                	ld	s1,280(sp)
    80005252:	6952                	ld	s2,272(sp)
}
    80005254:	853e                	mv	a0,a5
    80005256:	70b2                	ld	ra,296(sp)
    80005258:	7412                	ld	s0,288(sp)
    8000525a:	6155                	addi	sp,sp,304
    8000525c:	8082                	ret

000000008000525e <sys_unlink>:
{
    8000525e:	7151                	addi	sp,sp,-240
    80005260:	f586                	sd	ra,232(sp)
    80005262:	f1a2                	sd	s0,224(sp)
    80005264:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005266:	08000613          	li	a2,128
    8000526a:	f3040593          	addi	a1,s0,-208
    8000526e:	4501                	li	a0,0
    80005270:	95dfd0ef          	jal	80002bcc <argstr>
    80005274:	16054063          	bltz	a0,800053d4 <sys_unlink+0x176>
    80005278:	eda6                	sd	s1,216(sp)
  begin_op();
    8000527a:	e35fe0ef          	jal	800040ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000527e:	fb040593          	addi	a1,s0,-80
    80005282:	f3040513          	addi	a0,s0,-208
    80005286:	c87fe0ef          	jal	80003f0c <nameiparent>
    8000528a:	84aa                	mv	s1,a0
    8000528c:	c945                	beqz	a0,8000533c <sys_unlink+0xde>
  ilock(dp);
    8000528e:	d8afe0ef          	jal	80003818 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005292:	00003597          	auipc	a1,0x3
    80005296:	43658593          	addi	a1,a1,1078 # 800086c8 <etext+0x6c8>
    8000529a:	fb040513          	addi	a0,s0,-80
    8000529e:	9d9fe0ef          	jal	80003c76 <namecmp>
    800052a2:	10050e63          	beqz	a0,800053be <sys_unlink+0x160>
    800052a6:	00003597          	auipc	a1,0x3
    800052aa:	42a58593          	addi	a1,a1,1066 # 800086d0 <etext+0x6d0>
    800052ae:	fb040513          	addi	a0,s0,-80
    800052b2:	9c5fe0ef          	jal	80003c76 <namecmp>
    800052b6:	10050463          	beqz	a0,800053be <sys_unlink+0x160>
    800052ba:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800052bc:	f2c40613          	addi	a2,s0,-212
    800052c0:	fb040593          	addi	a1,s0,-80
    800052c4:	8526                	mv	a0,s1
    800052c6:	9c7fe0ef          	jal	80003c8c <dirlookup>
    800052ca:	892a                	mv	s2,a0
    800052cc:	0e050863          	beqz	a0,800053bc <sys_unlink+0x15e>
  ilock(ip);
    800052d0:	d48fe0ef          	jal	80003818 <ilock>
  if(ip->nlink < 1)
    800052d4:	04a91783          	lh	a5,74(s2)
    800052d8:	06f05763          	blez	a5,80005346 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800052dc:	04491703          	lh	a4,68(s2)
    800052e0:	4785                	li	a5,1
    800052e2:	06f70963          	beq	a4,a5,80005354 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800052e6:	4641                	li	a2,16
    800052e8:	4581                	li	a1,0
    800052ea:	fc040513          	addi	a0,s0,-64
    800052ee:	9e9fb0ef          	jal	80000cd6 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800052f2:	4741                	li	a4,16
    800052f4:	f2c42683          	lw	a3,-212(s0)
    800052f8:	fc040613          	addi	a2,s0,-64
    800052fc:	4581                	li	a1,0
    800052fe:	8526                	mv	a0,s1
    80005300:	869fe0ef          	jal	80003b68 <writei>
    80005304:	47c1                	li	a5,16
    80005306:	08f51b63          	bne	a0,a5,8000539c <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000530a:	04491703          	lh	a4,68(s2)
    8000530e:	4785                	li	a5,1
    80005310:	08f70d63          	beq	a4,a5,800053aa <sys_unlink+0x14c>
  iunlockput(dp);
    80005314:	8526                	mv	a0,s1
    80005316:	f0cfe0ef          	jal	80003a22 <iunlockput>
  ip->nlink--;
    8000531a:	04a95783          	lhu	a5,74(s2)
    8000531e:	37fd                	addiw	a5,a5,-1
    80005320:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005324:	854a                	mv	a0,s2
    80005326:	c3efe0ef          	jal	80003764 <iupdate>
  iunlockput(ip);
    8000532a:	854a                	mv	a0,s2
    8000532c:	ef6fe0ef          	jal	80003a22 <iunlockput>
  end_op();
    80005330:	de9fe0ef          	jal	80004118 <end_op>
  return 0;
    80005334:	4501                	li	a0,0
    80005336:	64ee                	ld	s1,216(sp)
    80005338:	694e                	ld	s2,208(sp)
    8000533a:	a849                	j	800053cc <sys_unlink+0x16e>
    end_op();
    8000533c:	dddfe0ef          	jal	80004118 <end_op>
    return -1;
    80005340:	557d                	li	a0,-1
    80005342:	64ee                	ld	s1,216(sp)
    80005344:	a061                	j	800053cc <sys_unlink+0x16e>
    80005346:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005348:	00003517          	auipc	a0,0x3
    8000534c:	39050513          	addi	a0,a0,912 # 800086d8 <etext+0x6d8>
    80005350:	c52fb0ef          	jal	800007a2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005354:	04c92703          	lw	a4,76(s2)
    80005358:	02000793          	li	a5,32
    8000535c:	f8e7f5e3          	bgeu	a5,a4,800052e6 <sys_unlink+0x88>
    80005360:	e5ce                	sd	s3,200(sp)
    80005362:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005366:	4741                	li	a4,16
    80005368:	86ce                	mv	a3,s3
    8000536a:	f1840613          	addi	a2,s0,-232
    8000536e:	4581                	li	a1,0
    80005370:	854a                	mv	a0,s2
    80005372:	efafe0ef          	jal	80003a6c <readi>
    80005376:	47c1                	li	a5,16
    80005378:	00f51c63          	bne	a0,a5,80005390 <sys_unlink+0x132>
    if(de.inum != 0)
    8000537c:	f1845783          	lhu	a5,-232(s0)
    80005380:	efa1                	bnez	a5,800053d8 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005382:	29c1                	addiw	s3,s3,16
    80005384:	04c92783          	lw	a5,76(s2)
    80005388:	fcf9efe3          	bltu	s3,a5,80005366 <sys_unlink+0x108>
    8000538c:	69ae                	ld	s3,200(sp)
    8000538e:	bfa1                	j	800052e6 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005390:	00003517          	auipc	a0,0x3
    80005394:	36050513          	addi	a0,a0,864 # 800086f0 <etext+0x6f0>
    80005398:	c0afb0ef          	jal	800007a2 <panic>
    8000539c:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    8000539e:	00003517          	auipc	a0,0x3
    800053a2:	36a50513          	addi	a0,a0,874 # 80008708 <etext+0x708>
    800053a6:	bfcfb0ef          	jal	800007a2 <panic>
    dp->nlink--;
    800053aa:	04a4d783          	lhu	a5,74(s1)
    800053ae:	37fd                	addiw	a5,a5,-1
    800053b0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800053b4:	8526                	mv	a0,s1
    800053b6:	baefe0ef          	jal	80003764 <iupdate>
    800053ba:	bfa9                	j	80005314 <sys_unlink+0xb6>
    800053bc:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800053be:	8526                	mv	a0,s1
    800053c0:	e62fe0ef          	jal	80003a22 <iunlockput>
  end_op();
    800053c4:	d55fe0ef          	jal	80004118 <end_op>
  return -1;
    800053c8:	557d                	li	a0,-1
    800053ca:	64ee                	ld	s1,216(sp)
}
    800053cc:	70ae                	ld	ra,232(sp)
    800053ce:	740e                	ld	s0,224(sp)
    800053d0:	616d                	addi	sp,sp,240
    800053d2:	8082                	ret
    return -1;
    800053d4:	557d                	li	a0,-1
    800053d6:	bfdd                	j	800053cc <sys_unlink+0x16e>
    iunlockput(ip);
    800053d8:	854a                	mv	a0,s2
    800053da:	e48fe0ef          	jal	80003a22 <iunlockput>
    goto bad;
    800053de:	694e                	ld	s2,208(sp)
    800053e0:	69ae                	ld	s3,200(sp)
    800053e2:	bff1                	j	800053be <sys_unlink+0x160>

00000000800053e4 <sys_open>:

uint64
sys_open(void)
{
    800053e4:	7131                	addi	sp,sp,-192
    800053e6:	fd06                	sd	ra,184(sp)
    800053e8:	f922                	sd	s0,176(sp)
    800053ea:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800053ec:	f4c40593          	addi	a1,s0,-180
    800053f0:	4505                	li	a0,1
    800053f2:	fa2fd0ef          	jal	80002b94 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800053f6:	08000613          	li	a2,128
    800053fa:	f5040593          	addi	a1,s0,-176
    800053fe:	4501                	li	a0,0
    80005400:	fccfd0ef          	jal	80002bcc <argstr>
    80005404:	87aa                	mv	a5,a0
    return -1;
    80005406:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005408:	0a07c263          	bltz	a5,800054ac <sys_open+0xc8>
    8000540c:	f526                	sd	s1,168(sp)

  begin_op();
    8000540e:	ca1fe0ef          	jal	800040ae <begin_op>

  if(omode & O_CREATE){
    80005412:	f4c42783          	lw	a5,-180(s0)
    80005416:	2007f793          	andi	a5,a5,512
    8000541a:	c3d5                	beqz	a5,800054be <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    8000541c:	4681                	li	a3,0
    8000541e:	4601                	li	a2,0
    80005420:	4589                	li	a1,2
    80005422:	f5040513          	addi	a0,s0,-176
    80005426:	aa9ff0ef          	jal	80004ece <create>
    8000542a:	84aa                	mv	s1,a0
    if(ip == 0){
    8000542c:	c541                	beqz	a0,800054b4 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000542e:	04449703          	lh	a4,68(s1)
    80005432:	478d                	li	a5,3
    80005434:	00f71763          	bne	a4,a5,80005442 <sys_open+0x5e>
    80005438:	0464d703          	lhu	a4,70(s1)
    8000543c:	47a5                	li	a5,9
    8000543e:	0ae7ed63          	bltu	a5,a4,800054f8 <sys_open+0x114>
    80005442:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005444:	fe1fe0ef          	jal	80004424 <filealloc>
    80005448:	892a                	mv	s2,a0
    8000544a:	c179                	beqz	a0,80005510 <sys_open+0x12c>
    8000544c:	ed4e                	sd	s3,152(sp)
    8000544e:	a43ff0ef          	jal	80004e90 <fdalloc>
    80005452:	89aa                	mv	s3,a0
    80005454:	0a054a63          	bltz	a0,80005508 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005458:	04449703          	lh	a4,68(s1)
    8000545c:	478d                	li	a5,3
    8000545e:	0cf70263          	beq	a4,a5,80005522 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005462:	4789                	li	a5,2
    80005464:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005468:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000546c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005470:	f4c42783          	lw	a5,-180(s0)
    80005474:	0017c713          	xori	a4,a5,1
    80005478:	8b05                	andi	a4,a4,1
    8000547a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000547e:	0037f713          	andi	a4,a5,3
    80005482:	00e03733          	snez	a4,a4
    80005486:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000548a:	4007f793          	andi	a5,a5,1024
    8000548e:	c791                	beqz	a5,8000549a <sys_open+0xb6>
    80005490:	04449703          	lh	a4,68(s1)
    80005494:	4789                	li	a5,2
    80005496:	08f70d63          	beq	a4,a5,80005530 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    8000549a:	8526                	mv	a0,s1
    8000549c:	c2afe0ef          	jal	800038c6 <iunlock>
  end_op();
    800054a0:	c79fe0ef          	jal	80004118 <end_op>

  return fd;
    800054a4:	854e                	mv	a0,s3
    800054a6:	74aa                	ld	s1,168(sp)
    800054a8:	790a                	ld	s2,160(sp)
    800054aa:	69ea                	ld	s3,152(sp)
}
    800054ac:	70ea                	ld	ra,184(sp)
    800054ae:	744a                	ld	s0,176(sp)
    800054b0:	6129                	addi	sp,sp,192
    800054b2:	8082                	ret
      end_op();
    800054b4:	c65fe0ef          	jal	80004118 <end_op>
      return -1;
    800054b8:	557d                	li	a0,-1
    800054ba:	74aa                	ld	s1,168(sp)
    800054bc:	bfc5                	j	800054ac <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800054be:	f5040513          	addi	a0,s0,-176
    800054c2:	a31fe0ef          	jal	80003ef2 <namei>
    800054c6:	84aa                	mv	s1,a0
    800054c8:	c11d                	beqz	a0,800054ee <sys_open+0x10a>
    ilock(ip);
    800054ca:	b4efe0ef          	jal	80003818 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800054ce:	04449703          	lh	a4,68(s1)
    800054d2:	4785                	li	a5,1
    800054d4:	f4f71de3          	bne	a4,a5,8000542e <sys_open+0x4a>
    800054d8:	f4c42783          	lw	a5,-180(s0)
    800054dc:	d3bd                	beqz	a5,80005442 <sys_open+0x5e>
      iunlockput(ip);
    800054de:	8526                	mv	a0,s1
    800054e0:	d42fe0ef          	jal	80003a22 <iunlockput>
      end_op();
    800054e4:	c35fe0ef          	jal	80004118 <end_op>
      return -1;
    800054e8:	557d                	li	a0,-1
    800054ea:	74aa                	ld	s1,168(sp)
    800054ec:	b7c1                	j	800054ac <sys_open+0xc8>
      end_op();
    800054ee:	c2bfe0ef          	jal	80004118 <end_op>
      return -1;
    800054f2:	557d                	li	a0,-1
    800054f4:	74aa                	ld	s1,168(sp)
    800054f6:	bf5d                	j	800054ac <sys_open+0xc8>
    iunlockput(ip);
    800054f8:	8526                	mv	a0,s1
    800054fa:	d28fe0ef          	jal	80003a22 <iunlockput>
    end_op();
    800054fe:	c1bfe0ef          	jal	80004118 <end_op>
    return -1;
    80005502:	557d                	li	a0,-1
    80005504:	74aa                	ld	s1,168(sp)
    80005506:	b75d                	j	800054ac <sys_open+0xc8>
      fileclose(f);
    80005508:	854a                	mv	a0,s2
    8000550a:	fbffe0ef          	jal	800044c8 <fileclose>
    8000550e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005510:	8526                	mv	a0,s1
    80005512:	d10fe0ef          	jal	80003a22 <iunlockput>
    end_op();
    80005516:	c03fe0ef          	jal	80004118 <end_op>
    return -1;
    8000551a:	557d                	li	a0,-1
    8000551c:	74aa                	ld	s1,168(sp)
    8000551e:	790a                	ld	s2,160(sp)
    80005520:	b771                	j	800054ac <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005522:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005526:	04649783          	lh	a5,70(s1)
    8000552a:	02f91223          	sh	a5,36(s2)
    8000552e:	bf3d                	j	8000546c <sys_open+0x88>
    itrunc(ip);
    80005530:	8526                	mv	a0,s1
    80005532:	bd4fe0ef          	jal	80003906 <itrunc>
    80005536:	b795                	j	8000549a <sys_open+0xb6>

0000000080005538 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005538:	7175                	addi	sp,sp,-144
    8000553a:	e506                	sd	ra,136(sp)
    8000553c:	e122                	sd	s0,128(sp)
    8000553e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005540:	b6ffe0ef          	jal	800040ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005544:	08000613          	li	a2,128
    80005548:	f7040593          	addi	a1,s0,-144
    8000554c:	4501                	li	a0,0
    8000554e:	e7efd0ef          	jal	80002bcc <argstr>
    80005552:	02054363          	bltz	a0,80005578 <sys_mkdir+0x40>
    80005556:	4681                	li	a3,0
    80005558:	4601                	li	a2,0
    8000555a:	4585                	li	a1,1
    8000555c:	f7040513          	addi	a0,s0,-144
    80005560:	96fff0ef          	jal	80004ece <create>
    80005564:	c911                	beqz	a0,80005578 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005566:	cbcfe0ef          	jal	80003a22 <iunlockput>
  end_op();
    8000556a:	baffe0ef          	jal	80004118 <end_op>
  return 0;
    8000556e:	4501                	li	a0,0
}
    80005570:	60aa                	ld	ra,136(sp)
    80005572:	640a                	ld	s0,128(sp)
    80005574:	6149                	addi	sp,sp,144
    80005576:	8082                	ret
    end_op();
    80005578:	ba1fe0ef          	jal	80004118 <end_op>
    return -1;
    8000557c:	557d                	li	a0,-1
    8000557e:	bfcd                	j	80005570 <sys_mkdir+0x38>

0000000080005580 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005580:	7135                	addi	sp,sp,-160
    80005582:	ed06                	sd	ra,152(sp)
    80005584:	e922                	sd	s0,144(sp)
    80005586:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005588:	b27fe0ef          	jal	800040ae <begin_op>
  argint(1, &major);
    8000558c:	f6c40593          	addi	a1,s0,-148
    80005590:	4505                	li	a0,1
    80005592:	e02fd0ef          	jal	80002b94 <argint>
  argint(2, &minor);
    80005596:	f6840593          	addi	a1,s0,-152
    8000559a:	4509                	li	a0,2
    8000559c:	df8fd0ef          	jal	80002b94 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800055a0:	08000613          	li	a2,128
    800055a4:	f7040593          	addi	a1,s0,-144
    800055a8:	4501                	li	a0,0
    800055aa:	e22fd0ef          	jal	80002bcc <argstr>
    800055ae:	02054563          	bltz	a0,800055d8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800055b2:	f6841683          	lh	a3,-152(s0)
    800055b6:	f6c41603          	lh	a2,-148(s0)
    800055ba:	458d                	li	a1,3
    800055bc:	f7040513          	addi	a0,s0,-144
    800055c0:	90fff0ef          	jal	80004ece <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800055c4:	c911                	beqz	a0,800055d8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800055c6:	c5cfe0ef          	jal	80003a22 <iunlockput>
  end_op();
    800055ca:	b4ffe0ef          	jal	80004118 <end_op>
  return 0;
    800055ce:	4501                	li	a0,0
}
    800055d0:	60ea                	ld	ra,152(sp)
    800055d2:	644a                	ld	s0,144(sp)
    800055d4:	610d                	addi	sp,sp,160
    800055d6:	8082                	ret
    end_op();
    800055d8:	b41fe0ef          	jal	80004118 <end_op>
    return -1;
    800055dc:	557d                	li	a0,-1
    800055de:	bfcd                	j	800055d0 <sys_mknod+0x50>

00000000800055e0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800055e0:	7135                	addi	sp,sp,-160
    800055e2:	ed06                	sd	ra,152(sp)
    800055e4:	e922                	sd	s0,144(sp)
    800055e6:	e14a                	sd	s2,128(sp)
    800055e8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800055ea:	b16fc0ef          	jal	80001900 <myproc>
    800055ee:	892a                	mv	s2,a0
  
  begin_op();
    800055f0:	abffe0ef          	jal	800040ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800055f4:	08000613          	li	a2,128
    800055f8:	f6040593          	addi	a1,s0,-160
    800055fc:	4501                	li	a0,0
    800055fe:	dcefd0ef          	jal	80002bcc <argstr>
    80005602:	04054363          	bltz	a0,80005648 <sys_chdir+0x68>
    80005606:	e526                	sd	s1,136(sp)
    80005608:	f6040513          	addi	a0,s0,-160
    8000560c:	8e7fe0ef          	jal	80003ef2 <namei>
    80005610:	84aa                	mv	s1,a0
    80005612:	c915                	beqz	a0,80005646 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005614:	a04fe0ef          	jal	80003818 <ilock>
  if(ip->type != T_DIR){
    80005618:	04449703          	lh	a4,68(s1)
    8000561c:	4785                	li	a5,1
    8000561e:	02f71963          	bne	a4,a5,80005650 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005622:	8526                	mv	a0,s1
    80005624:	aa2fe0ef          	jal	800038c6 <iunlock>
  iput(p->cwd);
    80005628:	15093503          	ld	a0,336(s2)
    8000562c:	b6efe0ef          	jal	8000399a <iput>
  end_op();
    80005630:	ae9fe0ef          	jal	80004118 <end_op>
  p->cwd = ip;
    80005634:	14993823          	sd	s1,336(s2)
  return 0;
    80005638:	4501                	li	a0,0
    8000563a:	64aa                	ld	s1,136(sp)
}
    8000563c:	60ea                	ld	ra,152(sp)
    8000563e:	644a                	ld	s0,144(sp)
    80005640:	690a                	ld	s2,128(sp)
    80005642:	610d                	addi	sp,sp,160
    80005644:	8082                	ret
    80005646:	64aa                	ld	s1,136(sp)
    end_op();
    80005648:	ad1fe0ef          	jal	80004118 <end_op>
    return -1;
    8000564c:	557d                	li	a0,-1
    8000564e:	b7fd                	j	8000563c <sys_chdir+0x5c>
    iunlockput(ip);
    80005650:	8526                	mv	a0,s1
    80005652:	bd0fe0ef          	jal	80003a22 <iunlockput>
    end_op();
    80005656:	ac3fe0ef          	jal	80004118 <end_op>
    return -1;
    8000565a:	557d                	li	a0,-1
    8000565c:	64aa                	ld	s1,136(sp)
    8000565e:	bff9                	j	8000563c <sys_chdir+0x5c>

0000000080005660 <sys_exec>:

uint64
sys_exec(void)
{
    80005660:	7121                	addi	sp,sp,-448
    80005662:	ff06                	sd	ra,440(sp)
    80005664:	fb22                	sd	s0,432(sp)
    80005666:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005668:	e4840593          	addi	a1,s0,-440
    8000566c:	4505                	li	a0,1
    8000566e:	d42fd0ef          	jal	80002bb0 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005672:	08000613          	li	a2,128
    80005676:	f5040593          	addi	a1,s0,-176
    8000567a:	4501                	li	a0,0
    8000567c:	d50fd0ef          	jal	80002bcc <argstr>
    80005680:	87aa                	mv	a5,a0
    return -1;
    80005682:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005684:	0c07c463          	bltz	a5,8000574c <sys_exec+0xec>
    80005688:	f726                	sd	s1,424(sp)
    8000568a:	f34a                	sd	s2,416(sp)
    8000568c:	ef4e                	sd	s3,408(sp)
    8000568e:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005690:	10000613          	li	a2,256
    80005694:	4581                	li	a1,0
    80005696:	e5040513          	addi	a0,s0,-432
    8000569a:	e3cfb0ef          	jal	80000cd6 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000569e:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800056a2:	89a6                	mv	s3,s1
    800056a4:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800056a6:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800056aa:	00391513          	slli	a0,s2,0x3
    800056ae:	e4040593          	addi	a1,s0,-448
    800056b2:	e4843783          	ld	a5,-440(s0)
    800056b6:	953e                	add	a0,a0,a5
    800056b8:	c52fd0ef          	jal	80002b0a <fetchaddr>
    800056bc:	02054663          	bltz	a0,800056e8 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800056c0:	e4043783          	ld	a5,-448(s0)
    800056c4:	c3a9                	beqz	a5,80005706 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800056c6:	c6cfb0ef          	jal	80000b32 <kalloc>
    800056ca:	85aa                	mv	a1,a0
    800056cc:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800056d0:	cd01                	beqz	a0,800056e8 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800056d2:	6605                	lui	a2,0x1
    800056d4:	e4043503          	ld	a0,-448(s0)
    800056d8:	c7cfd0ef          	jal	80002b54 <fetchstr>
    800056dc:	00054663          	bltz	a0,800056e8 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800056e0:	0905                	addi	s2,s2,1
    800056e2:	09a1                	addi	s3,s3,8
    800056e4:	fd4913e3          	bne	s2,s4,800056aa <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056e8:	f5040913          	addi	s2,s0,-176
    800056ec:	6088                	ld	a0,0(s1)
    800056ee:	c931                	beqz	a0,80005742 <sys_exec+0xe2>
    kfree(argv[i]);
    800056f0:	b60fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800056f4:	04a1                	addi	s1,s1,8
    800056f6:	ff249be3          	bne	s1,s2,800056ec <sys_exec+0x8c>
  return -1;
    800056fa:	557d                	li	a0,-1
    800056fc:	74ba                	ld	s1,424(sp)
    800056fe:	791a                	ld	s2,416(sp)
    80005700:	69fa                	ld	s3,408(sp)
    80005702:	6a5a                	ld	s4,400(sp)
    80005704:	a0a1                	j	8000574c <sys_exec+0xec>
      argv[i] = 0;
    80005706:	0009079b          	sext.w	a5,s2
    8000570a:	078e                	slli	a5,a5,0x3
    8000570c:	fd078793          	addi	a5,a5,-48
    80005710:	97a2                	add	a5,a5,s0
    80005712:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005716:	e5040593          	addi	a1,s0,-432
    8000571a:	f5040513          	addi	a0,s0,-176
    8000571e:	ba8ff0ef          	jal	80004ac6 <exec>
    80005722:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005724:	f5040993          	addi	s3,s0,-176
    80005728:	6088                	ld	a0,0(s1)
    8000572a:	c511                	beqz	a0,80005736 <sys_exec+0xd6>
    kfree(argv[i]);
    8000572c:	b24fb0ef          	jal	80000a50 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005730:	04a1                	addi	s1,s1,8
    80005732:	ff349be3          	bne	s1,s3,80005728 <sys_exec+0xc8>
  return ret;
    80005736:	854a                	mv	a0,s2
    80005738:	74ba                	ld	s1,424(sp)
    8000573a:	791a                	ld	s2,416(sp)
    8000573c:	69fa                	ld	s3,408(sp)
    8000573e:	6a5a                	ld	s4,400(sp)
    80005740:	a031                	j	8000574c <sys_exec+0xec>
  return -1;
    80005742:	557d                	li	a0,-1
    80005744:	74ba                	ld	s1,424(sp)
    80005746:	791a                	ld	s2,416(sp)
    80005748:	69fa                	ld	s3,408(sp)
    8000574a:	6a5a                	ld	s4,400(sp)
}
    8000574c:	70fa                	ld	ra,440(sp)
    8000574e:	745a                	ld	s0,432(sp)
    80005750:	6139                	addi	sp,sp,448
    80005752:	8082                	ret

0000000080005754 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005754:	7139                	addi	sp,sp,-64
    80005756:	fc06                	sd	ra,56(sp)
    80005758:	f822                	sd	s0,48(sp)
    8000575a:	f426                	sd	s1,40(sp)
    8000575c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000575e:	9a2fc0ef          	jal	80001900 <myproc>
    80005762:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005764:	fd840593          	addi	a1,s0,-40
    80005768:	4501                	li	a0,0
    8000576a:	c46fd0ef          	jal	80002bb0 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000576e:	fc840593          	addi	a1,s0,-56
    80005772:	fd040513          	addi	a0,s0,-48
    80005776:	85cff0ef          	jal	800047d2 <pipealloc>
    return -1;
    8000577a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000577c:	0a054463          	bltz	a0,80005824 <sys_pipe+0xd0>
  fd0 = -1;
    80005780:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005784:	fd043503          	ld	a0,-48(s0)
    80005788:	f08ff0ef          	jal	80004e90 <fdalloc>
    8000578c:	fca42223          	sw	a0,-60(s0)
    80005790:	08054163          	bltz	a0,80005812 <sys_pipe+0xbe>
    80005794:	fc843503          	ld	a0,-56(s0)
    80005798:	ef8ff0ef          	jal	80004e90 <fdalloc>
    8000579c:	fca42023          	sw	a0,-64(s0)
    800057a0:	06054063          	bltz	a0,80005800 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057a4:	4691                	li	a3,4
    800057a6:	fc440613          	addi	a2,s0,-60
    800057aa:	fd843583          	ld	a1,-40(s0)
    800057ae:	68a8                	ld	a0,80(s1)
    800057b0:	dc3fb0ef          	jal	80001572 <copyout>
    800057b4:	00054e63          	bltz	a0,800057d0 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800057b8:	4691                	li	a3,4
    800057ba:	fc040613          	addi	a2,s0,-64
    800057be:	fd843583          	ld	a1,-40(s0)
    800057c2:	0591                	addi	a1,a1,4
    800057c4:	68a8                	ld	a0,80(s1)
    800057c6:	dadfb0ef          	jal	80001572 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800057ca:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800057cc:	04055c63          	bgez	a0,80005824 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800057d0:	fc442783          	lw	a5,-60(s0)
    800057d4:	07e9                	addi	a5,a5,26
    800057d6:	078e                	slli	a5,a5,0x3
    800057d8:	97a6                	add	a5,a5,s1
    800057da:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800057de:	fc042783          	lw	a5,-64(s0)
    800057e2:	07e9                	addi	a5,a5,26
    800057e4:	078e                	slli	a5,a5,0x3
    800057e6:	94be                	add	s1,s1,a5
    800057e8:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    800057ec:	fd043503          	ld	a0,-48(s0)
    800057f0:	cd9fe0ef          	jal	800044c8 <fileclose>
    fileclose(wf);
    800057f4:	fc843503          	ld	a0,-56(s0)
    800057f8:	cd1fe0ef          	jal	800044c8 <fileclose>
    return -1;
    800057fc:	57fd                	li	a5,-1
    800057fe:	a01d                	j	80005824 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005800:	fc442783          	lw	a5,-60(s0)
    80005804:	0007c763          	bltz	a5,80005812 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005808:	07e9                	addi	a5,a5,26
    8000580a:	078e                	slli	a5,a5,0x3
    8000580c:	97a6                	add	a5,a5,s1
    8000580e:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005812:	fd043503          	ld	a0,-48(s0)
    80005816:	cb3fe0ef          	jal	800044c8 <fileclose>
    fileclose(wf);
    8000581a:	fc843503          	ld	a0,-56(s0)
    8000581e:	cabfe0ef          	jal	800044c8 <fileclose>
    return -1;
    80005822:	57fd                	li	a5,-1
}
    80005824:	853e                	mv	a0,a5
    80005826:	70e2                	ld	ra,56(sp)
    80005828:	7442                	ld	s0,48(sp)
    8000582a:	74a2                	ld	s1,40(sp)
    8000582c:	6121                	addi	sp,sp,64
    8000582e:	8082                	ret

0000000080005830 <kernelvec>:
    80005830:	7111                	addi	sp,sp,-256
    80005832:	e006                	sd	ra,0(sp)
    80005834:	e40a                	sd	sp,8(sp)
    80005836:	e80e                	sd	gp,16(sp)
    80005838:	ec12                	sd	tp,24(sp)
    8000583a:	f016                	sd	t0,32(sp)
    8000583c:	f41a                	sd	t1,40(sp)
    8000583e:	f81e                	sd	t2,48(sp)
    80005840:	e4aa                	sd	a0,72(sp)
    80005842:	e8ae                	sd	a1,80(sp)
    80005844:	ecb2                	sd	a2,88(sp)
    80005846:	f0b6                	sd	a3,96(sp)
    80005848:	f4ba                	sd	a4,104(sp)
    8000584a:	f8be                	sd	a5,112(sp)
    8000584c:	fcc2                	sd	a6,120(sp)
    8000584e:	e146                	sd	a7,128(sp)
    80005850:	edf2                	sd	t3,216(sp)
    80005852:	f1f6                	sd	t4,224(sp)
    80005854:	f5fa                	sd	t5,232(sp)
    80005856:	f9fe                	sd	t6,240(sp)
    80005858:	9c2fd0ef          	jal	80002a1a <kerneltrap>
    8000585c:	6082                	ld	ra,0(sp)
    8000585e:	6122                	ld	sp,8(sp)
    80005860:	61c2                	ld	gp,16(sp)
    80005862:	7282                	ld	t0,32(sp)
    80005864:	7322                	ld	t1,40(sp)
    80005866:	73c2                	ld	t2,48(sp)
    80005868:	6526                	ld	a0,72(sp)
    8000586a:	65c6                	ld	a1,80(sp)
    8000586c:	6666                	ld	a2,88(sp)
    8000586e:	7686                	ld	a3,96(sp)
    80005870:	7726                	ld	a4,104(sp)
    80005872:	77c6                	ld	a5,112(sp)
    80005874:	7866                	ld	a6,120(sp)
    80005876:	688a                	ld	a7,128(sp)
    80005878:	6e6e                	ld	t3,216(sp)
    8000587a:	7e8e                	ld	t4,224(sp)
    8000587c:	7f2e                	ld	t5,232(sp)
    8000587e:	7fce                	ld	t6,240(sp)
    80005880:	6111                	addi	sp,sp,256
    80005882:	10200073          	sret
	...

000000008000588e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000588e:	1141                	addi	sp,sp,-16
    80005890:	e422                	sd	s0,8(sp)
    80005892:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005894:	0c0007b7          	lui	a5,0xc000
    80005898:	4705                	li	a4,1
    8000589a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000589c:	0c0007b7          	lui	a5,0xc000
    800058a0:	c3d8                	sw	a4,4(a5)
}
    800058a2:	6422                	ld	s0,8(sp)
    800058a4:	0141                	addi	sp,sp,16
    800058a6:	8082                	ret

00000000800058a8 <plicinithart>:

void
plicinithart(void)
{
    800058a8:	1141                	addi	sp,sp,-16
    800058aa:	e406                	sd	ra,8(sp)
    800058ac:	e022                	sd	s0,0(sp)
    800058ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800058b0:	824fc0ef          	jal	800018d4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800058b4:	0085171b          	slliw	a4,a0,0x8
    800058b8:	0c0027b7          	lui	a5,0xc002
    800058bc:	97ba                	add	a5,a5,a4
    800058be:	40200713          	li	a4,1026
    800058c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800058c6:	00d5151b          	slliw	a0,a0,0xd
    800058ca:	0c2017b7          	lui	a5,0xc201
    800058ce:	97aa                	add	a5,a5,a0
    800058d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800058d4:	60a2                	ld	ra,8(sp)
    800058d6:	6402                	ld	s0,0(sp)
    800058d8:	0141                	addi	sp,sp,16
    800058da:	8082                	ret

00000000800058dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800058dc:	1141                	addi	sp,sp,-16
    800058de:	e406                	sd	ra,8(sp)
    800058e0:	e022                	sd	s0,0(sp)
    800058e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800058e4:	ff1fb0ef          	jal	800018d4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800058e8:	00d5151b          	slliw	a0,a0,0xd
    800058ec:	0c2017b7          	lui	a5,0xc201
    800058f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800058f2:	43c8                	lw	a0,4(a5)
    800058f4:	60a2                	ld	ra,8(sp)
    800058f6:	6402                	ld	s0,0(sp)
    800058f8:	0141                	addi	sp,sp,16
    800058fa:	8082                	ret

00000000800058fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800058fc:	1101                	addi	sp,sp,-32
    800058fe:	ec06                	sd	ra,24(sp)
    80005900:	e822                	sd	s0,16(sp)
    80005902:	e426                	sd	s1,8(sp)
    80005904:	1000                	addi	s0,sp,32
    80005906:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005908:	fcdfb0ef          	jal	800018d4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000590c:	00d5151b          	slliw	a0,a0,0xd
    80005910:	0c2017b7          	lui	a5,0xc201
    80005914:	97aa                	add	a5,a5,a0
    80005916:	c3c4                	sw	s1,4(a5)
}
    80005918:	60e2                	ld	ra,24(sp)
    8000591a:	6442                	ld	s0,16(sp)
    8000591c:	64a2                	ld	s1,8(sp)
    8000591e:	6105                	addi	sp,sp,32
    80005920:	8082                	ret

0000000080005922 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005922:	1141                	addi	sp,sp,-16
    80005924:	e406                	sd	ra,8(sp)
    80005926:	e022                	sd	s0,0(sp)
    80005928:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000592a:	479d                	li	a5,7
    8000592c:	04a7ca63          	blt	a5,a0,80005980 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005930:	0001f797          	auipc	a5,0x1f
    80005934:	54878793          	addi	a5,a5,1352 # 80024e78 <disk>
    80005938:	97aa                	add	a5,a5,a0
    8000593a:	0187c783          	lbu	a5,24(a5)
    8000593e:	e7b9                	bnez	a5,8000598c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005940:	00451693          	slli	a3,a0,0x4
    80005944:	0001f797          	auipc	a5,0x1f
    80005948:	53478793          	addi	a5,a5,1332 # 80024e78 <disk>
    8000594c:	6398                	ld	a4,0(a5)
    8000594e:	9736                	add	a4,a4,a3
    80005950:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005954:	6398                	ld	a4,0(a5)
    80005956:	9736                	add	a4,a4,a3
    80005958:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000595c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005960:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005964:	97aa                	add	a5,a5,a0
    80005966:	4705                	li	a4,1
    80005968:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000596c:	0001f517          	auipc	a0,0x1f
    80005970:	52450513          	addi	a0,a0,1316 # 80024e90 <disk+0x18>
    80005974:	fccfc0ef          	jal	80002140 <wakeup>
}
    80005978:	60a2                	ld	ra,8(sp)
    8000597a:	6402                	ld	s0,0(sp)
    8000597c:	0141                	addi	sp,sp,16
    8000597e:	8082                	ret
    panic("free_desc 1");
    80005980:	00003517          	auipc	a0,0x3
    80005984:	d9850513          	addi	a0,a0,-616 # 80008718 <etext+0x718>
    80005988:	e1bfa0ef          	jal	800007a2 <panic>
    panic("free_desc 2");
    8000598c:	00003517          	auipc	a0,0x3
    80005990:	d9c50513          	addi	a0,a0,-612 # 80008728 <etext+0x728>
    80005994:	e0ffa0ef          	jal	800007a2 <panic>

0000000080005998 <virtio_disk_init>:
{
    80005998:	1101                	addi	sp,sp,-32
    8000599a:	ec06                	sd	ra,24(sp)
    8000599c:	e822                	sd	s0,16(sp)
    8000599e:	e426                	sd	s1,8(sp)
    800059a0:	e04a                	sd	s2,0(sp)
    800059a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800059a4:	00003597          	auipc	a1,0x3
    800059a8:	d9458593          	addi	a1,a1,-620 # 80008738 <etext+0x738>
    800059ac:	0001f517          	auipc	a0,0x1f
    800059b0:	5f450513          	addi	a0,a0,1524 # 80024fa0 <disk+0x128>
    800059b4:	9cefb0ef          	jal	80000b82 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059b8:	100017b7          	lui	a5,0x10001
    800059bc:	4398                	lw	a4,0(a5)
    800059be:	2701                	sext.w	a4,a4
    800059c0:	747277b7          	lui	a5,0x74727
    800059c4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800059c8:	18f71063          	bne	a4,a5,80005b48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800059cc:	100017b7          	lui	a5,0x10001
    800059d0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800059d2:	439c                	lw	a5,0(a5)
    800059d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800059d6:	4709                	li	a4,2
    800059d8:	16e79863          	bne	a5,a4,80005b48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059dc:	100017b7          	lui	a5,0x10001
    800059e0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800059e2:	439c                	lw	a5,0(a5)
    800059e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800059e6:	16e79163          	bne	a5,a4,80005b48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800059ea:	100017b7          	lui	a5,0x10001
    800059ee:	47d8                	lw	a4,12(a5)
    800059f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800059f2:	554d47b7          	lui	a5,0x554d4
    800059f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800059fa:	14f71763          	bne	a4,a5,80005b48 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800059fe:	100017b7          	lui	a5,0x10001
    80005a02:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a06:	4705                	li	a4,1
    80005a08:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a0a:	470d                	li	a4,3
    80005a0c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005a0e:	10001737          	lui	a4,0x10001
    80005a12:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005a14:	c7ffe737          	lui	a4,0xc7ffe
    80005a18:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd97a7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005a1c:	8ef9                	and	a3,a3,a4
    80005a1e:	10001737          	lui	a4,0x10001
    80005a22:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a24:	472d                	li	a4,11
    80005a26:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a28:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005a2c:	439c                	lw	a5,0(a5)
    80005a2e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005a32:	8ba1                	andi	a5,a5,8
    80005a34:	12078063          	beqz	a5,80005b54 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005a38:	100017b7          	lui	a5,0x10001
    80005a3c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005a40:	100017b7          	lui	a5,0x10001
    80005a44:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005a48:	439c                	lw	a5,0(a5)
    80005a4a:	2781                	sext.w	a5,a5
    80005a4c:	10079a63          	bnez	a5,80005b60 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005a50:	100017b7          	lui	a5,0x10001
    80005a54:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005a58:	439c                	lw	a5,0(a5)
    80005a5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80005a5c:	10078863          	beqz	a5,80005b6c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005a60:	471d                	li	a4,7
    80005a62:	10f77b63          	bgeu	a4,a5,80005b78 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005a66:	8ccfb0ef          	jal	80000b32 <kalloc>
    80005a6a:	0001f497          	auipc	s1,0x1f
    80005a6e:	40e48493          	addi	s1,s1,1038 # 80024e78 <disk>
    80005a72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005a74:	8befb0ef          	jal	80000b32 <kalloc>
    80005a78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005a7a:	8b8fb0ef          	jal	80000b32 <kalloc>
    80005a7e:	87aa                	mv	a5,a0
    80005a80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005a82:	6088                	ld	a0,0(s1)
    80005a84:	10050063          	beqz	a0,80005b84 <virtio_disk_init+0x1ec>
    80005a88:	0001f717          	auipc	a4,0x1f
    80005a8c:	3f873703          	ld	a4,1016(a4) # 80024e80 <disk+0x8>
    80005a90:	0e070a63          	beqz	a4,80005b84 <virtio_disk_init+0x1ec>
    80005a94:	0e078863          	beqz	a5,80005b84 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005a98:	6605                	lui	a2,0x1
    80005a9a:	4581                	li	a1,0
    80005a9c:	a3afb0ef          	jal	80000cd6 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005aa0:	0001f497          	auipc	s1,0x1f
    80005aa4:	3d848493          	addi	s1,s1,984 # 80024e78 <disk>
    80005aa8:	6605                	lui	a2,0x1
    80005aaa:	4581                	li	a1,0
    80005aac:	6488                	ld	a0,8(s1)
    80005aae:	a28fb0ef          	jal	80000cd6 <memset>
  memset(disk.used, 0, PGSIZE);
    80005ab2:	6605                	lui	a2,0x1
    80005ab4:	4581                	li	a1,0
    80005ab6:	6888                	ld	a0,16(s1)
    80005ab8:	a1efb0ef          	jal	80000cd6 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005abc:	100017b7          	lui	a5,0x10001
    80005ac0:	4721                	li	a4,8
    80005ac2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005ac4:	4098                	lw	a4,0(s1)
    80005ac6:	100017b7          	lui	a5,0x10001
    80005aca:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005ace:	40d8                	lw	a4,4(s1)
    80005ad0:	100017b7          	lui	a5,0x10001
    80005ad4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005ad8:	649c                	ld	a5,8(s1)
    80005ada:	0007869b          	sext.w	a3,a5
    80005ade:	10001737          	lui	a4,0x10001
    80005ae2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005ae6:	9781                	srai	a5,a5,0x20
    80005ae8:	10001737          	lui	a4,0x10001
    80005aec:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005af0:	689c                	ld	a5,16(s1)
    80005af2:	0007869b          	sext.w	a3,a5
    80005af6:	10001737          	lui	a4,0x10001
    80005afa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005afe:	9781                	srai	a5,a5,0x20
    80005b00:	10001737          	lui	a4,0x10001
    80005b04:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005b08:	10001737          	lui	a4,0x10001
    80005b0c:	4785                	li	a5,1
    80005b0e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005b10:	00f48c23          	sb	a5,24(s1)
    80005b14:	00f48ca3          	sb	a5,25(s1)
    80005b18:	00f48d23          	sb	a5,26(s1)
    80005b1c:	00f48da3          	sb	a5,27(s1)
    80005b20:	00f48e23          	sb	a5,28(s1)
    80005b24:	00f48ea3          	sb	a5,29(s1)
    80005b28:	00f48f23          	sb	a5,30(s1)
    80005b2c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005b30:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005b34:	100017b7          	lui	a5,0x10001
    80005b38:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005b3c:	60e2                	ld	ra,24(sp)
    80005b3e:	6442                	ld	s0,16(sp)
    80005b40:	64a2                	ld	s1,8(sp)
    80005b42:	6902                	ld	s2,0(sp)
    80005b44:	6105                	addi	sp,sp,32
    80005b46:	8082                	ret
    panic("could not find virtio disk");
    80005b48:	00003517          	auipc	a0,0x3
    80005b4c:	c0050513          	addi	a0,a0,-1024 # 80008748 <etext+0x748>
    80005b50:	c53fa0ef          	jal	800007a2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005b54:	00003517          	auipc	a0,0x3
    80005b58:	c1450513          	addi	a0,a0,-1004 # 80008768 <etext+0x768>
    80005b5c:	c47fa0ef          	jal	800007a2 <panic>
    panic("virtio disk should not be ready");
    80005b60:	00003517          	auipc	a0,0x3
    80005b64:	c2850513          	addi	a0,a0,-984 # 80008788 <etext+0x788>
    80005b68:	c3bfa0ef          	jal	800007a2 <panic>
    panic("virtio disk has no queue 0");
    80005b6c:	00003517          	auipc	a0,0x3
    80005b70:	c3c50513          	addi	a0,a0,-964 # 800087a8 <etext+0x7a8>
    80005b74:	c2ffa0ef          	jal	800007a2 <panic>
    panic("virtio disk max queue too short");
    80005b78:	00003517          	auipc	a0,0x3
    80005b7c:	c5050513          	addi	a0,a0,-944 # 800087c8 <etext+0x7c8>
    80005b80:	c23fa0ef          	jal	800007a2 <panic>
    panic("virtio disk kalloc");
    80005b84:	00003517          	auipc	a0,0x3
    80005b88:	c6450513          	addi	a0,a0,-924 # 800087e8 <etext+0x7e8>
    80005b8c:	c17fa0ef          	jal	800007a2 <panic>

0000000080005b90 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005b90:	7159                	addi	sp,sp,-112
    80005b92:	f486                	sd	ra,104(sp)
    80005b94:	f0a2                	sd	s0,96(sp)
    80005b96:	eca6                	sd	s1,88(sp)
    80005b98:	e8ca                	sd	s2,80(sp)
    80005b9a:	e4ce                	sd	s3,72(sp)
    80005b9c:	e0d2                	sd	s4,64(sp)
    80005b9e:	fc56                	sd	s5,56(sp)
    80005ba0:	f85a                	sd	s6,48(sp)
    80005ba2:	f45e                	sd	s7,40(sp)
    80005ba4:	f062                	sd	s8,32(sp)
    80005ba6:	ec66                	sd	s9,24(sp)
    80005ba8:	1880                	addi	s0,sp,112
    80005baa:	8a2a                	mv	s4,a0
    80005bac:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005bae:	00c52c83          	lw	s9,12(a0)
    80005bb2:	001c9c9b          	slliw	s9,s9,0x1
    80005bb6:	1c82                	slli	s9,s9,0x20
    80005bb8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005bbc:	0001f517          	auipc	a0,0x1f
    80005bc0:	3e450513          	addi	a0,a0,996 # 80024fa0 <disk+0x128>
    80005bc4:	83efb0ef          	jal	80000c02 <acquire>
  for(int i = 0; i < 3; i++){
    80005bc8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005bca:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005bcc:	0001fb17          	auipc	s6,0x1f
    80005bd0:	2acb0b13          	addi	s6,s6,684 # 80024e78 <disk>
  for(int i = 0; i < 3; i++){
    80005bd4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005bd6:	0001fc17          	auipc	s8,0x1f
    80005bda:	3cac0c13          	addi	s8,s8,970 # 80024fa0 <disk+0x128>
    80005bde:	a8b9                	j	80005c3c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005be0:	00fb0733          	add	a4,s6,a5
    80005be4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005be8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005bea:	0207c563          	bltz	a5,80005c14 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005bee:	2905                	addiw	s2,s2,1
    80005bf0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005bf2:	05590963          	beq	s2,s5,80005c44 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005bf6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005bf8:	0001f717          	auipc	a4,0x1f
    80005bfc:	28070713          	addi	a4,a4,640 # 80024e78 <disk>
    80005c00:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005c02:	01874683          	lbu	a3,24(a4)
    80005c06:	fee9                	bnez	a3,80005be0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005c08:	2785                	addiw	a5,a5,1
    80005c0a:	0705                	addi	a4,a4,1
    80005c0c:	fe979be3          	bne	a5,s1,80005c02 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005c10:	57fd                	li	a5,-1
    80005c12:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005c14:	01205d63          	blez	s2,80005c2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c18:	f9042503          	lw	a0,-112(s0)
    80005c1c:	d07ff0ef          	jal	80005922 <free_desc>
      for(int j = 0; j < i; j++)
    80005c20:	4785                	li	a5,1
    80005c22:	0127d663          	bge	a5,s2,80005c2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005c26:	f9442503          	lw	a0,-108(s0)
    80005c2a:	cf9ff0ef          	jal	80005922 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005c2e:	85e2                	mv	a1,s8
    80005c30:	0001f517          	auipc	a0,0x1f
    80005c34:	26050513          	addi	a0,a0,608 # 80024e90 <disk+0x18>
    80005c38:	cbcfc0ef          	jal	800020f4 <sleep>
  for(int i = 0; i < 3; i++){
    80005c3c:	f9040613          	addi	a2,s0,-112
    80005c40:	894e                	mv	s2,s3
    80005c42:	bf55                	j	80005bf6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c44:	f9042503          	lw	a0,-112(s0)
    80005c48:	00451693          	slli	a3,a0,0x4

  if(write)
    80005c4c:	0001f797          	auipc	a5,0x1f
    80005c50:	22c78793          	addi	a5,a5,556 # 80024e78 <disk>
    80005c54:	00a50713          	addi	a4,a0,10
    80005c58:	0712                	slli	a4,a4,0x4
    80005c5a:	973e                	add	a4,a4,a5
    80005c5c:	01703633          	snez	a2,s7
    80005c60:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005c62:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005c66:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c6a:	6398                	ld	a4,0(a5)
    80005c6c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005c6e:	0a868613          	addi	a2,a3,168
    80005c72:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005c74:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005c76:	6390                	ld	a2,0(a5)
    80005c78:	00d605b3          	add	a1,a2,a3
    80005c7c:	4741                	li	a4,16
    80005c7e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005c80:	4805                	li	a6,1
    80005c82:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005c86:	f9442703          	lw	a4,-108(s0)
    80005c8a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005c8e:	0712                	slli	a4,a4,0x4
    80005c90:	963a                	add	a2,a2,a4
    80005c92:	058a0593          	addi	a1,s4,88
    80005c96:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005c98:	0007b883          	ld	a7,0(a5)
    80005c9c:	9746                	add	a4,a4,a7
    80005c9e:	40000613          	li	a2,1024
    80005ca2:	c710                	sw	a2,8(a4)
  if(write)
    80005ca4:	001bb613          	seqz	a2,s7
    80005ca8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005cac:	00166613          	ori	a2,a2,1
    80005cb0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005cb4:	f9842583          	lw	a1,-104(s0)
    80005cb8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005cbc:	00250613          	addi	a2,a0,2
    80005cc0:	0612                	slli	a2,a2,0x4
    80005cc2:	963e                	add	a2,a2,a5
    80005cc4:	577d                	li	a4,-1
    80005cc6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005cca:	0592                	slli	a1,a1,0x4
    80005ccc:	98ae                	add	a7,a7,a1
    80005cce:	03068713          	addi	a4,a3,48
    80005cd2:	973e                	add	a4,a4,a5
    80005cd4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005cd8:	6398                	ld	a4,0(a5)
    80005cda:	972e                	add	a4,a4,a1
    80005cdc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005ce0:	4689                	li	a3,2
    80005ce2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005ce6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005cea:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005cee:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005cf2:	6794                	ld	a3,8(a5)
    80005cf4:	0026d703          	lhu	a4,2(a3)
    80005cf8:	8b1d                	andi	a4,a4,7
    80005cfa:	0706                	slli	a4,a4,0x1
    80005cfc:	96ba                	add	a3,a3,a4
    80005cfe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005d02:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005d06:	6798                	ld	a4,8(a5)
    80005d08:	00275783          	lhu	a5,2(a4)
    80005d0c:	2785                	addiw	a5,a5,1
    80005d0e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005d12:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005d16:	100017b7          	lui	a5,0x10001
    80005d1a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005d1e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005d22:	0001f917          	auipc	s2,0x1f
    80005d26:	27e90913          	addi	s2,s2,638 # 80024fa0 <disk+0x128>
  while(b->disk == 1) {
    80005d2a:	4485                	li	s1,1
    80005d2c:	01079a63          	bne	a5,a6,80005d40 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005d30:	85ca                	mv	a1,s2
    80005d32:	8552                	mv	a0,s4
    80005d34:	bc0fc0ef          	jal	800020f4 <sleep>
  while(b->disk == 1) {
    80005d38:	004a2783          	lw	a5,4(s4)
    80005d3c:	fe978ae3          	beq	a5,s1,80005d30 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005d40:	f9042903          	lw	s2,-112(s0)
    80005d44:	00290713          	addi	a4,s2,2
    80005d48:	0712                	slli	a4,a4,0x4
    80005d4a:	0001f797          	auipc	a5,0x1f
    80005d4e:	12e78793          	addi	a5,a5,302 # 80024e78 <disk>
    80005d52:	97ba                	add	a5,a5,a4
    80005d54:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005d58:	0001f997          	auipc	s3,0x1f
    80005d5c:	12098993          	addi	s3,s3,288 # 80024e78 <disk>
    80005d60:	00491713          	slli	a4,s2,0x4
    80005d64:	0009b783          	ld	a5,0(s3)
    80005d68:	97ba                	add	a5,a5,a4
    80005d6a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005d6e:	854a                	mv	a0,s2
    80005d70:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005d74:	bafff0ef          	jal	80005922 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005d78:	8885                	andi	s1,s1,1
    80005d7a:	f0fd                	bnez	s1,80005d60 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005d7c:	0001f517          	auipc	a0,0x1f
    80005d80:	22450513          	addi	a0,a0,548 # 80024fa0 <disk+0x128>
    80005d84:	f17fa0ef          	jal	80000c9a <release>
}
    80005d88:	70a6                	ld	ra,104(sp)
    80005d8a:	7406                	ld	s0,96(sp)
    80005d8c:	64e6                	ld	s1,88(sp)
    80005d8e:	6946                	ld	s2,80(sp)
    80005d90:	69a6                	ld	s3,72(sp)
    80005d92:	6a06                	ld	s4,64(sp)
    80005d94:	7ae2                	ld	s5,56(sp)
    80005d96:	7b42                	ld	s6,48(sp)
    80005d98:	7ba2                	ld	s7,40(sp)
    80005d9a:	7c02                	ld	s8,32(sp)
    80005d9c:	6ce2                	ld	s9,24(sp)
    80005d9e:	6165                	addi	sp,sp,112
    80005da0:	8082                	ret

0000000080005da2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005da2:	1101                	addi	sp,sp,-32
    80005da4:	ec06                	sd	ra,24(sp)
    80005da6:	e822                	sd	s0,16(sp)
    80005da8:	e426                	sd	s1,8(sp)
    80005daa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005dac:	0001f497          	auipc	s1,0x1f
    80005db0:	0cc48493          	addi	s1,s1,204 # 80024e78 <disk>
    80005db4:	0001f517          	auipc	a0,0x1f
    80005db8:	1ec50513          	addi	a0,a0,492 # 80024fa0 <disk+0x128>
    80005dbc:	e47fa0ef          	jal	80000c02 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005dc0:	100017b7          	lui	a5,0x10001
    80005dc4:	53b8                	lw	a4,96(a5)
    80005dc6:	8b0d                	andi	a4,a4,3
    80005dc8:	100017b7          	lui	a5,0x10001
    80005dcc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005dce:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005dd2:	689c                	ld	a5,16(s1)
    80005dd4:	0204d703          	lhu	a4,32(s1)
    80005dd8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005ddc:	04f70663          	beq	a4,a5,80005e28 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005de0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005de4:	6898                	ld	a4,16(s1)
    80005de6:	0204d783          	lhu	a5,32(s1)
    80005dea:	8b9d                	andi	a5,a5,7
    80005dec:	078e                	slli	a5,a5,0x3
    80005dee:	97ba                	add	a5,a5,a4
    80005df0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005df2:	00278713          	addi	a4,a5,2
    80005df6:	0712                	slli	a4,a4,0x4
    80005df8:	9726                	add	a4,a4,s1
    80005dfa:	01074703          	lbu	a4,16(a4)
    80005dfe:	e321                	bnez	a4,80005e3e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005e00:	0789                	addi	a5,a5,2
    80005e02:	0792                	slli	a5,a5,0x4
    80005e04:	97a6                	add	a5,a5,s1
    80005e06:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005e08:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005e0c:	b34fc0ef          	jal	80002140 <wakeup>

    disk.used_idx += 1;
    80005e10:	0204d783          	lhu	a5,32(s1)
    80005e14:	2785                	addiw	a5,a5,1
    80005e16:	17c2                	slli	a5,a5,0x30
    80005e18:	93c1                	srli	a5,a5,0x30
    80005e1a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005e1e:	6898                	ld	a4,16(s1)
    80005e20:	00275703          	lhu	a4,2(a4)
    80005e24:	faf71ee3          	bne	a4,a5,80005de0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005e28:	0001f517          	auipc	a0,0x1f
    80005e2c:	17850513          	addi	a0,a0,376 # 80024fa0 <disk+0x128>
    80005e30:	e6bfa0ef          	jal	80000c9a <release>
}
    80005e34:	60e2                	ld	ra,24(sp)
    80005e36:	6442                	ld	s0,16(sp)
    80005e38:	64a2                	ld	s1,8(sp)
    80005e3a:	6105                	addi	sp,sp,32
    80005e3c:	8082                	ret
      panic("virtio_disk_intr status");
    80005e3e:	00003517          	auipc	a0,0x3
    80005e42:	9c250513          	addi	a0,a0,-1598 # 80008800 <etext+0x800>
    80005e46:	95dfa0ef          	jal	800007a2 <panic>

0000000080005e4a <sys_kbdint>:
extern int kbd_intr_count;
extern int total_syscalls;



uint64 sys_kbdint(void) { return kbd_intr_count; }
    80005e4a:	1141                	addi	sp,sp,-16
    80005e4c:	e422                	sd	s0,8(sp)
    80005e4e:	0800                	addi	s0,sp,16
    80005e50:	00005517          	auipc	a0,0x5
    80005e54:	7c052503          	lw	a0,1984(a0) # 8000b610 <kbd_intr_count>
    80005e58:	6422                	ld	s0,8(sp)
    80005e5a:	0141                	addi	sp,sp,16
    80005e5c:	8082                	ret

0000000080005e5e <sys_countsyscall>:
uint64 sys_countsyscall(void) { return total_syscalls; }
    80005e5e:	1141                	addi	sp,sp,-16
    80005e60:	e422                	sd	s0,8(sp)
    80005e62:	0800                	addi	s0,sp,16
    80005e64:	00006517          	auipc	a0,0x6
    80005e68:	80052503          	lw	a0,-2048(a0) # 8000b664 <total_syscalls>
    80005e6c:	6422                	ld	s0,8(sp)
    80005e6e:	0141                	addi	sp,sp,16
    80005e70:	8082                	ret

0000000080005e72 <sys_uptime>:

uint64 sys_uptime(void)
{
    80005e72:	1101                	addi	sp,sp,-32
    80005e74:	ec06                	sd	ra,24(sp)
    80005e76:	e822                	sd	s0,16(sp)
    80005e78:	e426                	sd	s1,8(sp)
    80005e7a:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80005e7c:	00014517          	auipc	a0,0x14
    80005e80:	d5c50513          	addi	a0,a0,-676 # 80019bd8 <tickslock>
    80005e84:	d7ffa0ef          	jal	80000c02 <acquire>
    uint xticks = ticks;
    80005e88:	00005497          	auipc	s1,0x5
    80005e8c:	7d84a483          	lw	s1,2008(s1) # 8000b660 <ticks>
    release(&tickslock);
    80005e90:	00014517          	auipc	a0,0x14
    80005e94:	d4850513          	addi	a0,a0,-696 # 80019bd8 <tickslock>
    80005e98:	e03fa0ef          	jal	80000c9a <release>
    return xticks;
}
    80005e9c:	02049513          	slli	a0,s1,0x20
    80005ea0:	9101                	srli	a0,a0,0x20
    80005ea2:	60e2                	ld	ra,24(sp)
    80005ea4:	6442                	ld	s0,16(sp)
    80005ea6:	64a2                	ld	s1,8(sp)
    80005ea8:	6105                	addi	sp,sp,32
    80005eaa:	8082                	ret

0000000080005eac <sys_rand>:

// simple LCG random
static unsigned long seed = 1;
uint64 sys_rand(void)
{
    80005eac:	1141                	addi	sp,sp,-16
    80005eae:	e422                	sd	s0,8(sp)
    80005eb0:	0800                	addi	s0,sp,16
    if (seed == 1)
    80005eb2:	00005717          	auipc	a4,0x5
    80005eb6:	6f673703          	ld	a4,1782(a4) # 8000b5a8 <seed>
    80005eba:	4785                	li	a5,1
    80005ebc:	02f70763          	beq	a4,a5,80005eea <sys_rand+0x3e>
        seed = ticks;
    seed = seed * 1103515245 + 12345;
    80005ec0:	00005717          	auipc	a4,0x5
    80005ec4:	6e870713          	addi	a4,a4,1768 # 8000b5a8 <seed>
    80005ec8:	6308                	ld	a0,0(a4)
    80005eca:	41c657b7          	lui	a5,0x41c65
    80005ece:	e6d78793          	addi	a5,a5,-403 # 41c64e6d <_entry-0x3e39b193>
    80005ed2:	02f50533          	mul	a0,a0,a5
    80005ed6:	678d                	lui	a5,0x3
    80005ed8:	03978793          	addi	a5,a5,57 # 3039 <_entry-0x7fffcfc7>
    80005edc:	953e                	add	a0,a0,a5
    80005ede:	e308                	sd	a0,0(a4)
    return (seed >> 16) & 0x7FFF;
    80005ee0:	1506                	slli	a0,a0,0x21
}
    80005ee2:	9145                	srli	a0,a0,0x31
    80005ee4:	6422                	ld	s0,8(sp)
    80005ee6:	0141                	addi	sp,sp,16
    80005ee8:	8082                	ret
        seed = ticks;
    80005eea:	00005797          	auipc	a5,0x5
    80005eee:	7767e783          	lwu	a5,1910(a5) # 8000b660 <ticks>
    80005ef2:	00005717          	auipc	a4,0x5
    80005ef6:	6af73b23          	sd	a5,1718(a4) # 8000b5a8 <seed>
    80005efa:	b7d9                	j	80005ec0 <sys_rand+0x14>

0000000080005efc <sys_shutdown>:


uint64 sys_shutdown(void)
{
    80005efc:	1141                	addi	sp,sp,-16
    80005efe:	e406                	sd	ra,8(sp)
    80005f00:	e022                	sd	s0,0(sp)
    80005f02:	0800                	addi	s0,sp,16
    printf("Shutting down xv6...\n");
    80005f04:	00003517          	auipc	a0,0x3
    80005f08:	91450513          	addi	a0,a0,-1772 # 80008818 <etext+0x818>
    80005f0c:	dc4fa0ef          	jal	800004d0 <printf>
    volatile uint32 *shutdown_reg = (uint32*)0x100000;
    *shutdown_reg = 0x5555;
    80005f10:	6795                	lui	a5,0x5
    80005f12:	55578793          	addi	a5,a5,1365 # 5555 <_entry-0x7fffaaab>
    80005f16:	00100737          	lui	a4,0x100
    80005f1a:	c31c                	sw	a5,0(a4)
    for (;;) ;
    80005f1c:	a001                	j	80005f1c <sys_shutdown+0x20>

0000000080005f1e <sys_datetime>:
    return BOOT_EPOCH + seconds;
}

uint64
sys_datetime(void)
{
    80005f1e:	715d                	addi	sp,sp,-80
    80005f20:	e486                	sd	ra,72(sp)
    80005f22:	e0a2                	sd	s0,64(sp)
    80005f24:	fc26                	sd	s1,56(sp)
    80005f26:	0880                	addi	s0,sp,80
    struct datetime dt;
    struct proc *p = myproc();
    80005f28:	9d9fb0ef          	jal	80001900 <myproc>
    80005f2c:	84aa                	mv	s1,a0
    uint64 addr;

    argaddr(0, &addr);
    80005f2e:	fb840593          	addi	a1,s0,-72
    80005f32:	4501                	li	a0,0
    80005f34:	c7dfc0ef          	jal	80002bb0 <argaddr>
  asm volatile("csrr %0, time" : "=r" (x) );
    80005f38:	c01027f3          	rdtime	a5
    uint64 seconds = time_ticks / 10000000;
    80005f3c:	00989737          	lui	a4,0x989
    80005f40:	68070713          	addi	a4,a4,1664 # 989680 <_entry-0x7f676980>
    80005f44:	02e7d7b3          	divu	a5,a5,a4
    timestamp += CAIRO_OFFSET;
    80005f48:	693c5737          	lui	a4,0x693c5
    80005f4c:	45570713          	addi	a4,a4,1109 # 693c5455 <_entry-0x16c3abab>
    80005f50:	00e78533          	add	a0,a5,a4
    dt->weekday = (timestamp / 86400 + 4) % 7;
    80005f54:	67d5                	lui	a5,0x15
    80005f56:	18078793          	addi	a5,a5,384 # 15180 <_entry-0x7ffeae80>
    80005f5a:	02f557b3          	divu	a5,a0,a5
    80005f5e:	00478713          	addi	a4,a5,4
    80005f62:	469d                	li	a3,7
    80005f64:	02d77733          	remu	a4,a4,a3
    80005f68:	fce42c23          	sw	a4,-40(s0)
    int year = 1970;
    80005f6c:	7b200713          	li	a4,1970
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    80005f70:	19000593          	li	a1,400
    80005f74:	06400893          	li	a7,100
    80005f78:	4805                	li	a6,1
    80005f7a:	a819                	j	80005f90 <sys_datetime+0x72>
    80005f7c:	02b766bb          	remw	a3,a4,a1
    80005f80:	0016b693          	seqz	a3,a3
        if (days < days_in_year)
    80005f84:	16d68613          	addi	a2,a3,365
    80005f88:	00c7ec63          	bltu	a5,a2,80005fa0 <sys_datetime+0x82>
        days -= days_in_year;
    80005f8c:	8f91                	sub	a5,a5,a2
        year++;
    80005f8e:	2705                	addiw	a4,a4,1
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
    80005f90:	00377693          	andi	a3,a4,3
    80005f94:	f6e5                	bnez	a3,80005f7c <sys_datetime+0x5e>
    80005f96:	0317663b          	remw	a2,a4,a7
    80005f9a:	86c2                	mv	a3,a6
    80005f9c:	f665                	bnez	a2,80005f84 <sys_datetime+0x66>
    80005f9e:	bff9                	j	80005f7c <sys_datetime+0x5e>
    dt->year = year;
    80005fa0:	fce42023          	sw	a4,-64(s0)
    for (month = 0; month < 12; month++) {
    80005fa4:	00003597          	auipc	a1,0x3
    80005fa8:	9ec58593          	addi	a1,a1,-1556 # 80008990 <month_days>
    80005fac:	4701                	li	a4,0
        if (month == 1 && is_leap_year(year))
    80005fae:	4805                	li	a6,1
    80005fb0:	06f1                	addi	a3,a3,28
    for (month = 0; month < 12; month++) {
    80005fb2:	48b1                	li	a7,12
    80005fb4:	a801                	j	80005fc4 <sys_datetime+0xa6>
        if (days < days_in_month)
    80005fb6:	00c7ec63          	bltu	a5,a2,80005fce <sys_datetime+0xb0>
        days -= days_in_month;
    80005fba:	8f91                	sub	a5,a5,a2
    for (month = 0; month < 12; month++) {
    80005fbc:	2705                	addiw	a4,a4,1
    80005fbe:	0591                	addi	a1,a1,4
    80005fc0:	01170763          	beq	a4,a7,80005fce <sys_datetime+0xb0>
        days_in_month = month_days[month];
    80005fc4:	4190                	lw	a2,0(a1)
        if (month == 1 && is_leap_year(year))
    80005fc6:	ff0718e3          	bne	a4,a6,80005fb6 <sys_datetime+0x98>
    80005fca:	8636                	mv	a2,a3
    80005fcc:	b7ed                	j	80005fb6 <sys_datetime+0x98>
    dt->month = month + 1;
    80005fce:	2705                	addiw	a4,a4,1
    80005fd0:	fce42223          	sw	a4,-60(s0)
    dt->day = days + 1;
    80005fd4:	2785                	addiw	a5,a5,1
    80005fd6:	fcf42423          	sw	a5,-56(s0)
    uint64 secs_in_day = timestamp % 86400;
    80005fda:	67d5                	lui	a5,0x15
    80005fdc:	18078793          	addi	a5,a5,384 # 15180 <_entry-0x7ffeae80>
    80005fe0:	02f577b3          	remu	a5,a0,a5
    dt->hour = secs_in_day / 3600;
    80005fe4:	6705                	lui	a4,0x1
    80005fe6:	e1070713          	addi	a4,a4,-496 # e10 <_entry-0x7ffff1f0>
    80005fea:	02e7d6b3          	divu	a3,a5,a4
    80005fee:	fcd42623          	sw	a3,-52(s0)
    dt->minute = (secs_in_day % 3600) / 60;
    80005ff2:	02e7f733          	remu	a4,a5,a4
    80005ff6:	03c00693          	li	a3,60
    80005ffa:	02d75733          	divu	a4,a4,a3
    80005ffe:	fce42823          	sw	a4,-48(s0)
    dt->second = secs_in_day % 60;
    80006002:	02d7f7b3          	remu	a5,a5,a3
    80006006:	fcf42a23          	sw	a5,-44(s0)

    // Convert to datetime structure
    unix_to_datetime(current_time, &dt);

    // Copy to user space
    if(copyout(p->pagetable, addr, (char*)&dt, sizeof(dt)) < 0) {
    8000600a:	46f1                	li	a3,28
    8000600c:	fc040613          	addi	a2,s0,-64
    80006010:	fb843583          	ld	a1,-72(s0)
    80006014:	68a8                	ld	a0,80(s1)
    80006016:	d5cfb0ef          	jal	80001572 <copyout>
        return -1;
    }

    return 0;
}
    8000601a:	957d                	srai	a0,a0,0x3f
    8000601c:	60a6                	ld	ra,72(sp)
    8000601e:	6406                	ld	s0,64(sp)
    80006020:	74e2                	ld	s1,56(sp)
    80006022:	6161                	addi	sp,sp,80
    80006024:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
