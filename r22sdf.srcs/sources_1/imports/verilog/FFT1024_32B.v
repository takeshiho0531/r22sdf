//----------------------------------------------------------------------
//  FFT: 1024-Point FFT Using Radix-2^2 Single-Path Delay Feedback
//----------------------------------------------------------------------
`timescale	1ns/1ns
module FFT #(
    parameter   WIDTH = 14
)(
    input               clock,  //  Master Clock
    input               reset,  //  Active High Asynchronous Reset
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    output              do_en,  //  Output Data Enable
    output  [WIDTH-1:0] do_re,  //  Output Data (Real)
    output  [WIDTH-1:0] do_im   //  Output Data (Imag)
);
//----------------------------------------------------------------------
//  Data must be input consecutively in natural order.
//  The result is scaled to 1/N and output in bit-reversed order.
//----------------------------------------------------------------------

wire            su1_do_en;
wire[WIDTH-1:0] su1_do_re;
wire[WIDTH-1:0] su1_do_im;
wire            su2_do_en;
wire[WIDTH-1:0] su2_do_re;
wire[WIDTH-1:0] su2_do_im;
wire            su3_do_en;
wire[WIDTH-1:0] su3_do_re;
wire[WIDTH-1:0] su3_do_im;
wire            su4_do_en;
wire[WIDTH-1:0] su4_do_re;
wire[WIDTH-1:0] su4_do_im;

SdfUnit #(.N(1024),.M(1024),.WIDTH(WIDTH)) SU1 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .do_en  (su1_do_en  ),  //  o
    .do_re  (su1_do_re  ),  //  o
    .do_im  (su1_do_im  )   //  o
);

SdfUnit #(.N(1024),.M(256),.WIDTH(WIDTH)) SU2 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (su1_do_en  ),  //  i
    .di_re  (su1_do_re  ),  //  i
    .di_im  (su1_do_im  ),  //  i
    .do_en  (su2_do_en  ),  //  o
    .do_re  (su2_do_re  ),  //  o
    .do_im  (su2_do_im  )   //  o
);

SdfUnit #(.N(1024),.M(64),.WIDTH(WIDTH)) SU3 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (su2_do_en  ),  //  i
    .di_re  (su2_do_re  ),  //  i
    .di_im  (su2_do_im  ),  //  i
    .do_en  (su3_do_en  ),  //  o
    .do_re  (su3_do_re  ),  //  o
    .do_im  (su3_do_im  )   //  o
);

SdfUnit #(.N(1024),.M(16),.WIDTH(WIDTH)) SU4 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (su3_do_en  ),  //  i
    .di_re  (su3_do_re  ),  //  i
    .di_im  (su3_do_im  ),  //  i
    .do_en  (su4_do_en  ),  //  o
    .do_re  (su4_do_re  ),  //  o
    .do_im  (su4_do_im  )   //  o
);

SdfUnit #(.N(1024),.M(4),.WIDTH(WIDTH)) SU5 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (su4_do_en  ),  //  i
    .di_re  (su4_do_re  ),  //  i
    .di_im  (su4_do_im  ),  //  i
    .do_en  (do_en      ),  //  o
    .do_re  (do_re      ),  //  o
    .do_im  (do_im      )   //  o
);

always @(posedge clock) begin
    // $display("su1_do_en=%b, su2_do_en=%b, su3_do_en=%b, su4_do_en=%b, do_en=%b", su1_do_en, su2_do_en, su3_do_en, su4_do_en, do_en);
end

endmodule
