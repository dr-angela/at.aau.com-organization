.data
Fakultät1_10: .asciiz "Fakultät beträgt: " # Message for output
newline: .asciiz "\n"                     # Newline for formatting output

.text
.globl main

# Main program
main:
    li $t0, 0                 # Start with n = 0

print_loop:
    move $a0, $t0             # Pass n to factorial function
    jal factorial             # Call factorial(n)

    # Display the result message
    li $v0, 4                 # Syscall for string output
    la $a0, Fakultät1_10      # Load address of the message
    syscall                   # Print message

    # Secure the factorial result before syscall that changes $v0
    move $s0, $v0             # Save factorial result in $s0
    move $a0, $s0             # Move saved result to $a0 for printing

    li $v0, 1                 # Syscall for integer output
    syscall                   # Print factorial result

    # Print newline for better output formatting
    li $v0, 4                 # Syscall for string output
    la $a0, newline           # Load newline string
    syscall                   # Print newline

    addi $t0, $t0, 1          # Increment n
    ble $t0, 10, print_loop   # Repeat until n = 10

end:
    li $v0, 10                # Syscall to exit
    syscall

# Recursive factorial function
factorial:
    # Base case: if n == 0, return 1
    beq $a0, 0, base_case     # If n == 0, jump to base_case

    # Recursive case: f(n) = n * f(n-1)
    addi $sp, $sp, -8         # Allocate space on stack for $a0 and $ra
    sw $a0, 0($sp)            # Save current n on stack
    sw $ra, 4($sp)            # Save return address on stack

    addi $a0, $a0, -1         # n - 1
    jal factorial             # Recursive call factorial(n-1)

    lw $a0, 0($sp)            # Restore original n
    lw $ra, 4($sp)            # Restore return address
    addi $sp, $sp, 8          # Deallocate space on stack

    # Multiply the returned value (in $v0) with n (in $a0)
    mul $v0, $v0, $a0         # Multiply n * factorial(n-1)

    jr $ra                    # Return to caller

base_case:
    li $v0, 1                 # Set return value to 1 if n == 0
    jr $ra                    # Return