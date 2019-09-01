                 include  "VECTREX.I"                  ; This is an include file, when you run the assembler, Imagine it is as if the contents of the .I file 
                    bss      
                    org      $c880 
Lives_Left          ds       1 
map_Height          ds       1 
deathscreen_count	  ds		  1
track_frame         ds       1 
player_yx           ds       0 
player_y            ds       1 
player_x            ds       1 
eye_frame           ds       1 
look_dir            ds       1 
jump_cycle          ds       1 
counter			  ds       1
score     		  ds       2
deathpit_height	  ds       2
;
platformStartAddress 
platform_1_yx       ds       0 
platform_1_y        ds       1 
platform_1_x        ds       1 
platform_2_yx       ds       0 
platform_2_y        ds       1 
platform_2_x        ds       1 
platform_3_yx       ds       0 
platform_3_y        ds       1 
platform_3_x        ds       1 
platform_4_yx       ds       0 
platform_4_y        ds       1 
platform_4_x        ds       1 
platform_5_yx       ds       0 
platform_5_y        ds       1 
platform_5_x        ds       1 
platform_6_yx       ds       0 
platform_6_y        ds       1 
platform_6_x        ds       1 
platform_7_yx       ds       0 
platform_7_y        ds       1 
platform_7_x        ds       1 
platform_8_yx       ds       0 
platform_8_y        ds       1 
platform_8_x        ds       1 
platform_9_yx       ds       0 
platform_9_y        ds       1 
platform_9_x        ds       1 
platformEndAddress 
hitdetect_count     ds       1 
                    code     
                    org      $0000 
; Magic Init Block
                    fcb      $67,$20 
                    fcc      "GCE 2018"
                    fcb      $80 
                    fdb      music 
                    fdb      $f850 
                    fdb      $30b8 
                    fcc      "GAME TEST"
                    fcb      $80,$0

setup: 
                    lda      #05 
                    sta      track_frame 
				  sta	  Lives_Left
 				  sta	  score
                    ldd      #$1010 
                    std      platform_1_yx 
                    std      player_yx 
                    ldd      #$3030 
                    std      platform_2_yx 
                    lda      #$50
				  ldb      #-$40
                    std      platform_3_yx 
                    ldd      #$7050 
                    std      platform_4_yx 
                    lda      #$90
				  ldb      #-$20 
                    std      platform_5_yx 
                    lda      #$a0
				  ldb      #$20 
                    std      platform_6_yx 
                    lda      #$c0
				  ldb      #$60 
                    std      platform_7_yx 
                    lda      #$e0
				  ldb      #-$80
                    std      platform_8_yx 
                    lda      #$ff
				  ldb      #-$20 
                    std      platform_9_yx 
                    lda      #-127
				  ldb      #-$00 
				  std	  deathpit_height 		    ; set death-pit height
                    ldd      #$FC20                       ; HEIGTH, WIDTH (-4, 32) 
                    std      Vec_Text_HW                  ; store to BIOS RAM location 
                    lda      #1                           ; these set up the joystick 
                    sta      Vec_Joy_Mux_1_X              ; enquiries 
                    lda      #3                           ; allowing only all directions 
                    sta      Vec_Joy_Mux_1_Y              ; for joystick one 
                    lda      #0                           ; this setting up saves a few 
                    sta      Vec_Joy_Mux_2_X              ; hundred cycles 
                    sta      Vec_Joy_Mux_2_Y              ; don't miss it, if you don't need the second joystick! 
;MAP PLAN
;eerst laad hij platformen tot de top
;houd vervolgens de couter bij van de scroll
;op basis van andere waarden tekent er een nieuw platform bij
;kijkt of er plafromen onderin weg gehaald moeten worden

level: 
                    jsr      Wait_Recal                   ;Reset the CRT 
                    ldd      #0000                        ;Get x,y 
                    jsr      Moveto_d_7F                  ;go to (x,y) 
                    lda      #$7f                         ;Get the Intensity 
                    jsr      Intensity_a                  ;Set intensitywaqs 
                    jsr      lives                ;Draw amount lives left 
; loop thru all platforms
; start at forst platform 
                    ldu      #platformStartAddress 
platformLoop 
                    ldd      ,u++                         ; load next position, and increment U by 2, so U after this points to the next platform position 
                    jsr      platform_draw                ;Draw platform 1 
					cmpa	 	#-120						;compair with platform_X
					bne		 #geenwissel					;branch if not
					jsr		 Random						;take a random number
					inca
					inca
					inca
					stb	 	 ,u							;write it to platform_x
geenwissel	
                    cmpu     #platformEndAddress          ; is u pointing to "platform finished" - 
                    bne      platformLoop                 ; no? that print next platform 
                    jsr      player_draw                  ;jump to drawing the player 
                    jsr      drop_height                  ;makes the height drop once a recal 
				
                    bra      level 

drop_height: 
				  dec	  platform_1_y

 ;not done//

				  
;                    lda      #$09                         ;Initialise our loop 
;                    sta      hitdetect_count              ;variable with a value of 5 
;                    ldu      #platform_1_yx               ; this time we don't bother with the extra variable, we just take the address of the first data 
;deathpitloop: 										; is the loop with mixes the plates when off screen
;                    ldy      ,u++                         ; load directly to y 
;                    ldx      deathpit_height              ; load directly to x
;                    lda      #10 
;                    ldb      #10 
;                    jsr      Obj_Hit 
;                    bne      deathpitloop 

 ;//not done

                    dec      platform_2_y 
                    dec      platform_3_y 
                    dec      platform_4_y 
                    dec      platform_5_y 
                    dec      platform_6_y 
                    dec      platform_7_y 
                    dec      platform_8_y 
                    dec      platform_9_y 
                    dec      player_y 
                    rts  

; expects position of platform in D
; uses egister X  
platform_draw: 
                    jsr      Moveto_d_7F                  ;go to (x,y) 
                    ldx      #Platform 
                    jsr      Draw_VLp                     ;Draw platform 1 
                    jsr      Reset0Ref                    ; go back to zero after platform is drawn 
                    rts                                   ;done drawing so lets go back 

player_draw: 
                    jsr      ifjoy 
                    jsr      Recalibrate 
                    lda      player_y 
                    ldb      player_x 
                    jsr      Moveto_d_7F                  ;go to (x,y) 
                    ldx      #Player 
                    jsr      Draw_VLp 
                    lda      look_dir 
                    beq      links_kijken 
                    ldb      #-1 
                    bra      recht_kijken 

links_kijken: 
                    ldb      #2 
recht_kijken: 
                    lda      eye_frame 
                    beq      eye_blink                    ;If the loop variable is not Zero, jump to loop_start 
                    deca     
                    beq      eye_blink 
                    deca     
                    beq      eye_blink 
                                                          ;draw eye 1 
                    lda      #10 
                    jsr      Moveto_d_7F 
                    ldx      #Eye1 
                    jsr      Draw_VLp 
                                                          ;draw eye 2 
                    ldx      #Eye2 
                    jsr      Draw_VLp 
                    lda      #-6 
                    ldb      #-8 
                    lda      eye_frame 
                    deca     
                    sta      eye_frame 
                    rts      

eye_blink:                                                ;Draw    blink 1 
                    lda      #11 
                    jsr      Moveto_d_7F 
                    ldx      #EyeBlink 
                    jsr      Draw_VLp 
                    lda      eye_frame 
                    beq      off 
                    deca     
                    sta      eye_frame 
                    rts      

off: 
                    lda      #130                         ;Initialise our loop (frames to wait till nect blink) 
                    sta      eye_frame                    ;tracking before next blink 
                    rts      

ifjoy: 
                    jsr      Joy_Digital                  ; read joystick positions 
                    lda      Vec_Joy_1_X                  ; load joystick 1 position 
                                                          ; X to A 
                    beq      x_done                       ; if zero, than no x position 
                    bmi      left_move                    ; if negative, than left otherwise right 
right_move:                                               ;        when right input is detected 
                    ldb      player_x                     ; get current horizontal 
                    incb     
                    incb     
                    incb     
                    stb      player_x                     ; update player position 
                    ldb      #$0 
                    stb      look_dir                     ; define player looking right 
                    bra      x_done                       ; goto x done 

left_move: 
                    ldb      player_x 
                    decb     
                    decb     
                    decb     
                    stb      player_x 
                    ldb      #$01 
                    stb      look_dir 
                    bra      x_done                       ; goto x done 

x_done: 
                    jsr      Read_Btns                    ; get button status 
                    cmpa     #$00                         ; is a button pressed? 
                    beq      fall                         ; no, than go on 
                    bita     #$01                         ; test for button 1 2 
                    beq      no_button                    ; if not pressed jump(so button 1 is pressed) 
                    lda      #17                          ; amount of 'frames' 
                    sta      jump_cycle                   ; set jump counter 
                    bra      jump                         ; jump to, move player up 
                    bra      no_button                    ; go to the end 

fall: 
                    lda      jump_cycle                   ; get jump 'frames' 
                    bne      jump                         ; jump if player is still jumping 
                    lda      #$09                         ;Initialise our loop 
                    sta      hitdetect_count              ;variable with a value of 5 
                    ldu      #platform_1_yx               ; this time we don't bother with the extra variable, we just take the address of the first data 
hitloop: 
                    ldy      ,u++                         ; load directly to y - no need to TFR 
                    ldx      player_yx                    ; load directly to x,no need to do a TFR 
                    lda      #5 
                    ldb      #14 
                    jsr      Obj_Hit 
                    bcs      no_button                    ; if Carry flag is set -> than a hit occured! 
                    dec      hitdetect_count              ; can be decremented directly - > flags will be set correctly! 
                    bne      hitloop 					; not hit try next one				  
				  
				  ldy 	  deathpit_height
				  ldx      player_yx                    ; load directly to x,no need to do a TFR 
				  lda      #3 
                    ldb      #125 
                    jsr      Obj_Hit 
				  bhi      notdead 					; not out of bounds	
				  lda	  #$01
				  cmpa	  Lives_Left
				  beq	  You_died
				  dec	  Lives_Left	
                    ldd      #$5010	
				  std      player_yx 				  	
				  jmp	  level	  

notdead:
                    ldb      player_y                     ; the players vertical position (falling)
                    decb     
                    decb     
                    decb     
                    decb     
                    stb      player_y                     ; hoogte van player verandert 
                    bra      no_button 

jump: 
                    lda      jump_cycle 
                    beq      no_button 
                    ldb      player_y 
                    incb     
                    incb     
                    incb     
                    incb     
                    stb      player_y 
                    deca     
                    sta      jump_cycle 
                    bra      no_button 

no_button: 
                    rts    
;start lives
lives:											;Look amount of lives then draw that
				  lda	  Lives_Left
				  sta	  counter
                    lda      #117 
				  ldb      #-120
                    jsr      Moveto_d_7F                  ;go to (x,y)   
draw_lives			
				  ldx      #life			  
                    jsr      Draw_VLp 		 
                    lda      #03 
				  ldb      #08
                    jsr      Moveto_d_7F                  ;go to (x,y)   
				  dec 	  counter              
				  bne 	  draw_lives				;branch not equel
                    jsr      Reset0Ref                    ; go back to zero after platform is drawn 
				  ;rts
;end lives
score_draw:											;Look amount of lives then draw that
                    jsr      Moveto_d_7F                  ;go to (x,y)   
				 ;ldd      score
	 			  ldu      #score_string     		; address of string
                    lda      #117 
				  ldb      #120
		 		  jsr   	  Print_Str_d             		; Vectrex BIOS print routine
       			  rts
You_died:		 
				lda		#$05
				sta		deathscreen_count
died_loop:
				jsr      Wait_Recal                   ;Reset the CRT
              	ldd      #0000
				jsr      Moveto_d_7F                  ;go to (x,y)  
				ldu      #died_text     		; address of string
		 		jsr   	  Print_Str_d             		; Vectrex BIOS print routine
				dec 	  deathscreen_count              
    				bra 	  died_loop				;branch not equel
    				lda	  #$05
				sta	  Lives_Left
				jmp	  setup				

died_text:
                DB   "YOU DIED"
                DB   $80
	
score_string:
                DB   "123456"     		         ; only capital letters
                DB   $80                        ; $80 is end of string
				    

;kill_player:
;        dec   Lives_Left    ;Decrement the number of lives left by 1
;        beq   game_over     ;Check if that was the last live, jump if so
;        rts
music: 
                    fdb      $fee8 
                    fdb      $feb6 
                    fcb      $0,$80 
                    fcb      $0,$80 
Player: 
                    DB       $FF, +$00, +$06              ; pattern, y, x 
                    DB       $FF, +$02, +$02              ; pattern, y, x 
                    DB       $FF, +$0B, +$00              ; pattern, y, x 
                    DB       $FF, +$02, -$02              ; pattern, y, x 
                    DB       $FF, +$00, -$06              ; pattern, y, x 
                    DB       $FF, -$02, -$02              ; pattern, y, x 
                    DB       $FF, -$0B, +$00              ; pattern, y, x 
                    DB       $FF, -$02, +$02              ; pattern, y, x 
                    DB       $00, +$04, -$02              ; pattern, y, x 
                    DB       $FF, -$01, -$04              ; pattern, y, x 
                    DB       $FF, +$03, +$00              ; pattern, y, x 
                    DB       $FF, -$01, +$04              ; pattern, y, x 
                    DB       $FF, +$00, +$0A              ; pattern, y, x 
                    DB       $FF, +$01, +$04              ; pattern, y, x 
                    DB       $FF, -$03, +$00              ; pattern, y, x 
                    DB       $FF, +$01, -$04              ; pattern, y, x 
                    DB       $00, -$06, -$07              ; pattern, y, x 
                    DB       $FF, -$03, -$01              ; pattern, y, x 
                    DB       $FF, +$00, +$02              ; pattern, y, x 
                    DB       $FF, +$03, -$01              ; pattern, y, x 
                    DB       $00, +$00, +$04              ; pattern, y, x 
                    DB       $FF, -$03, -$01              ; pattern, y, x 
                    DB       $FF, +$00, +$02              ; pattern, y, x 
                    DB       $FF, +$03, -$01              ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
Platform: 
                    DB       $00, -$05, -$05              ; pattern, y, x 
                    DB       $FF, +$00, +$14              ; pattern, y, x 
                    DB       $FF, +$04, +$04              ; pattern, y, x 
                    DB       $FF, +$00, -$1C              ; pattern, y, x 
                    DB       $FF, -$04, +$04              ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
Eye1: 
                    DB       $FF, +$03, +$00              ; pattern, y, x 
                    DB       $FF, +$00, -$02              ; pattern, y, x 
                    DB       $FF, -$03, +$00              ; pattern, y, x 
                    DB       $FF, +$00, +$02              ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
Eye2: 
                    DB       $00, +$00, -$03              ; pattern, y, x 
                    DB       $FF, +$03, +$00              ; pattern, y, x 
                    DB       $FF, +$00, -$02              ; pattern, y, x 
                    DB       $FF, -$03, +$00              ; pattern, y, x 
                    DB       $FF, +$00, +$02              ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
EyeBlink: 
                    DB       $FF, +$00, -$02              ; pattern, y, x 
                    DB       $00, +$00, -$03              ; pattern, y, x 
                    DB       $FF, +$00, +$02              ; pattern, y, x 
                    DB       $00, -$01, +$00              ; pattern, y, x 
                    DB       $01                          ; endmarker (high bit in pattern not set) 
life:
                    DB $01, -$03, -$02 ; sync and move to y, x
                    DB $FF, +$01, -$01 ; draw, y, x
                    DB $FF, +$03, +$00 ; draw, y, x
                    DB $FF, +$01, +$01 ; draw, y, x
                    DB $FF, +$00, +$01 ; draw, y, x
                    DB $FF, -$01, +$01 ; draw, y, x
                    DB $FF, -$03, +$00 ; draw, y, x
                    DB $FF, -$01, -$01 ; draw, y, x
                    DB $FF, +$00, -$01 ; draw, y, x
                    DB $01, -$01, -$03 ; sync and move to y, x
                    DB $FF, +$00, +$03 ; draw, y, x
                    DB $02 ; endmarker 

