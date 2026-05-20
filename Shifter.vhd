------------------ SHIFTER MODULE ------------------;
-- Based on a single barrel shifter
-- By Fidaa Yousef

-- INPUT: Two vectors, X and Y.
-- Y is the vector we want to shift, and X represents the number of shifts.
-- Since for an n-bit barrel shifter only k = log2(n) bits are needed,
-- X is defined as a k-bit vector.
-- OUTPUT: res is Y shifted by the amount specified in X, with zero fill.
-- cout is the last bit shifted out (carry out).


LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Shifter IS 
    GENERIC( 
        n : INTEGER := 8; 
        k : INTEGER := 3 
    ); 
    PORT( 
        X    : IN STD_LOGIC_VECTOR(k-1 DOWNTO 0); 
        Y    : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0); 
        dir  : IN STD_LOGIC; -- '1' = right, '0' = left
        cout : OUT STD_LOGIC;
        res  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
    ); 
END Shifter; 

-- Define a matrix where each row represents a stage of the barrel shifter


ARCHITECTURE structural OF Shifter IS  

    SUBTYPE vector_t IS STD_LOGIC_VECTOR(n-1 DOWNTO 0);
    TYPE matrix_t IS ARRAY (0 TO k) OF vector_t;

    SIGNAL mat       : matrix_t;
    SIGNAL shift_amount : INTEGER RANGE 0 TO n-1;

BEGIN  

    shift_amount <= TO_INTEGER(UNSIGNED(X));

    
    
    init_gen : FOR i IN 0 TO n-1 GENERATE
        mat(0)(i) <= Y(i)       WHEN dir = '0' ELSE
                     Y(n-1-i);
    END GENERATE;

    
    stage_gen : FOR step IN 1 TO k GENERATE

        low_gen : FOR j IN 0 TO (2**(step-1))-1 GENERATE
            mat(step)(j) <= mat(step-1)(j) WHEN X(step-1) = '0' ELSE
                            '0';
        END GENERATE;

        high_gen : FOR j IN 2**(step-1) TO n-1 GENERATE
            mat(step)(j) <= mat(step-1)(j)                WHEN X(step-1) = '0' ELSE
                            mat(step-1)(j - 2**(step-1));
        END GENERATE;

    END GENERATE;

    
    out_gen : FOR i IN 0 TO n-1 GENERATE
        res(i) <= mat(k)(i)       WHEN dir = '0' ELSE
                  mat(k)(n-1-i);
    END GENERATE;

    -- carry out
    cout <= Y(n - shift_amount) WHEN (dir = '0' AND shift_amount > 0) ELSE
            Y(shift_amount - 1) WHEN (dir = '1' AND shift_amount > 0) ELSE
            '0';

END structural;
