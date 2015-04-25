library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
 
entity elevator_controller is  
  port ( clk  : IN std_logic;  
      reset : in std_logic;
      new_call : in std_logic;
      at_call : in std_logic;
     -- call_above : inout std_logic;
     -- call_below : inout std_logic;
     -- timer_accel : inout std_logic;
     -- near_call : inout std_logic;
      hold_button : in std_logic;
      open_button : in std_logic;
      close_button : in std_logic;
     -- timer_door : inout std_logic;
      direction_up : inout std_logic;
      direction_down : inout std_logic;
      
      reset_timer : out std_logic;
      accel : out std_logic;
      hold : inout std_logic; -- means the elevator is moving vertically
      remove_call : out std_logic);
      
    --  elevator_location : out integer;
     -- start : in integer);
      
end entity;  




architecture behav of elevator_controller is 
  type state_type is (s0,s1,s2,s3,s4,s5,s6,s7);  
  signal state: state_type;  
  signal location : integer range 0 to 200;
  signal request_floor : integer range 0 to 100;
  signal floor_sensors : integer range 0 to 300;
  signal timer_accel, timer_door, call_above, call_below, near_call, at_landing, brake, open_door, door_closed : std_logic:='0';-- stopping/starting movement signals to output to corresponding ports
begin  
  
  
  
  process (clk,reset)
  
  begin  
    
    
    
    --group controller 
    
    
    
    
    -- timers
    if (clk='1' and clk'event and timer_accel='0')
      then timer_accel <= '1';
    end if;
    if (clk='1' and clk'event and timer_door='0')
      then timer_door <= '1';
      door_closed <= '1';
    end if;
    
    
    
    -- moving the elevator
    if (clk='1' and clk'event and direction_up='1' and hold='1' and (floor_sensors mod 2 = 0) and brake='0')
      then location <= location+1;
    elsif(clk='1' and clk'event and direction_down='1' and hold='1' and (floor_sensors mod 2 = 0) and brake='0')
      then location <= location-1;
    end if;
    
    
    -- sensors
    if (clk='1' and clk'event and direction_up='1' and brake='0')
      then floor_sensors <= floor_sensors + 1;
    end if;
    if (clk='1' and clk'event and direction_down='1' and brake='0')
      then floor_sensors <= floor_sensors - 1;
    end if;
    
     -- call conditions for stopping/starting movement to destination 
    if (clk='1' and clk'event and new_call = '1' and location > request_floor - 1)
      then call_below <= '1';
    elsif (clk='1' and clk'event and new_call = '1' and location = request_floor - 1)
      then near_call <= '1';
      if (floor_sensors mod 2 = 0)
        then at_landing <= '1';
      end if;
    elsif (clk='1' and clk'event and new_call = '1' and location < request_floor - 1)
      then call_above <= '1';
    end if;
 
    
    if (reset ='1') then  
      state <=s0;
    elsif (clk='1' and clk'event) then  
      case state is  
        when s0 => -- idle
                   reset_timer <= '0';
                   accel <= '0';
                   hold <= '0';
                   brake <= '1';
                   open_door <= '0';
                   remove_call <= '0';
                   direction_up <= '0';
                   direction_down <= '0';
                   if (new_call='1' and at_call='0' and call_above='1')
                     then state <= s1;  -- set dir up
                   elsif (new_call='1' and at_call='0' and call_below='1')
                     then state <= s2; -- set dir down
                   elsif ((new_call='1' and at_call='1') or open_button='1')
                     then state <= s6; -- open door  
                   end if;  
        when s1 =>  -- set dir up
                   direction_up <= '1'; 
                   reset_timer <= '1';
                   state <= s3; -- accel
                   timer_accel <='0';
        when s2 =>  -- set dir down
                   direction_down <= '1'; 
                   reset_timer <= '1';
                   state <= s3; -- accel
                   timer_accel <='0';
        when s3 =>  -- accel
                   brake <= '0';
                   accel <= '1';
                   at_landing <= '0';
                   if (timer_accel <='0')
                     then state <= s3; -- accel
                   else
                     state <= s4; -- hold
                     accel <= '0';
                   end if;
        when s4 => -- hold
                   hold <= '1';
                   if (near_call='0')
                     then state <= s4; -- hold
                   else 
                     state <= s5; -- brake
                     brake <= '1';
                   end if;
        when s5 => -- brake
                   hold <= '0';
                   brake <= '1';
                   reset_timer <= '1';
                   if (at_landing='0')
                     then state <= s5; -- brake
                   else state <= s6; -- open door
                   end if;
        when s6 => -- open door
                   door_closed <='1';
                   open_door <= '1';
                   remove_call <= '1';
                   if ((timer_door='0' or hold_button='1')and close_button='0')
                     then state <= s6; -- open door
                   else state <= s7; -- close door
                   end if;
        when s7 => -- close door
                    
                   open_door <= '0';
                   if (door_closed='0')
                     then state <= s7; -- close door
                   elsif (at_call='1' or hold_button='1' or open_button='1')
                     then state <= s6; -- open door
                   elsif (((direction_up='1' and call_above='1') or (direction_down='1' and call_below='0')) and (call_above='1' or call_below='1'))
                     then state <= s1; -- set dir up
                   elsif (((direction_down='1' and call_below='1') or (direction_up='1' and call_above='0')) and (call_above='1' or call_below='1'))
                     then state <= s2;
                   elsif (call_above='0' and call_below='0')
                     then state <= s0;
                   end if;
      end case;  
    end if;  
  end process;  
end behav;