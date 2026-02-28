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
** Cell name: RELU
** View name: schematic
.subckt RELU vdd vss y<2> y<1> y<0> z<2> z<1> z<0>
xi1 y<1> y<2> z<1> vdd vss NOR2
xi0 y<2> y<0> z<0> vdd vss NOR2
xi3 net12 z<2> vdd vss INV
xi2 vss net12 vdd vss INV
.ends RELU
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
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: NAND2
** View name: schematic
.subckt NAND2 a b y vdd vss
mp0 y a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 y b vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn3 y a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn4 y a net3 vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 net3 b vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends NAND2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: ADDR3
** View name: schematic
.subckt ADDR3 a<1> a<0> cin vdd vss w<1> w<0> y<2> y<1> y<0> _net2 _net1
xi19 net27 net8 y<2> vdd vss XOR2
xi0 w<0> a<0> net3 vdd vss XOR2
xi17 net20 y<1> vdd vss INV
xi15 w<1> _net0 vdd vss INV
xi14 net17 net24 vdd vss INV
xi12 net10 net9 vdd vss INV
xi2 net3 y<0> vdd vss INV
xi22 net17 net9 net32 vdd vss NAND2
xi21 w<1> a<1> net16 vdd vss NAND2
xi20 net32 net16 net8 vdd vss NAND2
xi11 a<0> w<0> net10 vdd vss NAND2
xi18 cin w<1> net27 vdd vss _net1 _net0 XOR4
xi16 net17 net9 net20 vdd vss net24 net10 XOR4
xi13 w<1> a<1> net17 vdd vss _net0 _net2 XOR4
.ends ADDR3
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: NAND3
** View name: schematic
.subckt NAND3 a b c y vdd vss
mpm6 y a vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp7 y b vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp8 y c vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn5 y a net25 vss nmos_rvt w=81e-9 l=20e-9 nfin=3
mn4 net25 b net2 vss nmos_rvt w=81e-9 l=20e-9 nfin=3
mn3 net2 c vss vss nmos_rvt w=81e-9 l=20e-9 nfin=3
mn0 y a net25 vss nmos_rvt w=81e-9 l=20e-9 nfin=3
mn1 net25 b net2 vss nmos_rvt w=81e-9 l=20e-9 nfin=3
mn2 net2 c vss vss nmos_rvt w=81e-9 l=20e-9 nfin=3
.ends NAND3
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: ADDR2
** View name: schematic
.subckt ADDR2 a<1> a<0> b<1> b<0> cout s<1> s<0> vdd vss _net4 _net3 _net5 _net2 _net0 _net1
xi23 net10 net14 net8 cout vdd vss NAND3
xi18 net1 net5 vdd vss INV
xi11 cout _net0 vdd vss INV
xi25 _net1 s<1> vdd vss INV
xi5 net3 _net1 vdd vss INV
xi17 net4 net9 vdd vss INV
xi20 a<1> b<1> net10 vdd vss NAND2
xi22 _net2 a<1> net8 vdd vss NAND2
xi21 _net3 b<1> net14 vdd vss NAND2
xi16 a<0> b<0> net4 vdd vss NAND2
xi14 a<1> b<1> net1 vdd vss _net4 _net5 XOR4
xi13 a<0> b<0> s<0> vdd vss _net3 _net2 XOR4
xi19 net1 net9 net3 vdd vss net5 net4 XOR4
.ends ADDR2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: MULT2
** View name: schematic
.subckt MULT2 y<1> y<0> vdd vss w<1> w<0> x<1> x<0> _net0 _net1
xi0 w<1> x<1> net3 vdd vss XOR2
xi5 y<0> net3 _net0 vdd vss NAND2
xi3 x<0> w<0> _net1 vdd vss NAND2
xi6 _net0 y<1> vdd vss INV
xi4 _net1 y<0> vdd vss INV
.ends MULT2
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: Neuron_submod
** View name: schematic
.subckt Neuron_submod vss x_1<0> x_1<1> x_0<0> x_0<1> vdd w_10<0> w_00<0> w_10<1> w_00<1> w_20<1> w_20<0> z_0<1> z_0<0> z_0<2>
xi1 vdd vss addr3_out<2> addr3_out<1> addr3_out<0> z_0<2> z_0<1> z_0<0> RELU
xi2 net4<0> net4<1> net3 vdd vss w_20<1> w_20<0> addr3_out<2> addr3_out<1> addr3_out<0> net5 net6 ADDR3
xi3 net8<0> net8<1> net7<0> net7<1> net3 net4<0> net4<1> vdd vss net13<0> net13<1> net10<0> net10<1> net6 net5 ADDR2
xi5 net7<0> net7<1> vdd vss w_10<1> w_10<0> x_1<1> x_1<0> net10<0> net10<1> MULT2
xi4 net8<0> net8<1> vdd vss w_00<1> w_00<0> x_0<1> x_0<0> net13<0> net13<1> MULT2
.ends Neuron_submod

