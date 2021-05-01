// data making up each of the levels

.const STARTING_LEVEL = 0
.const LEVEL_COUNT    = 10


.const VERTICAL     = $80
.const HORIZONTAL   = $00


.const BLOCK        = TILE_BLOCK
.const DOT          = TILE_DOT
.const SPIKE_UP     = TILE_SPIKE_UP
.const SPIKE_DOWN   = TILE_SPIKE_DOWN
.const SPIKE_LEFT   = TILE_SPIKE_LEFT
.const SPIKE_RIGHT  = TILE_SPIKE_RIGHT
.const CRUMBLE      = TILE_CRUMBLE


level0data:
// which sprite palette to use (in palettes/spritePaletteData.s)
.byte 0
// which tile palette to use (in palettes/tilePaletteData.s)
.byte 0
// line count
.byte 2
// enemy count
.byte 0

// line data
// col, row, type, length | orientation
.byte 10, 23, TILE_BLOCK, 20
.byte 14, 22, TILE_DOT, 2

// door location
.byte 24
.byte 20

// player start pos
.byte 4,20


// -------------------------------------------//


level1data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 13
// enemy count
.byte 0

// line data
// col, row, type, length | orientation
.byte  1, 20, BLOCK, 10
.byte 17, 21, BLOCK, 6
.byte 19, 20, DOT, 2
.byte 29, 20, BLOCK, 10


.byte  1, 15, BLOCK, 5
.byte  6, 15, BLOCK, 6
.byte 28, 15, BLOCK, 6
.byte 34, 15, BLOCK, 2 | VERTICAL

.byte 19, 10, DOT, 2
.byte 19, 2, DOT, 2


.byte 4,7, BLOCK, 8
.byte 4,7, BLOCK, 6 | VERTICAL
.byte 28,7, BLOCK, 11

// door location
.byte 36
.byte 4

// no enemies

// player start pos
.byte 3,16


// ------------------------------------------------------------ //

level2data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 15
// enemy count
.byte 0

// line data
// col, row, type, length | orientation

.byte 19, 8, DOT, 2
.byte 17,9, CRUMBLE, 6

.byte 10, 12, CRUMBLE, 5
.byte 26, 12, CRUMBLE, 5

.byte  3, 15, DOT, 2
.byte  1, 16, CRUMBLE, 5

.byte  35, 15, DOT, 2
.byte 34, 16, CRUMBLE, 5

.byte 1,6, BLOCK, 5
.byte 34,6, BLOCK, 5

.byte 8, 19, CRUMBLE, 7
.byte 25, 19, CRUMBLE, 7

.byte 19, 20, DOT, 2
.byte 18, 21, CRUMBLE, 4

.byte 1,23, SPIKE_UP, 38

// door location
.byte 36
.byte 3

// no enemies

// player start pos
.byte 3,4




// ------------------------------------------------------------ //

level3data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 10
// enemy count
.byte 2

// line data
// col, row, type, length | orientation

.byte 8,6, DOT,4
.byte 20,6, SPIKE_UP,4
.byte 1,7, BLOCK, 34
.byte 5,12, BLOCK, 34

.byte 17,17, DOT, 12
.byte 14,18, BLOCK, 18
.byte 14, 19, SPIKE_DOWN, 18

.byte 1,23, SPIKE_UP, 18
.byte 27,23, SPIKE_UP, 12

.byte 38, 13, SPIKE_RIGHT, 10 | VERTICAL


// door location
.byte 22
.byte 21

// 2 enemies
.byte 5,10
.byte 30,10

// player start pos
.byte 3,4




// ------------------------------------------------------------ //

level4data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 18
// enemy count
.byte 1

// line data
// col, row, type, length  | orientation

.byte 14,23, SPIKE_UP,13
.byte 1,20, BLOCK, 33
.byte 34,14, BLOCK, 7 | VERTICAL


.byte 38,19,DOT,1
.byte 35,17,DOT,1
.byte 38,15,DOT,1

.byte 23,14,BLOCK,11
.byte 23,13,SPIKE_UP,11


.byte 16,14,TILE_UP, 3
.byte 16,15,BLOCK,3


.byte 9,16, TILE_UP, 3
.byte 9,17,BLOCK,3


.byte 1,11, TILE_UP, 3
.byte 1,12,BLOCK,3


.byte 14,5,BLOCK,21
.byte 20,4, DOT, 4
.byte 26,4, SPIKE_UP, 4

.byte 38,8,DOT,4 | VERTICAL


// door location
.byte 27
.byte 17

// 1 enemy
.byte 5,10

// player start pos
.byte 2,22



// ------------------------------------------------------------ //

level5data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 10
// enemy count
.byte 0

// line data
// col, row, type, length  | orientation


.byte 1,5,BLOCK,17
.byte 18,5,CRUMBLE,4
.byte 22,5, BLOCK,17

.byte 13,10,SPIKE_UP,14
.byte 13,11,BLOCK,14

.byte 18,15,DOT,4


.byte 1, 21, TILE_BLANK_RED, 8
.byte 31, 21, TILE_BLANK_GREEN,8

.byte 7,23,TILE_SWITCH_UP_GREEN, 1
.byte 32,23,TILE_SWITCH_UP_RED, 1
// door location
.byte 19
.byte 21


// player start pos
.byte 2,3




// ------------------------------------------------------------ //

level6data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 15
// enemy count
.byte 3

// line data
// col, row, type, length  | orientation

.byte 1,5,BLOCK,34
.byte 34,5,TILE_BLOCK_RED,5
.byte 32,4,TILE_SWITCH_UP_GREEN,1

.byte 12,4,SPIKE_UP,12
.byte 0,2,TILE_EMITTER_RIGHT,1

.byte 5,9,BLOCK,34
.byte 0,8,TILE_EMITTER_RIGHT,1

.byte 1,15,SPIKE_UP,10
.byte 1,16,BLOCK,10
.byte 17,15,DOT,16
.byte 12,16,BLOCK,23

.byte 15,12,TILE_BLOCK_RED,10
.byte 25,12,BLOCK,10

.byte 1,23,SPIKE_UP,14
.byte 25,23,SPIKE_UP,14
// door location
.byte 19
.byte 21

// enemies
.byte 18,10
.byte 22,10
.byte 26,10

// player start pos
.byte 2,3



// ------------------------------------------------------------ //

level7data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 18
// enemy count
.byte 1

// line data
// col, row, type, length  | orientation

.byte 1,23,SPIKE_UP,38

.byte 15,4,TILE_SWITCH_UP_RED,1
.byte 19,4,TILE_SWITCH_UP_GREEN,1
.byte 23,4,TILE_SWITCH_UP_BLUE,1
.byte 14,5,BLOCK,11

.byte 18,13,BLOCK,4

.byte 30,11,DOT,2
.byte 29,12,TILE_BLANK_RED,4

.byte 35,16,DOT,2
.byte 34,17,TILE_BLANK_GREEN,4


.byte 28,19,DOT,2
.byte 27,20,TILE_BLANK_BLUE,4


.byte 10,19,DOT,2
.byte 9,20,TILE_BLANK_GREEN,4

.byte 3,16,DOT,2
.byte 2,17,TILE_BLANK_RED,4


.byte 8,11,DOT,2
.byte 7,12,TILE_BLANK_GREEN,4


// door location
.byte 18
.byte 10

// enemies
.byte 20,2

// player start pos
.byte 21,9



// ------------------------------------------------------------ //

level8data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 18

// enemy count
.byte 1

// line data
// col, row, type, length  | orientation

.byte 1,23,SPIKE_UP,38
.byte 1,4,BLOCK,38


.byte 12,5,TILE_EMITTER_DOWN,1
.byte 18,5,TILE_EMITTER_DOWN,1
.byte 24,5,TILE_EMITTER_DOWN,1
.byte 30,5,TILE_EMITTER_DOWN,1

.byte 37,3,TILE_SWITCH_DOWN_RED,1
.byte 3,2,TILE_BLOCK_RED, 2 | VERTICAL

.byte 4,7,TILE_SWITCH_UP_BLUE,1
.byte 1,8,BLOCK,6
.byte 7,8,TILE_BLANK_BLUE,28
.byte 39,11,TILE_EMITTER_LEFT,1
.byte 5,12,TILE_BLANK_BLUE,34

.byte 34,15,TILE_EMITTER_LEFT,1
.byte 1,16,TILE_BLANK_BLUE,34


.byte 10,17,DOT,5
.byte 20,19,DOT,5
.byte 1,20,TILE_BLANK_BLUE,38

// door location
.byte 2
.byte 17

// enemies
.byte 2,2

// player start pos
.byte 2,5



// ------------------------------------------------------------ //

level9data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 34

// enemy count
.byte 1

// line data
// col, row, type, length  | orientation

//.byte 10, 23, BLOCK, 20
.byte 14, 23, DOT, 2

.byte 20, 2, TILE_BLOCK_GREEN, 17 | VERTICAL
.byte 20, 18, BLOCK, 5 | VERTICAL
.byte 1,18, BLOCK, 5
.byte 2,17, TILE_SWITCH_UP_RED, 1

.byte 34,18, BLOCK,5
.byte 26,17, TILE_SWITCH_DOWN_GREEN, 1
.byte 21,18, TILE_BLANK_RED, 13
.byte 19,1, TILE_EMITTER_DOWN, 1
.byte 20,19, TILE_EMITTER_RIGHT, 1

.byte 15, 7, TILE_BLOCK_GREEN, 11 | VERTICAL
.byte 12, 18, TILE_BLOCK_GREEN, 4
.byte 6, 18, TILE_BLOCK, 5
.byte 9, 17, TILE_SWITCH_DOWN_GREEN, 1
.byte 1, 11, TILE_BLOCK_GREEN, 10

.byte 1,9, TILE_BLOCK_GREEN, 2
.byte 2,10, TILE_BLOCK_GREEN, 1
.byte 1,10, DOT, 1

.byte 27,1, TILE_EMITTER_DOWN, 1
.byte 31,1, TILE_EMITTER_DOWN, 1
.byte 35,1, TILE_EMITTER_DOWN, 1
.byte 26,13, DOT, 6

.byte 21,14, BLOCK, 13
.byte 20,21, TILE_BLANK_RED, 3 | VERTICAL

//.byte 37,17, TILE_UP, 1

.byte 34,10, SPIKE_DOWN, 5
.byte 34,11, TILE_BLOCK_GREEN, 5
.byte 26,9, TILE_BLOCK, 15 
.byte 36,8, DOT, 3
.byte 28,5, DOT, 3
.byte 32,5,DOT, 3
.byte 21,2, TILE_BLOCK, 12 | VERTICAL
.byte 26,4, TILE_BLANK_RED, 12
.byte 22,9, TILE_BLOCK_GREEN, 4 
.byte 30,23, TILE_UP, 3

// door location
.byte 24
.byte 21

// enemies
.byte 3,9

// player start pos
.byte 5,20


levels:
.byte <level0data
.byte >level0data

.byte <level1data
.byte >level1data


.byte <level3data
.byte >level3data

.byte <level4data
.byte >level4data

.byte <level2data
.byte >level2data


.byte <level5data
.byte >level5data

.byte <level6data
.byte >level6data

.byte <level7data
.byte >level7data

.byte <level8data
.byte >level8data

.byte <level9data
.byte >level9data

