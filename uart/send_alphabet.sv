// `define DEBUG
`ifdef DEBUG
module send_alphabet(
   input logic clk_25mhz, reset,
   output logic ftdi_rxd,
   output logic [7:0] led
);
`else
module send_alphabet(
   input logic clk_25mhz,
   output logic ftdi_rxd,
   output logic [7:0] led
);
`endif

   logic clk;
   logic uart_tx_ready, uart_tx_done, uart_tick;
   logic [7:0] increment_counter;
   logic [7:0] sending_data;
   assign clk = clk_25mhz;

   enum logic [3:0] {SENDING, WAIT1, WAIT2} currState, nextState;

   `ifdef DEBUG
      always_ff @(posedge clk) begin
         if (reset) begin
            currState <= WAIT1;
         end else begin
            currState <= nextState;
         end
      end
      always_ff @(posedge clk) begin
         if (reset || (increment_counter == 8'd25 && uart_tx_done)) begin
            increment_counter <= '0;
         end else if (uart_tx_done) begin
            increment_counter <= increment_counter + 1;
         end
      end
   `else
      always_ff @(posedge clk) begin
         currState <= nextState;
      end
      always_ff @(posedge clk) begin
         if (increment_counter == 8'd25 && uart_tx_done) begin
            increment_counter <= '0;
         end else if (uart_tx_done) begin
            increment_counter <= increment_counter + 1;
         end
      end
   `endif

   `ifdef DEBUG
      uart_tx byte_sender (.clk_25mhz(clk_25mhz),
                           .reset(reset),
                           .uart_tx_ready(uart_tx_ready),
                           .uart_tx_done(uart_tx_done),
                           .uart_tick_out(uart_tick),
                           .led(led),
                           .ftdi_txd(ftdi_rxd),
                           .sending_data(sending_data)
                           );
   `else
      uart_tx byte_sender (.clk_25mhz(clk_25mhz),
                           .uart_tx_ready(uart_tx_ready),
                           .uart_tx_done(uart_tx_done),
                           .uart_tick_out(uart_tick),
                           .led(led),
                           .ftdi_txd(ftdi_rxd),
                           .sending_data(sending_data)
                           );
   `endif

   assign sending_data = 8'd65 + increment_counter;

   always_comb begin
     uart_tx_ready = 1'b0;
     nextState = WAIT1;
      case (currState)
         WAIT1: begin
            uart_tx_ready = 1'b0;
            nextState = uart_tick ? WAIT2 : WAIT1;
         end
         WAIT2: begin
            uart_tx_ready = 1'b0;
            nextState = uart_tick ? SENDING : WAIT2;
         end
         SENDING: begin
            uart_tx_ready = 1'b1;
            nextState = uart_tx_done ? WAIT1 : SENDING;
         end
      endcase
   end

endmodule : send_alphabet
