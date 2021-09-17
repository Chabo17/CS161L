lw $v0,31($zero) # Load 361 (0001 0110 1001) at line 31
lw $v1,32($zero) # Load 174 (0000 1010 1110) at line 32
add  $a0, $v0, $v1 # a0 = 535 
addi $a0, $v0, 100 # a0 = 461 
sub  $a1, $v0, $v1 # a1 = 187
and  $a1, $a1, $zero # a1 = 0
or   $a2, $v1, $zero # a2 = 174
nor  $a2, $v1, $zero # a2 = 0
or   $a3, $v0, $zero # a3 = 361
slt  $a3, $v0, $v1   # a3 = 0