#!/usr/bin/env python3

# dadi model
import numpy
import dadi

def split_mig(params1, params2, pts):
    # Model with 2-way migration, instantaneous ancestral population size change, instantaneous recovery for the island population
    # F1, F2 inbreeding coefficients
    # nuM: Population size for pop1 - Mainland, also the ancestral population size after instantaneous change
    # nuB: The bottleneck population size for pop2 - Island
    # nuI: The current population size for pop2
    # m: The scaled migration rate
    # T1: Time when ancestral population size changes from when the ancestral population splits
    # T2: Time when the ancestral population splits from when the island population recovers
    # T3: Time when the island population recovers

    # n1,n2: Size of fs to generate.
    # pts: Number of points to use in grid for evaluation.

    F1, F2, nuM, nuB, nuI, m1, m2, T1, T2, T3 = params1
    n1, n2 = params2

    xx = yy = dadi.Numerics.default_grid(pts)

    # phi for the equilibrium ancestral population
    phi = dadi.PhiManip.phi_1D(xx)
    # Ancestral population size change
    phi = dadi.Integration.one_pop(phi , xx , T1 , nuM)
    # Population split
    phi = dadi.PhiManip.phi_1D_to_2D(xx, phi)
    phi = dadi.Integration.two_pops(phi, xx, T2, nu1=nuM, nu2=nuB, m12=m1, m21=m2)
    # instantaneous change for island population size
    phi = dadi.Integration.two_pops(phi, xx, T3, nu1=nuM, nu2=nuI, m12=m1, m21=m2)

    # Calculate the spectrum
    sfs = dadi.Spectrum.from_phi_inbreeding(phi, (n1,n2), (xx,yy), (F1,F2), (2,2))
    return sfs
