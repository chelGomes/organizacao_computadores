#Alunos: Michel Gomes de Andrade e Rayane Moraes da Silva

.data
	msg: .asciiz "\n"

.text 

main:
        addi $sp, $sp, -80  #alocando 80 byte na pilha para o vetor
        move $s0, $sp   #salvando na variavel vet[] o endereço do vetor, $s0 vet[]
        move $a0, $s0   # primeiro parametro vet 
        addi  $a1, $a0, 80  #segundo parametro eh o fim do vet[20]
        jal   zeraVetor  #chamada da funcao
        
        #preprarar aqui parametros da funcao
        move $a0, $s0   # primeiro parametro vet 
        li   $a1, 20    #segundo parametro tamanho do vetor
        li   $a2, 71    #terceiro parametro da funcao
        jal inicializaVetor #chamada da funcao iniciliza
        
        move $s1, $v0 #soma = retorno da funcao
        
   	#preprarar aqui parametros da funcao
        move $a0, $s0   # primeiro parametro vet 
        li   $a1, 20    #segundo parametro tamanho do vetor
        jal imprimeVetor  
        
        #imprimir a soma
        li $v0, 1 
        move $a0, $s1
        syscall
        
        move $a0, $s0   # primeiro parametro vet 
        li   $a1, 20    #segundo parametro tamanho do vetor
        jal imprimeVetor
        
        #imprime quebra de linha
        li $v0, 4
	la $a0, msg
	syscall
        
        move $a0, $s0   # primeiro parametro vet 
        li   $a1, 20    #segundo parametro tamanho do vetor
        jal imprimeVetor

       #imprime o ordenaVetor
     
        li      $a1, 20    #segundo parametro tamanho do vetor               
        move    $a0, $s0   # primeiro parametro vet 
        syscall
        jal     ordenaVetor
        
        li $v0, 17  #codigo para o fim do programa
        li $a0, 0   #valor do retorno zero
        syscall 
        

zeraVetor:
	add $t1, $a0, $zero   # $t1 = &inicio
	move $t2, $a1   #$t2 =  &fim
	
loop:
	bge $t1, $t2, zeraVetorFim  # se inicio >= fim vai para o fim
	li $t5, 4
	sw $t5, 0($t1)  # *inicio = 0
	#sw $zero,0($t1)  # *inicio = 0
	addi $t1, $t1, 4  # inicio ++
	j loop            # repeticao
	
zeraVetorFim:
       jr $ra # return voltar para o main
       
inicializaVetor:
         # caso base
	blez $a1, retorna # se $a1 for menor ou igual a 0, vai para retorna
	
	#valorAleatorio
	addi $t0, $zero, 47 # $t0 = 47, b = 47
	addi $t1, $zero, 337 # $t2 = 337, d = 337
	
	mult $a2, $t0 # $a2 * $t0, a * b, $a2 = a 
	mflo $t2 # $t2 = $a2 * $t0
	
	addi $t2, $t2, 97 # $t2 = $t2 + 97, a * b + c
	
	div $t2, $t1 # hi = $t2 % t1, (a * b + c) % d
	mfhi $t2 # $t2 = hi
	
	subi $t2, $t2, 3 # $t2 = $t2 - 3,(a * b + c) % d - e
	
	add $t3, $a0, $a1 # $t3 = $a0 + $a1, endereco da posicao final do vetor, vet[TAM]
	subi $t3, $t3, 4 # $t3 = $t3 - 4, endereco da ultima posicao do vetor
	 
	sw $t2, 0($t3) # guardar o valor de $t2 na ultima posicao do vetor
	
	subi $a1, $a1, 4 # $a1 = $a1 - 4, atualiza o $a1 (tam-1)
	move $a2, $t2 # $a2 = $t2, atualiza o $a2, ultimoValor
	
	add $v0, $v0, $t2 # $v0 = $v0 + $t2, atualiza $v0, somar todos os valores
	j inicializaVetor # chama o inicializaVetor com o valores dos parametros atualizados ( o primeiro sendo o vetor, o segundo sendo tam-1, o terceiro o valor aleatorio)
	
	jr $ra # retorna

retorna:
	add $v0, $v0, 0 # $v0 = $v0 + 0
	jr $ra # retorna
	
imprimeVetor:
	li $t0, 0 # $t0 = 0, i = 0
	move $t3, $a0 # $t3 = $a0, valor do vet
	
loopp:
	bge $t0, $a1, end # se $t0 >= $a1, se i >= tamanho, vai para end
	sll $t1, $t0, 2 # $t1 = $t0 * 4, i * 4
	
	add $t2, $t1, $t3 # $t2 = $t1 + $t3, valor de vet[i]
	
	lw $t4, 0($t2) # le o valor $t2
	
	li $v0, 1 # código para imprimir um inteiro
	move $a0, $t4 # $a0 é o registrador que irá conter o valor a ser impresso
	syscall	# executa a chamado do SO para imprimir
	
	li $v0, 4 # código para imprimir um caractere
	la $a0, msg # $a0 = msg
	syscall # executa a chamado do SO para imprimir
	
	addi $t0, $t0, 1 # $t0 = $t0 + 1, i += 1
	j loopp # vai para loopp
	
end:
	jr $ra # retorna


troca:
     addi $sp,$sp, -12     #alocando a pilha no vetor
     add  $t3, $a0, $zero  # $t3 = &a
     move $t4, $a1   	   # $t4 =  &b
     beq  $t3, $t4, trocaFim  # se a == b vai para o fim
     
     sw    $ra, 8($sp)   # salva $ra
     sw    $s0, 4($sp)   # salva $s0
     sw    $s1, 0($sp)   # salva $s1
     lw    $s0, 0($sp)   # restaura $s0 
     lw    $s1, 4($sp)   # restaura $s1
     lw    $ra, 8($sp)   # restaura $ra
     
trocaFim:
    jr $ra # return voltar para o main

 
ordenaVetor: 
	addi $sp, $sp, -28  #alocando a pilha no vetor
	sw   $ra, 24($sp)   # salva $rs
	sw   $s0, 20($sp)   # salva $s0
	sw   $s1, 16($sp)   # salva $s1
	sw   $s2, 12($sp)    # salva $s2
	sw   $s3, 8($sp)    # salva $s3
	sw   $s4, 4($sp)    # salva $s4
	sw   $s5, 0($sp)    # salva $s5	
	
	lw   $s0, 0($sp)    # restaura $s0
	lw   $s1, 4($sp)    # restaura $s1
	lw   $s2, 8($sp)    # restaura $s2
	lw   $s3, 12($sp)   # restaura $s3
	lw   $s4, 16($sp)   # restaura $s4
	lw   $s5, 20($sp)   # restaura $s5
	lw   $ra, 24($sp)   # restaura $ra
	
	add $t3, $s2, $zero # $t3 = i
	add $t4, $s3, $zero # $t4 = j
	add $t5, $s4, $zero # $t5 = min_ind
	
loopFor1:
        move $s3,$s2 # salva o min_ind
	addi $s3, $s2, 1  # j = i + 1
	
loopOrdenaVetor:	
	bge $t3, $s2, end1 # se i >= n vai para end1
	#addi $s3, $s2, 1  # j = i + 1
	
        addi $t6, $zero, 4  # min_ind * 4
        mult $t5, $s4   # $t5 * $s4
	lw $t5, 0($t5) # $t5 = vet[min_ind]
	addi $t6, $zero, 4   # j * 4
        mult $t4, $s3  # $t4 * $s3
	lw $t4, 0($t4) # $t4 = vet[j]
		
end1:
	jr $ra # retorna
	beq $t5, $t4, fim   # se min_ind == i vai para fim
	
	move $s4, $s3     # salva &min_ind em i
	addi $s3,$s3, 1   # j++
	j loopOrdenaVetor

fim:
    jr $ra
    
	beq $s4, $s2, end2  # se min_ind == i vai para end2
	addi $t6, $zero, 4  # min_ind * 4
        mult $t5, $s4       # $t5 * $s4
        addi $t7, $zero, 4  # i * 4
        mult $t3, $s2       # $t3 * $s2
	jal troca

end2:
    jr $ra
		
        addi $s2, $s2, 1  # i++
	j loopFor1