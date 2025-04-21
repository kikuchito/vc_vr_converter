  module vc_vr_converter #(
    parameter DATA_WIDTH = 8,
    CREDIT_NUM = 2
  ) (
    input logic                   clk,
    input logic                   rst_n,
    //valid/credit interface
    input logic [DATA_WIDTH-1:0]  s_data_i,
    input logic                   s_valid_i,
    output logic                  s_credit_o,
    //valid/ready interface
    output logic [DATA_WIDTH-1:0] m_data_o,
    output logic                  m_valid_o,
    input logic                   m_ready_i
  );

  localparam PTR_WIDTH = $clog2(CREDIT_NUM);

  logic [$clog2(CREDIT_NUM+1):0] reset_credit_counter;

  logic credit_reset;

  logic [DATA_WIDTH-1:0] s_data;
  logic [DATA_WIDTH-1:0] m_data;

  logic pop;
  logic full;
  logic empty;
  logic push;                         
  
  fifo #(
    .DATA_WIDTH (DATA_WIDTH ),
    .DEPTH      (CREDIT_NUM )
  ) fifo_inst (
    .clk_i      ( clk      ),
    .rst_ni     ( rst_n    ),
    .full_o     ( full     ),
    .empty_o    ( empty    ),
    .data_i     ( s_data_i ),
    .push_i     ( push     ),
    .data_o     ( m_data_o ),
    .pop_i      ( pop      )
  );
 
  assign push = s_valid_i && !full;
  assign pop  = m_valid_o && m_ready_i;

  assign m_valid_o = !empty;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      reset_credit_counter <= '0;
    end
    else if (reset_credit_counter < CREDIT_NUM)
      reset_credit_counter <= reset_credit_counter + 1;
  end

  always_ff @(posedge clk) begin
    if (!rst_n) 
      credit_reset <= '0;
    else
      credit_reset <= ( reset_credit_counter < CREDIT_NUM );
  end

  assign s_credit_o = ( pop && !push ) || credit_reset;

  endmodule