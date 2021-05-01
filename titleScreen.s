.encoding "screencode_mixed"

title_name:
.text "MEGA DOTS@"

controls_1:
.text "JOYSTICK PORT 1@"

controls_2:
.text "OR KEYS ; < AND X@"

//controls_3:
//.text "@"

DrawTitleScreen: {
  
  lda #5
  sta row
  lda #10
  sta col
  lda #<title_name
  sta text_address_low
  lda #>title_name
  sta text_address_high
  jsr DrawText


  lda #7
  sta row
  lda #10
  sta col
  lda #<controls_1
  sta text_address_low
  lda #>controls_1
  sta text_address_high
  jsr DrawText




  lda #9
  sta row
  lda #10
  sta col
  lda #<controls_2
  sta text_address_low
  lda #>controls_2
  sta text_address_high
  jsr DrawText

  rts
}
