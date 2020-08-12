#This script is written by Sangharatna Godboley Date: 9th Aug 2020
#Objective is to make parallel fuzzing using AFL for 4 cores

echo sanghu
BENCHMARK=$1
afl-gcc -fno-stack-protector -z execstack $BENCHMARK.c -o $BENCHMARK

#Here we need to supply the total number of predicates present in a
#program also it must be equal to total number of Annotated LLVM IRs
Predicates=15
Cores=4
i=1

BATCHES=$(($Predicates / $Cores))
MOD=$(($Predicates % $Cores))
while [ "$i" -le $BATCHES ]
do
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fA-$i:1/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fB-$i:2/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fC-$i:3/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fD-$i:4/4 ./p1
((i=$i+1))
done

#Below code is for the very last batch where the predicates are lesser than 4
if [ "$MOD" -eq 3 ]
then
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fA-$i:1/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fB-$i:2/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fC-$i:3/4 ./p1 
fi

if [ "$MOD" -eq 2 ]
then
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fA-$i:1/4 ./p1 &
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fB-$i:2/4 ./p1 
fi

if [ "$MOD" -eq 1 ]
then
timeout 60 ./afl-fuzz -C -i testcase -o sync_dir -M fA-$i:1/4 ./p1 
fi

