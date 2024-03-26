# PURPOSE: Program to manage memory usage -- allocates and deallocates memory
# as requested.
#
# NOTES: The program using these routines will ask for a certain size of
# memory.  We actually use more than that size, but we put it at the beginning,
# before the pointer we hand back.  We add a size field and an AVAILABLE/
# UNAVAILABLE marker.  So, the memory looks like this:
#
# ##############################################################
# # Available marker # Size of memory # Actual memory location #
# ##############################################################
#                                      ^-- Returned pointer points here
#
# The pointer we return only points to the actual location requested to make it
# easier for the calling program.  It also allows us to change our structure
# without the calling program having to change at all.
#

    .section .data

# Global variables

    # This points to the beginning of the memory we are managing.
heap_begin:
    .long 0

    # This points to one location past the memory we are managing.
current_break:
    .long 0

# Structure information

    # Size of space for memory region header.
    .equ HEADER_SIZE, 8
    # Location of the "available" flag in the header.
    .equ HDR_AVAIL_OFFSET, 0
    # Location of the size field in the header.
    .equ HDR_SIZE_OFFSET, 4

# Constants

    # This is the number we will use to mark space that has been given out.
    .equ UNAVAILABLE, 0
    # This is the number we will use to mark space that has been returned, and
    # is available for giving
    .equ AVAILABLE, 1
    # System call number for the break system call.
    .equ SYS_BRK, 45
    # Make system calls easier to read.
    .equ LINUX_SYSCALL, 0x80


    .section .text

# Functions

    # allocate_init
    #
    # PURPOSE: call this function to initialize the functions (specifically,
    # this sets heap_begin and current_break).  This has no parameters and no
    # return value.
    #

    .globl allocate_init
    .type allocate_init, @function

allocate_init:
    # Standard function stuff.
    pushl %ebp
    movl  %esp, %ebp

    # If the brk system call is called with 0 in %ebx, it returns the last
    # valid usable address.
    movl  $SYS_BRK, %eax
    movl  $0, %ebx
    int   $LINUX_SYSCALL

    # %eax now has the last valid address, and we want the memory location
    # after that.
    incl  %eax

    # Store the current break.
    movl  %eax, current_break

    # Store the current break as our first address.  This will cause the
    # allocate function to get more memory from Linux the first time it is run.
    movl  %eax, heap_begin

    # Exit the function.
    movl  %ebp, %esp
    popl  %ebp
    ret


    # allocate
    #
    # PURPOSE: This function is used to grab a section of memory.  It checks to
    # see if there are any free blocks, and, if not, it asks Linux for a new
    # one.
    #
    # PARAMETERS: This function has one parameter -- the size of the memory
    # block we want to allocate.
    #
    # RETURN VALUE: This function returns the address of the allocated memory
    # in %eax.  If there is no memory available, it will return 0 in %eax.
    #
    # PROCESSING:
    #
    # Variables used:
    #
    # - %ecx -- hold the size of the requested memory (first/only parameter);
    # - %eax -- current memory region being examined;
    # - %ebx -- current break position;
    # - %edx -- size of current memory region.
    #
    # We scan through each memory region starting with heap_begin.  We look at
    # the size of each one, and if it has been allocated.  If it's big enough
    # for the requested size, and its available, it grabs that one.  If it does
    # not find a region large enough, it asks Linux for more memory.  In that
    # case, it moves current_break up.
    #

    .globl allocate
    .type allocate, @function

    .equ ST_MEM_SIZE, 8         # stack position of the memory size to allocate

allocate:
    # Standard function stuff.
    pushl %ebp
    movl  %esp, %ebp

    # %ecx will hold the size we are looking for (which is the first and only
    # parameter).
    movl  ST_MEM_SIZE(%ebp), %ecx

    # %eax will hold the current search location.
    movl  heap_begin, %eax

    # %ebx will hold the current break.
    movl  current_break, %ebx

alloc_loop_begin:
    # Here we iterate through each memory region.
    cmpl  %ebx, %eax                    # need more memory if these are equal
    je    move_break

    movl  HDR_SIZE_OFFSET(%eax), %edx           # grab the size of this memory
    cmpl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)  # if the space is unavailable,
    je    next_location                         # go to the next one

    # If the space is available, compare the size to the needed size.
    cmpl  %edx, %ecx
    # If its big enough, go to allocate_here.
    jle   allocate_here

next_location:
    # The total size of the memory region is the sum of the size requested
    # (currently stored in %edx), plus another 8 bytes for the header (4 for
    # AVAILABLE/UNAVAILABLE flag, and 4 for the size of the region).  So,
    # adding %edx and $8 to %eax will get the address of the next memory
    # region.
    addl  $HEADER_SIZE, %eax
    addl  %edx, %eax
    jmp   alloc_loop_begin              # go look at the next location

allocate_here:
    # If we've made it here, that means that the region header of the region to
    # allocate is in %eax.

    # Mark space as unavailable.
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    # Move %eax past the header to the usable memory (since that's what we
    # return).
    addl  $HEADER_SIZE, %eax

    # Return from the function.
    movl  %ebp, %esp
    popl  %ebp
    ret

move_break:
    # If we've made it here, that means that we have exhausted all addressable
    # memory, and we need to ask for more.  %ebx holds the current endpoint of
    # the data, and %ecx holds its size.

    # We need to increase %ebx to where we _want_ memory to end, so we ...
    addl  $HEADER_SIZE, %ebx            # add space for the headers structure
    addl  %ecx, %ebx                    # add space for the data requested

    # Now it's time to ask Linux for more memory.

    # Save needed registers.
    pushl %eax
    pushl %ecx
    pushl %ebx

    # Reset the break (%ebx has the requested break point).
    movl  $SYS_BRK, %eax
    int   $LINUX_SYSCALL

    # Under the normal condition, this should return the new break in %eax,
    # which will be either 0 if it fails, or it will be equal to or larger than
    # we asked for.  We don't care in this program where it actually sets the
    # break, so as long as %eax isn't 0, we don't care what it is.

    # Check for error conditions.
    cmpl  $0, %eax
    je error

    # Restore saved registers.
    popl  %ebx
    popl  %ecx
    popl  %eax

    # Set this memory as unavailable, since we're about to give it away.
    movl  $UNAVAILABLE, HDR_AVAIL_OFFSET(%eax)
    # Set the size of the memory.
    movl  %ecx, HDR_SIZE_OFFSET(%eax)

    # Move %eax to the actual start of usable memory.
    addl  $HEADER_SIZE, %eax
    # %eax now holds the return value.

    # Save the new break.
    movl  %ebx, current_break

    # Return the function.
    movl  %ebp, %esp
    popl  %ebp
    ret

error:
    movl  $0, %eax                      # on error, we return zero

    movl  %ebp, %esp
    popl  %ebp
    ret


    # deallocate
    #
    # PURPOSE: The purpose of this function is to give back a region of memory
    # to the pool after we're done using it.
    #
    # PARAMETERS: The only parameter is the address of the memory we want to
    # return to the memory pool.
    #
    # RETURN VALUE: There is no return value.
    #
    # PROCESSING:
    # If you remember, we actually hand the program the start of the memory
    # that they can use, which is 8 storage locations after the actual start of
    # the memory region.  All we have to do is go back 8 locations and mark
    # that memory as available, so that the allocate function knows it can use
    # it.
    #

    .globl deallocate
    .type deallocate, @function

    .equ ST_MEMORY_SEG, 4         # stack position of the memory region to free

deallocate:
    # Since the function is so simple, we don't need any of the fancy function
    # stuff.

    # Get the address of the memory to free (normally this is 8(%ebp), but
    # since we didn't push %ebp or move %esp to %ebp, we can just do 4(%esp).
    movl  ST_MEMORY_SEG(%esp), %eax

    # Get the pointer to the real beginning of the memory.
    subl  $HEADER_SIZE, %eax

    # Mark it as available.
    movl  $AVAILABLE, HDR_AVAIL_OFFSET(%eax)

    # Return.
    ret
