`timescale 1ns/1ps

module fir_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire di_p0_addr_en;
  wire [9:0] di_p0_addr_data;
  wire di_p0_rd_en;
  wire [31:0] di_p0_rd_data;
  wire di_p0_rd_data_valid;
  
  wire idx_p0_addr_en;
  wire [9:0] idx_p0_addr_data;
  wire idx_p0_rd_en;
  wire [31:0] idx_p0_rd_data;
  wire idx_p0_rd_data_valid;

  fir dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .di_p0_addr_en(di_p0_addr_en),
    .di_p0_addr_data(di_p0_addr_data),
    .di_p0_rd_en(di_p0_rd_en),
    .di_p0_rd_data(di_p0_rd_data),
    .idx_p0_addr_en(idx_p0_addr_en),
    .idx_p0_addr_data(idx_p0_addr_data),
    .idx_p0_rd_en(idx_p0_rd_en),
    .idx_p0_rd_data(idx_p0_rd_data)
  );

  reg [31:0] di_mem [1023:0];
  reg [31:0] idx_mem [1023:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) di_mem_rd (
    .mem(di_mem),
    .rd_en(di_p0_rd_en),
    .addr(di_p0_addr_data),
    .dout_valid(di_p0_rd_data_valid),
    .dout(di_p0_rd_data),
    .clk(clk)
  );

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) idx_mem_rd (
    .mem(idx_mem),
    .rd_en(idx_p0_rd_en),
    .addr(idx_p0_addr_data),
    .dout_valid(idx_p0_rd_data_valid),
    .dout(idx_p0_rd_data),
    .clk(clk)
  );

  initial begin
    // $dumpfile("fir.vcd");
    // $dumpvars(0, fir_tb);
    
    // Initialize memory with dummy data
    for (int i = 0; i < 1024; i++) begin
      di_mem[i] = i; 
      idx_mem[i] = 1;
    end
    
    // Wait for the operations to complete. 
    // Since N=1024 and II=1, it takes roughly 1024 cycles, so wait enough time.
    #15000;
    
    $display("Simulation complete.");
    $finish;
  end

endmodule
