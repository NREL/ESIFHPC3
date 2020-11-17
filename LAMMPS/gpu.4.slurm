#!/bin/bash
#SBATCH --job-name lmp.gpu4
#SBATCH --nodes=4
#SBATCH --time=4:00:00
#SBATCH --account=hpcapps
#SBATCH --error=std.err
#SBATCH --output=std.out
#SBATCH --gres=gpu:2

#Sample run on NREL's Eagle
#Each node has 36 cores. Requesting 4 nodes.  
#Load modules
module purge
module use /nopt/nrel/apps/modules/centos77/modulefiles/
module load intel-mpi/2020.1.217 mkl/2020.1.217 cuda/10.2.89 
module list

#Required for baseline
export OMP_NUM_THREADS=1

taskpernode=36
ntasks=$((SLURM_JOB_NUM_NODES*taskpernode))
run_cmd="srun --ntasks $ntasks --tasks-per-node=$taskpernode"

lmp_path=/projects/nafion/openmp/lammps2/dist/lammps6/bin/lmp
input_path=../input
run_name=(small medium large)

#This parameter makes job longer to have >300s wall time
scale=$((SLURM_JOB_NUM_NODES*4))

#For GPU run, requesting for 2 gpu card per node
gpu_opt="-sf gpu -pk gpu 2"

echo Run $ntasks MPI ranks without GPU
for name in "${run_name[@]}"
do
	echo Run $name 
	line=`grep "thermo_print equal" $input_path/$name.in`
	IFS=', ' read -r -a array <<< "$line"
	old_step="${array[3]}"
	new_step=$((old_step*$scale))
	sed "s/thermo_print equal $old_step/thermo_print equal $new_step/" $input_path/$name.in > $name.in
	diff $name.in $input_path/$name.in 
	time $run_cmd $lmp_path $gpu_opt -in $name.in >& $name.$taskpernode.log
	grep Loop $name.$taskpernode.log
	grep day $name.$taskpernode.log   
done

echo Results are in std.out 



