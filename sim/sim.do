vlog ../rtl/aes/*.sv
vlog ../rtl/*.sv
vlog *.sv
vsim work.testbench
do wave.do
run 200ns
