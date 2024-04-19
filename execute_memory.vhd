LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY execute_memory IS
	PORT(
        Clk,Rst : IN std_logic;
		write_back1_in, mem_write_in, mem_read_in : IN std_logic;
        mem_to_reg_in : IN std_logic_vector(1 DOWNTO 0);
        write_address1_in, write_address2_in : IN std_logic_vector(2 DOWNTO 0);
        alu_result_in: IN std_logic_vector(31 DOWNTO 0);
        read_data2_in : IN std_logic_vector(31 DOWNTO 0);
        

		write_back1_out, mem_write_out, mem_read_out : OUT std_logic;
        mem_to_reg_out : OUT std_logic_vector(1 DOWNTO 0);
        read_data2_out, alu_result_out : OUT std_logic_vector(31 DOWNTO 0);
        write_address1_out, write_address2_out : OUT std_logic_vector(2 DOWNTO 0)
    );
END execute_memory;

ARCHITECTURE execute_memory_arch OF execute_memory IS
    SIGNAL temp_write_back1, temp_mem_write, temp_mem_read : std_logic;
    SIGNAL temp_mem_to_reg : std_logic_vector(1 DOWNTO 0);
    SIGNAL temp_write_address1, temp_write_address2 : std_logic_vector(2 DOWNTO 0);
    SIGNAL temp_alu_result : std_logic_vector(31 DOWNTO 0);
    SIGNAL temp_read_data2 : std_logic_vector(31 DOWNTO 0);

BEGIN
PROCESS(clk,rst)
BEGIN
    IF(rst = '1') THEN
        write_back1_out <= '0';
        mem_write_out <= '0';
        mem_read_out <= '0';
        mem_to_reg_out <= "00";
        write_address1_out <= "000";
        write_address2_out <= "000";
        alu_result_out <= (OTHERS => '0');
        read_data2_out <= (OTHERS => '0');

    ELSIF clk'event and clk = '0' THEN --read in rising edge
        temp_write_back1 <= write_back1_in;
        temp_mem_write <= mem_write_in;
        temp_mem_read <= mem_read_in;
        temp_mem_to_reg <= mem_to_reg_in;
        temp_write_address1 <= write_address1_in;
        temp_write_address2 <= write_address2_in;
        temp_alu_result <= alu_result_in;
        temp_read_data2 <= read_data2_in;
 
    -- ELSIF clk'event and clk = '0' THEN --write in falling edge
    
    END IF;
    write_back1_out <= temp_write_back1;
    mem_write_out <= temp_mem_write;
    mem_read_out <= temp_mem_read;
    mem_to_reg_out <= temp_mem_to_reg;
    write_address1_out <= temp_write_address1;
    write_address2_out <= temp_write_address2;
    alu_result_out <= temp_alu_result;
    read_data2_out <= temp_read_data2;

END PROCESS;
	

END execute_memory_arch;

