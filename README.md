# programming-from-the-ground-up

Programming examples from the book ["Programming from the Ground Up"](https://savannah.nongnu.org/projects/pgubook/) by Josh Bartlett.

## 3. Your First Programs

- [exit.s](03.your-first-programs/exit.s) -- a simple assembly program that just exits and returns a status code back to the Linux kernel.
- [maximum.s](03.your-first-programs/maximum.s) -- a program that finds the maximum number of a set of numbers.


## 4. All About Functions

- [power.s](04.all-about-functions/power.s) -- a program that illustrates how functions work by solving $2^3 + 5^2$.
- [factorial.s](04.all-about-functions/factorial.s) -- a program that calculates factorial using a recursive function.


## 5. Dealing with Files

- [toupper.s](05.dealing-with-files/toupper.s) -- a program that converts an input file to an output file with all letters converted to uppercase.


## 6. Reading and Writing Simple Records

- [record-def.s](06.reading-and-writing-simple-records/record-def.s) -- record definitions.
- [linux.s](06.reading-and-writing-simple-records/linux.s) -- common Linux definitions.
- [read-record.s](06.reading-and-writing-simple-records/read-record.s) -- a function that reads a record from the file descriptor.
- [write-record.s](06.reading-and-writing-simple-records/write-record.s) -- a function that writes a record to the file descriptor.
- [write-records.s](06.reading-and-writing-simple-records/write-records.s) -- a program that writes some sample records to the file.
- [count-chars.s](06.reading-and-writing-simple-records/count-chars.s) -- a function that counts the characters in the string until a null byte is reached.
- [write-newline.s](06.reading-and-writing-simple-records/write-newline.s) -- a function that writes a newline to the file descriptor.
- [read-records.s](06.reading-and-writing-simple-records/read-records.s) -- a program that reads records from the file.
- [add-year.s](06.reading-and-writing-simple-records/add-year.s) -- a program that reads records from the input file, increments the age of each record and writes them to the output file.


## 7. Developing Robust Programs

- [error-exit.s](07.developing-robust-programs/error-exit.s) -- a function that writes the error message to the standard error output and exits.
- [add-year.s](07.developing-robust-programs/add-year.s) -- a program that reads records from the input file, increments the age of each record and writes them to the output file.


## 8. Sharing Functions with Code Libraries

- [helloworld-nolib.s](08.sharing-functions-with-code-libraries/helloworld-nolib.s) -- a program that writes the message "hello world" and exits.
- [helloworld-lib.s](08.sharing-functions-with-code-libraries/helloworld-lib.s) -- a program that writes the message "hello world" and exits using the standard C library.
- [printf-example.s](08.sharing-functions-with-code-libraries/printf-example.s) -- a program that demonstrates the use of the `printf` function.
- [write-record.s](08.sharing-functions-with-code-libraries/write-record.s), [read-record.s](08.sharing-functions-with-code-libraries/read-record.s) -- functions that write and read records, which are used to create a shared library for working with records.
- [write-records.s](08.sharing-functions-with-code-libraries/write-records.s) -- a program that writes some sample records to the file and uses the shared library for working with records.

Notes:

- On x86-64 Linux in order to be able to link 32-bit programs with the `c` library install the `libc6-dev-i386` package:

  ```
  $ sudo apt install libc6-dev-i386
  ```
- In order to run the `write-records.exe` program, execute the following command:

  ```
  $ LD_LIBRARY_PATH=. ./write-records.exe
  ```


## 9. Intermediate Memory Topics

- [alloc.s](09.intermediate-memory-topics/alloc.s) -- a simple memory manager.
- [read-records.s](09.intermediate-memory-topics/read-records.s) -- a program that reads records from the file and uses a simple memory manager to allocate memory.


## 10. Counting Like a Computer

- [integer-to-string.s](10.counting-like-a-computer/integer-to-string.s) -- a function that converts an integer number to a ecimal string representation.
- [conversion-program.s](10.counting-like-a-computer/conversion-program.s) -- a program that converts an integer number to a decimal string representation and prints it.


## 11. High-Level Languages

- [hello-world.c](11.high-level-languages/hello-world.c) -- hello world program in C.
- [hello-world.pl](11.high-level-languages/hello-world.pl) -- hello world program in Perl.
- [hello-world.py](11.high-level-languages/hello-world.py) -- hello world program in Python.
