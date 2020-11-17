#!/bin/tcsh
#SBATCH --job-name nw.2
#SBATCH --ntasks=72
#SBATCH --time=4:00:00
#SBATCH --account=hpcapps
#SBATCH --error=std.err
#SBATCH --output=std.out

module purge
module use /nopt/nrel/apps/modules/centos74/modulefiles/
module use /nopt/nrel/apps/modules/test/modulefiles/
module load nwchem/7.0.0
module list

time srun -n 72 nwchem dft.nw > dft.log


