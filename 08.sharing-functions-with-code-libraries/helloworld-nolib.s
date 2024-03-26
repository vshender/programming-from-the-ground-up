# PURPOSE: This program writes the message "hello world" and exist.
#

    .include "linux.s"

    .section .data
helloworld:
    .ascii "hello world\n"
helloworld_end:
    .equ helloworld_len, helloworld_end - helloworld

    .section .text
    .globl _start
_start:
    movl  $SYS_WRITE, %eax
    movl  $STDOUT, %ebx
    movl  $helloworld, %ecx
    movl  $helloworld_len, %edx
    int   $LINUX_SYSCALL

    movl  $SYS_EXIT, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL
