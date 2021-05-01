// up to 8 actors for each level
// actor 0 is always the player
// actor 7 is always the effects (dust, boost, etc)

.const ACTOR_COUNT = 8

// actor types
.const NONE        = 0
.const PLAYER      = 1
.const ENEMY       = 2
.const EFFECTS     = 3

.const SPRITE_POINTERS = $bf8 // 0bf8


// 21 sprites facing right, then 21 facing left
// facing right is direction 0
// if facing left need to add offset to get sprite
.const SPRITE_DIRECTION_OFFSET  = 21 * 2

// memory location for right facing sprites
.const SPRITES_FLIPPED_LOCATION = $2000 + SPRITE_DIRECTION_OFFSET * 64

// pointers for sprites
// each sprite is 128 bytes
// sprites start at $8000 ( pointer $0200)
.const FRAME_STAND           = 0 //$c0 //250 //$80
.const FRAME_BLINK           = FRAME_STAND + (1 * 2)
.const FRAME_WALK            = FRAME_BLINK + (1 * 2)
.const FRAME_JUMP            = FRAME_WALK  + (3 * 2)
.const FRAME_SCRAPE          = FRAME_JUMP  + (1 * 2)
.const FRAME_BOOST_X         = FRAME_SCRAPE + (1 * 2)
.const FRAME_BOOST_Y         = FRAME_BOOST_X + (1 * 2)

.const SHADOW_SPRITE         = FRAME_BOOST_X + (1 * 2)

.const FRAME_LAND_EFFECT     = FRAME_BOOST_X + (2 * 2)
.const FRAME_WALLJUMP_EFFECT = FRAME_BOOST_X + (5 * 2)
.const FRAME_BOOST_EFFECT    = FRAME_BOOST_X + (7 * 2)

.const ENEMY_SPRITE          = FRAME_BOOST_EFFECT + (4 * 2)


.const JUMP_SPRITE           = FRAME_LAND_EFFECT
.const WALL_JUMP_SPRITE      = FRAME_WALLJUMP_EFFECT
.const BOOST_SPRITE          = FRAME_BOOST_EFFECT


// frame counts
.const STAND_FRAME_COUNT     = $01
.const WALK_FRAME_COUNT      = $03
.const JUMP_FRAME_COUNT      = $01

// registers
.const SPRITES_X = $d000
.const SPRITES_Y = $d001
.const SPRITES_ENABLED = $d015
.const SPRITES_X_MSB = $d010


// convert tile row/column to 
// actor x and y
ActorRowColToPosition: {
  lda col
  sta actor_screen_xl,x
  lda #$00
  sta actor_screen_xh,x

  asl actor_screen_xl,x
  rol actor_screen_xh,x
  asl actor_screen_xl,x
  rol actor_screen_xh,x
  asl actor_screen_xl,x
  rol actor_screen_xh,x

  lda row
  sta actor_screen_yl,x
  lda #$00
  sta actor_screen_yh,x

  asl actor_screen_yl,x
  rol actor_screen_yh,x
  asl actor_screen_yl,x
  rol actor_screen_yh,x
  asl actor_screen_yl,x
  rol actor_screen_yh,x
 
  jsr ActorScreenXToX
  jsr ActorScreenYToY

  rts
}


// convert x in screen coords to actor coords
ActorScreenXToX: {
  lda actor_screen_xl,x
  sta actor_xl,x

  lda actor_screen_xh,x
  sta actor_xh,x

  asl actor_xl,x
  rol actor_xh,x
  asl actor_xl,x
  rol actor_xh,x

	rts
}

// convert y in screen coords to actor coords
ActorScreenYToY: {
	lda actor_screen_yl,x
	sta actor_yl,x
	
	lda #$0
	sta actor_yh,x
	
	asl actor_yl,x
	rol actor_yh,x
	asl actor_yl,x
	rol actor_yh,x
	rts
}



// loop through all the actors and move them according to their speed
MoveActors: {
	
  ldx #ACTOR_COUNT - 1

move_actors_loop:
  // check if the actor is active
  lda actor_type,x
  beq move_actors_next
//  bne move_actors_ok
//  jmp move_actors_next
move_actors_ok:
  jsr MoveActorY
  jsr MoveActorX
move_actors_next:
  dex
  bmi move_actors_done
  jmp move_actors_loop
move_actors_done:
  rts  
}


// move actor in y direction
// x register should have actor
// y speed should be in actor_sy,x
// actor position is in actor_yl,x actor_yh,x
MoveActorY: {

  clc
  lda actor_sy,x
  bmi move_actor_negy

  // actor moving downwards
  adc actor_yl,x
  sta actor_yl,x
  sta actor_screen_yl,x

  lda actor_yh,x
  adc #$00
  sta actor_yh,x
  sta actor_screen_yh,x

  jmp move_actor_y_done

move_actor_negy:
  // actor is moving upwards
  adc actor_yl,x
  sta actor_yl,x
  sta actor_screen_yl,x

  lda actor_yh,x
  adc #$ff
  sta actor_yh,x
  sta actor_screen_yh,x

move_actor_y_done:

  // convert to screen coordinates
  lsr actor_screen_yh,x
  ror actor_screen_yl,x
  lsr actor_screen_yh,x
  ror actor_screen_yl,x

  // check collisions unless its the effect actor (#7)
  cpx #7
  beq move_actor_y_check_done

  jsr ActorCheckBelow
  sta actor_char_below,x
  
  cmp #TILE_SOLID
  bne move_actor_y_check_bottom_edge

	// bottom actor edge is in a solid
	// move player up out of it	
	lda actor_screen_yl,x
	adc actor_bottom_offset,x
	and #%11111000
	sec
	sbc actor_bottom_offset,x
	sta actor_screen_yl,x
	jsr ActorScreenYToY

  // check if standing in a tile which is >0 and < 8 pixels high
move_actor_y_check_bottom_edge:
  // only want to do this if y speed is positive
  lda actor_sy,x
  bmi move_actor_y_check_above

  jsr ActorCheckBottom
  cmp #TILE_2_HIGH
  bne move_actor_y_check_above

  // actor is standing on a solid
  lda #TILE_SOLID
  sta actor_char_below,x

  // standing in a tile which is 2 pixels high
	lda actor_screen_yl,x
	adc actor_bottom_offset,x
  // move into the tile below then round down to get the tile inside
  adc #5
	and #%11111000
	sec
	sbc actor_bottom_offset,x
  sbc #$02
	sta actor_screen_yl,x

	// convert from screen coords
	jsr ActorScreenYToY
	
move_actor_y_check_above:

	jsr ActorCheckAbove
	sta actor_char_above,x
	
	cmp #TILE_SOLID
	bne move_actor_y_check_done

	// only round players y position if moving upwards
	lda actor_sy,x
	cmp #$01
	bpl move_actor_y_check_done
	
	// round player y position
	clc
	lda actor_screen_yl,x
	adc #$07
	and #%11111000
	sec
	sbc #01
	
	sta actor_screen_yl,x
	// convert from screen coords
	jsr ActorScreenYToY
	
move_actor_y_check_done:
  rts
}

MoveActorX: {
  clc
  lda actor_sx,x
  bmi move_actor_negx

  adc actor_xl,x
  sta actor_xl,x
  sta actor_screen_xl,x

  lda actor_xh,x
  adc #$00
  sta actor_xh,x
  sta actor_screen_xh,x
  jmp move_actor_x_done
move_actor_negx:
  adc actor_xl,x
  sta actor_xl,x
  sta actor_screen_xl,x

  lda actor_xh,x
  adc #$ff
  sta actor_xh,x
  sta actor_screen_xh,x
move_actor_x_done:
  // convert to screen coords

  lsr actor_screen_xh,x
  ror actor_screen_xl,x
  lsr actor_screen_xh,x
  ror actor_screen_xl,x

	// skip checks if its the effects actor
	cpx #07
	beq move_actor_x_check_done

  jsr ActorCheckLeft
  sta actor_char_left,x
  
  cmp #TILE_SOLID
  bne move_actor_x_check_right

  // if actor is moving right, dont care about what is to the left
  lda actor_sx,x
  cmp #$01
  bpl move_actor_x_check_right

	// player left edge is in a solid, add 7 to position and round down 
	clc 
	lda actor_screen_xl,x
	adc #$07
	and #%11111000
	sta actor_screen_xl,x
  
  bcc !+
  inc actor_screen_xh,x
!:

	// need to account for direction actor is facing
	ldy actor_direction,x
	bne move_actor_check_left_done

	lda actor_screen_xl,x
	adc #$04
	sta actor_screen_xl,x
	
	bcc !+
	inc actor_screen_xh,x
!:

move_actor_check_left_done:
	// now convert screen back to actor_x
	
  jsr ActorScreenXToX
  
  // set horizontal speed to 0
  lda #$0
  sta actor_sx,x

	
move_actor_x_check_right:
	jsr ActorCheckRight
	sta actor_char_right,x
	
	cmp #TILE_SOLID
	bne move_actor_x_check_done
	

  lda actor_screen_xl,x
  and #%11111000
  ora #%00000001  // add 1
  sta actor_screen_xl,x
  
  ldy actor_direction,x
  beq move_actor_x_check_right_done
  sec
  sbc #04
  sta actor_screen_xl,x
  
  lda actor_screen_xh,x
  sbc #00
  sta actor_screen_xh,x

move_actor_x_check_right_done:
  jsr ActorScreenXToX

  // set horizontal speed to 0
  lda #$0
  sta actor_sx,x

	
move_actor_x_check_done:
  rts
}




AnimateActors: { 
	ldx #ACTOR_COUNT - 1
animate_actors_loop:
	inc actor_frame_timer,x
	lda actor_frame_timer,x
	cmp actor_frame_timer_count,x
	bcc animate_actors_check_frame
	
	// have reached next frame
	
	// reset frame timer
	lda #$00
	sta actor_frame_timer,x
	
	// move to the next frame
	inc actor_current_frame,x
	
animate_actors_check_frame:
	// check if current frame greater than number of frames
	lda actor_current_frame,x
	cmp actor_frame_count,x
	bmi animate_actors_next
	
	// current frame is greater than number of frames
	// reset to first frame
	lda #0
	sta actor_current_frame,x
	
	// the effect actor (7) only loops once
	cpx #$07
	bne animate_actors_next
	// turn effect actor off
	lda #NONE
	sta actor_type,x
	
animate_actors_next:
	dex
	bpl animate_actors_loop
	
animate_actors_done:
	rts
}



DrawActors: {

  // sprite 0 colour
  lda #7
  sta $d027

  // clear the virtual values
  lda #$0
  sta virtual_sprites_enabled
  sta virtual_spritex_msb

  // loop through actors
  ldx #ACTOR_COUNT - 1
draw_actors_loop:
  lda actor_type,x
  beq draw_actors_next

draw_actors_ok:

  // set to enabled
  lda virtual_sprites_enabled
  ora bittable,x
  sta virtual_sprites_enabled

	// add the current frame * 2 to the base frame pointer to get sprite pointer 
  clc

  lda actor_current_frame,X
  asl
  adc actor_base_frame,x
//  lda actor_base_frame,x  
//  adc actor_current_frame,x
  
  // check if need to add offset for actor direction
  ldy actor_direction,x
  beq draw_actors_store_pointer
  
  // facing right, so need to add offset to pointer
  clc
  adc #SPRITE_DIRECTION_OFFSET
  // also need to nudge by 1 pixel
  // todo: nudge
draw_actors_store_pointer:

  // set y register to x register * 2 (used for 16 bit sprite pointers and x,y position registers )
  // todo: do  this a better way :)
  pha
  txa
  asl 
  tay
  pla

//  lda #$02
//  lda #FRAME_STAND
  sta SPRITE_POINTERS,y

  // all sprite pointers are $02xx
  lda #$02
  sta SPRITE_POINTERS + 1,y

  // calculate x and y positions of sprite

  // set x coordinate (bits 0-7)
  lda actor_screen_yl,x
  clc
  adc #SPRITE_SCREEN_OFFSET_Y
  sta sprite_y

  lda actor_screen_xl,x 
  clc
  adc #(SPRITE_SCREEN_OFFSET_X - 4)
  sta sprite_xl

  lda actor_screen_xh,x
  adc #0
  sta sprite_xh

  // set y register to actor index * 2, use as offset into x and y position
//  txa
//  asl
//  tay

  lda sprite_xl
  sta SPRITES_X,y

  // set y coordinate
  lda sprite_y
  sta SPRITES_Y,y


  // x msb
  lda sprite_xh
  beq draw_actors_next
  lda virtual_spritex_msb
  ora bittable,x
  sta virtual_spritex_msb

draw_actors_next:
  dex
  bpl draw_actors_loop
draw_actors_done:

  lda virtual_sprites_enabled
  sta SPRITES_ENABLED

  lda virtual_spritex_msb
  sta SPRITES_X_MSB
  rts
}  




//Powers of two for the corresponding bits of each sprite
bittable:
.byte  1,2,4,8,16,32,64,128

// actor variables
actor_type:
.byte PLAYER, NONE, NONE, NONE, NONE, NONE, NONE, NONE

//actor_state
//.byte $01, $00, $00, $00, $00, $00, $00, $00


// base sprite frame for actor 
actor_base_frame:
.byte $80, $80, $80, $80, $80, $80, $80, $80

// number of frames for actor
actor_frame_count:
.byte $03, $03, $03, $03, $03, $03, $03, $03

// time on the current frame
actor_frame_timer_count:
.byte $04, $04, $04, $04, $04, $04, $04, $3


// current frame for actor
actor_current_frame:
.byte $00, $00, $00, $00, $00, $00, $00, $00

// time on the current frame
actor_frame_timer:
.byte $00, $00, $00, $00, $00, $00, $00, $00


// direction actor facing, 0 = right, 1 = left
actor_direction:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_sy:
.byte $0, $0, $0, $0, $0, $0, $0, $00

actor_sx:
.byte $00, $00, $0, $0, $0, $00, $00, $00

// x,y coordinates of actors
actor_xl:
.byte $f0, $30, $40, $50, $60, $70, $80, $90

actor_xh:
.byte $0, $0, $0, $0, $0, $0, $0, $0

actor_yl:
.byte $20, $30, $40, $50, $60, $70, $80, $90

actor_yh:
.byte $20, $30, $40, $50, $60, $70, $80, $90


// x,y coordinates of actors converted to screen space
actor_screen_xl:
.byte $20, $30, $40, $50, $60, $70, $80, $90
// x position, high byte
actor_screen_xh:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_screen_yl:
.byte $30, $30, $30, $30, $30, $30, $30, $30

actor_screen_yh:
.byte $00, $00, $00, $00, $00, $00, $00, $00


// char below actor
actor_char_below:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_char_above:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_char_left:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_char_right:
.byte $00, $00, $00, $00, $00, $00, $00, $00

// character below actor to the left
actor_char_below_left:
.byte $00, $00, $00, $00, $00, $00, $00, $00

// character below actor to the right
actor_char_below_right:
.byte $00, $00, $00, $00, $00, $00, $00, $00


actor_on_ground:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_right_offset:
.byte 7,7,7,7,7,7,7,7

actor_bottom_offset:
.byte 14, 14, 14, 14, 14, 14, 14, 14

//actor_yh:
//.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_gravity_force:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_max_down_speed:
.byte $00, $00, $00, $00, $00, $00, $00, $00


// these prob only needed for player actor??
actor_force:
.byte $00, $00, $00, $00, $00, $00, $00, $00

actor_force_no_input:
.byte $00, $00, $00, $00, $00, $00, $00, $00

