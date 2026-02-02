

module BoundaryScanRegister_input
(
  din,
  dout,
  sin,
  sout,
  clock,
  reset,
  testing,
  shift
);

  input din;
  output dout;
  input sin;
  output sout;
  input clock;input reset;input testing;input shift;
  reg store;

  always @(posedge clock or posedge reset) begin
    if(reset) begin
      store <= 1'b0;
    end else begin
      store <= (shift)? sin : dout;
    end
  end

  assign sout = store;
  assign dout = (testing)? store : din;

endmodule



module BoundaryScanRegister_output
(
  din,
  dout,
  sin,
  sout,
  clock,
  reset,
  testing,
  shift
);

  input din;
  output dout;
  input sin;
  output sout;
  input clock;input reset;input testing;input shift;
  reg store;

  always @(posedge clock or posedge reset) begin
    if(reset) begin
      store <= 1'b0;
    end else begin
      store <= (shift)? sin : dout;
    end
  end

  assign sout = store;
  assign dout = din;

endmodule



module \counter_4bit.original 
(
  clk,
  reset,
  q,
  sin,
  shift,
  sout,
  tck,
  test
);

  input sin;
  output sout;
  input shift;
  input tck;
  input test;
  wire __clk_source__;
  wire __chain_0__;
  assign __chain_0__ = sin;
  (* src = "counter_4bit.v:2.9-2.12" *)
  input clk;
  wire clk;
  (* src = "counter_4bit.v:3.9-3.14" *)
  input reset;
  wire reset;
  (* src = "counter_4bit.v:4.20-4.21" *)
  output [3:0] q;
  wire [3:0] q;
  wire _00_;
  wire _01_;
  (* force_downto = 32'd1 *)
  (* src = "counter_4bit.v:11.10-11.15|/home/niranjan/tools/oss-cad-suite/lib/../share/yosys/techmap.v:287.21-287.22" *)
  wire [3:0] _02_;
  (* force_downto = 32'd1 *)
  (* src = "counter_4bit.v:11.10-11.15|/home/niranjan/tools/oss-cad-suite/lib/../share/yosys/techmap.v:270.26-270.27" *)
  wire [3:0] _03_;
  wire _04_;
  assign _02_[0] = ~q[0];
  assign _03_[1] = q[1] ^ q[0];
  assign _00_ = ~(q[1] & q[0]);
  assign _03_[2] = ~(_00_ ^ q[2]);
  assign _01_ = q[2] & ~_00_;
  assign _03_[3] = _01_ ^ q[3];
  assign _04_ = ~reset;
  (* src = "counter_4bit.v:7.1-12.4" *)

  DFFSR
  _12_
  (
    .CLK(__clk_source__),
    .D((shift)? __chain_0__ : _02_[0]),
    .Q(q[0]),
    .R(_04_),
    .S(1'h1)
  );

  (* src = "counter_4bit.v:7.1-12.4" *)

  DFFSR
  _13_
  (
    .CLK(__clk_source__),
    .D((shift)? q[0] : _03_[1]),
    .Q(q[1]),
    .R(_04_),
    .S(1'h1)
  );

  (* src = "counter_4bit.v:7.1-12.4" *)

  DFFSR
  _14_
  (
    .CLK(__clk_source__),
    .D((shift)? q[1] : _03_[2]),
    .Q(q[2]),
    .R(_04_),
    .S(1'h1)
  );

  (* src = "counter_4bit.v:7.1-12.4" *)

  DFFSR
  _15_
  (
    .CLK(__clk_source__),
    .D((shift)? q[2] : _03_[3]),
    .Q(q[3]),
    .R(_04_),
    .S(1'h1)
  );

  assign _02_[3:1] = q[3:1];
  assign _03_[0] = _02_[0];
  assign sout = q[3];
  assign __clk_source__ = (test)? tck : clk;

endmodule



module counter_4bit
(
  clk,
  reset,
  q,
  sin,
  shift,
  sout,
  tck,
  test
);

  input sin;
  output sout;
  input reset;
  input shift;
  input tck;
  input test;
  input clk;
  wire __chain_0__;
  assign __chain_0__ = sin;
  wire __chain_1__;
  output [3:0] q;
  wire [3:0] q_din;
  wire __chain_2__;

  BoundaryScanRegister_output
  __BoundaryScanRegister_output__0__
  (
    .din(q_din[0]),
    .dout(q[0]),
    .sin(__chain_1__),
    .sout(__chain_2__),
    .clock(tck),
    .reset(reset),
    .testing(test),
    .shift(shift)
  );

  wire __chain_3__;

  BoundaryScanRegister_output
  __BoundaryScanRegister_output__1__
  (
    .din(q_din[1]),
    .dout(q[1]),
    .sin(__chain_2__),
    .sout(__chain_3__),
    .clock(tck),
    .reset(reset),
    .testing(test),
    .shift(shift)
  );

  wire __chain_4__;

  BoundaryScanRegister_output
  __BoundaryScanRegister_output__2__
  (
    .din(q_din[2]),
    .dout(q[2]),
    .sin(__chain_3__),
    .sout(__chain_4__),
    .clock(tck),
    .reset(reset),
    .testing(test),
    .shift(shift)
  );

  wire __chain_5__;

  BoundaryScanRegister_output
  __BoundaryScanRegister_output__3__
  (
    .din(q_din[3]),
    .dout(q[3]),
    .sin(__chain_4__),
    .sout(__chain_5__),
    .clock(tck),
    .reset(reset),
    .testing(test),
    .shift(shift)
  );


  \counter_4bit.original 
  __uuf__
  (
    .clk(clk),
    .reset(reset),
    .shift(shift),
    .tck(tck),
    .test(test),
    .sin(__chain_0__),
    .sout(__chain_1__),
    .q(q_din)
  );

  assign sout = __chain_5__;

endmodule


