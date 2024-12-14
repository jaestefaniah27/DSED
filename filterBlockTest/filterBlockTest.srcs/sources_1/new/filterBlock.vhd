----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.12.2024 19:05:39
-- Design Name: 
-- Module Name: filterBlock - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
--
-- Este bloque ha sido modificado para declarar explícitamente los componentes
-- antes de su instanciación.
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

entity filterBlock is
    Port (
        clk_12Mhz : in STD_LOGIC;
        rst       : in STD_LOGIC;
        sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_en : in STD_LOGIC;
        filterSelect : in STD_LOGIC;
        sample_out : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
        sample_out_ready : out STD_LOGIC
    );
end filterBlock;

architecture Behavioral of filterBlock is

    -- Declaración de señales internas
    signal c0, c1, c2, c3, c4 : std_logic_vector(sample_size - 1 downto 0);
    signal s0, s1, s2, s3, s4 : std_logic_vector(sample_size - 1 downto 0);
    signal sen : std_logic;

    -- Declaración de componentes

    component fir5stage is
        Port (
            clk_12Mhz          : in  STD_LOGIC;
            rst                : in  STD_LOGIC;
            s0, s1, s2, s3, s4 : in  STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sen                : in  STD_LOGIC;
            c0, c1, c2, c3, c4 : in  STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_out         : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_out_ready   : out STD_LOGIC
        );
    end component;

    component coefSelector is
        Port (
            filterSelect       : in  STD_LOGIC;
            c0, c1, c2, c3, c4 : out STD_LOGIC_VECTOR(sample_size - 1 downto 0)
        );
    end component;

    component sampleRegister is
        Port (
            clk_12Mhz          : in  STD_LOGIC;
            rst                : in  STD_LOGIC;
            sample_in          : in  STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sample_en          : in  STD_LOGIC;
            s0, s1, s2, s3, s4 : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
            sen                : out STD_LOGIC
        );
    end component;

begin

    FIR: fir5stage
        port map (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            s0 => s0,
            s1 => s1,
            s2 => s2,
            s3 => s3,
            s4 => s4,
            sen => sen,
            c0 => c0,
            c1 => c1,
            c2 => c2,
            c3 => c3,
            c4 => c4,
            sample_out => sample_out,
            sample_out_ready => sample_out_ready
        );

    COEFICIENT_SELECTOR: coefSelector
        port map (
            filterSelect => filterSelect,
            c0 => c0,
            c1 => c1,
            c2 => c2,
            c3 => c3,
            c4 => c4
        );

    SAMPLE_REGISTER: sampleRegister
        port map (
            clk_12Mhz => clk_12Mhz,
            rst => rst,
            sample_in => sample_in,
            sample_en => sample_en,
            s0 => s0,
            s1 => s1,
            s2 => s2,
            s3 => s3,
            s4 => s4,
            sen => sen
        );

end Behavioral;
