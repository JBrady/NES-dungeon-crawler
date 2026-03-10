.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import DisableRendering
.import EnableRendering
.import LoadPalettes
.import LoadScreen1024
.import ClearPpuQueue
.import title_screen_data
.import StartNewGame

.export LoadTitleScreen
.export UpdateTitle

.segment "CODE"

.proc LoadTitleScreen
    jsr DisableRendering
    jsr LoadPalettes
    lda #<title_screen_data
    sta ptr0
    lda #>title_screen_data
    sta ptr0+1
    jsr LoadScreen1024
    jsr ClearPpuQueue
    jsr EnableRendering
    rts
.endproc

.proc UpdateTitle
    lda state_timer
    beq :+
    dec state_timer
:
    lda state_timer
    bne done
    lda pad_pressed
    and #PAD_START
    beq done
    jsr StartNewGame
done:
    rts
.endproc
