.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import room_spawn_ptrs
.import room_dead_flags
.import CanEnemyMove

.export SpawnEnemiesForCurrentRoom
.export UpdateEnemies

.segment "RODATA"
enemy_speed_reload:
.byte 0, 4, 3, 2

.segment "CODE"

.proc SpawnEnemiesForCurrentRoom
    lda current_room
    asl a
    tax
    lda room_spawn_ptrs,x
    sta ptr0
    lda room_spawn_ptrs+1,x
    sta ptr0+1

    ldx #0
spawn_loop:
    stx temp7
    txa
    asl a
    asl a
    tay

    lda (ptr0),y
    sta temp0
    iny
    lda (ptr0),y
    sta temp1
    iny
    lda (ptr0),y
    sta temp2
    iny
    lda (ptr0),y
    sta temp3
    iny
    lda (ptr0),y
    sta temp4

    ldx current_room
    lda room_dead_flags,x
    and temp4
    bne clear_slot

    lda temp0
    beq clear_slot

    ldx temp7
    jsr SetEnemyPtrForSlot
    ldy #0
    lda #1
    sta (ptr1),y
    iny
    lda temp0
    sta (ptr1),y
    tax
    iny
    lda temp1
    sta (ptr1),y
    iny
    lda temp2
    sta (ptr1),y
    iny
    cpx #ENEMY_GUARD
    bne :+
    lda temp3
    beq guard_horizontal
    lda #DIR_DOWN
    bne store_facing
guard_horizontal:
    lda #DIR_RIGHT
    bne store_facing
:   lda #DIR_LEFT
store_facing:
    sta (ptr1),y
    iny
    cpx #ENEMY_GUARD
    bne :+
    lda #2
    bne store_hp
:   lda #1
store_hp:
    sta (ptr1),y
    iny
    lda #1
    sta (ptr1),y
    iny
    cpx #ENEMY_BLOB
    bne :+
    lda #32
    bne store_ai
:   cpx #ENEMY_STALKER
    bne :+
    lda #16
    bne store_ai
:   lda #0
store_ai:
    sta (ptr1),y
    iny
    lda temp7
    sta (ptr1),y
    iny
    lda temp3
    sta (ptr1),y
    iny
    lda #1
    sta (ptr1),y
    iny
    lda #0
    sta (ptr1),y
    iny
    sta (ptr1),y
    iny
    sta (ptr1),y
    iny
    sta (ptr1),y
    jmp next_slot

clear_slot:
    ldx temp7
    jsr SetEnemyPtrForSlot
    ldy #0
    lda #0
    sta (ptr1),y

next_slot:
    ldx temp7
    inx
    cpx #2
    beq :+
    jmp spawn_loop
:
    rts
.endproc

.proc UpdateEnemies
    ldx #0
update_loop:
    jsr SetEnemyPtrForSlot
    jsr UpdateEnemyAtPtr
    inx
    cpx #2
    beq :+
    jmp update_loop
:
    rts
.endproc

.proc SetEnemyPtrForSlot
    txa
    beq enemy0
    lda #< (enemy_table + 16)
    sta ptr1
    lda #> (enemy_table + 16)
    sta ptr1+1
    rts
enemy0:
    lda #< enemy_table
    sta ptr1
    lda #> enemy_table
    sta ptr1+1
    rts
.endproc

.proc UpdateEnemyAtPtr
    ldy #0
    lda (ptr1),y
    bne :+
    rts
:
    iny
    lda (ptr1),y
    sta temp6
    cmp #ENEMY_BLOB
    bne not_blob
    jsr UpdateBlobAi
    jmp maybe_move
not_blob:
    cmp #ENEMY_STALKER
    bne not_stalker
    jsr UpdateStalkerAi
    jmp maybe_move
not_stalker:
    jsr UpdateGuardAi

maybe_move:
    ldy #6
    lda (ptr1),y
    beq do_move
    sec
    sbc #1
    sta (ptr1),y
    rts

do_move:
    ldy #1
    lda (ptr1),y
    tax
    lda enemy_speed_reload,x
    ldy #6
    sta (ptr1),y

    ldy #2
    lda (ptr1),y
    sta temp0
    iny
    lda (ptr1),y
    sta temp1
    iny
    lda (ptr1),y
    sta temp2
    jsr CanEnemyMove
    bcc apply_move
    jsr HandleBlockedEnemy
    rts

apply_move:
    ldy #4
    lda (ptr1),y
    cmp #DIR_UP
    bne move_down
    ldy #3
    lda (ptr1),y
    sec
    sbc #1
    sta (ptr1),y
    jmp after_move
move_down:
    cmp #DIR_DOWN
    bne move_left
    ldy #3
    lda (ptr1),y
    clc
    adc #1
    sta (ptr1),y
    jmp after_move
move_left:
    cmp #DIR_LEFT
    bne move_right
    ldy #2
    lda (ptr1),y
    sec
    sbc #1
    sta (ptr1),y
    jmp after_move
move_right:
    ldy #2
    lda (ptr1),y
    clc
    adc #1
    sta (ptr1),y

after_move:
    lda temp6
    cmp #ENEMY_GUARD
    bne done
    ldy #10
    lda (ptr1),y
    bne guard_positive
    ldy #11
    lda (ptr1),y
    sec
    sbc #1
    sta (ptr1),y
    rts
guard_positive:
    ldy #11
    lda (ptr1),y
    clc
    adc #1
    sta (ptr1),y
done:
    rts
.endproc

.proc UpdateBlobAi
    ldy #7
    lda (ptr1),y
    beq reroll_blob
    sec
    sbc #1
    sta (ptr1),y
    rts
reroll_blob:
    jsr AdvanceRng
    and #$03
    ldy #4
    sta (ptr1),y
    ldy #7
    lda #32
    sta (ptr1),y
    rts
.endproc

.proc UpdateStalkerAi
    ldy #7
    lda (ptr1),y
    beq retarget_stalker
    sec
    sbc #1
    sta (ptr1),y
    rts
retarget_stalker:
    jsr ChooseStalkerDirection
    ldy #4
    sta (ptr1),y
    ldy #7
    lda #16
    sta (ptr1),y
    rts
.endproc

.proc UpdateGuardAi
    ldy #11
    lda (ptr1),y
    cmp #32
    bcc :+
    ldy #10
    lda #0
    sta (ptr1),y
:
    ldy #11
    lda (ptr1),y
    bne :+
    ldy #10
    lda #1
    sta (ptr1),y
:
    ldy #9
    lda (ptr1),y
    beq guard_horizontal
    ldy #10
    lda (ptr1),y
    beq guard_up
    lda #DIR_DOWN
    bne store_guard_dir
guard_up:
    lda #DIR_UP
    bne store_guard_dir
guard_horizontal:
    ldy #10
    lda (ptr1),y
    beq guard_left
    lda #DIR_RIGHT
    bne store_guard_dir
guard_left:
    lda #DIR_LEFT
store_guard_dir:
    ldy #4
    sta (ptr1),y
    rts
.endproc

.proc HandleBlockedEnemy
    lda temp6
    cmp #ENEMY_BLOB
    bne :+
    ldy #7
    lda #0
    sta (ptr1),y
    rts
:
    cmp #ENEMY_GUARD
    bne done
    ldy #10
    lda (ptr1),y
    eor #1
    sta (ptr1),y
done:
    rts
.endproc

.proc AdvanceRng
    lda rng_lo
    asl a
    eor rng_hi
    clc
    adc #$41
    sta rng_lo
    lda rng_hi
    ror a
    eor rng_lo
    clc
    adc #$17
    sta rng_hi
    lda rng_lo
    rts
.endproc

.proc ChooseStalkerDirection
    ldy #2
    lda (ptr1),y
    sta temp0
    iny
    lda (ptr1),y
    sta temp1

    lda player_x
    sec
    sbc temp0
    bcs dx_positive
    eor #$ff
    clc
    adc #1
dx_positive:
    sta temp2

    lda player_y
    sec
    sbc temp1
    bcs dy_positive
    eor #$ff
    clc
    adc #1
dy_positive:
    sta temp3

    lda temp2
    cmp temp3
    bcs choose_horizontal
    lda player_y
    cmp temp1
    bcc choose_up
    lda #DIR_DOWN
    rts
choose_up:
    lda #DIR_UP
    rts
choose_horizontal:
    lda player_x
    cmp temp0
    bcc choose_left
    lda #DIR_RIGHT
    rts
choose_left:
    lda #DIR_LEFT
    rts
.endproc
