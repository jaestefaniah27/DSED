----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 13:50:39
-- Design Name: 
-- Module Name: mux8_1 - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux8_1 is
    generic ( WIDTH : integer := 7) ;
    Port ( A : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           B : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           C : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           D : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           E : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           F : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           G : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           H : in STD_LOGIC_VECTOR (WIDTH - 1 downto 0);
           S : in STD_LOGIC_VECTOR  (2 downto 0);
           Y : out STD_LOGIC_VECTOR (WIDTH - 1 downto 0));
end mux8_1;

architecture Behavioral of mux8_1 is

begin
Y <=    A when S = "000" else
        B when S = "001" else
        C when S = "010" else
        D when S = "011" else
        E when S = "100" else
        F when S = "101" else
        G when S = "110" else
        H;
end Behavioral;
