module scan_dff (
  input clk,
  input reset,
  input d,
  input si,
  input se,
  output reg q
);

always @(posedge clk or posedge reset) begin
  if (reset)
    q <= 0;
  else if (se)
    q <= si;   // scan mode
  else
    q <= d;    // functional mode
end

endmodule
