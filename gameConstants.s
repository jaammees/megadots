.const GAME_STATE_PLAY        = 0
.const GAME_STATE_DEAD        = 1

// things to tweak

// player constants
.const MAX_PLAYER_SPEED      = 11
.const MAX_DOWN_SPEED        = 7
.const MAX_DOWN_WALL_SPEED   = 5

.const GRAVITY_FORCE         = 2
.const PLAYER_GROUND_FORCE   = 2

// how fast player decelerates on ground with no input
.const PLAYER_GROUND_FORCE_NO_INPUT  = 3

// how fast player decelerates in air with no input
.const PLAYER_AIR_FORCE_NO_INPUT     = 1
.const PLAYER_AIR_FORCE      = 3

.const COYOTE_TIME           = 6

.const WALL_JUMP_SPEED       = 14//17
// time after wall jump player can't control left or right
.const WALL_JUMP_TIME        = 7
.const WALL_STICK_TIME       = 10

.const UP_TILE_SPEED         = 30

.const BOOST_SPEED           = 22 //18
.const BOOST_STEPS           = 11 //12


// enemy constants
.const ENEMY_SPEED           = 2


// emitter tile constants
.const TIME_EMITTER         = 44
.const TIME_EMITTER_ACTIVE  = $06

