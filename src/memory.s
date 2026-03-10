.setcpu "6502"
.include "constants.inc"

.exportzp frame_ready
.exportzp game_state
.exportzp current_room
.exportzp next_room
.exportzp transition_entry
.exportzp pending_state
.exportzp pad_current
.exportzp pad_previous
.exportzp pad_pressed
.exportzp pad_released
.exportzp frame_counter_lo
.exportzp frame_counter_hi
.exportzp state_timer
.exportzp transition_timer
.exportzp player_x
.exportzp player_y
.exportzp player_facing
.exportzp player_hp
.exportzp player_iframes
.exportzp player_attack_timer
.exportzp player_anim_frame
.exportzp player_anim_timer
.exportzp player_blink_phase
.exportzp player_move_dir
.exportzp temp0
.exportzp temp1
.exportzp temp2
.exportzp temp3
.exportzp temp4
.exportzp temp5
.exportzp temp6
.exportzp temp7
.exportzp ptr0
.exportzp ptr1
.exportzp ptr2
.exportzp rng_lo
.exportzp rng_hi
.exportzp sword_hit_mask

.export oam_shadow
.export ppu_queue
.export audio_state
.export room_dead_flags
.export player_state
.export enemy_table
.export collision_map
.export transition_state

.segment "ZEROPAGE"
frame_ready:         .res 1
game_state:          .res 1
current_room:        .res 1
next_room:           .res 1
transition_entry:    .res 1
pending_state:       .res 1
pad_current:         .res 1
pad_previous:        .res 1
pad_pressed:         .res 1
pad_released:        .res 1
frame_counter_lo:    .res 1
frame_counter_hi:    .res 1
state_timer:         .res 1
transition_timer:    .res 1
player_x:            .res 1
player_y:            .res 1
player_facing:       .res 1
player_hp:           .res 1
player_iframes:      .res 1
player_attack_timer: .res 1
player_anim_frame:   .res 1
player_anim_timer:   .res 1
player_blink_phase:  .res 1
player_move_dir:     .res 1
temp0:               .res 1
temp1:               .res 1
temp2:               .res 1
temp3:               .res 1
temp4:               .res 1
temp5:               .res 1
temp6:               .res 1
temp7:               .res 1
ptr0:                .res 2
ptr1:                .res 2
ptr2:                .res 2
rng_lo:              .res 1
rng_hi:              .res 1
sword_hit_mask:      .res 1

.segment "OAM"
oam_shadow:          .res 256

.segment "QUEUE"
ppu_queue:           .res 64

.segment "AUDIORAM"
audio_state:         .res 128

.segment "BSS"
room_dead_flags:     .res 4
player_state:        .res 16
enemy_table:         .res 32
transition_state:    .res 32
collision_map:       .res 224
