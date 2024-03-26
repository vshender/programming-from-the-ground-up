ALL := hello-world.exe

all: ${ALL}

hello-world.exe: hello-world.c
	gcc $^ -o $@

clean:
	rm -f *~ *.o
	rm -f ${ALL}
