.PHONY: all clean

ALL := power.exe factorial.exe

all: ${ALL}

%.exe: %.o
	ld -m elf_i386 $< -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
