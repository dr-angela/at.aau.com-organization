.data
newline: .asciiz "\n"           # "\n" as newline string for formatting output

.text
.globl main

main:
	li $t0, 0	# load immediate 0 into $t0 (temp, caller-saved)

loop:
	move $a0, $t0	# put n as argument into $a0 (caller-saved)
	jal factorial	# function call; jal holds in $ra return address
	move $a0, $v0	# put result from $v0 to $a0 for printing
	li $v0, 1	# syscall to print integer
	syscall
	li $v0, 4	# syscall to print new line
	la $a0, newline	
	syscall
	
	addi $t0, $t0, 1	# increment n 
	bgt $t0, 10, end	# end if value in $t0 is 10
	j loop 
	
end:
	li $v0, 10	# os function -> exit programm
	syscall

factorial:
	li $v0, 1			# return value is 0!=1 (caller-saved)
	beq $a0, 0, end_factorial	# # if n==0, return 1 (base case for factorial)
	move $t1, $a0			# copy n into $t1, we will need it (caller-saved)
	
factorial_loop:
	mul $v0, $v0, $t1		# multiply with n
	subi $t1, $t1, 1		# decrement n 
	bgt $t1, 0, factorial_loop	# repeat until n is 0

end_factorial:
	jr $ra	# help function if n==0

