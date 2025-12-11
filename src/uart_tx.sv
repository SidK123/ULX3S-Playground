module uart_tx(
   input logic clk_25mhz,
   output logic ftdi_txd 
); 

   logic clk;
   assign clk = clk_25mhz;

   localparam NUM_CYCLES = 2500; // Using a pyserial baud rate of 10 KHz, and local clock is 25 MHz (math!).
   localparam STARTING_DATA = 8'h41;
   localparam NUM_INCREMENTS = 25;
   
   logic uart_tick;
   logic [7:0] current_data;
   logic [2:0] current_bit_of_byte; 
   logic data_wraparound;
   logic [$clog2(NUM_INCREMENTS):0] increment_counter;
   logic [$clog2(NUM_CYCLES):0] cycle_counter;

   assign uart_tick = (cycle_counter == NUM_CYCLES); 
   assign data_wraparound = (increment_counter == NUM_INCREMENTS); 
   assign current_data = STARTING_DATA + increment_counter;

   always_ff @(posedge clk) begin
      if (data_wraparound) begin
         increment_counter <= increment_counter + 1; 
      end 
   end

   always_ff @(posedge clk) begin
      if (uart_tick) begin
         cycle_counter <= '0;
         current_bit_of_byte <= current_bit_of_byte + 1; // Should wrap around after all 8 bits of the byte, and we shift the data we're sending out.
      end else begin
         cycle_counter <= cycle_counter + 1;
      end
   end

   assign ftdi_txd = (current_data >> current_bit_of_byte) & 8'h1;

endmodule : uart_tx
