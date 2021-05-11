* = $02 "Zeropage" virtual

game_state:               .byte $0
game_state_counter:       .byte $0

// some address pointers to use
address_low:              .byte $0
address_high:             .byte $0
address_low_2:            .byte $0
address_high_2:           .byte $0

address_low_3:            .byte $0
address_high_3:           .byte $0

address_low_4:            .byte $0
address_high_4:           .byte $0

copy_to_low:              .byte $0
copy_to_high:             .byte $0
temp:                     .byte $0
temp1:                    .byte $0
temp2:                    .byte $0
temp3:                    .byte $0
temp4:                    .byte $0

row:                      .byte $0
col:                      .byte $0

// used in actors.s
virtual_sprites_enabled:  .byte $0
virtual_spritex_msb:      .byte $0
sprite_xl:                .byte $0
sprite_xh:                .byte $0
sprite_y:                 .byte $0



actor_y_offset:           .byte $0
actor_x_offset:           .byte $0

// used in player.s
player_button_down:        .byte $0
player_jump_counter:       .byte $0
player_coyote_counter:     .byte $0
player_wall_stick_counter: .byte $0
player_wall_jump_counter:  .byte $0
player_can_boost:          .byte $0
player_boost_counter:      .byte $0
player_touching_door:      .byte $0
blink_timer:               .byte $0
blink_time:                .byte $0


// used in levels.s
level_current:             .byte $0
level_data_low:            .byte $0
level_data_high:           .byte $0
level_line_count:          .byte $0
level_enemy_count:         .byte $0
level_line_color:          .byte $0
level_line_type:           .byte $0
level_line_direction:      .byte $0

door_address_low:          .byte $0
door_address_high:         .byte $0
door_flash_counter:        .byte $0
door_flash_state:          .byte $0

// number of dots to collect
dot_count:                 .byte $0
door_color_address_low:    .byte $0
door_color_address_high:   .byte $0

// used in animatedtiles.s
tile_type:                 .byte $0
animated_tile_time:        .byte $0



// used in collisions.s
collision_switch:          .byte $0
collision_char_register:   .byte $0
collision_sprite_register: .byte $0

// used in switches.s
switch_type:               .byte $0

// use in sound.s
sound_last_channel:        .byte $0


// used in spriteCollisionsasm
sprites_enabled:              .byte 0

sprite_to_check:              .byte 0
sprite_to_check_xl:           .byte 0
sprite_to_check_xh:           .byte 0
sprite_to_check_yl:           .byte 0
sprite_to_check_yh:           .byte 0

sprite_collisions:            .byte 0

sprite_check_xl:                 .byte 0
sprite_check_xh:                 .byte 0
sprite_check_yl:                 .byte 0
sprite_check_yh:                 .byte 0


sprite_check_pixel_x:           .byte 0
sprite_check_pixel_y:           .byte 0


sprite_check_pixel:               .byte 0
sprite_pixel_x:                  .byte 0
sprite_pixel_y:                  .byte 0


sprite_col:                      .byte 0
sprite_row:                      .byte 0
tile_pixel_xl:                   .byte 0
tile_pixel_xh:                   .byte 0
tile_pixel_yl:                   .byte 0
tile_pixel_yh:                   .byte 0

tile_address_low:                .byte 0
tile_address_high:               .byte 0

grid_cell:                       .byte 0
grid_cell_tile:                  .byte 0


sprite_to_tile_low:              .byte 0
sprite_to_tile_high:             .byte 0
sprite_to_tile_col_low:          .byte 0
sprite_to_tile_col_high:         .byte 0
sprite_to_tile_row_low:          .byte 0
sprite_to_tile_row_high:         .byte 0

// used in text.s
text_address_low:                .byte 0
text_address_high:               .byte 0


// used in statusbar
status_address_low:              .byte 0
status_address_high:             .byte 0