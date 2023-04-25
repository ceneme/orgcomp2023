# T1 Org/Arq 2023

.data 
.align 0

insertNumElem:	.asciz "Insira o numero de elementos da lista (>=5): "
insertInt:	.asciz "Insira um ID (inteiro): "
insertString:	.asciz "Insira uma string de ate 28 caracteres: "
lab_printAll:	.asciz "Todos os elementos\n"
nxtLine:	.asciz "\n-------------\n"
lab_str:	.asciz "String: "
lab_id:		.asciz "ID: "

.text
.align 2
.globl main

main:

	li t1, -1 	# t1 armazena o num. de elem. da lista
	li t2, 5	# t2 serve como comparacao para t1 (5)
	li t3, 0

loop_num_elem:
	# laco para obter um numero de elementos para a lista
	bge t1, t2, start   # quando t1 >= 5, inicia a lista (j start)
	
	# imprime para usuario inserir numero de elementos 
	la a0, insertNumElem
	li a7, 4
	ecall
	
	# le do usuario numero de elementos e armazena em t1
	li a7, 5
	ecall
	mv t1, a0
	
	# retorna ao inicio do laco
	j loop_num_elem
	
start:
	# vai lendo o conteudo dos elementos ate que t1 == t3
	beq t3, t1, printAll
	addi t3, t3, 1
	b add_node

add_node:
	# aloca o espaco de 32 bytes e move o novo node para 
	jal allocate
	mv t4, a0
	
	# newNode-> next = 0
	sw zero, 32(t4)
	
	# pede um inteiro (ID)
	la a0, insertInt
	li a7, 4
	ecall
	
	# le o ID e insere no novo node
	li a7, 5
	ecall
	sw a0, (t4)
	
	# pede string
	la a0, insertString
	li a7, 4
	ecall
	
	# le a string e insere no novo node
	li a7, 8
	addi a0, t4, 4
	li a1, 28
	ecall
	
	# se a lista esta vazia, se trata do primeiro node
	beqz s7, firstNode
	
	# caso a lista nao esteja vazia
	# a3 = variavel global para current node
	# t5 = variavel para new node
	
	lw t2, 32(a3)
	sw t2, 36(t4)
	
	addi t0, t4, 4
	sw t0, 32(a3)
	
	addi a3, t4, 4
	
	j start
	
printAll:
	la a0, lab_printAll
	li a7, 4
	ecall
	
	mv t4, s7
	beqz t4, exit
	
printElement:
	
	la a0, lab_str
	li a7, 4
	ecall
	
	# imprime a string
	mv a0, t4
	ecall
	
	la a0, lab_id
	ecall
	
	# imprime o ID
	li a7, 1
	lw a0, -4(t4)
	ecall
	
	la a0, nxtLine
	li a7, 4
	ecall
	
	lw t2, 32(t4)
	beqz t2, exit
	mv t4, t2
	j printElement
	
allocate:
	li a7, 9
	li a0, 40
	ecall
	jr ra
	
firstNode:
	addi s7, t4, 4
	addi a3, t4, 4
	j start
	
exit:
	li a7, 10
	ecall
