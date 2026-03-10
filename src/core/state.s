.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import UpdateTitle
.import UpdateGameplay
.import UpdateRoomTransition
.import UpdateWin
.import UpdateGameOver
.import LoadTitleScreen
.import LoadWinScreen
.import LoadGameOverScreen
.import StartNewGame
.import HideAllSprites

.export UpdateState
.export EnterTitle
.export EnterWin
.export EnterGameOver

.segment "CODE"

.proc UpdateState
    lda game_state
    cmp #STATE_TITLE
    beq do_title
    cmp #STATE_GAMEPLAY
    beq do_gameplay
    cmp #STATE_ROOM_TRANSITION
    beq do_transition
    cmp #STATE_WIN
    beq do_win
    jmp UpdateGameOver
do_title:
    jmp UpdateTitle
do_gameplay:
    jmp UpdateGameplay
do_transition:
    jmp UpdateRoomTransition
do_win:
    jmp UpdateWin
.endproc

.proc EnterTitle
    lda #STATE_TITLE
    sta game_state
    lda #TITLE_START_LOCK_FRAMES
    sta state_timer
    lda #0
    sta pending_state
    jsr LoadTitleScreen
    rts
.endproc

.proc EnterWin
    lda #STATE_WIN
    sta game_state
    lda #END_SCREEN_START_LOCK_FRAMES
    sta state_timer
    jsr LoadWinScreen
    rts
.endproc

.proc EnterGameOver
    lda #STATE_GAME_OVER
    sta game_state
    lda #END_SCREEN_START_LOCK_FRAMES
    sta state_timer
    jsr LoadGameOverScreen
    rts
.endproc
