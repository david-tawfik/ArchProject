LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY cache IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY cache;

ARCHITECTURE synccachea OF cache IS

	TYPE cache_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL cache : cache_type;

BEGIN
	--PROCESS(clk) IS
	--	BEGIN
	--IF falling_edge(clk) THEN  
	--dataout <= cache(to_integer(unsigned(address)));
	--END IF;
	--END PROCESS;
	dataout <= cache(to_integer(unsigned(address)));
END synccachea;