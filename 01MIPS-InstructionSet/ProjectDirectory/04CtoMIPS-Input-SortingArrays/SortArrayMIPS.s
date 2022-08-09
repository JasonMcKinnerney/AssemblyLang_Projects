##Jason McKinnerney JLM573
##CS2318 Assignment 3





.data

                
    promptnum:      .asciiz "Please enter the number of elements: "
    promptinput:    .asciiz "Please enter the elements in array: "
    promptans:    .asciiz "The element at the top of the array is: "
    array:
                    .align  2               #array with size 100
                    .space  400
                    


.text

main:

                li      $v0, 4
                la      $a0, promptnum      #Ask for num of elements
                syscall

                li      $v0, 5
                syscall                     #assign the count to $a1
                move    $a1, $v0
                addi    $a3, $a1, 0
                sll     $a3, $a3, 2         #Have $a3 be $a1 * 4 bytes

                li      $v0, 4
                la      $a0, promptinput
                syscall

                la      $a0, array          #array pointer
                li      $t1, 0              #index counter

    while:      


                beq		$a3, $t1, endwhile	# if $a1 =$t0  branch endwhile
                add     $t0, $a0, $t1
                li      $v0, 5              # Input Loop
                syscall
                sw      $v0, 0($t0)         
                addi    $t1, $t1, 4
                b		while 			    # branch to target
            
    endwhile:   

                add     $s7, $0, $a0
                add     $s6, $0, $a1        # Save array size and pointer


                jal sort                    #Jump to function sort     #### Function Return

                move    $a0, $s7            # Replace with beginning values
                move    $a1, $s6            
                move    $s0,$a0


                #print the top of array

                li      $v0, 4
                la      $a0, promptans      # Print array index 0
                syscall


                lw $a0,0($s0) # $a0=unsorted[i]
                li $v0,1
                syscall

                li $v0,10
                syscall


#### Function for Sort. 

sort:

                move $a2,$a1    # $a2=n (count)

                sub $a1,$a1,1 # $a1=n-1 (count - 1)

                li $t0,0 # i=0

                forLoop1:

                                # if i=n-1, exit loop ,

                                beq $t0,$a1,exit

                                move $s0,$t0 # min=i

                                move $t1,$t0 #j=i

                forLoop2:

                                add $t1,$t1,1 # j=i+1

                                bne $t1,$a2, compare

                                j swap

                compare:

                                li $t2,4

                                mul $t3,$t2,$t1

                                add $t3,$t3,$a0

                                mul $t4,$t2,$s0

                                add $t4,$t4,$a0

                                lw $t5,0($t3)                   # t5 =  array[j]

                                lw $t6,0($t4)                   # t6=   array[min]

                                slt $t7,$t5,$t6                 # set $t7=1, if $t5<$t6

                                bne $t7,1,forLoop2              # if $t7 is not eqaul to 1

                                move $s0,$t1                    # other wise set min=j

                                j forLoop2                      # goto forLoop2

                               

swap:

                # swap array[i] and array[min]

                li $t2,4

                mul $t3,$t2,$t0

                add $t3,$t3,$a0

                lw $t5,0($t3) # t5=array[i]

                mul $t4,$t2,$s0

                add $t4,$t4,$a0

                lw $t6,0($t4) # t6=array[min]

                sw $t5,($t4)

                sw $t6,($t3)

                add $t0,$t0,1

                j forLoop1

exit:

                jr $ra # return to main