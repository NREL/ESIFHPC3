# Graph500
Graph500 v3.0 with configurations customized for NREL

## License
New code under University of Illinois/NCSA Open Source License
<br />&nbsp;&nbsp;See src/license.txt<br />
Old code (including generation code) under Boost Software License, Version 1.0
<br />&nbsp;&nbsp;See src/generator/LICENSE\_1\_0.txt

## Acquiring Code
The reference source code is available from (https://graph500.org/?page_id=47). Version 3.0.0 of the benchmark should be used for generating results for the ESIF-HPC-3 procurement.

## Build Instructions
    [cchang@el1 ~]$ module load openmpi/4.0.4/gcc-8.4.0
    [cchang@el1 ~]$ ml list

    Currently Loaded Modules:
      1) gcc/8.4.0   2) openmpi/4.0.4/gcc-8.4.0

    [cchang@el1 ~]$ cd Graph500/src/src
    [cchang@el1 src]$ make

## Test configurations
An example Slurm run script is provided that defines graph sizes as outlined on the [Graph500 site](https://graph500.org/?page_id=12). Run rules are

1. The graph500_reference_bfs_sssp executable should be used to generate results.
2. The number of ranks-per-node should be the largest power-of-2 that can fit for that problem size, given the node memory.
3. The range of rank counts for each problem size should be sampled by doublings, e.g., 128, 256, 512, ... 
4. The "toy" size problem should be run from 1 node to as many as needed to support 1024 ranks.
5. The "mini" size problem should be run from the minimal node count required to support 128 ranks, up to 4096 ranks.
6. Subsequent sizes should increment the rank count bounds by 4X (i.e., rank counts of 512 - 16384 for "small", 2048 - 65536 for "medium", etc.).
7. If insufficient resources are available within an offered node class to satisfy the above conditions, the Spreadsheet Response entries should be "N/A", and specific notes offered in the Text Response.
8. The "Medium" and "Large" sizes are not required, but may be included in the Spreadsheet Response if available.

## Results to be returned
* The Spreadsheet Response should include requested timing statistics for the BFS and SSSP cases as reported in the standard output of the run. The script `make_sheet.py` used to generated CSV-formatted reference data for import into the Spreadsheet is provided for convenience. The Offeror may modify it to parse their offered data for easier import into the reporting spreadsheet.

* The Text Response should include explanations for any missing results for toy, mini, or small cases. Any code changes or build modifications, and any customizations to the runtime environment, should be explained as well.

* The File Response should include standard output and standard error from job runs, as well as job scripts.
