# MIPS-ASSEMBLY-PROJECT
# Caesar Cipher Encryption/Decryption Program

This program is a simple encryption/decryption algorithm based on the Caesar cipher algorithm for English-based text messages. It is written in MIPS assembly language and designed to read and write to text files.

## Usage
* Upon running the program, the user is presented with a menu asking them to choose between encryption (E) or decryption (D). The user will then be prompted to input the name of the plain text file for encryption or the cipher text file for decryption.

* The program will then read the contents of the specified file, remove any non-alphabetic characters, and convert all characters to lowercase. After that, the program will encrypt or decrypt the text based on the user's choice and shift value.

* The user can also set a shift value between 1 and 100. The shift value determines the number of positions each letter of the alphabet is shifted during encryption/decryption.

* Finally, the program will write the output to a new file specified by the user.

## Authors
 Rama Abdlrahman and Nour Malaki 

## Error Handling
The program includes error messages for invalid input and for when the specified file does not exist.

## Note
The program can be modified to include more encryption/decryption algorithms or support for different languages.

