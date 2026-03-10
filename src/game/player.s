.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import QueueHudRefresh
.import CanPlayerMove

.export InitPlayerForNewGame
.export UpdatePlayerMovement
.export TickPlayerBlink

.segment "CODE"

.proc InitPlayerForNewGame
    lda #120
    sta player_x
    lda #120
    sta player_y
    lda #DIR_DOWN
    sta player_facing
    lda #PLAYER_MAX_HP
    sta player_hp
    lda #0
    sta player_iframes
    sta player_attack_timer
    sta player_anim_frame
    sta player_anim_timer
    sta player_blink_phase
    sta player_move_dir
    sta sword_hit_mask
    rts
.endproc

.proc UpdatePlayerMovement
    lda #DIR_NONE
    sta player_move_dir

    lda player_attack_timer
    bne done

    lda pad_current
    and #PAD_UP
    bne choose_up
    lda pad_current
    and #PAD_DOWN
    bne choose_down
    lda pad_current
    and #PAD_LEFT
    bne choose_left
    lda pad_current
    and #PAD_RIGHT
    bne choose_right
    rts

choose_up:
    lda #DIR_UP
    bne choose_done
choose_down:
    lda #DIR_DOWN
    bne choose_done
choose_left:
    lda #DIR_LEFT
    bne choose_done
choose_right:
    lda #DIR_RIGHT
choose_done:
    sta player_move_dir
    sta player_facing
    jsr CanPlayerMove
    bcs blocked
    lda player_move_dir
    cmp #DIR_UP
    bne :+
    dec player_y
    jmp moved
:
    cmp #DIR_DOWN
    bne :+
    inc player_y
    jmp moved
:
    cmp #DIR_LEFT
    bne :+
    dec player_x
    jmp moved
:
    inc player_x
moved:
    inc player_anim_timer
    lda player_anim_timer
    cmp #8
    bcc done
    lda #0
    sta player_anim_timer
    lda player_anim_frame
    eor #1
    sta player_anim_frame
done:
    rts
blocked:
    rts
.endproc

.proc TickPlayerBlink
    lda player_iframes
    beq done
    dec player_iframes
    lda frame_counter_lo
    and #$04
    sta player_blink_phase
done:
    rts
.endproc
