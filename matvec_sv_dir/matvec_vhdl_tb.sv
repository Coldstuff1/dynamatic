`timescale 1ns/1ps

module matvec_tb();

  logic clk;
  logic rst;

  // Handshake signals
  logic [0:0] start_in;
  logic start_valid;
  logic start_ready;
  logic [31:0] end_out;
  logic end_valid;
  logic end_ready;

  // Memory out ports
  logic [31:0] out_address0;
  logic out_ce0;
  logic out_we0;
  logic [31:0] out_dout0;
  logic [31:0] out_din0;
  
  logic [31:0] out_address1;
  logic out_ce1;
  logic out_we1;
  logic [31:0] out_dout1;
  logic [31:0] out_din1;

  // Memory v ports
  logic [31:0] v_address0;
  logic v_ce0;
  logic v_we0;
  logic [31:0] v_dout0;
  logic [31:0] v_din0;
  
  logic [31:0] v_address1;
  logic v_ce1;
  logic v_we1;
  logic [31:0] v_dout1;
  logic [31:0] v_din1;

  // Memory m ports
  logic [31:0] m_address0;
  logic m_ce0;
  logic m_we0;
  logic [31:0] m_dout0;
  logic [31:0] m_din0;
  
  logic [31:0] m_address1;
  logic m_ce1;
  logic m_we1;
  logic [31:0] m_dout1;
  logic [31:0] m_din1;

  // Instantiate the DUT
  matvec dut (
    .clk(clk),
    .rst(rst),
    .start_in(start_in),
    .start_valid(start_valid),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),
    
    .out_address0(out_address0),
    .out_ce0(out_ce0),
    .out_we0(out_we0),
    .out_dout0(out_dout0),
    .out_din0(out_din0),
    .out_address1(out_address1),
    .out_ce1(out_ce1),
    .out_we1(out_we1),
    .out_dout1(out_dout1),
    .out_din1(out_din1),
    
    .v_address0(v_address0),
    .v_ce0(v_ce0),
    .v_we0(v_we0),
    .v_dout0(v_dout0),
    .v_din0(v_din0),
    .v_address1(v_address1),
    .v_ce1(v_ce1),
    .v_we1(v_we1),
    .v_dout1(v_dout1),
    .v_din1(v_din1),
    
    .m_address0(m_address0),
    .m_ce0(m_ce0),
    .m_we0(m_we0),
    .m_dout0(m_dout0),
    .m_din0(m_din0),
    .m_address1(m_address1),
    .m_ce1(m_ce1),
    .m_we1(m_we1),
    .m_dout1(m_dout1),
    .m_din1(m_din1)
  );

  // Memories
  logic [31:0] m_mem [0:63];
  logic [31:0] v_mem [0:7];
  logic [31:0] out_mem [0:7];

  // Clock generation
  initial clk = 0;
  always #5 clk = ~clk;

  // RAM logic for out
  always @(posedge clk) begin
    if (out_ce0) begin
      if (out_we0)
        out_mem[out_address0] <= out_dout0;
      else
        out_din0 <= out_mem[out_address0];
    end
    if (out_ce1) begin
      if (out_we1)
        out_mem[out_address1] <= out_dout1;
      else
        out_din1 <= out_mem[out_address1];
    end
  end

  // RAM logic for v
  always @(posedge clk) begin
    if (v_ce0) begin
      if (v_we0)
        v_mem[v_address0] <= v_dout0;
      else
        v_din0 <= v_mem[v_address0];
    end
    if (v_ce1) begin
      if (v_we1)
        v_mem[v_address1] <= v_dout1;
      else
        v_din1 <= v_mem[v_address1];
    end
  end

  // RAM logic for m
  always @(posedge clk) begin
    if (m_ce0) begin
      if (m_we0)
        m_mem[m_address0] <= m_dout0;
      else
        m_din0 <= m_mem[m_address0];
    end
    if (m_ce1) begin
      if (m_we1)
        m_mem[m_address1] <= m_dout1;
      else
        m_din1 <= m_mem[m_address1];
    end
  end

  initial begin
    // Initialize memory
    for (int i = 0; i < 64; i++) begin
      m_mem[i] = i;
    end
    for (int i = 0; i < 8; i++) begin
      v_mem[i] = i;
      out_mem[i] = 32'd0;
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
    #10000;
    
    // Display the output memory to verify correctness
    $display("out results:");
    for (int i = 0; i < 8; i++) begin
      $display("out[%0d] = %0d", i, out_mem[i]);
    end
    
    $finish;
  end

endmodule
