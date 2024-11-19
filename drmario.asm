################# CSC258 Assembly Final Project ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Sherwin Okhowat, 1010296225
# Student 2: Name, Student Number (if applicable)
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       TODO
# - Unit height in pixels:      TODO
# - Display width in pixels:    TODO
# - Display height in pixels:   TODO
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
    .word 128

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
    .word 16

# top left corner of the game in screen pixels
GAME_SCREEN_Y:
    .word 16
    
##############################################################################
# Mutable Data
##############################################################################
draw_rectangle_colour_array:
    .word 0:100000 # 0:num of pixels of screen (width * height)
    
draw_bitmap_array:
    .word 0:100000

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    jal draw_background
    # li $t0, -2
    # li $t1, -2
    # la $t2, draw_rectangle_colour_array
    # push($t0)
    # push($t1)
    # push($t2)
    
    # li $t1, 0 
    # li $t2, 0 
    # push($t1)
    # push($t2)
    # jal draw_virus


    # li $t0, 0x10071aa8
    # addi $t0, $t0, 4
    
    # jal draw_game_block
    # jal draw_virus
    
    # Store value into temp draw bitmap array
    la $t0, draw_bitmap_array
    li $t1, 0
    sb $t1, 0($t0)
    li $t1, 0
    sb $t1, 1($t0)
    li $t1, 0
    sb $t1, 2($t0)
    li $t1, 16
    sb $t1, 3($t0)
    li $t1, 13
    sb $t1, 4($t0)
    li $t1, 0
    sb $t1, 5($t0)
    li $t1, 16
    sb $t1, 6($t0)
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
    li $t1, 14
    sb $t1, 15($t0)
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
    li $t1, 0
    sb $t1, 24($t0)
    li $t1, 0
    sb $t1, 25($t0)
    li $t1, 16
    sb $t1, 26($t0)
    li $t1, 16
    sb $t1, 27($t0)
    li $t1, 16
    sb $t1, 28($t0)
    li $t1, 16
    sb $t1, 29($t0)
    li $t1, 16
    sb $t1, 30($t0)
    li $t1, 5 #I PUT THIS HERE UP BIT 
    sb $t1, 31($t0)
    li $t1, 0
    sb $t1, 32($t0)
    li $t1, 0
    sb $t1, 33($t0)
    li $t1, 0
    sb $t1, 34($t0)
    li $t1, 0
    sb $t1, 35($t0)
    li $t1, 0
    sb $t1, 36($t0)
    li $t1, 0
    sb $t1, 37($t0)
    li $t1, 0
    sb $t1, 38($t0)
    li $t1, 16
    sb $t1, 39($t0)
    li $t1, 16
    sb $t1, 40($t0)
    li $t1, 6 # FACING UP CAP
    sb $t1, 41($t0)
    li $t1, 0
    sb $t1, 42($t0)
    li $t1, 11
    sb $t1, 43($t0)
    li $t1, 12
    sb $t1, 44($t0)
    li $t1, 3 # CAPSULE THAT I PUT IN
    sb $t1, 45($t0)
    li $t1, 4
    sb $t1, 46($t0)
    li $t1, 7
    sb $t1, 47($t0)
    li $t1, 8
    sb $t1, 48($t0)
    li $t1, 16
    sb $t1, 49($t0)
    li $t1, 16
    sb $t1, 50($t0)
    li $t1, 0
    sb $t1, 51($t0)
    li $t1, 0
    sb $t1, 52($t0)
    li $t1, 0
    sb $t1, 53($t0)
    li $t1, 0
    sb $t1, 54($t0)
    li $t1, 0
    sb $t1, 55($t0)
    li $t1, 0
    sb $t1, 56($t0)
    li $t1, 0
    sb $t1, 57($t0)
    li $t1, 0
    sb $t1, 58($t0)
    li $t1, 16
    sb $t1, 59($t0)
    li $t1, 16
    sb $t1, 60($t0)
    li $t1, 0
    sb $t1, 61($t0)
    li $t1, 0
    sb $t1, 62($t0)
    li $t1, 13
    sb $t1, 63($t0)
    li $t1, 0
    sb $t1, 64($t0)
    li $t1, 0
    sb $t1, 65($t0)
    li $t1, 15
    sb $t1, 66($t0)
    li $t1, 0
    sb $t1, 67($t0)
    li $t1, 0
    sb $t1, 68($t0)
    li $t1, 16
    sb $t1, 69($t0)
    li $t1, 16
    sb $t1, 70($t0)
    li $t1, 0
    sb $t1, 71($t0)
    li $t1, 0
    sb $t1, 72($t0)
    li $t1, 0
    sb $t1, 73($t0)
    li $t1, 0
    sb $t1, 74($t0)
    li $t1, 0
    sb $t1, 75($t0)
    li $t1, 0
    sb $t1, 76($t0)
    li $t1, 0
    sb $t1, 77($t0)
    li $t1, 0
    sb $t1, 78($t0)
    li $t1, 16
    sb $t1, 79($t0)
    li $t1, 16
    sb $t1, 80($t0)
    li $t1, 0
    sb $t1, 81($t0)
    li $t1, 0
    sb $t1, 82($t0)
    li $t1, 0
    sb $t1, 83($t0)
    li $t1, 0
    sb $t1, 84($t0)
    li $t1, 0
    sb $t1, 85($t0)
    li $t1, 0
    sb $t1, 86($t0)
    li $t1, 0
    sb $t1, 87($t0)
    li $t1, 0
    sb $t1, 88($t0)
    li $t1, 16
    sb $t1, 89($t0)
    li $t1, 16
    sb $t1, 90($t0)
    li $t1, 0
    sb $t1, 91($t0)
    li $t1, 0
    sb $t1, 92($t0)
    li $t1, 0
    sb $t1, 93($t0)
    li $t1, 0
    sb $t1, 94($t0)
    li $t1, 0
    sb $t1, 95($t0)
    li $t1, 0
    sb $t1, 96($t0)
    li $t1, 0
    sb $t1, 97($t0)
    li $t1, 0
    sb $t1, 98($t0)
    li $t1, 16
    sb $t1, 99($t0)
    li $t1, 16
    sb $t1, 100($t0)
    li $t1, 0
    sb $t1, 101($t0)
    li $t1, 0
    sb $t1, 102($t0)
    li $t1, 0
    sb $t1, 103($t0)
    li $t1, 0
    sb $t1, 104($t0)
    li $t1, 0
    sb $t1, 105($t0)
    li $t1, 0
    sb $t1, 106($t0)
    li $t1, 0
    sb $t1, 107($t0)
    li $t1, 0
    sb $t1, 108($t0)
    li $t1, 16
    sb $t1, 109($t0)
    li $t1, 16
    sb $t1, 110($t0)
    li $t1, 16
    sb $t1, 111($t0)
    li $t1, 16
    sb $t1, 112($t0)
    li $t1, 16
    sb $t1, 113($t0)
    li $t1, 16
    sb $t1, 114($t0)
    li $t1, 16
    sb $t1, 115($t0)
    li $t1, 16
    sb $t1, 116($t0)
    li $t1, 16
    sb $t1, 117($t0)
    li $t1, 16
    sb $t1, 118($t0)
    li $t1, 16
    sb $t1, 119($t0)
    
    li $t2, 0
    li $t3, 0
    li $t4, 10 # width
    li $t5, 12 # height
    push($t2) # start_x
    push($t3) # start_y
    push($t4) # width
    push($t5) # height
    push($t0) # bitmap
    jal draw_bitmap

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j EXIT
    
# ----------------------------------------------------------------- #
#                            DRAW BOTTLE                            #
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
    
     # ----------------------- WALL START ----------------------- #
    
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
    
    # ----------------------- WALL END ----------------------- #
    
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

EXIT:
    li $v0, 10  
    syscall
