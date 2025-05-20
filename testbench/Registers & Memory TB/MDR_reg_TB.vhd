-- Project: MIPS32 multi-cycle
-- Module:  MDR_reg_tb
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MDR_reg_tb is
end MDR_reg_tb;

architecture behavior of MDR_reg_tb is
    signal clk      : std_logic := '0';
    signal reg_in   : std_logic_vector(31 downto 0) := (others => '0');
    signal reg_out  : std_logic_vector(31 downto 0);

    component MDR_reg
        port (
            clk      : in std_logic;
            reg_in   : in std_logic_vector(31 downto 0);
            reg_out  : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: MDR_reg
        port map (
            clk      => clk,
            reg_in   => reg_in,
            reg_out  => reg_out
        );

    clk_process: process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        wait for 10 ns;
        reg_in <= x"12345678";
        wait for 10 ns;
        reg_in <= x"DEADBEEF";
        wait for 10 ns;
        wait;
    end process;

end behavior;

