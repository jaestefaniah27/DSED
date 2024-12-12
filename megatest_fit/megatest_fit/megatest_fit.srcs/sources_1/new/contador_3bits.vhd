----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2024 12:13:24
-- Design Name: 
-- Module Name: contador_3bits - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador_3bits is
    Port ( clk       : in  STD_LOGIC;
           rst       : in  STD_LOGIC;
           sen       : in  STD_LOGIC;
           mux_sel   : out STD_LOGIC_VECTOR(2 downto 0);
           sample_out_ready : out std_logic);
end contador_3bits;

architecture Behavioral of contador_3bits is
    signal r_reg, r_next: std_logic_vector(2 downto 0);
    signal sample_out_ready_reg, sample_out_ready_next : std_logic;
    signal count_enable_reg, count_enable_next: std_logic;
begin
--reg
    process(clk, rst, sen)
    begin
        if rst = '1' then
            r_reg <= "000"; -- Reset asincrónico
            count_enable_reg <= '0';
            sample_out_ready_reg <= '0';
        elsif rising_edge(clk) then
            if sen = '1' then
                count_enable_reg <= '1';
            else
                r_reg <= r_next;
                count_enable_reg <= count_enable_next;
                sample_out_ready_reg <= sample_out_ready_next;
            end if;
        end if;
    end process;
--next state logic 
count_enable_next <= '0' when r_reg = "110" else count_enable_reg;
r_next <=   r_reg + 1 when count_enable_reg = '1' else
            "000" when r_reg="111" 
            else r_reg;
sample_out_ready_next <= '1' when r_reg = "111" else '0'; -- cuidao
--output logic
mux_sel <= r_reg;
sample_out_ready <= sample_out_ready_reg;
end Behavioral;
