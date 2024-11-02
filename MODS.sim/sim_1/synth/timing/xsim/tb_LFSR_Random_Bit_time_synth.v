// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
// Date        : Sat Nov  2 20:48:47 2024
// Host        : gskang running 64-bit major release  (build 9200)
// Command     : write_verilog -mode timesim -nolib -sdf_anno true -force -file
//               C:/Users/gskan/Downloads/MODS2.xpr/MODS/MODS.sim/sim_1/synth/timing/xsim/tb_LFSR_Random_Bit_time_synth.v
// Design      : LFSR_random
// Purpose     : This verilog netlist is a timing simulation representation of the design and should not be modified or
//               synthesized. Please ensure that this netlist is used with the corresponding SDF file.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps
`define XIL_TIMING

(* NotValidForBitStream *)
module LFSR_random
   (CLOCK,
    rst,
    random);
  input CLOCK;
  input rst;
  output [7:0]random;

  wire CLOCK;
  wire CLOCK_IBUF;
  wire CLOCK_IBUF_BUFG;
  wire [0:0]p_0_out;
  wire [7:0]random;
  wire [7:0]random_OBUF;
  wire rst;
  wire rst_IBUF;

initial begin
 $sdf_annotate("tb_LFSR_Random_Bit_time_synth.sdf",,,,"tool_control");
end
  BUFG CLOCK_IBUF_BUFG_inst
       (.I(CLOCK_IBUF),
        .O(CLOCK_IBUF_BUFG));
  IBUF CLOCK_IBUF_inst
       (.I(CLOCK),
        .O(CLOCK_IBUF));
  LUT4 #(
    .INIT(16'h6996)) 
    \lfsr[0]_i_1 
       (.I0(random_OBUF[4]),
        .I1(random_OBUF[5]),
        .I2(random_OBUF[7]),
        .I3(random_OBUF[3]),
        .O(p_0_out));
  FDPE #(
    .INIT(1'b1)) 
    \lfsr_reg[0] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .D(p_0_out),
        .PRE(rst_IBUF),
        .Q(random_OBUF[0]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[1] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[0]),
        .Q(random_OBUF[1]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[2] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[1]),
        .Q(random_OBUF[2]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[3] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[2]),
        .Q(random_OBUF[3]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[4] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[3]),
        .Q(random_OBUF[4]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[5] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[4]),
        .Q(random_OBUF[5]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[6] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[5]),
        .Q(random_OBUF[6]));
  FDCE #(
    .INIT(1'b0)) 
    \lfsr_reg[7] 
       (.C(CLOCK_IBUF_BUFG),
        .CE(1'b1),
        .CLR(rst_IBUF),
        .D(random_OBUF[6]),
        .Q(random_OBUF[7]));
  OBUF \random_OBUF[0]_inst 
       (.I(random_OBUF[0]),
        .O(random[0]));
  OBUF \random_OBUF[1]_inst 
       (.I(random_OBUF[1]),
        .O(random[1]));
  OBUF \random_OBUF[2]_inst 
       (.I(random_OBUF[2]),
        .O(random[2]));
  OBUF \random_OBUF[3]_inst 
       (.I(random_OBUF[3]),
        .O(random[3]));
  OBUF \random_OBUF[4]_inst 
       (.I(random_OBUF[4]),
        .O(random[4]));
  OBUF \random_OBUF[5]_inst 
       (.I(random_OBUF[5]),
        .O(random[5]));
  OBUF \random_OBUF[6]_inst 
       (.I(random_OBUF[6]),
        .O(random[6]));
  OBUF \random_OBUF[7]_inst 
       (.I(random_OBUF[7]),
        .O(random[7]));
  IBUF rst_IBUF_inst
       (.I(rst),
        .O(rst_IBUF));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
