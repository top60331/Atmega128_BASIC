
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 2020-10-18
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;typedef unsigned char BYTE;
;typedef unsigned int  WORD;
;
;#define SET             1
;#define CLR             0
;
;#define BIT_SET(reg, n)     (reg |= (0x01 << n))
;#define BIT_CLEAR(reg, n)     (reg &= ~(0x01 << n))
;#define BIT_TEST(reg, n)     ((reg >> n) & 0x01)
;#define BIT_TOG(reg, n)     (reg ^= (0x01 << n))
;#define _BV(bit) (1 << (bit))   //PORTA |= _BV(2);
;#define nop()                 asm volatile("nop"::)   // 1clock (625nSec)  ex) nop x 16 = 1uSec.
;
;#define FAN1_PORT PORTA
;#define FAN2_PORT PORTA
;#define STATUS_PORT PORTA
;
;#define FAN1_PIN 7
;#define FAN2_PIN 6
;#define STATUS_LED 0
;
;#define FAN1_OFF()   BIT_CLEAR(FAN1_PORT, FAN1_PIN)
;#define FAN2_OFF()   BIT_CLEAR(FAN2_PORT, FAN2_PIN)
;
;#define FAN1_ON()   BIT_SET(FAN1_PORT, FAN1_PIN)
;#define FAN2_ON()   BIT_SET(FAN2_PORT, FAN2_PIN)
;#define _1msec  1000
;#define MIN5    300
;#define MIN10   600
;
;volatile WORD total_overflow_count;     //
;volatile WORD min5_count = 0;           // 300sec
;volatile WORD min10_count = 0;          // 600sec
;volatile BYTE key_scan_cnt = 0;
;volatile BYTE newKeyCheck = 0;
;//volatile BYTE flagSW = 0;
;volatile BYTE min5_completed = 0;
;volatile BYTE min10_completed = 0;
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0045 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0046 // Place your code here
; 0000 0047    #asm("cli")
	cli
; 0000 0048     if ( ++key_scan_cnt >= 20 && newKeyCheck == CLR)
	LDS  R26,_key_scan_cnt
	SUBI R26,-LOW(1)
	STS  _key_scan_cnt,R26
	CPI  R26,LOW(0x14)
	BRLO _0x4
	LDS  R26,_newKeyCheck
	CPI  R26,LOW(0x0)
	BREQ _0x5
_0x4:
	RJMP _0x3
_0x5:
; 0000 0049     {
; 0000 004A         key_scan_cnt = 0;
	LDI  R30,LOW(0)
	STS  _key_scan_cnt,R30
; 0000 004B         if ( (PINE & 0x10 ) == 0x00)
	SBIC 0x1,4
	RJMP _0x6
; 0000 004C         {
; 0000 004D             newKeyCheck = SET;
	LDI  R30,LOW(1)
	STS  _newKeyCheck,R30
; 0000 004E         }
; 0000 004F     }
_0x6:
; 0000 0050     total_overflow_count++;
_0x3:
	LDI  R26,LOW(_total_overflow_count)
	LDI  R27,HIGH(_total_overflow_count)
	RCALL SUBOPT_0x0
; 0000 0051     TCNT0 = 7;       // 16Mhz / 64 = 4us
	LDI  R30,LOW(7)
	OUT  0x32,R30
; 0000 0052     // 1ms / 4us -1 = 249   ===> 256 - 249 = 7
; 0000 0053     #asm("sei")
	sei
; 0000 0054 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// Declare your global variables here
;
;void main(void)
; 0000 0059 {
_main:
; 0000 005A // Declare your local variables here
; 0000 005B 
; 0000 005C // Input/Output Ports initialization
; 0000 005D // Port A initialization
; 0000 005E // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 005F // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0060 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0061 DDRA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 0062 
; 0000 0063 // Port B initialization
; 0000 0064 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0065 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0066 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0067 DDRB=0x00;
	OUT  0x17,R30
; 0000 0068 
; 0000 0069 // Port C initialization
; 0000 006A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 006B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 006C PORTC=0x00;
	OUT  0x15,R30
; 0000 006D DDRC=0x00;
	OUT  0x14,R30
; 0000 006E 
; 0000 006F // Port D initialization
; 0000 0070 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0071 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0072 PORTD=0x00;
	OUT  0x12,R30
; 0000 0073 DDRD=0x00;
	OUT  0x11,R30
; 0000 0074 
; 0000 0075 // Port E initialization
; 0000 0076 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0077 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0078 PORTE=0x00;
	OUT  0x3,R30
; 0000 0079 DDRE=0x00;
	OUT  0x2,R30
; 0000 007A 
; 0000 007B // Port F initialization
; 0000 007C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 007E PORTF=0x00;
	STS  98,R30
; 0000 007F DDRF=0x00;
	STS  97,R30
; 0000 0080 
; 0000 0081 // Port G initialization
; 0000 0082 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0083 // State4=T State3=T State2=T State1=T State0=T
; 0000 0084 PORTG=0x00;
	STS  101,R30
; 0000 0085 DDRG=0x00;
	STS  100,R30
; 0000 0086 
; 0000 0087 // Timer/Counter 0 initialization
; 0000 0088 // Clock source: System Clock
; 0000 0089 // Clock value: Timer 0 Stopped
; 0000 008A // Mode: Normal top=0xFF
; 0000 008B // OC0 output: Disconnected
; 0000 008C ASSR=0x00;
	OUT  0x30,R30
; 0000 008D TCCR0=0x04;     // 64����
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 008E TCNT0=0x07;     // 1ms
	LDI  R30,LOW(7)
	OUT  0x32,R30
; 0000 008F OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0090 
; 0000 0091 // Timer/Counter 1 initialization
; 0000 0092 // Clock source: System Clock
; 0000 0093 // Clock value: Timer1 Stopped
; 0000 0094 // Mode: Normal top=0xFFFF
; 0000 0095 // OC1A output: Discon.
; 0000 0096 // OC1B output: Discon.
; 0000 0097 // OC1C output: Discon.
; 0000 0098 // Noise Canceler: Off
; 0000 0099 // Input Capture on Falling Edge
; 0000 009A // Timer1 Overflow Interrupt: Off
; 0000 009B // Input Capture Interrupt: Off
; 0000 009C // Compare A Match Interrupt: Off
; 0000 009D // Compare B Match Interrupt: Off
; 0000 009E // Compare C Match Interrupt: Off
; 0000 009F TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00A0 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00A1 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00A2 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00A3 ICR1H=0x00;
	OUT  0x27,R30
; 0000 00A4 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A5 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A6 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A7 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A8 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A9 OCR1CH=0x00;
	STS  121,R30
; 0000 00AA OCR1CL=0x00;
	STS  120,R30
; 0000 00AB 
; 0000 00AC // Timer/Counter 2 initialization
; 0000 00AD // Clock source: System Clock
; 0000 00AE // Clock value: Timer2 Stopped
; 0000 00AF // Mode: Normal top=0xFF
; 0000 00B0 // OC2 output: Disconnected
; 0000 00B1 TCCR2=0x00;
	OUT  0x25,R30
; 0000 00B2 TCNT2=0x00;
	OUT  0x24,R30
; 0000 00B3 OCR2=0x00;
	OUT  0x23,R30
; 0000 00B4 
; 0000 00B5 // Timer/Counter 3 initialization
; 0000 00B6 // Clock source: System Clock
; 0000 00B7 // Clock value: Timer3 Stopped
; 0000 00B8 // Mode: Normal top=0xFFFF
; 0000 00B9 // OC3A output: Discon.
; 0000 00BA // OC3B output: Discon.
; 0000 00BB // OC3C output: Discon.
; 0000 00BC // Noise Canceler: Off
; 0000 00BD // Input Capture on Falling Edge
; 0000 00BE // Timer3 Overflow Interrupt: Off
; 0000 00BF // Input Capture Interrupt: Off
; 0000 00C0 // Compare A Match Interrupt: Off
; 0000 00C1 // Compare B Match Interrupt: Off
; 0000 00C2 // Compare C Match Interrupt: Off
; 0000 00C3 TCCR3A=0x00;
	STS  139,R30
; 0000 00C4 TCCR3B=0x00;
	STS  138,R30
; 0000 00C5 TCNT3H=0x00;
	STS  137,R30
; 0000 00C6 TCNT3L=0x00;
	STS  136,R30
; 0000 00C7 ICR3H=0x00;
	STS  129,R30
; 0000 00C8 ICR3L=0x00;
	STS  128,R30
; 0000 00C9 OCR3AH=0x00;
	STS  135,R30
; 0000 00CA OCR3AL=0x00;
	STS  134,R30
; 0000 00CB OCR3BH=0x00;
	STS  133,R30
; 0000 00CC OCR3BL=0x00;
	STS  132,R30
; 0000 00CD OCR3CH=0x00;
	STS  131,R30
; 0000 00CE OCR3CL=0x00;
	STS  130,R30
; 0000 00CF 
; 0000 00D0 // External Interrupt(s) initialization
; 0000 00D1 // INT0: Off
; 0000 00D2 // INT1: Off
; 0000 00D3 // INT2: Off
; 0000 00D4 // INT3: Off
; 0000 00D5 // INT4: Off
; 0000 00D6 // INT5: Off
; 0000 00D7 // INT6: Off
; 0000 00D8 // INT7: Off
; 0000 00D9 EICRA=0x00;
	STS  106,R30
; 0000 00DA EICRB=0x00;
	OUT  0x3A,R30
; 0000 00DB EIMSK=0x00;
	OUT  0x39,R30
; 0000 00DC 
; 0000 00DD // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00DE TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 00DF 
; 0000 00E0 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 00E1 
; 0000 00E2 // USART0 initialization
; 0000 00E3 // USART0 disabled
; 0000 00E4 UCSR0B=0x00;
	OUT  0xA,R30
; 0000 00E5 
; 0000 00E6 // USART1 initialization
; 0000 00E7 // USART1 disabled
; 0000 00E8 UCSR1B=0x00;
	STS  154,R30
; 0000 00E9 
; 0000 00EA // Analog Comparator initialization
; 0000 00EB // Analog Comparator: Off
; 0000 00EC // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00ED ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00EE SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00EF 
; 0000 00F0 // ADC initialization
; 0000 00F1 // ADC disabled
; 0000 00F2 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 00F3 
; 0000 00F4 // SPI initialization
; 0000 00F5 // SPI disabled
; 0000 00F6 SPCR=0x00;
	OUT  0xD,R30
; 0000 00F7 
; 0000 00F8 // TWI initialization
; 0000 00F9 // TWI disabled
; 0000 00FA TWCR=0x00;
	STS  116,R30
; 0000 00FB 
; 0000 00FC // Global enable interrupts
; 0000 00FD #asm("sei")
	sei
; 0000 00FE 
; 0000 00FF while (1)
_0x7:
; 0000 0100       {
; 0000 0101           if ( (total_overflow_count > _1msec) && (newKeyCheck == SET))
	LDS  R26,_total_overflow_count
	LDS  R27,_total_overflow_count+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLO _0xB
	LDS  R26,_newKeyCheck
	CPI  R26,LOW(0x1)
	BREQ _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 0102           {
; 0000 0103             total_overflow_count = 0;
	LDI  R30,LOW(0)
	STS  _total_overflow_count,R30
	STS  _total_overflow_count+1,R30
; 0000 0104             min5_count++;
	LDI  R26,LOW(_min5_count)
	LDI  R27,HIGH(_min5_count)
	RCALL SUBOPT_0x0
; 0000 0105             min10_count++;
	LDI  R26,LOW(_min10_count)
	LDI  R27,HIGH(_min10_count)
	RCALL SUBOPT_0x0
; 0000 0106             BIT_TOG( STATUS_PORT, STATUS_LED);
	IN   R30,0x1B
	LDI  R26,LOW(1)
	EOR  R30,R26
	OUT  0x1B,R30
; 0000 0107             FAN1_ON();
	SBI  0x1B,7
; 0000 0108             min10_completed = CLR;
	LDI  R30,LOW(0)
	STS  _min10_completed,R30
; 0000 0109           }
; 0000 010A 
; 0000 010B           if ( newKeyCheck == SET && min10_count > MIN10 && min10_completed == CLR)
_0xA:
	LDS  R26,_newKeyCheck
	CPI  R26,LOW(0x1)
	BRNE _0xE
	LDS  R26,_min10_count
	LDS  R27,_min10_count+1
	CPI  R26,LOW(0x259)
	LDI  R30,HIGH(0x259)
	CPC  R27,R30
	BRLO _0xE
	LDS  R26,_min10_completed
	CPI  R26,LOW(0x0)
	BREQ _0xF
_0xE:
	RJMP _0xD
_0xF:
; 0000 010C           {
; 0000 010D             FAN1_OFF();
	CBI  0x1B,7
; 0000 010E             FAN2_OFF();
	CBI  0x1B,6
; 0000 010F 
; 0000 0110             newKeyCheck = CLR;
	LDI  R30,LOW(0)
	STS  _newKeyCheck,R30
; 0000 0111             min5_count = CLR;
	STS  _min5_count,R30
	STS  _min5_count+1,R30
; 0000 0112             min10_count = CLR;
	STS  _min10_count,R30
	STS  _min10_count+1,R30
; 0000 0113             min5_completed = CLR;
	STS  _min5_completed,R30
; 0000 0114             min10_completed = SET;
	LDI  R30,LOW(1)
	STS  _min10_completed,R30
; 0000 0115           }
; 0000 0116 
; 0000 0117           if ( newKeyCheck == SET && min5_count > MIN5 && min5_completed == CLR)
_0xD:
	LDS  R26,_newKeyCheck
	CPI  R26,LOW(0x1)
	BRNE _0x11
	LDS  R26,_min5_count
	LDS  R27,_min5_count+1
	CPI  R26,LOW(0x12D)
	LDI  R30,HIGH(0x12D)
	CPC  R27,R30
	BRLO _0x11
	LDS  R26,_min5_completed
	CPI  R26,LOW(0x0)
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 0118           {
; 0000 0119             min5_count = 0;
	LDI  R30,LOW(0)
	STS  _min5_count,R30
	STS  _min5_count+1,R30
; 0000 011A             FAN2_ON();
	SBI  0x1B,6
; 0000 011B             min5_completed = SET;
	LDI  R30,LOW(1)
	STS  _min5_completed,R30
; 0000 011C           }
; 0000 011D       }
_0x10:
	RJMP _0x7
; 0000 011E }
_0x13:
	RJMP _0x13

	.DSEG
_total_overflow_count:
	.BYTE 0x2
_min5_count:
	.BYTE 0x2
_min10_count:
	.BYTE 0x2
_key_scan_cnt:
	.BYTE 0x1
_newKeyCheck:
	.BYTE 0x1
_min5_completed:
	.BYTE 0x1
_min10_completed:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET


	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
