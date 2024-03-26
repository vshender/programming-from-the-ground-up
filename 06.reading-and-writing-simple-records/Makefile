.PHONY: all clean

ALL := write-records.exe read-records.exe add-year.exe read-records-ex.exe

all: ${ALL}

write-records.exe: write-record.o write-records.o
read-records.exe: read-record.o count-chars.o write-newline.o read-records.o
add-year.exe: read-record.o write-record.o write-newline.o count-chars.o add-year.o

read-records-ex.exe: read-record.o long-to-string.o count-chars.o read-records-ex.o

%.exe:
	ld -m elf_i386 $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
	rm -f test.dat testout.dat
