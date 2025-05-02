library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft2_tb is
end entity;

architecture sim of ShiftLeft2_tb is
	signal i: std_logic_vector(25 downto 0):=(21 downto 18=>'0',others=>'1');	--1111_0000_1111_1111_.....
	signal o: std_logic_vector(27 downto 0);
begin	
SL1:entity ShiftLeft2 port map(i=>i,o=>o);
end architecture ;