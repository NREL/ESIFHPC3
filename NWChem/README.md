# NWChem
Licensing
---------
The code of NWChem is distributed as open-source under the terms of the Educational Community License version 2.0 (ECL 2.0) and can be found at https://opensource.org/licenses/ecl2.php.
Benchmarks must be run with revision 7.0.0 and can be downloaded at https://github.com/nwchemgit/nwchem/releases/tag/v7.0.0-release

Description
-----------
NWChem provides its users with computational chemistry tools that are scalable both in their ability to efficiently treat large scientific problems. NWChem serves here as an application benchmark reflecting its intensive use as an engine for Kohn-Sham density functional theory calculations.

How to Build
------------
The general installation instructions can be found at https://nwchemgit.github.io/Compiling-NWChem.html

Supplied content
----------------

1. NWChem input file: `dft.nw`  
2. Slurm job script template `nw.slurm`, to illustrate how the reference data was generated   
3. Reference output file: `ref.log`   
4. `get_result.bash` and `validate.py` scripts

How to Run
----------------

The NWChem benchmark must be run on Standard and Large Data compute units. It is a multi-threaded job to demonstrate system capability to run MPI jobs. It will run a single-point DFT calculation first (Step 0) and then run one iteration of a geometry optimzation (Step 1). 

Benchmark test results to report and content to return
------------------------------------------------------

* NWChem will use one MPI rank for I/O. Therefore, if you allocate M &#215; N MPI ranks for it with M compute units and N ranks per unit, NWChem will actually only use M &#215; (N-1) ranks to do computation. Please report the number of _computing_ MPI ranks in the Spreadsheet response--this number can be obtained by using `grep nproc dft.log` for output file `dft.log`, for example. 
* NWChem will write the energy and walltime data for Step 0 and Step 1 in the log file and can be obtained by using `grep @ dft.log`. The performance of Step 1 of geometry optimization (walltime of Step 1 minus walltime of Step 0) is required to be reported in the benchmark reporting sheet for 1, 2, 4, 8 ... nodes. 
* The `get_result.bash` script will print the number of computing MPI ranks and Step 1 timing information, as well as validate the calculation results. It could be run with the NWChem log file as the first argument, for example, `get_result.bash dft.log`. Validation is performed by calling `validate.py` which must be run using Python 3. Offeror must return the output log files from NWChem for each run, and output from the `get_result.bash` script as part of the File response.
* A general summary of workflow, any relevant configuration information, and installation script should be included in the Text response.
