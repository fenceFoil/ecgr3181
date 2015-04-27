library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;

library work;
use work.elevator_constants.all;
 
entity gtp_testbench is
end gtp_testbench;
 
architecture behavior of gtp_testbench is
 
    -- Component Declaration for the Unit Under Test (UUT)
    component group_traffic_controller
	port (		
		landing_call	: in integer;
		up_call			: in std_logic;
		down_call		: in std_logic;
		car_dir_up		: in CAR_BUS_STD_LOGIC;
		car_dir_down	: in CAR_BUS_STD_LOGIC;
		car_pos			: in CAR_BUS_INTEGER;
		call_serviced	: in CAR_BUS_STD_LOGIC;
		
		assigned_calls	: out CAR_BUS_INTEGER;
		new_assignment	: out CAR_BUS_STD_LOGIC);
	end component;

	-- UUT Connections
			landing_call	: in integer;
		up_call			: in std_logic;
		down_call		: in std_logic;
		car_dir_up		: in CAR_BUS_STD_LOGIC;
		car_dir_down	: in CAR_BUS_STD_LOGIC;
		car_pos			: in CAR_BUS_INTEGER;
		call_serviced	: in CAR_BUS_STD_LOGIC;
		
		assigned_calls	: out CAR_BUS_INTEGER;
		new_assignment	: out CAR_BUS_STD_LOGIC);
	
begin
	-- Instantiate the Unit Under Test (UUT)
	uut: car_processor port map (
		clk => clk,
		fast_clk => fast_clk,
		reset => reset,
		hold_button => hold_button,
		open_button => open_button,
		close_button => close_button,
		door_closed => door_closed,
		at_landing => at_landing,
		near_landing => near_landing,
		pos_landing => pos_landing,
		new_landing_call => new_landing_call,
		landing_call => landing_call,
		new_car_call => new_car_call,
		car_call => car_call,
		open_door => open_door,
		motor => motor,
		serviced_call => serviced_call,
		curr_landing => curr_landing,
		direction_up => direction_up,
		direction_down => direction_down		
	);

	stim_proc: process 
	begin
		wait for 100  ns;
		
	end process;
end;
