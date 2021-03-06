# Dork

[![Build Status](https://travis-ci.org/Data-Science-Platform/dork.svg?branch=master)](https://travis-ci.org/Data-Science-Platform/dork)
[![Docker Pulls](https://img.shields.io/docker/pulls/datascienceplatform/dorkd.svg?maxAge=2592000)](https://hub.docker.com/r/datascienceplatform/dorkd/)

## Description

Spark Docker image for deploying a stand-alone cluster.
There are [tags](https://hub.docker.com/r/datascienceplatform/dorkd/tags/) for different Spark versions available.  Dork container now has SSSD client installed for System Security Services integration with the host machine.  See sssd [documentation](https://sssd.io/).

## Usage

### Starting a Master

```sh
docker run --net host \
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
  -e SPARK_EVENT_LOG_DIR=/tmp/spark-events \
  datascienceplatform/dorkd:latest-s2.0.2-h2.7 start-master
```

### Starting a Worker

```sh
docker run -d --net host \
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
  -e SPARK_EVENT_LOG_DIR=/tmp/spark-events \
  -e $SPARK_WORKER_CLEANUP_ENABLED=true \
  -e $SPARK_WORKER_CLEANUP_INTERVAL=1800 \
  -e $SPARK_WORKER_CLEANUP_APPDATATTL=604800 \
  datascienceplatform/dorkd:latest-s2.0.2-h2.7 start-worker
```

### Starting a History Server

```sh
docker run -d --net host \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e SPARK_EVENT_LOG_DIR=/tmp/spark-events \
  -e SPARK_HISTORY_SERVER_PORT=18080 \
  -e SPARK_HISTORY_SERVER_UPDATE_INTERVAL=10s \
  -e SPARK_HISTORY_SERVER_MAXDISKUSAGE=10g \
  -e SPARK_HISTORY_SERVER_MEMORY=1g \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  datascienceplatform/dorkd:latest-s2.0.2-h2.7 start-history-server
```

### Disabling logs after the event

By default, the after-the-event logs for Spark History server are stored under `$SPARK_EVENT_LOG_DIR`. If the variable is not specified, writing of the logs is omitted.


### Submitting an Application

```sh
docker run -d --net host \
  --entrypoint dork-submit \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -e SPARK_USER_NAME=spark \
  -e SPARK_USER_ID=1100 \
  -e SPARK_GROUP_NAME=spark \
  -e SPARK_GROUP_ID=1100 \
  -e SPARK_APPLICATION_SOURCE="https://path-to-yo.ur/application.tar" \
  -e SPARK_APPLICATION_TARGET="/application" \
  -e SPARK_APPLICATION_USERNAME="user" \
  -e SPARK_APPLICATION_PASSWORD="password" \
  datascienceplatform/dorkd:latest-s2.0.2-h2.7 \
  --class org.apache.spark.examples.SparkPi \
  --master "local[*]" \
  /path/to/examples.jar \
  100
```

### Providing a Spark SSH

```sh
sudo docker run -d -p 8022:22 \
  --entrypoint dork-shell \
  -v $(pwd)/ssh-keys:/ssh-keys \
  -v /etc/localtime:/etc/localtime:ro \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/pam.d/common-session:/etc/pam.d/common-session:ro \
  -v /etc/nsswitch.conf:/etc/nsswitch.conf:ro \
  -v /etc/ldap.conf:/etc/ldap.conf:ro \
  -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro \
  -e LDAP_MATCH_GROUP=spark \
  -e DORK_SSH_PORT=22 \
  datascienceplatform/dorkd:latest-s2.0.2-h2.7
```
