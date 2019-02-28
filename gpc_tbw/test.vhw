--------------------------------------------------------------------------------
-- Copyright (c) 1995-2007 Xilinx, Inc.
-- All Right Reserved.
--------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   / 
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 9.2i
--  \   \         Application : ISE
--  /   /         Filename : test.vhw
-- /___/   /\     Timestamp : Mon Feb 25 22:48:21 2019
-- \   \  /  \ 
--  \___\/\___\ 
--
--Command: 
--Design Name: test
--Device: Xilinx
--

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library ieee;
use ieee.numeric_std.all;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE STD.TEXTIO.ALL;

ENTITY test IS
END test;

ARCHITECTURE testbench_arch OF test IS
    FILE RESULTS: TEXT OPEN WRITE_MODE IS "results.txt";

    COMPONENT GPC_Hvd_a
        PORT (
            clk : In std_logic;
            rst : In std_logic;
            enter : In std_logic;
            Din : In std_logic_vector (7 DownTo 0);
            Dout : Out std_logic_vector (7 DownTo 0);
            inFlags : Out std_logic_vector (7 DownTo 0);
            outFlags : Out std_logic_vector (7 DownTo 0);
            done : Out std_logic
        );
    END COMPONENT;

    SIGNAL clk : std_logic := '0';
    SIGNAL rst : std_logic := '0';
    SIGNAL enter : std_logic := '0';
    SIGNAL Din : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL Dout : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL inFlags : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL outFlags : std_logic_vector (7 DownTo 0) := "00000000";
    SIGNAL done : std_logic := '0';

    constant PERIOD : time := 200 ns;
    constant DUTY_CYCLE : real := 0.5;
    constant OFFSET : time := 100 ns;

    BEGIN
        UUT : GPC_Hvd_a
        PORT MAP (
            clk => clk,
            rst => rst,
            enter => enter,
            Din => Din,
            Dout => Dout,
            inFlags => inFlags,
            outFlags => outFlags,
            done => done
        );

        PROCESS    -- clock process for clk
        BEGIN
            WAIT for OFFSET;
            CLOCK_LOOP : LOOP
                clk <= '0';
                WAIT FOR (PERIOD - (PERIOD * DUTY_CYCLE));
                clk <= '1';
                WAIT FOR (PERIOD * DUTY_CYCLE);
            END LOOP CLOCK_LOOP;
        END PROCESS;

        PROCESS
            BEGIN
                -- -------------  Current Time:  185ns
                WAIT FOR 185 ns;
                rst <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  385ns
                WAIT FOR 200 ns;
                rst <= '0';
                Din <= "00000001";
                -- -------------------------------------
                -- -------------  Current Time:  785ns
                WAIT FOR 400 ns;
                enter <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  985ns
                WAIT FOR 200 ns;
                enter <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  1785ns
                WAIT FOR 800 ns;
                Din <= "00000010";
                -- -------------------------------------
                -- -------------  Current Time:  1985ns
                WAIT FOR 200 ns;
                enter <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  2185ns
                WAIT FOR 200 ns;
                enter <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  25985ns
                WAIT FOR 23800 ns;
                enter <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  26185ns
                WAIT FOR 200 ns;
                enter <= '0';
                -- -------------------------------------
                -- -------------  Current Time:  27985ns
                WAIT FOR 1800 ns;
                enter <= '1';
                -- -------------------------------------
                -- -------------  Current Time:  28185ns
                WAIT FOR 200 ns;
                enter <= '0';
                -- -------------------------------------
                WAIT FOR 12015 ns;

            END PROCESS;

    END testbench_arch;

