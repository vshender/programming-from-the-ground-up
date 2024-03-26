.PHONY: all clean

ALL := read-records.exe

all: ${ALL}

read-records.exe: read-record.o count-chars.o write-newline.o alloc.o read-records.o

%.exe:
	ld -m elf_i386 $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
	rm -f test.dat
