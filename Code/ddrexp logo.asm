	include "VECTREX.I"		; This is an include file, when you run the assembler, Imagine it is as if the contents of the .I file 

        org     $0000

; Magic Init Block

        fcb     $67,$20
        fcc     "GCE XXXX"
        fcb     $80
        fdb     music
        fdb     $f850
        fdb     $30b8
        fcc     "EXP LOGO"
        fcb     $80,$0
start:

;Draws a big line from the middle of screen to right edge.
draw_line:
        jsr   Wait_Recal                 ;Reset the CRT
        lda   #0                       ;Get y
        ldb   #0                       ;Get x
        jsr   Moveto_d_7F           		;go to (x,y)
        lda   #$7f                      ;Get the Intensity
        jsr   Intensity_a            ;Set intensity
        lda   #19                       ;Get y
        ldb   #35                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
        lda   #15                       ;Get y
        ldb   #-4                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-4                       ;Get y
        ldb   #-13                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-4                       ;Get y
        ldb   #6                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-12                       ;Get y
        ldb   #-8                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #17                       ;Get y
        ldb   #-32                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #34                       ;Get y
        ldb   #18                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-8                       ;Get y
        ldb   #14                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-7                       ;Get y
        ldb   #-4                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #4                       ;Get y
        ldb   #13                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #16                       ;Get y
        ldb   #-4                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #0                       ;Get y
        ldb   #-42                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-43                       ;Get y
        ldb   #-16                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-26                       ;Get y
        ldb   #36                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #14                       ;Get y
        ldb   #17                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #3                       ;Get y
        ldb   #17                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #$0                      ;Get the Intensity
        jsr   Intensity_a            ;Set intensity
		lda   #-3                       ;Get y
        ldb   #-17                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #$7f                      ;Get the Intensity
        jsr   Intensity_a            ;Set intensity
		lda   #12                       ;Get y
        ldb   #-53                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #4                       ;Get y
        ldb   #21                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #38                       ;Get y
        ldb   #-5                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #-5                       ;Get y
        ldb   #23                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #$0                      ;Get the Intensity
        jsr   Intensity_a            ;Set intensity
		lda   #-8                       ;Get y
        ldb   #14                     ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda   #$7f                      ;Get the Intensity
        jsr   Intensity_a            ;Set intensity
		lda   #13                       ;Get y
        ldb   #6                      ;Get x
        jsr   Draw_Line_d                 ;draw a line to (x,y)
		lda 	  #$F1 					; HEIGTH (big=-14)
		ldb 	  #$60 					; WIDTH (big=96)
		sta 	  Vec_Text_Height			; store heigth
		stb 	  Vec_Text_Width 			; store width
		ldu   #hello_world_string     ; address of string
		lda   #-80                    ; Text position relative Y
		ldb   #-83                  ; Text position relative X
		jsr   Print_Str_d             ; Vectrex BIOS print routine
        bra   draw_line
		
hello_world_string:
                db   "DDR-EXP"              ; only capital letters
                db   $80                        ; $80 is end of string
;***************************************************************************
                end  draw_line 

music:
        fdb     $fee8
        fdb     $feb6
        fcb     $0,$80
        fcb     $0,$80