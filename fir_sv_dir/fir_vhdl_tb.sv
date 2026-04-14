`timescale 1ns/1ps

module fir_vhdl_tb();
  wire clk;
  wire rst;
  wire tstart;

  clk_generator clkgen(
    .clk(clk),
    .rst(rst),
    .tstart(tstart)
  );

  // fir ports
  wire start_ready;
  wire [31:0] end_out;
  wire end_valid;
  wire end_ready = 1'b1;

  wire [31:0] idx_address0;
  wire idx_ce0;
  wire idx_we0;
  wire [31:0] idx_dout0; // outputs from DUT
  wire [31:0] idx_din0;  // inputs to DUT

  wire [31:0] idx_address1;
  wire idx_ce1;
  wire idx_we1;
  wire [31:0] idx_dout1;
  wire [31:0] idx_din1;

  wire [31:0] di_address0;
  wire di_ce0;
  wire di_we0;
  wire [31:0] di_dout0;
  wire [31:0] di_din0;

  wire [31:0] di_address1;
  wire di_ce1;
  wire di_we1;
  wire [31:0] di_dout1;
  wire [31:0] di_din1;

  fir dut (
    .clk(clk),
    .rst(rst),
    .start_in(tstart),
    .start_valid(tstart),
    .start_ready(start_ready),
    .end_out(end_out),
    .end_valid(end_valid),
    .end_ready(end_ready),

    // idx interface
    .idx_address0(idx_address0),
    .idx_ce0(idx_ce0),
    .idx_we0(idx_we0),
    .idx_dout0(idx_dout0),
    .idx_din0(idx_din0),
    .idx_address1(idx_address1),
    .idx_ce1(idx_ce1),
    .idx_we1(idx_we1),
    .idx_dout1(idx_dout1),
    .idx_din1(idx_din1),

    // di interface
    .di_address0(di_address0),
    .di_ce0(di_ce0),
    .di_we0(di_we0),
    .di_dout0(di_dout0),
    .di_din0(di_din0),
    .di_address1(di_address1),
    .di_ce1(di_ce1),
    .di_we1(di_we1),
    .di_dout1(di_dout1),
    .di_din1(di_din1)
  );

  // memory arrays
  reg [31:0] di_mem [1023:0];
  reg [31:0] idx_mem [1023:0];

  // idx memory port 0 logic
  reg [31:0] idx_din0_reg;
  assign idx_din0 = idx_din0_reg;
  always @(posedge clk) begin
    if (idx_ce0) begin
      if (idx_we0)
        idx_mem[idx_address0] <= idx_dout0;
      else
        idx_din0_reg <= idx_mem[idx_address0];
    end
  end

  // idx memory port 1 logic
  reg [31:0] idx_din1_reg;
  assign idx_din1 = idx_din1_reg;
  always @(posedge clk) begin
    if (idx_ce1) begin
      if (idx_we1)
        idx_mem[idx_address1] <= idx_dout1;
      else
        idx_din1_reg <= idx_mem[idx_address1];
    end
  end

  // di memory port 0 logic
  reg [31:0] di_din0_reg;
  assign di_din0 = di_din0_reg;
  always @(posedge clk) begin
    if (di_ce0) begin
      if (di_we0)
        di_mem[di_address0] <= di_dout0;
      else
        di_din0_reg <= di_mem[di_address0];
    end
  end

  // di memory port 1 logic
  reg [31:0] di_din1_reg;
  assign di_din1 = di_din1_reg;
  always @(posedge clk) begin
    if (di_ce1) begin
      if (di_we1)
        di_mem[di_address1] <= di_dout1;
      else
        di_din1_reg <= di_mem[di_address1];
    end
  end

  initial begin
    // Initialize memory with dummy data
    for (int i = 0; i < 1024; i++) begin
      di_mem[i] = i; 
      idx_mem[i] = 1;
    end
    // $dumpfile("fir_vhdl.vcd");
    // $dumpvars(0, fir_vhdl_tb);
    
    // Wait for the operations to complete. 
    #15000;
    
    $display("Simulation complete.");
    $finish;
  end

endmodule
