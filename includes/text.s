.const TEXT_TILES_OFFSET = TILE_BLOCK + 16

DrawText: {
  tya
  pha

  jsr GetScreenAddress
  ldy #0
draw_text_loop:
  lda (text_address_low),y
  beq !+
  adc #TEXT_TILES_OFFSET
  sta (address_low),y
  iny
  jmp draw_text_loop
!:

  pla
  tay
  rts  
}