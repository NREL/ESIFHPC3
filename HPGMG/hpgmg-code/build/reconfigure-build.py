#!/nopt/nrel/apps/epel/6.6/usr/bin/python
import os,sys
from argparse import Namespace
sys.path.insert(0, os.path.abspath('.'))
import hpgmgconf
hpgmgconf.configure(Namespace(CC='mpiicc', CFLAGS='-fopenmp -O3', CPPFLAGS='', LDFLAGS='', LDLIBS='', arch='build', fe=False, fv=True, fv_coarse_solver='bicgstab', fv_cycle='F', fv_mpi=True, fv_smoother='gsrb', fv_subcomm=True, petsc_arch='', petsc_dir='', with_hpm=None))