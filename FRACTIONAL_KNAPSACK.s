.data
op: .string ANSWER\n
profit: .word 12,18,13,15,20
weights: .word 3,9,1,5,5
ppw: .word 0,0,0,0,0
rm: .word 0,0,0,0,0
number: .word 5
capacity: .word 10
.text
la x1,profit
la x2,weights
la x3,ppw
la x15,rm
la x4, number
lw x5,0(x4)
comeback:
beqz x5,moveon
lw x6,0(x1)
lw x7,0(x2)
rem x26,x6,x7
div x8,x6,x7
sw x8,0(x3)
sw x26,0(x15)
addi x1,x1,4
addi x2,x2,4
addi x3,x3,4
addi x15,x15,4
addi x5,x5,-1
j comeback
moveon:
la x1,ppw
la x29,profit
la x30,profit
la x21,weights
la x22,weights
la x9,ppw
la x15,rm
la x17,rm
la x2,number
la x25,capacity
lw x3,0(x2)
add x7,x3,x0
addi x3,x3,-1
beqz x3,the_start
back:
lw x23,0(x21)
lw x27,0(x29)
lw x16, 0(x15)
lw x5,4(x1)
lw x24,4(x21)
lw x28,4(x29)
lw x26,4(x15)
blt x5,x4,skip
beq x5,x4,eskip
sw x5,0(x1)
sw x24,0(x21)
sw x28,0(x29)
sw x26,0(x15)
sw x4,4(x1)
sw x23,4(x21)
sw x27,4(x29)
sw x26,4(x15)
eskip: bge x16,x26,eeskip
sw x5,0(x1)
sw x24,0(x21)
sw x28,0(x29)
sw x4,4(x1)
sw x23,4(x21)
sw x27,4(x29)
eeskip:
skip: addi x3,x3,-1
addi x1,x1,4
addi x21,x21,4
addi x29,x29,4
addi x15,x15,4
bnez x3,back
add x1,x9,x0
add x21,x22,x0
add x29,x30,x0
add x15,x17,x0
addi x7,x7,-1
beqz x7,the_start
add x3,x7,x0
j back
the_start:
la x2,number
lw x20, 0(x2)
lw x21, 0(x25)
la x1, profit # Set up pointers to the arrays
la x2, weights
li x3, 0 # Loop Counter
li x4, 0 # Current capacity
li x11, 0 # Initialize the result (knapsack value) to 0
knapsack_loop:
bge x3, x20, knapsack_end # If the counter reaches the end of the arrays, branch to knapsack_end
lw x5, 0(x1) # Load value of current item
lw x6, 0(x2) # Load weight of current item
sub x7, x21, x4 # Calculate remaining capacity in the bag
bge x7,x0,item_fits # If the current item can fit in the bag, branch to item_fits
j next_iteration # If item doesn't fit, branch to the next_iteration label
item_fits:
sub x8, x7, x6 # Calculate the remaining capacity after adding the item
bge x8,x0,looper1
mul x27,x5,x7
div x27,x27,x6
add x11,x11,x27
j skipper
looper1:
add x11, x11, x5 # Update the result (knapsack value)
skipper: add x4, x4, x6
next_iteration: # To move to the next item
addi x1, x1, 4 # Increment value pointer
addi x2, x2, 4 # Increment weight pointer
addi x3, x3, 1 # Increment loop counter
j knapsack_loop # Repeat the loop
knapsack_end:
la a0, op # Load address of string 'ANSWER\n' to a0
li a7, 4 # Load the system call number for printing strings into a7
ecall # Make the system call to print the string
mv a0, x11 # Load result (Knapsack value) to a0
li a7,1 # Load the system call number for printing integers into a7
ecall # Make the system call to print the integer
nop