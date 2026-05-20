LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE work.aux_package.all;
--------------------------------------------------------------
entity top is
	generic (
		n : positive := 8 ;
		m : positive := 7 ;
		k : positive := 3
	); -- where k=log2(m+1)
	port(
		rst,ena,clk : in std_logic;
		x : in std_logic_vector(n-1 downto 0);
		DetectionCode : in integer range 0 to 3;
		detector : out std_logic
	);
end top;
------------- complete the top Architecture code --------------
architecture arc_sys of top is
	signal x_d1_w,x_d2_w,x_d2N_w : std_logic_vector(n-1 downto 0);
	signal valid_w : std_logic;
	signal diff_res : std_logic_vector(n-1 downto 0);
	signal cout_w : std_logic;
	signal counter_w,counter_r : integer range 0 to m+1 := 0;
	
begin
	process1: process (clk,rst)
	begin
		if rst = '1' then
			x_d1_w <= (others => '0');
			x_d2_w <=  (others => '0');
		elsif rising_edge(clk) then
			if ena = '1' then
				x_d1_w <= x;
				x_d2_w <= x_d1_w;
			end if;
		end if;
	end process;	

	---------------------------------------
	---------------Process 2---------------
	---------------------------------------
	x_d2N_w <= not x_d2_w;
	ADDER_MODULE: Adder generic map(length => n) port map(a => x_d1_w, b => x_d2N_w ,cin => '1', 
														  s => diff_res, cout => cout_w);
	
	valid_w <= '1' when diff_res =  DetectionCode + 1 else '0';
	counter_w <= counter_r + 1;

	process3: process (clk,rst)
	begin
		if rst = '1' then
			detector <= '0';
			counter_r <= 0;
		elsif rising_edge(clk) then
			if ena = '1' then
				if valid_w = '1' then
					if counter_w < m then
						counter_r <= counter_w;
					elsif counter_w >= m-1 then
						detector <= '1';
					else 
						detector <= '0';
					end if;
				else
					detector <= '0';
					counter_r <= 0;
				end if;
			end if;
		end if;
	end process;
end arc_sys;







