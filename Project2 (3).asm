#############################################################################
#############################################################################
.data
FileName: .space 40
input_from_file: .space 1000
clean_input: .space 1000
output_to_file: .space 1000
shift_value: .word 1:100
message1: .asciiz "Enter e for encryption OR d for decryption: "
message2: .asciiz "\nInput the name of the plain text file: "
message3: .asciiz "\nInput the name of the cipher text file: "
message4:  .asciiz "The Shift Value = "
message5:  .asciiz "\nThe Program is End"
.text
.globl main
main: 
la $a0, message1
li $v0, 4
syscall
li $v0, 12
syscall
beq $v0, 'e', encryption_text
beq $v0, 'd', decryption_text
j End_program
###########################################################################
encryption_text:
la $a0, message2
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
Add_Null_to_File_Name:
lb $t0, FileName($t2)
beq $t0, 10, replace
addiu $t2, $t2, 1
j Add_Null_to_File_Name
replace:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 0
syscall 
move $a0, $v0
blt $a0, 0, End_program
la $a1, input_from_file
li $a2, 1000
li $v0, 14
syscall 
move $t0, $v0
li $v0, 16
syscall
move $t2, $zero
move $t3, $zero
la $a0, input_from_file
la $a1, clean_input
remove_none_alphabet_characters:
beq $t3, $t0, Convert_All_Characters_To_Lower_Case
lb $t1, 0($a0) 
addiu $a0, $a0, 1
addiu $t3, $t3, 1
beq $t1, ' ', Add_Char_To_claen_input
bgt $t1, 'Z', Small_Char
blt $t1, 'A', remove_none_alphabet_characters
j Add_Char_To_claen_input
Small_Char:
bgt $t1, 'z', remove_none_alphabet_characters
blt $t1, 'a', remove_none_alphabet_characters
Add_Char_To_claen_input:
sb $t1, 0($a1)
addiu $a1, $a1, 1
addiu $t2, $t2, 1
j remove_none_alphabet_characters
Convert_All_Characters_To_Lower_Case:
move $t0, $zero
la $a0, clean_input
subiu $a0, $a0, 1
Loop:
beq $t0, $t3, calculate_shift_value
addiu $a0, $a0, 1
addiu $t0, $t0, 1
lb $t1, 0($a0)
bge $t1, 'a', Loop
beq $t1, ' ', Loop
addiu $t1, $t1, 32
sb $t1, 0($a0)
j Loop
calculate_shift_value:
la $a0, clean_input
la $a1, shift_value
move $t0, $zero
move $t2, $zero
move $t4, $zero
la $a0, clean_input
calculate:
beq $t0, $t3, print_shift_value
lb $t1, 0($a0)
beq $t1, ' ', NewWord
addiu $a0, $a0, 1
addiu $t0, $t0, 1
addiu $t2, $t2, 1
j calculate
NewWord:
sw $t2, 0($a1)
addiu $a1, $a1, 4
addiu $a0, $a0, 1
addiu $t0, $t0, 1
addiu $t4, $t4, 1
move $t2, $zero
j calculate
print_shift_value:
sw $t2, 0($a1)
addiu $t4, $t4, 1
la $a0, shift_value
move $a1, $t4
move $t8, $t3
jal bubbleSort
la $a0, message4
li $v0, 4	
syscall
la $a1, shift_value
lw $a0, 0($a1)
li $v0, 1
syscall
move $t6, $a0
move $t0, $zero
la $a0, clean_input
la $a1, output_to_file
Add_shift_value_to_text:
beq $t0, $t8, read_output_file_name
lb $t1, 0($a0)
beq $t1, ' ', Store_ouput
add $t1, $t1, $t6
ble $t1, 'z', Store_ouput
subiu $t1, $t1, 26
Store_ouput:
sb $t1, 0($a1)
addiu $a0, $a0, 1
addiu $a1, $a1, 1
addiu $t0, $t0, 1
j Add_shift_value_to_text
read_output_file_name:
la $a0, message3
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
Add_Null_to_File_Name_out:
lb $t0, FileName($t2)
beq $t0, 10, replac_out
addiu $t2, $t2, 1
j Add_Null_to_File_Name_out
replac_out:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 1
syscall 
move $a0, $v0
la $a1, output_to_file
move $a2, $t8
li $v0, 15
syscall 
move $t0, $v0
li $v0, 16
syscall
j End_program
###########################################################
decryption_text:
la $a0, message3
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
Add_Null_to_File_Name_In_dec:
lb $t0, FileName($t2)
beq $t0, 10, replace_In_dec
addiu $t2, $t2, 1
j Add_Null_to_File_Name_In_dec
replace_In_dec:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 0
syscall 
move $a0, $v0
blt $a0, 0, End_program
la $a1, clean_input
li $a2, 1000
li $v0, 14
syscall 
move $t8, $v0
li $v0, 16
syscall
la $a0, clean_input
la $a1, shift_value
move $t0, $zero
move $t2, $zero
move $t4, $zero
la $a0, clean_input
calculate_dec:
beq $t0, $t8, print_shift_value_dec
lb $t1, 0($a0)
beq $t1, ' ', NewWord_dec
addiu $a0, $a0, 1
addiu $t0, $t0, 1
addiu $t2, $t2, 1
j calculate_dec
NewWord_dec:
sw $t2, 0($a1)
addiu $a1, $a1, 4
addiu $a0, $a0, 1
addiu $t0, $t0, 1
addiu $t4, $t4, 1
move $t2, $zero
j calculate_dec
print_shift_value_dec:
sw $t2, 0($a1)
addiu $t4, $t4, 1
la $a0, shift_value
move $a1, $t4
jal bubbleSort
la $a0, message4
li $v0, 4	
syscall
la $a1, shift_value
lw $a0, 0($a1)
li $v0, 1
syscall
move $t6, $a0
move $t0, $zero
la $a0, clean_input
la $a1, output_to_file
Sub_shift_value_to_text:
beq $t0, $t8, read_output_file_name_dec
lb $t1, 0($a0)
beq $t1, ' ', Store_ouput_dec
sub $t1, $t1, $t6
bge $t1, 'a', Store_ouput_dec
addiu $t1, $t1, 26
Store_ouput_dec:
sb $t1, 0($a1)
addiu $a0, $a0, 1
addiu $a1, $a1, 1
addiu $t0, $t0, 1
j Sub_shift_value_to_text
read_output_file_name_dec:
la $a0, message2
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
Add_Null_to_File_Name_out_dec:
lb $t0, FileName($t2)
beq $t0, 10, replac_out_dec
addiu $t2, $t2, 1
j Add_Null_to_File_Name_out_dec
replac_out_dec:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 1
syscall 
move $a0, $v0
la $a1, output_to_file
move $a2, $t8
li $v0, 15
syscall 
move $t0, $v0
li $v0, 16
syscall
End_program:
la $a0, message5
li $v0, 4	
syscall 
li $v0, 10
syscall
bubbleSort: # $a0 = &A, $a1 = n
do: addiu $a1, $a1, -1 # n = n-1
blez $a1, L2 # branch if (n <= 0)
move $t0, $a0 # $t0 = &A
li $t1, 0 # $t1 = swapped = 0
li $t2, 0 # $t2 = i = 0
for: lw $t3, 0($t0) # $t3 = A[i]
lw $t4, 4($t0) # $t4 = A[i+1]
bge $t3, $t4, L1 # branch if (A[i] => A[i+1])
sw $t4, 0($t0) # A[i] = $t4
sw $t3, 4($t0) # A[i+1] = $t3
li $t1, 1 # swapped = 1
L1: addiu $t2, $t2, 1 # i++
addiu $t0, $t0, 4 # $t0 = &A[i]
bne $t2, $a1, for # branch if (i != n)
bnez $t1, do # branch if (swapped)
L2: jr $ra # return to caller
	