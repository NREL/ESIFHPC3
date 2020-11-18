ESIF-HPC-3 HiBench Benchmark
=========================

Licensing
---------
HiBench is licensed under the Apache License 2.0, see LICENSE.txt in the supplied HiBench distribution.<br />
Apache Maven is licensed under the Apache License 2.0, see LICENSE in the supplied Maven distribution.<br />
Scala is licensed under the 3-clause BSD license, as stated in the LICENSE.md file of the supplied distribution.

Description
-----------
This repository contains information for Big Data (Hadoop/Spark) benchmarks for the ESIF-HPC-3 system's Large Data compute units.

The instructions below cover pre-requisites, configuration and deliverables. These instructions have been tested on a 10 datanode (1 namenode + 10 datanodes) cluster. Offerors are requested to provide results on clusters of equal size. Additional reports can also be provided for different cluster sizes. 

The Offeror must run using the "bigdata" data profile for all reported runs.


How to Build
------------

### Pre-requisites
A makefile has been included for convenience, that may assist in setting up the pre-requisites for and building HiBench.

  * Java 8/1.8
  ```
  java -version
  openjdk version "1.8.0_265"
  OpenJDK Runtime Environment (AdoptOpenJDK)(build 1.8.0_265-b01)
  OpenJDK 64-Bit Server VM (AdoptOpenJDK)(build 25.265-b01, mixed mode)
  ```
  * [Maven](https://mirrors.sonic.net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz) 3.6
  ```
  mvn -version
  Apache Maven 3.6.3 (cecedd343002696d0abb50b32b541b8a6ba2883f)
  Maven home: /home/ksayers/hibench/apache-maven-3.6.3
  Java version: 1.8.0_265, vendor: AdoptOpenJDK, runtime: /home/ksayers/java/jdk8u265-b01/jre
  Default locale: en_US, platform encoding: UTF-8
  OS name: "linux", version: "3.10.0-1062.9.1.el7.x86_64", arch: "amd64", family: "unix"
  ```
  * [Scala](https://www.scala-lang.org/download/2.12.10.html) 2.12
  ```
  scala -version
  Scala code runner version 2.12.12 -- Copyright 2002-2020, LAMP/EPFL and Lightbend, Inc.
  ```
  * [Hadoop](https://www.apache.org/dyn/closer.cgi/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz) 3.2.1
  * [Spark](https://www.apache.org/dyn/closer.lua/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz) 3.0.1 
  * [HiBench](https://github.com/intel-hadoop/HiBench) - commit b40e9fd
 


### HiBench

More information is available at https://github.com/intel-hadoop/HiBench. Benchmarking should be performed using the specified version of HiBench (commit b40e9fd).

### Build HiBench

Finally, build if not using the included Makefile:

```
mvn -Dspark=3.0 -Dhadoop=3.2 -Dscala=2.12 clean package
```

**`pom.xml` is provided here with potential changes necessary for building**

* [Reference build](/docs/reference.md) provides a basic testing setup 

Instructions
------------
The following sections provide further details for completing the benchmark. 
* [Configuration](/docs/config.md)
* [Running the Benchmarks](/docs/benchmarking.md)
* [Reporting](/docs/reporting.md)

Optimizations
------------
As-is results must be generated according to the General Benchmark instructions. To generate Optimized results, the Offeror may make any optimizations, such as using plugins for specific architectures. 

Results
------------
As outlined in the instructions above, the offeror should provide benchmark results, and configuration values for the following benchmarks. 

### Required
* Sort
* Wordcount
* Bayes
* K-Means
* DFSIOE
* SVM
* Random Forest
