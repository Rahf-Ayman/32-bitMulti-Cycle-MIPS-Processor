library ieee;
use ieee.std_logic_1164.all;

entity MIPS_Processor_tb is
	
end MIPS_Processor_tb;

architecture behavior of MIPS_Processor_tb is
	 component MIPS_Processor
        port (
			CLK : in std_logic;
			reset : in std_logic
			);
    end component;

    -- Signals to connect to the UUT
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
	
	
	begin
		clk <= not clk after 10ns;
		DUT : MIPS_Processor port map(
		CLK => clk,
		reset => reset
		
		);
end behavior;
	