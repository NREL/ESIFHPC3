module purge
module load intel-mpi mkl/2020.1.217 
module list
#Currently Loaded Modules:
#  1) gcc/7.3.0   2) comp-intel/2018.0.3   3) intel-mpi/2018.0.3   4) mkl/2020.1.217

export NWCHEM_TOP=/nopt/nrel/apps/nwchem/dist/nwchem-7.0.0
export NWCHEM_TARGET=LINUX64
export ARMCI_NETWORK=MPI-PR
export USE_MPI=y
export MPI_LOC="$I_MPI_ROOT/intel64"
export MPI_INCLUDE="$I_MPI_ROOT/intel64/include"
export MPI_LIB="$I_MPI_ROOT/intel64/lib"
export USE_MPIF=y
export USE_MPIF4=y
export USE_OPENMP=y
export NWCHEM_MODULES="all"
export USE_NOFSCHECK=TRUE
export USE_NOIO=TRUE
export USE_SCALAPACK=y
export SCALAPACK="-L$MKLROOT/lib/intel64 -lmkl_scalapack_ilp64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -lmkl_blacs_intelmpi_ilp64 -liomp5 -lpthread -lm"
export SCALAPACK_SIZE=8
export SCALAPACK_LIB="$SCALAPACK"
export BLASOPT="-L$MKLROOT/lib/intel64 -lmkl_intel_ilp64 -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -lm"
export BLAS_SIZE=8
export LAPACK_LIB="$BLASOPT"

cd $NWCHEM_TOP/src  
make nwchem_config 
make FC=ifort CC=icc CPP=cpp

