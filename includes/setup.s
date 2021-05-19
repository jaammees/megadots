SetupSystem: {
	sei
	
	// set memory layout (c64??)
	lda #$35
	sta $01

	enableVIC4Registers()

	// turn off cia interrupts
	lda #$7f
	sta $dc0d
	sta $dd0d

	// turn off raster interrupts used by c65 rom
	lda #$00
	sta $d01a

	// disable c65 rom protection
	// $20000 - $3ffff
	lda #$70
	sta $d640
	eom

	// without this, screen seems to scroll by 1 pixel
	lda #$c8
	sta $d016

	enable40Mhz()

	cli

	// turn on fcm mode
	// bit 0 = Enable 16 bit char numbers
	// bit 1 = Enable Fullcolor for chars <=$ff
	// bit 2 = Enable Fullcolor for chars >$ff
	lda #$02
	sta $d054

	// Set VIC to use 40 column mode display
	// turn off bit 7 
	lda #$80		
	trb $d031 

	// Disable hot register so VIC2 registers 
	// without setting vic 2 registers can destroy vic 4 registers
	// wont destroy VIC4 values (bit 7)
	// turn off bit 7 
	lda #$80		
	trb $d05d		

	jsr SetupSprites

	jsr ClearColorRAM
	rts	
}


SetupSprites: {

	// set location of 16 bit sprite pointers 
	lda #<SPRITE_POINTERS
	sta $d06c

	lda #>SPRITE_POINTERS
	sta $d06d

	lda #$80
	sta $d06e

	// full colour sprite mode for all sprites (SPR16EN)
  lda #$ff
  sta $d06b

  // 16 pixel wide for all sprites (SPRX64EN) 53335
  lda #$ff
  sta $d057

  // 16 pixel high sprite heights
  lda #16
  sta $d056

  // all sprites use height in $d056 sprhgten
  lda #$ff
  sta $d055

}


ClearColorRAM: {
  ldx #0
  lda #0
!:
  sta COLOUR_RAM_ADDR,x
  sta COLOUR_RAM_ADDR + $100,x
  sta COLOUR_RAM_ADDR + $200,x
  sta COLOUR_RAM_ADDR + $2e8,x
  inx
  cpx #0
  bne !-
  rts
}
