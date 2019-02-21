# GPC_vhdl_assembler

To compile the c++ code use c++11, with codeblocks or DevC++ making this [change](https://stackoverflow.com/questions/16951376/how-to-change-mode-from-c98-mode-in-dev-c-to-a-mode-that-supports-c0x-ran)

To execute the file use the console, go to the directory that contains the .exe and write "executable.exe name_of_program_file", the program must be in the format on scheme.txt.

 - The .data section has variables names and optional initialization.
 - The .reference section has positions on the program between zero and n, where n is the position of the halt instruction in the program.
 - The .code section has program instructions, that will be executed sequential, each instruction can use zero or one operand, the jump instructions use an operand in the .reference section, the other instructions use an operand in the .data section.
