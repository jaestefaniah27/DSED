----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2024 13:02:56
-- Design Name: 
-- Module Name: gen_enables - Behavioral
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
entity gen_enables Is
    port (
       clk_12Mhz : in STD_LOGIC ;
       rst : in STD_LOGIC ;
       clk_3MHz : out STD_LOGIC ;
       en_2_cycles : out STD_LOGIC ;
       en_4_cycles : out STD_LOGIC);
    end gen_enables ;

architecture Behavioral of gen_enables is
type state_type is (S0, S1, S2, S3);
signal state, next_state : state_type;
begin
UPDATE: process(clk_12Mhz)
begin
    if rising_edge(clk_12Mhz) then
        state <= next_state;
    end if;
end process;

PROCESS_NEXT_STATE: process (state, rst)
begin 
next_state <= S0;
case(state) is
    when S0 =>
        if (rst = '1') then
            next_state <= S0;
        else
            next_state <= S1;
        end if;
    when S1 =>
        if (rst = '1') then
            next_state <= S0;
        else
            next_state <= S2;
        end if;
    when S2 =>
        if (rst = '1') then
            next_state <= S0;
        else
            next_state <= S3;
        end if;
    when S3 =>
        next_state <= S0;
end case;
end process;
    
OUTPUT_MOORE : process (state)
begin
case (state) is
    when S0 =>
        clk_3MHz <= '0';
        en_2_cycles <= '0';
        en_4_cycles <= '0';
    when S1 => 
        clk_3MHz <= '0';
        en_2_cycles <= '1';
        en_4_cycles <= '0';   
    when S2 => 
        clk_3MHz <= '1';
        en_2_cycles <= '0';
        en_4_cycles <= '1';     
    when S3 => 
        clk_3MHz <= '1';
        en_2_cycles <= '1';
        en_4_cycles <= '0'; 
end case;
end process;
end Behavioral;
