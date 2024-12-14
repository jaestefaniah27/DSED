----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 19:18:20
-- Design Name: 
-- Module Name: playing_reg - Behavioral
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

entity playing_reg is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           sample_req : in STD_LOGIC;
           to_jack : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           dout : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           filter_select : out STD_LOGIC;
           sample_to_filter : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_to_filter_en : out STD_LOGIC;
           sample_from_filter : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_filter_en : in STD_LOGIC;
           fin_idx : in STD_LOGIC_VECTOR(18 downto 0);
           SW : in STD_LOGIC_VECTOR(1 downto 0);
           BTNR, BTNL : in STD_LOGIC);
end playing_reg;

ARCHITECTURE Behavioral OF playing_reg IS
    SIGNAL addr_idx, addr_idx_next : std_logic_vector(18 DOWNTO 0);
    SIGNAL sample_to_jack, sample_to_jack_next : std_logic_vector(sample_size - 1 DOWNTO 0);
    SIGNAL counter, counter_next : unsigned(1 DOWNTO 0);
BEGIN

    -- REG
    REG: PROCESS(clk_12Mhz, rst, sample_req)
    BEGIN
        IF (rst = '1') THEN
            addr_idx <= (others => '0');
            sample_to_jack <= (others => '0');
            counter <= (others => '0');
        ELSIF rising_edge(clk_12Mhz) AND en = '1' THEN
            addr_idx <= addr_idx_next;  -- Asignación a addr_idx
            counter <= counter_next;
            IF (sample_req = '1') THEN
                sample_to_jack <= sample_to_jack_next;
                counter <= (others => '0');
            END IF;
        END IF;
    END PROCESS;

    -- Lógica de salida para sample_to_jack, filter_select y counter_next
    sample_to_jack_next <= dout WHEN (SW = "00" OR SW = "10") ELSE sample_from_filter;
    filter_select <= '1' WHEN (SW = "11") ELSE '0';
    counter_next <= counter WHEN counter = "11" ELSE counter + 1;
    sample_to_filter_en <= '1' WHEN to_integer(counter) = 2 ELSE '0';
    addr <= addr_idx;  -- Dirección de salida
    to_jack <= sample_to_jack;  -- Datos de salida
    sample_to_filter <= dout;  -- Muestra del filtro

    -- RAM_ADDR_MANAGER
RAM_ADDR_MANAGER: PROCESS(sample_req, SW, fin_idx, addr_idx, BTNR, BTNL)
    BEGIN
        -- Condición de control para BTNR
        IF (BTNR = '1') THEN
            addr_idx_next <= fin_idx;
        -- Condición de control para BTNL
        ELSIF (BTNL = '1') THEN
            addr_idx_next <= (others => '0');
        -- Condición de control cuando sample_req está activo
        ELSIF (sample_req = '1') THEN
            CASE SW IS
                WHEN "10" =>  -- Si SW es "10", restar 1 a la dirección
                    IF to_integer(unsigned(addr_idx)) = 0 THEN
                        addr_idx_next <= (others => '0');  -- No puede ser menor que 0
                    ELSE
                        addr_idx_next <= std_logic_vector(unsigned(addr_idx) - 1);
                    END IF;
                WHEN OTHERS =>  -- Si SW es otro valor, sumar 1 a la dirección
                    IF addr_idx = fin_idx THEN
                        addr_idx_next <= addr_idx;  -- Mantener la misma dirección si llegamos a fin_idx
                    ELSE
                        addr_idx_next <= std_logic_vector(unsigned(addr_idx) + 1);
                    END IF;
            END CASE;
        ELSE
            -- En caso de no cumplir ninguna condición, mantener la dirección actual
            addr_idx_next <= addr_idx;
        END IF;
    END PROCESS;

END Behavioral;

