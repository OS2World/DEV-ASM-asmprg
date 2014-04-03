;==============================================================================;
; OS/2 2.0 Assembler Routines                                                  ;
;                                                                              ;
; thunk16.asm     thunking routines, 16 <-> 32 bit calls                       ;
;                                                                              ;
; Author: Larry Morley                                  (c) Larry Morley, 1993 ;
;==============================================================================;

                  INCLUDE std20.inc
                  INCLUDE stdmac20.inc

PUBLIC            _Call16

;------------------------------------------------------------------------------

CODE32            SEGMENT
                  ASSUME  CS:CODE32,SS:STACK32

_Call16           PROC

                                                  ; get caller's return address
                                                  ; off the stack and save

                  POP     EAX
                  MOV     dwRetToCaller,EAX
                                                  ; put return address of thunk
                                                  ; on stack frame

                  PUSH    OFFSET FLAT:_RetToThunk16
                  MOV     EBX,ESP
                  SHL     WORD PTR [EBX+2],3
                  ADD     WORD PTR [EBX+2],7

                                                  ; stack frame now set up
                                                  ; for jump to - return from
                                                  ; 16 bit function

                  MOV     EAX,OFFSET FLAT:_Thunk16
                  MOV     EBX,EAX
                  SHR     EAX,16
                  SHL     AX,3
                  ADD     AX,7
                  MOV     wThunk16AddrSeg,AX
                  AND     EBX,00000FFFFH
                  MOV     dwThunk16AddrOff,EBX

                  MOV     dwRetToCall16Off,OFFSET FLAT:_RetToCall16
                  MOV     AX,CS
                  MOV     wRetToCall16Seg,AX

                  mov     eax,dwRetToCaller       ; ret to caller
                  mov     ax,wThunk16AddrSeg
                  mov     eax,dwThunk16AddrOff

                  MOV     dwSavedStackPtr,ESP

                  MOV     AX,SS
                  MOV     DS,AX
                  MOV     EAX,EBP
                  SHR     EAX,16
                  SHL     AX,3
                  ADD     AX,7
                  MOV     SS,AX
                  NOP

                  MOV     EBX,EBP
                  AND     EBX,00000FFFFH

                  JMP     fwThunk16AddrDS

_RetToCall16      EQU     $
                                                  ; leave ax, bx alone since
                                                  ; they may contain return
                                                  ; values from function call
                  MOV     DX,DS
                  MOV     SS,DX
                  NOP

                  MOV     EDX,dwSavedStackPtr
                  AND     EDX,0FFFF0000H
                  OR      ESP,EDX
                  JMP     dwRetToCaller

_Call16           ENDP

CODE32            ENDS

;******************************************************************************

CODE16            SEGMENT

_Thunk16          PROC

                  JMP     dwFnToCallFrom16

_RetToThunk16     EQU     $
                  JMP     fwRetToCall16

_Thunk16          ENDP


CODE16            ENDS
                  END

