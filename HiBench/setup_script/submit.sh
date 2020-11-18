#!/bin/bash 
#SBATCH --nodes=11
#SBATCH --time=04:00:00
#SBATCH --account=hpcapps
#SBATCH --partition=short
#SBATCH --mem=200000
#SBATCH --qos=high

cd /home/ksayers/hibench/hadoop_configs
python test.py
