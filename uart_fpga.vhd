library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_fpga is
port(
	Rx: in std_logic;
	CLK: in std_logic;
	LED: out std_logic_vector(7 downto 0)
	);
end uart_fpga;

architecture Behavioral of uart_fpga is
type states is (IDLE,START,RUN,STOP);
signal state: states := IDLE;
signal next_state: states := IDLE;
signal Rx_data: std_logic_vector(7 downto 0) := (others => '0');

begin
		
data: process(CLK)
variable bit_number: integer range 0 to 8;
variable counter: integer range 0 to 16000 := 0;
begin

	if rising_edge(CLK) then
		case state is
			when IDLE =>
				bit_number := 0;
				counter := 0;
				if Rx = '0' then				-- When other device starts transmission
					state <= START;			
				else
					state <= IDLE;
				end if;
				
			when START =>
				if counter = 15600 then 			-- 1,5 bit delay
					Rx_data(bit_number) <= Rx;
					bit_number := 1;
					counter := 0;
					state <= RUN;				
				else
					counter := counter + 1;
					state <= START;
				end if;			
			
			when RUN =>
				if counter = 10400 then 			-- 1 bit delay
					Rx_data(bit_number) <= Rx;		-- Bits assign
					bit_number := bit_number + 1;
					counter := 0;
					state <= RUN;
				else
					if bit_number = 8 then		-- After 1 byte has been received
						counter := 0;
						bit_number := 0;
						state <= STOP;
					else
						counter := counter + 1;
						state <= RUN;
					end if;
				end if;
			when STOP =>
				bit_number := 0;
				if counter = 10400 then
					counter := 0;
					state <= IDLE;
				else
					counter := counter + 1;
					state <= STOP;
				end if;
		end case;
	end if;
end process;


LED_output_change: process(CLK,state)					-- Assign received data to LEDs
begin
	if rising_edge(CLK) and state = IDLE then
		LED <= Rx_data;
	elsif rising_edge(CLK) and (state = START or state = RUN or state = STOP) then
		LED <= "00000000";
	end if;		
end process;

end Behavioral;

