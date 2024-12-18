----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2024 19:18:20
-- Design Name: 
-- Module Name: controller - Behavioral
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

entity controller is
    Port ( clk_12Mhz : in STD_LOGIC;
           rst : in STD_LOGIC;
           sample_from_micro : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_micro_ready : in STD_LOGIC;
           rec_en : out STD_LOGIC;
           play_en : out STD_LOGIC;
           sample_req : in STD_LOGIC;
           to_jack : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           din : out STD_LOGIC_VECTOR(sample_size - 1 downto 0);
           dout : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           we : out STD_LOGIC_VECTOR(0 downto 0);
           filter_select : out STD_LOGIC;
           sample_to_filter : out STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_to_filter_en : out STD_LOGIC;
           sample_from_filter : in STD_LOGIC_VECTOR (sample_size - 1 downto 0);
           sample_from_filter_en : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR(2 downto 0);
           BTNU, BTND, BTNC, BTNR, BTNL : in STD_LOGIC;
           act_idx_led, fin_idx_led : out STD_LOGIC_VECTOR(3 downto 0);
           PLAYING_LED, RECORDING_LED: out STD_LOGIC);
end controller;

ARCHITECTURE Behavioral OF controller IS
    SIGNAL addr_idx, addr_idx_next, fin_idx, fin_idx_next : std_logic_vector(18 DOWNTO 0);
    SIGNAL sample_to_jack, sample_to_jack_next : std_logic_vector(sample_size - 1 DOWNTO 0);
    SIGNAL counter, counter_next : unsigned(1 DOWNTO 0);
    SIGNAL PLAYING, PLAYING_NEXT : STD_LOGIC;
    SIGNAL BTNC_DELAYED, BTNC_DELAYED_NEXT : STD_LOGIC; -- SE REGISTRA EL ESTADO DEL BTNC PARA DETECTAR EL FLANCO
BEGIN
-- REG
REG: PROCESS(clk_12Mhz, rst, sample_req, sample_from_micro_ready, BTNU, addr_idx_next, fin_idx_next, counter_next, PLAYING_NEXT, BTNC_DELAYED_NEXT, sample_to_jack_next)
BEGIN
    IF rising_edge(clk_12Mhz) then 
        if rst = '1' THEN
            addr_idx <= (others => '0');
            fin_idx <= (others=>'0');
            sample_to_jack <= (others => '0');
            counter <= (others => '0');
            PLAYING <= '0';
            BTNC_DELAYED <= '0';
        ELSE
            addr_idx <= addr_idx_next;
            fin_idx <= fin_idx_next;
            counter <= counter_next;
            PLAYING <= PLAYING_NEXT;
            BTNC_DELAYED <= BTNC_DELAYED_NEXT;
            IF (sample_req = '1' and BTNU = '0') THEN -- Reproduciendo
                sample_to_jack <= sample_to_jack_next;
                counter <= (others => '0'); -- contador se utiliza para saber cuando meter muestras de la RAM al filtro
                -- se reinicia cuando se requiere una muestra para el altavoz
            elsif (sample_from_micro_ready = '1' and BTNU = '1') then -- Grabando, se utiliza BTNU como enable del modo grabar
                counter <= (others=>'0'); -- contador se utiliza para escribir en la RAM
                -- se reinicia cuando hay que guardar una muestra del microfono en la RAM
            END IF;
        END IF;
    END IF;
END PROCESS;

rec_en <= BTNU; -- se activa el microfono cuando se quiere grabar
play_en <= PLAYING;
BTNC_DELAYED_NEXT <= BTNC;
PLAY_PAUSE: process(BTNU, BTND, BTNR, BTNC, BTNC_DELAYED, BTNL, PLAYING)
begin
if (BTNU = '1') then
    PLAYING_NEXT <= '0';
elsif (BTNR = '0' and BTNC = '0' and BTNL = '1' and BTND = '0') 
or (BTNR = '1' and BTNC = '0' and BTNL = '0' and BTND = '0') then
    PLAYING_NEXT <= '1';
elsif (BTNU = '0' and BTNR = '0' and BTNC = '1' and BTNC_DELAYED = '0' and BTNL = '0' and BTND = '0') then
    PLAYING_NEXT <= not PLAYING;
elsif (BTND = '1') then
    PLAYING_NEXT <= '0';
else 
    PLAYING_NEXT <= PLAYING;
end if;
end process;

-- L�gica de salida
act_idx_led <= addr_idx(18 downto 15);
fin_idx_led <= fin_idx(18 downto 15);
playing_led <= PLAYING;
recording_led <= BTNU;

sample_to_jack_next <=  dout WHEN (SW(1 downto 0) = "00" OR SW(1 downto 0) = "10") ELSE 
                        std_logic_vector(to_unsigned(to_integer(signed(sample_from_filter)) + 128, 8));
filter_select <= '1' WHEN (SW(1 downto 0) = "11") ELSE '0';
counter_next <= counter WHEN counter = "11" ELSE counter + 1;
sample_to_filter_en <= '1' WHEN to_integer(counter) = 2 ELSE '0';
we(0) <= '1' when to_integer(counter) = 2 and BTNU = '1' else '0'; -- se escribe en la RAM cuando se esta grabando y se esperado a que se incremente la direccion
addr <= fin_idx when (BTNU = '1') else addr_idx; -- Addr_idx para reproducir, fin_idx para grabar.
to_jack <= sample_to_jack;  -- Datos de salida
sample_to_filter <= std_logic_vector(to_signed(to_integer(unsigned(dout)) - 128, 8)); -- Escalado de valores para que se operen correctamente en el filtro
din <= sample_from_micro;
-- RAM_ADDR_MANAGER
RAM_ADDR_MANAGER: PROCESS(sample_req, sample_from_micro_ready, SW, fin_idx, addr_idx, BTNR, BTNL, BTNU, BTND)
BEGIN
    addr_idx_next <= addr_idx;
    fin_idx_next <= fin_idx;
    -- BTNU = '1': grabando
    IF (BTNU = '1') then 
        if (signed(fin_idx) = -1) then
            fin_idx_next <= fin_idx; 
        elsif (sample_from_micro_ready = '1') then
            fin_idx_next <= std_logic_vector(unsigned(fin_idx) + 1);
        else 
            fin_idx_next <= fin_idx;
        end if;
    -- BTND = '1' "delete" audio
    elsif (BTND = '1') then
        addr_idx_next <= (others=>'0');
        fin_idx_next <= (others=>'0');
    -- Condici�n de control para BTNR
    ELSIF (BTNR = '1') THEN
        addr_idx_next <= fin_idx;
    -- Condici�n de control para BTNL
    ELSIF (BTNL = '1') THEN
        addr_idx_next <= (others => '0');
    -- Condici�n de control cuando sample_req est� activo
    ELSIF (sample_req = '1') THEN
        CASE SW(1 downto 0) IS
            WHEN "10" =>  -- Si SW es "10", restar 1 a la direcci�n
                IF to_integer(unsigned(addr_idx)) = 0 THEN
                    addr_idx_next <= (others => '0');  -- No puede ser menor que 0
                ELSIF (SW(2) = '1') and (unsigned(addr_idx) - 2) >= 0 then
                    addr_idx_next <= std_logic_vector(unsigned(addr_idx) - 2);
                ELSE 
                    addr_idx_next <= std_logic_vector(unsigned(addr_idx) - 1);
                    
                END IF;
            WHEN OTHERS =>  -- Si SW es otro valor, sumar 1 a la direcci�n
                 IF addr_idx = fin_idx THEN
                    addr_idx_next <= addr_idx;  -- Mantener la misma direcci�n si llegamos a fin_idx
                ELSIF SW(2) = '1' and std_logic_vector(unsigned(addr_idx) + 2) <= fin_idx then
                    addr_idx_next <= std_logic_vector(unsigned(addr_idx) + 2);
                ELSE
                   addr_idx_next <= std_logic_vector(unsigned(addr_idx) + 1);
                END IF;
       END CASE;
    ELSE
        -- En caso de no cumplir ninguna condici�n, mantener la direcci�n actual
        addr_idx_next <= addr_idx;
        fin_idx_next <= fin_idx;
    END IF;
END PROCESS;

END Behavioral;