library IEEE;  
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all;

package elevator_constants is
	constant NUM_LANDINGS : integer := 4;
	constant NUM_CARS : integer := 2;
	
	type CAR_BUS_INTEGER is array (NUM_CARS-1 downto 0) of integer;
	type CAR_BUS_STD_LOGIC is array (NUM_CARS-1 downto 0) of std_logic;
end elevator_constants;

package body elevator_constants is
end elevator_constants;