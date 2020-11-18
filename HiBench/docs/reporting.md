
# Reporting benchmarks

Please include data for each of the following in the Spreadsheet Response.

* HDFS disk space per node
* Spark Configuration
  * Number of Executors
  * Cores per Executor
  * Executor Memory
* Hadoop configuration
  * Data replication rate **(must be = 3)** 
* HiBench Configuration
  * Hadoop/Spark Parallelism Setting (or settings)
* Optimizations: If there are additional plugins or optimizations utilized. 

In the spreadsheet response, please supply performance results for the **bigdata** data profile for tests. These values can be obtained from `HiBench/report/hibench.report`.  

* Sort
* Wordcount
* Bayes
* K-Means
* DFSIOE
* SVM
* Random Forest

Note: Performance results need only include results for one level of parallelism that is representative of an approximate best-case performance for the given test and cluster size.

## Reporting optimizations
In addition to an unoptimized run, reporting optimized runs is also encouraged if possible. In the Spreadsheet Response report add a short name for the optimization in the Optimization column, and if necessary provide supplemental plaintext file describing the optimization and steps to reproduce it. 

## Streaming benchmarks
Although steps are not provided, additional benchmarks using the StreamBench benchmarks included in HiBench are also welcome additions. 
