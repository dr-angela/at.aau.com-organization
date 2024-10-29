.data
buffer: .space 100                 # Speicher für die Eingabezeichenkette (max. 100 Zeichen)
message_prompt: .asciiz "Bitte Zeichenkette eingeben: "

.text
.globl main

main:				# Startpunkt des Programms
    # Eingabeaufforderung ausgeben
    la $a0, message_prompt  	   # load address from message_prompt to $a0
    li $v0, 4                      # Print string syscall
    syscall

    # Zeichenkette einlesen
    la $a0, buffer                 # load address from buffer to $a0
    li $a1, 100                    # Zeichenkettenlänge in $a1 speichern
    li $v0, 8                      # Read string syscall
    syscall

    # Schleife über jedes Zeichen in der Zeichenkette
    la $t0, buffer                 # load address from buffer to $t0
convert_loop:			   # Entry of convert_loop
    lb $t1, 0($t0)                 # Load byte at address in $t0 into $t1 (read a single character)
    # Schleifenabbruch bei Nullterminierung
    beq $t1, $zero, end_conversion

    # Überprüfung, ob das Zeichen ein Kleinbuchstabe ist (a-z)
    li $t2, 97                     # ASCII für 'a'
    li $t3, 122                    # ASCII für 'z'
    blt $t1, $t2, check_uppercase  # if $t1 < 'a', jump to check_uppercase
    bgt $t1, $t3, check_uppercase  # if $t1 > 'z', jump to check_uppercase
    sub $t1, $t1, 32               # Konvertiere in Großbuchstaben
    j store_character              # Speichern und nächsten Durchlauf

check_uppercase:
    # Überprüfung, ob das Zeichen ein Großbuchstabe ist (A-Z)
    li $t2, 65                     # ASCII für 'A'
    li $t3, 90                     # ASCII für 'Z'
    blt $t1, $t2, skip_conversion  # Wenn $t1 < 'A', springe zu skip_conversion
    bgt $t1, $t3, skip_conversion  # Wenn $t1 > 'Z', springe zu skip_conversion
    add $t1, $t1, 32               # Konvertiere in Kleinbuchstaben

store_character:
    # Speicher das konvertierte Zeichen
    sb $t1, 0($t0)
    addi $t0, $t0, 1               # Zum nächsten Zeichen
    j convert_loop                 # jump to conver:_loop: Wiederhole die Schleife

skip_conversion:
    # Speicher das unveränderte Zeichen
    sb $t1, 0($t0)
    addi $t0, $t0, 1               # Zum nächsten Zeichen
    j convert_loop                 # Wiederhole die Schleife

end_conversion:
    # Ergebniszeichenkette ausgeben
    la $a0, buffer
    li $v0, 4                      # Print string syscall
    syscall

    # Programm beenden
    li $v0, 10                     # Exit syscall
    syscall