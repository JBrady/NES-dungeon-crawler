.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import room_exit_masks
.import LoadCurrentRoom

.export CheckDoorTransition
.export UpdateRoomTransition

.segment "CODE"

.proc CheckDoorTransition
    lda player_move_dir
    cmp #DIR_NONE
    bne :+
    jmp no_transition
:

    lda player_x
    clc
    adc #PLAYER_HITBOX_OFFSET_X
    sta temp0
    lda player_y
    clc
    adc #PLAYER_HITBOX_OFFSET_Y
    sta temp1

    ldx current_room
    lda room_exit_masks,x
    sta temp2

    lda player_move_dir
    cmp #DIR_UP
    bne check_down
    lda temp2
    and #EXIT_NORTH
    bne :+
    jmp no_transition
:
    lda temp0
    cmp #112
    bcs :+
    jmp no_transition
:
    cmp #144
    bcc :+
    jmp no_transition
:
    lda temp1
    cmp #32
    bcc :+
    jmp no_transition
:
    lda #ROOM_0_START
    sta next_room
    lda current_room
    cmp #ROOM_2_SOUTH
    beq from_two
    lda #ROOM_1_EAST
    sta next_room
from_two:
    lda #ENTRY_FROM_SOUTH
    sta transition_entry
    jmp commit
check_down:
    cmp #DIR_DOWN
    bne check_left
    lda temp2
    and #EXIT_SOUTH
    bne :+
    jmp no_transition
:
    lda temp0
    cmp #112
    bcs :+
    jmp no_transition
:
    cmp #144
    bcc :+
    jmp no_transition
:
    lda temp1
    cmp #224
    bcs :+
    jmp no_transition
:
    lda current_room
    cmp #ROOM_0_START
    beq to_two
    lda #ROOM_3_FINAL
    bne store_down
to_two:
    lda #ROOM_2_SOUTH
store_down:
    sta next_room
    lda #ENTRY_FROM_NORTH
    sta transition_entry
    jmp commit
check_left:
    cmp #DIR_LEFT
    bne check_right
    lda temp2
    and #EXIT_WEST
    bne :+
    jmp no_transition
:
    lda temp1
    cmp #112
    bcs :+
    jmp no_transition
:
    cmp #144
    bcc :+
    jmp no_transition
:
    lda temp0
    cmp #32
    bcc :+
    jmp no_transition
:
    lda current_room
    cmp #ROOM_1_EAST
    beq left_to_zero
    lda #ROOM_2_SOUTH
    bne store_left
left_to_zero:
    lda #ROOM_0_START
store_left:
    sta next_room
    lda #ENTRY_FROM_EAST
    sta transition_entry
    jmp commit
check_right:
    lda temp2
    and #EXIT_EAST
    bne :+
    jmp no_transition
:
    lda temp1
    cmp #112
    bcs :+
    jmp no_transition
:
    cmp #144
    bcc :+
    jmp no_transition
:
    lda temp0
    cmp #224
    bcs :+
    jmp no_transition
:
    lda current_room
    cmp #ROOM_0_START
    beq right_to_one
    lda #ROOM_3_FINAL
    bne store_right
right_to_one:
    lda #ROOM_1_EAST
store_right:
    sta next_room
    lda #ENTRY_FROM_WEST
    sta transition_entry
commit:
    lda #STATE_ROOM_TRANSITION
    sta game_state
    sec
    rts
no_transition:
    clc
    rts
.endproc

.proc UpdateRoomTransition
    lda next_room
    sta current_room
    lda transition_entry
    cmp #ENTRY_FROM_NORTH
    bne :+
    lda #120
    sta player_x
    lda #208
    sta player_y
    lda #DIR_UP
    sta player_facing
    jmp load_done
:
    cmp #ENTRY_FROM_SOUTH
    bne :+
    lda #120
    sta player_x
    lda #32
    sta player_y
    lda #DIR_DOWN
    sta player_facing
    jmp load_done
:
    cmp #ENTRY_FROM_WEST
    bne :+
    lda #216
    sta player_x
    lda #120
    sta player_y
    lda #DIR_LEFT
    sta player_facing
    jmp load_done
:
    lda #24
    sta player_x
    lda #120
    sta player_y
    lda #DIR_RIGHT
    sta player_facing
load_done:
    jsr LoadCurrentRoom
    lda #STATE_GAMEPLAY
    sta game_state
    rts
.endproc
