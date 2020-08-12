echo sanghu
BENCHMARK=$1
afl-gcc -fno-stack-protector -z execstack $BENCHMARK.c -o $BENCHMARK
timeout 65 afl-fuzz -C -i ./testcase/ -o ./results-$BENCHMARK/ ./$BENCHMARK
#add -C for crash exploration
/home/sanghu/Teaching/afl-2.52b/experimental/crash_triage/./triage_crashes.sh results-$BENCHMARK/ /home/sanghu/Teaching/afl-2.52b/$BENCHMARK &> results-$BENCHMARK/crashdetail.txt
sed '/Assertion /!d' results-$BENCHMARK/crashdetail.txt > results-$BENCHMARK/temp.txt
sort -u results-$BENCHMARK/temp.txt > results-$BENCHMARK/finalcrashes.txt

detectederrors=$(ls -l | grep -c "failed" results-$BENCHMARK/finalcrashes.txt)
echo "******Final Result Report from AFL ******"
echo "******Final Result Report from AFL******" >> results-$BENCHMARK/$BENCHMARK-report.txt
echo "Total number Injected Errors =:$detectederrors" 
echo "Total number Injected Errors =:$detectederrors" >> results-$BENCHMARK/$BENCHMARK-report.txt


#for parralel fuz
#timeout 300 ./afl-fuzz -C -i testcase -o sync_dir -M fA:1/7 ./p1


#/home/sanghu/TracerX/llvm/Release/bin/clang -I /home/sanghu/TracerX/tracerx/include -c -emit-llvm -g ${BENCHMARK}.c

