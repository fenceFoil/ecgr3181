library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
 
--type motor_type is (stop, accel_up, hold_up, brake_up, accel_down, hold_down, brake_down);

-- note: clock is assumed to have a period of 100 ns, freq = 10 mhz
-- fast_clock is assumed to have a period of 1 ns, freq = 1 ghz
-- Not realistic, but look good on the default waveform zoon
 
entity car_processor is 
	port ( 
		clk  			: in std_logic;
		fast_clk 		: in std_logic;	-- used for the car_call_processor
		reset 			: in std_logic;
		hold_button 	: in std_logic;
		open_button 	: in std_logic;
		close_button 	: in std_logic;
		door_closed		: in std_logic;
		at_landing 		: in std_logic;
		near_landing	: in std_logic;
		pos_landing		: in integer;
		new_landing_call: in std_logic;
		landing_call	: in integer;
		new_car_call	: in std_logic;
		car_call		: in integer;
		
		open_door		: out std_logic;
		motor			: out integer;
		serviced_call	: out std_logic;
		-- on some papers, these two are represented with a 2 bit number. 
		-- Using two individual bits performs the same function; IDLE = both 0
		--dir_up_out		: out std_logic; 
		--dir_down_out	: out std_logic;
		curr_landing	: out integer;
		
		direction_up 	: out std_logic;
		direction_down 	: out std_logic);
end entity;  

architecture behav of car_processor is 
	type state_type is (idle_state, dir_up_state, dir_down_state, accel_state, 
		hold_state, brake_state, open_state, close_state);

	signal state : state_type := idle_state; 
	
	-- direction registers
	signal dir_up, dir_down : std_logic := '0';
	
	-- state machine inputs not on the external port
	signal near_call, at_call, new_call, call_above, call_below : std_logic := '0';
	signal timer_accel, timer_door : std_logic := '0';
	
	-- state machine outputs not on the external port
	signal reset_timer 				: std_logic := '0';
	signal accel, hold, brake 		: std_logic := '0';
	signal remove_call 				: std_logic := '0';
	
	-- timer counter
	signal timer_counter			: integer := 0;

begin  
	process (clk, fast_clk, reset)
	begin  
		-- Datapath Implementation
		if (clk = '1' and clk'event) then
		
			-- From paper: Car Processor Timer
			timer_counter <= timer_counter + 1;
			if (reset_timer = '1') then
				timer_counter <= 0;
			end if;
			-- 3 second timer; 10 mhz * 3 seconds = 30000000 cycles
			if (timer_counter > 30000000) then
				timer_accel <= '1';
			else 
				timer_accel <= '0';
			end if;
			-- 8 second timer; 80000000 cycles
			if (timer_counter > 80000000) then
				timer_door <= '1';
			else
				timer_door <= '0';
			end if;
			
			-- new_call or gate
			new_call <= (new_landing_call or new_car_call);
			
			-- From papers: Direction Registers is redundant in this VHDL
			
			-- From papers: Motor Direction Selector
			if (dir_up = dir_down) then
				-- if dir_up and dir_down are zero, elevator is not moving, and should brake;
				-- if dir_up and dir_down are one, that cannot happen
				motor <= 0;
			elsif (dir_down = '1') then
				if (hold = '1') then
					motor <= 1;
				elsif (accel = '1') then
					motor <= 2;
				elsif (brake = '1') then
					motor <= 3;
				else
					motor <= 0;
				end if;
			elsif (dir_up = '1') then
				if (hold = '1') then
					motor <= 4;
				elsif (accel = '1') then
					motor <= 5;
				elsif (brake = '1') then
					motor <= 6;
				else
					motor <= 0;
				end if;
			end if;
			
			
		end if;

		-- FSM Implementation
		if (reset = '1') then  
			state <= idle_state;
			
			-- reset FSM outputs to zero
			open_door <= '0';
			brake <= '0';
			hold <= '0';
			accel <= '0';
			reset_timer <= '0';
			remove_call <= '0';
			
			-- reset registers on reset
			dir_up <= '0';
			dir_down <= '0';
		elsif (clk = '1' and clk'event) then  
			case state is  
			when idle_state =>
				-- Thoroughly reset all FSM outputs in this idle state
				open_door <= '0';
				brake <= '0';
				hold <= '0';
				accel <= '0';
				reset_timer <= '0';
				remove_call <= '0';
				
				dir_up <= '0';
				dir_down <= '0';
				
				-- Decide next state
				if (open_button = '1' or (new_call = '1' and at_call = '1')) then
					state <= open_state;
				elsif (new_call = '1' and at_call = '0' and call_above = '1') then
					state <= dir_up_state;
				elsif (new_call = '1' and at_call = '0' and call_below = '1') then
					state <= dir_down_state;
				end if;
			when dir_up_state =>
				dir_up <= '1'; 
				reset_timer <= '1';
				
				state <= accel_state;
			when dir_down_state =>
				dir_down <= '1'; 
				reset_timer <= '1';
				
				state <= accel_state;
			when accel_state =>
				-- Undo signal changes from dir_???_state
				reset_timer <= '0';
				-- Set signals for this state
				accel <= '1';
				
				-- Decide next state
				if (timer_accel = '1') then 
					state <= hold_state;
				end if;
			when hold_state =>
				-- Undo signal changes from accel_state
				accel <= '0';
				-- Set signals for this state
				hold <= '1';
				
				-- Decide next state
				if (near_call = '1') then
					state <= brake_state;
				end if;
			when brake_state =>
				-- Undo signal changes from hold_state
				hold <= '0';
				-- Set signals for this state
				brake <= '1';
				reset_timer <= '1';
				
				-- Decide next state
				if (at_landing = '1') then
					state <= open_state;
				end if;
			when open_state =>
				-- Undo signal changes from idle_state, brake_state, close_state
				brake <= '0';
				reset_timer <= '0';
				-- Set signals for this state
				open_door <= '1';
				remove_call <= '1';
				
				-- Decide next state
				if ((timer_door = '0' or hold_button = '1') and close_button = '0') then
					state <= open_state; -- remain in current state
				else 
					state <= close_state;
				end if;
			when close_state =>
				-- Undo signal changes from open_door
				open_door <= '0';
				remove_call <= '0';
				-- Set signals for this state
				-- n/a
				
				-- Decide next state
				if (door_closed='0') then
					state <= close_state; -- remain in current state
				elsif (at_call = '1' or hold_button = '1' or open_button = '1') then
					state <= open_state;
				elsif (((dir_up = '1' and call_above = '1') or (dir_down = '1' and call_below = '0')) 
					and (call_above = '1' or call_below = '1')) then
					state <= dir_up_state;
				elsif (((dir_down = '1' and call_below = '1') or (dir_up = '1' and call_above = '0')) 
					and (call_above = '1' or call_below = '1')) then
					state <= dir_down_state;
				elsif (call_above = '0' and call_below = '0') then
					state <= idle_state;
				end if;
			end case;  
		end if;  
	end process;  
end behav;