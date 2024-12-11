library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.packageDSED.all;
use IEEE.NUMERIC_STD.ALL;

entity inputMicrophone is
port (
    clk_12Mhz : in STD_LOGIC;
    rst : in STD_LOGIC;
    en_4_cycles : in STD_LOGIC;
    micro_data : in STD_LOGIC;
    sample_out : out STD_LOGIC_VECTOR (sample_size -1 downto 0);
    sample_out_ready : out STD_LOGIC
);
end inputMicrophone;

architecture Behavioral of inputMicrophone is
    type state_type is (S0, S1, S2, S3);
    signal state, next_state : state_type;
    signal counter_reg, counter_next : unsigned(8 downto 0); --Para contar hasta 299 se necesitan 9 bits
    signal data0_reg, data1_reg, data0_next, data1_next, sample_out_reg, sample_out_next : unsigned(sample_size -1 downto 0);
    signal primer_ciclo_reg, primer_ciclo_next : std_logic;
    signal sample_out_ready_reg, sample_out_ready_next : std_logic;
begin

UPDATE: process(clk_12Mhz, rst, en_4_cycles)
begin
    if (rst = '1') then
        state <= S0;
        counter_reg <= (OTHERS=>'0');
        data0_reg <= (OTHERS=>'0');
        data1_reg <= (OTHERS=>'0');
        sample_out_reg <= (others=>'0');
        primer_ciclo_reg <= '0';
        sample_out_ready_reg <= '0';
    elsif rising_edge(clk_12Mhz) then
        sample_out_ready_reg <= sample_out_ready_next;
        if en_4_cycles = '1' then
            state <= next_state;
            counter_reg <= counter_next;
            data0_reg <= data0_next;
            data1_reg <= data1_next;
            sample_out_reg <= sample_out_next;
            primer_ciclo_reg <= primer_ciclo_next;
        end if;
    end if;
end process;

NEXT_STATE_PROCESS: process(state, rst, micro_data, counter_reg)
begin
    case (state) is 
        when S0 =>
            if (counter_reg = 105) then
                next_state <= S1;
            else 
                next_state <= S0;
            end if;  
        when S1 =>
            if (counter_reg = 106) then
                next_state <= S1;
            elsif (counter_reg = 149) then
                next_state <= S2;
            else 
                next_state <= S1;
            end if;  
        when S2 =>
            if (counter_reg = 255) then
                next_state <= S3;
            else 
                next_state <= S2;
            end if;  
        when S3 =>
            if (counter_reg = 256) then
                next_state <= S3;
            elsif (counter_reg = 299) then
                next_state <= S0;
            else 
                next_state <= S3;
            end if;  
    end case;
end process;

COUNTER_PROCESS: process(clk_12Mhz, state, counter_reg)
begin
    case (state) is
        when S0 | S1 | S2 =>
            counter_next <= counter_reg + 1;
        when S3 =>
            if (counter_reg = 299) then
                counter_next <= (others=>'0');
            else
                counter_next <= counter_reg + 1;
            end if;
    end case;
end process;

PROCESS_DATA: process(state, micro_data, counter_reg, sample_out_reg, data0_reg, data1_reg)
begin
    sample_out_next <= sample_out_reg;
    case (state) is
        when S0 =>
            if(micro_data = '1') then
                data0_next <= data0_reg + 1;
                data1_next <= data1_reg + 1;
            else
                data0_next <= data0_reg;
                data1_next <= data1_reg;
            end if;
            if (counter_reg = 105) then
                sample_out_next <= data1_reg;
                data1_next <= (others=>'0');
            end if;
        when S1 =>
            if (micro_data = '1') then
                data0_next <= data0_reg + 1;
                data1_next <= data1_reg;
            else
                data0_next <= data0_reg;
                data1_next <= data1_reg;
            end if;
        when S2 =>
            if (micro_data = '1') then
                data0_next <= data0_reg + 1;
                data1_next <= data1_reg + 1;
            else
                data0_next <= data0_reg;
                data1_next <= data1_reg;
            end if; 
            if (counter_reg = 255) then
                sample_out_next <= data0_reg;
                data0_next <= (others=>'0');
            end if;
        when S3 =>
            if (micro_data = '1') then
                data0_next <= data0_reg;
                data1_next <= data1_reg + 1;
            else
                data0_next <= data0_reg;
                data1_next <= data1_reg;
            end if;     
    end case;
end process;

primer_ciclo_next <= '1' when to_integer(counter_reg) = 255 else primer_ciclo_reg; -- Creditos: Amadeo

sample_out <= std_logic_vector(sample_out_reg) when (primer_ciclo_reg = '1') else (others=>'0');

sample_out_ready_next <= '1' when ((counter_reg = 105 or counter_reg = 255) and primer_ciclo_reg = '1' and en_4_cycles = '1') else '0';

sample_out_ready <= sample_out_ready_reg;
end Behavioral;
