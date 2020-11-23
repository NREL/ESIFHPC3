#!/bin/bash
#SBATCH --job-name="hybrid"
#SBATCH --nodes=16
#SBATCH --partition=standard
#SBATCH --account=hpcapps
#SBATCH --time=04:00:00

# Example script to generate NREL data with Intel MPI.
#ml intel-mpi/2020.1.217
ml mpt/2.22

#set memory limit as needed
#export MEM=""
export MEM="-mem 2"

node_counts=(2 $((SLURM_NNODES/8)) $((SLURM_NNODES/4)) $((SLURM_NNODES/2)) $((SLURM_NNODES)))
cores_per_node=`cat /proc/cpuinfo | grep 'processor' | wc -l`
for i in $(seq 0 $((${#node_counts[@]}-1)))
do
   packed[$i]=$((cores_per_node*${node_counts[i]}))
done
echo 'node_counts array: '${node_counts[*]}
echo 'packed array: '${packed[*]}

rm msglens IMB_SELECT_MPI1 
## PingPong. Example not topologically aware, change for 2 actual tests
for i in 0 524288
do
   echo $i >> msglens
done
echo 'Pingpong' > IMB_SELECT_MPI1

echo Running Pingpong on 2 cores, 2 nodes with tasks-per-node 1
srun -n 2 --nodes=2 --tasks-per-node=1 src_c/IMB-MPI1 $MEM -input IMB_SELECT_MPI1 -msglen ./msglens

rm msglens IMB_SELECT_MPI1 

## Barrier
echo '0' > msglens
echo 'Barrier' > IMB_SELECT_MPI1

# 1 rank per node
for j in ${node_counts[*]}
do
	if [ "$j" -gt "1" ] ; then 
		echo Running Barrier on $j cores,  $j nodes with tasks-per-node 1
		srun -n $j --nodes $j --tasks-per-node=1 src_c/IMB-MPI1 $MEM -npmin $i -input IMB_SELECT_MPI1 -msglen ./msglens
	fi
done

# N ranks per node
for j in ${packed[*]}
do
	if [ "$j" -gt "1" ] ; then 
		nc=$((j / cores_per_node))
		echo Running Barrier on $j cores, $nc nodes with  tasks-per-node $cores_per_node
		srun -n $j --nodes $nc --tasks-per-node=$cores_per_node src_c/IMB-MPI1 $MEM -npmin $i -input IMB_SELECT_MPI1 -msglen ./msglens
	fi
done
rm msglens IMB_SELECT_MPI1 

## All others
#for i in 0 65536 524288 4194304
for i in 0 65536 524288 1048576
do
   echo $i >> msglens
done

for i in Alltoall Allgather Allreduce Sendrecv Exchange Uniband Biband
do
	echo $i > IMB_SELECT_MPI1
	# 1 rank per node
	for j in ${node_counts[*]}
	do
		if [ "$j" -gt "1" ] ; then 
			echo Running $i on $j cores, $j nodes with  tasks-per-node 1
			srun -n $j --nodes $j --tasks-per-node=1 src_c/IMB-MPI1 $MEM -npmin $j -input IMB_SELECT_MPI1 -msglen ./msglens
		fi
	done
	# N ranks per node
	for j in ${packed[*]}
	do
		if [ "$j" -gt "1" ] ; then 
			nc=$((j / cores_per_node))
			echo Running $i on $j cores, $nc nodes with  tasks-per-node $cores_per_node
			srun -n $j --nodes $nc --tasks-per-node=$cores_per_node src_c/IMB-MPI1 $MEM -npmin $j -input IMB_SELECT_MPI1 -msglen ./msglens
		fi
	done
done

# 32 nodes - 81 runs
