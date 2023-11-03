GAMELAUNCH:
    move    #$2700,SR                       ; disable Interrupts

    rept 20
    nop                                     ; 20 nops
    endr
    
    jsr     CLR_RAM
    nop
    nop
    nop

    clr.l   d0
    move.b  RAM_CurrentIndex,d0
    add.b   #1,d0
    jmp     (RAM_GAMELAUNCH)               ; jump to code starting at $100200 (RAM)

    
CLR_RAM:
; SD RAM
    movem.l D0-D7/A0-A6,-(A7)              ; save registers
    move.b  D0,$3a001d.l                   ; REG_SRAMUNLOCK: Unprotects backup RAM (MVS)
    lea     $d08000.l,A4                   ; EXT_00AD
    lea     (-$7edc,A4),A3                 ; load address $d08000-$7edc=$D00124 in a3
    move.b  #$7,D1                         ; set counter 8-1 in d1
.clr_sdram_loop:
    move.b  D0,$300001.l                   ; kick Watchdog
    move.l  #$ffff,(A3)+                   ; move 0x0000ffff in ($D00124)+
    dbra    D1,.clr_sdram_loop             ; repeat 8 times
    rept 75 
    nop                                    ; 75 nops
    endr    
; Sprites
    move.w  #SCB3,REG_VRAMADDR              ; Height attributes are in VRAM at Sprite Control Bank 3
    clr.w   d0
    move.w  #1,REG_VRAMMOD                  ; Set the VRAM address auto-increment value
    move.l  #512-1,d7                       ; Clear all 512 sprites
    nop
.clearspr:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    nop
    dbra    d7,.clearspr                    ; Are we done ? No: jump back to .clearspr

    move.l  #(40*32)-1,d7                   ; Clear the whole map
    move.w  #FIXMAP,REG_VRAMADDR
    move.w  #$0120,d0                       ; Use tile $FF
.clearfix:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    nop
    dbra    d7,.clearfix                    ; Are we done ? No: jump back to .clearfix

    movem.l (A7)+,D0-D7/A0-A6              ; restore registers
    rts                                    ; return from subroutine
