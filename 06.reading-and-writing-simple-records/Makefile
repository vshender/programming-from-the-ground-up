.PHONY: all clean

ALL := write-records.exe read-records.exe add-year.exe

all: ${ALL}

write-records.exe: write-record.o write-records.o
read-records.exe: read-record.o count-chars.o write-newline.o read-records.o
add-year.exe: read-record.o write-record.o write-newline.o count-chars.o add-year.o

%.exe:
	ld -m elf_i386 $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
	rm -f test.dat testout.dat
