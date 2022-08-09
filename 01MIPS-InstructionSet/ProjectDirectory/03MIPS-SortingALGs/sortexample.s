.data
msg:    .asciiz "The elements sorted in ascending order are:"
        .align 2        # align string
space:  .asciiz " "
            .align 2        # align string
comma:  .asciiz ","
            .align 2        # align string
arr:        .space 80       # max array length = 20 * 4 bytes 
.text

MAIN:   

    # Ask for user input and put value in $s1
    addi $v0, $zero, 5      # call service 5 for integer input
    syscall             # read integer
    add $s1, $zero, $v0         # Save $s1 = len

    # Load address for arr
    la $s0, arr             # pointer to arr goes in $s0

    add $a0, $zero, $s0     # save arr pointer to $a0
    add $a1, $zero, $s1     # save len to $a1

    # Ask for user input to fill arr
    jal FILL            

    # Sort the list using selection sort
    jal SORT            

    # Print list
    jal PRINT           

    # Call to end program
    addi $v0, $zero, 10         # system call for exit
    syscall             # exit program

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

FILL:   
    addi $sp, $sp, -8       # make space on stack
    sw $s0, 0($sp)          # save $s0 (position) on stack
    sw $s1, 4($sp)          # save $s1 (input) on stack
    addi $t0, $zero, 0      # $t0 = 0
    add $s0, $zero, $t0     # initialize $s0 = $t0 = 0

FILL_LOOP:
    slt $t1, $s0, $a1       # if(position < len) continue
    beq $t1, $zero, FILL_RETURN     # if(position >= len) branch out of loop 

    addi $v0, $zero 5       # call service 5 for integer input
    syscall             # read integer

    addi $s1, $zero, 0      # clear $s1 and set to 0
    add $s1, $zero, $v0         # $s1 holds input integer

    add $t3, $zero, $s0         # $t3 = position
    sll $t3, $t3, 2         # $t3 =  position * 4
    add $t3, $t3, $a0       # addr of arr[position]
    sw $s1, 0($t3)          # store value $s1 in arr[position]

    addi $s0, $s0, 1        # position++

    j   FILL_LOOP       

FILL_RETURN:
    lw $s0, 0($sp)          # restore $s0 from stack
    lw $s1, 4($sp)          # restore $s1 from stack
    addi $sp, $sp 8         # adjust stack pointer
    jr $ra              # Return

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

SORT:
    addi $sp, $sp, -28      # make space on stack
    sw $a0, 0($sp)          # save $a0 (arr) on stack
    sw $a1, 4($sp)          # save $a1 (len) on stack
    sw $ra, 8($sp)          # save return address on stack
    sw $s0, 12($sp)         # save $s0 ( i ) on stack
    sw $s1, 16($sp)         # save $s1 ( j ) on stack
    sw $s2, 20($sp)         # save $s2 (tmp) on stack
    sw $s3, 24($sp)         # save $s3 (minIndex) on stack

    addi $s0, $zero, 0      # i = 0
    add $t0, $zero, $a1     # $t0 = len
    addi $t0, $t0, -1       # $t0 = len - 1

FOR_1:
    slt $t1, $s0, $t0       # if(i < len - 1) continue
    beq $t1, $zero, SORT_RETURN     # if(i >= len - 1) branch out of loop

    add $s3, $zero, $s0         # minIndex = i
    addi $t1, $s0, 1        # $t1 = i + 1
    add $s1, $zero, $t1         # j = $t1 = i + 1

FOR_2: 
    slt $t1, $s1, $a1       # if(j < len) continue
    beq $t1, $zero, IF_1        # if(j >= len) branch out of loop 

IF_2: # "FIND MIN"

    # get value at arr[ j ] store in $t3
    add $t2, $zero, $s1         # calculate index $t2 = j 
    sll $t2, $t2, 2         # offset = $t2 * 4
    add $t2, $t2, $a0       # add offset to base address
    lw $t3, 0($t2)          # load value at arr[ j ] into $t3

     # get value at arr[minIndex] store in$t5
    add $t4, $zero, $s3         # calculate index $t4 = minIndex
    sll $t4, $t4, 2         # offset = $t4 * 4
    add $t4, $t4, $a0       # add offset to base address
    lw $t5, 0($t4)          # load value at arr[minIndex] into $t5

    slt $t1, $t3, $t5       # if(arr[ j ] < arr[minIndex]) continue
    beq $t1, $zero, LOOP_2      # if(arr[ j ] >= arr[minIndex]) branch out of if stmt
    add $s3, $zero, $s1         # minIndex = j

LOOP_2:
    addi $s1, $s1, 1        # j++
    j FOR_2

IF_1: # "SWAP"
    beq $s3, $s0, LOOP_1        # if(minIndex == i) branch out of if stmt (jump to LOOP_1)

    # tmp = arr[minIndex]
    add $t2, $zero, $s3         # calculate index $t2 = minIndex
    sll $t2, $t2, 2         # offset = $t2 * 4
    add $t2, $t2, $a0       # add offset to base address
    lw $s2, 0($t2)          # $s2 = tmp = arr[minIndex]

    # arr[minIndex] = arr[ i ]
    add $t3, $zero, $s0         # calculate index $t3 = i
    sll $t3, $t3, 2         # offset = $t2 * 4
    add $t3, $t3, $a0       # add offset to base address
    lw $t6, 0($t3)          # $t6 = arr [ i ]

    sw $t6, 0($t2)          # store value at arr[ i ] in arr[minIndex] 

    # arr[ i ] = tmp
    sw $s2, 0($t3)          # store tmp value in arr[ i ]           

LOOP_1:
    addi $s0, $s0, 1        # i++
    j FOR_1 

SORT_RETURN:
    lw $a0, 0($sp)          # restore $a0 from stack
    lw $a1, 4($sp)          # restore $a1 from stack
    lw $ra, 8($sp)          # restore return address from stack
    lw $s0, 12($sp)         # restore $s0 from stack
    lw $s1, 16($sp)         # restore $s1 from stack
    lw $s2,  20($sp)        # restore $s2 from stack
    lw $s3, 24($sp)         # restore $s3 from stack
    addi $sp, $sp 28        # adjust stack pointer
    jr $ra              # Return

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

PRINT:
    addi $sp, $sp, -4       # make space on stack
    sw $s0, 0($sp)          # save $s0 (position) on stack
    addi $t0, $zero, 0      # $t0 = 0
    add $s0, $zero, $t0     # initialize $s0 = $t0 = 0

    # Print msg
    la $s3, msg         # load address of msg into $s3
    add $a0, $zero, $s3         # put address of msg in $a0 to print
    addi $v0, $zero, 4      # call service 4 to print a string
    syscall             # print string

    # Print a space
    la $s3, space           # load address of space into $s3
    add $a0, $zero, $s3         # put address of space in $a0 to print
    addi $v0, $zero, 4      # call service 4 to print a string
    syscall             # print string

PRINT_LOOP:
    slt $t2, $s0, $a1       # if(position < len) continue
    beq $t2, $zero, PRINT_RETURN    # if(position >= len) branch out of loop 

    la $a0, arr             # reload arr pointer into $a0

    add $t3, $zero, $s0         # $t3 = position
    sll $t3, $t3, 2         # $t3 = position * 4
    add $t3, $t3, $a0       # $t3 =  address of arr[position]

    lw $t4, 0($t3)          # Load value to print
    add $a0, $zero, $t4         # put address of $t4 in $a0 to print

    addi $v0, $zero, 1      # call service 1 to print integer
    syscall             # print integer

    # Check if last array element
    # Skip printing comma and space
    addi $t3, $a1, -1       # $t3 = len - 1
    beq $t3, $s0, PRINT_RETURN  # if(at last element)

    # Print a comma
    la $s3, comma           # load address of comma into $s3
    add $a0, $zero, $s3         # put address of comma in $a0 to print
    addi $v0, $zero, 4      # call service 4 to print a string
    syscall             # print string

    # Print a space
    la $s3, space           # load address of space into $s3
    add $a0, $zero, $s3         # put address of space in $a0 to print
    addi $v0, $zero, 4      # call service 4 to print a string
    syscall             # print string

    addi $s0, $s0, 1        # position++

    j PRINT_LOOP

PRINT_RETURN:
    lw $s0, 0($sp)          # restore $s0 from stack
    addi $sp, $sp 4         # adjust stack pointer
    jr $ra              # Return