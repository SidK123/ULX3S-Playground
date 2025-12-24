`include "defines.sv"
`include "queue.sv"

module compute_node 
(
   input  logic    clk, reset,
   input  instr_t  instr, 
   output logic    request_data,
   input  logic    data_in_valid,
   output data_t   data,
   output logic    data_out_valid
);

   opcode_t op;

endmodule : compute_node

