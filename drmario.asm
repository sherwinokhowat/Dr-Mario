################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Sherwin Okhowat, 1010296225
# Student 2: Yimin Sun, 1010116143
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       1
# - Unit height in pixels:      1
# - Display width in pixels:    256
# - Display height in pixels:   200
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################

##############################################################################
# Macros
##############################################################################

    # Macro for pushing temporary registers onto the stack
    .macro push_temps()
            push($t0)
            push($t1)
            push($t2)
            push($t3)
            push($t4)
            push($t5)
            push($t6)
            push($t7)
            push($t8)
            push($t9)
    .end_macro
    
    # Macro for popping temporary registers from the stack
    .macro pop_temps()
        pop($t9)
        pop($t8)
        pop($t7)
        pop($t6)
        pop($t5)
        pop($t4)
        pop($t3)
        pop($t2)
        pop($t1)
        pop($t0)
   .end_macro

    # Push the value stored in %r onto the stack
    # Arguments: 
    # - %r: The register to push onto the stack
    .macro push(%r)
        addi $sp, $sp, -4
        sw %r, 0($sp) 
    .end_macro
    
    # Push the value %v onto the stack using register %r
    # Arguments: 
    # - %r: The register used to push
    # - %v: The value to push
    .macro pushi(%r, %v)
        addi $sp, $sp, -4
        li %r, %v
        sw %r, 0($sp)
    .end_macro
    
    # pops and puts on register %r
    # Pops the top value on the stack and stores it in register %r
    # Arguments:
    # - %r: The register to store the popped value in
    .macro pop(%r)
        lw %r, 0($sp)
        addi $sp, $sp, 4
    .end_macro
    
    .data
##############################################################################
# Immutable Data
##############################################################################
# Allocate space at 0x10010000 so that bitmap at 0x10008000 won't overflow to other variables
_: .word 1:100000

# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000

# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

# how many pixels wide is the bitmap
SCREEN_WIDTH: 
    .word 256

# how many pixels tall is the bitmap
SCREEN_HEIGHT:
    .word 200

# how units tall is the game
GAME_HEIGHT:
    .word 16

# how units wide is the game
GAME_WIDTH:
    .word 8

# how many pixels is 1 unit in the game
PIXELS_PER_GAME_UNIT:
    .word 8
    
# top left corner of the game in screen pixels
GAME_SCREEN_X:
    .word 24

# top left corner of the game in screen pixels
GAME_SCREEN_Y:
    .word 40
    
##############################################################################
# Mutable Data
##############################################################################
draw_rectangle_colour_array:
    .word 0:100000 # 0:num of pixels of screen (width * height)
    
# bitmap to draw the bottle
bottle_bitmap:
    .word 0:1000 # 0: width * height of the bottle
   
# bitmap to draw the actual game (playing field)
game_bitmap:
    .word 0:1000 # 0: width * height of the game

draw_bitmap_array:
    .word 0:100000
    
# capsule x coordinate in game units
capsule_x:
    .word 0

# capsule y coordinate in game units
capsule_y:
    .word 0
    
# check whether we need to load a capsule
capsule_needed:
    .byte 1
    
# check whether we are loading the capsule
capsule_loaded:
    .byte 0

##############################################################################
# Code
##############################################################################
	.text
	.globl main

# Run the game.
main:
    jal draw_background
    jal load_random_viruses
    lw $s0, ADDR_KBRD  # s0 = base address of the keyboard
    

game_loop:
    # Check whether we are spawning a capsule
    
    # Checking whether we need to spawn a capsule at the top of the bottle
    LOADING_BOTTLE_BITMAP:
        lb $t0, capsule_needed # check from memory whether its time to load capsule
        addiu $t1, $zero, 1 # set t1 = 1
        addiu $t2, $zero, 0 # set t2 = 0 (t2 will be used for the capsule colour, which is 0-9)
        bne $t0, $t1, END_LOADING_BOTTLE_BITMAP # if were loading capsule continue
        
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 
        li $a1, 9 # upper bound (exclusive)
        syscall # the return is stored in $a0
        add $t2, $zero, $a0
        addi $t2, $t2, 1
        push($t2) # the capsule we are loading into the bottle
        jal load_bottle_bitmap
        # No longer loading a capsule
        sb $zero, capsule_needed
        addiu $t1, $zero, 1
        sb $t1, capsule_loaded
        jal draw_bottle_bitmap 
    END_LOADING_BOTTLE_BITMAP:
    jal draw_game_bitmap
    
    
    # Key pressed logic 
    # Let's handle S first so that we can get the hard stuff out the way frfr
    lw $t0, ADDR_KBRD              
    lw $t8, 0($s0)                      # Load first word from keyboard
    beq $t8, 1, handle_key_pressed      # If first word 1, key is pressed
    
    

    
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # Check whether keyboard was pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep
	
	# push 0, unless we are loading in a capsule
	# if you are loading in a capsule, the integer must be random
	# from 1-9
	
	
	
	
	
	

    # 5. Go back to Step 1
    j game_loop
    
    
    
# ----------------------------------------------------------------- #
#                    DRAW INITIAL VIRUSES                           #
# ----------------------------------------------------------------- #


load_random_viruses:
    add $s2, $zero, $zero
    add $t0, $zero, $zero # count variable (loop)
    addiu $t1, $zero, 4 # constant 4
    
    VIRUSES_LOOP: bge $t0, $t1, END_VIRUS_LOOP # count >= 4 then skip
        li $v0, 42
        li $a0, 0
        li $a1, 9
        syscall
        add $t5, $zero, $a0 # t5 stores the rand x
        
        li $v0, 42
        li $a0, 0
        li $a1, 10
        syscall
        addiu $t4, $zero, 5
        add $t6, $t4, $a0 # t5 stores the rand y
        
        # see whats there in the bitmap
        
        la $t9, game_bitmap
        lw $t7, GAME_WIDTH
        lw $t8, GAME_HEIGHT  
        push($ra)
        push_temps()
        push($t5) # x
        push($t6) # y
        push($t7) # w
        push($t8) # h
        push($t9) # bitmap
        jal get_value_in_bitmap # (x,y,w,h,b)
        pop($s3) # get the code in the bitmap
        pop_temps()
        pop($ra)
        
        
        IF_VIRUS_NOT_THERE: bne $s3, $zero, ELSE_VIRUS_NOT_THERE
            # The virus is not here, so add count and update the bitmap
            # Get a random colour
            # virus are code 13,14,15
             li $v0, 42
             li $a0, 0
             li $a1, 3
             syscall 
             addiu $t4, $zero, 13
             add $t3, $t4, $a0 # store the virus id (add 13 for code offset)
             
             push($ra)
             push_temps()
             push($t5) # x
             push($t6) # y
             push($t3) # code for virus
             jal update_game_bitmap
             pop_temps()
             pop($ra)
             
             # update count
             addiu $t0, $t0, 1
             b INCREMENT
        ELSE_VIRUS_NOT_THERE:
            addiu $s2, $s2, 1
    
        INCREMENT:
        b VIRUSES_LOOP
    END_VIRUS_LOOP:
    jr $ra

    # int count = 0;
    
    # while (count < 4) {
        # x = rand(0, 9) 
        # y = rand(5, 17)
        
        # is this x and y already chosen?
        # well we can just draw on the bitmap then check the bitmap at that location
    # }
    

    
# ----------------------------------------------------------------- #
#                            KEY PRESSED                            #
# ----------------------------------------------------------------- #



handle_key_pressed:
    lw $a0, 4($s0)                  # Load second word from keyboard
    
    # Check what key was pressed
    beq $a0, 0x71, respond_to_Q     # done
    beq $a0, 0x71, respond_to_A     
    beq $a0, 0x73, respond_to_S     # working on
    beq $a0, 0x71, respond_to_D
    beq $a0, 0x71, respond_to_W
    
    # Go back home :)
    jr $ra
    
respond_to_Q:
    # Quit the game
    li $v0, 10  
    syscall

respond_to_A:
    # Move left by one game unit
    
    # Check collision
    # Move

respond_to_S:
    # Check whether we are in a load capsule state ! 
    lb $t0, capsule_loaded
    addiu $t1, $zero, 1
    
    beq $t0, $t1, S_LOAD_CAPSULE_CASE # if load state = 1
    bne $t0, $t1, S_MOVE_DOWN # if load state != 1
    S_LOAD_CAPSULE_CASE:
        # turn load capsule off
        sb $zero, capsule_loaded
        
        # get the colour and orientation from the bitmap
        
        # left side of capsule:
        addi $t0, $zero, 4 
        addi $t1, $zero, 2 
        li $t2, 10
        li $t3, 20 
        la $t4, bottle_bitmap
        
        push($ra)
        push($t0) # x
        push($t1) # y
        push($t2) # width
        push($t3) # height
        push($t4) 
        jal get_value_in_bitmap
        pop($s5) # get return value - left side of capsule code
        pop($ra)
        
        # right side of capsule:
        addi $t0, $zero, 5
        addi $t1, $zero, 2 
        li $t2, 10
        li $t3, 20 
        la $t4, bottle_bitmap
        
        push($ra)
        push($t0) # x
        push($t1) # y
        push($t2) # width
        push($t3) # height
        push($t4)
        jal get_value_in_bitmap
        pop($s6) # get return value - right side of capsule code
        pop($ra)
        
        # load the new bitmap for bottle
        push($ra)
        push($zero)
        jal load_bottle_bitmap
        pop($ra)
        
        
        # check for collision below blah blah
        
        # move down
        
        # left side
        push($ra)
        pushi($t0, 3) # x
        pushi($t0, 0) # y
        push($s5) # code
        jal update_game_bitmap
        pop($ra)
        
        # right side
        push($ra)
        pushi($t0, 4) # x
        pushi($t0, 0) # y
        push($s6) # code
        jal update_game_bitmap
        pop($ra)
        
        # set capsule x and y to initial pos
        addiu, $t0, $zero, 3 
        addiu, $t1, $zero, 0
        sw $t0, capsule_x
        sw $t1, capsule_y
        
        push($ra)
        jal draw_bottle_bitmap
        pop($ra)
        jr $ra
        
    S_MOVE_DOWN:
        # need to check collision here too
        # the plan is to have collision be its own part then this be the move down which both use
        
        # Get capsule bit
        lw $t0, capsule_x
        lw $t1, capsule_y
        lw $t2, GAME_WIDTH
        lw $t3, GAME_HEIGHT
        la $t4, game_bitmap
        push($ra)
        push_temps()
        push($t0)
        push($t1)
        push($t2)
        push($t3)
        push($t4)
        jal get_value_in_bitmap
        pop($s5) # the code for the capsule bit
        pop_temps()
        pop($ra)
        
        # if s5 is horizontal (i.e., s5 is 3, 7, or 11)
        addi $t7, $zero, 3
        addi $t8, $zero, 7
        addi $t9, $zero, 11
        
        beq $s5, $t7, S_MOVE_DOWN_HORIZONTAL
        beq $s5, $t8, S_MOVE_DOWN_HORIZONTAL
        beq $s5, $t9, S_MOVE_DOWN_HORIZONTAL
        b S_MOVE_DOWN_VERTICAL
        
        S_MOVE_DOWN_VERTICAL:
            # implement this when theres actually rotation xd
            jr $ra
        
        
        S_MOVE_DOWN_HORIZONTAL:
            # Get right capsule 
            addi $t7,  $t0, 1 # t7 = capsule_x + 1
            
            push($ra)
            push_temps()
            push($t7) # x
            push($t1) # y
            push($t2) 
            push($t3)
            push($t4)
            jal get_value_in_bitmap
            pop($s6) # the code for the capsule bit
            pop_temps()
            pop($ra)
            
            # s5 and s6 hold the left and right capsule codes
            
            # get rid of old ones
            
            # Get rid of left capsule
            push($ra)
            push_temps()
            push($t0) # x
            push($t1) # y
            push($zero) # code - black
            jal update_game_bitmap
            pop_temps()
            pop($ra)
            
            # Get rid of right capsule
            push($ra)
            push_temps()
            push($t7) # x
            push($t1) # y
            push($zero) # code - black
            jal update_game_bitmap
            pop_temps()
            pop($ra)
            
            # Increment y 
            addi $t1, $t1, 1
            
            # Draw left capsule
            push($ra)
            push_temps()
            push($t0)
            push($t1)
            push($s5)
            jal update_game_bitmap
            pop_temps()
            pop($ra)
            
            # Draw right capsule
            push($ra)
            push_temps()
            push($t7)
            push($t1)
            push($s6)
            jal update_game_bitmap
            pop_temps()
            pop($ra)
            
            # Increment capsule_y accordingly (x doesnt change)
            sw $t1, capsule_y
            
            jr $ra
            
        
        
        # First, check what orientation we are (i.e., horizontal vs vertical)
        
        
        # get left bit from above
        
        
        
        # x, y, w, h, bitmap
        
        
    
    
    
    jr $ra
    # Move down by one game unit
    
    # Check collision
    # Move

respond_to_D:
    # Move right by one game unit
    
    # Check collision
    # Move

respond_to_W:
    # Rotate capsule
    
    # Check collision
    # Move
    
# Checks whether the player capsule will result in a collision
# move_x - (game units) the number of units to move in x direction
# move_y - (game units) the number of units to move in the y direction
# Returns:
# - 0 if no collision
# - 1 if collision
check_collision:
    pop($t1) # move_y
    pop($t0) # move_x
    
    # Literally just check




# handle the key pressed
# asd moves left down right
# w rotates


    
# ----------------------------------------------------------------- #
#                            LOAD BITMAP                            #
# ----------------------------------------------------------------- #


# ----------------------------------------------------------------- #
#                            DRAW BOTTLE                            #
# ----------------------------------------------------------------- #

# Loads the initial bitmaps

# Arguments:
# - capsule: whether we should draw a capsule at the top for the bottle
# 0: no capsule
# 
# 1: red-red
# 2: red-blue
# 3: red-yellow
# 
# 4: blue-blue
# 5: blue-red
# 6: blue-yellow
#
# 7: yellow-yellow
# 8: yellow-red
# 9: yellow-blue
load_bottle_bitmap:
    # t0 = bottle bitmap
    # t1 = constantly changing value used for loading values into bitmap
    # t6 = which capsule to put
    # t7 = the left bit of the capsule
    # t8 = the right bit of the capsule
    # t9 = constant holding 1, 2, ..., 9 used for if statement checks
    pop($t6) # get argument (which capsule to put) 
    la $t0, bottle_bitmap # get bottle bitmap array address
    
    addiu $t9, $zero, 1
    beq $t6, $t9, RED_RED
    
    addiu $t9, $zero, 2
    beq $t6, $t9, RED_BLUE
    
    addiu $t9, $zero, 3
    beq $t6, $t9, RED_YELLOW
    
    addiu $t9, $zero, 4
    beq $t6, $t9, BLUE_BLUE
    
    addiu $t9, $zero, 5
    beq $t6, $t9, BLUE_RED
    
    addiu $t9, $zero, 6
    beq $t6, $t9, BLUE_YELLOW
    
    addiu $t9, $zero, 7
    beq $t6, $t9, YELLOW_YELLOW
    
    addiu $t9, $zero, 8
    beq $t6, $t9, YELLOW_RED
    
    addiu $t9, $zero, 9
    beq $t6, $t9, YELLOW_BLUE
    
    # Else:
    b NOTHING_NOTHING
    
    # Nothing
    NOTHING_NOTHING:
        addiu $t7, $zero, 0
        addiu $t8, $zero, 0
        b STORE_BOTTLE_BITMAP
    
    # Left Red
    RED_RED:
        addiu $t7, $zero, 3
        addiu $t8, $zero, 4
        b STORE_BOTTLE_BITMAP
    
    RED_BLUE:
        addiu $t7, $zero, 3
        addiu $t8, $zero, 8
        b STORE_BOTTLE_BITMAP
    
    RED_YELLOW:
        addiu $t7, $zero, 3
        addiu $t8, $zero, 12
        b STORE_BOTTLE_BITMAP
    
    # Left Blue
    
    BLUE_BLUE:
        addiu $t7, $zero, 7
        addiu $t8, $zero, 8
        b STORE_BOTTLE_BITMAP
    
    BLUE_RED:
        addiu $t7, $zero, 7
        addiu $t8, $zero, 4
        b STORE_BOTTLE_BITMAP
    
    BLUE_YELLOW:
        addiu $t7, $zero, 7
        addiu $t8, $zero, 12
        b STORE_BOTTLE_BITMAP
    
    # Left Yellow
    
    YELLOW_YELLOW:
        addiu $t7, $zero, 11
        addiu $t8, $zero, 12
        b STORE_BOTTLE_BITMAP
    
    YELLOW_RED:
        addiu $t7, $zero, 11
        addiu $t8, $zero, 4
        b STORE_BOTTLE_BITMAP
    
    YELLOW_BLUE:
        addiu $t7, $zero, 11
        addiu $t8, $zero, 8
        b STORE_BOTTLE_BITMAP
        
        
    STORE_BOTTLE_BITMAP:
        li $t1, 0
        sb $t1, 0($t0)
        li $t1, 0
        sb $t1, 1($t0)
        li $t1, 0
        sb $t1, 2($t0)
        li $t1, 16
        sb $t1, 3($t0)
        li $t1, 0
        sb $t1, 4($t0)
        li $t1, 0
        sb $t1, 5($t0)
        li $t1, 16
        sb $t1, 6($t0) # 1
        li $t1, 0
        sb $t1, 7($t0)
        li $t1, 0
        sb $t1, 8($t0)
        li $t1, 0
        sb $t1, 9($t0)
        
        li $t1, 0
        sb $t1, 10($t0)
        li $t1, 0
        sb $t1, 11($t0)
        li $t1, 0
        sb $t1, 12($t0)
        li $t1, 16
        sb $t1, 13($t0)
        li $t1, 0
        sb $t1, 14($t0)
        li $t1, 0
        sb $t1, 15($t0) # 2
        li $t1, 16
        sb $t1, 16($t0)
        li $t1, 0
        sb $t1, 17($t0)
        li $t1, 0
        sb $t1, 18($t0)
        li $t1, 0
        sb $t1, 19($t0)
        
        li $t1, 16
        sb $t1, 20($t0)
        li $t1, 16
        sb $t1, 21($t0)
        li $t1, 16
        sb $t1, 22($t0)
        li $t1, 16
        sb $t1, 23($t0)
        # li $t1, CAPL # THIS IS WHERE THE LEFT SIDE OF THE CAPSULE GOES
        add $t1, $zero, $t7
        sb $t1, 24($t0)
        # li $t1, CAPR # THIS IS WHERE THE RIGHT SIDE OF THE CAPSULE GOES
        add $t1, $zero, $t8
        sb $t1, 25($t0)
        li $t1, 16
        sb $t1, 26($t0) # 3
        li $t1, 16
        sb $t1, 27($t0)
        li $t1, 16
        sb $t1, 28($t0)
        li $t1, 16
        sb $t1, 29($t0)
        
        li $t1, 16
        sb $t1, 30($t0)
        # li $t1, 0
        # sb $t1, 31($t0)
        # li $t1, 0
        # sb $t1, 32($t0)
        # li $t1, 0
        # sb $t1, 33($t0)
        # li $t1, 0
        # sb $t1, 34($t0) # 4
        # li $t1, 0
        # sb $t1, 35($t0)
        # li $t1, 0
        # sb $t1, 36($t0)
        # li $t1, 0
        # sb $t1, 37($t0)
        # li $t1, 0
        # sb $t1, 38($t0)
        li $t1, 16
        sb $t1, 39($t0)
        
        li $t1, 16
        sb $t1, 40($t0)
        # li $t1, 0
        # sb $t1, 41($t0)
        # li $t1, 0
        # sb $t1, 42($t0)
        # li $t1, 0
        # sb $t1, 43($t0)
        # li $t1, 0
        # sb $t1, 44($t0)
        # li $t1, 0
        # sb $t1, 45($t0)
        # li $t1, 0
        # sb $t1, 46($t0)
        # li $t1, 0
        # sb $t1, 47($t0)
        # li $t1, 0
        # sb $t1, 48($t0)
        li $t1, 16
        sb $t1, 49($t0)
        
        li $t1, 16
        sb $t1, 50($t0)
        # li $t1, 0
        # sb $t1, 51($t0)
        # li $t1, 0
        # sb $t1, 52($t0)
        # li $t1, 0
        # sb $t1, 53($t0)
        # li $t1, 0
        # sb $t1, 54($t0)
        # li $t1, 0
        # sb $t1, 55($t0)
        # li $t1, 0
        # sb $t1, 56($t0)
        # li $t1, 0
        # sb $t1, 57($t0)
        # li $t1, 0
        # sb $t1, 58($t0)
        li $t1, 16
        sb $t1, 59($t0)
        
        li $t1, 16
        sb $t1, 50($t0)
        # li $t1, 0
        # sb $t1, 51($t0)
        # li $t1, 0
        # sb $t1, 52($t0)
        # li $t1, 0
        # sb $t1, 53($t0)
        # li $t1, 0
        # sb $t1, 54($t0)
        # li $t1, 0
        # sb $t1, 55($t0)
        # li $t1, 0
        # sb $t1, 56($t0)
        # li $t1, 0
        # sb $t1, 57($t0)
        # li $t1, 0
        # sb $t1, 58($t0)
        li $t1, 16
        sb $t1, 59($t0)
        
        li $t1, 16
        sb $t1, 60($t0)
        # li $t1, 0
        # sb $t1, 61($t0)
        # li $t1, 0
        # sb $t1, 62($t0)
        # li $t1, 0
        # sb $t1, 63($t0)
        # li $t1, 0
        # sb $t1, 64($t0)
        # li $t1, 0
        # sb $t1, 65($t0)
        # li $t1, 0
        # sb $t1, 66($t0)
        # li $t1, 0
        # sb $t1, 67($t0)
        # li $t1, 0
        # sb $t1, 68($t0)
        li $t1, 16
        sb $t1, 69($t0)
        
        li $t1, 16
        sb $t1, 70($t0)
        # li $t1, 0
        # sb $t1, 71($t0)
        # li $t1, 0
        # sb $t1, 72($t0)
        # li $t1, 0
        # sb $t1, 73($t0)
        # li $t1, 0
        # sb $t1, 74($t0)
        # li $t1, 0
        # sb $t1, 75($t0)
        # li $t1, 0
        # sb $t1, 76($t0)
        # li $t1, 0
        # sb $t1, 77($t0)
        # li $t1, 0
        # sb $t1, 78($t0)
        li $t1, 16
        sb $t1, 79($t0)
        
        li $t1, 16
        sb $t1, 80($t0)
        # li $t1, 0
        # sb $t1, 81($t0)
        # li $t1, 0
        # sb $t1, 82($t0)
        # li $t1, 0
        # sb $t1, 83($t0)
        # li $t1, 0
        # sb $t1, 84($t0)
        # li $t1, 0
        # sb $t1, 85($t0)
        # li $t1, 0
        # sb $t1, 86($t0)
        # li $t1, 0
        # sb $t1, 87($t0)
        # li $t1, 0
        # sb $t1, 88($t0)
        li $t1, 16
        sb $t1, 89($t0)
        
        li $t1, 16
        sb $t1, 90($t0)
        # li $t1, 0
        # sb $t1, 91($t0)
        # li $t1, 0
        # sb $t1, 92($t0)
        # li $t1, 0
        # sb $t1, 93($t0)
        # li $t1, 0
        # sb $t1, 94($t0)
        # li $t1, 0
        # sb $t1, 95($t0)
        # li $t1, 0
        # sb $t1, 96($t0)
        # li $t1, 0
        # sb $t1, 97($t0)
        # li $t1, 0
        # sb $t1, 98($t0)
        li $t1, 16
        sb $t1, 99($t0)
        
        li $t1, 16
        sb $t1, 100($t0)
        # li $t1, 0
        # sb $t1, 101($t0)
        # li $t1, 0
        # sb $t1, 102($t0)
        # li $t1, 0
        # sb $t1, 103($t0)
        # li $t1, 0
        # sb $t1, 104($t0)
        # li $t1, 0
        # sb $t1, 105($t0)
        # li $t1, 0
        # sb $t1, 106($t0)
        # li $t1, 0
        # sb $t1, 107($t0)
        # li $t1, 0
        # sb $t1, 108($t0)
        li $t1, 16
        sb $t1, 109($t0)
        
        li $t1, 16
        sb $t1, 110($t0)
        # li $t1, 0
        # sb $t1, 111($t0)
        # li $t1, 0
        # sb $t1, 112($t0)
        # li $t1, 0
        # sb $t1, 113($t0)
        # li $t1, 0
        # sb $t1, 114($t0)
        # li $t1, 0
        # sb $t1, 115($t0)
        # li $t1, 0
        # sb $t1, 116($t0)
        # li $t1, 0
        # sb $t1, 117($t0)
        # li $t1, 0
        # sb $t1, 118($t0)
        li $t1, 16
        sb $t1, 119($t0)
        
        li $t1, 16
        sb $t1, 120($t0)
        # li $t1, 0
        # sb $t1, 121($t0)
        # li $t1, 0
        # sb $t1, 122($t0)
        # li $t1, 0
        # sb $t1, 123($t0)
        # li $t1, 0
        # sb $t1, 124($t0)
        # li $t1, 0
        # sb $t1, 125($t0)
        # li $t1, 0
        # sb $t1, 126($t0)
        # li $t1, 0
        # sb $t1, 127($t0)
        # li $t1, 0
        # sb $t1, 128($t0)
        li $t1, 16
        sb $t1, 129($t0)
        
        li $t1, 16
        sb $t1, 130($t0)
        # li $t1, 0
        # sb $t1, 131($t0)
        # li $t1, 0
        # sb $t1, 132($t0)
        # li $t1, 0
        # sb $t1, 133($t0)
        # li $t1, 0
        # sb $t1, 134($t0)
        # li $t1, 0
        # sb $t1, 135($t0)
        # li $t1, 0
        # sb $t1, 136($t0)
        # li $t1, 0
        # sb $t1, 137($t0)
        # li $t1, 0
        # sb $t1, 138($t0)
        li $t1, 16
        sb $t1, 139($t0)
        
        li $t1, 16
        sb $t1, 140($t0)
        # li $t1, 0
        # sb $t1, 141($t0)
        # li $t1, 0
        # sb $t1, 142($t0)
        # li $t1, 0
        # sb $t1, 143($t0)
        # li $t1, 0
        # sb $t1, 144($t0)
        # li $t1, 0
        # sb $t1, 145($t0)
        # li $t1, 0
        # sb $t1, 146($t0)
        # li $t1, 0
        # sb $t1, 147($t0)
        # li $t1, 0
        # sb $t1, 148($t0)
        li $t1, 16
        sb $t1, 149($t0)
        
        li $t1, 16
        sb $t1, 150($t0)
        # li $t1, 0
        # sb $t1, 151($t0)
        # li $t1, 0
        # sb $t1, 152($t0)
        # li $t1, 0
        # sb $t1, 153($t0)
        # li $t1, 0
        # sb $t1, 154($t0)
        # li $t1, 0
        # sb $t1, 155($t0)
        # li $t1, 0
        # sb $t1, 156($t0)
        # li $t1, 0
        # sb $t1, 157($t0)
        # li $t1, 0
        # sb $t1, 158($t0)
        li $t1, 16
        sb $t1, 159($t0)
        
        li $t1, 16
        sb $t1, 160($t0)
        # li $t1, 0
        # sb $t1, 161($t0)
        # li $t1, 0
        # sb $t1, 162($t0)
        # li $t1, 0
        # sb $t1, 163($t0)
        # li $t1, 0
        # sb $t1, 164($t0)
        # li $t1, 0
        # sb $t1, 165($t0)
        # li $t1, 0
        # sb $t1, 166($t0)
        # li $t1, 0
        # sb $t1, 167($t0)
        # li $t1, 0
        # sb $t1, 168($t0)
        li $t1, 16
        sb $t1, 169($t0)
        
        li $t1, 16
        sb $t1, 170($t0)
        # li $t1, 0
        # sb $t1, 171($t0)
        # li $t1, 0
        # sb $t1, 172($t0)
        # li $t1, 0
        # sb $t1, 173($t0)
        # li $t1, 0
        # sb $t1, 174($t0)
        # li $t1, 0
        # sb $t1, 175($t0)
        # li $t1, 0
        # sb $t1, 176($t0)
        # li $t1, 0
        # sb $t1, 177($t0)
        # li $t1, 0
        # sb $t1, 178($t0)
        li $t1, 16
        sb $t1, 179($t0)
        
        li $t1, 16
        sb $t1, 180($t0)
        # li $t1, 0
        # sb $t1, 181($t0)
        # li $t1, 0
        # sb $t1, 182($t0)
        # li $t1, 0
        # sb $t1, 183($t0)
        # li $t1, 0
        # sb $t1, 184($t0)
        # li $t1, 0
        # sb $t1, 185($t0)
        # li $t1, 0
        # sb $t1, 186($t0)
        # li $t1, 0
        # sb $t1, 187($t0)
        # li $t1, 0
        # sb $t1, 188($t0)
        li $t1, 16
        sb $t1, 189($t0)
        
        li $t1, 16
        sb $t1, 190($t0)
        li $t1, 16
        sb $t1, 191($t0)
        li $t1, 16
        sb $t1, 192($t0)
        li $t1, 16
        sb $t1, 193($t0)
        li $t1, 16
        sb $t1, 194($t0)
        li $t1, 16
        sb $t1, 195($t0)
        li $t1, 16
        sb $t1, 196($t0)
        li $t1, 16
        sb $t1, 197($t0)
        li $t1, 16
        sb $t1, 198($t0)
        li $t1, 16
        sb $t1, 199($t0)
        
        
        # li $t2, 0 # start_x
        # li $t3, 0 # start_y
        # li $t4, 10 # width
        # li $t5, 20 # height
        # push($ra)
        # push($t2) # start_x
        # push($t3) # start_y
        # push($t4) # width
        # push($t5) # height
        # push($t0) # bitmap
        # jal draw_bitmap
        # pop($ra)
        jr $ra
        

draw_bottle_bitmap:
    la $t0, bottle_bitmap
    
    li $t2, -1 # start_x
    li $t3, -3 # start_y
    li $t4, 10 # width
    li $t5, 20 # height
    
    push($ra)
    push($t2) # start_x
    push($t3) # start_y
    push($t4) # width
    push($t5) # height
    push($t0) # bitmap
    jal draw_bitmap
    pop($ra)
    jr $ra
    
    
# Updates the game bitmap at the specified x and y to be code
# - x: (game units)
# - y: (game units)
# - code: the code to place in the bitmap at x,y
update_game_bitmap:
    pop($t3) # code
    pop($t2) # y
    pop($t1) # x
    
    la $t8, game_bitmap
    
    # index in bitmap should be 4 * (x + y * game width) (game width is 8 i believe)
    lw $t4, GAME_WIDTH
    
    # x + y * w
    mult $t2, $t4 # y * w
    mflo $t5
    
    add $t5, $t5, $t1 # x + y * w 
    # sll $t5, $t5, 2 # 4 * (x + y * w )
    
    # bitmap + index
    add $t6, $t8, $t5 # this is the index in the bitmap
    sb $t3, 0($t6) # put code in its place in the bitmap
    
    jr $ra
    
# draws the game bitmap the the display
draw_game_bitmap:
    la $t0, game_bitmap
    
    li $t2, 0 # start_x
    li $t3, 0 # start_y
    li $t4, 8 # width
    li $t5, 16 # height
    
    push($ra)
    push($t2) # start_x
    push($t3) # start_y
    push($t4) # width
    push($t5) # height
    push($t0) # bitmap
    jal draw_bitmap
    pop($ra)
    jr $ra
    
    
# Get the value in the bitmap at the specified x and y (col / row)
# - x
# - y
# - width
# - height
# - bitmap base address
# Returns:
# - the value at that location
get_value_in_bitmap:
    pop($t4) # bitmap base address
    pop($t3) # height
    pop($t2) # width
    pop($t1) # y
    pop($t0) # x
    
    # 4 * (x + y * width)
    mult $t1, $t2 # y * width
    mflo $t5
    add $t5, $t5, $t0 # x + y * width
    # sll $t5, $t5, 2 # 4 * (x + y * width) <- this is the index
    
    # now we need index + base address
    add $t6, $t4, $t5
    
    lb $t7, 0($t6)
    push($t7)
    
    jr $ra
    

            
    
# ----------------------------------------------------------------- #
#                         DRAWING HELPERS                           #
# ----------------------------------------------------------------- #

# Draws a rectangle at x and y where x and y are given in game unit coordinates.
# - x (game units)
# - y (game units)
# - address to colour array (PIXEL_PER_GAME_UNIT)^2 big
draw_game_block:
    # Load arguments
    pop($t2) # - address to colour array
    pop($t1) # - y
    pop($t0) # - x
    
    lw $t3, GAME_SCREEN_X
    lw $t4, GAME_SCREEN_Y
    lw $t5, PIXELS_PER_GAME_UNIT
    
    # how much x to increment
    mult $t5, $t0
    mflo $t6
    
    # how much y to increment
    mult $t5, $t1
    mflo $t7
    
    # x and y screen conversions
    add $t3, $t3, $t6
    add $t4, $t4, $t7
    
    # Put arguments for function
    push($ra)
    push_temps()
    push($t3)
    push($t4)
    push($t5)
    push($t5)
    push($t2)
    jal draw_rect
    pop_temps()
    pop($ra)
    jr $ra
    

# start_x - start x in game units
# start_y - start y in game units
# width - width of bitmap in game units
# height - height of bitmap in game units
# bitmap - address of bitmap. Each block is 8 bits (ex. 5 blocks: 0F 1F 3D 5F 2D)
draw_bitmap:
    pop($t0) # bitmap 
    pop($t1) # height
    pop($t2) # width
    pop($t3) # start_y
    pop($t4) # start_x
    
    # t7 = start_y + height
    # t8 = start_x + width
    add $t7, $t3, $t1
    add $t8, $t4, $t2
    
    # j = start_y
    # j = t5
    add $t5, $zero, $t3
    BITMAP_Y_LOOP: bge $t5, $t7, BITMAP_Y_LOOP_END
    
        # i = start_x
        # i = t6
        add $t6, $zero, $t4
        BITMAP_X_LOOP: bge $t6, $t8, BITMAP_X_LOOP_END
            # start_x + i
            # start_y + j
            # add $t1, $t4, $t6
            # add $t2, $t3, $t5
            
            
            la $t9, draw_rectangle_colour_array
            
            push($ra)
            push_temps()
            push($t0)
            jal load_colours
            pop_temps()
            pop($ra)

            push($ra)
            push_temps()
            push($t6)
            push($t5)
            push($t9)
            jal draw_game_block
            pop_temps()
            pop($ra)
            
            
            # Increment bitmap index
            addi $t0, $t0, 1
            

            addi $t6, $t6, 1
            j BITMAP_X_LOOP
        BITMAP_X_LOOP_END:
        addi $t5, $t5, 1
        j BITMAP_Y_LOOP
    
    BITMAP_Y_LOOP_END:
    jr $ra
    
    
# Gets the corresponding colour array for the bit in the bitmap
# - bit in the bitmap
load_colours:
    pop($t2) # address of bit
    
    lb $t2, 0($t2)
    
    la $t0, draw_rectangle_colour_array
    
    # BACKGROUND
    bne $t2, $zero, RED_UP_BIT
    
     # ----------------------- NOTHING ----------------------- #
    
    # Initialize colours
    li $t7, 0x000000        # $t7 = dark blue
    li $t8, 0x000000        # $t8 = light blue
    li $t9, 0x000000        # $t9 = black
    
    sw $t9, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t9, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t7, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t7, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t7, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t7, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t7, 168($t0)
    sw $t7, 172($t0)
    sw $t7, 176($t0)
    sw $t7, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t7, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t7, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t9, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t9, 252($t0)
    
    # ----------------------- NOTHING END ----------------------- #
    
    jr $ra
    
    
    # Capsules - UP, DOWN, LEFT, RIGHT
    
    # Red Capsules
    
    RED_UP_BIT:
    add $t1, $zero, 1
    bne, $t2, $t1, RED_DOWN_BIT
    
    
    # -----------------------  RED UP CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x471313 # $t7 = dark red
    li $t8, 0xed1c24 # $t8 = bright red
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t9, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
        
    
     # -----------------------  RED UP CAPSULE END ----------------------- #
    jr $ra
    RED_DOWN_BIT: 
    add $t1, $zero, 2
    bne, $t2, $t1, RED_LEFT_BIT
    # -----------------------  RED DOWN CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x471313 # $t7 = dark red
    li $t8, 0xed1c24 # $t8 = bright red
    li $t9, 0xf5f0f5 # very light grey
    
    
    sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t9, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
        
    
     # -----------------------  RED DOWN CAPSULE END ----------------------- #
    
    jr $ra
    RED_LEFT_BIT: 
    add $t1, $zero, 3
    bne, $t2, $t1, RED_RIGHT_BIT
    # -----------------------  RED LEFT CAPSULE START ----------------------- #
    
    li $t6, 0x000000 # black
    li $t7, 0x471313 # $t7 = dark red
    li $t8, 0xed1c24 # $t8 = bright red
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t9, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
    
    
     # -----------------------  RED LEFT CAPSULE END ----------------------- #
    
    jr $ra
    RED_RIGHT_BIT:
    add $t1, $zero, 4
    bne, $t2, $t1, BLUE_UP_BIT
    # -----------------------  RED RIGHT CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x471313 # $t7 = dark red
    li $t8, 0xed1c24 # $t8 = bright red
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t9, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
    
    
     # -----------------------  RED RIGHT CAPSULE END ----------------------- #
    
    # Blue Capsules
    
    jr $ra
    BLUE_UP_BIT: 
    add $t1, $zero, 5
    bne, $t2, $t1, BLUE_DOWN_BIT
    
    # -----------------------  BLUE UP CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x2f3699 # dark blue
    li $t8, 0x00b7ef # light blue
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t9, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
    
    
     # -----------------------  BLUE UP CAPSULE END ----------------------- #
   
    jr $ra
    BLUE_DOWN_BIT: 
    add $t1, $zero, 6
    bne, $t2, $t1, BLUE_LEFT_BIT
    
    # -----------------------  BLUE DOWN CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x2f3699 # dark blue
    li $t8, 0x00b7ef # light blue
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t9, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
    
    
     # -----------------------  BLUE DOWN CAPSULE END ----------------------- #
    
    jr $ra
    BLUE_LEFT_BIT: 
    add $t1, $zero, 7
    bne, $t2, $t1, BLUE_RIGHT_BIT
    
    # -----------------------  BLUE LEFT CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0x2f3699 # dark blue
    li $t8, 0x00b7ef # light blue
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t9, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
    
     # -----------------------  BLUE LEFT CAPSULE END ----------------------- #
    
    jr $ra
    BLUE_RIGHT_BIT: 
    add $t1, $zero, 8
    bne, $t2, $t1, YELLOW_UP_BIT
    
    # -----------------------  BLUE RIGHT CAPSULE START ----------------------- #
    
    li $t6, 0x000000 # black
    li $t7, 0x2f3699 # dark blue
    li $t8, 0x00b7ef # light blue
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t9, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
    
    
     # -----------------------  BLUE RIGHT CAPSULE END ----------------------- #
    
    # Yellow Capsules
    
    jr $ra
    YELLOW_UP_BIT: 
    add $t1, $zero, 9
    bne, $t2, $t1, YELLOW_DOWN_BIT
    
    # -----------------------  YELLOW UP CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0xCC7722 # $t7 = orange
    li $t8, 0xffc20e # $t8 = gold
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t9, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
    
    
    # ----------------------- YELLOW UP CAPSULE END ----------------------- #
    
    jr $ra
    YELLOW_DOWN_BIT: 
    add $t1, $zero, 10
    bne, $t2, $t1, YELLOW_LEFT_BIT
    
    # -----------------------  YELLOW DOWN CAPSULE START ----------------------- #
    li $t6, 0x000000 # black
    li $t7, 0xCC7722 # $t7 = orange
    li $t8, 0xffc20e # $t8 = gold
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t9, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t9, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
    
    
    # ----------------------- YELLOW DOWN CAPSULE END ----------------------- #
    
    jr $ra
    YELLOW_LEFT_BIT:
    add $t1, $zero, 11
    bne, $t2, $t1, YELLOW_RIGHT_BIT
    
    # -----------------------  YELLOW LEFT CAPSULE START ----------------------- #
    
    li $t6, 0x000000 # black
    li $t7, 0xCC7722 # $t7 = orange
    li $t8, 0xffc20e # $t8 = gold
    li $t9, 0xf5f0f5 # very light grey
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t7, 28($t0)
    sw $t6, 32($t0)
    sw $t7, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t8, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t9, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t9, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t6, 192($t0)
    sw $t7, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t6, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t7, 252($t0)
    
    
    # ----------------------- YELLOW LEFT CAPSULE END ----------------------- #
    
    jr $ra
    YELLOW_RIGHT_BIT: 
    add $t1, $zero, 12
    bne, $t2, $t1, RED_VIRUS_BIT
    
    # -----------------------  YELLOW RIGHT CAPSULE START ----------------------- #
    
    li $t6, 0x000000 # black
    li $t7, 0xCC7722 # $t7 = orange
    li $t8, 0xffc20e # $t8 = gold
    li $t9, 0xf5f0f5 # very light grey
    
     sw $t7, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t6, 24($t0)
    sw $t6, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t7, 56($t0)
    sw $t6, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t9, 72($t0)
    sw $t9, 76($t0)
    sw $t9, 80($t0)
    sw $t8, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t9, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t8, 168($t0)
    sw $t8, 172($t0)
    sw $t8, 176($t0)
    sw $t8, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t8, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t8, 212($t0)
    sw $t7, 216($t0)
    sw $t6, 220($t0)
    sw $t7, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t6, 248($t0)
    sw $t6, 252($t0)
    
    # ----------------------- YELLOW RIGHT CAPSULE END ----------------------- #
    
    jr $ra
    # Viruses
    RED_VIRUS_BIT:
    add $t1, $zero, 13
    bne, $t2, $t1, BLUE_VIRUS_BIT
    
    # -----------------------  RED VIRUS START ----------------------- #
    # Initialize colours
    li $t6, 0x000000 # black
    li $t7, 0xa70000 # darker red
    li $t8, 0xff0000 # lighter red
    li $t9, 0xcff5252 # even more lighter red
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t9, 8($t0)
    sw $t6, 12($t0)
    sw $t6, 16($t0)
    sw $t6, 20($t0)
    sw $t6, 24($t0)
    sw $t9, 28($t0)
    sw $t6, 32($t0)
    sw $t9, 36($t0)
    sw $t6, 40($t0)
    sw $t6, 44($t0)
    sw $t6, 48($t0)
    sw $t6, 52($t0)
    sw $t9, 56($t0)
    sw $t6, 60($t0)
    sw $t6, 64($t0)
    sw $t9, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t8, 84($t0)
    sw $t9, 88($t0)
    sw $t6, 92($t0)
    sw $t8, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t8, 124($t0)
    sw $t8, 128($t0)
    sw $t6, 132($t0)
    sw $t6, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t6, 148($t0)
    sw $t6, 152($t0)
    sw $t8, 156($t0)
    sw $t7, 160($t0)
    sw $t7, 164($t0)
    sw $t7, 168($t0)
    sw $t7, 172($t0)
    sw $t7, 176($t0)
    sw $t7, 180($t0)
    sw $t7, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t7, 196($t0)
    sw $t7, 200($t0)
    sw $t7, 204($t0)
    sw $t7, 208($t0)
    sw $t7, 212($t0)
    sw $t7, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t7, 228($t0)
    sw $t6, 232($t0)
    sw $t6, 236($t0)
    sw $t6, 240($t0)
    sw $t6, 244($t0)
    sw $t7, 248($t0)
    sw $t6, 252($t0)
    
    # ----------------------- RED VIRUS END ----------------------- #
    
    jr $ra
    BLUE_VIRUS_BIT:
    add $t1, $zero, 14
    bne, $t2, $t1, YELLOW_VIRUS_BIT
    
    # -----------------------  BLUE VIRUS START ----------------------- #
    
     # Initialize colours
    li $t6, 0x000000 # black
    li $t7, 0x2f3699 # darker blue
    li $t8, 0x4d6df3 # lighter blue
    li $t9, 0x99d9ea # even more lighter blue
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t9, 8($t0)
    sw $t6, 12($t0)
    sw $t6, 16($t0)
    sw $t6, 20($t0)
    sw $t6, 24($t0)
    sw $t9, 28($t0)
    sw $t6, 32($t0)
    sw $t9, 36($t0)
    sw $t6, 40($t0)
    sw $t6, 44($t0)
    sw $t6, 48($t0)
    sw $t6, 52($t0)
    sw $t9, 56($t0)
    sw $t6, 60($t0)
    sw $t6, 64($t0)
    sw $t9, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t8, 84($t0)
    sw $t9, 88($t0)
    sw $t6, 92($t0)
    sw $t8, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t8, 124($t0)
    sw $t8, 128($t0)
    sw $t6, 132($t0)
    sw $t6, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t6, 148($t0)
    sw $t6, 152($t0)
    sw $t8, 156($t0)
    sw $t7, 160($t0)
    sw $t7, 164($t0)
    sw $t7, 168($t0)
    sw $t7, 172($t0)
    sw $t7, 176($t0)
    sw $t7, 180($t0)
    sw $t7, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t7, 196($t0)
    sw $t7, 200($t0)
    sw $t7, 204($t0)
    sw $t7, 208($t0)
    sw $t7, 212($t0)
    sw $t7, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t7, 228($t0)
    sw $t6, 232($t0)
    sw $t6, 236($t0)
    sw $t6, 240($t0)
    sw $t6, 244($t0)
    sw $t7, 248($t0)
    sw $t6, 252($t0)
    
    # ----------------------- BLUE VIRUS END ----------------------- #
    
    jr $ra
    YELLOW_VIRUS_BIT:
    add $t1, $zero, 15
    bne, $t2, $t1, WALL_BIT
    
    # ----------------------- YELLOW VIRUS START ----------------------- #
    
    # Initialize colours
    li $t6, 0x000000 # black
    li $t7, 0xffa700 # darker yellow
    li $t8, 0xffce00 # lighter yellow
    li $t9, 0xffde1a # even more lighter yellow
    
    sw $t6, 0($t0)
    sw $t6, 4($t0)
    sw $t9, 8($t0)
    sw $t6, 12($t0)
    sw $t6, 16($t0)
    sw $t6, 20($t0)
    sw $t6, 24($t0)
    sw $t9, 28($t0)
    sw $t6, 32($t0)
    sw $t9, 36($t0)
    sw $t6, 40($t0)
    sw $t6, 44($t0)
    sw $t6, 48($t0)
    sw $t6, 52($t0)
    sw $t9, 56($t0)
    sw $t6, 60($t0)
    sw $t6, 64($t0)
    sw $t9, 68($t0)
    sw $t8, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t8, 84($t0)
    sw $t9, 88($t0)
    sw $t6, 92($t0)
    sw $t8, 96($t0)
    sw $t8, 100($t0)
    sw $t8, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t8, 116($t0)
    sw $t8, 120($t0)
    sw $t8, 124($t0)
    sw $t8, 128($t0)
    sw $t6, 132($t0)
    sw $t6, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t6, 148($t0)
    sw $t6, 152($t0)
    sw $t8, 156($t0)
    sw $t7, 160($t0)
    sw $t7, 164($t0)
    sw $t7, 168($t0)
    sw $t7, 172($t0)
    sw $t7, 176($t0)
    sw $t7, 180($t0)
    sw $t7, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t7, 196($t0)
    sw $t7, 200($t0)
    sw $t7, 204($t0)
    sw $t7, 208($t0)
    sw $t7, 212($t0)
    sw $t7, 216($t0)
    sw $t7, 220($t0)
    sw $t6, 224($t0)
    sw $t7, 228($t0)
    sw $t6, 232($t0)
    sw $t6, 236($t0)
    sw $t6, 240($t0)
    sw $t6, 244($t0)
    sw $t7, 248($t0)
    sw $t6, 252($t0)
    
    # ----------------------- YELLOW VIRUS END ----------------------- #
    
    jr $ra
    WALL_BIT:
    add $t1, $zero, 16
    
    # ----------------------- WALL START ----------------------- #
    
    # Initialize colours
    li $t7, 0xFFFFFF        # $t7 = dark blue
    li $t8, 0xFFFFFF        # $t8 = light blue
    li $t9, 0xFFFFFF        # $t9 = black
    
    sw $t9, 0($t0)
    sw $t7, 4($t0)
    sw $t7, 8($t0)
    sw $t7, 12($t0)
    sw $t7, 16($t0)
    sw $t7, 20($t0)
    sw $t7, 24($t0)
    sw $t9, 28($t0)
    sw $t7, 32($t0)
    sw $t8, 36($t0)
    sw $t8, 40($t0)
    sw $t8, 44($t0)
    sw $t8, 48($t0)
    sw $t8, 52($t0)
    sw $t8, 56($t0)
    sw $t7, 60($t0)
    sw $t7, 64($t0)
    sw $t8, 68($t0)
    sw $t7, 72($t0)
    sw $t8, 76($t0)
    sw $t8, 80($t0)
    sw $t7, 84($t0)
    sw $t8, 88($t0)
    sw $t7, 92($t0)
    sw $t7, 96($t0)
    sw $t8, 100($t0)
    sw $t7, 104($t0)
    sw $t8, 108($t0)
    sw $t8, 112($t0)
    sw $t7, 116($t0)
    sw $t8, 120($t0)
    sw $t7, 124($t0)
    sw $t7, 128($t0)
    sw $t8, 132($t0)
    sw $t8, 136($t0)
    sw $t8, 140($t0)
    sw $t8, 144($t0)
    sw $t8, 148($t0)
    sw $t8, 152($t0)
    sw $t7, 156($t0)
    sw $t7, 160($t0)
    sw $t8, 164($t0)
    sw $t7, 168($t0)
    sw $t7, 172($t0)
    sw $t7, 176($t0)
    sw $t7, 180($t0)
    sw $t8, 184($t0)
    sw $t7, 188($t0)
    sw $t7, 192($t0)
    sw $t8, 196($t0)
    sw $t7, 200($t0)
    sw $t8, 204($t0)
    sw $t8, 208($t0)
    sw $t7, 212($t0)
    sw $t8, 216($t0)
    sw $t7, 220($t0)
    sw $t9, 224($t0)
    sw $t7, 228($t0)
    sw $t7, 232($t0)
    sw $t7, 236($t0)
    sw $t7, 240($t0)
    sw $t7, 244($t0)
    sw $t7, 248($t0)
    sw $t9, 252($t0)
    
    # ----------------------- WALL END ----------------------- #
    
    jr $ra
    

# ----------------------------------------------------------------- #
#                         DRAW RECTANGLE                            #
# ----------------------------------------------------------------- #

    
# Arguments: 
# $t4 - x (screen unit)
# $t3 - y (screen unit)
# $t2 - width
# $t1 - height
# $t0 - address of array of colours
# Returns:
# - void
# Passed in by the stack
draw_rect:
    # Load arguments
    pop($t0) # Address
    pop($t1) # Height
    pop($t2) # Width
    pop($t3) # Y
    pop($t4) # X
    
    lw $t5 ADDR_DSPL # load display address into $t5
    # li $t5, 0x10008000
    
    # la $t6, ADDR_DSPL
    
    
    # i = $t6
    # j = $t7
    # x + width = $t2
    # y + height = $t1
    add $t2, $t2, $t4
    add $t1, $t1, $t3
    
    # lw $t7, 4($t0)
    
    # sw $t7, 0($t5)
    
    add $t7, $t3, $zero # Initialize i counter
    Y_LOOP: bge $t7, $t1, END_Y_LOOP
    
        add $t6, $t4, $zero # Initialize j counter
        X_LOOP: bge $t6, $t2, END_X_LOOP
            # Calculating coordinate on bitmap
            lw $t8, SCREEN_WIDTH # t8 = screen width (256)

            mult $t8, $t7 # t8 = screen width * j
            mflo $t8
            add $t8, $t8, $t6 # t8 = screen width * j + i 
            sll $t8, $t8, 2 # t8 = 4 * screen width * j + 4 * i 
            
            # Getting colour for this pixel
            lw $t9, 0($t0) 
            addi $t0, $t0, 4
            add $t8, $t8, $t5
            
            # Draw
            sw $t9, 0($t8)
            
            # Increment j
            addi $t6, $t6, 1
            
            j X_LOOP
        END_X_LOOP:
            # Increment i
            addi $t7, $t7, 1
            j Y_LOOP
    END_Y_LOOP:
    jr $ra
    

# ----------------------------------------------------------------- #
#                           DRAW VIRUSES                            #
# ----------------------------------------------------------------- #

# Draws a virus at the given coordinates in game units
# Arguments:
# x - game pixels
# y - game pixels
draw_virus:
    lw $t0, GAME_SCREEN_X
    lw $t1, GAME_SCREEN_Y
    lw $t2, PIXELS_PER_GAME_UNIT
    pop($t3) # y
    pop($t4) # x
    
    # x = GAME_SCREEN_X + x * PIXELS_PER_GAME_UNIT
    mult $t4, $t2
    mflo $t5
    add $t6, $t0, $t5
    
     # y = GAME_SCREEN_Y + y * PIXELS_PER_GAME_UNIT
     mult $t3, $t2
     mflo $t5
     add $t7, $t1, $t5
     
     push($ra)
     push_temps()
     push($t6)
     push($t7)
     jal draw_virus_screen
     pop_temps()
     pop($ra)
     jr $ra

# Draws a virus at the given coordinates in screen pixels
# Arguments:
# $t5 - x
# $t4 - y 
draw_virus_screen:
    # Load arguments
    pop($t4) # Y
    pop($t5) # X
    
    # Initialize colours
    li $t1, 0x471313        # $t1 = dark red
    li $t2, 0xed1c24        # $t2 = bright red
    li $t3, 0x000000        # $t3 = black
    
    lw $t6, PIXELS_PER_GAME_UNIT
    
    # $t0 = address of draw_recentagle_colour_array
    
    la $t0, draw_rectangle_colour_array
    
    # Row 1
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t3, 28($t0)
    
    # Row 2
    sw $t1, 32($t0)
    sw $t2, 36($t0)
    sw $t2, 40($t0)
    sw $t2, 44($t0)
    sw $t2, 48($t0)
    sw $t2, 52($t0)
    sw $t2, 56($t0)
    sw $t1, 60($t0)
    
    # Row 3
    sw $t1, 64($t0)
    sw $t2, 68($t0)
    sw $t1, 72($t0)
    sw $t2, 76($t0)
    sw $t2, 80($t0)
    sw $t1, 84($t0)
    sw $t2, 88($t0)
    sw $t1, 92($t0)
    
    # Row 4
    sw $t1, 96($t0)
    sw $t2, 100($t0)
    sw $t1, 104($t0)
    sw $t2, 108($t0)
    sw $t2, 112($t0)
    sw $t1, 116($t0)
    sw $t2, 120($t0)
    sw $t1, 124($t0)
    
    # Row 5
    sw $t1, 128($t0)
    sw $t2, 132($t0)
    sw $t2, 136($t0)
    sw $t2, 140($t0)
    sw $t2, 144($t0)
    sw $t2, 148($t0)
    sw $t2, 152($t0)
    sw $t1, 156($t0)
    
    # Row 6
    sw $t1, 160($t0)
    sw $t2, 164($t0)
    sw $t1, 168($t0)
    sw $t1, 172($t0)
    sw $t1, 176($t0)
    sw $t1, 180($t0)
    sw $t2, 184($t0)
    sw $t1, 188($t0)
    
    # Row 7
    sw $t1, 192($t0)
    sw $t2, 196($t0)
    sw $t1, 200($t0)
    sw $t2, 204($t0)
    sw $t2, 208($t0)
    sw $t1, 212($t0)
    sw $t2, 216($t0)
    sw $t1, 220($t0)
    
    # Row 8
    sw $t3, 224($t0)
    sw $t1, 228($t0)
    sw $t1, 232($t0)
    sw $t1, 236($t0)
    sw $t1, 240($t0)
    sw $t1, 244($t0)
    sw $t1, 248($t0)
    sw $t3, 252($t0)
    
    # Put arguments for function
    push($ra)
    push_temps()
    push($t5)
    push($t4)
    push($t6)
    push($t6)
    push($t0)
    jal draw_rect
    pop_temps()
    pop($ra)
    jr $ra
    
    
# ----------------------------------------------------------------- #
#                          DRAW BACKGROUND                          #
# ----------------------------------------------------------------- #

    
# Draws the entire canvas black
# Arguments:
# - None
# Return: 
# - Void
draw_background:
    li $t0, 0x000000 # Background colour
    lw $t1, ADDR_DSPL
    lw $t2, SCREEN_WIDTH
    lw $t3, SCREEN_HEIGHT
    
    # Calculate $t5 = (screen width * screen height) * 4
    mult $t2, $t3
    mflo $t4 # screen width * height
    sll $t4, $t4, 2
    
    # Max Address to draw at 
    add $t5, $t1, $t4
    
    # Draw entire canvas
    BACKGROUND_LOOP: bge $t1, $t5 END_BACKGROUND_LOOP
        sw $t0, 0($t1)
        addi $t1, $t1, 4
        j BACKGROUND_LOOP
    END_BACKGROUND_LOOP:
        jr $ra
        
        
        
# console.log([
    # 3, 1, 1, 1, 1, 1, 1, 3,
    # 1, 2, 2, 2, 2, 2, 2, 1,
    # 1, 2, 1, 2, 2, 1, 2, 1,
    # 1, 2, 1, 2, 2, 1, 2, 1,
    # 1, 2, 2, 2, 2, 2, 2, 1,
    # 1, 2, 1, 1, 1, 1, 2, 1,
    # 1, 2, 1, 2, 2, 1, 2, 1, 
    # 3, 1, 1, 1, 1, 1, 1, 3,
# ].map((color, i) => `sw $t${color}, ${i * 4}($t0)`)
# .join("\n"))

# console.log([
    # 0, 0, 0, 1, 0, 0, 1, 0, 0, 0,
    # 0, 0, 0, 1, 0, 0, 1, 0, 0, 0,
    # 1, 1, 1, 1, 0, 0, 1, 1, 1, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 0, 0, 0, 0, 0, 0, 0, 0, 1,
    # 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
# ].map((color, i) => `li $t1, ${color === 1 ? 16 : 0}\nsb $t1, ${i}($t0)`)
# .join("\n"))


# virus
# console.log([
    # 1, 1, 4, 1, 1, 1, 1, 4,
    # 1, 4, 1, 1, 1, 1, 4, 1,
    # 1, 4, 3, 3, 3, 3, 4, 1,
    # 3, 3, 3, 3, 3, 3, 3, 3,
    # 3, 1, 1, 3, 3, 1, 1, 3,
    # 2, 2, 2, 2, 2, 2, 2, 2,
    # 2, 2, 2, 2, 2, 2, 2, 2,
    # 1, 2, 1, 1, 1, 1, 2, 1,
# ].map((color, i) => `sw $t${5 + color}, ${i * 4}($t0)`)
# .join("\n"))

# LEFT CAPSULE:
# console.log([
    # 1, 1, 2, 2, 2, 2, 2, 2,
    # 1, 2, 3, 3, 3, 3, 3, 2,
    # 2, 3, 3, 4, 4, 4, 3, 2,
    # 2, 3, 4, 3, 3, 3, 3, 2,
    # 2, 3, 3, 3, 3, 3, 3, 2,
    # 2, 3, 3, 3, 3, 3, 3, 2,
    # 1, 2, 3, 3, 3, 3, 3, 2,
    # 1, 1, 2, 2, 2, 2, 2, 2,
# ].map((color, i) => `sw $t${color}, ${i * 4}($t0)`)
# .join("\n"))
