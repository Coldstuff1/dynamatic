`timescale 1ns/1ps

module matrix_tb();

  logic clk;
  logic rst;

  // Handshake signals
  logic [0:0] start_in;
  logic start_valid;
  logic start_ready;
  logic [0:0] end_out;
  logic end_valid;
  logic end_ready;

  // Memory outC ports
  logic [31:0] outC_address0;
  logic outC_ce0;
  logic outC_we0;
  logic [31:0] outC_dout0;
  logic [31:0] outC_din0;
  
  logic [31:0] outC_address1;
  logic outC_ce1;
  logic outC_we1;
  logic [31:0] outC_dout1;
  logic [31:0] outC_din1;

  // Memory inB ports
  logic [31:0] inB_address0;
  logic inB_ce0;
  logic inB_we0;
  logic [31:0] inB_dout0;
  logic [31:0] inB_din0;
  
  logic [31:0] inB_address1;
  logic inB_ce1;
  logic inB_we1;
  logic [31:0] inB_dout1;
  logic [31:0] inB_din1;

  // Memory inA ports
  logic [31:0] inA_address0;
  logic inA_ce0;
  logic inA_we0;
  logic [31:0] inA_dout0;
  logic [31:0] inA_din0;
  
  logic [31:0] inA_address1;
  logic inA_ce1;
  logic inA_we1;
  logic [31:0] inA_dout1;
  logic [31:0] inA_din1;

  // Instantiate the DUT
  matrix dut (
    .clk(clk),
    .rst(rst),
    .start_in(start_in),
    .start_valid(start_valid),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),
    
    .outC_address0(outC_address0),
    .outC_ce0(outC_ce0),
    .outC_we0(outC_we0),
    .outC_dout0(outC_dout0),
    .outC_din0(outC_din0),
    .outC_address1(outC_address1),
    .outC_ce1(outC_ce1),
    .outC_we1(outC_we1),
    .outC_dout1(outC_dout1),
    .outC_din1(outC_din1),
    
    .inB_address0(inB_address0),
    .inB_ce0(inB_ce0),
    .inB_we0(inB_we0),
    .inB_dout0(inB_dout0),
    .inB_din0(inB_din0),
    .inB_address1(inB_address1),
    .inB_ce1(inB_ce1),
    .inB_we1(inB_we1),
    .inB_dout1(inB_dout1),
    .inB_din1(inB_din1),
    
    .inA_address0(inA_address0),
    .inA_ce0(inA_ce0),
    .inA_we0(inA_we0),
    .inA_dout0(inA_dout0),
    .inA_din0(inA_din0),
    .inA_address1(inA_address1),
    .inA_ce1(inA_ce1),
    .inA_we1(inA_we1),
    .inA_dout1(inA_dout1),
    .inA_din1(inA_din1)
  );

  // Memories
  logic [31:0] inA_mem [0:1023];
  logic [31:0] inB_mem [0:1023];
  logic [31:0] outC_mem [0:1023];

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // RAM logic for inA
  always @(posedge clk) begin
    if (inA_ce0) begin
      if (inA_we0)
        inA_mem[inA_address0] <= inA_dout0;
      else
        inA_din0 <= inA_mem[inA_address0];
    end
    if (inA_ce1) begin
      if (inA_we1)
        inA_mem[inA_address1] <= inA_dout1;
      else
        inA_din1 <= inA_mem[inA_address1];
    end
  end

  // RAM logic for inB
  always @(posedge clk) begin
    if (inB_ce0) begin
      if (inB_we0)
        inB_mem[inB_address0] <= inB_dout0;
      else
        inB_din0 <= inB_mem[inB_address0];
    end
    if (inB_ce1) begin
      if (inB_we1)
        inB_mem[inB_address1] <= inB_dout1;
      else
        inB_din1 <= inB_mem[inB_address1];
    end
  end

  // RAM logic for outC
  always @(posedge clk) begin
    if (outC_ce0) begin
      if (outC_we0)
        outC_mem[outC_address0] <= outC_dout0;
      else
        outC_din0 <= outC_mem[outC_address0];
    end
    if (outC_ce1) begin
      if (outC_we1)
        outC_mem[outC_address1] <= outC_dout1;
      else
        outC_din1 <= outC_mem[outC_address1];
    end
  end

  integer cycle_count = 0;
  always @(posedge clk) begin
    cycle_count <= cycle_count + 1;
  end

  initial begin
    // $dumpfile("matrix.vcd");
    // $dumpvars(0, matrix_tb);
    
    // Initialize memory
    for (int i = 0; i < 1024; i++) begin
      inA_mem[i] = i;
      inB_mem[i] = i % 10;
      outC_mem[i] = 32'd0;
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
