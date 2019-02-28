VERSION 6
BEGIN SCHEMATIC
    BEGIN ATTR DeviceFamilyName "spartan3e"
        DELETE all:0
        EDITNAME all:0
        EDITTRAIT all:0
    END ATTR
    BEGIN NETLIST
        SIGNAL go
        SIGNAL mainClk
        SIGNAL reset
        SIGNAL XLXN_6
        SIGNAL done
        SIGNAL Din(3:0)
        SIGNAL Dout(3:0)
        SIGNAL inFlags(7:0)
        SIGNAL outFlags(7:0)
        SIGNAL monClk
        PORT Input go
        PORT Input mainClk
        PORT Input reset
        PORT Output done
        PORT Input Din(3:0)
        PORT Output Dout(3:0)
        PORT Output inFlags(7:0)
        PORT Output outFlags(7:0)
        PORT Output monClk
        BEGIN BLOCKDEF Button
            TIMESTAMP 2017 8 22 5 47 12
            RECTANGLE N 64 -192 320 0 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 320 -160 384 -160 
        END BLOCKDEF
        BEGIN BLOCKDEF GPC_Hvd_a
            TIMESTAMP 2019 2 21 19 50 42
            RECTANGLE N 64 -256 320 0 
            LINE N 64 -224 0 -224 
            LINE N 64 -160 0 -160 
            LINE N 64 -96 0 -96 
            RECTANGLE N 0 -44 64 -20 
            LINE N 64 -32 0 -32 
            LINE N 320 -224 384 -224 
            RECTANGLE N 320 -172 384 -148 
            LINE N 320 -160 384 -160 
            RECTANGLE N 320 -108 384 -84 
            LINE N 320 -96 384 -96 
            RECTANGLE N 320 -44 384 -20 
            LINE N 320 -32 384 -32 
        END BLOCKDEF
        BEGIN BLOCKDEF ClkMon
            TIMESTAMP 2017 8 22 6 26 22
            RECTANGLE N 64 -128 320 0 
            LINE N 64 -96 0 -96 
            LINE N 64 -32 0 -32 
            LINE N 320 -96 384 -96 
        END BLOCKDEF
        BEGIN BLOCK XLXI_1 Button
            PIN CLK mainClk
            PIN RST reset
            PIN x go
            PIN y XLXN_6
        END BLOCK
        BEGIN BLOCK XLXI_2 GPC_Hvd_a
            PIN clk mainClk
            PIN rst reset
            PIN enter XLXN_6
            PIN Din(3:0) Din(3:0)
            PIN done done
            PIN Dout(3:0) Dout(3:0)
            PIN inFlags(7:0) inFlags(7:0)
            PIN outFlags(7:0) outFlags(7:0)
        END BLOCK
        BEGIN BLOCK XLXI_3 ClkMon
            PIN clk mainClk
            PIN rst reset
            PIN y monClk
        END BLOCK
    END NETLIST
    BEGIN SHEET 1 3520 2720
        BEGIN INSTANCE XLXI_1 784 1040 R0
        END INSTANCE
        BEGIN INSTANCE XLXI_2 1328 1104 R0
        END INSTANCE
        BEGIN BRANCH go
            WIRE 640 1008 784 1008
        END BRANCH
        BEGIN BRANCH XLXN_6
            WIRE 1168 880 1216 880
            WIRE 1216 880 1216 1008
            WIRE 1216 1008 1328 1008
        END BRANCH
        BEGIN BRANCH done
            WIRE 1712 880 1760 880
        END BRANCH
        BEGIN BRANCH Din(3:0)
            WIRE 1312 1072 1328 1072
            WIRE 1312 1072 1312 1216
            WIRE 1312 1216 1328 1216
        END BRANCH
        BEGIN INSTANCE XLXI_3 784 1424 R0
        END INSTANCE
        BEGIN BRANCH mainClk
            WIRE 640 880 720 880
            WIRE 720 880 768 880
            WIRE 768 880 784 880
            WIRE 720 880 720 1328
            WIRE 720 1328 784 1328
            WIRE 768 768 768 880
            WIRE 768 768 1232 768
            WIRE 1232 768 1232 880
            WIRE 1232 880 1328 880
        END BRANCH
        BEGIN BRANCH reset
            WIRE 640 944 688 944
            WIRE 688 944 768 944
            WIRE 768 944 784 944
            WIRE 768 944 768 1120
            WIRE 768 1120 1232 1120
            WIRE 688 944 688 1392
            WIRE 688 1392 784 1392
            WIRE 1232 944 1232 1120
            WIRE 1232 944 1328 944
        END BRANCH
        BEGIN BRANCH Dout(3:0)
            WIRE 1712 944 1760 944
        END BRANCH
        BEGIN BRANCH inFlags(7:0)
            WIRE 1712 1008 1760 1008
        END BRANCH
        BEGIN BRANCH outFlags(7:0)
            WIRE 1712 1072 1760 1072
        END BRANCH
        IOMARKER 640 880 mainClk R180 28
        IOMARKER 640 944 reset R180 28
        IOMARKER 640 1008 go R180 28
        BEGIN BRANCH monClk
            WIRE 1168 1328 1200 1328
        END BRANCH
        IOMARKER 1200 1328 monClk R0 28
        IOMARKER 1328 1216 Din(3:0) R0 28
        IOMARKER 1760 1072 outFlags(7:0) R0 28
        IOMARKER 1760 1008 inFlags(7:0) R0 28
        IOMARKER 1760 944 Dout(3:0) R0 28
        IOMARKER 1760 880 done R0 28
    END SHEET
END SCHEMATIC
