;; TIB https://en.wikipedia.org/wiki/Win32_Thread_Information_Block
;; PEB https://en.wikipedia.org/wiki/Process_Environment_Block
;; - https://www.ired.team/miscellaneous-reversing-forensics/windows-kernel-internals/exploring-process-environment-block
;; windbg - dt _peb
;; windbg - dt _teb
;; https://learn.microsoft.com/en-us/windows/win32/api/winternl/ns-winternl-peb_ldr_data
;; windbg - dt _LIST_ENTRY 
;; windbg - dt _LDR_DATA_TABLE_ENTRY 


global _start

section .text
_start:
;Mount NTDLL
    mov r8, gs:0x60       ;Move the address of the PEB to r8
    mov r9, [r8+0x018]    ;LDR?
    mov r10, [r9+0x10]    ; --> _ldr.InLoadOrderModuleList
    mov r10, [r10]        ; Follow base FLINK --> ntdll.dll
    mov r13, [r10+0x060]     ; This should put the &UNicode string "ntdll.dll" into r15.
    mov rax, [r10+0x30]      ; ntdll.dll.base
    mov r10, [r10]        ; Follow second FLINK --> kernel32.dll
    mov r14, [r10+0x060]   ;This should put the &UNicode string "kernel32.dll" into r15.
    mov rbx, [r10+0x30]      ; kernel32.dll.base
    mov r10, [r10]        ; Follow third FLINK --> kernelbase.dll
    mov rcx, [r10+0x30]      ; kernelbase.dll.base
    mov r15, [r10+0x060]   ;This should put the &UNicode string "kernelbase.dll" into r15.
    xor r9, r9
    ret