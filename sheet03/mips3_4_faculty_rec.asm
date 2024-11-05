.data
newline: .asciiz "\n"           # Newline string for formatting output
error_msg: .asciiz "Overflow occurred\n"  # Error message for overflow

.text
.globl main

# Main program
main:
    li $t0, 0                   # Start with n = 0

loop:
    move $a0, $t0               # Pass n as argument in $a0 (caller-saved)
    jal factorial_recursive     # Call recursive factorial function
    move $a0, $v0               # Move result to $a0 for printing (caller-saved)
    
    li $v0, 1                   # Syscall code for printing integer
    syscall                     # Print the integer in $a0 (factorial result)

    li $v0, 4                   # Syscall code for printing string
    la $a0, newline             # Load address of newline string into $a0
    syscall                     # Print the newline

    addi $t0, $t0, 1            # Increment n
    bgt $t0, 10, end            # Stop after n = 10 to avoid overflow
    j loop                      # Repeat the loop for the next value of n

end:
    li $v0, 10                  # Syscall code for program exit
    syscall                     # Exit the program

# Recursive factorial function with overflow check
factorial_recursive:
    li $v0, 1                   # Initialize $v0 to 1, base case for factorial of 0
    beq $a0, 0, end_factorial_recursive  # If n == 0, return 1 immediately

    # Recursive case: factorial(n) = n * factorial(n - 1)
    
    addi $sp, $sp, -4           # Allocate space on the stack for $a0 (parameter n)
    sw $a0, 0($sp)              # Save the current value of n on the stack (caller-saved)
    
    subi $a0, $a0, 1            # Set $a0 to n - 1 for the recursive call
    jal factorial_recursive     # Recursive call: factorial_recursive(n - 1)
    # After returning, $v0 contains factorial(n - 1) result

    lw $a0, 0($sp)              # Restore the original value of n from the stack
    addi $sp, $sp, 4            # Deallocate space on the stack

    # Multiply n * factorial(n - 1) and store in $v0 with overflow check
    multu $v0, $a0              # Multiply $v0 and $a0 using unsigned multiplication
    mflo $v0                    # Move the result from LO to $v0 (factorial result)
    mfhi $t2                    # Move the upper 32 bits (HI) to $t2 for overflow check

    # Debug output: print the value of $v0 after each multiplication
    li $v0, 1                   # Syscall code to print integer
    move $a0, $v0               # Move result to $a0 for printing
    syscall                     # Print $v0

    bne $t2, $zero, overflow    # If HI != 0, overflow occurred

end_factorial_recursive:
    jr $ra                      # Return to caller, address held in $ra

# Overflow handling
overflow:
    li $v0, 4                   # Syscall to print string
    la $a0, error_msg           # Load address of overflow error message
    syscall                     # Print the error message

    li $v0, 10                  # Syscall to exit the program
    syscall                     # Exit due to overflow