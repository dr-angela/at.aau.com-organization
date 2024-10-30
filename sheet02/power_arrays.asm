    .data
array:     .word 15, 23, 32, 1, 34, 68, 256, 11, 128, 16
arraySize: .word 10

msg_power_of_two: .asciiz " ist eine Zweierpotenz.\n"
msg_not_power_of_two: .asciiz " ist keine Zweierpotenz.\n"

    .text
    .globl main

main:
    # Load size of array
    la   $t0, arraySize       	# load address from arrSize into $t0
    lw   $t1, 0($t0)         	# load (word) size of array in $t1
    la   $t2, array            	# load address of array in $t2

    # Initialize a counter variable 
    li   $t3, 0              	# load immediate 0 into $t3 (counter/index)

loop:
    # End the loop if the index reaches the array size
    bge  $t3, $t1, end       	# branch if $t3 >= $t1 to end 

    # Load the current array element
    lw   $t4, 0($t2)         	# load current array element into $t4
    addi $t2, $t2, 4         	# increment $t2 to point to the next element (4 byte long)

    # Check if $t4 is power of two 
    move $a0, $t4           	# copy the element to $a0 for output; $t4=n
    addi $t5, $t4, -1        	# $t5 = n - 1
    and  $t6, $t4, $t5       	# $t6 = n AND (n - 1)
    
    # Check if $t6 == 0 
    beq  $t6, $zero, is_power_of_two	# branch to is_power_of_two if $t6 == 0
    j    not_power_of_two		# otherwise jump to not_power_of_two (if $t6 != 0)


is_power_of_two:
    # Output -> msg_power_of_two
    li   $v0, 1              		# load syscall imm. number 1 for integer output
    move $a0, $t4			
    syscall				# execute syscall to output integer

    la   $a0, msg_power_of_two  	# load address from output message 
    li   $v0, 4                 
    syscall
    j    increment_counter      

not_power_of_two:
    # Output -> msg_not_power_of_two
    li   $v0, 1              
    move $a0, $t4
    syscall

    la   $a0, msg_not_power_of_two 
    li   $v0, 4                    
    syscall

increment_counter:
    # Increment counter variable for loop
    addi $t3, $t3, 1         # ++
    j    loop                # go back to loop

end:
    li   $v0, 10             # load immediate - operating system funct: 10 - Programmende
    syscall