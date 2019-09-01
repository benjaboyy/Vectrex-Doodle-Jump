track_frame 	equ $C880

box:
		ldb   #4
		lda   #10
		jsr   Moveto_d_7F           ;go to (x,y)
        lda   #2					;Get y
        ldb   #6					;Get x
        jsr   Moveto_d_7F           ;go to (x,y)
        lda   #8					;Get y
        ldb   #00					;Get x
        jsr   Draw_Line_d			;draw a line to (x,y)
		lda   #-3					;Get y
        ldb   #-3					;Get x
        jsr   Draw_Line_d			;draw a line to (x,y)
		lda   #3					;Get y
        ldb   #3					;Get x
        jsr   Moveto_d_7F			;go to (x,y)
		lda   #-3					;Get y
        ldb   #3					;Get x
        jsr   Draw_Line_d			;draw a line to (x,y)
		lda   #-7					;Get y
        ldb   #-9					;Get x
        jsr   Moveto_d_7F           ;go to (x,y)
		lda	  track_frame
		lbeq  box_fr				;jump1 if 0
		lda   track_frame
		deca
		lbeq  box_fr2  			;jump2 if 0
		sta   track_frame
		rts

		
box_fr:
        lda   #00                   ;Get y
        ldb   #12                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #12                   ;Get y
        ldb   #00                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #00                   ;Get y
        ldb   #-12                  ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #-12                  ;Get y
        ldb   #00                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
		lda   #02
		sta   track_frame
		rts
		
box_fr2:
		sta   track_frame
		ldb   #-2
		lda   #-2
		jsr   Moveto_d_7F           ;go to (x,y)
        lda   #00                   ;Get y
        ldb   #16                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #16                   ;Get y
        ldb   #00                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #00                   ;Get y
        ldb   #-16                  ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
        lda   #-16                  ;Get y
        ldb   #00                   ;Get x
        jsr   Draw_Line_d           ;draw a line to (x,y)
		ldb   #2
		lda   #2
		jsr   Moveto_d_7F           ;go to (x,y)
		rts