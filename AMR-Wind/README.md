Licensing
---------

AMR-Wind is licensed under the BSD 3-clause license, and can be found at
https://github.com/Exawind/AMR-Wind/blob/development/LICENSE.

Description
-----------

AMR-Wind is a massively parallel, block-structured adaptive-mesh,
incompressible flow solver for wind turbine and wind farm
simulations. It is part of the exawind software ecosystem and is
available [here](https://github.com/exawind/AMR-Wind).  The AMR-Wind
benchmark runs as formulated to measure strong scaling on nodes with
GPU coprocessors. In addition, we are also interested in system
throughput under load. To simulate this, we include a configuration
that entails multiple simultaneous instances of AMR-Wind running on
compute units with GPUs.

How to Build
------------
### Configuring AMR-Wind and building dependencies

Official documentation for building AMR-Wind for all platforms is
located [here](https://AMR-Wind.readthedocs.io/en/latest/user/build.html). In
particular, for running on GPUs, NVIDIA CUDA v10 or higher is
required.  As the above build guide would indicate, one can automate
the build from source with a number of CMake configuration choices, or
more manually using modified script mechanisms, which is also described
in the build instructions. It is left to the Offeror to make the
choice that best suits them.

The Exawind tool suite is updated on a regular basis and is built
nightly. In general the third party libraries and versions must be
similar or later than the versions shown below, as a module list for a
recent build. This set of tools was used to generate the NREL
baseline results.

```

Currently Loaded Modules:

  1) gcc/8.4.0/2a3v       4) mpt/2.22/guif              7) cuda/10.2.89/rmcc
  2) git/2.27.0/od5t      5) cmake/3.17.3/fonv
  3) binutils/2.34/2drp   6) netlib-lapack/3.8.0/trmt


```


NOTE: To checkout a recent version from the Git repository, the following workflow should be used for setup:

```
  git clone https://github.com/Exawind/amr-wind
  cd amr-wind
  mkdir build-cuda; cd build-cuda
  < ... build steps... >

```

How to Run
----------
### Strong Scaling Test

There are two cases differing in grid sizes (256 and 512) that are
considered for this benchmark. We provide input files for these two grids 
--  `abl_godunov-256.i` and `abl_godunov-512.i`, respectively. 

To run, simply specify the input file and log file names. The
following example illustrates a specific run on NREL's HPC system,
which uses two MPI tasks and two GPUs on each node:

```
  srun -N 4 -n 8 --gres=gpu:2  ${BUILD}/amr_wind  abl_godunov.i >& ablGodunov-8x8.log

```

The input files cause writing of large output every 100 timesteps and
writes checkpoint data every 200 steps, with the entire case running
for 1000 timesteps. An Offeror may modify the input files only with an
accompanying justification for the change in the Text response.

The `amr-cuda_all_jobs-256.sh` and `amr-cuda_single_job.sh` scripts
are provided to show how AMR-Wind was run to obtain reference
results. Here the `amr-cuda_all_jobs-256.sh` stages all the runs,
while the `amr-cuda_single_job.sh` with appropriate edits for nodes
and ranks can be submitted to run all the jobs simultaneously.



### Throughput Test

There will be two scales of throughput tests for this benchmark. The
first is intended to demonstrate large job throughput, where the Offeror can run 4-6
simultaneous instances of the benchmark over all offered Accelerated compute units. The
second highlights smaller but still substantial jobs that we envision to be more
common in production. In this case, the Offeror may run between 15 and 20
simultaneous instances, for the same input case as the large runs. The particular number of
instances may be chosen to reflect the optimal capability of the Offered
system. The results will be a component of the overall system metric as further defined
in the Spreadsheet Response.

Validating Output
-----------------

Validating output in AMR-Wind requires checking the absolute and
relative error between the norms of the two output directories at the 1000<sup>th</sup>
timestep for different output variables. One of the output
directories is a provided reference to be compared against the Offeror's run
output directory.

To validate results, for the 256 grid problem, run:

```
./${BASE}/submods/amrex/Tools/Plotfile/fcompare plt01000 plt01000.ref-256

```

where `plt01000.ref-256` is the reference output directory, being
compared against `plt01000` generated from the Offeror's runs. The comparison will provide the absolute and
relative errors of the two norms of each output variable obtained from each of
the runs. The reference output directories for validation of each of the two cases being considered for this
benchmark are available [here](https://www.nrel.gov/hpc/esif-hpc-3.html).


Reporting Results
-----------------

Outside of the information to return as enumerated in the General
Instructions, the following AMR-Wind-specific information should be
provided.

* For scaling studies, the wall time to be reported is the sum of the
  wallclock times that are reported in the `InitData` and `Evolve` row
  at the end of output log files (obtained from, for example, the
  command `grep Evolve ablGodunov-8x8.log`) should be entered into the
  Spreadsheet response. Results from NREL's system are provided in the
  reporting spreadsheet for reference.

* For throughput tests, each line of the associated table should
  represent the job configuration of 1 or more instances. This table
  should be extended to report all job configurations used in the
  test. The wall time for each run instance should be reported.

* As part of the File response, please return all log files, and
  plt01000 folders from each run. For the throughput test, please
  return all job submission and log files.

* Include in the Text response validation data, with validation
  results in a table. If results vary by more than the 1e-3 reference
  tolerance, please also report the maximum difference of results
  against the reference results with a justification as to why the
  results should be considered correct.
