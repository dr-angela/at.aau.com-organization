.data
newline: .asciiz "\n"

.text
.globl main

main:
    li $t0, 0

print_loop:
    move $a0, $t0
    jal factorial

    move $a0, $v0
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    ble $t0, 10, print_loop

end:
    li $v0, 10
    syscall

factorial:
    beq $a0, 0, base_case

    addi $sp, $sp, -8
    sw $a0, 0($sp)
    sw $ra, 4($sp)

    addi $a0, $a0, -1
    jal factorial

    lw $a0, 0($sp)
    lw $ra, 4($sp)
    addi $sp, $sp, 8

    mul $v0, $v0, $a0

    jr $ra

base_case:
    li $v0, 1
    jr $ra
