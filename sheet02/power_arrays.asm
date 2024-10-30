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

    
    lw   $t4, 0($t2)         # load current array element into $t4
    addi $t2, $t2, 4         # Nächstes Array-Element (4 Byte pro Wort)

    # Prüfe, ob $t4 eine Zweierpotenz ist
    move $a0, $t4            # Kopiere das Element in $a0 für die Ausgabe
    addi $t5, $t4, -1        # $t5 = n - 1
    and  $t6, $t4, $t5       # $t6 = n AND (n - 1)
    
    # Prüfe, ob $t6 == 0 und $t4 > 0
    beq  $t6, $zero, is_power_of_two
    j    not_power_of_two

is_power_of_two:
    # Ausgabe: ist eine Zweierpotenz
    li   $v0, 1              # Syscall für die Ausgabe von Integern
    move $a0, $t4
    syscall

    la   $a0, msg_power_of_two  # Lade die Nachricht "ist eine Zweierpotenz"
    li   $v0, 4                 # Syscall für das Drucken einer Zeichenkette
    syscall
    j    increment_counter      # Gehe zum Inkrementieren des Zählers

not_power_of_two:
    # Ausgabe: ist keine Zweierpotenz
    li   $v0, 1              # Syscall für die Ausgabe von Integern
    move $a0, $t4
    syscall

    la   $a0, msg_not_power_of_two # Lade die Nachricht "ist keine Zweierpotenz"
    li   $v0, 4                    # Syscall für das Drucken einer Zeichenkette
    syscall

increment_counter:
    # Inkrementiere den Schleifenzähler
    addi $t3, $t3, 1         # Erhöhe den Zähler um 1
    j    loop                # Zurück zur Schleife

end:
    li   $v0, 10             # Programm beenden
    syscall