// enemy logic, just goes left and right

EnemyLogic: {
  // go through the 5 possible enemies
  ldx #05
enemy_logic_loop:

  // actor type of 0 mean no actor
  lda actor_type,x
  
  bne enemy_logic_ok
  jmp enemy_logic_next
enemy_logic_ok:
  // do enemy logic in here
  
enemy_check_below:
  // check if character below, dont want to move left or right if nothing below
  lda actor_char_below, x
  cmp #TILE_BLOCK
  beq enemy_check_speed
  lda #$0
  sta actor_sx,x
  jmp enemy_move_vertically

enemy_check_speed:

  // set vertical speed to 0
//  lda #$0
//  sta actor_sy,x

  // if actor speed is 0, set it to +1
  lda actor_sx,x
  bne enemy_check_sides

  // by default set to enemy speed

  lda actor_direction,x
  bne !+
  lda #ENEMY_SPEED //enemyspeed
  jmp enemy_set_default_speed
!:
  lda #-ENEMY_SPEED

enemy_set_default_speed:
  sta actor_sx,x
enemy_check_sides:

  // check the character to the left
  lda actor_char_left,x
  cmp #TILE_BLOCK

  bne enemy_test_below_left
  jmp enemy_set_speed_right

enemy_test_below_left:
  
  // check the character below to the left
//  lda actor_type,x    // friend 1 doesn't stop on edge
//  cmp #FRIEND1
//  beq enemy_test_right

  lda actor_char_below_left,x
  cmp #TILE_BLOCK  // shorthand for this?
  beq enemy_test_right

enemy_set_speed_right:
  // theres a block on the left
  // set x speed to 1

  lda #ENEMY_SPEED //enemyspeed
  sta actor_sx,x
  
  lda #00
  sta actor_direction,x

  jmp enemy_move_vertically


enemy_test_right:
  lda actor_char_right, x
  cmp #TILE_BLOCK
  bne enemy_test_below_right
  jmp enemy_set_speed_left


enemy_test_below_right:
//  lda actor_type,x    // friend 1 doesn't stop on edge
//  cmp #FRIEND1
//  beq enemy_move_vertically

  lda actor_char_below_right,x

  cmp #TILE_BLOCK  // shorthand for this?
  beq enemy_move_vertically

enemy_set_speed_left:
  lda #-ENEMY_SPEED //enemyspeedleft
  sta actor_sx,x
  
  lda #01
  sta actor_direction,x

enemy_move_vertically:
  // set y speed to 1

  lda #-$02
  sta actor_gravity_force
  lda #MAX_DOWN_SPEED
  sta actor_max_down_speed

  sec
  lda actor_sy,x
  sbc actor_gravity_force
  sta actor_sy,x
  cmp actor_max_down_speed
  bmi enemy_logic_next
  // going too fast down
  lda actor_max_down_speed
  sta actor_sy,x

//  lda #03
//  sta actor_sy,x
  
  
enemy_logic_next:

  dex
//  cpx #01
  beq enemy_logic_done
//  bmi enemy_logic_done
  jmp enemy_logic_loop


enemy_logic_done:
  
  
  rts
}