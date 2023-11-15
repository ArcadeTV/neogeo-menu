    ; PALETTE #0 ----------------------------   $400000: White Text
PALETTE_NO set 5*32

    move.w      #BLACK,PALETTES+(PALETTE_NO)    ; Transparency, color 0 of palette 0 must always be black anyways
    move.w      #WHITE,PALETTES+(PALETTE_NO)+2  ; Text color
    move.w      #BLACK,PALETTES+(PALETTE_NO)+4  ; Background

    ; PALETTE #1 ----------------------------   $400020: Grey Text
PALETTE_NO set 6*32

    move.w      #BLACK,PALETTES+(PALETTE_NO)    ; Transparency, color 0 of palette 0 must always be black anyways
    move.w      #MIDGREY,PALETTES+(PALETTE_NO)+2; Text color
    move.w      #BLACK,PALETTES+(PALETTE_NO)+4  ; Background

    ; PALETTE #2 ----------------------------   $400040: Red Text
PALETTE_NO set 7*32

    move.w      #BLACK,PALETTES+(PALETTE_NO)    ; Transparency, color 0 of palette 0 must always be black anyways
    move.w      #RED,PALETTES+(PALETTE_NO)+2    ; Text color
    move.w      #BLACK,PALETTES+(PALETTE_NO)+4  ; Background

    ; PALETTE #3 ---------------------------    $400060: Credits Screen
PALETTE_NO set 8*32

    move.w      #$7000,PALETTES+(PALETTE_NO)
    move.w      #$0000,PALETTES+(PALETTE_NO)+2
    move.w      #$0555,PALETTES+(PALETTE_NO)+4
    move.w      #$0999,PALETTES+(PALETTE_NO)+6
    move.w      #$0DDD,PALETTES+(PALETTE_NO)+8
    move.w      #$7FFF,PALETTES+(PALETTE_NO)+10
    move.w      #$7111,PALETTES+(PALETTE_NO)+12
    move.w      #$0E00,PALETTES+(PALETTE_NO)+14
    move.w      #$7600,PALETTES+(PALETTE_NO)+16
    move.w      #$305E,PALETTES+(PALETTE_NO)+18
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+20
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+22
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+24
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+26
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+28
    move.w      #$5F0F,PALETTES+(PALETTE_NO)+30
