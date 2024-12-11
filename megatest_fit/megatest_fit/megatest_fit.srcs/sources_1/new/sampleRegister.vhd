----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.11.2024 13:03:25
-- Design Name: 
-- Module Name: sampleRegister - Behavioral
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

entity sampleRegister is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_en : in STD_LOGIC;
           s0 : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s1 : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s2 : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s3 : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           s4 : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sen : out STD_LOGIC);
end sampleRegister;

architecture Behavioral of sampleRegister is

    -- Registros internos del shift register
    signal s_reg0, s_reg1, s_reg2, s_reg3, s_reg4 : std_logic_vector(sample_size - 1 downto 0);

    -- Registro para la señal sen
    signal sen_reg : std_logic;

    -- Señal escalada de entrada (sample_in - 128)
    signal sample_in_scaled : std_logic_vector(sample_size - 1 downto 0);

begin

    -- Escalado de la muestra de entrada
    sample_in_scaled <= std_logic_vector(signed(sample_in)); -- QUITAR -128 VA EN EL CONTROL

    -- Proceso de actualización del shift register
    process(clk_12Mhz, rst)
    begin
        if rst = '1' then
            s_reg0 <= (others => '0');
            s_reg1 <= (others => '0');
            s_reg2 <= (others => '0');
            s_reg3 <= (others => '0');
            s_reg4 <= (others => '0');
            sen_reg <= '0';
        elsif rising_edge(clk_12Mhz) then
            if sample_en = '1' then
                -- Desplaza las muestras previas y agrega la nueva en s_reg0
                s_reg4 <= s_reg3;
                s_reg3 <= s_reg2;
                s_reg2 <= s_reg1;
                s_reg1 <= s_reg0;
                s_reg0 <= sample_in_scaled;

                -- Actualiza sen
                sen_reg <= sample_en;
            end if;
        end if;
    end process;

    -- Salidas
    s0 <= s_reg0;
    s1 <= s_reg1;
    s2 <= s_reg2;
    s3 <= s_reg3;
    s4 <= s_reg4;
    sen <= sen_reg;

end Behavioral;
