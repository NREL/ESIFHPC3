#!/bin/bash 
#SBATCH --account=hpcapps
#SBATCH --time=12:00:00
#SBATCH --job-name=rllib
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=36
#SBATCH --partition=gpu

# Env setup
module purge
source /home/tkaiser2/bin/doconda
module load conda
export CONDA_PKGS_DIRS=/scratch/$USER/conda/.conda-pkgs
export CONDA_ENVS_PATH=/scratch/$USER/conda/.conda-envs
conda activate slimgpu
unset LD_PRELOAD  # or redis will fail!

cd $SLURM_SUBMIT_DIR

cat $0


# Set this variable to change the  example you want to run
#export TUNED_EXAMPLE="tuned_examples/dqn/breakout-dqn.yaml"

for TUNED_EXAMPLE in  one.yml ; do
./tymer times.$SLURM_JOBID $TUNED_EXAMPLE start
cat $TUNED_EXAMPLE
rllib train -f $TUNED_EXAMPLE 
./tymer times.$SLURM_JOBID $TUNED_EXAMPLE end
done

