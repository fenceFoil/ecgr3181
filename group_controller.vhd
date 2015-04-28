library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
 
entity group_controller is  
  port 
  (clk  : IN std_logic;
    dir_up_1  			       : in std_logic;   -- Tells whether the car is moving up (1) or not (0),(Bit operation)
		dir_down_1 		       : in std_logic;   -- Tells whether the car is moving down (1) or not (0), (Bit operation)
    position_1          : in integer;     -- Indicates the current floor location of the car (Number)
		call_serviced_1     : in std_logic;   -- Goes high when a call has been serviced (Bit operation)
    dir_up_2  			       : in std_logic;   -- Tells whether the car is moving up (1) or not (0),(Bit operation)
		dir_down_2 		       : in std_logic;   -- Tells whether the car is moving down (1) or not (0), (Bit operation)
    position_2          : in integer;     -- Indicates the current floor location of the car (Number)
		call_serviced_2     : in std_logic;   -- Goes high when a call has been serviced (Bit operation)

    landing_call      : in integer;     -- Goes high when a call has been received (Number)	
    up_call           : in std_logic;   -- Goes high when a call to go up has been received (Bit operation)
    down_call         : in std_logic;   -- Goes high when a call to go down has been received (Bit operation)
    
		landing_call_1    : out integer;
		landing_call_2    : out integer;
		new_landing_call_1 	: inout std_logic; -- Goes high when a call is assigned (bit operation)
		new_landing_call_2 	: inout std_logic; -- Goes high when a call is assigned (bit operation)
        
         
         send : out std_logic);
          -- the number of the elevator to send the request to
end entity;  




architecture behav of group_controller is 
  type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8);  
  signal state: state_type;
  signal reset_d_count, load_distance, timer, reset_c_count, ld_lowest : std_logic;
  signal d_count, distance, lowest, c_count, count : integer;
  signal elevator_1_location, elevator_2_location, request_location, distance_1, distance_2 : integer;
  signal send_elevator : integer;
begin  
  




  datapath : process (clk)
  begin
    
if (clk' event and clk = '1') then
	if (new_landing_call_1 = '1') then
		new_landing_call_1 <= '0';
	end if;
	if (new_landing_call_2 = '1') then
		new_landing_call_2 <= '0';
	end if;

	if (call_serviced_1 = '1') then
		landing_call_1 <= 0;
		new_landing_call_1 <= '0';
	elsif (call_serviced_2 = '1') then
		landing_call_2 <= 0;
		new_landing_call_1 <= '0';       
	end if;

  if (up_call = '1' or down_call = '1') then
    elevator_1_location <= position_1;
    elevator_2_location <= position_2;
    request_location <= landing_call;
 
    -- calculate distances
    distance_1 <= request_location - elevator_1_location;
    distance_2 <= request_location - elevator_2_location;
    
    -- compare distances for all elevators that are stationary
    if (distance_1 <= distance_2 and dir_up_1 = up_call and dir_down_1 = down_call) then
        landing_call_1 <= landing_call;
        new_landing_call_1 <= '1';
    elsif (distance_2 <= distance_1 and dir_up_2 = up_call and dir_down_2 = down_call) then
        landing_call_2 <= landing_call;
        new_landing_call_2 <= '1';    
    -- compare distances for all elevators going in the same direction
    elsif (distance_1 <= distance_2 and dir_up_1 = up_call) then
        landing_call_1 <= landing_call;
        new_landing_call_1 <= '1';    
    elsif (distance_2 <= distance_1 and dir_up_2 = up_call) then
        landing_call_2 <= landing_call;
        new_landing_call_2 <= '1';
    -- compare distances for all elevators going in the opposite direction
    elsif (distance_1 <= distance_2) then
        landing_call_1 <= landing_call;
        new_landing_call_1 <= '1';
    elsif (distance_2 <= distance_1) then
        landing_call_2 <= landing_call;
        new_landing_call_2 <= '1';
    end if;  
      
  end if; 
end if;
  end process;
  
end behav;
