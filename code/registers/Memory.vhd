library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    port (
        clk        : in std_logic;
        address    : in std_logic_vector(31 downto 0);
        data_in    : in std_logic_vector(31 downto 0);
        mem_write  : in std_logic;
        mem_read   : in std_logic;
        data_out   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of Memory is
    type mem_array is array(0 to 2047) of std_logic_vector(7 downto 0);
    signal memory : mem_array := (
    
	-- Instruction: lw $t1, 0($t0) => 0x8C490000
    0  => x"8C",  -- opcode (100011), rs=$t0 (2), rt=$t1 (9), offset=0
    1  => x"49",
    2  => x"00",
    3  => x"00",
	-- Data at 0x00000020: 0xCAFEBABE
    32 => x"CA",
    33 => x"FE",
    34 => x"BA",
    35 => x"BE",
    
    -- initialize all others to 0
    others => (others => '0') 
);

begin

    process(clk)
        variable addr_index : integer;
    begin
        if rising_edge(clk) then
            if mem_write = '1' then
                addr_index := to_integer(unsigned(address));
                memory(addr_index)     <= data_in(31 downto 24);
                memory(addr_index + 1) <= data_in(23 downto 16);
                memory(addr_index + 2) <= data_in(15 downto 8);
                memory(addr_index + 3) <= data_in(7 downto 0);
            end if;
        end if;
    end process;

    process(mem_read, address)
        variable addr_index : integer;
    begin
        if mem_read = '1' then
            addr_index := to_integer(unsigned(address));
            data_out(31 downto 24) <= memory(addr_index);
            data_out(23 downto 16) <= memory(addr_index + 1);
            data_out(15 downto 8)  <= memory(addr_index + 2);
            data_out(7 downto 0)   <= memory(addr_index + 3);
        else
            data_out <= (others => '0');
        end if;
    end process;

end architecture;
