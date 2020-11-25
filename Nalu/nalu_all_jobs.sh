#!/bin/bash

# This is a script that submits all the jobs for the Nalu benchmark
# The 512 mesh case can only run on >32 nodes due to memory

set -e

MAINDIR=$(pwd)
LOCAL_SPACK_ROOT=/projects/windFlowModeling/ExaWind/NaluSharedSoftware/spack
RANKSPERNODE=24
NODES=(8 16 32 64 128 256)

for CASE in "256" "512";
do
  if [ "${CASE}" == "256" ]; then
    REQUESTEDWALLTIME=(20000 10000 5000 3000 3000 2000)
  elif [ "${CASE}" == "512" ]; then
    REQUESTEDWALLTIME=(320000 160000 80000 48000 48000 32000)
  fi
  cp ${MAINDIR}/nalu_single_job.sh ${MAINDIR}/abl_3km_${CASE}/nalu_single_job.sh
  cd ${MAINDIR}/abl_3km_${CASE}
  for i in "${!NODES[@]}";
  do
    RANKS=$(bc <<< "${NODES[$i]}*${RANKSPERNODE}")
    (set -x; qsub -l nodes="${NODES[$i]}":ppn=${RANKSPERNODE},walltime="${REQUESTEDWALLTIME[$i]}" \
      -q batch-h \
      -N nalu-"${CASE}"-"${RANKS}" \
      -A hpc-apps \
      -v CASE=${CASE},RANKS=${RANKS},NODES="${NODES[$i]}",RANKSPERNODE=${RANKSPERNODE},LOCAL_SPACK_ROOT=${LOCAL_SPACK_ROOT} \
      nalu_single_job.sh)
  done
done
