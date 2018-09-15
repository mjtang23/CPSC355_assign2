/* Marcus Tang 10086730
The design of this program is to add all the registers together to find the sum of them. In order to do that, all registers must dump their binary numbers into one register.
This we will call check sum. There are specific operations that will take place within the code (such as xor), that make the CCR complete. As well are specific inputs given, so
the user can't put in anything, which makes the solution a single answer. The answer should be 0x66b8. Unfortunately it gives 0x756e...*/

fmt:    .asciz "The current checksum is %x\n"
        .align 4

 .global main
main:
      save  %sp, -96, %sp
      set   0xffffffff, %l0   ! To set check sum, which will have the sum of all the inputs taken in
      set   0xaaaa8c01, %l4   ! setting the l4 register to specific input given
      set   0xff001234, %l5   ! setting the l5 register to specific input given
      set   0x13579bdf, %l6   ! setting the l6 register to specific input given
      set   0xc8b4ae32, %l7   ! setting the l7 register to specific input given
      set   0x8000, %g2  ! set bit mask for bit 15
	    set   32, %g3      ! set the count for the "for" loop
      set   4, %g4  ! sets what register to use
      set   0x80000000, %g5
      mov   %l4, %l3


      set   0x0000ffff, %o0  !
      and   %o0, %l0, %o1 ! Makes all the bits from 15-31 into zeros

      set     fmt, %o0  ! Print Statement for what the checksum currently is
      call    printf
      nop

      guard:

        cmp    %g3, 0    ! Checks the count to see if it needs to end
        bg	   iso_bit11 ! if a positive number still, then start the loop again
        nop


        mov    32, %g3   ! Sets count back to 32 when switching registers
        inc    %g4       ! increases so we can use next register

        cmp    %g4, 5    ! if register count is equal, it goes to switch1
        be     switch1   ! this will switch the registers being used in checksum
        nop


        cmp    %g4, 6     ! if register count is equal, it goes to switch2
        be     switch2    !this will switch the registers being used in checksum
        nop


        cmp    %g4, 7     ! if register count is equal, it goes to switch3
        be     switch3    !this will switch the registers being used in checksum
        nop


        ba     result     ! This will go to print out results
        nop

  switch1:
        mov    %l5, %l3   ! this switches the register being summed up
        ba     guard
        nop
  switch2:
        mov    %l6, %l3  ! this switches the register being summed up
        ba     guard
        nop
  switch3:
        mov    %l7, %l3  ! this switches the register being summed up
        ba     guard
        nop

	iso_bit11:
	  and    %l0, %g2, %l1 ! isolate bit 15
    and    %l0, 0x800, %l2 ! isolate bit 11
    sll    %l2, 4, %l2   ! shift the isolated bit of b 11 match the bits
    xor    %l1, %l2, %o3 ! operation required for program

    cmp   %o3, %l2  ! Decides if we need to change the bit in l0
    be     iso_bit4
    nop
		btog  0x800, %l0 ! Changes bit 11 in the checksum
    ba    iso_bit4
    nop


    iso_bit4:

    and    %l0, %g2, %l1 ! isolate bit 15
    and    %l0, 0x10, %l2 ! isolate bit 11
    sll    %l2, 11, %l2  ! shift the isolated bit of b4 11 times to match b15
    xor    %l1, %l2, %o3 ! operation needed to be made


		cmp   %o3, %l2       ! Decides if we need to change the bit in l0
    be     iso_bit31
    nop
		btog   0x10, %l0      ! Changes the bit 4 in the checksum
		ba     iso_bit31
		nop


	iso_bit31:

	  and    %l0, %g2, %l1 ! isolate bit 15
    and    %l3, %g5, %l2 ! isolate bit 31 on l4
		sll    %l1, 16, %l1 ! moves l1 to match isolated bit of l4
		xor    %l1, %l2, %o3 ! operation needed to be made

		sll    %l3, 1, %l4 ! shifts the l4 register left to compare next bit
		sll    %l0, 1, %l0 ! shifts the check sum left to compare compare next bit
		sub    %g3, 1, %g3

		cmp   %o3, 0       ! Decides if we need to change the bit in l0
    be     guard
    nop
		btog   1, %l0      ! Changes the bit 0 if needed in checksum while comparing the xor of the new data compared to the zero
    ba     guard
    nop




   result:

    set   0x0000ffff, %o0  ! set bits 15 on to zeros
    and   %o0, %l0, %o1 ! Makes all the bits from 15-31 into zeros

    set     fmt, %o0  ! Print Statement for what the checksum currently is
    call    printf
    nop


    mov     1, %g1    ! Ending the program
    ta      0
