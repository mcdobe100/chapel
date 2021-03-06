dnl  Power9 mpn_mul_1.

dnl  Copyright 2017, 2018 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.
dnl
dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of either:
dnl
dnl    * the GNU Lesser General Public License as published by the Free
dnl      Software Foundation; either version 3 of the License, or (at your
dnl      option) any later version.
dnl
dnl  or
dnl
dnl    * the GNU General Public License as published by the Free Software
dnl      Foundation; either version 2 of the License, or (at your option) any
dnl      later version.
dnl
dnl  or both in parallel, as here.
dnl
dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
dnl  for more details.
dnl
dnl  You should have received copies of the GNU General Public License and the
dnl  GNU Lesser General Public License along with the GNU MP Library.  If not,
dnl  see https://www.gnu.org/licenses/.

include(`../config.m4')

C                   cycles/limb
C POWER3/PPC630		 ?
C POWER4/PPC970		 ?
C POWER5		 ?
C POWER6		 ?
C POWER7		 ?
C POWER8		 ?
C POWER9		 2.47

C TODO
C  * Schedule for Power9 pipeline.
C  * Unroll 4x if that proves beneficial.
C  * This is marginally faster (but much smaller) than ../mul_1.asm.

C INPUT PARAMETERS
define(`rp', `r3')
define(`up', `r4')
define(`n',  `r5')
define(`v0', `r6')

ASM_START()
PROLOGUE(mpn_mul_1c)
	b	L(ent)
EPILOGUE()
PROLOGUE(mpn_mul_1)
	li	r7, 0
L(ent):	ld	r11, 0(up)
	cmpdi	cr6, n, 2
	addi	r0, n, -1	C FIXME: postpone
	srdi	r0, r0, 1	C FIXME: postpone
	mtctr	r0		C FIXME: postpone
	rldicl.	r12, n, 0,63	C r0 = n & 3, set cr0
	bne	cr0, L(b1)

L(b0):	ld	r0, 8(up)
	maddld(	r9, r11, v0, r7)
	maddhdu(r7, r11, v0, r7)
	ble	cr6, L(2)
	ld	r12, 16(up)
	mulld	r8, r0, v0
	mulhdu	r5, r0, v0
	addic	up, up, 16
	addi	rp, rp, -8
	b	L(mid)

L(b1):	ld	r0, 0(up)
	ble	cr6, L(1)
	ld	r12, 8(up)
	maddld(	r8, r11, v0, r7)
	maddhdu(r5, r11, v0, r7)
	ld	r0, 16(up)
	mulld	r9, r12, v0
	mulhdu	r7, r12, v0
	addic	up, up, 24
	bdz	L(end)

	ALIGN(16)
L(top):	ld	r12, 0(up)
	std	r8, 0(rp)
	adde	r9, r5, r9
	mulld	r8, r0, v0
	mulhdu	r5, r0, v0
L(mid):	ld	r0, 8(up)
	std	r9, 8(rp)
	adde	r8, r7, r8
	mulld	r9, r12, v0
	mulhdu	r7, r12, v0
	addi	rp, rp, 16
	addi	up, up, 16
	bdnz	L(top)

L(end):	std	r8, 0(rp)
	mulld	r8, r0, v0
	adde	r9, r5, r9
	mulhdu	r5, r0, v0
	std	r9, 8(rp)
	adde	r8, r7, r8
	std	r8, 16(rp)
	addze	r3, r5
	blr

L(2):	mulld	r8, r0, v0
	mulhdu	r5, r0, v0
	std	r9, 0(rp)
	addc	r8, r7, r8
	std	r8, 8(rp)
	addze	r3, r5
	blr

L(1):	maddld(	r8,  r0, v0, r7)
	std	r8, 0(rp)
	maddhdu(r3, r0, v0, r7)
	blr
EPILOGUE()
