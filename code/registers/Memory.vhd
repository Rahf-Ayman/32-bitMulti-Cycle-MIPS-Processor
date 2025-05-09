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
-- auto generated
-- lw $R0, 47($R20)
0 => "10001110",  -- opcode for lw
1 => "00000000",  -- base register (R20)
2 => "00000000",  -- offset (lower 8 bits)
3 => "00101111",  -- offset (upper 8 bits)

-- addi $R1, $R3, 50
4 => "00100000",  -- opcode for addi
5 => "01100001",  -- source register (R3)
6 => "00000000",  -- immediate value (lower 8 bits)
7 => "00110010",  -- immediate value (upper 8 bits)

-- addi $R2, $R3, 48
8 => "00100000",  -- opcode for addi
9 => "01100010",  -- source register (R3)
10 => "00000000", -- immediate value (lower 8 bits)
11 => "00110000", -- immediate value (upper 8 bits)

-- sw $R1, 0($R2)
12 => "10101100",  -- opcode for sw
13 => "00000001",  -- source register (R1)
14 => "00000000",  -- base register (R2)
15 => "00000000",  -- offset (lower 8 bits)

-- beq $R1, $R2, 1
16 => "00010000",  -- opcode for beq
17 => "00100010",  -- source register (R1)
18 => "00000000",  -- target register (R2)
19 => "00000001",  -- immediate value (offset)

-- j 3
20 => "00001000",  -- opcode for j
21 => "00000000",  -- address (lower 8 bits)
22 => "00000000",  -- address (middle 8 bits)
23 => "00000011",  -- address (upper 8 bits)

-- add $R0, $R1, $R2
24 => "00000000",  -- opcode for add
25 => "00100010",  -- source register (R1)
26 => "00000000",  -- target register (R2)
27 => "00100000",  -- destination register (R0)

-- lw $R10, 47($R20)
28 => "10001110",  -- opcode for lw
29 => "00001010",  -- base register (R20)
30 => "00000000",  -- offset (lower 8 bits)
31 => "00101111",  -- offset (upper 8 bits)

-- Default case for unspecified instructions
50 => "00000001",  -- some default instruction
others => "00000000"
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
