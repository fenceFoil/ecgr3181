library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;
 
entity group_controller is  
  port 
  (clk  : IN std_logic;
         request : in std_logic;
         request_floor : in integer; -- floor the landing call is coming from
         request_direction : in std_logic; -- direction the landing call is to (up = 1)
         direction_elevator_1 : in std_logic; -- direction the elevator is going in
         direction_elevator_2 : in std_logic;
         floor_elevator_1 : in integer; -- floor the elevator is on
         floor_elevator_2 : in integer;
        
         send : out std_logic;
         elevator_number : out integer; -- the number of the elevator to send the request to
         send_floor : out integer);
end entity;  




architecture behav of group_controller is 
  type state_type is (s0,s1,s2,s3,s4,s5,s6,s7,s8);  
  signal state: state_type;
  signal reset_d_count, load_distance, timer, reset_c_count, ld_lowest : std_logic;
  signal d_count, distance, lowest, c_count, count : integer range 0 to 100;
  
begin  
  
  
  
  process (clk)
  
  begin  
    
  

    if (clk='1' and clk'event) then  
      case state is  
        when s0 => -- init/wait
            if (request = '0') then
                state <= s0;
            else state <= s1;
            end if;
        when s1 => -- distances not calculated
            reset_d_count <= '1';
            state <= s2;
        when s2 => -- calculate
            d_count <= d_count + 1;
            load_distance <= '1';
            if (d_count > 0)
                then state <= s3;
                load_distance <= '0';
            elsif (d_count = 0)
                then state <= s4;
                load_distance <= '0';
            end if;
        when s3 => -- delay calculation
            if (timer = '0')
                then state <= s3;
                timer <= '1';
            elsif (timer = '1')
                then state <= s2;
            end if;
        when s4 => -- distances not compared
            reset_c_count <= '1';
            state <= s5;
        when s5 => -- comparing
            if (distance > lowest)
                then state <= s5;
            elsif (distance <= lowest)
                then state <= s6;
                c_count <= 0;
            end if;
            if (c_count = 0)
                then state <= s7;
            end if;
        when s6 => -- is lower
            ld_lowest <= '1';
            state <= s5;
        when s7 => -- next elevator
            count <= count + 1;
            if (count > 0)
                then state <= s4;
            elsif (count = 0)
                then state <= s8;
            end if;
        when s8 => -- send request
            send <= '1';
            state <= s0;
      end case;  
    end if;  
  end process;  
end behav; 
