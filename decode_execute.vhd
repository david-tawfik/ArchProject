

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decode_execute IS
	PORT(
        Clk,Rst : IN std_logic;
		write_back1_in, mem_write_in, mem_read_in, alu_src_in : IN std_logic;
        mem_to_reg_in : IN std_logic_vector(1 DOWNTO 0);
        alu_op_in : IN std_logic_vector(3 DOWNTO 0);
        read_data1_in, read_data2_in : IN std_logic_vector(31 DOWNTO 0);
        immediate_value_in : IN std_logic_vector(31 DOWNTO 0);
        write_address1_in, write_address2_in : IN std_logic_vector(2 DOWNTO 0);
		write_back1_out, mem_write_out, mem_read_out, alu_src_out : OUT std_logic;
        alu_op : OUT std_logic_vector(3 DOWNTO 0);
        mem_to_reg_out : OUT std_logic_vector(1 DOWNTO 0);
        read_data1_out, read_data2_out : OUT std_logic_vector(31 DOWNTO 0);
        immediate_value_out : OUT std_logic_vector(31 DOWNTO 0);
        write_address1_out, write_address2_out : OUT std_logic_vector(2 DOWNTO 0)
    );
END decode_execute;

ARCHITECTURE decode_execute_arch OF decode_execute IS
    signal temp_write_back1, temp_mem_write, temp_mem_read, temp_alu_src : std_logic;
    signal temp_mem_to_reg : std_logic_vector(1 DOWNTO 0);
    signal temp_alu_op : std_logic_vector(3 DOWNTO 0);
    signal temp_read_data1, temp_read_data2 : std_logic_vector(31 DOWNTO 0);
    signal temp_immediate_value : std_logic_vector(31 DOWNTO 0);
    signal temp_write_address1, temp_write_address2 : std_logic_vector(2 DOWNTO 0);
BEGIN
PROCESS(clk,rst)
BEGIN
    IF(rst = '1') THEN
        write_back1_out <= '0';
        mem_write_out <= '0';
        mem_read_out <= '0';
        alu_src_out <= '0';
        mem_to_reg_out <= (OTHERS => '0');
        alu_op <= (OTHERS => '0');
        read_data1_out <= (OTHERS => '0');
        read_data2_out <= (OTHERS => '0');
        immediate_value_out <= (OTHERS => '0');
        write_address1_out <= (OTHERS => '0');
        write_address2_out <= (OTHERS => '0');
    ELSIF clk'event and clk = '0' THEN --read in rising edge
        temp_write_back1 <= write_back1_in;
        temp_mem_write <= mem_write_in;
        temp_mem_read <= mem_read_in;
        temp_alu_src <= alu_src_in;
        temp_mem_to_reg <= mem_to_reg_in;
        temp_alu_op <= alu_op_in;
        temp_read_data1 <= read_data1_in;
        temp_read_data2 <= read_data2_in;
        temp_immediate_value <= immediate_value_in;
        temp_write_address1 <= write_address1_in;
        temp_write_address2 <= write_address2_in;
    -- ELSIF clk'event and clk = '0' THEN --write in falling edge
    END IF;
    write_back1_out <= temp_write_back1;
    mem_write_out <= temp_mem_write;
    mem_read_out <= temp_mem_read;
    alu_src_out <= temp_alu_src;
    mem_to_reg_out <= temp_mem_to_reg;
    alu_op <= temp_alu_op;
    read_data1_out <= temp_read_data1;
    read_data2_out <= temp_read_data2;
    immediate_value_out <= temp_immediate_value;
    write_address1_out <= temp_write_address1;
    write_address2_out <= temp_write_address2;    

END PROCESS;
	

END decode_execute_arch;
