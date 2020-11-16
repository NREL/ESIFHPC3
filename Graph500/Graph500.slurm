#!/bin/bash
#SBATCH --job-name=graph500
#SBATCH --time=06:00:00
#SBATCH --nodes=1024
#SBATCH --ntasks-per-node=1
#SBATCH --output=small_1024r1024n.out
#SBATCH --error=small_1024r1024n.err

# Minimum node counts
#  toy = 1 standard node, 16 ppn
#  mini = 16 standard nodes, 8 ppn

echo $SLURM_NODELIST
ml openmpi/4.0.4/gcc-8.4.0
# To turn off end-of-run warnings
# UCX  WARN  object 0x1c39540 was not returned to mpool ucp_requests
# This likely results from MPI_Finalize being called with some requests in flight. Doesn't affect results.
# See e.g., https://github.com/openucx/ucx/issues/4175
export UCX_LOG_LEVEL=error

# Define the predefined scales at https://graph500.org/?page_id=12
scale=small

case $scale in 
  toy)
    option=26
    ;;
  mini)
    option=29
    ;;
  small)
    option=32
    ;;
  medium)
    option=36
    ;;
  large)
    option=39
    ;;
  huge)
    option=42
    ;;
  *)
    echo "Unknown option value $scale"
    exit
esac

export PATH=/projects/hpcapps/cchang/Graph500/src/src:$PATH

# Find a number of ranks that is both a power-of-2 and minimally below
#   the number of Slurm processes available.
for i in {1..16}
do
   mytest=$((2**i-SLURM_NTASKS))
   if [ $mytest -gt 0 ]
   then
      ranks=$((2**(i-1)))
      break
   fi
done

mpirun -n $ranks graph500_reference_bfs_sssp $option

