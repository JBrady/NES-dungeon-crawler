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

    ; Queued PPUADDR writes disturb the internal scroll latch. Reassert the
    ; fixed-screen gameplay state every NMI so normal movement cannot leak
    ; scroll or peek into adjacent nametables.
    lda #PPUCTRL_NMI_8X16
    sta PPUCTRL
    lda #0
    sta PPUSCROLL
    sta PPUSCROLL

    pla
    tay
    pla
    tax
    pla
    rti
.endproc
