#!/bin/bash
#SBATCH --job-name=FIOtest
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=36
#SBATCH --output=%x-%j.out
#SBATCH --error=%x-%j.err

ml fio

export SCRATCH=/scratch/$USER/${SLURM_JOB_NAME:?}
if [ -d $SCRATCH ]
then
   rm -rf $SCRATCH
fi
mkdir $SCRATCH; cd $SCRATCH
cp $SLURM_SUBMIT_DIR/*.fio .

export PATH=$SCRATCH/fio/bin:$PATH

for jobfile in `ls *.fio`
do
   for blocksize in 4k 64k 1m
   do
      for size in 1m 64m 1g
      do
         for numjobs in 1 18 35
         do
            output_file=$(echo $jobfile | cut -f 1 -d '.').bs${blocksize}.size${size}.$numjobs
            fio --size=$size --bs=$blocksize --numjobs=$numjobs --output=$output_file --output-format=normal,terse --terse-version=5 $jobfile
         done
      done
   done
done
