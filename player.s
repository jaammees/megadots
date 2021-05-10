.const JOYSTICK              = $dc01
.const JOYSTICK_UP           = %00000001
.const JOYSTICK_DOWN         = %00000010
.const JOYSTICK_LEFT         = %00000100
.const JOYSTICK_RIGHT        = %00001000
.const JOYSTICK_FIRE         = %00010000

.const JUMP_STEPS            = 12
// number of pixels actor will go up on each step
actor_jump_table:
.byte -4, -06, -08, -08, -8, -10, -11, -13, -12, -10, -10, -10, -10, -12, -12, -12


// player has died, start countdown to restarting the level
PlayerDie: {
	jsr StatusIncreaseTries

	lda #(diesound - soundsstart)
  jsr QueueSound

  lda #GAME_STATE_DEAD
  sta game_state

  lda #25
  sta game_state_counter

	rts
}

// accumulator should be 1 if player can boost, 0 otherwise
SetPlayerCanBoost: {
	phy
	phx

	sta player_can_boost

	cmp #0
	beq player_cant_boost

	ldy #3
	ldx #1
	jsr CopySpriteColor
	jmp set_player_can_boost_done

player_cant_boost:
	ldy #4
	ldx #1
	jsr CopySpriteColor

set_player_can_boost_done:
	plx
	ply
	rts
}


// respond to player controls
PlayerControls: {

adjust_coyote:
	// player can start a jump when coyote counter is not zero
  dec player_coyote_counter
  bpl adjust_coyote_done
  lda #00
  sta player_coyote_counter
adjust_coyote_done:


check_boost_counter:
	lda player_boost_counter
	beq check_boost_counter_done

	dec player_boost_counter
	bne continue_boost
	
	// boost has just finished, reset things
continue_boost:
	// check not boosting into wall
	lda actor_char_left
	cmp #TILE_BLOCK
	beq check_boost_counter_done
	lda actor_char_right
	cmp #TILE_BLOCK
	beq check_boost_counter_done


	jmp player_controls_done
check_boost_counter_done:
	lda #$0
	sta player_boost_counter

	// set default frame, in air sprite
	lda #FRAME_JUMP
	sta actor_base_frame
	lda #JUMP_FRAME_COUNT
	sta actor_frame_count
	
test_on_ground:

	lda actor_char_below
	cmp #TILE_SOLID
	bne actor_is_in_air

	// on ground
	lda actor_on_ground
	bne actor_is_on_ground
	// actor has just reached ground
	
	lda #FRAME_LAND_EFFECT
	jsr player_add_effect

actor_is_on_ground:

	

	lda #01
	sta actor_on_ground
	jsr SetPlayerCanBoost
//	sta player_can_boost
	
	lda #$00
	sta player_boost_counter
	
	lda #COYOTE_TIME
	sta player_coyote_counter
	
	lda #PLAYER_GROUND_FORCE
	sta actor_force
	
	lda #PLAYER_GROUND_FORCE_NO_INPUT
	sta actor_force_no_input
	
	lda #FRAME_STAND
	sta actor_base_frame

test_on_ground_done:
	jmp check_joystick

actor_is_in_air:
	lda #0
	sta actor_on_ground

	lda #PLAYER_AIR_FORCE
	sta actor_force
	
	lda #PLAYER_AIR_FORCE_NO_INPUT
	sta actor_force_no_input

set_gravity_force:
	lda #GRAVITY_FORCE
	sta actor_gravity_force
	lda #MAX_DOWN_SPEED
	sta actor_max_down_speed
	
set_gravity_check_left:
	lda actor_char_left
	cmp #TILE_SOLID
	beq set_gravity_touching_wall
set_gravity_check_right:
	lda actor_char_right
	cmp #TILE_SOLID
	bne apply_gravity

// different max speed if touching wall
set_gravity_touching_wall:
	lda #MAX_DOWN_SPEED
	sta actor_max_down_speed
	
	lda #FRAME_SCRAPE
	sta actor_base_frame
	
// move this to general actor code
apply_gravity:
	clc
	lda actor_sy
	adc actor_gravity_force
	sta actor_sy

	cmp actor_max_down_speed
	bmi apply_gravity_done
	
	lda actor_max_down_speed
	sta actor_sy

apply_gravity_done:

check_joystick:
  lda JOYSTICK
  and #JOYSTICK_FIRE
  beq joystick_fire

	// z key can also be used
	lda z_key_pressed
	bne joystick_fire
	lda x_key_pressed
	bne joystick_fire

  jmp joystick_not_fire

	
joystick_fire:
	
  // if fire is already down, continuing jump
  // otherwise maybe start a jump
  lda player_button_down
  beq player_check_start_jump
  jmp player_continue_jump
  
// check if the player can start a jump  
player_check_start_jump:

	// if touching open door, player could be trying to exit instead of jump
	lda player_touching_door
	beq !+
	lda dot_count
	bne !+

	lda #$01
	sta player_button_down
	jsr NextLevel
	jmp player_controls_done
!:

	// can jump if coyote counter is not zero
	lda player_coyote_counter
	bne player_start_jump

	// if against left wall, start a wall jump
	lda actor_char_left
	cmp #TILE_SOLID
	bne player_check_start_wall_jump_right
	
	// jumping off left wall
	lda #WALL_JUMP_SPEED
	sta actor_sx

	// have to add the effect before settings the direction
	lda #FRAME_WALLJUMP_EFFECT
	jsr player_add_effect
	
	
	lda #0
	sta actor_direction
	
	jmp player_wall_jump
	
player_check_start_wall_jump_right:
	lda actor_char_right
	cmp #TILE_SOLID
	bne joystick_fire_in_air
	
	lda #-WALL_JUMP_SPEED
	sta actor_sx

	// have to add the effect before setting the direction
	lda #FRAME_WALLJUMP_EFFECT
	jsr player_add_effect

	lda #1
	sta actor_direction

player_wall_jump:	
//	lda #WALL_JUMP_SPRITE
//	sta actor_base_frame
	
	
	// player loses control for wall jump time
	lda #WALL_JUMP_TIME
	sta player_wall_jump_counter
	
	jmp player_start_jump	
	
	
// player has pushed fire while in the air
joystick_fire_in_air:
	lda player_can_boost
	bne !+
	jmp joystick_fire_done
!:

	// start a boost
player_check_boost_direction:
	lda actor_direction
	bne player_boost_left
player_boost_right:
	lda #BOOST_SPEED
	jmp player_start_boost
player_boost_left:
	lda #-BOOST_SPEED
player_start_boost:
	sta actor_sx
	
	lda #$01
	sta player_button_down

	lda #$00

	// no gravity in boost
	sta actor_sy
//	sta player_can_boost
	jsr SetPlayerCanBoost

	
	lda #FRAME_BOOST_X
	sta actor_base_frame
	
	lda #BOOST_STEPS
	sta player_boost_counter
	
	lda #FRAME_BOOST_EFFECT
	jsr player_add_effect

	lda #(boostsound - soundsstart)
  jsr QueueSound


	// started a boost, so lose control
	jmp player_controls_done	

// start a jump
player_start_jump:

	lda #$01
	sta player_button_down
	
	lda #WALL_STICK_TIME
	sta player_wall_stick_counter

	lda #$0
	sta actor_current_frame
	
	lda #JUMP_STEPS
	sta player_jump_counter

  lda #(jumpsound - soundsstart)
  jsr QueueSound


player_continue_jump:

	// if jump counter is zero, jump is over
	ldy player_jump_counter
	beq check_wall_stick
	
	// put the value from the jump table into y speed
	lda actor_jump_table,y
	sta actor_sy


	// decrease jump counter
	dec player_jump_counter
	jmp joystick_fire_done
	
check_wall_stick:
	// only want to stick if actor is about to move down and fire button pushed
	lda actor_sy
	bmi player_wall_stick_done

	lda player_wall_stick_counter
	beq player_wall_stick_done

	// stick the player to the wall if touching wall and fire held down after jump
	lda actor_char_right
	cmp #TILE_SOLID
	beq	player_wall_stick
	lda actor_char_left
	cmp #TILE_SOLID
	beq	player_wall_stick
	jmp joystick_fire_done

player_wall_stick:
	// set y speed to 0
	dec player_wall_stick_counter
	lda #0
	sta actor_sy
player_wall_stick_done:	
	jmp joystick_fire_done


joystick_not_fire:
	// reset button down
	lda #$0
	sta player_button_down
	sta player_jump_counter

joystick_fire_done:

	// left/right joystick shouldn't work if 
	// just started a wall jump
check_wall_jump_counter:
	lda player_wall_jump_counter
	beq check_wall_jump_counter_done
	dec player_wall_jump_counter
	jmp check_joystick_up
check_wall_jump_counter_done:


check_joystick_left:
  lda JOYSTICK
  and #JOYSTICK_LEFT
	beq joystick_is_left

	lda left_key_pressed
	bne joystick_is_left

  jmp check_joystick_right

joystick_is_left:
  lda #$01
  sta actor_direction
  
  lda actor_char_left 
  cmp #TILE_SOLID
  bne joystick_left_check_on_ground

joystick_left_check_on_ground:
	lda actor_on_ground
	beq do_joystick_left

joystick_left_on_ground:
	lda #FRAME_WALK
	sta actor_base_frame
	lda #WALK_FRAME_COUNT
	sta actor_frame_count

do_joystick_left:
  // subtract force from x speed
  sec
  lda actor_sx
  sbc #$01
  sta actor_sx
	
  cmp #-(MAX_PLAYER_SPEED)
  bpl joystick_left_done

  lda #-(MAX_PLAYER_SPEED - 1)
  sta actor_sx
joystick_left_done:
	jmp check_joystick_up

check_joystick_right:
  lda JOYSTICK
  and #JOYSTICK_RIGHT
	beq joystick_is_right
	lda right_key_pressed
	bne joystick_is_right


  jmp joystick_not_left_or_right

joystick_is_right:
  lda #$00
  sta actor_direction


  lda actor_char_right
  cmp #TILE_SOLID
  bne joystick_right_check_on_ground

joystick_right_check_on_ground:
	lda actor_on_ground
	beq do_joystick_right

joystick_right_on_ground:
	lda #FRAME_WALK
	sta actor_base_frame
	lda #WALK_FRAME_COUNT
	sta actor_frame_count


do_joystick_right:
  clc 
  lda actor_sx
  adc #$01 // force
  sta actor_sx

  cmp #MAX_PLAYER_SPEED

  bmi joystick_right_done

  lda #MAX_PLAYER_SPEED
  sta actor_sx

joystick_right_done:
	jmp check_joystick_up

joystick_not_left_or_right:
	jsr player_reduce_speed

check_joystick_up:
  lda JOYSTICK
  and #JOYSTICK_UP
  bne check_joystick_down

check_joystick_down:
  lda JOYSTICK
  and #JOYSTICK_DOWN
	beq joystick_is_down

	lda down_key_pressed
	bne joystick_is_down

  jmp player_controls_done  


joystick_is_down:
  // if touching door, could be trying to exit
  lda player_touching_door 
  beq player_controls_done
  jsr NextLevel
  
player_controls_done:
  rts


player_reduce_speed:
	// joystick is not left or right..reduce player speed if moving
  lda actor_sx
  bmi player_reduce_negative_speed          // branch if minus

  // speed is positive
  // subtract force from speed
  sec
  sbc actor_force_no_input
  sta actor_sx
  
  // if speed is still positive, go to next joystick test
  bpl check_joystick_up
  
  // speed is negative, gone too far, reset to zero
  jmp set_speed_to_zero


player_reduce_negative_speed:
  // speed is negative
  clc
  adc actor_force_no_input
  sta actor_sx
  
  // if speed is still negative, go to next joystick test
  bmi check_joystick_up

set_speed_to_zero:
  // gone too far, set speed to zero
  lda #$00
  sta actor_sx
	rts
	
	
// use actor 7 to add visual effects
// jump, land, boost
player_add_effect:
	sta actor_base_frame + 7
	lda #EFFECTS
	sta actor_type + 7
	
	// all effects are 3 frames
	lda #03
	sta actor_frame_count + 7
	lda #0
	sta actor_frame_timer + 7
	sta actor_current_frame + 7

	// copy values from player
	// same position as player sprite
	lda actor_xl
	sta actor_xl + 7

	lda actor_xh
	sta actor_xh + 7
	
	lda actor_yl
	sta actor_yl + 7
	lda actor_yh
	sta actor_yh + 7
	
	lda actor_direction
	sta actor_direction + 7

	rts
}

PlayerCheckInPlayArea: {
  // if player out of play area, then they die
  lda actor_screen_xh
  beq !+
  
  cmp #$3f
  beq out_of_play_area
  
  lda actor_screen_xl
  cmp #$3e
out_of_play_area:
  bmi !+
  jsr PlayerDie

!:
	rts
}
