library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hex_to_sseg_test is
  port(
    clk : in std_logic;
    sw : in std_logic_vector(7 downto 0);
    an : out std_logic_vector(3 downto 0);
    sseg : out std_logic_vector(7 downto 0)
  );
end hex_to_sseg_test;

architecture arch of hex_to_sseg_test is
  signal inc : std_logic_vector(7 downto 0);
  signal led0, led1, led2, led3 : std_logic_vector(7 downto 0);

begin
  inc <= std_logic_vector(unsigned(sw) + 1); -- increment input
