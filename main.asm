; ############################################################################################################
; MENU FOR NEO GEO 161in1 MULTICART 
; - based on the work of Vortex https://github.com/xvortex/VTXCart
; - used Furrtek's "Hello World" example code: https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial
;
; ArcadeTV
; // Created: 2023/10/13 09:41:53
; // Last modified: 2023/10/28 09:26:51
; ############################################################################################################

    INCLUDE "includes/regdefs.asm"
    INCLUDE "includes/header.asm"
    INCLUDE "includes/vars.asm"
    INCLUDE "includes/ram.asm"
    INCLUDE "includes/system.asm"
    INCLUDE "includes/palettes.asm"

    ;jsr     Credits 
    ;bra     .loop

; RENDER LIST ON STARTUP: -------------------
    move.b  #GamesCount,d0 
    tst.b   d0
    beq     .noGamesFound
    jsr     renderGUI
    jsr     updateList
    bra     .loop
.noGamesFound
    jsr     noGamesMessage

; MAIN LOOP: -------------------------------
.loop:
    bra     .loop

; ROUTINES -----------------------------
    INCLUDE "includes/gamelaunch.asm"

; SUB ROUTINES -----------------------------
    INCLUDE "includes/_controller_inputs.asm"
    INCLUDE "includes/_updateList.asm"
    INCLUDE "includes/_render_gui.asm"

; DATA -------------------------------------
    INCLUDE "gameslist.asm"
    even
    INCLUDE "includes/data_strings.asm"

    even

   ; Configuration menu layouts (soft DIPs)
 JPConfig:
    dc.b    "VORTEX MULTICART"                            ; Game name
    dc.b    $FF,$FF,$FF,$FF,$FF,$FF                       ; Special list
    dc.b    $02,$00,$00,$00,$00,$00,$00,$00,$00,$00       ; Option list
    dc.b    "ITEM ON PAGE"
    dc.b    "7           "
    dc.b    "14          "

 USConfig:
    dc.b    "VORTEX MULTICART"                            ; Game name
    dc.b    $FF,$FF,$FF,$FF,$FF,$FF                       ; Special list
    dc.b    $02,$00,$00,$00,$00,$00,$00,$00,$00,$00       ; Option list
    dc.b    "ITEM ON PAGE"
    dc.b    "7           "
    dc.b    "14          "

    even 

gameLaunchInstructions:
    dc.b    $33,$C0,$00,$2C,$0F,$EE         ; move.w  d0, $2c0fee.l
    dc.b    $4E,$71                         ; nop
    dc.b    $4E,$70                         ; reset
    dc.b    $4E,$F9,$00,$C0,$04,$02         ; jmp     $c00402.l
gameLaunchInstructions_end:

    align   4
    INCLUDE "version.asm"

end_of_file: