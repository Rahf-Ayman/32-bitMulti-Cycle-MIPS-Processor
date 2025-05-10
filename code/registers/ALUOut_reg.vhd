-- Project: MIPS32 multi-cycle
-- Module:  ALUOut_reg
library ieee;
use ieee.std_logic_1164.all;

entity ALUOut_reg is
    port (
        clk      : in std_logic;
        reg_in   : in std_logic_vector(31 downto 0);
        reg_out  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of ALUOut_reg is
    signal temp : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            temp <= reg_in;
        end if;
    end process;

    reg_out <= temp;
end architecture;
