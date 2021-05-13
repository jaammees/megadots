// draw the status bar at the top of the screen
.encoding "screencode_mixed"

player_status_display:
.text "LEVEL "
player_status_level:
.text "0000 "

//.text "F3:SKIP "
player_status_seconds:
.text "0000"
.text ":"
player_status_second_tenths:
.text "00 "

player_dots:
.text " DOTS "
player_status_dots: 
.text "0000 "
player_tries:
.text "TRIES "
player_status_tries:
.text "0001"
.text "@"


status_initial_level:
.text "0000"

status_initial_time:
.text "0000:00"

player_last_time:
.text "0000:00@"

player_best_time:
.text "9999:99@"


StatusResetTime: {
  phy

  ldy #6
!:
  lda player_status_seconds,y
  sta player_last_time,y

  lda status_initial_time,y
  sta player_status_seconds,y
  dey 
  bpl !-
  ply
  rts
}

StatusIncreaseTime: {
  phy

  lda #<player_status_second_tenths
  sta status_address_low
  lda #>player_status_second_tenths
  sta status_address_high

  jsr StatusIncrease2DigitNumber

  bcc !+

  lda #<player_status_seconds
  sta status_address_low
  lda #>player_status_seconds
  sta status_address_high
  jsr StatusIncreaseNumber
!:

  ply
  rts
}


status_increment:
.byte 0,0
status_2_digit_increment:
.byte 0,1

status_tenth_increment:
.byte 0,2


StatusResetLevel: {
  phy

  ldy #3
!:
  lda status_initial_level,y
  sta player_status_level,y
  dey 
  bpl !-
  ply
  rts

}

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

StatusIncrease2DigitNumber: {
  // save y
  phy

  // 4 digits, loop over digits starting with last digit first
  ldy #1
  clc
increase_number_loop:
  lda (status_address_low),y
  adc status_tenth_increment,y

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