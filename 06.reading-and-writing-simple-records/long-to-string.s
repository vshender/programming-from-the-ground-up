    .globl long_to_string

# Convert the given positive long number to a string representation.
#
# Arguments:
# - a long number to convert;
# - a string buffer to use as a destination for the string
#   representation.
#
# Return value:
# - the length of the string representation.
#
    .type long_to_string, @function

    .equ ST_LONG, 8
    .equ ST_BUF, 12
long_to_string:
    pushl %ebp
    movl  %esp, %ebp

    movl  ST_LONG(%ebp), %eax
    movl  ST_BUF(%ebp), %edi

    xorl  %ecx, %ecx
convert_loop:
    # Find the next digit.
    movl  $10, %ebx
    xorl  %edx, %edx
    divl  %ebx

    # Convert the digit to char.
    pushl %eax

    pushl %edx
    call  digit_to_char
    addl  $4, %esp

    movb  %al, (%edi)
    popl  %eax

    incl  %ecx
    incl  %edi

    # Exit, if the quotient is zero.
    cmpl  $0, %eax
    jne   convert_loop

    # Terminating null character.
    movb  $0, (%edi)

    # Reverse the string representation.
    pushl %ecx
    pushl ST_BUF(%ebp)
    call  reverse_string
    addl  $4, %esp

    # The string representation length (including the terminating null
    # character).
    popl  %eax
    incl  %eax

    movl  %ebp, %esp
    popl  %ebp
    ret


# Convert the given digit to the character representation.
#
# Arguments:
# - a digit to convert (a long value).
#
# Return value:
# - character representation of the given digit.
#
    .type digit_to_char, @function

    .equ ST_DIGIT, 8
digit_to_char:
    pushl %ebp
    movl  %esp, %ebp

    movl  ST_DIGIT(%ebp), %eax
    addl  $'0', %eax

    popl  %ebp
    ret


# Reverse the given string.
#
# Arguments:
# - a string to reverse;
# - the length of the string.
#
# Return value:
# - nothing.
#
    .type reverse_string, @function

    .equ ST_STRING, 8
    .equ ST_LENGTH, 12
reverse_string:
    pushl %ebp
    movl  %esp, %ebp

    movl  ST_LENGTH(%ebp), %ecx
    movl  ST_STRING(%ebp), %esi

    leal  -1(%esi, %ecx, 1), %edi       # end of the string

    shrl  $1, %ecx
reverse_loop:
    cmpl  $0, %ecx
    je    reverse_loop_end

    movb  (%esi), %al
    xchgb %al, (%edi)
    movb  %al, (%esi)

    incl  %esi
    decl  %edi
    decl  %ecx

    jmp   reverse_loop

reverse_loop_end:
    popl  %ebp
    ret
