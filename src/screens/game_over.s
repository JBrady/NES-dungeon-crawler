.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import DisableRendering
.import EnableRendering
.import LoadPalettes
.import LoadScreen1024
.import ClearPpuQueue
.import game_over_screen_data
.import EnterTitle

.export LoadGameOverScreen
.export UpdateGameOver

.segment "CODE"

.proc LoadGameOverScreen
    jsr DisableRendering
    jsr LoadPalettes
    lda #<game_over_screen_data
    sta ptr0
    lda #>game_over_screen_data
    sta ptr0+1
    jsr LoadScreen1024
    jsr ClearPpuQueue
    jsr EnableRendering
    rts
.endproc

.proc UpdateGameOver
    lda state_timer
    beq :+
    dec state_timer
:
    lda state_timer
    bne done
    lda pad_pressed
    and #PAD_START
    beq done
    jsr EnterTitle
done:
    rts
.endproc
