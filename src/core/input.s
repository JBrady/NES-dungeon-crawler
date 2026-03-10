.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.export ReadController

.segment "CODE"

.proc ReadController
    lda pad_current
    sta pad_previous

    lda #1
    sta JOY1
    lda #0
    sta JOY1

    ldx #8
    lda #0
    sta pad_current
read_loop:
    lda JOY1
    lsr a
    rol pad_current
    dex
    bne read_loop

    lda pad_current
    eor #$ff
    and pad_previous
    sta pad_released

    lda pad_previous
    eor #$ff
    and pad_current
    sta pad_pressed
    rts
.endproc
