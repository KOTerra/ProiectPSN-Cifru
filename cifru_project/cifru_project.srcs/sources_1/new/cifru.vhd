library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity cifru is
    port (
        clk : in std_logic;
        reset : in std_logic;
        up : in std_logic;
        down : in std_logic;
        addCifra : in std_logic;
        liberOcupatLED : out std_logic;
        introduCaractereLED : out std_logic;
        anodActiv : out std_logic_vector (7 downto 0);
        segmentOutLED : out std_logic_vector (6 downto 0)
    );

end cifru;

architecture Behavioral of cifru is
    component UnitateControl is
        port (
            clk : in std_logic;
            reset : in std_logic;
            addCifra : in std_logic;
            enableCompare : out std_logic;
            checkedMatch : in std_logic;
            enableAnod1 : out std_logic;
            enableAnod2 : out std_logic;
            enableAnod3 : out std_logic;
            match : in std_logic;

            liberOcupat : inout std_logic;
            liberOcupatLED : out std_logic;
            introduCaractereLED : out std_logic
        );
    end component;

    component UnitateExecutie is
        port (
            clk : in std_logic;
            reset : in std_logic;
            liberOcupat : in std_logic;
            enableAnod1 : in std_logic;
            enableAnod2 : in std_logic;
            enableAnod3 : in std_logic;
            up : in std_logic;
            down : in std_logic;
            enableCompare : in std_logic;
            checkedMatch : out std_logic;
            match : out std_logic;

            anodActiv : out std_logic_vector (7 downto 0);
            segmentOutLED : out std_logic_vector (6 downto 0)
        );
    end component;

    component MPG is
        port (
            btn : in std_logic;
            clk : in std_logic;
            debounced : out std_logic);
    end component;

    signal addCifraDebounced : std_logic := '0';
    signal upDebounced : std_logic := '0';
    signal downDebounced : std_logic := '0';

    signal enableCompare : std_logic;
    signal checkedMatch : std_logic;
    signal match : std_logic;
    signal liberOcupat : std_logic;
    signal enableAnod1 : std_logic;
    signal enableAnod2 : std_logic;
    signal enableAnod3 : std_logic;
begin
    mpgAddCifra : MPG port map(addCifra, clk, addCifraDebounced);
    mpgUp : MPG port map(up, clk, upDebounced);
    mpgDown : MPG port map(down, clk, downDebounced);

    control : UnitateControl port map(clk, reset, addCifraDebounced, enableCompare, checkedMatch, enableAnod1, enableAnod2, enableAnod3, match, liberOcupat, liberOcupatLED, introduCaractereLED); --change to debounced
    executie : UnitateExecutie port map(clk, reset, liberOcupat, enableAnod1, enableAnod2, enableAnod3, upDebounced, downDebounced, enableCompare, checkedMatch, match, anodActiv, segmentOutLED);
end Behavioral;