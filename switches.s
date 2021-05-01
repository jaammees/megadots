// switches make tiles solid and blank


SwitchPress: {
  // need to save x
  phx

  ldx #00
  
  // need to loop 4 times, use temp3 as the loop counter
  lda #$04
  sta temp3
  
  // address_low/high contains screen addresses

  lda #>SCREEN_ADDR
  sta address_high  
  
  lda #<SCREEN_ADDR
  sta address_low

  ldy #00
set_current_color_loop:
  
  lda (address_low),y
  
  cmp #TILE_BLOCK_RED
  beq found_block_tile
  cmp #TILE_BLOCK_GREEN
  beq found_block_tile
  cmp #TILE_BLOCK_BLUE
  beq found_block_tile

  jmp check_for_blank_tile
found_block_tile:
  // convert the tile to its type, compare to switch type
  sec
  sbc #TILE_BLOCK_FIRST
  cmp switch_type
  // if not the same type, make the tile blank
  bne make_tile_blank

  jmp set_color_next_test


make_tile_blank:
  // convert to a blank tile
  clc 
  adc #TILE_BLANK_FIRST
  sta (address_low),y

  jmp set_color_next_test


check_for_blank_tile:

  cmp #TILE_BLANK_RED
  beq found_blank_tile
  cmp #TILE_BLANK_GREEN
  beq found_blank_tile
  cmp #TILE_BLANK_BLUE
  beq found_blank_tile

  jmp check_for_up_switch

found_blank_tile:
  // convert the tile to its type, compare to switch type
  sec
  sbc #TILE_BLANK_FIRST
  cmp switch_type
  // if is the same type, make the tile solid
  beq make_tile_solid
  jmp set_color_next_test

make_tile_solid:

  // convert to a blank tile
  clc 
  adc #TILE_BLOCK_FIRST
  sta (address_low),y

  jmp set_color_next_test

check_for_up_switch:
  cmp #TILE_SWITCH_UP_RED
  beq found_up_switch
  cmp #TILE_SWITCH_UP_GREEN
  beq found_up_switch
  cmp #TILE_SWITCH_UP_BLUE
  beq found_up_switch

  jmp check_for_down_switch

found_up_switch:
  // find the switch type
  sec
  sbc #TILE_SWITCH_UP_FIRST
  cmp switch_type
  // if is the same type, need to set to down switch
  beq make_switch_down
  jmp set_color_next_test

make_switch_down:
  clc
  adc #TILE_SWITCH_DOWN_FIRST
  sta (address_low),y

  jmp set_color_next_test


check_for_down_switch:  
  cmp #TILE_SWITCH_DOWN_RED
  beq found_down_switch
  cmp #TILE_SWITCH_DOWN_GREEN
  beq found_down_switch
  cmp #TILE_SWITCH_DOWN_BLUE
  beq found_down_switch

  jmp set_color_next_test
found_down_switch:
  // find switch type
  sec
  sbc #TILE_SWITCH_DOWN_FIRST
  cmp switch_type
  // if not the same type, turn it into an up switch
  bne make_switch_up
  jmp set_color_next_test

make_switch_up:
  clc
  adc #TILE_SWITCH_UP_FIRST
  sta (address_low),y  
set_color_next_test:

  dey
  beq !+
  jmp set_current_color_loop
!:  
  
  // get ready for another loop
  inc address_high
  inc address_high_2
  ldy #$0
  
  // should we do another loop?
  dec temp3
  beq !+
  jmp set_current_color_loop
!:  

  plx
  rts
}