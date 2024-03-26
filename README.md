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
