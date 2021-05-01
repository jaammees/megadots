#import "notes.s"


// bytes in each row:

//   timer
//   frequency low
//   frequency high
//   pulse low
//   pulse high
//   wavecontrol
//   attack/decay
//   sustain/release

// wave control byte:
//  7      6      5         4        3     2     1         0
// noise pulse sawtooth  triangle  test  ring synchronize gate


soundsstart:

nosound:
.byte $00

startsound:
jumpsound:
.byte $03, g4_lo, g4_hi, $08, $f8, $11, $31, $a3
.byte $03, d5_lo, d5_hi, $08, $f8, $11, $31, $a3
.byte $00

switchsound:
.byte $03, g4_lo, g4_hi, $08, $f8, $81, $c1, $a1
.byte $00

bouncesound:
.byte $03, d5_lo, d5_hi, $08, $f8, $11, $31, $a3
.byte $00


dotsound:
.byte $03, fs5_lo, fs5_hi, $01, $f4, $11, $15, $03
.byte $00

canexitsound:
.byte $05, fs5_lo, fs5_hi, $01, $f4, $11, $6f, $33
.byte $03, g5_lo, g5_hi, $01, $f4, $11, $6f, $3b
.byte $00

boostsound:
.byte $04, g2_lo, g2_hi, $01, $f4, $81, $4f, $35
.byte $00

diesound:
.byte $04, ds3_lo, ds3_hi, $01, $f4, $21, $4f, $35
.byte $00

