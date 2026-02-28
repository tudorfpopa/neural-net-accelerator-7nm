** Library name: ECE555_xorcist
** Cell name: INV
** View name: schematic
.SUBCKT INV in out vdd! vss!
mn0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ENDS INV
