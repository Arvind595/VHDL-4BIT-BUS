--Parallel Data Bus
--b_bus <= data_out when read_en = '1' else (others => 'Z');

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity databus is
	port(
		cs		:	in STD_LOGIC;
		clk		:	in STD_LOGIC;
		rst		:	in STD_LOGIC;
		write_en	:	in STD_LOGIC;
		read_en	:	in STD_LOGIC;
		addr		:	in STD_LOGIC_VECTOR(1 downto 0);
		fmc_bus		:	inout STD_LOGIC_VECTOR(3 downto 0)
		);
end databus;


architecture Behavioral of databus is
	
	signal	b_cs					:	STD_LOGIC;
	signal	b_clk					:	STD_LOGIC;
	signal	b_rst					:	STD_LOGIC;
	signal	b_write_en				:	STD_LOGIC;
	signal	b_read_en				:	STD_LOGIC;
	signal	b_addr					:	STD_LOGIC_VECTOR(1 downto 0);
	signal 	b_fmc_bus				:	STD_LOGIC_VECTOR(3 downto 0);
	
	
	signal  bus_state				:	STD_LOGIC := '0';
	signal	data_out				:	STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	signal 	reg0, reg1, reg2, reg3	:	STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
	
	begin
		
		b_cs <= cs;
		b_clk <= clk;
		b_rst <= rst;
		b_write_en <= write_en;
		b_read_en <= read_en;
		b_addr <= addr;
		b_fmc_bus <= fmc_bus;

		process (b_clk, b_rst)
		begin
			if rising_edge (b_clk) then
				if 	(b_cs = '1') then
					if (b_rst = '1') then
					reg0 <= "0000";
					reg1 <= "0000";
					reg2 <= "0000";
					reg3 <= "0000";
				
					elsif  (b_write_en = '1' and b_read_en = '0') then
						case b_addr is 
							when "00" =>
								reg0 <= b_fmc_bus;
							when "01" =>
								reg1 <= b_fmc_bus;
							when "10" =>
								reg2 <= b_fmc_bus;
							when "11" =>
								reg3 <= b_fmc_bus;
							when others => null;
						end case;
				
					elsif (b_read_en = '1' and b_write_en = '0') then
					bus_state <='1';
						case b_addr is 
							when "00" =>
								data_out <= reg0;
							when "01" =>
								data_out <= reg1;
							when "10" =>
								data_out <= reg2;
							when "11" =>
								data_out <= reg3;
							when others => null;
						end case;
						
					else 
					bus_state <= '0';
					end if;
				else
				bus_state <='0';
				end if;
			end if;
		end process;
		fmc_bus <= data_out when bus_state = '1' else (others =>'Z');
	end Behavioral;