`timescale 1ns/1ps

module simple_example_vhdl_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  // simple_example ports
  wire start_ready;
  wire [0:0] end_out;
  wire end_valid;
  wire end_ready = 1'b1;

  wire [31:0] a_address0;
  wire a_ce0;
  wire a_we0;
  wire [31:0] a_dout0; // outputs from DUT
  wire [31:0] a_din0;  // inputs to DUT

  wire [31:0] a_address1;
  wire a_ce1;
  wire a_we1;
  wire [31:0] a_dout1;
  wire [31:0] a_din1;

  simple_example dut (
    .clk(clk),
    .rst(rst),
    .start_in(tstart),
    .start_valid(tstart),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),

    // a interface
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

  // memory arrays
  reg [31:0] a_mem [127:0];

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
    for (int i = 0; i < 128; i++) begin
      a_mem[i] = 32'd0;
    end
    
    // Wait for the operations to complete
    #3000;
    
    // Display some of the output memory to verify correctness
    for (int i = 0; i < 5; i++) begin
      $display("x[%0d] = %0d", i, a_mem[i]);
    end
    $display("...");
    for (int i = 123; i < 128; i++) begin
      $display("x[%0d] = %0d", i, a_mem[i]);
    end
    
    $finish;
  end

endmodule
