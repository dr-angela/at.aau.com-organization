.data	
buffer: .space 100                 # Reserviert eine 100 Bytes Variable namens buffer 
message_prompt: .asciiz "Bitte Zeichenkette eingeben: "

.text
.globl main			

main:				   # Startpunkt des Programms
    # Eingabeaufforderung ausgeben
    la $a0, message_prompt  	   # load address from message_prompt to $a0
    li $v0, 4                      # load immediate - Systemaufruf zum Ausgeben einer Zeichenkette
    syscall			   # Systemaufruf wird ausgeführt

    # Zeichenkette einlesen
    la $a0, buffer                 # load address from buffer to $a0
    li $a1, 100                    # load immediate - Zeichenkettenlänge in $a1 speichern
    li $v0, 8                      # load immediate - Read string syscall
    syscall

    # Schleife über jedes Zeichen in der Zeichenkette
    la $t0, buffer                 # load address from buffer to $t0
    
convert_loop:			   # Entry of convert_loop
    lb $t1, 0($t0)                 # load byte at address in $t0 into $t1 (read a single character)
    
    # Schleifenabbruch bei Nullterminierung
    beq $t1, $zero, end_conversion	# Check if byte is null terminator (0); if yes, jump to end_conversion to exit loop

    # Überprüfung, ob das Zeichen ein Kleinbuchstabe ist (a-z)
    li $t2, 97                     # Load ASCII for 'a' into $t2
    li $t3, 122                    # Load ASCII for 'z' into $t3
    blt $t1, $t2, check_uppercase  # if $t1 < 'a', jump to check_uppercase
    bgt $t1, $t3, check_uppercase  # if $t1 > 'z', jump to check_uppercase
    sub $t1, $t1, 32               # Konvertiere in Großbuchstaben
    j store_character              # Jump to store character

check_uppercase:
    # Überprüfung, ob das Zeichen ein Großbuchstabe ist (A-Z)
    li $t2, 65                     # Load ASCII for 'A' into $t2
    li $t3, 90                     # Load ASCII for 'Z' into $t3
    blt $t1, $t2, skip_conversion  # if $t1 < 'A', jump to skip_conversion
    bgt $t1, $t3, skip_conversion  # if $t1 > 'Z', jump to skip_conversion
    add $t1, $t1, 32               # Konvertiere in Kleinbuchstaben

store_character:
    # Speicher das konvertierte Zeichen
    sb $t1, 0($t0)
    addi $t0, $t0, 1               # Move to next character in buffer
    j convert_loop                 # jump to convert_loop: Repeat loop for next character

skip_conversion:
    # Speicher das unveränderte Zeichen
    sb $t1, 0($t0)		   # Store unmodified character in buffer
    addi $t0, $t0, 1               # Move to next character in buffer
    j convert_loop                 # Repeat loop for next character

end_conversion:
    # Ergebniszeichenkette ausgeben
    la $a0, buffer
    li $v0, 4                      # Print string syscall
    syscall

    # Programm beenden
    li $v0, 10                     # load immediate - operating system funct: 10 - Programmende
    syscall
