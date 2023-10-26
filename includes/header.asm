	org  $0000
	dc.l $10F300							; Initial SP
	dc.l $C00402							; Initial PC

	org  $0064
	dc.l VBLANK								; IRQ handler

	org  $0100
	dc.b "NEO-GEO",$00

	org  $0108
	dc.w $1234								; NGH
	dc.l $00100000    						; P ROM size

	org  $0114
	dc.b $00  								; Eyecatcher animation flag. 0=Done by system ROM, 1=Done by game, 2=Nothing.
	dc.b $00  								; Sprite bank number (upper 8 bits of tile number) for the eye-catcher logo, if done by system ROM.

	dc.l JPConfig     						; JP config menu pointer
    dc.l USConfig     						; US config menu pointer
    dc.l USConfig     						; EU config menu pointer

	org $0122
	jmp Game								; JMP to USER subroutine (code start).

	org  $0182
	dc.l Code								; Pointer to security code (second cartridge recognition code).
	even
Code:
	dc.l $76004A6D,$0A146600,$003C206D,$0A043E2D
	dc.l $0A0813C0,$00300001,$32100C01,$00FF671A
	dc.l $30280002,$B02D0ACE,$66103028,$0004B02D
	dc.l $0ACF6606,$B22D0AD0,$67085088,$51CFFFD4
	dc.l $36074E75,$206D0A04,$3E2D0A08,$3210E049
	dc.l $0C0100FF,$671A3010,$B02D0ACE,$66123028
	dc.l $0002E048,$B02D0ACF,$6606B22D,$0AD06708
	dc.l $588851CF,$FFD83607
	dc.w $4e75

