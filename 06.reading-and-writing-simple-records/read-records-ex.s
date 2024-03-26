    .include "linux.s"
    .include "record-def.s"

    .data
usage_msg:
    .ascii "Usage: ./read-records-ex.s <data-file>\n"
    usage_msg_len = . - usage_msg
file_not_found_msg:
    .ascii "File not found: "
    file_not_found_msg_len = . - file_not_found_msg
newline:
    .ascii "\n\0"
empty:
    .ascii "\0"


    .section .bss
    .lcomm record_buffer, RECORD_SIZE
    .lcomm num_buffer, 12


    .section .text
    .globl _start

    .equ ST_ARGC, 0
    .equ ST_ARGV_1, 8
    .equ ST_INPUT_DESCRIPTOR, -4
    .equ ST_OUTPUT_DESCRIPTOR, -8
_start:
    movl  %esp, %ebp
    subl  $8, %esp

    # Check the number of arguments.
    cmpl  $2, ST_ARGC(%ebp)
    jl    exit_number_of_args

    # Open the input file.
    movl  $SYS_OPEN, %eax
    movl  ST_ARGV_1(%ebp), %ebx
    movl  $0, %ecx
    movl  $0, %edx
    int   $LINUX_SYSCALL

    cmpl  $-1, %eax
    je    exit_file_not_found

    movl  %eax, ST_INPUT_DESCRIPTOR(%ebp)
    movl  $STDOUT, ST_OUTPUT_DESCRIPTOR(%ebp)

record_read_loop:
    # Read record.
    pushl ST_INPUT_DESCRIPTOR(%ebp)
    pushl $record_buffer
    call  read_record
    addl  $8, %esp

    cmpl  $RECORD_SIZE, %eax
    jne   exit

    # Output record.

    pushl $record_buffer + RECORD_FIRSTNAME
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    call  write_string
    addl  $8, %esp

    pushl $record_buffer + RECORD_LASTNAME
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    call  write_string
    addl  $8, %esp

    pushl $record_buffer + RECORD_ADDRESS
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    call  write_string
    addl  $8, %esp

    pushl $num_buffer
    pushl record_buffer + RECORD_AGE
    call  long_to_string
    addl  $8, %esp

    pushl $num_buffer
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    call  write_string
    addl  $8, %esp

    pushl $empty
    pushl ST_OUTPUT_DESCRIPTOR(%ebp)
    call  write_string
    addl  $8, %esp

    jmp   record_read_loop

exit:
    movl  $SYS_EXIT, %eax
    xorl  %ebx, %ebx
    int   $LINUX_SYSCALL

exit_number_of_args:
    # Output usage message.
    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  $usage_msg, %ecx
    movl  $usage_msg_len, %edx
    int   $LINUX_SYSCALL

    jmp   exit_error

exit_file_not_found:
    # Output file not found message.
    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  $file_not_found_msg, %ecx
    movl  $file_not_found_msg_len, %edx
    int   $LINUX_SYSCALL

    movl  ST_ARGV_1(%ebp), %eax
    pushl %eax
    call  count_chars
    addl  $4, %esp

    movl  %eax, %edx
    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  ST_ARGV_1(%ebp), %ecx
    int   $LINUX_SYSCALL

    movl  $SYS_WRITE, %eax
    movl  $STDERR, %ebx
    movl  $newline, %ecx
    movl  $1, %edx
    int   $LINUX_SYSCALL

exit_error:
    # Exit with error code.
    movl  $SYS_EXIT, %eax
    movl  $1, %ebx
    int   $LINUX_SYSCALL


# Output the given null-terminated string.
#
# Arguments:
# - a file descriptor
# - a string to output
#
# Return value:
# - nothing
#
    .type write_string, @function

    .equ ST_FILE_DESCRIPTOR, 8
    .equ ST_STRING, 12
write_string:
    pushl %ebp
    movl  %esp, %ebp

    movl  ST_STRING(%ebp), %eax
    pushl %eax
    call  count_chars
    addl  $4, %esp

    movl  %eax, %edx
    movl  $SYS_WRITE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl  ST_STRING(%ebp), %ecx
    int   $LINUX_SYSCALL

    movl  $SYS_WRITE, %eax
    movl  ST_FILE_DESCRIPTOR(%ebp), %ebx
    movl  $newline, %ecx
    movl  $1, %edx
    int   $LINUX_SYSCALL

    popl  %ebp
    ret
