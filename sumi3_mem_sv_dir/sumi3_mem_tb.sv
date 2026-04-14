`timescale 1ns/1ps

module sumi3_mem_tb();
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
  wire a_p0_rd_data_valid;
  
  sumi3_mem dut(
    .clk(clk),
    .rst(rst),
    .t(tstart),
    .a_p0_addr_en(a_p0_addr_en),
    .a_p0_addr_data(a_p0_addr_data),
    .a_p0_rd_en(a_p0_rd_en),
    .a_p0_rd_data(a_p0_rd_data)
  );

  reg [31:0] a_mem [1023:0];

  memref_rd #(
    .WIDTH(32),
    .SIZE(1024)
  ) a_mem_rd (
    .mem(a_mem),
    .rd_en(a_p0_rd_en),
    .addr(a_p0_addr_data),
    .dout_valid(a_p0_rd_data_valid),
    .dout(a_p0_rd_data),
    .clk(clk)
  );

  integer cycle_count = 0;
  
  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
  end

  initial begin
    // $dumpfile("sumi3_mem.vcd");
    // $dumpvars(0, sumi3_mem_tb);
    
    // Initialize memory with dummy data
    for (int i = 0; i < 1024; i++) begin
      a_mem[i] = i; 
    end
    
    // Wait for the operations to complete. 
    // Since N=1024 and II=1, it takes at least 1024 cycles, so wait enough time.
    #15000;
    
    $display("Simulation complete.");
    $finish;
  end

endmodule
