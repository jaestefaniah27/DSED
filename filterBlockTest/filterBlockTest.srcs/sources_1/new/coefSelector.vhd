----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.11.2024 13:43:04
-- Design Name: 
-- Module Name: coefSelector - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity coefSelector is
  Port (
    filterSelect : in std_logic;
    c0, c1, c2, c3, c4 : out std_logic_vector(7 downto 0));
end coefSelector;

architecture Behavioral of coefSelector is

begin
process (filterSelect)
begin
case (filterSelect) is
    when '0' =>
        --     S  .  0    .    7
        c0 <= "0" & "0000101"; -- S.0.7 | 0.039 en 8 bits a complemento a 2 queda 00000101 = 0.0390625
        c1 <= "0" & "0011111"; -- S.0.7 | 0.2422 en 8 bits a complemento a 2 queda 00011111 = 0.2421875
        c2 <= "0" & "0111001"; -- S.0.7 | 0.4453 en 8 bits a complemento a 2 queda 00111001 = 0.4453125
        c3 <= "0" & "0011111"; -- igual q c1
        c4 <= "0" & "0000101"; -- igual q c0
    when others =>
        c0 <= "1" & "1111111"; -- S.0.7 | 0.-0.0078 en 8 bits a complemento a 2 queda 11111111 = -0.0078125
        c1 <= "1" & "1100110"; -- S.0.7 | 0.2422 en 8 bits a complemento a 2 queda 11100110 = -0.203125 
        c2 <= "0" & "1001101"; -- S.0.7 | 0.4453 en 8 bits a complemento a 2 queda 00111001 = 0.6015625
        c3 <= "1" & "1100110"; -- igual q c1
        c4 <= "1" & "1111111"; -- igual q c0
end case;
end process;
end Behavioral;
