`timescale 1ns/1ps

module stencil_2d_tb();

  logic clk;
  logic rst;

  // Handshake signals
  logic [0:0] start_in;
  logic start_valid;
  logic start_ready;
  logic [31:0] end_out;
  logic end_valid;
  logic end_ready;

  // Memory sol ports
  logic [31:0] sol_address0;
  logic sol_ce0;
  logic sol_we0;
  logic [31:0] sol_dout0;
  logic [31:0] sol_din0;
  
  logic [31:0] sol_address1;
  logic sol_ce1;
  logic sol_we1;
  logic [31:0] sol_dout1;
  logic [31:0] sol_din1;

  // Memory filter ports
  logic [31:0] filter_address0;
  logic filter_ce0;
  logic filter_we0;
  logic [31:0] filter_dout0;
  logic [31:0] filter_din0;
  
  logic [31:0] filter_address1;
  logic filter_ce1;
  logic filter_we1;
  logic [31:0] filter_dout1;
  logic [31:0] filter_din1;

  // Memory orig ports
  logic [31:0] orig_address0;
  logic orig_ce0;
  logic orig_we0;
  logic [31:0] orig_dout0;
  logic [31:0] orig_din0;
  
  logic [31:0] orig_address1;
  logic orig_ce1;
  logic orig_we1;
  logic [31:0] orig_dout1;
  logic [31:0] orig_din1;

  // Instantiate the DUT
  stencil_2d dut (
    .clk(clk),
    .rst(rst),
    .start_in(start_in),
    .start_valid(start_valid),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),
    
    .sol_address0(sol_address0),
    .sol_ce0(sol_ce0),
    .sol_we0(sol_we0),
    .sol_dout0(sol_dout0),
    .sol_din0(sol_din0),
    .sol_address1(sol_address1),
    .sol_ce1(sol_ce1),
    .sol_we1(sol_we1),
    .sol_dout1(sol_dout1),
    .sol_din1(sol_din1),
    
    .filter_address0(filter_address0),
    .filter_ce0(filter_ce0),
    .filter_we0(filter_we0),
    .filter_dout0(filter_dout0),
    .filter_din0(filter_din0),
    .filter_address1(filter_address1),
    .filter_ce1(filter_ce1),
    .filter_we1(filter_we1),
    .filter_dout1(filter_dout1),
    .filter_din1(filter_din1),
    
    .orig_address0(orig_address0),
    .orig_ce0(orig_ce0),
    .orig_we0(orig_we0),
    .orig_dout0(orig_dout0),
    .orig_din0(orig_din0),
    .orig_address1(orig_address1),
    .orig_ce1(orig_ce1),
    .orig_we1(orig_we1),
    .orig_dout1(orig_dout1),
    .orig_din1(orig_din1)
  );

  // Memories
  logic [31:0] orig_mem [0:1023];
  logic [31:0] filter_mem [0:15];
  logic [31:0] sol_mem [0:1023];

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // RAM logic for sol
  always @(posedge clk) begin
    if (sol_ce0) begin
      if (sol_we0)
        sol_mem[sol_address0] <= sol_dout0;
      else
        sol_din0 <= sol_mem[sol_address0];
    end
    if (sol_ce1) begin
      if (sol_we1)
        sol_mem[sol_address1] <= sol_dout1;
      else
        sol_din1 <= sol_mem[sol_address1];
    end
  end

  // RAM logic for filter
  always @(posedge clk) begin
    if (filter_ce0) begin
      if (filter_we0)
        filter_mem[filter_address0] <= filter_dout0;
      else
        filter_din0 <= filter_mem[filter_address0];
    end
    if (filter_ce1) begin
      if (filter_we1)
        filter_mem[filter_address1] <= filter_dout1;
      else
        filter_din1 <= filter_mem[filter_address1];
    end
  end

  // RAM logic for orig
  always @(posedge clk) begin
    if (orig_ce0) begin
      if (orig_we0)
        orig_mem[orig_address0] <= orig_dout0;
      else
        orig_din0 <= orig_mem[orig_address0];
    end
    if (orig_ce1) begin
      if (orig_we1)
        orig_mem[orig_address1] <= orig_dout1;
      else
        orig_din1 <= orig_mem[orig_address1];
    end
  end

  initial begin
    // Initialize memory
    for (int i = 0; i < 1024; i++) begin
      orig_mem[i] = i;
      sol_mem[i] = 32'd0;
    end
    
    for (int i = 0; i < 16; i++) begin
      filter_mem[i] = i % 5;
    end
    
    // Initialize signals
    rst = 1;
    start_in = 1'b0;
    start_valid = 1'b0;
    end_ready = 1'b1;
    
    // Reset sequence
    #20;
    rst = 0;
    
    // Start signal
    #10;
    start_valid = 1'b1;
    start_in = 1'b1;
    
    wait (start_ready == 1'b1);
    @(posedge clk);
    start_valid = 1'b0;
    start_in = 1'b0;
    
    // Wait for the operations to complete, mimicking the original TB
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
