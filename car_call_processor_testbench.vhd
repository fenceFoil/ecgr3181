LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY car_call_processor_testbench IS
END car_call_processor_testbench;
 
ARCHITECTURE behavior OF car_call_processor_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT car_call_processor
	port (
		car_clk : IN std_logic;
		clk : IN std_logic;
		reset : IN std_logic; 				-- used?
		new_car_call : IN std_logic; 
		remove_call : IN std_logic;
		car_call : IN integer;
		pos_landing : IN integer;
		
		call_above : OUT std_logic;
		call_below : OUT std_logic;
		call_at_pos: OUT std_logic);
    END COMPONENT;
    

   --Inputs
	signal car_clk : std_logic := '0';
	signal clk : std_logic := '0';
	signal reset : std_logic := '0';
	signal new_car_call : std_logic := '0';
	signal remove_call : std_logic := '0';
	signal car_call : integer := 0;
	signal pos_landing : integer := 0;



	--Outputs
	signal call_above : std_logic;
	signal call_below : std_logic;
	signal call_at_pos : std_logic;

	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: car_call_processor PORT MAP (
			car_clk => car_clk,
			clk => clk,
			reset => reset,
			new_car_call => new_car_call,
			remove_call => remove_call,
			car_call => car_call,
			pos_landing => pos_landing,
			call_above => call_above,
			call_below => call_below,
			call_at_pos => call_at_pos
        );
 
   clk_proc: process
   begin
	clk <= '1';
	wait for 1 ns;
	clk <= '0';
	wait for 1 ns;
   end process;

   -- Stimulus process
   stim_proc: process
   begin		
		-- STEP 1
		REPORT "Step 1 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '1';
		remove_call <= '0';
		car_call <= 3;
		pos_landing <= 3;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 1"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 1"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '1')
			REPORT "Output of call_at_pos incorrect at step 1"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 1
		
		
		-- STEP 2
		REPORT "Step 2 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 2;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 2"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 2"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 2"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 2
		
		
		-- STEP 3
		REPORT "Step 3 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 4;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 3"
			SEVERITY NOTE;
		ASSERT (call_below = '1')
			REPORT "Output of call_below incorrect at step 3"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 3"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 3
		
		
		-- STEP 4
		REPORT "Step 4 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '1';
		remove_call <= '0';
		car_call <= 2;
		pos_landing <= 4;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 4"
			SEVERITY NOTE;
		ASSERT (call_below = '1')
			REPORT "Output of call_below incorrect at step 4"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 4"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 4
		
		
		-- STEP 5
		REPORT "Step 5 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 1;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 5"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 5"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 5"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 5
		
		
		-- STEP 6
		REPORT "Step 6 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 2;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 6"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 6"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '1')
			REPORT "Output of call_at_pos incorrect at step 6"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 6
		
		
		-- STEP 7
		REPORT "Step 7 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 3;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 7"
			SEVERITY NOTE;
		ASSERT (call_below = '1')
			REPORT "Output of call_below incorrect at step 7"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '1')
			REPORT "Output of call_at_pos incorrect at step 7"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 7
		
		
		-- STEP 8
		REPORT "Step 8 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 4;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 8"
			SEVERITY NOTE;
		ASSERT (call_below = '1')
			REPORT "Output of call_below incorrect at step 8"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 8"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 8
		
		
		-- STEP 9
		REPORT "Step 9 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '1';
		car_call <= 0;
		pos_landing <= 2;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 9"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 9"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 9"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 9
		
		
		-- STEP 10
		REPORT "Step 10 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '0';
		remove_call <= '1';
		car_call <= 0;
		pos_landing <= 3;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 10"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 10"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 10"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 10
		
		
		-- STEP 11
		REPORT "Step 11 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '1';
		remove_call <= '0';
		car_call <= 2;
		pos_landing <= 1;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 11"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 11"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 11"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 11
		
		
		-- STEP 12
		REPORT "Step 12 started";
		-- Set up inputs
		reset <= '0';
		new_car_call <= '1';
		remove_call <= '0';
		car_call <= 3;
		pos_landing <= 1;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '1')
			REPORT "Output of call_above incorrect at step 12"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 12"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 12"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 12
		
		
		-- STEP 13
		REPORT "Step 13 started";
		-- Set up inputs
		reset <= '1';
		new_car_call <= '0';
		remove_call <= '0';
		car_call <= 0;
		pos_landing <= 1;
		-- Lower car clock, triggering car call processor
		car_clk <= '0';	
		-- Wait for processing to finish
		wait for 100 ns;
		-- Check outputs
		ASSERT (call_above = '0')
			REPORT "Output of call_above incorrect at step 13"
			SEVERITY NOTE;
		ASSERT (call_below = '0')
			REPORT "Output of call_below incorrect at step 13"
			SEVERITY NOTE;
		ASSERT (call_at_pos = '0')
			REPORT "Output of call_at_pos incorrect at step 13"
			SEVERITY NOTE;
		-- Raise car clock again
		car_clk <= '1';
		-- Wait before lowering car clock and testing next step
		wait for 100 ns;
		-- END OF STEP 13
		
		

      wait;
   end process;

END;
