* Example HSPICE testbench file (test.sp)

* transistor model
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"

* Design Under Test (DUT)
.INCLUDE "AND2.sp" 

* Enable this line for schematic netlist
*.INCLUDE "INV.pex.netlist" * Enable this line for layout netlist
* Simulation Parameters
.TEMP 25.0

.options artist=2 ingold=2 parhier=local psf=2 hier_delim=0 accurate=1 NUMDGT=8 measdgt=5 GMINDC=1e-18 DELMAX=1n method=gear INGOLD=2 POST=1

* Instantiate (DUT)
xdut gnd vdd in out INV
vdd0 vdd gnd 0.9v
vin in gnd pwl(0ns 0.9v 1ns 0.9v 1.05ns 0v 6ns 0v 6.05ns 0.9v 12ns 0.9v)

* Set fanout manually or by instantiating four other inverters
cout out gnd 100f

* Transient analysis
.tr 10ps 12ns
