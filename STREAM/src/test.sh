#!/bin/bash
#SBATCH --job-name="hybrid"
#SBATCH --nodes=1
#SBATCH --partition=debug
#SBATCH --account=hpcapps
#SBATCH --time=01:00:00

#define compilers
module load comp-intel/2020.1.217
export FC=ifort
export CC=icc

#   Assumes hyperthreading is off.
export max_threads=36
export num_physical_cores=`grep -c processor /proc/cpuinfo`
export precent=60
# Calculating array size to use $precent % of the memory on the node
export dec=`awk "BEGIN {print $precent / 100}"`
export num_64bfloats_60percent=$(echo "$dec * `grep MemTotal /proc/meminfo | awk '{print $2}'` * 1000 / 8 / 3" | bc)


rm results.${CC}.${FC}

echo "STREAM test run.." &>> results.${CC}.${FC}
echo "Checking Compilers.." &>> results.${CC}.${FC}
echo "  C compiler used ${CC} .." &>> results.${CC}.${FC}
echo "  Fortran compiler used ${FC} .." &>> results.${CC}.${FC}
echo "Running make clean .." &>> results.${CC}.${FC}
make clean 
echo "Building the default executable .." &>> results.${CC}.${FC}
make all CC=${CC} FC=${FC}

# note to vendor:  Set OMP and affinity variables to give good performance
#export OMP_DISPLAY_ENV=True
#export KMP_AFFINITY=verbose
export KMP_AFFINITY=scatter
export KMP_AFFINITY=compact
unset OMP_NUM_THREADS
printenv &>> results.${CC}.${FC}
##############
echo "running the C executable scaling study with default memory, 1 to $max_threads OpenMP threads.." &>> results.${CC}.${FC}
for x in `seq 1 $max_threads` ; do
  export OMP_NUM_THREADS=$x
  echo OMP_NUM_THREADS=$OMP_NUM_THREADS &>> results.${CC}.${FC}
  ./stream_c.${CC}.exe  &>> results.${CC}.${FC}
done

echo "running the Fortran executable scaling study with default memory, 1 to $max_threads OpenMP threads.." &>> results.${CC}.${FC}
for x in `seq 1 $max_threads` ; do
  export OMP_NUM_THREADS=$x
  echo OMP_NUM_THREADS=$OMP_NUM_THREADS &>> results.${CC}.${FC}
  ./stream_f.${FC}.exe  &>> results.${CC}.${FC}
done


echo "Running make clean .." &>> results.${CC}.${FC}
make clean 
echo "Building STREAM executable to use $precent % of memory.." &>> results.${CC}.${FC}
make all CC=${CC} FC=${FC} CPPFLAGS="-DSTREAM_ARRAY_SIZE=$num_64bfloats_60percent"

echo "running the C executable scaling study with $precent % of memory, 1 to $max_threads OpenMP threads.." &>> results.${CC}.${FC}
for x in `seq 1 $max_threads` ; do
  export OMP_NUM_THREADS=$x
  echo OMP_NUM_THREADS=$OMP_NUM_THREADS &>> results.${CC}.${FC}
  ./stream_c.${CC}.exe  &>> results.${CC}.${FC}
done

echo "running the Fortran executable scaling study with $precent % of  memory, 1 to $max_threads OpenMP threads.." &>> results.${CC}.${FC}
for x in `seq 1 $max_threads` ; do
  export OMP_NUM_THREADS=$x
  echo OMP_NUM_THREADS=$OMP_NUM_THREADS &>> results.${CC}.${FC}
  ./stream_f.${FC}.exe  &>> results.${CC}.${FC}
done


echo "STREAM test complete!" &>> results.${CC}.${FC}

cp results.${CC}.${FC} resluts.$SLURM_JOB_ID
