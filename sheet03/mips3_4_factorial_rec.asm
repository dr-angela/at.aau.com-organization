.data
newline: .asciiz "\n"  # Zeilenumbruch für bessere Formatierung der Ausgabe

.text
.globl main

main:
    li $t0, 0  # Startwert für n

print_loop:
    move $a0, $t0          # Übergebe n an die Fakultätsfunktion
    jal factorial          # Rufe die rekursive Fakultätsfunktion auf

    # Ausgabe des Fakultätsergebnisses
    move $a0, $v0          # Bereitstellen des Ergebnisses für den Druck
    li $v0, 1              # Syscall-Code für das Drucken eines Integers
    syscall

    # Zeilenumbruch ausgeben
    li $v0, 4              # Syscall-Code für das Drucken einer Zeichenkette
    la $a0, newline        # Adresse des Zeilenumbruchs laden
    syscall

    addi $t0, $t0, 1       # Inkrementiere n
    ble $t0, 10, print_loop  # Wiederhole bis n = 10 erreicht ist

end:
    li $v0, 10             # Syscall-Code zum Beenden des Programms
    syscall

# Rekursive Fakultätsfunktion
factorial:
    beq $a0, 0, base_case  # Basisfall: Wenn n == 0, gehe zu base_case

    # Rekursiver Fall: f(n) = n * f(n-1)
    addi $sp, $sp, -8      # Stack-Platz für $ra und $a0 reservieren
    sw $a0, 0($sp)         # Aktuellen Wert von n auf den Stack legen
    sw $ra, 4($sp)         # Rücksprungadresse auf den Stack legen

    addi $a0, $a0, -1      # Reduziere n um 1
    jal factorial          # Rekursiver Aufruf mit n-1

    lw $a0, 0($sp)         # Stelle den ursprünglichen Wert von n wieder her
    lw $ra, 4($sp)         # Stelle die Rücksprungadresse wieder her
    addi $sp, $sp, 8       # Gebe Stack-Platz frei

    mul $v0, $v0, $a0      # Multipliziere das zurückgegebene Ergebnis mit n

    jr $ra                 # Kehre zum Aufrufer zurück

base_case:
    li $v0, 1              # Rückgabewert 1, wenn n == 0
    jr $ra                 # Kehre zum Aufrufer zurück