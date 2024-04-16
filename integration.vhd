LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY integration IS
	PORT(
		clk,reset,enable : IN std_logic;
		read_address1,read_address2,write_address,op_code : OUT  std_logic_vector(2 DOWNTO 0)
        );
END ENTITY integration;

architecture integration_arch OF integration IS
component pc is
    PORT(
        clk,reset,enable : IN std_logic;
        count: OUT  std_logic_vector(5 DOWNTO 0)
        );
END component pc;

component ram is
    PORT(
		clk : IN std_logic;
		we  : IN std_logic;
		address : IN  std_logic_vector(5 DOWNTO 0);
		datain  : IN  std_logic_vector(15 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0)
        );
END component ram;

component my_nDFF is
		GENERIC ( n : integer := 16);
		PORT(	Clk,Rst : IN std_logic;
			d : IN std_logic_vector(n-1 DOWNTO 0);
			q : OUT std_logic_vector(n-1 DOWNTO 0));
END component my_nDFF;

signal pc_count : std_logic_vector(5 DOWNTO 0);
signal data : std_logic_vector(15 DOWNTO 0);
signal decoded_data : std_logic_vector(15 DOWNTO 0);

begin
	counter: pc PORT MAP(clk,reset,enable,pc_count);
	instruction_cache: ram PORT MAP(clk,'0',pc_count,"0000000000000000",data);
	fetch_decode: my_nDFF PORT MAP(clk,'0',data,decoded_data);
	op_code <= decoded_data(15 DOWNTO 13);
	write_address <= decoded_data(12 DOWNTO 10);
	read_address1 <= decoded_data(9 DOWNTO 7);
	read_address2 <= decoded_data(6 DOWNTO 4);
end integration_arch;




