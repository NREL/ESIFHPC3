IOR
===

## Licensing
IOR is licensed under GPLv2. Further information can be found at https://github.com/hpc/ior.

## Description
IOR is designed to measure parallel file system I/O performance through a variety of potential APIs. This parallel program performs writes and reads to/from files and reports the resulting throughput rates. We use this benchmark to understand the performance of the proposed file systems. 

## How to Build
We require results from version IOR 3.2.1.
Release 3.2.1 source code must be obtained from [https://github.com/hpc/ior/releases/tag/3.2.1].
Build and run instructions may be found [here](https://buildmedia.readthedocs.org/media/pdf/ior/latest/ior.pdf). 
NREL reference build notes  
* Code change: aiori-HDF5.c line 232: "collective_md" -> "collective".
* Environment

        Currently Loaded Modules:
          1) gcc/8.4.0   2) openmpi/4.0.4/gcc-8.4.0   3) hdf5/1.10.6/gcc-ompi
        ./configure --prefix=/scratch/cchang/IOR --with-lustre --with-hdf5 --with-posix --with-mpiio MPICC=mpicc
        make; make check; make install

## Run Definitions and Requirements

The Offeror shall run small (random) and large (streaming) I/O tests for the POSIX, MPI, and HDF5 interfaces.

MPI ranks must be assigned consecutively (e.g., not round-robin) over at least 2 nodes to achieve predictable page caching behavior.

These tests will be run for the following processor/node count **conditions**:

1. [HPC,DSS] 100 ranks on Standard nodes. Example commands provided for this case.
2. [HPC,DSS] The number of processes on one node that yields the peak performance for ProjectFS and ScratchFS for a single node of each class (Standard, Large Data, and Accelerated).
3. [HPC] The number of processes on one node that yields the peak performance for the local storage on the Large Data nodes. 
4. [HPC,DSS] The number of fully subscribed nodes that yields the peak performance for ScratchFS and ProjectFS, for each node class of Standard and Accelerated. 

Note: For HPC offerings that do not have a related ProjectFS DSS offering, it is acceptable to provide a non-binding estimate of performance based on test data, or to leave ProjectFS rows blank.

Note: For DSS ProjectFS offerings, please provide data and specify the test system used to generate this data in the Text Response for conditions 1 and 2. If credible data exists for condition 4, please include with specifications as well. If data arising from actual runs connected to a test cluster is not available, please provide projections for conditions 1, 2, and 4, and describe in detail how such projections were arrived at.

## How to Run

Useful IOR options include 

`-a` interface {POSIX, MPI, or HDF5}  
`-i` number of repetitions  
`-v` verbosity (please run as "-v"; additional "v"s increase verbosity level)  
`-g` turn on Barriers between open, read/write, close  
`-e` defeat page caching effects on write by forcing flush (fsync) after writes return  
`-C` defeat page caching effects on read by forcing each process to readback from a neighboring node; inconsistent with -z option  
`-w` do write test  
`-r` do read test  
`-b` block size, contiguous data written per operation per process. Made of multiple transfers  
`-t` transfer size, the size of a single buffer in a single I/O call  
`-s` segment count, determines the total amount of data read or written (segment count * block size * number of ranks)  
`-F` turn on file-per-process   
`-z` random offset within file; inconsistent with -C option

### Tests

The following assume that the binary executable named `ior` is on the user's PATH.

1. POSIX Streaming, 10 GB single-segment, file-per-process  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a POSIX -g -w -r -e -C -F -b 100m -t 1m -s 1`

2. MPI Streaming, 100 GB single-segment, single file  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a MPIIO -g -w -r -e -C -b 1g -t 1m -s 1`

3. HDF5 Streaming, 100 GB single-segment, single file  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a HDF5 -g -w -r -C -b 1g -t 1m -s 1`

4. HDF5 Streaming, 100 GB ten-segment, single file  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a HDF5 -g -w -r -e -C -b 100m -t 1m -s 10`

5. POSIX Random, 1 GB single-segment, single file  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a POSIX -g -w -r -e -z -b 10m -t 2k -s 1`

6. HDF5 Small Transfer, 1 GB ten-segment, single file  
`srun --ntasks=100 --cpu-bind=rank --distribution=block ior -v -a HDF5 -g -w -r -e -b 10m -t 2k -s 1`

For system peak performance tests, nodes should be fully subscribed and results for the node count that provides maximum performance should be reported. 

IOR options that may be changed:
* For conditions 2-4, process count may obviously be changed to achieve optimality.
* For all conditions, for the "as-is" data, iteration count via the `-i` option may be modified as desired; only the maximum, reproducible transfer rate achieved should be reported. Other than that, the IOR command options specified above must not be changed, and all unspecified options must be left at their default values.
* For all conditions, for the "optimized" data, block and transfer sizes may be changed, as well as options left unspecified above. No changes are permitted that would enable page caching. Documentation of any changes must be provided in the Text Response.
 
## Run Rules
In addition to the general ESIF-HPC-3 benchmark rules, the following also apply:

Changes related to tuning must be practical for production utilization of the filesystem. For example, tuning that optimizes random I/O at the expense of large streaming I/O would not be practical for our expected mixed workload. The Offeror shall include details of any optimizations used to run these benchmarks, and distinguish parameters which may be set by an unprivileged user from those which would be globally set by system administrators. 

## Benchmark test results to report and files to return
In addition to items enumerated in the General Benchmark Instructions,

* the Text response should include a high-level description of optimizations that would permit NREL to understand and replicate the optimized runs, as well as a description of 
    * relevant client and server features (node and processor counts, processor models, memory size, speed, OS)
    * client and server configuration settings important to understand performance
    * network interface options
    * file system configuration options
    * storage and configuration for each file system
    * network fabric used to connect servers, clients, and storage
    * network configuration settings
 
* the File response should include all and only those log files corresponding to runs with performance numbers in the Spreadsheet response
* the Spreadsheet response should include annotations for each provided performance number such that the corresponding log file of the File response may be immediately referenced. The file `parse.py ` used to create a CSV file for Spreadsheet import from reference runs is included for convenience. The Offeror may modify and use it.

