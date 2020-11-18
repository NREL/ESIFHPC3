SHELL := /bin/bash

all: get_requirements build_hibench setup_cluster
get_requirements:
	wget https://mirrors.sonic.net/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
	wget https://mirrors.gigenet.com/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
	wget https://archive.apache.org/dist/spark/spark-3.0.1/spark-3.0.1-bin-hadoop3.2.tgz
	wget https://downloads.lightbend.com/scala/2.12.12/scala-2.12.12.tgz
	wget https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u272-b10/OpenJDK8U-jdk_x64_linux_hotspot_8u272b10.tar.gz
	tar xzf apache-maven-3.6.3-bin.tar.gz
	tar xzf hadoop-3.2.1.tar.gz
	tar xzf spark-3.0.1-bin-hadoop3.2.tgz
	tar xzf scala-2.12.12.tgz
	tar xzf OpenJDK8U-jdk_x64_linux_hotspot_8u272b10.tar.gz
	git clone https://github.com/Intel-bigdata/HiBench
	cd HiBench; \
	git checkout b40e9fd 
	

build_hibench:
	cp pom.xml HiBench/pom.xml
	source exports; \
	cd HiBench; \
	mvn -Dspark=3.0 -Dhadoop=3.2 -Dscala=2.12 clean package

setup_cluster: 
	export HIBENCH_HOME=$$PWD/HiBench; \
	export HADOOP_HOME=$$PWD/hadoop-3.2.1; \
	source exports; \
	cd setup_script; \
	python cluster_setup.py --hibench $$HIBENCH_HOME --hadoop $$HADOOP_HOME


clean:
	rm *.tar.gz
	rm *.tgz
	rm -rf apache-maven-3.6.3
	rm -rf hadoop-3.2.1
	rm -rf spark-3.0.1-bin-hadoop3.2
	rm -rf scala-2.12.12