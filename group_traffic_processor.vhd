library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;

library work;
use work.elevator_constants.all;
 
entity group_traffic_processor is 
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
end entity group_traffic_processor;  

architecture behav of group_traffic_processor is 
	
begin  
	gtp_proc: process (call_serviced, up_call, down_call)
	begin  		
		report "Group Traffic Processor: process activated";
	end process;  
end behav;