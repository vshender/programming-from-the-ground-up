    .include "linux.s"
    .include "record-def.s"

    .section .data

    # Constant data of the records we want to write.  Each text data
    # item is padded to the proper length with null (i.e. 0) bytes.
    #
    # .rept is used to pad each item.  .rept tells the assembler to
    # repeat the section between .rept and .endr the number of times
    # specified.  This is used in this program to add extra null
    # characters at the end of each field to fill it up.
record1:
    .ascii "Fredrick\0"
    .rept 31     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "Bartlett0"
    .rept 31     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "4242 S Prairie\nTulsa, OK 55555\0"
    .rept 209    # padding to 240 bytes
    .byte 0
    .endr

    .long 45

record2:
    .ascii "Marilyn\0"
    .rept 32     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "Taylor\0"
    .rept 33     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "2224 S Johannan St\nChicago, IL 12345\0"
    .rept 203    # padding to 240 bytes
    .byte 0
    .endr

    .long 29

record3:
    .ascii "Derrick\0"
    .rept 32     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "McIntire\0"
    .rept 31     # padding to 40 bytes
    .byte 0
    .endr

    .ascii "500 W Oakland\nSan Diego, SA 54321\0"
    .rept 206    # padding to 240 bytes
    .byte 0
    .endr

    .long 36

    # This is the name of the file we will write to.
file_name:
    .ascii "test.dat\0"


    .section .text

    .equ ST_FILE_DESCRIPTOR, -4

    .globl _start
_start:
    movl  %esp, %ebp               # copy the stack pointer to %ebp
    subl  $4, %esp                 # allocate space to hold the file descriptor

    # Open the file.
    movl  $SYS_OPEN, %eax
    movl  $file_name, %ebx
    movl  $0101, %ecx  # this says to create if it doesn't exist, and open for writing
    movl  $0666, %edx
    int   $LINUX_SYSCALL

    # Store the file descriptor away.
    movl  %eax, ST_FILE_DESCRIPTOR(%ebp)

    # Write the first record.
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record1
    call  write_record
    addl  $8, %esp

    # Write the second record.
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record2
    call  write_record
    addl  $8, %esp

    # Write the third record.
    pushl ST_FILE_DESCRIPTOR(%ebp)
    pushl $record3
    call  write_record
    addl  $8, %esp

    # Close the file descriptor.
    movl  $SYS_CLOSE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    int   $LINUX_SYSCALL

    # Exit the program.
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
