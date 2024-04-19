LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY harvard_cpu IS
    PORT (
        clk : IN STD_LOGIC;
        pcCounter : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
END harvard_cpu;

architecture harvard_cpu_arch OF harvard_cpu IS
    component pc
        PORT (
            clk : IN STD_LOGIC;
            pcIn : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            count : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
            );
    END component;

    component ram is
        PORT(
            clk : IN std_logic;
            we  : IN std_logic;
            address : IN  std_logic_vector(5 DOWNTO 0);
            datain  : IN  std_logic_vector(15 DOWNTO 0);
            dataout : OUT std_logic_vector(15 DOWNTO 0)
            );
    END component ram;

    component my_nDFF is
		GENERIC ( n : integer := 16);
		PORT(	Clk,Rst : IN std_logic;
			d : IN std_logic_vector(n-1 DOWNTO 0);
			q : OUT std_logic_vector(n-1 DOWNTO 0));
    END component my_nDFF;

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

    component alu is
        PORT (
            A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            zeroFlag, overflowFlag, negativeFlag, carryFlag : OUT STD_LOGIC
        );
    END component alu;

    component memory IS
	PORT(
		clk : IN std_logic;
		memWrite,memRead  : IN std_logic;
		address : IN  std_logic_vector(31 DOWNTO 0);
		datain  : IN  std_logic_vector(31 DOWNTO 0);
		dataout : OUT std_logic_vector(31 DOWNTO 0));
    END component;
    signal pcIn : std_logic_vector(31 DOWNTO 0);
    signal count : std_logic_vector(31 DOWNTO 0);
    signal instruction : std_logic_vector(15 DOWNTO 0);
    signal fetch_decode_out : std_logic_vector(15 DOWNTO 0);
    signal writeBack1, memRead, memWrite : std_logic;
    signal memInReg : std_logic_vector(1 DOWNTO 0);
    signal aluSrc : std_logic;
    signal data_write1, data_write2 : std_logic_vector(31 DOWNTO 0);
    signal data_read1, data_read2 : std_logic_vector(31 DOWNTO 0);
    signal aluOp : std_logic_vector(3 DOWNTO 0);
    signal decode_execute_out : std_logic_vector(111 DOWNTO 0);
    signal value : std_logic_vector(31 DOWNTO 0);
    signal zeroFlag, overflowFlag, negativeFlag, carryFlag : std_logic;
    signal flag : std_logic_vector(3 DOWNTO 0);
    signal write_address1, write_address2 : std_logic_vector(2 DOWNTO 0);
    signal result : std_logic_vector(31 DOWNTO 0);
    signal execute_memory_out : std_logic_vector(78 DOWNTO 0);
    signal memory_out : std_logic_vector(31 DOWNTO 0);
    signal memory_wb_out : std_logic_vector(102 DOWNTO 0);

    begin
        pc1 : pc PORT MAP(clk,pcIn,count);

        instruction_memory : ram PORT MAP(clk, '0', count, instruction);

        fetch_decode : my_nDFF GENERIC MAP(16) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => instruction, 
            q => fetch_decode_out
            );

        controller1 : controller PORT MAP(
            opCode => fetch_decode_out(15 downto 10),
            aluOp => aluOp,
            writeBack1 => writeBack1,
            memRead => memRead,
            memWrite => memWrite,
            memInReg => memInReg,
            aluSrc => aluSrc
            );

        register_file1 : register_file PORT MAP(
            write_address1 => fetch_decode_out(9 downto 7), 
            write_address2 => fetch_decode_out(6 downto 4),
            read_address1 => fetch_decode_out(6 downto 4),
            read_address2 => fetch_decode_out(3 downto 1),
            clk => clk,
            write_enable1 => memory_wb_out(102),
            write_enable2 => '0',
            reset => '0',
            data_write1 => memory_wb_out(69 downto 38),
            data_write2 => '00000000000000000000000000000000',
            data_read1 => data_read1,
            data_read2 => data_read2
            );

        decode_execute : my_nDFF GENERIC MAP(112) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => aluOp & writeBack1 & memRead & memWrite & memInReg & aluSrc & data_read1 & data_read2 & value & write_address1 & write_address2, 
            q => decode_execute_out
            );
        
        alu1 : alu PORT MAP(
            A => decode_execute_out(101 downto 70),
            B => decode_execute_out(69 downto 38),
            sel => decode_execute_out(111 downto 108),
            F => result,
            zeroFlag => zeroFlag,
            overflowFlag => overflowFlag,
            negativeFlag => negativeFlag,
            carryFlag => carryFlag
            );

        flag_register : my_nDFF GENERIC MAP(4) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => zeroFlag & overflowFlag & negativeFlag & carryFlag, 
            q => flag
            );

        execute_memory : my_nDFF GENERIC MAP(79) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => decode_execute_out(107 downto 103) & flag & result & decode_execute_out(37 downto 0), 
            q => execute_memory_out
            );
        
        memory1 : memory PORT MAP(
            clk => clk,
            memWrite => execute_memory_out(76),
            memRead => execute_memory_out(77),
            address => execute_memory_out(69 downto 38),
            datain => execute_memory_out(37 downto 6),
            dataout => memory_out
            );

        memory_wb : my_nDFF GENERIC MAP(103) PORT MAP(
            Clk => clk, 
            Rst => '0',
            d => execute_memory_out(102) & memory_out & execute_memory_out(69 downto 0), 
            q => memory_wb_out
            );

        

        

        

    


end harvard_cpu_arch;
