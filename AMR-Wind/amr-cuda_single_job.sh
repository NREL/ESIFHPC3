#!/bin/bash
#SBATCH --nodes=4          # Use 4 nodes
#SBATCH --time 01:00:00    # Set a 20 minute time limit
#SBATCH --ntasks 8         # Maximum MPI ranks for job
#SBATCH --gres=gpu:2       # GPU request -- number of GPUs/node
#SBATCH -A hpcapps

BUILD=/projects/hpcapps/apurkaya/Nalu/amr-wind/build-cuda

source exawind-env-gcc.sh

srun ${BUILD}/amr_wind  abl_godunov.i >& ablGodunov-8x8.log
${BUILD}/submods/amrex/Tools/Plotfile/fcompare plt01000 plt01000.ref-256 >& fcompare-8x8.out 

