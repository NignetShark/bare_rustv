# boot.S
# bootloader for SoS
# Stephen Marz
# 8 February 2019
.option norvc
.section .data

.section .text.init
.global _start
_start:
	# Disable MMU : SATP should be zero
	csrw	satp, zero

    # Read HART id (must be 0)
	csrr	t0, mhartid
	bnez	t0, _cpu_park # If not zero then park

.option push
.option norelax
	la		gp, _global_pointer
.option pop

	# Clear BSS section is expected to be zero
	la 		a0, _bss_start
	la		a1, _bss_end
	bgeu	a0, a1, _bss_break_loop

_bss_clear_loop:
	sw		zero, (a0)
	addi	a0, a0, 8
	bltu	a0, a1, _bss_clear_loop
_bss_break_loop:

    # Control registers, set the stack, mstatus, mepc,
    # and mtvec to return to the main function.
    # li		t5, 0xffff;
    # csrw	medeleg, t5
    # csrw	mideleg, t5
    la		sp, _stack_end
    # We use mret here so that the mstatus register
    # is properly updated.
    li		t0, (0b11 << 11) | (1 << 7) | (1 << 3)
    csrw	mstatus, t0
    la		t1, main
    csrw	mepc, t1
    la		t2, asm_trap_vector
    csrw	mtvec, t2
    li		t3, (1 << 3) | (1 << 7) | (1 << 11)
    csrw	mie, t3
    la		ra, _cpu_park
    mret

_cpu_park:
	wfi
	j	_cpu_park
