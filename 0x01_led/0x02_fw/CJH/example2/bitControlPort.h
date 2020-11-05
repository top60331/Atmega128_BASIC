#ifndef _BITCONTROLPORT_H_
#define _BITCONTROLPORT_H_

#define SET 1
#define CLR 0
#define BIT_SET(reg, n)     (reg |= (0x01 << n))
#define BIT_CLEAR(reg, n)     (reg &= ~(0x01 << n))
#define BIT_TEST(reg, n)     ((reg >> n) & 0x01)
#define BIT_TOG(reg, n)     (reg ^= (0x01 << n))
#define _BV(bit) (1 << (bit))   //PORTA |= _BV(2);

typedef unsigned int WORD;

void bitControlPortA (WORD pin, WORD setClear);


#endif /* _BOARD_INIT_H_ */