# Dork

## Description

Spark Docker image for deploying a stand-alone cluster.
There are [tags](https://hub.docker.com/r/frosner/dork/tags/) for different Spark versions available.

## Usage

### Starting a Master

```
sudo docker run --net host \
  -v $(pwd)/spark-2.0.0-bin-hadoop2.7:/spark \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e SPARK_MASTER_IP=localhost \
  -e SPARK_MASTER_PORT=7077 \
  -e SPARK_MASTER_WEBUI_PORT=10000 \
  -e SPARK_LOCAL_IP=localhost \
  -e SPARK_PORT_DRIVER=10001 \
  -e SPARK_PORT_FILESERVER=10002 \
  -e SPARK_PORT_BROADCAST=10003 \
  -e SPARK_PORT_REPL_CLASS_SERVER=10003 \
  -e SPARK_PORT_BLOCK_MANAGER=10004 \
  -e SPARK_PORT_EXECUTOR=10005 \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  frosner/dork start-master
```

### Starting a Worker

```
sudo docker run -d --net host \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v $(pwd)/spark-2.0.0-bin-hadoop2.7:/spark \
  -e SPARK_WORKER_CORES=2 \
  -e SPARK_WORKER_MEMORY=2g \
  -e SPARK_MASTER_ADDR=localhost:7077 \
  -e SPARK_WORKER_PORT=19999 \
  -e SPARK_WORKER_WEBUI_PORT=20000 \
  -e SPARK_LOCAL_IP=localhost \
  -e SPARK_PORT_DRIVER=20001 \
  -e SPARK_PORT_FILESERVER=20002 \
  -e SPARK_PORT_BROADCAST=20003 \
  -e SPARK_PORT_REPL_CLASS_SERVER=20003 \
  -e SPARK_PORT_BLOCK_MANAGER=20004 \
  -e SPARK_PORT_EXECUTOR=20005 \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  frosner/dork start-worker
```

### Submitting an Application

```
sudo docker run -d --net host \
  --entrypoint spark-submit \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v $(pwd)/spark-2.0.0-bin-hadoop2.7:/spark \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  frosner/dork \
  --class org.apache.spark.examples.SparkPi \
  --master "local[*]" \
  /path/to/examples.jar \
  100
```
