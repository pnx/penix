
# BIOS loads this bootsector code at address 0x7C00 in RAM
# This contant will be loaded into the DS (Data segment) register.
#
# each segment contains 16 adresses so the value stored in the segment
# register will be multiplied by 16 (0x1) to get the actual address.
# (0x07C0 * 0x1 = 0x7C00)
BOOTSEG = 0x07C0

# The CPU starts in Realmode (that is 16 bit word sizes).
# tell the assembler that we are writing 16 bit code.
.code16
.section .text
	.globl _start

_start:
	# Setup segment registers
	movw $BOOTSEG	, %ax
	movw %ax	, %ds

	# print $msg1 on the screen.
	movw $(msg1 - _start), %si
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


_bootflag:
	# Write MBR magic number at byte 510 and 511.
	.org 	510
	.word 	0xAA55
