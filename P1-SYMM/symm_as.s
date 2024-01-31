.global symm 

.text

exit:
    mov %rbp, %rsp
    pop %rbp
    xor %rax, %rax
    ret

symm:
    push %rbp 
    mov %rsp, %rbp
    subq $48, %rsp                              # 8 + 8 + 8 + 4 + 4 + 4 + 4 + 8: reserva de espaço para variáveis
    movl $-1, 32(%rbp)                          # inicializa o índice i
    loop1_symm:
        incl 32(%rbp)                           # incrementa i
        mov 32(%rbp), %ecx                      # copia o índice i para %ecx, não é possível comparar dois endereços de memória diretamente
        cmpl -12(%rbp), %ecx                    # verifica se i < m
        je exit
        movl $-1, 36(%rbp)                      # inicializa o índice j
        loop2.1_symm:
            incl 36(%rbp)                       # incrementa j
            mov 36(%rbp), %ecx                  # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
            cmpl -16(%rbp), %ecx                # verifica se j < n
            je loop1_symm                       # se for, sai fora desse loop
            movq $0, 28(%rbp)                   # inicializa a variavel temp
            movl $-1, 40(%rbp)                  # inicializa o índice k
            loop3_symm:
                incl 40(%rbp)                   # incrementa k
                mov 40(%rbp), %ecx              # copia o índice j para %ecx, não é possível comparar dois endereços de memória diretamente
                cmpl 32(%rbp), %ecx             # verifica se k < i
                je loop2.2_symm                 # se for, sai fora desse loop
                                                #################### calcula offset de A[i][k] ####################
                mov 32(%rbp), %eax              # guarda i em %eax (i é um inteiro de 32bits)
                imul -16(%rbp), %eax            # calcula (i * n) e guarda em %eax
                add 40(%rbp), %eax              # calcula [(i * n) + k] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -32(%rbp), %rax            # soma o offset ao endereço base de A, %rax tem o endereço exato do elemento A[i][k]
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento A[i][k] 
                movss (%rax), %xmm2             # copia feita para utilização posterior do elemento A[i][k]
                                                #################### calcula offset de B[i][j] ####################
                movl 32(%rbp), %eax             # guarda i em %eax
                imull -16(%rbp), %eax           # calcula (i * n) e guarda em %eax
                addl 36(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -40(%rbp), %rax            # %rax tem o endereço exato do elemento B[i][j]
                mulss (%rax), %xmm0             # %xmm0 tem A[i][k] * B[i][j]
                mulss -20(%rbp), %xmm0          # xmm0 tem A[i][k] * B[i][j] * alpha
                                                #################### calcula offset de C[k][j] ####################
                movl 40(%rbp), %eax             # guarda k em %eax
                imull -16(%rbp), %eax           # calcula (k * n) e armazena em %eax
                addl 36(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -48(%rbp), %rax            # %rax tem o endereço do elemento C[k][j]    
                movss (%rax), %xmm1             # copia o elemento C[k][j] para o registrador %xmm1
                addss %xmm0, %xmm1              # soma (A[i][k] * B[i][j] * alpha) com C[k][j]
                movss %xmm1, (%rax)             # atualiza o valor de C[k][j] com seu novo valor
                                                #################### calcula offset de B[k][j] ####################
                movl 40(%rbp), %eax             # guarda k em %eax
                imull -16(%rbp), %eax           # calcula (k * n) e armazena em %eax
                addl 36(%rbp), %eax             # calcula [(k * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -40(%rbp), %rax            # %rax tem o endereço do elemento B[k][j]   
                movss (%rax), %xmm0             # %xmm0 tem o elemento B[i][k]
                mulss %xmm2, %xmm0              # calcula A[i][k] * B[i][k] e coloca em %xmm0
                movss 28(%rbp), %xmm1           # %xmm1 tem o valor da variável temp
                addss %xmm1, %xmm0              # calcula temp + A[i][k] * B[i][k] 
                movss %xmm0, 28(%rbp)           # escreve o resultado da operação anterior na própria variável temp

        loop2.2_symm:                           #C[i][j] = beta * C[i][j] + alpha * B[i][j] * A[i][i] + alpha * temp1;
                                                #################### calcula offset de C[i][j] ####################
                movl 32(%rbp), %eax             # guarda i em %eax
                imull -16(%rbp), %eax           # calcula (i * n) e armazena em %eax
                addl 36(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -48(%rbp), %rax            # %rax tem o endereço do elemento C[i][j]   
                movq %rax, %rbx                 # copia %rax para %rbx para usar posteriormente
                movss (%rax), %xmm0             # desreferenciação %xmm0 tem o elemento C[i][j] 
                mulss -24(%rbp), %xmm0          # faz a operação beta * C[i][j] 
                movss (%rax), %xmm1             # desreferenciação %xmm1 tem o elemento C[i][j] 
                addss %xmm1, %xmm0              # %xmm0 tem beta * C[i][j] + C[i][j] 
                movss %xmm0, (%rax)             # atualiza o valor de C[i][j] em seu endereço
                                                #################### calcula offset de B[i][j] ####################
                movl 32(%rbp), %eax             # guarda i em %eax
                imull -16(%rbp), %eax           # calcula (i * n) e armazena em %eax
                addl 36(%rbp), %eax             # calcula [(i * n) + j] e guarda em %eax
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -40(%rbp), %rax            # %rax tem o endereço do elemento B[i][j] 
                movss (%rax), %xmm0             # desreferenciação, %xmm0 tem o elemento B[i][j]
                mulss -20(%rbp), %xmm0          # calcula alpha * B[i][j]
                                                #################### calcula offset de A[i][i] ####################
                movl 32(%rbp), %eax             # guarda i em %eax
                imull -16(%rbp), %eax           # calcula (i * n) e guarda em %eax
                addl 32(%rbp), %eax             # calcula [(i * n) + i] e guarda em aux1
                cltq                            # transforma %eax que um int64
                imulq $4, %rax                  # multiplica o offset %rax por 4, já que cada float ocupa 4 bytes
                addq -32(%rbp), %rax            # agora, %rax tem o endereço exato do elemento A[i][i]
                movss (%rax), %xmm1             # desreferenciação, %xmm1 tem o elemento A[i][i]
                mulss %xmm1, %xmm0              # %xmm0 tem A[i][i] * alpha * B[i][j]
                movss (%rbx), %xmm1             # %xmm1 tem o elemento C[i][j]
                addss %xmm1, %xmm0              # faz a operação A[i][i] * alpha * B[i][j] + C[i][j] e armazena em %xmm0
                movss %xmm0, (%rbx)             # salva o resultado da operação anteriro                
                                                ####################### calcula alpha * temp ######################
                movss -20(%rbp), %xmm1          # %xmm0 tem alpha
                mulss 28(%rbp), %xmm1           # alpha * temp
                addss %xmm1, %xmm0              # soma alpha * temp com C[i][j] 
                addss %xmm0, (%rbx)             # armazena em C[i][j]

                jmp loop1_symm  

              
