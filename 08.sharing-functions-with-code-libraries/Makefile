.PHONY: all clean

ALL := helloworld-nolib.exe helloworld-lib.exe printf-example.exe librecord.so write-records.exe

all: ${ALL}

helloworld-nolib.exe: helloworld-nolib.o
	ld -m elf_i386 $< -o $@

%.exe: %.o
	ld -m elf_i386 -dynamic-linker /lib32/ld-linux.so.2 -lc $< -o $@

write-records.exe: write-records.o
	ld -m elf_i386 -dynamic-linker /lib32/ld-linux.so.2 -L . -lrecord $< -o $@

librecord.so: write-record.o read-record.o
	ld -m elf_i386 -shared $^ -o $@

%.o: %.s
	as --32 $< -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
	rm -f test.dat
