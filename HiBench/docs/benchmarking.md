# Benchmarks

## Required benchmarks
The following are the required benchmarks to be run. If both Hadoop and Spark workloads are available both are expected, some benchmarks are only used by a single framework (either Hadoop or Spark).

* Sort
* Wordcount
* Bayes
* K-Means
* DFSIOE
* SVM
* Random Forest

## Running the benchmarks

### Run-all benchmarks.lst 
Benchmarks can also be added to `conf/benchmarks.lst` for HiBench and run with `bin/run_all.sh`

**Note DFSIOE currently seems to have an issue with running in the background and may not work with run-all or if submitted as a slurm job**

### Run individual benchmarks
The benchmarks can also be run individually, using the relevant scripts under `bin/workloads`

Example:
```
bin/workloads/micro/wordcount/prepare/prepare.sh
bin/workloads/micro/wordcount/hadoop/run.sh
bin/workloads/micro/wordcount/spark/run.sh
```

## Results
The result for each run are reported in the `HiBench/report/hibench.report` file. 
