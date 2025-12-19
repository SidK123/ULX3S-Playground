`include "defines.sv"
`include "queue.sv"

module node_top (
   input  logic    clk, reset,
   input  instr_t  instr,
   input  logic    data_in_valid,
   output logic    busy, // If node cannot handle any incoming instructions.
   output instr_t  data_out,
   output logic    data_out_valid
); 

   logic    instr_queue_re, instr_queue_we;
   logic    compute_node_req_data;
   instr_t  dispatched_instr;

   assign instr_queue_re = compute_node_req_data;
   assign instr_queue_we = data_in_valid; 

   queue #(32, instr_t)  
   instr_queue (.clk(clk),
                .reset(reset),
                .rd_data(dispatched_instr),
                .wr_data(instr),
                .re(instr_queue_re),
                .we(instr_queue_we),
                .full(instr_queue_full),
                .empty(instr_queue_empty)
               );

   compute_node #(ADD) 
   compute (.clk(clk),
            .reset(reset),
            .data_in(dispatched_instr),
            .request_data(compute_node_req_data),
            .instr(instr),
            .data_in_valid(data_in_valid),
            .data(data_out),
            .data_out_valid(data_out_valid)
           );

endmodule : node_top
