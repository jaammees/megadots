// routines to draw a level, go to next level
// data for the levels is in levels/levelData.s

.const DOOR_GREEN       = 51
.const DOOR_LIGHT_GREEN = 57
.const DOOR_DARK_GREEN  = 56

.const DOOR_FRAME_LIGHT = 53
.const DOOR_FRAME_DARK  = 35
.const DOOR_FRAME_COLOR = 50


.const FUNNEL_COLOR_1   = 8
.const FUNNEL_COLOR_2   = 9

.const FUNNEL_COLOR_LIGHT = 10
.const FUNNEL_COLOR_DARK = 11


funnel_color_state:
.byte 0
funnel_state_counter:
.byte 0

CycleFunnelColors: {
  dec funnel_state_counter
  bpl cycle_funnel_colors_done

//  inc $d020
  lda #10
  sta funnel_state_counter

  lda funnel_color_state
  bne !+
    
  ldy #FUNNEL_COLOR_LIGHT
  ldx #FUNNEL_COLOR_1
  jsr CopyTileColor

  ldy #FUNNEL_COLOR_DARK
  ldx #FUNNEL_COLOR_2
  jsr CopyTileColor
  jmp cycle_funnel_colors_done

!:
  ldy #FUNNEL_COLOR_LIGHT
  ldx #FUNNEL_COLOR_2
  jsr CopyTileColor

  ldy #FUNNEL_COLOR_DARK
  ldx #FUNNEL_COLOR_1
  jsr CopyTileColor

cycle_funnel_colors_done:
  lda funnel_color_state
  eor #1
  sta funnel_color_state
  rts
}

// flash the door exit sign if the player can exit
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
  ldy #DOOR_FRAME_DARK
  ldx #DOOR_FRAME_COLOR
  jsr CopyTileColor

  lda player_touching_door
  bne touching_door


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
  jmp door_status_done

touching_door:
  
  ldy #DOOR_LIGHT_GREEN
  ldx #DOOR_GREEN
  jsr CopyTileColor

  ldy #DOOR_FRAME_LIGHT
  ldx #DOOR_FRAME_COLOR
  jsr CopyTileColor

door_status_done:
  plx
  ply
  rts
}

EnterDoor: {
  phy
  // dots need to be zero
  lda dot_count
  bne enter_door_done

  // 4 rows below door top = 3 * 40
  ldy #120
  lda (door_address_low),y
  cmp #TILE_BLOCK
  beq go_through_door
  cmp #TILE_BLOCK_RED
  beq go_through_door
  cmp #TILE_BLOCK_GREEN
  beq go_through_door
  cmp #TILE_BLOCK_BLUE
  beq go_through_door
  cmp #TILE_CRUMBLE1
  beq go_through_door
  cmp #TILE_CRUMBLE2
  beq go_through_door
  cmp #TILE_CRUMBLE3
  beq go_through_door
  
  jmp enter_door_done

  // door needs to be on a solid
go_through_door:
  ply
  jmp NextLevel

enter_door_done:
  ply
  rts
} 

SkipLevel: {
	lda #$0
	sta dot_count

  lda #<player_status_seconds
  sta status_address_low
  lda #>player_status_seconds
  sta status_address_high

  jsr StatusIncrease2DigitNumber



	jsr NextLevel
  rts
}

RestartGame: {
  lda #0
  sta level_current

  jsr StartLevel
  rts
}

NextLevel: {

  jsr StatusIncreaseLevel 
  inc level_current
  
  lda level_current
  cmp #LEVEL_COUNT
  bne !+

  // reached the end, go back to the start!
  lda #0
  sta level_current
  jsr StatusResetTime
  jsr StatusResetLevel
  lda #1
  sta title_show_times
!:
  jsr StartLevel
next_level_done:
  rts
}


// start a level
StartLevel: {
  lda #GAME_STATE_PLAY 
  sta game_state
  // initialise dots to 0
  lda #$0
  sta dot_count
  sta player_touching_door
  sta blink_time

  // reset switch type
  lda #$ff
  sta switch_type
  
  // Setup colours
  ldy #DOOR_FRAME_DARK
  ldx #DOOR_FRAME_COLOR
  jsr CopyTileColor

  // initialise the actors
  ldx #(ACTOR_COUNT - 1)
  lda #00
init_actors_loop:
  sta actor_type,x
  sta actor_direction,x
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

  lda #$00
  sta $d027
  sta $d028
  sta $d029
  sta $d02a
  sta $d02b
  sta $d02c
  sta $d02d
  sta $d02e
  
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
	// put length into x
  tax
	
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
  

  iny
  lda (level_data_low),y
//  lda #00
  sta actor_direction,x

  lda #$00
  sta actor_sx,x
  
  lda #ENEMY_SPRITE
  sta actor_base_frame,x
  
  lda #ENEMY 
  sta actor_type,x

  // update level data pointers  
  lda #03
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

  iny
  lda (level_data_low),y
  sta actor_direction


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
