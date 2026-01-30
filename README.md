# 2nd-Order Low-Pass Delta-Sigma Modulator (MATLAB)

This repository contains a MATLAB implementation of a second-order
low-pass delta-sigma modulator developed as part of an unpublished
academic manuscript.

## Authors
- Vildan Mınık, Koç University
- Advisor: Dr. Tezgül Coşkun Öztürk, TÜBİTAK UME Voltage Laboratory
- Co-authors: Yağmur Karaca, Boğaziçi University

## Related Manuscript
This code accompanies the following unpublished manuscript:

> V. Minik et al.,  
> "Realization of a 2nd-Order Low-Pass Delta-Sigma Modulator in MATLAB
> as the Digital Bias for JAWS",  
> manuscript in preparation.

## Modulator Architecture
The implemented model corresponds to a:
- Second-order low-pass delta-sigma modulator
- Single-bit quantizer
- Discrete-time behavioral model
- Designed for digital bias generation in JAWS applications

The structure follows the system-level description provided in the manuscript.

## Repository Structure
- `src/deltaSigmaModulatorFunction.m`  
  Core delta-sigma modulator implementation.
- `scripts/DSM_filtered_finalized.m`  
  Simulation script including output filtering and performance evaluation.

## Usage
Run the simulation script:
```matlab
DSM_filtered_finalized
