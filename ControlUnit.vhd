library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
    port(
		-- Clock
		clk : in std_logic;

		-- Controls
		reset     : in std_logic;

		reg_a_en  : out std_logic;
		mux1_s    : out std_logic_vector (1 downto 0);
		mux2_s    : out std_logic;
		mux3_s    : out std_logic_vector(1 downto 0);
		mem_a_cs, mem_a_re, mem_a_wr : out std_logic;
		mem_b_cs, mem_b_re, mem_b_wr : out std_logic;
		CU_Cin    : out std_logic;
		counter_enable, counter_restart : out std_logic;
		enable_tw : out std_logic;
		
		-- Flags
		F_OverFlow   : in std_logic;
		F_UnderFlow  : in std_logic;
		F_tipwarning : in std_logic;
		F_TC         : in std_logic;

		start        : in std_logic;
		done         : out std_logic;
		F_ZC         : in std_logic
	);
end ControlUnit;

architecture behavior of ControlUnit is
    type State_type is (
						reset_state,
						Load,
						CalcFirst,
						start_TW_output,
						SUM_NE_OK,      -- somma senza costante correzione errore, dato ok
						SUM_NE_UF, 	    -- somma senza costante correzione errore, underflow del dato
						SUM_NE_OF, 	    -- somma senza costante correzione errore, underflow del dato
						SUM_E_OK, 	    -- somma con costante correzione errore, dato ok 
						SUM_E_UF, 	    -- somma con costante correzione errore, underflow del dato
						SUM_E_OF, 	    -- somma con costante correzione errore, underflow del dato
						Sum_2E,         -- somma 2 volte il dato in arrivo dalla memoria
						sub_1quarterE,  -- sottrae 1/4 del dato in arrivo alla memoria
						done_state
						);
	signal Present_State, Next_State : State_type;

    begin
    	process (Present_State, clk)
			begin
				reg_a_en 		 <= '0';
				mux1_s   		 <= "00";
				mux2_s   		 <= '0';
				mux3_s   		 <= "00";
				mem_a_cs 		 <= '0';
				mem_a_re 		 <= '0';
				mem_a_wr 		 <= '1';
				mem_b_cs 		 <= '0';
				mem_b_re 		 <= '0';
				mem_b_wr 		 <= '1';
				CU_Cin          <= '0';
				counter_enable  <= '0';
				counter_restart <= '0';
				enable_tw       <= '0';
				done            <= '0';
				
				Next_State <= reset_state;

				case Present_State is
					
					when reset_state => 
						counter_restart <= '1';
						
						if start = '1' then
							Next_State <= Load;
						else
							Next_State <= reset_state;
						end if;

					when Load =>
						counter_enable <= '1';
						mem_a_cs       <= '1';
						mem_a_wr       <= '0';
						
						if F_TC = '1' then
							Next_State <= CalcFirst;
						else
							Next_State <= Load;
						end if;


					when CalcFirst =>
						mem_a_cs <= '1';
						mem_a_re <= '1';
						mux1_s   <= "01";
						mux2_s   <= '1';
						cu_cin   <= '1';

						Next_State <= start_TW_output;


					when start_TW_output =>
						enable_tw 		<= '1';
						mem_a_cs  		<= '1';
						mem_a_re  		<= '1';
						mux1_s    	   <= "01";
						mux2_s     	   <= '1';
						cu_cin     		<= '1';
						counter_enable <= '1';
						reg_a_en 		<= '1';

						if F_tipwarning = '1' then
							if F_OverFlow = '1' then
								Next_State <= SUM_E_OF;
							elsif F_UnderFlow = '1' then
								Next_State <= SUM_E_UF;
							else
								Next_State <= SUM_E_OK;
							end if ;
						else 
							if F_OverFlow = '1' then
								Next_State <= SUM_NE_OF;
							elsif F_UnderFlow = '1' then
								Next_State <= SUM_NE_UF;
							else
								Next_State <= SUM_NE_OK;
							end if;
						end if;
						

					when SUM_E_OF =>
						mux3_s   <= "01";   -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';   -- parte per la lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s    <= "10";    

						if F_ZC = '1' then   
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;


					when SUM_E_UF =>
						mux3_s   <= "10";	  -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';	  --parte uguale per tutti sulla lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s    <= "10";   
					
						if F_ZC = '1' then		
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;


					when SUM_E_OK =>
						mux3_s   <= "00";   -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';   --parte uguale per tutti sulla lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s <= "10";     
					
						if F_ZC = '1' then		
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;


					when SUM_NE_OF =>
						mux3_s   <= "01";   -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';   --parte uguale per tutti sulla lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s    <= "11";      
					
						if F_ZC = '1' then		
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;


					when SUM_NE_UF =>
						mux3_s   <= "10";   -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';   --parte uguale per tutti sulla lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s <= "11";     

						if F_ZC = '1' then		
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;


					when SUM_NE_OK =>
						mux3_s   <= "00";   -- parte specifica sul salvataggio del dato
						mem_b_cs <= '1';	
						mem_b_wr <= '0';

						mem_a_cs  <= '1';   --parte uguale per tutti sulla lavorazione di e-1 per il prossimo
						mem_a_re  <= '1';
						mux2_s    <= '1';
						reg_a_en  <= '1';
						enable_tw <= '1';
						mux1_s    <= "11";    

						if F_ZC = '1' then
							Next_State <= done_state;
						else
							Next_State <= Sum_2E;
						end if ;
						

					when Sum_2E =>
						mem_a_cs  <= '1';	
						mem_a_re  <= '1';
						mux1_s    <= "00";
						mux2_s    <= '0';
						reg_a_en  <= '1';
						enable_tw <= '1';

						Next_State <= sub_1quarterE;


					when sub_1quarterE =>
						mem_a_cs  <= '1';	
						mem_a_re  <= '1';
						mux1_s    <= "01";
						mux2_s    <= '0';
						reg_a_en  <= '1';
						cu_cin    <= '1';
						enable_tw <= '1';

						counter_enable <= '1';
						
						if F_tipwarning = '1' then
							if F_OverFlow = '1' then
								Next_State <= SUM_E_OF;
							elsif F_UnderFlow = '1' then
								Next_State <= SUM_E_UF;
							else
								Next_State <= SUM_E_OK;
							end if ;
						else 
							if F_OverFlow = '1' then
								Next_State <= SUM_NE_OF;
							elsif F_UnderFlow = '1' then
								Next_State <= SUM_NE_UF;
							else
								Next_State <= SUM_NE_OK;
							end if;
						end if;
					
					
					when done_state =>
						done <= '1';
						if start = '1' then
							Next_State <= done_state;
						else
							Next_State <= reset_state;
						end if;


					when others =>
						Next_State <= reset_state;

				end case;
		end process;
		
		process (clk, reset) -- state flip-flops
			begin
				if (RESET = '0') then
					Present_State <= reset_state;
				elsif (clk' event AND clk = '1') then
					Present_State <= Next_State;
				end if;
		end process;

end architecture;