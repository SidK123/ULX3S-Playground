`include "defines.sv"

module rf #(
   parameter NUM_REGS = 32
)(
   input  logic  clk, reset,
   input  logic  re, we,
   input  logic  [$clog2(NUM_REGS) - 1 : 0] rs1, rs2, rd,
   input  data_t wr_data,
   output data_t rs1_data, rs2_data
);

   data_t [NUM_REGS - 1 : 0] regs;

   always_ff @(posedge clk) begin
      if (reset) begin
         for (int i = 0; i < NUM_REGS; i++) begin
            regs[i] <= '0;
         end
      end else if (we) begin
         regs[rd] <= wr_data;
      end
   end

   assign rs1_data = regs[rs1];
   assign rs2_data = regs[rs2];

endmodule : rf 
