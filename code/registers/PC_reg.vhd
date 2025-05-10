-- Project: MIPS32 multi-cycle
-- Module:  PC_reg
library ieee;
use ieee.std_logic_1164.all;

entity pc_reg is
    port (
        clk      : in std_logic;
        reset    : in std_logic;
        pc_write : in std_logic;
        pc_in    : in std_logic_vector(31 downto 0);
        pc_out   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of pc_reg is
    signal pc : std_logic_vector(31 downto 0) := (others => '0');
begin

    process(clk, reset)
    begin
        if reset = '1' then
            pc <= (others => '0');
        elsif rising_edge(clk) then
            if pc_write = '1' then
                pc <= pc_in;
            end if;
        end if;
    end process;

    pc_out <= pc;

end architecture;
