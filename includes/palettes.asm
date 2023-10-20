    ; PALETTE #0 ----------------------------
    move.w  #BLACK,PALETTES                 ; Transparency, color 0 of palette 0 must always be black anyways
    move.w  #WHITE,PALETTES+2               ; Text color
    move.w  #BLACK,PALETTES+4               ; Background
    ; PALETTE #1 ----------------------------
    move.w  #BLACK,PALETTES+32              ; Transparency, color 0 of palette 0 must always be black anyways
    move.w  #MIDGREY,PALETTES+34            ; Text color
    move.w  #BLACK,PALETTES+36              ; Background
    ; PALETTE #2 ----------------------------
    move.w  #BLACK,PALETTES+64              ; Transparency, color 0 of palette 0 must always be black anyways
    move.w  #RED,PALETTES+66                ; Text color
    move.w  #BLACK,PALETTES+68              ; Background
