
// ----------------- create lookup table for screen rows
CreateScreenLookup: {
  lda #00
  sta address_low

  // screenrowslo, screenrowshi are the lookup tables            
  sta screenrowslo    
  sta screenrowshi
  
  // #$08 is high byte of start of screen     
  lda #$08
  sta screenrowshi
  sta address_high

  // going to loop 24 times
  // each time add 40 to address_low
  // and add carry to address_high
  // then store in screenrowslo and screenrowshi
  
  ldx #$00
screen_lookup_loop:

  lda address_low
  clc
  adc #40
  sta screenrowslo+1,x
  sta address_low
  bcc !+
  inc address_high  
!:
  lda address_high
  sta screenrowshi+1,x
  inx
  cpx #24     // table for all 25 screen rows
  bne screen_lookup_loop
  rts
}

// should use y as offset?
GetScreenAddress: {
  // save the value of x
  phx
  clc
  ldx row
  lda screenrowslo,x
  adc col
  sta address_low
  lda screenrowshi,x
  adc #$00
  sta address_high
  
  // restore x
  plx
  rts
}


// This is the table of memory addresses of the 24 gamescreen rows.
screenrowslo:
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00

screenrowshi:
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
.byte $00
