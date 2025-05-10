-- Project: MIPS32 multi-cycle
-- Module:  MUX4To1_32_tb
library ieee;
use ieee.std_logic_1164.all;

entity Mux4To1_32_tb is
end entity;

architecture sim of Mux4To1_32_tb is 
signal in0: std_logic_vector(31 downto 0):=(others=>'0'); 
signal in1: std_logic_vector(31 downto 0):=(others=>'1');
signal in2: std_logic_vector(31 downto 0):=(31 downto 15=>'1',others=>'0'); 
signal in3: std_logic_vector(31 downto 0):=(31 downto 15=>'0',others=>'1');
signal	selector:  std_logic_vector(1 downto 0):="10";
signal	output: std_logic_vector(31 downto 0);
begin	
f:entity Mux4To1_32 port map(in0=>in0,in1=>in1,in2=>in2,in3=>in3,selector=>selector,output=>output);	
end architecture ;