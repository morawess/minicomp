# Código generado por minicomp (JFlex + CUP) — abrir y ejecutar en MARS

.data
    str_verdadero: .asciiz "verdadero"
    str_falso:     .asciiz "falso"
    str_vacia:     .asciiz ""
    v_flag: .word 0
    str_0: .asciiz "Inicio del Programa"
    str_3: .asciiz "Hola Mundo!"
    str_4: .asciiz "Error"
    str_5: .asciiz "Final del Programa"

.text
.globl main
main:
    # línea 1: boolean flag = true;
    li   $t0, 1              # verdadero
    sw   $t0, v_flag
    # línea 2: System.Out.Println("Inicio del Programa");
    la   $t0, str_0
    move $a0, $t0
    li   $v0, 4              # syscall print_string
    syscall
    li   $a0, 10             # salto de línea
    li   $v0, 11             # syscall print_char
    syscall
    # línea 3: IF (flag){
    lw   $t0, v_flag
    beqz $t0, L1             # si es falso, saltar
    # línea 4: System.Out.Println ("Hola Mundo!");
    la   $t0, str_3
    move $a0, $t0
    li   $v0, 4              # syscall print_string
    syscall
    li   $a0, 10             # salto de línea
    li   $v0, 11             # syscall print_char
    syscall
    j    L2                  # fin del bloque entonces
L1:
    # línea 7: System.Out.Println ("Error");
    la   $t0, str_4
    move $a0, $t0
    li   $v0, 4              # syscall print_string
    syscall
    li   $a0, 10             # salto de línea
    li   $v0, 11             # syscall print_char
    syscall
L2:
    # línea 9: System.Out.Println("Final del Programa");
    la   $t0, str_5
    move $a0, $t0
    li   $v0, 4              # syscall print_string
    syscall
    li   $a0, 10             # salto de línea
    li   $v0, 11             # syscall print_char
    syscall
    li   $v0, 10             # fin del programa (syscall exit)
    syscall
