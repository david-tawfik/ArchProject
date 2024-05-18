LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY memory IS
	PORT (
		clk : IN STD_LOGIC;
		memWrite : IN STD_LOGIC;
		memRead : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END ENTITY memory;

ARCHITECTURE mem_arch OF memory IS
	TYPE mem_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL mem : mem_type;
BEGIN
	PROCESS (clk)
	BEGIN
		IF falling_edge(clk) THEN
			IF memWrite = '1' THEN
				mem(to_integer(unsigned(address(11 downto 0))) + 1) <= datain(15 DOWNTO 0);
				mem(to_integer(unsigned(address(11 downto 0)))) <= datain(31 DOWNTO 16);
			END IF;
		END IF;
	END PROCESS;
	dataout <= mem(to_integer(unsigned(address(11 downto 0)))) & mem(to_integer(unsigned(address(11 downto 0))) + 1) WHEN (memRead = '1')
		ELSE
		(OTHERS => '0');

END ARCHITECTURE mem_arch;