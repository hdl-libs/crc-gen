
-------------------------------------------------------------------------------
-- Copyright (C) 2009 OutputLogic.com
-- This source file may be used and distributed without restriction
-- provided that this copyright statement is not removed from the file
-- and that any derivative work contains the original copyright notice
-- and the associated disclaimer.
-- THIS SOURCE FILE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS
-- OR IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
-------------------------------------------------------------------------------
-- CRC module for
--    data(7:0)
--    crc(15:0)=1+x^5+x^12+x^16;

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------
entity crc is
    generic (
        INPUT_WIDTH  : integer := 8;
        OUTPUT_WIDTH : integer := 16;
        INIT         : std_logic_vector(15 downto 0) := (others => '1');
        OUTPUT_XOR   : std_logic_vector(15 downto 0) := (others => '0');
        INPUT_INV    : std_logic := '0';
        OUTPUT_INV   : std_logic := '0'
    );
    port (
        data_in : in  std_logic_vector((INPUT_WIDTH-1) downto 0);
        crc_en  : in  std_logic;
        crc_out : out std_logic_vector((OUTPUT_WIDTH-1) downto 0);
        rst     : in  std_logic;
        clk     : in  std_logic
    );
end entity crc;
architecture imp_crc of crc is
    signal data_in_inv      : std_logic_vector((INPUT_WIDTH-1) downto 0);
    signal data_in_inv_res  : std_logic_vector((INPUT_WIDTH-1) downto 0);
    signal crc_out_inv      : std_logic_vector((OUTPUT_WIDTH-1) downto 0);
    signal crc_out_inv_res  : std_logic_vector((OUTPUT_WIDTH-1) downto 0);
    signal lfsr_q           : std_logic_vector((OUTPUT_WIDTH-1) downto 0);
    signal lfsr_c           : std_logic_vector((OUTPUT_WIDTH-1) downto 0);
begin

    -- input reverse
    gen_data_in_inv: for ii in 0 to INPUT_WIDTH-1 generate
        data_in_inv(ii) <= data_in(INPUT_WIDTH-ii-1);
    end generate gen_data_in_inv;

    -- output reverse
    gen_crc_out_inv: for ii in 0 to OUTPUT_WIDTH-1 generate
        crc_out_inv(ii) <= lfsr_q(OUTPUT_WIDTH-ii-1);
    end generate gen_crc_out_inv;

    -- input reverse
    data_in_inv_res <= data_in_inv when INPUT_INV = '1' else data_in;
    -- output reverse
    crc_out_inv_res <= crc_out_inv when OUTPUT_INV = '1' else lfsr_q;
    -- output xor
    crc_out <= crc_out_inv_res xor OUTPUT_XOR;

    lfsr_c(0) <= lfsr_q(8) xor lfsr_q(12) xor data_in_inv_res(0) xor data_in_inv_res(4);
    lfsr_c(1) <= lfsr_q(9) xor lfsr_q(13) xor data_in_inv_res(1) xor data_in_inv_res(5);
    lfsr_c(2) <= lfsr_q(10) xor lfsr_q(14) xor data_in_inv_res(2) xor data_in_inv_res(6);
    lfsr_c(3) <= lfsr_q(11) xor lfsr_q(15) xor data_in_inv_res(3) xor data_in_inv_res(7);
    lfsr_c(4) <= lfsr_q(12) xor data_in_inv_res(4);
    lfsr_c(5) <= lfsr_q(8) xor lfsr_q(12) xor lfsr_q(13) xor data_in_inv_res(0) xor data_in_inv_res(4) xor data_in_inv_res(5);
    lfsr_c(6) <= lfsr_q(9) xor lfsr_q(13) xor lfsr_q(14) xor data_in_inv_res(1) xor data_in_inv_res(5) xor data_in_inv_res(6);
    lfsr_c(7) <= lfsr_q(10) xor lfsr_q(14) xor lfsr_q(15) xor data_in_inv_res(2) xor data_in_inv_res(6) xor data_in_inv_res(7);
    lfsr_c(8) <= lfsr_q(0) xor lfsr_q(11) xor lfsr_q(15) xor data_in_inv_res(3) xor data_in_inv_res(7);
    lfsr_c(9) <= lfsr_q(1) xor lfsr_q(12) xor data_in_inv_res(4);
    lfsr_c(10) <= lfsr_q(2) xor lfsr_q(13) xor data_in_inv_res(5);
    lfsr_c(11) <= lfsr_q(3) xor lfsr_q(14) xor data_in_inv_res(6);
    lfsr_c(12) <= lfsr_q(4) xor lfsr_q(8) xor lfsr_q(12) xor lfsr_q(15) xor data_in_inv_res(0) xor data_in_inv_res(4) xor data_in_inv_res(7);
    lfsr_c(13) <= lfsr_q(5) xor lfsr_q(9) xor lfsr_q(13) xor data_in_inv_res(1) xor data_in_inv_res(5);
    lfsr_c(14) <= lfsr_q(6) xor lfsr_q(10) xor lfsr_q(14) xor data_in_inv_res(2) xor data_in_inv_res(6);
    lfsr_c(15) <= lfsr_q(7) xor lfsr_q(11) xor lfsr_q(15) xor data_in_inv_res(3) xor data_in_inv_res(7);

    process (clk, rst) begin
        if rst = '1' then
            lfsr_q <= INIT;
        elsif rising_edge(clk) then
            if crc_en = '1' then
                lfsr_q <= lfsr_c;
            else
                null;
            end if;
        end if;
    end process;

end architecture imp_crc;
