** Library name: ECE555
** Cell name: INV
** View name: schematic
.subckt INV in out
mn0 out in vss! vss! nmos_rvt w=27e-9 l=20e-9 nfin=1
mp1 out in vdd! vdd! pmos_rvt w=54e-9 l=20e-9 nfin=2
.ends INV
** End of subcircuit definition.

** Library name: ECE555
** Cell name: AND2
** View name: schematic
xi6 y out<3> INV
xi5 y out<2> INV
xi4 y out<1> INV
xi3 y out<0> INV
mn1 y net1 vss! vss! nmos_sram w=54e-9 l=20e-9 nfin=2
mn0 net5 a vss! vss! nmos_sram w=108e-9 l=20e-9 nfin=4
mn4 net1 b net5 net5 nmos_sram w=108e-9 l=20e-9 nfin=4
mp5 y net1 vdd! y pmos_sram w=81e-9 l=20e-9 nfin=3
mp3 net1 a vdd! net1 pmos_sram w=81e-9 l=20e-9 nfin=3
mp2 net1 b vdd! net1 pmos_sram w=81e-9 l=20e-9 nfin=3
.END
