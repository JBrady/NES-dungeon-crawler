.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import WaitVBlank
.import DisableRendering
.import EnableRendering
.import LoadPalettes
.import HideAllSprites
.import EnterTitle
.import Main

.export Reset
.export IRQ

.segment "CODE"

.proc Reset
    sei
    cld
    ldx #$40
    stx JOY2
    ldx #$ff
    txs
    inx

    stx PPUCTRL
    stx PPUMASK
    stx APUSTATUS

    jsr ClearRam
    jsr WaitVBlank
    jsr WaitVBlank
    jsr DisableRendering
    jsr LoadPalettes
    jsr HideAllSprites

    lda #< $5A
    sta rng_lo
    lda #> $A55A
    sta rng_hi

    lda #0
    sta frame_counter_lo
    sta frame_counter_hi
    sta frame_ready
    sta pending_state
    sta next_room
    sta transition_entry
    sta transition_timer

    jsr EnterTitle
    jmp Main
.endproc

.proc ClearRam
    lda #0
    tay
clear_loop:
    sta $0000,y
    sta $0200,y
    sta $0300,y
    sta $0400,y
    sta $0500,y
    sta $0600,y
    sta $0700,y
    iny
    bne clear_loop
    rts
.endproc

.proc IRQ
    rti
.endproc
