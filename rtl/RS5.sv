/*!\file RS5.sv
 * RS5 VERSION - 1.1.0 - Pipeline Simplified and Core Renamed
 *
 * Distribution:  July 2023
 *
 * Willian Nunes   <willian.nunes@edu.pucrs.br>
 * Marcos Sartori  <marcos.sartori@acad.pucrs.br>
 * Ney calazans    <ney.calazans@pucrs.br>
 *
 * Research group: GAPH-PUCRS  <>
 *
 * \brief
 * Is the top Module of RS5 processor core.
 *
 * \detailed
 * This is the top Module of the RS5 processor core
 * and is responsible for the instantiation of the lower level modules
 * and also defines the interface ports (inputs and outputs) os the processor.
 */

`include "RS5_pkg.sv"
`include "execute_a.sv" // Added execute_a
`include "execute_b.sv" // Added execute_b
`include "execute_c.sv" // Added execute_c
`include "arbiter.sv"   // Added arbiter

module RS5
    import RS5_pkg::*;
#(
`ifndef SYNTH
    parameter bit           DEBUG          = 1'b0,
    parameter string        DBG_REG_FILE   = "./debug/regBank.txt",
    parameter bit           PROFILING      = 1'b0,
    parameter string        PROFILING_FILE = "./debug/Report.txt",
`endif
    parameter environment_e Environment    = ASIC,
    parameter mul_e         MULEXT         = MUL_M,
    parameter bit           COMPRESSED     = 1'b0,
    parameter bit           VEnable        = 1'b0,
    parameter int           VLEN           = 256,
    parameter bit           XOSVMEnable    = 1'b0,
    parameter bit           ZIHPMEnable    = 1'b0,
    parameter bit           ZKNEEnable     = 1'b0,
    parameter bit           BRANCHPRED     = 1'b1
)
(
    input  logic                    clk,
    input  logic                    reset_n,
    input  logic                    sys_reset_i,
    input  logic                    stall,

    input  logic [31:0]             instruction_i,
    input  logic [31:0]             mem_data_i,
    input  logic [63:0]             mtime_i,
    input  logic [31:0]             irq_i,

    output logic [31:0]             instruction_address_o,
    output logic                    mem_operation_enable_o,
    output logic  [3:0]             mem_write_enable_o,
    output logic [31:0]             mem_address_o,
    output logic [31:0]             mem_data_o,
    output logic                    interrupt_ack_o
);

//////////////////////////////////////////////////////////////////////////////
// Global signals
//////////////////////////////////////////////////////////////////////////////

    logic            jump;
    logic            hazard;
    logic            hold; // This will be an output from the arbiter

    logic            mmu_inst_fault;
    logic            mmu_data_fault;

    privilegeLevel_e privilege;
    logic   [31:0]   jump_target;

    logic            mem_read_enable; // This will be an output from the arbiter
    logic    [3:0]   mem_write_enable; // This will be an output from the arbiter
    logic   [31:0]   mem_address; // This will be an output from the arbiter
    logic   [31:0]   instruction_address;

//////////////////////////////////////////////////////////////////////////////
// Fetch signals
//////////////////////////////////////////////////////////////////////////////

    logic           enable_fetch;

//////////////////////////////////////////////////////////////////////////////
// Decoder signals
//////////////////////////////////////////////////////////////////////////////

    logic   [31:0]  pc_decode;
    logic           enable_decode;
    logic           jump_misaligned;

//////////////////////////////////////////////////////////////////////////////
// RegBank signals
//////////////////////////////////////////////////////////////////////////////

    logic    [4:0]  rs1, rs2;
    logic   [31:0]  regbank_data1, regbank_data2;
    logic    [4:0]  rd_retire; // This will be an output from the arbiter
    logic   [31:0]  regbank_data_writeback;
    logic           regbank_write_enable; // This will be an output from the arbiter

//////////////////////////////////////////////////////////////////////////////
// Execute signals
//////////////////////////////////////////////////////////////////////////////

    iType_e         instruction_operation_execute;
    iTypeVector_e   vector_operation_execute;
    logic   [31:0]  first_operand_execute, second_operand_execute, third_operand_execute;
    logic   [31:0]  instruction_execute;
    logic   [31:0]  pc_execute;
    logic    [4:0]  rd_execute;
    logic    [4:0]  rs1_execute;
    logic           exc_ilegal_inst_execute;
    logic           exc_misaligned_fetch_execute;
    logic           exc_inst_access_fault_execute;
    logic           instruction_compressed_execute;
    logic   [31:0]  vtype, vlen;


    // Signals for execute_a outputs
    logic               hold_a;
    logic               write_enable_a;
    logic               write_enable_fwd_a;
    iType_e             instruction_operation_a;
    logic   [31:0]      result_a;
    logic   [31:0]      result_fwd_a;
    logic   [ 4:0]      rd_a;
    logic [31:0]        mem_address_a;
    logic               mem_read_enable_a;
    logic  [3:0]        mem_write_enable_a;
    logic [31:0]        mem_write_data_a;
    logic               csr_read_enable_a;
    logic               csr_write_enable_a;
    csrOperation_e      csr_operation_a;
    logic   [31:0]      csr_data_to_write_a;
    logic   [31:0]      vtype_a, vlen_a;
    logic               ctx_switch_a;
    logic               jump_rollback_a;
    logic [31:0]        ctx_switch_target_a;
    logic [31:0]        jump_target_a;
    logic               jump_a;
    logic               interrupt_ack_a_out;
    logic               machine_return_a;
    logic               raise_exception_a;
    exceptionCode_e     exception_code_a;


    // Signals for execute_b outputs
    logic               hold_b;
    logic               write_enable_b;
    logic               write_enable_fwd_b;
    iType_e             instruction_operation_b;
    logic   [31:0]      result_b;
    logic   [31:0]      result_fwd_b;
    logic   [ 4:0]      rd_b;
    logic [31:0]        mem_address_b;
    logic               mem_read_enable_b;
    logic  [3:0]        mem_write_enable_b;
    logic [31:0]        mem_write_data_b;
    logic               csr_read_enable_b;
    logic               csr_write_enable_b;
    csrOperation_e      csr_operation_b;
    logic   [31:0]      csr_data_to_write_b;
    logic   [31:0]      vtype_b, vlen_b;
    logic               ctx_switch_b;
    logic               jump_rollback_b;
    logic [31:0]        ctx_switch_target_b;
    logic [31:0]        jump_target_b;
    logic               jump_b;
    logic               interrupt_ack_b_out;
    logic               machine_return_b;
    logic               raise_exception_b;
    exceptionCode_e     exception_code_b;

    // Signals for execute_c outputs
    logic               hold_c;
    logic               write_enable_c;
    logic               write_enable_fwd_c;
    iType_e             instruction_operation_c;
    logic   [31:0]      result_c;
    logic   [31:0]      result_fwd_c;
    logic   [ 4:0]      rd_c;
    logic [31:0]        mem_address_c;
    logic               mem_read_enable_c;
    logic  [3:0]        mem_write_enable_c;
    logic [31:0]        mem_write_data_c;
    logic               csr_read_enable_c;
    logic               csr_write_enable_c;
    csrOperation_e      csr_operation_c;
    logic   [31:0]      csr_data_to_write_c;
    logic   [31:0]      vtype_c, vlen_c;
    logic               ctx_switch_c;
    logic               jump_rollback_c;
    logic [31:0]        ctx_switch_target_c;
    logic [31:0]        jump_target_c;
    logic               jump_c;
    logic               interrupt_ack_c_out;
    logic               machine_return_c;
    logic               raise_exception_c;
    exceptionCode_e     exception_code_c;


//////////////////////////////////////////////////////////////////////////////
// Retire signals
//////////////////////////////////////////////////////////////////////////////

    iType_e         instruction_operation_retire; // This will be an output from the arbiter
    logic   [31:0]  result_retire; // This will be an output from the arbiter
    logic           killed;

//////////////////////////////////////////////////////////////////////////////
// CSR Bank signals
//////////////////////////////////////////////////////////////////////////////

    logic           csr_read_enable; // This will be an output from the arbiter
    logic           csr_write_enable; // This will be an output from the arbiter
    csrOperation_e  csr_operation; // This will be an output from the arbiter
    logic   [11:0]  csr_addr;
    logic   [31:0]  csr_data_to_write; // This will be an output from the arbiter
    logic   [31:0]  csr_data_read;
    logic   [31:0]  mepc, mtvec;
    logic           RAISE_EXCEPTION; // This will be an output from the arbiter
    logic           MACHINE_RETURN; // This will be an output from the arbiter
    logic           interrupt_pending;
    exceptionCode_e Exception_Code; // This will be an output from the arbiter

    /* Signals enabled with XOSVM */
    /* verilator lint_off UNUSEDSIGNAL */
    logic   [31:0]  mvmdo, mvmio, mvmds, mvmis, mvmdm, mvmim;
    logic           mvmctl;
    logic           mmu_en;
    /* verilator lint_on UNUSEDSIGNAL */

    // Arbiter output signals that connect to other modules (except execute)
    logic           write_enable_exec_arb; // From arbiter to Decode
    logic   [31:0]  result_exec_arb;       // From arbiter to Decode
    logic           ctx_switch_arb;        // From arbiter to Fetch/Decode
    logic           jump_rollback_arb;     // From arbiter to Fetch/Decode
    logic [31:0]    ctx_switch_target_arb; // From arbiter to Fetch/Decode
    logic [31:0]    vtype_arb, vlen_arb;   // From arbiter to CSRBank


//////////////////////////////////////////////////////////////////////////////
// Assigns
//////////////////////////////////////////////////////////////////////////////

    if (XOSVMEnable == 1'b1) begin : gen_xosvm_mmu_on
        assign mmu_en = privilege != privilegeLevel_e'(2'b11) && mvmctl == 1'b1;
    end
    else begin : gen_xosvm_mmu_off
        assign mmu_en = 1'b0;
    end

    assign enable_fetch  = !(stall || hold || hazard);
    assign enable_decode = !(stall || hold);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////// FETCH //////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    logic        jump_rollback;
    logic        jumping;
    logic        ctx_switch;
    logic        bp_take_fetch;
    logic        bp_rollback;
    logic        compressed_decode;
    logic [31:0] bp_target;
    logic [31:0] ctx_switch_target;
    logic [31:0] instruction_decode;

    fetch #(
        .COMPRESSED(COMPRESSED),
        .BRANCHPRED(BRANCHPRED)
    ) fetch1 (
        .clk                    (clk),
        .reset_n                (reset_n),
        .sys_reset              (sys_reset_i),
        .enable_i               (enable_fetch),
        .ctx_switch_i           (ctx_switch_arb), // From Arbiter
        .jump_rollback_i        (jump_rollback_arb), // From Arbiter
        .ctx_switch_target_i    (ctx_switch_target_arb), // From Arbiter
        .bp_take_i              (bp_take_fetch),
        .bp_target_i            (bp_target),
        .jumping_o              (jumping),
        .bp_rollback_o          (bp_rollback),
        .jump_misaligned_o      (jump_misaligned),
        .compressed_o           (compressed_decode),
        .instruction_address_o  (instruction_address),
        .instruction_data_i     (instruction_i),
        .instruction_o          (instruction_decode),
        .pc_o                   (pc_decode)
    );

    if (XOSVMEnable == 1'b1) begin : gen_xosvm_i_mmu_on
        mmu i_mmu (
            .en_i           (mmu_en               ),
            .mask_i         (mvmim                ),
            .offset_i       (mvmio                ),
            .size_i         (mvmis                ),
            .address_i      (instruction_address  ),
            .exception_o    (mmu_inst_fault       ),
            .address_o      (instruction_address_o)
        );
    end
    else begin : gen_xosvm_i_mmu_off
        assign mmu_inst_fault        = 1'b0;
        assign instruction_address_o = instruction_address;
    end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// DECODER /////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    logic        bp_taken_exec;
    // logic        write_enable_exec; // Now comes from Arbiter
    // logic [31:0] result_exec;       // Now comes from Arbiter

    decode # (
        .MULEXT    (MULEXT    ),
        .COMPRESSED(COMPRESSED),
        .ZKNEEnable(ZKNEEnable),
        .VEnable   (VEnable   ),
        .BRANCHPRED(BRANCHPRED)
    ) decoder1 (
        .clk                        (clk),
        .reset_n                    (reset_n),
        .enable                     (enable_decode),
        .instruction_i              (instruction_decode),
        .pc_i                       (pc_decode),
        .rs1_data_read_i            (regbank_data1),
        .rs2_data_read_i            (regbank_data2),
        .rd_retire_i                (rd_retire), // From Arbiter
        .writeback_i                (regbank_data_writeback),
        .result_i                   (result_exec_arb), // From Arbiter
        .regbank_we_i               (regbank_write_enable), // From Arbiter
        .execute_we_i               (write_enable_exec_arb), // From Arbiter
        .rs1_o                      (rs1),
        .rs2_o                      (rs2),
        .rd_o                       (rd_execute),
        .instr_rs1_o                (rs1_execute),
        .csr_address_o              (csr_addr),
        .first_operand_o            (first_operand_execute),
        .second_operand_o           (second_operand_execute),
        .third_operand_o            (third_operand_execute),
        .pc_o                       (pc_execute),
        .instruction_o              (instruction_execute),
        .compressed_o               (instruction_compressed_execute),
        .instruction_operation_o    (instruction_operation_execute),
        .vector_operation_o         (vector_operation_execute),
        .hazard_o                   (hazard),
        .killed_o                   (killed),
        .ctx_switch_i               (ctx_switch_arb), // From Arbiter
        .jumping_i                  (jumping),
        .jump_rollback_i            (jump_rollback_arb), // From Arbiter
        .rollback_i                 (bp_rollback),
        .compressed_i               (compressed_decode),
        .jump_misaligned_i          (jump_misaligned),
        .bp_take_o                  (bp_take_fetch),
        .bp_taken_o                 (bp_taken_exec),
        .bp_target_o                (bp_target),
        .exc_inst_access_fault_i    (mmu_inst_fault),
        .exc_inst_access_fault_o    (exc_inst_access_fault_execute),
        .exc_ilegal_inst_o          (exc_ilegal_inst_execute),
        .exc_misaligned_fetch_o     (exc_misaligned_fetch_execute)
    );

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// REGISTER BANK //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (Environment == FPGA) begin :RegFileFPGA_blk
        DRAM_RegBank RegBankA (
            .clk        (clk),
            .we         (regbank_write_enable), // From Arbiter
            .a          (rd_retire),            // From Arbiter
            .d          (regbank_data_writeback),
            .dpra       (rs1),
            .dpo        (regbank_data1)
        );

        DRAM_RegBank RegBankB (
            .clk        (clk),
            .we         (regbank_write_enable), // From Arbiter
            .a          (rd_retire),            // From Arbiter
            .d          (regbank_data_writeback),
            .dpra       (rs2),
            .dpo        (regbank_data2)
        );
    end
    else begin : RegFileFF_blk
        regbank #(
        `ifndef SYNTH
            .DEBUG      (DEBUG       ),
            .DBG_FILE   (DBG_REG_FILE)
        `endif
        ) regbankff (
            .clk        (clk),
            .reset_n    (reset_n),
            .rs1        (rs1),
            .rs2        (rs2),
            .rd         (rd_retire), // From Arbiter
            .enable     (regbank_write_enable), // From Arbiter
            .data_i     (regbank_data_writeback),
            .data1_o    (regbank_data1),
            .data2_o    (regbank_data2)
        );
    end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// EXECUTE /////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    execute_a #(
        .Environment (Environment),
        .MULEXT      (MULEXT),
        .ZKNEEnable  (ZKNEEnable),
        .VEnable     (VEnable),
        .VLEN        (VLEN),
        .BRANCHPRED  (BRANCHPRED)
    ) execute1 (
        .clk                     (clk),
        .reset_n                 (reset_n),
        .stall                   (stall),
        .instruction_i           (instruction_execute),
        .pc_i                    (pc_execute),
        .first_operand_i         (first_operand_execute),
        .second_operand_i        (second_operand_execute),
        .third_operand_i         (third_operand_execute),
        .rd_i                    (rd_execute),
        .rs1_i                   (rs1_execute),
        .instruction_operation_i (instruction_operation_execute),
        .instruction_compressed_i(instruction_compressed_execute),
        .vector_operation_i      (vector_operation_execute),
        .privilege_i             (privilege),
        .exc_ilegal_inst_i       (exc_ilegal_inst_execute),
        .exc_misaligned_fetch_i  (exc_misaligned_fetch_execute),
        .exc_inst_access_fault_i (exc_inst_access_fault_execute),
        .exc_load_access_fault_i (mmu_data_fault),
        .mem_read_data_i         (mem_data_i),
        .csr_address_i           (csr_addr),
        .csr_data_read_i         (csr_data_read),
        .bp_taken_i              (bp_taken_exec),
        .interrupt_pending_i     (interrupt_pending),
        .mtvec_i                 (mtvec),
        .mepc_i                  (mepc),
        // Outputs to Arbiter
        .hold_o                  (hold_a),
        .write_enable_o          (write_enable_a),
        .write_enable_fwd_o      (write_enable_fwd_a),
        .instruction_operation_o (instruction_operation_a),
        .result_o                (result_a),
        .result_fwd_o            (result_fwd_a),
        .rd_o                    (rd_a),
        .mem_address_o           (mem_address_a),
        .mem_read_enable_o       (mem_read_enable_a),
        .mem_write_enable_o      (mem_write_enable_a),
        .mem_write_data_o        (mem_write_data_a),
        .csr_read_enable_o       (csr_read_enable_a),
        .csr_write_enable_o      (csr_write_enable_a),
        .csr_operation_o         (csr_operation_a),
        .csr_data_o              (csr_data_to_write_a),
        .vtype_o                 (vtype_a),
        .vlen_o                  (vlen_a),
        .ctx_switch_o            (ctx_switch_a),
        .jump_rollback_o         (jump_rollback_a),
        .ctx_switch_target_o     (ctx_switch_target_a),
        .jump_target_o           (jump_target_a),
        .jump_o                  (jump_a),
        .interrupt_ack_o         (interrupt_ack_a_out),
        .machine_return_o        (machine_return_a),
        .raise_exception_o       (raise_exception_a),
        .exception_code_o        (exception_code_a)
    );

    execute_b #(
        .Environment (Environment),
        .MULEXT      (MULEXT),
        .ZKNEEnable  (ZKNEEnable),
        .VEnable     (VEnable),
        .VLEN        (VLEN),
        .BRANCHPRED  (BRANCHPRED)
    ) execute2 (
        .clk                     (clk),
        .reset_n                 (reset_n),
        .stall                   (stall),
        .instruction_i           (instruction_execute),
        .pc_i                    (pc_execute),
        .first_operand_i         (first_operand_execute),
        .second_operand_i        (second_operand_execute),
        .third_operand_i         (third_operand_execute),
        .rd_i                    (rd_execute),
        .rs1_i                   (rs1_execute),
        .instruction_operation_i (instruction_operation_execute),
        .instruction_compressed_i(instruction_compressed_execute),
        .vector_operation_i      (vector_operation_execute),
        .privilege_i             (privilege),
        .exc_ilegal_inst_i       (exc_ilegal_inst_execute),
        .exc_misaligned_fetch_i  (exc_misaligned_fetch_execute),
        .exc_inst_access_fault_i (exc_inst_access_fault_execute),
        .exc_load_access_fault_i (mmu_data_fault),
        .mem_read_data_i         (mem_data_i),
        .csr_address_i           (csr_addr),
        .csr_data_read_i         (csr_data_read),
        .bp_taken_i              (bp_taken_exec),
        .interrupt_pending_i     (interrupt_pending),
        .mtvec_i                 (mtvec),
        .mepc_i                  (mepc),
        // Outputs to Arbiter
        .hold_o                  (hold_b),
        .write_enable_o          (write_enable_b),
        .write_enable_fwd_o      (write_enable_fwd_b),
        .instruction_operation_o (instruction_operation_b),
        .result_o                (result_b),
        .result_fwd_o            (result_fwd_b),
        .rd_o                    (rd_b),
        .mem_address_o           (mem_address_b),
        .mem_read_enable_o       (mem_read_enable_b),
        .mem_write_enable_o      (mem_write_enable_b),
        .mem_write_data_o        (mem_write_data_b),
        .csr_read_enable_o       (csr_read_enable_b),
        .csr_write_enable_o      (csr_write_enable_b),
        .csr_operation_o         (csr_operation_b),
        .csr_data_o              (csr_data_to_write_b),
        .vtype_o                 (vtype_b),
        .vlen_o                  (vlen_b),
        .ctx_switch_o            (ctx_switch_b),
        .jump_rollback_o         (jump_rollback_b),
        .ctx_switch_target_o     (ctx_switch_target_b),
        .jump_target_o           (jump_target_b),
        .jump_o                  (jump_b),
        .interrupt_ack_o         (interrupt_ack_b_out),
        .machine_return_o        (machine_return_b),
        .raise_exception_o       (raise_exception_b),
        .exception_code_o        (exception_code_b)
    );

    execute_c #(
        .Environment (Environment),
        .MULEXT      (MULEXT),
        .ZKNEEnable  (ZKNEEnable),
        .VEnable     (VEnable),
        .VLEN        (VLEN),
        .BRANCHPRED  (BRANCHPRED)
    ) execute3 (
        .clk                     (clk),
        .reset_n                 (reset_n),
        .stall                   (stall),
        .instruction_i           (instruction_execute),
        .pc_i                    (pc_execute),
        .first_operand_i         (first_operand_execute),
        .second_operand_i        (second_operand_execute),
        .third_operand_i         (third_operand_execute),
        .rd_i                    (rd_execute),
        .rs1_i                   (rs1_execute),
        .instruction_operation_i (instruction_operation_execute),
        .instruction_compressed_i(instruction_compressed_execute),
        .vector_operation_i      (vector_operation_execute),
        .privilege_i             (privilege),
        .exc_ilegal_inst_i       (exc_ilegal_inst_execute),
        .exc_misaligned_fetch_i  (exc_misaligned_fetch_execute),
        .exc_inst_access_fault_i (exc_inst_access_fault_execute),
        .exc_load_access_fault_i (mmu_data_fault),
        .mem_read_data_i         (mem_data_i),
        .csr_address_i           (csr_addr),
        .csr_data_read_i         (csr_data_read),
        .bp_taken_i              (bp_taken_exec),
        .interrupt_pending_i     (interrupt_pending),
        .mtvec_i                 (mtvec),
        .mepc_i                  (mepc),
        // Outputs to Arbiter
        .hold_o                  (hold_c),
        .write_enable_o          (write_enable_c),
        .write_enable_fwd_o      (write_enable_fwd_c),
        .instruction_operation_o (instruction_operation_c),
        .result_o                (result_c),
        .result_fwd_o            (result_fwd_c),
        .rd_o                    (rd_c),
        .mem_address_o           (mem_address_c),
        .mem_read_enable_o       (mem_read_enable_c),
        .mem_write_enable_o      (mem_write_enable_c),
        .mem_write_data_o        (mem_write_data_c),
        .csr_read_enable_o       (csr_read_enable_c),
        .csr_write_enable_o      (csr_write_enable_c),
        .csr_operation_o         (csr_operation_c),
        .csr_data_o              (csr_data_to_write_c),
        .vtype_o                 (vtype_c),
        .vlen_o                  (vlen_c),
        .ctx_switch_o            (ctx_switch_c),
        .jump_rollback_o         (jump_rollback_c),
        .ctx_switch_target_o     (ctx_switch_target_c),
        .jump_target_o           (jump_target_c),
        .jump_o                  (jump_c),
        .interrupt_ack_o         (interrupt_ack_c_out),
        .machine_return_o        (machine_return_c),
        .raise_exception_o       (raise_exception_c),
        .exception_code_o        (exception_code_c)
    );


    arbiter arbiter1 (
        // Inputs from execute_a
        .hold_a_i(hold_a),
        .write_enable_a_i(write_enable_a),
        .write_enable_fwd_a_i(write_enable_fwd_a),
        .instruction_operation_a_i(instruction_operation_a),
        .result_a_i(result_a),
        .result_fwd_a_i(result_fwd_a),
        .rd_a_i(rd_a),
        .mem_address_a_i(mem_address_a),
        .mem_read_enable_a_i(mem_read_enable_a),
        .mem_write_enable_a_i(mem_write_enable_a),
        .mem_write_data_a_i(mem_write_data_a),
        .csr_read_enable_a_i(csr_read_enable_a),
        .csr_write_enable_a_i(csr_write_enable_a),
        .csr_operation_a_i(csr_operation_a),
        .csr_data_to_write_a_i(csr_data_to_write_a),
        .vtype_a_i(vtype_a),
        .vlen_a_i(vlen_a),
        .ctx_switch_a_i(ctx_switch_a),
        .jump_rollback_a_i(jump_rollback_a),
        .ctx_switch_target_a_i(ctx_switch_target_a),
        .jump_target_a_i(jump_target_a),
        .jump_a_i(jump_a),
        .interrupt_ack_a_i(interrupt_ack_a_out),
        .machine_return_a_i(machine_return_a),
        .raise_exception_a_i(raise_exception_a),
        .exception_code_a_i(exception_code_a),

        // Inputs from execute_b
        .hold_b_i(hold_b),
        .write_enable_b_i(write_enable_b),
        .write_enable_fwd_b_i(write_enable_fwd_b),
        .instruction_operation_b_i(instruction_operation_b),
        .result_b_i(result_b),
        .result_fwd_b_i(result_fwd_b),
        .rd_b_i(rd_b),
        .mem_address_b_i(mem_address_b),
        .mem_read_enable_b_i(mem_read_enable_b),
        .mem_write_enable_b_i(mem_write_enable_b),
        .mem_write_data_b_i(mem_write_data_b),
        .csr_read_enable_b_i(csr_read_enable_b),
        .csr_write_enable_b_i(csr_write_enable_b),
        .csr_operation_b_i(csr_operation_b),
        .csr_data_to_write_b_i(csr_data_to_write_b),
        .vtype_b_i(vtype_b),
        .vlen_b_i(vlen_b),
        .ctx_switch_b_i(ctx_switch_b),
        .jump_rollback_b_i(jump_rollback_b),
        .ctx_switch_target_b_i(ctx_switch_target_b),
        .jump_target_b_i(jump_target_b),
        .jump_b_i(jump_b),
        .interrupt_ack_b_i(interrupt_ack_b_out),
        .machine_return_b_i(machine_return_b),
        .raise_exception_b_i(raise_exception_b),
        .exception_code_b_i(exception_code_b),

        // Inputs from execute_c
        .hold_c_i(hold_c),
        .write_enable_c_i(write_enable_c),
        .write_enable_fwd_c_i(write_enable_fwd_c),
        .instruction_operation_c_i(instruction_operation_c),
        .result_c_i(result_c),
        .result_fwd_c_i(result_fwd_c),
        .rd_c_i(rd_c),
        .mem_address_c_i(mem_address_c),
        .mem_read_enable_c_i(mem_read_enable_c),
        .mem_write_enable_c_i(mem_write_enable_c),
        .mem_write_data_c_i(mem_write_data_c),
        .csr_read_enable_c_i(csr_read_enable_c),
        .csr_write_enable_c_i(csr_write_enable_c),
        .csr_operation_c_i(csr_operation_c),
        .csr_data_to_write_c_i(csr_data_to_write_c),
        .vtype_c_i(vtype_c),
        .vlen_c_i(vlen_c),
        .ctx_switch_c_i(ctx_switch_c),
        .jump_rollback_c_i(jump_rollback_c),
        .ctx_switch_target_c_i(ctx_switch_target_c),
        .jump_target_c_i(jump_target_c),
        .jump_c_i(jump_c),
        .interrupt_ack_c_i(interrupt_ack_c_out),
        .machine_return_c_i(machine_return_c),
        .raise_exception_c_i(raise_exception_c),
        .exception_code_c_i(exception_code_c),

        // Outputs
        .hold_o(hold),
        .write_enable_o(regbank_write_enable), // To RegBank and Decode
        .write_enable_fwd_o(write_enable_exec_arb), // To Decode
        .instruction_operation_o(instruction_operation_retire), // To Retire
        .result_o(result_retire),             // To Retire
        .result_fwd_o(result_exec_arb),       // To Decode
        .rd_o(rd_retire),                     // To RegBank and Decode
        .mem_address_o(mem_address),
        .mem_read_enable_o(mem_read_enable),
        .mem_write_enable_o(mem_write_enable),
        .mem_write_data_o(mem_data_o),        // To Top Level Output
        .csr_read_enable_o(csr_read_enable),
        .csr_write_enable_o(csr_write_enable),
        .csr_operation_o(csr_operation),
        .csr_data_o(csr_data_to_write),
        .vtype_o(vtype_arb),                   // To CSRBank
        .vlen_o(vlen_arb),                     // To CSRBank
        .ctx_switch_o(ctx_switch_arb),         // To Fetch and Decode
        .jump_rollback_o(jump_rollback_arb),   // To Fetch and Decode
        .ctx_switch_target_o(ctx_switch_target_arb), // To Fetch
        .jump_target_o(jump_target),           // To CSRBank
        .jump_o(jump),                         // To CSRBank
        .interrupt_ack_o(interrupt_ack_o),     // To Top Level Output / CSRBank
        .machine_return_o(MACHINE_RETURN),     // To CSRBank
        .raise_exception_o(RAISE_EXCEPTION),   // To CSRBank
        .exception_code_o(Exception_Code)      // To CSRBank
    );


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// RETIRE //////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    retire retire1 (
        .instruction_operation_i(instruction_operation_retire), // From Arbiter
        .result_i               (result_retire),                // From Arbiter
        .mem_data_i             (mem_data_i),
        .regbank_data_o         (regbank_data_writeback)
    );

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// CSRs BANK ///////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    CSRBank #(
    `ifndef SYNTH
        .PROFILING     (PROFILING     ),
        .PROFILING_FILE(PROFILING_FILE),
    `endif
        .XOSVMEnable   (XOSVMEnable   ),
        .ZIHPMEnable   (ZIHPMEnable   ),
        .COMPRESSED    (COMPRESSED    ),
        .MULEXT        (MULEXT        ),
        .VEnable       (VEnable       ),
        .VLEN          (VLEN          )
    ) CSRBank1 (
        .clk                        (clk),
        .reset_n                    (reset_n),
        .sys_reset                  (sys_reset_i),
        .read_enable_i              (csr_read_enable),    // From Arbiter
        .write_enable_i             (csr_write_enable),   // From Arbiter
        .operation_i                (csr_operation),      // From Arbiter
        .address_i                  (csr_addr),
        .data_i                     (csr_data_to_write),  // From Arbiter
        .killed                     (killed),
        .out                        (csr_data_read),
        .instruction_operation_i    (instruction_operation_execute), // This is the operation type before arbiter, used for CSR internal logic if needed
        .hazard                     (hazard),
        .stall                      (stall),
        .hold                       (hold),               // From Arbiter
        .vtype_i                    (vtype_arb),          // From Arbiter
        .vlen_i                     (vlen_arb),           // From Arbiter
        .raise_exception_i          (RAISE_EXCEPTION),    // From Arbiter
        .machine_return_i           (MACHINE_RETURN),     // From Arbiter
        .exception_code_i           (Exception_Code),     // From Arbiter
        .pc_i                       (pc_execute),
        .next_pc_i                  (pc_decode),
        .instruction_i              (instruction_execute),
        .instruction_compressed_i   (instruction_compressed_execute),
        .jump_misaligned_i          (jump_misaligned),
        .jump_i                     (jump),               // From Arbiter
        .jump_target_i              (jump_target),        // From Arbiter
        .mtime_i                    (mtime_i),
        .irq_i                      (irq_i),
        .interrupt_ack_i            (interrupt_ack_o),    // From Arbiter (also a top-level output)
        .interrupt_pending_o        (interrupt_pending),
        .privilege_o                (privilege),
        .mepc                       (mepc),
        .mtvec                      (mtvec),
    // XOSVM Signals
        .mvmctl_o                   (mvmctl),
        .mvmdo_o                    (mvmdo),
        .mvmds_o                    (mvmds),
        .mvmdm_o                    (mvmdm),
        .mvmio_o                    (mvmio),
        .mvmis_o                    (mvmis),
        .mvmim_o                    (mvmim)
    );

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////// MEMORY SIGNALS //////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    if (XOSVMEnable == 1'b1) begin : gen_d_mmu_on
        mmu d_mmu (
            .en_i           (mmu_en        ),
            .mask_i         (mvmdm         ),
            .offset_i       (mvmdo         ),
            .size_i         (mvmds         ),
            .address_i      (mem_address   ), // From Arbiter
            .exception_o    (mmu_data_fault),
            .address_o      (mem_address_o )  // To Top Level Output
        );
    end
    else begin : gen_d_mmu_off
        assign mmu_data_fault = 1'b0;
        assign mem_address_o  = mem_address; // From Arbiter to Top Level Output
    end

    always_comb begin
        if ((mem_write_enable != '0 || mem_read_enable) && !mmu_data_fault) // mem_write_enable and mem_read_enable are from Arbiter
            mem_operation_enable_o = 1'b1;
        else
            mem_operation_enable_o = 1'b0;
    end

    assign mem_write_enable_o = mem_write_enable; // From Arbiter to Top Level Output

endmodule