	org $0000
	dc.l $10F300
	dc.l $C00402

	org $0064
	dc.l VBLANK	;IRQ handler

	org $0100
	dc.b "NEO-GEO",$00

	org $0108
	dc.w $1234	;NGH

	org $0122
	jmp USER	;entry

	org $0114
	dc.w $0100	;logo flag, don't show it just go straight to the entry point

	org $0182
	dc.l Code	;code pointer
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
