;==============================================================================;
; OS/2 2.0 Assembler Routines                                                  ;
;                                                                              ;
; stdmac20.inc     Standard macros for OS/2 2.0 modules                        ;
;                                                                              ;
; INCLUDE this file after std20.inc or equivalent                              ;
;                                                                              ;
; Author: Larry Morley                                  (c) Larry Morley, 1993 ;
;==============================================================================;
; stack variables for calling 16 bit code from 32 bit code                     ;
;------------------------------------------------------------------------------

IFNDEF  __THUNK16__
   EXTRN _Call16:NEAR32
ENDIF

dwStackVarBytes   EQU     040H                    ; bytes for local vars

dwSavedStackPtr   EQU     DWORD PTR SS:[EBP+014H]

fwRetToCall16     EQU     FWORD PTR SS:[BP +00EH]
 wRetToCall16Seg  EQU     WORD  PTR SS:[EBP+012H]
dwRetToCall16Off  EQU     DWORD PTR SS:[EBP+00EH]

fwThunk16Addr     EQU     FWORD PTR SS:[EBP+008H]
fwThunk16AddrDS   EQU     FWORD PTR DS:[EBP+008H]
 wThunk16AddrSeg  EQU     WORD  PTR SS:[EBP+00CH]
dwThunk16AddrOff  EQU     DWORD PTR SS:[EBP+008H]

dwFnToCallFrom16  EQU     DWORD PTR SS:[BP +004H]
dwFnToCallFrom32  EQU     DWORD PTR SS:[EBP+004H]
 wFnToCallSeg     EQU     WORD  PTR SS:[EBP+006H]

dwRetToCaller     EQU     DWORD PTR SS:[EBP+000H]

;------------------------------------------------------------------------------

PREP16            MACRO   fn16Bit:REQ             ; prepare for call to 16-bit
                                                  ; code from 32-bit code
                          PUSH    EBP

                          SUB     ESP,dwStackVarBytes     ; make room on stack
                          MOV     EBP,ESP                 ; for 32->16 vars

                          ; convert target fn address to 16:16

                          MOV     dwFnToCallFrom32,OFFSET FLAT:fn16Bit
                          SHL     wFnToCallSeg,3
                          ADD     wFnToCallSeg,7

                  ENDM

;------------------------------------------------------------------------------

CVTLP16           MACRO   p32:REQ

                          PUSHD   OFFSET FLAT:p32
                          MOV     EBX,ESP
                          SHL     WORD PTR [EBX+2],3
                          ADD     WORD PTR [EBX+2],7

                  ENDM

;------------------------------------------------------------------------------

CALL16            MACRO

                  CALL    _Call16
                                                  ; stack ptr += size of local
                  ADD     ESP,dwStackVarBytes

                  POP     EBP

                  ENDM

;------------------------------------------------------------------------------

EXIT_THREAD       EQU     0
EXIT_PROCESS      EQU     1

$$DosExit         MACRO   dwAction:REQ, dwResult:REQ
                     PUSH    dwResult
                     PUSH    dwAction
                     CALL    DosExit
                     ADD     ESP,8
                  ENDM

;------------------------------------------------------------------------------;
; Declare stack - 16K is default stack size                                    ;
;------------------------------------------------------------------------------;

DCLSTACK          MACRO nBytes:=<04000H>
                        STACK32 SEGMENT
                                DB nBytes DUP(?)
                        STACK32 ENDS
                  ENDM

;------------------------------------------------------------------------------

BEGINDATA         MACRO
DATA32 SEGMENT
                  ENDM

ENDDATA           MACRO
DATA32 ENDS
                  ENDM

;------------------------------------------------------------------------------
