# Neural Net Hardware Accelerator
Neural net hardware accelerator for human activity recognition based on the ASAP7 7nm process. This is an archive of my *ECE555: Digital Circuits and Components* class final project. 

## Introduction
This repository contains the CAD and test files for a Neural Net inference hardware accelerator. Each Neuron features a MAC and ReLU unit. 
The model weights are taken as inputs for easy tuning. It allows for energy-efficient human activity recognition from strain sensor data.

## Design Toolchain
The repository features schematics and custom layouts done in **Cadence Virtuoso** and the **ASAP7nm** PDK. It was designed from the standard cell up to the full neuron in a bottom-up approach, making it easily modular.

## Verification environment
For verification and testing, we built an environment based on **Synopsys HSpice** for simulation, and **CosmoScope** for manual debugging and waveform viewing. The full suite is automated using **Python**, and stress tests the Neuron module accross all possible inputs to find its worst-case delay.

## Specs
We achieved over 8.5GHz on a single neuron using standard CMOS inverting logic for all our standard cells, except for our transmission XOR gate.
