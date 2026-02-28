* 2-bit Adder Exhaustive Testbench
* Tests all 9 valid input combinations for ternary inputs {-1, 0, 1}
* Inputs: a[1:0], b[1:0] in 2's complement
* Output: s[2:0] in 2's complement

.title 2-bit Adder Testbench

* Include your technology library and adder subcircuit
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"
.INCLUDE './ADDR2_OPT.sp'

* Supply voltage
.param supply=0.9

* Power supplies
vdd vdd 0 dc supply
vss vss 0 dc 0

* DUT instantiation (matching ADDR2_OPT pin order)
* Pins: a<0> a<1> b<0> b<1> s<0> s<1> cout vdd vss
XDUT a<0> a<1> b<0> b<1> s<0> s<1> cout vdd vss ADDR2_OPT

* Input voltage sources with piecewise linear
* Each test case gets 10ns
.param period=10n
.param vlow=0
.param vhigh=supply
.param trise=115p
.param tfall=115p

* a<0> pattern: 0,0,0,1,1,1,1,1,1
va0 a<0> 0 pwl(
+ 0n vlow
+ '30n+200p' vlow '30n+200p+trise' vhigh
+ 90n vhigh)

* a<1> pattern: 0,0,1,0,0,1,1,1,1
va1 a<1> 0 pwl(
+ 0n vlow
+ 20n vlow '20n+trise' vhigh
+ 30n vhigh '30n+tfall' vlow
+ 50n vlow '50n+trise' vhigh
+ 90n vhigh)

* b<0> pattern: 0,1,1,0,1,0,1,1,1
vb0 b<0> 0 pwl(
+ 0n vlow
+ 10n vlow '10n+trise' vhigh
+ '30n+200p' vhigh '30n+200p+tfall' vlow
+ 40n vlow '40n+trise' vhigh
+ 90n vhigh)

* b<1> pattern: 0,0,1,0,0,0,0,1,1
vb1 b<1> 0 pwl(
+ 0n vlow
+ 20n vlow '20n+trise' vhigh
+ 30n vhigh '30n+tfall' vlow
+ 70n vlow '70n+trise' vhigh
+ 90n vhigh)

* Test vector sequence (0-90ns):
* Time | a<1> a<0> | b<1> b<0> | a_val | b_val | Expected s<2> s<1> s<0> | Sum
* -----|-----------|-----------|-------|-------|-------------------------|-----
*  0ns |   0   0   |   0   0   |   0   |   0   |       0    0    0       |  0
* 10ns |   0   0   |   0   1   |   0   |   1   |       0    0    1       |  1
* 20ns |   0   0   |   1   1   |   0   |  -1   |       1    1    1       | -1
* 30ns |   0   1   |   0   0   |   1   |   0   |       0    0    1       |  1
* 40ns |   0   1   |   0   1   |   1   |   1   |       0    1    0       |  2
* 50ns |   0   1   |   1   1   |   1   |  -1   |       0    0    0       |  0
* 60ns |   1   1   |   0   0   |  -1   |   0   |       1    1    1       | -1
* 70ns |   1   1   |   0   1   |  -1   |   1   |       0    0    0       |  0
* 80ns |   1   1   |   1   1   |  -1   |  -1   |       1    1    0       | -2

* Analysis commands
.tran 1p 90n

* Measure propagation delays (from a<0> transition at 30ns)
.meas tran tpd_s0 trig v(a<0>) val='supply/2' rise=1 
+                  targ v(s<0>) val='supply/2' rise=1

.meas tran tpd_s1 trig v(a<0>) val='supply/2' rise=1 
+                  targ v(s<1>) val='supply/2' fall=1

.meas tran tpd_s2 trig v(a<0>) val='supply/2' rise=1 
+                  targ v(cout) val='supply/2' fall=1

* Measure power consumption
.meas tran avg_power avg power from=0n to=90n

* Print results
.print tran v(a<1>) v(a<0>) v(b<1>) v(b<0>) v(cout) v(s<1>) v(s<0>)

* Options
.option post=2
.option accurate
.option gmindc=1e-15

.end
