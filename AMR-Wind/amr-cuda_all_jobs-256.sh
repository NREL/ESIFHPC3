#!/bin/bash

# This is a script that stages all the jobs for the AMR-Wind-Cuda benchmark

set -e

MAINDIR=$(pwd)
NODES=(4 8 16 32 )
CASE=256
RANKSPERNODE=2

REQUESTEDWALLTIME=(30 20 15 10 )

for i in "${!NODES[@]}";
do

    mkdir -p ${MAINDIR}/amr-cuda_${CASE}_${NODES[$i]}
    cp amr-cuda_single_job.sh amr-cuda_${CASE}_${NODES[$i]}/.
    cp abl_godunov-${CASE}.i amr-cuda_${CASE}_${NODES[$i]}/abl_godunov.i
    cp exawind-*.sh amr-cuda_${CASE}_${NODES[$i]}/.
    cp -r plt01000.ref-256 amr-cuda_${CASE}_${NODES[$i]}/.
    cd ${MAINDIR}/amr-cuda_${CASE}_${NODES[$i]}
    RANKS=$(bc <<< "${NODES[$i]}*${RANKSPERNODE}")
    (set -x; sbatch -N "${NODES[$i]}" -n ${RANKS} --time="${REQUESTEDWALLTIME[$i]}" \
      --gres=gpu:2 \
      -o amr-"${CASE}"-"${RANKS}".%j.out \
      -e amr-error.%j.out \
      -A hpcapps \
      --export=CASE=${CASE},RANKS=${RANKS},NODES="${NODES[$i]}",RANKSPERNODE=${RANKSPERNODE} \
      amr-cuda_single_job.sh )
done
