# PURPOSE: This program converts an input file to an output file with
# all letters converted to uppercase.
#
# PROCESSING:
#
# 1. Open the input file
# 2. Open the output file
# 3. While we're not at the end of the input file
#    a) read part of file into our memory buffer
#    b) go through each byte of memory
#         if the byte is a lower-case letter,
#         convert it to uppercase
#    c) write the memory buffer to output file

    .section .data

    ## Constants

    # System call numbers
    .equ SYS_OPEN, 5
    .equ SYS_CLOSE, 6
    .equ SYS_READ, 3
    .equ SYS_WRITE, 4
    .equ SYS_EXIT, 1

    # Options for open (look at /usr/include/asm/fcntl.h for various
    # values; you can combine them by adding them or ORing them).
    .equ O_RDONLY, 0
    .equ O_CREAT_WRONLY_TRUNC, 03101

    # Standard file descriptors
    .equ STDIN, 0
    .equ STDOUT, 1
    .equ STDERR, 2

    # System call interrupt.
    .equ LINUX_SYSCALL, 0x80

    # This is the return value of read which means we've hit the end
    # of the file.
    .equ END_OF_FILE, 0


    .section .bss

    # Buffer -- this is where the data is loaded into from the input
    # file and written from into the output file.  This should never
    # exceed 16'000 for various reasons.
    .equ BUFFER_SIZE, 500
    .lcomm BUFFER_DATA, BUFFER_SIZE


    .section .text

    # Stack positions.
    .equ ST_SIZE_RESERVE, 8
    .equ ST_FD_IN, -4
    .equ ST_FD_OUT, -8
    .equ ST_ARGS, 0     # number of arguments
    .equ ST_ARGV_0, 4   # name of program
    .equ ST_ARGV_1, 8   # input file name
    .equ ST_ARGV_2, 12  # output file name

    .globl _start
_start:
    ## Initialize program

    movl  %esp, %ebp                    # save the stack pointer

    # Allocate space for our file descriptors on the stack.
    subl  $ST_SIZE_RESERVE, %esp

open_files:
    # Open input file.
open_fd_in:
    movl  $SYS_OPEN, %eax               # open syscall
    movl  ST_ARGV_1(%ebp), %ebx         # input filename
    movl  $O_RDONLY, %ecx               # read-only flag
    movl  $0666, %edx                   # this doesn't really matter for reading
    int   $LINUX_SYSCALL                # call Linux

store_fd_in:
    movl  %eax, ST_FD_IN(%ebp)          # save the given file descriptor

    # Open output file.
open_fd_out:
    movl  $SYS_OPEN, %eax               # open syscall
    movl  ST_ARGV_2(%ebp), %ebx         # output filename
    movl  $O_CREAT_WRONLY_TRUNC, %ecx   # flags for writing to the file
    movl  $0666, %edx                   # permissions for new file (if it's created)
    int   $LINUX_SYSCALL                # call Linux

store_fd_out:
    movl  %eax, ST_FD_OUT(%ebp)         # store the file descriptor

    # Begin main loop
read_loop_begin:

    # Read in a block from the input file.
    movl  $SYS_READ, %eax               # read syscall
    movl  ST_FD_IN(%ebp), %ebx          # the input file descriptor
    movl  $BUFFER_DATA, %ecx            # the location to read into
    movl  $BUFFER_SIZE, %edx            # the size of the buffer
    int   $LINUX_SYSCALL                # length of data read is returned in %eax

    # Exit if we've reached the end.
    cmpl  $END_OF_FILE, %eax            # check for end of file marker
    jle   end_loop                      # if found or on error, go to the end

continue_read_loop:
    # Convert the block to upper case.
    pushl %eax                          # length of data
    pushl $BUFFER_DATA                  # location of buffer
    call  convert_to_upper
    addl  $4, %esp
    popl  %eax                          # get the length back

    # Write the block out to the output file
    movl  %eax, %edx                    # length of data
    movl  $SYS_WRITE, %eax              # write syscall
    movl  ST_FD_OUT(%ebp), %ebx         # file to use
    movl  $BUFFER_DATA, %ecx            # location of the buffer
    int   $LINUX_SYSCALL

    # Continue the loop.
    jmp   read_loop_begin

end_loop:
    # Close the files.
    # None: we don't need to do error checking on these, because error
    # conditions don't signify anything special here.
    movl  $SYS_CLOSE, %eax
    movl  ST_FD_OUT(%ebp), %ebx
    int   $LINUX_SYSCALL

    movl  $SYS_CLOSE, %eax
    movl  ST_FD_IN(%ebp), %ebx
    int   $LINUX_SYSCALL

    # Exit.
    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL


# PURPOSE: This function actually does the conversion to upper case
# for a block.
#
# INPUT:
#
# - The first parameter is the location of the block of memory to
#   convert.
# - The second parameter is the length of that buffer.
#
# OUTPUT: This function overwrites the current buffer with the
# upper-casified version.
#
# VARIABLES:
#
# - %eax -- beginning of buffer
# - %ebx -- length of buffer
# - %edi -- current buffer offset
# - %cl -- current byte being examined (first part of %ecx)
#

    # Constants.
    .equ LOWERCASE_A, 'a'               # the lower boundary of our search
    .equ LOWERCASE_Z, 'z'               # the upper boundary of our search
    .equ UPPER_CONVERSION, 'A' - 'a'    # conversion between upper and lower case

    # Stack stuff.
    .equ ST_BUFFER, 8                   # actual buffer
    .equ ST_BUFFER_LEN, 12              # length of buffer

convert_to_upper:
    pushl %ebp
    movl  %esp, %ebp

    # Set up variables.
    movl  ST_BUFFER(%ebp), %eax
    movl  ST_BUFFER_LEN(%ebp), %ebx
    movl  $0, %edi

    # If a buffer with zero length was given to us, just leave.
    cmpl  $0, %ebx
    je    end_convert_loop

convert_loop:
    movb  (%eax, %edi, 1), %cl          # get the current byte

    # Go to the next byte unless it is between 'a' and 'z'.
    cmpb  $LOWERCASE_A, %cl
    jl    next_byte
    cmpb  $LOWERCASE_Z, %cl
    jg    next_byte

    # Otherwise convert the byte to uppercase ...
    addb  $UPPER_CONVERSION, %cl
    # ... and store it back.
    movb  %cl, (%eax, %edi, 1)

next_byte:
    incl  %edi                          # next byte
    cmpl  %edi, %ebx                    # continue unless we've reached the end
    jne   convert_loop

end_convert_loop:
    # No return value, just leave.
    movl  %ebp, %esp
    popl  %ebp
    ret
