

screen_loop_y:
.byte $ff,$ff,$ff,$e7

// switches make tiles solid and blank
SwitchPress: {
  // need to save x
  phx
  phy

  // use x for outer loop, y for inner loop
  ldx #0
  
  // address_low/high contains screen addresses

  lda #>SCREEN_ADDR
  sta address_high  
  
  lda #<SCREEN_ADDR
  sta address_low

set_current_color_outer_loop:  
  ldy screen_loop_y,x
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

  //dey
//  iny
//  cpy screen_loop_y,x
  dey 
  cpy #$ff
  beq !+
  jmp set_current_color_loop
!:  
  // get ready for another loop
  inc address_high
//  ldy screen_loop_y,x
  
  // should we do another loop?
  inx
  cpx #$4
  beq !+
  jmp set_current_color_outer_loop
!:  


  // -------------------------------------------------------//
  // check if any of the animated 'prev' tiles need updating
  // 'prev' would be the tile a projectile is currently in
  ldx #MAX_ANIMATED_TILES - 1
set_animated_current_color_loop:

  lda animated_tile_prev,x

  cmp #TILE_BLOCK_RED
  beq found_animated_prev_block_tile
  cmp #TILE_BLOCK_GREEN
  beq found_animated_prev_block_tile
  cmp #TILE_BLOCK_BLUE
  beq found_animated_prev_block_tile

  jmp check_for_animated_prev_blank_tile
found_animated_prev_block_tile:
  // convert the tile to its type, compare to switch type
  sec
  sbc #TILE_BLOCK_FIRST
  cmp switch_type
  // if not the same type, make the tile blank
  bne make_animated_prev_tile_blank

  jmp set_animated_color_next_test


make_animated_prev_tile_blank:
  // convert to a blank tile
  clc 
  adc #TILE_BLANK_FIRST
  sta animated_tile_prev,x
//  sta (address_low),y

  jmp set_animated_color_next_test


check_for_animated_prev_blank_tile:

  cmp #TILE_BLANK_RED
  beq found_animated_prev_blank_tile
  cmp #TILE_BLANK_GREEN
  beq found_animated_prev_blank_tile
  cmp #TILE_BLANK_BLUE
  beq found_animated_prev_blank_tile

  jmp set_animated_color_next_test

found_animated_prev_blank_tile:
  // convert the tile to its type, compare to switch type
  sec
  sbc #TILE_BLANK_FIRST
  cmp switch_type
  // if is the same type, make the tile solid
  beq make_animated_prev_tile_solid
  jmp set_animated_color_next_test

make_animated_prev_tile_solid:

  // convert to a blank tile
  clc 
  adc #TILE_BLOCK_FIRST
  sta animated_tile_prev,x

set_animated_color_next_test:
  dex
  bmi !+
  jmp set_animated_current_color_loop
!:  


  ply
  plx
  rts
}