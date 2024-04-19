LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY harvard_cpu IS
    PORT (
        clk,reset : IN STD_LOGIC;
        pcCounter : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
END harvard_cpu;

architecture harvard_cpu_arch OF harvard_cpu IS
    component pc
        PORT (
            clk,reset : IN STD_LOGIC;
            pcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
            );
    END component;

    component cache is
        PORT(
            clk : IN std_logic;
            address : IN  std_logic_vector(31 DOWNTO 0);
            dataout : OUT std_logic_vector(15 DOWNTO 0)
            );
    END component cache;

    component my_nDFF is
		GENERIC ( n : integer := 16);
		PORT(	Clk,Rst : IN std_logic;
			d : IN std_logic_vector(n-1 DOWNTO 0);
			q : OUT std_logic_vector(n-1 DOWNTO 0));
    END component my_nDFF;

    component fetch_decode is
        PORT(	Clk,Rst : IN std_logic;
		instruction : IN std_logic_vector(15 DOWNTO 0);
		op_code : OUT std_logic_vector(5 DOWNTO 0);
        dst, src1, src2 : OUT std_logic_vector(2 DOWNTO 0)
    );
    END component fetch_decode;

    COMPONENT register_file IS
    PORT (
		write_address1, write_address2, read_address1, read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		clk, write_enable1, write_enable2, reset : IN STD_LOGIC;
		data_write1, data_write2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_read1, data_read2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
    END COMPONENT register_file;

    COMPONENT controller IS
        PORT (
            opCode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
            aluOp : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            writeBack1, memRead, memWrite : OUT STD_LOGIC;
            memInReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            aluSrc : OUT STD_LOGIC
        );
    END COMPONENT controller;  

    Component decode_execute IS
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
    END component decode_execute;

    component alu is
        PORT (
            A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            zeroFlag, overflowFlag, negativeFlag, carryFlag : OUT STD_LOGIC
        );
    END component alu;

    Component execute_memory IS
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
    END component execute_memory;


    component memory IS
	PORT(
		clk : IN std_logic;
		memWrite,memRead  : IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
    END component;

    Component memory_wb IS
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
    END  Component memory_wb;

    signal count : std_logic_vector(31 DOWNTO 0);
    signal instruction : std_logic_vector(15 DOWNTO 0);
    signal opcode_fd_out : std_logic_vector(5 DOWNTO 0);
    signal dst_fd_out, src1_fd_out, src2_fd_out : std_logic_vector(2 DOWNTO 0);
    signal alu_op_controller_out : std_logic_vector(3 DOWNTO 0);
    signal write_back_controller_out, mem_read_controller_out, mem_write_controller_out : std_logic;
    signal mem_to_reg_controller_out : std_logic_vector(1 DOWNTO 0);
    signal alu_src_controller_out : std_logic;
    signal data_read1_reg_out, data_read2_reg_out : std_logic_vector(31 DOWNTO 0);
    signal write_back1_controller_out : std_logic;
    signal write_address1_de_out, write_address2_de_out : std_logic_vector(2 DOWNTO 0);
    signal write_back1_de_out, mem_write_de_out, mem_read_de_out, alu_src_de_out : std_logic;
    signal alu_op_de_out : std_logic_vector(3 DOWNTO 0);
    signal mem_to_reg_de_out : std_logic_vector(1 DOWNTO 0);
    signal read_data1_de_out, read_data2_de_out : std_logic_vector(31 DOWNTO 0);
    signal immediate_value_de_out : std_logic_vector(31 DOWNTO 0);
    signal alu_out : std_logic_vector(31 DOWNTO 0);
    signal zero_flag_alu_out, overflow_flag_alu_out, negative_flag_alu_out, carry_flag_alu_out : std_logic;
    signal flag_register_in, flag_register_out : std_logic_vector(3 DOWNTO 0);
    signal write_address1_em_out, write_address2_em_out : std_logic_vector(2 DOWNTO 0);
    signal write_back1_em_out, mem_write_em_out, mem_read_em_out, alu_src_em_out : std_logic;
    signal alu_em_out : std_logic_vector(31 DOWNTO 0);
    signal data_read2_em_out : std_logic_vector(31 DOWNTO 0);
    signal memory_out : std_logic_vector(31 DOWNTO 0);
    signal write_address1_wb_out, write_address2_wb_out : std_logic_vector(2 DOWNTO 0);
    signal write_back1_wb_out : std_logic;
    signal mem_to_reg_wb_out : std_logic_vector(1 DOWNTO 0);
    signal data_read2_wb_out, alu_result_wb_out, memory_data_wb_out : std_logic_vector(31 DOWNTO 0);
    signal dst_em_out : std_logic_vector(2 DOWNTO 0);
    signal dst2_em_out : std_logic_vector(2 DOWNTO 0);
    signal mem_to_reg_em_out : std_logic_vector(1 DOWNTO 0);

    begin
        pc1 : pc PORT MAP(clk,reset,"00000000000000000000000000000000",count);
        flag_register_in <= zero_flag_alu_out & overflow_flag_alu_out & negative_flag_alu_out & carry_flag_alu_out;
        instruction_memory : cache PORT MAP(
            clk => clk,
            address => count,
            dataout => instruction
            );

        fetch_decode1 : fetch_decode PORT MAP(
            Clk => clk,
            Rst => '0',
            instruction => instruction,
            op_code => opcode_fd_out,
            dst => dst_fd_out,
            src1 => src1_fd_out,
            src2 => src2_fd_out
            );

        controller1 : controller PORT MAP(
            opCode => opcode_fd_out,
            aluOp => alu_op_controller_out,
            writeBack1 => write_back1_controller_out,
            memRead => mem_read_controller_out,
            memWrite => mem_write_controller_out,
            memInReg => mem_to_reg_controller_out,
            aluSrc => alu_src_controller_out
            );

        register_file1 : register_file PORT MAP(
            write_address1 => write_address1_wb_out, 
            write_address2 => write_address2_wb_out,
            read_address1 => src1_fd_out,
            read_address2 => src2_fd_out,
            clk => clk,
            write_enable1 => write_back1_wb_out,
            write_enable2 => '0',
            reset => '0',
            data_write1 => alu_result_wb_out,
            data_write2 => memory_data_wb_out,
            data_read1 => data_read1_reg_out,
            data_read2 => data_read2_reg_out
            );

        decode_execute1 : decode_execute PORT MAP(
            Clk => clk,
            Rst => '0',
            write_back1_in => write_back1_controller_out,
            mem_write_in => mem_write_controller_out,
            mem_read_in => mem_read_controller_out,
            alu_src_in => alu_src_controller_out,
            mem_to_reg_in => mem_to_reg_controller_out,
            alu_op_in => alu_op_controller_out,
            read_data1_in => data_read1_reg_out,
            read_data2_in => data_read2_reg_out,
            immediate_value_in => "00000000000000000000000000000000",--TODO,
            write_address1_in => dst_fd_out,
            write_address2_in => src1_fd_out,
            write_back1_out => write_back1_de_out,
            mem_write_out => mem_write_de_out,
            mem_read_out => mem_read_de_out,
            alu_src_out => alu_src_de_out,
            alu_op => alu_op_de_out,
            mem_to_reg_out => mem_to_reg_de_out,
            read_data1_out => read_data1_de_out,
            read_data2_out => read_data2_de_out,
            immediate_value_out => immediate_value_de_out,
            write_address1_out => write_address1_de_out,
            write_address2_out => write_address2_de_out
            );

        
        alu1 : alu PORT MAP(
            A => read_data1_de_out,
            B => read_data2_de_out,
            sel => alu_op_de_out,
            F => alu_out,
            zeroFlag => zero_flag_alu_out,
            overflowFlag => overflow_flag_alu_out,
            negativeFlag => negative_flag_alu_out,
            carryFlag => carry_flag_alu_out
            );

        flag_register : my_nDFF GENERIC MAP(4) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => flag_register_in, 
            q => flag_register_out
            );

        execute_memory1 : execute_memory PORT MAP(
            Clk => clk,
            Rst => '0',
            write_back1_in => write_back1_de_out,
            mem_write_in => mem_write_de_out,
            mem_read_in => mem_read_de_out,
            mem_to_reg_in => mem_to_reg_de_out,
            write_address1_in => write_address1_de_out,
            write_address2_in => write_address2_de_out,
            alu_result_in => alu_out,
            read_data2_in => read_data2_de_out,
            write_back1_out => write_back1_em_out,
            mem_write_out => mem_write_em_out,
            mem_read_out => mem_read_em_out,
            mem_to_reg_out => mem_to_reg_em_out,
            read_data2_out => data_read2_em_out,
            alu_result_out => alu_em_out,
            write_address1_out => write_address1_em_out,
            write_address2_out => write_address2_em_out
            );
        
        memory1 : memory PORT MAP(
            clk => clk,
            memWrite => mem_write_em_out,
            memRead => mem_read_em_out,
            address => alu_em_out,
            datain => data_read2_em_out,
            dataout => memory_out
            );

        memory_wb1 : memory_wb PORT MAP(
            Clk => clk,
            Rst => '0',
            write_back1_in => write_back1_em_out,
            mem_to_reg_in => mem_to_reg_em_out,
            write_address1_in => write_address1_em_out,
            write_address2_in => write_address2_em_out,
            memory_data_in => memory_out,
            alu_result_in => alu_em_out,
            data_read2_in => data_read2_em_out,
            write_back1_out => write_back1_wb_out,
            mem_to_reg_out => mem_to_reg_wb_out,
            read_data2_out => data_read2_wb_out,
            alu_result_out => alu_result_wb_out,
            memory_data_out => memory_data_wb_out,
            write_address1_out => write_address1_wb_out,
            write_address2_out => write_address2_wb_out
            );

        

        

        

    


end harvard_cpu_arch;
