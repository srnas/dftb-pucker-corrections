# Pucker corrections for DFTB

WARNING: WORK IN PROGRESS, TO BE TESTED

This repository contains tabulated corrections for DFTB taken from the paper by [Huang et al, 2014](http://dx.doi.org/10.1021/ct401013s)

Original tables have been extracted from supporting tables S1 and S2 of that paper.

External potentials in a format that can be read by [PLUMED](http://www.plumed.org) are provided.

A sample input file for PLUMED is also provided.

Implementation have been made by Alejandro Gil-Ley and Vojtech Mlynsky.

USE AT YOUR OWN RISK!

How to
======

Usage:
    ./generate-grids.sh method sequence

methods is dftb3 or am1d
sequence is space separated sequence

Example:
    ./generate-grids.sh dftb3 C G U U C G G C

This will generate a `plumed.dat` input file as well as 8 grid files
containing the correcting potentials for the 8 nucleotides.

    


