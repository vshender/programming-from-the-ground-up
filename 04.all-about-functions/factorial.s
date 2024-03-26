# PURPOSE: Given a number, this program computes the factorial.  For
# example, the factorial of 3 is 3*2*1, or 6.  The factorial of 4 is
# 4 * 3 * 2 * 1, or 24, and so on.
#
# This program shows how to call a function recursively.
#

    .section .data
    # This program has no global data

    .section .text

    .globl _start
    .globl factorial  # this is unneeded unless we want to share this
                      # function among other programs
_start:
    # The factorial takes one argument -- the number we want a factorial of.
    # So, it gets pushed.
    pushl $4
    call  factorial                     # run the factorial function
    addl  $4, %esp                      # scrub the parameter that was pushed on the stack

    # factorial returns the answer in %eax, but we want it in %ebx to
    # send it as our exit status.
    movl  %eax, %ebx
    movl  $1, %eax                      # call the kernel's exit function
    int   $0x80


    # This is the actual function definition
    .type factorial, @function
factorial:
    # Standard function stuff -- we have to restore %ebp to its prior
    # state before returning, so we have to push it.
    pushl %ebp
    # This is because we don't want to modify the stack pointer, so we
    # use %ebp.
    movl  %esp, %ebp

    # This moves the first argument to %eax. (%ebp) holds prior state
    # of %ebp, 4(%ebp) holds return address, and 8(%ebp) holds first
    # parameter.
    movl  8(%ebp), %eax
    # If the number is 1, that is our base case, and we simply return
    # (1 is already in %eax as the return value).
    cmp   $1, %eax
    je    end_factorial

    decl  %eax                          # otherwise, decrease the value
    pushl %eax                          # push it for our call to factorial
    call  factorial                     # call factorial
    # %eax has the return value, so we reload our parameter into %ebx.
    movl  8(%ebp), %ebx
    # Multiply that by the result of the last call to factorial (in
    # %eax).  The answer is stored in %eax, which is good since that's
    # where return values go.
    imull %ebx, %eax

end_factorial:
    # Standard function return stuff -- we have to restore %ebp and
    # %esp to where they were before the function started.
    movl  %ebp, %esp
    popl  %ebp

    # Return to the function (this pops the return value, too).
    ret
