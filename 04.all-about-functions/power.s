# PURPOSE: Program to illustrate how functions work
#
# This program will compute the value of 2^3 + 5^2
#

# Everything in the main program is stored in registers, so the data
# section doesn't have anything.
    .section .data

    .section .text

    .global _start
_start:
    pushl $3                            # push second argument
    pushl $2                            # push first argument
    call  power                         # call the function
    addl  $8, %esp                      # move the stack pointer back

    # Save the first answer before making the next call.
    pushl  %eax

    pushl $2                            # push second argument
    pushl $5                            # push first argument
    call  power                         # call the function
    addl  $8, %esp                      # move the stack pointer back

    # The second answer is already in %eax.  We saved the first answer
    # onto the stack, so now we can just pop it out into %ebx.
    popl  %ebx

    addl  %eax, %ebx                    # add them together

    movl  $1, %eax                      # exit (%ebx is returned)
    int $0x80


# PURPOSE: This function is used to compute the value of a number
# raised to a power.
#
# INPUT:
#
# - first argument -- the base number
# - second argument -- the power to raise it to
#
# OUTPUT: Will give the result as a return value.
#
# NOTES: The power must be 0 or greater.
#
# VARIABLES:
#
# - %ebx -- holds the base number
# - %ecx -- holds the power
# - -4(%ebp) -- holds the current result
# - %eax is used for temporary storage
#

    .type power, @function
power:
    pushl %ebp                          # save old base pointer
    movl  %esp, %ebp                    # make stack pointer the base pointer
    subl  $4, %esp                      # get room for our local storage
    # Although we could use a register for temporary storage, this
    # program uses a local variable in order to show how to set it
    # up.

    movl  8(%ebp), %ebx                 # put first argument in %ebx
    movl  12(%ebp), %ecx                # put second argument in %ecx

    movl  $1, -4(%ebp)                  # store current result

power_loop_start:
    cmpl  $0, %ecx                      # if the power is 0, we are done
    je    end_power

    movl  -4(%ebp), %eax                # move the current result into %eax
    imull %ebx, %eax                    # multiply the current result by the base number
    movl  %eax, -4(%ebp)                # store the current result

    decl  %ecx                          # decrease the power
    jmp   power_loop_start              # run for the next power

end_power:
    movl  -4(%ebp), %eax                # return value goes in %eax
    movl  %ebp, %esp                    # restore the stack pointer
    popl  %ebp                          # restore the base pointer
    ret
