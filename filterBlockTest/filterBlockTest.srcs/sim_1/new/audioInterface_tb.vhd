----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2024 00:42:49
-- Design Name: 
-- Module Name: audioInterface_tb - Behavioral
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

entity audioInterface_tb is
--  Port ( );
end audioInterface_tb;

architecture Behavioral of audioInterface_tb is
signal clk_12Mhz, rst, record_enable, sample_out_ready, micro_clk, micro_data, micro_LR, play_enable, sample_request, jack_sd, jack_pwm : std_logic;
signal sample_out, sample_in : std_logic_vector (sample_size - 1 downto 0);

CONSTANT clk_period : time := 83.33 ns;
SIGNAL rand_a : STD_LOGIC := '0';
SIGNAL rand_b : STD_LOGIC := '0';
SIGNAL rand_c : STD_LOGIC := '0';
begin
DUT : entity work.audioInterface(Behavioral) port map (
    clk_12Mhz => clk_12Mhz,
    rst => rst,
    record_enable => record_enable,
    sample_out => sample_out,
    sample_out_ready => sample_out_ready,
    micro_clk => micro_clk,
    micro_data => micro_data,
    micro_LR => micro_LR,
    play_enable => play_enable,
    sample_in => sample_in,
    sample_request => sample_request,
    jack_sd => jack_sd,
    jack_pwm => jack_pwm);

-- Generación del reloj de 12 MHz
    clk_process: process
    begin
        clk_12Mhz <= '1';
        wait for clk_period / 2;
        clk_12Mhz <= '0';
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
        record_enable <= '0';
        play_enable <= '0';
        sample_in <= (others=>'0');
        wait for 500 ns;
        rst <= '0';
        wait for 300 us;
        record_enable <= '1';
        -- Esperar el tiempo suficiente para observar los cambios
        wait for 4000 us;
        record_enable <= '0';
        wait for 300 us;
        play_enable <= '1';

        -- Probar valores extremos e intermedios
        sample_in <= "00000000";
        wait for 600 * clk_period; -- Espera varios ciclos
        sample_in <= "11111111";
        wait for 600 * clk_period;
        sample_in <= "10011001"; -- Valor intermedio
        wait for 600 * clk_period;
        sample_in <= "00000000"; -- Mínimo valor
        wait for 600 * clk_period;
        sample_in <= "11111111"; -- Máximo valor
        wait for 600 * clk_period;
        sample_in <= "10011001"; -- Valor intermedio alto
        wait for 600 * clk_period;
        sample_in <= "01100110"; -- Valor intermedio bajo
        wait for 600 * clk_period;
        sample_in <= "10101010"; -- Patrón alternado alto-bajo
        wait for 600 * clk_period;
        sample_in <= "01010101"; -- Patrón alternado bajo-alto
        wait for 600 * clk_period;
        sample_in <= "11000011"; -- Mayoría de bits altos
        wait for 600 * clk_period;
        sample_in <= "00111100"; -- Mayoría de bits bajos
        wait for 600 * clk_period;
        sample_in <= "11110000"; -- Mitad alta, mitad baja
        wait for 600 * clk_period;
        sample_in <= "00001111"; -- Mitad baja, mitad alta
        wait for 600 * clk_period;
        sample_in <= "10000001"; -- Extremos altos, resto bajo
        wait for 600 * clk_period;
        sample_in <= "01111110"; -- Extremos bajos, resto alto
        wait for 600 * clk_period;
        sample_in <= "11010101"; -- Patrón aleatorio
        wait for 600 * clk_period;
        sample_in <= "00101010"; -- Patrón inverso aleatorio
        wait for 600 * clk_period;
        sample_in <= "00000000";
        wait for 600 * clk_period; -- Espera varios ciclos
        
        play_enable <= '0';
        wait;
    end process;
end Behavioral;
