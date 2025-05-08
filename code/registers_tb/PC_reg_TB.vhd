library ieee;
use ieee.std_logic_1164.all;

entity pc_reg_tb is
end entity;

architecture behavior of pc_reg_tb is
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal pc_write : std_logic := '0';
    signal pc_in    : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_out   : std_logic_vector(31 downto 0);

    component pc_reg
        port (
            clk      : in std_logic;
            reset    : in std_logic;
            pc_write : in std_logic;
            pc_in    : in std_logic_vector(31 downto 0);
            pc_out   : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    uut: pc_reg
        port map (
            clk => clk,
            reset => reset,
            pc_write => pc_write,
            pc_in => pc_in,
            pc_out => pc_out
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
        reset <= '1';
        wait for 20 ns;
        
        reset <= '0';
        pc_in <= "00000000000000000000000000000001";
        pc_write <= '1';
        wait for 20 ns;

        pc_in <= "00000000000000000000000000000010";
        wait for 20 ns;

        pc_write <= '0';
        wait for 20 ns;

        reset <= '1';
        wait for 20 ns;
        
        reset <= '0';
        wait for 20 ns;

        wait;
    end process;

end architecture;
