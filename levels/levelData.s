// data making up each of the levels


.const LEVEL_COUNT    = 18


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
.byte 4,20,0


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
.byte 3,16,0




// -------------------------------------------//


level1cdata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 6
// enemy count
.byte 0

.byte 9, 21, CRUMBLE, 3
.byte 17, 18, CRUMBLE, 3
.byte 25, 15, CRUMBLE, 3
.byte 33, 12, CRUMBLE, 3

.byte 1, 6, CRUMBLE, 32
.byte 5, 5, DOT, 18
// door location
.byte 2
.byte 3

// no enemies

// player start pos
.byte 3,16,0


// -------------------------------------------//


level1adata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 43
// enemy count
.byte 1

// line data
// col, row, type, length | orientation
.byte 20,6,BLOCK, 18 | VERTICAL


.byte 1,12, SPIKE_LEFT, 12 |VERTICAL
.byte 19, 15, SPIKE_RIGHT, 9|VERTICAL
.byte 5, 23, TILE_UP, 1
.byte  10, 17, CRUMBLE, 4

.byte 19,13,DOT,1
.byte  17, 14, CRUMBLE, 3

.byte 1,4,DOT,5 | VERTICAL
.byte  1, 11, BLOCK, 1
.byte  1, 10, TILE_UP, 1

.byte  11,5,BLOCK, 10
.byte 18,4,DOT,2
.byte  20,2,CRUMBLE, 3 | VERTICAL

.byte 24,2, BLOCK, 19 | VERTICAL

.byte 21,15, SPIKE_LEFT, 2|VERTICAL
.byte 23,19,SPIKE_RIGHT, 2 |VERTICAL
.byte 21,2,SPIKE_DOWN, 3
.byte 23,5, DOT, 3 | VERTICAL
.byte 23,10, SPIKE_RIGHT,2 |VERTICAL
//.byte 23,11,BLOCK,1
//.byte 21, 23, TILE_RIGHT, 1
//.byte 24, 23, DOT, 2
.byte 21, 23, TILE_FUNNEL_RIGHT, 6

.byte 28,23,TILE_UP,1
.byte 28,20,DOT,2|VERTICAL
.byte 29, 7,BLOCK, 17 | VERTICAL
.byte 29, 2, SPIKE_DOWN, 10
.byte 28,18,TILE_LEFT,1

.byte 25,20,BLOCK,1
.byte 25,19,TILE_UP,1
.byte 25,14,DOT,4|VERTICAL


.byte 28,14,SPIKE_RIGHT,1|VERTICAL
.byte 25,10,SPIKE_LEFT,1|VERTICAL


.byte 29,6,SPIKE_UP,8
.byte 30,7,BLOCK,7
.byte 37,7,CRUMBLE,2

//.byte 38,10,TILE_LEFT,1
.byte 34,10,TILE_FUNNEL_LEFT,5


.byte 30, 10, DOT, 1
.byte 30,11,CRUMBLE,2

.byte 32,11,BLOCK,7

//.byte 30, 14, TILE_RIGHT, 1
.byte 32, 14, SPIKE_UP, 2
.byte 30,15,BLOCK,7

.byte 34,14,SPIKE_UP, 3
.byte 38, 14, DOT, 1
.byte 37, 15, CRUMBLE,2

.byte 32,19,BLOCK,7


// door location
.byte 36
.byte 21

// 2 enemies
//.byte  33, 13, 1
.byte  33, 17, 1

// player start pos
.byte 3,16,0

// ------------------------------------------------------------ //



// -------------------------------------------//


level1bdata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 41
// enemy count
.byte 2

// line data

.byte 10, 2, DOT, 5
.byte 8, 4, SPIKE_UP, 9

.byte 29, 2, DOT, 5
.byte 27, 4, SPIKE_UP, 9
.byte 1, 5, BLOCK, 35
.byte 35, 5, BLOCK, 16 | VERTICAL

.byte 36, 5, SPIKE_LEFT, 4 | VERTICAL
.byte 38, 6, DOT, 2 | VERTICAL

.byte 38, 10, SPIKE_RIGHT, 4 | VERTICAL
.byte 36, 11, DOT, 2 | VERTICAL

.byte 36, 15, SPIKE_LEFT, 4 | VERTICAL
.byte 38, 16, DOT, 2 | VERTICAL


.byte 35, 23, BLOCK, 1

.byte 1, 22, TILE_UP, 1
.byte 1, 18, DOT, 1

.byte 1, 23, TILE_EMITTER_RIGHT, 1


.byte 4, 21, TILE_FUNNEL_LEFT, 8
//.byte 1, 21, TILE_UP, 1



.byte 1, 15, TILE_RIGHT, 1
//.byte 1, 19, DOT, 2 | VERTICAL



.byte 3, 10, TILE_LEFT, 1
//.byte 3, 14, DOT, 2 | VERTICAL
.byte 3, 16, TILE_UP, 1
.byte 3, 17, BLOCK, 1


//.byte 1, 9, DOT, 2 | VERTICAL
.byte 1, 11, TILE_UP, 1
.byte 1, 12, BLOCK, 1

.byte 4, 6, DOT, 6

.byte 34, 10, DOT, 6 | VERTICAL

.byte 26, 21, DOT, 2
.byte 17, 21, DOT, 2
.byte 5, 20, BLOCK, 30
.byte 4, 10, BLOCK, 11 | VERTICAL


.byte 4, 9, BLOCK, 27
.byte 31, 9, BLOCK, 8 | VERTICAL
.byte 8, 16, BLOCK, 24
.byte 31, 19, TILE_EMITTER_LEFT, 1

.byte 8, 13, BLOCK, 4 | VERTICAL
.byte 9, 13, BLOCK, 19

.byte 8, 12, TILE_EMITTER_RIGHT, 1
.byte 16, 9, TILE_EMITTER_DOWN, 1
.byte 24, 9, TILE_EMITTER_DOWN, 1

.byte 9, 14, TILE_RIGHT, 2 | VERTICAL
.byte 16, 14, DOT, 12
.byte 16, 15, DOT, 12
// door location
.byte 29
.byte 13

// 2 enemies
.byte 4, 7, 1
.byte 31, 7, 0

// player start pos
.byte 1,2,0

// ------------------------------------------------
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
.byte 37
.byte 3

// no enemies

// player start pos
.byte 3,4,0



// ------------------------------------------------------------ //

level2adata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 34
// enemy count
.byte 0

// line data
// col, row, type, length | orientation

.byte 15, 17, BLOCK, 3
.byte 21, 17, BLOCK, 3

.byte 12, 19, SPIKE_UP, 15
.byte 11, 20, BLOCK, 17

.byte 26, 13, SPIKE_RIGHT, 6 | VERTICAL
.byte 27, 13, BLOCK, 7 | VERTICAL


.byte 11, 6, BLOCK, 17
.byte 12, 7, SPIKE_DOWN, 15 
.byte 11, 7, BLOCK, 13 | VERTICAL
.byte 12, 8, SPIKE_LEFT, 11 | VERTICAL


.byte 26, 8, SPIKE_RIGHT, 1 | VERTICAL
.byte 27, 7, BLOCK, 2 | VERTICAL

.byte 22, 9, DOT, 4 | VERTICAL
.byte 22, 16, TILE_UP, 1

.byte 30, 7, BLOCK, 17 | VERTICAL
.byte 28, 6, BLOCK, 3


.byte 6, 23, TILE_UP, 1
.byte 1, 17, BLOCK, 2


.byte 6, 13, TILE_UP, 1
.byte 5, 14, BLOCK, 3

.byte 20, 5, DOT, 3
.byte 1, 5, TILE_RIGHT, 1
.byte 2, 5, DOT, 1
.byte 1, 6, BLOCK, 2


.byte 27, 5, TILE_UP, 1

.byte 36, 6, BLOCK, 16 | VERTICAL
.byte 37, 7, SPIKE_LEFT, 14 | VERTICAL
.byte 38, 10, DOT, 10 | VERTICAL
.byte 30, 5, SPIKE_UP, 7
.byte 31, 6, BLOCK, 5


.byte 31, 15, TILE_UP, 1
.byte 31, 16, BLOCK, 1


.byte 35, 11, SPIKE_RIGHT, 4 | VERTICAL
.byte 33, 10, BLOCK, 3

// door location
.byte 34
.byte 7

// no enemies

// player start pos
.byte 16,15,0



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

// 2 enemies: x,y,direction 0 = left, 1 = right
.byte 5,10,0
.byte 30,10,0

// player start pos
.byte 3,4,0




// ------------------------------------------------------------ //

level3adata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 31
// enemy count
.byte 0

// line data
// col, row, type, length | orientation


.byte 4,2, BLOCK, 6 | VERTICAL
.byte 4,11, BLOCK, 5 | VERTICAL

.byte 2,7, DOT, 5 | VERTICAL
.byte 2,14,TILE_UP,1
.byte 1,15,BLOCK, 3

.byte 7,4, BLOCK, 4 | VERTICAL
.byte 7,11, BLOCK, 5 | VERTICAL
.byte 7,10, SPIKE_UP, 3
.byte 14,10,TILE_UP,2
.byte 8,11,BLOCK,8


.byte 27,7,TILE_UP,3
.byte 20,8, BLOCK, 19
.byte 20,9,BLOCK,4 | VERTICAL
//.byte 32,2,SPIKE_RIGHT,6 | VERTICAL

.byte 33,2,TILE_LEFT, 1 | VERTICAL
.byte 34,2,BLOCK,6 | VERTICAL


.byte 10,3,TILE_SWITCH_UP_RED, 1
.byte 8,4, BLOCK, 14
.byte 22,4,SPIKE_LEFT, 1

//.byte 17,17, DOT, 12
.byte 18,19,TILE_UP,2


//.byte 12,19,DOT, 5

//.byte 18,19,TILE_UP,1

//.byte 8,14,TILE_RIGHT,1
.byte 10,14,TILE_SWITCH_DOWN_GREEN,1
.byte 8, 15, TILE_BLOCK,4

.byte 16,11,TILE_BLANK_RED,4
.byte 20,13,TILE_BLANK_RED,7|VERTICAL
.byte 10,20,TILE_BLANK_RED,10

.byte 24,19, DOT,4
.byte 20,20,TILE_BLOCK_GREEN,10
.byte 1,23, SPIKE_UP, 38
//.byte 27,23, SPIKE_UP, 12

.byte 38, 9, SPIKE_RIGHT, 14 | VERTICAL

.byte 20,12,BLOCK,5


.byte 34,16,TILE_UP,2
.byte 34,17,BLOCK,2
// door location
.byte 21
.byte 9

// 2 enemies: x,y,direction 0 = left, 1 = right

// player start pos
.byte 2,3,0

// ------------------------------------------------------------ //

level4adata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 16
// enemy count
.byte 0

// line data
// col, row, type, length  | orientation
.byte 4, 23, TILE_UP, 1
.byte 8, 23, SPIKE_UP, 31
.byte 14,21, CRUMBLE,5
.byte 22,19, CRUMBLE, 5
.byte 28,13, BLOCK, 6
.byte 27,13,SPIKE_RIGHT,1

.byte 31,14,DOT,2



.byte 34,4,SPIKE_UP, 1
.byte 34,5,BLOCK, 9 | VERTICAL

.byte 31,8,TILE_UP,1
.byte 29,9,BLOCK, 5
.byte 28,9,SPIKE_RIGHT,1



.byte 1,4, DOT, 1
.byte 1,5,CRUMBLE,3


.byte 17,3, DOT, 3
.byte 16,4,CRUMBLE,5




// door location
.byte 32
.byte 10


// player start pos
.byte 1,22,0




// ------------------------------------------------------------ //

level4bdata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 31
// enemy count
.byte 0

// line data
// col, row, type, length  | orientation

.byte 15,20, DOT, 3
.byte 14,21, TILE_BLANK_RED,5

.byte 36,20, DOT,1
.byte 34,21, TILE_BLOCK_GREEN, 5
.byte 7,23, TILE_SWITCH_UP_RED, 1

.byte 25,23, TILE_SWITCH_DOWN_GREEN,1


.byte 28,15,TILE_UP,1

.byte 23,16,SPIKE_RIGHT, 1
.byte 24,16,BLOCK, 10
.byte 24,17, SPIKE_DOWN, 10
.byte 34,16,SPIKE_LEFT, 1


.byte 3, 14, TILE_SWITCH_DOWN_GREEN, 1
.byte 8, 14, TILE_SWITCH_UP_RED, 1
.byte 1,15,BLOCK, 15
.byte 16,15, SPIKE_LEFT, 1
.byte 1,16,SPIKE_DOWN,15


.byte 14,8,TILE_SWITCH_UP_RED, 1
.byte 1,9, TILE_BLOCK_GREEN, 10
.byte 11,9,BLOCK, 12


.byte 36,11,TILE_BLOCK_GREEN,3
.byte 38,10,DOT,1




.byte 28, 4, DOT, 1

.byte 25,5,TILE_SPIKE_RIGHT,1
.byte 26, 5, TILE_BLOCK, 5
.byte 31,5,TILE_SPIKE_LEFT,1

.byte 18, 2, TILE_DOT, 3

.byte 6, 3, TILE_SWITCH_UP_RED, 1
.byte 5, 4, TILE_BLOCK, 9
.byte 14, 4, TILE_SPIKE_LEFT, 1
.byte 4, 4, TILE_SPIKE_RIGHT, 1

.byte 1, 2, DOT, 1


// door location
.byte 1
.byte 6


// player start pos
.byte 1,22,0



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

.byte 14,23, SPIKE_UP,12
.byte 1,20, BLOCK, 33
.byte 34,14, BLOCK, 7 | VERTICAL


.byte 38,19,DOT,1
.byte 35,17,DOT,1
.byte 38,14,DOT,1

.byte 23,14,BLOCK,11
.byte 23,13,SPIKE_UP,11


.byte 18,14,TILE_UP, 1
.byte 18,15,BLOCK,1


.byte 10,16, TILE_UP, 1
.byte 10,17,BLOCK,1


.byte 1,11, TILE_UP, 1
.byte 1,12,BLOCK,1


.byte 14,5,CRUMBLE,21
.byte 20,4, DOT, 4
.byte 26,4, SPIKE_UP, 4

.byte 38,8,DOT,4 | VERTICAL


// door location
.byte 27
.byte 17

// 1 enemy, x, y, direction
.byte 5,10,0

// player start pos
.byte 2,22,0



// ------------------------------------------------------------ //

level5data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 14
// enemy count
.byte 0

// line data
// col, row, type, length  | orientation


.byte 1,5,BLOCK,17
.byte 18,5,CRUMBLE,4
.byte 22,5, BLOCK,17

.byte 13,10,SPIKE_UP,14
.byte 13,11,BLOCK,14
.byte 13,11,TILE_EMITTER_DOWN,1
.byte 26,11,TILE_EMITTER_DOWN,1

.byte 19,15,DOT,2
.byte 19,17,SPIKE_UP,2
.byte 19,18,BLOCK,2


.byte 1, 21, TILE_BLANK_RED, 8
.byte 31, 21, TILE_BLANK_GREEN,8

.byte 7,23,TILE_SWITCH_UP_GREEN, 1
.byte 32,23,TILE_SWITCH_UP_RED, 1
// door location
.byte 19
.byte 21


// player start pos
.byte 2,3,0




// ------------------------------------------------------------ //

level5adata:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 43
// enemy count
.byte 1

// line data
// col, row, type, length  | orientation


.byte 1,5,BLOCK,5
.byte 6,5,TILE_BLOCK_RED,5
.byte 11,5, BLOCK,18
.byte 29,5, TILE_BLOCK_GREEN,5
.byte 34,5, BLOCK, 5


.byte 38, 6, TILE_LEFT, 1
.byte 11, 6, BLOCK, 4 | VERTICAL
.byte 3, 9, SPIKE_UP, 8
.byte 3, 10, BLOCK, 9
.byte 3, 12, DOT, 5
.byte 1, 13, BLOCK, 8



.byte 11, 11, BLOCK, 11 | VERTICAL
.byte 6, 16, BLOCK, 6

.byte 0, 14, TILE_EMITTER_RIGHT, 2 | VERTICAL
.byte 2, 14, TILE_BLANK_RED, 2 | VERTICAL
.byte 1, 16, BLOCK, 2


.byte 4, 20, TILE_UP, 1
.byte 4, 21, BLOCK, 1

.byte 10, 19, DOT, 2 | VERTICAL




// -

// middle block
.byte 17,9,TILE_SWITCH_UP_GREEN, 1
.byte 15,10,BLOCK,8
.byte 15,9,BLOCK, 1
.byte 20,9,TILE_SWITCH_UP_RED, 1
.byte 22,9,BLOCK, 1

//.byte 13,11,TILE_EMITTER_DOWN,1
//.byte 26,11,TILE_EMITTER_DOWN,1


.byte 34, 8, DOT, 2
.byte 23, 9, BLOCK, 16
.byte 30,8,SPIKE_UP,3


.byte 12, 13, TILE_BLOCK_GREEN,13
.byte 25, 13, BLOCK, 10
.byte 25, 12, TILE_BLOCK_GREEN, 1|VERTICAL
.byte 32,10, DOT, 2
.byte 39, 12, TILE_EMITTER_LEFT, 1

//.byte 19,15,DOT,2
.byte 12,16,SPIKE_UP,17
.byte 12,17,BLOCK,17
.byte 34,16, DOT, 2
.byte 32, 17, BLOCK, 7


.byte 28, 18, BLOCK, 4 | VERTICAL
.byte 29, 21, BLOCK, 6

.byte 39, 20, TILE_EMITTER_LEFT, 1


.byte 14, 23, TILE_UP, 1

.byte 25, 23, TILE_UP, 1
.byte 15, 23, SPIKE_UP, 10

.byte 16, 18, DOT, 8



// door location
.byte 19
.byte 2

// enemy location
.byte 18, 7, 0

// player start pos
.byte 19,3,0


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

// enemies: x, y, direction
.byte 18,10,0
.byte 22,10,0
.byte 26,10,0

// player start pos
.byte 2,3,0



// ------------------------------------------------------------ //

level7data:
// sprite palette
.byte 0
// tile palette
.byte 0
// line count
.byte 19
// enemy count
.byte 1

// line data
// col, row, type, length  | orientation

.byte 1,23,SPIKE_UP,38

.byte 15,12,TILE_SWITCH_UP_RED,1
.byte 19,12,TILE_SWITCH_UP_GREEN,1
.byte 23,12,TILE_SWITCH_UP_BLUE,1
.byte 14,13,BLOCK,11

.byte 18,7,BLOCK,4
.byte 18,19,BLOCK,4


.byte 36,16,DOT,2
.byte 35,17,TILE_BLANK_GREEN,4


.byte 28,19,DOT,2
.byte 27,20,TILE_BLANK_BLUE,4


.byte 10,19,DOT,2
.byte 9,20,TILE_BLANK_GREEN,4

.byte 2,16,DOT,2
.byte 1,17,TILE_BLANK_RED,4


.byte 30,10,DOT,2
.byte 28,11,TILE_BLANK_RED,6

.byte 8,10,DOT,2
.byte 6,11,TILE_BLANK_GREEN,6


// door location
.byte 18
.byte 4

// enemies
.byte 20,8,1

// player start pos
.byte 21,4,0



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


.byte 12,4,TILE_EMITTER_DOWN,1
.byte 18,4,TILE_EMITTER_DOWN,1
.byte 24,4,TILE_EMITTER_DOWN,1
.byte 30,4,TILE_EMITTER_DOWN,1

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
.byte 2,2,0

// player start pos
.byte 2,5,0



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
.byte 10, 23, DOT, 2

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
.byte 31,23, TILE_UP, 1

// door location
.byte 24
.byte 21

// enemies
.byte 3,9,0

// player start pos
.byte 5,20,0


levels:
.byte <level0data
.byte >level0data

// jump tutorial
.byte <level1data
.byte >level1data


// crumble tutorial
.byte <level1cdata
.byte >level1cdata


// enemy tutorial
.byte <level3data
.byte >level3data


// jump box
.byte <level2adata
.byte >level2adata


// wall jump + jump tiles
.byte <level4data
.byte >level4data


// buttons
.byte <level4bdata
.byte >level4bdata

// jump tile 
.byte <level4adata
.byte >level4adata


// fall through crumble then 2 buttons
.byte <level5data
.byte >level5data


// all crumble
.byte <level2data
.byte >level2data



// start with jump + buttons
.byte <level3adata
.byte >level3adata


// fall through crumble then 2 buttons
.byte <level5adata
.byte >level5adata

// enemies fall down
.byte <level6data
.byte >level6data


.byte <level9data
.byte >level9data


// jump and crumble
.byte <level1adata
.byte >level1adata


.byte <level8data
.byte >level8data

// enemy controlled switches
.byte <level7data
.byte >level7data


// spiral
.byte <level1bdata
.byte >level1bdata



