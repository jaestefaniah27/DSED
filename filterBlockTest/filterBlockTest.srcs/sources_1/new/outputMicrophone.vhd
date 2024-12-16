----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2024 11:16:00
-- Design Name: 
-- Module Name: outputMicrophone - Behavioral
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

entity outputMicrophone is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end outputMicrophone;

architecture Behavioral of outputMicrophone is
signal r_reg, r_next : unsigned(8 downto 0);
signal buf_reg, buf_next : std_logic;
signal sample_req_aux, sample_req_aux_next : std_logic;
begin
--register and output buffer
process(clk_12Mhz, rst, en_2_cycles)
begin
if (rst = '1') then
    r_reg <= (others=>'0');
    buf_reg <= '0';
    sample_req_aux <= '0';
elsif rising_edge(clk_12Mhz) then
    sample_req_aux <= sample_req_aux_next;
    if (en_2_cycles = '1') then
        r_reg <= r_next;
        buf_reg <= buf_next;
    end if;
end if;
end process;
--next state logic
r_next <= (others=>'0') when (r_reg = 299) else r_reg + 1;
sample_req_aux_next <= '1' when (r_next = 0) else '0';
--output_logic
buf_next <=
    '1' when (r_reg < unsigned(sample_in)) else -- or (unsigned(sample_in) = 0)
    '0';
pwm_pulse <= buf_reg;
sample_request <= sample_req_aux when r_reg = 0 else '0';
end Behavioral;
