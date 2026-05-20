LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
USE work.aux_package.all;


-------------------------------------
-- Top module: ALU
-- Combines three main units:
-- 1. Adder/Subtractor
-- 2. Shifter
-- 3. Logic Unit
-- Output is selected based on ALUFN control signal

-------------------------------------
ENTITY top IS
  GENERIC (n : INTEGER := 8;
		   k : integer := 3;   -- k=log2(n)
		   m : integer := 4	); -- m=2^(k-1)
  PORT 
  (  
	          Y_i,X_i: IN   STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		  ALUFN_i : IN  STD_LOGIC_VECTOR (4 DOWNTO 0);
		  ALUout_o: OUT STD_LOGIC_VECTOR(n-1 downto 0);
		  Nflag_o,Cflag_o,Zflag_o,Vflag_o: OUT STD_LOGIC
  ); -- Zflag,Cflag,Nflag,Vflag
END top;
------------- complete the top Architecture code --------------
ARCHITECTURE struct OF top IS
         signal AdderSub_res : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         signal AdderSub_cout : STD_LOGIC; 


         signal Shifter_res : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         signal Shifter_cout : STD_LOGIC;
         signal shift_dir : STD_LOGIC;

         signal Logic_res : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
         
-----------------FINAL OUTPUT --------------------------------; 
         signal ALUout : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN

--------------------------------------------------------------;
---------------------Direction of Shifter---------------------;
          shift_dir<= '0' WHEN ALUFN_i( 2 DOWNTO 0) = "000" ELSE 
                      '1' WHEN ALUFN_i( 2 DOWNTO 0) = "001" ELSE
                      '0'; 


----------------------------------------------------------------
    -- AdderSub instance
----------------------------------------------------------------
     U1:  Entity work.AdderSub 
          GENERIC MAP ( n => n)
          PORT MAP ( 
               X => X_i, 
               Y => Y_i,  
               Sub_cont => ALUFN_i( 2 downto 0), 
               cout => AdderSub_cout, 
               res => AdderSub_res
); 

----------------------------------------------------------------
    -- Shifter instance
----------------------------------------------------------------



      U2 : ENTITY work.Shifter 
           GENERIC MAP ( 
                      n => n, 
                      k => k)
           PORT MAP ( 
                 X =>  X_i(k-1 downto 0),
                 Y => Y_i,
                 dir => shift_dir,
                 cout => Shifter_cout,
                 res  => Shifter_res
); 


----------------------------------------------------------------
    -- Logic instance
----------------------------------------------------------------


      U3 : ENTITY work.Logic 
           GENERIC MAP ( n => n)                  
           PORT MAP ( 
                  x => X_i,
                  y => Y_i,
                  ALUFN => ALUFN_i,
                  ALUout => Logic_res
);



-----------------------------------------------------------------
                 --Final Result
-----------------------------------------------------------------


with ALUFN_i select
    ALUout <= AdderSub_res when "01000" | "01001" | "01010" | "01100"| "01011",
              Shifter_res  when "10000" | "10001",
              Logic_res    when "11000" | "11001" | "11010" | "11011" |
                               "11100" | "11101" | "11110",
              (others => '0') when others;








    Nflag_o <= ALUout(n-1);

    Zflag_o <= '1' WHEN ALUout = (ALUout'RANGE => '0') ELSE '0';

    Cflag_o <= AdderSub_cout  WHEN ALUFN_i(4 DOWNTO 3) = "01" ELSE
               Shifter_cout   WHEN (ALUFN_i = "10000" OR ALUFN_i = "10001") ELSE
               '0';

    -- overflow meaningful only for arithmetic block
    Vflag_o <= '1' WHEN (
                    ALUFN_i(4 DOWNTO 3) = "01" AND
                    (
                      (ALUFN_i(2 DOWNTO 0) = "000" AND X_i(n-1) = '0' AND Y_i(n-1) = '0' AND ALUout(n-1) = '1') OR
                      (ALUFN_i(2 DOWNTO 0) = "000" AND X_i(n-1) = '1' AND Y_i(n-1) = '1' AND ALUout(n-1) = '0') OR
                      (ALUFN_i(2 DOWNTO 0) = "001" AND Y_i(n-1) = '0' AND X_i(n-1) = '1' AND ALUout(n-1) = '1') OR
                      (ALUFN_i(2 DOWNTO 0) = "001" AND Y_i(n-1) = '1' AND X_i(n-1) = '0' AND ALUout(n-1) = '0')
                    )
                  ) ELSE
                  '0';

         ALUout_o <=ALUout;
   
 


END struct;

























