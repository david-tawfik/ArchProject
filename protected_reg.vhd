LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY protected_reg IS
    PORT (
        clk, reset : IN STD_LOGIC;
        memory_address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        pf_enable : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        protected_bit : OUT STD_LOGIC
    );
END protected_reg;

ARCHITECTURE protected_arch OF protected_reg IS
TYPE reg_array IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL reg : reg_array;
BEGIN
    PROCESS (clk, reset, memory_address_in, pf_enable)
    BEGIN
        IF reset = '1' THEN
            reg(1) <= (OTHERS => '0');
        ELSIF clk = '1' THEN
            IF pf_enable = "01" THEN
                reg(to_integer(unsigned(memory_address_in(11 downto 0))))(1) <= '1';
            ELSIF pf_enable = "10" THEN
                reg(to_integer(unsigned(memory_address_in(11 downto 0))))(1) <= '0';
            END IF;
        END IF;

    END PROCESS;
    -- data_read1 <= reg(to_integer(unsigned(read_address1)));
    -- data_read2 <= reg(to_integer(unsigned(read_address2)));
    protected_bit <= reg(to_integer(unsigned(memory_address_in(11 downto 0))))(1);

END protected_arch;