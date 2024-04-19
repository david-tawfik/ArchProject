LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY cache IS
	PORT(
		clk : IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY cache;

ARCHITECTURE synccachea OF cache IS

	TYPE cache_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL cache : cache_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF falling_edge(clk) THEN  
					dataout <= cache(to_integer(unsigned(address)));
				END IF;
		END PROCESS;
END synccachea;