#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>

volatile unsigned char send_enable = 0;
void UART_Init(void)
{
	UBRRH = (51>>8);
	UBRRL = 51;										// baud rate 9600bps
	UCSRB |= (1<<TXEN);								// transmitter enable
	UCSRC |=  (1<<URSEL)|(1<<UCSZ1)|(1<<UCSZ0);		// 8 bit mode
	
}

void UART_Transmit(unsigned char byte)
{
	while ( !( UCSRA & (1<<UDRE)) )		// wait for empty transmit buffer
	;
	UDR = byte;
}

void Button_Init(void)
{
	MCUCR |= (1<<ISC11);				// the falling edge of INT1 generates an interrupt request
	GICR |= (1<<INT1);
}

ISR(INT1_vect)
{
	_delay_ms(5);						// Simple debouncer
	if (!(PIND&(1<<PD3)))
	send_enable = 1;

}
int main(void)
{
    UART_Init();
	Button_Init();
	sei();							// global interrupt flag set
	unsigned char counter = 0;		// data to be send
	DDRB |= (1<<PB0);				// LED indicator port
    while (1) 
    {
				PORTB &= (~(1<<PB0));	// LED off
				if (send_enable)
				{
					PORTB |= (1<<PB0);	// LED on
					send_enable = 0;
					counter++;
					UART_Transmit(counter);
				}
    }
}

