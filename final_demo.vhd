library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity final_demo_testbench is
end final_demo_testbench;
 
architecture behavior of final_demo_testbench is
 
    component car_processor
	port ( 
		clk  			: in std_logic;
		fast_clk 		: in std_logic;	
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
		curr_landing	: out integer;
		
		direction_up 	: out std_logic;
		direction_down 	: out std_logic);
	end component;
	
	component group_controller
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
    end component;
	
	-- UUT connections
	-- Inputs
	signal clk : std_logic := '0';
	signal fast_clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal hold_button : std_logic := '0';
	signal open_button : std_logic := '0';
	signal close_button : std_logic := '0';
	
	-- Duplicated for each car
		
	signal door_closed_1, door_closed_2 : std_logic := '0';
	signal at_landing_1, at_landing_2 : std_logic := '0';
	signal near_landing_1, near_landing_2 : std_logic := '0';
	signal pos_landing_1 : integer := 1;
	signal pos_landing_2 : integer := 4;
	signal new_landing_call_1, new_landing_call_2 : std_logic := '0';
	signal landing_call_1, landing_call_2 : integer := 0;
	signal new_car_call_1, new_car_call_2 : std_logic := '0';
	signal car_call_1, car_call_2 : integer := 0;
	signal open_door_1, open_door_2 : std_logic := '0';
	signal motor_1, motor_2 : integer := 0;
	signal serviced_call_1, serviced_call_2 : std_logic := '0';
	signal curr_landing_1, curr_landing_2 : integer := 0;
	signal direction_up_1, direction_up_2 : std_logic := '0';
	signal direction_down_1, direction_down_2 : std_logic := '0';
	
	signal go_nowhere : std_logic := '0';

	signal tb_landing_call : integer := 0;
	signal tb_new_up_call, tb_new_down_call : std_logic := '0';
	
	-- Clock constants
	constant CLK_PERIOD : time := 100 ns;
	constant FAST_CLK_PERIOD: time := 1 ns;	
	
begin
	-- Instantiate the Unit Under Test (UUT)
	car1: car_processor port map (
		clk => clk,
		fast_clk => fast_clk,
		reset => reset,
		hold_button => hold_button,
		open_button => open_button,
		close_button => close_button,
		
		door_closed => door_closed_1,
		at_landing => at_landing_1,
		near_landing => near_landing_1,
		pos_landing => pos_landing_1,
		new_landing_call => new_landing_call_1,
		landing_call => landing_call_1,
		new_car_call => new_car_call_1,
		car_call => car_call_1,
		open_door => open_door_1,
		motor => motor_1,
		serviced_call => serviced_call_1,
		curr_landing => curr_landing_1,
		direction_up => direction_up_1,
		direction_down => direction_down_1		
	);
	
	car2: car_processor port map (
		clk => clk,
		fast_clk => fast_clk,
		reset => reset,
		hold_button => hold_button,
		open_button => open_button,
		close_button => close_button,
		
		door_closed => door_closed_2,
		at_landing => at_landing_2,
		near_landing => near_landing_2,
		pos_landing => pos_landing_2,
		new_landing_call => new_landing_call_2,
		landing_call => landing_call_2,
		new_car_call => new_car_call_2,
		car_call => car_call_2,
		open_door => open_door_2,
		motor => motor_2,
		serviced_call => serviced_call_2,
		curr_landing => curr_landing_2,
		direction_up => direction_up_2,
		direction_down => direction_down_2		
	);
	
	gtc: group_controller port map (
		clk => clk,
		
		dir_up_1 => direction_up_1,
		dir_down_1 => direction_down_1,
		position_1 => curr_landing_1,
		call_serviced_1 => serviced_call_1,
		
		dir_up_2 => direction_up_2,
		dir_down_2 => direction_down_2,
		position_2 => curr_landing_2,
		call_serviced_2 => serviced_call_2,
		
		landing_call => tb_landing_call,
		up_call => tb_new_up_call,
		down_call => tb_new_down_call,
		
		landing_call_1 => landing_call_1,
		landing_call_2 => landing_call_2,
		new_landing_call_1 => new_landing_call_1,
		new_landing_call_2 => new_landing_call_2,
		
		send => go_nowhere
	);

	-- Mock: Clocks
	clk_proc: process
	begin
		clk <= '1';
		wait for CLK_PERIOD / 2;
		clk <= '0';
		wait for CLK_PERIOD / 2;
	end process;
	fast_clk_proc: process
	begin
		fast_clk <= '1';
		wait for FAST_CLK_PERIOD / 2;
		fast_clk <= '0';
		wait for FAST_CLK_PERIOD / 2;
	end process;
	
	-- Mock: Doors
	mock_doors_1: process (clk)
		variable door_lag : integer := 0;
	begin
		-- if (clk = '1' and clk'event) then
			-- if (open_door_1 = '1') then
				-- door_closed_1 <= '0';
			-- end if;
			
			-- if (open_door_1 = '0' and door_lag > 3) then
				-- door_closed_1 <= '1';
			-- elsif (open_door_1 = '0' and open_door_1'event) then
				-- door_lag := 0;
			-- elsif (open_door_1 = '0') then
				-- door_lag := door_lag + 1;
			-- end if;
		-- end if;
	
		door_closed_1 <= not open_door_1;
	end process;
	
	mock_doors_2: process (open_door_2)
	begin
		door_closed_2 <= not open_door_2;
	end process;
	
	-- Mock: Motor and Position Sensors
	mock_motor_1: process (clk)
		variable motor_lag : integer := 0;
	begin
		if (motor_1'event or (clk'event and clk = '1')) then
			-- acceleration
			if (motor_1 = 2 or motor_1 = 5) then
				at_landing_1 <= '0';
				near_landing_1 <= '0';
			end if;
			-- holding (and floor number change)
			if (motor_1 = 1) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing_1 <= pos_landing_1 - 1;
					motor_lag := 0;
				end if;
				
				at_landing_1 <= '0';
				near_landing_1 <= '1';
			end if;
			if (motor_1 = 4) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing_1 <= pos_landing_1 + 1;
					motor_lag := 0;
				end if;
				
				at_landing_1 <= '0';
				near_landing_1 <= '1';
			end if;
			-- braking
			if (motor_1 = 3 or motor_1 = 6) then
				at_landing_1 <= '1';
				near_landing_1 <= '0';
			end if;
			-- stopped
			if (motor_1 = 0) then
				at_landing_1 <= '1';
				near_landing_1 <= '0';
			end if;
			
			if (motor_1 < 0 or motor_1 > 6) then
				report "MOTOR _1 VALUE INVALID";
			end if;
		end if;
	end process;
	
	mock_motor_2: process (clk)
		variable motor_lag : integer := 0;
	begin
		if (motor_2'event or (clk'event and clk = '1')) then
			-- acceleration
			if (motor_2 = 2 or motor_2 = 5) then
				at_landing_2 <= '0';
				near_landing_2 <= '0';
			end if;
			-- holding (and floor number change)
			if (motor_2 = 1) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing_2 <= pos_landing_2 - 1;
					motor_lag := 0;
				end if;
				
				at_landing_2 <= '0';
				near_landing_2 <= '1';
			end if;
			if (motor_2 = 4) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing_2 <= pos_landing_2 + 1;
					motor_lag := 0;
				end if;
				
				at_landing_2 <= '0';
				near_landing_2 <= '1';
			end if;
			-- braking
			if (motor_2 = 3 or motor_2 = 6) then
				at_landing_2 <= '1';
				near_landing_2 <= '0';
			end if;
			-- stopped
			if (motor_2 = 0) then
				at_landing_2 <= '1';
				near_landing_2 <= '0';
			end if;
			
			if (motor_2 < 0 or motor_2 > 6) then
				report "MOTOR _2 VALUE INVALID";
			end if;
		end if;
	end process;

	-- Stimulus process
	stim_proc: process
	begin		
		-- Setup
		close_button <= '1';
		
		report "Starting test 1";
		report "Registering landing call: Up 2";
		tb_landing_call <= 2;
		tb_new_up_call <= '1';
		wait for CLK_PERIOD;
		tb_new_up_call <= '0';
		
		wait for CLK_PERIOD * 100;
		report "Starting test 2";
		-- tb_landing_call <= 1;
		-- tb_new_up_call <= '1';
		-- wait for CLK_PERIOD;
		-- tb_new_up_call <= '0';
		-- wait for CLK_PERIOD;

		tb_landing_call <= 3;
		tb_new_up_call <= '1';
		wait for CLK_PERIOD;
		tb_new_up_call <= '0';
		
		wait for CLK_PERIOD * 100;
		report "Starting test 3";
		-- tb_landing_call <= 3;
		-- tb_new_up_call <= '1';
		-- wait for CLK_PERIOD;
		-- tb_new_up_call <= '0';
		-- wait for CLK_PERIOD;

		-- tb_landing_call <= 3;
		-- tb_new_down_call <= '1';
		-- wait for CLK_PERIOD;
		-- tb_new_down_call <= '0';
		-- wait for CLK_PERIOD;
		
		wait for CLK_PERIOD * 1;
		report "Registering car call: Car 1 Floor 2";
		car_call_1 <= 2;
		new_car_call_1 <= '1';
		wait for CLK_PERIOD;
		new_car_call_1 <= '0';
		
		wait for CLK_PERIOD * 1;
		report "Registering car call: Car 2 Floor 1";
		car_call_2 <= 1;
		new_car_call_2 <= '1';
		wait for CLK_PERIOD;
		new_car_call_2 <= '0';
		
		-- wait for CLK_PERIOD * 1;
		-- report "Registering car call: Car 2 Floor 4";
		-- car_call_2 <= 4;
		-- new_car_call_2 <= '1';
		-- wait for CLK_PERIOD;
		-- new_car_call_2 <= '0';
		
		-- report "Registering landing call: Floor 3";
		-- force_landing_call <= 3;
		-- wait for CLK_PERIOD;
		-- new_landing_call <= '1';
		-- wait for CLK_PERIOD;
		-- new_landing_call <= '0';
		
		-- wait for CLK_PERIOD * 1;
		-- report "Registering car call: Floor 2";
		-- car_call <= 2;
		-- new_car_call <= '1';
		-- wait for CLK_PERIOD;
		-- new_car_call <= '0';
		
		-- wait for CLK_PERIOD * 25;
		-- report "Registering car call: Floor 4";
		-- car_call <= 4;
		-- new_car_call <= '1';
		-- wait for CLK_PERIOD;
		-- new_car_call <= '0';
		
		-- wait for CLK_PERIOD * 100;
		-- report "Registering car call: Floor 2";
		-- car_call <= 2;
		-- new_car_call <= '1';
		-- wait for CLK_PERIOD * 2;
		-- new_car_call <= '0';
		
		-- wait for CLK_PERIOD * 100;
		-- report "Registering landing call: Floor 4";
		-- force_landing_call <= 4;
		-- wait for CLK_PERIOD;
		-- new_landing_call <= '1';
		-- wait for CLK_PERIOD;
		-- new_landing_call <= '0';
	
		wait;
	end process;
end;
