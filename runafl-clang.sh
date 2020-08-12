echo sanghu
BENCHMARK=$1


clang -S -emit-llvm $BENCHMARK.c
afl-clang -fno-stack-protector -z execstack $BENCHMARK.ll -o $BENCHMARK
timeout 65 afl-fuzz -i ./testcase/ -o ./results-$BENCHMARK/ ./$BENCHMARK
#add -C for crash exploration
/scratch/sanghu/Desktop/afl/experimental/crash_triage/./triage_crashes.sh results-$BENCHMARK/ /scratch/sanghu/Desktop/afl/$BENCHMARK &> results-$BENCHMARK/crashdetail.txt
sed '/Assertion /!d' results-$BENCHMARK/crashdetail.txt > results-$BENCHMARK/temp.txt
sort -u results-$BENCHMARK/temp.txt > results-$BENCHMARK/finalcrashes.txt

detectederrors=$(ls -l | grep -c "failed" results-$BENCHMARK/finalcrashes.txt)
echo "******Final Result Report from AFL ******"
echo "******Final Result Report from AFL******" >> results-$BENCHMARK/$BENCHMARK-report.txt
echo "Total number Injected Errors =:$detectederrors" 
echo "Total number Injected Errors =:$detectederrors" >> results-$BENCHMARK/$BENCHMARK-report.txt


#for parralel fuz
#timeout 300 ./afl-fuzz -C -i testcase -o sync_dir -M fA:1/7 ./p1

