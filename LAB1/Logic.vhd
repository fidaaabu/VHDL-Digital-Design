

------------------ BY FIDAA YOUSRF--------------------------------------;

------------------LIBRARY DEFINETION -----------------------------------;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

------------------ENTITY DEFINETION-------------------------------------;
ENTITY Logic IS 
    GENERIC(n : integer :=8);
    PORT(
          x, y:IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);  
          ALUFN: IN STD_LOGIC_VECTOR(4 DOWNTO 0); 
          ALUout: OUT STD_LOGIC_VECTOR( n-1 DOWNTO 0) 
    );
END Logic; 

------------------ARCHITECTURE DEFINETION-------------------------------; 
ARCHITECTURE behavioral OF Logic  IS    
     SIGNAL ALUout_TEMP: STD_LOGIC_VECTOR(n-1 DOWNTO 0);   
     BEGIN 
     WITH ALUFN(2 DOWNTO 0) SELECT  
       ALUout_TEMP <= (not(y)) WHEN  "000",
                 (y or x) WHEN "001",
                 (y and x) WHEN "010",
                 (y xor x) WHEN "011", 
                 (y nor x) WHEN "100", 
                 (y nand x) WHEN "101", 
                 (y xnor x) WHEN "110", 
                   (others => '0') WHEN OTHERS; 
       
       ALUout <= ALUout_TEMP; 
END behavioral; 

                  
                  
                  

                  
                  
                   
                  
                  

                  
                  
                  
                  
                 
     