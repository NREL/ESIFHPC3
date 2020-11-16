# mdtest
The ESIF-HPC-3 mdtest benchmark instructions

## Licensing
mdtest is licensed under GPLv2.

## Benchmark Description
mdtest is designed to characterize metadata performance of a filesystem. The intent of this benchmark is to measure the performance of file metadata operations on each proposed globally accessible file system.

## Build Instructions
mdtest is distributed as part of IOR, and is built by default when IOR is. Build instructions are thus included with IOR.  
The mdtest version 1.9.3 that is distributed with the IOR 3.2.1 release should be used for all reported results, please refer to the IOR benchmark instructions for more detail.

## Required Runs

For each proposed globally accessible file system, the Offeror shall run the following tests:
* creating, statting, and removing 2<sup>20</sup> files in a single directory
* creating, statting, and removing 2<sup>20</sup> files in separate directories (16 files each, 1-deep)
* creating, statting, and removing 2<sup>20</sup> files in separate directories (16 files each, 8-deep)

Each test will be run for the POSIX API.
Each of these tests should be run at the following process concurrencies:

 1. A single process (POSIX API only, 2<sup>20</sup> tests only)
 2. The optimal number of MPI processes on a single compute node 
 3. The minimum number of MPI processes on multiple compute nodes that achieves the peak results for the proposed system 
 4. The maximum number of MPI processes on the full set of nodes of each type, using one MPI process per physical core. If the number of files or directories does not divide evenly by the full rank count in a node class, integer division is acceptable to set the `-n` option. For example, if a node class had 16 nodes, 2<sup>20</sup>/(36 cores/node * 16 nodes) = 1820.44; `-n=1820` would be acceptable.

Each of these tests should be run for the Standard and Accelerated nodes.

Each of these tests should be run for each separate user-addressable part of the ProjectFS and ScratchFS file systems. 

## Running mdtest

mdtest is executed as any standard MPI application would be on the proposed system, for example with `mpirun`. The exact invocation depends on your MPI implementation. We will use srun for examples, and a Slurm batch script is provided with the basic run configurations requested.

Available options may be displayed with the "-h" option to mdtest. Useful options include

* `-C` Turn on file and directory creation tests
* `-T` Turn on file and directory stat tests
* `-r` Turn on file and directory remove tests
* `-n` number of files and directories per MPI process
* `-d` absolute path to directory in which the test should be run
* `-z=depth` The depth of a hierarchical directory structure below the top-level test directory for each process
* `-I=files_per_dir` number of items per directory per rank in tree
* `-N tasks_per_node` To defeat caching effects. This provides the rank offset for the different phases of the test, such that each test phase (read, stat, delete) is performed on a different node (the task that deletes a file is on a different node than the task that created the file). This parameter must be set equal to the number of MPI processes per node.  

MPI ranks must be placed consecutively on nodes, not round-robin or other schemes across nodes.

MPI ranks must be evenly distributed on nodes.

The number of top-level test directories is -n/-I, so -n must be a multiple of -I.

The total number of objects created per directory level is 2 &times; (# ranks) &times; (-n).
The total number of objects created is 2 &times; (# ranks) &times; (-n) &times; (-n/-I)<sup>2</sup> &times; (-z + 1).

For the tests that create, stat and remove 1,048,576 files/directories, you must specify the number of files _each_ process will create. 
For example, the command
>    mpirun -np 64 ./mdtest -C -T -r -n 16384 -d /scratch -N 16 

will use **64** **MPI** **processes**. Each MPI process will manipulate **16384** files/directories for a **total** of **1048576** objects (64 &times; 16384). 
 
Other example commands can be found in the mdtest.slurm file provided.
 
The file create, stat and delete portions of the execution will be timed and the rates of creation/statting/deletion are reported to stdout at the end of each test. 

## Run Rules
Observed benchmark performance shall be obtained from file systems configured as closely as possible to the proposed file systems. If the proposed storage solution includes multiple performance tiers _directly accessible by applications_, benchmark results shall be provided for all such tiers. 

The benchmark is intended to measure the capability of the storage subsystem to create and delete files and directories, and it contains features that minimize caching/buffering effects. The Offeror should not utilize optimizations that cache or buffer file metadata or metadata operations in compute node (client) memory. 

## Reporting Results
The `File creation`, `File stat` and `File removal` rates from stdout should be reported. The maximum values for these rates must be reported for all tests. Reporting the maximum creation rates from one run and the maximum deletion rates from a different run is NOT permitted. If the highest observed file creation rate came from a different run than the highest observed deletion rate, report the results from the run with the highest file creation rate. 
 * Rates should be recorded as part of the Spreadsheet response.
 * In addition, as part of the File response the Offeror shall provide all output files corresponding to the numbers in the Spreadsheet response. If performance projections are made, all output files on which the projections are based must also be provided.
 * For each run reported, the Text response should include the mdtest command lines used and the correspondence to the associated table in the Spreadsheet response. 

## Benchmark Platform Description
In addition to the information requested in the General Benchmark instructions, the benchmark report for mdtest should include 
 * the file system configuration and mount options used for testing
 * the storage media and configurations used for each tier of the storage subsystem
 * network fabric used to connect servers, clients and storage including network configuration settings and topology
 
