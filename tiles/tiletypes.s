// tiles start at tile 136 ($2200 = 136x64)
// 64 bytes per tile
.const FIRST_TILE        = 136



// just a holder value to represent a tile 2 pixels high
.const TILE_2_HIGH       = 102




.const TILE_0            = FIRST_TILE + 64
.const TILE_1            = FIRST_TILE + 65
.const TILE_2            = FIRST_TILE + 66
.const TILE_3            = FIRST_TILE + 67
.const TILE_4            = FIRST_TILE + 68
.const TILE_5            = FIRST_TILE + 69
.const TILE_6            = FIRST_TILE + 70
.const TILE_7            = FIRST_TILE + 71
.const TILE_8            = FIRST_TILE + 72
.const TILE_9            = FIRST_TILE + 73

// tiles
.const TILE_BLOCK        = 136 //137 // $a1 //160
.const TILE_SOLID        = TILE_BLOCK 
.const TILE_BLOCK_FIRST  = TILE_BLOCK + 1
.const TILE_BLOCK_RED    = TILE_BLOCK + 1
.const TILE_BLOCK_GREEN  = TILE_BLOCK + 2
.const TILE_BLOCK_BLUE   = TILE_BLOCK + 3




.const TILE_BLANK        = 140
.const TILE_BLANK_FIRST  = TILE_BLANK + 1
.const TILE_BLANK_RED    = TILE_BLANK + 1
.const TILE_BLANK_GREEN  = TILE_BLANK + 2
.const TILE_BLANK_BLUE   = TILE_BLANK + 3


.const TILE_CRUMBLE      = FIRST_TILE + 8
.const TILE_CRUMBLE1     = TILE_CRUMBLE + 0
.const TILE_CRUMBLE2     = TILE_CRUMBLE + 1
.const TILE_CRUMBLE3     = TILE_CRUMBLE + 2
.const TILE_CRUMBLE4     = TILE_CRUMBLE + 3

.const TILE_CRUMBLE_TIME_1 = 6
.const TILE_CRUMBLE_TIME_2 = 20
.const TILE_CRUMBLE_TIME_3 = 20
.const TILE_CRUMBLE_TIME_4 = 50

.const TILE_PROJECTILE        = FIRST_TILE + 12
.const TILE_PROJECTILE_UP     = TILE_PROJECTILE + 0
.const TILE_PROJECTILE_DOWN   = TILE_PROJECTILE + 1
.const TILE_PROJECTILE_LEFT   = TILE_PROJECTILE + 2
.const TILE_PROJECTILE_RIGHT  = TILE_PROJECTILE + 3

.const TILE_EMITTER           = FIRST_TILE + 22
.const TILE_EMITTER_UP        = TILE_EMITTER + 0
.const TILE_EMITTER_DOWN      = TILE_EMITTER + 1
.const TILE_EMITTER_LEFT      = TILE_EMITTER + 2
.const TILE_EMITTER_RIGHT     = TILE_EMITTER + 3


.const TILE_EMITTER_ACTIVE       = FIRST_TILE + 38
.const TILE_EMITTER_ACTIVE_UP    = TILE_EMITTER_ACTIVE + 0
.const TILE_EMITTER_ACTIVE_DOWN  = TILE_EMITTER_ACTIVE + 1
.const TILE_EMITTER_ACTIVE_LEFT  = TILE_EMITTER_ACTIVE + 2
.const TILE_EMITTER_ACTIVE_RIGHT = TILE_EMITTER_ACTIVE + 3

//.const TILE_EMITTER2  = 219
//.const TILE_EMITTER3  = 188


.const TILE_SWITCH_UP_FIRST = 152
.const TILE_SWITCH_UP_RED   = 152
.const TILE_SWITCH_UP_GREEN = 153
.const TILE_SWITCH_UP_BLUE  = 154


.const TILE_SWITCH_DOWN_FIRST  = 155
.const TILE_SWITCH_DOWN_RED    = 155
.const TILE_SWITCH_DOWN_GREEN  = 156
.const TILE_SWITCH_DOWN_BLUE   = 157

.const TILE_DOT      = 168
//.const TILE_INVISIBLE = 156

.const TILE_UP        = FIRST_TILE + 34 //170
.const TILE_UP_1      = TILE_UP + 1 //171
.const TILE_UP_2      = TILE_UP + 2 //172
.const TILE_UP_3      = TILE_UP + 3 //173


.const TILE_SPIKE        = FIRST_TILE + 49
.const TILE_SPIKE_UP     = TILE_SPIKE + 0
.const TILE_SPIKE_DOWN   = TILE_SPIKE + 1
.const TILE_SPIKE_RIGHT  = TILE_SPIKE + 2
.const TILE_SPIKE_LEFT   = TILE_SPIKE + 3


.const DOOR_CLOSED_1 = 164
.const DOOR_CLOSED_2 = 165
.const DOOR_CLOSED_3 = 180
.const DOOR_CLOSED_4 = 181
.const DOOR_CLOSED_5 = 196
.const DOOR_CLOSED_6 = 197


.const DOOR_OPEN_1 = 166
.const DOOR_OPEN_2 = 167
.const DOOR_OPEN_3 = 182
.const DOOR_OPEN_4 = 183
.const DOOR_OPEN_5 = 198
.const DOOR_OPEN_6 = 199


.const PROJECTILE_UP     = 0
.const PROJECTILE_DOWN   = 1
.const PROJECTILE_LEFT   = 2
.const PROJECTILE_RIGHT  = 3

.const BLACK       = 0
.const WHITE       = 1
.const RED         = 2
.const CYAN        = 3
.const PURPLE      = 4
.const GREEN       = 5
.const BLUE        = 6
.const YELLOW      = 7
.const ORANGE      = 8
.const BROWN       = 9
.const LIGHT_RED   = 10
.const GREY_1      = 11
.const GREY_2      = 12
.const LIGHT_GREEN = 13
.const LIGHT_BLUE  = 14
.const GREY_3      = 15


