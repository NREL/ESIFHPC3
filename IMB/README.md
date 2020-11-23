Intel MPI Benchmarks
===
## Licensing
The Intel MPI Benchmarks package (IMB) is licensed under the Common Public License Version 1.0, as described at https://software.intel.com/content/www/us/en/develop/articles/intel-mpi-benchmarks.html (Wed Sep 16 13:22:40 MDT 2020).

## Description
IMB is used to measure application-level latency and bandwidth, particularly over a high-speed interconnect, associated with a wide variety of MPI communication patterns with respect to message size.

We require use of Intel MPI Benchmarks 2019 Update 6 release, available from the Intel [Github repo](https://github.com/intel/mpi-benchmarks) master branch as hash 2d75254.

For the current purposes, we are interested in these tests:

	- PingPong
	- Sendrecv
	- Exchange
	- Barrier
	- Uniband
	- Biband
	- Allreduce
	- Alltoall
	- Allgather
	
## How to Build

To build the binary needed for testing,

   1. `% export CC=mpiicc` (Point to your mpi compiler, mpiicc in our test case)
   2. `% make` (This will create the IMB-MPI1 binary that will be used for testing)

If needed, please refer to further information in `ReadMe_IMB.txt`, or at [https://software.intel.com/en-us/articles/intel-mpi-benchmarks](https://software.intel.com/en-us/articles/intel-mpi-benchmarks).

## How to Run
Message sizes to run for each benchmark: 

* Pingpong **0B** and **524288B** 
* Barrier **0B**
* For all other functions run the benchmark for the following message sizes. 
	* **0B**
	* **65536 B**
	* **524288 B**
	* **4194304 B**	

Where node memory limits prohibit these message sizes (e.g., collectives), the Offeror should include as many of the above message sizes as possible, and augment data with the largest message size that will fit into the Offered memory. For example, if the 0B and 65536B messages are feasible, but the largest feasible message size is only 131072B, then the reporting sheet should be modified to report data for 0B, 65536B, and 131072B message sizes.

Please refer to the table below to meet the minimum number of iterations for each message size: 

```
|----------------------------------------------|
|Message size in Bytes|  minimum #Iterations   |
|---------------------|------------------------|
|            0        |  1000                  |
|        65536        |  640                   |
|       524288        |  80                    |     
|      4194304        |  10                    |
|---------------------|------------------------|
```

For the PingPong test, two nodes should be used. 

For all tests except PingPong, ranks should be placed on 2, 64, 128, 256, and 512 nodes. For each such test and node-count, the Offeror must run with (a) one rank per node, and (b) one rank per physical execution core. An example script used at NREL to generate data with Intel MPI is included as `testrun1/example.slurm`.  Note this script uses echo to add lines to the output of the form

`Running Pingpong on 2 cores, 2 nodes with tasks-per-node 1`

The Python script `imb.py` will parse the output of the execution from example.slurm (called `rawdat` in our provided example), and

* write to stdout data suitable for capture and reporting, or further processing by `imbbreak.py`
* create a file tab1.csv which is structured as a single table
* produce a validation file called `rawdat.val` containing the name and size of each run and a line indicating that MPI_Finalize was called.  If `imb.py` does not find matching "titles" and "MPI_Finalize" lines this will be indicated.

If there was a memory error or a timeout, reported values will be replaced with a "?".

`imb.py` also takes on the command line a comma-separated description of the node on which the test is run, and any code optimization performed and/or compiler version. These options map to the columns "node_class" and "optimization" in the Spreadsheet response, and default to "Test System, As-is code". 

* If the vendor offers more than one type of node the tests should be run on all types.
* If there are optimizations performed on the code the results should be supplied with "As-is code" being replaced with an appropriate short description.

The optional `imbbreak.py` post-reprocessing script will take as input the captured stdout from `imb.py` (assumed to be named "pandas.csv") and produce a Microsoft Excel file, as well as separate CSV files by test. These outputs may be useful for analysis or data transformations to import into the Spreadsheet Response. Note that the Pandas Python package will need to be available for imbbreak.py to function.

## Benchmark results to report
```
[Pingpong]
node_class,optimization,test,cores,nodes,tpn,size,t[usec],b,c,d,e,f,g

Barrier
node_class,optimization,test,cores,nodes,tpn,t_max[usec],a,b,c,d,e,f,g

Alltoall,Allgather,Allreduce,Sendrecv,Exchange
node_class,optimization,test,cores,nodes,tpn,size,t_max[usec],size,t_max[usec],size,t_max[usec],size,t_max[usec]

Uniband,biband
node_class,optimization,test,cores,nodes,tpn,size,Msg/sec,size,Msg/sec,size,Msg/sec,size,Msg/sec
```

All tests must call MPI_Finalize to be successful.  

### Typical post processing procedure

Assume that the Offeror has run `example.slurm` targeting a particular node type with highly optimized IMB code.

```
eagle:testrun1> ./imb.py  node A12Z56, highly optimized > pandas.csv
eagle:testrun1> ./imbbreak.py
eagle:testrun1> ls -lt
total 440
-rw-r--r--  1 user_me  group_me    1153 Nov 23 16:10 Biband.csv
-rw-r--r--  1 user_me  group_me    1157 Nov 23 16:10 Uniband.csv
...
-rw-r--r--  1 user_me  group_me   12349 Nov 23 16:10 imb.xlsx
-rw-r--r--  1 user_me  group_me   17966 Nov 23 16:10 tab1.csv
-rw-r--r--  1 user_me  group_me    8848 Nov 23 16:10 pandas.csv
-rw-r--r--  1 user_me  group_me    8157 Nov 23 16:10 rawdat.val
-rwxr-xr-x  1 user_me  group_me    1331 Nov 23 15:48 imbbreak.py
-rwxr-xr-x  1 user_me  group_me    7280 Nov 23 15:48 imb.py
-rwxr-xr-x  1 user_me  group_me    2533 Nov 23 11:22 example.slurm
-rw-r--r--  1 user_me  group_me  112859 Nov 23 11:22 rawdat

```

The final Spreadsheet Response should contain a single table with data for each node type/optimization appended below the previous one.  

The File response should include any configuration files, raw output, Excel files, the *.val validation files for each run, and run scripts.

