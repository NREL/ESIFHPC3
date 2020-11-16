#!/bin/bash
#SBATCH --job-name=mdtest
#SBATCH --time=01:00:00
#SBATCH --nodes=32
#SBATCH --output=exp20_32nodes.out.%x-%j
#SBATCH --error=exp20_32nodes.err.%x-%j

export SCRATCH=/scratch/$USER/${SLURM_JOB_NAME:?}
if [ -d $SCRATCH ]
then
   rm -rf $SCRATCH
fi
mkdir $SCRATCH; cd $SCRATCH

ml ior/3.2.1

exponent=20

run_1node(){
   #ranks=$1
   #n=$2
   #I=$3
   #z=$4
   # Standard tests
   srun --nodes=1 --ntasks=$1 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -r -n=$2 -I=$3 -z=$4 -d `pwd`
   rm -rf $SCRATCH/*
   # Random stat test
   if [ $3 -eq 1 ]
   then
      echo "Random stat test"
      srun --nodes=1 --ntasks=$1 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -R -n=$2 -I=$3 -z=$4 -d `pwd`
   fi
   rm -rf $SCRATCH/*
}
 
run_Nnodes(){
   #ranks=$1
   #ranks_per_node=$2
   #n=$3
   #I=$4
   #z=$5
   # Standard tests
   echo "srun --nodes=$(($1/$2)) --ntasks-per-node=$2 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -r -n $3 -N=$2 -I=$4 -z=$5 -d `pwd`"
   srun --nodes=$(($1/$2)) --ntasks-per-node=$2 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -r -n $3 -N=$2 -I=$4 -z=$5 -d `pwd`
   rm -rf $SCRATCH/*
   # Random stat test
   if [ $4 -eq 1 ]
   then
      echo "Random stat test"
      echo "srun --ntasks=$(($1/$2)) --ntasks-per-node=$2 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -R -n $3 -N=$2 -I=$4 -z=$5 -d `pwd`"
      srun --ntasks=$(($1/$2)) --ntasks-per-node=$2 --cpu-bind=rank --distribution=block mdtest -a=POSIX -C -T -R -n $3 -N=$2 -I=$4 -z=$5 -d `pwd`
   fi
   rm -rf $SCRATCH/*
}

n_multiple_i(){
   # $1 is initial guess for -n
   # $2 is value for -I
   # Figure out whether should round down, or up from initial guess.
   testn=$(($1/$2))
   if [ $testn -eq 0 ] # Round up
   then
      echo 1
   elif [ $(($1/$2)) -eq $((($1+1)/$2)) ] # -n not clean multiple of -I
   then
      t=$1
      round_test=`echo "scale=1; a=$1/$2; scale=0; b=$1/$2; a-b-0.5 <= 0" | bc`
      if [ $round_test -eq 1 ] # -n/-I is closer to floor than ceil
      then # Round down
         while [ `echo "$t%$2 != 0" | bc` -eq 1 ]
         do
            t=$((t-=1))
         done
      else # Round up
         while [ `echo "$t%$2 != 0" | bc` -eq 1 ]
         do
            t=$((t+=1))
         done
      fi
      echo $t
   fi
}

# Test 1 - Single directory. Effective -I=2**exponent
  # Single process. 
#run_1node 1 $((2**exponent)) $((2**exponent)) 0
  # Optimal ranks on single node
#ranks=16; run_1node $ranks $((2**exponent/ranks)) $((2**exponent/ranks)) 0
  # Optimal ranks over any node count. For example, say 4 nodes
ranks=256; nodes=32; run_Nnodes $ranks $((ranks/nodes)) $((2**exponent/ranks)) $((2**exponent/ranks)) 0
  # All cores in node class. For example, say 16 nodes
#ranks=$((16*36)); nodes=16; run_Nnodes $ranks $((ranks/nodes)) `n_multiple_i $((2**exponent/ranks)) $((2**exponent/ranks))` $((2**exponent/ranks)) 0

# Test 2 - Separate directories, 16 files each, 1 level deep.
  # Single process. Only do POSIX. I=16, need to drop n by 4x.
#run_1node 1 $((2**exponent)) 16 0
  # Optimal ranks on single node
#ranks=16; run_1node $ranks $((2**exponent/ranks)) 16 0
  # Optimal ranks over any node count. For example, say 4 nodes
ranks=256; nodes=32; run_Nnodes $ranks $((ranks/nodes)) $((2**exponent/ranks)) 16 0
  # All cores in node class. For example, say 16 nodes
#ranks=$((16*36)); nodes=16; run_Nnodes $ranks $((ranks/nodes)) `n_multiple_i $((2**exponent/ranks)) 16` 16 0

# Test 3 - Separate directories, 16 files each, 8 levels deep
  # Single process. Only do POSIX
#run_1node 1 $((2**exponent/8)) 16 8
  # Optimal ranks on single node
#ranks=16; run_1node $ranks $((2**exponent/ranks)) 16 8
  # Optimal ranks over any node count. For example, say 4 nodes
ranks=256; nodes=32; run_Nnodes $ranks $((ranks/nodes)) $((2**exponent/ranks)) 16 8
  # All cores in node class. For example, say 1000 nodes
#ranks=$((1000*36)); nodes=1000; run_Nnodes $ranks $((ranks/nodes)) `n_multiple_i $((2**exponent/ranks)) 16` 16 8

