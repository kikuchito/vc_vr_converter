module vc_vr_tb ();

localparam DATA_WIDTH = 8;
localparam CREDIT_NUM = 2;

logic clk_tb;
logic rst_n_tb;
logic [DATA_WIDTH-1:0] s_data_tb;
logic s_valid_tb;
logic s_credit_tb;
logic [DATA_WIDTH-1:0] m_data_tb;
logic m_valid_tb;
logic m_ready_tb;

vc_vr_converter #(
    .DATA_WIDTH ( DATA_WIDTH ),
    .CREDIT_NUM ( CREDIT_NUM )
  ) DUT (
    .clk        ( clk_tb          ),
    .rst_n      ( rst_n_tb     ),
    .s_data_i   ( s_data_tb    ),
    .s_valid_i  ( s_valid_tb   ),
    .s_credit_o ( s_credit_tb  ),
    .m_data_o   ( m_data_tb    ),
    .m_valid_o  ( m_valid_tb   ),
    .m_ready_i  (  m_ready_tb  )
  );

  

  parameter CLK_PERIOD = 100;

  initial begin
    clk_tb = 0;
    forever #(CLK_PERIOD / 2) clk_tb = ~clk_tb;
  end 

  initial begin 
    rst_n_tb <= '0;
    m_ready_tb <= '1;
    s_valid_tb <= '0;
    @(posedge clk_tb);
    @(posedge clk_tb);
    @(posedge clk_tb);
    rst_n_tb <= '1;
    
    wait (s_credit_tb);
    @(posedge clk_tb);
    @(posedge clk_tb);
    s_valid_tb <= '1;
    s_data_tb <= 8'hAA;
    wait (s_credit_tb);
    @(posedge clk_tb);
    s_valid_tb <= '0;
    s_data_tb <= 8'h0;
    wait (s_credit_tb);
    @(posedge clk_tb);
    m_ready_tb <= '0;
    @(posedge clk_tb);
    @(posedge clk_tb);
    s_valid_tb <= '1;
    s_data_tb <= 8'hBB;
    @(posedge clk_tb);
    s_data_tb <= 8'hCC;
    @(posedge clk_tb);
    s_valid_tb <= '0;
    @(posedge clk_tb);
    @(posedge clk_tb);
    @(posedge clk_tb);
    @(posedge clk_tb);
    m_ready_tb <= '1;
    wait (s_credit_tb);
    @(posedge clk_tb);
    s_valid_tb <= '1;
    s_data_tb <= 8'hFF;
    @(posedge clk_tb);
    s_valid_tb <= '0;
  end
  
// fifo_v3 #(
//     .DATA_WIDTH (DATA_WIDTH ),
//     .DEPTH      (CREDIT_NUM )
//   ) fifo_inst (
//     .clk_i      ( clk      ),
//     .rst_ni     ( rst_n    ),
//     .full_o     ( full     ),
//     .empty_o    ( empty    ),
//     .data_i     ( s_data_i ),
//     .push_i     ( push     ),
//     .data_o     ( m_data_o ),
//     .pop_i      ( pop      )
//   );

endmodule