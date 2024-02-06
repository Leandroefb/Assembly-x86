.global main 

.data
    banner: .asciz "   _______     ____  __ __  __ \n  / ____\\ \\   / /  \\/  |  \\/  |\n | (___  \\ \\_/ /| \\  / | \\  / |\n  \\___ \\  \\   / | |\\/| | |\\/| |\n  ____) |  | |  | |  | | |  | |\n |_____/   |_|  |_|  |_|_|  |_|\n"
    null:   .float 0

    m:      .int 3
    n:      .int 3

    alpha:  .float 1.3
    beta:   .float 3.14
    temp:   .float 0

    format1: .asciz "float: %f\n"
    format2: .asciz "int: %d\n"

    floatf:    .asciz "%f\t"
    novalinha:   .asciz "\n"
    entradaint: .asciz "%d"
    entradafloat: .asciz "%f"

    mmatrizA:   .asciz "\nMatriz A:"
    mmatrizB:   .asciz "\nMatriz B:"
    mmatrizC:   .asciz "\nMatriz C:"
    entradam:   .asciz "\nDigite o valor de m: "
    entradan:   .asciz "\nDigite o valor de n: "
    entradaalpha: .asciz "\nDigite o valor de alpha: "
    entradabeta: .asciz "\nDigite o valor de beta: "
    entradaC:   .asciz "\nDigite os elementos da matriz na sequencia C00, C01, ..., C10, C11, ... um elemento cada linha"
    entradaB:   .asciz "\nDigite os elementos da matriz na sequencia B00, B01, ..., B10, B11, ...um elemento cada linha"
    entradaA:   .asciz "\nDigite os elementos da matriz A na sequencia A00, A01, ..., A10, A11, ... um elemento cada linha"

.text
main:

    mov $banner, %rdi # imprime o banner na tela
    sub $8, %rsp
    call puts
    add $8, %rsp

################# RECEBE M

    mov $entradam, %rdi # pede ao usuário o valor de m
    sub $8, %rsp
    call puts
    add $8, %rsp  
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradaint, %rdi # formato da entrada
    mov $0, %rax
    call scanf
    mov 8(%rsp), %eax # rax pega o valor recebido do usuário
    add $8, %rsp
    mov %eax, m(%rip) # salva o valor de m 

################# RECEBE N

    mov $entradan, %rdi # pede ao usuário o valor de n
    sub $8, %rsp
    call puts
    add $8, %rsp  
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradaint, %rdi # formato da entrada
    mov $0, %rax
    call scanf
    mov 8(%rsp), %eax # rax pega o valor recebido do usuário
    add $8, %rsp # salva o valor de n

    mov %eax, n(%rip)

############### RECEBE ALPHA

    mov $entradaalpha, %rdi # pede ao usuário o valor de alpha
    sub $8, %rsp
    call puts
    add $8, %rsp  
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradafloat, %rdi # formato da entrada
    mov $0, %rax
    call scanf
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp
    movss %xmm0, alpha(%rip) # salva o valor de alpha 

############### RECEB BETA

    mov $entradabeta, %rdi # pede ao usuário o valor de beta
    sub $8, %rsp
    call puts
    add $8, %rsp  
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradafloat, %rdi # formato da entrada
    mov $0, %rax
    call scanf
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp
    movss %xmm0, beta(%rip) # # salva o valor de beta

############### RECEBE C

    mov m(%rip), %eax
    imul n(%rip), %eax
    imul $4, %eax
    mov %eax, %edi                               
    call malloc
    push %rax # coloca na pilha o endereço de memória do primeiro elemento do bloco de memória que aloca a matriz C
    movq %rax, %rbx
    mov $entradaC, %rdi 
    sub $8, %rsp
    call puts # imprime as orientações para reeceber a matriz C
    add $8, %rsp
    mov m(%rip), %r14
    imul n(%rip), %r14
    movq $-1, %r12 # inicializa o índice utilizado para saber onde deve-se escrever o elemento recebido do usuário no bloco de memória que representa a matriz C
loopC:
    inc %r12 # incrementa o índice (indica qual elemento da matriz será escrito)
    cmpl %r14d, %r12d
    je continuaC
    sub $8, %rsp
    leaq 8(%rsp), %rax # reserva um espaço na pilha de 9 bytes onde será escrito a entrada do usuário, escrita pela função scanf
    movq %rax, %rsi
    mov $entradafloat, %rdi # formato da entrada
    mov $0, %rax
    sub $8, %rsp
    call scanf
    add $8, %rsp 
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp    
    movq %r12, %rax
    imulq $4, %rax
    addq %rbx, %rax
    movss %xmm0, (%rax)
    jmp loopC
continuaC:
    pop %rax
    push %rbx

############### RECEBE B
    mov m(%rip), %eax
    imul n(%rip), %eax
    imul $4, %eax
    mov %eax, %edi       
    call malloc
    push %rax # coloca na pilha o endereço de memória do primeiro elemento do bloco de memória que aloca a matriz B
    movq %rax, %rbx
    mov $entradaB, %rdi 
    sub $8, %rsp
    call puts # imprime as orientações para reeceber a matriz B
    add $8, %rsp   
    mov m(%rip), %r14
    imul n(%rip), %r14
    movq $-1, %r12 # inicializa o índice utilizado para saber onde deve-se escrever o elemento recebido do usuário no bloco de memória que representa a matriz C
loopB:
    inc %r12 # incrementa o índice (indica qual elemento da matriz será escrito)
    cmpl %r14d, %r12d
    je continuaB
    sub $8, %rsp
    leaq 8(%rsp), %rax # reserva um espaço na pilha de 9 bytes onde será escrito a entrada do usuário, escrita pela função scanf
    movq %rax, %rsi
    mov $entradafloat, %rdi # formato da entrada
    mov $0, %rax
    sub $16, %rsp
    call scanf
    add $16, %rsp 
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp    
    movq %r12, %rax
    imulq $4, %rax
    addq %rbx, %rax
    movss %xmm0, (%rax)
    jmp loopB
continuaB:
    pop %rax
    pushq %rbx

############### RECEBE A    

    mov m(%rip), %eax
    imul %eax, %eax
    imul $4, %eax
    mov %eax, %edi
    call malloc
    push %rax # # coloca na pilha o endereço de memória do primeiro elemento do bloco de memória que aloca a matriz A
    movq %rax, %rbx
    mov $entradaA, %rdi 
    sub $8, %rsp
    call puts # imprime as orientações para reeceber a matriz A
    add $8, %rsp
    mov m(%rip), %r14
    imul m(%rip), %r14
    movq $-1, %r12 # inicializa o índice utilizado para saber onde deve-se escrever o elemento recebido do usuário no bloco de memória que representa a matriz C
loopA:
    inc %r12 # incrementa o índice (indica qual elemento da matriz será escrito)
    cmpl %r14d, %r12d
    je continuaA
    sub $8, %rsp
    leaq 8(%rsp), %rax # reserva um espaço na pilha de 9 bytes onde será escrito a entrada do usuário, escrita pela função scanf
    movq %rax, %rsi
    mov $entradafloat, %rdi # formato da entrada
    mov $0, %rax
    sub $8, %rsp
    call scanf
    add $8, %rsp 
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp    
    movq %r12, %rax
    imulq $4, %rax
    addq %rbx, %rax
    movss %xmm0, (%rax)
    jmp loopA
continuaA:
    pop %rax
    push %rbx

    mov 16(%rsp), %rbx
############### EXECUTA O ALGORITMO SYMM

    call symm

############### IMPRIME C    

    mov 0(%rsp), %rdi # limpa o bloco de memória da matrix B
    call free
    mov 8(%rsp), %rdi # limpa o bloco de memória da matrix A
    call free

    mov 16(%rsp), %rax # copia o endereço de C
    mov %rax, (%rsp) # coloca o endereço de C no topo da pilha; como o código encerra por aqui, não é necessário respeitar o valor que já estava lá
    mov $mmatrizC, %rdi
    sub $8, %rsp
    call puts
    add $8, %rsp

    call imprime_matriz

    mov (%rsp), %rdi # limpa o bloco de memória da matrix C
    call free

exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

############### ALGORITMO SYMM

symm:
    push %rbp 
    mov %rsp, %rbp
    subq $16, %rsp                              # reserva de espaço para variáveis
    mov 24(%rbp), %r10                          # pega o endereço base do vetor [alpha, beta, temp]
    movl $-1, -4(%rbp)                          # inicializa o índice i
    loop1_symm:
        incl -4(%rbp)                           # incrementa i
        mov -4(%rbp), %ecx                      # copia o índice i para %ecx, não é possível comparar dois endereços de memória diretamente
        cmpl m(%rip), %ecx                      # verifica se i < m
        je exit_symm
        movl $-1, -8(%rbp)                      # inicializa o índice j
        loop2.1_symm:
            incl -8(%rbp)                       # incrementa j
            mov -8(%rbp), %ecx                  # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
            cmpl n(%rip), %ecx                  # verifica se j < n
            je loop1_symm                       # se for, sai fora desse loop
            movq $0, temp(%rip)                 # inicializa a variavel temp
            movl $-1, -12(%rbp)                 # inicializa o índice k
            loop3_symm:
                incl -12(%rbp)                  # incrementa k
                mov -12(%rbp), %ecx             # copia o índice k para %ecx, não é possível comparar dois endereços de memória diretamente
                cmpl -4(%rbp), %ecx             # verifica se k < i
                je loop2.2_symm                 # se for, sai fora desse loop
                                                #################### calcula offset de A[i][k] ####################
                mov -4(%rbp), %eax              # guarda i em %eax (i é um inteiro de 32bits)
                imul m(%rip), %eax              # calcula (i * m) e guarda em %eax
                add -12(%rbp), %eax             # calcula [(i * m) + k] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 16(%rbp), %rax             # soma o offset ao endereço base de A, %rax tem o endereço exato do elemento A[i][k]
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento A[i][k] 
                movss (%rax), %xmm2             # copia feita para utilização posterior do elemento A[i][k]
                                                #################### calcula offset de B[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull n(%rip), %eax             # calcula (i * n) e guarda em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 24(%rbp), %rax             # %rax tem o endereço exato do elemento B[i][j]
                mulss (%rax), %xmm0             # %xmm0 tem A[i][k] * B[i][j]
                #mulss -20(%rbp), %xmm0         # xmm0 tem A[i][k] * B[i][j] * alpha
                mulss alpha(%rip), %xmm0        # xmm0 tem A[i][k] * B[i][j] * alpha
                                                #################### calcula offset de C[k][j] ####################
                movl -12(%rbp), %eax            # guarda k em %eax
                imull n(%rip), %eax             # calcula (k * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 32(%rbp), %rax             # %rax tem o endereço do elemento C[k][j]    
                movss (%rax), %xmm1             # copia o elemento C[k][j] para o registrador %xmm1
                addss %xmm0, %xmm1              # soma (A[i][k] * B[i][j] * alpha) com C[k][j]
                movss %xmm1, (%rax)             # atualiza o valor de C[k][j] com seu novo valor
                                                #################### calcula offset de B[k][j] ####################
                movl -12(%rbp), %eax            # guarda k em %eax
                imull n(%rip), %eax             # calcula (k * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 24(%rbp), %rax             # %rax tem o endereço do elemento B[k][j]   
                movss (%rax), %xmm0             # %xmm0 tem o elemento B[i][k]
                mulss %xmm2, %xmm0              # calcula A[i][k] * B[i][k] e coloca em %xmm0
                movss temp(%rip), %xmm1         # %xmm1 tem o valor da variável temp
                addss %xmm1, %xmm0              # calcula temp + A[i][k] * B[i][k] 
                movss %xmm0, temp(%rip)         # escreve o resultado da operação anterior na própria variável temp
                jmp loop3_symm
        loop2.2_symm:                           #C[i][j] = beta * C[i][j] + alpha * B[i][j] * A[i][i] + alpha * temp1;
                                                #################### calcula offset de C[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull n(%rip), %eax             # calcula (i * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 32(%rbp), %rax             # %rax tem o endereço do elemento C[i][j]   
                movq %rax, %rbx                 # copia %rax para %rbx para usar posteriormente
                movss (%rax), %xmm0             # desreferenciação %xmm0 tem o elemento C[i][j] 
                mulss beta(%rip), %xmm0         # faz a operação beta * C[i][j] 
                movss %xmm0, (%rax)             # atualiza o valor de C[i][j] em seu endereço
                                                #################### calcula offset de B[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull n(%rip), %eax             # calcula (i * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 24(%rbp), %rax             # %rax tem o endereço do elemento B[i][j] 
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento B[i][j]
                mulss alpha(%rip), %xmm0        # calcula alpha * B[i][j]
                                                #################### calcula offset de A[i][i] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull m(%rip), %eax             # calcula (i * m) e guarda em %eax
                addl -4(%rbp), %eax             # calcula [(i * m) + i] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq  16(%rbp), %rax            # agora, %rax tem o endereço exato do elemento A[i][i]
                movss (%rax), %xmm1             # desreferenciação, %xmm1 tem o elemento A[i][i]
                mulss %xmm1, %xmm0              # %xmm0 tem A[i][i] * alpha * B[i][j]
                movss (%rbx), %xmm1             # %xmm1 tem o elemento C[i][j]
                addss %xmm1, %xmm0              # faz a operação A[i][i] * alpha * B[i][j] + C[i][j] e armazena em %xmm0
                movss %xmm0, (%rbx)             # salva o resultado da operação anteriro                
                                                ####################### calcula alpha * temp ######################
                movss alpha(%rip), %xmm1        # %xmm0 tem alpha
                mulss temp(%rip), %xmm1         # alpha * temp
                addss %xmm1, %xmm0              # soma alpha * temp com C[i][j] 
                movss %xmm0, (%rbx)             # armazena em C[i][j]
                jmp loop2.1_symm  
exit_symm:
    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    ret
              
imprime_matriz:
    push %rbp
    mov %rsp, %rbp
    subq $8, %rsp                               # reserva espaço para i, j
    movl $-1, -4(%rbp)                          # inicializa o índice i
    loopi_imprime:
        incl -4(%rbp)                           # incrementa i
        mov -4(%rbp), %ecx                      # copia o índice i para %ecx, não é possível comparar dois endereços de memória diretamente
        cmpl m(%rip), %ecx                      # verifica se i < m
        je exit_imprime
        movl $-1, -8(%rbp)                      # inicializa o índice j
        loopj_imprime:
            incl -8(%rbp)                       # incrementa j
            mov -8(%rbp), %ecx                  # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
            cmpl n(%rip), %ecx                  # verifica se j < n
            je loopi2_imprime  
            movl -4(%rbp), %eax                 # guarda i em %eax
            imull n(%rip), %eax                 # calcula (i * n) e guarda em %eax
            addl -8(%rbp), %eax                 # calcula [(i * n) + j] e guarda em %eax
            cltq                                # transforma %eax que um int64
            imulq $4, %rax                      # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
            addq 16(%rbp), %rax                 # %rax tem o endereço exato do elemento M[i][j]
            movss (%rax), %xmm0                 # %xmm0 tem M[i][J]
            cvtss2sd %xmm0, %xmm0               # transforma o float de %xmm0 em um double, já que esse é o formato aceito para printf
            mov $floatf, %rdi                   # formato de escrita
            mov $1, %rax                        # necessário para printf imprimir na tela o float, tendo como entrada o registrador %xmm0
            sub $8, %rsp
            call printf   
            add $8, %rsp 
            jmp loopj_imprime
    loopi2_imprime:
        sub $8, %rsp
        mov $novalinha, %rdi
        call puts
        add $8, %rsp
        jmp loopi_imprime
exit_imprime:
    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    ret
