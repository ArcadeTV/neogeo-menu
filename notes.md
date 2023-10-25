Write NGH.w to $2C0FEE and reset to launch games.
(Instructions must be copied and called from RAM)

```
100200: move.w  D0, $2c0fee.l
100206: nop
100208: reset
```

Chinese Menu checks for button inputs and sets 0|1 flag in
$108104 to $108107 (RAM).
Game-launch is then starting from $FF000 (ROM)

```
0E036C: jmp     $ff000.l
0FF000: move    #$2700, SR  ; disable Interrupts
```


Complete instructions for game launch on chinese menu:

```
loc_000E0372:
0E0372: movem.l (sp)+,d0-d7/a0-a6           ; restore registers
0E0376: rte                                 ; return from exception
; -------------------------------------------
0FF000: move    #$2700, SR                  ; disable Interrupts
0FF004: nop     ; x20 <-----------          ; 20 nops
...
0FF02C: jsr     $ff246.l

sub_ff246:
0FF246: movem.l D0-D7/A0-A6, -(A7)          ; save registers
0FF24A: move.b  D0, $3a001d.l               ; REG_SRAMUNLOCK: Unprotects backup RAM (MVS)
0FF250: lea     $d08000.l, A4               ; EXT_00AD
0FF256: lea     (-$7edc,A4), A3             ; load address $d08000-$7edc=$D00124 in a3
0FF25A: move.b  #$7, D1                     ; set counter 8-1 in d1
0FF25E: move.b  D0, $300001.l               ; kick Watchdog
0FF264: move.l  #$ffff, (A3)+               ; move 0x0000ffff in ($D00124)+
0FF26A: dbra    D1, $ff25e                  ; repeat 8 times

   (loop)

0FF26E: nop     ; x75 <-----------          ; 75 nops
...
0FF304: movem.l (A7)+, D0-D7/A0-A6          ; restore registers
0FF308: rts                                 ; return from subroutine
sub_ff246_end:

0FF032: nop
0FF034: nop
0FF036: nop
0FF038: move.w  $108004.l, D3               ; Arrow position -|
0FF03E: move.w  $108002.l, D2               ; List offset    -|
0FF044: add.w   D2, D3                      ;                 |  
0FF046: addi.w  #$1, D3                     ;                 |-> sum+1=listNumber
0FF04A: cmpi.w  #$a2, D3                    ; compare listNumber to $a2(#162)
0FF04E: bge     $ff056                      ; greater than or Equal? jump to loc_000E0372 when true
0FF052: bra     $ff05c                      ; skip next opcode
0FF056: jmp     loc_000E0372                ; jump to E0372 (see above)
0FF05C: move.w  D3, D0                      ; copy listNumber in d0 for game launch
0FF05E: lea     $100200.l, A0               ; address in ram for copying launch code
0FF064: movea.l A0, A1                      ; make a copy in a1 for jump
0FF066: move.l  #$33c0002c, (A0)+           ; -|
0FF06C: move.l  #$fee4e71, (A0)+            ; -|
0FF072: move.l  #$4e704ef9, (A0)+           ; -|
0FF078: move.l  #$c00402, (A0)              ; -|-> copy opcodes (see below) to RAM
0FF07E: jmp     (A1)                        ; jump to code starting at $100200 (RAM)

100200: move.w  D0, $2c0fee.l               ; send listNumber to CPLD
100206: nop                                 ; wait a little
100208: reset                               ; trigger a reset in the M68K
10020A: jmp     $c00402.l                   ; jump to "Reset Exception Vector" (same as ROM:00000004)
```