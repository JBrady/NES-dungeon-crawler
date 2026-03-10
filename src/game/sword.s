.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.export UpdateSwordState
.export SwordIsActive

.segment "CODE"

.proc UpdateSwordState
    lda player_attack_timer
    beq maybe_start
    inc player_attack_timer
    lda player_attack_timer
    cmp #SWORD_TOTAL_FRAMES+1
    bcc done
    lda #0
    sta player_attack_timer
    sta sword_hit_mask
done:
    rts
maybe_start:
    lda pad_pressed
    and #PAD_B
    beq done
    lda #1
    sta player_attack_timer
    lda #0
    sta sword_hit_mask
    rts
.endproc

.proc SwordIsActive
    lda player_attack_timer
    cmp #SWORD_ACTIVE_START
    bcc not_active
    cmp #SWORD_ACTIVE_END+1
    bcs not_active
    sec
    rts
not_active:
    clc
    rts
.endproc
