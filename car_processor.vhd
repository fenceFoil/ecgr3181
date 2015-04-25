library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
 
entity car_processor is 
	type motor_type is (stop, accel_up, hold_up, brake_up, accel_down, 
		hold_down, brake_down);
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
		motor			: out motor_type;
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
	type state_type is (state_idle, dir_up_state, dir_down_state, accel_state, 
		hold_state, brake_state, open_state, close_state);  

	signal state: state_type := state_idle; 
	
	-- state machine inputs not on the external port
	signal near_call, at_call, new_call, call_above, call_below : std_logic := '0';
	signal timer_accel, timer_door : std_logic := '0';
	
	-- state machine outputs not on the external port
	signal reset_timer : std_logic := 0;
	signal accel, hold, brake : std_logic := 0;
	signal remove_call : std_logic := 0;

begin  
	process (clk, fast_clk, reset)
	begin  
		-- timers
		if (clk = '1' and clk'event and timer_accel = '0')
			then timer_accel <= '1';
		end if;
		if (clk = '1' and clk'event and timer_door = '0')
			then timer_door <= '1';
			door_closed <= '1';
		end if;

		-- FSM Implementation
		if (reset = '1') then  
			state <= state_idle;
		elsif (clk = '1' and clk'event) then  
			case state is  
			when state_idle => -- idle
				reset_timer <= '0';
				accel <= '0';
				hold <= '0';
				brake <= '1';
				open_door <= '0';
				remove_call <= '0';
				direction_up <= '0';
				direction_down <= '0';
				if (new_call='1' and at_call='0' and call_above='1')
					then state <= dir_up_state;  -- set dir up
				elsif (new_call='1' and at_call='0' and call_below='1')
					then state <= dir_down_state; -- set dir down
				elsif ((new_call='1' and at_call='1') or open_button='1')
					then state <= open_state; -- open door  
				end if;  
			when dir_up_state =>  -- set dir up
				direction_up <= '1'; 
				reset_timer <= '1';
				state <= accel_state; -- accel
				timer_accel <='0';
			when dir_down_state =>  -- set dir down
				direction_down <= '1'; 
				reset_timer <= '1';
				state <= accel_state; -- accel
				timer_accel <='0';
			when accel_state =>  -- accel
				brake <= '0';
				accel <= '1';
				at_landing <= '0';
				if (timer_accel <='0')
					then state <= accel_state; -- accel
				else
					state <= hold_state; -- hold
					accel <= '0';
				end if;
			when hold_state => -- hold
				hold <= '1';
				if (near_call='0')
					then state <= hold_state; -- hold
				else 
					state <= brake_state; -- brake
					brake <= '1';
				end if;
			when brake_state => -- brake
				hold <= '0';
				brake <= '1';
				reset_timer <= '1';
				if (at_landing='0')
					then state <= brake_state; -- brake
				else
					state <= open_state; -- open door
				end if;
			when open_state => -- open door
				door_closed <='1';
				open_door <= '1';
				remove_call <= '1';
				if ((timer_door='0' or hold_button='1')and close_button='0')
					then state <= open_state; -- open door
				else state <= close_state; -- close door
				end if;
			when close_state => -- close door
				open_door <= '0';
				if (door_closed='0')
					then state <= close_state; -- close door
				elsif (at_call='1' or hold_button='1' or open_button='1')
					then state <= open_state; -- open door
				elsif (((direction_up='1' and call_above='1') or (direction_down='1' and call_below='0')) and (call_above='1' or call_below='1'))
					then state <= dir_up_state; -- set dir up
				elsif (((direction_down='1' and call_below='1') or (direction_up='1' and call_above='0')) and (call_above='1' or call_below='1'))
					then state <= dir_down_state;
				elsif (call_above='0' and call_below='0')
					then state <= state_idle;
				end if;
			end case;  
		end if;  
	end process;  
end behav;