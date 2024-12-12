----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2024 12:39:17
-- Design Name: 
-- Module Name: simpleAudioSystem_tb - Behavioral
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

entity simpleAudioSystem_tb is
--  Port ( );
end simpleAudioSystem_tb;

architecture Behavioral of simpleAudioSystem_tb is
signal clk_100Mhz, rst, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm : std_logic;
CONSTANT clk_period : time := 10 ns;
SIGNAL rand_a, rand_b, rand_c : STD_LOGIC := '0';

begin
DUT : entity work.simpleAudioSystem(Behavioral) port map (
    clk_100Mhz => clk_100Mhz,
    rst => rst,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm
);

clk_process: process
    begin
        clk_100Mhz <= '1';
        wait for clk_period / 2;
        clk_100Mhz <= '0';
        wait for clk_period / 2;
    end process;

-- Proceso para generar pseudo-aleatoriedad en micro_data con más cambios
    pseudo_random_process: process
    begin
        -- Cambios en rand_a, rand_b, y rand_c en diferentes intervalos
        while true loop
            rand_a <= not rand_a after 30 us;
            rand_b <= not rand_b after 20 us;
            rand_c <= not rand_c after 33 us;
            wait for 6000 ns;

            rand_a <= not rand_a after 15 us;
            rand_b <= not rand_b after 33 us;
            rand_c <= not rand_c after 23 us;
            wait for 8000 ns;

            rand_a <= not rand_a after 40 us;
            rand_b <= not rand_b after 10 us;
            rand_c <= not rand_c after 13 us;
            wait for 10 us;
        end loop;
    end process;

    -- Asignación de micro_data como una combinación pseudo-aleatoria de las señales rand_a, rand_b y rand_c
    micro_data <= rand_a xor rand_b xor rand_c;
 
-- Proceso para simular el reset y observar las salidas
    stim_proc: process
    begin	
        -- Inicialización del reset
        rst <= '1';
        wait for 500 ns;
        rst <= '0';
        -- Esperar el tiempo suficiente para observar los cambios
        wait for 10 ms;
        
        wait;
    end process;

end Behavioral;
