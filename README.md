# Dork

## Description

Spark docker image for deploying a standalone cluster.

## Usage

### Starting a Master

```
sudo docker run --net host \
  -v /etc/localtime:/etc/localtime:ro \
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
  frosner/dork:latest start-master
```

### Starting a Worker

```
sudo docker run --net host \
  -v /etc/localtime:/etc/localtime:ro \
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
  frosner/dork:latest start-worker
```
