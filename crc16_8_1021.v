//-----------------------------------------------------------------------------
// Copyright (C) 2009 OutputLogic.com
// This source file may be used and distributed without restriction
// provided that this copyright statement is not removed from the file
// and that any derivative work contains the original copyright notice
// and the associated disclaimer.
// THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
// OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
//-----------------------------------------------------------------------------
// CRC module for
//  data[7:0]
//  crc[15:0]=1+x^5+x^12+x^16;
//

// verilog_format: off
`resetall
`timescale 1ns / 1ps
`default_nettype none
// verilog_format: on

module crc16_8_1021 #(
    parameter INPUT_WIDTH = 8,
    parameter OUTPUT_WIDTH = 16,
    parameter INIT = 16'hFFFF,
    parameter OUTPUT_XOR = 16'hFFFF,
    parameter INPUT_INV = 1'b1,
    parameter OUTPUT_INV = 1'b1
) (
    input  wire [ 7:0] data_in,
    input  wire        crc_en,
    output wire [15:0] crc_out,
    input  wire        rst,
    input  wire        clk
);
    genvar ii;
    wire [ (INPUT_WIDTH-1):0] data_in_inv;
    wire [ (INPUT_WIDTH-1):0] data_in_inv_res;
    wire [(OUTPUT_WIDTH-1):0] crc_out_inv;
    wire [(OUTPUT_WIDTH-1):0] crc_out_inv_res;
    reg [15:0] lfsr_q, lfsr_c;

    generate
        for (ii = 0; ii < INPUT_WIDTH; ii = ii + 1) begin
            assign data_in_inv[ii] = data_in[INPUT_WIDTH-ii-1];
        end
        for (ii = 0; ii < OUTPUT_WIDTH; ii = ii + 1) begin
            assign crc_out_inv[ii] = lfsr_q[OUTPUT_WIDTH-ii-1];
        end
    endgenerate

    // 输入反转
    assign data_in_inv_res = (INPUT_INV == 1'b1) ? (data_in_inv) : data_in;
    // 输出反转
    assign crc_out_inv_res = (OUTPUT_INV == 1'b1) ? (crc_out_inv) : lfsr_q;
    // 输出异或
    assign crc_out         = crc_out_inv_res ^ OUTPUT_XOR;

    always @(*) begin
        lfsr_c[0] = lfsr_q[8] ^ lfsr_q[12] ^ data_in_inv_res[0] ^ data_in_inv_res[4];
        lfsr_c[1] = lfsr_q[9] ^ lfsr_q[13] ^ data_in_inv_res[1] ^ data_in_inv_res[5];
        lfsr_c[2] = lfsr_q[10] ^ lfsr_q[14] ^ data_in_inv_res[2] ^ data_in_inv_res[6];
        lfsr_c[3] = lfsr_q[11] ^ lfsr_q[15] ^ data_in_inv_res[3] ^ data_in_inv_res[7];
        lfsr_c[4] = lfsr_q[12] ^ data_in_inv_res[4];
        lfsr_c[5]  = lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[13] ^ data_in_inv_res[0] ^ data_in_inv_res[4] ^ data_in_inv_res[5];
        lfsr_c[6]  = lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ data_in_inv_res[1] ^ data_in_inv_res[5] ^ data_in_inv_res[6];
        lfsr_c[7]  = lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ data_in_inv_res[2] ^ data_in_inv_res[6] ^ data_in_inv_res[7];
        lfsr_c[8] = lfsr_q[0] ^ lfsr_q[11] ^ lfsr_q[15] ^ data_in_inv_res[3] ^ data_in_inv_res[7];
        lfsr_c[9] = lfsr_q[1] ^ lfsr_q[12] ^ data_in_inv_res[4];
        lfsr_c[10] = lfsr_q[2] ^ lfsr_q[13] ^ data_in_inv_res[5];
        lfsr_c[11] = lfsr_q[3] ^ lfsr_q[14] ^ data_in_inv_res[6];
        lfsr_c[12] = lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[15] ^ data_in_inv_res[0] ^ data_in_inv_res[4] ^ data_in_inv_res[7];
        lfsr_c[13] = lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[13] ^ data_in_inv_res[1] ^ data_in_inv_res[5];
        lfsr_c[14] = lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[14] ^ data_in_inv_res[2] ^ data_in_inv_res[6];
        lfsr_c[15] = lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[15] ^ data_in_inv_res[3] ^ data_in_inv_res[7];
    end  // always

    always @(posedge clk, posedge rst) begin
        if (rst) begin
            lfsr_q <= INIT;
        end else begin
            lfsr_q <= crc_en ? lfsr_c : lfsr_q;
        end
    end  // always
endmodule  // crc

// verilog_format: off
`resetall
// verilog_format: on
