FROM java:8

RUN echo "nameserver 8.8.8.8\nnameserver 8.8.4.4" >> /etc/resolv.conf #https://www.turnkeylinux.org/forum/support/20090724/fix-apt-get-could-not-resolve-archiveubuntucom
RUN apt-get update \
  && apt-get install python -y \
  && apt-get install sudo -y \
  && apt-get clean all -y

ENV SPARK_HOME /spark

RUN curl -s http://www.apache.org/dist/spark/spark-1.6.2/spark-1.6.2-bin-hadoop2.6.tgz | tar -xz -C / \
  && mv /spark-1.6.2-bin-hadoop2.6 /spark

COPY start-worker /usr/bin
COPY start-master /usr/bin
COPY setup-users /usr/bin
RUN chmod u+x /usr/bin/start-worker
RUN chmod u+x /usr/bin/start-master
RUN chmod u+x /usr/bin/setup-users

