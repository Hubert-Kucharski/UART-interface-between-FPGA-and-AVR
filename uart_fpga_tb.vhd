LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY uart_fpga_tb IS
END uart_fpga_tb;
 
ARCHITECTURE behavior OF uart_fpga_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT uart_fpga
    PORT(
         Rx : IN  std_logic;
         CLK : IN  std_logic;
         LED : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Rx : std_logic := '0';
   signal CLK : std_logic := '0';

   --Outputs
   signal LED : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: uart_fpga PORT MAP (
          Rx => Rx,
          CLK => CLK,
          LED => LED
        );

	clock: process
	begin
		CLK  <= '0';
      		for i in 1 to 1000000 loop
       			wait for 5 ns;
			CLK  <= not CLK;
      		end loop;
      		wait;
	end process;
	

--    Stimulus process
   tb: process
   begin	
	Rx <= '1';
	wait for 5 us;
	Rx <= '0';
	wait for 104 us;
	Rx <= '1';
	wait for 104 us;
	Rx <= '0';
	wait for 104 us;
	Rx <= '1';
	wait for 104 us;
	Rx <= '0';
	wait for 104 us;
	Rx <= '1';
	wait for 104 us;
	Rx <= '1';
	wait for 104 us;
	Rx <= '0';
	wait for 104 us;
	Rx <= '0';
	wait for 104 us;
	Rx <= '1';

      wait;
   end process;

END;
