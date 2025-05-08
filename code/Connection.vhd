library ieee;
use ieee.std_logic_1164.all;

entity connection is
	port (
	CLK : in std_logic;
	reset : in std_logic
	);
end connection;

architecture behavior of connection is
-- component of register
	-- here
--

-- component of dataflow
	-- here
--

-- component of control unit
	-- here
	component ControlTop is
	port(
	    -- input
	    CLK : in std_logic;
		reset : in std_logic;
		func : in std_logic_vector(5 downto 0);
		Op : in std_logic_vector(5 downto 0);
		
		-- output
		operation : out std_logic_vector(3 downto 0);
		RegDst : out std_logic; 
		RegWrite : out std_logic;
		ALUSrcA : out std_logic;
		MemRead : out std_logic;
		MemWrite : out std_logic;
		MemtoReg :out std_logic;
		IorD : out std_logic;
		IRWrite :out std_logic;
		PCWrite : out std_logic;
		PCWriteCond : out std_logic;
		ALUSrcB : out std_logic_vector (1 downto 0);
		PCSource : out std_logic_vector (1 downto 0)
	);
end component;
--

-- internal signal
-- here
    signal IROut : std_logic_vector(31 downto 0);
	signal IRWrite , PCWriteCond , PCWrite 
	, IorD , MemtoReg , MemWrite , MemRead 
	, ALUSrcA , RegWrite , RegDst : std_logic;
	signal ALUSrcB , PCSource : std_logic_vector(1 downto 0);
	signal operation : std_logic_vector(3 downto 0);
	
--
begin
-- port map of register
	-- here
--

-- port map of dataflow
	-- here
--

-- port map of control unit
-- here
CTRL : ControlTop port map (CLK => CLK , reset => reset , Op => IROut(31 downto 26) , func => IROut(5 downto 0)
							,IRWrite => IRWrite , PCWriteCond => PCWriteCond , PCWrite => PCWrite
							,IorD => IorD , MemtoReg => MemtoReg , MemWrite => MemWrite , MemRead => MemRead
							,ALUSrcA => ALUSrcA , RegWrite => RegWrite , RegDst => RegDst , ALUSrcB => ALUSrcB
							,PCSource => PCSource , operation => operation);

--	
end behavior;
	