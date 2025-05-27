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
    output  logic [31:0]        mem_write_data_o
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

endmodule