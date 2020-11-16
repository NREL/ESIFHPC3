#!/bin/bash
#SBATCH --job-name std.4
#SBATCH --nodes=4
#SBATCH --time=4:00:00
#SBATCH --error=std.err
#SBATCH --output=std.out

module purge
module use /nopt/nrel/apps/modules/centos74/modulefiles/
module load intel-mpi/2018.0.3 mkl/2018.3.222  
module list

input_path=../../input
vasp_run=/projects/nafion/openmp/vasp6/dist3/vasp.6.1.2/bin/vasp_std

gga_rankspernode=36
hse_rankspernode=$gga_rankspernode
gw_rankspernode=8

nnodes=$SLURM_NNODES
gga_npar=$nnodes

hse_kpar=$((nnodes*2))
hse_npar=$((nnodes*hse_rankspernode/hse_kpar))

gga_ntasks=$((nnodes*gga_rankspernode))
hse_ntasks=$((nnodes*hse_rankspernode))
gw_ntasks=$((nnodes*gw_rankspernode))

echo Running on $nnodes nodes
#GGA
run_type="gga"
npar=$gga_npar
vasp_ntasks=$gga_ntasks

echo Start $run_type Calculation using $vasp_ntasks MPI ranks
mkdir $run_type; cd $run_type
cp $input_path/KPOINTS .
cp $input_path/POSCAR .
cp $input_path/POTCAR .

cp $input_path/INCAR-$run_type INCAR
sed -i -e "s/NPAR *= *[0-9]\{1,\}/NPAR = $npar/" INCAR
diff INCAR $input_path/INCAR-$run_type

time srun -n $vasp_ntasks $vasp_run >& LOG
cd ..
cp -r $run_type pre_run

#HSE
run_type="hse"
npar=$hse_npar
kpar=$hse_kpar
vasp_ntasks=$hse_ntasks

echo Start $run_type Calculation using $vasp_ntasks MPI ranks
mv pre_run $run_type; cd $run_type

cp $input_path/INCAR-$run_type INCAR
sed -i -e "s/NPAR *= *[0-9]\{1,\}/NPAR = $npar/" INCAR
sed -i -e "s/KPAR *= *[0-9]\{1,\}/KPAR = $kpar/" INCAR
diff INCAR $input_path/INCAR-$run_type

time srun -n $vasp_ntasks $vasp_run >& LOG
cd ..
cp -r $run_type pre_run

#GW
run_type="gw"
vasp_ntasks=$gw_ntasks

echo Start $run_type Calculation using $vasp_ntasks MPI ranks and $gw_rankspernode ranks per node
mv pre_run $run_type; cd $run_type
cp $input_path/INCAR-$run_type INCAR
time srun --ntasks=$vasp_ntasks --ntasks-per-node=$gw_rankspernode $vasp_run >& LOG
cd ..
echo All done.


