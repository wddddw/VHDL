LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY GENERALREG IS
	PORT(
		CLK:		IN STD_LOGIC;
		RESET: 		IN STD_LOGIC;
		DRWR:		IN STD_LOGIC;
		D_INPUT:	IN STD_LOGIC_VECTOR(15 downto 0);
		DR:			IN STD_LOGIC_VECTOR(1 downto 0);
		DR_DATA:	OUT STD_LOGIC_VECTOR(15 downto 0);
		SR:			IN STD_LOGIC_VECTOR(1 downto 0);
		SR_DATA:	OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END ENTITY GENERALREG;

ARCHITECTURE STRUCTURE OF GENERALREG IS

SIGNAL SELED: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL COMMONOUT0: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL COMMONOUT1: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL COMMONOUT2: STD_LOGIC_VECTOR(15 downto 0);
SIGNAL COMMONOUT3: STD_LOGIC_VECTOR(15 downto 0);

COMPONENT REG_16 IS
	PORT(
		CLOCK:	IN STD_LOGIC;
		CLR:	IN STD_LOGIC;
		DRW:	IN STD_LOGIC;
		SEL:	IN STD_LOGIC;
--		REG:	BUFFER STD_LOGIC_VECTOR(15 downto 0);
		D:		IN STD_LOGIC_VECTOR(15 downto 0);
		Q:		OUT STD_LOGIC_VECTOR(15 downto 0) 
	);
END COMPONENT REG_16;

COMPONENT SELECTOR2_4 IS
	PORT(
		SEL:	IN STD_LOGIC_VECTOR(1 downto 0);
		SEL00:	OUT STD_LOGIC;
		SEL01:	OUT STD_LOGIC;
		SEL02:	OUT STD_LOGIC;
		SEL03:	OUT STD_LOGIC
	);
END COMPONENT SELECTOR2_4;

COMPONENT SELECTOR4_1 IS
	PORT(
		INPUT0: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT1: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT2: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT3: IN STD_LOGIC_VECTOR(15 downto 0);
		SEL:	IN STD_LOGIC_VECTOR(1 downto 0);
		OUTPUT:	OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END COMPONENT SELECTOR4_1;

BEGIN
	G_TRANS:SELECTOR2_4 PORT MAP(
		SEL => DR,
		SEL00 => SELED(0),
		SEL01 => SELED(1),
		SEL02 => SELED(2),
		SEL03 => SELED(3)
	);
	REG0:REG_16 PORT MAP(
		CLOCK => CLK,
		CLR => RESET,
		DRW => DRWR,
		SEL => SELED(0),
		D => D_INPUT,
		Q => COMMONOUT0
	);
	REG2:REG_16 PORT MAP(
		CLOCK => CLK,
		CLR => RESET,
		DRW => DRWR,
		SEL => SELED(1),
		D => D_INPUT,
		Q => COMMONOUT1
	);
	REG3:REG_16 PORT MAP(
		CLOCK => CLK,
		CLR => RESET,
		DRW => DRWR,
		SEL => SELED(2),
		D => D_INPUT,
		Q => COMMONOUT2
	);
	REG4:REG_16 PORT MAP(
		CLOCK => CLK,
		CLR => RESET,
		DRW => DRWR,
		SEL => SELED(3),
		D => D_INPUT,
		Q => COMMONOUT3
	);
	GDR_DATA:SELECTOR4_1 PORT MAP(
		INPUT0 => COMMONOUT0,
		INPUT1 => COMMONOUT1,
		INPUT2 => COMMONOUT2,
		INPUT3 => COMMONOUT3,
		SEL => DR,
		OUTPUT => DR_DATA
	);
	GSR_DATA:SELECTOR4_1 PORT MAP(
		INPUT0 => COMMONOUT0,
		INPUT1 => COMMONOUT1,
		INPUT2 => COMMONOUT2,
		INPUT3 => COMMONOUT3,
		SEL => SR,
		OUTPUT => SR_DATA
	);		
END ARCHITECTURE STRUCTURE;



--16BIT REGISTER
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY REG_16 IS
	PORT(
		CLOCK:	IN STD_LOGIC;
		CLR:	IN STD_LOGIC;
		DRW:	IN STD_LOGIC;
		SEL:	IN STD_LOGIC;
--		REG:	BUFFER STD_LOGIC_VECTOR(15 downto 0);
		D:		IN STD_LOGIC_VECTOR(15 downto 0);
		Q:		OUT STD_LOGIC_VECTOR(15 downto 0) 
	);
END ENTITY REG_16;

ARCHITECTURE BEHAV OF REG_16 IS
BEGIN
PROCESS(CLR,DRW,SEL,CLOCK)
BEGIN
	IF CLR='1' THEN
		Q(15 downto 0)<="0000000000000000";
--	ELSIF (DRW='1' AND SEL='1' AND RISING_EDGE(CLOCK)) THEN
--		Q(15 downto 0)<=D(15 downto 0);
	ELSIF (CLOCK'EVENT AND CLOCK='1') THEN
		IF(DRW='1' AND SEL='1') THEN
			Q(15 downto 0)<=D(15 downto 0);
		END IF;
	END IF;
END PROCESS;
END ARCHITECTURE BEHAV;

--SELECTOR2 IN 4
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY SELECTOR2_4 IS
	PORT(
		SEL:	IN STD_LOGIC_VECTOR(1 downto 0);
		SEL00:	OUT STD_LOGIC;
		SEL01:	OUT STD_LOGIC;
		SEL02:	OUT STD_LOGIC;
		SEL03:	OUT STD_LOGIC
	);
END ENTITY SELECTOR2_4;
ARCHITECTURE BEHAV OF SELECTOR2_4 IS
BEGIN
	SEL00 <= NOT(SEL(0)) AND NOT(SEL(1));
	SEL01 <= SEL(0) AND NOT(SEL(1));
	SEL02 <= NOT(SEL(0)) AND SEL(1);
	SEL03 <= SEL(0) AND SEL(1);
--	PROCESS(SEL)
--	BEGIN
--		IF SEL = "00" THEN
--			SEL00 <= '1';
--			SEL01 <= '0';
--			SEL02 <= '0';
--			SEL03 <= '0';
--		ELSIF SEL = "01" THEN
--			SEL00 <= '0';
--			SEL01 <= '1';
--			SEL02 <= '0';
--			SEL03 <= '0';
--		ELSIF SEL = "10" THEN
--			SEL00 <= '0';
--			SEL01 <= '0';
--			SEL02 <= '1';
--			SEL03 <= '0';
--		ELSIF SEL = "11" THEN
--			SEL00 <= '0';
--			SEL01 <= '0';
--			SEL02 <= '0';
--			SEL03 <= '1';
--		END IF;
--	END PROCESS;
END ARCHITECTURE BEHAV;

--4 SELECT 1 SELECTOR WITH 2 BIT VECTOR
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY SELECTOR4_1 IS
	PORT(
		INPUT0: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT1: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT2: IN STD_LOGIC_VECTOR(15 downto 0);
		INPUT3: IN STD_LOGIC_VECTOR(15 downto 0);
		SEL:	IN STD_LOGIC_VECTOR(1 downto 0);
		OUTPUT:	OUT STD_LOGIC_VECTOR(15 downto 0)
	);
END ENTITY SELECTOR4_1;

ARCHITECTURE BEHAV OF SELECTOR4_1 IS
BEGIN
	PROCESS(SEL,INPUT0,INPUT1,INPUT2,INPUT3)
	BEGIN
		IF SEL = "00" THEN
			OUTPUT <= INPUT0;
		ELSIF SEL = "01" THEN
			OUTPUT <= INPUT1;
		ELSIF SEL = "10" THEN
			OUTPUT <= INPUT2;
		ELSIF SEL = "11" THEN
			OUTPUT <= INPUT3;
		END IF;
	END PROCESS;
END ARCHITECTURE BEHAV;