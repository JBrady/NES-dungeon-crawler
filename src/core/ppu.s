.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import bg_palette_data

.export WaitVBlank
.export DisableRendering
.export EnableRendering
.export LoadPalettes
.export LoadScreen1024
.export FlushPpuQueue
.export ClearPpuQueue

.segment "CODE"

.proc WaitVBlank
    bit PPUSTATUS
:
    bit PPUSTATUS
    bpl :-
    rts
.endproc

.proc DisableRendering
    lda #0
    sta PPUCTRL
    sta PPUMASK
    sta PPUSCROLL
    sta PPUSCROLL
    rts
.endproc

.proc EnableRendering
    lda #PPUCTRL_NMI_8X16
    sta PPUCTRL
    lda #PPUMASK_RENDER_ON
    sta PPUMASK
    lda #0
    sta PPUSCROLL
    sta PPUSCROLL
    rts
.endproc

.proc LoadPalettes
    lda PPUSTATUS
    lda #$3f
    sta PPUADDR
    lda #$00
    sta PPUADDR
    ldx #0
palette_loop:
    lda bg_palette_data,x
    sta PPUDATA
    inx
    cpx #32
    bne palette_loop
    rts
.endproc

.proc LoadScreen1024
    lda PPUSTATUS
    lda #$20
    sta PPUADDR
    lda #$00
    sta PPUADDR
    ldx #4
page_loop:
    ldy #0
copy_loop:
    lda (ptr0),y
    sta PPUDATA
    iny
    bne copy_loop
    inc ptr0+1
    dex
    bne page_loop
    rts
.endproc

.proc ClearPpuQueue
    lda #0
    sta ppu_queue
    rts
.endproc

.proc FlushPpuQueue
    ldy #0
packet_loop:
    lda ppu_queue,y
    beq done
    sta PPUADDR
    iny
    lda ppu_queue,y
    sta PPUADDR
    iny
    lda ppu_queue,y
    tax
    iny
data_loop:
    lda ppu_queue,y
    sta PPUDATA
    iny
    dex
    bne data_loop
    jmp packet_loop
done:
    lda #0
    sta ppu_queue
    rts
.endproc
