** Library name: ECE555_xorcist
** Cell name: XOR2_4T
** View name: schematic
.subckt XOR2_4T a b y vdd vss
mn1 net3 b vss vss nmos_rvt w=108e-9 l=20e-9 nfin=4
mn0 y a net3 vss nmos_rvt w=108e-9 l=20e-9 nfin=4
mp3 y a b vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 y b a vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends XOR2_4T
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
** Cell name: INV
** View name: schematic
.subckt INV in out vdd vss
mn0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends INV
** End of subcircuit definition.

** Library name: ECE555_xorcist
** Cell name: ADDR2_OPT
** View name: schematic
.subckt ADDR2_OPT a<0> a<1> b<0> b<1> s<0> s<1> cout vdd vss
xi7 b<1> b<0> net28 vdd vss XOR2_4T
xi4 a<1> b<1> net7 vdd vss XOR2_4T
xi3 net7 s<0> s<1> vdd vss XOR2_4T
xi2 a<0> b<0> s<0> vdd vss XOR2_4T
xi6 net18 net21 cout vdd vss AND2
xi5 a<0> a<1> net18 vdd vss AND2
xi8 net28 net21 vdd vss INV
.ends

