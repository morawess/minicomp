.data
    v_flag: .word 0
    v_num: .word 0
    v_num2: .word 0
    v_total: .word 0
    v_otroNum: .word 0
    texto0: .asciiz "Inicio del Programa"
    texto1: .asciiz "numero: "
    texto2: .asciiz "total: "
    texto3: .asciiz "Otro numero "
    texto4: .asciiz "Hola Mundo!"
    texto5: .asciiz "Error"
    texto8: .asciiz "Final del Programa"

.text
.globl main
main:
    # boolean flag = ...
    li   $t0, 1
    sw   $t0, v_flag
    # int num = ...
    li   $t0, 5
    sw   $t0, v_num
    # int num2 = ...
    li   $t0, 10
    sw   $t0, v_num2
    # int total = ...
    lw   $t0, v_num
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    lw   $t0, v_num2
    move $t1, $t0
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    add  $t0, $t0, $t1
    sw   $t0, v_total
    # int otroNum = ...
    li   $t0, 3
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    li   $t0, 4
    move $t1, $t0
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    add  $t0, $t0, $t1
    sw   $t0, v_otroNum
    # System.Out.Println(...)
    la   $a0, texto0
    li   $v0, 4           # syscall print_string
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    # System.Out.Println(...)
    la   $a0, texto1
    li   $v0, 4           # syscall print_string
    syscall
    lw   $t0, v_num
    move $a0, $t0
    li   $v0, 1           # syscall print_int
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    # System.Out.Println(...)
    la   $a0, texto2
    li   $v0, 4           # syscall print_string
    syscall
    lw   $t0, v_total
    move $a0, $t0
    li   $v0, 1           # syscall print_int
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    # System.Out.Println(...)
    la   $a0, texto3
    li   $v0, 4           # syscall print_string
    syscall
    lw   $t0, v_otroNum
    move $a0, $t0
    li   $v0, 1           # syscall print_int
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    # IF-ELSE
    lw   $t0, v_flag
    beqz $t0, else_6
    # System.Out.Println(...)
    la   $a0, texto4
    li   $v0, 4           # syscall print_string
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    j    fin_if7
else_6:
    # System.Out.Println(...)
    la   $a0, texto5
    li   $v0, 4           # syscall print_string
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
fin_if7:
    # System.Out.Println(...)
    la   $a0, texto8
    li   $v0, 4           # syscall print_string
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    li   $v0, 10          # fin del programa
    syscall
