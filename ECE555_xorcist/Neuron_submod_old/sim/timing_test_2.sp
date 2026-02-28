** Ternary Neuron Timing Test 2
** Fixed weights: w0=-1, w1=-1, w2=1
** Input sequence: 9 different input combinations
** Each input held for 500ns, transition time 25ps

.TEMP 25.0
.OPTION ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 POST=2 ACCURATE NUMDGT=8 CASE=INSENSITIVE

** Include PDK models
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"

** Include neuron netlist
.INCLUDE "Neuron_submod.pex.netlist"

** Define INV subcircuit for FO4 loads
.subckt INV in out vdd vss
mn0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
mp1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends INV

** Supply voltages
vvdd vdd 0 DC 0.9
vvss vss 0 DC 0

** Instantiate neuron
xneuron vss x_1<0> x_1<1> x_0<0> x_0<1> vdd w_10<0> w_00<0> w_10<1> w_00<1> w_20<1> w_20<0> z_0<1> z_0<0> z_0<2> Neuron_submod

** Fixed weights (DC)
vw00_0 w_00<0> 0 DC 0.9
vw00_1 w_00<1> 0 DC 0.9
vw10_0 w_10<0> 0 DC 0.9
vw10_1 w_10<1> 0 DC 0.9
vw20_0 w_20<0> 0 DC 0
vw20_1 w_20<1> 0 DC 0.9

** Cycling inputs (PWL waveforms)
vx0_0 x_0<0> 0 PWL 0 0 4.975n 0 5.025n 0.9 499n 0.9 504.975n 0.9 505.025n 0.9 999n 0.9 1004.975n 0.9 1005.025n 0.9 1499n 0.9 1504.975n 0.9 1505.025n 0 1999n 0 2004.975n 0 2005.025n 0 2499n 0 2504.975n 0 2505.025n 0 2999n 0 3004.975n 0 3005.025n 0 3499n 0 3504.975n 0 3505.025n 0 3999n 0 4004.975n 0 4005.025n 0 4499n 0
vx0_1 x_0<1> 0 PWL 0 0 4.975n 0 5.025n 0.9 499n 0.9 504.975n 0.9 505.025n 0.9 999n 0.9 1004.975n 0.9 1005.025n 0.9 1499n 0.9 1504.975n 0.9 1505.025n 0 1999n 0 2004.975n 0 2005.025n 0 2499n 0 2504.975n 0 2505.025n 0 2999n 0 3004.975n 0 3005.025n 0.9 3499n 0.9 3504.975n 0.9 3505.025n 0.9 3999n 0.9 4004.975n 0.9 4005.025n 0.9 4499n 0.9
vx1_0 x_1<0> 0 PWL 0 0 4.975n 0 5.025n 0.9 499n 0.9 504.975n 0.9 505.025n 0 999n 0 1004.975n 0 1005.025n 0 1499n 0 1504.975n 0 1505.025n 0.9 1999n 0.9 2004.975n 0.9 2005.025n 0 2499n 0 2504.975n 0 2505.025n 0 2999n 0 3004.975n 0 3005.025n 0.9 3499n 0.9 3504.975n 0.9 3505.025n 0 3999n 0 4004.975n 0 4005.025n 0 4499n 0
vx1_1 x_1<1> 0 PWL 0 0 4.975n 0 5.025n 0.9 499n 0.9 504.975n 0.9 505.025n 0 999n 0 1004.975n 0 1005.025n 0.9 1499n 0.9 1504.975n 0.9 1505.025n 0.9 1999n 0.9 2004.975n 0.9 2005.025n 0 2499n 0 2504.975n 0 2505.025n 0.9 2999n 0.9 3004.975n 0.9 3005.025n 0.9 3499n 0.9 3504.975n 0.9 3505.025n 0 3999n 0 4004.975n 0 4005.025n 0.9 4499n 0.9

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

** Transient analysis
.TRAN 1p 4500n

** Measurements for each input in sequence

** Input 0: x0=-1, x1=-1, expected=3
.MEAS TRAN v_z0_0_inp0 FIND v(z_0<0>) AT=490n
.MEAS TRAN v_z0_1_inp0 FIND v(z_0<1>) AT=490n
.MEAS TRAN v_z0_2_inp0 FIND v(z_0<2>) AT=490n

** Input 1: x0=-1, x1=0, expected=2
.MEAS TRAN v_z0_0_inp1 FIND v(z_0<0>) AT=990n
.MEAS TRAN v_z0_1_inp1 FIND v(z_0<1>) AT=990n
.MEAS TRAN v_z0_2_inp1 FIND v(z_0<2>) AT=990n

** Input 2: x0=-1, x1=1, expected=1
.MEAS TRAN v_z0_0_inp2 FIND v(z_0<0>) AT=1490n
.MEAS TRAN v_z0_1_inp2 FIND v(z_0<1>) AT=1490n
.MEAS TRAN v_z0_2_inp2 FIND v(z_0<2>) AT=1490n

** Input 3: x0=0, x1=-1, expected=2
.MEAS TRAN v_z0_0_inp3 FIND v(z_0<0>) AT=1990n
.MEAS TRAN v_z0_1_inp3 FIND v(z_0<1>) AT=1990n
.MEAS TRAN v_z0_2_inp3 FIND v(z_0<2>) AT=1990n

** Input 4: x0=0, x1=0, expected=1
.MEAS TRAN v_z0_0_inp4 FIND v(z_0<0>) AT=2490n
.MEAS TRAN v_z0_1_inp4 FIND v(z_0<1>) AT=2490n
.MEAS TRAN v_z0_2_inp4 FIND v(z_0<2>) AT=2490n

** Input 5: x0=0, x1=1, expected=0
.MEAS TRAN v_z0_0_inp5 FIND v(z_0<0>) AT=2990n
.MEAS TRAN v_z0_1_inp5 FIND v(z_0<1>) AT=2990n
.MEAS TRAN v_z0_2_inp5 FIND v(z_0<2>) AT=2990n

** Input 6: x0=1, x1=-1, expected=1
.MEAS TRAN v_z0_0_inp6 FIND v(z_0<0>) AT=3490n
.MEAS TRAN v_z0_1_inp6 FIND v(z_0<1>) AT=3490n
.MEAS TRAN v_z0_2_inp6 FIND v(z_0<2>) AT=3490n

** Input 7: x0=1, x1=0, expected=0
.MEAS TRAN v_z0_0_inp7 FIND v(z_0<0>) AT=3990n
.MEAS TRAN v_z0_1_inp7 FIND v(z_0<1>) AT=3990n
.MEAS TRAN v_z0_2_inp7 FIND v(z_0<2>) AT=3990n

** Input 8: x0=1, x1=1, expected=0
.MEAS TRAN v_z0_0_inp8 FIND v(z_0<0>) AT=4490n
.MEAS TRAN v_z0_1_inp8 FIND v(z_0<1>) AT=4490n
.MEAS TRAN v_z0_2_inp8 FIND v(z_0<2>) AT=4490n

** Propagation delay measurements for all transitions

** Transition 0 (at 5ns)
.MEAS TRAN t_in_0 WHEN v(x_0<1>)=0.45 CROSS=1
.MEAS TRAN t_out0_0 WHEN v(z_0<0>)=0.45 CROSS=1
.MEAS TRAN t_out1_0 WHEN v(z_0<1>)=0.45 CROSS=1
.MEAS TRAN t_out2_0 WHEN v(z_0<2>)=0.45 CROSS=1
.MEAS TRAN tpd_0_0 PARAM='t_out0_0-t_in_0'
.MEAS TRAN tpd_1_0 PARAM='t_out1_0-t_in_0'
.MEAS TRAN tpd_2_0 PARAM='t_out2_0-t_in_0'

** Transition 1 (at 505ns)
.MEAS TRAN t_in_1 WHEN v(x_0<1>)=0.45 CROSS=2
.MEAS TRAN t_out0_1 WHEN v(z_0<0>)=0.45 CROSS=2
.MEAS TRAN t_out1_1 WHEN v(z_0<1>)=0.45 CROSS=2
.MEAS TRAN t_out2_1 WHEN v(z_0<2>)=0.45 CROSS=2
.MEAS TRAN tpd_0_1 PARAM='t_out0_1-t_in_1'
.MEAS TRAN tpd_1_1 PARAM='t_out1_1-t_in_1'
.MEAS TRAN tpd_2_1 PARAM='t_out2_1-t_in_1'

** Transition 2 (at 1005ns)
.MEAS TRAN t_in_2 WHEN v(x_0<1>)=0.45 CROSS=3
.MEAS TRAN t_out0_2 WHEN v(z_0<0>)=0.45 CROSS=3
.MEAS TRAN t_out1_2 WHEN v(z_0<1>)=0.45 CROSS=3
.MEAS TRAN t_out2_2 WHEN v(z_0<2>)=0.45 CROSS=3
.MEAS TRAN tpd_0_2 PARAM='t_out0_2-t_in_2'
.MEAS TRAN tpd_1_2 PARAM='t_out1_2-t_in_2'
.MEAS TRAN tpd_2_2 PARAM='t_out2_2-t_in_2'

** Transition 3 (at 1505ns)
.MEAS TRAN t_in_3 WHEN v(x_0<1>)=0.45 CROSS=4
.MEAS TRAN t_out0_3 WHEN v(z_0<0>)=0.45 CROSS=4
.MEAS TRAN t_out1_3 WHEN v(z_0<1>)=0.45 CROSS=4
.MEAS TRAN t_out2_3 WHEN v(z_0<2>)=0.45 CROSS=4
.MEAS TRAN tpd_0_3 PARAM='t_out0_3-t_in_3'
.MEAS TRAN tpd_1_3 PARAM='t_out1_3-t_in_3'
.MEAS TRAN tpd_2_3 PARAM='t_out2_3-t_in_3'

** Transition 4 (at 2005ns)
.MEAS TRAN t_in_4 WHEN v(x_0<1>)=0.45 CROSS=5
.MEAS TRAN t_out0_4 WHEN v(z_0<0>)=0.45 CROSS=5
.MEAS TRAN t_out1_4 WHEN v(z_0<1>)=0.45 CROSS=5
.MEAS TRAN t_out2_4 WHEN v(z_0<2>)=0.45 CROSS=5
.MEAS TRAN tpd_0_4 PARAM='t_out0_4-t_in_4'
.MEAS TRAN tpd_1_4 PARAM='t_out1_4-t_in_4'
.MEAS TRAN tpd_2_4 PARAM='t_out2_4-t_in_4'

** Transition 5 (at 2505ns)
.MEAS TRAN t_in_5 WHEN v(x_0<1>)=0.45 CROSS=6
.MEAS TRAN t_out0_5 WHEN v(z_0<0>)=0.45 CROSS=6
.MEAS TRAN t_out1_5 WHEN v(z_0<1>)=0.45 CROSS=6
.MEAS TRAN t_out2_5 WHEN v(z_0<2>)=0.45 CROSS=6
.MEAS TRAN tpd_0_5 PARAM='t_out0_5-t_in_5'
.MEAS TRAN tpd_1_5 PARAM='t_out1_5-t_in_5'
.MEAS TRAN tpd_2_5 PARAM='t_out2_5-t_in_5'

** Transition 6 (at 3005ns)
.MEAS TRAN t_in_6 WHEN v(x_0<1>)=0.45 CROSS=7
.MEAS TRAN t_out0_6 WHEN v(z_0<0>)=0.45 CROSS=7
.MEAS TRAN t_out1_6 WHEN v(z_0<1>)=0.45 CROSS=7
.MEAS TRAN t_out2_6 WHEN v(z_0<2>)=0.45 CROSS=7
.MEAS TRAN tpd_0_6 PARAM='t_out0_6-t_in_6'
.MEAS TRAN tpd_1_6 PARAM='t_out1_6-t_in_6'
.MEAS TRAN tpd_2_6 PARAM='t_out2_6-t_in_6'

** Transition 7 (at 3505ns)
.MEAS TRAN t_in_7 WHEN v(x_0<1>)=0.45 CROSS=8
.MEAS TRAN t_out0_7 WHEN v(z_0<0>)=0.45 CROSS=8
.MEAS TRAN t_out1_7 WHEN v(z_0<1>)=0.45 CROSS=8
.MEAS TRAN t_out2_7 WHEN v(z_0<2>)=0.45 CROSS=8
.MEAS TRAN tpd_0_7 PARAM='t_out0_7-t_in_7'
.MEAS TRAN tpd_1_7 PARAM='t_out1_7-t_in_7'
.MEAS TRAN tpd_2_7 PARAM='t_out2_7-t_in_7'

** Transition 8 (at 4005ns)
.MEAS TRAN t_in_8 WHEN v(x_0<1>)=0.45 CROSS=9
.MEAS TRAN t_out0_8 WHEN v(z_0<0>)=0.45 CROSS=9
.MEAS TRAN t_out1_8 WHEN v(z_0<1>)=0.45 CROSS=9
.MEAS TRAN t_out2_8 WHEN v(z_0<2>)=0.45 CROSS=9
.MEAS TRAN tpd_0_8 PARAM='t_out0_8-t_in_8'
.MEAS TRAN tpd_1_8 PARAM='t_out1_8-t_in_8'
.MEAS TRAN tpd_2_8 PARAM='t_out2_8-t_in_8'

** Power
.MEAS TRAN power_avg AVG POWER FROM=500n TO=4500n

.END
