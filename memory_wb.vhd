LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY memory_wb IS
    PORT (
        Clk, Rst : IN STD_LOGIC;
        write_back1_in : IN STD_LOGIC;
        write_back2_in : IN STD_LOGIC;
        mem_to_reg_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        write_address1_in, write_address2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        memory_data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_read2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        zero_in, negative_in, overflow_in, carry_in : IN STD_LOGIC;
        InputPort_from_EM_to_MWB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB_data_src_from_EM_to_MWB : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OutPort_en_from_EM_to_MWB : IN STD_LOGIC;
        in_op_from_EM_to_MWB : IN STD_LOGIC;
        memory_read_from_EM_to_MWB : IN STD_LOGIC;

        InputPort_from_MWB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_back1_out : OUT STD_LOGIC;
        write_back2_out : OUT STD_LOGIC;
        mem_to_reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        read_data2_out, alu_result_out, memory_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        write_address1_out, write_address2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_data_src_from_MWB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        zero_out, negative_out, overflow_out, carry_out : OUT STD_LOGIC;
        in_op_from_MWB : OUT STD_LOGIC;
        Outport_en_from_MWB : OUT STD_LOGIC;
        memory_read_from_MWB : OUT STD_LOGIC
    );
END memory_wb;

ARCHITECTURE memory_wb_arch OF memory_wb IS
    SIGNAL temp_write_back1 : STD_LOGIC;
    SIGNAL temp_mem_to_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_write_address1, temp_write_address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_read_data2, temp_alu_result, temp_memory_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_zero, temp_negative, temp_overflow, temp_carry : STD_LOGIC;
    SIGNAL temp_InputPort : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_WB_data_src : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_OutPort_en : STD_LOGIC;
    SIGNAL temp_in_op : STD_LOGIC;
    SIGNAL temp_write_back2 : STD_LOGIC;
    Signal temp_memory_read : STD_LOGIC;

BEGIN
    PROCESS (clk, rst)
    variable temp : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN
        IF (rst = '1') THEN
            temp_write_back1 <= '0';
            temp_mem_to_reg <= (OTHERS => '0');
            temp_write_address1 <= (OTHERS => '0');
            temp_write_address2 <= (OTHERS => '0');
            temp_read_data2 <= (OTHERS => '0');
            temp_alu_result <= (OTHERS => '0');
            temp_memory_data <= (OTHERS => '0');
            temp_zero <= '0';
            temp_negative <= '0';
            temp_overflow <= '0';
            temp_carry <= '0';
            temp_WB_data_src <= (OTHERS => '0');
            temp_OutPort_en <= '0';
            temp_in_op <= '0';
            temp_write_back2 <= '0';
            temp_memory_read <= '0';
        ELSIF falling_edge(clk) THEN --read in rising edge
            temp_write_back1 <= write_back1_in;
            temp_mem_to_reg <= mem_to_reg_in;
            temp_write_address1 <= write_address1_in;
            temp_write_address2 <= write_address2_in;
            temp_read_data2 <= data_read2_in;
            temp_alu_result <= alu_result_in;
            temp_memory_data <= memory_data_in;
            temp_zero <= zero_in;
            temp_negative <= negative_in;
            temp_overflow <= overflow_in;
            temp_carry <= carry_in;
            temp_InputPort <= InputPort_from_EM_to_MWB;
            temp_WB_data_src <= WB_data_src_from_EM_to_MWB;
            temp_OutPort_en <= OutPort_en_from_EM_to_MWB;
            temp_in_op <= in_op_from_EM_to_MWB;
            temp_write_back2 <= write_back2_in;
            temp_memory_read <= memory_read_from_EM_to_MWB;

        ELSIF rising_edge (clk) THEN
            write_back1_out <= temp_write_back1;
            mem_to_reg_out <= temp_mem_to_reg;
            write_address1_out <= temp_write_address1;
            write_address2_out <= temp_write_address2;
            read_data2_out <= temp_read_data2;
            alu_result_out <= temp_alu_result;
            memory_data_out <= temp_memory_data;
            zero_out <= temp_zero;
            negative_out <= temp_negative;
            overflow_out <= temp_overflow;
            carry_out <= temp_carry;
            InputPort_from_MWB <= temp_InputPort;
            WB_data_src_from_MWB <= temp_WB_data_src;
            Outport_en_from_MWB <= temp_OutPort_en;
            in_op_from_MWB <= temp_in_op;
            write_back2_out <= temp_write_back2;
            memory_read_from_MWB <= temp_memory_read;
        END IF;

    END PROCESS;
END memory_wb_arch;