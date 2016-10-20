# this script will build spark on EC2

# download spark(not pre-build version)
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1.tgz

# decompress
tar zxvf spark-2.0.1.tgz

# move to right path
sudo mv spark-2.0.1 /opt/spark/

# Build with Hive (maybe spent 30 mins)
./build/mvn -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.2 -Phive -Phive-thriftserver -DskipTests clean package

# Configure Hive Connectio: add hive-site.xml
cp /opt/hive/apache-hive-1.2.1-bin/conf/hive-site.xml /opt/spark/spark-2.0.1/conf

# mysql-connector for Hive metastore
echo "spark.driver.extraClassPath /opt/hive/apache-hive-1.2.1-bin/lib/mysql-connector-java-5.1.38-bin.jar" >> /opt/spark/spark-2.0.1/conf/spark-defaults.conf

# Configure s3 file system: add core-site.xml
cp /opt/hadoop/hadoop-2.7.2/etc/hadoop/core-site.xml /opt/spark/spark-2.0.1/conf

# aws connector for s3
echo "spark.driver.extraClassPath /opt/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/aws-java-sdk-1.7.4.jar:/opt/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/hadoop-aws-2.7.2.jar" >> /opt/spark/spark-2.0.1/conf/spark-defaults.conf


sudo su -c "R -e \"install.packages('testthat', repos='https://cran.rstudio.com/')\""


# example
rm(list=ls())
Sys.setenv(SPARK_HOME="/opt/spark/spark-2.0.1/")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
library(magrittr)
library(dplyr)

sc <- sparkR.session(appName = "SparkR-data-manipulation-example")


df <- read.parquet(sc, "s3://vpon.dsp/joined_wonbid_response/dt=2016-10-01")





