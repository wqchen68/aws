
# download spark
wget http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1.tgz

# decompress
tar zxvf spark-2.0.1.tgz

# move to right path
sudo mv spark-2.0.1 /opt/spark/

# build/mvn  這步會跑大概 30 分鐘
./build/mvn -Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.2 -Phive -Phive-thriftserver -DskipTests clean package

# config
cp /opt/hive/apache-hive-1.2.1-bin/conf/hive-site.xml /opt/spark/spark-2.0.1/conf

echo "spark.driver.extraClassPath /opt/hive/apache-hive-1.2.1-bin/lib/mysql-connector-java-5.1.38-bin.jar" >> /opt/spark/spark-2.0.1/conf/spark-defaults.conf.template

cp /opt/hadoop/hadoop-2.7.2/etc/hadoop/core-site.xml /opt/spark/spark-2.0.1/conf

echo "spark.driver.extraClassPath /opt/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/aws-java-sdk-1.7.4.jar:/opt/hadoop/hadoop-2.7.2/share/hadoop/tools/lib/hadoop-aws-2.7.2.jar" >> /opt/spark/spark-2.0.1/conf/spark-defaults.conf.template


sudo su -c "R -e \"install.packages('testthat', repos='https://cran.rstudio.com/')\""



rm(list=ls())
Sys.setenv(SPARK_HOME="/opt/spark/spark-2.0.1/")
.libPaths(c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib"), .libPaths()))
library(SparkR)
library(magrittr)
library(dplyr)

sc <- sparkR.session(appName = "SparkR-data-manipulation-example")


df <- read.parquet(sc, "s3://vpon.dsp/joined_wonbid_response/dt=2016-10-01")




