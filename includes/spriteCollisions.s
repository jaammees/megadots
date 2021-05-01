// work out sprite to sprite and sprite to tile collisions
// a mess, but seems to work



// store sprite to sprite collisions
sprite_to_sprite:

// corresponding bit is set if the sprite has collided that sprite
sprite_to_sprite_0:
.byte $0
sprite_to_sprite_1:
.byte $0
sprite_to_sprite_2:
.byte $0
sprite_to_sprite_3:
.byte $0
sprite_to_sprite_4:
.byte $0
sprite_to_sprite_5:
.byte $0
sprite_to_sprite_6:
.byte $0
sprite_to_sprite_7:
.byte $0



// store sprite to tile collisions
// a sprite can cover a max of 3x3 grid of tiles (9 bytes)
// each byte has what tile was found for the corresponding cell
sprite_to_tile:
sprite_to_tile_0:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_1:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_2:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_3:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_4:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_5:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_6:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_7:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0

// pointers to the sprite to tile collision data
sprite_to_tile_ptr_low:
.byte <sprite_to_tile_0
.byte <sprite_to_tile_1
.byte <sprite_to_tile_2
.byte <sprite_to_tile_3
.byte <sprite_to_tile_4
.byte <sprite_to_tile_5
.byte <sprite_to_tile_6
.byte <sprite_to_tile_7

sprite_to_tile_ptr_high:
.byte >sprite_to_tile_0
.byte >sprite_to_tile_1
.byte >sprite_to_tile_2
.byte >sprite_to_tile_3
.byte >sprite_to_tile_4
.byte >sprite_to_tile_5
.byte >sprite_to_tile_6
.byte >sprite_to_tile_7


// each byte has the row of the tile which collided with the sprite
sprite_to_tile_row:
sprite_to_tile_row_0:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_1:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_2:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_3:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_4:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_5:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_6:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_row_7:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0

// pointers to the sprite to tile collision data
sprite_to_tile_row_ptr_low:
.byte <sprite_to_tile_row_0
.byte <sprite_to_tile_row_1
.byte <sprite_to_tile_row_2
.byte <sprite_to_tile_row_3
.byte <sprite_to_tile_row_4
.byte <sprite_to_tile_row_5
.byte <sprite_to_tile_row_6
.byte <sprite_to_tile_row_7

sprite_to_tile_row_ptr_high:
.byte >sprite_to_tile_row_0
.byte >sprite_to_tile_row_1
.byte >sprite_to_tile_row_2
.byte >sprite_to_tile_row_3
.byte >sprite_to_tile_row_4
.byte >sprite_to_tile_row_5
.byte >sprite_to_tile_row_6
.byte >sprite_to_tile_row_7



// each byte has the column of the tile which collided with the sprite
sprite_to_tile_col:
sprite_to_tile_col_0:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_1:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_2:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_3:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_4:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_5:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_6:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0
sprite_to_tile_col_7:
.byte $0,$0,$0,$0,$0,$0,$0,$0,$0

// pointers to the sprite to tile collision data
sprite_to_tile_col_ptr_low:
.byte <sprite_to_tile_col_0
.byte <sprite_to_tile_col_1
.byte <sprite_to_tile_col_2
.byte <sprite_to_tile_col_3
.byte <sprite_to_tile_col_4
.byte <sprite_to_tile_col_5
.byte <sprite_to_tile_col_6
.byte <sprite_to_tile_col_7

sprite_to_tile_col_ptr_high:
.byte >sprite_to_tile_col_0
.byte >sprite_to_tile_col_1
.byte >sprite_to_tile_col_2
.byte >sprite_to_tile_col_3
.byte >sprite_to_tile_col_4
.byte >sprite_to_tile_col_5
.byte >sprite_to_tile_col_6
.byte >sprite_to_tile_col_7



sprite_address_low:
.byte $0,$0,$0,$0,$0,$0,$0,$0

sprite_address_high:
.byte $0,$0,$0,$0,$0,$0,$0,$0


// convert current sprite pointers to addresses in memory and store them
StoreSpriteAddresses: {
  txa
  pha

  ldx #7
store_sprite_addresses_loop:
  // only do it for enable sprites
  lda SPRITES_ENABLED
  and bittable,x



  // prob should save these somewhere so dont need to calculate for every pixel
  lda SPRITE_POINTERS,x
  sta sprite_address_low,x

  lda SPRITE_POINTERS + 1,y
  sta sprite_address_high,x


  // multiply by 64 bytes per sprite
  asl sprite_address_low,x
  rol sprite_address_high,x
  asl sprite_address_low,x
  rol sprite_address_high,x
  asl sprite_address_low,x
  rol sprite_address_high,x
  asl sprite_address_low,x
  rol sprite_address_high,x
  asl sprite_address_low,x
  rol sprite_address_high,x
  asl sprite_address_low,x
  rol sprite_address_high,x

  dex
  bpl store_sprite_addresses_loop

  pla
  tax
  rts
}

CheckSprite: {

  lda sprite_to_check
  tax  
  asl
  tay

  lda $d000,y
  sta sprite_to_check_xl
  lda $d001,y
  sta sprite_to_check_yl

  lda #0
  sta sprite_to_check_yh

  lda $d010
  and bittable,x
  beq !+
  lda #$01
!:  
  sta sprite_to_check_xh


  // clear collisions
  // set the collision bits here, then transfer at the end to proper location
  lda #$0
  sta sprite_collisions

  // loop through all sprites
  ldx #$07


check_sprite_loop:
  // dont check collisions against itself
  cpx sprite_to_check
  beq check_next_sprite


  // only check if sprite is enabled
  lda SPRITES_ENABLED
  and bittable,x
  beq check_next_sprite


  // multiply x by 2 and store in y
  txa
  asl
  tay


  lda $d010
  and bittable,x
  beq !+
  
  lda #$01
!:  
  sta temp

  // convert sprite x coordinates into the coordinates of the sprite being checked
  sec
  //lda $d000,y
  lda $d000,y
  sbc sprite_to_check_xl
  sta sprite_check_xl

  lda temp
  sbc sprite_to_check_xh
  sta sprite_check_xh

  // if sprite_check_xl, sprite_check_xh is >= -16 and < 16 then keep checking


  // add 16 to x difference, check if less than 32
  clc
  lda sprite_check_xl
  adc #16
  sta temp1

  lda sprite_check_xh
  adc #0
  sta temp2

  // if high byte is non zero, then check next sprite
  lda temp2
  bne check_next_sprite

  // if low byte is greater than 32 then check next sprite
  lda temp1
  cmp #32
  bpl check_next_sprite

  


  // convert sprite y coordinates into the coordinates of sprite being checked
  // calculate y difference between sprites
  sec
  lda $d001,y
  sbc sprite_to_check_yl
  sta sprite_check_yl

  lda #0
  sbc sprite_to_check_yh
  sta sprite_check_yh

  // add 16 to y difference, check if less than 32
  clc
  lda sprite_check_yl
  adc #16
  sta temp1

  lda sprite_check_yh
  adc #0
  sta temp2

  lda temp2
  bne check_next_sprite

  lda temp1
  cmp #32
  bpl check_next_sprite
  // sprite rects are overlapping, so check the pixels...
  jsr CheckSpritePixelCollision

  cmp #0
  beq !+
  // collision, so set the bit
  lda sprite_collisions
  ora bittable,x
  sta sprite_collisions

!:  




check_next_sprite:
  dex
  bpl check_sprite_loop


  ldx sprite_to_check
  lda sprite_collisions
  sta sprite_to_sprite,x


  // -------------  tile collisions -------------------- //
  // now check against tiles

  // first clear collisions

  // set address_low_2 to tile collisions 3x3 grid
  ldx sprite_to_check

  lda sprite_to_tile_ptr_low,x
  sta address_low_2
  lda sprite_to_tile_ptr_high,x
  sta address_high_2

  lda sprite_to_tile_col_ptr_low,x
  sta address_low_3
  lda sprite_to_tile_col_ptr_high,x
  sta address_high_3

  lda sprite_to_tile_row_ptr_low,x
  sta address_low_4
  lda sprite_to_tile_row_ptr_high,x
  sta address_high_4


  lda #0
  ldy #8
clear_tile_collisions_loop:
  sta (address_low_2),y
  dey
  bpl clear_tile_collisions_loop

  // want cell row and col of sprite position
  // convert position to tile coords

  sec
  lda sprite_to_check_xl
  sbc #SPRITE_SCREEN_OFFSET_X
  sta sprite_to_check_xl
  sta sprite_col

  lda sprite_to_check_xh
  sta sprite_to_check_xh
  sbc #0

  // divide by 8 to get col
  lsr
  ror sprite_col
  lsr sprite_col
  lsr sprite_col
  // sprite_col should have col

//  lda #20
//  sta sprite_col

  sec
  lda sprite_to_check_yl
  sbc #SPRITE_SCREEN_OFFSET_Y
  sta sprite_to_check_yl
  sta sprite_row

  // divide by 8 to get row
  lsr sprite_row
  lsr sprite_row
  lsr sprite_row


  // sprite_row should now have row

  // want to check the 3x3 grid around the sprite
  lda #0
  sta grid_cell


  ldy #2
  lda sprite_row
  sta row

check_tile_row_loop:
  ldx #2
  lda sprite_col
  sta col
  
check_tile_col_loop:
  // save y
  phy

  // get the tile address
  jsr GetScreenAddress
  ldy #0
  lda (address_low),y
  sta grid_cell_tile
  // should check here if it's a tile we care about


  // multiply by 64 to get address of tile data

  sta tile_address_low
  lda #0
  sta tile_address_high

  asl tile_address_low
  rol tile_address_high
  asl tile_address_low
  rol tile_address_high
  asl tile_address_low
  rol tile_address_high
  asl tile_address_low
  rol tile_address_high
  asl tile_address_low
  rol tile_address_high
  asl tile_address_low
  rol tile_address_high



  // need the x and y difference between tile and sprite
  // multiply row and col by 8 to get 
  lda row
  asl
  asl
  asl  
  sta tile_pixel_yl

  lda col
  asl
  asl
  asl
  sta tile_pixel_xl

  lda #0
  sta tile_pixel_yh
  sta tile_pixel_xh

  sec
  lda tile_pixel_xl
  sbc sprite_to_check_xl
  sta sprite_check_xl

  sec
  lda tile_pixel_yl
  sbc sprite_to_check_yl
  sta sprite_check_yl

  jsr CheckSpriteTilePixelCollision

  cmp #0
  beq !+
  // collision occurred, set the grid value to the tile
  // address_low_2 should be pointer to the sprites' grid of cells
  ldy grid_cell
  lda grid_cell_tile
  sta (address_low_2), y

  lda col
  sta (address_low_3),y

  lda row
  sta (address_low_4),y

!:  
  // restore y
  ply

  inc grid_cell

  inc col
  dex
  bpl check_tile_col_loop

  inc row
  dey
  bpl check_tile_row_loop

  rts
}



// check 16x16 sprite against 8x8 tile
// sprite checking is in x
// tile_address_low and tile_address_high have the tile data
// x and y position difference is in sprite_check_xl and sprite_check_yl
// set accumulator to 1 if collision, 0 if no collision
CheckSpriteTilePixelCollision: {
  // save y
  phy

  lda #0
  sta sprite_check_pixel_y

check_pixel_y_loop:
  lda #0
  sta sprite_check_pixel_x
check_pixel_x_loop:

  lda (tile_address_low),y
  iny
  cmp #0  
  beq check_next_pixel

  
  // now check sprite in x register
  // add the offset to get in sprites coords
  lda sprite_to_check
  sta sprite_check_pixel

  clc
  lda sprite_check_pixel_x
  adc sprite_check_xl
  sta sprite_pixel_x

  clc
  lda sprite_check_pixel_y
  adc sprite_check_yl
  sta sprite_pixel_y

  jsr GetSpritePixel
  cmp #0
  beq check_next_pixel

  // collision !!!!
  lda #1
  jmp check_sprite_tile_collision_done

check_next_pixel:
  inc sprite_check_pixel_x
  lda sprite_check_pixel_x
  cmp #8
  bne check_pixel_x_loop


  inc sprite_check_pixel_y
  lda sprite_check_pixel_y
  cmp #8
  bne check_pixel_y_loop

  // no collision found
  lda #0
check_sprite_tile_collision_done:
  // restore y
  ply  
  rts
}


// sprite to check is sprite_to_check
// x coord is sprite_pixel_x
// y coord is sprite_pixel_y
GetSpritePixel: {
  // save x and y registers
  phx
  phy

  lda #0
  sta temp3

  // if sprite_pixel_x or sprite_pixel_y are not >= 0 and < 16 then can immediately return 0
  lda sprite_pixel_x
  bmi get_sprite_pixel_return_0
  cmp #16
  bpl get_sprite_pixel_return_0

  lda sprite_pixel_y
  bmi get_sprite_pixel_return_0
  cmp #16
  bpl get_sprite_pixel_return_0

  // need to get the sprite's address
  // get the 16 bit pointer
  lda sprite_check_pixel
  asl
  tay



  lda sprite_address_low,y
  sta address_low
  lda sprite_address_high,y
  sta address_high


  // multiply pixel y by 8 (sprites have 8 bytes per row)
  lda sprite_pixel_y
  asl
  asl
  asl

  // add it to sprite address
  clc
  adc address_low
  sta address_low

  lda #$0
  adc address_high
  sta address_high

  // now divide pixel x by 2 (each pixel is a nybble)
  lda sprite_pixel_x
  lsr 
  // carry flag should now have whether odd or even (should use stack)
  ror temp3

  clc 
  adc address_low
  sta address_low

  lda #$0
  adc address_high
  sta address_high



  ldy #0
  lda (address_low),y

  // if pixel x is odd, want the low nibble (temp3 has carry bit from before)
  ldy temp3
  bne get_sprite_return_low

get_sprite_return_high:
  lsr
  lsr
  lsr
  lsr
  jmp get_sprite_pixel_done
  // restore x and y registers


get_sprite_return_low:
  and #$0f
  jmp get_sprite_pixel_done

get_sprite_pixel_return_0:
  // return 0
  lda #0
get_sprite_pixel_done:
  ply
  plx

  rts  
}


// sprite checking is in x
// sprite checking against is in sprite_to_check
// x and y position difference is in sprite_check_xl and sprite_check_yl
CheckSpritePixelCollision: {
  lda #0
  sta sprite_check_pixel_y

check_pixel_y_loop:
  lda #0
  sta sprite_check_pixel_x
check_pixel_x_loop:

  // first check the sprite being checked against
//  lda sprite_to_check
//  sta sprite_check_pixel

  stx sprite_check_pixel

  lda sprite_check_pixel_x
  sta sprite_pixel_x
//  sta col

  lda sprite_check_pixel_y
  sta sprite_pixel_y
  //sta row


  jsr GetSpritePixel
  cmp #0
  
  beq check_next_pixel

  
  // now check sprite in x register
  // add the offset to get in sprites coords
//  stx sprite_check_pixel
  lda sprite_to_check
  sta sprite_check_pixel

  clc
  lda sprite_check_pixel_x
  adc sprite_check_xl
  sta sprite_pixel_x

  clc
  lda sprite_check_pixel_y
  adc sprite_check_yl
  sta sprite_pixel_y

  jsr GetSpritePixel
  cmp #0
  beq check_next_pixel

  lda #1
  rts


check_next_pixel:
  inc sprite_check_pixel_x
  lda sprite_check_pixel_x
  cmp #16
  bne check_pixel_x_loop


  inc sprite_check_pixel_y
  lda sprite_check_pixel_y
  cmp #16
  bne check_pixel_y_loop

  lda #0
  rts
}


CheckSpriteCollisions: {

  jsr StoreSpriteAddresses

  lda SPRITES_ENABLED
  sta sprites_enabled

  lda #7
  sta sprite_to_check
check_sprite_collisions_loop:  
  asl sprites_enabled
  bcc !+

  jsr CheckSprite

!:
  dec sprite_to_check
  bpl check_sprite_collisions_loop

  rts
}
