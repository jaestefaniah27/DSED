----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2024 13:14:41
-- Design Name: 
-- Module Name: inputMicrophone_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity inputMicrophone_gen_enables_tb is
end inputMicrophone_gen_enables_tb;

architecture Behavioral of inputMicrophone_gen_enables_tb is
    SIGNAL clk_12Mhz        : STD_LOGIC := '0';
    SIGNAL rst              : STD_LOGIC := '1';
    SIGNAL micro_data       : STD_LOGIC := '0';
    SIGNAL sample_out       : STD_LOGIC_VECTOR (sample_size -1 downto 0);
    SIGNAL sample_out_ready : STD_LOGIC;
    SIGNAL en_4_cycles : STD_LOGIC;
    -- Periodo del reloj de 12 MHz (83.33 ns)
    CONSTANT clk_period : time := 83.33 ns;

    -- Se�ales internas para pseudo-aleatoriedad
    SIGNAL rand_a : STD_LOGIC := '0';
    SIGNAL rand_b : STD_LOGIC := '0';
    SIGNAL rand_c : STD_LOGIC := '0';
    
    component inputMicrophone port(
        clk_12Mhz : in STD_LOGIC;
        rst : in STD_LOGIC;
        en_4_cycles : in STD_LOGIC;
        micro_data : in STD_LOGIC;
        sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_out_ready : out STD_LOGIC);
    end component;
    
    component gen_enables port (
           clk_12Mhz : in STD_LOGIC ;
           rst : in STD_LOGIC ;
           clk_3MHz : out STD_LOGIC ;
           en_2_cycles : out STD_LOGIC ;
           en_4_cycles : out STD_LOGIC);
        end component;
begin

LYC: inputMicrophone
    port map (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            en_4_cycles => en_4_cycles,
            micro_data => micro_data,
            sample_out => sample_out,
            sample_out_ready => sample_out_ready
    );
    -- Instancia del DUT
    DUT: gen_enables
        PORT MAP (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            clk_3MHz => open,
            en_2_cycles => open,
            en_4_cycles => en_4_cycles
        );
    -- Generaci�n del reloj de 12 MHz
    clk_process: process
    begin
        clk_12Mhz <= '1';
        wait for clk_period / 2;
        clk_12Mhz <= '0';
        wait for clk_period / 2;
    end process;

    -- Proceso para generar pseudo-aleatoriedad en micro_data con m�s cambios
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

    -- Asignaci�n de micro_data como una combinaci�n pseudo-aleatoria de las se�ales rand_a, rand_b y rand_c
    micro_data <= rand_a xor rand_b xor rand_c;

    -- Proceso para simular el reset y observar las salidas
    stim_proc: process
    begin	
        -- Inicializaci�n del reset
        rst <= '1';
        wait for 500 ns;
        rst <= '0';

        -- Esperar el tiempo suficiente para observar los cambios
        wait for 4000 us;

        -- Terminar la simulaci�n
        wait;
    end process;

end Behavioral;
