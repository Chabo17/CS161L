# Load values from memory
lw $v0, 31($zero)
lw $v1, 32($zero)
# DeMorgan's !(v0 && v1) = !v0 || !v1
and $t0, $v0, $v1
nor $t0, $t0, $t0
nor $t1, $v0, $v0
nor $t2, $v1, $v1
or  $t3, $t1, $t2
slt $s0, $t0, $t3
slt $s1, $t3, $t0
# DeMorgan's !(v0 || v1) = !v0 && !v1)
or  $t4, $v0, $v1
nor $t4, $t4, $t4
and $t5, $t1, $t2
slt $s2, $t4, $t5
slt $s3, $t5, $t4
# Check that both laws are true
nor $a0, $s0, $s1
nor $a1, $s2, $s3
and $a2, $a0, $a1