.setcpu "6502"
.include "constants.inc"

.export player_tile_pairs
.export sword_tile_pairs
.export enemy_tile_pairs
.export enemy_palette_attrs

.segment "RODATA"

player_tile_pairs:
.byte 1, 3
.byte 5, 7
.byte 9, 11
.byte 13, 15
.byte 17, 19
.byte 21, 23
.byte 25, 27
.byte 29, 31

sword_tile_pairs:
.byte 49, 51, 53, 55

enemy_tile_pairs:
.byte 33, 35
.byte 37, 39
.byte 41, 43
.byte 45, 47

enemy_palette_attrs:
.byte SPR_ATTR_PAL1
.byte SPR_ATTR_PAL1
.byte SPR_ATTR_PAL1
.byte SPR_ATTR_PAL1
