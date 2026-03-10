.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import UpdatePlayerMovement
.import TickPlayerBlink
.import CheckDoorTransition
.import UpdateSwordState
.import UpdateEnemies
.import UpdateCombat

.export UpdateGameplay

.segment "CODE"

.proc UpdateGameplay
    lda pending_state
    beq :+
    jsr UpdateCombat
    rts
:
    jsr TickPlayerBlink
    jsr UpdatePlayerMovement
    jsr CheckDoorTransition
    bcs done
    jsr UpdateSwordState
    jsr UpdateEnemies
    jsr UpdateCombat
done:
    rts
.endproc
