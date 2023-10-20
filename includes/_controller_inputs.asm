
readControllerInputs:
    jsr     UpdateIOMirrors

    tst.b   p1_Repeat
    beq.w   .nopress

    btst.b  #CNT_A,p1_Repeat
    beq     .noa
    nop                                     ; A pressed
.noa:
    btst.b  #CNT_B,p1_Repeat
    beq     .nob
    nop                                     ; B pressed

.nob:
    btst.b  #CNT_C,p1_Repeat
    beq     .noc
    nop                                     ; C pressed

.noc:
    btst.b  #CNT_D,p1_Repeat
    beq     .nod
    nop                                     ; D pressed

.nod:
    btst.b  #CNT_UP,p1_Repeat
    beq     .noup
    nop                                     ; UP pressed
    move.b  RAM_CurrentIndex,d0
    tst.b   d0
    beq.w   .setIndexToLast
    sub.b   #1,d0
    move.b  d0,RAM_CurrentIndex
    jsr     updateList
    bra.s   .noup
.setIndexToLast:
    move.b  #GamesCount-1,RAM_CurrentIndex
    jsr     updateList

.noup:
    btst.b  #CNT_DOWN,p1_Repeat
    beq     .nodown
    nop                                     ; DOWN pressed
    move.b  RAM_CurrentIndex,d0
    cmp.b   #GamesCount-1,d0
    beq.w   .setIndexToFirst
    add.b   #1,d0
    move.b  d0,RAM_CurrentIndex
    jsr     updateList
    bra.s   .nodown
.setIndexToFirst:
    move.b  #0,RAM_CurrentIndex
    jsr     updateList

.nodown:
    btst.b  #CNT_LEFT,p1_Repeat
    beq.w   .noleft
    nop                                     ; LEFT pressed

    move.b  RAM_CurrentIndex,d0
    move.b  RAM_CurrentListPos,d3

    cmp.b   #EntriesPerPage,d0              ; if (CurrentIndex < #EntriesPerPage)
    bcs.s   .first_to_last_page

    sub.b   #EntriesPerPage,d0              ; CurrentIndex - #EntriesPerPage
    bra     .not_last_page

.first_to_last_page:
    move.b  #GamesCount,d1
    move.b  #TotalListCount,d2
    sub.b   d3,d1                           ; #GamesCount - RAM_CurrentListPosR
    sub.b   d1,d2                           ; #TotalListCount - (#GamesCount - RAM_CurrentListPos)
    move.b  RAM_CurrentIndex,d0             
    sub.b   d2,d0                           
    cmp.b   #GamesCount-1,d0
    bhi.s   .adjustLastPosition             ; if index is greater than last games' index
    bra     .not_last_page
.adjustLastPosition
    move.b  #GamesCount-1,d0                ; set index to last existing game
.not_last_page:

    move.b  d0,RAM_CurrentIndex
    jsr     updateList

.noleft:
    btst.b  #CNT_RIGHT,p1_Repeat
    beq     .noright
    nop                                     ; RIGHT pressed
                                            
    move.b  RAM_CurrentPage,d0
    cmp.b   #TotalPages-2,d0                ; Compare currentPage to TotalPages-2
    beq     .page_before_last_page          ; branch if equal

                                            ; Case: currentPage != TotalPages-2
                                            
    cmp.b   #TotalPages-1,d0                ; Compare currentPage to TotalPages-1
    beq     .last_page                      ; branch if equal

                                            ; Case: currentPage != TotalPages-1
                                            ; Calculate Index = Index+EntriesPerPage
    move.b  RAM_CurrentIndex,d0             ; get currentIndex in d0
    add.b   #EntriesPerPage,d0              ; Add EntriesPerPage to d0
    bra     .end_of_calc                    ; Branch out

.page_before_last_page:                     ; Case: currentPage == TotalPages-2
                                            ; Calculate Index + EntriesPerPage
    move.b  RAM_CurrentIndex,d0             ; Get CurrentIndex in Register d0
    move.b  d0,d1
    add.b   #EntriesPerPage,d1              ; Add EntriesPerPage to d0
                                            
    cmp.b   #GamesCount-1,d1                ; Compare to GamesCount-1
    bcc     .not_greater                    ; branch if not greater
.not_greater:
    move.b  #GamesCount-1,d0                ; Index = GamesCount-1
    bra     .end_of_calc                    ; Branch out

.last_page:                                 ; Case: currentPage == TotalPages-1
    move.b  RAM_CurrentListPos,d0           ; Index = CurrentListPos

.end_of_calc:


    move.b  d0,RAM_CurrentIndex
    jsr     updateList

.noright:
    nop                                     ; NOTHING pressed
    
.nopress:
    rts


UpdateIOMirrors:
	move.b	d0,REG_DIPSW		; kick watchdog

	; update player 1
	move.b	BIOS_P1STATUS,p1_Status
	move.b	BIOS_P1PREVIOUS,p1_Previous
	move.b	BIOS_P1CURRENT,p1_Current
	move.b	BIOS_P1CHANGE,p1_Change
	move.b	BIOS_P1REPEAT,p1_Repeat
	move.b	BIOS_P1TIMER,p1_Timer

	move.b	d0,REG_DIPSW		; kick watchdog

	; update player 2
	move.b	BIOS_P2STATUS,p2_Status
	move.b	BIOS_P2PREVIOUS,p2_Previous
	move.b	BIOS_P2CURRENT,p2_Current
	move.b	BIOS_P2CHANGE,p2_Change
	move.b	BIOS_P2REPEAT,p2_Repeat
	move.b	BIOS_P2TIMER,p2_Timer

	; future expansion: player 3 and 4 (good luck fitting them on the screen)

	move.b	d0,REG_DIPSW		; kick watchdog

	; update stat current and change first, because they're on all systems
	move.b	BIOS_STATCURNT_RAW,sys_StatCurrent
	move.b	BIOS_STATCHANGE_RAW,sys_StatChange

	; update input TT1 and TT2
	move.b	BIOS_INPUT_TT1,sys_InputTT1
	move.b	BIOS_INPUT_TT2,sys_InputTT2
	move.b	REG_STATUS_A,sys_StatusA

	move.b	d0,REG_DIPSW		; kick watchdog

	; check if we're on a MVS system before bothering to update sys_Dipswitches
	btst.b	#7,REG_STATUS_B
	beq.b	UpdateIOMirrors_Home

	; MVS; update sys_Dipswitches
	move.b	REG_DIPSW,sys_Dipswitches
	bra.b	UpdateIOMirrors_end

UpdateIOMirrors_Home:
	; Home system; do nothing.
	moveq	#0,d0
	move.b	d0,sys_Dipswitches

UpdateIOMirrors_end:
	rts
