** Library name: ECE555_xorcist
** Cell name: XOR2_4T
** View name: schematic
.SUBCKT XOR2_4T a b y vdd! vss!
mn1 net3 b vss vss nmos_rvt w=108e-9 l=20e-9 nfin=4
mn0 y a net3 vss nmos_rvt w=108e-9 l=20e-9 nfin=4
mp3 y a b vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
mp2 y b a vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ENDS XOR2_4T
