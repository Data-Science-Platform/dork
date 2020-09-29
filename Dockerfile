FROM ubuntu:18.04

ENV LANG "C.UTF-8"
ENV DEBIAN_FRONTEND=noninteractive

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y software-properties-common && \
  add-apt-repository ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y \
    openjdk-8-jdk-headless \
    curl \
    grep \
    sed \
    git \
    wget \
    bzip2 \
    gzip \
    zip unzip \
    gettext \
    sudo \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    fortune \
    libxrender1 \
    libnss-ldap ldap-utils \
    openssh-server && \
  apt-get clean all

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
  /bin/bash ~/anaconda.sh -b -p /opt/conda && \
  rm ~/anaconda.sh
  
RUN mkdir /var/run/sshd
  
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

RUN rm -f /usr/bin/python && ln -s /opt/conda/bin/python /usr/bin/python

ADD spark /spark

RUN mkdir /application
RUN chmod 777 /application

ENV SPARK_HOME /spark
ENV PATH $PATH:/spark/bin

COPY conf/sshd_config.template /etc/ssh/sshd_config.template

COPY scripts/dork-submit /usr/bin
COPY scripts/dork-shell /usr/bin
COPY scripts/start-history-server /usr/bin
COPY scripts/start-worker /usr/bin
COPY scripts/start-master /usr/bin
COPY scripts/setup-users /usr/bin

RUN chmod u+x /usr/bin/dork-submit
RUN chmod u+x /usr/bin/dork-shell
RUN chmod u+x /usr/bin/start-history-server
RUN chmod u+x /usr/bin/start-worker
RUN chmod u+x /usr/bin/start-master
RUN chmod u+x /usr/bin/setup-users

RUN mkdir /ssh-keys
