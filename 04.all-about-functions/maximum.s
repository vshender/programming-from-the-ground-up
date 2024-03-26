# Exercise
#
# PURPOSE: This program finds the maximum number of a set of data
# items.

    .section .data
data_items:
    .long 3, 67, 34, 222, 45, 75, 54, 34, 44, 33, 22, 11, 66
    data_len = (. - data_items) / 4

    .section .text
    .globl _start
_start:
    pushl $data_len
    pushl $data_items
    call  maximum
    addl  $8, %esp

    movl  %eax, %ebx
    movl  $1, %eax
    int   $0x80


# Find the maximum number of a set of data items.
#
# Arguments:
#   first argument --- the address of data items;
#   second argument --- length of data.
#
# Used registers:
#   %eax --- largest data item found
#   %ebx --- current data item
#   %ecx --- index of the data item being examined
#   %esi --- address of data

    .type maximum, @function
maximum:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %esi
    movl  (%esi), %eax

    movl  $0, %ecx
loop:
    incl  %ecx

    cmpl  %ecx, 12(%ebp)
    je    loop_exit

    movl  (%esi, %ecx, 4), %ebx
    cmpl  %ebx, %eax
    jge   loop

    movl  %ebx, %eax
    jmp   loop

loop_exit:
    movl  %ebp, %esp
    popl  %ebp
    ret
