[2020-11-05]
아래처럼 4가지의 경우를 예를 들어 봤습니다. 

      #if (0)
      PORTA.0 = SET;
      delay_ms(500);
      PORTA.0 = CLR;
      delay_ms(500);
      #endif  
      
      #if (0)
      PORTA ^= 0x01;
      delay_ms(500);
      #endif  
      
      #if (0)
      PORTA &= 0x00;
      delay_ms(500);
      PORTA |= 0x01;
      delay_ms(500);
      #endif  
      
      #if (1)
      PORTA = 0x01;
      delay_ms(500);
      PORTA = ~0xff;
      delay_ms(500);
      #endif