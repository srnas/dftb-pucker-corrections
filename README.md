# Pucker corrections for semiempirical methods

This repository contains tabulated corrections for DFTB/DFTB2 and AM1/d-PhoT taken from the paper by [Huang et al, 2014](http://dx.doi.org/10.1021/ct401013s)

Original tables have been extracted from supporting tables S1 and S2 of that paper.

External potentials in a format that can be read by [PLUMED](http://www.plumed.org) are provided.

A sample input file for PLUMED is also provided.

Implementation have been made by Alejandro Gil-Ley, Vojtech Mlynsky, and Giovanni Bussi

USE AT YOUR OWN RISK!

How to
======

Usage:

    > ./generate-grids.sh method sequence

Here methods is `dftb3` or `am1d`,
and sequence is space separated sequence.

Example:

    > ./generate-grids.sh dftb3 C G U U C G G C > plumed.dat

This will generate a `plumed.dat` input file as well as 8 grid files
containing the correcting potentials for the 8 nucleotides.

Warnings
========
- Potential outside of the -pi/6,+pi/6 range for both Zx and Zy
  is set to an arbitrary value. Usually these variables should not 
  reach the boundaries. In case they do it, one should set a wall to avoid it.
- Atom selection uses PLUMED MOLINFO syntax. Please double check that
  atoms for puckering have been properly selected.


