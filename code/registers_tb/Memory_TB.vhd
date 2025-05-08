library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_tb is
end entity;

architecture behavior of Memory_tb is
    signal clk        : std_logic := '0';
    signal address    : std_logic_vector(31 downto 0) := (others => '0');
    signal data_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal mem_write  : std_logic := '0';
    signal mem_read   : std_logic := '0';
    signal data_out   : std_logic_vector(31 downto 0);

    component Memory
        port (
            clk        : in std_logic;
            address    : in std_logic_vector(31 downto 0);
            data_in    : in std_logic_vector(31 downto 0);
            mem_write  : in std_logic;
            mem_read   : in std_logic;
            data_out   : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: Memory
        port map (
            clk => clk,
            address => address,
            data_in => data_in,
            mem_write => mem_write,
            mem_read => mem_read,
            data_out => data_out
        );

    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    stimulus_process: process
    begin
        mem_write <= '0';
        mem_read <= '0';
        address <= (others => '0');
        data_in <= (others => '0');
        wait for 20 ns;
        
        mem_write <= '1';
        data_in <= "00000000000000000000000010101010";
        address <= "00000000000000000000000000000001";
        wait for 20 ns;
        
        mem_write <= '0';
        wait for 20 ns;
        
        mem_read <= '1';
        address <= "00000000000000000000000000000001";
        wait for 20 ns;
        
        mem_read <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;
