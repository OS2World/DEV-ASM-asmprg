;==============================================================================;
; OS/2 2.0 Assembler Routines                                                  ;
;                                                                              ;
; std20.inc        Standard stuff for OS/2 2.0 modules                         ;
;                                                                              ;
; INCLUDE this file at the start of the module (include early, include often?) ;
;                                                                              ;
; Author: Larry Morley                                  (c) Larry Morley, 1993 ;
;==============================================================================;

                  .386P    ; target processor 386 or above in protected mode
                  .387

;==============================================================================;
; STANDARD SEGDEFs - same as IBM C Set/2 compiler                              ;
;==============================================================================;

CODE32            SEGMENT USE32   DWORD   PUBLIC  'CODE'
CODE32            ENDS

;------------------------------------------------------------------------------;

CODE16            SEGMENT USE16   DWORD   PUBLIC  'CODE'
CODE16            ENDS

;------------------------------------------------------------------------------;

DATA32            SEGMENT USE32   DWORD   PUBLIC  'DATA'
DATA32            ENDS

;------------------------------------------------------------------------------;

CONST32           SEGMENT USE32   DWORD   PUBLIC  'CONST'
CONST32           ENDS

;------------------------------------------------------------------------------;

BSS32             SEGMENT USE32   DWORD   PUBLIC  'BSS'
BSS32             ENDS

;------------------------------------------------------------------------------;

STACK32           SEGMENT USE32   DWORD   STACK   'STACK'
STACK32           ENDS

;------------------------------------------------------------------------------;

DGROUP            GROUP  DATA32, CONST32, BSS32, STACK32

;==============================================================================;
