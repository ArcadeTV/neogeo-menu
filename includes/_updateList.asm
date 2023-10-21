updateList:
    movem.l d0-d7/a0-a6,-(a7)
    
    jsr     saveListValues
    jsr     removeArrows
    jsr     renderArrow
    jsr     updatePageNumber
    jsr     updateTotalPagesNumber
    jsr     updateGameInfo
    jsr     updateIndex
    jsr     renderList

.doNotUpdateList:

    movem.l (a7)+,d0-d7/a0-a6
    rts


saveListValues:
    clr.l   d0
    move.b  (RAM_CurrentIndex),d0           ; perform RAM_CurrentIndex % EntriesPerPage: step1: get value of RAM_CurrentIndex
    divu.w  #EntriesPerPage,d0              ; step2: divu -> upper word = rest, lower word = result of division
    move.b  d0,RAM_CurrentPage              ; save CurrentPage in RAM
    swap    d0                              ; swap both words in d1 to get the rest-value
    move.b  d0,RAM_CurrentListPos

    move.l  #(EntriesPerPage-1),d1          ; init d2 for rows-count
    sub.b   d0,d1                           ; inverse the logic for "result of modulo" vs "RAM_CurrentListPos"
    move.b  d1,RAM_CurrentListPosR

    rts


removeArrows:
; REMOVE ALL ARROWS -------------------------------
    clr.l   d1
    move.b  #(EntriesPerPage*2+(EntriesPerPage-1))-1,d1            ; set counter for loop
    move.l  #ARROW_FIXSTART,d6              ; start position in fix map for upper arrow
    move.w  #1,REG_VRAMMOD                  ; Set the VRAM address auto-increment value
.doKillArrows:
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #$0020,d0                       ; set tile $20, blank
    move.w  d0,REG_VRAMRW                   ; Write tile to VRAM
    nop                                     ; Wait a bit...
    addq.b  #1,d6                           ; add 1 to vram address for lower part of arrow tiles
    move.b  d0,REG_DIPSW                    ; Watchdog
    dbra    d1,.doKillArrows

    rts


renderArrow:
; ARROW ------------------------------------
    clr.l   d1
    move.b  RAM_CurrentListPos,d1
    mulu.w  #3,d1                           ; 2 tiles + 1 gap = 3 for the multiplication
    move.l  #ARROW_FIXSTART,d6              ; start position in fix map for first visible arrow
    add.w   d1,d6                           ; add the result to the start position

    ; upper arrow ---------------------------
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #$2111,d0                       ; set tile $111, palette #2 in D0
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    ; lower arrow ---------------------------
    add.l   #1,d6                           ; start position in fix map for upper arrow
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #$2211,d0                       ; set tile $211, palette #2 in D0
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    move.b  d0,REG_DIPSW                    ; Watchdog

    rts 


updatePageNumber:
    move.b  d0,REG_DIPSW                    ; Watchdog
    move.l  #POS_PAGE_CURRENT,d6            ; initial start-to-write position in fix map
    clr.l   d1
    move.b  (RAM_CurrentPage),d1
    add.b   d1,d1
    lea     Str_Numbers2,a0                  ; Load the text's address in A0
    add.l	d1,a0                           ; offset
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.l  #1,d2                           ; we need to loop for 2 iterations (2-1)=1
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeStr_PageNo:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d2,.writeStr_PageNo             ; Jump back to .writeStr_Page until all 2 chars are written

    rts


updateTotalPagesNumber:
    movem.l d0-d7/a0-a6,-(a7)
    move.b  d0,REG_DIPSW                    ; Watchdog
    move.l  #POS_PAGE_TOTAL,d6              ; initial start-to-write position in fix map
    clr.l   d1
    move.b  #(TotalPages-1),d1
    add.b   d1,d1
    lea     Str_Numbers2,a0                  ; Load the text's address in A0
    add.l	d1,a0                           ; offset
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.l  #1,d2                           ; we need to loop for 2 iterations (2-1)=1
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeStr_Pages:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d2,.writeStr_Pages              ; Jump back to .writeStr_Page until all 2 chars are written
    movem.l (a7)+,d0-d7/a0-a6

    rts


updateGameInfo:
    ; REMOVE ALL TEXT FIRST
    clr.l   d1
    move.b  #34-1,d1                        ; set counter for loop
    move.l  #POS_GAME_INFO,d6               ; start position in fix map for upper arrow
    move.w  d6,REG_VRAMADDR                 ; Set the position (address in fix map)
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.w  #$0020,d0                       ; set tile $20, blank
.doKillText:
    move.w  d0,REG_VRAMRW                   ; Write tile to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.doKillText
    move.b  d0,REG_DIPSW                    ; Watchdog
    ; RENDER TEXT
    clr.l   d0
    move.b  RAM_CurrentIndex,d0
    add.w   d0,d0
    add.w   d0,d0
    move.l  #POS_GAME_INFO,d6               ; initial start-to-write position in fix map

    clr.l   d1
    move.b  RAM_ListMode,d1
    tst.b   d1
    bne.w   .showGameCategories
    
    ; show GameInfos
    tst.b   BIOS_COUNTRY_CODE               ; test if register is 0 (Japan region)
    beq.w   .loadJapTable                   ; if it is, branch to load the jap titles Table
    lea     GameInfosTable,a0               ; Load the text's table address in A0
    bra.s   .loadUsaTable
.loadJapTable:
    lea     GameInfosTable_j,a0             ; Load the text's address in A0
.loadUsaTable:
    move.w  #$007B,d1                       ; put copyright-sign tile in d1 for writing 1st letter in letter in line
    bra.w   .listMode_was_checked

.showGameCategories:
    ; show Game Categories
    move.w  #$0020,d1                       ; put blank tile in d1 for writing 1st letter in letter in line
    tst.b   BIOS_COUNTRY_CODE               ; test if register is 0 (Japan region)
    beq.w   .loadJapCategoriesTable         ; if it is, branch to load the jap titles Table
    lea     CategoriesTable,a0              ; Load the text's table address in A0
    bra.s   .loadUsaCategoriesTable
.loadJapCategoriesTable:
    lea     CategoriesTable_j,a0            ; Load the text's address in A0
.loadUsaCategoriesTable:

.listMode_was_checked:
    movea.l (a0,d0),a0
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.w  d1,REG_VRAMRW                   ; write copyright sign or blank, depending on ListMode
    move.w  #$0020,REG_VRAMRW               ; write space
.writeStr_Info:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    tst.b   d0 
    beq.w   .writeStr_Info_complete
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    move.b  d0,REG_DIPSW                    ; Watchdog
    bra    .writeStr_Info                   ; Jump back to .writeStr_Info until all chars are written and 0 occured
.writeStr_Info_complete:

; RENDER MEGS INFO: -------------------------
    ; MEGS Value
    clr.l   d1
    move.l  #POS_MEGS,d6                    ; initial start-to-write position in fix map
    move.b  (RAM_CurrentIndex),d1           ; Fetch current List-Index in d1
    mulu.w  #3,d1                           ; Multiply with 3 because our index-number-string consists of 3 digits
    tst.b   BIOS_COUNTRY_CODE               ; test if register is 0 (Japan region)
    beq.w   .loadJapMegs                    ; if it is, branch to load the jap titles Megs
    lea     Megs,a0                         ; Load the text's address in A0
    bra.s   .loadUsaMegs
.loadJapMegs:
    lea     Megs_j,a0                  ; Load the text's address in A0
.loadUsaMegs:
    add.l	d1,a0                           ; offset

    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.l  #2,d1                           ; set loop = 3
.write_Megs:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    tst.b   d0 
    beq.w   .write_Megs_complete
    or.w    #$2000,d0                       ; change palette
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.write_Megs                  ; Jump back to .write_Megs until all 3 chars are written
.write_Megs_complete:

    ; MEGS String
    move.l  #POS_MEGS_STR,d6                ; initial start-to-write position in fix map
    lea     Str_Megs,a0                     ; Load the text's address in A0
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeStr_Megs:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    tst.b   d0 
    beq.w   .writeStr_Megs_complete
    or.w    #$2000,d0                       ; change palette
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    bra    .writeStr_Megs                   ; Jump back to .writeStr_Megs until all chars are written and 0 occured
.writeStr_Megs_complete:

    rts


updateIndex:
    move.b  d0,REG_DIPSW                    ; Watchdog
    move.l  #POS_INDEX,d6                   ; initial start-to-write position in fix map
    clr.l   d1
    move.b  (RAM_CurrentIndex),d1           ; Fetch current List-Index in d1
    mulu.w  #3,d1                           ; Multiply with 3 because our index-number-string consists of 3 digits
    lea     Str_Numbers3,a0                 ; Load the text's address in A0
    add.l	d1,a0                           ; offset
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0000,d0                       ; tiles from address $0 in S ROM
    nop
    move.l  #2,d2                           ; we need to loop for 3 iterations (3-1)=1
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
.writeStr_Index:
    move.b  (a0)+,d0                        ; put char in d0, auto-increment a0 for next char
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d2,.writeStr_Index              ; Jump back to .writeStr_Page until all 2 chars are written

    rts


renderList:
; RENDER LIST: ------------------------------
    move.b  (RAM_CurrentListPos),d3         ; get current list position (where the arrow is drawn) in d3
    move.b  (RAM_CurrentListPosR),d4        ; get current list position (where the arrow is drawn) in d3
    move.l  #(EntriesPerPage-1),d2          ; init d2 for rows-count
    move.b  (RAM_CurrentPage),d5            ; get current page value from RAM
    move.l  #POS_LIST,d6                    ; initial upper left position in fix map
    tst.b   BIOS_COUNTRY_CODE               ; test if register is 0 (Japan region)
    beq.w   .loadJapList                    ; if it is, branch to load the jap titles list
    lea     Gameslist,a0                    ; Load the text's address in A0
    bra.s   .loadUsaList
.loadJapList:
    lea     Gameslist_j,a0                  ; Load the text's address in A0
.loadUsaList:
    mulu.w  #(LineLength*EntriesPerPage),d5 ; calculate the offset: linelen*items*currentPage
    add.w   d5,a0                           ; add the result to the gamelist-start offset
    bra.w   .writeListEntry                 ; skip loading jap titles because region is NOT 0
.writeListEntry:
    ; Render upper half: ---
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0100,d0                       ; Upper tiles are in S ROM bank 1, this word will be concatenated with a byte for tile-numer later
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    
    move.l  #(LineLength-1),d1              ; init d1 for column (text) length 32
.writeupper:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    cmp.b   d4,d2                           ; compare to RAM_CurrentListPosR to highlight menu item
    beq.w   .skipPaletteChangeUpper
    or.w    #$1000,d0
.skipPaletteChangeUpper:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.writeupper                  ; Jump back to .writeupper until all 32 chars are written

    ; Render lower half: ---
    sub.w   #LineLength,a0                  ; Go back 32 chars to write the same entry again, but with lower half tiles
    add.w   #1,d6
    move.w  d6,REG_VRAMADDR                 ; Set the text position (address in fix map) #FIXMAP+(Y+2+((X+1)*32))
    move.w  #$0200,d0                       ; Lower tiles are in S ROM bank 2, this word will be concatenated with a byte for tile-numer later
    nop
    move.w  #32,REG_VRAMMOD                 ; Set the VRAM address auto-increment value
    move.l  #(32-1),d1                      ; init d1 for column length 32
.writelower:
    move.b  (a0)+,d0                        ; Load D0's lower byte
    cmp.b   d4,d2                           ; compare to RAM_CurrentListPosR to highlight menu item
    beq.w   .skipPaletteChangeLower
    or.w    #$1000,d0
.skipPaletteChangeLower:
    move.w  d0,REG_VRAMRW                   ; Write to VRAM
    nop                                     ; Wait a bit...
    dbra    d1,.writelower                  ; Jump back to .writelower until all 32 chars are written

    add.w   #2,d6
    dbra    d2,.writeListEntry              ; Jump back to .writeListEntry until all 8 rows are written

    rts
