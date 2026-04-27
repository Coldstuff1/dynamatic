`timescale 1ns/1ps

module matvec_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire m_p0_addr_en;
  wire [5:0] m_p0_addr_data;
  wire m_p0_rd_en;
  wire [31:0] m_p0_rd_data;
  wire m_dout_valid;

  wire v_p0_addr_en;
  wire [2:0] v_p0_addr_data;
  wire v_p0_rd_en;
  wire [31:0] v_p0_rd_data;
  wire v_dout_valid;

  wire out_p0_addr_en;
  wire [2:0] out_p0_addr_data;
  wire out_p0_wr_en;
  wire [31:0] out_p0_wr_data;

  matvec dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .m_p0_addr_en(m_p0_addr_en),
    .m_p0_addr_data(m_p0_addr_data),
    .m_p0_rd_en(m_p0_rd_en),
    .m_p0_rd_data(m_p0_rd_data),
    .v_p0_addr_en(v_p0_addr_en),
    .v_p0_addr_data(v_p0_addr_data),
    .v_p0_rd_en(v_p0_rd_en),
    .v_p0_rd_data(v_p0_rd_data),
    .out_p0_addr_en(out_p0_addr_en),
    .out_p0_addr_data(out_p0_addr_data),
    .out_p0_wr_en(out_p0_wr_en),
    .out_p0_wr_data(out_p0_wr_data)
  );

  reg [31:0] m_mem [63:0];
  reg [31:0] v_mem [7:0];
  reg [31:0] out_mem [7:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(64)
  ) m_mem_rd (
    .mem(m_mem),
    .rd_en(m_p0_rd_en),
    .addr(m_p0_addr_data),
    .dout_valid(m_dout_valid),
    .dout(m_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(8)
  ) v_mem_rd (
    .mem(v_mem),
    .rd_en(v_p0_rd_en),
    .addr(v_p0_addr_data),
    .dout_valid(v_dout_valid),
    .dout(v_p0_rd_data),
    .clk(clk)
  );

  memref_wr #(
    .WIDTH(32),
    .SIZE(8)
  ) out_mem_wr (
    .mem(out_mem),
    .wr_en(out_p0_wr_en),
    .addr(out_p0_addr_data),
    .din(out_p0_wr_data),
    .clk(clk)
  );

  initial begin
    // Initialize matrices
    for (int i = 0; i < 64; i++) begin
      m_mem[i] = i;
    end
    for (int i = 0; i < 8; i++) begin
      v_mem[i] = i;
      out_mem[i] = 32'd0;
    end
    
    // Wait for the operations to complete
    #10000;
    
    // Display the output memory to verify correctness
    $display("out results:");
    for (int i = 0; i < 8; i++) begin
      $display("out[%0d] = %0d", i, out_mem[i]);
    end
    
    $finish;
  end

endmodule
