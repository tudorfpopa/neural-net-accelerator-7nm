**Test                                                                                                      
.GLOBAL vss! vdd!
.TEMP 25.0
.OPTION
+    ARTIST=2
+    INGOLD=2
+    PARHIER=LOCAL
+    PSF=2
+    HIER_DELIM=0
.options accurate=1 NUMDGT=8 measdgt=5 GMINDC=1e-18 DELMAX=1n method=gear INGOLD=2 POST=1
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"
.INCLUDE "AND2.sp"
v1 vdd! 0 0.9v
v2 vss! 0 0v
v3 A 0 PWL(
+ 0ps   0v
+ 100ps 0v   125ps 0.9v
+ 200ps 0.9v 225ps 0v
+ 300ps 0v   325ps 0.9v
+ 400ps 0.9v 425ps 0v
+ 500ps 0v
)
v4 B 0 PWL(
+ 0ps   0v
+ 200ps 0v   225ps 0.9v
+ 400ps 0.9v 425ps 0v
+ 500ps 0v
)
.OP
.TRAN STEP=1p STOP=500p
.end
