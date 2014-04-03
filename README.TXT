********************************************************************************
****************************- I M P O R T A N T -*******************************
********************************************************************************
**                                                                            **
**    "This software is provided as is and carries no warranty whatsoever.    **
**    Larry Morley ("Author") disclaims and excludes any and all implied      **
**    warranties of merchantability, title and fitness for particular         **
**    purpose.  Author does not warrant that the software will satisfy your   **
**    requirements or that the software is without defect or error or that    **
**    operation of the software will be uninterrupted.  You are using the     **
**    software at your risk.  Use of this software constitutes acceptance     **
**    of these terms."                                                        **
**                                                                            **
********************************************************************************
********************************************************************************
*  (c) Larry Morley 1992, 1993; All Rights Reserved.                           *
********************************************************************************

These files contain a couple of things - a OS/2 2.0 program in assembler that
makes KBD and VIO calls, and a demo of one way to call 16 bit code from 32
bit code (KDB, VIO et. al. are still 16 bit...).

Here's how the 32 bit code calls the 16 bit functions:

   (1) The 32 bit caller uses the PREP16 macro to allocate local temp
       storage /work space for registers and addresses.

   (2) The 32 bit caller pushes function parameters on the stack; optionally,
       32 bit flat pointers are converted to SELECTOR:OFFSET.

   (3) The 32 bit caller uses the CALL16 macro to call the 16 bit function.

Here's how control is transferred between 32 and 16 bit code:

   The 32 bit caller calls a function in a USE32 segment.  This function
   does a 48 bit FAR jump (16 bit segment, 32 bit offset) to a function
   in a USE16 segment, after saving a 48 bit return address on the stack.
   The 48 bit (FWORD) jump loads CS and EIP; this allows the jump into
   the 16 bit segment (the high order 16 bits of EIP are zeroed).  The
   16 bit function then calls the target 16 bit function.  When the
   target function returns, the 16 bit code does a 48 bit FAR jump back
   to the 32 bit intermediate segment, which restores registers and
   returns to the original caller.

   This approach doesn't use FS or GS (IBM and MS docs say they're reserved
   for use by the operating system), and the code is pure with no data
   segment.

   Please send me any feedback - comments, questions, etc. - that you
   might have.

   Larry Morley
   CIS 73670,563

   6909 Custer Rd #2503
   Plano, TX 75023
   (214) 618-0934

   <end>
