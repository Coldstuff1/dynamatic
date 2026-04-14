`timescale 1ns/1ps

module simple_example_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire x_p0_addr_en;
  wire [6:0] x_p0_addr_data;
  wire x_p0_wr_en;
  wire [31:0] x_p0_wr_data;

  simple_example dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .x_p0_addr_en(x_p0_addr_en),
    .x_p0_addr_data(x_p0_addr_data),
    .x_p0_wr_en(x_p0_wr_en),
    .x_p0_wr_data(x_p0_wr_data)
  );

  reg [31:0] x_mem [127:0];

  memref_wr #(
    .WIDTH(32),
    .SIZE(128)
  ) x_mem_wr (
    .mem(x_mem),
    .wr_en(x_p0_wr_en),
    .addr(x_p0_addr_data),
    .din(x_p0_wr_data),
    .clk(clk)
  );

  initial begin
    // $dumpfile("simple_example.vcd");
    // $dumpvars(0, simple_example_tb);
    
    for (int i = 0; i < 128; i++) begin
      x_mem[i] = 32'd0;
    end
    
    // Wait for the operations to complete
    #3000;
    
    // Display some of the output memory to verify correctness
    for (int i = 0; i < 5; i++) begin
      $display("x[%0d] = %0d", i, x_mem[i]);
    end
    $display("...");
    for (int i = 123; i < 128; i++) begin
      $display("x[%0d] = %0d", i, x_mem[i]);
    end
    
    $finish;
  end

endmodule
