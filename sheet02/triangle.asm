.data
message_true: .asciiz "Dreiecksungleichung GILT\n"
message_false: .asciiz "Dreiecksungleichung gilt NICHT\n"

.text
.globl main
main:
    # Einlesen von a
    li $v0, 5           # Systemaufruf zum Einlesen eines Integers
    syscall
    move $t0, $v0       # Wert von a in $t0 speichern

    # Einlesen von b
    li $v0, 5
    syscall
    move $t1, $v0       # Wert von b in $t1 speichern

    # Einlesen von c
    li $v0, 5
    syscall
    move $t2, $v0       # Wert von c in $t2 speichern

    # Überprüfung der Dreiecksungleichung: c <= a + b
    add $t3, $t0, $t1   # a + b in $t3 speichern
    ble $t2, $t3, print_true  # Falls c <= a + b, springe zu print_true

    # Falls Bedingung nicht erfüllt ist, "Nicht"-Nachricht ausgeben
    print_false:
    la $a0, message_false  # Lade Adresse der Nachricht
    li $v0, 4              # Systemaufruf zum Drucken einer Zeichenkette
    syscall
    j end_program           # Programm beenden

    # Falls Bedingung erfüllt ist, "Gilt"-Nachricht ausgeben
    print_true:
    la $a0, message_true    # Lade Adresse der Nachricht
    li $v0, 4               # Systemaufruf zum Drucken einer Zeichenkette
    syscall

    # Programmende
    end_program:
    li $v0, 10              # Systemaufruf zum Programmende
    syscall