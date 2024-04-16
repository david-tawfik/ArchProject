library ieee;
use ieee.std_logic_1164.all;

entity multiplexer is
    port (A,B: in std_logic_vector(15 downto 0);
    cin: in std_logic;
	sel: in std_logic_vector(3 downto 0);
	F: out std_logic_vector(15 downto 0);
	cout: out std_logic);
end entity multiplexer;

architecture multiplexer_arch of multiplexer is
    component partb is
        port (A,B: in std_logic_vector(15 downto 0);
        sel: in std_logic_vector(3 downto 0);
        F: out std_logic_vector(15 downto 0);
        cout: out std_logic);
    end component partb;

    component partc is
        port (A,B: in std_logic_vector(15 downto 0);
        cin: in std_logic;
        sel: in std_logic_vector(3 downto 0);
        F: out std_logic_vector(15 downto 0);
        cout: out std_logic);
    end component partc;

    component partd is
        port (A,B: in std_logic_vector(15 downto 0);
        cin: in std_logic;
        sel: in std_logic_vector(3 downto 0);
        F: out std_logic_vector(15 downto 0);
        cout: out std_logic);
    end component partd;

    signal Fb,Fc,Fd: std_logic_vector(15 downto 0);
    signal coutb,coutc,coutd: std_logic;
begin
    partb1: partb port map(A,B,sel,Fb,coutb);
    partc1: partc port map(A,B,cin,sel,Fc,coutc);
    partd1: partd port map(A,B,cin,sel,Fd,coutd);
    F<= Fb when sel(3 downto 2)="01" else
        Fc when sel(3 downto 2)="10" else
        Fd when sel(3 downto 2)="11";
        cout<= coutb when sel(3 downto 2)="01" else
        coutc when sel(3 downto 2)="10" else
        coutd when sel(3 downto 2)="11";


end multiplexer_arch