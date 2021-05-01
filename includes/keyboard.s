
.const PRA  =  $dc00            // CIA#1 (Port Register A)
.const PRB  =  $dc01            // CIA#1 (Port Register B)
.const DDRA =  $dc02            // CIA#1 (Data Direction Register A)
.const DDRB =  $dc03            // CIA#1 (Data Direction Register B)

last_prb:  
.byte $0


shift_pressed:
.byte $0

left_key_pressed:
.byte $0

right_key_pressed:
.byte $0

up_key_pressed:
.byte $0

down_key_pressed:
.byte $0

z_key_pressed:
.byte $0

x_key_pressed:
.byte $0


CheckKeyboard: {
	lda #$0
	sta shift_pressed
	sta left_key_pressed
	sta right_key_pressed
	sta up_key_pressed
	sta down_key_pressed
	sta z_key_pressed
  sta x_key_pressed


  lda #%11111111  // CIA#1 Port A set to output 
  sta DDRA             
  lda #%00000000  // CIA#1 Port B set to inputt
  sta DDRB       
  

	// row 2
	lda #%11111101
	sta PRA
	
	// check z key
	lda PRB
	bit #%00010000
	bne !+
	// z key
	inc z_key_pressed
!:
	// check left shift
	lda PRB
	bit #%10000000
	bne !+
	//left-shift
	lda #$01
	sta shift_pressed
!:	


  lda #%11111011
  sta PRA

  // x key
  lda PRB
  bit #%10000000
  bne !+

  lda #$01
  sta x_key_pressed
!:  

	// check right shift key
	// row 7
	lda #%10111111
	sta PRA
	lda PRB
	bit #%00010000
	bne !+
	lda #$01
	sta shift_pressed
!:

	// cursor keys
	//row 1
	lda #%11111110
	sta PRA
	lda PRB
	and #%10000000
	bne !+
	
	// up/down, if no shift then it's down
	lda shift_pressed
	bne up_key_is_pressed
	inc down_key_pressed
	jmp !+
up_key_is_pressed:
	inc up_key_pressed
!:	

	lda PRB
	bit #%00000100
	bne !+

	// left/right, if no shift then it's right
	lda shift_pressed
	bne left_key_is_down
	inc right_key_pressed
	jmp !+
left_key_is_down:
	inc left_key_pressed	
!:	


  // . and ,
  lda #%11011110
  sta PRA

  // , key
  lda PRB
  and #%10000000
  bne !+

	
	// getting collision with comma and cursor keys for some reason
	// hack to avoid the collision
	lda up_key_pressed
	bne !+
	lda down_key_pressed
	bne !+

  lda #$01
	
  sta left_key_pressed
!:

  // . key
  lda PRB
  bit #%00010000
  bne !+
  lda #$01
  sta right_key_pressed
!:  

  // function keys
	lda #%11111110
	sta PRA
	lda PRB
	cmp last_prb
	beq check_keyboard_done
	sta last_prb
	and #%00010000 // F1
	bne !+
!:
	lda PRB
	and #%00100000 // F3
	bne !+
	lda #$0
	sta dot_count
	jsr NextLevel
!:

check_keyboard_done:
  lda #%01111111
  sta PRA 

  rts
}