`timescale 1ns/1ps

module vector_rescale_tb();

  logic clk;
  logic rst;

  // Handshake signals
  logic [0:0] start_in;
  logic start_valid;
  logic start_ready;
  logic [0:0] end_out;
  logic end_valid;
  logic end_ready;

  // c scalar
  logic [31:0] c_din;
  logic c_valid_in;
  logic c_ready_out;

  // Memory b ports
  logic [31:0] b_address0;
  logic b_ce0;
  logic b_we0;
  logic [31:0] b_dout0;
  logic [31:0] b_din0;
  
  logic [31:0] b_address1;
  logic b_ce1;
  logic b_we1;
  logic [31:0] b_dout1;
  logic [31:0] b_din1;

  // Memory a ports
  logic [31:0] a_address0;
  logic a_ce0;
  logic a_we0;
  logic [31:0] a_dout0;
  logic [31:0] a_din0;
  
  logic [31:0] a_address1;
  logic a_ce1;
  logic a_we1;
  logic [31:0] a_dout1;
  logic [31:0] a_din1;

  // Instantiate the DUT
  vector_rescale dut (
    .clk(clk),
    .rst(rst),
    .start_in(start_in),
    .start_valid(start_valid),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),
    
    .c_din(c_din),
    .c_valid_in(c_valid_in),
    .c_ready_out(c_ready_out),

    .b_address0(b_address0),
    .b_ce0(b_ce0),
    .b_we0(b_we0),
    .b_dout0(b_dout0),
    .b_din0(b_din0),
    .b_address1(b_address1),
    .b_ce1(b_ce1),
    .b_we1(b_we1),
    .b_dout1(b_dout1),
    .b_din1(b_din1),
    
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

  // Memories
  logic [31:0] a_mem [0:1023];
  logic [31:0] b_mem [0:1023];

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // RAM logic for b
  always @(posedge clk) begin
    if (b_ce0) begin
      if (b_we0)
        b_mem[b_address0] <= b_dout0;
      else
        b_din0 <= b_mem[b_address0];
    end
    if (b_ce1) begin
      if (b_we1)
        b_mem[b_address1] <= b_dout1;
      else
        b_din1 <= b_mem[b_address1];
    end
  end

  // RAM logic for a
  always @(posedge clk) begin
    if (a_ce0) begin
      if (a_we0)
        a_mem[a_address0] <= a_dout0;
      else
        a_din0 <= a_mem[a_address0];
    end
    if (a_ce1) begin
      if (a_we1)
        a_mem[a_address1] <= a_dout1;
      else
        a_din1 <= a_mem[a_address1];
    end
  end

  initial begin
    // Initialize memory
    for (int i = 0; i < 1024; i++) begin
      a_mem[i] = i;
      b_mem[i] = 32'd0;
    end
    
    // Initialize scalar c
    c_din = 32'd5;
    c_valid_in = 1'b1;

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
