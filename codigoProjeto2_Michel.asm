# Michel Gomes de Andrade - 201876037

.data
    msgSoma:    .asciiz    "Soma: "
.text 

main:
  
    addi    $sp, $sp, -80    #alocando 80 byte na pilha para o vetor
    
   
    move    $s0, $sp        #salvando na variavel vet[] o endere�o do vetor, $s0 vet[]
    li      $s1, 0          # soma = 0
    
  
    move    $a0, $s0        # Primeiro par�metro: vet
    li      $a1, 20         # Segundo par�metro: SIZE
    li      $a2, 71         # Terceiro par�metro: 71
    jal     inicializaVetor #chamada da funcao iniciliza
    move    $s1, $v0        # Guarda o retorno da fun��o em soma
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro par�metro: vet
    li      $a1, 20         # Segundo par�metro: SIZE
    jal     imprimeVetor    # Chama a fun��o imprimeVetor
    
    # ordenaVetor
    move    $a0, $s0        # Primeiro par�metro: vet
    li      $a1, 20         # Segundo par�metro: SIZE
    jal     ordenaVetor     # Chama a fun��o ordenaVetor
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro par�metro: vet
    li      $a1, 20         # Segundo par�metro: SIZE
    jal     imprimeVetor    # Chama a fun��o imprimeVetor
    
    # zeraVetor
    move    $a0, $s0        # Primeiro par�metro: &vet[0]
    addi    $a1, $s0, 80    # Segundo par�metro: &vet[20]
    jal     zeraVetor       # Chama a fun��o zeraVetor
    
    # imprimeVetor
    move    $a0, $s0        # Primeiro par�metro: vet
    li      $a1, 20         # Segundo par�metro: SIZE
    jal     imprimeVetor    # Chama a fun��o imprimeVetor
    
     # Impress�o em tela: printf("Soma: %d\n", soma);
    li      $v0, 4          # C�digo 4 para impress�o de string
    la      $a0, msgSoma    # Primeiro par�metro: endere�o da string "Soma: "
    syscall
    li      $v0, 1          # C�digo 1 para impress�o de inteiro
    move    $a0, $s1        # Primeiro par�metro: soma ($s1)
    syscall
    li      $v0, 11         # C�digo 11 para impress�o de caractere
    li      $a0, 10         # Primeiro par�metro: \n (ASCII)
    syscall
    
    # Libera espa�o na pilha
    addi    $sp, $sp, 80    # Libera os 80 bytes alocados pela fun��o

    # Fim do programa
    li      $v0, 17         # C�digo 17 para exit com valor de retorno
    li      $a0, 0          # Primeiro par�metro: valor de retorno 0
    syscall 


zeraVetor:
    
    zeraVetorLoop:
        bge    $a0, $a1, zeraVetorEnd    # Se inicio >= fim vai para zeraFim
        addi   $a0, $a0, 4         #inicio ++
        sw     $zero, 0($a0)       # salva valor 0 no endere�o apontado por inicio
        #addi   $a0, $a0, 4        # inicio ++
        j      zeraVetorLoop       # Repete o la�o
    
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
        
        li  $v0, 1        # C�digo 1 para impress�o de inteiro
        lw  $a0, 0($t0)   # Primeiro par�metro: vet[i]
        syscall
    
        li  $v0, 11     # C�digo 11 para impress�o de caractere
        li  $a0, 32     # Primeiro par�metro: " " (espa�o)
        syscall
    
        addi  $s2, $s2, 1  # i++
        nop
        j  imprimeLoop  # repete o la�o
                
imprimeEnd:
    li  $v0, 11   # C�digo 11 para impress�o de caractere
    li  $a0, 10   # Primeiro par�metro: \n
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

    move  $s0, $a0    # Par�metro vet salvo em $s0
    move  $s1, $a1    # Par�metro tamanho salvo em $s1
    move  $s2, $a2    # Par�metro ultimoValor salvo em $s2
    li    $s3, 0      # novoValor = 0

    move  $v0, $zero   # Prepara valor de retorno 0
    #ble   $s1, $zero, inicializaEnd   # Se tamanho <= 0 vai para inicializaEnd
    
    move  $a0, $s2        # Primeiro par�metro: ultimoValor
    li    $a1, 47         # Segundo par�metro: 47    
    li    $a2, 97         # Terceir par�metro: 97
    li    $a3, 337        # Quarto par�metro: 337
    
    addi  $sp, $sp, -4    # Aloca 4 na pilha
    li    $t0, 3          # $t0 = 3
    sw    $t0, 0($sp)     # Quinto par�metro: 3    
    jal   valorAleatorio
    addi  $sp, $sp, 4     # Libera 4 bytes na pilha 
    
    move  $s3, $v0        # novoValor = $v0 (retorno da fun��o valorAleatorio)
    
    ble   $s1, $zero, inicializaEnd   # Se tamanho <= 0 vai para inicializaEnd
    addi  $t0, $s1, -1    # $t0 = tamanho - 1
    sll   $t0, $t0, 2     # $t0 = (tamanho - 1) * 4
    add   $t0, $s0, $t0   # $t0 = &vet[tamanho - 1]
    sw    $s3, 0($t0)     # vet[tamanho - 1] = novoValor
    
    move  $a0, $s0        # Primeiro par�metro: vet
    addi  $a1, $s1, -1    # Segundo par�metro: tamanho - 1
    move  $a2, $s3        # Terceiro par�metro: novoValor
    jal   inicializaVetor
    
    
    add  $v0, $v0, $s3   # Prepara valor de retorno novoValor + retorno da recurs�o 

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

   
    move  $s0, $a0    # Par�metro vet salvo em $s0
    move  $s1, $a1    # Par�metro n salvo em $s1
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
            j    ordenaFor2              # Pula para o pr�ximo la�o

    ordenaFor2:
           blt  $s3, $s1, ordenaFor3    # Se i < n vai para ordenaFor3
           j    ordenaEnd2              # Pula para o pr�ximo la�o

    ordenaFor3:
            sll  $t0

            
            bge  $t0, $t1, sortIf1End    # Se vet[j] >= vet[min_idx] vai para sortIf1Fim
            move $s4, $s3                # min_idx = j                        
            
    sortIf1End:
            addi  $s3, $s3, 1   # j++
            j    ordenaFor2    # Repete o la�o interno
        
    ordenaEnd2:
      
        beq  $s4, $s2, ordenaIfEnd  # Se min_idx == i vai para ordenaIfFim
        
        sll  $t0, $s4, 2      # $t0 = min_idx * 4
        add  $a0, $s0, $t0    # Primeiro par�metro: &vet[min_idx]
        sll  $t0, $s2, 2      # $t0 = i * 4
        add  $a1, $s0, $t0   # Segundo par�metro: &vet[i]
        jal  troca
        
     ordenaIfEnd:
        addi $s2, $s2, 1    # i++
        j   ordenaFor1     # Repete o la�o externo
    
    ordenaEnd1:
    
    	lw  $ra, 0($sp)     # restaura $ra 
    	lw  $s0, 4($sp)     # restaura $s0 
    	lw  $s1, 8($sp)     # restaura $s1 
    	lw  $s2, 12($sp)    # restaura $s2 
    	lw  $s3, 16($sp)    # restaura $s3 
    	lw  $s4, 20($sp)    # restaura $s4 
    	addi    $sp, $sp, 24    # Libera os 24 bytes alocados pela fun��o
    
  
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
