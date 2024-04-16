LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY register_file IS
	PORT (
		write_address1, read_address1, read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		clk, write_enable1, reset : IN STD_LOGIC;
		data_write1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		data_read1, data_read2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
END ENTITY register_file;

ARCHITECTURE register_file_arch OF register_file IS
	TYPE reg_array IS ARRAY (0 TO 6) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
	SIGNAL reg : reg_array;
BEGIN
	PROCESS (clk)
	BEGIN
		IF reset = '1' THEN
			reg <= (OTHERS => (OTHERS => '0'));
		ELSIF falling_edge(clk) THEN
			IF write_enable1 = '1' THEN
				reg(to_integer(unsigned(write_address1))) <= data_write1;
			END IF;
		END IF;
	END PROCESS;
	data_read1 <= reg(to_integer(unsigned(read_address1)));
	data_read2 <= reg(to_integer(unsigned(read_address2)));

END register_file_arch;