** Library name: ECE555_xorcist
** Cell name: XOR2
** View name: schematic
.subckt XOR2 a b y vdd vss _net2 _net3
mp0 a b y vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp1 _net2 _net3 y vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mn4 _net2 b y vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mn5 a _net3 y vss nmos_rvt w=54e-9 l=20e-9 nfin=2
.ends XOR2
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
** Cell name: XOR2_test
** View name: schematic
xi0 a b y vdd vss net6 net7 XOR2
xi2 b net7 vdd vss INV
xi1 a net6 vdd vss INV
.END
