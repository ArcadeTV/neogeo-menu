; ############################################################################################################
; MENU FOR NEO GEO 161in1 MULTICART 
; - based on the work of Vortex https://github.com/xvortex/VTXCart
; - used Furrtek's "Hello World" example code: https://wiki.neogeodev.org/index.php?title=Hello_world_tutorial
;
; ArcadeTV
; // Created: 2023/10/13 09:41:53
; // Last modified: 2023/10/21 01:17:20
; ############################################################################################################

    INCLUDE "includes/regdefs.asm"
    INCLUDE "includes/header.asm"
    INCLUDE "includes/vars.asm"
    INCLUDE "includes/ram.asm"


    ORG $300

    INCLUDE "includes/system.asm"
    INCLUDE "includes/palettes.asm"


; RENDER LIST ON STARTUP: -------------------
    jsr     renderGUI
    jsr     updateList


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
    align   4
    INCLUDE "version.asm"

end_of_file: