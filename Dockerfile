FROM openjdk:8-jre

RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y \
    curl \
    grep \
    sed \
    git \
    wget \
    bzip2 \
    gettext \
    sudo \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 && \
  apt-get clean all

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.continuum.io/archive/Anaconda2-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
  /bin/bash ~/anaconda.sh -b -p /opt/conda && \
  rm ~/anaconda.sh

RUN ln -s /opt/conda/bin/python /usr/bin/python

ADD spark /spark

ENV SPARK_HOME /spark

COPY scripts/spark-submit /usr/bin
COPY scripts/start-worker /usr/bin
COPY scripts/start-master /usr/bin
COPY scripts/setup-users /usr/bin
RUN chmod u+x /usr/bin/spark-submit
RUN chmod u+x /usr/bin/start-worker
RUN chmod u+x /usr/bin/start-master
RUN chmod u+x /usr/bin/setup-users
