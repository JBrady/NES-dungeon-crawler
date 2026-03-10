.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import BuildGameplayOAM

.export HideAllSprites
.export BuildFrameOAM

.segment "CODE"

.proc HideAllSprites
    ldx #0
hide_loop:
    lda #$f8
    sta oam_shadow,x
    inx
    lda #0
    sta oam_shadow,x
    inx
    sta oam_shadow,x
    inx
    sta oam_shadow,x
    inx
    bne hide_loop
    rts
.endproc

.proc BuildFrameOAM
    jsr HideAllSprites
    lda game_state
    cmp #STATE_GAMEPLAY
    bne done
    jsr BuildGameplayOAM
done:
    rts
.endproc
