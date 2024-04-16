LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pc IS
	PORT (
		clk,reset,enable : IN STD_LOGIC;
		count : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
END pc;

ARCHITECTURE pc_arch OF pc IS
    SIGNAL c : STD_LOGIC_VECTOR(5 DOWNTO 0);
BEGIN
    PROCESS(clk)
    BEGIN
        IF reset = '1' THEN
            c <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF enable = '1' THEN
                c <= std_logic_vector(to_unsigned(to_integer(unsigned(c)) + 1, c'length));
            END IF;
        END IF;
    END PROCESS;
    count <= c;
END pc_arch;

