collision_char:
.byte $0

check_screen_xl:
.byte $0

check_screen_xh:
.byte $0

check_screen_y:
.byte $0

// get character type at x, y pixel location
// x low in check_screen_xl, x high in check_screen_xh
// y in check_screen_y
// translate character to character type, store in accumulator
GetCharAt: {

  // divide y by 8, store in row
  lda check_screen_y
  lsr
  lsr
  lsr
  sta row
 
  // divide x by 8, store in col
  lda check_screen_xh
  sta temp
  lda check_screen_xl
  lsr temp
  ror
  lsr temp
  ror
  lsr temp
  ror

  sta col

  ldy #$00
  
  // call the col, row to screen address routine
  jsr GetScreenAddress

  // load the character at the address
  lda (address_low),y
  // char is in accumulator
  // check if returning a solid tile

  // all the switches are 2 pixels high
check_switch_tile:
  cmp #TILE_SWITCH_DOWN_RED
  beq !+
  cmp #TILE_SWITCH_DOWN_GREEN
  beq !+  
  cmp #TILE_SWITCH_DOWN_BLUE
  beq !+  
  cmp #TILE_SWITCH_UP_RED
  beq !+  
  cmp #TILE_SWITCH_UP_GREEN
  beq !+  
  cmp #TILE_SWITCH_UP_BLUE
  beq !+
  jmp check_block_tile  
!:  
  lda #TILE_2_HIGH
  rts

  // if its red, green or blue tile return as a solid block
check_block_tile:
  cmp #TILE_BLOCK_RED
  beq !+
  cmp #TILE_BLOCK_GREEN
  beq !+
  cmp #TILE_BLOCK_BLUE
  beq !+

check_crumble:
	cmp #TILE_CRUMBLE1
	bne check_crumble_2


  lda #TILE_CRUMBLE_TIME_1
  sta animated_tile_time
  lda #TILE_CRUMBLE2
  jsr AddAnimatedTile
  cmp #0
  beq !+

  lda #TILE_CRUMBLE2
  sta (address_low),y

!:
	lda #TILE_SOLID
	rts
	
check_crumble_2:
	cmp #TILE_CRUMBLE2
	bne check_crumble_3
	
	// crumble 2 is a solid block
	lda #TILE_SOLID
  rts

check_crumble_3:
  cmp #TILE_CRUMBLE3
  bne get_char_at_done
  lda #TILE_SOLID

get_char_at_done:
  rts
}

ActorCheckAbove: {
	lda #$0
	sta collision_char
	
	sec
	lda actor_screen_yl,x
	sbc #01
	sta check_screen_y
	
  // check left first
  // x coordinate of left pixel of sprite
  lda actor_screen_xl,x
  sta check_screen_xl
  lda actor_screen_xh,x
  sta check_screen_xh
  
  jsr GetCharAt

  // is the player on a solid?
  cmp #TILE_SOLID
  bne actor_check_above_right_edge
  sta collision_char  

actor_check_above_right_edge:
  // check top right hand corner
  clc
  lda actor_screen_xl,x
  adc #$05
  sta check_screen_xl
  lda actor_screen_xh,x
  adc #$00
  sta check_screen_xh
  
  jsr GetCharAt
  
  cmp #TILE_SOLID
  bne actor_check_above_end
  // player hit something
  
  sta collision_char

actor_check_above_end:
  lda collision_char	
	rts
}
	

// hack to check which tile feet are in
// should combine with ActorCheckBelow
// at the moment this only checks if feet are in a 2 pixel high tile
// x register contains actor index
// return value in accumulator and collision_char
ActorCheckBottom: {
  lda #$0
  sta collision_char
  
  // get the y pixel to check
  clc
  lda actor_screen_yl,x
  adc actor_bottom_offset,x
  // want one pixel above z
  dec
  dec
  sta check_screen_y
  
  // check left first
  // x coordinate of left pixel of sprite
  lda actor_screen_xl,x
  sta check_screen_xl
  lda actor_screen_xh,x
  sta check_screen_xh
  
  jsr GetCharAt
  // store it if it's a tile with pixels to stand on
  cmp #TILE_2_HIGH
  bne actor_check_bottom_right_edge

  sta collision_char
  rts
  
  // still need to check both edges?
actor_check_bottom_right_edge:
  
  // add width of actor to x coordinate
  clc
  lda actor_screen_xl,x
  adc #$05
  sta check_screen_xl
  lda actor_screen_xh,x
  adc #$00
  sta check_screen_xh
  
  jsr GetCharAt

  cmp #TILE_2_HIGH
  bne actor_check_bottom_end
  sta collision_char

actor_check_bottom_end:
  lda collision_char
  rts

}

// x register contains actor index
// return value in accumulator and collision_char
ActorCheckBelow: {

  lda #$0
  sta collision_char
  
  // get the y pixel to check
  clc
  lda actor_screen_yl,x
  adc actor_bottom_offset,x
  sta check_screen_y
  
  // check left first
  // x coordinate of left pixel of sprite
  lda actor_screen_xl,x
  sta check_screen_xl
  lda actor_screen_xh,x
  sta check_screen_xh
  
  jsr GetCharAt
  sta collision_char

  // is the player on a solid?
  cmp #TILE_SOLID
  bne actor_check_below_right_edge
  rts
  
  // still need to check both edges?
actor_check_below_right_edge:
  
  // add width of actor to x coordinate
  clc
  lda actor_screen_xl,x
  adc #$05
  sta check_screen_xl
  lda actor_screen_xh,x
  adc #$00
  sta check_screen_xh
  
  jsr GetCharAt

  cmp #TILE_SOLID
  bne actor_check_below_end
  sta collision_char

actor_check_below_end:
  lda collision_char
  rts
}




ActorCheckLeft: {
  // result is in collision_char
  lda #$00
  sta collision_char
  
  // test left edge

  // ----- top left
  lda actor_screen_yl,x
  
  sta check_screen_y
  inc check_screen_y
  
  clc
  lda actor_screen_xl,x
//  adc 
  //  sbc temp8
  sta check_screen_xl
  

  lda actor_screen_xh,x
//  adc #$00
  sta check_screen_xh
  
  // subtract one from the edge
  sec 
  lda check_screen_xl
  sbc #01 
  sta check_screen_xl
  
  lda check_screen_xh
  sbc #00
  sta check_screen_xh
  
  jsr GetCharAt
  
  cmp #TILE_SOLID
  bne actor_check_left_mid

  // found tile block
  sta collision_char
  // GetCharAt should also return the column

  // --- bottom left
actor_check_left_mid:

  // actor is 14 pixels high
  clc
  lda actor_screen_yl,x
  adc #07
  sta check_screen_y
  
  // need to go up one
  dec check_screen_y

  jsr GetCharAt

  // is player left edge in a solid
  cmp #TILE_SOLID
  bne actor_check_left_bottom
  sta collision_char


actor_check_left_bottom:
  // actor is 14 pixels high
  clc
  lda actor_screen_yl,x
  adc #14
  sta check_screen_y
  
  // need to go up one
  dec check_screen_y

  jsr GetCharAt

  // is player left edge in a solid
  cmp #TILE_SOLID
  bne actor_check_left_end
  sta collision_char
  
actor_check_left_end:
  // want character just below left
  clc
  inc check_screen_y
  inc check_screen_y
  inc check_screen_y
  jsr GetCharAt

  sta actor_char_below_left,x

  lda collision_char

  rts
}

ActorCheckRight: {
  lda #$00
  sta collision_char
  
  lda actor_screen_yl,x
  sta check_screen_y
  inc check_screen_y
  
  clc
  lda actor_screen_xl,x
  adc actor_right_offset,x
  sta check_screen_xl

  lda actor_screen_xh,x
  adc #$00
  sta check_screen_xh
  jsr GetCharAt
  
  cmp #TILE_SOLID
  bne actor_check_right_mid

  sta collision_char

actor_check_right_mid:
  
  // add the offset to the bottom of the sprite
  clc
  lda actor_screen_yl,x
  adc #07
  sta check_screen_y
  dec check_screen_y
  
  jsr GetCharAt
  
  cmp #TILE_SOLID
  bne actor_check_right_bottom
  
  sta collision_char
actor_check_right_bottom:
  
  // add the offset to the bottom of the sprite
  clc
  lda actor_screen_yl,x
  adc #14
  sta check_screen_y
  dec check_screen_y
  
  jsr GetCharAt
  
  cmp #TILE_SOLID
  bne actor_check_right_done
  
  sta collision_char

actor_check_right_done:

  // want character just below right
  clc
  inc check_screen_y
  inc check_screen_y
  inc check_screen_y

  jsr GetCharAt
  sta actor_char_below_right,x
  
  lda collision_char
  
  rts
}
  
  