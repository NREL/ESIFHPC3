#!/bin/bash
#SBATCH --job-name lmp.std2
#SBATCH --nodes=2
#SBATCH --time=4:00:00
#SBATCH --account=hpcapps
#SBATCH --error=std.err
#SBATCH --output=std.out

#Sample run on NREL's Eagle
#Each node has 36 cores. Requesting 2 nodes.  
#Load modules
module purge
module use /nopt/nrel/apps/modules/centos77/modulefiles/
module load intel-mpi/2020.1.217 mkl/2020.1.217 
module list

export OMP_NUM_THREADS=1
taskpernode=32
ntasks=$((SLURM_JOB_NUM_NODES*taskpernode))
run_cmd="srun --ntasks $ntasks --tasks-per-node=$taskpernode"

lmp_path=/nopt/nrel/apps/lammps/3Mar20-centos77/bin/lmp
input_path=../input
run_name=(medium_numerical_test)

echo Run $ntasks MPI ranks without GPU
for name in "${run_name[@]}"
do
	echo Run $name 
	cp $input_path/$name.in .
	time $run_cmd $lmp_path -in $name.in >& $name.log
	../validate.sh $name.log ../NREL_results	
done

 

