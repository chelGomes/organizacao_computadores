# Michel Gomes de Andrade - 201876037

.data
    msgSoma:    .asciiz    "Soma: "
.text 

main:
  
    addi    $sp, $sp, -80    #alocando 80 byte na pilha para o vetor
    
   
    move    $s0, $sp        #salvando na variavel vet[] o endereço do vetor, $s0 vet[]
    li      $s1, 0          # soma = 0
    
  
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    li      $a2, 71         # Terceiro parâmetro: 71
    jal     inicializaVetor #chamada da funcao iniciliza
    move    $s1, $v0        # Guarda o retorno da função em soma
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    
    # ordenaVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     ordenaVetor     # Chama a função ordenaVetor
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    
    # zeraVetor
    move    $a0, $s0        # Primeiro parâmetro: &vet[0]
    addi    $a1, $s0, 80    # Segundo parâmetro: &vet[20]
    jal     zeraVetor       # Chama a função zeraVetor
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro parâmetro: vet
    li      $a1, 20         # Segundo parâmetro: SIZE
    jal     imprimeVetor    # Chama a função imprimeVetor
    
     # Impressão em tela: printf("Soma: %d\n", soma);
    li      $v0, 4          # Código 4 para impressão de string
    la      $a0, msgSoma    # Primeiro parâmetro: endereço da string "Soma: "
    syscall
    li      $v0, 1          # Código 1 para impressão de inteiro
    move    $a0, $s1        # Primeiro parâmetro: soma ($s1)
    syscall
    li      $v0, 11         # Código 11 para impressão de caractere
    li      $a0, 10         # Primeiro parâmetro: \n (ASCII)
    syscall
    
    # Libera espaço na pilha
    addi    $sp, $sp, 80    # Libera os 80 bytes alocados pela função

    # Fim do programa
    li      $v0, 17         # Código 17 para exit com valor de retorno
    li      $a0, 0          # Primeiro parâmetro: valor de retorno 0
    syscall 


zeraVetor:
    
    zeraVetorLoop:
        bge    $a0, $a1, zeraVetorEnd    # Se inicio >= fim vai para zeraFim
        addi   $a0, $a0, 4         #inicio ++
        sw     $zero, 0($a0)       # salva valor 0 no endereço apontado por inicio
        #addi   $a0, $a0, 4        # inicio ++
        j      zeraVetorLoop       # Repete o laço
    
   zeraVetorEnd:
        jr      $ra             # Retorna
    

imprimeVetor:
  
    addi $sp, $sp, -16   # 16 bytes 
    nop
    sw   $ra, 0($sp)     # salva $ra 
    sw   $s0, 4($sp)     # salva $s0 
    sw   $s1, 8($sp)     # salva $s1 
    sw   $s2, 12($sp)    # salva $s2 
    
    move  $s0, $a0    # vet salvo em $s0
    move  $s1, $a1    # tam salvo em $s1
    li    $s2, 0      # i = 0 em $s2
    
imprimeLoop:
        beq  $s2, $s1, imprimeEnd    # Se i == tam vai para imprimeEnd
        sll  $t0, $s2, 2         # $t0 = i * 4
        add  $t0, $s0, $t0       # $t0 = &vet[i]
        
        li  $v0, 1        # Código 1 para impressão de inteiro
        lw  $a0, 0($t0)   # Primeiro parâmetro: vet[i]
        syscall
    
        li  $v0, 11     # Código 11 para impressão de caractere
        li  $a0, 32     # Primeiro parâmetro: " " (espaço)
        syscall
    
        addi  $s2, $s2, 1  # i++
        nop
        j  imprimeLoop  # repete o laço
                
imprimeEnd:
    li  $v0, 11   # Código 11 para impressão de caractere
    li  $a0, 10   # Primeiro parâmetro: \n
    syscall
    
    lw   $ra, 0($sp)     # restaura $ra 
    lw   $s0, 4($sp)     # restaura $s0 
    lw   $s1, 8($sp)     # restaura $s1 
    lw   $s2, 12($sp)    # restaura $s2 
    addi $sp, $sp, 16    # Libera os 16 bytes alocados
    nop 
    
  
    jr  $ra   # return voltar para o main
    

inicializaVetor:
   
    addi $sp, $sp, -20   # 20 bytes para $ra, $s0, $s1, $s2 e $s3
    sw   $ra, 0($sp)     # salva $ra 
    sw   $s0, 4($sp)     # salva $s0 
    sw   $s1, 8($sp)     # salva $s1 
    sw   $s2, 12($sp)    # salva $s2 
    sw   $s3, 16($sp)    # salva $s3 

    move  $s0, $a0    # Parâmetro vet salvo em $s0
    move  $s1, $a1    # Parâmetro tamanho salvo em $s1
    move  $s2, $a2    # Parâmetro ultimoValor salvo em $s2
    li    $s3, 0      # novoValor = 0

    move  $v0, $zero   # Prepara valor de retorno 0
    #ble   $s1, $zero, inicializaEnd   # Se tamanho <= 0 vai para inicializaEnd
    
    move  $a0, $s2        # Primeiro parâmetro: ultimoValor
    li    $a1, 47         # Segundo parâmetro: 47    
    li    $a2, 97         # Terceir parâmetro: 97
    li    $a3, 337        # Quarto parâmetro: 337
    
    addi  $sp, $sp, -4    # Aloca 4 na pilha
    li    $t0, 3          # $t0 = 3
    sw    $t0, 0($sp)     # Quinto parâmetro: 3    
    jal   valorAleatorio
    addi  $sp, $sp, 4     # Libera 4 bytes na pilha 
    
    move  $s3, $v0        # novoValor = $v0 (retorno da função valorAleatorio)
    
    ble   $s1, $zero, inicializaEnd   # Se tamanho <= 0 vai para inicializaEnd
    addi  $t0, $s1, -1    # $t0 = tamanho - 1
    sll   $t0, $t0, 2     # $t0 = (tamanho - 1) * 4
    add   $t0, $s0, $t0   # $t0 = &vet[tamanho - 1]
    sw    $s3, 0($t0)     # vet[tamanho - 1] = novoValor
    
    move  $a0, $s0        # Primeiro parâmetro: vet
    addi  $a1, $s1, -1    # Segundo parâmetro: tamanho - 1
    move  $a2, $s3        # Terceiro parâmetro: novoValor
    jal   inicializaVetor
    
    
    add  $v0, $v0, $s3   # Prepara valor de retorno novoValor + retorno da recursão 

inicializaEnd:
   
    lw   $ra, 0($sp)     # restaura $ra 
    lw   $s0, 4($sp)     # restaura $s0 
    lw   $s1, 8($sp)     # restaura $s1 
    lw   $s2, 12($sp)    # restaura $s2 
    lw   $s3, 16($sp)    # restaura $s3 
    addi $sp, $sp, 20    # Libera os 20 bytes alocados
    nop
    
  
    jr $ra   # return voltar para o main
    

ordenaVetor:
  
    addi  $sp, $sp, -24   # 24 bytes 
    nop
    sw    $ra, 0($sp)     # salva $ra 
    sw    $s0, 4($sp)     # salva $s0 
    sw    $s1, 8($sp)     # salva $s1 
    sw    $s2, 12($sp)    # salva $s2 
    sw    $s3, 16($sp)    # salva $s3 
    sw    $s4, 20($sp)    # salva $s4 

   
    move  $s0, $a0    # Parâmetro vet salvo em $s0
    move  $s1, $a1    # Parâmetro n salvo em $s1
    li    $s2, 0      # i = 0
    li    $s3, 0      # j = 0
    li    $s4, 0      # min_idx = 0
    
    li $s2, 0   # i = 0
    
    #ordenaFor1:
       # addi $t0, $s1, -1          # $t0 = n - 1
        #bge  $s2, $t0, ordenaEnd1  # Se i >= n - 1 
        #move $s4, $s2              # min_idx = i
    
       
        #addi  $s3, $s2, 1             # j = i + 1
        
        #ordenaFor2:
            #bge $s3, $s1, ordenaEnd2    # Se j >= n vai para ordenaEnd2
                    
            #sll  $t0, $s3, 2     # $t0 = j * 4
            #add  $t0, $s0, $t0   # $t0 = &vet[j]
            #lw   $t0, 0($t0)     # $t0 = vet[j]

            #sll  $t1, $s4, 2     # $t1 = min_idx * 4
            #add  $t1, $s0, $t1   # $t1 = &vet[min_idx]
            #lw   $t1, 0($t1)     # $t1 = vet[min_idx]
            
    ordenaFor1:
    	    addi  $t0, $s1, -1            # $t0 = n - 1
            bge   $s2, $t0, ordenaEnd1    # Se i >= n - 1 vai para ordenaEnd1
            move  $s3, $s2                # $s3 = i
            addi  $s2, $s2, 1             # Incrementa i++
            j    ordenaFor2              # Pula para o próximo laço

    ordenaFor2:
           blt  $s3, $s1, ordenaFor3    # Se i < n vai para ordenaFor3
           j    ordenaEnd2              # Pula para o próximo laço

    ordenaFor3:
            sll  $t0

            
            bge  $t0, $t1, sortIf1End    # Se vet[j] >= vet[min_idx] vai para sortIf1Fim
            move $s4, $s3                # min_idx = j                        
            
    sortIf1End:
            addi  $s3, $s3, 1   # j++
            j    ordenaFor2    # Repete o laço interno
        
    ordenaEnd2:
      
        beq  $s4, $s2, ordenaIfEnd  # Se min_idx == i vai para ordenaIfFim
        
        sll  $t0, $s4, 2      # $t0 = min_idx * 4
        add  $a0, $s0, $t0    # Primeiro parâmetro: &vet[min_idx]
        sll  $t0, $s2, 2      # $t0 = i * 4
        add  $a1, $s0, $t0   # Segundo parâmetro: &vet[i]
        jal  troca
        
     ordenaIfEnd:
        addi $s2, $s2, 1    # i++
        j   ordenaFor1     # Repete o laço externo
    
    ordenaEnd1:
    
    	lw  $ra, 0($sp)     # restaura $ra 
    	lw  $s0, 4($sp)     # restaura $s0 
    	lw  $s1, 8($sp)     # restaura $s1 
    	lw  $s2, 12($sp)    # restaura $s2 
    	lw  $s3, 16($sp)    # restaura $s3 
    	lw  $s4, 20($sp)    # restaura $s4 
    	addi    $sp, $sp, 24    # Libera os 24 bytes alocados pela função
    
  
    	jr  $ra   # return voltar para o main
                  
troca:
    beq  $a0, $a1, trocaEnd  # Se a == b vai para trocaEnd
    
    lw   $t0, 0($a0)  # $t0 = *a
    lw   $t1, 0($a1)  # $t1 = *b
    sw   $t1, 0($a0)  # *a = $t1
    sw   $t0, 0($a1)  # *b = $t0
    
trocaEnd:
    
    jr $ra  # return voltar para o main
                      
                                                                                                                                                                                                                                                          
valorAleatorio:
    lw  $t0, 0($sp) # $t0 = e
    
    mul  $v0, $a0, $a1   # $v0 = a * b
    add  $v0, $v0, $a2   # $v0 = a * b + c
    div  $v0, $a3        # hi = (a * b + c) % d
    mfhi $v0             # $v0 = hi
    sub  $v0, $v0, $t0   # $v0 = (a * b + c) % d - e
        
    jr $ra  # return voltar para o main
