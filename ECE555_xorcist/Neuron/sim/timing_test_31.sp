** Ternary Neuron Timing Test 31
** Test: x0=-1, x1=0, w0=-1, w1=0, w2=0
** Expected output: 1
** Uses 25ps rise/fall times per project specs

.TEMP 25.0
.OPTION ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 POST=2 ACCURATE NUMDGT=8 CASE=INSENSITIVE

** Include PDK models
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"

** Include neuron netlist
.INCLUDE "Neuron.sp"

** Define INV subcircuit for FO4 loads
.subckt INV in out vdd vss
mn0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends INV

** Supply voltages
vvdd vdd 0 DC 0.9
vvss vss 0 DC 0

** Instantiate neuron (PEX netlist defines it as a subcircuit)
xneuron vss x_1<0> x_1<1> x_0<0> x_0<1> vdd w_10<0> w_00<0> w_10<1> w_00<1> w_20<1> w_20<0> z_0<1> z_0<0> z_0<2> Neuron_submod

** Input stimulus: transition at 5ns with 25ps rise/fall
vx0_0 x_0<0> 0 PULSE(0 0.9 5n 25p 25p 500n 1000n)
vx0_1 x_0<1> 0 PULSE(0 0.9 5n 25p 25p 500n 1000n)
vx1_0 x_1<0> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)
vx1_1 x_1<1> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)
vw00_0 w_00<0> 0 PULSE(0 0.9 5n 25p 25p 500n 1000n)
vw00_1 w_00<1> 0 PULSE(0 0.9 5n 25p 25p 500n 1000n)
vw10_0 w_10<0> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)
vw10_1 w_10<1> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)
vw20_0 w_20<0> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)
vw20_1 w_20<1> 0 PULSE(0.9 0 5n 25p 25p 500n 1000n)

** Output loads - FO4
xinv_z0_0_0 z_0<0> z0_0_inv0 vdd vss INV
xinv_z0_0_1 z_0<0> z0_0_inv1 vdd vss INV
xinv_z0_0_2 z_0<0> z0_0_inv2 vdd vss INV
xinv_z0_0_3 z_0<0> z0_0_inv3 vdd vss INV
xinv_z0_1_0 z_0<1> z0_1_inv0 vdd vss INV
xinv_z0_1_1 z_0<1> z0_1_inv1 vdd vss INV
xinv_z0_1_2 z_0<1> z0_1_inv2 vdd vss INV
xinv_z0_1_3 z_0<1> z0_1_inv3 vdd vss INV
xinv_z0_2_0 z_0<2> z0_2_inv0 vdd vss INV
xinv_z0_2_1 z_0<2> z0_2_inv1 vdd vss INV
xinv_z0_2_2 z_0<2> z0_2_inv2 vdd vss INV
xinv_z0_2_3 z_0<2> z0_2_inv3 vdd vss INV

** Transient analysis - extended to 500ns for full settling
.TRAN 10p 500n

** Timing measurements
.MEAS TRAN t_input WHEN v(x_0<1>)=0.45 CROSS=1
.MEAS TRAN t_out0 WHEN v(z_0<0>)=0.45 CROSS=1
.MEAS TRAN t_out1 WHEN v(z_0<1>)=0.45 CROSS=1
.MEAS TRAN t_out2 WHEN v(z_0<2>)=0.45 CROSS=1
.MEAS TRAN tpd_0 PARAM='t_out0-t_input'
.MEAS TRAN tpd_1 PARAM='t_out1-t_input'
.MEAS TRAN tpd_2 PARAM='t_out2-t_input'

** Output values - measure at 490ns (fully settled)
.MEAS TRAN v_z0_0_final FIND v(z_0<0>) AT=490n
.MEAS TRAN v_z0_1_final FIND v(z_0<1>) AT=490n
.MEAS TRAN v_z0_2_final FIND v(z_0<2>) AT=490n

** Power - measure over stable period
.MEAS TRAN power_avg AVG POWER FROM=250n TO=500n

.END
