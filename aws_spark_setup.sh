#!/usr/bin/env sh
# SPARK AWS EC2 INSTALLATION AND CONFIGURATION

# TODO:   parameterize scala version and spark version

# Assuming EC2 box is up and running and you have the .pem 
chmod 400 name_of_pem.pem
ssh -i "name_of_pem.pem" ubuntu@ec2-ip-address-with-dashes.us-east-2.compute.amazonaws.com

# Add Java repo to current machine
sudo add-apt-repository ppa:webupd8team/java -y

# install java
sudo apt install java-common oracle-java8-installer oracle-java8-set-default
sudo chmod -R 777 /opt

cd /opt
wget https://downloads.lightbend.com/scala/2.12.6/scala-2.12.6.tgz #get required version

tar -xzvf scala-2.12.6.tgz

Set the environment in .bash_profile

echo 'export SCALA_HOME=/opt/scala-2.12.6' >> ~/.bash_profile
echo 'export PATH=$PATH:SCALA_HOME/bin' >> ~/.bash_profile

source ~/.bash_profile

# check scala version
scala -version


# Install Python
sudo apt-get update
sudo apt-get install python3.7

# Get and install Spark with hadoop
wget https://www.apache.org/dyn/closer.lua/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz

tar -xzvf spark-2.4.3-bin-hadoop2.7.tgz

echo 'export SPARK_HOME/opt/spark-2.4.3-bin-hadoop2.7'  >> ~/.bash_profile

echo 'export PATH=$PATH:$SPARK_HOME/sbin'  >> ~/.bash_profile
echo 'export PATH=$PATH:$SPARK_HOME/bin'  >> ~/.bash_profile

echo 'export PYSPARK_PYTHON=python3'  >> ~/.bash_profile
echo 'export PYTHONPATH=$SPARK_HOME/python:$PYTHONPATH'  >> ~/.bash_profile

source ~/.bash_profile

echo "Ready to use Spark with Scala, Java and Python ....."

# check spark REPL: spark-shell
# check PySpark REPL: pyspark
# check spark-sql: spark-sql

# Submit Spark jobs via Commandline
# ./bin/spark-submit \
#   --class <main-class> \
#   --master <master-url> \
#   --deploy-mode <deploy-mode> \
#   --executor-memory 20G \
#   --total-executor-cores 100 
#   --conf <key>=<value> \
#   <application-jar> \
#  [application-arguments]


# More Examples of running
'# Run application locally on 8 cores
./bin/spark-submit \
 --class org.apache.spark.examples.SparkPi \
 --master local[8] \
  /path/to/examples.jar \
  100

# Run on a Spark standalone cluster in client deploy mode
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master spark://host-ip:7077 \
  --executor-memory 20G \
  --total-executor-cores 100 \
  /path/to/examples.jar \
  1000

# Run on a YARN cluster
export HADOOP_CONF_DIR=XXX
./bin/spark-submit \
  --class org.apache.spark.examples.SparkPi \
  --master yarn \
  --deploy-mode cluster \ # can be client for client mode
  --executor-memory 20G \
  --num-executors 50 \
  /path/to/examples.jar \
  1000

  '

# Monitor Spark jobs
# http://localhost:4040/jobs/
