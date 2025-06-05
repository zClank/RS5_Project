vlog ../rtl/aes/*.sv
vlog ../rtl/*.sv
vlog *.sv
vsim -voptargs=+acc work.testbench
do wave.do
run 1ms
