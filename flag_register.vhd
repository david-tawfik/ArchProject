LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY flag_register IS
	PORT (
		-- write_address1, write_address2, write_address2, write_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		clk, zero_we, overflow_we, negative_we, carry_we, reset : IN STD_LOGIC;
		zero, overflow, negative, carry, Jz_reset : IN STD_LOGIC;
		zero_flag_out : OUT STD_LOGIC);
END ENTITY flag_register;

ARCHITECTURE flag_register_arch OF flag_register IS
	TYPE reg_array IS ARRAY (0 TO 3) OF STD_LOGIC;
	SIGNAL reg : reg_array;
BEGIN
	PROCESS (clk, reset, Jz_reset, zero_we, overflow_we, negative_we, carry_we, zero, overflow, negative, carry)
	BEGIN
		IF reset = '1' THEN
			reg <= (OTHERS => '0');
		ELSIF (Jz_reset = '1' AND rising_edge(clk)) THEN
			reg(3) <= '0';
		ELSIF clk = '1' THEN
			IF zero_we = '1' THEN
				reg(3) <= zero;
			END IF;
			IF overflow_we = '1' THEN
				reg(2) <= overflow;
			END IF;
			IF negative_we = '1' THEN
				reg(1) <= negative;
			END IF;
			IF carry_we = '1' THEN
				reg(0) <= carry;
			END IF;
		END IF;

	END PROCESS;
	zero_flag_out <= reg(3);
	-- data_read1 <= reg(to_integer(unsigned(read_address1)));
	-- data_read2 <= reg(to_integer(unsigned(read_address2)));

END flag_register_arch;