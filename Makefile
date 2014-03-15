
AS = as
ASFLAGS = --32
LD = ld 
LDFLAGS = -m elf_i386

image.bin : boot.o
	$(LD) $(LDFLAGS) --oformat=binary -o $@ $^

clean :
	$(RM) *.o

distclean : clean
	$(RM) image.bin
