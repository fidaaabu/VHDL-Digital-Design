

------------------ BY FIDAA YOUSEF--------------------------------------;

------------------LIBRARY DEFINETION -----------------------------------;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.aux_package.all;



------------------ENTITY DEFINETION-------------------------------------;


-- AdderSub module
-- Performs arithmetic operations according to sub_cont


ENTITY AdderSub IS 
      GENERIC (n : INTEGER := 8);
      PORT( 
            X, Y : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
            sub_cont : IN STD_LOGIC_VECTOR(2 downto 0);
            cout : OUT STD_LOGIC;
            res : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
         );
    
END AdderSub; 

------------------ARCHITECTURE DEFINETION-------------------------------; 
ARCHITECTURE behavioral OF AdderSub  IS
  
    SIGNAL c       : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL x_temp  : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL y_temp  : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    SIGNAL cin : STD_LOGIC;
    CONSTANT  two : STD_LOGIC_VECTOR(n-1 DOWNTO 0):=  
                     ( 1 => '1' , others => '0');               
    BEGIN
    cin <= '0' WHEN (sub_cont="000"  or sub_cont="011") ELSE 
           '1' WHEN (sub_cont="001"  or sub_cont="010"or sub_cont= "100" ) ELSE
           '0'; 
     
    x_creat : for i in 0 to n-1 generate
    begin
              x_temp(i) <= x(i) when (sub_cont="000") ELSE 
                           not(x(i)) when ((sub_cont="001") or (sub_cont="010"))  ELSE 
                           two(i) when (sub_cont="011") ELSE
                           not(two(i)) when (sub_cont = "100") ELSE
                           '0';   
    end generate;
    y_creat : for i in 0 to n-1 generate
    begin
    y_temp(i) <= '0' when (sub_cont="010") else
                 y(i);
    end generate;

----------------------------------------------------------------------
    -- First full adder stage
---------------------------------------------------------------------




    FA0 : ENTITY work.FA PORT MAP(
        xi    => x_temp(0),
        yi    => y_temp(0),
        cin  => cin,
        s    => res(0),
        cout => c(0)
);   
    
  
---------------------------------------------------------------
    -- Remaining ripple-carry full adder stages
---------------------------------------------------------------


     

FA_gen : FOR i IN 1 TO n-1 GENERATE
BEGIN

    FAi : ENTITY work.FA PORT MAP(
        xi    => x_temp(i),
        yi    => y_temp(i),
        cin  => c(i-1),
        s    => res(i),
        cout => c(i)
    );
     
END GENERATE;
        cout <= c(n-1);

END behavioral;
                   

                   

     
             












          
