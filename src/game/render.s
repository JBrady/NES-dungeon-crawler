.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import player_tile_pairs
.import sword_tile_pairs
.import enemy_tile_pairs
.import enemy_palette_attrs

.export BuildGameplayOAM

.segment "CODE"

.proc BuildGameplayOAM
    jsr DrawPlayer
    jsr DrawSword
    jsr DrawEnemy0
    jsr DrawEnemy1
    rts
.endproc

.proc DrawPlayer
    lda player_iframes
    beq draw_body
    lda player_blink_phase
    bne hide_body
draw_body:
    lda player_y
    sta oam_shadow+OAM_PLAYER_0
    sta oam_shadow+OAM_PLAYER_1

    lda player_facing
    asl a
    asl a
    clc
    adc player_anim_frame
    tax

    lda player_tile_pairs,x
    sta oam_shadow+OAM_PLAYER_0+1
    lda #SPR_ATTR_PAL0
    sta oam_shadow+OAM_PLAYER_0+2
    lda player_x
    sta oam_shadow+OAM_PLAYER_0+3

    inx
    lda player_tile_pairs,x
    sta oam_shadow+OAM_PLAYER_1+1
    lda #SPR_ATTR_PAL0
    sta oam_shadow+OAM_PLAYER_1+2
    lda player_x
    clc
    adc #8
    sta oam_shadow+OAM_PLAYER_1+3
    rts
hide_body:
    lda #$f8
    sta oam_shadow+OAM_PLAYER_0
    sta oam_shadow+OAM_PLAYER_1
    rts
.endproc

.proc DrawSword
    lda player_attack_timer
    beq hide_sword

    lda player_facing
    tax
    lda sword_tile_pairs,x
    sta oam_shadow+OAM_SWORD_0+1
    lda #SPR_ATTR_PAL2
    sta oam_shadow+OAM_SWORD_0+2

    lda player_facing
    cmp #DIR_UP
    bne not_up
    lda player_y
    sec
    sbc #8
    sta oam_shadow+OAM_SWORD_0
    lda player_x
    clc
    adc #4
    sta oam_shadow+OAM_SWORD_0+3
    rts
not_up:
    cmp #DIR_DOWN
    bne not_down
    lda player_y
    clc
    adc #16
    sta oam_shadow+OAM_SWORD_0
    lda player_x
    clc
    adc #4
    sta oam_shadow+OAM_SWORD_0+3
    rts
not_down:
    cmp #DIR_LEFT
    bne sword_right
    lda player_y
    clc
    adc #2
    sta oam_shadow+OAM_SWORD_0
    lda player_x
    sec
    sbc #8
    sta oam_shadow+OAM_SWORD_0+3
    rts
sword_right:
    lda player_y
    clc
    adc #2
    sta oam_shadow+OAM_SWORD_0
    lda player_x
    clc
    adc #16
    sta oam_shadow+OAM_SWORD_0+3
    rts
hide_sword:
    lda #$f8
    sta oam_shadow+OAM_SWORD_0
    sta oam_shadow+OAM_SWORD_1
    rts
.endproc

.proc DrawEnemy0
    lda enemy_table+0
    bne :+
    lda #$f8
    sta oam_shadow+OAM_ENEMY0_0
    sta oam_shadow+OAM_ENEMY0_1
    rts
:
    lda enemy_table+1
    sec
    sbc #1
    asl a
    tax
    lda enemy_tile_pairs,x
    sta oam_shadow+OAM_ENEMY0_0+1
    inx
    lda enemy_tile_pairs,x
    sta oam_shadow+OAM_ENEMY0_1+1

    lda #SPR_ATTR_PAL1
    sta oam_shadow+OAM_ENEMY0_0+2
    sta oam_shadow+OAM_ENEMY0_1+2

    lda enemy_table+3
    sta oam_shadow+OAM_ENEMY0_0
    sta oam_shadow+OAM_ENEMY0_1
    lda enemy_table+2
    sta oam_shadow+OAM_ENEMY0_0+3
    clc
    adc #8
    sta oam_shadow+OAM_ENEMY0_1+3
    rts
.endproc

.proc DrawEnemy1
    lda enemy_table+16
    bne :+
    lda #$f8
    sta oam_shadow+OAM_ENEMY1_0
    sta oam_shadow+OAM_ENEMY1_1
    rts
:
    lda enemy_table+17
    sec
    sbc #1
    asl a
    tax
    lda enemy_tile_pairs,x
    sta oam_shadow+OAM_ENEMY1_0+1
    inx
    lda enemy_tile_pairs,x
    sta oam_shadow+OAM_ENEMY1_1+1

    lda #SPR_ATTR_PAL1
    sta oam_shadow+OAM_ENEMY1_0+2
    sta oam_shadow+OAM_ENEMY1_1+2

    lda enemy_table+19
    sta oam_shadow+OAM_ENEMY1_0
    sta oam_shadow+OAM_ENEMY1_1
    lda enemy_table+18
    sta oam_shadow+OAM_ENEMY1_0+3
    clc
    adc #8
    sta oam_shadow+OAM_ENEMY1_1+3
    rts
.endproc
