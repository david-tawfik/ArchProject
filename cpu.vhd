LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY cpu IS
    PORT (
        clk, reset, enable : IN STD_LOGIC);
END cpu;

ARCHITECTURE cpu_arch OF cpu IS
    COMPONENT integration IS
        PORT (
            clk, reset, enable : IN STD_LOGIC;
            read_address1, read_address2, write_address, op_code : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT integration;

    COMPONENT controller IS
        PORT (
            op_code : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            functionality : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            write_enable : OUT STD_LOGIC
        );
    END COMPONENT controller;

    COMPONENT register_file IS
        PORT (
            write_address1, read_address1, read_address2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            clk, write_enable1, reset : IN STD_LOGIC;
            data_write1 : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            data_read1, data_read2 : OUT STD_LOGIC_VECTOR(11 DOWNTO 0));
    END COMPONENT register_file;

    COMPONENT my_nDFF IS
        GENERIC (n : INTEGER := 16);
        PORT (
            Clk, Rst : IN STD_LOGIC;
            d : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            q : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0));
    END COMPONENT my_nDFF;

    COMPONENT multiplexer IS
        GENERIC (n : INTEGER := 12);
        PORT (
            A, B : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cin : IN STD_LOGIC;
            sel : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            F : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            cout : OUT STD_LOGIC);
    END COMPONENT multiplexer;

    SIGNAL read1, read2, write1, op : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL selector : STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL we_controller : STD_LOGIC;
    SIGNAL exec_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL trash : STD_LOGIC;
    SIGNAL data_write_back, data_reg_file1, data_reg_file2 : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL q : STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal temp1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal temp2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    temp1 <= selector & we_controller & data_reg_file1 & data_reg_file2 & write1;
    temp2 <= exec_out(27) & data_write_back & exec_out(2 DOWNTO 0);
    U1 : integration PORT MAP(clk, reset, enable, read1, read2, write1, op);
    U2 : controller PORT MAP(op, selector, we_controller);
    U3 : register_file PORT MAP(q(2 DOWNTO 0), read1, read2, clk, q(15), reset, q(14 DOWNTO 3), data_reg_file1, data_reg_file2);
    U4 : my_nDFF GENERIC MAP(32) PORT MAP(clk, reset, temp1, exec_out);
    U5 : multiplexer GENERIC MAP(12) PORT MAP(exec_out(26 DOWNTO 15), exec_out(14 DOWNTO 3), '0',exec_out(31 downto 28), data_write_back, trash);
    U6 : my_nDFF GENERIC MAP(16) PORT MAP(clk, reset, temp2, q);

END cpu_arch;