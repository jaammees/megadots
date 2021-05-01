//pulsewidth_lowbyte = $d402
//pulsewidth_highbyte= $d403

// control sets the waveform and gatebit
//wavecontrol = $d404

// the first nybble of attack_decay is attack, the second nybble is decay
// on the SID this is $d405
//attack_decay = $d405
// the first nybble of sustain_release is sustain, the second nybble is release
//sustain_release = $d406

.const FILTERMODE_VOLUME = $d418


sound_ptr_low:
.byte $00, $00, $00

sound_ptr_high:
.byte $00, $00, $00

channel_timer:
.byte $00, $00, $00

channel_nosound_timer:
.byte $00, $00, $00

channel_control:
.byte $00, $00, $00


InitSound: {

  // clear all sid registers to 0
  ldx #$00
  lda #$00
  
  sta sound_last_channel
clearsidloop:
  // SID registers start at $d400
  sta $d400
  inc clearsidloop+1 
  inx
  cpx #$29 // and there are 29 of them
  bne clearsidloop

  // set master volume and turn filter off
  lda #%00001111 
  sta FILTERMODE_VOLUME

  // queue empty sounds
  lda #00
  jsr QueueSound
  lda #00
  jsr QueueSound
  lda #00
  jsr QueueSound

  rts
}
  
// queue a sound into the next free channel  
QueueSound: {
	//save y
  phy
  ldy sound_last_channel

  // accumulator is holding offset to the sound
  clc
  adc #<soundsstart
  sta sound_ptr_low,y
  lda #$00
  sta channel_timer,y
  sta channel_nosound_timer,y

  adc #>soundsstart
  sta sound_ptr_high,y  

  inc sound_last_channel
  lda sound_last_channel

  cmp #$03
  bne queuesound_done

  lda #$00
  sta sound_last_channel

queuesound_done:

	// restore y
  ply
  rts
}  



//$d400 frequency voice 1 low byte
//$d401 frequency voice 1 high byte
//$d402 pulsewave duty low byte
//$d403 pulsewave duty high byte
//$d404 wave control
//$d405 attack decay
//$d406 sustain sustain_release

PlaySounds: {
  // set address_low2 to start of sid registers
  lda #$00
  sta address_low_2
  lda #$d4
  sta address_high_2

  // loop over 3 sid channels
  ldx #$00

playsounds_loop:

  // y is offset into sound data
  ldy #$0

  // has the timer for this channels sound reached 0
  lda channel_timer,x
  beq playsound_next_row

  dec channel_timer,x
  jmp playsounds_next

playsound_next_row:
  // channel timer has reached zero, so load the next sound
  lda sound_ptr_low,x
  sta address_low

  lda sound_ptr_high,x
  sta address_high


playsound_check_byte:
  // if the first byte is zero, then there is no sound
  lda (address_low),y   // if first byte is zero, then no sound
  bne play_channel_sound

play_no_sound:
  // no sound, so close the gate
  ldy #$04    

  lda channel_control,x
  and #$fe
  sta (address_low_2),y
  
  // if played no sound for certain number of ticks,
  // set test bit and reset adsr
  lda channel_nosound_timer,x
  cmp #100
  bpl reset_adsr
  inc channel_nosound_timer,x
  jmp playsounds_next

reset_adsr:
  lda #%00010000
  sta (address_low_2),y
  lda #$0
  iny
  sta (address_low_2),y
  iny
  sta (address_low_2),y
  jmp playsounds_next
play_channel_sound:
  // first byte is timer
  sta channel_timer,x

  // set temp_low, temp_high to start of channel data (add 1 byte)
  clc
  lda address_low
  adc #$01
  sta address_low
  lda address_high
  adc #$00
  sta address_high

  // now just want to copy the rest into sid registers
copy_sid_data_loop:

  lda (address_low),y
  sta (address_low_2),y
//  sta $0413,y

  iny
  cpy #$07
  bne copy_sid_data_loop

  ldy #$04
  lda (address_low),y
  sta channel_control,x

  // set sound pointer to next row in sound
  // could use temp_low and add 7?
  clc
  lda sound_ptr_low,x
  adc #$08
  sta sound_ptr_low,x
  bcc sound_ptr_increased
  inc sound_ptr_high,x

sound_ptr_increased:

playsounds_next:
  clc
  lda address_low_2
  adc #$07
  sta address_low_2

  lda address_high_2
  adc #$00
  sta address_high_2

  inx
  cpx #$03
  beq !+
  jmp playsounds_loop
!:
  rts
}
