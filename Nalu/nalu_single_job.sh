#!/bin/bash -l

# This script submits a single job in the Nalu benchmark using values from nalu_all_jobs.sh
# This script is quite specific to the Peregrine machine

#PBS -o $PBS_JOBNAME.log
#PBS -j oe
#PBS -W umask=002

set -e

echo ------------------------------------------------------
echo "Job is running on node ${HOSTNAME} at `date`"
echo ------------------------------------------------------
if [ ! -z "${PBS_JOBID}" ]; then
  echo PBS: Qsub is running on ${PBS_O_HOST}
  echo PBS: Originating queue is ${PBS_O_QUEUE}
  echo PBS: Executing queue is ${PBS_QUEUE}
  echo PBS: Working directory is ${PBS_O_WORKDIR}
  echo PBS: Execution mode is ${PBS_ENVIRONMENT}
  echo PBS: Job identifier is ${PBS_JOBID}
  echo PBS: Job name is ${PBS_JOBNAME}
  echo PBS: Node file is ${PBS_NODEFILE}
  echo PBS: Node file contains $(cat ${PBS_NODEFILE})
  echo PBS: Current home directory is ${PBS_O_HOME}
  echo PBS: PATH = ${PBS_O_PATH}
  echo ------------------------------------------------------
fi
printf "\n"

# Set Spack executable and compiler to use
COMPILER=gcc
SPACK=${LOCAL_SPACK_ROOT}/bin/spack

# Setup base environment
{
module purge
module load gcc/5.2.0
module load python/2.7.8
} &> /dev/null

# Load necessary modules created by spack
module use ${LOCAL_SPACK_ROOT}/share/spack/modules/$(${SPACK} arch)
module load $(${SPACK} module find openmpi %${COMPILER})
module load $(${SPACK} module find nalu %${COMPILER})

printf "CASE: ${CASE} \n"
printf "RANKS: ${RANKS} \n"
printf "NODES: ${NODES} \n"
printf "RANKSPERNODE: ${RANKSPERNODE} \n\n"

# Run the simulation
(set -x; which mpirun)
(set -x; which naluX)
(set -x; mpirun -report-bindings -np ${RANKS} --map-by ppr:1:core -bind-to core \
         /bin/bash -c "ulimit -s 10240 && naluX -i abl_3km_${CASE}.i -o abl_3km_${CASE}_${RANKS}.log")
