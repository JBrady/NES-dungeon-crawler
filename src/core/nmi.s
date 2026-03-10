.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import FlushPpuQueue
.import AudioUpdate

.export NMI

.segment "CODE"

.proc NMI
    pha
    txa
    pha
    tya
    pha

    lda #1
    sta frame_ready

    lda #0
    sta OAMADDR
    lda #>oam_shadow
    sta OAMDMA

    jsr AudioUpdate
    jsr FlushPpuQueue

    pla
    tay
    pla
    tax
    pla
    rti
.endproc
