Licensing
---------
The HPGMG benchmark is licensed under the 2-clause BSD license found in hpgmg-code/LICENSE.

Description
-----------
The HPGMG finite volume benchmark is important to certain combustion applications, and offers a more direct view of balanced system performance than does the traditional HPL floating-point operations-per-second metric. The code uses hybrid parallelism over both MPI ranks and OpenMP threads.

How to Build
------------
To build HPGMG, use the snapshot of the code provided in the `hpgmg-code` directory. Results generated for Standard compute units must use the binary executable created from this source.

`cd hpgmg-code/build'

Edit the Makefile in the `hpgmg-code/build` directory as needed.

To build, use the command `make V=1`.

How to Run
----------
This benchmark must be run only for the Standard compute unit offering.

Once the HPGMG binary is compiled, a simple example of running it with OpenMPI on 18-core nodes with 18 threads per MPI rank with `X` MPI ranks would be carried out as such:

```
export OMP_NUM_THREADS=18;
mpirun -np X ./hpgmg-fv 7 8
```

Another example of running the HPGMG benchmark is shown in `hpgmg-code/README.md`. The Offeror may choose to run with the MPI implementation and configuration that best suits their system. The hpgmg-fv executable takes two positional arguments. The first is the base-2 logarithm of the box dimension; the second is the number of boxes per rank. The recommended values for these parameters are 7 and 8, respectively. Runs must be performed and reported with these values; however, the Offeror may modify these values in additional runs to demonstrate the best aggregate performance for their system. 

### Scaling Test
Performance for the MPI rank counts requested in the benchmark reporting sheet (64, 128, 256, 512, and 1024) as well as performance results for the full number, half, and one-quarter of the Offered Standard compute units must be provided. Additional runs may be reported with other MPI rank counts if desired. Performance for other rank counts should be reported to support projection to the Offered system if the benchmark test system differs from the Offered system.  For all runs, the Offeror may run with any number of threads per MPI rank to obtain the best performance for their system. 

### Throughput Test
To generate these results, the Offeror shall fill the Standard compute unit offering (or project thereto) with 8-12 concurrent HPGMG runs, with the goal of maximizing the aggregate metric (DOF/s) achievable on the full Standard compute unit offering. The specific number of runs may be chosen to best fit the offered system. The HPGMG-FV benchmark runs for a fixed time, and reports performance as degrees of freedom per second (DOF/s). System throughput from these results will be calculated as the sum of the DOF/s values from the concurrent jobs.

Reporting Results
-----------------
Baseline performance is provided in the reporting spreadsheet for reference using the average of three runs. The performance metric reported by the HPGMG benchmark is "degrees of freedom per second" (DOF/s). Each run produces 3 lines involving DOF/s; for the scaling study, please enter into the reporting spreadsheet the average of three _separate_ runs using the value from each run's *first* line only (which is typically the largest DOF/s reported). Run configuration including # nodes or analogous compute units, # physical cores, # ranks, and total # threads should be reported in the corresponding spreadsheet cells.

For throughput tests, each line of the associated table should represent the job configuration of 1 or more instances. This table should be extended to report all job configurations used in the test. The sum of DOF/s over all jobs should be entered where specified in the sheet.

Other content to be returned is as enumerated in the General Benchmark Instructions.
