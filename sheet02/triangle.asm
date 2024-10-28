.data			# ab hier statische Daten
message_true: .asciiz "Dreiecksungleichung GILT\n"
message_false: .asciiz "Dreiecksungleichung gilt NICHT\n"

.text			# ab hier ausführbarer Code
.globl main
main:
    # Einlesen von a
    li $v0, 5           # operating system function: Systemaufruf zum Einlesen eines Integers
    syscall
    move $t0, $v0       # Wert von $v0 (=a) nach $t0 kopieren

    # Einlesen von b
    li $v0, 5		# 5 = Einlesen einer Ganzzahl
    syscall
    move $t1, $v0       # Wert von $v0 (=b) nach $t1 kopieren

    # Einlesen von c
    li $v0, 5
    syscall
    move $t2, $v0       # Wert von $v0 (=c) nach $t2 kopieren

    # Überprüfung der Dreiecksungleichung: c <= a + b
    add $t3, $t0, $t1   	# Addition von $t0 und $t1 und Ergebnis nach $t3
    ble $t2, $t3, print_true  	# Branch if Less Than or Equal und überprüft, 
    				# ob der Wert in $t2 (c) kleiner oder gleich $t3 (a + b) ist

    # Bedingung ist falsch: Ausgabe von message_false
    print_false:
    la $a0, message_false  	# Load Address: lädt Speicheradresse von message_false in Reg $a0
    li $v0, 4              	# operating system funct: zum Ausgeben einer Zeichenkette (String)
    syscall
    j end_program           	# jump to end_programm

    # Bedingung ist wahr: Ausgabe von message_true
    print_true:
    la $a0, message_true    # Load Address
    li $v0, 4               # operating system funct: zum Ausgeben einer Zeichenkette (String) 
    syscall

    # Programmende
    end_program:
    li $v0, 10              # load immediate - operating system funct: 10 - Programmende
    syscall