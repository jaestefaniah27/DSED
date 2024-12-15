----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2024 17:11:31
-- Design Name: 
-- Module Name: audioSystem - Behavioral
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

entity audioSystem is
    Port ( clk_100Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (1 downto 0);
           micro_lr : out STD_LOGIC;
           micro_data : in STD_LOGIC;
           jack_pwm : out STD_LOGIC;
           jack_sd : out STD_LOGIC;
           micro_clk : out STD_LOGIC);
end audioSystem;

architecture Behavioral of audioSystem is

begin


end Behavioral;
