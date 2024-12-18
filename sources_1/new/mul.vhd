----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 12:36:42
-- Design Name: 
-- Module Name: mul - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul is
    Port (  clk_12Mhz : in std_logic;
            rst : in std_logic;
            in_1 : in STD_LOGIC_VECTOR (7 downto 0);
            in_2 : in STD_LOGIC_VECTOR (7 downto 0);
            mul_o : out STD_LOGIC_VECTOR (17 downto 0));
end mul;

architecture Behavioral of mul is
signal in_1_signed, in_2_signed : signed(7 downto 0);
signal mul_out_signed : signed(15 downto 0);
signal r0_reg, r1_reg, r0_next, r1_next : std_logic_vector(17 downto 0);
begin
--next state logic
in_1_signed <= signed(in_1);
in_2_signed <= signed(in_2);
mul_out_signed <= in_1_signed * in_2_signed;
r0_next <= std_logic_vector(resize(mul_out_signed, 18));
r1_next <= r0_reg;
--reg
process (clk_12Mhz, rst)
begin
if rising_edge(clk_12Mhz) then 
    if rst = '1' then
        r0_reg <= (others=>'0');
        r1_reg <= (others=>'0');
    else
        r0_reg <= r0_next;
        r1_reg <= r1_next;
    end if;
end if;
end process;
--output
mul_o <= r1_reg;

end Behavioral;
