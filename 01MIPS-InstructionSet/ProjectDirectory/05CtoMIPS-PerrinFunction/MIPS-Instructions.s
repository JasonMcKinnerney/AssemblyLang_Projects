# Jason McKinnerney
# CS 2318
# 
# Assignment 4




.data
    promptinput:    .asciiz "Please enter an integer less than or equal to 10: "
    promptans:      .asciiz "The answer is: "
.text

main:

    li      $v0, 4
    la      $a0, promptinput        # Ask for Integer
    syscall

    li      $v0, 5                  # $t0 == input
    syscall                     
    move    $t0, $v0

    addiu   $sp, $sp, -12           # Allocate Stack Space
    sw      $t0, 0($sp)             # Store Argument
    sw      $ra, 8($sp)             # Save Return Address
    jal     perrin                  # Call Function
    lw      $ra, 8($sp)             # Load Return address
    lw		$s0, 4($sp)             # Load Result
    addiu   $sp, $sp, 12            # Deallocate Stack Space
    
    li      $v0, 4
    la      $a0, promptans          # Print array index 0
    syscall

    move    $a0, $s0                # $a0=unsorted[i]
    li      $v0,1
    syscall

    li      $v0,10                  # Quit
    syscall

perrin:
    lw		$t0, 0($sp)		        # Load Input
    
    li      $t1, 3                  # Set a
    li      $t2, 0                  # Set b
    li      $t3, 2                  # Set c
    
    li      $t4, 1                  # if2 Condition Check

    if1:
        bne     $t0, $t2, if2       # if input == 0
        add     $s0, $0, $t1            # Change Input to 3

    if2:
        bne     $t0, $t4, if3       # if input == 1
        addi    $s0, $0, 0              # Change Input to 0

    if3:
        bne     $t0, $t3, next      # if input == 2
        add     $s0, $0, $t3            # Change Input to 2

    next:
        addi    $t4, $t4, 1             # t0 = input, $t1 = a, $t2 = b, $t3 = c, $t4 = 2;

    while:
        ble     $t0, $t4, doneWhile     # branch if input <= 2
        add     $s0, $t1, $t2
        add     $t1, $0, $t2
        add     $t2, $0, $t3            # Perrin Cycle
        add     $t3, $0, $s0
        addi	$t0, $t0, -1
        b		while

    doneWhile:
        sw      $s0, 4($sp)             # Save Result + Return to main
        jr      $ra
        