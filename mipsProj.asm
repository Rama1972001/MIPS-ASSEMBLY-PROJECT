# This project requires to build a MIPS program that does simple encryption/decryption algorithm based on Caesar
#cipher algorithm for English- based text messages.
# Done by Nour Malaki + Rama Abdlrahman 

.data
FileName: .space 40
input_from_file: .space 1000
clean_input: .space 1000 # new file after removing nonalphabatic
output_to_file: .space 1000
shift_value: .word 1:100 # array integer of 100 
message1: .asciiz "\nPlease choose:\n(E) for encryption\n(D) for decryption\nInput: "
message2: .asciiz "\nInput the name of the plain text file: "
message3: .asciiz "\nInput the name of the cipher text file: "
message4:  .asciiz "The Shift Value = "
message5:  .asciiz "\n>>Program finished"
message6: .asciiz "\n-------------------------------------------------------------\n Invalid!!\n"
message7:  .asciiz "Error opening file.."
message8: .asciiz "\n========================= Welcome To our Program ===========================\n"

.text
la $a0, message8 # Welcoming message
li $v0, 4
syscall
.globl main
main: 
la $a0, message1 #menu message
li $v0, 4
syscall
li $v0, 12 # read character
syscall
beq $v0, 'e', encryption_text
beq $v0, 'E', encryption_text
beq $v0, 'd', decryption_text
beq $v0, 'D', decryption_text
la $a0, message6 # invalid message
li $v0, 4
syscall
j main #repeat process
###########################################################################
encryption_text:
la $a0, message2 #inputfile
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8  #read file string
syscall 
move $t2, $zero # index to walk through file name and remove \n at the end
continuee:
lb $t0, FileName($t2)
beq $t0, 10, replace # 10 is ascii code for \n
addiu $t2, $t2, 1 #if we did not reach the end of file name >> continue
j continuee
replace:
sb $zero, FileName($t2) # replace \n with \0
la $a0, FileName
li $v0, 13 #file open
li $a1, 0 # 0 is for  read int
syscall
bge $v0, 0, exist # file exist
la $a0, message7 # file does not exist if less than file descriptor = 0
li $v0, 4 #print
syscall #do
j encryption_text #repeat
exist:  #readfile
#$a0 = file descriptor
#$a1 = address of input buffer
#$a2 = maximum number of characters to read

move $a0, $v0 #file descriptor in $v0
la $a1, input_from_file # array of  what i read in a1
li $a2, 1000 
li $v0, 14 
syscall 
move $t0, $v0 # save to temp file number of read chars
li $v0, 16 #close file
syscall
move $t2, $zero #index to walk through input from file array
move $t3, $zero # save num of chars after clean (length)
la $a0, input_from_file
la $a1, clean_input
############################################
remove_none_alphabet_characters:
############################################
beq $t3, $t0, Convert_All_Characters_To_Lower_Case #if they are equal >> i walked through every letter
lb $t1, 0($a0) # load on t1 (char of input from file)
addiu $a0, $a0, 1 # address of next character
addiu $t3, $t3, 1 # i=1
beq $t1, ' ', Add_Char_To_claen_input # keep the previous read form
beq $t1, 10, Add_Char_To_claen_input
beq $t1, 13, Add_Char_To_claen_input
bgt $t1, 'Z', Small_Char #90  either small or character
blt $t1, 'A', remove_none_alphabet_characters #65 >>>skip
j Add_Char_To_claen_input
Small_Char:
bgt $t1, 'z', remove_none_alphabet_characters #122 >> noNALPHA character 
blt $t1, 'a', remove_none_alphabet_characters #97
Add_Char_To_claen_input:
sb $t1, 0($a1) #store space + \n + \r
addiu $a1, $a1, 1 # move to next bar in array
addiu $t2, $t2, 1 # count num of characters to the clean input
j remove_none_alphabet_characters
#===============================================
Convert_All_Characters_To_Lower_Case:
#===============================================
move $t0, $zero # re-use it to walk throuhg array
la $a0, clean_input
subiu $a0, $a0, 1 
Loop:
beq $t0, $t3, calculate_shift_value
addiu $a0, $a0, 1
addiu $t0, $t0, 1
lb $t1, 0($a0)
bge $t1, 'a', Loop # if a lowercase letter skip
beq $t1, ' ', Loop
beq $t1, 13, Loop
beq $t1, 10, Loop
addiu $t1, $t1, 32 # if uppercase convert
sb $t1, 0($a0)
j Loop
#########################
calculate_shift_value:
#########################
la $a0, clean_input
la $a1, shift_value # length of words
move $t0, $zero # index of clean input array
move $t3, $zero # compute length of each word
move $t4, $zero # index of shift value array
la $a0, clean_input
calculate:
beq $t0, $t2, print_shift_value #walked through all words
lb $t1, 0($a0)
addiu $a0, $a0, 1
addiu $t0, $t0, 1
beq $t1, ' ', NewWord
beq $t1, 10, NewWord
beq $t1, 13, calculate
addiu $t3, $t3, 1
j calculate
NewWord:
sw $t3, 0($a1)#store word length
addiu $a1, $a1, 4 #word 4 bytes
addiu $t4, $t4, 1 #count num of words
move $t3, $zero #nextword
j calculate
print_shift_value: #lastword
sw $t3, 0($a1)#save the length of words
addiu $t4, $t4, 1 #added new bar to arrray
la $a0, shift_value #address of array in a0
move $t8, $t2
move $a1, $t4 #num of bars in array in a1
jal Sortion
la $a0, message4 #shiftValue
li $v0, 4	
syscall
la $a1, shift_value
lw $a0, 0($a1)
li $v0, 1 #write integer
syscall
move $t6, $a0
move $t0, $zero
la $a0, clean_input
la $a1, output_to_file
Add_shift_value_to_text:
beq $t0, $t8, read_output_file_name
lb $t1, 0($a0)
beq $t1, ' ', Store_ouput
beq $t1, 13, Store_ouput
beq $t1, 10, Store_ouput
add $t1, $t1, $t6
ble $t1, 'z', Store_ouput 
subiu $t1, $t1, 26 # z-26 = a
Store_ouput:
sb $t1, 0($a1)
addiu $a0, $a0, 1
addiu $a1, $a1, 1
addiu $t0, $t0, 1
j Add_shift_value_to_text
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
read_output_file_name:
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
la $a0, message3
li $v0, 4	
syscall 
la $a0, FileName
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
continue2:
lb $t0, FileName($t2)
beq $t0, 10, replac_out
addiu $t2, $t2, 1
j continue2
replac_out:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 1 #write
syscall 
move $a0, $v0 # move descriptor
la $a1, output_to_file
move $a2, $t8 #length
li $v0, 15
syscall 
move $t0, $v0
li $v0, 16 #close file
syscall
j End_program
###########################################################
decryption_text:
la $a0, message3
li $v0, 4	
syscall 
la $a0, FileName #read file
li $a1, 40
li $v0, 8
syscall 
move $t2, $zero
continue_In_dec:
lb $t0, FileName($t2)
beq $t0, 10, replace_In_dec
addiu $t2, $t2, 1
j continue_In_dec
replace_In_dec:
sb $zero, FileName($t2)
la $a0, FileName
li $v0, 13
li $a1, 0 #read
syscall 
bge $v0, 0, exist1
la $a0, message7 #error opening
li $v0, 4
syscall
j decryption_text #repeat
exist1:
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
lb $t1, 0($a0) #load char
addiu $a0, $a0, 1
addiu $t0, $t0, 1
beq $t1, ' ', NewWord_dec
beq $t1, 10, NewWord_dec
beq $t1, 13, calculate_dec
addiu $t2, $t2, 1
j calculate_dec
NewWord_dec:
sw $t2, 0($a1)
addiu $a1, $a1, 4
addiu $t4, $t4, 1 
move $t2, $zero
j calculate_dec
print_shift_value_dec:
sw $t2, 0($a1)
addiu $t4, $t4, 1
la $a0, shift_value
move $a1, $t4
jal Sortion
la $a0, message4 #shiftvalue
li $v0, 4	
syscall
la $a1, shift_value
lw $a0, 0($a1)
li $v0, 1 #print int
syscall
move $t6, $a0
move $t0, $zero
la $a0, clean_input
la $a1, output_to_file
Sub_shift_value_to_text:
beq $t0, $t8, read_output_file_name_dec
lb $t1, 0($a0)
beq $t1, ' ', Store_ouput_dec
beq $t1, 10, Store_ouput_dec
beq $t1, 13, Store_ouput_dec
sub $t1, $t1, $t6 #subtract shift value
bge $t1, 'a', Store_ouput_dec
addiu $t1, $t1, 26 
Store_ouput_dec:
sb $t1, 0($a1)
addiu $a0, $a0, 1 #next letter
addiu $a1, $a1, 1 #next bar
addiu $t0, $t0, 1 #length of array
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
continue_out_dec:
lb $t0, FileName($t2)
beq $t0, 10, replac_out_dec
addiu $t2, $t2, 1
j continue_out_dec
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
# $a0 = &A, $a1 = n
Sortion:
start: subiu $a1, $a1, 1 
blez $a1, L2 
move $t0, $a0 
li $t1, 0  #flag
li $t2, 0 #index
swap: lw $t3, 0($t0) # $t3 = A[i]
lw $t4, 4($t0) # $t4 = A[i+1]
bge $t3, $t4, L1  #dont swap and move to L1
sw $t4, 0($t0) #swap
sw $t3, 4($t0) 
li $t1, 1 #flag
L1: addiu $t2, $t2, 1 # i++
addiu $t0, $t0, 4 
bne $t2, $a1, swap 
bnez $t1, start # branch if (swapped)
L2: jr $ra