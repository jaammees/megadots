.cpu _45gs02

.const SCREEN_ADDR            = $0800
.const SPRITE_POINTERS        = $c00 //$bf8 

.const COLOUR_RAM_ADDR        = $d800
.const SPRITE_SCREEN_OFFSET_X = 24
.const SPRITE_SCREEN_OFFSET_Y = 51



#import "gameConstants.s"
#import "includes/m65macros.s"
#import "zeropage.s"
#import "tiles/tileTypes.s"


BasicUpstart65(Entry)
*=$2016
Entry: {
	
	jsr SetupSystem


	jsr CreateScreenLookup
	jsr InitSound

	jsr SetSpritePalette
	jsr SetTilePalette


	lda #$0
	sta $d020
	sta $d021


	//Adjust screen if not xemu
//	lda $d629 
//	beq !+
//	lda #0
//	sta $d04f
//	lda #$6a
//	sta $d04e
//!:

	lda #$0
	sta title_show_times

	lda #STARTING_LEVEL
	sta level_current
	jsr StartLevel


	// wait for raster line
wait_for_raster:
	lda $d012
	cmp #$fe
	bne wait_for_raster

	jsr DrawStatus
	jsr CheckKeyboard


	lda game_state
	cmp #GAME_STATE_DEAD
	bne game_play

	dec game_state_counter
	bne game_dead

	jsr StartLevel
game_dead:
	jmp game_play_end

game_play:
	lda level_current
	beq increase_time_done
	jsr StatusIncreaseTime
increase_time_done:
	jsr PlayerControls
	jsr MoveActors
	
	jsr AnimateActors
	jsr DrawActors
	jsr AnimateTiles

	// work out sprite to sprite and sprite to tile collisions
	jsr CheckSpriteCollisions

	// game logic for collisions
	jsr CheckCollisions

	
	jsr EnemyLogic

	// just in case the player somehow gets outside the play area
	jsr PlayerCheckInPlayArea

	// should the door exit be flashing?
	jsr DoorStatus

	jsr CycleFunnelColors
	
game_play_end:

	jsr PlaySounds


wait_for_raster_end:
	lda $d012
	cmp #$f0
	beq wait_for_raster_end
	jmp wait_for_raster
}

*= $3e04 
#import "includes/setup.s"
#import "includes/util.s"
#import "includes/text.s"
#import "includes/keyboard.s"

#import "actorBoundsChecks.s"
#import "actors.s"
#import "animatedtiles.s"
#import "levels/leveldata.s"

#import "titleScreen.s"
#import "levels.s"
#import "player.s"
#import "enemy.s"
#import "collisions.s"
#import "switches.s"
#import "sound.s"

#import "sounds/sounddata.s"
#import "includes/spriteCollisions.s"

*= $e000
#import "statusBar.s"

#import "palette.s"
#import "palettes/spritePaletteData.s"
#import "palettes/tilePaletteData.s"



// the screen is set up to have 1 byte per tile, so can have max 256 tiles
// tiles can be between 0 and $4000
// if tiles start at $2200 can have 120 tiles
// first tile is $2200/$40 = $88 (136)
// tiles between $2200 and $4000
*= $2200
#import "tiles/tileData.s"


// 42 sprites @ 128bytes each = 5376 ($1500) bytes 
*= $8000  
#import "sprites/spriteData.s"


