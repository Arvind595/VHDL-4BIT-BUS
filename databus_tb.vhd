library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
--ok

entity databus_tb is 
end databus_tb;

architecture Behavioral of databus_tb is

	component databus
		port (
		cs		:	in STD_LOGIC;
		clk		:	in STD_LOGIC;
		rst		:	in STD_LOGIC;
		write_en	:	in STD_LOGIC;
		read_en	:	in STD_LOGIC;
		addr		:	in STD_LOGIC_VECTOR(1 downto 0);
		fmc_bus		:	inout STD_LOGIC_VECTOR(3 downto 0)
		);
	end component;
	
	signal	cs							:	STD_LOGIC := '0';
	signal	clk							:	STD_LOGIC := '0';
	signal	rst							:	STD_LOGIC := '0';
	signal	write_en					:	STD_LOGIC := '0';
	signal	read_en						:	STD_LOGIC := '0';
	signal	addr						:	STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal	data_feed					: 	STD_LOGIC_VECTOR(3 downto 0) := (others => 'Z');
	signal  fmc_bus						:	STD_LOGIC_VECTOR(3 downto 0) := (others => 'Z');

	begin
		
		uut : databus
		port map (
		cs => cs,
		clk => clk,
		rst => rst,
		write_en => write_en,
		read_en => read_en,
		addr => addr,
		fmc_bus => fmc_bus
		);
		
		--feed data only in write operations rest hold in ZZZZ state
		
		fmc_bus <= data_feed when write_en = '1' else (others => 'Z');
		
		clk_sim : process
		begin
		while true loop
		clk <='0';
		wait for 5 ns;
		clk <='1';
		wait for 5 ns;
		end loop;
		end process;
		
		stim_on : process
		begin
		wait for 10 ns;
		--defaut
		cs <= '0' ;
		rst <= '0';
		addr <= "00";
		read_en <= '0';
		write_en <= '0';
		data_feed <= "ZZZZ";
		wait for 10 ns;
		
		--test 1 :  reg0 write
		
		cs <= '1' ;
		rst <= '0';
		addr <= "00";
		read_en <= '0';
		write_en <= '1';
		data_feed <= "1010";
		wait for 10 ns;
		write_en <= '0';
		data_feed <= "ZZZZ";
		
		
		--test 2:  reg1 write
		
		cs <= '1' ;
		rst <= '0';
		addr <= "01";
		read_en <= '0';
		write_en <= '1';
		data_feed <= "1011";
		wait for 10 ns;
		write_en <= '0';
		data_feed <= "ZZZZ";
		
		
		--test 3:  reg2 write
		
		cs <= '1' ;
		rst <= '0';
		addr <= "10";
		read_en <= '0';
		write_en <= '1';
		data_feed <= "1100";
		wait for 10 ns;
		write_en <= '0';
		data_feed <= "ZZZZ";
		
		
		--test 4 :  reg0 write
		
		cs <= '1' ;
		rst <= '0';
		addr <= "11";
		read_en <= '0';
		write_en <= '1';
		data_feed <= "1101";
		wait for 10 ns;
		write_en <= '0';
		data_feed <= "ZZZZ";
		
		--test 5 :  no operation cs closed
		
		cs <= '0' ;
		rst <= '0';
		addr <= "11";
		read_en <= '1';
		wait for 10 ns;
		read_en <= '0';
		
		
		--test 6 : read reg0
		
		cs<='1';
		rst<='0';
		addr<="00";
		read_en<='1';
		write_en<='0';
		wait for 10 ns;
		read_en<='0';
		
		--test 7 : read reg1
		
		cs<='1';
		rst<='0';
		addr<="01";
		read_en<='1';
		write_en<='0';
		wait for 10 ns;
		read_en<='0';
		
		--test 8 : read reg2
		
		cs<='1';
		rst<='0';
		addr<="10";
		read_en<='1';
		write_en<='0';
		wait for 10 ns;
		read_en<='0';
		
		--test 9 : read reg3
		
		cs<='1';
		rst<='0';
		addr<="11";
		read_en<='1';
		write_en<='0';
		wait for 10 ns;
		read_en<='0';
		
		--test 10 : reset all data sync
		
		cs<='1';
		read_en<= '0';
		write_en<= '0';
		wait for 10 ns;
		rst<='1';
		wait for 10 ns;
		rst <='0';
		
		--test 11 : read reg0
		
		cs<='1';
		rst<='0';
		addr<="00";
		read_en<='1';
		write_en<='0';
		wait for 10 ns;
		read_en<='0';
		
		wait for 10 ns;
		assert false report "Test complete" severity note;
	end process;
		
end Behavioral;
	