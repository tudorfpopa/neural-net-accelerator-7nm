#!/usr/bin/env python3
"""
Simple Timing Testbench for Ternary Neuron
Measures propagation delay by switching between two test cases
"""

from pathlib import Path

def generate_timing_testbench(netlist='Neuron_submod.pex.netlist', vdd=0.9):
    """
    Generate a timing testbench that switches from one test case to another
    
    Test case 1 (0-5ns):  All inputs = 0, all weights = 0  → output = 0
    Test case 2 (5ns+):   x0=1, x1=1, w00=1, w10=1, w20=1 → output = 3
    
    Measures propagation delay from input transition to output transition
    """
    
    testbench = f"""** Ternary Neuron Timing Testbench
** Measures propagation delay with post-layout parasitics
** 
** Test sequence:
**   0-5ns:  All inputs/weights = 0 → Expected output = 0
**   5ns+:   x0=1, x1=1, w00=1, w10=1, w20=1 → Expected output = 3
**
** Measures time from input transition to output transition

.TEMP 25.0
.OPTION ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 POST=2 ACCURATE NUMDGT=8 CASE=INSENSITIVE

** Include PDK models
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"

** Include neuron netlist
.INCLUDE "{netlist}"

** Define INV subcircuit for fanout loads
.subckt INV in out vdd vss
xm0 out in vss vss nmos_rvt w=54e-9 l=20e-9 nfin=2
xm1 out in vdd vdd pmos_rvt w=81e-9 l=20e-9 nfin=3
.ends INV

** Supply voltages
vvdd vdd 0 DC {vdd}
vvss vss 0 DC 0

** Instantiate neuron (PEX netlist defines it as a subcircuit)
xneuron vss x_1<0> x_1<1> x_0<0> x_0<1> vdd w_10<0> w_00<0> w_10<1> w_00<1> w_20<1> w_20<0> z_0<1> z_0<0> z_0<2> Neuron_submod

** Input stimulus with transitions
** Encoding: -1=[VDD,VDD], 0=[0,0], +1=[VDD,0]
** Rise/fall times: 50ps (realistic)
** Transition time: 5ns

** Input x_0: 0 → +1
** 0 = [0, 0], +1 = [VDD, 0]
vx0_0 x_0<0> 0 PULSE(0 0 5n 50p 50p 100n 200n)
vx0_1 x_0<1> 0 PULSE(0 {vdd} 5n 50p 50p 100n 200n)

** Input x_1: 0 → +1  
vx1_0 x_1<0> 0 PULSE(0 0 5n 50p 50p 100n 200n)
vx1_1 x_1<1> 0 PULSE(0 {vdd} 5n 50p 50p 100n 200n)

** Weight w_00: 0 → +1
vw00_0 w_00<0> 0 PULSE(0 0 5n 50p 50p 100n 200n)
vw00_1 w_00<1> 0 PULSE(0 {vdd} 5n 50p 50p 100n 200n)

** Weight w_10: 0 → +1
vw10_0 w_10<0> 0 PULSE(0 0 5n 50p 50p 100n 200n)
vw10_1 w_10<1> 0 PULSE(0 {vdd} 5n 50p 50p 100n 200n)

** Weight w_20: 0 → +1
vw20_0 w_20<0> 0 PULSE(0 0 5n 50p 50p 100n 200n)
vw20_1 w_20<1> 0 PULSE(0 {vdd} 5n 50p 50p 100n 200n)

** Output loads - 4 inverters per output bit (FO4)
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
.TRAN 10p 20n

** Print waveforms
.PRINT TRAN v(x_0<0>) v(x_0<1>) v(w_00<0>) v(w_00<1>) v(z_0<0>) v(z_0<1>) v(z_0<2>)

** Timing measurements
** Reference: measure when input crosses 50% (middle of transition)
.MEAS TRAN t_input WHEN v(x_0<1>)={vdd/2} CROSS=1

** Measure when each output bit crosses 50%
.MEAS TRAN t_out0 WHEN v(z_0<0>)={vdd/2} CROSS=1
.MEAS TRAN t_out1 WHEN v(z_0<1>)={vdd/2} CROSS=1
.MEAS TRAN t_out2 WHEN v(z_0<2>)={vdd/2} CROSS=1

** Propagation delays (input to each output)
.MEAS TRAN tpd_0 PARAM='t_out0-t_input'
.MEAS TRAN tpd_1 PARAM='t_out1-t_input'
.MEAS TRAN tpd_2 PARAM='t_out2-t_input'

** Critical path delay (worst case)
.MEAS TRAN tpd_max MAX tpd_0 tpd_1 tpd_2

** Output values before and after transition
.MEAS TRAN out_before FIND v(z_0<0>) AT=4.9n
.MEAS TRAN out_after FIND v(z_0<0>) AT=15n

** Power measurement (average over stable period after transition)
.MEAS TRAN power_avg AVG POWER FROM=10n TO=20n

** Rise/fall times at outputs (10% to 90%)
.MEAS TRAN trise_0 TRIG v(z_0<0>) VAL={vdd*0.1} RISE=1 TARG v(z_0<0>) VAL={vdd*0.9} RISE=1
.MEAS TRAN tfall_0 TRIG v(z_0<0>) VAL={vdd*0.9} FALL=1 TARG v(z_0<0>) VAL={vdd*0.1} FALL=1

.END
"""
    
    # Write testbench
    tb_path = Path('timing_test.sp')
    with open(tb_path, 'w') as f:
        f.write(testbench)
    
    return tb_path


if __name__ == '__main__':
    import subprocess
    import sys
    
    print("="*70)
    print("Ternary Neuron Timing Analysis")
    print("="*70)
    print()
    
    # Check for PEX netlist
    pex_netlist = 'Neuron_submod.pex.netlist'
    if not Path(pex_netlist).exists():
        print(f"❌ Error: {pex_netlist} not found!")
        print("This script requires the post-layout PEX netlist.")
        sys.exit(1)
    
    # Generate testbench
    print("Generating timing testbench...")
    tb_path = generate_timing_testbench(netlist=pex_netlist)
    print(f"✅ Created: {tb_path}")
    print()
    
    # Run HSPICE
    print("Running HSPICE simulation...")
    print("This will take a few minutes with PEX parasitics...")
    print()
    
    try:
        result = subprocess.run(
            ['hspice', str(tb_path)],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        if result.returncode != 0:
            print("❌ HSPICE simulation failed!")
            print("Check timing_test.st0 for errors")
            sys.exit(1)
        
        print("✅ HSPICE simulation complete!")
        print()
        
        # Parse results
        mt0_path = tb_path.with_suffix('.mt0')
        if mt0_path.exists():
            print("="*70)
            print("Timing Results")
            print("="*70)
            
            with open(mt0_path, 'r') as f:
                lines = f.readlines()
            
            # Find measurements
            for line in lines:
                if 'tpd_' in line or 't_input' in line or 't_out' in line or 'power' in line or 'trise' in line or 'tfall' in line:
                    print(line.strip())
            
            print()
            print("="*70)
            print("View waveforms:")
            print(f"  cosmosscope {tb_path.with_suffix('.tr0')}")
            print("="*70)
        else:
            print("⚠️  No measurement file found")
            print("Check timing_test.lis for output")
    
    except FileNotFoundError:
        print("❌ Error: hspice command not found")
        print("Make sure HSPICE is installed and in your PATH")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)
