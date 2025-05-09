library ieee;
use ieee.std_logic_1164.all;

entity connection_tb is
end entity;

architecture sim of connection_tb is
component connection is
	port (
	clk : in std_logic;
	reset : in std_logic
	);
end component;
signal clk : std_logic := '0';
signal reset : std_logic := '0';
constant clk_period : time := 400 ns;


begin 
	
	uut: connection
        port map (
            clk => clk,
            reset => reset
        );
		
		clk_process : process
    begin
        if(clk='0') then 
			clk<='1';
			wait for 150 ns;
		else
			clk<='0';
			wait for 50 ns;
		end if;
    end process;
	
	stim_process : process
    begin
        reset <= '0';
        wait for 150 ns;  
        reset <= '1'; 
        wait;
    end process;
end architecture ;
