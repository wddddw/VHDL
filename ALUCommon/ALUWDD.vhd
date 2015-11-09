library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity ALUWDD is
	port 
	(   clk:in std_logic;
		reset:in std_logic;
		dinput:in std_logic_vector(15 downto 0);
		wr :in std_logic;
		op:in std_logic_vector(2 downto 0);
		sel:in std_logic;
		result:out std_logic_vector(15 downto 0);
		Z,C:out std_logic
	);
end entity ALUWDD;
architecture rtl of ALUWDD is
signal result1:std_logic_vector(16 downto 0);
signal A1,B1:std_logic_vector(16 downto 0);
begin
 process(clk,reset)
variable A,B:std_logic_vector(15 downto 0);
variable Z1,C1:std_logic;
   begin
    if(reset='0')then
       Z1:='0';
       C1:='0';
       result<="0000000000000000";
    elsif(clk'event and clk='1')then 
        if(sel='0' and wr='1')then 
          A:=dinput;
          A1<='0'&A;
         elsif(sel='1' and wr='1')then
          B:=dinput;
          B1<='0'&B;
        end if;
     end if;
     
         case op is
           when "000" => result1<=A1+B1;
                          C1:=result1(16);
                         if(result1="00000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "001" => result1<='0'&A+'1';
                          C1:=result1(16);
                         if(result1="00000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "010" => result1<=A1-B1;
                          C1:=result1(16);
                         if(result1="00000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "011" => result1<='0'&A-'1';
                          C1:=result1(16);
                         if(result1="00000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "100" => result1(15 downto 0)<=A and B;
                         C1:='0';
                         if(result1(15 downto 0)="0000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "101" => result1(15 downto 0)<=A or B;
                         C1:='0';
                         if(result1(15 downto 0)="0000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
           when "110" => result1(15 downto 0)<=not B;
                         C1:='0';
                         if(result1(15 downto 0)="0000000000000000")then
                          Z1:='1';
                          else
                          Z1:='0';
                         end if;
            when "111" => result1(15 downto 0)<=B;
            end case;
   if(clk'event and clk='1')then
         Z<=Z1;
         C<=C1;
   end if;
   result<=result1(15 downto 0);
  end process;
end rtl;


