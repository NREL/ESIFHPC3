# Reference configurations

## Hadoop / Spark configs
The [Setup Script](/setup_script) folder in this repository includes Jinja2 template files and a Python setup script for reference. This can be run providing the paths for HiBench and Hadoop as shown here: 

```
python cluster_setup.py --hibench ~/hibench/HiBench --hadoop ~/hibench/hadoop-3.2.1
```


## HiBench configs
The HiBench specific configurations should be adjusted based on the examples below. 

**conf/hadoop.conf**

```
# Hadoop home
hibench.hadoop.home     /home/user/hadoop-3.2.1

# The path of hadoop executable
hibench.hadoop.executable     ${hibench.hadoop.home}/bin/hadoop

# Hadoop configraution directory
hibench.hadoop.configure.dir  ${hibench.hadoop.home}/etc/hadoop

# The root HDFS path to store HiBench data
hibench.hdfs.master       hdfs://r102u03:9000/user/ksayers


# Hadoop release provider. Supported value: apache, cdh5, hdp
hibench.hadoop.release    apache
```
**conf/hibench.conf**
Update the following values:
```
# Data scale profile. Available value is tiny, small, large, huge, gigantic and bigdata.
# The definition of these profiles can be found in the workload's conf file i.e. conf/workloads/micro/wordcount.conf
hibench.scale.profile                bigdata
# Mapper number in hadoop, partition number in Spark
hibench.default.map.parallelism         350

# Reducer nubmer in hadoop, shuffle partition number in Spark
hibench.default.shuffle.parallelism     350
```

**conf/spark.conf**

```
# Spark home
hibench.spark.home      /home/user/spark-3.0.1-bin-hadoop3.2

# Spark master
#   standalone mode: spark://xxx:7077
#   YARN mode: yarn-client
hibench.spark.master    yarn

# executor number and cores when running on Yarn
hibench.yarn.executor.num     70
hibench.yarn.executor.cores   5

# executor and driver memory in standalone & YARN mode
spark.executor.memory  100g
```

## Tuning
The following was used as a basis for picking config values. 
* [HiBench tuning](https://silo.tips/download/hibench-introduction-carson-wang-software-services-group)
