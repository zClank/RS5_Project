`include "RS5_pkg.sv"

module arbiter
    import RS5_pkg::*;
(
    // Inputs from execute_a
    input   logic               hold_a_i,
    input   logic               write_enable_a_i,
    input   logic               write_enable_fwd_a_i,
    input   iType_e             instruction_operation_a_i,
    input   logic   [31:0]      result_a_i,
    input   logic   [31:0]      result_fwd_a_i,
    input   logic   [ 4:0]      rd_a_i,
    input   logic [31:0]        mem_address_a_i,
    input   logic               mem_read_enable_a_i,
    input   logic  [3:0]        mem_write_enable_a_i,
    input   logic [31:0]        mem_write_data_a_i,
    input   logic               csr_read_enable_a_i,
    input   logic               csr_write_enable_a_i,
    input   csrOperation_e      csr_operation_a_i,
    input   logic   [31:0]      csr_data_to_write_a_i,
    input   logic   [31:0]      vtype_a_i, vlen_a_i,
    input   logic               ctx_switch_a_i,
    input   logic               jump_rollback_a_i,
    input   logic [31:0]        ctx_switch_target_a_i,
    input   logic [31:0]        jump_target_a_i,
    input   logic               jump_a_i,
    input   logic               interrupt_ack_a_i,
    input   logic               machine_return_a_i,
    input   logic               raise_exception_a_i,
    input   exceptionCode_e     exception_code_a_i,

    // Inputs from execute_b
    input   logic               hold_b_i,
    input   logic               write_enable_b_i,
    input   logic               write_enable_fwd_b_i,
    input   iType_e             instruction_operation_b_i,
    input   logic   [31:0]      result_b_i,
    input   logic   [31:0]      result_fwd_b_i,
    input   logic   [ 4:0]      rd_b_i,
    input   logic [31:0]        mem_address_b_i,
    input   logic               mem_read_enable_b_i,
    input   logic  [3:0]        mem_write_enable_b_i,
    input   logic [31:0]        mem_write_data_b_i,
    input   logic               csr_read_enable_b_i,
    input   logic               csr_write_enable_b_i,
    input   csrOperation_e      csr_operation_b_i,
    input   logic   [31:0]      csr_data_to_write_b_i,
    input   logic   [31:0]      vtype_b_i, vlen_b_i,
    input   logic               ctx_switch_b_i,
    input   logic               jump_rollback_b_i,
    input   logic [31:0]        ctx_switch_target_b_i,
    input   logic [31:0]        jump_target_b_i,
    input   logic               jump_b_i,
    input   logic               interrupt_ack_b_i,
    input   logic               machine_return_b_i,
    input   logic               raise_exception_b_i,
    input   exceptionCode_e     exception_code_b_i,

    // Inputs from execute_c
    input   logic               hold_c_i,
    input   logic               write_enable_c_i,
    input   logic               write_enable_fwd_c_i,
    input   iType_e             instruction_operation_c_i,
    input   logic   [31:0]      result_c_i,
    input   logic   [31:0]      result_fwd_c_i,
    input   logic   [ 4:0]      rd_c_i,
    input   logic [31:0]        mem_address_c_i,
    input   logic               mem_read_enable_c_i,
    input   logic  [3:0]        mem_write_enable_c_i,
    input   logic [31:0]        mem_write_data_c_i,
    input   logic               csr_read_enable_c_i,
    input   logic               csr_write_enable_c_i,
    input   csrOperation_e      csr_operation_c_i,
    input   logic   [31:0]      csr_data_to_write_c_i,
    input   logic   [31:0]      vtype_c_i, vlen_c_i,
    input   logic               ctx_switch_c_i,
    input   logic               jump_rollback_c_i,
    input   logic [31:0]        ctx_switch_target_c_i,
    input   logic [31:0]        jump_target_c_i,
    input   logic               jump_c_i,
    input   logic               interrupt_ack_c_i,
    input   logic               machine_return_c_i,
    input   logic               raise_exception_c_i,
    input   exceptionCode_e     exception_code_c_i,

    // Outputs
    output  logic               hold_o,
    output  logic               write_enable_o,
    output  logic               write_enable_fwd_o,
    output  iType_e             instruction_operation_o,
    output  logic   [31:0]      result_o,
    output  logic   [31:0]      result_fwd_o,
    output  logic   [ 4:0]      rd_o,
    output  logic [31:0]        mem_address_o,
    output  logic               mem_read_enable_o,
    output  logic  [3:0]        mem_write_enable_o,
    output  logic [31:0]        mem_write_data_o,
    output  logic               csr_read_enable_o,
    output  logic               csr_write_enable_o,
    output  csrOperation_e      csr_operation_o,
    output  logic   [31:0]      csr_data_o,
    output  logic   [31:0]      vtype_o, vlen_o,
    output  logic               ctx_switch_o,
    output  logic               jump_rollback_o,
    output  logic [31:0]        ctx_switch_target_o,
    output  logic [31:0]        jump_target_o,
    output  logic               jump_o,
    output  logic               interrupt_ack_o,
    output  logic               machine_return_o,
    output  logic               raise_exception_o,
    output  exceptionCode_e     exception_code_o


);

    // Logic for hold_o
    always_comb begin
        if (hold_a_i == hold_b_i) begin
            hold_o = hold_a_i;
        end else if (hold_a_i == hold_c_i) begin
            hold_o = hold_a_i;
        end else if (hold_b_i == hold_c_i) begin
            hold_o = hold_b_i;
        end else begin
            hold_o = hold_a_i; // All different, use 'a'
        end
    end

    // Logic for write_enable_o
    always_comb begin
        if (write_enable_a_i == write_enable_b_i) begin
            write_enable_o = write_enable_a_i;
        end else if (write_enable_a_i == write_enable_c_i) begin
            write_enable_o = write_enable_a_i;
        end else if (write_enable_b_i == write_enable_c_i) begin
            write_enable_o = write_enable_b_i;
        end else begin
            write_enable_o = write_enable_a_i; // All different, use 'a'
        end
    end

    // Logic for write_enable_fwd_o
    always_comb begin
        if (write_enable_fwd_a_i == write_enable_fwd_b_i) begin
            write_enable_fwd_o = write_enable_fwd_a_i;
        end else if (write_enable_fwd_a_i == write_enable_fwd_c_i) begin
            write_enable_fwd_o = write_enable_fwd_a_i;
        end else if (write_enable_fwd_b_i == write_enable_fwd_c_i) begin
            write_enable_fwd_o = write_enable_fwd_b_i;
        end else begin
            write_enable_fwd_o = write_enable_fwd_a_i; // All different, use 'a'
        end
    end

    // Logic for instruction_operation_o
    always_comb begin
        if (instruction_operation_a_i == instruction_operation_b_i) begin
            instruction_operation_o = instruction_operation_a_i;
        end else if (instruction_operation_a_i == instruction_operation_c_i) begin
            instruction_operation_o = instruction_operation_a_i;
        end else if (instruction_operation_b_i == instruction_operation_c_i) begin
            instruction_operation_o = instruction_operation_b_i;
        end else begin
            instruction_operation_o = instruction_operation_a_i; // All different, use 'a'
        end
    end

    // Logic for result_o
    always_comb begin
        if (result_a_i == result_b_i) begin
            result_o = result_a_i;
        end else if (result_a_i == result_c_i) begin
            result_o = result_a_i;
        end else if (result_b_i == result_c_i) begin
            result_o = result_b_i;
        end else begin
            result_o = result_a_i; // All different, use 'a'
        end
        $display("result_o: ", result_o); // Continue from here
    end

    // Logic for result_fwd_o
    always_comb begin
        if (result_fwd_a_i == result_fwd_b_i) begin
            result_fwd_o = result_fwd_a_i;
        end else if (result_fwd_a_i == result_fwd_c_i) begin
            result_fwd_o = result_fwd_a_i;
        end else if (result_fwd_b_i == result_fwd_c_i) begin
            result_fwd_o = result_fwd_b_i;
        end else begin
            result_fwd_o = result_fwd_a_i; // All different, use 'a'
        end
    end

    // Logic for rd_o
    always_comb begin
        if (rd_a_i == rd_b_i) begin
            rd_o = rd_a_i;
        end else if (rd_a_i == rd_c_i) begin
            rd_o = rd_a_i;
        end else if (rd_b_i == rd_c_i) begin
            rd_o = rd_b_i;
        end else begin
            rd_o = rd_a_i; // All different, use 'a'
        end
    end

    // Logic for mem_address_o
    always_comb begin
        if (mem_address_a_i == mem_address_b_i) begin
            mem_address_o = mem_address_a_i;
        end else if (mem_address_a_i == mem_address_c_i) begin
            mem_address_o = mem_address_a_i;
        end else if (mem_address_b_i == mem_address_c_i) begin
            mem_address_o = mem_address_b_i;
        end else begin
            mem_address_o = mem_address_a_i; // All different, use 'a'
        end
    end

    // Logic for mem_read_enable_o
    always_comb begin
        if (mem_read_enable_a_i == mem_read_enable_b_i) begin
            mem_read_enable_o = mem_read_enable_a_i;
        end else if (mem_read_enable_a_i == mem_read_enable_c_i) begin
            mem_read_enable_o = mem_read_enable_a_i;
        end else if (mem_read_enable_b_i == mem_read_enable_c_i) begin
            mem_read_enable_o = mem_read_enable_b_i;
        end else begin
            mem_read_enable_o = mem_read_enable_a_i; // All different, use 'a'
        end
    end

    // Logic for mem_write_enable_o
    always_comb begin
        if (mem_write_enable_a_i == mem_write_enable_b_i) begin
            mem_write_enable_o = mem_write_enable_a_i;
        end else if (mem_write_enable_a_i == mem_write_enable_c_i) begin
            mem_write_enable_o = mem_write_enable_a_i;
        end else if (mem_write_enable_b_i == mem_write_enable_c_i) begin
            mem_write_enable_o = mem_write_enable_b_i;
        end else begin
            mem_write_enable_o = mem_write_enable_a_i; // All different, use 'a'
        end
    end

    // Logic for mem_write_data_o
    always_comb begin
        if (mem_write_data_a_i == mem_write_data_b_i) begin
            mem_write_data_o = mem_write_data_a_i;
        end else if (mem_write_data_a_i == mem_write_data_c_i) begin
            mem_write_data_o = mem_write_data_a_i;
        end else if (mem_write_data_b_i == mem_write_data_c_i) begin
            mem_write_data_o = mem_write_data_b_i;
        end else begin
            mem_write_data_o = mem_write_data_a_i; // All different, use 'a'
        end
    end

    // Logic for csr_read_enable_o
    always_comb begin
        if (csr_read_enable_a_i == csr_read_enable_b_i) begin
            csr_read_enable_o = csr_read_enable_a_i;
        end else if (csr_read_enable_a_i == csr_read_enable_c_i) begin
            csr_read_enable_o = csr_read_enable_a_i;
        end else if (csr_read_enable_b_i == csr_read_enable_c_i) begin
            csr_read_enable_o = csr_read_enable_b_i;
        end else begin
            csr_read_enable_o = csr_read_enable_a_i; // All different, use 'a'
        end
    end


    // Logic for csr_write_enable_o
    always_comb begin
        if (csr_write_enable_a_i == csr_write_enable_b_i) begin
            csr_write_enable_o = csr_write_enable_a_i;
        end else if (csr_write_enable_a_i == csr_write_enable_c_i) begin
            csr_write_enable_o = csr_write_enable_a_i;
        end else if (csr_write_enable_b_i == csr_write_enable_c_i) begin
            csr_write_enable_o = csr_write_enable_b_i;
        end else begin
            csr_write_enable_o = csr_write_enable_a_i; // All different, use 'a'
        end
    end


    // Logic for csr_operation_o
    always_comb begin
        if (csr_operation_a_i == csr_operation_b_i) begin
            csr_operation_o = csr_operation_a_i;
        end else if (csr_operation_a_i == csr_operation_c_i) begin
            csr_operation_o = csr_operation_a_i;
        end else if (csr_operation_b_i == csr_operation_c_i) begin
            csr_operation_o = csr_operation_b_i;
        end else begin
            csr_operation_o = csr_operation_a_i; // All different, use 'a'
        end
    end


    // Logic for csr_data_o
    always_comb begin
        if (csr_data_to_write_a_i == csr_data_to_write_b_i) begin
            csr_data_o = csr_data_to_write_a_i;
        end else if (csr_data_to_write_a_i == csr_data_to_write_c_i) begin
            csr_data_o = csr_data_to_write_a_i;
        end else if (csr_data_to_write_b_i == csr_data_to_write_c_i) begin
            csr_data_o = csr_data_to_write_b_i;
        end else begin
            csr_data_o = csr_data_to_write_a_i; // All different, use 'a'
        end
    end


    // Logic for vtype_o
    always_comb begin
        if (vtype_a_i == vtype_b_i) begin
            vtype_o = vtype_a_i;
        end else if (vtype_a_i == vtype_c_i) begin
            vtype_o = vtype_a_i;
        end else if (vtype_b_i == vtype_c_i) begin
            vtype_o = vtype_b_i;
        end else begin
            vtype_o = vtype_a_i; // All different, use 'a'
        end
    end


    // Logic for vlen_o
    always_comb begin
        if (vlen_a_i == vlen_b_i) begin
            vlen_o = vlen_a_i;
        end else if (vlen_a_i == vlen_c_i) begin
            vlen_o = vlen_a_i;
        end else if (vlen_b_i == vlen_c_i) begin
            vlen_o = vlen_b_i;
        end else begin
            vlen_o = vlen_a_i; // All different, use 'a'
        end
    end


    // Logic for ctx_switch_o
    always_comb begin
        if (ctx_switch_a_i == ctx_switch_b_i) begin
            ctx_switch_o = ctx_switch_a_i;
        end else if (ctx_switch_a_i == ctx_switch_c_i) begin
            ctx_switch_o = ctx_switch_a_i;
        end else if (ctx_switch_b_i == ctx_switch_c_i) begin
            ctx_switch_o = ctx_switch_b_i;
        end else begin
            ctx_switch_o = ctx_switch_a_i; // All different, use 'a'
        end
    end


    // Logic for jump_rollback_o
    always_comb begin
        if (jump_rollback_a_i == jump_rollback_b_i) begin
            jump_rollback_o = jump_rollback_a_i;
        end else if (jump_rollback_a_i == jump_rollback_c_i) begin
            jump_rollback_o = jump_rollback_a_i;
        end else if (jump_rollback_b_i == jump_rollback_c_i) begin
            jump_rollback_o = jump_rollback_b_i;
        end else begin
            jump_rollback_o = jump_rollback_a_i; // All different, use 'a'
        end
    end


    // Logic for ctx_switch_target_o
    always_comb begin
        if (ctx_switch_target_a_i == ctx_switch_target_b_i) begin
            ctx_switch_target_o = ctx_switch_target_a_i;
        end else if (ctx_switch_target_a_i == ctx_switch_target_c_i) begin
            ctx_switch_target_o = ctx_switch_target_a_i;
        end else if (ctx_switch_target_b_i == ctx_switch_target_c_i) begin
            ctx_switch_target_o = ctx_switch_target_b_i;
        end else begin
            ctx_switch_target_o = ctx_switch_target_a_i; // All different, use 'a'
        end
    end


    // Logic for jump_target_o
    always_comb begin
        if (jump_target_a_i == jump_target_b_i) begin
            jump_target_o = jump_target_a_i;
        end else if (jump_target_a_i == jump_target_c_i) begin
            jump_target_o = jump_target_a_i;
        end else if (jump_target_b_i == jump_target_c_i) begin
            jump_target_o = jump_target_b_i;
        end else begin
            jump_target_o = jump_target_a_i; // All different, use 'a'
        end
    end


    // Logic for jump_o
    always_comb begin
        if (jump_a_i == jump_b_i) begin
            jump_o = jump_a_i;
        end else if (jump_a_i == jump_c_i) begin
            jump_o = jump_a_i;
        end else if (jump_b_i == jump_c_i) begin
            jump_o = jump_b_i;
        end else begin
            jump_o = jump_a_i; // All different, use 'a'
        end
    end


    // Logic for interrupt_ack_o
    always_comb begin
        if (interrupt_ack_a_i == interrupt_ack_b_i) begin
            interrupt_ack_o = interrupt_ack_a_i;
        end else if (interrupt_ack_a_i == interrupt_ack_c_i) begin
            interrupt_ack_o = interrupt_ack_a_i;
        end else if (interrupt_ack_b_i == interrupt_ack_c_i) begin
            interrupt_ack_o = interrupt_ack_b_i;
        end else begin
            interrupt_ack_o = interrupt_ack_a_i; // All different, use 'a'
        end
    end


    // Logic for machine_return_o
    always_comb begin
        if (machine_return_a_i == machine_return_b_i) begin
            machine_return_o = machine_return_a_i;
        end else if (machine_return_a_i == machine_return_c_i) begin
            machine_return_o = machine_return_a_i;
        end else if (machine_return_b_i == machine_return_c_i) begin
            machine_return_o = machine_return_b_i;
        end else begin
            machine_return_o = machine_return_a_i; // All different, use 'a'
        end
    end


    // Logic for raise_exception_o
    always_comb begin
        if (raise_exception_a_i == raise_exception_b_i) begin
            raise_exception_o = raise_exception_a_i;
        end else if (raise_exception_a_i == raise_exception_c_i) begin
            raise_exception_o = raise_exception_a_i;
        end else if (raise_exception_b_i == raise_exception_c_i) begin
            raise_exception_o = raise_exception_b_i;
        end else begin
            raise_exception_o = raise_exception_a_i; // All different, use 'a'
        end
    end


    // Logic for exception_code_o
    always_comb begin
        if (exception_code_a_i == exception_code_b_i) begin
            exception_code_o = exception_code_a_i;
        end else if (exception_code_a_i == exception_code_c_i) begin
            exception_code_o = exception_code_a_i;
        end else if (exception_code_b_i == exception_code_c_i) begin
            exception_code_o = exception_code_b_i;
        end else begin
            exception_code_o = exception_code_a_i; // All different, use 'a'
        end
    end


endmodule