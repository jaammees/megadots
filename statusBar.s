.encoding "screencode_mixed"

player_status_display:
.text "LEVEL "
player_status_level:
.text "0000 "

.text "F3:SKIP "
player_dots:
.text " DOTS "
player_status_dots: 
.text "0000 "
player_tries:
.text "TRIES "
player_status_tries:
.text "0001"
.text "@"


status_increment:
.byte 0,0,0,1

StatusIncreaseLevel: {

  lda #<player_status_level
  sta status_address_low
  lda #>player_status_level
  sta status_address_high

  jsr StatusIncreaseNumber
  rts

}


StatusIncreaseDots: {
  lda #<player_status_dots
  sta status_address_low
  lda #>player_status_dots
  sta status_address_high

  jsr StatusIncreaseNumber
  rts
}

StatusIncreaseTries: {

  lda #<player_status_tries
  sta status_address_low
  lda #>player_status_tries
  sta status_address_high

  jsr StatusIncreaseNumber
  rts
}


StatusIncreaseNumber: {
  // save y
  phy

  // 4 digits, loop over digits starting with last digit first
  ldy #3

  clc
increase_number_loop:
  lda (status_address_low),y
  adc status_increment,y

  // check if gone over 9 ($39 is screencode for 9 in mixed screencode mode)
  cmp #$3a
  bcc store_number
  // gone over 9, so subtract 10
  // carry should be set
  sbc #10

store_number:
//  lda #136 //TILE_9
  sta (status_address_low),y

  dey
  bpl increase_number_loop

  // restore y
  ply

  rts
}

DrawStatus: {
  lda #0
  sta row
  sta col
  lda #<player_status_display
  sta text_address_low
  lda #>player_status_display
  sta text_address_high

  jsr DrawText
  rts
}