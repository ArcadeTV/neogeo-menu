; [System related]
FLAGS                   equ $100000
MODE                    equ $100001
HANDLERS                equ $100002

; [MENU related]
RAM_CurrentPage	        equ $100006	; (byte) Current Page	  
RAM_CurrentIndex        equ $100007	; (byte) Current Index  
RAM_CurrentListPos      equ $100008	; (byte) Current List Position
RAM_CurrentListPosR     equ $100009	; (byte) Current List Position in Counter (reversed order)
RAM_ListMode            equ $10000A	; (byte) List Mode flag
RAM_GAMELAUNCH          equ $100200 ; (instructions) Location of Gamelaunch

; copies of registers used for drawing updates
; [Player 1]
p1_Status			    equ $100010	; (byte) Controller status
p1_Previous			    equ $100011	; (byte) Previous frame's inputs (DCBArldu)
p1_Current			    equ $100012	; (byte) Current frame's inputs (DCBArldu)
p1_Change			    equ $100013	; (byte) Active edge inputs (DCBArldu)
p1_Repeat			    equ $100014	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p1_Timer			    equ $100015	; (byte) Input repeat timer

; [Player 2]
p2_Status			    equ $100020	; (byte) Controller status
p2_Previous			    equ $100021	; (byte) Previous frame's inputs (DCBArldu)
p2_Current			    equ $100022	; (byte) Current frame's inputs (DCBArldu)
p2_Change			    equ $100023	; (byte) Active edge inputs (DCBArldu)
p2_Repeat			    equ $100024	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p2_Timer			    equ $100025	; (byte) Input repeat timer

; [System Stuff]
sys_StatusA			    equ $100050	; (byte) Coins (xxx43S21)
sys_StatCurrent		    equ $100051	; (byte) Current frame's Select and Start (BIOS_STATCURNT_RAW)
sys_StatChange		    equ $100052	; (byte) Active edge Select and Start (BIOS_STATCHANGE_RAW)
sys_InputTT1		    equ $100053	; (byte) 
sys_InputTT2		    equ $100054	; (byte) 
sys_Dipswitches		    equ $100055	; (byte) (REG_DIPSW)
BIOS_STATCURNT_RAW      equ $10FEDC ; (byte) raw version of BIOS_STATCURNT (includes Select on MVS) (a.k.a. "INPUT_SS")
BIOS_STATCHANGE_RAW     equ $10FEDD ; (byte) raw version of BIOS_STATCHANGE (includes Select on MVS)
BIOS_INPUT_TT1          equ $10FEDE ; (byte)
BIOS_INPUT_TT2          equ $10FEDF ; (byte)
