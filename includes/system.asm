VBLANK:                                     ; Label defined in header.asm
    btst    #7,BIOS_SYSTEM_MODE             ; Check if the system ROM wants to take care of the interrupt
    bne     .gamemode                       ; No: jump to .gamemode
    jmp     SYS_INT1                        ; Yes: jump to system ROM
.gamemode:
    movem.l d0-d7/a0-a6,-(a7)
    move.b  d0,REG_DIPSW                    ; Watchdog
    jsr     SYS_IO
    jsr     readControllerInputs
    btst.b  #FLAG_DOTASKS,FLAGS
    beq     .nothing
.nothing:
    movem.l (a7)+,d0-d7/a0-a6
    move.w  #4,REG_IRQACK
    rte

JT_USER:
    dc.l    StartupInit                     ; Jump table for the different things the system ROM can ask for
    dc.l    EyeCatcher
    dc.l    Game
    dc.l    Title

USER:
    move.b  d0,REG_DIPSW                    ; Kick watchdog
    clr.l   d0                              ; Clear register D0
    move.b  BIOS_USER_REQUEST,d0            ; Put BIOS_USER_REQUEST (byte) in D0
    lsl.b   #2,d0                           ; D0 <<= 2
    lea     JT_USER,a0                      ; Put the address of JT_USER in A0
    movea.l (a0,d0),a0                      ; Read from jump table
    jsr     (a0)                            ; Jump to label
    jmp     SYS_RETURN                      ; Tell the system ROM that we're done

StartupInit:
EyeCatcher:
Title:
    rts

Game:                                       ; Label defined in the jump table
    lea     $10F300,sp                      ; Init stack pointer
    move.b  d0,REG_DIPSW                    ; Kick watchdog
    move.w  #$0000,REG_LSPCMODE             ; Make sur the pixel timer is disabled

    move.w  #7,REG_IRQACK                   ; Clear all interrupts
    move.w  #$2000,sr                       ; Enable interrupts

    move.l  #($F300/32)-1,d7                ; We'll clear $F300 bytes of user RAM by writing 8 longwords (32 bytes) at a time
    lea     RAMSTART,a0                     ; Start at the beginning of user RAM
    moveq.l #0,d0                           ; Clear it with 0's
.clear_ram:
    move.l  d0,(a0)+                        ; Write the 8 longwords, incrementing A0 each time
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    move.l  d0,(a0)+
    dbra    d7,.clear_ram                   ; Are we done ? No: jump back to .clear_ram

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

    ; INIT MENU VARS
    move.b  #CurrentIndex,RAM_CurrentIndex
    move.b  #CurrentPage,RAM_CurrentPage
    move.b  #CurrentListPos,RAM_CurrentListPos
    move.b  #CurrentListPosR,RAM_CurrentListPosR

    ; copy game-launch instructions to RAM:
    
    ; move.w  d0, $2c0fee.l
    ; nop
    ; reset
    ; jmp     $c00402.l

    lea     gameLaunchInstructions,a0
    lea     RAM_GAMELAUNCH,a1
    move.l  #(gameLaunchInstructions_end-gameLaunchInstructions-1),d1
.writeLaunchInstructionsToRAM:
    move.b  (a0)+,(a1)+
    dbra    d1,.writeLaunchInstructionsToRAM