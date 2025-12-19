`include "defines.sv"

module queue #(
   parameter CAPACITY = 32,
   type elem_t = data_t 
)(
   input  logic  clk, reset,
   input  elem_t wr_data, 
   input  logic  re, we,
   output logic  full, empty,
   output elem_t rd_data
);

   logic  [$clog2(CAPACITY) : 0] read_ptr, write_ptr;
   elem_t [CAPACITY - 1 : 0] data_arr; 

   always_ff @(posedge clk, negedge reset) begin
      if (~reset) begin
         read_ptr  <= '0;
         write_ptr <= '0;
      end else if (re && ~empty) begin
         read_ptr <= read_ptr + 1;
      end else if (we && ~full) begin
         write_ptr <= write_ptr + 1;
         data_arr[write_ptr] <= wr_data; 
      end
   end

   assign rd_data = data_arr[read_ptr];

   assign empty = (write_ptr == read_ptr);
   assign full = (write_ptr[$clog2(CAPACITY) - 1 : 0] == read_ptr[$clog2(CAPACITY) - 1 : 0]) && (write_ptr[$clog2(CAPACITY)] == ~read_ptr[$clog2(CAPACITY)];

endmodule : queue
