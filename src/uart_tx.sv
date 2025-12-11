`define DEBUG
`ifdef DEBUG
module uart_tx(
   input logic clk_25mhz, reset,
   output logic [7:0] led,
   output logic ftdi_txd  
); 
`else 
module uart_tx(
   input logic clk_25mhz, 
   output logic [7:0] led,
   output logic ftdi_txd  
); 
`endif

   logic clk;
   assign clk = clk_25mhz;

   localparam NUM_CYCLES = 2604; // Using a pyserial baud rate of 10 KHz, and local clock is 25 MHz (math!).
   localparam STARTING_DATA = 8'h41;
   localparam NUM_INCREMENTS = 8'd25;
   
   logic uart_tick;
   logic [7:0] current_data;
   logic [2:0] current_bit_of_byte; 
   logic [7:0] shifted_data;
   logic data_wraparound;
   logic [7:0] increment_counter;
   logic [$clog2(NUM_CYCLES):0] cycle_counter;
   enum logic [3:0] {IDLE, START, DATA, STOP} currState, nextState;

   assign uart_tick = (cycle_counter == NUM_CYCLES); 
   assign data_wraparound = (increment_counter == NUM_INCREMENTS); 
   assign current_data = STARTING_DATA + increment_counter;

   `ifdef DEBUG
   always_ff @(posedge clk) begin
      if (reset) begin
         increment_counter <= '0;
      end else if (data_wraparound && current_bit_of_byte == 3'h7 && uart_tick) begin
         increment_counter <= '0;
      end else if (current_bit_of_byte == 3'h7 && uart_tick) begin
         increment_counter <= increment_counter + 1; 
      end
   end

   always_ff @(posedge clk) begin
      if (reset) begin
         cycle_counter <= '0;
      end else if (uart_tick) begin
         cycle_counter <= '0;
      end else begin
         cycle_counter <= cycle_counter + 1;
      end
   end

   always_ff @(posedge clk) begin
      if (reset) begin
         current_bit_of_byte <= '0;
      end else if (currState == DATA && uart_tick) begin
         current_bit_of_byte <= current_bit_of_byte + 1; // Should wrap around after all 8 bits of the byte, and we shift the data we're sending out
      end 
   end

   always_ff @(posedge clk) begin
      if (reset) begin
         currState <= IDLE;
      end else begin
         currState <= nextState;
      end
   end
   `else 
   always_ff @(posedge clk) begin
      if (data_wraparound && current_bit_of_byte == 3'h7 && uart_tick) begin
         increment_counter <= '0;
      end else if (current_bit_of_byte == 3'h7 && uart_tick) begin
         increment_counter <= increment_counter + 1; 
      end
   end

   always_ff @(posedge clk) begin
      if (uart_tick) begin
         cycle_counter <= '0;
      end else begin
         cycle_counter <= cycle_counter + 1;
      end
   end

   always_ff @(posedge clk) begin
      if (currState == DATA && uart_tick) begin
         current_bit_of_byte <= current_bit_of_byte + 1; // Should wrap around after all 8 bits of the byte, and we shift the data we're sending out.
      end 
   end

   always_ff @(posedge clk) begin
      currState <= nextState;
   end
   `endif

   assign led = current_data;
   assign shifted_data = (current_data >> current_bit_of_byte);
   // assign ftdi_txd = shifted_data[0];

   always_comb begin
      ftdi_txd = 1'b1;
      nextState = IDLE;
      case (currState)
         IDLE: begin
            ftdi_txd = 1'b1;
            nextState = uart_tick ? START : IDLE;
         end
         START: begin
            ftdi_txd = 1'b0;
            nextState = uart_tick ? DATA : START;
         end 
         DATA: begin
            ftdi_txd = shifted_data[0];
            nextState = (current_bit_of_byte == 3'd7 && uart_tick) ? STOP : DATA;
         end
         STOP: begin
            ftdi_txd = 1'b1;
            nextState = uart_tick ? IDLE : STOP;
         end
      endcase
   end

endmodule : uart_tx
