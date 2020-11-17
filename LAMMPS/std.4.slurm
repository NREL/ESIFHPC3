#!/bin/bash
#SBATCH --job-name lmp.std4
#SBATCH --nodes=4
#SBATCH --time=1:00:00
#SBATCH --account=hpcapps
#SBATCH --error=std.err
#SBATCH --output=std.out
#SBATCH -p debug

#Sample run on NREL's Eagle
#Each node has 36 cores. Requesting 4 nodes.  
#Load modules
module purge
module use /nopt/nrel/apps/modules/centos77/modulefiles/
module load intel-mpi/2020.1.217 mkl/2020.1.217 
module list

#Required for baseline
export OMP_NUM_THREADS=1

taskpernode=36
ntasks=$((SLURM_JOB_NUM_NODES*taskpernode))
run_cmd="srun -n $ntasks"

lmp_path=/nopt/nrel/apps/lammps/3Mar20-centos77/bin/lmp
input_path=../input
run_name=(small medium large)

#This parameter makes job longer to have >300s wall time
scale=$SLURM_JOB_NUM_NODES

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
	time $run_cmd $lmp_path -in $name.in >& $name.log
	grep Loop $name.log
	grep day $name.log   
done

echo Results are in std.out 

