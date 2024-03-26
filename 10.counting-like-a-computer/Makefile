.PHONY: all clean

ALL := conversion-program.exe

all: ${ALL}

conversion-program.exe: count-chars.o write-newline.o integer-to-string.o conversion-program.o
	ld -m elf_i386 $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
