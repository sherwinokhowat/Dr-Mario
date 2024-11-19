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

    # Push the value in %r onto the stack
    # Arguments: 
    # - %r: The register to push onto the stack
    # Returns:
    # - Void
    .macro push(%r)
        addiu $sp, $sp, -4
        sw %r, 0($sp) 
    .end_macro
    
    # Push the value %v onto the stack using register %r
    # Arguments: 
    # - %r: The register used to push
    # - %v: The value to push
    # Returns:
    # - Void
    .macro pushi(%r, %v)
        addiu $sp, $sp, -4
        li %r, %v
        sw %r, 0($sp)
    .end_macro
    
    # pops and puts on register %r
    .macro pop(%r)
        lw %r, 0($sp)
        addiu $sp, $sp, 4
    .end_macro
    
    .data
##############################################################################
# Immutable Data
##############################################################################
_: .word 1:100000
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!

ADDR_KBRD:
    .word 0xffff0000
    
SCREEN_WIDTH: 
    .word 128

SCREEN_HEIGHT:
    .word 128

##############################################################################
# Mutable Data
##############################################################################
draw_rectangle_colour_array:
    .word 0:1000 # 0:num of pixels of screen (width * height)

##############################################################################
# Code
##############################################################################
	.text
	.globl main

    # Run the game.
main:
    jal draw_background
    # jal draw_background
    # jal draw_background
    jal draw_virus

game_loop:
    # 1a. Check if key has been pressed
    # 1b. Check which key has been pressed
    # 2a. Check for collisions
	# 2b. Update locations (capsules)
	# 3. Draw the screen
	# 4. Sleep

    # 5. Go back to Step 1
    j game_loop
    
# Arguments: 
# $t4 - x
# $t3 - y
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
draw_virus:
    # Initialize the game
    li $t1, 0x471313        # $t1 = dark red
    li $t2, 0xed1c24        # $t2 = bright red
    li $t3, 0x000000        # $t3 = black
    
    # $t0 = address of draw_recentagle_colour_array
    
    la $t0, draw_rectangle_colour_array
    
    sw $t3, 0($t0)
    sw $t1, 4($t0)
    sw $t1, 8($t0)
    sw $t1, 12($t0)
    sw $t1, 16($t0)
    sw $t1, 20($t0)
    sw $t1, 24($t0)
    sw $t3, 28($t0)
    sw $t1, 32($t0)
    sw $t2, 36($t0)
    sw $t2, 40($t0)
    sw $t2, 44($t0)
    sw $t2, 48($t0)
    sw $t2, 52($t0)
    sw $t2, 56($t0)
    sw $t1, 60($t0)
    sw $t1, 64($t0)
    sw $t2, 68($t0)
    sw $t1, 72($t0)
    sw $t2, 76($t0)
    sw $t2, 80($t0)
    sw $t1, 84($t0)
    sw $t2, 88($t0)
    sw $t1, 92($t0)
    sw $t1, 96($t0)
    sw $t2, 100($t0)
    sw $t1, 104($t0)
    sw $t2, 108($t0)
    sw $t2, 112($t0)
    sw $t1, 116($t0)
    sw $t2, 120($t0)
    sw $t1, 124($t0)
    sw $t1, 128($t0)
    sw $t2, 132($t0)
    sw $t2, 136($t0)
    sw $t2, 140($t0)
    sw $t2, 144($t0)
    sw $t2, 148($t0)
    sw $t2, 152($t0)
    sw $t1, 156($t0)
    sw $t1, 160($t0)
    sw $t2, 164($t0)
    sw $t1, 168($t0)
    sw $t1, 172($t0)
    sw $t1, 176($t0)
    sw $t1, 180($t0)
    sw $t2, 184($t0)
    sw $t1, 188($t0)
    sw $t1, 192($t0)
    sw $t2, 196($t0)
    sw $t1, 200($t0)
    sw $t2, 204($t0)
    sw $t2, 208($t0)
    sw $t1, 212($t0)
    sw $t2, 216($t0)
    sw $t1, 220($t0)
    sw $t3, 224($t0)
    sw $t1, 228($t0)
    sw $t1, 232($t0)
    sw $t1, 236($t0)
    sw $t1, 240($t0)
    sw $t1, 244($t0)
    sw $t1, 248($t0)
    sw $t3, 252($t0)
    
    push($ra)
    pushi($t5, 15)
    pushi($t5, 10)
    pushi($t5, 8)
    pushi($t5, 8)
    push($t0)
    jal draw_rect
    pop($ra)
    jr $ra

    
draw_background:
    li $t0, 0xFFFFFFFF
    lw $t1, ADDR_DSPL
    # li $t1, 0x10008000
    lw $t2, SCREEN_WIDTH
    lw $t3, SCREEN_HEIGHT
    mult $t2, $t3
    mflo $t4 # screen width * height
    sll $t4, $t4, 2
    # li $t4 32776
    add $t5, $t1, $t4
    
    BACKGROUND_LOOP: bge $t1, $t5 END_BACKGROUND_LOOP
        sw $t0, 0($t1)
        addi $t1, $t1, 4
        j BACKGROUND_LOOP
    END_BACKGROUND_LOOP:
        jr $ra
        
        
END:
