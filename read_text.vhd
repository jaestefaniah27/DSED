----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2024 12:02:36
-- Design Name: 
-- Module Name: read_text - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity read_text is
end read_text;

architecture behavior of read_text is
    -- señal del reloj
    signal clk : std_logic := '1';
    signal sample_in : signed (7 downto 0) := (others => '0');
    signal sample_out : signed (7 downto 0);
    signal sample_out_ready : std_logic := '0';

    -- periodo del reloj
    constant clk_period : time := 10 ns;

    -- declaración de archivos
    file in_file : text open read_mode is "C:/Users/dsed/DSED/Archivos_texto/sample_in.dat";
    file out_file : text open write_mode is "C:/Users/dsed/DSED/Archivos_texto/sample_out.dat";

begin
    -- generador de reloj
    clk_process : process
    begin
        clk <= not clk after clk_period / 2;
        wait for clk_period / 2;
    end process;

    -- proceso de estímulo
    stimulus_process : process
        variable in_line : line;
        variable in_int : integer;
        variable out_line : line;
        variable out_int : integer;
        variable in_read_ok : boolean; -- variable para verificar la lectura correcta
    begin
        -- leer archivo de entrada
        while not endfile(in_file) loop
            -- leer línea del archivo de entrada
            readline(in_file, in_line);
            read(in_line, in_int, in_read_ok); -- lectura con verificación
            -- verificar si la lectura fue exitosa
            if (not in_read_ok) then
                assert false report "error al leer datos del archivo de entrada" severity failure;
            else
                -- convertir a formato de 8 bits
                sample_in <= to_signed(in_int, 8);
                
                -- esperar al flanco positivo del reloj
                wait until rising_edge(clk);
    
                -- simular el procesamiento del filtro
                sample_out <= sample_in; -- incluir lógica del filtro real
                sample_out_ready <= '1';
            end if;

            wait until rising_edge(clk);
            sample_out_ready <= '0';

            -- convertir la salida a entero y escribir en el archivo de salida
            out_int := to_integer(sample_out);
            write(out_line, out_int);
            writeline(out_file, out_line);
        end loop;
        
        -- finalizar simulación
        assert false report "simulación finalizada" severity failure;
    end process;
end behavior;




