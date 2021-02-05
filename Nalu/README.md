Licensing
---------

Nalu is licensed under the Nalu 1.0 license, which may be found at
https://github.com/Exawind/nalu-wind/blob/master/LICENSE.

Description
-----------

Nalu or Nalu-wind is a CFD application that is used for wind farm
modeling and is part of a larger ExaWind tool suite that is available
[here](https://github.com/Exawind).  The individual Nalu benchmark
runs as formulated, are to measure strong scaling. In addition, we are
interested in system throughput under load. To simulate this, we
include a configuration that includes multiple simultaneous instances
of Nalu.

How to Build
------------
### Configuring Nalu and building dependencies

Official documentation for building Nalu is located 
[here](https://nalu-wind.readthedocs.io/en/latest/). As the above build
guide would indicate, one can automate the build using
[Spack](https://github.com/LLNL/spack), or mechanically using a number
of different script mechanisms. It is left to the Offeror to make the
choice that best suites them.


The Exawind tool suite is updated on a regular basis and is built
nightly. In general the third party library and Nalu versions must be
 similar or later than the versions shown below, as a module list for a recent
build. This set of libraries were used to generate the NREL baseline results.

```

Currently Loaded Modules:

  1) gcc/8.4.0/2a3v       5) intel-parallel-studio/cluster.2018.4/ia7n  9) tioga/master/tsat    13) boost/1.68.0/46jf
  2) python/3.7.7/mib4    6) intel-mpi/2018.4.274/2auf                  10) yaml-cpp/0.6.3/a55w
  3) git/2.27.0/od5t      7) intel-mkl/2018.4.274/olol                  11) cmake/3.17.3/uy2u
  4) binutils/2.34/2drp   8) hypre/2.18.2/7xdy                          12) fftw/3.3.8/cupd

```


_NOTE: To checkout a recent version from the Git repository, and for creating a build directory, the following workflow should be used (using Nalu as an example):_
```
  git clone https://github.com/Exawind/nalu-wind
  cd nalu-wind
  mkdir build-intel; cd build-intel

```

How to Run
----------
### Strong Scaling Test

There are two cases differing in mesh size (256 and 512) that are
provided. We provide input files for these two problem sizes (in
directories `abl_3km_256` and `abl_3km_512`, respectively). You will need to
download the actual mesh files for both cases before running them, available
[here](https://www.nrel.gov/hpc/esif-hpc-3.html).

To run, simply specify the input file and log file names:

```
  mpirun -np 4 naluX -i abl_3km_256.i -o abl_3km_256.log
```

The input files cause writing of large output every 100 timesteps and
writes checkpoint data every 500 steps, with the entire case running
for 1000 timesteps. An Offeror may modify the input files only with an
accompanying justification for the change in the Text response.

The `nalu_all_jobs-<256,512>.sh` and `nalu_single_job.sh` scripts are provided to show how Nalu was run to obtain reference results. 

### Throughput Test

Run from 15 to 20 concurrent instances of the 512 mesh benchmark. The particular
number of instances may be chosen to reflect optimal capability of the
Offered system within the given instance count. All offered compute units
(Standard and Accelerated) may be subscribed.

Validating Output
-----------------

Validating output in Nalu requires checking the difference of the
norms in the Nalu log file against our "gold" norms generated from our
baseline test. Unfortunately Nalu results can be very sensitive to the
BLAS and LAPACK libraries used, and compiler optimizations
employed. To validate results, for the 256 mesh case on 192 ranks
only, run `abl_3km_256/pass_fail.sh` on the log file with a 1e-3
tolerance, like:

```
./pass_fail.sh abl_3km_256_192 0.001
```

where `abl_3km_256_192` is the basename of the log file, and `0.001`
is the tolerance. This will create a `.norm` file from the log file
and check the differences against the "gold" norm file.  Note that
running simulations with different numbers of ranks can cause
deviations in the norms, as can be seen between the "gold" norm files
provided. For a successful validation, the Offeror may match the
number of MPI ranks used with the number of MPI ranks used in the
"gold" norm files. Validation against a single "gold" norm for each
case is sufficient to pass.

Reporting Results
-----------------

Outside of the information to return as enumerated in the General
Instructions, the following Nalu-specific information should be
provided.

* For scaling studies, wallclock times that are reported in the `avg`
  column of the output (obtained from, for example, the command `grep
  "main()" *.log`) should be entered into the Spreadsheet
  response. Results from NREL's system are provided in the reporting
  spreadsheet for reference.

* For throughput tests, each line of the associated table should
  represent the job configuration of 1 or more instances. This table
  should be extended to report all job configurations used in the
  test. The sum of timesteps/s over all jobs should be entered where
  specified in the sheet.

* As part of the File response, please return all norm files. For the
  throughput test, please return all job submission and log files.

* Include in the Text response validation data, with validation
  results in a table. If results vary by more than the 1e-3 reference
  tolerance, please also report the maximum difference of results
  against the reference results with a justification as to why the
  results should be considered correct.
