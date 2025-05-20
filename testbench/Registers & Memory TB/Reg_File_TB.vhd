-- Project: MIPS32 multi-cycle
-- Module:  Reg_File_tb
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_File_tb is
end Reg_File_tb;

architecture behavior of Reg_File_tb is
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal reg_write   : std_logic := '0';
    signal read_reg1   : std_logic_vector(4 downto 0) := (others => '0');
    signal read_reg2   : std_logic_vector(4 downto 0) := (others => '0');
    signal write_reg   : std_logic_vector(4 downto 0) := (others => '0');
    signal write_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal read_data1  : std_logic_vector(31 downto 0);
    signal read_data2  : std_logic_vector(31 downto 0);

    component Reg_File
        port (
            clk         : in std_logic;
            reset       : in std_logic;
            reg_write   : in std_logic;
            read_reg1   : in std_logic_vector(4 downto 0);
            read_reg2   : in std_logic_vector(4 downto 0);
            write_reg   : in std_logic_vector(4 downto 0);
            write_data  : in std_logic_vector(31 downto 0);
            read_data1  : out std_logic_vector(31 downto 0);
            read_data2  : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: Reg_File
        port map (
            clk         => clk,
            reset       => reset,
            reg_write   => reg_write,
            read_reg1   => read_reg1,
            read_reg2   => read_reg2,
            write_reg   => write_reg,
            write_data  => write_data,
            read_data1  => read_data1,
            read_data2  => read_data2
        );

    clk_process: process
    begin
        while now < 200 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    stim_proc: process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        reg_write <= '1';
        write_reg <= "00001";
        write_data <= x"11111111";
        wait for 10 ns;

        reg_write <= '0';
        read_reg1 <= "00001";
        read_reg2 <= "00000";
        wait for 10 ns;

        wait;
    end process;

end behavior;
