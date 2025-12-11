module uart_tx_tb ();
   logic clk_25mhz, ftdi_txd;
   logic [7:0] led;

   uart_tx dut(.clk_25mhz(clk_25mhz), 
               .ftdi_txd(ftdi_txd), 
               .led(led));

   initial begin
      clk_25mhz = 1'b0;
      forever #5 clk_25mhz = ~clk_25mhz;
   end

   initial begin
      for (int i = 0; i < 32'd650_000; i++) begin
         @(posedge clk_25mhz);
      end
      $finish;
   end

endmodule : uart_tx_tb
