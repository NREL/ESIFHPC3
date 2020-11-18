# WRF4
The WRF model version 4 Benchmark instructions

Description
-----------

The WRFv4 software is a next-generation mesoscale numerical weather
prediction system designed for both atmospheric research and
operational forecasting applications, developed at NCAR. Please see
https://www.mmm.ucar.edu/weather-research-and-forecasting-model, for
additional information on the software. This benchmark will be used to
understand capability performance.


How to Build
------------

Build instructions for any WRF-4.x and WPS-4.1 versions, can be found
[here](https://www2.mmm.ucar.edu/wrf/OnLineTutorial/compilation_tutorial.php).
For this benchmark, a WRF4 build with both NetCDF-4 and PnetCDF enabled will
be considered.

The Conus2.5km WRF benchmark will be used for testing and characterization of
machine architectures. For reference, the original benchmark for WRFv3 can be found
[here](http://www2.mmm.ucar.edu/wrf/WG2/benchv3/). The modifications
for benchmarking WRFv4 include changing the physics settings, and
using the NCEP GFS 0.25 deg input data for 2018-06-17, which available [here](https://rda.ucar.edu/data/ds084.1).
The input files `namelist.wps` and `namelist.input` are provided for generating the
boundary and input files necessary for running the Conus 2.5km benchmark for WRFv4.

For building WRFv4 on the NREL system, the following software packages listed as loaded environment
modules were used as supporting libraries, along with the Intel MPI and compilers.
configure.wrf and configure.wps scripts that were used for building WRF v4.1.3, and WPS v4.1
on NREL systems are also provided for reference. 

* Environment
   
     Currently Loaded Modules:

  	    1) netcdf-f/4.4.4/intel1803-impi     4) gcc/7.3.0             7) hdf5/1.10.4/intel1803-impi
  	    2) netcdf-c/4.6.2/intel-18.0.3-mpi   5) comp-intel/2018.0.3   8) wrf/4.1.3/intel-18.0.3-mpi
  	    3) pnetcdf/1.9.0/intel1803-impi      6) intel-mpi/2018.0.3


The Offeror is free to build any version of WRFv4.1.x, and WPSv4.1.x using the above
versions of intel-mpi toolchain, libraries or any preferred later
versions, as well as any modification of the configure scripts that are provided.

How to Run
----------
### Strong Scaling Test

This CONUS benchmarks will be run for the generated boundary and input
files for different processor counts for spatial resolution of 2.5km
and temporal resolution of 30 mins, specified in the input `namelist.input` file.
To run, place the input file, wrf boundary and input files and copy the default
runtime files from WRF/run/<files>, in the run directory:

```
% srun --ntasks=<# procs> ./wrf.exe -o conus_2.5km-<# procs>.log

```

### Throughput Test

There will be 6 instances of running WRF with NetCDF for serial I/O,
and 6 instances of running WRF with PnetCDF for parallel I/O. Each of
the instances for serial or parallel I/O are run using MPI task counts
ranging over 60, 120, 240, 480, 960 and 1440. For PnetCDF, the offerer is
free to use any number of additional processors for parallel I/O.

## Validation of Results and Documenting Performance

* A reference WRF output file will be provided. Then the output files from
the completed benchmark runs will be validated by:

```
% /external/io_netcdf/diffwrf  wrfout_d01_2018-06-17_06_00_00 wrfout_reference >& diffout_tag

```

Here the `tag` refers to a run instance, such as with serial I/O
on 120 cores, so the `tag=n-120`.

* A python script `wrf_stats` will be provided which will collect
statistics on each run. It will be used in the following way:

```
% wrf_stats rsl.out.0000 >& rsl-tag

```

Here `tag` is defined similarly as above.

Rules
------

In addition to the general ESIF-HPC-3 benchmark rules, the following
also apply:

The Offeror shall include details of any optimizations used to build
and run these benchmarks, and distinguish parameters which may be set
by an unprivileged user from those which would be globally set by
system administrators.


## Benchmark test results to report and files to return
In addition to items enumerated in the General Benchmark Instructions,

* A script `gensheet.py` is included for reference. This was used to generate existing table rows
  in the Spreadsheet Response. Offerors may modify and use it as desired to parse output files and
  generate CSV format output to import into the Spreadsheet Response. Please delete from the
  Spreadsheet any pre-existing blank table entries for Test and Offered systems that are not needed.
* The Text response should include
  * a high-level description of build optimizations, if any, that would permit NREL to replicate
  the optimized builds.
  * a high-level description of optimizations that would permit NREL to understand and replicate
  the optimized runs.
* The File Response should include
  * files for validation of each run instance, as described above.
  * The files for run statistics for each run instance, as described above.
  These files should also contain and be mapped to performance numbers in the Spreadsheet
  response.
  
