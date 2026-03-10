.setcpu "6502"

.export title_screen_data
.export win_screen_data
.export game_over_screen_data

.segment "RODATA"
.include "screens.inc"
