-- Project: MIPS32 multi-cycle
-- Module:  Control unit
-- all instructions : lw , sw , Rtype , beq , jump , addi , ORi , andi
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

type state is(   InstructionFetch,
                InstructionDecode,
                MemoryAddressComp,
                MemoryAccessLoad,
                MemoryAccessStore,
                Execution,
                Execution_ADDI,
                Execution_ANDI,
                BranchCompletion,
                JumpCompletion,
                RTypeCompletion,
                WriteBack_I,
                MemoryReadCompletionStep,
				DumpState
      );

signal current_state, next_state : state := DumpState ;
begin
process(CLK, Reset)
begin
    if Reset = '1' then
        current_state <= DumpState;
    elsif rising_edge(CLK) then
        current_state <= next_state;
    end if;
end process;	
  
process(current_state, Op)
begin
    -- Default values
    PCWrite     <= '0';
    PCWriteCond <= '0';
    IorD        <= '0';
    MemRead     <= '0';
    MemWrite    <= '0';
    MemtoReg    <= '0';
    IRWrite     <= '0';
    PCSource    <= "00";
    ALUOp       <= "00";
    ALUSrcB     <= "00";
    ALUSrcA     <= '0';
    RegWrite    <= '0';
    RegDst      <= '0';

    case current_state is
    when InstructionFetch  => 
      	PCWrite  <= '1';
      MemRead  <= '1';
      IRWrite  <= '1';
      ALUSrcB  <= "01";
      
      next_state <= InstructionDecode;

      when InstructionDecode => 
        ALUSrcB  <= "11";		     
    
      if Op = "100011" then -- lw
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

    when MemoryAddressComp => -- (cycle 3 lw) (cycle 3 sw)
      ALUSrcA  <= '1';
      ALUSrcB  <= "10";
    
      if Op = "100011" then -- lw
          next_state <= MemoryAccessLoad;
        else  -- sw
          next_state <= MemoryAccessStore;
        end if;

    when Execution         => -- (cycle 3 R)
      ALUSrcA  <= '1';
      ALUOp    <= "10";
      
      next_state <= RTypeCompletion;

    when Execution_ADDI       => 	-- (cycle 3 addi)
      ALUSrcA  <= '1';
      ALUSrcB  <= "10";
      
      next_state <= WriteBack_I;
    
  when Execution_ANDI       => -- (cycle 3 andi) (cycle 3 ori)
      ALUSrcA  <= '1';
      ALUSrcB  <= "10";
      ALUOp    <= "11";
      next_state <= WriteBack_I;
    
    when MemoryAccessLoad  => -- (cycle 4 lw)	(read)
      MemRead <= '1';
      IorD    <= '1';
      
      next_state <= MemoryReadCompletionStep;

    when BranchCompletion  => -- (cycle 3 beq)
      ALUSrcA     <= '1';
      ALUOp       <= "01";
      PCWriteCond <= '1';
      PCSource    <= "01";
      
      next_state <= InstructionFetch;
  
  when JumpCompletion  => -- (cycle 3 j)
      PCWrite     <= '1';
      PCSource    <= "10";
      
      next_state <= InstructionFetch;	  
    
  when RTypeCompletion  => -- (cycle 4 R) (write back destination (rd))
      RegDst   <= '1';
      RegWrite <= '1';
      
      next_state <= InstructionFetch;
  
  when WriteBack_I  => -- (cycle 4 addi) (cycle 4 andi) (cycle 4 ori) (destination (rt))
      RegWrite <= '1';
      
      next_state <= InstructionFetch;
    
  when MemoryReadCompletionStep  => -- (cycle 5 lw)
      RegWrite <= '1';
      MemtoReg <= '1';
      
      next_state <= InstructionFetch;
  
    when MemoryAccessStore  => -- (cycle 4 sw) (write)
      MemWrite <= '1';
      IorD     <= '1';
      
      next_state <= InstructionFetch;	  
  
    when others =>
      next_state <= InstructionFetch;	
    end case;
end process;
  
  
end behavior;