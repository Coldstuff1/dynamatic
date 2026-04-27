`timescale 1ns/1ps

module matrix_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire inA_p0_addr_en;
  wire [9:0] inA_p0_addr_data;
  wire inA_p0_rd_en;
  wire [31:0] inA_p0_rd_data;
  wire inA_dout_valid;

  wire inB_p0_addr_en;
  wire [9:0] inB_p0_addr_data;
  wire inB_p0_rd_en;
  wire [31:0] inB_p0_rd_data;
  wire inB_dout_valid;

  wire outC_p0_addr_en;
  wire [9:0] outC_p0_addr_data;
  wire outC_p0_wr_en;
  wire [31:0] outC_p0_wr_data;

  matrix dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .inA_p0_addr_en(inA_p0_addr_en),
    .inA_p0_addr_data(inA_p0_addr_data),
    .inA_p0_rd_en(inA_p0_rd_en),
    .inA_p0_rd_data(inA_p0_rd_data),
    .inB_p0_addr_en(inB_p0_addr_en),
    .inB_p0_addr_data(inB_p0_addr_data),
    .inB_p0_rd_en(inB_p0_rd_en),
    .inB_p0_rd_data(inB_p0_rd_data),
    .outC_p0_addr_en(outC_p0_addr_en),
    .outC_p0_addr_data(outC_p0_addr_data),
    .outC_p0_wr_en(outC_p0_wr_en),
    .outC_p0_wr_data(outC_p0_wr_data)
  );

  reg [31:0] inA_mem [1023:0];
  reg [31:0] inB_mem [1023:0];
  reg [31:0] outC_mem [1023:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) inA_mem_rd (
    .mem(inA_mem),
    .rd_en(inA_p0_rd_en),
    .addr(inA_p0_addr_data),
    .dout_valid(inA_dout_valid),
    .dout(inA_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) inB_mem_rd (
    .mem(inB_mem),
    .rd_en(inB_p0_rd_en),
    .addr(inB_p0_addr_data),
    .dout_valid(inB_dout_valid),
    .dout(inB_p0_rd_data),
    .clk(clk)
  );

  memref_wr #(
    .WIDTH(32),
    .SIZE(1024)
  ) outC_mem_wr (
    .mem(outC_mem),
    .wr_en(outC_p0_wr_en),
    .addr(outC_p0_addr_data),
    .din(outC_p0_wr_data),
    .clk(clk)
  );

  integer cycle_count = 0;
  
  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
  end

  initial begin
    // $dumpfile("matrix.vcd");
    // $dumpvars(0, matrix_tb);
    
    for (int i = 0; i < 1024; i++) begin
      inA_mem[i] = i;
      inB_mem[i] = i % 10;
      outC_mem[i] = 32'd0;
    end
    
    // Wait for the operations to complete
    #500000;
    
    // Display some of the output memory to verify correctness
    $display("outC partial results:");
    for (int i = 0; i < 10; i++) begin
      $display("outC[%0d] = %0d", i, outC_mem[i]);
    end
    $display("...");
    for (int i = 1014; i < 1024; i++) begin
      $display("outC[%0d] = %0d", i, outC_mem[i]);
    end
    
    $finish;
  end

endmodule
