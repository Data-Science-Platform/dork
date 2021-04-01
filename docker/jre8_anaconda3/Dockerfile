FROM ubuntu:bionic-20210222

RUN apt-get clean && apt-get update
RUN apt-get install --reinstall ca-certificates -y

RUN apt-get install sudo apt-transport-https wget -y

RUN echo "Acquire::http::Proxy \"http://proxy02.gda.allianz:3128\";" | sudo tee /etc/apt/apt.conf.d/proxy.conf
RUN echo "Acquire::https::Proxy \"http://proxy02.gda.allianz:3128\";"| sudo tee -a /etc/apt/apt.conf.d/proxy.conf
RUN echo 'Acquire::https::Verify-Peer false;'| sudo tee -a /etc/apt/apt.conf.d/proxy.conf

ENV HTTP_PROXY="http://proxy02.gda.allianz:3128"
ENV HTTPS_PROXY="http://proxy02.gda.allianz:3128"

RUN sudo apt-get install software-properties-common openjdk-8-jdk git -y

RUN echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' | sudo tee -a /etc/environment
RUN echo 'JRE_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre' | sudo tee -a /etc/environment

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

RUN wget -q https://downloads.apache.org/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -P /tmp
RUN tar xf /tmp/apache-maven-*.tar.gz -C /opt
RUN ln -fs /opt/apache-maven-3.6.3 /opt/maven
RUN /opt/maven/bin/mvn --version

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
  wget --quiet https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh -O ~/anaconda.sh && \
  /bin/bash ~/anaconda.sh -b -p /opt/conda && \
  rm ~/anaconda.sh

RUN rm -f /usr/bin/python && ln -s /opt/conda/bin/python /usr/bin/python

RUN useradd -m -u 5000 app || :
RUN echo 'app ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /var/run/sshd

RUN apt-get clean

USER app


