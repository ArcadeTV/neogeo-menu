
readControllerInputs:
    jsr     UpdateIOMirrors

    tst.b   p1_Repeat
    beq.w   .nopress

    btst.b  #CNT_A,p1_Current
    beq     .noa
    nop                                     ; A pressed

    clr.l   d0
    move.b  RAM_CurrentIndex,d0
    add.w   d0,d0                           ; NGH values are WORD sized, so we need to double our byte in d0
    tst.b   BIOS_COUNTRY_CODE               ; test if register is 0 (Japan region)
    beq.w   .loadNGH_j                      ; if it is, branch to load the jap titles Table
    lea     NGH,a0                          ; Load the NGH based on the US List
    bra.s   .loadNGH
.loadNGH_j:
    lea     NGH_j,a0                        ; Load the NGH based on the JAP List
.loadNGH:
    move.w  (a0,d0),d0                      ; get the NGH

    jmp     RAM_GAMELAUNCH                  ; Launch the selected game!


.noa:
    btst.b  #CNT_B,p1_Repeat
    beq     .nob
    nop                                     ; B pressed

.nob:
    btst.b  #CNT_C,p1_Repeat
    beq     .noc
    nop                                     ; C pressed

.noc:
    btst.b  #CNT_D,p1_Current
    beq     .nod
    nop                                     ; D pressed
    move.b  RAM_ListMode,d0
    not.b   d0                              ; toggle 0 and 1 by inverting the byte
    move.b  d0,RAM_ListMode
    jsr     updateList
    
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
;
;------------------
    move.b  #TotalPages,d0                  ; 
    cmp.b   #1,d0                           ;
    beq     .noleft                         ; branch out if we only have 1 page

    move.b  RAM_CurrentIndex,d0             ; 
    tst.b   RAM_CurrentPage                 ; if we are on any other page than the first,
    bne     .LEFT_else                      ; just skip to the prev page

    cmp.b   #EntriesPerPage,d0              ; 
    bge     .LEFT_else                      ; if RAM_CurrentIndex >= EntriesPerPage, just skip to the prev page

                                            ; if (RAM_CurrentIndex < EntriesPerPage):
    move.b  #TotalListCount,d1              ; D1 = TotalListCount
    move.b  #EntriesPerPage,d2              ; D2 = EntriesPerPage
    sub.b   RAM_CurrentListPos,d2           ; D2 = EntriesPerPage - RAM_CurrentListPos
    sub.b   d2,d1                           ; D1 = TotalListCount - (EntriesPerPage - RAM_CurrentListPos)
    move.b  d1,d0                           ; D0 = NextIndex

    move.b  #GamesCount,d1                  ; D1 = GamesCount
    sub.b   #1,d1                           ; D1 = GamesCount - 1
    cmp.b   d1,d0                           ; Compare NextIndex to (GamesCount - 1)
    ble     .LEFT_done                      ; if NextIndex <= (GamesCount - 1), branch out

    move.b  d1,d0                           ; D0 = NextIndex = GamesCount - 1
    bra     .LEFT_done                      ; branch out

.LEFT_else:
    SUB.B   #EntriesPerPage,d0              ; D0 = RAM_CurrentIndex - EntriesPerPage
    bra     .LEFT_done                      ; 

.LEFT_done:

;------------------
;
    move.b  d0,RAM_CurrentIndex
    jsr     updateList

.noleft:
    btst.b  #CNT_RIGHT,p1_Repeat
    beq     .noright
    nop                                     ; RIGHT pressed
;-------------------------
    move.b  #TotalPages,d0 
    cmp.b   #1,d0 
    beq     .noright                        ; branch out if we only have 1 page

    move.b  RAM_CurrentIndex,d0
    move.b  RAM_CurrentPage,d1
    move.b  RAM_CurrentListPos,d2

    cmp.b   #TotalPages-1,d1
    beq     .lastPage
    cmp.b   #TotalPages-2,d1
    beq     .pageBeforeLastPage

    bra     .Right_defaultCase

    ; #EntriesPerPage
    ; #TotalPages
    ; #GamesCount
    ; #ListOverhead

    bra     .Right_end

.pageBeforeLastPage:
    ; if currentIndex+EntriesPerPage <= GamesCount-1 => default
    ; else d0=GamesCount-1
    add.b   #EntriesPerPage,d0
    cmp.b   #GamesCount-1,d0
    bls     .Right_defaultCase
    move.b  #GamesCount-1,d0
    bra     .Right_end

.lastPage:
    move.b  d2,d0
    bra     .Right_end

    ; if GamesCount > CurrentPos => d0=CurrentPos, else d0=GamesCount-1

.Right_defaultCase:
    move.b  RAM_CurrentIndex,d0
    add.b   #EntriesPerPage,d0

.Right_end:

;-------------------------                                            
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
