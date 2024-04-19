LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY memory IS
	PORT(
		clk : IN std_logic;
		memWrite,memRead  : IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY memory;

ARCHITECTURE mem_arch OF mem IS

	TYPE mem_type IS ARRAY(0 TO 4095) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL mem : mem_type ;
	
	BEGIN
		PROCESS(clk) IS
			BEGIN
				IF rising_edge(clk) THEN  
					IF memWrite  = '1' THEN
						mem(to_integer(unsigned(address))) <= datain(15 DOWNTO 0);
                        mem(to_integer(unsigned(address))+1) <= datain(31 DOWNTO 16);
					END IF;
				END IF;
		END PROCESS;
		dataout <= mem(to_integer(unsigned(address))+1) & mem(to_integer(unsigned(address)));
END mem_arch;

