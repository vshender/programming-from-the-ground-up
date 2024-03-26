.PHONY: all clean

ALL := add-year.exe

all: ${ALL}

add-year.exe: read-record.o write-record.o write-newline.o count-chars.o error-exit.o add-year.o

%.exe:
	ld -m elf_i386 $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
	rm -f test.dat testout.dat
