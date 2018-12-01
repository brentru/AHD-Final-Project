----------------------------------------------------------------------------------
-- Company: NYU Tandon AHD
-- Engineer: 
-- 
-- Create Date: 11/06/2018
-- Design Name: 
-- Module Name: dmem - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Data Memory for MIPS32-AHD 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created (11/06/2018 03:49PM)
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity dmem is
    Port ( 
            CLK, WE : in std_logic;
            A, WD   : in std_logic_vector(31 downto 0);
            RD      : out std_logic_vector(31 downto 0)         
    );
end dmem;


architecture Behavioral of dmem is

-- Component Sign Extend
component signextend
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

type RAM_Type is array (0 to 1023) of std_logic_vector(15 downto 0);

signal RAM : RAM_Type := (
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000", 
    "0100011011111000", "1110100011000101", "0100011000001100", "0110000010000101", 
    "0111000011111000", "0011101110001010", "0010100001001011", "1000001100000011",
    "0101000100111110", "0001010001010100", "1111011000100001", "1110110100100010",
    "0011000100100101", "0000011001011101", "0001000110101000", "0011101001011101",
    "1101010000100111", "0110100001101011", "0111000100111010", "1101100000101101",
    "0100101101111001", "0010111110011001", "0010011110011001", "1010010011011101",
    "1010011110010000", "0001110001001001", "1101111011011110", "1000011100011010",
    "0011011011000000", "0011000110010110", "1010011111101111", "1100001001001001",
    "0110000110100111", "1000101110111000", "0011101100001010", "0001110100101011",
    "0100110110111111", "1100101001110110", "1010111000010110", "0010000101100111",
    "0011000011010111", "0110101100001010", "0100001100011001", "0010001100000100", 
    "1111011011001100", "0001010000110001", "0110010100000100", "0110001110000000", 
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",         --Add A and B
    "0000000011111111", "0000000000000000", "0000000000000000", "0000000000000000",
    "0101000101100011", "1011011111100001", "0111100110111001", "1001111000110111",         -- P and Q Magic Numbers. Starting w/ P lsb, P msb, Q lsb, Q msb
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000",
    "0000000000000000", "0000000000000000", "0000000000000000", "0000000000000000"   
);

signal sig_input : std_logic_vector(15 downto 0);

begin

    process(clk)
    begin
        if (rising_edge(clk) AND WE = '1') then    
            RAM(to_integer(unsigned(A(9 downto 0)))) <= WD(15 downto 0);
        end if;
    end process;
    
    sig_input <= RAM(to_integer(unsigned(A(9 downto 0))));
    
    signext : signextend PORT MAP (input => sig_input, output => RD);

end Behavioral;