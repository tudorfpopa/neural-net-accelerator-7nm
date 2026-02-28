** Library name: ECE555_xorcist
** Cell name: NAND2
** View name: schematic
.subckt NAND2 a b y vdd vss
mp0 y a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 y b vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn2 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn3 y a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn4 y a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends NAND2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: OR2
** View name: schematic
.subckt OR2 a b y vdd vss
mp0 net4 b net1 vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 net8 a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 net4 b net8 vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp3 net1 a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp10 y net4 vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn4 net4 a vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn0 y net4 vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 net4 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends OR2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: AND2
** View name: schematic
.subckt AND2 a b y vdd vss
mp0 y net5 vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 net5 a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 net5 b vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn3 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn4 net5 a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 net5 a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn6 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn7 y net5 vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends AND2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: NOR2
** View name: schematic
.subckt NOR2 a b y vdd vss
mp0 y b net1 vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 net8 a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 y b net8 vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp3 net1 a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn4 y a vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 y b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends NOR2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: INV
** View name: schematic
.subckt INV in out vdd vss
mn0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends INV
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: XOR4
** View name: schematic
.subckt XOR4 a b y vdd vss _net2 _net3
mp0 a b y vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 _net2 _net3 y vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn4 _net2 b y vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 a _net3 y vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends XOR4
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: XOR2
** View name: schematic
.subckt XOR2 a b y vdd vss
xi3 a b y vdd vss net6 net7 XOR4
xi2 b net7 vdd vss INV
xi1 a net6 vdd vss INV
.ends XOR2

** Library name: ECE555_xorcist
** Cell name: Neuron
** View name: schematic
xi114 adder_0_s<0> w_20<0> net23 vdd vss NAND2
xi108 net13 mult_out_1<0> net21 vdd vss NAND2
xi105 net13 net14 net12 vdd vss NAND2
xi104 x_0<0> w_00<0> net9 vdd vss NAND2
xi101 x_1<0> w_10<0> net7 vdd vss NAND2
xi98 mult_out_1<0> net6 net11 vdd vss NAND2
xi64 net24 net25 net80 vdd vss NAND2
xi63 net74 net80 net59 vdd vss NAND2
xi62 w_20<1> net1 net74 vdd vss NAND2
xi42 net41 net20 net22 vdd vss NAND2
xi41 net15 net22 adder_0_cout vdd vss NAND2
xi40 net10 net19 net15 vdd vss NAND2
xi115 net24 net25 net4 vdd vss net16 net23 XOR4
xi112 net5 w_20<1> net58 vdd vss net27 net26 XOR4
xi111 w_20<1> net1 net24 vdd vss net26 net65 XOR4
xi110 net41 net20 adder_0_s<1> vdd vss net18 net21 XOR4
xi103 net19 net10 net41 vdd vss net12 net11 XOR4
xi100 net13 mult_out_1<0> adder_0_s<0> vdd vss net9 net7 XOR4
xi69 adder_1_cout adder_1_s<1> z_0<1> vdd vss NOR2
xi68 adder_1_cout adder_1_s<0> z_0<0> vdd vss NOR2
xi118 net41 net18 vdd vss INV
xi117 net24 net16 vdd vss INV
xi116 net23 net25 vdd vss INV
xi113 w_20<1> net26 vdd vss INV
xi109 net21 net20 vdd vss INV
xi107 net12 net19 vdd vss INV
xi106 net9 net13 vdd vss INV
xi102 net11 net10 vdd vss INV
xi99 net7 mult_out_1<0> vdd vss INV
xi82 net3 z_0<2> vdd vss INV
xi83 vss net3 vdd vss INV
xi57 net65 net1 vdd vss INV
xi56 adder_0_s<1> net65 vdd vss INV
xi96 net8 net27 vdd vss INV
xi94 net2 adder_1_s<0> vdd vss INV
xi93 net4 adder_1_s<1> vdd vss INV
xi97 net27 net5 vdd vss INV
xi76 adder_0_s<0> w_20<0> net2 vdd vss XOR2
xi79 net58 net59 adder_1_cout vdd vss XOR2
xi95 adder_0_cout net41 net8 vdd vss XOR2
xi87 w_10<1> x_1<1> net6 vdd vss XOR2
xi86 x_0<1> w_00<1> net14 vdd vss XOR2
.END
