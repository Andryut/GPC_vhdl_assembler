library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity GPC_Hvd_a is
    GENERIC(N:integer:=4);
    Port ( clk      : in  STD_LOGIC;
           rst      : in  STD_LOGIC;
			  enter	  : in  STD_LOGIC;
           Din		  : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  Dout	  : out  STD_LOGIC_VECTOR (N-1 downto 0);
           inFlags  : out  STD_LOGIC_VECTOR (7 downto 0);
           outFlags : out  STD_LOGIC_VECTOR (7 downto 0);
			  done     :out STD_LOGIC);          
end GPC_Hvd_a;

architecture Behavioral of GPC_Hvd_a is

signal IR:unsigned (11 downto 0);
signal PC:unsigned (5 downto 0);
signal A:signed (N-1 downto 0);

signal aux_inFlags:unsigned (7 downto 0);
signal aux_outFlags:unsigned (7 downto 0);

type state_t is(fetch,decode,loadA,storeA,addA,subA,inA,outA,jpos,jneg,jz,jnz,jmp,halt);
signal state:state_t;
type rom_mem_type is array (natural range 0 to 63) of std_logic_vector (11 downto 0); --program memeory
signal ROM : rom_mem_type:=
(
--your_program_comes_here
others => x"000"
);
		
type ram_mem_type is array (natural range 0 to 63) of std_logic_vector (N-1 downto 0); --ram memeory
signal RAM : ram_mem_type:=
(
--your_variable_initializations_comes_here
others => X"0"
);

begin
                          
	process(clk,rst)
   begin
		if rst='1'then
			state<=fetch;
			PC<="000000";
			A<=(others=>'0');			 
			Dout<=(others=>'0');  
      inFlags <=(others=>'0');			
			aux_inFlags <="00000001";
			outFlags <=(others=>'0');
			aux_outFlags <="00000001";			
			done<='0';
		elsif rising_edge(clk) then
			case state is
				--fetch
				when fetch => 
					IR<=unsigned(ROM(to_integer(PC)));
					PC<=PC+1;
					state <= decode;
				--decode
				when decode => 
					CASE IR(11 DOWNTO 8) IS -- decode first 8 bits of IR as opcode and memory addressing
						WHEN X"0" => state <= loadA;
						WHEN X"1" => state <= storeA;
						WHEN X"2" => state <= addA;
						WHEN X"3" => state <= subA;
						WHEN X"4" => state <= inA;
						WHEN X"5" => state <= outA;
						WHEN X"6" => state <= jpos;
						WHEN X"7" => state <= jneg;
						WHEN X"8" => state <= jz;
						WHEN X"9" => state <= jnz;
						WHEN X"A" => state <= jmp;
						WHEN X"B" => state <= halt;
						WHEN OTHERS => NULL;
					END CASE;	
				--execute:
				--loadA
				when loadA => 
					A<=signed(RAM(to_integer(IR(5 downto 0))));
					state<=fetch;			
				--storeA	
				when storeA => 
					RAM(to_integer(IR(5 downto 0)))<=std_logic_vector(A);
					state<=fetch;
        --addA	
        when addA => 				
					A<=A+signed(RAM(to_integer(IR(5 downto 0))));
					state<=fetch;
				--subA
				when subA => 
					A<=A-signed(RAM(to_integer(IR(5 downto 0))));
					state<=fetch;
				--inA
				when inA => 
				  inFlags<=std_logic_vector(aux_inFlags);
				  if enter = '1' then 
						A<=signed(Din);
					  inFlags<=(others=>'0');
					  aux_inFlags<=SHIFT_LEFT (aux_inFlags,1);
					  state<=fetch;
					end if;										
				--outA
				when outA =>
          outFlags<=std_logic_vector(aux_outFlags);				
					Dout <= std_logic_vector(A);
					if enter = '1' then 
					  outFlags<=(others=>'0');
						Dout <=(others => '0');
						aux_outFlags<=SHIFT_LEFT (aux_outFlags,1);					
						state<=fetch;
					end if;					
				--jpos	
				when jpos =>	
					if A>0 then 
						PC<=IR(5 downto 0);
					end if;	
					state<=fetch;
				--jneg		
				when jneg =>	
					if A<0 then 
						PC<=IR(5 downto 0);
					end if;	
					state<=fetch;						
				--jz	
				when jz =>	
					if A=0 then 
						PC<=IR(5 downto 0);
					end if;	
					state<=fetch;
				--jnz	
				when jnz =>	
					if A/=0 then 
						PC<=IR(5 downto 0);
					end if;	
					state<=fetch;
				--jmp
				when jmp =>
					PC<=IR(5 downto 0);
					state<=fetch;
	      --halt
				when halt =>
					done<='1';
				when others => NULL;
			end case;
		end if;
	end process;
end Behavioral;



