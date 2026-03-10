.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import RectsOverlap
.import IsSolidPoint
.import SwordIsActive
.import QueueHudRefresh
.import EnterWin
.import EnterGameOver
.import room_required_dead_masks

.export UpdateCombat

.segment "RODATA"
sword_hitbox_x:
.byte 2, 2, 248, 16
sword_hitbox_y:
.byte 248, 16, 2, 2
sword_hitbox_w:
.byte 12, 12, 8, 8
sword_hitbox_h:
.byte 8, 8, 12, 12

.segment "CODE"

.proc UpdateCombat
    jsr CheckSwordHits
    jsr CheckEnemyContactDamage
    jsr CheckPendingOutcome
    rts
.endproc

.proc CheckSwordHits
    jsr SwordIsActive
    bcs :+
    jmp done
:
    jsr BuildSwordRect
    jsr SwordBlockedByWall
    bcc :+
    jmp done
:

    ldx #0
slot_loop:
    jsr SetEnemyPtrForSlot
    ldy #0
    lda (ptr1),y
    beq next_slot

    txa
    beq mask_slot0
    lda #2
    bne have_mask
mask_slot0:
    lda #1
have_mask:
    sta temp6
    and sword_hit_mask
    bne next_slot

    jsr BuildSwordRect

    ldy #2
    lda (ptr1),y
    clc
    adc #ENEMY_HITBOX_OFFSET_X
    sta temp4
    iny
    lda (ptr1),y
    clc
    adc #ENEMY_HITBOX_OFFSET_Y
    sta temp5
    lda #ENEMY_HITBOX_W
    sta temp6
    lda #ENEMY_HITBOX_H
    sta temp7

    jsr RectsOverlap
    bcc next_slot

    ldy #5
    lda (ptr1),y
    beq next_slot
    sec
    sbc #1
    sta (ptr1),y

    txa
    beq add_mask0
    lda #2
    bne add_mask_done
add_mask0:
    lda #1
add_mask_done:
    ora sword_hit_mask
    sta sword_hit_mask

    lda (ptr1),y
    bne next_slot

    ldy #0
    lda #0
    sta (ptr1),y
    txa
    sta temp4
    ldx current_room
    lda temp4
    beq dead_mask0
    lda #2
    bne dead_mask_done
dead_mask0:
    lda #1
dead_mask_done:
    ldx current_room
    ora room_dead_flags,x
    sta room_dead_flags,x

    ldx temp4
next_slot:
    inx
    cpx #2
    bne slot_loop
done:
    rts
.endproc

.proc BuildSwordRect
    lda player_facing
    tax
    lda player_x
    clc
    adc sword_hitbox_x,x
    sta temp0
    lda player_y
    clc
    adc sword_hitbox_y,x
    sta temp1
    lda sword_hitbox_w,x
    sta temp2
    lda sword_hitbox_h,x
    sta temp3
    rts
.endproc

.proc SwordBlockedByWall
    lda temp0
    ldy temp1
    jsr IsSolidPoint
    bcc :+
    sec
    rts
:
    lda temp0
    clc
    adc temp2
    sec
    sbc #1
    ldy temp1
    jsr IsSolidPoint
    bcc :+
    sec
    rts
:
    lda temp0
    ldy temp1
    tya
    clc
    adc temp3
    sec
    sbc #1
    tay
    lda temp0
    jsr IsSolidPoint
    bcc :+
    sec
    rts
:
    lda temp0
    clc
    adc temp2
    sec
    sbc #1
    sta temp6
    lda temp1
    clc
    adc temp3
    sec
    sbc #1
    tay
    lda temp6
    jsr IsSolidPoint
    rts
.endproc

.proc CheckEnemyContactDamage
    lda player_iframes
    bne done

    lda player_x
    clc
    adc #PLAYER_HITBOX_OFFSET_X
    sta temp0
    lda player_y
    clc
    adc #PLAYER_HITBOX_OFFSET_Y
    sta temp1
    lda #PLAYER_HITBOX_W
    sta temp2
    lda #PLAYER_HITBOX_H
    sta temp3

    ldx #0
contact_loop:
    jsr SetEnemyPtrForSlot
    ldy #0
    lda (ptr1),y
    beq next_contact
    ldy #2
    lda (ptr1),y
    clc
    adc #ENEMY_HITBOX_OFFSET_X
    sta temp4
    iny
    lda (ptr1),y
    clc
    adc #ENEMY_HITBOX_OFFSET_Y
    sta temp5
    lda #ENEMY_HITBOX_W
    sta temp6
    lda #ENEMY_HITBOX_H
    sta temp7
    jsr RectsOverlap
    bcc next_contact

    lda player_hp
    beq done
    sec
    sbc #1
    sta player_hp
    lda #PLAYER_IFRAMES
    sta player_iframes
    jsr QueueHudRefresh
    lda player_hp
    bne done
    lda #STATE_GAME_OVER
    sta pending_state
    lda #END_FREEZE_FRAMES
    sta state_timer
    jmp done

next_contact:
    inx
    cpx #2
    bne contact_loop
done:
    rts
.endproc

.proc CheckPendingOutcome
    lda pending_state
    beq maybe_win
    dec state_timer
    lda state_timer
    bne done
    lda pending_state
    cmp #STATE_GAME_OVER
    bne do_win
    lda #0
    sta pending_state
    jsr EnterGameOver
    rts
do_win:
    lda #0
    sta pending_state
    jsr EnterWin
    rts
maybe_win:
    lda current_room
    cmp #ROOM_3_FINAL
    bne done
    lda room_dead_flags+ROOM_3_FINAL
    and room_required_dead_masks+ROOM_3_FINAL
    cmp room_required_dead_masks+ROOM_3_FINAL
    bne done
    lda #STATE_WIN
    sta pending_state
    lda #END_FREEZE_FRAMES
    sta state_timer
done:
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
