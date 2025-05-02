library ieee;
use ieee.std_logic_1164.all;

entity SignExtend_tb is
end entity;

architecture sim of SignExtend_tb is
	signal i: std_logic_vector(15 downto 0):=(13|12=>'0',others=>'1');	
	signal o: std_logic_vector(31 downto 0);
begin	
SES:entity SignExtend port map(i=>i,o=>o);
end architecture ;
