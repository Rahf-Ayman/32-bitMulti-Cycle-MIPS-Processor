-- Project: MIPS32 multi-cycle
-- Module:  Control unit
-- all op : lw , sw , Rtype , beq , jump , addi , ORi , andi


library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is 
	port(
	-- input port
	CLK : in std_logic;
	reset : in std_logic;
	Op : in std_logic_vector(5 downto 0);
	
	-- output port
	RegDst : out std_logic; -- two modes assert & deassert
	RegWrite : out std_logic;
	ALUSrcA : out std_logic;
	MemRead : out std_logic;
	MemWrite : out std_logic;
	MemtoReg :out std_logic;
	IorD : out std_logic;
	IRWrite :out std_logic;
	PCWrite : out std_logic;
	PCWriteCond : out std_logic;
	
	ALUOp : out std_logic_vector(1 downto 0);
	ALUSrcB : out std_logic_vector (1 downto 0);
	PCSource : out std_logic_vector (1 downto 0)
	
	);
	
end ControlUnit;

architecture behavior of ControlUnit is

  type state is(  InstructionFetch, --
                  InstructionDecode, --
                  MemoryAddressComp, --
                  MemoryAccessLoad, --
                  MemoryAccessStore,--
                  Execution,	--
                  Execution_ADDI,
                  Execution_ANDI,
                  BranchCompletion, --
                  JumpCompletion, --
                  RTypeCompletion, --
                  WriteBack_I,
                  MemoryReadCompletionStep --
			);

signal current_state, next_state : state;
signal ctrl_out : std_logic_vector(15 downto 0) := (others => '0');				 

begin
	
CTRL_U : process(CLK, Reset, Op)
  begin
    if Reset = '0' then
      current_state <= InstructionFetch;
    elsif rising_edge(CLK) then
      current_state <= next_state;
    end if;

    case current_state is

      when InstructionFetch  => next_state <= InstructionDecode;

      when InstructionDecode => if Op = "100011" then -- lw
                                  next_state <= MemoryAddressComp;
                                elsif Op = "101011" then -- sw
                                  next_state <= MemoryAddressComp;
                                elsif Op = "000000" then -- R-type
                                  next_state <= Execution;
                                elsif Op = "001000" then -- addimmediate
                                  next_state <= Execution_ADDI;
								                elsif Op = "001100" then -- andimmediate
                                  next_state <= Execution_ANDI;
								                elsif Op = "001101" then -- orimmediate
                                  next_state <= Execution_ANDI;  
                                elsif Op = "000100" then -- BEQ
                                  next_state <= BranchCompletion;
                                elsif Op = "000010" then -- Jump
                                  next_state <= JumpCompletion;
                                end if;

      when MemoryAddressComp => if Op = "100011" then -- lw
                                  next_state <= MemoryAccessLoad;
                                else  -- sw
                                  next_state <= MemoryAccessStore;
                                end if;

      when Execution         => next_state <= RTypeCompletion;

      when Execution_ADDI       => next_state <= WriteBack_I;
	  
	    when Execution_ANDI       => next_state <= WriteBack_I;
	  
      when MemoryAccessLoad  => next_state <= MemoryReadCompletionStep;

      when others            => next_state <= InstructionFetch;

    end case;

  end process CTRL_U;
  
with current_state select
    ctrl_out <= "1001001000001000" when InstructionFetch, --
	              "0000000000011000" when InstructionDecode, --
	              "0000000000010100" when MemoryAddressComp, -- 
	              "0000000001000100" when Execution,--
	              "0000000000010100" when Execution_ADDI, 
				        "0000000001110100" when Execution_ANDI, -- andi , ori
				        "0100000010100100" when BranchCompletion, --
	              "1000000100000000" when JumpCompletion,--
	              "0011000000000000" when MemoryAccessLoad,	-- read
	              "0010100000000000" when MemoryAccessStore,-- write
	              "0000000000000011" when RTypeCompletion, -- write back destinatin (rd)
	              "0000000000000010" when WriteBack_I, -- destination (rt)
	              "0000010000000010" when MemoryReadCompletionStep, --
	              "0000000000000000" when others;

	
PCWrite     <= ctrl_out(15);
PCWriteCond <= ctrl_out(14);
IorD        <= ctrl_out(13);
MemRead     <= ctrl_out(12);
MemWrite    <= ctrl_out(11);
MemToReg    <= ctrl_out(10);
IRWrite     <= ctrl_out(9);
PCSource    <= ctrl_out(8 downto 7);
ALUOp       <= ctrl_out(6 downto 5);
ALUSrcB     <= ctrl_out(4 downto 3);
ALUSrcA     <= ctrl_out(2);
RegWrite    <= ctrl_out(1);
RegDst      <= ctrl_out(0);

end behavior;