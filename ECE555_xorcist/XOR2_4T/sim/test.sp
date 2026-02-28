
** TEST
.GLOBAL vss! vdd!
.TEMP 25.0
.OPTION
+	ARTIST=2
+	INGOLD=2
+	PARHIER=LOCAL
+	PSF=2
+ 	HIER_DELIM=0
.options accurate=1 NUGMDGT=8 measdgt=5 GMINDC=1e-18 DELMAX=1n method=gear INGOLD=2 POST=1
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"
.INCLUDE "XOR2_4T.sp" 	* load XOR2_4T gate netlist 
.INCLUDE "../../INV/sim/INV.sp"	* load inverter 
v1 vdd! 0 0.9v
v2 vss! 0 0v
v3 A 0 PWL(
+ 0ps 0v
+ 100ps 0v 125ps 0.9v
+ 200ps 0.9v 225ps 0v
+ 300ps 0v 325ps 0.9v
+ 400ps 0.9v 425ps 0v
+ 500ps 0v
)

v4 B 0 PWL(
+ 0ps 0v
+ 200ps 0v 225ps 0.9v
+ 400ps 0.9v 425 0v
+ 500ps 0v
)

* instantiate AND2 gate
xxor2 A B xor_out vdd! vss! XOR2_4T

* instantiate 4 inverters at the AND gate output
xinv1 xor_out inv1_out vdd! vss! INV
xinv2 xor_out inv2_out vdd! vss! INV
xinv3 xor_out inv3_out vdd! vss! INV
xinv4 xor_out inv4_out vdd! vss! INV

.OP
.TRAN STEP=1p STOP=600p
.end
