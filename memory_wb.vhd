LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY memory_wb IS
	PORT(
        Clk,Rst : IN std_logic;
		write_back1_in : IN std_logic;
        mem_to_reg_in : IN std_logic_vector(1 DOWNTO 0);
        write_address1_in, write_address2_in : IN std_logic_vector(2 DOWNTO 0);
        memory_data_in: IN std_logic_vector(31 DOWNTO 0);
        alu_result_in : IN std_logic_vector(31 DOWNTO 0);
        data_read2_in : IN std_logic_vector(31 DOWNTO 0);
        

		write_back1_out : OUT std_logic;
        mem_to_reg_out : OUT std_logic_vector(1 DOWNTO 0);
        read_data2_out, alu_result_out, memory_data_out : OUT std_logic_vector(31 DOWNTO 0);
        write_address1_out, write_address2_out : OUT std_logic_vector(2 DOWNTO 0)
    );
END memory_wb;

ARCHITECTURE memory_wb_arch OF memory_wb IS
    signal temp_write_back1 : std_logic;
    signal temp_mem_to_reg : std_logic_vector(1 DOWNTO 0);
    signal temp_write_address1, temp_write_address2 : std_logic_vector(2 DOWNTO 0);
    signal temp_read_data2, temp_alu_result, temp_memory_data : std_logic_vector(31 DOWNTO 0);
BEGIN
PROCESS(clk,rst)
BEGIN
    IF(rst = '1') THEN
        write_back1_out <= '0';
        mem_to_reg_out <= (OTHERS => '0');
        write_address1_out <= (OTHERS => '0');
        write_address2_out <= (OTHERS => '0');
        read_data2_out <= (OTHERS => '0');
        alu_result_out <= (OTHERS => '0');
        memory_data_out <= (OTHERS => '0');
    ELSIF clk'event and clk = '0' THEN --read in rising edge
        temp_write_back1 <= write_back1_in;
        temp_mem_to_reg <= mem_to_reg_in;
        temp_write_address1 <= write_address1_in;
        temp_write_address2 <= write_address2_in;
        temp_read_data2 <= data_read2_in;
        temp_alu_result <= alu_result_in;
        temp_memory_data <= memory_data_in;
    -- ELSIF clk'event and clk = '0' THEN --write in falling edge 
    END IF;
    write_back1_out <= temp_write_back1;
    mem_to_reg_out <= temp_mem_to_reg;
    write_address1_out <= temp_write_address1;
    write_address2_out <= temp_write_address2;
    read_data2_out <= temp_read_data2;
    alu_result_out <= temp_alu_result;
    memory_data_out <= temp_memory_data;  

END PROCESS;
	

END memory_wb_arch;


