#!/usr/bin/env python3
"""
Self-Checking HSPICE Testbench for Ternary Neural Network Accelerator
Customized for the gate-level neuron implementation

Neuron Interface:
  Inputs:  x_0<1:0>, x_1<1:0> (two 2-bit ternary values)
  Weights: w_00<1:0>, w_10<1:0>, w_20<1:0> (three 2-bit ternary weights)
  Outputs: z_0<2:0> (one 3-bit output with ReLU)
  Power:   vdd, vss
"""

import subprocess
import re
import numpy as np
from pathlib import Path
import json
from datetime import datetime
from itertools import product

class NeuronVerification:
    def __init__(self, neuron_netlist):
        """
        Initialize verification for your specific neuron
        
        Args:
            neuron_netlist: Path to Neuron.sp file
        """
        self.neuron_netlist = neuron_netlist
        self.vdd = 0.9  # Supply voltage
        
        # Ternary values: -1, 0, 1
        self.ternary_values = [-1, 0, 1]
        
        self.results = []
        
    def ternary_to_bits(self, value):
        """
        Convert ternary value {-1, 0, 1} to 2-bit representation
        Using sign-magnitude encoding:
        - -1: [1, 1] (sign=1, mag=1)
        -  0: [0, 0] (sign=0, mag=0)
        - +1: [0, 1] (sign=0, mag=1)
        
        This matches typical ternary neural network encoding
        """
        if value == -1:
            return [1, 1]  # bit<1>=1, bit<0>=1
        elif value == 0:
            return [0, 0]  # bit<1>=0, bit<0>=0
        elif value == 1:
            return [0, 1]  # bit<1>=0, bit<0>=1
        else:
            raise ValueError(f"Invalid ternary value: {value}")
    
    def bits_to_value(self, bits):
        """
        Convert 3-bit output to integer value (0-7)
        
        Args:
            bits: List of 3 bits [bit<2>, bit<1>, bit<0>] (MSB to LSB)
        """
        return bits[0] * 4 + bits[1] * 2 + bits[2]
    
    def golden_model(self, x0, x1, w00, w10, w20):
        """
        Golden model: out = ReLU(x0*w00 + x1*w10 + w20)
        
        Args:
            x0, x1: Input values {-1, 0, 1}
            w00, w10, w20: Weight values {-1, 0, 1}
        
        Returns:
            Output value after ReLU, saturated to 0-7
        """
        # MAC operation
        weighted_sum = x0 * w00 + x1 * w10 + w20
        
        # ReLU activation
        relu_out = max(0, weighted_sum)
        
        # Saturate to 3-bit output (0-7)
        output = min(7, relu_out)
        
        return output
    
    def generate_exhaustive_tests(self):
        """
        Generate all 243 possible ternary test cases
        """
        test_cases = []
        test_id = 0
        
        print(f"\n{'='*70}")
        print(f"Generating Exhaustive Test Vectors")
        print(f"{'='*70}")
        print(f"Ternary values: {self.ternary_values}")
        print(f"Total combinations: 3^5 = 243 tests")
        print(f"{'='*70}\n")
        
        for x0, x1 in product(self.ternary_values, repeat=2):
            for w00, w10, w20 in product(self.ternary_values, repeat=3):
                # Calculate expected output
                expected = self.golden_model(x0, x1, w00, w10, w20)
                weighted_sum = x0 * w00 + x1 * w10 + w20
                
                test_cases.append({
                    'test_id': test_id,
                    'x0': x0,
                    'x1': x1,
                    'w00': w00,
                    'w10': w10,
                    'w20': w20,
                    'weighted_sum': weighted_sum,
                    'expected_output': expected
                })
                test_id += 1
        
        return test_cases
    
    def generate_hspice_netlist(self, test_case):
        """
        Generate HSPICE netlist for specific test case
        """
        test_id = test_case['test_id']
        
        # Convert ternary values to bits
        x0_bits = self.ternary_to_bits(test_case['x0'])
        x1_bits = self.ternary_to_bits(test_case['x1'])
        w00_bits = self.ternary_to_bits(test_case['w00'])
        w10_bits = self.ternary_to_bits(test_case['w10'])
        w20_bits = self.ternary_to_bits(test_case['w20'])
        
        # Create netlist
        netlist = f"""** Neuron Verification Test {test_id:03d}
** x0={test_case['x0']:+d}, x1={test_case['x1']:+d}, w00={test_case['w00']:+d}, w10={test_case['w10']:+d}, w20={test_case['w20']:+d}
** Computation: {test_case['x0']}*{test_case['w00']} + {test_case['x1']}*{test_case['w10']} + {test_case['w20']} = {test_case['weighted_sum']}
** Expected output: {test_case['expected_output']}

.TEMP 25.0
.OPTION ARTIST=2 INGOLD=2 PARHIER=LOCAL PSF=2 POST=2 ACCURATE NUMDGT=8 MEASOUT=1 CASE=INSENSITIVE

** Include PDK models
.INCLUDE "/cae/apps/data/asap7PDK-2022/asap7PDK_r1p7/models/hspice/7nm_TT_160803.pm"

** Include neuron netlist
.INCLUDE "{self.neuron_netlist}"

** Supply voltages
vvdd vdd 0 DC {self.vdd}
vvss vss 0 DC 0

** Instantiate neuron (PEX netlist defines it as a subcircuit)
xneuron vss x_1<0> x_1<1> x_0<0> x_0<1> vdd w_10<0> w_00<0> w_10<1> w_00<1> w_20<1> w_20<0> z_0<1> z_0<0> z_0<2> Neuron_submod

** Input x_0<1:0> = {test_case['x0']}
vx0_0 x_0<0> 0 DC {self.vdd if x0_bits[1] else 0}
vx0_1 x_0<1> 0 DC {self.vdd if x0_bits[0] else 0}

** Input x_1<1:0> = {test_case['x1']}
vx1_0 x_1<0> 0 DC {self.vdd if x1_bits[1] else 0}
vx1_1 x_1<1> 0 DC {self.vdd if x1_bits[0] else 0}

** Weight w_00<1:0> = {test_case['w00']}
vw00_0 w_00<0> 0 DC {self.vdd if w00_bits[1] else 0}
vw00_1 w_00<1> 0 DC {self.vdd if w00_bits[0] else 0}

** Weight w_10<1:0> = {test_case['w10']}
vw10_0 w_10<0> 0 DC {self.vdd if w10_bits[1] else 0}
vw10_1 w_10<1> 0 DC {self.vdd if w10_bits[0] else 0}

** Weight w_20<1:0> = {test_case['w20']} (bias)
vw20_0 w_20<0> 0 DC {self.vdd if w20_bits[1] else 0}
vw20_1 w_20<1> 0 DC {self.vdd if w20_bits[0] else 0}

** Output loads, 4 inverters per output
** Output z_0<0> fanout
xinv_z0_0_0 z_0<0> z0_0_inv0 vdd vss INV
xinv_z0_0_1 z_0<0> z0_0_inv1 vdd vss INV
xinv_z0_0_2 z_0<0> z0_0_inv2 vdd vss INV
xinv_z0_0_3 z_0<0> z0_0_inv3 vdd vss INV

** Output z_0<1> fanout
xinv_z0_1_0 z_0<1> z0_1_inv0 vdd vss INV
xinv_z0_1_1 z_0<1> z0_1_inv1 vdd vss INV
xinv_z0_1_2 z_0<1> z0_1_inv2 vdd vss INV
xinv_z0_1_3 z_0<1> z0_1_inv3 vdd vss INV

** Output z_0<2> fanout
xinv_z0_2_0 z_0<2> z0_2_inv0 vdd vss INV
xinv_z0_2_1 z_0<2> z0_2_inv1 vdd vss INV
xinv_z0_2_2 z_0<2> z0_2_inv2 vdd vss INV
xinv_z0_2_3 z_0<2> z0_2_inv3 vdd vss INV

** DC operating point
.OP

** Transient analysis for waveform viewing
.TRAN 1p 10n

** Print DC voltages to .lis file
.PRINT DC v(z_0<0>) v(z_0<1>) v(z_0<2>)

** Print transient voltages for waveform
.PRINT TRAN v(x_0<0>) v(x_0<1>) v(x_1<0>) v(x_1<1>) v(w_00<0>) v(w_00<1>) v(w_10<0>) v(w_10<1>) v(w_20<0>) v(w_20<1>) v(z_0<0>) v(z_0<1>) v(z_0<2>)

** Measure output bits at end of simulation
.MEAS TRAN v_z0_0 FIND v(z_0<0>) AT=9n
.MEAS TRAN v_z0_1 FIND v(z_0<1>) AT=9n
.MEAS TRAN v_z0_2 FIND v(z_0<2>) AT=9n

** Measure power
.MEAS TRAN power_avg AVG POWER FROM=50p TO=100p

.END
"""
        
        # Write to file
        netlist_path = Path(f'test_{test_id:03d}.sp')
        with open(netlist_path, 'w') as f:
            f.write(netlist)
        
        return netlist_path
    
    def run_hspice(self, netlist_path, timeout=60):
        """Run HSPICE simulation"""
        try:
            result = subprocess.run(
                ['hspice', str(netlist_path)],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                timeout=timeout,
                text=True
            )
            return result.returncode == 0
        except subprocess.TimeoutExpired:
            print(f"⚠️  Timeout: {netlist_path}")
            return False
        except Exception as e:
            print(f"⚠️  Error: {e}")
            return False
    
    def parse_hspice_output(self, netlist_path):
        """Parse HSPICE output - try .ic0 (initial conditions), .mt0, or .lis"""
        
        # Try different output file types in order of preference
        possible_files = [
            (netlist_path.with_suffix('.ic0'), 'ic0'),   # Initial conditions (always exists)
            (netlist_path.with_suffix('.mt0'), 'mt0'),   # Measurement file
            (netlist_path.with_suffix('.lis'), 'lis'),   # List file
            (netlist_path.with_suffix('.ms0'), 'ms0'),   # Measure file
        ]
        
        content = None
        output_file = None
        file_type = None
        
        for file_path, ftype in possible_files:
            if file_path.exists():
                with open(file_path, 'r') as f:
                    content = f.read()
                output_file = file_path
                file_type = ftype
                break
        
        if content is None:
            return None
        
        measurements = {}
        
        # Different parsing strategies based on file type
        if file_type == 'ic0':
            # IC0 file format: "+ node_name = voltage"
            # Look for our output nodes z_0<0>, z_0<1>, z_0<2>
            out_bits = []
            for node in ['z_0<2>', 'z_0<1>', 'z_0<0>']:  # MSB to LSB
                # IC0 format: "+ z_0<0> = 4.3091023e-07"
                pattern = rf'\+\s+{re.escape(node)}\s*=\s*([\d.e+-]+)'
                
                match = re.search(pattern, content, re.IGNORECASE)
                if match:
                    voltage = float(match.group(1))
                    bit = 1 if voltage > self.vdd/2 else 0
                    out_bits.append(bit)
                else:
                    # Node not found
                    break
        else:
            # For measurement files (.mt0, .lis, .ms0)
            patterns = [
                # Transient measurements (with TRAN prefix)
                (r'v_z0_2\s*=\s*([\d.e+-]+)', r'v_z0_1\s*=\s*([\d.e+-]+)', r'v_z0_0\s*=\s*([\d.e+-]+)'),
                # DC measurements  
                (r'v\(z_0<2>\)\s*=?\s*([\d.e+-]+)', r'v\(z_0<1>\)\s*=?\s*([\d.e+-]+)', r'v\(z_0<0>\)\s*=?\s*([\d.e+-]+)'),
            ]
            
            out_bits = []
            for pattern_set in patterns:
                out_bits = []
                for pattern in pattern_set:
                    match = re.search(pattern, content)
                    if match:
                        voltage = float(match.group(1))
                        bit = 1 if voltage > self.vdd/2 else 0
                        out_bits.append(bit)
                    else:
                        break
                
                if len(out_bits) == 3:
                    break
        
        if len(out_bits) != 3:
            # Debug output
            debug_file = f'debug_parse_{netlist_path.stem}.txt'
            with open(debug_file, 'w') as f:
                f.write(f"Output file used: {output_file}\n")
                f.write(f"File type: {file_type}\n")
                f.write(f"File size: {output_file.stat().st_size} bytes\n\n")
                f.write("=== SEARCHING FOR ===\n")
                f.write("z_0<2>, z_0<1>, z_0<0>\n\n")
                f.write("=== FILE CONTENT (first 4000 chars) ===\n")
                f.write(content[:4000])
                f.write("\n\n=== FILE CONTENT (last 1000 chars) ===\n")
                f.write(content[-1000:])
            print(f"⚠️  Debug file created: {debug_file}")
            return None
        
        measurements['out_bits'] = out_bits
        measurements['out_value'] = self.bits_to_value(out_bits)
        
        # Extract power (only in measurement files)
        if file_type != 'ic0':
            power_patterns = [r'power_avg\s*=\s*([\d.e+-]+)', r'avg_power\s*=\s*([\d.e+-]+)']
            for pattern in power_patterns:
                power_match = re.search(pattern, content)
                if power_match:
                    measurements['power'] = float(power_match.group(1))
                    break
        
        return measurements
    
    def cleanup_files(self, netlist_path):
        """Aggressively cleanup all HSPICE generated files"""
        # All possible HSPICE output file extensions
        extensions = ['.sp', '.lis', '.ic', '.st0', '.tr0', '.pa0', '.mt0', 
                     '.ms0', '.sw0', '.ac0', '.measure', '.log', '.out', '.ic0']
        
        for ext in extensions:
            try:
                file_to_delete = netlist_path.with_suffix(ext)
                if file_to_delete.exists():
                    file_to_delete.unlink()
            except Exception as e:
                pass  # Ignore cleanup errors
    
    def run_verification(self, test_cases, cleanup=True, verbose=False, stop_on_fail=False):
        """Run complete verification"""
        print(f"\n{'='*70}")
        print(f"Starting Neuron Verification")
        print(f"{'='*70}")
        print(f"Total test cases: {len(test_cases)}")
        print(f"Neuron: {self.neuron_netlist}")
        print(f"{'='*70}\n")
        
        passed = 0
        failed = 0
        failed_tests = []
        
        for i, test_case in enumerate(test_cases):
            # Generate netlist
            netlist_path = self.generate_hspice_netlist(test_case)
            
            try:
                # Run HSPICE
                if not self.run_hspice(netlist_path):
                    print(f"❌ Test {test_case['test_id']:03d}: Simulation failed")
                    failed += 1
                    failed_tests.append(test_case)
                    if stop_on_fail:
                        print("\n⚠️  Stopping on first failure for debugging")
                        print(f"Check netlist: {netlist_path}")
                        return None
                    continue
                
                # Parse results
                hspice_results = self.parse_hspice_output(netlist_path)
                
                if hspice_results is None:
                    print(f"❌ Test {test_case['test_id']:03d}: Parse failed")
                    failed += 1
                    failed_tests.append(test_case)
                    if stop_on_fail:
                        print("\n⚠️  Stopping on first failure")
                        print(f"Check output: {netlist_path.with_suffix('.lis')}")
                        return None
                    continue
                
                # Compare
                expected = test_case['expected_output']
                actual = hspice_results['out_value']
                test_passed = (expected == actual)
                
                # Store result
                result = {
                    **test_case,
                    'hspice_bits': hspice_results['out_bits'],
                    'hspice_value': actual,
                    'passed': test_passed,
                    'power': hspice_results.get('power', None)
                }
                self.results.append(result)
                
                if test_passed:
                    passed += 1
                    if verbose:
                        print(f"✅ Test {test_case['test_id']:03d}: "
                              f"x0={test_case['x0']:+d} x1={test_case['x1']:+d} "
                              f"w00={test_case['w00']:+d} w10={test_case['w10']:+d} w20={test_case['w20']:+d} "
                              f"→ {expected}")
                else:
                    failed += 1
                    failed_tests.append(result)
                    print(f"❌ Test {test_case['test_id']:03d}: FAIL | "
                          f"x0={test_case['x0']:+d} x1={test_case['x1']:+d} "
                          f"w00={test_case['w00']:+d} w10={test_case['w10']:+d} w20={test_case['w20']:+d} | "
                          f"Sum={test_case['weighted_sum']:+d} → "
                          f"Expected={expected}, Got={actual} | "
                          f"Bits={hspice_results['out_bits']}")
                    if stop_on_fail:
                        print("\n⚠️  Stopping on first failure")
                        return None
                
                # Progress
                if (i + 1) % 50 == 0:
                    print(f"Progress: {i+1}/{len(test_cases)} ({passed} pass, {failed} fail)")
                
            finally:
                # ALWAYS cleanup, even if there's an error
                if cleanup:
                    self.cleanup_files(netlist_path)
        
        # Summary
        print(f"\n{'='*70}")
        print(f"Verification Complete")
        print(f"{'='*70}")
        print(f"Total:  {len(test_cases)}")
        print(f"Passed: {passed} ({passed/len(test_cases)*100:.1f}%)")
        print(f"Failed: {failed} ({failed/len(test_cases)*100:.1f}%)")
        
        # Failed test details
        if failed > 0:
            print(f"\n{'='*70}")
            print(f"Failed Tests:")
            print(f"{'='*70}")
            for ft in failed_tests:
                print(f"Test {ft['test_id']:03d}: "
                      f"x0={ft['x0']:+d} x1={ft['x1']:+d} "
                      f"w00={ft['w00']:+d} w10={ft['w10']:+d} w20={ft['w20']:+d} → "
                      f"Expected={ft['expected_output']}, Got={ft.get('hspice_value', 'N/A')}")
        
        # Power stats
        powers = [r['power'] for r in self.results if r.get('power')]
        if powers:
            print(f"\n{'='*70}")
            print(f"Power Statistics:")
            print(f"{'='*70}")
            print(f"Average: {np.mean(powers)*1e6:.2f} µW")
            print(f"Min:     {np.min(powers)*1e6:.2f} µW")
            print(f"Max:     {np.max(powers)*1e6:.2f} µW")
            print(f"Std Dev: {np.std(powers)*1e6:.2f} µW")
        
        if failed > 0:
            print(f"\n❌ VERIFICATION FAILED")
        else:
            print(f"\n✅ ALL {passed} TESTS PASSED!")
        print(f"{'='*70}\n")
        
        return {
            'total': len(test_cases),
            'passed': passed,
            'failed': failed,
            'pass_rate': passed/len(test_cases) if len(test_cases) > 0 else 0,
            'failed_tests': failed_tests,
            'results': self.results
        }
    
    def save_results(self, filename='verification_results.json'):
        """Save results to JSON"""
        with open(filename, 'w') as f:
            json.dump({
                'timestamp': datetime.now().isoformat(),
                'neuron_netlist': str(self.neuron_netlist),
                'vdd': self.vdd,
                'total_tests': len(self.results),
                'results': self.results
            }, f, indent=2)
        print(f"\n✅ Results saved to {filename}")
    
    def generate_truth_table(self, filename='truth_table.txt'):
        """Generate human-readable truth table"""
        if not self.results:
            return
        
        with open(filename, 'w') as f:
            f.write("="*90 + "\n")
            f.write("Ternary Neuron Truth Table\n")
            f.write("Computation: z = ReLU(x0*w00 + x1*w10 + w20)\n")
            f.write("="*90 + "\n\n")
            f.write(f"{'x0':>3} {'x1':>3} {'w00':>4} {'w10':>4} {'w20':>4} | "
                   f"{'Sum':>4} {'ReLU':>4} | {'Expected':>8} {'HSPICE':>7} | {'Status':>6}\n")
            f.write("-"*90 + "\n")
            
            for r in sorted(self.results, key=lambda x: x['test_id']):
                status = "PASS" if r['passed'] else "FAIL"
                f.write(f"{r['x0']:+3d} {r['x1']:+3d} {r['w00']:+4d} {r['w10']:+4d} {r['w20']:+4d} | "
                       f"{r['weighted_sum']:+4d} {r['expected_output']:4d} | "
                       f"{r['expected_output']:8d} {r['hspice_value']:7d} | {status:>6}\n")
        
        print(f"✅ Truth table saved to {filename}")


if __name__ == '__main__':
    import sys
    import glob
    import argparse
    
    # Parse command-line arguments
    parser = argparse.ArgumentParser(description='Verify ternary neuron with HSPICE')
    parser.add_argument('--netlist', default='Neuron_submod.sp', 
                       help='Neuron netlist file (default: Neuron_submod.sp, use Neuron_submod_pex.netlist for post-layout)')
    parser.add_argument('--pex', action='store_true',
                       help='Use PEX netlist (shortcut for --netlist Neuron_submod_pex.netlist)')
    parser.add_argument('--cleanup', action='store_true', default=False,
                       help='Delete intermediate files during simulation')
    parser.add_argument('--verbose', action='store_true',
                       help='Show all passing tests')
    parser.add_argument('--continue-on-fail', action='store_true',
                       help='Continue even if tests fail (default: stop on first failure)')
    args = parser.parse_args()
    
    # Determine netlist file
    if args.pex:
        neuron_file = 'Neuron_submod.pex.netlist'
    else:
        neuron_file = args.netlist
    
    # Check if netlist exists
    if not Path(neuron_file).exists():
        print(f"❌ Error: {neuron_file} not found!")
        if args.pex:
            print(f"Please make sure Neuron_submod_pex.netlist is in the current directory.")
        else:
            print(f"Please make sure {neuron_file} is in the current directory.")
        sys.exit(1)
    
    # Check if HSPICE is available
    try:
        result = subprocess.run(['which', 'hspice'], 
                              stdout=subprocess.PIPE, 
                              stderr=subprocess.PIPE)
        if result.returncode != 0:
            print(f"⚠️  Warning: hspice command not found in PATH")
            print(f"Please make sure HSPICE is installed and in your PATH")
            response = input("Continue anyway? (y/n): ")
            if response.lower() != 'y':
                sys.exit(1)
    except Exception as e:
        print(f"⚠️  Could not check for hspice: {e}")
    
    # Initialize verifier
    print(f"\n{'='*70}")
    print(f"Ternary Neuron Verification")
    print(f"{'='*70}")
    print(f"Netlist: {neuron_file}")
    if args.pex:
        print(f"Mode: POST-LAYOUT (with RC parasitics)")
    else:
        print(f"Mode: SCHEMATIC (pre-layout)")
    print(f"{'='*70}\n")
    
    verifier = NeuronVerification(neuron_netlist=neuron_file)
    
    # Generate all 243 test cases
    test_cases = verifier.generate_exhaustive_tests()
    
    # Run verification
    results = verifier.run_verification(
        test_cases,
        cleanup=args.cleanup,
        verbose=args.verbose,
        stop_on_fail=not args.continue_on_fail
    )
    
    if results is not None:  # Only save if verification completed
        # Determine output filenames based on netlist type
        if args.pex:
            results_file = 'verification_results_pex.json'
            truth_file = 'truth_table_pex.txt'
        else:
            results_file = 'verification_results.json'
            truth_file = 'truth_table.txt'
        
        # Save results
        verifier.save_results(results_file)
        verifier.generate_truth_table(truth_file)
        
        print("\n🎉 Verification script completed!")
    else:
        print("\n⚠️  Verification stopped early due to failure")
        print("Check the test netlist and .lis file that were preserved for debugging")
    
    # Final cleanup check - remove any stray test files
    print("\n🧹 Running final cleanup check...")
    test_files = glob.glob('test_*.sp') + glob.glob('test_*.lis') + \
                 glob.glob('test_*.st0') + glob.glob('test_*.tr0') + \
                 glob.glob('test_*.pa0') + glob.glob('test_*.mt0') + \
                 glob.glob('test_*.ms0') + glob.glob('test_*.ic')
    
    if test_files:
        print(f"Found {len(test_files)} leftover test files")
        response = input("Delete them? (y/n): ")
        if response.lower() == 'y':
            for f in test_files:
                try:
                    Path(f).unlink()
                    print(f"  Deleted: {f}")
                except:
                    pass
            print("✅ Cleanup complete")
    else:
        print("✅ No leftover files found - all clean!")
