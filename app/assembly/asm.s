.section .init
.align 4

.globl boot

main:
    li      a1, 12
    li      a1, 15

loop:
    addi a3, a1, 12
    addi a4, a2, 15
    j loop
    
    ecall


.section .rodata		# Constants
.align 4
.globl _has_priv	# Set available for 'extern'
_has_priv: .4byte 1
reg_buffer: .4byte 0

