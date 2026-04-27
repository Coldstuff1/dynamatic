`timescale 1ns/1ps

module vector_rescale_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire a_p0_addr_en;
  wire [9:0] a_p0_addr_data;
  wire a_p0_rd_en;
  wire [31:0] a_p0_rd_data;
  wire a_dout_valid;

  wire b_p0_addr_en;
  wire [9:0] b_p0_addr_data;
  wire b_p0_wr_en;
  wire [31:0] b_p0_wr_data;

  reg [31:0] c;

  vector_rescale dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .a_p0_addr_en(a_p0_addr_en),
    .a_p0_addr_data(a_p0_addr_data),
    .a_p0_rd_en(a_p0_rd_en),
    .a_p0_rd_data(a_p0_rd_data),
    .c(c),
    .b_p0_addr_en(b_p0_addr_en),
    .b_p0_addr_data(b_p0_addr_data),
    .b_p0_wr_en(b_p0_wr_en),
    .b_p0_wr_data(b_p0_wr_data)
  );

  reg [31:0] a_mem [1023:0];
  reg [31:0] b_mem [1023:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) a_mem_rd (
    .mem(a_mem),
    .rd_en(a_p0_rd_en),
    .addr(a_p0_addr_data),
    .dout_valid(a_dout_valid),
    .dout(a_p0_rd_data),
    .clk(clk)
  );

  memref_wr #(
    .WIDTH(32),
    .SIZE(1024)
  ) b_mem_wr (
    .mem(b_mem),
    .wr_en(b_p0_wr_en),
    .addr(b_p0_addr_data),
    .din(b_p0_wr_data),
    .clk(clk)
  );

  integer cycle_count = 0;
  
  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
  end

  initial begin
    // Set rescaling factor
    c = 32'd5;
    
    // Initialize memories
    for (int i = 0; i < 1024; i++) begin
      a_mem[i] = i;
      b_mem[i] = 32'd0;
    end
    
    // Wait for the operations to complete
    #500000;
    
    // Display some of the output memory to verify correctness
    $display("b partial results:");
    for (int i = 0; i < 10; i++) begin
      $display("b[%0d] = %0d", i, b_mem[i]);
    end
    $display("...");
    for (int i = 1014; i < 1024; i++) begin
      $display("b[%0d] = %0d", i, b_mem[i]);
    end
    
    $finish;
  end

endmodule
