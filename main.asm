; ############################################################################################################
; MENU FOR NEO GEO 161in1 MULTICART 
; - based on the work of Vortex https://github.com/xvortex/VTXCart
; - used Furrtek's "Hello World" example code: https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial
;
; ArcadeTV
; // Created: 2023/10/13 09:41:53
; // Last modified: 2023/10/24 13:03:15
; ############################################################################################################

    INCLUDE "includes/regdefs.asm"
    INCLUDE "includes/header.asm"
    INCLUDE "includes/vars.asm"
    INCLUDE "includes/ram.asm"


    ORG $300

    INCLUDE "includes/system.asm"
    INCLUDE "includes/palettes.asm"


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


; SUB ROUTINES -----------------------------
    INCLUDE "includes/_controller_inputs.asm"
    INCLUDE "includes/_updateList.asm"
    INCLUDE "includes/_render_gui.asm"

; DATA -------------------------------------
    INCLUDE "gameslist.asm"
    INCLUDE "includes/data_strings.asm"

gameLaunchInstructions:
    dc.b    $33,$C0,$00,$2C,$0F,$EE,$4E,$71,$4E,$70
gameLaunchInstructions_end:

    align   4
    INCLUDE "version.asm"

end_of_file: