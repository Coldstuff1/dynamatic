`timescale 1ns/1ps

module stencil_2d_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire orig_p0_addr_en;
  wire [9:0] orig_p0_addr_data;
  wire orig_p0_rd_en;
  wire [31:0] orig_p0_rd_data;
  wire orig_dout_valid;

  wire filter_p0_addr_en;
  wire [3:0] filter_p0_addr_data;
  wire filter_p0_rd_en;
  wire [31:0] filter_p0_rd_data;
  wire filter_dout_valid;

  wire sol_p0_addr_en;
  wire [9:0] sol_p0_addr_data;
  wire sol_p0_wr_en;
  wire [31:0] sol_p0_wr_data;

  stencil_2d dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .orig_p0_addr_en(orig_p0_addr_en),
    .orig_p0_addr_data(orig_p0_addr_data),
    .orig_p0_rd_en(orig_p0_rd_en),
    .orig_p0_rd_data(orig_p0_rd_data),
    .filter_p0_addr_en(filter_p0_addr_en),
    .filter_p0_addr_data(filter_p0_addr_data),
    .filter_p0_rd_en(filter_p0_rd_en),
    .filter_p0_rd_data(filter_p0_rd_data),
    .sol_p0_addr_en(sol_p0_addr_en),
    .sol_p0_addr_data(sol_p0_addr_data),
    .sol_p0_wr_en(sol_p0_wr_en),
    .sol_p0_wr_data(sol_p0_wr_data)
  );

  reg [31:0] orig_mem [1023:0];
  reg [31:0] filter_mem [15:0];
  reg [31:0] sol_mem [1023:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) orig_mem_rd (
    .mem(orig_mem),
    .rd_en(orig_p0_rd_en),
    .addr(orig_p0_addr_data),
    .dout_valid(orig_dout_valid),
    .dout(orig_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(16)
  ) filter_mem_rd (
    .mem(filter_mem),
    .rd_en(filter_p0_rd_en),
    .addr(filter_p0_addr_data),
    .dout_valid(filter_dout_valid),
    .dout(filter_p0_rd_data),
    .clk(clk)
  );

  memref_wr #(
    .WIDTH(32),
    .SIZE(1024)
  ) sol_mem_wr (
    .mem(sol_mem),
    .wr_en(sol_p0_wr_en),
    .addr(sol_p0_addr_data),
    .din(sol_p0_wr_data),
    .clk(clk)
  );

  integer cycle_count = 0;
  
  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
  end

  initial begin
    for (int i = 0; i < 1024; i++) begin
      orig_mem[i] = i;
      sol_mem[i] = 32'd0;
    end
    
    for (int i = 0; i < 16; i++) begin
      filter_mem[i] = i % 5;
    end
    
    // Wait for the operations to complete
    #500000;
    
    // Display some of the output memory to verify correctness
    $display("sol partial results:");
    for (int i = 0; i < 10; i++) begin
      $display("sol[%0d] = %0d", i, sol_mem[i]);
    end
    $display("...");
    for (int i = 1014; i < 1024; i++) begin
      $display("sol[%0d] = %0d", i, sol_mem[i]);
    end
    
    $finish;
  end

endmodule
