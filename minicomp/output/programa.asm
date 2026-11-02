.data
    v_i: .word 0
    v_pares: .word 0
    v_resto: .word 0
    texto0: .asciiz "Analizando numeros del 1 al 6:\n"
    texto4: .asciiz "Total de numeros pares encontrados:\n"

.text
.globl main
main:
    # int i = ...
    li   $t0, 1
    sw   $t0, v_i
    # int pares = ...
    li   $t0, 0
    sw   $t0, v_pares
    # int resto (inicializada en 0)
    # System.Out.Println("Analizando numeros del 1 al 6:")
    la   $a0, texto0
    li   $v0, 4
    syscall
    # WHILE
inicio_while_2:
    lw   $t0, v_i
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    li   $t0, 6
    move $t1, $t0
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    sle  $t0, $t0, $t1
    beqz $t0, fin_while_3
    # resto = ...
    lw   $t0, v_i
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    li   $t0, 2
    move $t1, $t0
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    div  $t0, $t1
    mfhi $t0
    sw   $t0, v_resto
    # IF
    lw   $t0, v_resto
    addi $sp, $sp, -4
    sw   $t0, 0($sp)
    li   $t0, 0
    move $t1, $t0
    lw   $t0, 0($sp)
    addi $sp, $sp, 4
    seq  $t0, $t0, $t1
    beqz $t0, fin_if1
    # System.Out.Println(expr)
    lw   $t0, v_i
    move $a0, $t0
    li   $v0, 1           # syscall print_int
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    # pares++
    lw   $t0, v_pares
    addi $t0, $t0, 1
    sw   $t0, v_pares
fin_if1:
    # i++
    lw   $t0, v_i
    addi $t0, $t0, 1
    sw   $t0, v_i
    j    inicio_while_2
fin_while_3:
    # System.Out.Println("Total de numeros pares encontrados:")
    la   $a0, texto4
    li   $v0, 4
    syscall
    # System.Out.Println(expr)
    lw   $t0, v_pares
    move $a0, $t0
    li   $v0, 1           # syscall print_int
    syscall
    li   $a0, 10          # salto de línea
    li   $v0, 11          # syscall print_char
    syscall
    li   $v0, 10          # fin del programa
    syscall
