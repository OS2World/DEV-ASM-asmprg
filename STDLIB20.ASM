;==============================================================================;
; OS/2 2.0 Assembler Routines                                                  ;
;                                                                              ;
; stdlib.asm      standard library functions                                   ;
;                                                                              ;
; Author: Larry Morley                                  (c) Larry Morley, 1993 ;
;==============================================================================;

                  INCLUDE std20.inc
                  INCLUDE stdmac20.inc

EXTERN            KbdCharIn:NEAR32

PUBLIC            _strlen
PUBLIC            _getkey

;------------------------------------------------------------------------------

BEGINDATA

   IO_WAIT                 EQU     0
   IO_NOWAIT               EQU     1

   KBDKEYINFO      STRUCT  2
      chChar_                BYTE    0
      chScan_                BYTE    0
      fbStatus_              BYTE    0
      bNlsShift_             BYTE    0
      fsState_               WORD    0
      time_                  DWORD   0
   KBDKEYINFO        ENDS

   PKBDKEYINFO       TYPEDEF FAR PTR KBDKEYINFO

   __KbdKeyInfo      KBDKEYINFO <>

ENDDATA

;------------------------------------------------------------------------------

CODE32            SEGMENT
                  ASSUME  CS:CODE32,SS:STACK32,DS:FLAT

_strlen           PROC    PASCAL USES ECX EDI, szString:NEAR32

                  SUB     EAX,EAX
                  MOV     ECX,0FFFFFFFFH
                  MOV     EDI,szString

            REPNE SCASB                    ; while ((cx--) && (es:[edi] != al));

                  .IF     ECX == 0

                     MOV     EAX,ECX

                  .ELSE

                     NEG     ECX
                     SUB     ECX,2
                     MOV     EAX,ECX

                  .ENDIF

                  RET

_strlen           ENDP

;--------------------------------------

_getkey           PROC    PASCAL USES EBX EDX

                  PREP16  KbdCharIn
                  CVTLP16 __KbdKeyInfo
                  PUSHW   IO_WAIT
                  PUSHW   0
                  CALL16

                  SUB     EAX,EAX
                  MOV     AL,BYTE PTR FLAT:[__KbdKeyInfo.chChar_]

                  RET

_getkey           ENDP

;--------------------------------------

CODE32            ENDS
                  END

;------------------------------------------------------------------------------
