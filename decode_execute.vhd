

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY decode_execute IS
    PORT (
        Clk, Rst, JmpRst : IN STD_LOGIC;
        Clk, Rst, noWrite, loadReset,JmpRst : IN STD_LOGIC;
        write_back1_in, write_back2_in, mem_write_in, mem_read_in, alu_src_in, zero_we_in, overflow_we_in, negative_we_in, carry_we_in : IN STD_LOGIC;
        mem_to_reg_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        alu_op_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        read_data1_in, read_data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate_value_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        src1_address_in, src2_address_in, write_address1_in, write_address2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        InputPort_from_FD_to_DE : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB_data_src_to_DE : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        OutPort_en_to_DE : IN STD_LOGIC;
        in_op_from_C_to_DE : IN STD_LOGIC;
        sp_sel_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Jmp_from_C_to_DE : IN STD_LOGIC;
        Jz_from_C_to_DE : IN STD_LOGIC;
        write_back1_out, write_back2_out, mem_write_out, mem_read_out, alu_src_out, zero_we_out, overflow_we_out, negative_we_out, carry_we_out : OUT STD_LOGIC;
        pf_enable_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        pcPlusOneIn : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        mem_to_reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        read_data1_out, read_data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        immediate_value_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        InputPort_from_DE_to_EM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        WB_data_src_from_DE_to_EM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        OutPort_en_from_DE_to_EM : OUT STD_LOGIC;
        in_op_from_DE_to_EM : OUT STD_LOGIC;
        src1_address_EX, src2_address_EX, write_address1_out, write_address2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        sp_sel_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        Jmp_from_DE_to_EM : OUT STD_LOGIC;
        Jz_from_DE_to_EM : OUT STD_LOGIC
        pf_enable_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        pcPlusOneOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END decode_execute;

ARCHITECTURE decode_execute_arch OF decode_execute IS
    SIGNAL temp_write_back1, temp_write_back2, temp_mem_write, temp_mem_read, temp_alu_src : STD_LOGIC;
    SIGNAL temp_mem_to_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_alu_op : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL temp_read_data1, temp_read_data2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_immediate_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_write_address1, temp_write_address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_zero_we, temp_overflow_we, temp_negative_we, temp_carry_we : STD_LOGIC;
    SIGNAL temp_InputPort : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL temp_WB_data_src : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_OutputPort_en : STD_LOGIC;
    SIGNAL temp_in_op : STD_LOGIC;
    SIGNAL temp_src1_address, temp_src2_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_sp_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_Jmp : STD_LOGIC;
    SIGNAL temp_Jz : STD_LOGIC;
    SIGNAL temp_pf_enable : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL temp_pcPlusOne : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            temp_write_back1 <= '0';
            temp_write_back2 <= '0';
            temp_mem_write <= '0';
            temp_mem_read <= '0';
            temp_alu_src <= '0';
            temp_mem_to_reg <= (OTHERS => '0');
            temp_alu_op <= (OTHERS => '0');
            temp_read_data1 <= (OTHERS => '0');
            temp_read_data2 <= (OTHERS => '0');
            temp_immediate_value <= (OTHERS => '0');
            temp_write_address1 <= (OTHERS => '0');
            temp_write_address2 <= (OTHERS => '0');
            temp_zero_we <= '0';
            temp_overflow_we <= '0';
            temp_negative_we <= '0';
            temp_carry_we <= '0';
            temp_WB_data_src <= (OTHERS => '0');
            temp_OutputPort_en <= '0';
            temp_src1_address <= (OTHERS => '0');
            temp_src2_address <= (OTHERS => '0');
            temp_in_op <= '0';
            temp_sp_sel <= (OTHERS => '0');
            temp_pf_enable <= (OTHERS => '0');
            temp_pcPlusOne <= (OTHERS => '0');
            temp_Jmp <= '0';
            temp_Jz <= '0';

        ELSIF (falling_edge(clk) AND (loadReset = '1' OR JmpRst = '1')) THEN
            temp_Jmp <= '0';
            temp_Jz <= '0';
            temp_write_back1 <= '0';
            temp_write_back2 <= '0';
            temp_mem_write <= '0';
            temp_mem_read <= '0';
            temp_alu_src <= '0';
            temp_mem_to_reg <= (OTHERS => '0');
            temp_alu_op <= (OTHERS => '0');
            temp_read_data1 <= (OTHERS => '0');
            temp_read_data2 <= (OTHERS => '0');
            temp_immediate_value <= (OTHERS => '0');
            temp_write_address1 <= (OTHERS => '0');
            temp_write_address2 <= (OTHERS => '0');
            temp_zero_we <= '0';
            temp_overflow_we <= '0';
            temp_negative_we <= '0';
            temp_carry_we <= '0';
            temp_WB_data_src <= (OTHERS => '0');
            temp_OutputPort_en <= '0';
            temp_src1_address <= (OTHERS => '0');
            temp_src2_address <= (OTHERS => '0');
            temp_in_op <= '0';
            temp_sp_sel <= (OTHERS => '0');
            temp_pf_enable <= (OTHERS => '0');
            temp_pcPlusOne <= (OTHERS => '0');

        ELSIF falling_edge(clk) THEN --read in rising edge
            temp_write_back1 <= write_back1_in;
            temp_write_back2 <= write_back2_in;
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
            temp_zero_we <= zero_we_in;
            temp_overflow_we <= overflow_we_in;
            temp_negative_we <= negative_we_in;
            temp_carry_we <= carry_we_in;
            temp_InputPort <= InputPort_from_FD_to_DE;
            temp_WB_data_src <= WB_data_src_to_DE;
            temp_OutputPort_en <= OutPort_en_to_DE;
            temp_src1_address <= src1_address_in;
            temp_src2_address <= src2_address_in;
            temp_in_op <= in_op_from_C_to_DE;
            temp_sp_sel <= sp_sel_in;
            temp_Jmp <= Jmp_from_C_to_DE;
            temp_Jz <= Jz_from_C_to_DE;
            temp_pf_enable <= pf_enable_in;
            temp_pcPlusOne <= pcPlusOneIn;
            --ELSIF clk'event and clk = '0' THEN --write in falling edge
        END IF;
        write_back1_out <= temp_write_back1;
        write_back2_out <= temp_write_back2;
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
        zero_we_out <= temp_zero_we;
        overflow_we_out <= temp_overflow_we;
        negative_we_out <= temp_negative_we;
        carry_we_out <= temp_carry_we;
        InputPort_from_DE_to_EM <= temp_InputPort;
        WB_data_src_from_DE_to_EM <= temp_WB_data_src;
        OutPort_en_from_DE_to_EM <= temp_OutputPort_en;
        src1_address_EX <= temp_src1_address;
        src2_address_EX <= temp_src2_address;
        in_op_from_DE_to_EM <= temp_in_op;
        sp_sel_out <= temp_sp_sel;
        Jmp_from_DE_to_EM <= temp_Jmp;
        Jz_from_DE_to_EM <= temp_Jz;
        pf_enable_out <= temp_pf_enable;
        pcPlusOneOut <= temp_pcPlusOne;
    END PROCESS;
END decode_execute_arch;