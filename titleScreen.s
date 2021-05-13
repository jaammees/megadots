.encoding "screencode_mixed"

title_name:
.text "MEGA DOTS@"

controls_1:
.text "JOYSTICK PORT 1@"

controls_2:
.text "OR KEYS K L AND S@"

time_heading:
.text "TIME: @"

best_heading:
.text "BEST: @"

//controls_3:
//.text "@"


title_show_times:
.byte $0


DrawTitleScreen: {
  
  lda #5
  sta row
  lda #15
  sta col
  lda #<title_name
  sta text_address_low
  lda #>title_name
  sta text_address_high
  jsr DrawText

  lda title_show_times
  bne show_times

show_controls:
  lda #8
  sta row
  lda #12
  sta col
  lda #<controls_1
  sta text_address_low
  lda #>controls_1
  sta text_address_high
  jsr DrawText

  lda #10
  sta row
  lda #11
  sta col
  lda #<controls_2
  sta text_address_low
  lda #>controls_2
  sta text_address_high
  jsr DrawText

  rts


show_times:

  lda #8
  sta row
  lda #12
  sta col
  lda #<time_heading
  sta text_address_low
  lda #>time_heading
  sta text_address_high
  jsr DrawText

  lda #8
  sta row
  lda #18
  sta col
  lda #<player_last_time
  sta text_address_low
  lda #>player_last_time
  sta text_address_high
  jsr DrawText



  lda #10
  sta row
  lda #11
  sta col
  lda #<best_heading
  sta text_address_low
  lda #>best_heading
  sta text_address_high
  jsr DrawText

  lda #10
  sta row
  lda #17
  sta col
  lda #<player_best_time
  sta text_address_low
  lda #>player_best_time
  sta text_address_high
  jsr DrawText

  rts
}
