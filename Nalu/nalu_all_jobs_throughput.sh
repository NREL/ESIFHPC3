#!/bin/bash

set -ex

MAINDIR=$(pwd)
LOCAL_SPACK_ROOT=/projects/windFlowModeling/ExaWind/NaluSharedInstallationB/spack
RANKSPERNODE=24
NODES=36

for CASE in "256"; # "512";
do
  if [ "${CASE}" == "256" ]; then
    REQUESTEDWALLTIME=5000
  elif [ "${CASE}" == "512" ]; then
    REQUESTEDWALLTIME=80000
  fi

  cp ${MAINDIR}/nalu_single_job.sh ${MAINDIR}/abl_3km_${CASE}/nalu_single_job.sh

  for i in {1..16};
  do
      cp -R ${MAINDIR}/abl_3km_${CASE} ${MAINDIR}/abl_3km_${CASE}_${i}
  done
  
  for i in {1..16};
  do
      cd ${MAINDIR}/abl_3km_${CASE}_${i}
      qsub -l nodes=${NODES}:ppn=${RANKSPERNODE},walltime=${REQUESTEDWALLTIME} \
        -q batch-h \
        -N nalu-"${CASE}"-"${RANKS}"-"${i}" \
        -A hpc-apps \
        -v CASE=${CASE},RANKS=${RANKS},NODES=${NODES},RANKSPERNODE=${RANKSPERNODE},LOCAL_SPACK_ROOT=${LOCAL_SPACK_ROOT} \
        nalu_single_job.sh
  done
done
