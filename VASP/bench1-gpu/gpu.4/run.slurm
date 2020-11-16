#!/bin/bash
#SBATCH --job-name gpu.4
#SBATCH --nodes=4
#SBATCH --time=8:00:00
#SBATCH --error=std.err
#SBATCH --output=std.out
#SBATCH --gres=gpu:2

module purge
module use /nopt/nrel/apps/modules/centos74/modulefiles/
module load intel-mpi/2018.0.3 mkl/2018.3.222 cuda/10.2.89  
module list

input_path=../../input
vasp_run=/projects/nafion/openmp/vasp6/dist3/vasp.6.1.2/bin/vasp_std
vasp_gpurun=/projects/nafion/openmp/vasp6/dist3/vasp.6.1.2/bin/vasp_gpu

gga_rankspernode=2
hse_rankspernode=24

nnodes=$SLURM_NNODES
gga_kpar=$((nnodes*4))
hse_kpar=$((nnodes*4))
gga_ntasks=$((nnodes*gga_rankspernode))
hse_ntasks=$((nnodes*hse_rankspernode))

echo Running on $nnodes nodes
#GGA
run_type="gga"
kpar=$gga_kpar
vasp_ntasks=$gga_ntasks

echo Start $run_type Calculation using $vasp_ntasks MPI ranks and $gga_rankspernode per node
mkdir $run_type; cd $run_type
cp $input_path/KPOINTS .
cp $input_path/POSCAR .
cp $input_path/POTCAR .

cp $input_path/INCAR-$run_type INCAR
sed -i -e "s/KPAR *= *[0-9]\{1,\}/KPAR = $kpar/" INCAR
diff INCAR $input_path/INCAR-$run_type

time srun --ntasks=$vasp_ntasks --ntasks-per-node=$gga_rankspernode $vasp_gpurun >& LOG
cd ..
cp -r $run_type pre_run

#HSE
run_type="hse"
kpar=$hse_kpar
vasp_ntasks=$hse_ntasks

echo Start $run_type Calculation using $vasp_ntasks MPI ranks and $hse_rankspernode per node
mv pre_run $run_type; cd $run_type

cp $input_path/INCAR-$run_type INCAR
sed -i -e "s/KPAR *= *[0-9]\{1,\}/KPAR = $kpar/" INCAR
diff INCAR $input_path/INCAR-$run_type

time srun --ntasks=$vasp_ntasks --ntasks-per-node=$hse_rankspernode $vasp_gpurun >& LOG
echo All done.


