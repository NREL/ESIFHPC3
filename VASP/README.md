VASP
====

Licensing
----------------
Must be arranged through developers or a commercial reseller per

https://www.vasp.at/index.php/faqs/71-how-can-i-purchase-a-vasp-license.

Benchmarks must be run with version 6.1.2.

General comments
----------------

1. Build Vasp: Five binaries can be built from the VASP Makefile: `vasp_std`, which is the standard version, `vasp_gam`, which is the gamma point only version, `vasp_ncl`, which is the non-collinear version, `vasp_gpu`, which is the gpu version of vasp_std, and `gpu_ncl`, which is the gpu version of `vasp_ncl`. For the required benchmarks, `vasp_std` should be used for the Standard nodes and `vasp_gpu` for the Accelerated nodes.

    We have experieced the following error when running VASP binaries built with Intel Compiler 2020 and MKL 2020: "Fatal error in PMPI_Waitall: See the MPI_ERROR field in MPI_Status for the error code", which was solved by using Intel Compiler 2018 and MKL 2018 instead. 
    
2. Supplied content: Reporting spreadsheet and three benchmark directories: 

    a. bench1: benchmark 1, which should be run on the Standard nodes using `vasp_std`.
    
    b. bench1-gpu: benchmark 1, which should be run on the Accelerated nodes using `vasp_gpu`.
    
    c. bench2: benchmark 2, which should be run on the Standard nodes using `vasp_std` and on the Accelerated nodes using `vasp_gpu`, respectively.  
    
    In each benchmark directory, there are the following contents:
    
    a. input subdirectory: VASP input files of `INCAR*, POTCAR, POSCAR,` and `KPOINTS`.   
    
    b. sample calculation subdirectory with slurm job script templates such as std.4 for the Standard nodes and gpu.4 for the Accelerated nodes. 4 means that it was run using 4 nodes.  
    
    c. NREL-results subdirectry supplied with reference data.
    
    d. Validation scripts.

3. Generate results. Benchmarks should be run on the Standard and Accelerated node offerings. Please note that for the best performance, the number of MPI ranks per node may not equal the number of cores per node. In addition, KPAR and NPAR (or NCORE = the number of MPI ranks/NPAR) also have great impact on the performance. The Offeror is permitted to vary these parameters to identify the best performance. The Offeror is also permitted to map ranks within a NUMA domain as desired, subject to limitations given in the General Benchmark Instructions.
   
3. Validation

    a. Validation is achieved via scripts written in Python, version 3 (reference runs were validated with Python 3.7, but the Offeror may use other versions that support these scripts). This lends the validation process a certain degree of platform independence, and validation should be able to pass on any platform with a Python3 implementation, assuming this implementation is done to standard. Aside from the standard libraries alone, the validation process will require the `numpy` module.  
    
    b. The method of validation is described in the README.md file in each benchmark directory. 
    
    c. Neither the validation python scripts nor the reference data may be modified in any way by the Offeror,
without prior written permission.   

    d. The directory containing reference data (*i.e.*, the OUTCAR* files) may be transferred to another machine if needed. For example, if the machine used for job execution did not have Python3 installed, the respondent may find it convenient to perform the validation elsewhere.
    
VASP bench1
-----------

*Benchmark 1* represents a typical high-accuracy band structure calculation, involving bootstrapping
from an initial approximate GGA wavefunction, through a hybrid HSE function, to a final band structure
from a GW calculation. The runs as configured test scaling with respect to node count. Each run should have access to at least 96 GB of available memory. As a multi-stage job, there are three distinct INCAR files supplied. The "vasp_std" build should be used for this benchmark.

The key output files for validation are of the form `OUTCAR-{type}-{rankcount}`, where `{type}` is one
of `gga`, `hse`, or `gw`. We have supplied the relevant reference data, with which test data will be compared.

Validation may be done either for individual files, or all at once after all the requested runs are completed.
To validate individual files, run the `validate.py3` script directly, providing the test file name (which must
have the format given above) as the sole argument. To run all validations at once, you may run the
`validate.bash` convenience script.

*GW calculations*: It should be noted that the GW method as implemented in VASP currently does not take advantage of parallelism in the same manner that the GGA and HSE methods do. Thus, the rank counts used to demonstrate scaling for GGA and HSE are excessive and beyond useful scaling for GW on the test calculation. For our reference runs, only 8 ranks per node were used for GW calculations.

*Accelerated node*: The "vasp_gpu" build should be used for this benchmark. Currently running VASP with gpu requires the following: NCORE=1, LREAL=Auto, and ALGO set to one of Normal, Fast, or VeryFast. We have changed input files accordingly in the directory "bench1-gpu/input". GW calculations are not required for the Accelerated node benchmarks. 

VASP bench2
-----------

*Benchmark 2* represents a typical surface catalysis study calculation, with large unit cell and k-point
sampling limited to the Gamma point. A single model chemistry (DFT functional and plane-wave basis) is
employed, and strong scaling with respect to MPI rank count is of interest. The "vasp_std" build should be used for the Standard nodes and "vasp_gpu" build should be used for the Accelerated nodes.

For throughput testing, this benchmark includes a configuration requiring the Offeror to use a single node. For this configuration, the intent is to minimize time-to-solution. To that end, the Offeror may subscribe the node with MPI ranks, and configure VASP paralellism (_e.g._, by changing the NPAR parameter in the INCAR file), as needed to achieve this goal.

Items to Return
---------------
The Spreadsheet response should include output times from the "time" Linux command as illustrated in the provided example run scripts, converted to seconds. The "# cores" reported should reflect the number of _physical_ cores hosting independent threads of execution, and the "# workers" reported should be equal to the number of execution threads.

In addition to content enumerated in the General Instructions, please return files OUTCAR and vasprun.xml for every run, as well as all validation output, as part of the File response.
