// animated tiles, crumble, projectile, projectile emitter, bounce up tile
.const MAX_ANIMATED_TILES   = 64

AddAnimatedTile: {
  // save x..use y instead??
  stx temp1
  sta temp2
 
  ldx #(MAX_ANIMATED_TILES-1)

// find a free animated tile slot
add_animated_tile_loop:
  lda animated_tile,x
  beq add_animated_tile_slot_found

  dex
  bmi add_animated_tile_done // no slot found...
  jmp add_animated_tile_loop


add_animated_tile_done: 
  // no slot found..
  // restore x
  ldx temp1
  lda #$00     // fail

  rts

add_animated_tile_slot_found:

  lda temp2
  sta animated_tile,x

//  lda #$03   // timer
  lda animated_tile_time

  sta animated_tile_counter,x

  lda row
  sta animated_tile_row,x
  lda col
  sta animated_tile_col,x
  lda tile_type
  sta animated_tile_type,x

  // store what is currently in the tile position
  lda (address_low),y
  sta animated_tile_prev,x
  

  // y has offset from address_low/high
  // add it to address_low/high
  clc
  tya
  adc address_low
  sta animated_tile_l,x
  lda #$00
  adc address_high
  sta animated_tile_h,x

  // restore x
  ldx temp1   
  lda #$01     // success
  rts
}




AddProjectile: {
	lda #$30
	sta animated_tile_counter,x
	
	// position where to add projectile should be in row/col
	jsr GetScreenAddress
	
	// check if cell is free
	lda (address_low),y
	cmp #TILE_BLANK
	bne add_projectile_done
	
	lda #$03
	sta animated_tile_time
	
	lda #TILE_PROJECTILE
	clc
	adc tile_type

	jsr AddAnimatedTile
	
	lda #TILE_PROJECTILE
	clc 
	adc tile_type
	sta (address_low),y
add_projectile_done:
	rts
}




// loop through all the animated tiles and animated them
AnimateTiles: {
  ldx #(MAX_ANIMATED_TILES-1)
  ldy #$0

animate_tiles_loop:
	// if animated tile is zero, then slot is empty
  lda animated_tile,x
  bne animate_tiles_ok
  jmp animate_tiles_next

animate_tiles_ok:
	// only animate the tile if the counter is zero
  dec animated_tile_counter,x
//  lda animated_tile_counter,x
  beq do_animate_tile
  jmp animate_tiles_next
do_animate_tile:
  // animated tile counter is zero

	// screen address of the tile
  lda animated_tile_l,x
  sta address_low
  lda animated_tile_h,x
  sta address_high

	// check what the tile is to determine what to put there next
  lda animated_tile,x
	cmp #TILE_CRUMBLE1
	bne animated_tile_check_crumble_2

	// turn it into a crumble 2 tile
  lda #TILE_CRUMBLE2
  sta (address_low),y
  sta animated_tile,x
  lda #TILE_CRUMBLE_TIME_2
  sta animated_tile_counter,x
  jmp animate_tiles_next


animated_tile_check_crumble_2:
	
  cmp #TILE_CRUMBLE2     // crumble 2
  bne animated_tile_check_crumble_3

  lda #TILE_CRUMBLE3
  sta (address_low),y
  sta animated_tile,x
  lda #TILE_CRUMBLE_TIME_3
  sta animated_tile_counter,x
  jmp animate_tiles_next

animated_tile_check_crumble_3:

  cmp #TILE_CRUMBLE3
  bne animated_tile_check_crumble_4
  lda #TILE_CRUMBLE4
  sta (address_low),y
  sta animated_tile,x
  lda #TILE_CRUMBLE_TIME_4
  sta animated_tile_counter,x

  jmp animate_tiles_next
  
animated_tile_check_crumble_4:
  cmp #TILE_CRUMBLE4
  bne animate_tile_check_tile_up_1
  lda #TILE_CRUMBLE1
  sta (address_low),y

	// clear the animated tile slot
  lda #$0
  sta animated_tile,x
  jmp animate_tiles_next

animate_tile_check_tile_up_1:
	cmp #TILE_UP_1
	bne animate_tile_check_tile_up_2
	
	lda #TILE_UP_2
	sta (address_low),y
	sta animated_tile,x
	lda #$1
	sta animated_tile_counter,x
	jmp animate_tiles_next

animate_tile_check_tile_up_2:
	cmp #TILE_UP_2
	bne animate_tile_check_tile_up_3
	
	lda #TILE_UP_3
	sta (address_low),y
	sta animated_tile,x
	lda #$10
	sta animated_tile_counter,x
	jmp animate_tiles_next
	
animate_tile_check_tile_up_3:
	cmp #TILE_UP_3
	bne animate_tile_check_tile_left_1
	
	lda #TILE_UP
	sta (address_low),y
	lda #$0
	sta animated_tile,x
	jmp animate_tiles_next

animate_tile_check_tile_left_1:
	cmp #TILE_LEFT_1
	bne animate_tile_check_tile_left_2
	
	lda #TILE_LEFT_2
	sta (address_low),y
	sta animated_tile,x
	lda #$1
	sta animated_tile_counter,x
	jmp animate_tiles_next

animate_tile_check_tile_left_2:
	cmp #TILE_LEFT_2
	bne animate_tile_check_tile_left_3
	
	lda #TILE_LEFT_3
	sta (address_low),y
	sta animated_tile,x
	lda #$10
	sta animated_tile_counter,x
	jmp animate_tiles_next
	
animate_tile_check_tile_left_3:
	cmp #TILE_LEFT_3
	bne animate_tile_check_tile_right_1
	
	lda #TILE_LEFT
	sta (address_low),y
	lda #$0
	sta animated_tile,x
	jmp animate_tiles_next
	

animate_tile_check_tile_right_1:
	cmp #TILE_RIGHT_1
	bne animate_tile_check_tile_right_2
	
	lda #TILE_RIGHT_2
	sta (address_low),y
	sta animated_tile,x
	lda #$1
	sta animated_tile_counter,x
	jmp animate_tiles_next

animate_tile_check_tile_right_2:
	cmp #TILE_RIGHT_2
	bne animate_tile_check_tile_right_3
	
	lda #TILE_RIGHT_3
	sta (address_low),y
	sta animated_tile,x
	lda #$10
	sta animated_tile_counter,x
	jmp animate_tiles_next
	
animate_tile_check_tile_right_3:
	cmp #TILE_RIGHT_3
	bne animate_tile_check_emitter_up
	
	lda #TILE_RIGHT
	sta (address_low),y
	lda #$0
	sta animated_tile,x
	jmp animate_tiles_next


animate_tile_check_emitter_up:
	cmp #TILE_EMITTER_UP
	bne animate_tile_check_emitter_active_up

	// change it to active
	lda #TILE_EMITTER_ACTIVE_UP
	sta (address_low),y
	sta animated_tile,x

	// put a projectile tile in row above	


	lda animated_tile_row,x
	sta row
	dec row
	lda animated_tile_col,x
	sta col
	
	lda #PROJECTILE_UP
	sta tile_type
	
	jsr AddProjectile

	lda #TIME_EMITTER_ACTIVE
	sta animated_tile_counter,x

	jmp animate_tiles_next
	
animate_tile_check_emitter_active_up:
	cmp #TILE_EMITTER_ACTIVE_UP
	bne animate_tile_check_emitter_down

	lda #TILE_EMITTER
	sta (address_low),y
	sta animated_tile,x
	lda #TIME_EMITTER
	sta animated_tile_counter,x

	jmp animate_tiles_next

animate_tile_check_emitter_down:
	cmp #TILE_EMITTER_DOWN
	bne animate_tile_check_emitter_active_down

	// change it to active
	lda #TILE_EMITTER_ACTIVE_DOWN
	sta (address_low),y
	sta animated_tile,x

	// put a projectile tile in row above	
	lda animated_tile_row,x
	sta row
	inc row
	lda animated_tile_col,x
	sta col
	
	lda #PROJECTILE_DOWN
	sta tile_type
	
	jsr AddProjectile

	lda #TIME_EMITTER_ACTIVE
	sta animated_tile_counter,x

	jmp animate_tiles_next
	
animate_tile_check_emitter_active_down:
	cmp #TILE_EMITTER_ACTIVE_DOWN
	bne animate_tile_check_emitter_left

	lda #TILE_EMITTER_DOWN
	sta (address_low),y
	sta animated_tile,x
	lda #TIME_EMITTER
	sta animated_tile_counter,x

	jmp animate_tiles_next


animate_tile_check_emitter_left:
	cmp #TILE_EMITTER_LEFT
	bne animate_tile_check_emitter_active_left

	// change it to active
	lda #TILE_EMITTER_ACTIVE_LEFT
	sta (address_low),y
	sta animated_tile,x

	// put a projectile tile in row above	
	lda animated_tile_row,x
	sta row
	lda animated_tile_col,x
	sta col
	dec col
	
	lda #PROJECTILE_LEFT
	sta tile_type
	
	jsr AddProjectile
	
	lda #TIME_EMITTER_ACTIVE
	sta animated_tile_counter,x
	
	jmp animate_tiles_next
	
animate_tile_check_emitter_active_left:
	cmp #TILE_EMITTER_ACTIVE_LEFT
	bne animate_tile_check_emitter_right

	lda #TILE_EMITTER_LEFT
	sta (address_low),y
	sta animated_tile,x
	lda #TIME_EMITTER
	sta animated_tile_counter,x

	jmp animate_tiles_next

animate_tile_check_emitter_right:

	cmp #TILE_EMITTER_RIGHT
	bne animate_tile_check_emitter_active_right

	// change it to active
	lda #TILE_EMITTER_ACTIVE_RIGHT
	sta (address_low),y
	sta animated_tile,x


	// put a projectile tile in row above	
	lda animated_tile_row,x
	sta row
	lda animated_tile_col,x
	sta col
	inc col
	
	lda #PROJECTILE_RIGHT
	sta tile_type
	
	jsr AddProjectile
	
	lda #TIME_EMITTER_ACTIVE
	sta animated_tile_counter,x
	
	jmp animate_tiles_next

animate_tile_check_emitter_active_right:

	cmp #TILE_EMITTER_ACTIVE_RIGHT
	bne animate_tile_check_projectile

	lda #TILE_EMITTER_RIGHT
	sta (address_low),y
	sta animated_tile,x
	lda #TIME_EMITTER
	sta animated_tile_counter,x

	jmp animate_tiles_next


animate_tile_check_projectile:
	cmp #TILE_PROJECTILE_UP
	beq !+
	cmp #TILE_PROJECTILE_DOWN
	beq !+
	cmp #TILE_PROJECTILE_LEFT
	beq !+
	cmp #TILE_PROJECTILE_RIGHT
	beq !+
//	bne animate_tiles_next
	jmp animate_tiles_next
!:
	lda #$03
	sta animated_tile_counter,x
	
	// set cell back to what it was
	lda animated_tile_row,x
	sta row
	lda animated_tile_col,x
	sta col
	jsr GetScreenAddress
	
	lda animated_tile_prev,x
	sta (address_low),y
		
	lda animated_tile_type,x
	cmp #PROJECTILE_UP
	bne check_projectile_down
	dec row
	jmp draw_projectile_new_position
check_projectile_down:
	cmp #PROJECTILE_DOWN
	bne check_projectile_left
	inc row
	jmp draw_projectile_new_position
check_projectile_left:
	cmp #PROJECTILE_LEFT
	bne check_projectile_right
	dec col
	jmp draw_projectile_new_position
check_projectile_right:
	inc col

draw_projectile_new_position:
	jsr GetScreenAddress
	
	lda (address_low),y
	cmp #TILE_BLANK
	beq draw_projectile_new
	cmp #TILE_BLANK_RED
	beq draw_projectile_new
	cmp #TILE_BLANK_GREEN
	beq draw_projectile_new
	cmp #TILE_BLANK_BLUE
	beq draw_projectile_new
	
	// projectile reached end, so disable animated tile
	lda #$00
	sta animated_tile,x
	jmp animate_tiles_next

draw_projectile_new:
  // save the previous character
  lda (address_low),y
  sta animated_tile_prev,x
  

	clc
	lda #TILE_PROJECTILE
	adc animated_tile_type,x
	sta (address_low),y
	
	lda row
	sta	animated_tile_row,x
	lda col
	sta animated_tile_col,x

draw_projectile_new_done:


  
animate_tiles_next:
  dex
  bmi animate_tiles_done
  jmp animate_tiles_loop

animate_tiles_done:
  rts
}

// animated tiles
animated_tile:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_counter:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_l:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_h:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_col:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_row:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

animated_tile_type:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


// what the tile was previously
animated_tile_prev:
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


