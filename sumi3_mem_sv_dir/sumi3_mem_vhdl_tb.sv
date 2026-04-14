`timescale 1ns/1ps

module sumi3_mem_vhdl_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  wire start_ready;
  wire [31:0] end_out;
  wire end_valid;
  wire end_ready = 1'b1;

  wire [31:0] a_address0;
  wire a_ce0;
  wire a_we0;
  wire [31:0] a_dout0; // output from dut
  wire [31:0] a_din0;  // input to dut

  wire [31:0] a_address1;
  wire a_ce1;
  wire a_we1;
  wire [31:0] a_dout1;
  wire [31:0] a_din1;

  sumi3_mem dut (
    .clk(clk),
    .rst(rst),
    .start_in(tstart),
    .start_valid(tstart),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),

    .a_address0(a_address0),
    .a_ce0(a_ce0),
    .a_we0(a_we0),
    .a_dout0(a_dout0),
    .a_din0(a_din0),
    .a_address1(a_address1),
    .a_ce1(a_ce1),
    .a_we1(a_we1),
    .a_dout1(a_dout1),
    .a_din1(a_din1)
  );

  reg [31:0] a_mem [1023:0];

  // a memory port 0 logic
  reg [31:0] a_din0_reg;
  assign a_din0 = a_din0_reg;
  always @(posedge clk) begin
    if (a_ce0) begin
      if (a_we0)
        a_mem[a_address0] <= a_dout0;
      else
        a_din0_reg <= a_mem[a_address0];
    end
  end

  // a memory port 1 logic
  reg [31:0] a_din1_reg;
  assign a_din1 = a_din1_reg;
  always @(posedge clk) begin
    if (a_ce1) begin
      if (a_we1)
        a_mem[a_address1] <= a_dout1;
      else
        a_din1_reg <= a_mem[a_address1];
    end
  end

  initial begin
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
