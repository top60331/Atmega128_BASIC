#include <atmel_start.h>
#include "./delay.h"

unsigned char second;

int main(void)
{
	/* Initializes MCU, drivers and middleware */
	atmel_start_init();

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0 output: Disconnected
    ASSR=0x00;
	
    //TCCR0=0x04;     // 64분주
	/* Prescale the timer to be clock source/128 to make */
	/* TC0 overflow precisely once every second. */
	TCCR0 = (1 << CS02);	// 64분주
	
    TCNT0=0x07;     // 1ms
    OCR0=0x00;

	/* Enable Timer/Counter0 Overflow Interrupts */
	TIMSK |= (1 << TOIE0);

	/* Set the Global Interrupt Enable Bit */
	sei();
	second = 0;
	
	/* Replace with your application code */
	while (1) {
		if (0){//second >= 10) {
			PORTE ^= 0xFF;
			//PORTE_toggle_pin_level(2);
			second = 0;
		}
		
		
		PORTE_toggle_pin_level(2);
		//PORTE = 0xFF;
		PORTE_set_pin_level(2,1);
		_delay_ms(500);
		PORTE ^= 0xff;
		PORTE ^= 0xff;
		PORTE ^= 0xff;
		PORTE ^= 0xff;
		PORTE_set_pin_level(2,0);
		_delay_ms(500);
		
	}
}

/* keep track of time, date, month, and year */
ISR(TIMER0_OVF_vect)
{
	cli();
	second++;
	//PORTE ^= 0xff;
	TCNT0=0x07;     // 1ms
	sei();
}