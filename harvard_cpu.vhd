LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY harvard_cpu IS
    PORT (
        clk, reset : IN STD_LOGIC;
        InputPort : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        OutPort : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        pcCounter : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END harvard_cpu;

ARCHITECTURE harvard_cpu_arch OF harvard_cpu IS
    -- COMPONENT pc
    --     PORT (
    --         clk, reset : IN STD_LOGIC;
    --         pcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    --         count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    --     );
    -- END COMPONENT;

    COMPONENT pcNew
        PORT (
            clk : IN STD_LOGIC;
            pcIn : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            count : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT pcAdder
        PORT (
            in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            out1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT cache IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT cache;

    COMPONENT fetch_decode IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            instruction : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            InputPort_to_FD : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            InputPort_from_FD_to_DE : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            op_code : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
            dst, src1, src2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT fetch_decode;

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
            writeBack1, writeBack2, memRead, memWrite, zero_we, overflow_we, negative_we, carry_we, outputPort_enable, in_op : OUT STD_LOGIC;
            WB_data_src : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            memInReg : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            aluSrc : OUT STD_LOGIC
        );
    END COMPONENT controller;

    COMPONENT decode_execute IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
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
            write_back1_out, write_back2_out, mem_write_out, mem_read_out, alu_src_out, zero_we_out, overflow_we_out, negative_we_out, carry_we_out : OUT STD_LOGIC;
            alu_op : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            mem_to_reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            read_data1_out, read_data2_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            immediate_value_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            InputPort_from_DE_to_EM : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            WB_data_src_from_DE_to_EM : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            OutPort_en_from_DE_to_EM : OUT STD_LOGIC;
            in_op_from_DE_to_EM : OUT STD_LOGIC;
            src1_address_EX, src2_address_EX, write_address1_out, write_address2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT decode_execute;

    COMPONENT alu IS
        PORT (
            A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            zeroFlag, overflowFlag, negativeFlag, carryFlag : OUT STD_LOGIC
        );
    END COMPONENT alu;

    COMPONENT flag_register IS
        PORT (
            clk, zero_we, overflow_we, negative_we, carry_we, reset : IN STD_LOGIC;
            zero, overflow, negative, carry : IN STD_LOGIC
        );
    END COMPONENT flag_register;

    COMPONENT execute_memory IS
        PORT (
            Clk, Rst : IN STD_LOGIC;
            write_back1_in, write_back2_in, mem_write_in, mem_read_in : IN STD_LOGIC;
            mem_to_reg_in : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            write_address1_in, write_address2_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            alu_result_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            read_data2_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            zero_in, negative_in, overflow_in, carry_in : IN STD_LOGIC;
            InputPort_from_DE_to_EM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            WB_data_src_from_DE_to_EM : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            OutPort_en_from_DE_to_EM : IN STD_LOGIC;
            in_op_from_DE_to_EM : IN STD_LOGIC;

            InputPort_from_EM_to_MWB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_back1_out, write_back2_out, mem_write_out, mem_read_out : OUT STD_LOGIC;
            mem_to_reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            read_data2_out, alu_result_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_address1_out, write_address2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            zero_out, negative_out, overflow_out, carry_out : OUT STD_LOGIC;
            WB_data_src_from_EM_to_MWB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            OutPort_en_from_EM_to_MWB : OUT STD_LOGIC;
            in_op_from_EM_to_MWB : OUT STD_LOGIC
        );
    END COMPONENT execute_memory;
    COMPONENT memory IS
        PORT (
            clk : IN STD_LOGIC;
            memWrite : IN STD_LOGIC;
            memRead : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            datain : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT memory_wb IS
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

            InputPort_from_MWB : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_back1_out : OUT STD_LOGIC;
            write_back2_out : OUT STD_LOGIC;
            mem_to_reg_out : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            read_data2_out, alu_result_out, memory_data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            write_address1_out, write_address2_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            WB_data_src_from_MWB : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
            zero_out, negative_out, overflow_out, carry_out : OUT STD_LOGIC;
            in_op_from_MWB : OUT STD_LOGIC;
            Outport_en_from_MWB : OUT STD_LOGIC
        );
    END COMPONENT memory_wb;

    COMPONENT mux2x1 IS
        GENERIC (
            DATA_WIDTH : INTEGER := 16
        );
        PORT (
            in0, in1 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            sel : IN STD_LOGIC;
            out1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT mux2x1;

    COMPONENT mux4 IS
        GENERIC (
            DATA_WIDTH : INTEGER := 16
        );
        PORT (
            in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
            out1 : OUT STD_LOGIC_VECTOR (DATA_WIDTH - 1 DOWNTO 0)
        );
    END COMPONENT mux4;

    COMPONENT outputPort IS
        PORT (
            enable : IN STD_LOGIC;
            data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT outputPort;

    COMPONENT forwardcheckingunit IS
        PORT (
            src1_address_EX, src2_address_EX : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            Dst1_address_MEM, Dst2_address_MEM, Dst1_address_WB, Dst2_address_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            alu_out_MEM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            alu_out_WB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            InputPort_from_EM_to_MWB, InputPort_from_MWB : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            WB1_MEM, WB2_MEM, WB1_WB, WB2_WB : IN STD_LOGIC;
            in_op_from_EM, in_op_from_MWB : IN STD_LOGIC;
            src2_data_mem, src2_data_wb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            forwarded_value1, forwarded_value2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            forward_sel1 : OUT STD_LOGIC;
            forward_sel2 : OUT STD_LOGIC

        );
    END COMPONENT forwardcheckingunit;

    SIGNAL pcOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL resetMuxOut : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instruction_cache_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL opcode_fd_out : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL dst_fd_out, src1_fd_out, src2_fd_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL alu_op_controller_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL write_back_controller_out, mem_read_controller_out, mem_write_controller_out : STD_LOGIC;
    SIGNAL mem_to_reg_controller_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL alu_src_controller_out : STD_LOGIC;
    SIGNAL data_read1_reg_out, data_read2_reg_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_back1_controller_out, write_back2_controller_out : STD_LOGIC;
    SIGNAL write_address1_de_out, write_address2_de_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL write_back1_de_out, write_back2_de_out, mem_write_de_out, mem_read_de_out, alu_src_de_out : STD_LOGIC;
    SIGNAL alu_op_de_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL mem_to_reg_de_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL read_data1_de_out, read_data2_de_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL immediate_value_de_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL alu_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero_flag_alu_out, overflow_flag_alu_out, negative_flag_alu_out, carry_flag_alu_out : STD_LOGIC;
    SIGNAL flag_register_in, flag_register_out : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL write_address1_em_out, write_address2_em_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL write_back1_em_out, write_back2_em_out, mem_write_em_out, mem_read_em_out, alu_src_em_out : STD_LOGIC;
    SIGNAL alu_em_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL data_read2_em_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memory_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL write_address1_wb_out, write_address2_wb_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL write_back1_wb_out, write_back2_wb_out : STD_LOGIC;
    SIGNAL mem_to_reg_wb_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL data_read2_wb_out, alu_result_wb_out, memory_data_wb_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL dst_em_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL dst2_em_out : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL mem_to_reg_em_out : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL fd_reset : STD_LOGIC;
    SIGNAL alu_src2_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL immediate_value_de_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL zero_em_out, negative_em_out, overflow_em_out, carry_em_out : STD_LOGIC;
    SIGNAL zero_wb_out, negative_wb_out, overflow_wb_out, carry_wb_out : STD_LOGIC;
    SIGNAL zero_wb_controller_out, overflow_wb_controller_out, negative_wb_controller_out, carry_wb_controller_out : STD_LOGIC;
    SIGNAL zero_wb_de_out, overflow_wb_de_out, negative_wb_de_out, carry_wb_de_out : STD_LOGIC;
    SIGNAL pcplus1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memAddressIn : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL memReadIn : STD_LOGIC;
    SIGNAL WB_data_src_from_C_to_DE : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_data_src_from_DE_to_EM : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_data_src_from_EM_to_MWB : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL WB_data_src_from_MWB : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL InputPort_from_FD_to_DE, InputPort_from_DE_to_EM, InputPort_from_EM_to_MWB, InputPort_from_MWB : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL WB1_data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL outputport_en_to_DE, outport_en_from_DE_to_EM, outport_en_from_EM_to_MWB, outport_en_from_MWB : STD_LOGIC;
    SIGNAL forwarded_value1, forwarded_value2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL forward_sel1, forward_sel2 : STD_LOGIC;
    SIGNAL src1_address_EX, src2_address_EX : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL alu_src1_after_mux, alu_src2_after_mux : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_op_from_C_to_DE, in_op_from_DE_to_EM, in_op_from_EM : STD_LOGIC;
    SIGNAL in_op_from_MWB : STD_LOGIC;

BEGIN
    reset2x1MuxBeforePc : mux2x1 GENERIC MAP(
        32) PORT MAP(
        in0 => pcplus1,
        in1 => memory_out,
        sel => reset,
        out1 => resetMuxOut
    );

    pcCounter <= pcOut;

    pc1 : pcNew PORT MAP(
        clk => clk,
        pcIn => resetMuxOut,
        count => pcOut
    );

    pcAdder1 : pcAdder PORT MAP(
        in1 => pcOut,
        out1 => pcplus1
    );

    flag_register_in <= zero_flag_alu_out & overflow_flag_alu_out & negative_flag_alu_out & carry_flag_alu_out;

    instruction_memory : cache PORT MAP(
        clk => clk,
        rst => reset,
        address => pcOut,
        dataout => instruction_cache_out
    );

    fetch_decode1 : fetch_decode PORT MAP(
        Clk => clk,
        Rst => fd_reset,
        instruction => instruction_cache_out,
        op_code => opcode_fd_out,
        dst => dst_fd_out,
        src1 => src1_fd_out,
        src2 => src2_fd_out,
        InputPort_to_FD => InputPort,
        InputPort_from_FD_to_DE => InputPort_from_FD_to_DE
    );
    fd_reset <= '1' WHEN opcode_fd_out(5 DOWNTO 4) = "01" OR reset = '1' ELSE
        '0';
    controller1 : controller PORT MAP(
        opCode => opcode_fd_out,
        aluOp => alu_op_controller_out,
        writeBack1 => write_back1_controller_out,
        writeBack2 => write_back2_controller_out,
        memRead => mem_read_controller_out,
        memWrite => mem_write_controller_out,
        zero_we => zero_wb_controller_out,
        overflow_we => overflow_wb_controller_out,
        negative_we => negative_wb_controller_out,
        carry_we => carry_wb_controller_out,
        memInReg => mem_to_reg_controller_out,
        aluSrc => alu_src_controller_out,
        WB_data_src => WB_data_src_from_C_to_DE,
        outputPort_enable => outputport_en_to_DE,
        in_op => in_op_from_C_to_DE
    );

    register_file1 : register_file PORT MAP(
        write_address1 => write_address1_wb_out,
        write_address2 => write_address2_wb_out,
        read_address1 => src1_fd_out,
        read_address2 => src2_fd_out,
        clk => clk,
        write_enable1 => write_back1_wb_out,
        write_enable2 => write_back2_wb_out,
        reset => '0',
        data_write1 => WB1_data,
        data_write2 => data_read2_wb_out,
        data_read1 => data_read1_reg_out,
        data_read2 => data_read2_reg_out
    );
    immediate_value_de_in <= "0000000000000000" & instruction_cache_out WHEN instruction_cache_out(15) = '0'
        ELSE
        "1111111111111111" & instruction_cache_out;

    decode_execute1 : decode_execute PORT MAP(
        Clk => clk,
        Rst => reset,
        write_back1_in => write_back1_controller_out,
        mem_write_in => mem_write_controller_out,
        mem_read_in => mem_read_controller_out,
        alu_src_in => alu_src_controller_out,
        zero_we_in => zero_wb_controller_out,
        overflow_we_in => overflow_wb_controller_out,
        negative_we_in => negative_wb_controller_out,
        carry_we_in => carry_wb_controller_out,
        mem_to_reg_in => mem_to_reg_controller_out,
        alu_op_in => alu_op_controller_out,
        read_data1_in => data_read1_reg_out,
        read_data2_in => data_read2_reg_out,
        immediate_value_in => immediate_value_de_in,
        write_address1_in => dst_fd_out,
        write_address2_in => src1_fd_out,
        write_back1_out => write_back1_de_out,
        mem_write_out => mem_write_de_out,
        mem_read_out => mem_read_de_out,
        alu_src_out => alu_src_de_out,
        zero_we_out => zero_wb_de_out,
        overflow_we_out => overflow_wb_de_out,
        negative_we_out => negative_wb_de_out,
        carry_we_out => carry_wb_de_out,
        alu_op => alu_op_de_out,
        mem_to_reg_out => mem_to_reg_de_out,
        read_data1_out => read_data1_de_out,
        read_data2_out => read_data2_de_out,
        immediate_value_out => immediate_value_de_out,
        write_address1_out => write_address1_de_out,
        write_address2_out => write_address2_de_out,
        InputPort_from_FD_to_DE => InputPort_from_FD_to_DE,
        InputPort_from_DE_to_EM => InputPort_from_DE_to_EM,
        WB_data_src_to_DE => WB_data_src_from_C_to_DE,
        WB_data_src_from_DE_to_EM => WB_data_src_from_DE_to_EM,
        OutPort_en_to_DE => outputport_en_to_DE,
        OutPort_en_from_DE_to_EM => outport_en_from_DE_to_EM,
        src1_address_in => src1_fd_out,
        src2_address_in => src2_fd_out,
        src1_address_EX => src1_address_EX,
        src2_address_EX => src2_address_EX,
        in_op_from_C_to_DE => in_op_from_C_to_DE,
        in_op_from_DE_to_EM => in_op_from_DE_to_EM,
        write_back2_in => write_back2_controller_out,
        write_back2_out => write_back2_de_out

    );

    alu_src2_in <= read_data2_de_out WHEN alu_src_de_out = '0' ELSE
        immediate_value_de_out;
    alusrc1mux : mux2x1 GENERIC MAP(
        32) PORT MAP(
        in0 => read_data1_de_out,
        in1 => forwarded_value1,
        sel => forward_sel1,
        out1 => alu_src1_after_mux
    );
    alusrc2mux : mux2x1 GENERIC MAP(
        32) PORT MAP(
        in0 => alu_src2_in,
        in1 => forwarded_value2,
        sel => forward_sel2,
        out1 => alu_src2_after_mux
    );

    alu1 : alu PORT MAP(
        A => alu_src1_after_mux,
        B => alu_src2_after_mux,
        sel => alu_op_de_out,
        F => alu_out,
        zeroFlag => zero_flag_alu_out,
        overflowFlag => overflow_flag_alu_out,
        negativeFlag => negative_flag_alu_out,
        carryFlag => carry_flag_alu_out
    );

    flag_register1 : flag_register PORT MAP(
        clk => clk,
        zero_we => zero_wb_de_out,
        overflow_we => overflow_wb_de_out,
        negative_we => negative_wb_de_out,
        carry_we => carry_wb_de_out,
        reset => reset,
        zero => zero_flag_alu_out,
        overflow => overflow_flag_alu_out,
        negative => negative_flag_alu_out,
        carry => carry_flag_alu_out
    );

    forwardcheckingunit1 : forwardcheckingunit PORT MAP(
        src1_address_EX => src1_address_EX,
        src2_address_EX => src2_address_EX,
        Dst1_address_MEM => write_address1_em_out,
        Dst2_address_MEM => write_address2_em_out,
        Dst1_address_WB => write_address1_wb_out,
        Dst2_address_WB => write_address2_wb_out,
        alu_out_MEM => alu_em_out,
        alu_out_WB => alu_result_wb_out,
        WB1_MEM => write_back1_em_out,
        WB2_MEM => write_back2_em_out,
        WB1_WB => write_back1_wb_out,
        WB2_WB => write_back2_wb_out,
        forwarded_value1 => forwarded_value1,
        forwarded_value2 => forwarded_value2,
        forward_sel1 => forward_sel1,
        forward_sel2 => forward_sel2,
        InputPort_from_EM_to_MWB => InputPort_from_EM_to_MWB,
        InputPort_from_MWB => InputPort_from_MWB,
        in_op_from_EM => in_op_from_EM,
        in_op_from_MWB => in_op_from_MWB,
        src2_data_mem => data_read2_em_out,
        src2_data_wb => data_read2_wb_out
    );

    execute_memory1 : execute_memory PORT MAP(
        Clk => clk,
        Rst => reset,
        write_back1_in => write_back1_de_out,
        write_back2_in => write_back2_de_out,
        mem_write_in => mem_write_de_out,
        mem_read_in => mem_read_de_out,
        mem_to_reg_in => mem_to_reg_de_out,
        write_address1_in => write_address1_de_out,
        write_address2_in => write_address2_de_out,
        alu_result_in => alu_out,
        read_data2_in => alu_src2_after_mux,
        zero_in => zero_flag_alu_out,
        negative_in => negative_flag_alu_out,
        overflow_in => overflow_flag_alu_out,
        carry_in => carry_flag_alu_out,
        write_back1_out => write_back1_em_out,
        write_back2_out => write_back2_em_out,
        mem_write_out => mem_write_em_out,
        mem_read_out => mem_read_em_out,
        mem_to_reg_out => mem_to_reg_em_out,
        read_data2_out => data_read2_em_out,
        alu_result_out => alu_em_out,
        write_address1_out => write_address1_em_out,
        write_address2_out => write_address2_em_out,
        zero_out => zero_em_out,
        negative_out => negative_em_out,
        overflow_out => overflow_em_out,
        carry_out => carry_em_out,
        InputPort_from_DE_to_EM => InputPort_from_DE_to_EM,
        InputPort_from_EM_to_MWB => InputPort_from_EM_to_MWB,
        WB_data_src_from_DE_to_EM => WB_data_src_from_DE_to_EM,
        WB_data_src_from_EM_to_MWB => WB_data_src_from_EM_to_MWB,
        OutPort_en_from_DE_to_EM => outport_en_from_DE_to_EM,
        OutPort_en_from_EM_to_MWB => outport_en_from_EM_to_MWB,
        in_op_from_DE_to_EM => in_op_from_DE_to_EM,
        in_op_from_EM_to_MWB => in_op_from_EM

    );

    resetMuxforMemAddress : mux2x1 GENERIC MAP(
        32) PORT MAP(
        in0 => alu_em_out,
        in1 => "00000000000000000000000000000000",
        sel => reset,
        out1 => memAddressIn
    );

    memReadIn <= mem_read_em_out OR reset;

    memory1 : memory PORT MAP(
        clk => clk,
        memWrite => mem_write_em_out,
        memRead => memReadIn,
        address => memAddressIn,
        datain => data_read2_em_out,
        dataout => memory_out
    );

    memory_wb1 : memory_wb PORT MAP(
        Clk => clk,
        Rst => reset,
        write_back1_in => write_back1_em_out,
        write_back2_in => write_back2_em_out,
        mem_to_reg_in => mem_to_reg_em_out,
        write_address1_in => write_address1_em_out,
        write_address2_in => write_address2_em_out,
        memory_data_in => memory_out,
        alu_result_in => alu_em_out,
        data_read2_in => data_read2_em_out,
        zero_in => zero_em_out,
        negative_in => negative_em_out,
        overflow_in => overflow_em_out,
        carry_in => carry_em_out,
        write_back1_out => write_back1_wb_out,
        write_back2_out => write_back2_wb_out,
        mem_to_reg_out => mem_to_reg_wb_out,
        read_data2_out => data_read2_wb_out,
        alu_result_out => alu_result_wb_out,
        memory_data_out => memory_data_wb_out,
        write_address1_out => write_address1_wb_out,
        write_address2_out => write_address2_wb_out,
        zero_out => zero_wb_out,
        negative_out => negative_wb_out,
        overflow_out => overflow_wb_out,
        carry_out => carry_wb_out,
        InputPort_from_EM_to_MWB => InputPort_from_EM_to_MWB,
        InputPort_from_MWB => InputPort_from_MWB,
        WB_data_src_from_EM_to_MWB => WB_data_src_from_EM_to_MWB,
        WB_data_src_from_MWB => WB_data_src_from_MWB,
        OutPort_en_from_EM_to_MWB => outport_en_from_EM_to_MWB,
        Outport_en_from_MWB => outport_en_from_MWB,
        in_op_from_EM_to_MWB => in_op_from_EM,
        in_op_from_MWB => in_op_from_MWB
    );

    WB_data_src_mux : mux4 GENERIC MAP(
        32) PORT MAP(
        in0 => memory_data_wb_out,
        in1 => alu_result_wb_out,
        in2 => InputPort_from_MWB,
        in3 => InputPort_from_MWB,
        sel => WB_data_src_from_MWB,
        out1 => WB1_data
    );

    outputPort1 : outputPort PORT MAP(
        enable => outport_en_from_MWB,
        data_in => alu_result_wb_out,
        data_out => OutPort
    );
END harvard_cpu_arch;