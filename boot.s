
BOOTSEG = 0x7C00
VIDSEG = 0xB800

# The CPU starts in Realmode (that is 16 bit word sizes).
# tell the assembler that we are writing 16 bit code.
.code16
.section .text
.globl _start

_start:
	# BIOS loads this bootsector code at address 0x7C00 in RAM.
	# therefor if $msg1 is located at for example 0x20 in the binary.
	# it is loaded at 0x7C00 + 0x20 in RAM.
	movw $BOOTSEG, %si
	addw $(msg1 - _start), %si

	# print $msg1 on the screen.
	call print

hang:	jmp hang


print:
	# Tell bios to print a character at the cursor.
	movb $0x0e, %ah

_prl:
	# load char from memory to al register.
	movb (%si), %al

	# if NULL character, jump out.
	cmpb $0, %al
	jz _prexit

	# write to TTY
	int $0x10

	# increment the address in si register and jump
	# to beginning of loop.
	addw $1, %si
	jmp _prl
_prexit:
	ret

msg1:	.ascii "Welcome to penix.\r\n\0"

# At offset 510. write MBR magic number.
.org 510
	.byte 0x55
	.byte 0xAA
