        OUTPUT opl2.com
        .ORG $0100      ; COM file origin

; === OPL2 Port Definitions ===
OPL_ADDR:       .equ $90
OPL_DATA:       .equ $91

; === WriteReg: Write C to OPL Reg B ===
WriteReg:
    ld a, b
    out (OPL_ADDR), a
    call SmallDelay
    ld a, c
    out (OPL_DATA), a
    call SmallDelay
    ret

; === Minimal Delay (~20uS on RC2014 @ 7.3728 MHz) ===
SmallDelay:
    ld b, 10
DelayLoop:
    djnz DelayLoop
    ret

; === Main Entry Point ===
start:

    ; Setup modulator (operator 1) — Chan 0
    ld b, $20     ; Tremolo/Vib/Env on: OFF, Multiplier = 0x01
    ld c, $01
    call WriteReg

    ld b, $40     ; Total Level = max attenuation (quieter)
    ld c, $3F
    call WriteReg

    ld b, $60     ; Attack: max, Decay: min
    ld c, $F0
    call WriteReg

    ld b, $80     ; Sustain: med, Release: med
    ld c, $77
    call WriteReg

    ; Setup carrier (operator 2) — Chan 0
    ld b, $23     ; Enable
    ld c, $01
    call WriteReg

    ld b, $43     ; Total Level = 0 (loudest)
    ld c, $00
    call WriteReg

    ld b, $63     ; Attack/Decay
    ld c, $F0
    call WriteReg

    ld b, $83     ; Sustain/Release
    ld c, $77
    call WriteReg

    ; Set frequency (A0 = Freq Lo, B0 = Block + Freq Hi + KeyOn)
    ld b, $A0
    ld c, $40     ; Low bits of frequency
    call WriteReg

    ld b, $B0
    ld c, $20     ; Block = 1, F-Num Hi = 0, Key-on = 1
    call WriteReg

loop:
    jp loop

    .END
