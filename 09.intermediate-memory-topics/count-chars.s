# PURPOSE: Count the characters until a null byte is reached.
#
# INPUT: The address of the character string.
#
# OUTPUT: Returns the count in %eax.
#
# Registers used:
#
# - %ecx -- character count
# - %al -- current character
# - %edx -- current character address
#

    .section .text

    .globl count_chars
    .type count_chars, @function

    # This is where our one parameter is on the stack.
    .equ ST_STRING_START_ADDRESS, 8
count_chars:
    pushl %ebp
    movl  %esp, %ebp

    movl  $0, %ecx                             # counter starts at zero
    movl  ST_STRING_START_ADDRESS(%ebp), %edx  # starting address of data

count_loop_begin:
    movb  (%edx), %al                   # grab the current character
    cmpb  $0, %al                       # is it null?
    je    count_loop_end                # if yes, we're done

    # Otherwise, increment the counter and the pointer.
    incl  %ecx
    incl  %edx
    # Go back to the beginning of the loop.
    jmp   count_loop_begin

count_loop_end:
    # We're done.  Move the count into %eax and return.
    movl  %ecx, %eax

    popl %ebp
    ret
