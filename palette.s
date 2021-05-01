// The VIC-IV has four palette banks, compared with the single palette bank of the VICIII. The VIC-IV allows the selection of separate palette banks for bitmap/text graphics
// and for sprites

// register $d070
// bit 0-1 = VIC-IV bitmap/text palette bank (alternate palette)
// bit 2-3 = sprite palette bank
// bit 4-5 = bitmap/text palette bank
// Bit 6-7 = Mapped Palette


SetSpritePalette: {
	phx

	// set mapped palette to 01
	// sprite palette is 01
	// tile palette is 10
	lda #%01100110
	sta $d070

	ldx #$00
!:
	lda sprite_palette_0_red,x
//	lda #$ff
	sta $d100, x //Red
	lda sprite_palette_0_green,x

	sta $d200, x //Green
	lda sprite_palette_0_blue,x
	sta $d300, x //Blue
	inx
	bne !-


	phy
	ldy #03
	ldx #01
	jsr CopySpriteColor
	ply

	plx
  rts
}


// copy sprite colour y to x
CopySpriteColor: {
	// set mapped palette to 01
	lda #%01100110
	sta $d070

	lda $d100,y
	sta $d100,x

	lda $d200,y
	sta $d200,x


	lda $d300,y
	sta $d300,x

	rts
}


// choose a tile palette from palettes in palettes/paletteData.s
// accumulator has palette number
SetTilePalette: {
	phx
	tax

	// set mapped palette to 01
	// sprite palette is 01
	// tile palette is 10
	lda #%10100110
	sta $d070

	lda tile_palette_red_low,x
	sta red_palette + 1
	lda tile_palette_red_high,x
	sta red_palette + 2

	lda tile_palette_green_low,x
	sta green_palette + 1
	lda tile_palette_green_high,x
	sta green_palette + 2

	lda tile_palette_blue_low,x
	sta blue_palette + 1
	lda tile_palette_blue_high,x
	sta blue_palette + 2

	ldx #$00
!:
red_palette:
	lda $ffff, x
	sta $d100, x //Red
green_palette:
	lda $ffff, x
	lda tile_palette_0_green,x
	sta $d200, x //Green
blue_palette:	
	lda $ffff, x
	lda tile_palette_0_blue,x
	sta $d300, x //Blue
	inx
	bne !-

	plx

	rts
}

// copy tile colour from y to x
CopyTileColor: {
	// set mapped palette to 01
	lda #%10100110
	sta $d070

	lda $d100,y
	sta $d100,x

	lda $d200,y
	sta $d200,x


	lda $d300,y
	sta $d300,x

	rts
}