.global main 

.data

    banner: .asciz "   _______     ____  __ __  __ \n  / ____\\ \\   / /  \\/  |  \\/  |\n | (___  \\ \\_/ /| \\  / | \\  / |\n  \\___ \\  \\   / | |\\/| | |\\/| |\n  ____) |  | |  | |  | | |  | |\n |_____/   |_|  |_|  |_|_|  |_|\n"
    null:   .float 0

    m:      .int 3
    n:      .int 3

    floatbuffer: .float 0

    a00:    .float 1.7
    a01:    .float 2.2
    a02:    .float 7.3
    a10:    .float 2.2
    a11:    .float 1.7
    a12:    .float 5.9
    a20:    .float 7.3 
    a21:    .float 5.9
    a22:    .float 1.7

    b00:    .float 0
    b01:    .float 9.5
    b02:    .float 1.2
    b10:    .float 9.5
    b11:    .float 3.1
    b12:    .float 6.9
    b20:    .float 1.2 
    b21:    .float 6.9
    b22:    .float 0

    alpha:  .float 1.3
    beta:   .float 3.14

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

.text

main:

    mov $banner, %rdi # imprime o banner na tela
    sub $8, %rsp
    call puts
    add $8, %rsp
    #push %rbp
    #mov %rsp, %rbp

    
    mov $entradam, %rdi # pede ao usuário o valor de m
    sub $8, %rsp
    call puts
    add $8, %rsp  
/   
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradaint, %rdi
    mov $0, %rax
    #sub $8, %rsp
    call scanf
    #add $8, %rsp 
    mov 8(%rsp), %eax # rax pega o valor recebido do usuário
    add $8, %rsp

    mov %eax, m(%rip)

#################

    mov $entradan, %rdi # pede ao usuário o valor de n
    sub $8, %rsp
    call puts
    add $8, %rsp  
/   
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradaint, %rdi
    mov $0, %rax
    #sub $8, %rsp
    call scanf
    #add $8, %rsp 
    mov 8(%rsp), %eax # rax pega o valor recebido do usuário
    add $8, %rsp

    mov %eax, n(%rip)
###############

    mov $entradaalpha, %rdi # pede ao usuário o valor de alhpa
    sub $8, %rsp
    call puts
    add $8, %rsp  
/   
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradafloat, %rdi
    mov $0, %rax
    #sub $8, %rsp
    call scanf
    #add $8, %rsp 
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp

    movss %xmm0, alpha(%rip)

###############

    mov $entradabeta, %rdi # pede ao usuário o valor de beta
    sub $8, %rsp
    call puts
    add $8, %rsp  
/   
    sub $8, %rsp
    leaq 8(%rsp), %rax
    movq %rax, %rsi
    mov $entradafloat, %rdi
    mov $0, %rax
    #sub $8, %rsp
    call scanf
    #add $8, %rsp 
    movss 8(%rsp), %xmm0 # xmm0 pega o valor recebido do usuário
    add $8, %rsp

    movss %xmm0, beta(%rip)

###############

    mov m(%rip), %eax
    imul n(%rip), %eax
    imul $4, %eax
    mov %eax, %edi                               # 
    call malloc
    push %rax # C

        mov (%rsp), %rsi
        mov $format2, %rdi
        mov $0, %rax
        sub $8, %rsp
        call printf    
        add $8, %rsp
######

    mov m(%rip), %eax
    imul n(%rip), %eax
    imul $4, %eax
    mov %eax, %edi       
    call malloc

    /*
    movss b00(%rip), %xmm0
    movss %xmm0, (%rax)
    movss b01(%rip), %xmm0
    movss %xmm0, 4(%rax)
    movss b02(%rip), %xmm0
    movss %xmm0, 8(%rax)
    movss b10(%rip), %xmm0
    movss %xmm0, 12(%rax)
    movss b11(%rip), %xmm0
    movss %xmm0, 16(%rax)
    movss b12(%rip), %xmm0
    movss %xmm0, 20(%rax)
    movss b20(%rip), %xmm0
    movss %xmm0, 24(%rax)
    movss b21(%rip), %xmm0
    movss %xmm0, 28(%rax)
    movss b22(%rip), %xmm0
    movss %xmm0, 32(%rax)*/
    push %rax # B
    movq %rax, %rbx
    # print int
    movq %rax, %rsi
    mov $format2, %rdi
    mov $0, %rax
    sub $8, %rsp
    call printf    
    add $8, %rsp

    # print int
    mov (%rsp), %rsi
    mov $format2, %rdi
    mov $0, %rax
    sub $8, %rsp
    call printf    
    add $8, %rsp

    movq $-1, %r12
    loopi:
        inc %r12
        cmp $9, %r12
        je continua
        mov $entradabeta, %rdi # pede ao usuário o valor de beta
        sub $8, %rsp
        call puts
        add $8, %rsp  
    /   
        sub $8, %rsp
        leaq 8(%rsp), %rax
        movq %rax, %rsi
        mov $entradafloat, %rdi
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

        jmp loopi

        


continua:
    pop %rax
    push %rbx

        mov (%rsp), %rsi
        mov $format2, %rdi
        mov $0, %rax
        sub $8, %rsp
        call printf    
        add $8, %rsp

        mov 8(%rsp), %rsi
        mov $format2, %rdi
        mov $0, %rax
        sub $8, %rsp
        call printf    
        add $8, %rsp        
    

    mov m(%rip), %eax
    imul %eax, %eax
    imul $4, %eax
    mov %eax, %edi
    call malloc

    movss a00(%rip), %xmm0
    movss %xmm0, (%rax)
    movss a01(%rip), %xmm0
    movss %xmm0, 4(%rax)
    movss a02(%rip), %xmm0
    movss %xmm0, 8(%rax)
    movss a10(%rip), %xmm0
    movss %xmm0, 12(%rax)
    movss a11(%rip), %xmm0
    movss %xmm0, 16(%rax)
    movss a12(%rip), %xmm0
    movss %xmm0, 20(%rax)
    movss a20(%rip), %xmm0
    movss %xmm0, 24(%rax)
    movss a21(%rip), %xmm0
    movss %xmm0, 28(%rax)
    movss a22(%rip), %xmm0
    movss %xmm0, 32(%rax)   
    push %rax # A


    mov $12, %rdi # espaço para 3 floats
    call malloc
    movss alpha(%rip), %xmm0
    movss %xmm0, (%rax)
    movss beta(%rip), %xmm0
    movss %xmm0, 4(%rax)
    movss null(%rip), %xmm0
    movss %xmm0, 8(%rax)
    push %rax

    movl n(%rip), %eax
    sub $4, %rsp
    movl %eax, (%rsp) # empilha o n
    movl m(%rip), %eax
    sub $4, %rsp
    movl %eax, (%rsp) # empilha o m
/*
    # print int
    mov (%rsp), %rsi
    mov $format2, %rdi
    mov $0, %rax
    sub $8, %rsp
    call printf    
    add $8, %rsp

/*
    # print float
    mov 8(%rsp), %rax
    movss (%rax), %xmm0 # teste print
    cvtss2sd %xmm0, %xmm0
    mov $format1, %rdi
    mov $1, %rax
    sub $16, %rsp
    call printf   
    add $16, %rsp */

    call symm

    mov 32(%rsp), %rax # copia o endereço de C


    mov %rax, 8(%rsp)

    mov $mmatrizC, %rdi
    sub $8, %rsp
    call puts
    add $8, %rsp

    call imprime_matriz


exit:
    mov $60, %rax
    xor %rdi, %rdi
    syscall

symm:
    push %rbp 
    mov %rsp, %rbp
    subq $16, %rsp                              # 8 + 8 + 8 + 4 + 4 + 4 + 4 + 8: reserva de espaço para variáveis
    mov 24(%rbp), %r10                        # pega o endereço base do vetor [alpha, beta, temp]

    movl $-1, -4(%rbp)                          # inicializa o índice i
    loop1_symm:
        incl -4(%rbp)                           # incrementa i
        mov -4(%rbp), %ecx                      # copia o índice i para %ecx, não é possível comparar dois endereços de memória diretamente
        cmpl 16(%rbp), %ecx                    # verifica se i < m
        je exit_symm
        movl $-1, -8(%rbp)                      # inicializa o índice j
        loop2.1_symm:
            incl -8(%rbp)                       # incrementa j
            mov -8(%rbp), %ecx                  # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
            cmpl 20(%rbp), %ecx                # verifica se j < n
            je loop1_symm                       # se for, sai fora desse loop
            #movq $0, 28(%rbp)                   # inicializa a variavel temp
            movq $0, 8(%r10)                   # inicializa a variavel temp
            movl $-1, -12(%rbp)                  # inicializa o índice k
            loop3_symm:
                incl -12(%rbp)                   # incrementa k
                mov -12(%rbp), %ecx              # copia o índice k para %ecx, não é possível comparar dois endereços de memória diretamente
                cmpl -4(%rbp), %ecx             # verifica se k < i
                je loop2.2_symm                 # se for, sai fora desse loop
                                                #################### calcula offset de A[i][k] ####################
                mov -4(%rbp), %eax              # guarda i em %eax (i é um inteiro de 32bits)
                imul 20(%rbp), %eax            # calcula (i * n) e guarda em %eax
                add -12(%rbp), %eax              # calcula [(i * n) + k] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 32(%rbp), %rax            # soma o offset ao endereço base de A, %rax tem o endereço exato do elemento A[i][k]
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento A[i][k] 
                movss (%rax), %xmm2             # copia feita para utilização posterior do elemento A[i][k]
                                                #################### calcula offset de B[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull 20(%rbp), %eax           # calcula (i * n) e guarda em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 40(%rbp), %rax            # %rax tem o endereço exato do elemento B[i][j]
                mulss (%rax), %xmm0             # %xmm0 tem A[i][k] * B[i][j]
                #mulss -20(%rbp), %xmm0          # xmm0 tem A[i][k] * B[i][j] * alpha
                mulss (%r10), %xmm0          # xmm0 tem A[i][k] * B[i][j] * alpha
                                                #################### calcula offset de C[k][j] ####################
                movl -12(%rbp), %eax             # guarda k em %eax
                imull 20(%rbp), %eax           # calcula (k * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 48(%rbp), %rax            # %rax tem o endereço do elemento C[k][j]    
                movss (%rax), %xmm1             # copia o elemento C[k][j] para o registrador %xmm1
                addss %xmm0, %xmm1              # soma (A[i][k] * B[i][j] * alpha) com C[k][j]
                movss %xmm1, (%rax)             # atualiza o valor de C[k][j] com seu novo valor
                                                #################### calcula offset de B[k][j] ####################
                movl -12(%rbp), %eax             # guarda k em %eax
                imull 20(%rbp), %eax           # calcula (k * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 40(%rbp), %rax            # %rax tem o endereço do elemento B[k][j]   
                movss (%rax), %xmm0             # %xmm0 tem o elemento B[i][k]
                mulss %xmm2, %xmm0              # calcula A[i][k] * B[i][k] e coloca em %xmm0
                #movss 28(%rbp), %xmm1           # %xmm1 tem o valor da variável temp
                movss 8(%r10), %xmm1           # %xmm1 tem o valor da variável temp
                addss %xmm1, %xmm0              # calcula temp + A[i][k] * B[i][k] 
                #movss %xmm0, 28(%rbp)           # escreve o resultado da operação anterior na própria variável temp
                movss %xmm0, 8(%r10)           # escreve o resultado da operação anterior na própria variável temp
                jmp loop3_symm

        loop2.2_symm:                           #C[i][j] = beta * C[i][j] + alpha * B[i][j] * A[i][i] + alpha * temp1;
                                                #################### calcula offset de C[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull 20(%rbp), %eax           # calcula (i * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 48(%rbp), %rax            # %rax tem o endereço do elemento C[i][j]   
                movq %rax, %rbx                 # copia %rax para %rbx para usar posteriormente
                movss (%rax), %xmm0             # desreferenciação %xmm0 tem o elemento C[i][j] 
                
                #mulss -24(%rbp), %xmm0          # faz a operação beta * C[i][j] 
                mulss 4(%r10), %xmm0             # faz a operação beta * C[i][j] 
                movss (%rax), %xmm1             # desreferenciação %xmm1 tem o elemento C[i][j] 
                addss %xmm1, %xmm0              # %xmm0 tem beta * C[i][j] + C[i][j] 
                movss %xmm0, (%rax)             # atualiza o valor de C[i][j] em seu endereço
                                                #################### calcula offset de B[i][j] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull 20(%rbp), %eax           # calcula (i * n) e armazena em %eax
                addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq 40(%rbp), %rax            # %rax tem o endereço do elemento B[i][j] 
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento B[i][j]
                #mulss -20(%rbp), %xmm0          # calcula alpha * B[i][j]
                mulss (%r10), %xmm0            # calcula alpha * B[i][j]
                                                #################### calcula offset de A[i][i] ####################
                movl -4(%rbp), %eax             # guarda i em %eax
                imull 20(%rbp), %eax           # calcula (i * n) e guarda em %eax
                addl -4(%rbp), %eax             # calcula [(i * n) + i] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq  32(%rbp), %rax            # agora, %rax tem o endereço exato do elemento A[i][i]
                movss (%rax), %xmm1             # desreferenciação, %xmm1 tem o elemento A[i][i]
                mulss %xmm1, %xmm0              # %xmm0 tem A[i][i] * alpha * B[i][j]
                movss (%rbx), %xmm1             # %xmm1 tem o elemento C[i][j]
                addss %xmm1, %xmm0              # faz a operação A[i][i] * alpha * B[i][j] + C[i][j] e armazena em %xmm0
                movss %xmm0, (%rbx)             # salva o resultado da operação anteriro                
                                                ####################### calcula alpha * temp ######################
                #movss -20(%rbp), %xmm1          # %xmm0 tem alpha
                movss (%r10), %xmm1          # %xmm0 tem alpha
                #mulss 28(%rbp), %xmm1           # alpha * temp
                mulss 8(%r10), %xmm1           # alpha * temp
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
    mov 24(%rsp), %rsi
    mov $format2, %rdi
    mov $0, %rax
    sub $8, %rsp
    call printf    
    add $8, %rsp    
    subq $8, %rsp # reserva espaço para i, j, 
    movl $-1, -4(%rbp)                          # inicializa o índice i
    loopi_imprime:

        incl -4(%rbp)                           # incrementa i
        mov -4(%rbp), %ecx                      # copia o índice i para %ecx, não é possível comparar dois endereços de memória diretamente
        cmpl 16(%rbp), %ecx                    # verifica se i < m
        je exit_imprime

        movl $-1, -8(%rbp)                      # inicializa o índice j
        loopj_imprime:
            incl -8(%rbp)                       # incrementa j
            mov -8(%rbp), %ecx                  # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
            cmpl 20(%rbp), %ecx                # verifica se j < n
            je loopi2_imprime  
            movl -4(%rbp), %eax             # guarda i em %eax
            imull 20(%rbp), %eax           # calcula (i * n) e guarda em %eax
            addl -8(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
            cltq                            # transforma %eax que um int64
            imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
            addq 24(%rbp), %rax            # %rax tem o endereço exato do elemento M[i][j]
            movss (%rax), %xmm0             # %xmm0 tem M[i][J]
            cvtss2sd %xmm0, %xmm0
            #push %rbp
            mov $floatf, %rdi
            mov $1, %rax
            #mov %rsp, %rbp
            sub $8, %rsp
            call printf   
            #pop %rbp
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

