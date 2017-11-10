# Dork

[![Build Status](https://travis-ci.org/FRosner/dork.svg?branch=master)](https://travis-ci.org/FRosner/dork)
[![Docker Pulls](https://img.shields.io/docker/pulls/frosner/dorkd.svg?maxAge=2592000)](https://hub.docker.com/r/frosner/dorkd/)

## Description

Spark Docker image for deploying a stand-alone cluster.
There are [tags](https://hub.docker.com/r/frosner/dorkd/tags/) for different Spark versions available.

## Usage

### Starting a Master

```
sudo docker run --net host \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e SPARK_MASTER_IP=localhost \
  -e SPARK_MASTER_PORT=7077 \
  -e SPARK_MASTER_WEBUI_PORT=10000 \
  -e SPARK_MASTER_RECOVERY_DIRECTORY=/master-recovery \
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
  frosner/dorkd:latest-s2.0.2-h2.7 start-master
```

### Starting a Worker

```
sudo docker run -d --net host \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
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
  -e SPARK_SHUFFLE_SERVICE_ENABLED=true \
  -e SPARK_SHUFFLE_SERVICE_PORT=7337 \
  frosner/dorkd:latest-s2.0.2-h2.7 start-worker
```

### Submitting an Application

```
sudo docker run -d --net host \
  --entrypoint dork-submit \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  frosner/dorkd:latest-s2.0.2-h2.7 \
  --class org.apache.spark.examples.SparkPi \
  --master "local[*]" \
  /path/to/examples.jar \
  100
```

### Providing a Spark SSH

```
sudo docker run -d -p 8022:22 \
  --entrypoint dork-shell \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/pam.d/common-session:/etc/pam.d/common-session:ro \
  -v /etc/nsswitch.conf:/etc/nsswitch.conf:ro \
  -v /etc/ldap.conf:/etc/ldap.conf:ro \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e LDAP_MATCH_GROUP=spark \
  -e DORK_SSH_PORT=22 \
  frosner/dorkd:latest-s2.0.2-h2.7
```
