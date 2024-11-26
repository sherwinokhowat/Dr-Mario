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

.macro BACKGROUND_SPRITE_CODE()
    0
.end_macro

.macro RED_UP_CAPSULE_SPRITE_CODE()
    1
.end_macro

.macro RED_DOWN_CAPSULE_SPRITE_CODE()
    2
.end_macro

.macro RED_LEFT_CAPSULE_SPRITE_CODE()
    3
.end_macro

.macro RED_RIGHT_CAPSULE_SPRITE_CODE()
    4
.end_macro

.macro BLUE_UP_CAPSULE_SPRITE_CODE()
    5
.end_macro

.macro BLUE_DOWN_CAPSULE_SPRITE_CODE()
    6
.end_macro

.macro BLUE_LEFT_CAPSULE_SPRITE_CODE()
    7
.end_macro

.macro BLUE_RIGHT_CAPSULE_SPRITE_CODE()
    8
.end_macro

.macro YELLOW_UP_CAPSULE_SPRITE_CODE()
    9
.end_macro

.macro YELLOW_DOWN_CAPSULE_SPRITE_CODE()
    10
.end_macro

.macro YELLOW_LEFT_CAPSULE_SPRITE_CODE()
    11
.end_macro

.macro YELLOW_RIGHT_CAPSULE_SPRITE_CODE()
    12
.end_macro

.macro RED_VIRUS_SPRITE_CODE()
    13
.end_macro

.macro BLUE_VIRUS_SPRITE_CODE()
    14
.end_macro

.macro YELLOW_VIRUS_SPRITE_CODE()
    15
.end_macro

.macro WALL_SPRITE_CODE()
    16
.end_macro

##############################################################################
# START DATA
##############################################################################

.data

##############################################################################
# Immutable Data
##############################################################################

# Allocate space at 0x10010000 so that bitmap at 0x10008000 won't overflow to other variables
.word 1:100000

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
    .word 56
    
MIN_TO_CLEAR:
    .word 4
    
    
##############################################################################
# Sprites data
##############################################################################
    
BACKGROUND_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000

RED_UP_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313

RED_DOWN_CAPSULE_SPRITE:
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x000000
    .word 0x000000

RED_LEFT_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313

RED_RIGHT_CAPSULE_SPRITE:
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x000000
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xf5f0f5
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x471313
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0xed1c24
    .word 0x471313
    .word 0x000000
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x471313
    .word 0x000000
    .word 0x000000

BLUE_UP_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699

BLUE_DOWN_CAPSULE_SPRITE:
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x000000

BLUE_LEFT_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699

BLUE_RIGHT_CAPSULE_SPRITE:
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0xf5f0f5
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x2f3699
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x00b7ef
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x000000

YELLOW_UP_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722

YELLOW_DOWN_CAPSULE_SPRITE:
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0x000000
    .word 0x000000

YELLOW_LEFT_CAPSULE_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722

YELLOW_RIGHT_CAPSULE_SPRITE:
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0x000000
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xf5f0f5
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0xCC7722
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xffc20e
    .word 0xCC7722
    .word 0x000000
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0xCC7722
    .word 0x000000
    .word 0x000000

RED_VIRUS_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0xe35f5f
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xe35f5f
    .word 0x000000
    .word 0xe35f5f
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xe35f5f
    .word 0x000000
    .word 0x000000
    .word 0xe35f5f
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xe35f5f
    .word 0x000000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0xff0000
    .word 0x000000
    .word 0x000000
    .word 0xff0000
    .word 0xff0000
    .word 0x000000
    .word 0x000000
    .word 0xff0000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0xa70000
    .word 0x000000
    .word 0xa70000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xa70000
    .word 0x000000

BLUE_VIRUS_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0x99d9ea
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x99d9ea
    .word 0x000000
    .word 0x99d9ea
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x99d9ea
    .word 0x000000
    .word 0x000000
    .word 0x99d9ea
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x99d9ea
    .word 0x000000
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x000000
    .word 0x000000
    .word 0x4d6df3
    .word 0x4d6df3
    .word 0x000000
    .word 0x000000
    .word 0x4d6df3
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x2f3699
    .word 0x000000
    .word 0x2f3699
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x2f3699
    .word 0x000000

YELLOW_VIRUS_SPRITE:
    .word 0x000000
    .word 0x000000
    .word 0xffde1a
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xffde1a
    .word 0x000000
    .word 0xffde1a
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xffde1a
    .word 0x000000
    .word 0x000000
    .word 0xffde1a
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffde1a
    .word 0x000000
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0xffce00
    .word 0x000000
    .word 0x000000
    .word 0xffce00
    .word 0xffce00
    .word 0x000000
    .word 0x000000
    .word 0xffce00
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0xffa700
    .word 0x000000
    .word 0xffa700
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xffa700
    .word 0x000000

WALL_SPRITE_LEFT:
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1
    
WALL_SPRITE_RIGHT:
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1

WALL_SPRITE_BOTTOM:
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1

WALL_SPRITE_TOP:  
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x4fc7e1
    
WALL_SPRITE_TOP_LEFT:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000

WALL_SPRITE_TOP_RIGHT:
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1

WALL_SPRITE_BOT_LEFT:
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1

WALL_SPRITE_BOT_RIGHT:
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0xcbf6ff    
    .word 0xcbf6ff    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x3f1189    
    .word 0x3f1189    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x4fc7e1    
    .word 0x4fc7e1    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
TOP_LEFT_WALL_SPRITE:
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0x000000    
.word 0x000000    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0x000000    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0x000000    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff    
.word 0xffffff
        
PAUSED_SPRITE:
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    
UNPAUSED_SPRITE:
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0xFFFFFF
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    .word 0x000000
    
    
##############################################################################
# LETTERS OF THE ALPHABET
##############################################################################

LETTER_G_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_V_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0x170073      
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0xb8b7b9          
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_C_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000

LETTER_O_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0x170073        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
        
LETTER_A_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_E_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_S_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_Y_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_M_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_D_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_I_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_U_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_H_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
LETTER_R_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
NUMBER_0_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0xb8b7b9    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002
    
NUMBER_1_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_2_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_3_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0xb8b7b9        
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_4_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_5_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_6_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_7_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
NUMBER_8_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000

NUMBER_9_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_T_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
HYPHEN_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x010002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x010002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0x170073     
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
                
                
LETTER_W_GREEN_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x010002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x010002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x010002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x36bb00    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9      
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000002    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_I_GREEN_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
    
LETTER_N_GREEN_SPRITE:
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0x36bb00      
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0xb8b7b9     
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000    
    .word 0x000000
            
##############################################################################
# Mutable Data
##############################################################################
canvas:
    .word 0:100000

draw_rectangle_colour_array:
    .word 0:100000 # 0:num of pixels of screen (width * height)
    
# bitmap to draw the bottle
bottle_bitmap:
    .byte 0
    .byte 0
    .byte 0
    .byte 20
    .byte 0
    .byte 0
    .byte 21
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 18
    .byte 0
    .byte 0
    .byte 19
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 18
    .byte 0
    .byte 0
    .byte 19
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 18
    .byte 0
    .byte 0
    .byte 19
    .byte 0
    .byte 0
    .byte 0
    .byte 20
    .byte 16
    .byte 16
    .byte 23
    .byte 0
    .byte 0
    .byte 22
    .byte 16
    .byte 16
    .byte 21
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 18
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 19
    .byte 22
    .byte 17
    .byte 17
    .byte 17
    .byte 17
    .byte 17
    .byte 17
    .byte 17
    .byte 17
    .byte 23
   
# bitmap to draw the actual game (playing field)
game_bitmap:
    .byte 0:1000 # 0: width * height of the game
    
# capsule x coordinate in game units
capsule_x:
    .word 0

# capsule y coordinate in game units
capsule_y:
    .word 0
    
# check whether we are loading the capsule
capsule_loading:
    .byte 0
    
# orientation of capsule (horizontal / vertical)
capsule_orientation:
    .byte 0
    
# Complete the word (4 bytes)
.byte 1
.byte 1
    
# Top most one
capsule_loading_1_left_color:
    .word 0
    
capsule_loading_1_right_color:
    .word 0
    
capsule_loading_2_left_color:
    .word 0
    
capsule_loading_2_right_color:
    .word 0
    
capsule_loading_3_left_color:
    .word 0
    
capsule_loading_3_right_color:
    .word 0
    
capsule_loading_4_left_color:
    .word 0
    
capsule_loading_4_right_color:
    .word 0
    
capsule_loading_5_left_color:
    .word 0
    
capsule_loading_5_right_color:
    .word 0

s_held:
    .word 0

gravity_speed: # how many ticks until one fall
    .word 50

gravity_timer:
    .word 0
    
difficulty: # 1 - 3 / easy / med / hard
    .word 1
    
score:
    .word 0
    
highscore:
    .word 0
    
max_viruses:
    .word 0
    
won:
    .word 0

##############################################################################
# START CODE
##############################################################################
.text
.globl main

##############################################################################
# CODE_ENTRANCE
##############################################################################
main:
    jal restart_game
    
    # Exit
    li $v0, 10  
    syscall

##############################################################################
# GAME LOOP
##############################################################################
game_loop:
    # DRAW BACKGROUND
    push($ra)
    jal draw_background
    pop($ra)
    # DRAW UNPAUSE SYMBOL
    push($ra)
    push_temps()
    li $t0, 225 # x
    push($t0)
    li $t0, 15 # y
    push($t0)
    li $t0, 16 # width
    push($t0)
    li $t0, 16 # height
    push($t0)
    la $t0, UNPAUSED_SPRITE
    push($t0)
    jal draw_rect
    pop_temps()
    pop($ra)
    
    # Draw difficulty
    jal draw_difficulty
    
    # Draw score
    jal draw_score_words
    jal draw_score_numbers
    
    # Draw highscore
    jal draw_highscore_words
    jal draw_highscore_numbers

    # Draw bitmaps
    jal draw_bottle_bitmap
    jal draw_game_bitmap
    jal push_canvas
    
    # Quit if done the game | we could make this be a cool game over screen or smth
    jal count_viruses
    # if v0 is 0, then i want to make t1 1
    sltiu $t1, $v0, 1
    sw $t1, won
    beq $v0, $zero, gameover_loop # won the game if 0 virus left, so quit
    
    jal handle_key_press
    
    # Check if gravity timer is up
    la $a0, gravity_timer
    lw $a1, gravity_speed
    jal run_timer # return in $v0
    
    # Skip timer if s is held
    lw $t0, s_held
    blez $t0, END_IF_S_HELD
    bgtz $t0, IF_S_HELD
    IF_S_HELD:
        li $v0, 1
    END_IF_S_HELD:
    
    # Run gravity
    beq $v0, $zero, END_IF_GRAVITY # Skip if timer is not up
    jal gravity
    bne $v0, $zero, IF_GRAVITY # If at least one thing was pulled by gravity
    beq $v0, $zero, IF_NOT_GRAVITY # If nothing was pulled by gravity
    IF_GRAVITY:
        j END_IF_GRAVITY
    IF_NOT_GRAVITY:
        jal clear_connected # v0 - returns 1 if clear, 0 otherwise
        lw $t9, score
        # if cleared something
        bne $v0, $zero, IF_CLEARED_SOMETHING
        beq $v0, $zero, END_IF_CLEARED_SOMETHING
        IF_CLEARED_SOMETHING:
            lw $t0, gravity_speed
            addi $t0, $t0, -2
            sw $t0, gravity_speed
            j END_IF_GRAVITY
        END_IF_CLEARED_SOMETHING:
        # if cleared nothing
        # add new capsule to bottle bitmap
        li $t0, 1
        sb $t0, capsule_loading
    END_IF_GRAVITY:

    j game_loop

run_timer:
    # load timer progress
    lw $t0, 0($a0)
    # increment timer progress
    addi $t0, $t0, 5
    # save incremented timer progress
    sw $t0, 0($a0)
    sge $t2, $t0, $a1 # t2 = timer progress >= timer interval
    beq $t2, $zero, CONT_TIMER
    # timer is passed
    sw $zero, 0($a0) # reset timer progress
    li $v0, 1 # return true
    jr $ra
    CONT_TIMER:
        li $v0, 0 # return false
        jr $ra
        
gameover_loop:
    
    
    # a while loop that waits until you press r to restart, or q to just quit
    push($ra)
    jal draw_gameover_words
    pop($ra)
    lw $t0, ADDR_KBRD # keyboard base address
    GAMEOVER_LOOP:
        lw $t8, 0($t0)    # Load first word from keyboard
        bne $t8, 1, GAMEOVER_LOOP # if keyboard is not pressed, stay here
        
        # keyboard is now pressed
        lw $t1, 4($t0) # load second word from keyboard
        
        # if it is q, then exit
        beq $t1, 0x71, handle_q_press
        # if it is not p, then keep looping
        bne $t1, 0x72, GAMEOVER_LOOP
    j restart_game
        
        
        
    
restart_game:
    # RESET GAME BITMAP
    li $t0, 0 # x loop variable
    li $t1, 0 # y loop variable
    
    lw $t2, GAME_WIDTH
    lw $t3, GAME_HEIGHT
    
    RESTART_GAME_LOOP_X: bge $t0, $t2, END_RESTART_GAME_LOOP_X
    
        li $t1, 0
        RESTART_GAME_LOOP_Y: bge $t1, $t3, END_RESTART_GAME_LOOP_Y
        
            push($ra)
            push_temps()
            push($t0)
            push($t1)
            push($zero)
            jal update_game_bitmap
            pop_temps()
            pop($ra)
    
            addi $t1, $t1, 1
            j RESTART_GAME_LOOP_Y
        END_RESTART_GAME_LOOP_Y:
        
        addi $t0, $t0, 1
        j RESTART_GAME_LOOP_X
    END_RESTART_GAME_LOOP_X:

    la $t9, game_bitmap
    
    # Check whether won and highscore > score
    
    lw $t2, won 
    
    beq $t2, $zero, UPDATE_WON_SKIP # skip if we did not win
    UPDATE_WON: # only update highscore if we won
        # otherwise, update score
        lw $t0, score
        lw $t1, highscore
        
        ble $t0, $t1, UPDATE_WON_SKIP # skip if score <= highscore
        sw $t0, highscore # socre > highscore, so update
    UPDATE_WON_SKIP:
    
    
    # RESET CAPSULE NEEDED
    li $t0, 1
    sb $t0, capsule_loading
    
    # RESET WIN
    sw $zero, won
    
    # RESET SCORE
    sw $zero, score

    # DRAW BACKGROUND
    push($ra)
    jal draw_background
    pop($ra)
    
    push($ra)
    jal difficulty_selection_loop
    pop($ra)

    # SPAWN VIRUSES
    push($ra)
    jal load_random_viruses
    pop($ra)
    
    # INIT BOTTLE
    push($ra)
    li $a0, 0
    jal update_bottle_bitmap
    pop($ra)
    
    # START GAME LOOP
    push($ra)
    jal game_loop
    pop($ra)
    
    jr $ra
    
        
pause_loop:
    # a while loop that waits until you press p to quit it 
    lw $t0, ADDR_KBRD # keyboard base address
    
    push($ra)
    push_temps()
    li $t0, 225
    push($t0)
    li $t0, 15
    push($t0)
    li $t0, 16
    push($t0)
    li $t0, 16
    push($t0)
    la $t0, PAUSED_SPRITE
    push($t0)
    jal draw_rect
    pop_temps()
    pop($ra)
    
    push($ra)
    push_temps()
    jal push_canvas
    pop_temps()
    pop($ra)
    
    PAUSE_WHILE_LOOP: 
        # TODO: DRAW PAUSE SYMBOL
        
        
        lw $t8, 0($t0)    # Load first word from keyboard
        bne $t8, 1, PAUSE_WHILE_LOOP # if keyboard is not pressed, stay here
    
    # keyboard is now pressed
    lw $t1, 4($t0) # load second word from keyboard
    
    # if it is q, then exit
    beq $t1, 0x71, handle_q_press
    # if it is not p, then keep looping
    bne $t1, 0x70, PAUSE_WHILE_LOOP
    
    
    
    # we pressed p so leave
    jr $ra
    
    
difficulty_selection_loop:
    
    # loop until we press enter
    li $a0, 0 # default selection - easy
    lw $s0, ADDR_KBRD # keyboard base address
    DIFFICULTY_SELECTION_LOOP: 
        # draw the modes
        push($ra)
        push($a0)
        jal draw_difficulty_selection
        pop($a0)
        pop($ra)
        
        # draw selection
        push($ra)
        jal draw_select
        pop($ra)
        
        # draw to canvas
        push($ra)
        jal push_canvas
        pop($ra)
        
        # now deal with keyboard stuff
    
        lw $t8, 0($s0)    # Load first word from keyboard
        bne $t8, 1, DIFFICULTY_SELECTION_LOOP # if keyboard is not pressed, stay here
        
        # keyboard is now pressed
        lw $t1, 4($s0) # load second word from keyboard
        
        # if it is q, then exit
        beq $t1, 0x71, handle_q_press
        # if it is s, then go down
        beq $t1, 0x73, DIFFICULTY_SELECTION_UP
        # if it is w, then go up
        beq $t1, 0x77, DIFFICULTY_SELECTION_DOWN
        # if it is enter, then select this difficulty and start
        beq $t1, 0xa, DIFFICULTY_SELECTION_SELECTED
        
        # else just repeat
        b DIFFICULTY_SELECTION_LOOP
        
        
        DIFFICULTY_SELECTION_UP:
            addi $a0, $a0, 1 # Increment selection
            # set a0 to the remainder of a0 / 3
            li $t0, 3        # Load the divisor (3) into $t0
            div $a0, $t0     # Divide $a0 by $t0 (3)
            mfhi $a0         # Move the remainder from HI to $a0
            b DIFFICULTY_SELECTION_LOOP
        DIFFICULTY_SELECTION_DOWN:
            addi $a0, $a0, -1 # Increment selection
            # if we are less than 0, then loop back
            bgez $a0, DIFFICULTY_SELECTION_LOOP
            DIFFICULTY_SELECTION_LOOP_BACK:
                li $a0, 2
            b DIFFICULTY_SELECTION_LOOP
        DIFFICULTY_SELECTION_SELECTED:
            addi $a0, $a0, 1 # add 1 since we had 0 - 2 for a0
            sw $a0, difficulty
            
            # easy if 1
            li $t0, 1
            beq $a0, $t0, EASY_SELECTED
            
            # medium if 2
            li $t0, 2
            beq $a0, $t0, MEDIUM_SELECTED
            
            # else hard
            b HARD_SELECTED
            EASY_SELECTED:
                # number of virus
                li $t0, 1
                sw $t0, max_viruses
                
                # gravity speed
                li $t0, 100
                sw $t0, gravity_speed
                jr $ra
            
            MEDIUM_SELECTED:
                li $t0, 8
                sw $t0, max_viruses
                
                # gravity speed
                li $t0, 50
                sw $t0, gravity_speed
                jr $ra
            
            HARD_SELECTED:
                li $t0, 12
                sw $t0, max_viruses
                
                # gravity speed
                li $t0, 25
                sw $t0, gravity_speed
                jr $ra
            
            
##############################################################################
# Update bottle bitmap
##############################################################################

# $a0 - mode (0/1) (load 5 new capsules/load 1 new capsule)
update_bottle_bitmap:
    push_temps()
    
    # mode 0: load 5 new capsule
    beq $a0, $zero, INIT_CAPSULES
    # mode 1: init 1 capsule
    bne $a0, $zero, INIT_ONE_CAPSULE
    
    INIT_CAPSULES:
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t0, $a0, 2 # multiply by 4
        addi $t0, $t0, 3
        sw $t0, capsule_loading_1_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t1, $a0, 2 # multiply by 4
        addi $t1, $t1, 4
        sw $t1, capsule_loading_1_right_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t2, $a0, 2 # multiply by 4
        addi $t2, $t2, 3
        sw $t2, capsule_loading_2_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t3, $a0, 2 # multiply by 4
        addi $t3, $t3, 4
        sw $t3, capsule_loading_2_right_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t4, $a0, 2 # multiply by 4
        addi $t4, $t4, 3
        sw $t4, capsule_loading_3_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t5, $a0, 2 # multiply by 4
        addi $t5, $t5, 4
        sw $t5, capsule_loading_3_right_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t6, $a0, 2 # multiply by 4
        addi $t6, $t6, 3
        sw $t6, capsule_loading_4_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t7, $a0, 2 # multiply by 4
        addi $t7, $t7, 4
        sw $t7, capsule_loading_4_right_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t8, $a0, 2 # multiply by 4
        addi $t8, $t8, 3
        sw $t8, capsule_loading_5_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t9, $a0, 2 # multiply by 4
        addi $t9, $t9, 4
        sw $t9, capsule_loading_5_right_color
        
        la $s0, bottle_bitmap # get bottle bitmap array address
        
        sb $t0, 4($s0)
        sb $t1, 5($s0)
        sb $t2, 14($s0)
        sb $t3, 15($s0)
        sb $t4, 24($s0)
        sb $t5, 25($s0)
        sb $t6, 34($s0)
        sb $t7, 35($s0)
        sb $t8, 44($s0)
        sb $t9, 45($s0)
        
        j END_INIT_CAPSULES
    INIT_ONE_CAPSULE:
        lw $t8, capsule_loading_2_left_color
        sw $t8, capsule_loading_1_left_color
        lw $t6, capsule_loading_3_left_color
        sw $t6, capsule_loading_2_left_color
        lw $t4, capsule_loading_4_left_color
        sw $t4, capsule_loading_3_left_color
        lw $t2, capsule_loading_5_left_color
        sw $t2, capsule_loading_4_left_color
        
        lw $t9, capsule_loading_2_right_color
        sw $t9, capsule_loading_1_right_color
        lw $t7, capsule_loading_3_right_color
        sw $t7, capsule_loading_2_right_color
        lw $t5, capsule_loading_4_right_color
        sw $t5, capsule_loading_3_right_color
        lw $t3, capsule_loading_5_right_color
        sw $t3, capsule_loading_4_right_color
       
    
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t0, $a0, 2 # multiply by 4
        addi $t0, $t0, 3
        sw $t0, capsule_loading_5_left_color
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 3 # upper bound (exclusive)
        syscall # the return is stored in $a0
        sll $t1, $a0, 2 # multiply by 4
        addi $t1, $t1, 4
        sw $t1, capsule_loading_5_right_color
        
        la $s0, bottle_bitmap # get bottle bitmap array address
        
        sb $t0, 4($s0)
        sb $t1, 5($s0)
        sb $t2, 14($s0)
        sb $t3, 15($s0)
        sb $t4, 24($s0)
        sb $t5, 25($s0)
        sb $t6, 34($s0)
        sb $t7, 35($s0)
        sb $t8, 44($s0)
        sb $t9, 45($s0)
    END_INIT_CAPSULES:

    pop_temps()
    jr $ra

##############################################################################
# KEYBOARD FUNCTIONS
##############################################################################

handle_key_press:
    # Key pressed logic 
    # Let's handle S first so that we can get the hard stuff out the way frfr
    lw $t0, ADDR_KBRD              
    lw $t8, 0($t0)                      # Load first word from keyboard
    bne $t8, 1, skip_handle_key_press      # If keyboard not pressed

    lw $a0, 4($t0)                  # Load second word from keyboard

    beq $a0, 0x71, handle_q_press     # done
    beq $a0, 0x61, handle_a_press    
    beq $a0, 0x64, handle_d_press
    beq $a0, 0x77, handle_w_press
    beq $a0, 0x70, pause_loop # P -> pause loop
    
     beq $a0, 0x73, HANDLE_S
    HANDLE_S:
        push($ra)
        jal handle_s_press
        pop($ra)
        j done
    HANDLE_S_END:
    
    
    skip_handle_key_press:

    push($ra)
        jal handle_s_unpress
        pop($ra)
    done:
    jr $ra

handle_q_press:
    # Exit
    li $v0, 10  
    syscall
    

handle_s_press:
    li $t0, 1
    sw $t0, s_held
    jr $ra

handle_s_unpress:
    li $t0, 0
    sw $t0, s_held
    jr $ra
    
handle_a_press:
    # Capsule loading => do nothing
    lb $t0, capsule_loading
    bne $t0, $zero, END_HANDLE_A_PRESS

    # Check collision
    push($ra)
    push_temps()
    li $a0, 2
    lw $a1, capsule_x
    lw $a2, capsule_y
    lb $a3, capsule_orientation
    jal check_collision_capsule 
    pop_temps()
    pop($ra)
    bne $v0, $zero, END_HANDLE_A_PRESS
    
    # Move the capsule
    push($ra)
    push_temps()
    li $a0, -1
    li $a1, 0
    lw $a2, capsule_x
    lw $a3, capsule_y
    lb $t2, capsule_orientation
    jal move_capsule
    pop_temps()
    pop($ra)
    
    lw $t0, capsule_x
    addi $t9, $t0, -1
    sw $t9, capsule_x
    
    jr $ra
    
    END_HANDLE_A_PRESS:
        jr $ra

handle_d_press:
    # Capsule loading => do nothing
    lb $t0, capsule_loading
    bne $t0, $zero, END_HANDLE_D_PRESS

    # Check collision
    push($ra)
    push_temps()
    li $a0, 3
    lw $a1, capsule_x
    lw $a2, capsule_y
    lb $a3, capsule_orientation
    jal check_collision_capsule 
    pop_temps()
    pop($ra)
    bne $v0, $zero, END_HANDLE_D_PRESS
    
    # Move the capsule
    push($ra)
    push_temps()
    li $a0, 1
    li $a1, 0
    lw $a2, capsule_x
    lw $a3, capsule_y
    lb $t2, capsule_orientation
    jal move_capsule
    pop_temps()
    pop($ra)
    
    lw $t0, capsule_x
    addi $t9, $t0, 1
    sw $t9, capsule_x
    
    jr $ra
    
    END_HANDLE_D_PRESS:
        jr $ra

handle_w_press:
    # Capsule loading => do nothing
    lb $t0, capsule_loading
    bne $t0, $zero, END_HANDLE_W_PRESS
    
    push($ra)
    jal rotate_capsule
    pop($ra)
    
    END_HANDLE_W_PRESS:
        jr $ra

##############################################################################
# CAPSULE MOVEMENT FUNCTIONS
##############################################################################

# Arguments
# $a0 - direction (0/1/2/3) (UP/DOWN/LEFT/RIGHT)
# $a1 - x
# $a2 - y
# $a3 - orientation (0/1) (HORIZONTAL/VERT)
# Returns
# $v0 - colliding (0/1)
check_collision_capsule:
    # lb $t0, capsule_x
    # lb $t1, capsule_y
    # lb $t2, capsule_orientation
    add $t0, $a1, $zero
    add $t1, $a2, $zero
    add $t2, $a3, $zero
    
    beq $t2, $zero, CHECK_HORIZONTAL_COLLISION
    CHECK_VERTICAL_COLLISION:
        addi $t3, $t0, 0 # other x = capsulex 
        addi $t4, $t1, -1 # other y = capsuley - 1
        
        # Check going up
        li $t5, 0 # constant t5 = 0
        beq $a0, $t5, CHECK_VERTICAL_COLLISION_UP
        
        # Check going down
        li $t5, 1 # constant t5 = 1
        beq $a0, $t5, CHECK_VERTICAL_COLLISION_DOWN
        
        # Check going left
        li $t5, 2 # constant t5 = 2
        beq $a0, $t5, CHECK_VERTICAL_COLLISION_LEFT
        
        # Check going right
        li $t5, 3 # constant t5 = 3
        beq $a0, $t5, CHECK_VERTICAL_COLLISION_RIGHT
        
        # error 
        j CHECK_COLLISION_CAPSULE_RETURN
        
        CHECK_VERTICAL_COLLISION_UP:
            # Check right capsule going up 
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, -1 # dirY
            
            # NOTE: only need to check other capsule going up 
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_VERTICAL_COLLISION_DOWN:
            # Check bottom capsule going down 
            add $a0, $zero, $t0 # capsulex 
            add $a1, $zero, $t1 # capsuley
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, 1 # dirY
            
            # NOTE: only need to check bottom capsule going down 
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_VERTICAL_COLLISION_LEFT:
            # Check bottom capsule going left
            add $a0, $zero, $t0 # capsule_x
            add $a1, $zero, $t1 # capsule_y
            addi $a2, $zero, -1 # dirX
            addi $a3, $zero, 0 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            
            # Check top capsule going left
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, -1 # dirX
            addi $a3, $zero, 0 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_VERTICAL_COLLISION_RIGHT:
            # Check bottom capsule going right
            add $a0, $zero, $t0 # capsule_x
            add $a1, $zero, $t1 # capsule_y
            addi $a2, $zero, 1 # dirX
            addi $a3, $zero, 0 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            
            # Check top capsule going right
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, 1 # dirX
            addi $a3, $zero, 0 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
    
    CHECK_HORIZONTAL_COLLISION:
        addi $t3, $t0, 1 # other x = capsulex + 1
        addi $t4, $t1, 0 # other y = capsuley
        
        # Check going up
        li $t5, 0 # constant t5 = 0
        beq $a0, $t5, CHECK_HORIZONTAL_COLLISION_UP
        
        # Check going down
        li $t5, 1 # constant t5 = 1
        beq $a0, $t5, CHECK_HORIZONTAL_COLLISION_DOWN
        
        # Check going left
        li $t5, 2 # constant t5 = 2
        beq $a0, $t5, CHECK_HORIZONTAL_COLLISION_LEFT
        
        # Check going right
        li $t5, 3 # constant t5 = 3
        beq $a0, $t5, CHECK_HORIZONTAL_COLLISION_RIGHT
        
        CHECK_HORIZONTAL_COLLISION_UP:
            # Check left capsule going up
            add $a0, $zero, $t0 # capsule_x
            add $a1, $zero, $t1 # capsule_y
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, -1 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            
            # Check right capsule going up 
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, -1 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_HORIZONTAL_COLLISION_DOWN:
            # Check left capsule going down
            add $a0, $zero, $t0 # capsule_x
            add $a1, $zero, $t1 # capsule_y
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, 1 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            
            # Check right capsule going down 
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, 0 # dirX
            addi $a3, $zero, 1 # dirY
            
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_HORIZONTAL_COLLISION_LEFT:
            # Check left capsule going left
            add $a0, $zero, $t0 # capsule_x
            add $a1, $zero, $t1 # capsule_y
            addi $a2, $zero, -1 # dirX
            addi $a3, $zero, 0 # dirY
            
            # NOTE: Only need to check left capsule
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
        CHECK_HORIZONTAL_COLLISION_RIGHT:
            # Check right capsule going right 
            add $a0, $zero, $t3 # otherX 
            add $a1, $zero, $t4 # otherY
            addi $a2, $zero, 1 # dirX
            addi $a3, $zero, 0 # dirY
            
            # NOTE: Only need to check right capsule
            push($ra)
            push_temps()
            jal check_collision # return value stored in v0
            pop_temps()
            pop($ra)
            bne $v0, $zero, CHECK_COLLISION_CAPSULE_RETURN # return if collision
            j CHECK_COLLISION_CAPSULE_RETURN # end of check
        
    CHECK_COLLISION_CAPSULE_RETURN:
        # return value already stored in v0, so just return
        jr $ra
        

# Arguments
# $a0 - x
# $a1 - y
# $a2 - direction x
# $a3 - direction y
# Returns
# $v0 - colliding (0/1)
check_collision:
    # check collision
    add $t1, $a0, $a2 # x + dirX
    add $t2, $a1, $a3 # y + dirY
    lw $t3, GAME_WIDTH
    lw $t4, GAME_HEIGHT
    la $t5, game_bitmap
    
    
    # check out of bounds
    blt $t1, $zero, IF_CHECK_COLLISION_OUT_BOUNDS
    bge $t1, $t3, IF_CHECK_COLLISION_OUT_BOUNDS
    blt $t2, $zero, IF_CHECK_COLLISION_OUT_BOUNDS
    bge $t2, $t4, IF_CHECK_COLLISION_OUT_BOUNDS
    j END_IF_CHECK_COLLISION_OUT_BOUNDS
    IF_CHECK_COLLISION_OUT_BOUNDS:
        li $v0, 1
        jr $ra
    END_IF_CHECK_COLLISION_OUT_BOUNDS:
    
    # Check other object
    push($ra)
    push($t1)
    push($t2)
    push($t3)
    push($t4)
    push($t5)
    jal get_value_in_bitmap
    pop($ra)
    
    # v0 = v0
    jr $ra
    

# Arguments
# a0 - dirX
# a1 - dirY
# a2 - x
# a3 - y
# t2 - orientation
move_capsule:
    # lb $t0, capsule_x
    # lb $t1, capsule_y
    # lb $t2, capsule_orientation
    add $t0, $a2, $zero
    add $t1, $a3, $zero
    # t2 already there
    
    beq $t2, $zero, MOVE_CAPSULE_HORIZONTAL
    MOVE_CAPSULE_VERTICAL:
        addi $t3, $t0, 0 # other x = capsulex 
        addi $t4, $t1, -1 # other y = capsuley - 1
        j MOVE_CAPSULE_ERASE
    
    MOVE_CAPSULE_HORIZONTAL:
        addi $t3, $t0, 1 # other x = capsulex + 1
        addi $t4, $t1, 0 # other y = capsuley
        j MOVE_CAPSULE_ERASE
        
    MOVE_CAPSULE_ERASE:
        lw $t6, GAME_WIDTH
        lw $t7, GAME_HEIGHT
        la $t5, game_bitmap
        
        # -- Get capsule colours / codes -- 
        # Get code of Left / Bottom capsule
        push($ra)
        push_temps()
        push($t0)
        push($t1)
        push($t6)
        push($t7)
        push($t5)
        jal get_value_in_bitmap # return value in v0
        pop_temps()
        pop($ra)
        add $t8, $zero, $v0 # store Left / Bottom code
        
        # Get code of Right / Top capsule
        push($ra)
        push_temps()
        push($t3)
        push($t4)
        push($t6)
        push($t7)
        push($t5)
        jal get_value_in_bitmap # return value in v0
        pop_temps()
        pop($ra)
        add $t9, $zero, $v0 # store Right / Top code
        
        # ----- Erase -----
        
        # Left / Bottom capsule
        push($ra)
        push_temps()
        push($t0)
        push($t1)
        push($zero)
        jal update_game_bitmap
        pop_temps()
        pop($ra)
        
        # Right / Top capsule
        push($ra)
        push_temps()
        push($t3)
        push($t4)
        push($zero)
        jal update_game_bitmap
        pop_temps()
        pop($ra)
    
    MOVE_CAPSULE_DRAW:
        
        # -- Draw the updated capsule -- 
        # Left / Bottom capsule
        push($ra)
        push_temps()
        add $t0, $t0, $a0 # x = capsulex + dirX
        push($t0)
        add $t1, $t1, $a1 # y = capsuley + dirY
        push($t1)
        push($t8)
        jal update_game_bitmap
        pop_temps()
        pop($ra)
        
        # Right / Top capsule
        push($ra)
        push_temps()
        add $t3, $t3, $a0 # x = otherx + dirX
        push($t3)
        add $t4, $t4, $a1 # y = othery + dirY
        push($t4)
        push($t9)
        jal update_game_bitmap
        pop_temps()
        pop($ra)
        
        # Update capsule x and y 
        
        jr $ra
        
        
    
    
    
    
# Rotate capsule clockwise
# Won't rotate if collides
rotate_capsule:
    lb $t0, capsule_x
    lb $t1, capsule_y
    lb $t2, capsule_orientation
    
    beq $t2, $zero, ROTATE_HORIZONTAL
    ROTATE_VERTICAL:
        # Return if left collides on right
        push($ra)
        push_temps()
        add $a0, $t0, $zero # x
        add $a1, $t1, $zero # y
        li $a2, 1 # dirX
        li $a3, 0 # dirY
        jal check_collision # returns in $v0
        pop_temps()
        pop($ra)
        bne $v0, $zero END_ROTATE
    
        addi $t3, $t0, 0 # other x = capsulex
        addi $t4, $t1, -1 # other y = capsuley - 1
        
        # Top to right
        push($ra)
        push_temps()
        add $a0, $t3, $zero # otherX
        add $a1, $t4, $zero # otherY
        li $a2, 1 # Move right
        li $a3, 1 # Move down
        pushi($t0, 3)
        jal translate_game_bit
        pop_temps()
        pop($ra)
        
        # rotate left
        push($ra)
        push_temps()
        add $a0, $t0, $zero # capsule x
        add $a1, $t1, $zero # capsule y
        li $a2, 0 # Stay same
        li $a3, 0 # Stay same
        pushi($t0, 1)
        jal translate_game_bit
        pop_temps()
        pop($ra)
        
        li $t0, 0
        sb $t0, capsule_orientation
        
        j END_ROTATE
        
    ROTATE_HORIZONTAL:
        # Return if left collides on top
        push($ra)
        push_temps()
        add $a0, $t0, $zero # x
        add $a1, $t1, $zero # y
        li $a2, 0 # dirX
        li $a3, -1 # dirY
        jal check_collision # returns in $v0
        pop_temps()
        pop($ra)
        bne $v0, $zero END_ROTATE
    
        addi $t3, $t0, 1 # other x = capsulex + 1
        addi $t4, $t1, 0 # other y = capsuley
        
        # left goes to top
        push($ra)
        push_temps()
        add $a0, $t0, $zero # capsuleX
        add $a1, $t1, $zero # capsuleY
        li $a2, 0 # X stays the same
        li $a3, -1 # Move up
        pushi($t0, -2)
        jal translate_game_bit
        pop_temps()
        pop($ra)
        
        # right goes to left
        push($ra)
        push_temps()
        add $a0, $t3, $zero # otherX
        add $a1, $t4, $zero # otherY
        li $a2, -1 # Move left
        li $a3, 0 # Y stays the same
        pushi($t0, -2)
        jal translate_game_bit
        pop_temps()
        pop($ra)
        
        li $t0, 1
        sb $t0, capsule_orientation
    
    END_ROTATE:
        jr $ra
        
        
        
    
    
    # Get capsule position
    # Get capsule rotation
    
    

##############################################################################
# GAME BITMAP HELPER FUNCTIONS
##############################################################################

# Returns the number of virus in the game
# Arguments:
# - None
# Returns:
# v0 - the number of virus
count_viruses:
    lw $t0, GAME_WIDTH
    lw $t1, GAME_HEIGHT
    li $s3, 0 # count variable
    
    # x loop
    li $s0, 0
    COUNT_VIRUSES_X_LOOP: bge $s0, $t0, END_COUNT_VIRUSES_X_LOOP
        # y loop
        li $s1, 0
        COUNT_VIRUSES_Y_LOOP: bge $s1, $t1, END_COUNT_VIRUSES_Y_LOOP
            push($ra)
            push_temps()
            add $a0, $zero, $s0 # x
            add $a1, $zero, $s1 # y
            jal get_value_in_game_bitmap # (x,y) - return value in v0
            pop_temps()
            pop($ra)
            
            li $t3, 13 # red virus
            beq $v0, $t3, IF_VIRUS
            li $t3, 14 # blue virus
            beq $v0, $t3, IF_VIRUS
            li $t3, 15 # yellow virus
            beq $v0, $t3, IF_VIRUS
            
            j END_IF_VIRUS # else 
            IF_VIRUS: 
                # increment count
                addi $s3, $s3, 1
            END_IF_VIRUS:
        
            addi $s1, $s1, 1 # increment y
            j COUNT_VIRUSES_Y_LOOP
        END_COUNT_VIRUSES_Y_LOOP:
            addi $s0, $s0, 1 # increment x
            j COUNT_VIRUSES_X_LOOP
    END_COUNT_VIRUSES_X_LOOP:
    # put count in v0
    add $v0, $zero, $s3
    # return
    jr $ra


# checks clears
# returns v1 - 1 if cleared something, 0 otherwise
clear_connected:
    # s0 = game_width
    # s1 = game_height
    # s2 = min_to_clear
    # s3 = y (loop variable)
    # s4 = size (loop variable)
    # s5 = startx (loop variable)
    # t0 = NUM_COLS - size (constant)
    # t1 = same (bool)
    # t2 = y * game_width + startx (index)
    # t3 = base address of game_bitmap array

    lw $s0, GAME_WIDTH
    lw $s1, GAME_HEIGHT
    lw $s2, MIN_TO_CLEAR
    
    li $t9, 0 # this is our return value, whether we have cleared something
    
    # for y in range(GAME_HEIGHT)
    li $s3, 0
    CLEAR_Y_LOOP: bge $s3, $s1, END_CLEAR_Y_LOOP # break if y >= game_height
        add $s4, $zero, $s0 # s4 = game width / num_rows = size
        CLEAR_SIZE_LOOP: blt $s4, $s2, END_CLEAR_SIZE_LOOP # break if size < min_to_clear
            
            # INNER LOOP STUFF
            # for startX
            li $s5, 0 # startX
            sub $t0, $s0, $s4 # t0 = NUM_COLS - size
            
            CLEAR_STARTX_LOOP: bgt $s5, $t0 END_CLEAR_STARTX_LOOP
                li $t1, 1 # same = true
                
                # trying to get a[y][startX]
                # index = (y * game_width + startx)
                mult $s3, $s0
                mflo $t2 
                add $t2, $t2, $s5 # <- this is the index in the array
                
                la $t3, game_bitmap
                add $t3, $t3, $t2 # base address + index
                
                lb $t4, 0($t3) # a[y][startX]
                beq $t4, $zero, CLEAR_STARTX_LOOP_ENDIF # do not continue if black
                     
                
                # NEXT LOOP YIPPEE
                add $s6, $zero, $s5 # s6 = startX = i
                add $t5, $s5, $s4 # t5 = startX + size (constant)
                
                CLEAR_I_LOOP: bge $s6, $t5, END_CLEAR_I_LOOP
                    # a[y][i]
                    # y * game_width + i
                    mult $s3, $s0
                    mflo $t2 
                    add $t2, $t2, $s6 # <- this is the index in the array
                    
                    la $t3, game_bitmap
                    add $t3, $t3, $t2 # base address + index
                    
                    lb $t6, 0($t3) # a[y][i]
                    
                    # if a[y][i] != first:
                    add $a0, $zero, $t4
                    add $a1, $zero, $t6
                    push($ra)
                    push_temps()
                    jal check_same_colour # - return in v0
                    pop_temps()
                    pop($ra)
                    CLEAR_I_LOOP_IF: bne $v0, $zero, CLEAR_I_LOOP_ENDIF 
                        li $t1, 0 # same = false 
                    CLEAR_I_LOOP_ENDIF:
                     
                    addi $s6, $s6, 1
                    j CLEAR_I_LOOP
                END_CLEAR_I_LOOP:
                
                CLEAR_STARTX_LOOP_IF: beq $t1, $zero, CLEAR_STARTX_LOOP_ENDIF
                    add $s7, $zero, $s5
                    add $t5, $s5, $s4 # t5 = startX + size (constant)
                    CLEAR_J_LOOP: bge $s7, $t5, END_CLEAR_J_LOOP
                        #  x = j, y
                        li $t9, 1 # we cleared something
                        
                        # What did we clear 
                        # ------  Get value from bitmap ------ 
                        push($ra)
                        push($v0)
                        push($a0)
                        push($a1)
                        push_temps()
                        
                        add $a0, $zero, $s7
                        add $a1, $zero, $s3
                        jal get_value_in_game_bitmap # return in v0
                        
                        pop_temps()
                        pop($a1)
                        pop($a0)
                        # if virus
                        push_temps()
                        li $t0, 13 
                        blt $v0, $t0, FIRST_IF_CAPSULE # < 13 implies 
                        FIRST_IF_VIRUS:
                            lw $t0, score
                            lw $t1, difficulty
                            sll $t1, $t1, 1 # multiply by 2
                            add $t0, $t0, $t1 # so score = score + 2 * difficulty
                            sw $t0, score # store score in memory
                            j END_FIRST_IF
                        FIRST_IF_CAPSULE:
                            lw $t0, score
                            lw $t1, difficulty
                            add $t0, $t0, $t1 # score = score + difficulty
                            sw $t0, score # store score in memory
                            j END_FIRST_IF
                        END_FIRST_IF:
                        pop_temps()
                        pop($v0)
                        pop($ra)
                        
                        # ------ got the value from bitmap ------ 
                        
                        push($ra)
                        push_temps()
                        push($s7)
                        push($s3)
                        push($zero)
                        jal update_game_bitmap
                        pop_temps()
                        pop($ra)
                        
                        # ----- DRAWING HERE FOR ANIMATION -----
                        push($ra)
                        push_temps()
                        jal draw_game_bitmap
                        pop_temps()
                        pop($ra)
                        
                        push($ra)
                        push_temps()
                        jal push_canvas
                        pop_temps()
                        pop($ra)

                        # wait 0.1 second
                        li $v0, 32
                        li $a0, 100
                        syscall
                        # ----- DRAWING END FOR ANIMATION -----
                    
                        addi $s7, $s7, 1
                        j CLEAR_J_LOOP
                    END_CLEAR_J_LOOP:
                CLEAR_STARTX_LOOP_ENDIF:                
                
                addi $s5, $s5, 1
                j CLEAR_STARTX_LOOP
            END_CLEAR_STARTX_LOOP:
            
            
            
            # INNER LOOP STUFF END
            
            addi $s4, $s4, -1
            j CLEAR_SIZE_LOOP
        END_CLEAR_SIZE_LOOP:
        addi $s3, $s3, 1
        j CLEAR_Y_LOOP
    END_CLEAR_Y_LOOP:
    
    # s0 = game_width
    # s1 = game_height
    # s2 = min_to_clear
    # s3 = x (loop variable)
    # s4 = size (loop variable)
    # s5 = starty (loop variable)
    # t0 = NUM_COLS - size (constant)
    # t1 = same (bool)
    # t2 = startY * game_width + x (index)
    # t3 = base address of game_bitmap array

    lw $s0, GAME_WIDTH
    lw $s1, GAME_HEIGHT
    lw $s2, MIN_TO_CLEAR
    
    # for x in range(GAME_WIDTH)
    li $s3, 0
    CLEAR_Y_LOOP_2: bge $s3, $s0, END_CLEAR_Y_LOOP_2 # break if x >= game_width
        add $s4, $zero, $s1 # s4 = game height / num_cols = size
        CLEAR_SIZE_LOOP_2: blt $s4, $s2, END_CLEAR_SIZE_LOOP_2 # break if size < min_to_clear
            
            # INNER LOOP STUFF
            # for startY
            li $s5, 0 # startY
            sub $t0, $s1, $s4 # t0 = NUM_ROWS - size
            
            CLEAR_STARTX_LOOP_2: bgt $s5, $t0 END_CLEAR_STARTX_LOOP_2
                li $t1, 1 # same = true
                
                # trying to get a[startY][x]
                # index = (startY * game_width + x)
                mult $s5, $s0
                mflo $t2 
                add $t2, $t2, $s3 # <- this is the index in the array
                
                la $t3, game_bitmap
                add $t3, $t3, $t2 # base address + index
                
                lb $t4, 0($t3) # a[startY][x]
                beq $t4, $zero, CLEAR_STARTX_LOOP_ENDIF_2 # do not continue if black
                
                # NEXT LOOP YIPPEE
                add $s6, $zero, $s5 # s6 = startY = i
                add $t5, $s5, $s4 # t5 = startY + size (constant)
                
                CLEAR_I_LOOP_2: bge $s6, $t5, END_CLEAR_I_LOOP_2
                    # a[i][x]
                    # i * game_width + x
                    mult $s6, $s0
                    mflo $t2 
                    add $t2, $t2, $s3 # <- this is the index in the array
                    
                    la $t3, game_bitmap
                    add $t3, $t3, $t2 # base address + index
                    
                    lb $t6, 0($t3) # a[i][x]
                    
                    # if a[i][x] != first:
                    # t7 = (a[i][x] != first)
                    add $a0, $zero, $t4
                    add $a1, $zero, $t6
                    push($ra)
                    push_temps()
                    jal check_same_colour # - return in v0
                    pop_temps()
                    pop($ra)
                    CLEAR_I_LOOP_IF_2: bne $v0, $zero, CLEAR_I_LOOP_ENDIF_2
                        li $t1, 0 # same = false 
                    CLEAR_I_LOOP_ENDIF_2:
                     
                    addi $s6, $s6, 1
                    j CLEAR_I_LOOP_2
                END_CLEAR_I_LOOP_2:
                
                CLEAR_STARTX_LOOP_IF_2: beq $t1, $zero, CLEAR_STARTX_LOOP_ENDIF_2
                    add $s7, $zero, $s5
                    add $t5, $s5, $s4 # t5 = startY + size (constant)
                    CLEAR_J_LOOP_2: bge $s7, $t5, END_CLEAR_J_LOOP_2
                        #  x, y = j
                        li $t9, 1 # we cleared something
                        
                        # What did we clear 
                        # ------  Get value from bitmap ------ 
                        push($ra)
                        push($v0)
                        push($a0)
                        push($a1)
                        push_temps()
                        
                        add $a0, $zero, $s3
                        add $a1, $zero, $s7
                        jal get_value_in_game_bitmap # return in v0
                        
                        pop_temps()
                        pop($a1)
                        pop($a0)
                        # if virus
                        push_temps()
                        li $t0, 13 
                        blt $v0, $t0, SECOND_IF_CAPSULE # < 13 implies 
                        SECOND_IF_VIRUS:
                            lw $t0, score
                            lw $t1, difficulty
                            sll $t1, $t1, 1 # multiply by 2
                            add $t0, $t0, $t1 # so score = score + 2 * difficulty
                            sw $t0, score # store score in memory
                            j END_SECOND_IF
                        SECOND_IF_CAPSULE:
                            lw $t0, score
                            lw $t1, difficulty
                            add $t0, $t0, $t1 # score = score + difficulty
                            sw $t0, score # store score in memory
                            j END_SECOND_IF
                        END_SECOND_IF:
                        pop_temps()
                        pop($v0)
                        pop($ra)
                        
                        # ------ got the value from bitmap ------ 
                        
                        push($ra)
                        push_temps()
                        push($s7)
                        push($s3)
                        push($zero)
                        jal update_game_bitmap
                        pop_temps()
                        pop($ra)
                        
                        push($ra)
                        push_temps()
                        push($s3)
                        push($s7)
                        push($zero)
                        jal update_game_bitmap
                        pop_temps()
                        pop($ra)
                        
                        # ----- DRAWING HERE FOR ANIMATION -----
                        push($ra)
                        push_temps()
                        jal draw_game_bitmap
                        pop_temps()
                        pop($ra)
                        
                        push($ra)
                        push_temps()
                        jal push_canvas
                        pop_temps()
                        pop($ra)

                        # wait 0.1 second
                        li $v0, 32
                        li $a0, 100
                        syscall
                        # ----- DRAWING END FOR ANIMATION -----
                    
                        addi $s7, $s7, 1
                        j CLEAR_J_LOOP_2
                    END_CLEAR_J_LOOP_2:
                CLEAR_STARTX_LOOP_ENDIF_2:                
                
                addi $s5, $s5, 1
                j CLEAR_STARTX_LOOP_2
            END_CLEAR_STARTX_LOOP_2:
            
            # INNER LOOP STUFF END
            
            addi $s4, $s4, -1
            j CLEAR_SIZE_LOOP_2
        END_CLEAR_SIZE_LOOP_2:
        addi $s3, $s3, 1
        j CLEAR_Y_LOOP_2
    END_CLEAR_Y_LOOP_2:
    
    push($ra)
    push_temps()
    jal mark_disconnected
    pop_temps()
    pop($ra)
    
    # put return value in v0
    add $v0, $zero, $t9 # t9 = 1 if we cleared something
    jr $ra
    
    
# need_clear = true

# Returns:
# v0 - 0/1 ; return whether anything dropped
gravity:
    # anything dropped
    li $t6, 0
    # Check whether we are in a load capsule state ! 
    lb $t0, capsule_loading
    li $t1, 1 # $t1 = 1
    
    beq $t0, $t1, S_LOAD_CAPSULE_CASE_1 # if load state = 1
    j S_LOAD_CAPSULE_CASE_1_END # if load state != 1
    S_LOAD_CAPSULE_CASE_1:
        # if capsule loading = 1
    
        # turn load capsule off
        sb $zero, capsule_loading
        
        # ----- Get the colours from the bitmap -----
        
        # left side of capsule:
        addi $t0, $zero, 4 
        addi $t1, $zero, 4 
        li $t2, 10
        li $t3, 20 
        la $t4, bottle_bitmap
        
        push($ra)
        push_temps()
        push($t0) # x
        push($t1) # y
        push($t2) # width
        push($t3) # height
        push($t4) 
        jal get_value_in_bitmap # return value in $v0
        add $s5, $zero, $v0
        pop_temps()
        pop($ra)
        
        # right side of capsule:
        addi $t0, $zero, 5
        addi $t1, $zero, 4 
        li $t2, 10
        li $t3, 20 
        la $t4, bottle_bitmap
        
        push($ra)
        push_temps()
        push($t0) # x
        push($t1) # y
        push($t2) # width
        push($t3) # height
        push($t4)
        jal get_value_in_bitmap  # return value in $v0
        add $s6, $zero, $v0
        pop_temps()
        pop($ra)
        
        # ----- Check collision -----
        li $a0, 3
        li $a1, 0
        li $a2, 0
        li $a3, 0
        push($ra)
        push_temps()
        jal check_collision 
        pop_temps()
        pop($ra)
        bne $v0, $zero, gameover_loop #!!!
        
        li $a0, 4
        li $a1, 0
        li $a2, 0
        li $a3, 0
        push($ra)
        push_temps()
        jal check_collision 
        pop_temps()
        pop($ra)
        bne $v0, $zero, gameover_loop
        
        # ----- Draw -----
        
        # left side
        push_temps()
        push($ra)
        pushi($t0, 3) # x
        pushi($t0, 0) # y
        push($s5) # code
        jal update_game_bitmap
        pop($ra)
        pop_temps()
        
        # right side
        push($ra)
        push_temps()
        pushi($t0, 4) # x
        pushi($t0, 0) # y
        push($s6) # code
        jal update_game_bitmap
        pop_temps()
        pop($ra)
        
        # set capsule x and y to initial pos
        addiu, $t0, $zero, 3 
        addiu, $t1, $zero, 0
        addiu, $t2, $zero, 0
        sw $t0, capsule_x
        sw $t1, capsule_y
        sb $t2, capsule_orientation
        
        push($ra)
        push_temps()
        li $a0, 1
        jal update_bottle_bitmap
        pop_temps()
        pop($ra)
        
        # Return
        li $t0, 1
        add $v0, $t6, $t0
        jr $ra
    S_LOAD_CAPSULE_CASE_1_END:

    # s0 = y (loop variable)
    # s1 = x (loop variable)
    # s3 = orientation
    # t0 = game_width
    # t1 = game_height
    lw $t0, GAME_WIDTH
    lw $t1, GAME_HEIGHT
    
    # height - 1 -> 0
    addi $s0, $t1, -1 # y = gameheight - 1
    GRAVITY_LOOP_Y: bltz $s0, END_GRAVITY_LOOP_Y # if y < 0, then break
    
        # Inner loop
        add $s1, $zero, $zero
        # x = 0 -> x = game_width - 1
        GRAVITY_LOOP_X: beq $s1, $t0, END_GRAVITY_LOOP_X # if x >= game_width, then break
            # Get the code at (x, y)
            push($ra)
            push_temps()
            add $a0, $zero, $s1 # x 
            add $a1, $zero, $s0 # y
            jal get_value_in_game_bitmap # - returns $v0
            pop_temps()
            pop($ra)
            
            # v0 holds the code
            
            # Check whether (x,y) is connected
            andi $t2, $v0, 0b10000000
            beq $t2, $zero, GRAVITY_CONNECTED # if left most bit is 0, then is connected
            b GRAVITY_UNCONNECTED # else
            
            GRAVITY_UNCONNECTED:
                # Check right below
                # If air, drop one
                push($ra)
                push_temps()
                add $a0, $zero, $s1 # x
                add $a1, $zero, $s0 # y
                add $a2, $zero, $zero # dirX
                addi $a3, $zero, 1 # dirY
                jal check_collision # - return in $v0
                pop_temps()
                pop($ra)
                
                # If collision, increment
                bne $v0, $zero, GRAVITY_LOOP_X_INCREMENT
                
                # Otherwise move down
                push($ra)
                push_temps()
                add $a0, $zero, $s1 # x
                add $a1, $zero, $s0 # y
                add $a2, $zero, $zero # dirX
                addi $a3, $zero, 1 # dirY
                push($zero)
                jal translate_game_bit
                pop_temps()
                pop($ra)
                # something dropped
                li $t6, 1
                
                j GRAVITY_LOOP_X_INCREMENT
            
            GRAVITY_CONNECTED:
                # Only continue if we are a left or bottom capsule
                # Get the code at (x, y)
                push($ra)
                push_temps()
                add $a0, $zero, $s1 # x 
                add $a1, $zero, $s0 # y
                jal get_value_in_game_bitmap # - returns $v0
                pop_temps()
                pop($ra)
                
                # Get orientation
                push($ra)
                push_temps()
                add $a0, $v0, $zero
                jal get_orientation # returns $v0
                pop_temps()
                pop($ra)
                
                # Skip if not bottom or left
                li $t3, -1
                beq $v0, $t3, GRAVITY_LOOP_X_INCREMENT
                li $t3, 0
                beq $v0, $t3, GRAVITY_LOOP_X_INCREMENT
                li $t3, 3
                beq $v0, $t3, GRAVITY_LOOP_X_INCREMENT
                
                # Orientation is now 1 or 2 (Bottom or Left)
                
                # Check collision
                # Map orientation 1 -> 1, 2 -> 0
                push($ra)
                push_temps()
                li $a0, 1 # direction (0/1/2/3)
                add $a1, $zero, $s1 # x 
                add $a2, $zero, $s0 # y
                li $t3, 1
                seq $a3, $t3, $v0 # orientation (0/1) ; checks whether orientation == 1 
                seq $s3, $t3, $v0 # save orientation
                jal check_collision_capsule # returns v0 
                pop_temps()
                pop($ra)
                
                # If collision, increment
                bne $v0, $zero, GRAVITY_LOOP_X_INCREMENT
                
                # Otherwise move down
                push($ra)
                push_temps()
                add $a0, $zero, $zero # dirx
                addi $a1, $zero, 1    # diry
                add $a2, $zero, $s1 # x
                add $a3, $zero, $s0 # y
                add $t2, $zero, $s3 # orientation
                jal move_capsule
                pop_temps()
                pop($ra)
                # something dropped
                li $t6, 1
                
                # Check whether it is the player
                # s1 = x, x0 = y 
                lw $t7, capsule_x
                lw $t8, capsule_y 
                seq $t7, $t7, $s1 # x == capsule_x
                seq $t8, $t8, $s0 # y == capsule_y
                seq $t9, $t7, $t8 # x == capsule_x and y == capsule_y
                
                # If not, increment
                beq $t9, $zero, GRAVITY_LOOP_X_INCREMENT
                
                # Otherwise, increment capsule_x and capsule_y
                lw $t7, capsule_y
                addi $t7, $t7, 1
                sw $t7, capsule_y # increment y
                
                j GRAVITY_LOOP_X_INCREMENT
            
            GRAVITY_LOOP_X_INCREMENT:
                # Increment
                addi $s1, $s1, 1
                j GRAVITY_LOOP_X
        END_GRAVITY_LOOP_X:
        
        # Increment
        addi $s0, $s0, -1
        j GRAVITY_LOOP_Y
    END_GRAVITY_LOOP_Y:
    add $v0, $t6, $zero # t6 == 1 => we dropped something
    
    GRAVITY_END:
        jr $ra
    
mark_disconnected:
    lw $t0, GAME_WIDTH
    lw $t1, GAME_HEIGHT
    
    add $t2, $zero, 0 # t2 = i = 0 
    MARK_DISCONNECTED_I_LOOP: bge $t2, $t0, END_MARK_DISCONNECTED_I_LOOP # if i >= game_width, then break
    
        add $t3, $zero, 0 # t3 = j = 0 
        MARK_DISCONNECTED_J_LOOP: bge $t3, $t1, END_MARK_DISCONNECTED_J_LOOP # if j >= game_height, then break
            push($ra)
            push_temps()
            add $a0, $zero, $t2 # x 
            add $a1, $zero, $t3 # y
            jal get_value_in_game_bitmap # return stored in $v0
            pop_temps()
            pop($ra)
            
            # Get orientation
            add $a0, $zero, $v0 # code
            push($ra)
            push_temps()
            jal get_matching_direction # return stored in $v0, $v1
            pop_temps()
            pop($ra)
            
            # If dirX, dirY = 0
            add $t7, $v0, $v1
            beq $t7, $zero, MARK_DISCONNECTED_INCREMENT_J
            
            # Handle edge case dirY = -1 and y >= GAME_HEIGHT
            bgez $v1, MARK_DISCONNECTED_J_LOOP_IF
            blt $t3, $t1, MARK_DISCONNECTED_J_LOOP_IF
            j MARK_DISCONNECTED_INCREMENT_J
            
            MARK_DISCONNECTED_J_LOOP_IF: 
                add $t7, $v0, $zero
                add $t8, $v1, $zero
            
                # Get bit value at pos
                push($ra)
                push_temps()
                add $a0, $zero, $t2 # x
                add $a1, $zero, $t3 # y
                jal get_value_in_game_bitmap # return stored in $v0
                pop_temps()
                pop($ra)
                
                add $t5, $v0, $zero
                
                # if current block is air go away
                beq $t5, $zero, MARK_DISCONNECTED_INCREMENT_J
            
                # Get bit value at pos + dir
                push($ra)
                push_temps()
                add $a0, $t7, $t2 # x + dirX
                add $a1, $t8, $t3 # y + dirY
                jal get_value_in_game_bitmap # return stored in $v0
                pop_temps()
                pop($ra)
                
                # if bit value is not air skip
                bne $v0, $zero, MARK_DISCONNECTED_INCREMENT_J
                
                # Mark bit as disconnected
                ori $t9, $t5, 0b10000000
                push($ra)
                push_temps()
                push($t2) # x
                push($t3) # y
                push($t9) # sprite code
                jal update_game_bitmap
                pop_temps()
                pop($ra)
            
            MARK_DISCONNECTED_INCREMENT_J:
                addi $t3, $t3, 1
                j MARK_DISCONNECTED_J_LOOP
        END_MARK_DISCONNECTED_J_LOOP:
        
        addi $t2, $t2, 1
        j MARK_DISCONNECTED_I_LOOP
    END_MARK_DISCONNECTED_I_LOOP:

# Returns the orientation of the sprite 
# Arguments:
# a0 - code
# Returns:
# v0 - orientation (0/1/2/3) (UP/DOWN/LEFT/RIGHT) else -1
get_orientation:
    # Up
    li $t0, RED_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP
    li $t0, BLUE_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP
    li $t0, YELLOW_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP
    
    # Down
    li $t0, RED_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN
    li $t0, BLUE_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN
    li $t0, YELLOW_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN
    
    # Left
    li $t0, RED_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT
    li $t0, BLUE_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT
    li $t0, YELLOW_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT
    
    # Right
    li $t0, RED_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT
    li $t0, BLUE_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT
    li $t0, YELLOW_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT
    
    # Else
    b GET_ORIENTATION_ELSE
    
    GET_ORIENTATION_UP:
        li $v0, 0
        jr $ra
        
    GET_ORIENTATION_DOWN:
        li $v0, 1
        jr $ra
    
    GET_ORIENTATION_LEFT:
        li $v0, 2
        jr $ra
    
    GET_ORIENTATION_RIGHT:
        li $v0, 3
        jr $ra
    
    GET_ORIENTATION_ELSE:
        li $v0, -1
        jr $ra

    
# Returns the direction of the matching capsule bit given by the code
# Arguments:
# a0 - code
# Returns:
# v0 - dirX
# v1 - dirY
# direction is 0 if it doesn't have orientation
get_matching_direction:
    # Up
    li $t0, RED_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP_MATCHING
    li $t0, BLUE_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP_MATCHING
    li $t0, YELLOW_UP_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_UP_MATCHING
    
    # Down
    li $t0, RED_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN_MATCHING
    li $t0, BLUE_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN_MATCHING
    li $t0, YELLOW_DOWN_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_DOWN_MATCHING
    
    # Left
    li $t0, RED_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT_MATCHING
    li $t0, BLUE_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT_MATCHING
    li $t0, YELLOW_LEFT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_LEFT_MATCHING
    
    # Right
    li $t0, RED_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT_MATCHING
    li $t0, BLUE_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT_MATCHING
    li $t0, YELLOW_RIGHT_CAPSULE_SPRITE_CODE()
    beq $a0, $t0, GET_ORIENTATION_RIGHT_MATCHING
    
    # Else
    b GET_ORIENTATION_ELSE_MATCHING
    
    GET_ORIENTATION_UP_MATCHING:
        li $v0, 0
        li $v1, 1
        jr $ra
        
    GET_ORIENTATION_DOWN_MATCHING:
        li $v0, 0
        li $v1, -1
        jr $ra
    
    GET_ORIENTATION_LEFT_MATCHING:
        li $v0, 1
        li $v1, 0
        jr $ra
    
    GET_ORIENTATION_RIGHT_MATCHING:
        li $v0, -1
        li $v1, 0
        jr $ra
    
    GET_ORIENTATION_ELSE_MATCHING:
        li $v0, 0
        li $v1, 0
        jr $ra
    
# Return whether two colours are the same colour.
# Arugments:
# a0 - code1
# a1 - code2
# Returns:
# v0 - 0/1 
check_same_colour:
# 0 = black
# 1 = red 
# 2 = blue
# 3 = yellow
# then return temp 1 == temp 2 

    # Determine the colour of code1 
    CHECK_CODE1_COLOUR:
        add $t2, $a0, $zero
        andi $t2, $t2, 0b01111111
        # if 1 <= code1 <= 4 
        # if code1 == 13
        li $t0, 1
        beq $t2, $t0, CHECK_CODE1_RED
        li $t0, 2
        beq $t2, $t0, CHECK_CODE1_RED
        li $t0, 3
        beq $t2, $t0, CHECK_CODE1_RED
        li $t0, 4
        beq $t2, $t0, CHECK_CODE1_RED
        li $t0, 13
        beq $t2, $t0, CHECK_CODE1_RED
        
        li $t0, 5
        beq $t2, $t0, CHECK_CODE1_BLUE
        li $t0, 6
        beq $t2, $t0, CHECK_CODE1_BLUE
        li $t0, 7
        beq $t2, $t0, CHECK_CODE1_BLUE
        li $t0, 8
        beq $t2, $t0, CHECK_CODE1_BLUE
        li $t0, 14
        beq $t2, $t0, CHECK_CODE1_BLUE
        
        li $t0, 9
        beq $t2, $t0, CHECK_CODE1_YELLOW
        li $t0, 10
        beq $t2, $t0, CHECK_CODE1_YELLOW
        li $t0, 11
        beq $t2, $t0, CHECK_CODE1_YELLOW
        li $t0, 12
        beq $t2, $t0, CHECK_CODE1_YELLOW
        li $t0, 15
        beq $t2, $t0, CHECK_CODE1_YELLOW
    
        j CHECK_CODE1_BLACK
            
        CHECK_CODE1_RED:
            li $t5, 1
            j CHECK_CODE2_COLOUR
        CHECK_CODE1_BLUE:
            li $t5, 2
            j CHECK_CODE2_COLOUR
        
        CHECK_CODE1_YELLOW:
            li $t5, 3
            j CHECK_CODE2_COLOUR
        
        CHECK_CODE1_BLACK:
            li $t5, 0
            j CHECK_CODE2_COLOUR
    
    
    # Checking second ones colour 
    
    CHECK_CODE2_COLOUR:
        add $t2, $a1, $zero
        andi $t2, $t2, 0b01111111

        li $t0, 1
        beq $t2, $t0, CHECK_CODE2_RED
        li $t0, 2
        beq $t2, $t0, CHECK_CODE2_RED
        li $t0, 3
        beq $t2, $t0, CHECK_CODE2_RED
        li $t0, 4
        beq $t2, $t0, CHECK_CODE2_RED
        li $t0, 13
        beq $t2, $t0, CHECK_CODE2_RED
        
        li $t0, 5
        beq $t2, $t0, CHECK_CODE2_BLUE
        li $t0, 6
        beq $t2, $t0, CHECK_CODE2_BLUE
        li $t0, 7
        beq $t2, $t0, CHECK_CODE2_BLUE
        li $t0, 8
        beq $t2, $t0, CHECK_CODE2_BLUE
        li $t0, 14
        beq $t2, $t0, CHECK_CODE2_BLUE
        
        li $t0, 9
        beq $t2, $t0, CHECK_CODE2_YELLOW
        li $t0, 10
        beq $t2, $t0, CHECK_CODE2_YELLOW
        li $t0, 11
        beq $t2, $t0, CHECK_CODE2_YELLOW
        li $t0, 12
        beq $t2, $t0, CHECK_CODE2_YELLOW
        li $t0, 15
        beq $t2, $t0, CHECK_CODE2_YELLOW
        
        j CHECK_CODE2_BLACK
    
        CHECK_CODE2_RED:
            li $t6, 1
            j CHECK_CODE1_EQUAL_CODE2
        
        CHECK_CODE2_BLUE:
            li $t6, 2
            j CHECK_CODE1_EQUAL_CODE2
        
        CHECK_CODE2_YELLOW:
            li $t6, 3
            j CHECK_CODE1_EQUAL_CODE2
        
        CHECK_CODE2_BLACK:
            li $t6, 0
            j CHECK_CODE1_EQUAL_CODE2

    CHECK_CODE1_EQUAL_CODE2:
        seq $v0, $t5, $t6
    jr $ra


# Moves the bit at (x,y) in the direction of dirX and dirY
# $a0 - x
# $a1 - y
# $a2 - dirX
# $a3 - dirY
# - sprite code offset
translate_game_bit:
    pop($t9) # sprite code offset

    # get value in bitmap x,y
    push($ra)
    jal get_value_in_game_bitmap # uses a0, a1 for x, y and returns in $v0
    pop($ra)
    
    # Erase current thing
    push($ra)
    push($a0)
    push($a1)
    push($zero)
    jal update_game_bitmap
    pop($ra)
    
    # update value in bitmap x+dirX, y+dirY
    add $t0, $a0, $a2 # x + dirX
    add $t1, $a1, $a3 # y + dirY
    add $t3, $v0, $t9 # sprite code + sprite code offset
    push($ra)
    push($t0)
    push($t1)
    push($t3)
    jal update_game_bitmap
    pop($ra)
    
# Get the value in the bitmap at the specified x and y (col / row)
# $a0 - x
# $a1 - y
# Returns:
# v0 - the value at that location
get_value_in_game_bitmap:
    lw $t0, GAME_WIDTH
    lw $t1, GAME_HEIGHT
    la $t2, game_bitmap
    
    push($ra)
    push($a0)
    push($a1)
    push($t0)
    push($t1)
    push($t2)
    jal get_value_in_bitmap # return in $v0
    pop($ra)
    
    jr $ra
    

# Get the value in the bitmap at the specified x and y (col / row)
# - x
# - y
# - width
# - height
# - bitmap base address
# Returns:
# v0 - the value at that location
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
    
    # now we need index + base address
    add $t6, $t4, $t5
    
    lb $t7, 0($t6)

    add $v0, $t7, $zero
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
    
    # bitmap + index
    add $t6, $t8, $t5 # this is the index in the bitmap
    sb $t3, 0($t6) # put code in its place in the bitmap
    
    jr $ra

##############################################################################
# GAME INIT FUNCTIONS
##############################################################################

load_random_viruses:
    add $s2, $zero, $zero
    add $t0, $zero, $zero # count variable (loop)
    # addiu $t1, $zero, 4 # constant 4
    lw $t1, max_viruses
    
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
        addiu $t4, $zero, 6
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
        pop_temps()
        pop($ra)
        
        
        IF_VIRUS_NOT_THERE: bne $v0, $zero, ELSE_VIRUS_NOT_THERE
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

##############################################################################
# GAME DRAWING FUNCTIONS
##############################################################################

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
    
# draws the game bitmap the the display
draw_bottle_bitmap:
    la $t0, bottle_bitmap
    
    li $t2, -1 # start_x
    li $t3, -5 # start_y
    li $t4, 10 # width
    li $t5, 22 # height
    
    push($ra)
    push($t2) # start_x
    push($t3) # start_y
    push($t4) # width
    push($t5) # height
    push($t0) # bitmap
    jal draw_bitmap
    pop($ra)
    jr $ra

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
    pop($t0) # bitmap position
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
            la $t9, draw_rectangle_colour_array
            
            push($ra)
            push_temps()
            lb $a0, 0($t0)
            jal get_sprite
            pop_temps()
            pop($ra)

            push($ra)
            push_temps()
            push($t6) # x
            push($t5) # y
            push($v0) # colour array
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

# Arguments:
# - Sprite code ($a0)
# Returns:
# - Address to sprite colour array in $v0
get_sprite:
    add $t2, $a0, $zero
    andi $t2, $t2, 0b01111111

    li $t1, BACKGROUND_SPRITE_CODE()
    beq $t2, $t1, RETURN_BACKGROUND_SPRITE
    li $t1, RED_UP_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_RED_UP_CAPSULE_SPRITE
    li $t1, RED_DOWN_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_RED_DOWN_CAPSULE_SPRITE
    li $t1, RED_LEFT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_RED_LEFT_CAPSULE_SPRITE
    li $t1, RED_RIGHT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_RED_RIGHT_CAPSULE_SPRITE
    li $t1, BLUE_UP_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_BLUE_UP_CAPSULE_SPRITE
    li $t1, BLUE_DOWN_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_BLUE_DOWN_CAPSULE_SPRITE
    li $t1, BLUE_LEFT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_BLUE_LEFT_CAPSULE_SPRITE
    li $t1, BLUE_RIGHT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_BLUE_RIGHT_CAPSULE_SPRITE
    li $t1, YELLOW_UP_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_YELLOW_UP_CAPSULE_SPRITE
    li $t1, YELLOW_DOWN_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_YELLOW_DOWN_CAPSULE_SPRITE
    li $t1, YELLOW_LEFT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_YELLOW_LEFT_CAPSULE_SPRITE
    li $t1, YELLOW_RIGHT_CAPSULE_SPRITE_CODE()
    beq $t2, $t1, RETURN_YELLOW_RIGHT_CAPSULE_SPRITE
    li $t1, RED_VIRUS_SPRITE_CODE()
    beq $t2, $t1, RETURN_RED_VIRUS_SPRITE
    li $t1, BLUE_VIRUS_SPRITE_CODE()
    beq $t2, $t1, RETURN_BLUE_VIRUS_SPRITE
    li $t1, YELLOW_VIRUS_SPRITE_CODE()
    beq $t2, $t1, RETURN_YELLOW_VIRUS_SPRITE
    li $t1, WALL_SPRITE_CODE()
    beq $t2, $t1, RETURN_TOP_WALL_SPRITE
    li $t1, 17
    beq $t2, $t1, RETURN_BOTTOM_WALL_SPRITE
    li $t1, 18
    beq $t2, $t1, RETURN_LEFT_WALL_SPRITE
    li $t1, 19
    beq $t2, $t1, RETURN_RIGHT_WALL_SPRITE
    li $t1, 20
    beq $t2, $t1, RETURN_TOP_LEFT_WALL_SPRITE
    li $t1, 21
    beq $t2, $t1, RETURN_TOP_RIGHT_WALL_SPRITE
    li $t1, 22
    beq $t2, $t1, RETURN_BOT_LEFT_WALL_SPRITE
    li $t1, 23
    beq $t2, $t1, RETURN_BOT_RIGHT_WALL_SPRITE
    li $t1, 24
    
    
    RETURN_BACKGROUND_SPRITE:
        la $v0, BACKGROUND_SPRITE
        jr $ra
    RETURN_RED_UP_CAPSULE_SPRITE:
        la $v0, RED_UP_CAPSULE_SPRITE
        jr $ra
    RETURN_RED_DOWN_CAPSULE_SPRITE:
        la $v0, RED_DOWN_CAPSULE_SPRITE
        jr $ra
    RETURN_RED_LEFT_CAPSULE_SPRITE:
        la $v0, RED_LEFT_CAPSULE_SPRITE
        jr $ra
    RETURN_RED_RIGHT_CAPSULE_SPRITE:
        la $v0, RED_RIGHT_CAPSULE_SPRITE
        jr $ra
    RETURN_BLUE_UP_CAPSULE_SPRITE:
        la $v0, BLUE_UP_CAPSULE_SPRITE
        jr $ra
    RETURN_BLUE_DOWN_CAPSULE_SPRITE:
        la $v0, BLUE_DOWN_CAPSULE_SPRITE
        jr $ra
    RETURN_BLUE_LEFT_CAPSULE_SPRITE:
        la $v0, BLUE_LEFT_CAPSULE_SPRITE
        jr $ra
    RETURN_BLUE_RIGHT_CAPSULE_SPRITE:
        la $v0, BLUE_RIGHT_CAPSULE_SPRITE
        jr $ra
    RETURN_YELLOW_UP_CAPSULE_SPRITE:
        la $v0, YELLOW_UP_CAPSULE_SPRITE
        jr $ra
    RETURN_YELLOW_DOWN_CAPSULE_SPRITE:
        la $v0, YELLOW_DOWN_CAPSULE_SPRITE
        jr $ra
    RETURN_YELLOW_LEFT_CAPSULE_SPRITE:
        la $v0, YELLOW_LEFT_CAPSULE_SPRITE
        jr $ra
    RETURN_YELLOW_RIGHT_CAPSULE_SPRITE:
        la $v0, YELLOW_RIGHT_CAPSULE_SPRITE
        jr $ra
    RETURN_RED_VIRUS_SPRITE:
        la $v0, RED_VIRUS_SPRITE
        jr $ra
    RETURN_BLUE_VIRUS_SPRITE:
        la $v0, BLUE_VIRUS_SPRITE
        jr $ra
    RETURN_YELLOW_VIRUS_SPRITE:
        la $v0, YELLOW_VIRUS_SPRITE
        jr $ra
    RETURN_TOP_WALL_SPRITE:
        la $v0, WALL_SPRITE_TOP
        jr $ra
    RETURN_BOTTOM_WALL_SPRITE:
        la $v0, WALL_SPRITE_BOTTOM
        jr $ra
    RETURN_LEFT_WALL_SPRITE:
        la $v0, WALL_SPRITE_LEFT
        jr $ra
    RETURN_RIGHT_WALL_SPRITE:
        la $v0, WALL_SPRITE_RIGHT
        jr $ra
    RETURN_TOP_LEFT_WALL_SPRITE:
        la $v0, WALL_SPRITE_TOP_LEFT
        jr $ra
    RETURN_TOP_RIGHT_WALL_SPRITE:
        la $v0, WALL_SPRITE_TOP_RIGHT
        jr $ra
    RETURN_BOT_LEFT_WALL_SPRITE:
        la $v0, WALL_SPRITE_BOT_LEFT
        jr $ra
    RETURN_BOT_RIGHT_WALL_SPRITE:
        la $v0, WALL_SPRITE_BOT_RIGHT
        jr $ra


##############################################################################
# SCREEN DRAWING FUNCTIONS
##############################################################################

draw_difficulty:
    lw $t0, difficulty # t0 \in {1, 2, 3}
    
    # chosen easy
    li $t1, 1
    beq $t0, $t1, DRAW_EASY_DIFFICULTY
    
    # chosen medium
    li $t1, 2
    beq $t0, $t1, DRAW_MEDIUM_DIFFICULTY
    
    # chosen hard
    li $t1, 3
    beq $t0, $t1, DRAW_HARD_DIFFICULTY
    DRAW_EASY_DIFFICULTY:
        li $a0, 192 # x
        li $a1, 185 # y
        li $a2, 4 # E A S Y = 4 letters
        
        # push letters onto stack, in reverse order
        push($ra)
        pushi($t0, 13) # Y
        pushi($t0, 12) # S
        pushi($t0, 11) # A
        pushi($t0, 10) # E
        jal draw_word
        pop($ra)
        b DRAW_DIFFICULTY_RETURN
    
    DRAW_MEDIUM_DIFFICULTY:
        li $a0, 160 # x
        li $a1, 185 # y
        li $a2, 6 # M E D I U M = 6 letters
        
        # push letters onto stack, in reverse order
        push($ra)
        pushi($t0, 14) # M
        pushi($t0, 17) # U
        pushi($t0, 16) # I
        pushi($t0, 15) # D
        pushi($t0, 10) # E
        pushi($t0, 14) # M
        jal draw_word
        pop($ra)
        b DRAW_DIFFICULTY_RETURN
    
    DRAW_HARD_DIFFICULTY:
        li $a0, 192 # x
        li $a1, 185 # y
        li $a2, 4 # H A R D = 4 letters
        
        # push letters onto stack, in reverse order
        push($ra)
        pushi($t0, 15) # D
        pushi($t0, 19) # R
        pushi($t0, 11) # A
        pushi($t0, 18) # H
        jal draw_word
        pop($ra)
        b DRAW_DIFFICULTY_RETURN
    
    DRAW_DIFFICULTY_RETURN:
        jr $ra

draw_highscore_words:
    li $a0, 110 # x
    li $a1, 60 # y
    li $a2, 8 # H I - S C O R E = 5 letters
    # put all the codes on the stack, in reverse order 
    push($ra)
    pushi($t0, 10) # E 
    pushi($t0, 19) # R
    pushi($t0, 20) # O
    pushi($t0, 22) # C
    pushi($t0, 12) # S
    pushi($t0, 25) # -
    pushi($t0, 16) # I
    pushi($t0, 18) # H
    jal draw_word
    pop($ra)
    
    # return
    jr $ra

draw_highscore_numbers:
    li $a0, 110 # x
    li $a1, 80 # y
    addi $a2, $zero, 5 # length
    # Perform division to get both quotient and remainder
    lw $t0, highscore    # Load the score into $t0
    push($ra)

    # Get ones place
    li $t1, 10
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t2         # Ones place digit in $t2
    push($t2)

    # Get tens place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t3         # Tens place digit in $t3
    push($t3)

    # Get hundreds place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t4         # Hundreds place digit in $t4
    push($t4)

    # Get thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t5         # Thousands place digit in $t5
    push($t5)

    # Get hundreds of thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t6         # Hundreds of thousands place digit in $t6
    push($t6)

    jal draw_word
    pop($ra)
    
    # return
    jr $ra

draw_score_numbers:
    li $a0, 110 # x
    li $a1, 35 # y
    addi $a2, $zero, 5 # length
    # Perform division to get both quotient and remainder
    lw $t0, score    # Load the score into $t0
    push($ra)

    # Get ones place
    li $t1, 10
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t2         # Ones place digit in $t2
    push($t2)

    # Get tens place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t3         # Tens place digit in $t3
    push($t3)

    # Get hundreds place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t4         # Hundreds place digit in $t4
    push($t4)

    # Get thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t5         # Thousands place digit in $t5
    push($t5)

    # Get hundreds of thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t6         # Hundreds of thousands place digit in $t6
    push($t6)

    jal draw_word
    pop($ra)
    
    # Return
    jr $ra

draw_score_words:
    li $a0, 110 # x
    li $a1, 15 # y
    li $a2, 5 # S C O R E = 5 letters
    # put all the codes on the stack, in reverse order 
    push($ra)
    pushi($t0, 10) # E 
    pushi($t0, 19) # R
    pushi($t0, 20) # O
    pushi($t0, 22) # C
    pushi($t0, 12) # S
    jal draw_word
    pop($ra)
    
    # RETURN
    jr $ra
    
draw_gameover_words:
    push($ra)
    jal draw_background
    pop($ra)
    
    # win variable
    lw $t0, won
    beq $t0 $zero, GAMEOVER_WORDS_START
    
    # else draw the win title
    li $a0, 104 # x
    li $a1, 40 # y
    li $a2, 3 # W I N = 3 letters
    # put all the codes on the stack, in reverse order
    push($ra)
    pushi($t0, 28) # N 
    pushi($t0, 27) # I 
    pushi($t0, 26) # W
    jal draw_word 
    pop($ra)
    
    # skip over gameover words
    b GAMEOVER_TITLE_END
    
    # ------- GAMEOVER WORDS -------
    
    GAMEOVER_WORDS_START:
    li $a0, 60 # x
    li $a1, 40 # y
    li $a2, 8 # G A M E O V E R = 8 letters
    # put all the codes on the stack, in reverse order
    push($ra)
    pushi($t0, 19) # R
    pushi($t0, 10) # E
    pushi($t0, 23) # V
    pushi($t0, 20) # O
    pushi($t0, 10) # E
    pushi($t0, 14) # M
    pushi($t0, 11) # A 
    pushi($t0, 21) # G
    jal draw_word
    pop($ra)
    
    GAMEOVER_TITLE_END:
    
    
    # ------- SCORE WORDS --------
    
    # Draw score under it
    li $a0, 88 # x
    li $a1, 70 # y
    li $a2, 5 # S C O R E = 5 letters
    # put all the codes on the stack, in reverse order 
    push($ra)
    pushi($t0, 10) # E 
    pushi($t0, 19) # R
    pushi($t0, 20) # O
    pushi($t0, 22) # C
    pushi($t0, 12) # S
    jal draw_word
    pop($ra)
    
    # ------ SCORE NUMBERS -------
    
    li $a0, 88 # x
    li $a1, 90 # y
    addi $a2, $zero, 5 # length
    # Perform division to get both quotient and remainder
    lw $t0, score    # Load the score into $t0
    push($ra)

    # Get ones place
    li $t1, 10
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t2         # Ones place digit in $t2
    push($t2)

    # Get tens place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t3         # Tens place digit in $t3
    push($t3)

    # Get hundreds place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t4         # Hundreds place digit in $t4
    push($t4)

    # Get thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t5         # Thousands place digit in $t5
    push($t5)

    # Get hundreds of thousands place
    div $t0, $t1     # Divide $t0 by 10
    mflo $t0         # Quotient (remaining number) back to $t0
    mfhi $t6         # Hundreds of thousands place digit in $t6
    push($t6)

    jal draw_word
    pop($ra)
    
    # ------ DRAW RETRY WORDS ------
    
    li $a0, 72 # x
    li $a1, 120 # y
    addi $a2, $zero, 7 # R - R E T R Y = 7 letters
    
    push($ra)
    pushi($t0, 13) # Y
    pushi($t0, 19) # R
    pushi($t0, 24) # T
    pushi($t0, 10) # E
    pushi($t0, 19) # R
    pushi($t0, 25) # -
    pushi($t0, 19) # R
    jal draw_word
    pop($ra)
    
    # ------ DRAW TO CANVAS ------
    
    push($ra)
    jal push_canvas
    pop($ra)
    jr $ra
    
draw_difficulty_selection:
    # Draw the background
    push($ra)
    jal draw_background
    pop($ra)
    
    # Draw the difficulties - Easy, Medium, Hard
    push($ra)
    jal draw_easy_words
    pop($ra)
    
    push($ra)
    jal draw_medium_words
    pop($ra)
    
    push($ra)
    jal draw_hard_words
    pop($ra)
    
    jr $ra
    
# Arguments:
# a0 - number from 0-2, indicating the selection of easy/medium/hard
draw_select:
    push($ra)
    push_temps()
    li $t0, 70 # x
    push($t0)
    
    li $t0, 60 # y
    li $t1, 20 
    mult $t1, $a0
    mflo $t1 
    add $t0, $t0, $t1  # y = y + 20 * (a0)
    
    push($t0) 
    li $t0, 16 # width
    push($t0)
    li $t0, 16 # height
    push($t0)
    la $t0, UNPAUSED_SPRITE
    push($t0)
    jal draw_rect
    pop_temps()
    pop($ra)
    
    jr $ra

    
draw_easy_words:
    li $a0, 90 # x
    li $a1, 60 # y
    li $a2, 4 # E A S Y = 4 letters
    
    # push letters onto stack, in reverse order
    push($ra)
    pushi($t0, 13) # Y
    pushi($t0, 12) # S
    pushi($t0, 11) # A
    pushi($t0, 10) # E
    jal draw_word
    pop($ra)
    
    jr $ra
    

draw_medium_words:
    li $a0, 90 # x
    li $a1, 80 # y
    li $a2, 6 # M E D I U M = 6 letters
    
    # push letters onto stack, in reverse order
    push($ra)
    pushi($t0, 14) # M
    pushi($t0, 17) # U
    pushi($t0, 16) # I
    pushi($t0, 15) # D
    pushi($t0, 10) # E
    pushi($t0, 14) # M
    jal draw_word
    pop($ra)
    
    jr $ra

draw_hard_words:
    li $a0, 90 # x
    li $a1, 100 # y
    li $a2, 4 # H A R D = 4 letters
    
    # push letters onto stack, in reverse order
    push($ra)
    pushi($t0, 15) # D
    pushi($t0, 19) # R
    pushi($t0, 11) # A
    pushi($t0, 18) # H
    jal draw_word
    pop($ra)
    
    jr $ra




    

# Arugments:
# a0 - x (start)
# a1 - y (start)
# a2 - length
# - codes on the stack
draw_word:
    add $t1, $a0, $zero # t1 = x 
    add $t2, $a1, $zero # t2 = y
    add $t3, $a2, $zero # t3 = length
    
    # counter variable = t0
    add $t0, $zero, $zero # start t0 = 0 
    DRAW_WORD_LOOP: bge $t0, $t3, END_DRAW_WORD_LOOP # exit if count >= length
        pop($t5) # the code on the stack
        
        # draw the letter
        push($ra)
        push_temps()
        add $a0, $zero, $t1 # x
        add $a1, $zero, $t2 # y
        add $a2, $zero, $t5 # code 
        jal draw_letter
        pop_temps()
        pop($ra)
    
        # Increment
        addi $t1, $t1, 16 # move x to the next pos
        addi $t0, $t0, 1
        j DRAW_WORD_LOOP
    END_DRAW_WORD_LOOP:
        jr $ra
    
    

# Arguments:
# a0 - x 
# a1 - y 
# a2 - code 
draw_letter:
    push($ra)
    push_temps()
    push($a0) # x
    push($a1) # y 
    pushi($t0, 16) # width
    pushi($t0, 16) # height
    
    # ------ Determine the code ------
    # Start numbers
    li $t1, 0
    beq $a2, $t1, DRAW_NUMBER_0
    li $t1, 1
    beq $a2, $t1, DRAW_NUMBER_1
    li $t1, 2
    beq $a2, $t1, DRAW_NUMBER_2
    li $t1, 3
    beq $a2, $t1, DRAW_NUMBER_3
    li $t1, 4
    beq $a2, $t1, DRAW_NUMBER_4
    li $t1, 5
    beq $a2, $t1, DRAW_NUMBER_5
    li $t1, 6
    beq $a2, $t1, DRAW_NUMBER_6
    li $t1, 7
    beq $a2, $t1, DRAW_NUMBER_7
    li $t1, 8
    beq $a2, $t1, DRAW_NUMBER_8
    li $t1, 9
    beq $a2, $t1, DRAW_NUMBER_9

    # Start letters
    li $t1, 10
    beq $a2, $t1, DRAW_LETTER_E
    li $t1, 11
    beq $a2, $t1, DRAW_LETTER_A
    li $t1, 12
    beq $a2, $t1, DRAW_LETTER_S
    li $t1, 13
    beq $a2, $t1, DRAW_LETTER_Y
    li $t1, 14
    beq $a2, $t1, DRAW_LETTER_M
    li $t1, 15
    beq $a2, $t1, DRAW_LETTER_D
    li $t1, 16
    beq $a2, $t1, DRAW_LETTER_I
    li $t1, 17
    beq $a2, $t1, DRAW_LETTER_U
    li $t1, 18
    beq $a2, $t1, DRAW_LETTER_H
    li $t1, 19
    beq $a2, $t1, DRAW_LETTER_R
    li $t1, 20
    beq $a2, $t1, DRAW_LETTER_O
    li $t1, 21
    beq $a2, $t1, DRAW_LETTER_G
    li $t1, 22
    beq $a2, $t1, DRAW_LETTER_C
    li $t1, 23
    beq $a2, $t1, DRAW_LETTER_V
    li $t1, 24
    beq $a2, $t1, DRAW_LETTER_T
    li $t1, 25
    beq $a2, $t1, DRAW_HYPHEN
    li $t1, 26
    beq $a2, $t1, DRAW_GREEN_W
    li $t1, 27
    beq $a2, $t1, DRAW_GREEN_I
    li $t1, 28
    beq $a2, $t1, DRAW_GREEN_N

    # START NUMBERS
    DRAW_NUMBER_0:
        la $t0, NUMBER_0_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_1:
        la $t0, NUMBER_1_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_2:
        la $t0, NUMBER_2_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_3:
        la $t0, NUMBER_3_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_4:
        la $t0, NUMBER_4_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_5:
        la $t0, NUMBER_5_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_6:
        la $t0, NUMBER_6_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_7:
        la $t0, NUMBER_7_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_8:
        la $t0, NUMBER_8_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_NUMBER_9:
        la $t0, NUMBER_9_SPRITE
        j DRAW_LETTER_ENDIF
    # END NUMBERS
    
    DRAW_LETTER_E:
        la $t0, LETTER_E_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_A:
        la $t0, LETTER_A_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_S:
        la $t0, LETTER_S_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_Y:
        la $t0, LETTER_Y_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_M:
        la $t0, LETTER_M_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_D:
        la $t0, LETTER_D_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_I:
        la $t0, LETTER_I_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_U:
        la $t0, LETTER_U_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_H:
        la $t0, LETTER_H_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_R:
        la $t0, LETTER_R_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_O:
        la $t0, LETTER_O_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_G:
        la $t0, LETTER_G_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_C:
        la $t0, LETTER_C_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_V:
        la $t0, LETTER_V_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_LETTER_T:
        la $t0, LETTER_T_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_HYPHEN:
        la $t0, HYPHEN_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_GREEN_W:
        la $t0, LETTER_W_GREEN_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_GREEN_I:
        la $t0, LETTER_I_GREEN_SPRITE
        j DRAW_LETTER_ENDIF
    DRAW_GREEN_N:
        la $t0, LETTER_N_GREEN_SPRITE
        j DRAW_LETTER_ENDIF
        
    DRAW_LETTER_ENDIF:
        push($t0) # address to colour array
        jal draw_rect
        pop_temps()
        pop($ra)
    jr $ra
    
    
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
    
    la $t5 canvas # load canvas address into $t5
    
    add $t2, $t2, $t4
    add $t1, $t1, $t3
    
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

    
# Draws the entire canvas black
# Arguments:
# - None
# Return: 
# - Void
draw_background:
    li $t0, 0x000000 # Background colour
    la $t1, canvas
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

# Draws canvas to the screen
push_canvas:
    lw $t2, ADDR_DSPL
    la $t3, canvas
    lw $t5, SCREEN_WIDTH
    lw $t6, SCREEN_HEIGHT
    mult $t5, $t6
    mflo $t1
    sll $t1, $t1, 2

    li $t0, 0
    
    PUSH_CANVAS_LOOP: bge $t0, $t1 END_PUSH_CANVAS_LOOP
        add $t4, $t2, $t0 # address at display
        add $t5, $t3, $t0 # address at canvas
        lw $t6, 0($t5) # value at canvas
        sw $t6, 0($t4) # store at display
        
        addi $t0, $t0, 4
        
        j PUSH_CANVAS_LOOP
    END_PUSH_CANVAS_LOOP:
    
    jr $ra
     
exit:
    # Quit the game
    li $v0, 10  
    syscall
