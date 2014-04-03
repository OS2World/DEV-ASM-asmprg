;==============================================================================;
; OS/2 2.0 Assembler Routines                                                  ;
;                                                                              ;
; os2asm.asm      Test program                                                 ;
;                                                                              ;
; Author: Larry Morley                                  (c) Larry Morley, 1993 ;
;==============================================================================;

                  INCLUDELIB os2386.lib
                  INCLUDELIB os2286.lib

                  INCLUDE std20.inc
                  INCLUDE stdmac20.inc

DCLSTACK

BEGINDATA
                  szMsgLine00  DB "OS/2 Version 2.0 Assembler Routines",13,10,0
                  szMsgline01  DB "by Larry Morley",13,10,13,10,0
                  szMsgline02  DB "(c) 1993 Larry Morley, All Rights Reserved.",
                               13,10,0
ENDDATA

EXTRN             _strlen   : NEAR32
EXTRN             _getkey   : NEAR32
EXTRN             DosExit   : NEAR32
EXTRN             VioWrtTTY : NEAR32

;------------------------------------------------------------------------------

CODE32            SEGMENT
                  ASSUME  CS:CODE32,SS:STACK32,DS:DATA32

_main             PROC

                  ;=========================;

                  ; prepare the thunking layer for a call to VioWrtTTY
                  ; using PREP16 <function_address>
                  PREP16  VioWrtTTY

                  ; push ptr to string and convert to selector:offset
                  CVTLP16 szMsgLine00

                  ; push string length in bytes, and VIO handle (0)
                  ; note use of PUSHW to force size of pushed item
                  PUSH    OFFSET FLAT:szMsgLine00
                  CALL    _strlen
                  PUSH    AX

                  PUSHW   0

                  ; call the thunking layer's 32-bit setup-and-go proc
                  CALL16

                  ; return value is in registers...

                  ;=========================;

                  PREP16  VioWrtTTY
                  CVTLP16 szMsgLine01
                  PUSH    OFFSET FLAT:szMsgLine01
                  CALL    _strlen
                  PUSH    AX
                  PUSHW   0
                  CALL16

                  PREP16  VioWrtTTY
                  CVTLP16 szMsgLine02
                  PUSH    OFFSET FLAT:szMsgLine02
                  CALL    _strlen
                  PUSH    AX
                  PUSHW   0
                  CALL16

                  CALL    _getkey

                  ;=========================;

                  $$DosExit 1,0

_main             ENDP

;-------------------------------------------------------------------------------

CODE32            ENDS
                  END     _main

