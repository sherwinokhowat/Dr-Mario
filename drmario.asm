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
    .word 40
    
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

WALL_SPRITE:
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
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF
    .word 0xFFFFFF

##############################################################################
# Mutable Data
##############################################################################
canvas:
    .word 0:100000

draw_rectangle_colour_array:
    .word 0:100000 # 0:num of pixels of screen (width * height)
    
# bitmap to draw the bottle
bottle_bitmap:
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 0
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
    .byte 16
   
# bitmap to draw the actual game (playing field)
game_bitmap:
    .byte 0:1000 # 0: width * height of the game
    
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
capsule_loading:
    .byte 0
    
# orientation of capsule (horizontal / vertical)
capsule_orientation:
    .byte 0
    
need_clear:
    .byte 1
    
gravity_timer:
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
    li $a0, 0x09
    li $a1, 0x89
    jal check_same_colour
    

    li $t0, 1
    sb $t0, capsule_needed

    jal draw_background
    # jal load_random_viruses
    li $a0, 0
    jal update_bottle_bitmap
    jal game_loop
    
    # Exit
    li $v0, 10  
    syscall

##############################################################################
# GAME LOOP
##############################################################################
game_loop:

    
    # jal update_bottle_bitmap
    jal draw_bottle_bitmap
    jal draw_game_bitmap
    jal push_canvas
    
    jal handle_key_press
    # jal handle_s_press
    jal run_timer
    beq $v0, $zero, END_IF_GRAVITY
    jal gravity
    bne $v0, $zero, IF_GRAVITY
    beq $v0, $zero, IF_NOT_GRAVITY
    IF_GRAVITY:
        j END_IF_GRAVITY
    IF_NOT_GRAVITY:
        lb $t0 need_clear
        bne $t0, $zero, IF_NEED_CLEAR
        beq $t0, $zero, IF_NOT_NEED_CLEAR
        IF_NEED_CLEAR:
            jal clear_connected
            sb $zero, need_clear
        
            j END_IF_NEED_CLEAR
        IF_NOT_NEED_CLEAR:
            li $a0, 0
            jal update_bottle_bitmap
        
            li $t1, 1
            sb $t1, need_clear
            j END_IF_NEED_CLEAR
        END_IF_NEED_CLEAR:
    
        j END_IF_GRAVITY
    END_IF_GRAVITY:
    
    # if !gravity: 
        # if need_clear:
            # clear()
            # need_clear = false
        # else:
            # spawn new capsule in bottle map

    j game_loop

# $a0 - timer address
# $a1 - timer interval
# $v0 - timer ticked (0/1)
run_timer:
    lw $t0, gravity_timer
    addi $t0, $t0, 1
    sw $t0, gravity_timer
    li $t1, 5
    seq $t2, $t0, $t1 # gravity_timer = 1000
    beq $t2, $zero, CONT_TIMER
    sw $zero, gravity_timer
    li $v0, 1
    jr $ra
    CONT_TIMER:
        li $v0, 0
        jr $ra

##############################################################################
# Update bottle bitmap
##############################################################################

# $a0 - mode (0/1) (load new capsule/delete capsule)
update_bottle_bitmap:
    # lb $t0, capsule_needed
    # lb $t3, capsule_loading
    
    # needed => IF_CAPSULE_NEEDED
    # not needed/ loading => RETURN
    # not needed/not loading => draw black
    
    
    # bne $t0, $zero, IF_CAPSULE_NEEDED    #  needed => capsule needed
    # bne $t3, $zero, UPDATE_BOTTLE_BITMAP_EXIT   # not needed and loading => leave
    # not needed and not loading => draw black
    
    #mode 0: load new capsule
    beq $a0, $zero, IF_CAPSULE_NEEDED
    # mode 1: draw black
    li $t2, 0
    j END_IF_CAPSULE_NEEDED
    
    
    IF_CAPSULE_NEEDED:
        # Choose random capsule colour (1-9)
        li $v0, 42 # rng sys id 
        li $a0, 0 # lower bound
        li $a1, 9 # upper bound (exclusive)
        syscall # the return is stored in $a0
        addi $t2, $a0, 1
        li $t0, 1
        sb $t0, capsule_loading
    END_IF_CAPSULE_NEEDED:
        
    # t0 = bottle bitmap
    # t1 = constantly changing value used for loading values into bitmap
    # t6 = which capsule to put
    # t7 = the left bit of the capsule
    # t8 = the right bit of the capsule
    # t9 = constant holding 1, 2, ..., 9 used for if statement checks
    la $t0, bottle_bitmap # get bottle bitmap array address
    
    addiu $t9, $zero, 1
    beq $t2, $t9, RED_RED
    addiu $t9, $zero, 2
    beq $t2, $t9, RED_BLUE
    addiu $t9, $zero, 3
    beq $t2, $t9, RED_YELLOW
    addiu $t9, $zero, 4
    beq $t2, $t9, BLUE_BLUE
    addiu $t9, $zero, 5
    beq $t2, $t9, BLUE_RED
    addiu $t9, $zero, 6
    beq $t2, $t9, BLUE_YELLOW
    addiu $t9, $zero, 7
    beq $t2, $t9, YELLOW_YELLOW
    addiu $t9, $zero, 8
    beq $t2, $t9, YELLOW_RED
    addiu $t9, $zero, 9
    beq $t2, $t9, YELLOW_BLUE
    
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
        # THIS IS WHERE THE LEFT SIDE OF THE CAPSULE GOES
        sb $t7, 24($t0)
        # THIS IS WHERE THE RIGHT SIDE OF THE CAPSULE GOES
        sb $t8, 25($t0)
  
        # capsule_needed = 0
        sb $zero, capsule_needed
        # capsule_loading = 1
        # addiu $t1, $zero, 1
        # sb $t1, capsule_loading
        jr $ra
        
    UPDATE_BOTTLE_BITMAP_EXIT:
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

    # beq $a0, 0x71, respond_to_Q     # done
    beq $a0, 0x61, handle_a_press     
    beq $a0, 0x73, handle_s_press     # working on
    beq $a0, 0x64, handle_d_press
    beq $a0, 0x77, handle_w_press
    
    skip_handle_key_press:
    jr $ra
    
    

handle_s_press:
    # capsule_needed = capsule colliding at bottom
    lb $t0 capsule_needed
    
    
    # If (capsule_needed) spawn a capsule into bottle bitmap
    # Else If (capsule_loading) move capsule from bottle bitmap to game bitmap
    # Else move_capsule(down)
    
    # Check whether we are in a load capsule state ! 
    lb $t0, capsule_loading
    li $t1, 1 # $t1 = 1
    
    beq $t0, $t1, S_LOAD_CAPSULE_CASE # if load state = 1
    bne $t0, $t1, S_MOVE_DOWN # if load state != 1
    S_LOAD_CAPSULE_CASE:
        # turn load capsule off
        sb $zero, capsule_loading
        
        # ----- Get the colours from the bitmap -----
        
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
        jal get_value_in_bitmap # return value in $v0
        add $s5, $zero, $v0
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
        jal get_value_in_bitmap  # return value in $v0
        add $s6, $zero, $v0
        pop($ra)
        
        # ----- Check collision -----
        li $a0, 3
        li $a1, 0
        li $a2, 0
        li $a3, 0
        push($ra)
        jal check_collision 
        pop($ra)
        bne $v0, $zero, S_EXIT
        
        li $a0, 4
        li $a1, 0
        li $a2, 0
        li $a3, 0
        push($ra)
        jal check_collision 
        pop($ra)
        bne $v0, $zero, S_EXIT
        
        # ----- Draw -----
        
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
        
        # Return
        b END_HANDLE_S_PRESS
    S_MOVE_DOWN:
        # Check collision
        push($ra)
        push_temps()
        li $a0, 1
        lw $a1, capsule_x
        lw $a2, capsule_y
        lb $a3, capsule_orientation
        jal check_collision_capsule 
        pop_temps()
        pop($ra)
        bne $v0, $zero, S_MOVE_DOWN_COLLISION
        
        # Move the capsule
        push($ra)
        push_temps()
        li $a0, 0
        li $a1, 1
        lw $a2, capsule_x
        lw $a3, capsule_y
        lb $t2, capsule_orientation
        jal move_capsule
        pop_temps()
        pop($ra)
        
        lw $t0, capsule_x
        lw $t1, capsule_y
        addi $t1, $t1, 1
        sw $t0, capsule_x
        sw $t1, capsule_y
        
        j END_HANDLE_S_PRESS

    S_MOVE_DOWN_COLLISION:
        push($ra)
        push_temps()
        jal clear_connected
        pop_temps()
        pop($ra)
        
        li $t0, 1
        sb $t0, capsule_needed
        li $t0, 0
        sb $t0, capsule_orientation
        jr $ra
        
    END_HANDLE_S_PRESS:
        jr $ra
        
    S_EXIT:
        j exit
    
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

# checks clears
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
                        
                        push($ra)
                        push_temps()
                        push($s7)
                        push($s3)
                        push($zero)
                        jal update_game_bitmap
                        pop_temps()
                        pop($ra)
                    
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
                        
                        push($ra)
                        push_temps()
                        push($s3)
                        push($s7)
                        push($zero)
                        jal update_game_bitmap
                        pop_temps()
                        pop($ra)
                    
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
    jal mark_disconnected
    pop($ra)
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
        li $t6, 1
    
        # turn load capsule off
        sb $zero, capsule_loading
        
        # ----- Get the colours from the bitmap -----
        
        # left side of capsule:
        addi $t0, $zero, 4 
        addi $t1, $zero, 2 
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
        addi $t1, $zero, 2 
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
        bne $v0, $zero, S_EXIT #!!!
        
        li $a0, 4
        li $a1, 0
        li $a2, 0
        li $a3, 0
        push($ra)
        push_temps()
        jal check_collision 
        pop_temps()
        pop($ra)
        bne $v0, $zero, S_EXIT
        
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
        jal update_bottle_bitmap
        pop_temps()
        pop($ra)
        
        # Return
        add $v0, $t6, $zero
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
                bne $v0, $zero, GRAIVTY_LOOP_X_INCREMENT
                
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
                
                j GRAIVTY_LOOP_X_INCREMENT
            
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
                beq $v0, $t3, GRAIVTY_LOOP_X_INCREMENT
                li $t3, 0
                beq $v0, $t3, GRAIVTY_LOOP_X_INCREMENT
                li $t3, 3
                beq $v0, $t3, GRAIVTY_LOOP_X_INCREMENT
                
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
                bne $v0, $zero, GRAIVTY_LOOP_X_INCREMENT
                
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
                beq $t9, $zero, GRAIVTY_LOOP_X_INCREMENT
                
                # Otherwise, increment capsule_x and capsule_y
                lw $t7, capsule_y
                addi $t7, $t7, 1
                sw $t7, capsule_y # increment y
                
                j GRAIVTY_LOOP_X_INCREMENT
            
            GRAIVTY_LOOP_X_INCREMENT:
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
    b GET_ORIENTATION_ELSE
    
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
    beq $t2, $t1, RETURN_WALL_SPRITE
    
    
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
    RETURN_WALL_SPRITE:
        la $v0, WALL_SPRITE
        jr $ra


##############################################################################
# SCREEN DRAWING FUNCTIONS
##############################################################################
    
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
