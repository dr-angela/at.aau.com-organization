.data
newline: .asciiz "\n"  # line break string for formatting the output

.text
.globl main

main:
    li $t0, 1               # start value n=1

print_loop:
    move $a0, $t0          # put n into $a0 for the fibonacci function
    jal fibonacci          # call the recursive fibonacci function

    move $a0, $v0          # move the result into $a0 for printing
    li $v0, 1              # syscall code for printing an integer
    syscall                # execute syscall to print the integer

    li $v0, 4              # syscall code for printing a string
    la $a0, newline        # load the address of the newline string
    syscall                # execute syscall to print the newline

    addi $t0, $t0, 1       	# increment n by 1
    ble $t0, 10, print_loop  	# loop back if n is less than or equal to 10

end:
    li $v0, 10             # syscall code for exiting a program
    syscall                # execute syscall to terminate the program

# Recursive fibonacci function
fibonacci:
    li $v0, 1              # set the return value to 1 when n <= 2
    ble $a0, 2, end_fib    # if n <= 2, jump to end_fib and return 1

    addi $sp, $sp, -12     # make space on the stack for $ra, $a0, and intermediate result
    sw $a0, 0($sp)         # save the current value of n on the stack
    sw $ra, 4($sp)         # save the return address on the stack

    addi $a0, $a0, -1      # decrease n by 1
    jal fibonacci          # recursive call fibonacci with n-1
    sw $v0, 8($sp)         # save the result of F(n-1) on the stack

    lw $a0, 0($sp)         # restore the original value of n
    addi $a0, $a0, -2      # decrease n by 2
    jal fibonacci          # recursive call fibonacci with n-2

    lw $s0, 8($sp)         # restore the result of F(n-1)
    add $v0, $v0, $s0      # add the result of F(n-2) to F(n-1)

    lw $ra, 4($sp)         # restore the return address
    addi $sp, $sp, 12      # deallocate the stack space
    jr $ra                 # return to the caller

end_fib:
    jr $ra                 # return to the caller