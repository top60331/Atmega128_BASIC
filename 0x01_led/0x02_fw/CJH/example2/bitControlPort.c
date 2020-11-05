// portA control

#include <mega128.h>
#include <delay.h>
#include "bitControlPort.h"

void bitControlPortA (WORD pin, WORD setClear)
{
    if (setClear == SET)
    {
        BIT_SET(PORTA, pin);
    }
    else
    {
        BIT_CLEAR(PORTA, pin);
    }

}
