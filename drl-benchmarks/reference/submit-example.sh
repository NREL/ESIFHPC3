#!/bin/bash 
#SBATCH --account=rlldrd
#SBATCH --time=1:00:00
#SBATCH --job-name=rllib
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=36

# Env setup
source $HOME/.bashrc
module purge
module load conda
conda activate /projects/rlldrd/conda-envs/rllib
unset LD_PRELOAD  # or redis will fail!

# Set this variable to change the  example you want to run
export TUNED_EXAMPLE="tuned_examples/dqn/breakout-dqn.yaml"

# Print out the configuration and run the example
cat $TUNED_EXAMPLE
srun --ntasks=1 --gres=gpu:1 rllib train -f $TUNED_EXAMPLE 
