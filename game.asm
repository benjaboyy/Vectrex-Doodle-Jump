;==========================================================================
; VECTREX GAME CODE – RESTRUCTURED VERSION
;==========================================================================

                    include  "VECTREX.I"                  ; Include common definitions/macros

;==========================================================================
; SECTION 1: VARIABLE DEFINITIONS (BSS)
;==========================================================================

                    bss      
                    org      $c880 

;--- Game State Variables ---
Lives_Left          ds       1                            ; Number of lives remaining 
map_Height          ds       1 
deathscreen_count   ds       1 
track_frame         ds       1 

player_yx           ds       0                            ; Combined player coordinates storage 
player_y            ds       1                            ; Player Y position 
player_x            ds       1                            ; Player X position 

eye_frame           ds       1                            ; Counter for eye blink animation 
look_dir            ds       1                            ; Player facing direction (0=left, else right) 
jump_cycle          ds       1                            ; Jump counter for upward motion 
counter             ds       1                            ; General purpose counter 
score               ds       2                            ; Score value 
deathpit_height     ds       2                            ; Height at which player dies 

;--- Platform Data (Start & End Markers) ---
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

hitdetect_count     ds       1                            ; Counter for hit-detection loops 

;==========================================================================
; SECTION 2: CODE (Program Instructions)
;==========================================================================

                    code     
                    org      $0000 

;--- Magic Initialization Block ---
                    fcb      $67,$20 
                    fcc      "GCE 2018"
                    fcb      $80 
                    fdb      music 
                    fdb      $f850 
                    fdb      $30b8 
                    fcc      "GAME TEST"
                    fcb      $80,$0 

;==========================================================================
; ROUTINE: SETUP
; Initialize game variables, positions, and hardware settings
;==========================================================================
setup: 
                    lda      #05 
                    sta      track_frame 
                    sta      Lives_Left 
                    sta      score 

        ;--- Initialize Platforms & Player Starting Position ---
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

        ;--- Set Death-Pit Height ---
                    lda      #-127 
                    ldb      #-$00 
                    std      deathpit_height 

        ;--- Configure Display & Joystick ---
                    ldd      #$FC20                       ; Height, Width (-4, 32) 
                    std      Vec_Text_HW                  ; Store to BIOS RAM location 

                    lda      #1                           ; Setup joystick 1 (all directions) 
                    sta      Vec_Joy_Mux_1_X 
                    lda      #3 
                    sta      Vec_Joy_Mux_1_Y 

                    lda      #0                           ; Disable joystick 2 to save cycles 
                    sta      Vec_Joy_Mux_2_X 
                    sta      Vec_Joy_Mux_2_Y 

                    jmp      level                        ; Enter main game loop 


;==========================================================================
; ROUTINE: LEVEL (Main Game Loop)
;==========================================================================
level: 
                    jsr      Wait_Recal                   ; Reset CRT 
                    ldd      #0000                        ; Set starting coordinates (0,0) 
                    jsr      Moveto_d_7F                  ; Move to (x,y) 
                    lda      #$7f 
                    jsr      Intensity_a                  ; Set drawing intensity 

                    jsr      lives                        ; Draw remaining lives 

        ;--- Loop through each platform ---
                    ldu      #platformStartAddress 
platformLoop: 
                    ldd      ,u++                         ; Get platform position; U now points to next platform 
                    jsr      platform_draw                ; Draw the current platform 

                    cmpa     # -120                       ; Compare platform X coordinate (example threshold) 
                    bne      SkipRandomize 
                    jsr      Random                       ; Get a random number if condition met 
                    inca     
                    inca     
                    inca     
                    stb      ,u                           ; Update platform X coordinate 

SkipRandomize: 
                    cmpu     #platformEndAddress          ; Have we processed all platforms? 
                    bne      platformLoop 

                    jsr      player_draw                  ; Draw the player (including eyes animation) 
                    jsr      drop_height                  ; Update vertical positions (platforms and player) 

                    bra      level                        ; Repeat the main game loop 


;==========================================================================
; SUBROUTINE: drop_height
; Decrement vertical positions to simulate scrolling/falling
;==========================================================================
drop_height: 
                    dec      platform_1_y 

        ; (Additional drop logic for platform_1 may be added here)

                    dec      platform_2_y 
                    dec      platform_3_y 
                    dec      platform_4_y 
                    dec      platform_5_y 
                    dec      platform_6_y 
                    dec      platform_7_y 
                    dec      platform_8_y 
                    dec      platform_9_y 
                    dec      player_y                     ; Move the player downward 
                    rts      


;==========================================================================
; SUBROUTINE: platform_draw
; Expects platform position in D; uses X to load graphics pattern.
;==========================================================================
platform_draw: 
                    jsr      Moveto_d_7F                  ; Go to the platform's (x,y) 
                    ldx      #Platform                    ; Load pointer to platform graphics 
                    jsr      Draw_VLp                     ; Draw the platform graphic 
                    jsr      Reset0Ref                    ; Reset drawing reference 
                    rts      


;==========================================================================
; SUBROUTINE: player_draw
; Draws the player and handles eye animation.
;==========================================================================
player_draw: 
                    jsr      ifjoy                        ; Process joystick input (movement and jumping) 
                    jsr      Recalibrate                  ; Recalibrate if needed 

                    lda      player_y 
                    ldb      player_x 
                    jsr      Moveto_d_7F                  ; Position the player 
                    ldx      #Player 
                    jsr      Draw_VLp                     ; Draw the player graphic 

                    lda      look_dir                     ; Check player's facing direction 
                    beq      draw_left_eyes 
                    ldb      #-1                          ; Right facing: (if look_dir nonzero) 
                    bra      draw_right_eyes 


draw_left_eyes: 
                    ldb      #2                           ; Left facing indicator 
draw_right_eyes: 
                    lda      eye_frame 
                    beq      eye_blink                    ; If eye_frame zero, blink eyes 

                    deca     
                    beq      eye_blink 
                    deca     
                    beq      eye_blink 

        ;--- Draw Normal Eyes ---
                    lda      #10 
                    jsr      Moveto_d_7F 
                    ldx      #Eye1 
                    jsr      Draw_VLp 

                    ldx      #Eye2 
                    jsr      Draw_VLp 

                    lda      #-6 
                    ldb      #-8 
                    lda      eye_frame 
                    deca     
                    sta      eye_frame 
                    rts      


;==========================================================================
; SUBROUTINE: eye_blink
; Draws the blinking eye pattern.
;==========================================================================
eye_blink: 
                    lda      #11 
                    jsr      Moveto_d_7F 
                    ldx      #EyeBlink 
                    jsr      Draw_VLp 
                    lda      eye_frame 
                    beq      reset_eye_frame 
                    deca     
                    sta      eye_frame 
                    rts      


reset_eye_frame: 
                    lda      #130                         ; Wait frames until next blink 
                    sta      eye_frame 
                    rts      


;==========================================================================
; SUBROUTINE: ifjoy
; Processes joystick input for horizontal movement, jumping, or falling.
;==========================================================================
ifjoy: 
                    jsr      Joy_Digital                  ; Read joystick input 
                    lda      Vec_Joy_1_X                  ; Check horizontal (X) axis 
                    beq      X_Done                       ; No movement if zero 
                    bmi      Left_Move                    ; Negative => move left 

        ;--- Right Movement ---
Right_Move: 
                    ldb      player_x 
                    incb     
                    incb     
                    incb     
                    stb      player_x 
                    ldb      #$0                          ; Set look direction: right 
                    sta      look_dir 
                    bra      X_Done 


Left_Move: 
                    ldb      player_x 
                    decb     
                    decb     
                    decb     
                    stb      player_x 
                    ldb      #$01                         ; Set look direction: left 
                    sta      look_dir 

X_Done: 
                    jsr      Read_Btns                    ; Read button inputs 
                    cmpa     #$00                         ; No button pressed? 
                    beq      Fall                         ; Proceed to falling logic 

                    bita     #$01                         ; Button test (e.g., jump button) 
                    beq      No_Button                    ; If not pressed, do nothing extra 

                    lda      #17                          ; Set jump cycle counter 
                    sta      jump_cycle 
                    bra      Jump 


Fall: 
                    lda      jump_cycle                   ; Check if still in jump 
                    bne      Jump                         ; Continue jump if counter > 0 

        ;--- Hit Detection & Falling ---
                    lda      #$09                         ; Initialize hit detection loop counter 
                    sta      hitdetect_count 
                    ldu      #platform_1_yx               ; Point to first platform 
HitLoop: 
                    ldy      ,u++                         ; Load platform coordinate 
                    ldx      player_yx                    ; Load player's coordinate 
                    lda      #5 
                    ldb      #14 
                    jsr      Obj_Hit                      ; Check for collision 
                    bcs      No_Button                    ; If collision detected, exit loop 
                    dec      hitdetect_count 
                    bne      HitLoop 

        ; Check if the player is below the death pit
                    ldy      deathpit_height 
                    ldx      player_yx 
                    lda      #3 
                    ldb      #125 
                    jsr      Obj_Hit 
                    bhi      NotDead                      ; Continue if within bounds 

        ; Player has “died”
                    lda      #$01 
                    cmpa     Lives_Left 
                    beq      You_died                     ; If last life, go to death screen 
                    dec      Lives_Left 
                    ldd      #$5010 
                    std      player_yx                    ; Reset player position 
                    jmp      level 


NotDead: 
                    ldb      player_y                     ; Process falling: adjust vertical position 
                    decb     
                    decb     
                    decb     
                    decb     
                    stb      player_y 
                    bra      No_Button 


Jump: 
                    lda      jump_cycle 
                    beq      No_Button 
                    ldb      player_y 
                    incb     
                    incb     
                    incb     
                    incb     
                    stb      player_y                     ; Update player's Y for jump 
                    deca     
                    sta      jump_cycle 
                    bra      No_Button 


No_Button: 
                    rts      


;==========================================================================
; SUBROUTINE: lives
; Draws the life icons on the screen.
;==========================================================================
lives: 
                    lda      Lives_Left 
                    sta      counter 
                    lda      #117 
                    ldb      #-120 
                    jsr      Moveto_d_7F                  ; Set starting position for life icons 
Draw_Lives: 
                    ldx      #life 
                    jsr      Draw_VLp 
                    lda      #03 
                    ldb      #08 
                    jsr      Moveto_d_7F                  ; Move to next icon position 
                    dec      counter 
                    bne      Draw_Lives 
                    jsr      Reset0Ref                    ; Reset drawing reference after lives are drawn 
                    rts      


;==========================================================================
; SUBROUTINE: score_draw
; Displays the score.
;==========================================================================
score_draw: 
                    jsr      Moveto_d_7F                  ; Set position for score display 
        ; (Conversion of SCORE to ASCII could be added here)
                    ldu      #score_string                ; Load pointer to score string 
                    lda      #117 
                    ldb      #120 
                    jsr      Print_Str_d                  ; Print score string using BIOS routine 
                    rts      


;==========================================================================
; SUBROUTINE: You_died
; Display the "YOU DIED" message and then reset the game.
;==========================================================================
You_died: 
                    lda      #$05 
                    sta      deathscreen_count 
Died_Loop: 
                    jsr      Wait_Recal                   ; Reset CRT 
                    ldd      #0000 
                    jsr      Moveto_d_7F 
                    ldu      #died_text 
                    jsr      Print_Str_d                  ; Display death text 
                    dec      deathscreen_count 
                    bra      Died_Loop 

                    lda      #$05 
                    sta      Lives_Left 
                    jmp      setup 


;==========================================================================
; SECTION 3: DATA (Strings, Music, and Graphics)
;==========================================================================

died_text: 
                    DB       "YOU DIED"
                    DB       $80                          ; End-of-string marker 

score_string: 
                    DB       "123456"                     ; Example score (only capital letters)
                    DB       $80                          ; End-of-string marker 

;--- Music Data ---
music: 
                    fdb      $fee8 
                    fdb      $feb6 
                    fcb      $0,$80 
                    fcb      $0,$80 

;--- Graphics Data ---
Player: 
                    DB       $FF, +$00, +$06 
                    DB       $FF, +$02, +$02 
                    DB       $FF, +$0B, +$00 
                    DB       $FF, +$02, -$02 
                    DB       $FF, +$00, -$06 
                    DB       $FF, -$02, -$02 
                    DB       $FF, -$0B, +$00 
                    DB       $FF, -$02, +$02 
                    DB       $00, +$04, -$02 
                    DB       $FF, -$01, -$04 
                    DB       $FF, +$03, +$00 
                    DB       $FF, -$01, +$04 
                    DB       $FF, +$00, +$0A 
                    DB       $FF, +$01, +$04 
                    DB       $FF, -$03, +$00 
                    DB       $FF, +$01, -$04 
                    DB       $00, -$06, -$07 
                    DB       $FF, -$03, -$01 
                    DB       $FF, +$00, +$02 
                    DB       $FF, +$03, -$01 
                    DB       $00, +$00, +$04 
                    DB       $FF, -$03, -$01 
                    DB       $FF, +$00, +$02 
                    DB       $FF, +$03, -$01 
                    DB       $01                          ; End marker 

Platform: 
                    DB       $00, -$05, -$05 
                    DB       $FF, +$00, +$14 
                    DB       $FF, +$04, +$04 
                    DB       $FF, +$00, -$1C 
                    DB       $FF, -$04, +$04 
                    DB       $01                          ; End marker 

Eye1: 
                    DB       $FF, +$03, +$00 
                    DB       $FF, +$00, -$02 
                    DB       $FF, -$03, +$00 
                    DB       $FF, +$00, +$02 
                    DB       $01 

Eye2: 
                    DB       $00, +$00, -$03 
                    DB       $FF, +$03, +$00 
                    DB       $FF, +$00, -$02 
                    DB       $FF, -$03, +$00 
                    DB       $FF, +$00, +$02 
                    DB       $01 

EyeBlink: 
                    DB       $FF, +$00, -$02 
                    DB       $00, +$00, -$03 
                    DB       $FF, +$00, +$02 
                    DB       $00, -$01, +$00 
                    DB       $01 

life: 
                    DB       $01, -$03, -$02 
                    DB       $FF, +$01, -$01 
                    DB       $FF, +$03, +$00 
                    DB       $FF, +$01, +$01 
                    DB       $FF, +$00, +$01 
                    DB       $FF, -$01, +$01 
                    DB       $FF, -$03, +$00 
                    DB       $FF, -$01, -$01 
                    DB       $FF, +$00, -$01 
                    DB       $01, -$01, -$03 
                    DB       $FF, +$00, +$03 
                    DB       $02 

;==========================================================================
; END OF PROGRAM
;==========================================================================
