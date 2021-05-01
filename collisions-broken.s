// Check collisions between actors and tiles
// and player and other actors
CheckCollisions: {
	// reset collision switch and player touching door
  lda #00
  sta collision_switch
  sta player_touching_door

  // tile collisions
  // want to check all actors against tiles
  // check player actor first (actor 0)
  ldx #$0
check_collisions_loop:
  // check if the actor is active
  lda actor_type,x
  beq check_collisions_next

  jsr CheckTileCollisions

  // sprite to sprite collisions
  // only care about player sprite (actor 0)
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
  phy

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


  // skip all the tests if it's an empty cell (tile index 0)
  cmp #0
  bne !+
  jmp check_tile_next
!:


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
  beq check_hit_projectile
  cmp #TILE_PROJECTILE_DOWN
  beq check_hit_projectile
  cmp #TILE_PROJECTILE_LEFT
  beq check_hit_projectile
  cmp #TILE_PROJECTILE_RIGHT
  beq check_hit_projectile

  jmp check_dot_collision


check_hit_projectile:
  txa 
  bne check_dot_collision

  jsr PlayerDie  
  
  jmp tile_collision_done

check_dot_collision:

  cmp #TILE_DOT
  bne check_collision_switch

clear_dot_cell:
  phy
  ldy #0

  // make sure cell is still a dot
  lda (address_low),y
  cmp #TILE_DOT
  beq player_collect_dot

  // already blank
  ply
  jmp check_tile_next


player_collect_dot:
  lda #(dotsound - soundsstart)
  jsr QueueSound

  // increase dot count if it's the player
  cpx #0
  bne !+
  jsr StatusIncreaseDots
!:


  lda #TILE_BLANK
  sta (address_low),y
  dec dot_count
  bpl dot_count_is_ok

  // dot count gone negative, set it to zero
  lda #$00
  sta dot_count

dot_count_is_ok:
  ply

  lda dot_count
  beq all_dots_gone

  jmp check_tile_next
//  bne check_collision_switch
  
  // all dots gone
all_dots_gone:  
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
  phy
  ldy #0
  lda (address_low),y
  ply
  
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

  phy
  ldy #0
	lda #TILE_UP_1
  sta (address_low),y
	jsr AddAnimatedTile
  ply


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
  dey
  bmi !+
  jmp check_tile_loop
!:


tile_collision_done:

  // restore y
  ply
  rts
}
  

// actor number is in x
ActorCheckSpriteCollisions: {
  lda sprite_to_sprite,x
  // ignore collisions with both actor 0 (player) and actor 7 (effects)
  and #%01111110
  beq !+
  // there's been a collision!
  jsr PlayerDie
!:
  rts

}



