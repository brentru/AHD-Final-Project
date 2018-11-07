----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/06/2018 05:12:03 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0));
end top_module;

architecture Behavioral of top_module is

-- Component PC
component pc
    Port ( in_pc : in STD_LOGIC_VECTOR (31 downto 0);
       clr : in STD_LOGIC;
       clk : in STD_LOGIC;
       out_pc : out STD_LOGIC_VECTOR (31 downto 0));
end component;

-- Component Imem
component imem
    Port ( 
       in_pc : in std_logic_vector (31 downto 0);
       out_imem : out std_logic_vector (31 downto 0));
end component;

-- Component RF

component rf
    Port (
        CLK, WE3   : in std_logic;
        A1, A2, A3 : in std_logic_vector(4 downto 0);
        WD3        : in std_logic_vector(31 downto 0);   
        RD1, RD2   : out std_logic_vector(31 downto 0));
end component;

-- Component Control Unit
component control_unit
    Port ( opCode : in STD_LOGIC_VECTOR (5 downto 0);
       funct : in STD_LOGIC_VECTOR (5 downto 0);
       controlReg : out STD_LOGIC_VECTOR (8 downto 0));
end component;

-- component FlipFlop 1-bit
component FF1bit
    Port (
        clk, input : in std_logic;
        output     : out std_logic);
end component;

-- Component Sign Extend
component signextend
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

-- component ALU

component ALU_FPGA
    Port ( SrcA : in STD_LOGIC_VECTOR (31 downto 0);
       SrcB : in STD_LOGIC_VECTOR (31 downto 0);
       ALU_Control : in STD_LOGIC_VECTOR (2 downto 0);
       ALU_Result : out STD_LOGIC_VECTOR (31 downto 0);
       Flag_Zero : out STD_LOGIC;
       Flag_Negative : out STD_Logic);
end component;

 -- component DMEM
 component dmem
     Port ( 
         CLK, WE : in std_logic;
         A, WD   : in std_logic_vector(31 downto 0);
         RD      : out std_logic_vector(31 downto 0));
 end component;
 
 
 --  Component MUX32
 
 component mux32bit2to1
     Port (
         SEL       : in std_logic;
         A, B      : in std_logic_vector(31 downto 0);
         X         : out std_logic_vector(31 downto 0));
 end component;

 --  Component MUX5
 
 component mux5bit2to1
     Port (
         SEL       : in std_logic;
         A, B      : in std_logic_vector(4 downto 0);
         X         : out std_logic_vector(4 downto 0));
 end component;


-- Compunent SignExtt
component signextent
    Port (
        input  : in std_logic_vector(15 downto 0);
        output : out std_logic_vector(31 downto 0));
end component;

-- Left shift Component
component Shift_Left_Func is
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Shift_Amt : in STD_LOGIC_VECTOR (4 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

-- Component Add 
component Add_Func
    Port ( A_Source : in STD_LOGIC_VECTOR (31 downto 0);
           B_Source : in STD_LOGIC_VECTOR (31 downto 0);
           Output_Val : out STD_LOGIC_VECTOR (31 downto 0);
           Zero_Flag : out STD_LOGIC);
end component;

-- Signals

signal in_pc : std_logic_vector (31 downto 0) := X"00000000";
signal progCounter : std_logic_vector (31 downto 0);
signal pcPlus4 : std_logic_vector (31 downto 0);
signal pcBranch : std_logic_vector (31 downto 0);

signal currentInst : std_logic_vector (31 downto 0);

signal sourceA : std_logic_vector (31 downto 0);
signal register2 : std_logic_vector (31 downto 0);
signal sourceB : std_logic_vector (31 downto 0);
signal currentInst_A3 : std_logic_vector (4 downto 0);

signal signImm : std_logic_vector (31 downto 0);
signal signImmLeftShift : std_logic_vector (31 downto 0);

signal ALUResult : std_logic_vector (31 downto 0);
signal zero: std_logic;
signal negative: std_logic;
signal orOp: std_logic;


signal memReadData : std_logic_vector (31 downto 0);

signal result : std_logic_vector (31 downto 0);


-- Control signals
signal cPCsrc: std_logic;
signal cMemToReg: std_logic;
signal cMemWrite: std_logic;
signal cBranch: std_logic;
signal cALUOpcode: std_logic_vector(2 downto 0);
signal cALUSrc: std_logic;
signal cRegDst: std_logic;
signal cRegWrite: std_logic;
signal tempCoontrolReg : std_logic_vector ( 8 downto 0 );

constant two : std_logic_vector( 4 downto 0 ) := "00010";
constant four : std_logic_vector( 31 downto 0 ) := X"00000004";
constant one : std_logic_vector( 31 downto 0 ) := X"00000001";

begin

-- Define control Reg

cMemToReg <= tempCoontrolReg(8);
cMemWrite <= tempCoontrolReg(7);
cBranch <= tempCoontrolReg(6);
cALUOpcode <= tempCoontrolReg(5 downto 3);
cALUSrc <= tempCoontrolReg(2);
cRegDst <= tempCoontrolReg(1);
cRegWrite <= tempCoontrolReg(0);

-- Main Components

pc1: pc PORT MAP(in_pc => in_pc, clr => rst, clk => clk, out_pc => progCounter );
imem0: imem PORT MAP( in_pc => progCounter, out_imem => currentInst);
rf0: rf PORT Map ( clk => clk, WE3 => cRegWrite, A1 => currentInst( 25 downto 21), A2 => currentInst( 20 downto 16 ), A3 => currentInst_A3 , WD3 => result , RD1 => sourceA, RD2 => register2 );
alu0: ALU_FPGA PORT MAP( SrcA => sourceA, SrcB => sourceB, ALU_Control => cALUOpcode, ALU_Result => ALUResult, Flag_Zero => zero, Flag_Negative => negative );
cu0: control_unit PORT MAP( opcode => currentInst( 31 downto 26), funct => currentInst( 5 downto 0), controlReg => tempCoontrolReg );
dmem0: dmem PORT MAP ( clk => clk, WE => cMemWrite, A => ALUResult, WD => register2, RD => memReadData );


-- MUX and other components

mux0: mux32bit2to1 PORT MAP( SEL => cPCsrc, A => pcPlus4, B => pcBranch, X => in_pc );
mux1: mux5bit2to1 PORT MAP( SEL => cRegDst, A => currentInst( 20 downto 16 ), B => currentInst( 15 downto 11 ), X => currentInst_A3 );
mux2: mux32bit2to1 PORT MAP( SEL => cALUSrc, A => register2, B => signImm, X => sourceB );
mux3: mux32bit2to1 PORT MAP( SEL => cMemToReg, A => ALUResult, B => memReadData, X => result);
se0: signextend PORT MAP ( input => currentInst( 15 downto 0), output => signImm );
ls0: Shift_Left_Func PORT MAP ( A_Source => signImm, Shift_Amt => two , Output_Val => signImmLeftShift);
adder1: Add_Func PORT MAP ( A_Source => progCounter, B_Source => one , Output_Val => pcPlus4 );
adder2: Add_Func PORT MAP ( A_Source => signImmLeftShift , B_Source => pcPlus4 , Output_Val => pcBranch );

-- Branch signal

orOp <= zero OR negative;
cPCsrc <= cBranch AND orOp;

output <= result;

end Behavioral;