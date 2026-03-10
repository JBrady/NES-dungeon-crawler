.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import InitPlayerForNewGame
.import LoadCurrentRoom

.export StartNewGame

.segment "CODE"

.proc StartNewGame
    lda #0
    sta room_dead_flags+0
    sta room_dead_flags+1
    sta room_dead_flags+2
    sta room_dead_flags+3
    sta pending_state
    lda #ROOM_0_START
    sta current_room
    jsr InitPlayerForNewGame
    jsr LoadCurrentRoom
    lda #STATE_GAMEPLAY
    sta game_state
    rts
.endproc
