HPL
===
HPL is a software package that solves a (random) dense linear system in double precision (64-bit) arithmetic on distributed-memory computers. It can thus be regarded as a portable as well as freely available implementation of the High Performance Computing Linpack Benchmark.

## Licensing
HPL is licensed per the COPYRIGHT notice in the hpl-2.3 folder.

## Description
The latest version of HPL as of October 2020 is 2.3 from December 2, 2018.
The HPL source code is available at [https://www.netlib.org/benchmark/hpl/](https://www.netlib.org/benchmark/hpl/)

## How to Build

Full instructions are found in the `hpl-2.3/INSTALL` file. In short,

* Copy a template "Make.<arch>" file from the `setup` directory into the top-level directory. For Eagle use Make.Linux_Intel64. 
* Rename this file to whatever is convenient, _e.g._, Make.myarch. Canonically this reflects the architecture, but can be anything unique.
* Change variable TOPdir in this Make.myarch file to reflect the location of hpl-2.3.
* Change variable ARCH in this Make.myarch file to whatever suffix has been chosen (_i.e._, myarch in this example).
* Modify the file as needed to create binaries optimized for the Offered architecture.
* HPL requires BLAS/LINPACK to run along with MPI and looks like the preferred choise is Intel MKL. To compile and link HPL properly with MKL use  Intel MKL Link Advisor "https://software.intel.com/content/www/us/en/develop/articles/intel-mkl-link-line-advisor.html" to get appropriate settings. The CC variable should be set to the  appropriate mpi compiler - like "mpiicc". The provided benchmark results were obtained with Intel MKL, Intel MPI and Intel cc compiler. 
* `make arch=myarch`. It will create a subdirectory bin/myarch and will place binary xhpl and sample HPL.dat files there.

More information may be found at "http://www.netlib.org/benchmark/hpl/". 

## How to Run

Once built, the HPL benchmark binary xhpl will be located in the ./bin/myarch directory (with `.` denoting the location where `make` is executed). xhpl requires MPI support to run. The required input is total number of nodes and total number of MPI ranks. The benchmark results were obtained with Slurm cluster management. The default environment settings for MPI and MKL were used.
`srun -t <time in minutes> -N <number of nodes> -n <number of ranks> ./xhpl`
The output goes into stdout and stderr.

HPL.dat file contains HPL configuration parameters and has to be in the same directory from where xhpl is run.  A sample HPL.dat file is automatically generated upon a successful build in ./bin/myarch subdirectory. The parameters that affect the performance most are N, P, Q and described below. HPL-2.3_benchmarking.xls contains run results for suggested N, P and Q combinations at different scales. For additional information and to maximazie the performance check hpl-2.3/TUNING file for parameters description. Generally, increasing N leads to a higher performance, but significantly increases the run time and can negatively affect MPI stability. HPL tune calculator is available here "https://www.advancedclustering.com/act_kb/tune-hpl-dat-file/"
* N defines matrix size. The data will be spread between all the nodes. Do not use all the memory on the nodes. Watch for memory consumption when MPI rank is high. The memory shortage can lead to MPI hang. The benchmark runs were performed at lower memory values..
* NB is usually set to 192
* P &#215; Q - should match MPI rank. Generally P &#8804; Q
* Other parameters:
```
16.0         threshold
1            # of panel fact
0 1 2        PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
2 4          NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
0 1 2        RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
0            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
0            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
```
The values of #MPI\_tasks\_per\_node, #Threads\_per\_node, N, NB, P, and Q should be chosen to achieve maximum performance. Rank counts for a benchmark test system differing from the Offered system should include sufficient additional data to permit accurate projection to the Offered system. 
 
## Benchmark test results to report and files to return

The Make.myarch file or script, job submission scripts, stdout and stderr files from each run, an environment dump, and HPL.dat files shall be included in the File response.

## Result validation

All output should show that tests passed successfully, as in: 

```
||Ax-b||_oo/(eps*(||A||_oo*||x||_oo+||b||_oo)*N)=        0.0013190 ...... PASSED

```
