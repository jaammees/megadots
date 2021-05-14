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

player_last_is_best:
.byte $0


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




  // check if a best time
  lda #<player_last_time
  sta address_low
  lda #>player_last_time
  sta address_high

  lda #<player_best_time
  sta address_low_2
  lda #>player_best_time
  sta address_high_2

  jsr CompareTimes
  sta player_last_is_best
  cmp #1
  bne reset_time_done
  
  // its a best time, copy last time into best time
  ldy #6
!:
  lda player_last_time,y
  sta player_best_time,y
  dey 
  bpl !-


reset_time_done:

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

// time1 in address_low
// time2 in address_high
CompareTimes: {
  phy

  ldy #0
!:
  lda (address_low),y
  cmp (address_low_2),y
//  lda player_last_time,y
//  cmp player_best_time,y
  beq next_digit
  bmi time2_bigger
  bpl time1_bigger
  

next_digit:  
  iny
  cpy #07
  bne !-

time1_bigger:
  lda #0
  ply
  rts

time2_bigger:
  inc $d020
  lda #1
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