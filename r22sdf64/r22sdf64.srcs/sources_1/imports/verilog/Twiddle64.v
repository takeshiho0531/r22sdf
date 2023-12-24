//----------------------------------------------------------------------
//  Twiddle: 64-Point Twiddle Table for Radix-2^2 Butterfly
//----------------------------------------------------------------------
`timescale	1ns/1ns
module Twiddle #(
    parameter   TW_FF = 1   //  Use Output Register
)(
    input           clock,  //  Master Clock
    input   [5:0]   addr,   //  Twiddle Factor Number
    output  [13:0]  tw_re,  //  Twiddle Factor (Real)
    output  [13:0]  tw_im   //  Twiddle Factor (Imag)
);

wire[13:0]  wn_re[0:63];    //  Twiddle Table (Real)
wire[13:0]  wn_im[0:63];    //  Twiddle Table (Imag)
wire[13:0]  mx_re;          //  Multiplexer output (Real)
wire[13:0]  mx_im;          //  Multiplexer output (Imag)
reg [13:0]  ff_re;          //  Register output (Real)
reg [13:0]  ff_im;          //  Register output (Imag)

assign  mx_re = wn_re[addr];
assign  mx_im = wn_im[addr];

always @(posedge clock) begin
    ff_re <= mx_re;
    ff_im <= mx_im;
end

assign  tw_re = TW_FF ? ff_re : mx_re;
assign  tw_im = TW_FF ? ff_im : mx_im;

//----------------------------------------------------------------------
//  Twiddle Factor Value
//----------------------------------------------------------------------
//  Multiplication is bypassed when twiddle address is 0.
//  Setting wn_re[0] = 0 and wn_im[0] = 0 makes it easier to check the waveform.
//  It may also reduce power consumption slightly.
//
//      wn_re = cos(-2pi*n/64)          wn_im = sin(-2pi*n/64)
assign  wn_re[0] = 14'b01111110101110;   assign  wn_im[0] = 14'b00000000000000;   //  0  0.990 -0.000
assign  wn_re[1] = 14'b01111110101110;   assign  wn_im[1] = 14'b11110011011101;   //  1  0.990 -0.098
assign  wn_re[2] = 14'b01111101100011;   assign  wn_im[2] = 14'b11100111000010;   //  2  0.981 -0.195
assign  wn_re[3] = 14'b01111010011111;   assign  wn_im[3] = 14'b11011010110110;   //  3  0.957 -0.290
assign  wn_re[4] = 14'b01110110010000;   assign  wn_im[4] = 14'b11001111000001;   //  4  0.924 -0.383
assign  wn_re[5] = 14'b01110000111001;   assign  wn_im[5] = 14'b11000011101010;   //  5  0.882 -0.471
assign  wn_re[6] = 14'b01101010011011;   assign  wn_im[6] = 14'b10111000111001;   //  6  0.831 -0.556
assign  wn_re[7] = 14'b01100010111101;   assign  wn_im[7] = 14'b10101110110011;   //  7  0.773 -0.634
assign  wn_re[8] = 14'b01011010100001;   assign  wn_im[8] = 14'b10100101011111;   //  8  0.707 -0.707
assign  wn_re[9] = 14'b01010001001101;   assign  wn_im[9] = 14'b10011101000011;   //  9  0.634 -0.773
assign  wn_re[10] = 14'b01000111000111;   assign  wn_im[10] = 14'b10010101100101;   // 10  0.556 -0.831
assign  wn_re[11] = 14'b00111100010110;   assign  wn_im[11] = 14'b10001111000111;   // 11  0.471 -0.882
assign  wn_re[12] = 14'b00110000111111;   assign  wn_im[12] = 14'b10001001110000;   // 12  0.383 -0.924
assign  wn_re[13] = 14'b00100101001010;   assign  wn_im[13] = 14'b10000101100001;   // 13  0.290 -0.957
assign  wn_re[14] = 14'b00011000111110;   assign  wn_im[14] = 14'b10000010011101;   // 14  0.195 -0.981
assign  wn_re[15] = 14'b10000001010010;   assign  wn_im[15] = 14'b10000000100111;   // 15 -0.990 -0.995
assign  wn_re[16] = 14'b10000001010010;   assign  wn_im[16] = 14'b10000000000000;   // 16 -0.990 -1.000
assign  wn_re[17] = 14'b10000001010010;   assign  wn_im[17] = 14'b10000000100111;   // 17 -0.990 -0.995
assign  wn_re[18] = 14'b11100111000010;   assign  wn_im[18] = 14'b10000010011101;   // 18 -0.195 -0.981
assign  wn_re[19] = 14'b11011010110110;   assign  wn_im[19] = 14'b10000101100001;   // 19 -0.290 -0.957
assign  wn_re[20] = 14'b11001111000001;   assign  wn_im[20] = 14'b10001001110000;   // 20 -0.383 -0.924
assign  wn_re[21] = 14'b11000011101010;   assign  wn_im[21] = 14'b10001111000111;   // 21 -0.471 -0.882
assign  wn_re[22] = 14'b10111000111001;   assign  wn_im[22] = 14'b10010101100101;   // 22 -0.556 -0.831
assign  wn_re[23] = 14'b10101110110011;   assign  wn_im[23] = 14'b10011101000011;   // 23 -0.634 -0.773
assign  wn_re[24] = 14'b10100101011111;   assign  wn_im[24] = 14'b10100101011111;   // 24 -0.707 -0.707
assign  wn_re[25] = 14'b10011101000011;   assign  wn_im[25] = 14'b10101110110011;   // 25 -0.773 -0.634
assign  wn_re[26] = 14'b10010101100101;   assign  wn_im[26] = 14'b10111000111001;   // 26 -0.831 -0.556
assign  wn_re[27] = 14'b10001111000111;   assign  wn_im[27] = 14'b11000011101010;   // 27 -0.882 -0.471
assign  wn_re[28] = 14'b10001001110000;   assign  wn_im[28] = 14'b11001111000001;   // 28 -0.924 -0.383
assign  wn_re[29] = 14'b10000101100001;   assign  wn_im[29] = 14'b11011010110110;   // 29 -0.957 -0.290
assign  wn_re[30] = 14'b10000010011101;   assign  wn_im[30] = 14'b11100111000010;   // 30 -0.981 -0.195
assign  wn_re[31] = 14'b10000001010010;   assign  wn_im[31] = 14'b11110011011101;   // 31 -0.990 -0.098
assign  wn_re[32] = 14'b10000001010010;   assign  wn_im[32] = 14'b00000000000000;   // 32 -0.990 -0.000
assign  wn_re[33] = 14'b10000001010010;   assign  wn_im[33] = 14'b00001100100011;   // 33 -0.990  0.098
assign  wn_re[34] = 14'b10000010011101;   assign  wn_im[34] = 14'b00011000111110;   // 34 -0.981  0.195
assign  wn_re[35] = 14'b10000101100001;   assign  wn_im[35] = 14'b00100101001010;   // 35 -0.957  0.290
assign  wn_re[36] = 14'b10001001110000;   assign  wn_im[36] = 14'b00110000111111;   // 36 -0.924  0.383
assign  wn_re[37] = 14'b10001111000111;   assign  wn_im[37] = 14'b00111100010110;   // 37 -0.882  0.471
assign  wn_re[38] = 14'b10010101100101;   assign  wn_im[38] = 14'b01000111000111;   // 38 -0.831  0.556
assign  wn_re[39] = 14'b10011101000011;   assign  wn_im[39] = 14'b01010001001101;   // 39 -0.773  0.634
assign  wn_re[40] = 14'b10100101011111;   assign  wn_im[40] = 14'b01011010100001;   // 40 -0.707  0.707
assign  wn_re[41] = 14'b10101110110011;   assign  wn_im[41] = 14'b01100010111101;   // 41 -0.634  0.773
assign  wn_re[42] = 14'b10111000111001;   assign  wn_im[42] = 14'b01101010011011;   // 42 -0.556  0.831
assign  wn_re[43] = 14'b11000011101010;   assign  wn_im[43] = 14'b01110000111001;   // 43 -0.471  0.882
assign  wn_re[44] = 14'b11001111000001;   assign  wn_im[44] = 14'b01110110010000;   // 44 -0.383  0.924
assign  wn_re[45] = 14'b11011010110110;   assign  wn_im[45] = 14'b01111010011111;   // 45 -0.290  0.957
assign  wn_re[46] = 14'b11100111000010;   assign  wn_im[46] = 14'b01111101100011;   // 46 -0.195  0.981
assign  wn_re[47] = 14'b11110011011101;   assign  wn_im[47] = 14'b01111110101110;   // 47 -0.098  0.990
assign  wn_re[48] = 14'b00000000000000;   assign  wn_im[48] = 14'b01111110101110;   // 48 -0.000  0.990
assign  wn_re[49] = 14'b00001100100011;   assign  wn_im[49] = 14'b01111110101110;   // 49  0.098  0.990
assign  wn_re[50] = 14'b00011000111110;   assign  wn_im[50] = 14'b01111101100011;   // 50  0.195  0.981
assign  wn_re[51] = 14'b00100101001010;   assign  wn_im[51] = 14'b01111010011111;   // 51  0.290  0.957
assign  wn_re[52] = 14'b00110000111111;   assign  wn_im[52] = 14'b01110110010000;   // 52  0.383  0.924
assign  wn_re[53] = 14'b00111100010110;   assign  wn_im[53] = 14'b01110000111001;   // 53  0.471  0.882
assign  wn_re[54] = 14'b01000111000111;   assign  wn_im[54] = 14'b01101010011011;   // 54  0.556  0.831
assign  wn_re[55] = 14'b01010001001101;   assign  wn_im[55] = 14'b01100010111101;   // 55  0.634  0.773
assign  wn_re[56] = 14'b01011010100001;   assign  wn_im[56] = 14'b01011010100001;   // 56  0.707  0.707
assign  wn_re[57] = 14'b01100010111101;   assign  wn_im[57] = 14'b01010001001101;   // 57  0.773  0.634
assign  wn_re[58] = 14'b01101010011011;   assign  wn_im[58] = 14'b01000111000111;   // 58  0.831  0.556
assign  wn_re[59] = 14'b01110000111001;   assign  wn_im[59] = 14'b00111100010110;   // 59  0.882  0.471
assign  wn_re[60] = 14'b01110110010000;   assign  wn_im[60] = 14'b00110000111111;   // 60  0.924  0.383
assign  wn_re[61] = 14'b01111010011111;   assign  wn_im[61] = 14'b00100101001010;   // 61  0.957  0.290
assign  wn_re[62] = 14'b01111101100011;   assign  wn_im[62] = 14'b00011000111110;   // 62  0.981  0.195
assign  wn_re[63] = 14'b01111110101110;   assign  wn_im[63] = 14'b00001100100011;   // 63  0.990  0.098


endmodule
