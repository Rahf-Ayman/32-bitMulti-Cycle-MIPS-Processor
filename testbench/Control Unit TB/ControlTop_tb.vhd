-- Project: MIPS32 multi-cycle
-- Module:  Control Top tb
library ieee;
use ieee.std_logic_1164.all;


entity ControlTop_tb is
	
end ControlTop_tb;

architecture sim of ControlTop_tb is

signal CLK : std_logic := '0' ;
signal reset : std_logic := '0' ;
signal func : std_logic_vector(5 downto 0) := "000000" ;
signal Op : std_logic_vector(5 downto 0) := "000000";

signal operation : std_logic_vector(3 downto 0) := "0000" ;
signal RegDst : std_logic := '0' ; 
signal RegWrite :  std_logic := '0' ;
signal ALUSrcA :  std_logic := '0' ;
signal MemRead :  std_logic := '0' ;
signal MemWrite :  std_logic := '0' ;
signal MemtoReg : std_logic := '0';
signal IorD : std_logic := '0' ;
signal IRWrite : std_logic := '0' ;
signal PCWrite :  std_logic := '0' ;
signal PCWriteCond :  std_logic := '0' ;
signal ALUSrcB : std_logic_vector (1 downto 0) := "00";
signal PCSource : std_logic_vector (1 downto 0) := "00";

begin
	DUT : entity ControlTop
		port map(
		CLK => CLK,
		reset => reset,
		func => func,
		Op => Op,
		
		operation => operation,
		RegDst => RegDst,
		RegWrite => RegWrite,
		ALUSrcA => ALUSrcA,
		MemRead => MemRead,
		MemWrite => MemWrite,
		MemtoReg => MemtoReg,
		IorD => IorD,
		IRWrite => IRWrite,
		PCWrite => PCWrite,
		PCWriteCond => PCWriteCond,
		ALUSrcB => ALUSrcB,
		PCSource => PCSource
		);
		
	-- Clock generation process
    clk_process : process
    begin
        while true loop
            CLK <= '0';
            wait for 10 ns;
            CLK <= '1';
            wait for 10 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Reset pulse
        --reset <= '1';
--        wait for 40 ns;
--        reset <= '0';
--        wait for 20 ns;

        -- I-Type & J-Type Instructions
        --Op <= "100011"; wait for 100 ns; -- lw
--        Op <= "101011"; wait for 100 ns; -- sw
--        Op <= "001000"; wait for 100 ns;  --addi
--        Op <= "001100"; wait for 100 ns; -- andi
--        Op <= "001101"; wait for 100 ns; -- ori
--        Op <= "000100"; wait for 100 ns; -- beq
        Op <= "000010"; wait for 100 ns; -- jump

        -- R-Type Instructions (Op = 000000)
        
		--Op <= "000000"; 
		--func <= "100000"; wait for 100 ns; -- add
		--func <= "100010"; wait for 100 ns; -- sub
--        func <= "100100"; wait for 100 ns; -- and
--        func <= "100101"; wait for 100 ns; -- or
--        func <= "100110"; wait for 100 ns; -- xor
--        func <= "100111"; wait for 100 ns; -- nor
--        func <= "101010"; wait for 100 ns; -- slt
--        func <= "000000"; wait for 100 ns; -- sll
--        func <= "000010"; wait for 100 ns; -- srl
--        func <= "000011"; wait for 100 ns; -- sra

        
    end process;
end sim;