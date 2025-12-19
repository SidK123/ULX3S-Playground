`include "defines.sv"
`include "queue.sv"

module compute_node #(
   parameter OP = ADD
)(
   input  logic    clk, reset,
   input  instr_t  instr, 
   output logic    request_data,
   input  logic    data_in_valid,
   output data_t   data,
   output logic    data_out_valid
);

endmodule : compute_node

