.setcpu "6502"
.include "constants.inc"
.include "memory.inc"

.import DisableRendering
.import EnableRendering
.import LoadPalettes
.import LoadScreen1024
.import DrawHudFull
.import ClearPpuQueue
.import room_screen_ptrs
.import room_collision_ptrs
.import room_spawn_ptrs
.import SpawnEnemiesForCurrentRoom

.export LoadCurrentRoom
.export CopyCurrentCollisionMap

.segment "CODE"

.proc LoadCurrentRoom
    jsr DisableRendering
    jsr LoadPalettes
    jsr SetRoomPointers
    jsr LoadScreen1024
    jsr CopyCurrentCollisionMap
    jsr SpawnEnemiesForCurrentRoom
    jsr DrawHudFull
    jsr ClearPpuQueue
    jsr EnableRendering
    rts
.endproc

.proc SetRoomPointers
    lda current_room
    asl a
    tax
    lda room_screen_ptrs,x
    sta ptr0
    lda room_screen_ptrs+1,x
    sta ptr0+1
    rts
.endproc

.proc CopyCurrentCollisionMap
    lda current_room
    asl a
    tax
    lda room_collision_ptrs,x
    sta ptr0
    lda room_collision_ptrs+1,x
    sta ptr0+1
    ldy #0
copy_loop:
    lda (ptr0),y
    sta collision_map,y
    iny
    cpy #224
    bne copy_loop
    rts
.endproc
