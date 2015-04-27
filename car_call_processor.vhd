library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;

entity car_call_processor is
	port (
		car_clk : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic; 				-- used?
		new_car_call : IN std_logic; 
		remove_call : IN std_logic;
		car_call : IN integer;
		pos_landing : IN integer;
		
		call_above : OUT std_logic;
		call_below : OUT std_logic;
		call_at_pos: OUT std_logic);
end entity; 

architecture behav of car_call_processor is
	constant NUM_LANDINGS : integer := 4;
	type state_type is (wait_falling_state, add_call_state, remove_call_state, 
		loop_landings_state, no_call_state, at_call_state, call_above_state, 
		call_below_state, wait_rising_state);
	signal state: state_type := wait_falling_state;
	signal requests: std_logic_vector (NUM_LANDINGS-1 downto 0);
	signal call_above_temp, call_below_temp, call_at_pos_temp : std_logic := '0';
	signal i : integer := 0;
begin
	car_call_proc: process (clk, reset)
	begin
		if (reset = '1') then
			state <= wait_falling_state;
			requests <= (others => '0');
		else -- not a reset
			if (clk = '1' and clk'event) then
				-- calculate new state
				case state is
					when wait_falling_state =>
						call_below_temp <= '0';
						call_above_temp <= '0';
						call_at_pos_temp <= '0';
						i <= 0;
						
						if (car_clk = '0') then
							if (new_car_call = '1') then
								state <= add_call_state;
							elsif (remove_call = '1') then
								state <= remove_call_state;
							else
								state <= loop_landings_state;
							end if;
						end if;
						
					when add_call_state =>
						requests(car_call) <= '1';
						
						if (remove_call  = '1') then
							state <= remove_call_state;
						else 
							state <= loop_landings_state;
						end if;
						
					when remove_call_state =>
						requests(pos_landing) <= '0';	
						state <= loop_landings_state;
						
					when loop_landings_state =>
						if (i < NUM_LANDINGS) then
							if (requests(i) = '1') then
								if (i < pos_landing) then
									state <= call_below_state;
								elsif (i > pos_landing) then
									state <= call_above_state;
								else -- i = pos_landing
									state <= at_call_state;
								end if;
							else
								state <= no_call_state;
							end if;
						else
							state <= wait_rising_state;
						end if;
						
					when no_call_state =>
						i <= i + 1;
						state <= loop_landings_state;
						
					when at_call_state =>
						i <= i + 1;
						call_at_pos_temp <= '1';
						state <= loop_landings_state;
						
					when call_above_state =>
						i <= i + 1;
						call_above_temp <= '1';
						state <= loop_landings_state;
					
					when call_below_state =>
						i <= i + 1;
						call_below_temp <= '1';
						state <= loop_landings_state;
						
					when wait_rising_state =>
						call_below <= call_below_temp;
						call_above <= call_above_temp;
						call_at_pos <= call_at_pos_temp;
						
						if (car_clk = '1') then
							state <= wait_falling_state;
						end if;
				end case;
			end if; -- clk edge
		end if; -- not a reset
	end process;
end behav;
