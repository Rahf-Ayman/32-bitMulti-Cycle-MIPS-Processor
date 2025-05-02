library ieee;
use ieee.std_logic_1164.all;

entity ShiftLeft1_tb is
end entity;

architecture sim of ShiftLeft1_tb is
	signal i: std_logic_vector(31 downto 0):=(27 downto 24=>'0',others=>'1');	--1111_0000_1111_1111_.....
	signal o: std_logic_vector(31 downto 0);
begin	
SL1:entity ShiftLeft1 port map(i=>i,o=>o);
end architecture ;