renderGUI:

; WRITE LINES -------------------------------
    ; upper line ----------------------------
    move    #LineLength+1,d1                ; define a length for the line, length of a list-entry + 2 (in tiles)
    move.l  #POS_LINE_TOP,d6                ; start position in fix map for upper line
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.w  #$554F,d0                       ; set line tile $54F in D0
.writeUpperLine:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.writeUpperLine              ; Jump back to .writelower until all 32 chars are written
    ; lower line ----------------------------
    move    #LineLength+1,d1                ; define a length for the line, length of a list-entry + 2 (in tiles)
    move.l  #POS_LINE_BOTTOM,d6             ; start position in fix map for upper line
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.w  #$554F,d0                       ; set line tile $54F in D0
.writeLowerLine:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.writeLowerLine              ; Jump back to .writelower until all 32 chars are written


renderStaticStrings:

; RENDER PAGE INFO: -------------------------
    move.l  #POS_PAGE_STR,d6                ; initial start-to-write position in fix map
    lea     Str_Page,a0                     ; Load the text's address in A0
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$6000,d0                       ; tiles from address $0 in S ROM
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeStr_Page:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    tst.b   d0 
    beq.w   .writeStr_Page_complete
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    bra    .writeStr_Page                   ; Jump back to .writeStr_Page until all chars are written and 0 occured
.writeStr_Page_complete:

    rts


Credits:
    move.l  #$8BA0,d0                       ; tiles from address $BA0 in S ROM, use palette #3
    move.l  #28-1,d2                        ; height: 28 tiles = 224px
    move.l  #$7002,d3                       ; initial upper left position in fixmap
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeLogoColumns:
    move.l  #40-1,d1                        ; loop counter for inner dbra loop -> width: 40 tiles = 320px
    move.b  d0,REG_DIPSW                    ; Watchdog
    move.w  d3,REG_VRAMADDR                 ; send start position to vram
.writeLogoRow:
    move.w  d0,REG_VRAMRW                   ; Write tileNo. to VRAM
    addq    #1,d0
    nop                                     ; Wait a bit...
    dbra    d1,.writeLogoRow                ; Jump back to .writeLogo until all chars are written and 0 occured
    addq    #1,d3                           ; next Row
    dbra    d2,.writeLogoColumns
.writeLogo_complete:

    rts

clrFix:
    move.l  #(40*32)-1,d7                   ; Clear the whole map
    move.w  #1,REG_VRAMMOD                  ; Set the VRAM address auto-increment value
    move.w  #FIXMAP,REG_VRAMADDR
    move.w  #$20,d0                         ; Use blank tile
.clearfix:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    nop
    move.b  d0,REG_DIPSW                    ; Watchdog
    dbra    d7,.clearfix                    ; Are we done ? No: jump back to .clearfix
    rts