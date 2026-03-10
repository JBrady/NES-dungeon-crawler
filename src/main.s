.setcpu "6502"
.include "constants.inc"
.include "memory.inc"
.include "header.inc"

.import Reset
.import NMI
.import IRQ
.import ReadController
.import UpdateState
.import BuildFrameOAM

.export Main

.segment "CODE"

.proc Main
main_loop:
    lda frame_ready
    beq main_loop
    lda #0
    sta frame_ready

    jsr ReadController
    jsr UpdateState
    jsr BuildFrameOAM

    inc frame_counter_lo
    bne :+
    inc frame_counter_hi
:
    jmp main_loop
.endproc

.segment "VECTORS"
.addr NMI
.addr Reset
.addr IRQ

.segment "CHR"
.incbin "../build/generated/chr.bin"
