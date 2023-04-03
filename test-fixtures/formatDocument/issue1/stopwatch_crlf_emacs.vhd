----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    21:26:55 09/19/2013
-- Design Name:
-- Module Name:    stopwatch - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stopwatch is
    generic (clock_freq : integer := 100000000);

    port (Led : out std_logic_vector (3 downto 0);
          sw  : in  std_logic_vector (7 downto 0);
          an  : out std_logic_vector (3 downto 0) := "0000";
          seg : out std_logic_vector (7 downto 0);
          btn : in  std_logic_vector (3 downto 0);
          clk : in  std_logic);

end stopwatch;

architecture Behavioral of stopwatch is
-------------------------------GLOBAL SIGNALS------------------------------
    signal millis         : integer                       := 0;
    signal t_millis       : integer                       := 0;
    signal h_millis       : integer                       := 0;
    signal secs           : integer                       := 0;
    signal t_secs         : integer                       := 0;
    signal ssd_millis     : std_logic_vector (7 downto 0) := "11111111";
    signal ssd_t_millis   : std_logic_vector (7 downto 0) := "11111111";
    signal ssd_h_millis   : std_logic_vector (7 downto 0) := "11111111";
    signal ssd_secs       : std_logic_vector (7 downto 0) := "11111111";
    signal led_t_secs     : std_logic_vector (3 downto 0) := "0000";
    signal m_clk          : std_logic                     := '0';
    signal millis_divisor : integer                       := clock_freq/1000;
    signal clk_counter    : integer                       := 0;
    signal counter        : integer                       := 0;
    signal en             : std_logic                     := '1';
    signal inc            : std_logic                     := '0';
    signal stop           : std_logic                     := '0';
    signal start          : std_logic                     := '0';
    signal rst            : std_logic                     := '0';
    signal incstate       : integer                       := 0;
---------------------------------------------------------------------------
begin
--millis_divisor <= 1000;       -- Debug purposes
-------------------------------CLOCK DIVIDER-------------------------------
    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (clk_counter = millis_divisor) then
                clk_counter <= 0;
                m_clk       <= '1';
            else
                clk_counter <= clk_counter + 1;
                m_clk       <= '0';
            end if;
        end if;
    end process;
--------------------------------------------------------------------------
-------------------------------COUNTERS-----------------------------------
    process (m_clk, en, rst)
    begin
        if (rst = '1') then
            millis   <= 0;
            t_millis <= 0;
            h_millis <= 0;
            secs     <= 0;
            t_secs   <= 0;
        elsif(m_clk'event and m_clk = '1') then
            if (en = '1') then
                millis <= millis + 1;
                if (millis = 9) then  -- Why 9 and not 10? Ask someone about this.
                    millis   <= 0;
                    t_millis <= t_millis + 1;
                    if (t_millis = 9) then
                        t_millis <= 0;
                        h_millis <= h_millis + 1;
                        if (h_millis = 9) then
                            secs     <= secs + 1;
                            h_millis <= 0;
                            if (secs = 9) then
                                t_secs <= t_secs + 1;
                                secs   <= 0;
                                if (t_secs = 15) then
                                    t_secs <= 0;  -- Max count reached, reset t_secs
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            elsif(inc = '1' and (incstate = 0)) then  -- Messy bit of code for inc button
                incstate <= incstate + 1;
                millis   <= millis + 1;
                if (millis = 9) then  -- Why 9 and not 10? Ask someone about this.
                    millis   <= 0;
                    t_millis <= t_millis + 1;
                    if (t_millis = 9) then
                        t_millis <= 0;
                        h_millis <= h_millis + 1;
                        if (h_millis = 9) then
                            secs     <= secs + 1;
                            h_millis <= 0;
                            if (secs = 9) then
                                t_secs <= t_secs + 1;
                                secs   <= 0;
                                if (t_secs = 15) then
                                    t_secs <= 0;  -- Max count reached, reset t_secs
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            elsif (inc = '1' and (incstate > 0) and (incstate < 30)) then
                incstate <= incstate + 1;
            elsif (inc = '0' and (incstate > 0)) then
                incstate <= incstate - 1;
            end if;
        end if;
    end process;
--------------------------------------------------------------------------
------------------------------Decoders------------------------------------
    with millis select
        ssd_millis <=
        "11000000" when 0,
        "11111001" when 1,
        "10100100" when 2,
        "10110000" when 3,
        "10011001" when 4,
        "10010010" when 5,
        "10000010" when 6,
        "11111000" when 7,
        "10000000" when 8,
        "10010000" when 9,
        "10000110" when others;
    with t_millis select
        ssd_t_millis <=
        "11000000" when 0,
        "11111001" when 1,
        "10100100" when 2,
        "10110000" when 3,
        "10011001" when 4,
        "10010010" when 5,
        "10000010" when 6,
        "11111000" when 7,
        "10000000" when 8,
        "10010000" when 9,
        "10000110" when others;
    with h_millis select
        ssd_h_millis <=
        "11000000" when 0,
        "11111001" when 1,
        "10100100" when 2,
        "10110000" when 3,
        "10011001" when 4,
        "10010010" when 5,
        "10000010" when 6,
        "11111000" when 7,
        "10000000" when 8,
        "10010000" when 9,
        "10000110" when others;
    with secs select
        ssd_secs <=
        "11000000" when 0,
        "11111001" when 1,
        "10100100" when 2,
        "10110000" when 3,
        "10011001" when 4,
        "10010010" when 5,
        "10000010" when 6,
        "11111000" when 7,
        "10000000" when 8,
        "10010000" when 9,
        "10000110" when others;
    with t_secs select
        led_t_secs <=
        "0000" when 0,
        "0001" when 1,
        "0010" when 2,
        "0011" when 3,
        "0100" when 4,
        "0101" when 5,
        "0110" when 6,
        "0111" when 7,
        "1000" when 8,
        "1001" when 9,
        "1010" when 10,
        "1011" when 11,
        "1100" when 12,
        "1101" when 13,
        "1110" when 14,
        "1111" when 15,
        "1111" when others;
--------------------------------------------------------------------------
------------------------------7SEG DRIVER---------------------------------
-- Start messy code from previous project --
    process(clk)
    begin
        an <= "1111";
        if (clk'event and clk = '1') then
            counter <= counter + 1;

            if(counter > 150 and counter < 200) then
                -- Display first digit
                seg <= ssd_secs and "01111111";
                an  <= "0111";

            elsif (counter > 250 and counter < 300) then
                -- Display second digit
                seg <= ssd_h_millis;
                an  <= "1011";

            elsif (counter > 350 and counter < 400) then
                -- Display third digit
                seg <= ssd_t_millis;
                an  <= "1101";

            elsif (counter > 450 and counter < 500) then
                -- Display fourth digit
                seg <= ssd_millis;
                an  <= "1110";

            elsif (counter > 499) then
                counter <= 1;

            else
                an  <= "1111";
                seg <= "11111111";
            end if;
        end if;
    end process;
--------------------------------------------------------------------------
-------------------------------INPUT LOGIC--------------------------------
    process (clk)
    begin
        if (clk'event and clk = '1') then
            if (start = '1' and stop = '0') then
                en <= '1';
            elsif (stop = '1' and start = '0') then
                en <= '0';
            else
                en <= en;
            end if;
        end if;
    end process;

--------------------------------------------------------------------------
---------------------------COMBINATIONAL LOGIC----------------------------
    Led   <= led_t_secs;
    start <= btn(0);
    stop  <= btn(1);
    inc   <= btn(2);
    rst   <= btn(3);
--------------------------------------------------------------------------
end Behavioral;
