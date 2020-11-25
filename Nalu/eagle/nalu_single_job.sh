#!/bin/bash -l

# This script submits a single job in the Nalu benchmark using values from nalu_all_jobs.sh
# This script is quite specific to the Eagle machine


set -e


printf "CASE: ${CASE} \n"
printf "RANKS: ${RANKS} \n"
printf "NODES: ${NODES} \n"
printf "RANKSPERNODE: ${RANKSPERNODE} \n\n"

BASE=/lustre/eaglefs/projects/hpcapps/apurkaya/Nalu/Nalu/abl_3km_${CASE}
PATH=$PATH:$BASE
echo $PATH

#Set compiler to use
COMPILER=intel #gcc
# Setup base environment
{
module purge
module unuse /nopt/nrel/utils/modulefiles/Linux:/nopt/nrel/utils/modulefiles/Core:/nopt/nrel/apps/modules/default/modulefiles
module use /nopt/nrel/ecom/hpacf/compilers/modules-2020-07
module use /nopt/nrel/ecom/hpacf/utilities/modules-2020-07
module load gcc
module load python
module load git
module load binutils
module load cmake
#
if [ "${COMPILER}" == "gcc" ]; then
module use /nopt/nrel/ecom/hpacf/software/modules-2020-07/gcc-8.4.0
module load mpt
module load netlib-lapack
module load hypre
module load tioga
module load yaml-cpp
module load fftw
module load boost
elif [ "${COMPILER}" == "intel" ]; then
module use /nopt/nrel/ecom/hpacf/software/modules-2020-07/intel-18.0.4
module load intel-parallel-studio/cluster.2018.4
module load intel-mpi/2018.4.274
module load intel-mkl/2018.4.274
module load hypre
module load tioga
module load yaml-cpp
module load fftw
module load boost
fi
} &> /dev/null
#
module list

ln -sf ${BASE}/abl_3km_${CASE}.g .


# Run the simulation
(set -x; which mpiexec)
(set -x; mpiexec -n ${RANKS}  ${BASE}/../../nalu-wind/build-${COMPILER}/naluX -i ${BASE}/abl_3km_${CASE}.i  -o abl_3km_${CASE}_${RANKS}.log)
(set -x; ${BASE}/pass_fail.sh abl_3km_${CASE}_${RANKS} ${BASE}/abl_3km_${CASE}_${RANKS}.norm.gold 0.001)

