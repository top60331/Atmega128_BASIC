/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
?Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2020-11-05
Author  : 
Company : 
Comments: 

Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include "board_init.h"
#include "bitControlPort.h"


// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

systemInit();

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here   
      #if (1) 
      bitControlPortA (2, SET); 
      delay_ms(1000);
      bitControlPortA (2, CLR);
      delay_ms(1000);
      #endif  
      }
}
