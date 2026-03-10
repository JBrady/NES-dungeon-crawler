.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.export CanPlayerMove
.export IsSolidPoint
.export RectsOverlap
.export CanEnemyMove

.segment "CODE"

.proc CanPlayerMove
    lda player_move_dir
    cmp #DIR_UP
    bne check_down

    lda player_x
    clc
    adc #3
    ldy player_y
    iny
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:

    lda player_x
    clc
    adc #12
    ldy player_y
    iny
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:
    clc
    rts

check_down:
    cmp #DIR_DOWN
    bne check_left

    lda player_x
    clc
    adc #3
    ldy player_y
    tya
    clc
    adc #14
    tay
    lda player_x
    clc
    adc #3
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:

    lda player_x
    clc
    adc #12
    ldy player_y
    tya
    clc
    adc #14
    tay
    lda player_x
    clc
    adc #12
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:
    clc
    rts

check_left:
    cmp #DIR_LEFT
    bne check_right

    lda player_x
    clc
    adc #1
    ldy player_y
    tya
    clc
    adc #3
    tay
    lda player_x
    clc
    adc #1
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:

    lda player_x
    clc
    adc #1
    ldy player_y
    tya
    clc
    adc #12
    tay
    lda player_x
    clc
    adc #1
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:
    clc
    rts

check_right:
    lda player_x
    clc
    adc #14
    ldy player_y
    tya
    clc
    adc #3
    tay
    lda player_x
    clc
    adc #14
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:

    lda player_x
    clc
    adc #14
    ldy player_y
    tya
    clc
    adc #12
    tay
    lda player_x
    clc
    adc #14
    jsr IsSolidPoint
    bcc :+
    jmp blocked
:
    clc
    rts

blocked:
    sec
    rts
.endproc

.proc IsSolidPoint
    sta temp0
    sty temp1

    cpy #PLAYFIELD_ORIGIN_Y
    bcc solid
    cpy #(PLAYFIELD_ORIGIN_Y + 224)
    bcs solid

    tya
    sec
    sbc #PLAYFIELD_ORIGIN_Y
    lsr a
    lsr a
    lsr a
    lsr a
    asl a
    asl a
    asl a
    asl a
    sta temp2

    lda temp0
    sec
    sbc #PLAYFIELD_ORIGIN_X
    lsr a
    lsr a
    lsr a
    lsr a
    clc
    adc temp2
    tay
    lda collision_map,y
    beq passable
solid:
    sec
    rts
passable:
    clc
    rts
.endproc

.proc RectsOverlap
    lda temp0
    clc
    adc temp2
    cmp temp4
    bcc no_overlap
    beq no_overlap
    lda temp4
    clc
    adc temp6
    cmp temp0
    bcc no_overlap
    beq no_overlap
    lda temp1
    clc
    adc temp3
    cmp temp5
    bcc no_overlap
    beq no_overlap
    lda temp5
    clc
    adc temp7
    cmp temp1
    bcc no_overlap
    beq no_overlap
    sec
    rts
no_overlap:
    clc
    rts
.endproc

.proc CanEnemyMove
    lda temp2
    cmp #DIR_UP
    bne check_enemy_down

    lda temp0
    clc
    adc #3
    ldy temp1
    iny
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    lda temp0
    clc
    adc #12
    ldy temp1
    iny
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    clc
    rts

check_enemy_down:
    cmp #DIR_DOWN
    bne check_enemy_left
    lda temp0
    clc
    adc #3
    ldy temp1
    tya
    clc
    adc #14
    tay
    lda temp0
    clc
    adc #3
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    lda temp0
    clc
    adc #12
    ldy temp1
    tya
    clc
    adc #14
    tay
    lda temp0
    clc
    adc #12
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    clc
    rts

check_enemy_left:
    cmp #DIR_LEFT
    bne check_enemy_right
    lda temp0
    clc
    adc #1
    ldy temp1
    tya
    clc
    adc #3
    tay
    lda temp0
    clc
    adc #1
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    lda temp0
    clc
    adc #1
    ldy temp1
    tya
    clc
    adc #12
    tay
    lda temp0
    clc
    adc #1
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    clc
    rts

check_enemy_right:
    lda temp0
    clc
    adc #14
    ldy temp1
    tya
    clc
    adc #3
    tay
    lda temp0
    clc
    adc #14
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    lda temp0
    clc
    adc #14
    ldy temp1
    tya
    clc
    adc #12
    tay
    lda temp0
    clc
    adc #14
    jsr IsSolidPoint
    bcc :+
    jmp enemy_blocked
:
    clc
    rts

enemy_blocked:
    sec
    rts
.endproc
