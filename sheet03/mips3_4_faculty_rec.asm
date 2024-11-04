.data
newline: .asciiz "\n"           # Newline string for formatting output

.text
.globl main

# Main program
main:
    li $t0, 0                  # Start with n = 0

loop:
    move $a0, $t0              # Pass n as argument in $a0
    jal factorial_recursive    # Call recursive factorial function
    move $a0, $v0              # Move result to $a0 for printing
    li $v0, 1                  # Syscall to print integer
    syscall
    li $v0, 4                  # Syscall to print newline
    la $a0, newline
    syscall

    addi $t0, $t0, 1           # Increment n
    bgt $t0, 10, end           # Stop after n = 10
    j loop

end:
    li $v0, 10                 # Exit program
    syscall

# Recursive factorial function
factorial_recursive:
    # Basisfall: f(0) = 1
    li $v0, 1
    beq $a0, 0, end_factorial_recursive  # If n == 0, return 1

    # Rekursiver Fall: f(n) = n * f(n - 1)
    addi $sp, $sp, -4          # Allocate space on stack for $a0
    sw $a0, 0($sp)             # Save current n on stack

    subi $a0, $a0, 1           # Set n = n - 1
    jal factorial_recursive    # Call factorial_recursive(n - 1)

    lw $a0, 0($sp)             # Restore n from stack
    addi $sp, $sp, 4           # Deallocate space on stack
    mul $v0, $v0, $a0          # n * result of factorial_recursive(n - 1)

end_factorial_recursive:
    jr $ra                     # Return to caller