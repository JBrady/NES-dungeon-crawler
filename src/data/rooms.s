.setcpu "6502"

.export room_exit_masks
.export room_required_dead_masks
.export room_screen_ptrs
.export room_collision_ptrs
.export room_spawn_ptrs

.segment "RODATA"
.include "rooms.inc"
