`timescale 1ns/1ps

module gesummv_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire [31:0] alpha = 32'd2;
  wire [31:0] beta = 32'd3;

  wire tmp_p0_addr_en;
  wire [2:0] tmp_p0_addr_data;
  wire tmp_p0_wr_en;
  wire [31:0] tmp_p0_wr_data;

  wire A_p0_addr_en;
  wire [5:0] A_p0_addr_data;
  wire A_p0_rd_en;
  wire [31:0] A_p0_rd_data;
  wire A_p0_rd_data_valid;

  wire B_p0_addr_en;
  wire [5:0] B_p0_addr_data;
  wire B_p0_rd_en;
  wire [31:0] B_p0_rd_data;
  wire B_p0_rd_data_valid;

  wire X_p0_addr_en;
  wire [2:0] X_p0_addr_data;
  wire X_p0_rd_en;
  wire [31:0] X_p0_rd_data;
  wire X_p0_rd_data_valid;

  wire Y_p0_addr_en;
  wire [2:0] Y_p0_addr_data;
  wire Y_p0_wr_en;
  wire [31:0] Y_p0_wr_data;

  gesummv dut(
    .alpha(alpha),
    .beta(beta),
    .tmp_p0_addr_en(tmp_p0_addr_en),
    .tmp_p0_addr_data(tmp_p0_addr_data),
    .tmp_p0_wr_en(tmp_p0_wr_en),
    .tmp_p0_wr_data(tmp_p0_wr_data),
    .A_p0_addr_en(A_p0_addr_en),
    .A_p0_addr_data(A_p0_addr_data),
    .A_p0_rd_en(A_p0_rd_en),
    .A_p0_rd_data(A_p0_rd_data),
    .B_p0_addr_en(B_p0_addr_en),
    .B_p0_addr_data(B_p0_addr_data),
    .B_p0_rd_en(B_p0_rd_en),
    .B_p0_rd_data(B_p0_rd_data),
    .X_p0_addr_en(X_p0_addr_en),
    .X_p0_addr_data(X_p0_addr_data),
    .X_p0_rd_en(X_p0_rd_en),
    .X_p0_rd_data(X_p0_rd_data),
    .Y_p0_addr_en(Y_p0_addr_en),
    .Y_p0_addr_data(Y_p0_addr_data),
    .Y_p0_wr_en(Y_p0_wr_en),
    .Y_p0_wr_data(Y_p0_wr_data),
    .t(tstart),
    .clk(clk),
    .rst(rst)
  );

  reg [31:0] tmp_mem [7:0];
  reg [31:0] Y_mem [7:0];
  reg [31:0] A_mem [63:0];
  reg [31:0] B_mem [63:0];
  reg [31:0] X_mem [7:0];

  memref_wr #(
    .WIDTH(32),
    .SIZE(8)
  ) tmp_mem_wr (
    .mem(tmp_mem),
    .wr_en(tmp_p0_wr_en),
    .addr(tmp_p0_addr_data),
    .din(tmp_p0_wr_data),
    .clk(clk)
  );

  memref_wr #(
    .WIDTH(32),
    .SIZE(8)
  ) Y_mem_wr (
    .mem(Y_mem),
    .wr_en(Y_p0_wr_en),
    .addr(Y_p0_addr_data),
    .din(Y_p0_wr_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(64)
  ) A_mem_rd (
    .mem(A_mem),
    .rd_en(A_p0_rd_en),
    .addr(A_p0_addr_data),
    .dout_valid(A_p0_rd_data_valid),
    .dout(A_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(64)
  ) B_mem_rd (
    .mem(B_mem),
    .rd_en(B_p0_rd_en),
    .addr(B_p0_addr_data),
    .dout_valid(B_p0_rd_data_valid),
    .dout(B_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(8)
  ) X_mem_rd (
    .mem(X_mem),
    .rd_en(X_p0_rd_en),
    .addr(X_p0_addr_data),
    .dout_valid(X_p0_rd_data_valid),
    .dout(X_p0_rd_data),
    .clk(clk)
  );

  initial begin
    // $dumpfile("gesummv.vcd");
    // $dumpvars(0, gesummv_tb);
    
    // Initialize memory with dummy data
    for (int i = 0; i < 8; i++) begin
      X_mem[i] = i; 
      tmp_mem[i] = 0;
      Y_mem[i] = 0;
    end
    for (int i = 0; i < 64; i++) begin
      A_mem[i] = 1; 
      B_mem[i] = 2; 
    end
    
    // Wait for the operations to complete. 
    #1500;
    
    $display("Simulation complete.");
    for (int i = 0; i < 8; i++) begin
      $display("Y[%0d] = %0d", i, Y_mem[i]);
    end
    $finish;
  end

endmodule
