# Reference build

## Requirements
* Python >= 3.6
* git
* make

This is a provided reference build for internal use and testing. Running `make all` in this repositories root directory will do the following:
1. Download all requirements and extract them
2. Copy the modified `pom.xml` file and then build HiBench
3. Update your `~/.bashrc` with the necessary paths:
```
export PATH="~/apache-maven-3.6.3/bin:$PATH"
export PATH="~/scala-2.12.12/bin:$PATH"
export PATH="~/jdk8u272-b10/bin:$PATH"
export JAVA_HOME="~/jdk8u272-b10"
```
4. Run the `cluster_setup.py` script 
5. Minimal config for `HiBench/conf/spark.conf` , update `hibench.spark.home` with correct path for Spark **Note the spark.conf must be updated for Spark runs to work**
```
# Spark home
hibench.spark.home      /home/ksayers/hibench/spark-3.0.1-bin-hadoop3.2

# Spark master
#   standalone mode: spark://xxx:7077
#   YARN mode: yarn-client
hibench.spark.master    yarn

# executor number and cores when running on Yarn
hibench.yarn.executor.num     2
hibench.yarn.executor.cores   4

# executor and driver memory in standalone & YARN mode
spark.executor.memory  4g
#spark.driver.memory   4g

# set spark parallelism property according to hibench's parallelism value
spark.default.parallelism     ${hibench.default.map.parallelism}

# set spark sql's default shuffle partitions according to hibench's parallelism value
spark.sql.shuffle.partitions  ${hibench.default.shuffle.parallelism}
```
6. Run a workload

```

cd HiBench
./bin/workloads/micro/wordcount/prepare/prepare.sh
./bin/workloads/micro/wordcount/hadoop/run.sh 
./bin/workloads/micro/wordcount/spark/run.sh
```

7. Check results
```
cat report/hibench.report
```

Expected output: 
```
Type         Date       Time     Input_data_size      Duration(s)          Throughput(bytes/s)  Throughput/node     
HadoopWordcount 2020-11-02 22:30:27 35154                21.227               1656                 1656                
ScalaSparkWordcount 2020-11-02 22:32:39 35154                17.718               1984                 1984   
```
