----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 13:41:32
-- Design Name: 
-- Module Name: fir5stage - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.packageDSED.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir5stage is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           s0 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s1 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s2 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s3 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s4 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sen : in STD_LOGIC;
           c0 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           c1 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           c2 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           c3 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           c4 : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_out_ready : out STD_LOGIC);
end fir5stage;

architecture Behavioral of fir5stage is
signal r1_reg, r2_reg, r1_next, r2_next : std_logic_vector((sample_size - 1) * 2 + 3 downto 0); --17 downto 0
signal mul_in_1, mul_in_2 : std_logic_vector(sample_size - 1 downto 0);
signal mul_o : std_logic_vector((sample_size - 1) * 2 + 3 downto 0);
signal sum_o: signed((sample_size - 1) * 2 + 3 downto 0);
--signal counter_en : std_logic;
signal mux_sel : std_logic_vector(2 downto 0);

component contador_3bits is
        Port (
            clk_12Mhz              : in std_logic;
            rst              : in std_logic;
            sen              : in std_logic;
            mux_sel          : out std_logic_vector(2 downto 0);
            sample_out_ready : out std_logic
        );
    end component;

    component mul is
        Port (
            clk_12Mhz   : in std_logic;
            rst   : in std_logic;
            in_1  : in std_logic_vector(7 downto 0);
            in_2  : in std_logic_vector(7 downto 0);
            mul_o : out std_logic_vector(17 downto 0)
        );
    end component;

    component mux8_1 is
        generic ( WIDTH : integer := 8 );
        Port (
            A : in  std_logic_vector(WIDTH-1 downto 0);
            B : in  std_logic_vector(WIDTH-1 downto 0);
            C : in  std_logic_vector(WIDTH-1 downto 0);
            D : in  std_logic_vector(WIDTH-1 downto 0);
            E : in  std_logic_vector(WIDTH-1 downto 0);
            F : in  std_logic_vector(WIDTH-1 downto 0);
            G : in  std_logic_vector(WIDTH-1 downto 0);
            H : in  std_logic_vector(WIDTH-1 downto 0);
            S : in  std_logic_vector(2 downto 0);
            Y : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;


begin
--reg
process (clk_12Mhz, rst)
begin
if rising_edge(clk_12Mhz) then 
    if rst = '1' then
        r1_reg <= (others=>'0');
        r2_reg <= (others=>'0');
    else
        r1_reg <= r1_next;
        r2_reg <= r2_next;
    end if;
end if;
end process;

r2_next <= mul_o;

sum_o <= signed(r1_reg) + signed(r2_reg);
--sample_out <= std_logic_vector(resize(SIGNED(r1_reg), 8));
sample_out <= r1_reg(17) & r1_reg(13 downto 7); --r1_reg(17)
COUNTER: contador_3bits port map (
    clk_12Mhz => clk_12Mhz,
    rst => rst,
    sen => sen,
    mux_sel => mux_sel,
    sample_out_ready => sample_out_ready);

MULTIPLIER: mul port map(
    clk_12Mhz => clk_12Mhz,
    rst => rst,
    in_1 => mul_in_1,
    in_2 => mul_in_2,
    mul_o => mul_o);

MUX1: mux8_1
generic map (WIDTH => 8)
port map (
    A => c0,
    B => c1,
    C => c2,
    D => c3,
    E => c4,
    F => (others=>'0'),
    G => (others=>'0'),
    H => (others=>'0'),
    S => mux_sel,
    Y => mul_in_1);

MUX2: mux8_1
generic map (WIDTH => 8)
port map (
    A => s0,
    B => s1,
    C => s2,
    D => s3,
    E => s4,
    F => (others=>'0'),
    G => (others=>'0'),
    H => (others=>'0'),
    S => mux_sel,
    Y => mul_in_2);

MUX3: mux8_1
generic map (WIDTH => 18)
port map (
    A => r1_reg,
    B => mul_o,
    C => r1_reg,
    D => std_logic_vector(sum_o),
    E => std_logic_vector(sum_o),
    F => std_logic_vector(sum_o),
    G => std_logic_vector(sum_o),
    H => std_logic_vector(sum_o),
    S => mux_sel,
    Y => r1_next);
    
end Behavioral;
