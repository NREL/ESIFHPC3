#!/bin/bash

# This is a script that submits all the jobs for the Nalu benchmark
# The 512 mesh case can only run on >32 nodes due to memory

set -e

MAINDIR=$(pwd)
NODES=(6 12 24 48 96 192)
CASE=256
RANKSPERNODE=32

REQUESTEDWALLTIME=(50 30 15 8 6 4)

for i in "${!NODES[@]}";
do

    mkdir -p ${MAINDIR}/abl_3km_${CASE}_${NODES[$i]}
    cp ${MAINDIR}/nalu_single_job.sh ${MAINDIR}/abl_3km_${CASE}_${NODES[$i]}/nalu_single_job.sh
    cp -r xml ${MAINDIR}/abl_3km_${CASE}_${NODES[$i]}/.
    cd ${MAINDIR}/abl_3km_${CASE}_${NODES[$i]}
    RANKS=$(bc <<< "${NODES[$i]}*${RANKSPERNODE}")
    (set -x; sbatch -N "${NODES[$i]}" -n ${RANKS} --time="${REQUESTEDWALLTIME[$i]}" \
      -p standard \
      -o nalu-"${CASE}"-"${RANKS}".%j.out \
      -e nalu-error.%j.out \
      -A hpcapps \
      --export=CASE=${CASE},RANKS=${RANKS},NODES="${NODES[$i]}",RANKSPERNODE=${RANKSPERNODE} \
      nalu_single_job.sh )
done
