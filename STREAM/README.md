STREAM
===

## Licensing
STREAM is licensed per http://www.cs.virginia.edu/stream/FTP/Code/LICENSE.txt.

## Description

STREAM is used to measure the sustainable memory bandwidth of high performance computers.
The code is available from [http://www.cs.virginia.edu/stream/ref.html](http://www.cs.virginia.edu/stream/ref.html)

We provide source code retrieved on : Wed Sep 16 09:36:13 MDT 2020 with one change to the
Fortran version of the code:


diff ../../nrel/STREAM/src stream.f
249c249
<  9050 FORMAT (a,f10.1,3 (f10.4,2x))
---
>  9050 FORMAT (a,4 (f10.4,2x))

This change was made to prevent a format overflow.
 

## How to Build

An example Makefile is provided in src/. In addition, an example `test.sh` script is included
that builds and runs the benchmark.

The STREAM Triad benchmark uses 3 arrays of size N.
This can be controlled with `-DSTREAM_ARRAY_SIZE=<array_size>` during compilation,
where `array_size` is the number of elements in the array. For double-precision floats,
then, total array memory (GB) = 3 * STREAM\_ARRAY\_SIZE * 8 (bytes/float) / 1000<sup>3</sup>.

The offeror will build at least cases (1) and (2) of the benchmark. The third run is optional:

1.  default memory size defined in STREAM (_i.e._, not using `-DSTREAM_ARRAY_SIZE=<array_size>`; note that
     the Fortran source code has had a preprocessor definition added that sets the default array size
     to be consistent with the C version); and,

2.  a case which uses 60% of the total DRAM available to a single compute unit.

3.  a vendor-optimized version of the code which uses 60% of the total DRAM available to a single compute unit. 


## How to Run

The STREAM benchmark results must be returned for the following cases: 

 1. Fortran version: Number of threads in the range 1 to the number of cores on a compute unit.
 2. C version: Number of threads in the range 1 to the number of cores on a compute unit.

## Benchmark test results to report and files to return

<ins>Spreadsheet Response</ins>: We want data for all tests, Copy, Add, Scale, Triad for each thread/core counts as
shown in the file testrun1/stream.xlsx. It contains data from the testrun run on NREL's current HPC platform. 

The script `stream.sh` pulls data from the output file and compiles it into a files with various formats, 
`pandas.csv`, `STREAM.csv`, and `STREAM.tab`. The script stream.sh is hardwired for 36 cores/threads.  This will
need to be changed for other configurations. The file `strbreak.py` takes the file `pandas.csv` and creates an Excel file.

Tests sould be run on all offered compute unit types. If the vendor offers different
optimization levels for this code, results should be reported for each.  "stream.sh" takes a command line argument
of the form: 

`node description, system, optimization settings`  

Note they are separated by a comma ",".  These values will be in the first three columns of the output files.  
The default description is "Test System, Reference, As-is code".  If the tests are run on more than one configuration the final 
spreadsheet submitted should contain a single table with data for each type appended below the previous one.  This 
can be done by appending the pandas.csv files together, removing the header from the second or more file before
converting to an Excel file.

<ins>File Response</ins>: Scripts, Makefiles, configuration files, environment dump, standard output, and standard error files for each reported run.

<ins>Text Response</ins>: Please describe all runtime settings such as pinning threads to cores, utilizing specific NUMA domains, etc. that impact STREAM results.

## Result validation

Output should indicate a valid solution, as in: 

`Solution Validates!`


