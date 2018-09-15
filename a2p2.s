/* Marcus Tang 10086730  This program shows how to multiply 2 numbers together without using .mul. There input values are given, and the program basically shows how .mul works. */

fmt:    .asciz "The current product is %x and %x\n" ! Statement for the result
        .align 4

 .global main
main:
      save  %sp, -96, %sp

    set   0, %l0          ! product
    set   0x04ee67b7, %l1 ! multiplicand
    set   0x072e8b8c, %l2 ! multiplier
    set   0x80000000, %g3 ! bit mask for bit 31
	  set   0, %l3          ! count to go through all the bits

	guard:
	   cmp   %l3, 32
	   bl    step1
	   nop

	   set     fmt, %o0  ! Print Statement
     mov     %l0, %o1  ! placing the product into first %x
	   mov     %l2, %o2  ! placing the multiplier into second %x
     call    printf    !
     nop


	   mov     1, %g1    ! Ending the program
     ta      0

	step1:
	   and   %l2, %g3, %l3 ! isolating bit 31 in multiplier
	   cmp   %l3, 0        ! if lsd in multiplier is zero, go to next step
	   be   step2
	   nop
	   add   %l1, %l0, %l0 ! else add multiplicand to product
     ba   step2
     nop

	step2:
     and  %l0, 0x1, %l5 ! isolate bit 0 from the product
	   sra  %l0, 1, %l0   ! shift right 1 in product
	   sra  %l2, 1, %l2   ! shirft right 1 in multiplier
     and  %l2, %g3, %l4 ! isolate the 31 bit in multiplier
     sll  %l5, 31, %l5  ! shift the product  to match the value of multiplier
     inc  %g3           ! increase the count by one
	   cmp  %l5, %l4      ! compare the multiplier and the product to see if same
	   be   guard         ! if same, skips to the guard
	   nop

	   btog %g3, %l2      ! if not, it switches the digit in 31 bit in multiplier
	   ba   guard
	   nop
