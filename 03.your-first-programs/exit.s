# PURPOSE: Simple program that exits and returns a status code back
# to the Linux kernel.
#
# INPUT: none
#
# OUTPUT: Returns a status code.  This can be viewed by typing
#   echo $?
# after running the program.
#
# VARIABLES:
#
# - %eax holds the system call number
# - %ebx holds the return value
#

    .section .data

    .section .text
    .globl _start
_start:
    # This is the linux kernel command number (system call) for
    # exiting a program.
    movl  $1, %eax

    # This is the status number we will return to the operating
    # system.  Change this around and it will return different things
    # to echo $?.
    movl  $0, %ebx

    # This wakes up the kernel to run the exit command.
    int   $0x80
