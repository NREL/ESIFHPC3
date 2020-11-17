## Licensing
LAMMPS is open-source software licensed under the GPLv3. 

Description
-----------
Source code of LAMMPS version 3-Mar-2020 is available from [https://github.com/lammps/lammps/releases/tag/stable_3Mar2020](https://github.com/lammps/lammps/releases/tag/stable_3Mar2020). Benchmark results must be produced with this version.

Directory `input` has LAMMPS inputs. Sample Slurm scripts have been provided for reference. 

We supply a LAMMPS parameter file `data.begin.bz2`. This compressed file contains coordinates and velocities of ~0.75 million atoms in a cubic unit cell, ~20 nm on a side, representing a 35% LiCl solution pre-equlibrated to 300K and 1 atm. Larger unit cells for "medium" and "large" systems are generated programmatically from this file.

Three LAMMPS benchmarks are required, and input files `small.in`, `medium.in`, and `large.in` are provided. For `medium.in` and `large.in`, the unit cell decribed above is replicated to create larger cubic cells (via LAMMPS `replicate` commands).  

Directory `nrel_results` has reference results for validation. 

How to Build
------------
The benchmark results for "As-is" tests must be generated from LAMMPS version 3-Mar-2020. Optional libraries or packages included in the LAMMPS distribution (*e.g.*, OpenMP) may be used and reported as the "optimized code" in the reporting spreadsheet.

LAMMPS can be built by following the instructions at https://lammps.sandia.gov/doc/Install.html. For systems with GPUs, a version should be built with the LAMMPS GPU package, and double precision MUST be used.   

How to Run  
----------
The "As-is" benchmark must be run on Standard and Accelerated nodes with no OpenMP parallization, that is, OMP_NUM_THREADS should be set to 1. Two sample Slurm scripts can be found as `std.4.slurm` and `gpu.4.slurm` for a 4-standard-node run and a 4-GPU-node run, respectively.
  
Each benchmark case should be run on 1, 4, 16, 64 ... nodes. For `medium` and `large` jobs, especially running on a small number of Accelerated nodes, it is possible that jobs won't run due to the limitation of memory. In this case, `Out of Memory` should be reported in the Spreadsheet response. For Accelerated nodes, it is possible that the optimal speed is achieved when number of MPI ranks per node is smaller than the number of CPU cores per node and in this case, the Offeror needs to vary the number of MPI ranks per node to find the optimal value. The "# cores" reported should reflect the number of `physical` CPU cores hosting independent threads of execution.

For each benchmark system size, the total simulation time is controlled via the input parameter `thermo` in the LAMMPS input scripts. As MPI rank counts are increased, `thermo` should be increased in order to maintain a simulation wall time ("Loop time") of 300 seconds or greater, and to keep the total number of simulation steps ("total-running-steps") equal to 10 times `thermo`. 

How to Validate
-------------------------
Numerical results vary somewhat with respect to the number of MPI ranks employed. In recognition of this, we are requesting validation only on four specific runs: using the `medium_numerical_test.in` input in directory `input`, with 16 and 64 MPI ranks and on both Standard and Accelerated nodes. For the validation runs, OMP_NUM_THREADS must be set to 1. The performance results from these validation runs are not to be entered into the reporting sheet. A sample Slurm script is provided as `numerical_std.64.slurm`. 

A script named `validate.sh` is provided to validate system temperature and total energy data from the output of each of these runs against those obtained by NREL. The Offeror should run this script with the first argument as the path to the output file of a validation run, and the second argument the path to the provided directory `NREL_results` containing reference data. The usage is:

`./validate.sh PATH_TO_OUTPUT/lammps_output PATH_TO_NREL_RESULTS/`

(Example: `./validate.sh numerical_test.std64/medium_numerical_test.log NREL_results/` ) 

This will produce a file called `thermo.dat` that contains time, temperature, and energy output for the run; and, a file `rms_errors.dat` that contains validation information. The first line in `rms_errors.dat` gives the average temperature and energy for the run. These should have values of approximately 300 and -8.9e+07, respectively. The second line gives the relative root-mean-squared deviation between the output provided by NREL (in `NREL_thermo.dat`) and the output from the test run. Reasonable relative deviations are less than 10<sup>-3</sup> for temperature and 10<sup>-5</sup> for energy. The validation script returns either "run validated" or "run not validated" on the third line of `rms_errors.dat`, depending on whether deviations are less than or greater than these thresholds, respectively.

Reporting Results
-----------------
For the Spreadsheet response, the target performance numbers are "timesteps/s" as reported in the LAMMPS standard output stream. In addition to these values, the total number-of-steps that have been run and the reported "Loop time" must be included as well. Example logfile output looks like

`Loop time of 1356.94 on 24 procs for 5000 steps with 744000 atoms`  
`Performance: 0.318 ns/day, 75.385 hours/ns, 3.685 timesteps/s`

In this case, the number-of-steps is 5000, the loop-time is 1356.94 seconds, and the performance is 3.685 timesteps/s.

## What Must be Returned
In addition to the content enumerated in the General Benchmark Instructions, (a) output log files from the four validation runs, and (b) `rms_errors.dat` files from validation should be included in the File response.

