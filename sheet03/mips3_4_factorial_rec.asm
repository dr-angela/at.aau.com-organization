.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $t0, 0	# initialize 0 to $t0, as counter

print_loop:
    move $a0, $t0	# move the value of $t0 to $a0 as an argument 
    jal factorial	# jump and link to factorial 

    move $a0, $v0	# after factorial call we get the a value back in $v0 and copy it into $a0
    li $v0, 1		# os function: print int
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1		# increment counter 
    ble $t0, 10, print_loop	# branch to print_loop as long if n in $t0 is <= 10

end:
    li $v0, 10
    syscall

# procedure
factorial:
    beq $a0, 0, base_case	# if $a0=0, jump to base case

    addi $sp, $sp, -8		# increment sp - for saving $a0 and $sp (4bytes+4bytes)
    sw $a0, 0($sp)		# store value of $a0 on stack
    sw $ra, 4($sp)		# store return address on stack

    addi $a0, $a0, -1		# decrement counter
    jal factorial		# recursive jump with updated counter in $a0

    lw $a0, 0($sp)		# loads original value ($a0) from stack to $a0
    lw $ra, 4($sp)		# loads return address from stack 
    addi $sp, $sp, 8		# increment sp (clear stack, we don't need those 8 byte anymore)

    mul $v0, $v0, $a0		# continue calculation 

    jr $ra

base_case:
    li $v0, 1	# factorial(0)=1
    jr $ra	# return to caller
