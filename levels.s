// routines to draw a level, go to next level

.const DOOR_GREEN       = 51
.const DOOR_LIGHT_GREEN = 57
.const DOOR_DARK_GREEN  = 56


// flash the door if can exit
DoorStatus: {
  phy
  phx

  // player can exit if dot count is zero
  lda dot_count
  beq flash_door

  // set door to normal colour
  ldy #DOOR_DARK_GREEN
  ldx #DOOR_GREEN
  jsr CopyTileColor

  jmp door_status_done
flash_door:
  dec door_flash_counter
  bne door_status_done

  lda #40
  sta door_flash_counter

  lda door_flash_state
  beq !+
  lda #0
  sta door_flash_state


  ldy #DOOR_LIGHT_GREEN
  ldx #DOOR_GREEN
  jsr CopyTileColor

  jmp door_status_done
!:  

  
  lda #1
  sta door_flash_state
  ldy #DOOR_DARK_GREEN
  ldx #DOOR_GREEN
  jsr CopyTileColor


door_status_done:
  plx
  ply
  rts
}

NextLevel: {
  // to go to next leve, dot count needs to be zero
  lda dot_count
  bne next_level_done

  jsr StatusIncreaseLevel 
  inc level_current
  
  lda level_current
  cmp #LEVEL_COUNT
  bne !+
  lda #0
  sta level_current
!:
  jsr StartLevel
next_level_done:
  rts
}

StartLevel: {
  lda #GAME_STATE_PLAY
  sta game_state
  // initialise dots to 0
  lda #$0
  sta dot_count
  sta player_touching_door

  // reset switch type
  lda #$ff
  sta switch_type
  
  // initialise the actors
  ldx #(ACTOR_COUNT - 1)
  lda #00
init_actors_loop:
  sta actor_type,x
  dex
  bne init_actors_loop
  

  // clear animated tiles, need to do this before drawing level
  ldx #MAX_ANIMATED_TILES
  lda #$0
clear_animated_tile_loop:
  sta animated_tile,x
  dex
  bpl clear_animated_tile_loop

	jsr DrawLevelData
  jsr SetupEnemies
  jsr SetupPlayer

  lda level_current
  bne !+
  jsr DrawTitleScreen
!:

  rts
}

ClearScreen: {
  ldx #0
  lda #TILE_BLANK
!:
  sta SCREEN_ADDR,x
  sta SCREEN_ADDR + $100,x
  sta SCREEN_ADDR + $200,x
  sta SCREEN_ADDR + $2e8,x
  inx
  cpx #0
  bne !-
  rts
}

DrawBorder: {
  ldx #40
  lda #TILE_SOLID  
draw_border_top_bottom:
  // top and bottom border
  sta SCREEN_ADDR + $27,x  
  sta SCREEN_ADDR + $03bf,x  
  
  dex
  bne draw_border_top_bottom
  
  // draw the side borders
  // start at row=1, col=0
  lda #01
  sta row
  lda #00 
  sta col
  

  // looping 22 times  
  ldx #22
draw_border_sides:
  ldy #0
  inc row
  jsr GetScreenAddress
  lda #TILE_SOLID
  sta (address_low),y
  ldy #39
  sta (address_low),y
  dex
  bne draw_border_sides

  rts
}


DrawLevelData: {

  // multiply current level by 2
	lda level_current
	asl
	tax
	
  // get the pointer to the current level's data
	lda levels,x
	sta level_data_low
	inx
	lda levels,x
	sta level_data_high
	
	ldy #0

  // sprite palette
  lda (level_data_low),y
  jsr SetSpritePalette

  // tile palette
  iny 
  lda (level_data_low),y
  jsr SetTilePalette


	// bg colour
  /*
  iny
	lda (level_data_low),y
	sta $d021
	sta $d020
	*/
	// number of lines
	iny
	lda (level_data_low),y
	sta level_line_count

	// enemy count
	iny
	lda (level_data_low),y
	sta level_enemy_count
	
	// point level data to the level's line data
	clc
	lda level_data_low
	adc #04
	sta level_data_low
	bcc !+
	inc level_data_high
!:

	jsr ClearScreen
	jsr DrawBorder
	jsr DrawLines
//	jsr setup_enemies
//	jsr setup_player
  rts
}


DrawLines: {
	ldy #0
	
	// get the column
	lda (level_data_low),y
	sta col
	
	// get the row
	iny
	lda (level_data_low),y
	sta row
	
	// get the tile type 
	iny
	lda (level_data_low),y
	sta level_line_type
	
	// get the direction (bit 7) | length
	iny

  // direction
	lda (level_data_low),y
  and #$80
  sta level_line_direction

  // length
  lda (level_data_low),y
  and #$7f
  tax
	// put length into x
//	lsr
//	tax
//	rol level_line_direction
	
	// point level_data to next line data (4 bytes per line)
	clc
	lda level_data_low
	adc #04
	sta level_data_low
	bcc !+
	inc level_data_high
!:

	// draw the line
	ldy #0
draw_line_loop:
	jsr GetScreenAddress
	lda level_line_type
  // ---------------------------
//  lda #TILE_SOLID
	sta (address_low),y
	
	cmp #TILE_EMITTER_UP
	beq draw_line_add_animated
	cmp #TILE_EMITTER_DOWN
	beq draw_line_add_animated
	cmp #TILE_EMITTER_LEFT
	beq draw_line_add_animated
	cmp #TILE_EMITTER_RIGHT
	beq draw_line_add_animated
	
	cmp #TILE_DOT
	bne get_line_direction
	
	inc dot_count
	
	
	jmp get_line_direction
	
draw_line_add_animated:
	ldy #$12
	sty animated_tile_time
	ldy #$0
	jsr AddAnimatedTile


get_line_direction:	
	lda level_line_direction
	bne draw_line_vertical
	// horizontal, so increase the column
	inc col
	jmp draw_line_next
draw_line_vertical:
	inc row
draw_line_next:
	dex
	bne draw_line_loop
	
	dec level_line_count
	bne DrawLines
	
	

  ldy #0
  
  // read in door location
  lda (level_data_low),y
  sta col
  
  iny
  lda (level_data_low),y
  sta row
  
  jsr GetScreenAddress

  lda address_low
  sta door_address_low
  lda address_high
  sta door_address_high

  // draw the door
  ldy #0
  lda #DOOR_CLOSED_1
  sta (door_address_low),y
  iny
  lda #DOOR_CLOSED_2
  sta (door_address_low),y
  ldy #40
  lda #DOOR_CLOSED_3
  sta (door_address_low),y
  iny
  lda #DOOR_CLOSED_4
  sta (door_address_low),y

  ldy #80
  lda #DOOR_CLOSED_5
  sta (door_address_low),y
  iny 
  lda #DOOR_CLOSED_6
  sta (door_address_low),y  
	
  // move pointer past door data
  lda #02
  clc
  adc level_data_low
  sta level_data_low

	bcc !+
  inc level_data_high
!:
	rts
}




SetupEnemies: {
  lda level_enemy_count
  beq setup_enemies_done

  // x holds current enemy index
  ldx #01
setup_enemy_read_data:
  ldy #00
  // read in row and column of enemy
  lda (level_data_low),y
  sta col
  iny
  lda (level_data_low),y
  sta row

  // store the actor position
  jsr ActorRowColToPosition
  
  lda #$01
  sta actor_sx,x
  
  lda #ENEMY_SPRITE
  sta actor_base_frame,x
  
  lda #ENEMY 
  sta actor_type,x

  // update level data pointers  
  lda #02
  clc
  adc level_data_low
  sta level_data_low
  bcc !+
  inc level_data_high
!:  

  inx
  
  dec level_enemy_count
  bne setup_enemy_read_data

setup_enemies_done:
	
	rts
}
	
SetupPlayer: {
  // set all the player stuff
  // player is always actor 0
  ldy #00
  ldx #00

  // player start position
  lda (level_data_low),y
  sta col
  iny
  lda (level_data_low),y
  sta row

  jsr ActorRowColToPosition


  // initialise to zero
  lda #$00 
  sta player_can_boost
  sta player_boost_counter
  sta player_jump_counter
  sta actor_sx
  sta actor_sy

  sta player_coyote_counter
  sta player_wall_jump_counter
  
	rts
}



OpenTheDoor: {
  phy
//  inc $d020
  // draw the open door
  ldy #0
  lda #DOOR_OPEN_1
  sta (door_address_low),y
  iny
  lda #DOOR_OPEN_2
  sta (door_address_low),y
  ldy #40
  lda #DOOR_OPEN_3
  sta (door_address_low),y
  iny
  lda #DOOR_OPEN_4
  sta (door_address_low),y

  ldy #80
  lda #DOOR_OPEN_5
  sta (door_address_low),y
  iny 
  lda #DOOR_OPEN_6
  sta (door_address_low),y  



  lda #1
  sta door_flash_counter

  ply
  rts
	
}
