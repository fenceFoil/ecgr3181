library ieee;
use ieee.std_logic_1164.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
entity car_processor_testbench is
end car_processor_testbench;
 
architecture behavior of car_processor_testbench is
 
    -- Component Declaration for the Unit Under Test (UUT)
    component car_processor
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
		curr_landing	: out integer;
		
		direction_up 	: out std_logic;
		direction_down 	: out std_logic);
	end component;
    
	-- UUT connections
	-- Inputs
	signal clk : std_logic := '0';
	signal fast_clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal hold_button : std_logic := '0';
	signal open_button : std_logic := '0';
	signal close_button : std_logic := '0';
	signal door_closed : std_logic := '0';
	signal at_landing : std_logic := '0';
	signal near_landing : std_logic := '0';
	signal pos_landing : integer := 1;
	signal new_landing_call : std_logic := '0';
	signal landing_call : integer := 0;
	signal new_car_call : std_logic := '0';
	signal car_call : integer := 0;
	
	--Outputs
	signal open_door : std_logic := '0';
	signal motor : integer := 0;
	signal serviced_call : std_logic := '0';
	signal curr_landing : integer := 0;
	signal direction_up : std_logic := '0';
	signal direction_down : std_logic := '0';
	
	-- Mock Component connections
	signal force_landing_call : integer := 0;
	
	-- Clock constants
	constant CLK_PERIOD : time := 100 ns;
	constant FAST_CLK_PERIOD: time := 1 ns;	
	
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
	mock_doors: process (open_door)
	begin
		door_closed <= not open_door;
	end process;
	
	-- Mock: Group Traffic Processor
	mock_gtp: process (force_landing_call, serviced_call)
	begin
		if (force_landing_call /= 0 and force_landing_call'event) then
			landing_call <= force_landing_call;
		end if;
		
		if (serviced_call = '1' and serviced_call'event) then
			landing_call <= 0;
		end if;
	end process;
	
	-- Mock: Motor and Position Sensors
	mock_motor: process (clk)
		variable motor_lag : integer := 0;
	begin
		if (motor'event or (clk'event and clk = '1')) then
			-- acceleration
			if (motor = 2 or motor = 5) then
				at_landing <= '0';
				near_landing <= '0';
			end if;
			-- holding (and floor number change)
			if (motor = 1) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing <= pos_landing - 1;
					motor_lag := 0;
				end if;
				
				at_landing <= '0';
				near_landing <= '1';
			end if;
			if (motor = 4) then
				motor_lag := motor_lag + 1;
				if (motor_lag >= 5) then
					pos_landing <= pos_landing + 1;
					motor_lag := 0;
				end if;
				
				at_landing <= '0';
				near_landing <= '1';
			end if;
			-- braking
			if (motor = 3 or motor = 6) then
				at_landing <= '1';
				near_landing <= '0';
			end if;
			-- stopped
			if (motor = 0) then
				at_landing <= '1';
				near_landing <= '0';
			end if;
			
			if (motor < 0 or motor > 6) then
				report "MOTOR VALUE INVALID";
			end if;
		end if;
	end process;

	-- Stimulus process
	stim_proc: process
	begin		
		-- Setup
		close_button <= '1';
		report "Step 0: Waiting for 3 clock periods.";
		wait for CLK_PERIOD * 3;
		
		-- Step 1
		report "Step 1";
		force_landing_call <= 3;
		new_landing_call <= '1';
		wait for CLK_PERIOD;
		assert (direction_up = '1')
			report "Step 1: Direction not yet up."
			severity note;
		
		-- Step 2
		report "Step 2";
		new_landing_call <= '0';
		wait for CLK_PERIOD;
		assert (direction_up = '1')
			report "Step 2: Direction not yet up."
			severity note;
	
		wait;
	end process;
end;
