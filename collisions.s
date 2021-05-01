// check sprite to tile collisions, sprite to sprite collisions
// uses the data generated by includes/spriteCollisions.s

CheckCollisions: {
	// reset collision switch and player touching door
  lda #00
  sta collision_switch
  sta player_touching_door

  // go from 0 to 7, want to do player test first
  ldx #$0
check_collisions_loop:
  // check if the actor is active
  lda actor_type,x
  beq check_collisions_next

  jsr CheckTileCollisions

  // only really care about sprite collisions for the player (actor 0)
  cpx #0
  bne !+
  jsr ActorCheckSpriteCollisions
!:  

check_collisions_next:
  inx
  cpx #ACTOR_COUNT - 1

  bne check_collisions_loop

check_collisions_done:
  rts
}

// actor number is in x
CheckTileCollisions: {
  // loop through the grid produced in sprite Collisions.s

  // get pointers

  // pointer to 3x3 grid of tiles the actor is touching
  lda sprite_to_tile_ptr_low,x
  sta sprite_to_tile_low
  lda sprite_to_tile_ptr_high,x
  sta sprite_to_tile_high

  // pointer to 3x3 grid of the screen row of the tiles actor is touching
  lda sprite_to_tile_row_ptr_low,x
  sta sprite_to_tile_row_low
  lda sprite_to_tile_row_ptr_high,x
  sta sprite_to_tile_row_high

  // pointer to 3x3 grid of the screen col of the tiles actor is touching
  lda sprite_to_tile_col_ptr_low,x
  sta sprite_to_tile_col_low
  lda sprite_to_tile_col_ptr_high,x
  sta sprite_to_tile_col_high

  // save y register
  tya
  pha

  // loop through the 3x3 grid of tiles
  ldy #8
check_tile_loop:

  // get the screen address of the tile
  lda (sprite_to_tile_row_low),y
  sta row
  lda (sprite_to_tile_col_low),y
  sta col
  jsr GetScreenAddress

  // get the tile
  lda (sprite_to_tile_low),y

  // save y, set it to 0, want to retain value of a, so store in a temp
  sty temp4


  // skip all the tests if it's an empty cell (tile index 0)
  cmp #0
  bne !+
  jmp check_tile_next
!:
  ldy #0


check_death_char:
  cmp #TILE_SPIKE_UP  // death char
  beq check_is_death_char
  cmp #TILE_SPIKE_DOWN  // death char
  beq check_is_death_char
  cmp #TILE_SPIKE_LEFT  // death char
  beq check_is_death_char
  cmp #TILE_SPIKE_RIGHT  // death char
  beq check_is_death_char


  jmp check_projectile_collision

check_is_death_char:
  // only care about this if it's the player (x register = 0)
  txa 
  bne check_projectile_collision
  
  jsr PlayerDie
  jmp tile_collision_done

check_projectile_collision:

  cmp #TILE_PROJECTILE_UP
  beq actor_hit_projectile
  cmp #TILE_PROJECTILE_DOWN
  beq actor_hit_projectile
  cmp #TILE_PROJECTILE_LEFT
  beq actor_hit_projectile
  cmp #TILE_PROJECTILE_RIGHT
  beq actor_hit_projectile

  jmp check_dot_collision


actor_hit_projectile:
  txa 
  bne check_dot_collision
  jsr PlayerDie  
  
  jmp tile_collision_done

check_dot_collision:  
  cmp #TILE_DOT
  bne check_collision_switch

clear_dot_cell:

  // is dot cell already empty?

  lda (address_low),y
  cmp #TILE_DOT
  bne check_dots_left

  lda #(dotsound - soundsstart)
  jsr QueueSound
 
  // increase dot count if its the player 
  cpx #0
  bne !+
  jsr StatusIncreaseDots
!:
	
	// clear the dot
  lda #TILE_BLANK
  sta (address_low),y

  dec dot_count

check_dots_left:  

  lda dot_count
  bmi all_dots_gone // just in case
  bne check_collision_switch
  
  // all dots gone  
all_dots_gone:  
  lda #$0
  sta dot_count

  lda #(canexitsound - soundsstart)
  jsr QueueSound
  jsr OpenTheDoor
  jmp check_tile_next

check_collision_switch:  
  // need to check if on a down switch
  // to set the switch collision flag.
  // dont want to keep toggling up/down
  cmp #TILE_SWITCH_DOWN_RED
  beq char_collision_switch
  cmp #TILE_SWITCH_DOWN_GREEN
  beq char_collision_switch
  cmp #TILE_SWITCH_DOWN_BLUE
  beq char_collision_switch
  
  jmp check_switch_up_collision

char_collision_switch:
  // been a collision with a switch
  lda #$01
  sta collision_switch
  jmp check_tile_next


check_switch_up_collision:
  cmp #TILE_SWITCH_UP_RED
  beq switch_up_collision
  cmp #TILE_SWITCH_UP_GREEN
  beq switch_up_collision
  cmp #TILE_SWITCH_UP_BLUE
  beq switch_up_collision

  jmp check_door_collision


switch_up_collision:
  // store the switch type
  sec
  sbc #TILE_SWITCH_UP_FIRST
  sta switch_type

  // if someone else pushed switch, thats it for this test
  lda collision_switch
  bne check_tile_next

  // tile below needs to be solid
  inc row
  // call the col, row to screen address routine
  jsr GetScreenAddress

  // load the character at the address
  lda (address_low),y
  
  cmp #TILE_SOLID
  bne check_tile_next

  lda #(switchsound - soundsstart)
  jsr QueueSound

  // need to reset address_low/high
  // should do this better
  jsr SwitchPress
  
  lda #01
  sta collision_switch



check_door_collision:
  
  cmp #DOOR_OPEN_3   // door tile 1
  beq door_collision
  cmp #DOOR_OPEN_4
  beq door_collision
  cmp #DOOR_OPEN_5
  beq door_collision
  cmp #DOOR_OPEN_6
  beq door_collision
  
  jmp check_up_collision
  
door_collision:
  // only want to do for player 1
  txa 
  bne check_tile_next
  lda #$01 
  sta player_touching_door


check_up_collision:
  cmp #TILE_UP 
  bne check_tile_next
  
	lda #$1
	sta animated_tile_time
	lda #TILE_UP_1
  sta (address_low),y

	jsr AddAnimatedTile

  lda #-UP_TILE_SPEED
  sta actor_sy,x
 
	cpx #0
	bne !+
  // reset the boost
  lda #$01
  jsr SetPlayerCanBoost
  
  lda #0
  sta player_boost_counter
//  jsr reset_shake
!:
 
  lda #(bouncesound - soundsstart)
  jsr QueueSound



check_tile_next:
  // restore y
  ldy temp4

  dey
  bmi !+
  jmp check_tile_loop
!:


tile_collision_done:
  pla
  tay
  rts
}
  

// actor number is in x
ActorCheckSpriteCollisions: {
  lda sprite_to_sprite,x
  // ignore collisions with both actor 0 (player) and actor 7 (effects)
  and #%01111110
  beq !+
  // there's been a collision!
  //inc $d020
  jsr PlayerDie

!:
  rts
}
