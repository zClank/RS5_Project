onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {New Group} /testbench/RAM_MEM/RAM
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/vtype_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/vlen_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/mem_address_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/mem_read_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/mem_write_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/mem_write_data_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/vector_scalar_result
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/vector_wr_en
add wave -noupdate -expand -group {New Group} /testbench/dut/execute1/hold_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/vtype_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/vlen_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/mem_address_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/mem_read_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/mem_write_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/mem_write_data_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/vector_scalar_result
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/vector_wr_en
add wave -noupdate -expand -group {New Group} /testbench/dut/execute2/hold_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/vtype_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/vlen_o
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/mem_address_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/mem_read_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/mem_write_enable_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/mem_write_data_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/vector_scalar_result
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/vector_wr_en
add wave -noupdate -expand -group {New Group} /testbench/dut/execute3/hold_vector
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/clk
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/reset_n
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/sys_reset
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/enable_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/ctx_switch_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/ctx_switch_target_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jumping_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/bp_take_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jump_rollback_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/bp_target_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/bp_rollback_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jump_misaligned_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/compressed_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/instruction_address_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/instruction_data_i
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/instruction_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/pc_o
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_continue
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_continue_next
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jumped
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jump_target
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_advance
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_next
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jumped_r
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/jumped_r2
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/should_rollback
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_jumped
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_jumped_r
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/pc_add
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/pc
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/pc_next
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/pc_update
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/enable_r
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/idata_held
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/instruction_fetched
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/instruction_next
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/bp_rollback_r
add wave -noupdate -expand -group {New Group} /testbench/dut/fetch1/iaddr_not_jumped
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/hold_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_fwd_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/instruction_operation_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_fwd_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/rd_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_address_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_read_enable_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_enable_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_data_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_read_enable_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_write_enable_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_operation_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_data_to_write_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vtype_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vlen_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_rollback_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_target_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_target_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/interrupt_ack_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/machine_return_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/raise_exception_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/exception_code_a_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/hold_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_fwd_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/instruction_operation_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_fwd_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/rd_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_address_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_read_enable_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_enable_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_data_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_read_enable_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_write_enable_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_operation_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_data_to_write_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vtype_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vlen_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_rollback_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_target_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_target_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/interrupt_ack_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/machine_return_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/raise_exception_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/exception_code_b_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/hold_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_fwd_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/instruction_operation_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_fwd_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/rd_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_address_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_read_enable_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_enable_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_data_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_read_enable_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_write_enable_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_operation_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_data_to_write_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vtype_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vlen_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_rollback_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_target_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_target_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/interrupt_ack_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/machine_return_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/raise_exception_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/exception_code_c_i
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/hold_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/write_enable_fwd_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/instruction_operation_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/result_fwd_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/rd_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_address_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_read_enable_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_enable_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/mem_write_data_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_read_enable_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_write_enable_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_operation_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/csr_data_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vtype_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/vlen_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_rollback_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/ctx_switch_target_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_target_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/jump_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/interrupt_ack_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/machine_return_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/raise_exception_o
add wave -noupdate -expand -group {New Group} /testbench/dut/arbiter1/exception_code_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {999229 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {999050 ns} {1000050 ns}
