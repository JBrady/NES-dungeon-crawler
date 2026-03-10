.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.export DrawHudFull
.export QueueHudRefresh

.segment "CODE"

.proc DrawHudFull
    lda PPUSTATUS
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    lda #TILE_H
    sta PPUDATA
    lda #TILE_P
    sta PPUDATA
    lda #TILE_SPACE
    sta PPUDATA
    ldx #0
heart_loop:
    cpx player_hp
    bcc full_heart
    lda #TILE_HEART_EMPTY
    bne store_heart
full_heart:
    lda #TILE_HEART_FULL
store_heart:
    sta PPUDATA
    inx
    cpx #3
    bne heart_loop
    rts
.endproc

.proc QueueHudRefresh
    lda #$20
    sta ppu_queue+0
    lda #$03
    sta ppu_queue+1
    lda #3
    sta ppu_queue+2

    ldx #0
hud_queue_loop:
    cpx player_hp
    bcc queue_full
    lda #TILE_HEART_EMPTY
    bne queue_store
queue_full:
    lda #TILE_HEART_FULL
queue_store:
    sta ppu_queue+3,x
    inx
    cpx #3
    bne hud_queue_loop
    lda #0
    sta ppu_queue+6
    rts
.endproc
